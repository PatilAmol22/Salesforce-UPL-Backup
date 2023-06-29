/**************************************************************************************************
* Name               : grz_AccountLedgerInternal.js                                              
* Description        : JS controller for grz_AccountLedgerInternal component.                           
* Created Date       : 23/05/2022
* Created By         : Nikhil Verma (Grazitti)                                                   
**************************************************************************************************/                                         
import { LightningElement, wire, api,track} from 'lwc';
import LANG from "@salesforce/i18n/lang";
import modal from "@salesforce/resourceUrl/quickActionWidth";
import { loadStyle } from "lightning/platformResourceLoader";
import { CloseActionScreenEvent } from 'lightning/actions';
import labels from "@salesforce/label/c.Grz_AccountLedgerTranslation"
import sapuserId from "@salesforce/label/c.Grz_SapUserId"
import getData from "@salesforce/apex/Grz_AccountLedgerInternal.getData";
import getLedgerData from "@salesforce/apex/Grz_AccountLedgerInternal.getLedgerData";
import getSalesArea from "@salesforce/apex/Grz_SapCommonIntegration.getSalesAreaValues"; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
export default class Grz_AccountLedgerInternal extends LightningElement {
    @api recordId;
    @track labels;
    @track sapuserId = sapuserId;
    @track errorMessage;
    @track ledgerData;
    @track account;
    @track ledgerTableScroll;
    @track isLoading = true;
    @track ledgerNoRecordError = false;
    @track openingNegativeBalance = false;
    @track openingPositiveBalance = false;
    @track closingNegativeBalance = false;
    @track closingPositiveBalance = false;     
    @track showDownloadOption = false;     
    @track language = LANG;
    @track pdfURL; xlsURL; pdfFileName; xlsFileName;
    totalCredit; totalDebit; openingBal; closingBal;
    fiscalYear; monthFrom; monthTo; tempLedYear; finalFiscalYear;
    ledgerYearOptions; selectedMonth; vfYear; vfMonth; 
    @track salesAreaOptions; salesArea; salesOrg; quaterType = "1"; // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    connectedCallback() {
        console.log('User Language ==> ',this.language);
        loadStyle(this, modal);
        this.labels = JSON.parse(labels);
        this.setYear();
        //this.setMonth();
        this.monthFrom = "1";
        this.monthTo = "3";
    }

    setMonth(){
        var today = new Date();
        var month = String(today.getMonth() + 1).padStart(2, "0");
        if (month == "01") {
            this.selectedMonth = "10";
            this.monthFrom = "10";
            this.monthTo = "10";
        } else if (month == "02") {
            this.selectedMonth = "11";
            this.monthFrom = "11";
            this.monthTo = "11";
        } else if (month == "03") {
            this.selectedMonth = "12";
            this.monthFrom = "12";
            this.monthTo = "12";
        } else if (month == "10") {
            this.selectedMonth = "7";
            this.monthFrom = "7";
            this.monthTo = "7";
        } else {
            let st = month;
            let ab = Number(st.replace("0", "")) - 3;
            this.selectedMonth = String(ab);
            this.monthFrom = String(ab);
            this.monthTo = String(ab);
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
                label: String(i) + '-' + String(i + 1), // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                value: String(i),
            };
            console.log('option==>',option);
            yearArr = [...yearArr, option];
        }
        this.ledgerYearOptions = yearArr;
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

    get QuaterOptions() {
        return [
          { label: "Quarter 1 (April - June)", value: "1" },
          { label: "Quarter 2 (July - Sept)", value: "2" },
          { label: "Quarter 3 (Oct - Dec)", value: "3" },
          { label: "Quarter 4 (Jan - March)", value: "4" }
        ];
    }
    handleQuaterOption(event) {
        this.quaterType = event.detail.value;
        console.log("Selected Option --- ", this.quaterType);
        if (this.quaterType == "1") {
            this.monthFrom = "1";
            this.monthTo = "3";
        } else if (this.quaterType == "2") {
            this.monthFrom = "4";
            this.monthTo = "6";
        } else if (this.quaterType == "3") {
            this.monthFrom = "7";
            this.monthTo = "9";
        } else if (this.quaterType == "4") {
            this.monthFrom = "10";
            this.monthTo = "12";
        }
    }
    // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->

    handleLedgerYearOption(event){
        this.fiscalYear = event.detail.value;
        this.tempLedYear = event.detail.value;
    }

    handleMonthOption(event){
        this.selectedMonth = event.detail.value;
        this.monthFrom = event.detail.value;
        this.monthTo = event.detail.value;
    }

    getLedgerData(){
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
        this.isLoading = true;
        this.errorMessage = undefined;
        this.ledgerNoRecordError = false;
        this.showDownloadOption = false;
        this.ledgerData = undefined;
        /*if (this.monthFrom == "10" || this.monthFrom == "11" || this.monthFrom == "12") {
            this.finalFiscalYear = String(this.tempLedYear - 1);
        } else {
            this.finalFiscalYear = String(this.tempLedYear);
        }*/
        this.finalFiscalYear = String(this.tempLedYear);
        /*for(var i=0 ; i< this.monthOptions.length ; i++){
            if(this.monthOptions[i].value == String(this.monthFrom)){
                this.vfMonth = this.monthOptions[i].label;
                break;
            } 
        }*/
        for(var i=0 ; i< this.QuaterOptions.length ; i++){
            if(this.QuaterOptions[i].value == String(this.quaterType)){
                this.vfMonth = this.QuaterOptions[i].label;
                break;
            } 
        }
        for(var i=0 ; i< this.ledgerYearOptions.length ; i++){
            if(this.ledgerYearOptions[i].value == String(this.finalFiscalYear)){
                this.vfYear = this.ledgerYearOptions[i].label;
                break;
            } 
        }
        // End for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        console.log('==> ' + this.finalFiscalYear + '==> ' + this.monthFrom + '==> ' + this.monthTo);
        getLedgerData({ 
            customerCode: this.account[0].SAP_Customer_Code__c,
            companyCode: cmpCode, // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
            sapUserId: this.sapuserId,
            fiscalYear: this.finalFiscalYear,
            fiscalYearFrom: this.monthFrom,
            fiscalYearTo: this.monthTo,
            salesOrgCode: salesOrg // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
        })
            .then(result => {  
                console.log( ' ledgerData => result => ',result );
                if(result.success){
                    this.ledgerData = result.data.ItemInfo;
                    this.totalCredit = result.totalCredit;
                    this.totalDebit = result.totalDebit;
                    this.openingBal = result.data.customerInfo.OpeningBalance;
                    this.closingBal = result.data.customerInfo.ClosingBalance;
                    this.pdfFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.ledgerStatement + '.pdf';
                    this.xlsFileName = this.account[0].SAP_Customer_Code__c + '-' + this.labels.ledgerStatement + '.xls';
                    if (this.closingBal.includes("-") && this.openingBal.includes("-")) {
                        this.openingNegativeBalance = true;
                        this.openingPositiveBalance = false;
                        this.closingNegativeBalance = true;
                        this.closingPositiveBalance = false;
                        this.closingBal = this.closingBal.replace("-", "");
                        this.openingBal = this.openingBal.replace("-", "");
                    } else {
                        this.openingNegativeBalance = false;
                        this.openingPositiveBalance = true;
                        this.closingNegativeBalance = false;
                        this.closingPositiveBalance = true;
                    }
                    if (this.openingBal.includes("-") && !this.closingBal.includes("-")) {
                        this.openingNegativeBalance = true;
                        this.openingPositiveBalance = false;
                        this.closingNegativeBalance = false;
                        this.closingPositiveBalance = true;
                        this.openingBal = this.openingBal.replace("-", "");
                    } else if (!this.openingBal.includes("-") && this.closingBal.includes("-")) {
                        this.openingNegativeBalance = false;
                        this.openingPositiveBalance = true;
                        this.closingNegativeBalance = true;
                        this.closingPositiveBalance = false;
                        this.closingBal = this.closingBal.replace("-", "");
                    }
                    if (this.ledgerData.length > 12) {
                        this.ledgerTableScroll = SCROLL_TABLE_CLASS;
                    } else {
                        this.ledgerTableScroll = NO_SCROLL_TABLE_CLASS;
                    }
                    if (this.ledgerData.length == 0) {
                        this.ledgerNoRecordError = true;
                        this.showDownloadOption = false;
                    } else {
                        this.ledgerNoRecordError = false;
                        this.showDownloadOption = true;
                    }
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
                console.log( 'ledgerData => error =>'+JSON.stringify(error) );
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
        this.pdfURL = "/apex/Grz_AccountLedgerInternalPDF?customerCode=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&companyCode=" +
                        cmpCode + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&sapUserId=" +
                        this.sapuserId +
                        "&fiscalYear=" +
                        this.finalFiscalYear +
                        "&fiscalYearFrom=" +
                        this.monthFrom +
                        "&fiscalYearTo=" +
                        this.monthTo +
                        "&salesOrgCode=" +
                        salesOrg + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&fileName=" +
                        this.pdfFileName +
                        "&vfYear=" +
                        this.vfYear +
                        "&vfMonth=" +
                        this.vfMonth;

        this.xlsURL = "/apex/Grz_AccountLedgerInternalXLS?customerCode=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&companyCode=" +
                        cmpCode + // for RITM0579566 SA GRZ(Nikhil Verma) 26-06-2023-->
                        "&sapUserId=" +
                        this.sapuserId +
                        "&fiscalYear=" +
                        this.finalFiscalYear +
                        "&fiscalYearFrom=" +
                        this.monthFrom +
                        "&fiscalYearTo=" +
                        this.monthTo +
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