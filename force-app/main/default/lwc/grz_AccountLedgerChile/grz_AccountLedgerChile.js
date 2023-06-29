import { api, LightningElement, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import detailsLabel from "@salesforce/label/c.Grz_AccountInformation";
import { loadStyle } from "lightning/platformResourceLoader";
import getAccountStatement from "@salesforce/apex/grz_AccountLedgerChileController.getAccountStatement";
import getCustomerRecord from "@salesforce/apex/grz_AccountLedgerChileController.getCustomerRecord";
import getLedgerStatement from "@salesforce/apex/grz_AccountLedgerChileController.getLedgerStatement";
import SendEMail from "@salesforce/apex/grz_SapIntegration.SendEMail"; //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
import getAccInfo from "@salesforce/apex/grz_AccountLedgerChileController.getAccInfo";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import LANG from "@salesforce/i18n/lang";
import FORM_FACTOR from '@salesforce/client/formFactor'//Added By Akhilesh for Mobile UI compatibilty
//For Pagination added by Akhilesh
import First from '@salesforce/label/c.First';
import Previous from '@salesforce/label/c.Previous';
import Next from '@salesforce/label/c.Next';
import Last from '@salesforce/label/c.Last';
import Page from '@salesforce/label/c.Page';
//Pagination labels ends here

const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
const ACC_SCROLL_TABLE_CLASS = "acc-table-data-scroll";
const ACC_NO_SCROLL_TABLE_CLASS = "acc-table-no-scroll";
export default class Grz_AccountLedgerChile extends LightningElement {
    backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
    downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
    filterIcon = Icons + "/Grz_Resourse/Images/FilterIcon.png";
    Headlabel = {
        detailsLabel,
    };
    @track isBr = false;
    @track language = LANG;
    @track companyCode;
    @track displayLedgerStatement;
    @track displayAccountStatement;
    @track statementType = "Both";
    @track quaterType;
    @track endDate;
    @track startDate;
    @track accNoRecordError = false;
    @track ledgerNoRecordError = false;
    @track isSpinner = false;
    queryTerm;
    @track lstOptions = [];
    @track ledgerTableScroll;
    @track accTableScroll;
    /*Customer Data*/
    @track CustomerCode;
    @track SalesOffice;
    @track CustomerName;
    @track GlAccountNumber;
    @track sapUserId;
    @track City;
    /*For Ledger*/
    @track ledgerData;
    @track ledgerYearType;
    @track ledgerFiscalYear;
    @track ledgerFiscalYearFrom;
    @track ledgerFiscalYearTo;
    @track showLedgerTable = false;
    @track displayPDF = false;
    @track totalCredit;
    @track totalDebit;
    @track openingBal;
    @track closingBal;
    @track ledgerURL;
    @track ledgerURLXls;
    @track ledgerDocType;
    @track accDocType;

    @track listOfSearchRecords = [];
    @track ledgerCustInfo = [];
    @track accountCustInfo = [];
    @track SearchKeyWord = "";
    @track AccStatementData;
    @track showAccountStatementTable = false;
    @track openingNegativeBalance = false;
    @track openingPositiveBalance = false;
    @track closingNegativeBalance = false;
    @track closingPositiveBalance = false;
    @track accTotalCredit;
    @track accTotalDebit;
    @api lstSelectedRecords = [];
    @track selecteditem = [];
    @track allDocType;
    @track accStatementURL;
    @track accError = false;

    @track YearOptions = [];
    @track LedgerYearOptions = [];
    @track customerSapCode;

    @track fiscalYear;
    @track fiscalYearFrom;
    @track fiscalYearTo;

    @track yearType;
    @track fiscalyearStartDate;
    @track fiscalyearEndDate;

    @track isCredit = true;
    @track isDebit = true;
    @track accStatementExcelURL;
    @track docCol1;
    @track docCol2;
    @track docCol3;
    @track docCol4;
    @track docCol5;
    @track isCstAvl = false;
    @track isAccCstAvl = false;
    @track ledgCustomerSap;
    @track customerSapAcc;
    @track isInternalUser = false;
    @track tempLedYear;

    //For Pagination Added by Akhilesh
    @track page = 1; //this is initialize for 1st page
    @track data = []; //data to be display in the table
    @track startingRecord = 1; //start record position per page
    @track pageSize = '10'; //default value we are assigning
    @track totalRecountCount=0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track endingRecord = 0; //end record position per page
    @track showSpinner = false;
    @track labels = {
        First,
        Previous,
        Next,
        Last,
        Page
    };//ends here

    @track portalLink;

    //For Account Statement
    @track showASTableColumn=[{label:'Fecha', fieldName:'PostDate', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Número de doc', fieldName:'AccountingDocNumber', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Número de Ref / Chq', fieldName:'ReferebceChqNumber', type: 'text', cellAttributes: { alignment: 'left' }},        
    {label:'Tipo de documento', fieldName:'DocType', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Crédito (USD)', fieldName:'Credit', type: 'DebitChile', cellAttributes: { alignment: 'left' }},
    {label:'Débito (USD)', fieldName:'Debit', type: 'CreditChile', cellAttributes: { alignment: 'left' }}
    ];

    //For Account Ledger
    @track showALTableColumn=[{label:'Fecha de publicación', fieldName:'PostDate', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Vencimiento', fieldName:'NetDueDate', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Tipo de documento', fieldName:'DocType', type: 'text', cellAttributes: { alignment: 'left' }},        
    {label:'Doc No. Particulares', fieldName:'AccountingDocNumber', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Número de Ref / Chq', fieldName:'ReferebceChqNumber', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Crédito (USD)', fieldName:'Credit', type: 'DebitChile', cellAttributes: { alignment: 'left' }},
    {label:'Débito (USD)', fieldName:'Debit', type: 'CreditChile', cellAttributes: { alignment: 'left' }},
    {label:'Saldo (USD)', fieldName:'RunningBalance', type: 'text', cellAttributes: { alignment: 'left' }}
    ];
    

    connectedCallback() {
        var today = new Date();
        //this.endDate = today.toISOString();
        //var last30days = new Date(today.setDate(today.getDate() - 30));
        //this.startDate = last30days.toISOString();
        this.startDate = String(today.getFullYear()) + "-01-01";
        //this.endDate = String(today.getFullYear()) + '-' + String(today.getMonth() -1).padStart(2, "0") + '-' + String(today.getDate().toString().padStart(2,0));
        //this.endDate = today.toDateString();
        var month = "" + (today.getMonth() + 1);
        var day = "" + today.getDate();
        var year = today.getFullYear();
        if (month.length < 2) month = "0" + month;
        if (day.length < 2) day = "0" + day;
        this.endDate = year+'-'+ month+'-'+ day;
        var todayLed = new Date();
        this.tempLedYear = todayLed.getFullYear();
        var dtNum = String(todayLed.getMonth() + 1).padStart(2, "0");
        if (dtNum == "01") {
            this.quaterType = "10";
            this.ledgerFiscalYearFrom = "10";
            this.ledgerFiscalYearTo = "10";
        } else if (dtNum == "02") {
            this.quaterType = "11";
            this.ledgerFiscalYearFrom = "11";
            this.ledgerFiscalYearTo = "11";
        } else if (dtNum == "03") {
            this.quaterType = "12";
            this.ledgerFiscalYearFrom = "12";
            this.ledgerFiscalYearTo = "12";
        } else if (dtNum == "10") {
            this.quaterType = "7";
            this.ledgerFiscalYearFrom = "7";
            this.ledgerFiscalYearTo = "7";
        } else {
            let st = dtNum;
            let ab = Number(st.replace("0", "")) - 3;
            this.quaterType = String(ab);
            this.ledgerFiscalYearFrom = String(ab);
            this.ledgerFiscalYearTo = String(ab);
        }

        //Added By Akhilesh
        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile =false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile =true;
        }//End

        //For Link Management added by Akhilesh
        var urlLink = (window.location.href).split('/s/')[0];
        console.log('url ----->',urlLink);
        if(urlLink.includes('uplpartnerportalstd')){
            this.portalLink='/uplpartnerportalstd';
        }else{
            this.portalLink='/uplpartnerportal';
        }
    }

    //Added By Akhilesh for pagination
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

//Added By Akhilesh for pagination code 
getdata(){
    this.page=1;                    
        this.showSpinner = false;
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
        if(this.showLedgerTable==true){
            this.data = JSON.parse(JSON.stringify(this.ledgerData.slice(0, this.pageSize)));
        }else{
            this.data = JSON.parse(JSON.stringify(this.AccStatementData.slice(0, this.pageSize)));
        }        
        this.rowNumberOffset = 0;
        this.endingRecord = this.pageSize;
        this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount)
            ? this.totalRecountCount : (this.pageSize * this.page);
     
      this.template.querySelector('c-responsive-card').tableData = this.data;
      this.template.querySelector('c-responsive-card').updateValues();
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
        if(this.showLedgerTable==true){
            this.data = this.ledgerData.slice(this.startingRecord, this.endingRecord);
        }else{
            this.data = this.AccStatementData.slice(this.startingRecord, this.endingRecord);
        }        
        this.rowNumberOffset = this.startingRecord;
    

    //increment by 1 to display the startingRecord count, 
    //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
    this.startingRecord = this.startingRecord + 1;

    //added by Vaishnavi w.r.t Mobile UI
    if(this.isMobile){
        this.template.querySelector('c-responsive-card').tableData = this.data;
        this.template.querySelector('c-responsive-card').updateValues();
    }
}
//Pagination change ends here

    @wire(getAccInfo)
    uplAccStatment(results) {
        if (results.data) {
            if (results.data.isInternalUser) {
                this.isInternalUser = true;
            } else {
                this.isInternalUser = false;
                this.companyCode = results.data.companyCode;
                this.sapUserId = results.data.sapUserId;
                this.customerSapCode = results.data.customerCode;
                this.City = results.data.city;
                this.CustomerName = results.data.name;
                this.CustomerCode = results.data.customerCode;
            }
            var today = new Date();
            let intCurYear = today.getFullYear();
            let curtYear = String(today.getFullYear());
            this.ledgerYearType = curtYear;
            this.ledgerFiscalYear = this.ledgerYearType;
            this.fiscalYear = curtYear;
            this.yearType = curtYear;
            this.fiscalyearStartDate = this.fiscalYear + "-01-01";
            this.fiscalyearEndDate = Number(this.fiscalYear) + "-12-31";
            let yy = [];
            for (let i = 1; i <= 3; i++) {
                if (i == 1) {
                    yy.push(intCurYear - 2);
                } else if (i == 2) {
                    yy.push(intCurYear - 1);
                } else {
                    yy.push(intCurYear);
                }
            }
            this.allDocType = results.data.docTypeInfo;
            let l1 = [];
            let l2 = [];
            let l3 = [];
            let l4 = [];
            let s = Math.floor(this.allDocType.length / 4);
            for (let i = 0; i < this.allDocType.length; i++) {
                if (l1.length < s) {
                    l1.push(this.allDocType[i]);
                } else if (l2.length < s) {
                    l2.push(this.allDocType[i]);
                } else if (l3.length < s) {
                    l3.push(this.allDocType[i]);
                } else {
                    l4.push(this.allDocType[i]);
                }
            }
            this.docCol1 = l1;
            this.docCol2 = l2;
            this.docCol3 = l3;
            this.docCol4 = l4;
            let yearArr = [];
            let accDocInfo = [];
            for (let i = 0; i < yy.length; i++) {
                const option = {
                    label: String(yy[i]),
                    value: String(yy[i]),
                };
                yearArr = [...yearArr, option];
            }
            for (let i = 0; i < this.allDocType.length; i++) {
                const option = {
                    label: this.allDocType[i].Short_Form__c,
                    value: this.allDocType[i].Short_Form__c,
                };
                accDocInfo = [...accDocInfo, option];
            }
            this.LedgerYearOptions = yearArr;
            this.YearOptions = yearArr;
            this.lstOptions = accDocInfo;
        }
        if (results.error) {
            this.error = results.error;
        }
    }

    onChangeSAPLedg(event) {
        const abc = event.detail;
        console.log('abccc===>',abc.recordId);
        this.ledgCustomerSap = abc.recordId;
    }
    onChangeSAPAcc(event) {
        const abc = event.detail;
        console.log('abccc===>',abc.recordId);
        this.customerSapAcc = abc.recordId;
    }
    handleGetLedgerClickInternal(event) {
        this.showLedgerTable = false;
        if (this.ledgCustomerSap != undefined && this.ledgCustomerSap != "") {
            this.isSpinner = true;
            getCustomerRecord({
                customerCode: this.ledgCustomerSap,
            }).then((result) => {
                if (result.noDistributor) {
                    const event = new ShowToastEvent({
                        title: "Distribuidor não encontrado",
                        variant: "error",
                    });
                    this.dispatchEvent(event);
                    this.isCstAvl = false;
                    this.ledgerNoRecordError = false;
                    this.isSpinner = false;
                } else {
                    this.customerSapCode = result.customerCode;
                    this.companyCode = result.companyCode;
                    this.sapUserId = result.sapUserId;
                    this.handleGetLedgerClick();
                }

            });
            //Added by Akhilesh For Mobile data updation w.r.t search
            if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
                this.template.querySelector('c-responsive-card').tableData = this.data;
                this.template.querySelector('c-responsive-card').updateValues();
            } 
        } else {
            const event = new ShowToastEvent({
                title: "cliente no puede estar vacío",
                variant: "error",
            });
            this.dispatchEvent(event);
            this.isSpinner = false;
        }
    }

    handleGetStatementClickInternal(event) {
        this.showAccountStatementTable = false;
        if (this.customerSapAcc != undefined && this.customerSapAcc != "") {
            this.isSpinner = true;
            console.log("customerSapAcc --- ", this.customerSapAcc);
            getCustomerRecord({
                customerCode: this.customerSapAcc,
            }).then((result) => {
                if (result.noDistributor) {
                    const event = new ShowToastEvent({
                        title: "Distribuidor não encontrado",
                        variant: "error",
                    });
                    this.dispatchEvent(event);
                    this.isAccCstAvl = false;
                    this.accNoRecordError = false;
                    this.isSpinner = false;
                } else {
                    this.customerSapCode = this.customerCode;
                    this.companyCode = result.companyCode;
                    this.sapUserId = result.sapUserId;
                    this.handleGetStatementClick();
                }
            });
        } else {
            const event = new ShowToastEvent({
                title: "cliente no puede estar vacío",
                variant: "error",
            });
            this.dispatchEvent(event);
            this.isSpinner = false;
        }
    }
    renderedCallback() {
        Promise.all([
            loadStyle(this, Icons + "/Grz_Resourse/CSS/SummaryTabs.css"),
        ]);
    }
    handleLedgerActive() {
        this.displayAccountStatement = false;
        this.displayLedgerStatement = true;
    }
    handleAccountActive() {
        this.displayAccountStatement = true;
        this.displayLedgerStatement = false;
        if (this.lstSelectedRecords.length > 0) {
            this.lstSelectedRecords = "";
        }
    }

    searchHelper(SearchKeyWord) {
        var excludeitemsList = this.lstSelectedRecords;
        var excludeitemsListValues = [];
        for (var i = 0; i < excludeitemsList.length; i++) {
            excludeitemsListValues.push(excludeitemsList[i].value);
        }
        var searchList = [];
        var searchList1 = [];
        if (SearchKeyWord.length > 0) {
            var term = SearchKeyWord.toLowerCase();
        }
        var listOfOptions = this.lstOptions;
        for (var i = 0; i < listOfOptions.length; i++) {
            var option = listOfOptions[i].label.toLowerCase();
            if (
                option.indexOf(term) !== -1 &&
                excludeitemsListValues.indexOf(listOfOptions[i].value) < 0
            ) {
                searchList.push(listOfOptions[i]);
            }
            if (
                !term &&
                excludeitemsListValues.indexOf(listOfOptions[i].value) < 0
            ) {
                searchList1.push(listOfOptions[i]);
            }
        }
        this.template
            .querySelector('[data-id="mySpinner"]')
            .classList.add("slds-show");
        this.listOfSearchRecords = searchList;
        if (!term) {
            this.listOfSearchRecords = searchList1;
        }
        if (!this.listOfSearchRecords.length > 0) {
            this.template
                .querySelector(".searchRes")
                .classList.add("slds-is-close");
            this.template
                .querySelector(".searchRes")
                .classList.remove("slds-is-open");
        }
    }

    onblurclick() {
        this.listOfSearchRecords = [];
        this.SearchKeyWord = "";
        this.template
            .querySelector(".searchRes")
            .classList.add("slds-is-close");
        this.template
            .querySelector(".searchRes")
            .classList.remove("slds-is-open");
    }
    keyPressController(event) {
        this.template
            .querySelector('[data-id="mySpinner"]')
            .classList.add("slds-show");
        this.SearchKeyWord = event.target.value;

        if (this.SearchKeyWord.length > 0 && this.SearchKeyWord.length <= 2) {
            this.template
                .querySelector(".searchRes")
                .classList.add("slds-is-open");
            this.template
                .querySelector(".searchRes")
                .classList.remove("slds-is-close");
            this.searchHelper(this.SearchKeyWord);
        } else {
            this.listOfSearchRecords = [];
            this.template
                .querySelector(".searchRes")
                .classList.add("slds-is-close");
            this.template
                .querySelector(".searchRes")
                .classList.remove("slds-is-open");
        }
    }
    clear(event) {
        var selectedPillId = event.target.name;
        var AllPillsList = this.lstSelectedRecords;
        var removepilllist = [];
        for (var i = 0; i < AllPillsList.length; i++) {
            removepilllist.push(AllPillsList[i]);
        }
        for (var i = 0; i < removepilllist.length; i++) {
            if (removepilllist[i].value == selectedPillId) {
                removepilllist.splice(i, 1);
                this.lstSelectedRecords = removepilllist;
            }
        }
        if (this.lstSelectedRecords.length == 0) {
            this.template
                .querySelector('[data-id="defaultValue1"]')
                .classList.remove("hidedefaultvalue");
        }
        this.listOfSearchRecords = [];
        this.SearchKeyWord = "";
    }
    selectRecord(event) {
        this.template
            .querySelector('[data-id="defaultValue1"]')
            .classList.add("hidedefaultvalue");
        this.SearchKeyWord = "";
        var selectedItem = event.currentTarget.dataset.value;
        var selectedItem2 = event.currentTarget.dataset.label;
        var includeitemsList = this.lstSelectedRecords;
        var listselecteditems = [];

        for (var i = 0; i < includeitemsList.length; i++) {
            listselecteditems.push(includeitemsList[i]);
        }
        listselecteditems.push({ label: selectedItem2, value: selectedItem });

        this.lstSelectedRecords = listselecteditems;
        this.template
            .querySelector('[data-id="lookup-pill"]')
            .classList.add("slds-show");
        this.template
            .querySelector('[data-id="lookup-pill"]')
            .classList.remove("slds-hide");

        this.template
            .querySelector(".searchRes")
            .classList.add("slds-is-close");
        this.template
            .querySelector(".searchRes")
            .classList.remove("slds-is-open");
    }
    get StatementOptions() {
        return [
            { label: "Ambas", value: "Both" },
            { label: "Crédito", value: "Credit" },
            { label: "Débito", value: "Debit" },
        ];
    }
    get QuaterOptions() {
        return [
            { label: "enero", value: "10" },
            { label: "febrero", value: "11" },
            { label: "marzo", value: "12" },
            { label: "abril", value: "1" },
            { label: "mayo", value: "2" },
            { label: "junio", value: "3" },
            { label: "julio", value: "4" },
            { label: "agosto", value: "5" },
            { label: "septiembre", value: "6" },
            { label: "octubre", value: "7" },
            { label: "noviembre", value: "8" },
            { label: "diciembre", value: "9" },
        ];
    }
    handleLedgerYearOption(event) {
        this.ledgerYearType = event.detail.value;
        this.ledgerFiscalYear = this.ledgerYearType;
        this.tempLedYear = event.detail.value;
    }
    handleYearOption(event) {
        this.yearType = event.detail.value;
        this.fiscalYear = this.yearType;
        this.fiscalyearStartDate = this.fiscalYear + "-01-01";
        this.fiscalyearEndDate = Number(this.fiscalYear) + "-12-31";
        this.startDate = this.fiscalyearStartDate;
        this.endDate = this.fiscalyearEndDate;
    }
    handleQuaterOption(event) {
        this.quaterType = event.detail.value;
        this.ledgerFiscalYearFrom = this.quaterType;
        this.ledgerFiscalYearTo = this.quaterType;
        /*if (this.quaterType == "1") {
      this.ledgerFiscalYearFrom = "1";
      this.ledgerFiscalYearTo = "3";
    } else if (this.quaterType == "2") {
      this.ledgerFiscalYearFrom = "4";
      this.ledgerFiscalYearTo = "6";
    } else if (this.quaterType == "3") {
      this.ledgerFiscalYearFrom = "7";
      this.ledgerFiscalYearTo = "9";
    } else if (this.quaterType == "4") {
      this.ledgerFiscalYearFrom = "10";
      this.ledgerFiscalYearTo = "12";
    }*/
    }

    handleStatementOption(event) {
        this.accError = false;
        this.statementType = event.detail.value;
    }
    handleKeyUp(event) {
        const isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            this.queryTerm = event.target.value;
        }
    }

    startdateChange(event) {
        this.startDate = event.target.value;
        console.log("----this.startdatesearch---", this.startDate);
        console.log("this.fiscalyearStartDate", this.fiscalyearStartDate);

        if (
            this.startDate < this.fiscalyearStartDate ||
            this.startDate > this.fiscalyearEndDate
        ) {
            this.notValidDate = true;
        } else if (this.startDate == null || this.endDate == null) {
            this.notValidDate = true;
        } else {
            this.notValidDate = false;
        }
    }
    enddateChange(event) {
        this.endDate = event.target.value;
        console.log("----this.enddatesearch---", this.endDate);
        if (
            this.endDate < this.fiscalyearStartDate ||
            this.endDate > this.fiscalyearEndDate
        ) {
            this.notValidDate = true;
        } else if (this.startDate == null || this.endDate == null) {
            this.notValidDate = true;
        } else {
            this.notValidDate = false;
        }
    }
    handleGetLedgerClick(event) {
        if (
            this.ledgerFiscalYearFrom == "10" ||
            this.ledgerFiscalYearFrom == "11" ||
            this.ledgerFiscalYearFrom == "12"
        ) {
            this.ledgerFiscalYear = this.tempLedYear - 1;
        } else {
            this.ledgerFiscalYear = this.tempLedYear;
        }
        if (
            this.ledgerFiscalYear != null &&
            this.ledgerFiscalYearFrom != null &&
            this.ledgerFiscalYearTo != null
        ) {
            this.isSpinner = true;
            this.showLedgerTable = false;
            console.log("customerSapCode---", this.customerSapCode);
            console.log("companyCode---", this.companyCode);
            console.log("sapUserId---", this.sapUserId);
            console.log("ledgerFiscalYear---", this.ledgerFiscalYear);
            console.log("ledgerFiscalYearFrom --- ", this.ledgerFiscalYearFrom);
            console.log("ledgerFiscalYearTo --- ", this.ledgerFiscalYearTo);
            getLedgerStatement({
                customerCode: this.customerSapCode,
                companyCode: this.companyCode,
                fiscalYear: this.ledgerFiscalYear,
                fiscalYearFrom: this.ledgerFiscalYearFrom,
                fiscalYearTo: this.ledgerFiscalYearTo,
                getDoc: true,
                sapUserId: this.sapUserId,
            }).then((result) => {
                if (result.isSuccess == false) {
                    const event = new ShowToastEvent({
                        title: result.msg,
                        variant: "error",
                    });
                    this.dispatchEvent(event);
                    this.isSpinner = false;
                } else if (result.isSuccess == true) {
                    window.console.log("result ====> ", result);
                    this.ledgerCustInfo = [];
                    this.ledgerCustInfo.push(result.customerInfo);
                    this.totalCredit = result.totalCredit;
                    this.totalDebit = result.totalDebit;
                    this.openingBal = result.customerInfo.OpeningBalance;
                    this.closingBal = result.customerInfo.ClosingBalance;
                    this.ledgerDocType = result.MetaDocType;
                    var csCode = result.customerInfo.CustomerCode;
                    if (csCode != "" && csCode != undefined) {
                        this.isCstAvl = true;
                    } else {
                        this.isCstAvl = false;
                    }
                    if (
                        this.closingBal.includes("-") &&
                        this.openingBal.includes("-")
                    ) {
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
                    if (
                        this.openingBal.includes("-") &&
                        !this.closingBal.includes("-")
                    ) {
                        this.openingNegativeBalance = true;
                        this.openingPositiveBalance = false;
                        this.closingNegativeBalance = false;
                        this.closingPositiveBalance = true;
                        this.openingBal = this.openingBal.replace("-", "");
                    } else if (
                        !this.openingBal.includes("-") &&
                        this.closingBal.includes("-")
                    ) {
                        this.openingNegativeBalance = false;
                        this.openingPositiveBalance = true;
                        this.closingNegativeBalance = true;
                        this.closingPositiveBalance = false;
                        this.closingBal = this.closingBal.replace("-", "");
                    }
                    this.ledgerData = result.ItemInfo;
                    this.data = this.ledgerData.slice(0, this.pageSize);//for Pagination
                        //Below code is added by Akhilesh For Pagination
                                this.recordCount = this.ledgerData.length;
                                this.totalRecountCount = this.recordCount;
                                console.log('details in ledgerData'+JSON.stringify(this.ledgerData));
                                this.page=1;                    
                                this.showSpinner = false;
                                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
                            this.data = this.ledgerData.slice(0, this.pageSize);
                            this.rowNumberOffset = 0;
                            this.endingRecord = this.pageSize;
                            this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount)
                                ? this.totalRecountCount : (this.pageSize * this.page);

                            this.error = undefined;  
                        //Added by Akhilesh For Mobile data updation w.r.t search
                        if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
                            this.template.querySelector('c-responsive-card').tableData = this.data;
                            this.template.querySelector('c-responsive-card').updateValues();
                        } 
                    if (this.ledgerData.length > 12) {
                        this.ledgerTableScroll = SCROLL_TABLE_CLASS;
                    } else {
                        this.ledgerTableScroll = NO_SCROLL_TABLE_CLASS;
                    }
                    if (this.ledgerData.length == 0) {
                        this.ledgerNoRecordError = true;
                        this.showLedgerTable = false;
                    } else {
                        this.ledgerNoRecordError = false;
                        this.showLedgerTable = true;
                    }
                    this.isSpinner = false;
                    this.ledgerURL =
                        this.portalLink+"/apex/Grz_AccountLedgerChilePDF?fiscalYear=" +
                        this.ledgerFiscalYear +
                        "&customerCode=" +
                        this.customerSapCode +
                        "&companyCode=" +
                        this.companyCode +
                        "&fiscalYearFrom=" +
                        this.ledgerFiscalYearFrom +
                        "&fiscalYearTo=" +
                        this.ledgerFiscalYearTo +
                        "&sapUserId=" +
                        this.sapUserId;

                    this.ledgerURLXls =
                        this.portalLink+"/apex/Grz_AccountLedgerChileXLS?fiscalYear=" +
                        this.ledgerFiscalYear +
                        "&customerCode=" +
                        this.customerSapCode +
                        "&companyCode=" +
                        this.companyCode +
                        "&fiscalYearFrom=" +
                        this.ledgerFiscalYearFrom +
                        "&fiscalYearTo=" +
                        this.ledgerFiscalYearTo +
                        "&sapUserId=" +
                        this.sapUserId;
                }
            });
        }
    }
    handleGetStatementClick(event) {
        console.log("StartDate==> ", this.startDate);
        console.log("EndDate==> ", this.endDate);
        if (this.statementType != null) {
            this.accError = false;
            this.isSpinner = true;
            this.showAccountStatementTable = false;
            var listselecteditems = [];
            if (this.lstSelectedRecords.length != 0) {
                for (var i = 0; i < this.lstSelectedRecords.length; i++) {
                    listselecteditems.push(this.lstSelectedRecords[i].value);
                }
            }
            var start = new Date(this.startDate.slice(0, 10));
            var end = new Date(this.endDate);
            var today = new Date();
            var StartThreeMon = new Date(this.startDate);
            StartThreeMon.setMonth(StartThreeMon.getMonth() + 3);
            StartThreeMon.setDate(StartThreeMon.getDate() - 1);
            var threemonStart = StartThreeMon.toISOString().slice(0, 10);
            var EndThreeMon = new Date(this.endDate);
            EndThreeMon.setMonth(EndThreeMon.getMonth() - 3);
            var threemonEnd = EndThreeMon.toISOString().slice(0, 10);
            /*if (start > today || end > today) {
        const event = new ShowToastEvent({
          title: "Start date and end date must be less than today",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      } */
            if (start > end) {
                const event = new ShowToastEvent({
                    title:
                        "La fecha de inicio no puede ser mayor que la fecha de finalización",
                    variant: "error",
                });
                this.dispatchEvent(event);
                this.isSpinner = false;
                //3090100163
            } else if (end < start) {
                const event = new ShowToastEvent({
                    title:
                        "La fecha de finalización no puede ser menor que la fecha de inicio",
                    variant: "error",
                });
                this.dispatchEvent(event);
                this.isSpinner = false;
                //3090100163
            } else if (
                this.startDate.substring(0, 4) != this.fiscalYear ||
                this.endDate.substring(0, 4) != this.fiscalYear
            ) {
                const event = new ShowToastEvent({
                    title:
                        "Las fechas deben estar dentro del rango de años seleccionado.",
                    variant: "error",
                });
                this.dispatchEvent(event);
                this.isSpinner = false;
            } else {
                console.log("in else");
                if (this.startDate.substring(5, 7) == "01") {
                    this.fiscalYearFrom = "10";
                } else if (this.startDate.substring(5, 7) == "02") {
                    this.fiscalYearFrom = "11";
                } else if (this.startDate.substring(5, 7) == "03") {
                    this.fiscalYearFrom = "12";
                } else if (this.startDate.substring(5, 7) == "10") {
                    this.fiscalYearFrom = "7";
                } else {
                    let st = this.startDate.substring(5, 7);
                    let ab = Number(st.replace("0", "")) - 3;
                    this.fiscalYearFrom = String(ab);
                }
                if (this.endDate.substring(5, 7) == "01") {
                    this.fiscalYearTo = "10";
                } else if (this.endDate.substring(5, 7) == "02") {
                    this.fiscalYearTo = "11";
                } else if (this.endDate.substring(5, 7) == "03") {
                    this.fiscalYearTo = "12";
                } else if (this.endDate.substring(5, 7) == "10") {
                    this.fiscalYearTo = "7";
                } else {
                    let st = this.endDate.substring(5, 7);
                    let ab = Number(st.replace("0", "")) - 3;
                    this.fiscalYearTo = String(ab);
                }
                if (this.statementType == "Credit") {
                    this.isCredit = true;
                    this.isDebit = false;
                } else if (this.statementType == "Debit") {
                    this.isDebit = true;
                    this.isCredit = false;
                } else if (this.statementType == "Both") {
                    this.isCredit = true;
                    this.isDebit = true;
                }
                var yearStr;
                var fromStr;
                var toStr;

                if (
                    this.fiscalYearFrom == "10" ||
                    this.fiscalYearFrom == "11" ||
                    this.fiscalYearFrom == "12"
                ) {
                    if (
                        this.fiscalYearTo == "10" ||
                        this.fiscalYearTo == "11" ||
                        this.fiscalYearTo == "12"
                    ) {
                        fromStr = this.fiscalYearFrom;
                        toStr = this.fiscalYearTo;
                        yearStr = String(parseInt(this.fiscalYear) - 1);
                    } else {
                        fromStr = this.fiscalYearFrom + "," + "1";
                        toStr = "12" + "," + this.fiscalYearTo;
                        yearStr =
                            String(parseInt(this.fiscalYear) - 1) +
                            "," +
                            this.fiscalYear;
                    }
                } else {
                    fromStr = this.fiscalYearFrom;
                    toStr = this.fiscalYearTo;
                    yearStr = this.fiscalYear;
                }
                console.log("startdate---", this.startDate);
                console.log("endDate---", this.endDate);
                console.log("fiscalYear---", yearStr);
                console.log("fiscalYearFrom --- ", fromStr);
                console.log("fiscalYearTo --- ", toStr);
                getAccountStatement({
                    customerCode: this.customerSapCode,
                    companyCode: this.companyCode,
                    fiscalYear: yearStr,
                    fiscalYearFrom: fromStr,
                    fiscalYearTo: toStr,
                    docFilter: listselecteditems,
                    startDate: this.startDate,
                    endDate: this.endDate,
                    getDoc: true,
                    sapUserId: this.sapUserId,
                }).then((result) => {
                    console.log("in then");
                    console.log("result.isSuccess", result.isSuccess);
                    console.log("result", result);
                    if (result.isSuccess == false) {
                        console.log("in false");
                        const event = new ShowToastEvent({
                            title: result.msg,
                            variant: "error",
                        });
                        this.dispatchEvent(event);
                        this.isSpinner = false;
                    } else if (result.isSuccess == true) {
                        window.console.log("result ====> ", result);
                        this.accountCustInfo = [];
                        this.accountCustInfo.push(result.customerInfo);
                        var csCode = result.customerInfo.CustomerCode;
                        if (csCode != "" && csCode != undefined) {
                            this.isAccCstAvl = true;
                        } else {
                            this.isAccCstAvl = false;
                        }
                        this.accTotalCredit = result.totalCredit;
                        this.accTotalDebit = result.totalDebit;
                        this.AccStatementData = result.ItemInfo;
                        this.data = this.AccStatementData.slice(0, this.pageSize);//for Pagination
                        //Below code is added by Akhilesh For Pagination
                                this.recordCount = this.AccStatementData.length;
                                this.totalRecountCount = this.recordCount;
                                console.log('details in AccStatementData'+JSON.stringify(this.AccStatementData));
                                this.page=1;                    
                                this.showSpinner = false;
                                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
                            this.data = this.AccStatementData.slice(0, this.pageSize);
                            this.rowNumberOffset = 0;
                            this.endingRecord = this.pageSize;
                            this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount)
                                ? this.totalRecountCount : (this.pageSize * this.page);

                            this.error = undefined;  
                        //Added by Akhilesh For Mobile data updation w.r.t search
                        if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
                            this.template.querySelector('c-responsive-card').tableData = this.data;
                            this.template.querySelector('c-responsive-card').updateValues();
                        } 
                        this.accDocType = result.MetaDocType;
                        if (this.AccStatementData.length > 12) {
                            this.accTableScroll = ACC_SCROLL_TABLE_CLASS;
                        } else {
                            this.accTableScroll = ACC_NO_SCROLL_TABLE_CLASS;
                        }
                        if (this.AccStatementData.length == 0) {
                            this.accNoRecordError = true;
                            this.showAccountStatementTable = false;
                        } else {
                            this.accNoRecordError = false;
                            this.showAccountStatementTable = true;
                        }

                        this.isSpinner = false;
                        this.accStatementURL =
                            this.portalLink+"/apex/Grz_AccountStatementChilePDF?fiscalYear=" +
                            yearStr +
                            "&customerCode=" +
                            this.customerSapCode +
                            "&companyCode=" +
                            this.companyCode +
                            "&fiscalYearFrom=" +
                            fromStr +
                            "&fiscalYearTo=" +
                            toStr +
                            "&docFilter=" +
                            listselecteditems +
                            "&startDate=" +
                            this.startDate +
                            "&endDate=" +
                            this.endDate +
                            "&isCredit=" +
                            this.isCredit +
                            "&isDebit=" +
                            this.isDebit +
                            "&sapUserId=" +
                            this.sapUserId;

                        this.accStatementExcelURL =
                            this.portalLink+"/apex/Grz_AccountStatementChileXLS?fiscalYear=" +
                            yearStr +
                            "&customerCode=" +
                            this.customerSapCode +
                            "&companyCode=" +
                            this.companyCode +
                            "&fiscalYearFrom=" +
                            fromStr +
                            "&fiscalYearTo=" +
                            toStr +
                            "&docFilter=" +
                            listselecteditems +
                            "&startDate=" +
                            this.startDate +
                            "&endDate=" +
                            this.endDate +
                            "&isCredit=" +
                            this.isCredit +
                            "&isDebit=" +
                            this.isDebit +
                            "&sapUserId=" +
                            this.sapUserId;
                    }
                });
            }
        } else {
            console.log("in last else");
            this.accError = true;
        }
    }
    ledPDF() {
        this.isSpinner = true;
        setTimeout(() => {
            this.isSpinner = false;
        }, 3000);
    }
    accPDF() {
        this.isSpinner = true;
        setTimeout(() => {
            this.isSpinner = false;
        }, 3000);
    }
    get fiscalyearStartDate() {
        return this.getFiscalYearStart() + "-01-01";
    }

    get fiscalyearEndDate() {
        return this.getFiscalYearStart() + "-12-31";
    }

    getFiscalYearStart() {
        var fiscalyearStart = "";
        var today = new Date();

        if (today.getMonth() + 1 <= 3) {
            fiscalyearStart = today.getFullYear() - 1;
        } else {
            fiscalyearStart = today.getFullYear();
        }
        console.log("-----fiscalyearStart---- " + fiscalyearStart);
        return fiscalyearStart;
    }

    //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
    GetAccAsPDF(){
        this.callEmail(this.accStatementURL, 'pdf');
    }
      GetAccAsXLS(){
        this.callEmail(this.accStatementExcelURL, 'xls');
    }

    GetledgerAsPDF(){
    this.callEmail(this.ledgerURL, 'pdf');
    }
    GetledgerAsXLS(){
    this.callEmail(this.ledgerURLXls, 'xls');
    }
      
    callEmail(fileUrl,filetype){
        this.isSpinner = true;
    SendEMail({ 
        Url : fileUrl, 
        fileType : filetype,
        fileName : 'Declaración del libro mayor',
        subjectName : 'Declaración del libro mayor',
        });
        setTimeout(() => {
            this.isSpinner = false;
            const event = new ShowToastEvent({
                title: "Archivo adjunto enviado por correo electrónico.",
                variant: "success"
            });
            this.dispatchEvent(event);
        }, 3000);
    }
}