/**************************************************************************************************
* Name               : grz_OutstandingSummaryInternal.js                                              
* Description        : JS controller for grz_OutstandingSummaryInternal component.                           
* Created Date       : 27/05/2022
* Created By         : Nikhil Verma (Grazitti)                                                   
**************************************************************************************************/                                         
import { LightningElement, wire, api,track} from 'lwc';
import LANG from "@salesforce/i18n/lang";
import labels from "@salesforce/label/c.Grz_OutstandingSummaryTranslation"
import { CloseActionScreenEvent } from 'lightning/actions';
import getFinalData from "@salesforce/apex/Grz_OutstandingSummaryInternal.getOutstanding360Data"; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
import getSalesArea from "@salesforce/apex/Grz_SapCommonIntegration.getSalesAreaValues"; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
import modal from "@salesforce/resourceUrl/quickActionWidth";
import { loadStyle } from "lightning/platformResourceLoader";
export default class Grz_OutstandingSummaryInternal extends LightningElement {
    @track labels;
    @api recordId;
    @track errorMessage;
    @track account;
    @track outstandingData;
    @track isLoading = true;
    @track language = LANG;
    @track pdfURL; xlsURL; pdfFileName; xlsFileName;
    @track salesAreaOptions; salesArea; salesOrg; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    connectedCallback() {
        console.log('User Language ==> ',this.language);
        loadStyle(this, modal);
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
            }
            this.isLoading = false;
            this.getOutstandingData();
        }else if(result.error){
            this.errorMessage = JSON.stringify(result.error);
            this.isLoading = false;
        }
    }

    handleSalesAreaOption(event){
        this.creditData = undefined;
        this.salesArea = event.detail.value;
        this.getOutstandingData();
    }

    getOutstandingData() {
        this.errorMessage = undefined;
        this.outstandingData = undefined;
        let cmpCode;
        let salesOrg;
        if(this.salesArea){
            cmpCode = this.salesArea.split("-")[0];
            salesOrg = this.salesArea.split("-")[1];
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }
        this.isLoading = true;
        getFinalData({ 
            recordId: this.recordId,
            Comp_Code: cmpCode,
            sCode: salesOrg,
        }).then(result => {  
            console.log( ' getOutstandingData => result => ',result );
            if (result.success) {
                this.outstandingData = result.data;
                this.account = result.account;
                this.pdfFileName = this.outstandingData.customerNumber + '-' + this.labels.outstandingSummary + '.pdf';
                this.xlsFileName = this.outstandingData.customerNumber + '-' + this.labels.outstandingSummary + '.xls';
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
                }else{
                    this.errorMessage = errMsg;
                }
            }
            this.isLoading = false;
        })
        .catch(error => {
            this.isLoading = false;
            this.errorMessage = error;
            console.log( 'getOutstandingData => error =>'+JSON.stringify(error) );
        });
    }
    // END for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    generatedDocumentURL(){
        this.pdfURL = "/apex/Grz_OutstandingSummaryInternalPDF?OutstandingData=" +
                        JSON.stringify(this.outstandingData) +
                        "&fileName=" +
                        this.pdfFileName;

        this.xlsURL = "/apex/Grz_OutstandingSummaryInternalXLS?OutstandingData=" +
                        JSON.stringify(this.outstandingData) +
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