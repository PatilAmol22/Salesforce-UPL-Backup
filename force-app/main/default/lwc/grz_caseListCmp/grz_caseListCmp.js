import { LightningElement, track, wire, api } from "lwc";
import getCaseListAll from "@salesforce/apex/grz_CaseListClass.getCaseListAll";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import LANG from "@salesforce/i18n/lang";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import CaseLabel from "@salesforce/label/c.Grz_Case"
import CaseType from "@salesforce/label/c.Grz_Issue_Type";
import CaseOwner from "@salesforce/label/c.Grz_CaseOwner";
import CreateDate from "@salesforce/label/c.Grz_CreatedDate"
import CaseNumber from "@salesforce/label/c.Grz_CaseNumber"
import NoData from "@salesforce/label/c.Grz_NoItemsToDisplay"
import ValidDateError from "@salesforce/label/c.Grz_ValidDateError"
import StartDateError from "@salesforce/label/c.Grz_StartDateError";
import StartEndDateError from "@salesforce/label/c.Grz_StartEndDateError";
import EndDateError from "@salesforce/label/c.Grz_EndDateError"
import CaseSubject from "@salesforce/label/c.Grz_CaseSubject"
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class Grz_caseListCmp extends LightningElement {
  DownloadPDF = DownloadPDF;
  DownloadXLS = DownloadXLS;
  @track searchKey = "";
  @track pagenumber = 1;
  @track recordstart = 0;
  @track recordend = 0;
  @track totalpages = 1;
  @track totalrecords = 0;
  @track caseCreatePageLink;
  @track detailPageLink;
  @track nodata = false;
  @track isSpinner = false;
  @track pagesize = 10;
  @track caseStatementURL;
  @track caseStatementExcelURL;
  @track value = "CreatedDate desc";
  @track statusvalue = "All";
  @track isBr = false;
  @track isInd = false;
  @track isMexico = false;
  @track isParentBr = false;
  @track distributorOptionsBr = [];
  @track distributorValue = "All";
  @track language = LANG;
  @track startDate;
  @track endDate;
  @track currentFiscalYear;
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;
  @track CaseLabel = CaseLabel;
  @track CaseType = CaseType;
  @track CaseOwner = CaseOwner;
  @track CreateDate = CreateDate;
  @track CaseNumber = CaseNumber;
  @track CaseSubject = CaseSubject;
  @track NoDateFound = NoData;
  @track ValidDateError = ValidDateError;
  @track StartDateError = StartDateError;
  @track StartEndDateError = StartEndDateError;
  @track EndDateError = EndDateError;
  @track MexicoCasePDF = '';
  @track MexicoCaseXLS = '';
  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track isMainParent = false;
  @track subGroupOption = [];
  @track subDistributor = '';
  //Added by Vaishnavi for Mobile APP
  isMobile;
  country;

  

  @track colLabels =[
    { label: 'CaseNumber', fieldName: 'casenumber', type: 'text'  },
    { label: 'CaseSubject', fieldName: 'subject', type: 'text'  },
    { label: 'Estado', fieldName: 'status', type: 'text'  },
    { label: 'CaseOwner', fieldName: 'ownername', type: 'text'  },
    { label: 'CreateDate', fieldName: 'createddate', type: 'date'  },
    { label: 'Última actualización', fieldName: 'lastmodifieddate', type: 'date'  },
    { label: 'CaseType', fieldName: 'casetype', type: 'text'  }

];

  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  connectedCallback() {


     //added by Vaishnavi w.r.t Mobile UI
     console.log('The device form factor is: ' + FORM_FACTOR);
     if(FORM_FACTOR == 'Large'){
         this.isMobile = false;
     }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
         this.isMobile = true;
     }
     console.log('this.isMobile ' + this.isMobile);


    if (this.language == "pt-BR") {
      this.isBr = true;
      this.statusvalue = "New";
    } 
    else if(this.language == "es-MX"){
      this.isMexico = true;
      this.country = 'Mexico';
    }
    else {
      this.isInd = true;
      this.isBr = false;
      this.isMexico = false;
    }

    var today = new Date();
    var dd = String(today.getDate()).padStart(2, "0");
    var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
    var yyyy = today.getFullYear();
    this.endDate = yyyy + "-" + mm + "-" + dd;
    this.todayDate = yyyy + "-" + mm + "-" + dd;
    /*if (today.getMonth() + 1 <= 3) {
      this.currentFiscalYear = today.getFullYear() - 1;
    } else {
      this.currentFiscalYear = today.getFullYear();
    }*/
    this.currentFiscalYear = today.getFullYear();
    if(this.isMexico){
      if (today.getMonth() + 1 <= 3) {
        this.currentFiscalYear = today.getFullYear() - 1;
      } else {
        this.currentFiscalYear = today.getFullYear();
      }
      this.startDate = this.currentFiscalYear + "-04-01";
      this.fiscalyearStartDate = Number(this.currentFiscalYear) - 1 + "-04-01";
      this.fiscalyearEndDate = Number(this.currentFiscalYear) + 1 + "-03-31";
    }else{
      this.startDate = this.currentFiscalYear + "-01-01";
      this.fiscalyearStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
      this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
    }
  }

  startDateChange(event) {
    this.validStartDate = event.target.value;
    var isInvalid = false;
    if (this.validStartDate < this.fiscalyearStartDate || this.validStartDate > this.fiscalyearEndDate) {
        const event = new ShowToastEvent({
          title: ValidDateError,
          variant: "error"
        });
        this.dispatchEvent(event);
        isInvalid = true;
    } else if (this.validStartDate > this.validEndDate) {
      const event = new ShowToastEvent({
        title: StartDateError,
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    } else if (this.validStartDate > this.todayDate) {
      const event = new ShowToastEvent({
        title: StartEndDateError,
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    if (!isInvalid && this.validStartDate != this.startDate && this.validStartDate != null) {
      this.startDate = this.validStartDate;
      this.isSpinner = true;
      this.pagenumber = 1;
    } else {
      event.target.value = this.startDate;
    }
  }
  endDateChange(event) {
    this.validEndDate = event.target.value;
    var isInvalid = false;

    if (this.validEndDate < this.fiscalyearStartDate || this.validEndDate > this.fiscalyearEndDate) {
      const event = new ShowToastEvent({
        title: StartDateError,
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    } else if (this.validEndDate > this.todayDate) {
      const event = new ShowToastEvent({
        title: StartEndDateError,
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    } else if (this.validEndDate < this.validStartDate) {
      const event = new ShowToastEvent({
        title: EndDateError,
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    if (!isInvalid && this.validEndDate != this.endDate && this.validEndDate != null) {
      this.endDate = this.validEndDate;
      this.isSpinner = true;
      this.pagenumber = 1;
    } else {
      event.target.value = this.endDate;
    }
    //this.endDate = event.target.value;
  }

  get options() {
    return [
      { label: "Created Date - Desc", value: "CreatedDate desc" },
      { label: "Created Date - Asc", value: "CreatedDate asc" },
      { label: "Last Update - Desc", value: "LastModifiedDate desc" },
      { label: "Last Update - Asc", value: "LastModifiedDate asc" }
    ];
  }
  accPDF() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 3000);
  }
  get statusoptions() {
    return [
      { label: "All", value: "All" },
      { label: "New", value: "New" },
      { label: "Reopen", value: "Reopen" },
      { label: "Closed", value: "Closed" }
    ];
  }
  get optionsBr() {
    return [
      { label: "Data de Criação – Decr", value: "CreatedDate desc" },
      { label: "Data de Criação – Cres", value: "CreatedDate asc" },
      { label: "Última Atualização – Decr", value: "LastModifiedDate desc" },
      { label: "Última Atualização – Cres", value: "LastModifiedDate asc" }
    ];
  }
  get statusoptionsBr() {
    return [
      { label: "Todos", value: "All" },
      { label: "Novo", value: "New" },
      { label: "Encerrada", value: "Closed" }
    ];
  }

  get optionsMx() {
    return [
      { label: "Fecha de creación - Decr", value: "CreatedDate desc" },
      { label: "Fecha de creación - Cres", value: "CreatedDate asc" },
      { label: "Última actualización - Decr", value: "LastModifiedDate desc" },
      { label: "Última actualización - Cres", value: "LastModifiedDate asc" }
    ];
  }
  get statusoptionsMx() {
    return [
      { label: "Todos", value: "All" },
      { label: "Nuevo", value: "Nuevo" },
      { label: "Pendiente", value: "pendiente" },
      {label: "Aprobado", value: "aprobado" },
      { label: 'Auto Aprobación', value: 'Auto Aprobación'},
      { label: "Cerrado", value: "Cerrado" }
    ];
  }

  @track casedetails;
  @track data;
  @track error;
  @wire(getCaseListAll, {
    language: "$language",
    searchKey: "$searchKey",
    startDate: "$startDate",
    endDate: "$endDate",
    OrderByDate: "$value",
    status: "$statusvalue",
    pageNumber: "$pagenumber",
    pageSize: "$pagesize",
    distributor: "$distributorValue",
    subGroupId: "$subDistributor"//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  })
  getCaseListAll(result) {
    if (result.data) {
      //below added by vaishnavi w.r.t mobile
      var url = (window.location.href).split('/s/')[0];
      let pdfUrl = "/uplpartnerportal/apex/Grz_CaseBrazilpdfDownload?searchKey=";
      let xlsurl = "/uplpartnerportal/apex/Grz_CaseBrazilxlsDownload?searchKey=";
      let mxpdfUrl = "/uplpartnerportal/apex/Grz_CaseMexicopdfDownload?searchKey=";
      let mxXlsUrl = "/uplpartnerportal/apex/Grz_CaseMexicoxlsDownload?searchKey=";
      let statementUrl = "/uplpartnerportal/apex/Grz_Casestatementdownload?searchKey=";
      let statementXlsUrl = "/uplpartnerportal/apex/Grz_Casestatementdownloadxls?searchKey=";

      if(url.includes('uplpartnerportalstd')){
        pdfUrl = "/uplpartnerportalstd/apex/Grz_CaseBrazilpdfDownload?searchKey=";
        xlsurl = "/uplpartnerportalstd/apex/Grz_CaseBrazilxlsDownload?searchKey=";
        mxpdfUrl = "/uplpartnerportalstd/apex/Grz_CaseMexicopdfDownload?searchKey=";
        mxXlsUrl = "/uplpartnerportalstd/apex/Grz_CaseMexicoxlsDownload?searchKey=";
        statementUrl = "/uplpartnerportalstd/apex/Grz_Casestatementdownload?searchKey=";
        statementXlsUrl = "/uplpartnerportalstd/apex/Grz_Casestatementdownloadxls?searchKey=";
      }


      this.casedetails = result.data.wrapCaseList;
      if (this.casedetails.length == 0) {
        this.nodata = true;
      } else {
        this.nodata = false;
      
      
        this.CasepdfURL = pdfUrl +
          this.searchKey +
          "&OrderByDate=" +
          this.value +
          "&status=" +
          this.statusvalue +
          "&startDate=" +
          this.startDate +
          "&endDate=" +
          this.endDate +
          "&distributor=" +
          this.distributorValue +
          "&subGroupId=" +
          this.subDistributor;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022

        this.CasexlsURL =xlsurl+
          this.searchKey +
          "&OrderByDate=" +
          this.value +
          "&status=" +
          this.statusvalue +
          "&startDate=" +
          this.startDate +
          "&endDate=" +
          this.endDate +
          "&distributor=" +
          this.distributorValue +
          "&subGroupId=" +
          this.subDistributor;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022

          this.MexicoCasePDF = mxpdfUrl+this.searchKey +
          "&OrderByDate=" +
          this.value +
          "&status=" +
          this.statusvalue +
          "&startDate=" +
          this.startDate +
          "&endDate=" +
          this.endDate;

          this.MexicoCaseXLS = mxXlsUrl+this.searchKey +
          "&OrderByDate=" +
          this.value +
          "&status=" +
          this.statusvalue +
          "&startDate=" +
          this.startDate +
          "&endDate=" +
          this.endDate;

       
      }

      this.caseStatementURL =statementUrl +
        this.searchKey +
        "&OrderByDate=" +
        this.value +
        "&status=" +
        this.statusvalue;
      this.caseStatementExcelURL =statementXlsUrl +
        this.searchKey +
        "&OrderByDate=" +
        this.value +
        "&status=" +
        this.statusvalue;
      //console.log('Cases Records : '+JSON.stringify(this.casedetails));
      this.totalrecords = result.data.totalRecords;
      // //added by Vaishnavi w.r.t Mobile UI
      // if(this.isMobile){
      //     this.template.querySelector('c-responsive-card').tableData = this.casedetails;
      //     this.template.querySelector('c-responsive-card').updateValues();
      // }
      //  this.brazilflag = result.data.brazilFlag;
      this.recordstart = result.data.RecordStart;
      this.recordend = result.data.RecordEnd;
      this.isParentBr = result.data.isParentBr;
      this.isMainParent = result.data.isMainParent;
      if (this.isParentBr) {
        let distr = result.data.cstrCode;
        if (distr.length > 0) {
          let cstCode = [];
          const opt = {
            label: "Todos",
            value: "All"
          };
          cstCode = [...cstCode, opt];
          for (let i = 0; i < distr.length; i++) {
            let arr = distr[i].split(' - ');
            const option = {
              label: arr[1].substr(0,25) + ' - ' + arr[2].substr(0,23) + ' - ' + arr[0].substr(arr[0].length - 7),//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.distributorOptionsBr = cstCode;
        }
      }
      //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      if (this.isMainParent) {
        let distr = result.data.subGroupData;
        if (distr.length > 0) {
          let cstCode = [];
          for (let i = 0; i < distr.length; i++) {
            let arr = distr[i].split(' - ');
            const option = {
              label: arr[1].substr(0,25) + ' - ' + arr[2].substr(0,23) + ' - ' + arr[0].substr(arr[0].length - 7),
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.subGroupOption = cstCode;
        }
      }
      this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
      this.generatePageList(this.pagenumber, this.totalpages);
      this.isSpinner = false;
    } else if (result.error) {
      this.isSpinner = false;
      this.error = result.error;
    }
  }
  handleDistributor(event) {
    this.isSpinner = true;
    this.distributorValue = event.target.value;
    this.subDistributor = '';//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    this.pagenumber = 1;
  }
  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  handleSubGroup(event) {
    this.isSpinner = true;
    this.distributorValue = "All";
    this.subDistributor = event.target.value;
    this.pagenumber = 1;
  }
  handleDate(event) {
    this.isSpinner = true;
    this.value = event.detail.value;
    this.pagenumber = 1;
  }
  handleStatus(event) {
    this.isSpinner = true;
    this.statusvalue = event.detail.value;
    this.pagenumber = 1;
  }

  handleKeyChange(event) {
    var code = event.keyCode ? event.keyCode : event.which;
    if (code != 13) {
      //'Enter' keycode
      return;
    }

    if (this.searchKey != event.target.value) {
      this.searchKey = event.target.value;
      this.isSpinner = true;
    }
    if (this.searchKey == "") {
      this.isSpinner = false;
    }
    this.pagenumber = 1;
  }
  clearClick() {
    this.isSpinner = true;
    this.searchKey = "";
  }
  buttonClick() {

    if (this.searchKey != this.template.querySelector("lightning-input").value) {
        this.searchKey = this.template.querySelector("lightning-input").value;
        this.isSpinner = true;
        this.pagenumber = 1;
    }
  }

  handleFirst(event) {
    this.isSpinner = true;
    var pagenumber = 1;
    this.pagenumber = pagenumber;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

  processMe(event) {
    var checkpage = this.pagenumber;
    this.pagenumber = parseInt(event.target.name);

    if (this.pagenumber != checkpage) {
      this.isSpinner = true;
    }

    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

  renderedCallback() {
    this.template.querySelectorAll(".testcss").forEach((but) => {
      but.style.backgroundColor =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "#F47920" : "white";
      but.style.color =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "white" : "black";
    });
  }

  get disableFirst() {
    if (this.pagenumber == 1) {
      return true;
    }
    return false;
  }

  get disableNext() {
    if (
      this.pagenumber == this.totalpages ||
      this.pagenumber >= this.totalpages
    ) {
      return true;
    }
    return false;
  }

  handlePrevious(event) {
    this.isSpinner = true;
    this.pagenumber--;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

  handleNext(event) {
    this.isSpinner = true;
    this.pagenumber = this.pagenumber + 1;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

  handleButtonClick() {
    this.caseCreatePageLink = "create-case";
  }

  navigateToRecordView(event) {
    var recordid;// = event.target.dataset.id;
    //this.detailPageLink = 'casedetailpage?id='+recordid;
    if(this.isMobile){
      recordid = event.detail;
    }else{
      recordid = event.target.dataset.id;
    }
    this.detailPageLink = "case/" + recordid;
    if(this.isMobile){
      window.open(this.detailPageLink);
    }
  }

  handleLast(event) {
    this.isSpinner = true;
    this.pagenumber = this.totalpages;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

  generatePageList = (pagenumber, totalpages) => {
    var pagenumber = parseInt(pagenumber);
    var pageList = [];
    var totalpages = this.totalpages;
    this.pagelist = [];
    if (totalpages > 1) {
      if (totalpages < 3) {
        if (pagenumber == 1) {
          pageList.push(1, 2);
        }
        if (pagenumber == 2) {
          pageList.push(1, 2);
        }
      } else {
        if (pagenumber + 1 < totalpages && pagenumber - 1 > 0) {
          pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
        } else if (pagenumber == 1 && totalpages > 2) {
          pageList.push(1, 2, 3);
        } else if (pagenumber + 1 == totalpages && pagenumber - 1 > 0) {
          pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
        } else if (pagenumber == totalpages && pagenumber - 1 > 0) {
          pageList.push(pagenumber - 2, pagenumber - 1, pagenumber);
        }
      }
    }
    this.pagelist = pageList;
  };
}