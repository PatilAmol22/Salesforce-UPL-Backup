/**************************************************************************************************
* Name               : grz_CreditSummaryInternal.js                                              
* Description        : JS controller for grz_CreditSummaryInternal component.                           
* Created Date       : 23/05/2022
* Created By         : Nikhil Verma (Grazitti)                                                   
**************************************************************************************************/                                         
import { LightningElement, wire, api,track} from 'lwc';
import LANG from "@salesforce/i18n/lang";
import labels from "@salesforce/label/c.Grz_CreditSummaryTranslation"
import { CloseActionScreenEvent } from 'lightning/actions';
import getData from "@salesforce/apex/Grz_CreditSummaryInternal.getData";
import getSalesArea from "@salesforce/apex/Grz_SapCommonIntegration.getSalesAreaValues"; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
export default class Grz_CreditSummaryInternal extends LightningElement {
    @track labels;
    @api recordId;
    @track errorMessage;
    @track account;
    @track creditData;
    @track isLoading = true;
    @track language = LANG;
    @track salesAreaOptions; salesArea; salesOrg; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
    @track pdfURL; xlsURL; pdfFileName; xlsFileName;

    connectedCallback() {
        console.log('User Language ==> ',this.language);
        this.labels = JSON.parse(labels);
    }

    // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
    @wire(getSalesArea, {
        recordId: "$recordId"
    })
    getSalesArea(result) {
        this.isLoading = true;
        console.log('result ===> ',result);
        if(result.data){
            let saArr = [];
            for (let i = 0; i < result.data.length; i++) {
                const option = {
                    label: String(result.data[i].SalesOrg__r.Name),
                    value: String(result.data[i].Company_Code__c) + '-' + String(result.data[i].Sales_Org_Code__c)
                };
                saArr = [...saArr, option];
            }
            console.log('saArr==>',saArr);
            this.salesAreaOptions = saArr;
            if(this.salesAreaOptions.length != 0){
                this.salesArea = this.salesAreaOptions[0].value;
                this.isLoading = false;
            }
            this.getCreditData();
        }else if(result.error){
            this.errorMessage = JSON.stringify(result.error);
            this.isLoading = false;
        }
    }

    handleSalesAreaOption(event){
        this.creditData = undefined;
        this.salesArea = event.detail.value;
        this.getCreditData();
    }

    getCreditData() {
        this.errorMessage = undefined;
        this.creditData = undefined;
        let cmpCode;
        let salesOrg;
        if(this.salesArea){
            cmpCode = this.salesArea.split("-")[0];
            salesOrg = this.salesArea.split("-")[1];
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }
        this.isLoading = true;
        getData({ 
            recordId: this.recordId,
            Comp_Code: cmpCode,
            sCode: salesOrg,
        }).then(result => {  
            console.log( ' credit => result => ',result );
            if(result.success){
                this.creditData = result.data;
                this.account = result.account;
                this.pdfFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.creditSummary + '.pdf';
                this.xlsFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.creditSummary + '.xls';
                this.generatedDocumentURL();
            }else{
                var errMsg = result.message;
                if(errMsg == 'Error_In_SAP'){
                    this.errorMessage = this.labels.errorInSap;
                }else if(errMsg == 'Required_Data_Missing'){
                    this.errorMessage = this.labels.reqDataMissingError;
                }else if(errMsg == 'no_access'){
                    this.errorMessage = this.labels.noAccess;
                }else if(errMsg == 'wrong_acc'){
                    this.errorMessage = this.labels.wrongAcc;
                }else if(errMsg == 'no_mapping'){
                    this.errorMessage = this.labels.noMapping;
                }else{
                    this.errorMessage = errMsg;
                }
            }
            this.isLoading = false;
        })
        .catch(error => {
            this.isLoading = false;
            this.errorMessage = error;
            console.log( 'credit => error =>'+JSON.stringify(error) );
        });
    }
    // END for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    generatedDocumentURL(){
        this.pdfURL = "/apex/Grz_CreditSummaryInternalPDF?CreditLimit=" +
                        this.creditData[0].CreditLimit +
                        "&CreditExposure=" +
                        this.creditData[0].CreditExposure +
                        "&BalanceLimit=" +
                        this.creditData[0].BalanceLimit +
                        "&Percentage=" +
                        this.creditData[0].Percentage +
                        "&Name=" +
                        this.account[0].Name +
                        "&fileName=" +
                        this.pdfFileName;

        this.xlsURL = "/apex/Grz_CreditSummaryInternalXLS?CreditLimit=" +
                        this.creditData[0].CreditLimit +
                        "&CreditExposure=" +
                        this.creditData[0].CreditExposure +
                        "&BalanceLimit=" +
                        this.creditData[0].BalanceLimit +
                        "&Percentage=" +
                        this.creditData[0].Percentage +
                        "&Name=" +
                        this.account[0].Name +
                        "&fileName=" +
                        this.xlsFileName;
    }

    pdfDownloadClick() {
        window.open(this.pdfURL, '_blank');
    }
    xlsDownloadClick() {
        window.open(this.xlsURL, '_blank');
    }
}