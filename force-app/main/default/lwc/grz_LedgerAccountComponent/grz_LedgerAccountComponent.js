import { api, LightningElement, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import detailsLabel from "@salesforce/label/c.Grz_AccountInformation";
import { loadStyle } from "lightning/platformResourceLoader";
import getAccountStatement from "@salesforce/apex/Grz_AccountLedgerStatement.getAccountStatement";
import SendMail from "@salesforce/apex/Grz_AccountLedgerStatement.SendMail";
import getLedgerStatement from "@salesforce/apex/Grz_AccountLedgerStatement.getLedgerStatement";
import getAccInfo from "@salesforce/apex/Grz_AccountLedgerStatement.getAccInfo";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getData from "@salesforce/apex/Grz_OutstandingSummaryInternal.getData";
import getSalesArea from "@salesforce/apex/Grz_OutstandingSummaryInternal.getSalesAreaValues";
import LANG from "@salesforce/i18n/lang";
import labels from "@salesforce/label/c.Grz_OutstandingSummaryTranslation"
const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
const ACC_SCROLL_TABLE_CLASS = "acc-table-data-scroll";
const ACC_NO_SCROLL_TABLE_CLASS = "acc-table-no-scroll";
export default class Grz_LedgerAccountComponent extends NavigationMixin(
  LightningElement
) {
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  filterIcon = Icons + "/Grz_Resourse/Images/FilterIcon.png";
  Headlabel = {
    detailsLabel
  };
   isScreen=false;
  @track isBr = false;
  @track language = LANG;
  @track companyCode;
  @track displayLedgerStatement;
  @track displayAccountStatement;
  @track displayOutstandingSummary;
  @track statementType;
  @track quaterType = "1";
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
  @track ledgerFiscalYearFrom = "1";
  @track ledgerFiscalYearTo = "3";
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
  @track doctyperecordcheck = false;
  //Change by grazitti 12Dec22 for Invoice Download functionality by Swaranjeet
 // @track contentDocid;
  @track documentid;
  @track YearOptions = [];
  @track LedgerYearOptions = [];
  @track SalesAreaOptions = [];
  @track customerSapCode;

  @track fiscalYear;
  @track fiscalYearFrom;
  @track fiscalYearTo;

  @track yearType;
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;
  @track isMX = false;
  @track isCredit = true;
  @track isDebit = true;
  @track accStatementExcelURL;
  @track docCol1;
  @track docCol2;
  @track docCol3;
  @track docCol4;
  @track docCol5;
  @track errorMessage;
  @track accountId;
  @track outstandingData;
  @track labels;
  @track outstandingSummaryPdfURL;
  @track outstandingSummaryExcelURL;
  @track salesArea;
  @track outNoRecordError=false;
  @track showOutstandingDataTable=false;
  connectedCallback() {
     window.addEventListener('resize', this.myFunction);

         console.log('screen================='+screen.width);
         if(screen.width<768)this.isScreen=true;
         else this.isScreen=false; 
    var today = new Date();
    this.endDate = today.toISOString();
    var last30days = new Date(today.setDate(today.getDate() - 30));
    this.startDate = last30days.toISOString();
    console.log('language---', this.language);
     if(this.language == 'es-MX'){
       this.isMX = true;
       console.log('isMX---',this.isMX);
    }else{
       this.isMX = false;
         console.log('isMX---',this.isMX);
    }
    this.labels = JSON.parse(labels);
    
  }

  
 myFunction = () => {
    if(screen.width<768)this.isScreen=true; 
    else this.isScreen=false; 

    console.log('isScreen=========='+this.isScreen);
 };
  @wire(getAccInfo)
  uplAccStatment(results) {
    if (results.data) {
      this.accountId=results.data.Id;
      console.log('this.accountId----',this.accountId);
      this.companyCode = results.data.companyCode;
      this.sapUserId = results.data.sapUserId;
      this.customerSapCode = results.data.customerCode;
      this.City = results.data.city;
      this.CustomerName = results.data.name;
      this.CustomerCode = results.data.customerCode;
      /* this.CustomerCode = results.data.cstInfo.CustomerCode;
      this.SalesOffice = results.data.cstInfo.SalesOffice;
      this.CustomerName = results.data.cstInfo.CustomerName;
      this.GlAccountNumber = results.data.cstInfo.GlAccountNumber;
      this.City = results.data.cstInfo.City;*/
      let intCurYear = results.data.currentFiscalYear;
      let curtYear = String(results.data.currentFiscalYear);
      this.ledgerYearType = curtYear;
      this.ledgerFiscalYear = this.ledgerYearType;
      this.fiscalYear = curtYear;
      this.yearType = curtYear;
      this.fiscalyearStartDate = this.fiscalYear + "-04-01";
      this.fiscalyearEndDate = Number(this.fiscalYear) + 1 + "-03-31";
      let yy = [];
      for (let i = 1; i <= 2; i++) {
        if (i == 1) {
          yy.push(intCurYear - 1);
        } else {
          yy.push(intCurYear);
        }
      }
      console.log("currentFiscalYear---" + results.data.currentFiscalYear);
      console.log("customerCode---" + results.data.customerCode);
      console.log("companyCode---" + this.companyCode);
      console.log("sapUserId---" + this.sapUserId);
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
      //for Fiscal Years
      //let allYears = String(results.data.fiscalYears);
      //let strYears = allYears.split(",");
      //Change for fiscal year label India Community RITM0491232
      let yearArr = [];
      let accDocInfo = [];
      for (let i = 0; i < yy.length; i++) {
        const option = {
          label: String(yy[i])+'-'+String(yy[i]+1),
          value: String(yy[i])
        };
        yearArr = [...yearArr, option];
      }
      for (let i = 0; i < this.allDocType.length; i++) {
        const option = {
          label: this.allDocType[i].Short_Form__c,
          value: this.allDocType[i].Short_Form__c
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
     this.getSalesAreaOptions();
  }
  renderedCallback() {
    Promise.all([loadStyle(this, Icons + "/Grz_Resourse/CSS/SummaryTabs.css")]);
  }
  handleLedgerActive() {
    this.displayAccountStatement = false;
    this.displayLedgerStatement = true;
    this.displayOutstandingSummary=false;
    // this.getSalesAreaOptions();
  }
  handleAccountActive() {
    this.displayAccountStatement = true;
    this.displayLedgerStatement = false;
    this.displayOutstandingSummary=false;
    if (this.lstSelectedRecords.length > 0) {
      this.lstSelectedRecords = "";
    }
     this.getSalesAreaOptions();
  }
  handleOutstandingActive() {
    this.displayAccountStatement = false;
    this.displayLedgerStatement = false;
    this.displayOutstandingSummary=true;
    if (this.lstSelectedRecords.length > 0) {
      this.lstSelectedRecords = "";
    }
    this.getSalesAreaOptions();
    //this.getOutstandingData();
  }
  getSalesAreaOptions(){
    console.log('this.accountId-------123-',this.accountId);
      getSalesArea({
      recordId:this.accountId     
    }).then((result) => {
  console.log('result of sales area==>',result);
  let saArr = [];
  for (let i = 0; i < result.length; i++) {
  const option = {
    label: String(result[i].SalesOrg__r.Name),
    value: String(result[i].Company_Code__c)
  };
  saArr = [...saArr, option];
  }
  console.log('saArr==>',saArr);
  this.SalesAreaOptions=saArr;
  if(this.SalesAreaOptions.length!=0)
  this.salesArea=this.SalesAreaOptions[0].value;
    });
  }
  handleSalesAreaOption(event){
    this.showOutstandingDataTable=false;
     this.showLedgerTable = false;
     this.showAccountStatementTable = false;
    this.salesArea=event.detail.value;
    console.log('this.salesArea---',this.salesArea);
  }
  handleGetSummaryClick(){
    this.getOutstandingData();
  }
  getOutstandingData(){
    this.outstandingData=[];
    console.log('companyCode==>',this.salesArea);
    this.isSpinner = true;
    getData({
      recordId:this.accountId,
      companyCode:this.salesArea     
    }).then((result) => {
      console.log('outstandingData==>',result);
      
      this.isSpinner = false;
      if(result.data){
        if (result.success) {
          this.showOutstandingDataTable=true;
            this.outstandingData = result.data;
            console.log('this.outstandingData==>',this.outstandingData);
            var pdfFileName=this.outstandingData.customerNumber + '-' + this.labels.outstandingSummary + '.pdf';
            console.log('pdfFileName==>',pdfFileName);
            this.outstandingSummaryPdfURL = "/uplpartnerportal/apex/Grz_OutstandingSummaryInternalPDF?OutstandingData=" +
            JSON.stringify(this.outstandingData) +
            "&fileName=" +
            pdfFileName;
            console.log(' this.outstandingSummaryPdfURL==>', this.outstandingSummaryPdfURL);
            var xlsFileName=this.outstandingData.customerNumber + '-' + this.labels.outstandingSummary + '.xls';
            console.log('xlsFileName==>',xlsFileName);
            this.outstandingSummaryExcelURL = "/uplpartnerportal/apex/Grz_OutstandingSummaryInternalXLS?OutstandingData=" +
            JSON.stringify(this.outstandingData) +
            "&fileName=" +
            xlsFileName;
            console.log(' this.outstandingSummaryExcelURL==>', this.outstandingSummaryExcelURL);
        }else{
          this.showOutstandingDataTable=false;
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
    }else if(result.error){
      this.showOutstandingDataTable=false;
        this.isSpinner = false;
        console.log(JSON.stringify(result.error));
        this.errorMessage = JSON.stringify(result.error);
    }
    if(result.data==undefined){
      this.showOutstandingDataTable=false;
      this.outNoRecordError=true;
      this.isSpinner = false;
    }
    });
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
      if (!term && excludeitemsListValues.indexOf(listOfOptions[i].value) < 0) {
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
  }

  onblurclick() {
    this.listOfSearchRecords = [];
    this.SearchKeyWord = "";
    this.template.querySelector(".searchRes").classList.add("slds-is-close");
    this.template.querySelector(".searchRes").classList.remove("slds-is-open");
  }
  keyPressController(event) {
    debugger;
    this.template
      .querySelector('[data-id="mySpinner"]')
      .classList.add("slds-show");
    this.SearchKeyWord = event.target.value;

    if (this.SearchKeyWord.length > 0 && this.SearchKeyWord.length <= 2) {
      this.template.querySelector(".searchRes").classList.add("slds-is-open");
      this.template
        .querySelector(".searchRes")
        .classList.remove("slds-is-close");
      this.searchHelper(this.SearchKeyWord);
    } else {
      this.listOfSearchRecords = [];
      this.template.querySelector(".searchRes").classList.add("slds-is-close");
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

    this.template.querySelector(".searchRes").classList.add("slds-is-close");
    this.template.querySelector(".searchRes").classList.remove("slds-is-open");
  }
  get StatementOptions() {
    return [
      { label: "Both", value: "Both" },
      { label: "Credit", value: "Credit" },
      { label: "Debit", value: "Debit" }
    ];
  }
  get QuaterOptions() {
    return [
      { label: "Quarter 1", value: "1" },
      { label: "Quarter 2", value: "2" },
      { label: "Quarter 3", value: "3" },
      { label: "Quarter 4", value: "4" }
    ];
  }
  get QuaterOptionsBr() {
    return [
      { label: "Abril - junho", value: "1" },
      { label: "Julho - setembro", value: "2" },
      { label: "Outubro - dezembro", value: "3" },
      { label: "Janeiro - Março", value: "4" }
    ];
  }
  handleLedgerYearOption(event) {
    this.ledgerYearType = event.detail.value;
    this.ledgerFiscalYear = this.ledgerYearType;
  }
  handleYearOption(event) {
    this.yearType = event.detail.value;
    this.fiscalYear = this.yearType;
    this.fiscalyearStartDate = this.fiscalYear + "-04-01";
    this.fiscalyearEndDate = Number(this.fiscalYear) + 1 + "-03-31";
    this.startDate = this.fiscalyearStartDate;
    this.endDate = this.fiscalyearEndDate;
  }
  handleQuaterOption(event) {
    this.quaterType = event.detail.value;
    console.log("Selected Option --- ", this.quaterType);
    if (this.quaterType == "1") {
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
    }
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
  
    downloaddocument(event)
    {
        
        this.documentid = event.target.dataset.value;
        window.location.href = '/uplpartnerportal/sfc/servlet.shepherd/document/download/' + this.documentid + '?operationContext=S1';
        console.log(' window.location.href--', window.location.href);
    }
  handleGetLedgerClick(event) {
   this.doctyperecordcheck=false;
    console.log('this.salesArea------',this.salesArea);
    if (
      this.ledgerFiscalYear != null &&
      this.ledgerFiscalYearFrom != null &&
      this.ledgerFiscalYearTo != null
    ) {
      this.isSpinner = true;
      this.showLedgerTable = false;
       console.log('in ledger');
      console.log("ledgerFiscalYear---", this.ledgerFiscalYear);
      console.log("ledgerFiscalYearFrom --- ", this.ledgerFiscalYearFrom);
      console.log("ledgerFiscalYearTo --- ", this.ledgerFiscalYearTo);
      getLedgerStatement({
        customerCode: this.customerSapCode,
        companyCode: this.salesArea,
        fiscalYear: this.ledgerFiscalYear,
        fiscalYearFrom: this.ledgerFiscalYearFrom,
        fiscalYearTo: this.ledgerFiscalYearTo,
        getDoc: true,
        sapUserId: this.sapUserId,
         accountidinfo: this.accountId
      }).then((result) => {
        if (result.isSuccess == false) {
          const event = new ShowToastEvent({
            title: result.msg,
            variant: "error"
          });
          this.dispatchEvent(event);
          this.isSpinner = false;
        } else if (result.isSuccess == true) {
          window.console.log("result ====> ", result);
          this.totalCredit = result.totalCredit;
          this.totalDebit = result.totalDebit;
          this.openingBal = result.customerInfo.OpeningBalance;
          this.closingBal = result.customerInfo.ClosingBalance;
          //Change by grazitti 12Dec22 for Invoice Download functionality by Swaranjeet
            //this.contentDocid = result.ContentDocid;
          this.ledgerDocType = result.MetaDocType;
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
          console.log('this.ledgerData==>',this.ledgerData);
          //Change by grazitti 1Nov22 for credit note functionality
          for(var r=0;r<result.ItemInfo.length;r++){
            if(result.ItemInfo[r].Doctyperecordcheck==true){
              this.doctyperecordcheck=true;
                console.log('this.doctyperecordcheck----',this.doctyperecordcheck);
              break;
            }
          }
           //console.log('this.doctyperecordcheck11123----',this.doctyperecordcheck);
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
            "/uplpartnerportal/apex/Grz_LedgerStatementDownload?fiscalYear=" +
            this.ledgerFiscalYear +
            "&customerCode=" +
            this.customerSapCode +
            "&companyCode=" +
            this.salesArea +
            "&fiscalYearFrom=" +
            this.ledgerFiscalYearFrom +
            "&fiscalYearTo=" +
            this.ledgerFiscalYearTo +
            "&sapUserId=" +
            this.sapUserId;
            
            this.ledgerURLXls =
            "/uplpartnerportal/apex/Grz_LedgerStatementXlsDownload?fiscalYear=" +
            this.ledgerFiscalYear +
            "&customerCode=" +
            this.customerSapCode +
            "&companyCode=" +
            this.salesArea +
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
      if (start > today || end > today) {
        const event = new ShowToastEvent({
          title: "Start date and end date must be less than today",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      } else if (start > end) {
        const event = new ShowToastEvent({
          title: "Start date cannot be greater than end date",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      }
      else if (start < new Date(threemonEnd) || end > new Date(threemonStart)) {

        
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
           console.log("startdate---", this.startDate);
        console.log("endDate---", this.endDate);
         this.accStatementURL =
              "/uplpartnerportal/apex/Grz_AccountStatementDownload?fiscalYear=" +
              this.fiscalYear +
              "&customerCode=" +
              this.customerSapCode +
              "&companyCode=" +
              this.salesArea +
              "&fiscalYearFrom=" +
              this.fiscalYearFrom +
              "&fiscalYearTo=" +
              this.fiscalYearTo +
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
              "/uplpartnerportal/apex/Grz_accountstatementdownloadxls?fiscalYear=" +
              this.fiscalYear +
              "&customerCode=" +
              this.customerSapCode +
              "&companyCode=" +
              this.salesArea +
              "&fiscalYearFrom=" +
              this.fiscalYearFrom +
              "&fiscalYearTo=" +
              this.fiscalYearTo +
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
        SendMail({ Url : this.accStatementURL,  startdate : this.startDate, enddate : this.endDate.substring(0,10)});
        const event = new ShowToastEvent({
          title:
            "Start date and end date duration is greater three months . So it is mailed to the customer",
          variant: "success"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      }
      else {
        console.log('in else');
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
        console.log('in account');
        console.log("startdate---", this.startDate);
        console.log("endDate---", this.endDate);
        console.log("statement---", this.statementType);
        console.log("fiscalYear---", this.fiscalYear);
        console.log("fiscalYearFrom --- ", this.fiscalYearFrom);
        console.log("fiscalYearTo --- ", this.fiscalYearTo);
        getAccountStatement({
          customerCode: this.customerSapCode,
          companyCode: this.salesArea,
          fiscalYear: this.fiscalYear,
          fiscalYearFrom: this.fiscalYearFrom,
          fiscalYearTo: this.fiscalYearTo,
          docFilter: listselecteditems,
          startDate: this.startDate,
          endDate: this.endDate,
          getDoc: true,
          sapUserId: this.sapUserId,
          accountidinfo: this.accountId
        }).then((result) => {
          console.log('in then');
          console.log('result.isSuccess', result.isSuccess);
           console.log('result',result);
          if (result.isSuccess == false) {
             console.log('in false');
            const event = new ShowToastEvent({
              title: result.msg,
              variant: "error"
            });
            this.dispatchEvent(event);
            this.isSpinner = false;
          } else if (result.isSuccess == true) {
            window.console.log("result ====> ", result);
            this.accTotalCredit = result.totalCredit;
            this.accTotalDebit = result.totalDebit;
            this.AccStatementData = result.ItemInfo;
            //Change by grazitti 1Nov22 for credit note functionality
            //this.doctyperecordcheck = result.Doctyperecordcheck;
              for(var r=0;r<result.ItemInfo.length;r++){
            if(result.ItemInfo[r].Doctyperecordcheck==true){
              this.doctyperecordcheck=true;
                console.log('this.doctyperecordcheck----',this.doctyperecordcheck);
              break;
            }
          }
         
         
          //Change by grazitti 12Dec22 for Invoice Download functionality by Swaranjeet
           // this.contentDocid = result.ContentDocid; 
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
              "/uplpartnerportal/apex/Grz_AccountStatementDownload?fiscalYear=" +
              this.fiscalYear +
              "&customerCode=" +
              this.customerSapCode +
              "&companyCode=" +
              this.salesArea +
              "&fiscalYearFrom=" +
              this.fiscalYearFrom +
              "&fiscalYearTo=" +
              this.fiscalYearTo +
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
              "/uplpartnerportal/apex/Grz_accountstatementdownloadxls?fiscalYear=" +
              this.fiscalYear +
              "&customerCode=" +
              this.customerSapCode +
              "&companyCode=" +
              this.salesArea +
              "&fiscalYearFrom=" +
              this.fiscalYearFrom +
              "&fiscalYearTo=" +
              this.fiscalYearTo +
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
       console.log('in last else');
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
    return this.getFiscalYearStart() - 1 + "-04-01";
  }

  get fiscalyearEndDate() {
    return this.getFiscalYearStart() + 1 + "-03-31";
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
}