/**************************************************************************************************
* Name               : grz_accountledgerexternal.js                                              
* Description        : JS controller for grz_accountledgerexternal component.                           
* Created Date       : 23/05/2022
* Created By         : Swaranjeet (Grazitti)                                                   
**************************************************************************************************/                                         
import { LightningElement, wire, api,track} from 'lwc';
import LANG from "@salesforce/i18n/lang";
import modal from "@salesforce/resourceUrl/quickActionWidth";
import { loadStyle } from "lightning/platformResourceLoader";
import { CloseActionScreenEvent } from 'lightning/actions';
import labels from "@salesforce/label/c.Grz_AccountLedgerTranslation"

import getData from "@salesforce/apex/Grz_AccountLedgerExternal.getData";
import getLedgerData from "@salesforce/apex/Grz_AccountLedgerExternal.getLedgerData";
import First from '@salesforce/label/c.First';
import Previous	from '@salesforce/label/c.Previous';
import Next from '@salesforce/label/c.Next';
import Last from '@salesforce/label/c.Last';
import Page from '@salesforce/label/c.Page';
import FORM_FACTOR from '@salesforce/client/formFactor';

const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
export default class Grz_accountledgerexternal extends LightningElement {
    @api recordId;
    @track labels;
   
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
    isMobile;
    column=[];
    @track page = 1;
    @track data=[];
    @track startingRecord = 1; //start record position per page
    @track pageSize = '5'; //default value we are assigning
    @track totalRecountCount=0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track endingRecord = 0; //end record position per page
    @track showSpinner = false;
    rowNumberOffset;
    labels1 = {
        
         First,
         Previous,
         Next,
         Last,
         Page
       
    };
    
    columns =[{"label":"{labels.docDate}","fieldName":"PostDate","value":""},
    {"label":"{labels.docNumber}","fieldName":"AccountingDocNumber","value":""},
    {"label":"{labels.docType}","fieldName":"DocType","value":""},
    {"label":"{labels.docDes}","fieldName":"docDes","value":""},
    {"label":"{labels.debit}","fieldName":"Debit","value":""},
    {"label":"{labels.credit}","fieldName":"Credit","value":""},
    {"label":"{labels.balance}","fieldName":"RunningBalance","value":""}];

    connectedCallback() {
        console.log('User Language ==> ',this.language);
        //Added by vaishnavi w.r.t Mobile resposiveness
        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile = false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile = true;
        }
        console.log('Labels =>',labels);
        loadStyle(this, modal);
        this.labels = JSON.parse(labels);
        this.setYear();
        this.setMonth();
        this.column=[{label: this.labels.docDate, fieldName:'PostDate'},
        {label: this.labels.docNumber, fieldName:'AccountingDocNumber'},
        {label: this.labels.docType, fieldName:'DocType'},
        {label: this.labels.docDes, fieldName:'docDes'},
        {label: this.labels.debit, fieldName:'Debit'},
        {label: this.labels.credit, fieldName:'Credit'},
        {label: this.labels.balance, fieldName:'RunningBalance'}];
    }
    get showFirstButton() {
        if (this.page == 1 || this.page == 0) {
            return true;
        }else if(this.totalRecountCount===0){
            return true;
        }else{
            return false;
        }
    }

    get showLastButton() {
       if(this.totalRecountCount===undefined || this.totalRecountCount === 0){
            return true;
       }
        if (Math.ceil(this.totalRecountCount / this.pageSize) === this.page || Math.ceil(this.totalRecountCount / this.pageSize)===0) {
            return true;
        }
        return false;
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
                label: String(i),
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
    @wire(getData)
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
        this.isLoading = true;
        this.errorMessage = undefined;
        this.ledgerNoRecordError = false;
        this.showDownloadOption = false;
        this.ledgerData = undefined;
        if (this.monthFrom == "10" || this.monthFrom == "11" || this.monthFrom == "12") {
            this.finalFiscalYear = String(this.tempLedYear - 1);
        } else {
            this.finalFiscalYear = String(this.tempLedYear);
        }
        for(var i=0 ; i< this.monthOptions.length ; i++){
            if(this.monthOptions[i].value == String(this.monthFrom)){
                this.vfMonth = this.monthOptions[i].label;
                break;
            } 
        }
        this.vfYear = String(this.tempLedYear);
        getLedgerData({ 
            customerCode: this.account[0].SAP_Customer_Code__c,
            companyCode: this.account[0].Company_Code__c,
            sapUserId: this.account[0].Sap_UserId__c,
            fiscalYear: this.finalFiscalYear,
            fiscalYearFrom: this.monthFrom,
            fiscalYearTo: this.monthTo,
            salesOrgCode: this.account[0].Sales_Org_Code__c
        })
            .then(result => {  
                console.log( ' ledgerData => result => ',result );
                if(result.success){
                    this.ledgerData = result.data.ItemInfo;
                    this.totalRecountCount = this.ledgerData.length;
                    console.log('ledgerData => ',this.ledgerData);
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
                
                this.page=1;   
                console.log('this.ledgerData==>',this.ledgerData);
                this.data = this.ledgerData.slice(0, this.pageSize);
                this.rowNumberOffset = 0;
                this.endingRecord = this.pageSize;
                this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount)
                    ? this.totalRecountCount : (this.pageSize * this.page);
                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
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
        //added by vaishnavi w.r.t Mobile.
        var url = (window.location.href).split('/s/')[0];
        //changed /Distributor/apex/ with url
        this.pdfURL = url+"/apex/Grz_AccountLedgerExternalPDF?customerCode=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&companyCode=" +
                        this.account[0].Company_Code__c +
                        "&sapUserId=" +
                        this.account[0].Sap_UserId__c +
                        "&fiscalYear=" +
                        this.finalFiscalYear +
                        "&fiscalYearFrom=" +
                        this.monthFrom +
                        "&fiscalYearTo=" +
                        this.monthTo +
                        "&salesOrgCode=" +
                        this.account[0].Sales_Org_Code__c +
                        "&fileName=" +
                        this.pdfFileName +
                        "&vfYear=" +
                        this.vfYear +
                        "&vfMonth=" +
                        this.vfMonth;

        this.xlsURL = url+"/apex/Grz_AccountLedgerExternalXLS?customerCode=" +
                        this.account[0].SAP_Customer_Code__c +
                        "&companyCode=" +
                        this.account[0].Company_Code__c +
                        "&sapUserId=" +
                        this.account[0].Sap_UserId__c +
                        "&fiscalYear=" +
                        this.finalFiscalYear +
                        "&fiscalYearFrom=" +
                        this.monthFrom +
                        "&fiscalYearTo=" +
                        this.monthTo +
                        "&salesOrgCode=" +
                        this.account[0].Sales_Org_Code__c +
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
    handleFirst(event) {
        if (this.page > 1) {
            this.page = 1;
            this.displayRecordPerPage(this.page);
        }          
    }

    handleLast(event) {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.totalPage;
            this.displayRecordPerPage(this.page);
        }         
    }

    handleNext(event) {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);
        }        
    }

    handlePrevious(event) {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }
  
    displayRecordPerPage(page) {

        /*let's say for 2nd page, it will be => "Displaying 6 to 10 of 23 records. Page 2 of 5"
        page = 2; pageSize = 5; startingRecord = 5, endingRecord = 10
        so, slice(5,10) will give 5th to 9th records.
        */
        //this.HandleButton();
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = ((this.pageSize * page) > this.totalRecountCount)
            ? this.totalRecountCount : (this.pageSize * page);
        
            this.data = this.ledgerData.slice(this.startingRecord, this.endingRecord);
            this.rowNumberOffset = this.startingRecord;
        
        

        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;
        this.template.querySelector('c-responsive-card').tableData = this.data;
        this.template.querySelector('c-responsive-card').updateValues();
    }
}