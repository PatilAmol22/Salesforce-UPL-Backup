/**************************************************************************************************
* Name               : grz_CollectionInternal.js                                              
* Description        : JS controller for grz_CollectionInternal component.                           
* Created Date       : 16/06/2022
* Created By         : Nikhil Verma (Grazitti)                                                   
**************************************************************************************************/                                         
import { LightningElement, wire, api,track} from 'lwc';
import LANG from "@salesforce/i18n/lang";
import modal from "@salesforce/resourceUrl/quickActionWidth";
import { loadStyle } from "lightning/platformResourceLoader";
import { CloseActionScreenEvent } from 'lightning/actions';
import labels from "@salesforce/label/c.Grz_CollectionTranslation"
import sapuserId from "@salesforce/label/c.Grz_SapUserId"
import getData from "@salesforce/apex/Grz_CollectionInternal.getData";
import getSalesArea from "@salesforce/apex/Grz_SapCommonIntegration.getSalesAreaValues"; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
import getCollectionData from "@salesforce/apex/Grz_CollectionInternal.getCollectionData";
export default class Grz_CollectionInternal extends LightningElement {
    @api recordId;
    @track labels;
    @track sapuserId = sapuserId;
    @track errorMessage;
    @track collectionData;
    @track account;
    @track isLoading = true;
    @track showDownloadOption = false;     
    @track language = LANG;
    @track pdfURL; xlsURL; pdfFileName; xlsFileName;
    fiscalYear; fiscalPeriod; tempLedYear; finalFiscalYear;
    yearOptions; selectedMonth; vfYear; vfMonth;
    @track salesAreaOptions; salesArea; salesOrg; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    connectedCallback() {
        console.log('User Language ==> ',this.language);
        loadStyle(this, modal);
        this.labels = JSON.parse(labels);
        this.setYear();
        this.setMonth();
    }

    setMonth(){
        var today = new Date();
        var month = String(today.getMonth() + 1).padStart(2, "0");
        if (month == "01") {
            this.selectedMonth = "10";
            this.fiscalPeriod = "10";
        } else if (month == "02") {
            this.selectedMonth = "11";
            this.fiscalPeriod = "11";
        } else if (month == "03") {
            this.selectedMonth = "12";
            this.fiscalPeriod = "12";
        } else if (month == "10") {
            this.selectedMonth = "7";
            this.fiscalPeriod = "7";
        } else {
            let st = month;
            let ab = Number(st.replace("0", "")) - 3;
            this.selectedMonth = String(ab);
            this.fiscalPeriod = String(ab);
        }
    }
    
    setYear(){
        var today = new Date();
        let currentYear = today.getFullYear();
        this.fiscalYear = String(currentYear);
        this.tempLedYear = String(currentYear);
        let yearArr = [];
        for (let i = currentYear; i > currentYear - 3; i--) {
            const option = {
                label: String(i),
                value: String(i),
            };
            console.log('option==>',option);
            yearArr = [...yearArr, option];
        }
        this.yearOptions = yearArr;
    }

    get monthOptions() {
        return [
            { label: this.labels.jan, value: "10" },
            { label: this.labels.feb, value: "11" },
            { label: this.labels.march, value: "12" },
            { label: this.labels.april, value: "1" },
            { label: this.labels.may, value: "2" },
            { label: this.labels.june, value: "3" },
            { label: this.labels.july, value: "4" },
            { label: this.labels.aug, value: "5" },
            { label: this.labels.sep, value: "6" },
            { label: this.labels.oct, value: "7" },
            { label: this.labels.nov, value: "8" },
            { label: this.labels.dec, value: "9" },
        ];
    }
    @wire(getData, {
        recordId: "$recordId"
    })
    getData(result) {
        this.isLoading = true;
        console.log('result ===> ',result);
        if(result.data){
            if (result.data.success) {
                this.account = result.data.data; 
            }else{
                var errMsg = result.data.message;
                if(errMsg == 'Required_Data_Missing'){
                    this.errorMessage = this.labels.dataMissingErr;
                }else if(errMsg == 'no_access'){
                    this.errorMessage = this.labels.noAccess;
                }else if(errMsg == 'wrong_acc'){
                    this.errorMessage = this.labels.wrongAcc;
                }else{
                    this.errorMessage = errMsg;
                }
            }
            this.isLoading = false;
        }else if(result.error){
            this.errorMessage = result.error;
            this.isLoading = false;
            console.log('error ===> ',JSON.stringify(result.error));
        }
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
        }else if(result.error){
            this.errorMessage = JSON.stringify(result.error);
            this.isLoading = false;
        }
    }

    handleSalesAreaOption(event){
        this.salesArea = event.detail.value;
    }
    // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    handleYearOption(event){
        this.fiscalYear = event.detail.value;
        this.tempLedYear = event.detail.value;
    }

    handleMonthOption(event){
        this.selectedMonth = event.detail.value;
        this.fiscalPeriod = event.detail.value;
    }

    getCollectionData(){
        // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        let cmpCode;
        let salesOrg;
        if(this.salesArea){
            cmpCode = this.salesArea.split("-")[0];
            salesOrg = this.salesArea.split("-")[1];
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }else{
            cmpCode = this.account[0].Company_Code__c;
            salesOrg = this.account[0].Sales_Org_Code__c;
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }
        // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

        this.isLoading = true;
        this.errorMessage = undefined;
        this.showDownloadOption = false;
        this.collectionData = undefined;
        if (this.fiscalPeriod == "10" || this.fiscalPeriod == "11" || this.fiscalPeriod == "12") {
            this.finalFiscalYear = String(this.tempLedYear - 1);
        } else {
            this.finalFiscalYear = String(this.tempLedYear);
        }
        for(var i=0 ; i< this.monthOptions.length ; i++){
            if(this.monthOptions[i].value == String(this.fiscalPeriod)){
                this.vfMonth = this.monthOptions[i].label;
                break;
            } 
        }
        this.vfYear = String(this.tempLedYear);
        getCollectionData({ 
            customerCode: this.account[0].SAP_Customer_Code__c,
            companyCode: cmpCode, // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
            sapUserId: this.sapuserId,
            fiscalYear: this.finalFiscalYear,
            fiscalPeriod: this.fiscalPeriod,
            salesOrgCode: salesOrg // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        })
            .then(result => {  
                console.log( ' Collection => result => ',result );
                if(result.success){
                    this.collectionData = result.collection;
                    this.pdfFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.collection + '.pdf';
                    this.xlsFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.collection + '.xls';
                    this.showDownloadOption = true;
                    this.generatedDocumentURL();
                }else{
                    if(result.message == 'Error_In_SAP'){
                        this.errorMessage = this.labels.errorInSap;
                    }else{
                        this.errorMessage = result.message;
                    }
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.isLoading = false;
                this.errorMessage = error;
                console.log( 'Collection => error =>'+JSON.stringify(error) );
            });
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    generatedDocumentURL(){
        // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        let cmpCode;
        let salesOrg;
        if(this.salesArea){
            cmpCode = this.salesArea.split("-")[0];
            salesOrg = this.salesArea.split("-")[1];
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }else{
            cmpCode = this.account[0].Company_Code__c;
            salesOrg = this.account[0].Sales_Org_Code__c;
            console.log('==> ',salesOrg +' ==> ', cmpCode);
        }
        // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        this.pdfURL = "/apex/Grz_CollectionInternalPDF?customerCode=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&companyCode=" +
                        cmpCode + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&sapUserId=" +
                        this.sapuserId +
                        "&name=" +
                        this.account[0].Name +
                        "&fiscalYear=" +
                        this.finalFiscalYear +
                        "&fiscalPeriod=" +
                        this.fiscalPeriod +
                        "&salesOrgCode=" +
                        salesOrg + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&fileName=" +
                        this.pdfFileName +
                        "&vfYear=" +
                        this.vfYear +
                        "&vfMonth=" +
                        this.vfMonth;

        this.xlsURL = "/apex/Grz_CollectionInternalXLS?customerCode=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&companyCode=" +
                        cmpCode + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&sapUserId=" +
                        this.sapuserId +
                        "&name=" +
                        this.account[0].Name +
                        "&fiscalYear=" +
                        this.finalFiscalYear +
                        "&fiscalPeriod=" +
                        this.fiscalPeriod +
                        "&salesOrgCode=" +
                        salesOrg + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&fileName=" +
                        this.xlsFileName +
                        "&vfYear=" +
                        this.vfYear +
                        "&vfMonth=" +
                        this.vfMonth;
    }

    pdfDownloadClick() {
        window.open(this.pdfURL, '_blank');
    }
    xlsDownloadClick() {
        window.open(this.xlsURL, '_blank');
    }
}