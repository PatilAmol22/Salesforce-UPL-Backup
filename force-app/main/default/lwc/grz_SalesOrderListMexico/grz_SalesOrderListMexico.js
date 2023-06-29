import { LightningElement, track, wire, api } from "lwc";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { NavigationMixin } from "lightning/navigation";
import Salesorders from "@salesforce/label/c.Grz_SalesOrder";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getSalesOrderRecord from "@salesforce/apex/Grz_SalesOrderListMexico.getSalesOrderRecord";
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class grz_SalesOrderListMexico extends NavigationMixin(LightningElement){

  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  DownloadPDF = DownloadPDF;
  DownloadXLS = DownloadXLS;
  @track searchKey = "";
  @api recordId;
  @track detailPageLink;
  Headertitle = Salesorders;
  @track pagenumber = 1;
  @track recordstart = 0;
  @track recordend = 0;
  @track totalpages = 1;
  @track totalrecords = 0;
  @track isLoading = false;
  @track currentpagenumber = 1;
  @track selectedFiscalYear = 0;
  @track onLoadFiscalYear = "0";
  @track pagesize = 10;
  @track value = "All";
  @track invoicevalue = "All";
  @track isParentBr = false;
  @track distributorOptionsBr = [];
  @track distributorValue = "All";
  @track datevalue = "CreatedDate desc";
  @track picValueOptions;
  @track salesOrderList;
  @track error;
  @track SalesOrderxlsURL;
  @track SalesOrderpdfURL;
  @track startDate;
  @track endDate;
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;
  @track isSpinner = false;
  @track validStartDate;
  @track validEndDate;
  @track todayDate;
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  /*get fiscalYearOptions() {
    return [
      { label: "Ano Fiscal Atual", value: "0" },
      { label: "Último Ano Fiscal", value: "1" }
    ];
  }*/
  get dateoptions() {
    return [
      { label: "Fecha de creación - Desc", value: "CreatedDate desc" },
      { label: "Fecha de creación - Asc", value: "CreatedDate asc" }
    ];
  }
   /*get invoiceoptions() {
     return [
      { label: "Todo", value: "All" },
      { label: "Pedido Faturado", value: "A" },
      { label: "Pedido em Processamento", value: "B" },
      { label: "Entrega prevista para", value: "Entrega prevista para" },
      { label: "Entregue em", value: "Entregue em" }
    ];
  }*/

  //Added by Vaishnavi for Mobile APP
  isMobile;

  @track orderColumn = [
    { label: 'Orden de venta', fieldName: 'SAPOrderNumber', type: 'text'  },
    { label: 'Estado de la orden', fieldName: 'OrderStatus', type: 'text'  },
    { label: 'Fecha de creación', fieldName: 'CreatedDate', type: 'text'  },
    { label: 'Cliente', fieldName: 'SoldToPartyName', type: 'text'  },
    { label: 'Ciudad', fieldName: 'City', type: 'text'  },
    { label: 'Moneda', fieldName: 'CurrencyMexico', type: 'text'  },
    { label: 'Monto', fieldName: 'Amount', type: 'text'  }
];
  
  connectedCallback() {

    //added by Vaishnavi w.r.t Mobile UI
    console.log('The device form factor is: ' + FORM_FACTOR);
    if(FORM_FACTOR == 'Large'){
        this.isMobile = false;
    }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
        this.isMobile = true;
    }
    console.log('this.isMobile ' + this.isMobile);


    var today = new Date();
    var dd = String(today.getDate()).padStart(2, "0");
    console.log('dd--',dd);
    var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
     console.log('mm--',mm);
    var yyyy = today.getFullYear();
    this.endDate = yyyy + "-" + mm + "-" + dd;
    this.todayDate = yyyy + "-" + mm + "-" + dd;
    if (today.getMonth() + 1 <= 3) {
      this.currentFiscalYear = today.getFullYear() - 1;
    } else {
      this.currentFiscalYear = today.getFullYear();
    }
    //this.currentFiscalYear = today.getFullYear();
    console.log('this.currentFiscalYear--',this.currentFiscalYear);
    this.startDate = this.currentFiscalYear + "-04-01";
    this.fiscalyearStartDate = Number(this.currentFiscalYear) - 1 + "-04-01";
    this.fiscalyearEndDate = Number(this.currentFiscalYear) + 1 + "-03-31";
  }
  renderedCallback() {
    this.template.querySelectorAll(".testcss").forEach((but) => {
      but.style.backgroundColor =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "#F47920" : "white";
      but.style.color =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "white" : "black";
    });
  }
  @wire(getSalesOrderRecord, {
    searchKey: "$searchKey",
    datefilter: "$datevalue",
    sortby: "$value",
    pageNumber: "$pagenumber",
    pageSize: "$pagesize",
    startDate: "$startDate",
    endDate: "$endDate",
    distributor: "$distributorValue"
  })
  getSalesOrderRecord(result) {
    if (result.data) {
      this.salesOrderList = result.data.salesWrapList;
      var url = '/uplpartnerportal/';
      if(window.location.href.includes('uplpartnerportalstd')){
        url='/uplpartnerportalstd/';
      }
      if (this.salesOrderList.length == 0) {
        this.nodata = true;
      } else {
        this.nodata = false;
        this.SalesOrderpdfURL =
                  url+"apex/Grz_SalesOrderMexicopdfDownload?searchKey=" +
                  this.searchKey +
                  "&datefilter=" +
                  this.datevalue +
                  "&sortby=" +
                  this.value +
                  "&startDate=" +
                  this.startDate +
                  "&endDate=" +
                  this.endDate +
                  "&distributor=" +
                  this.distributorValue;

        this.SalesOrderxlsURL =
                  url+"apex/Grz_SalesOrderMexicoxlsDownload?searchKey=" +
                  this.searchKey +
                  "&datefilter=" +
                  this.datevalue +
                  "&sortby=" +
                  this.value +
                  "&startDate=" +
                  this.startDate +
                  "&endDate=" +
                  this.endDate +
                  "&distributor=" +
                  this.distributorValue;
      }
      //console.log("salesOrderList+++++ ", result.data);
      let allPicVal = result.data.picklistValues;
      let tempPicVal = [];
      const optionAll = {
        label: "Todo",
        value: "All"
      };
      tempPicVal.push(optionAll);
      for (let i = 0; i < allPicVal.length; i++) {
        const option = {
          label: allPicVal[i],
          value: allPicVal[i]
        };
        tempPicVal = [...tempPicVal, option];
      }
     /* this.isParentBr = result.data.isParentBr;
      if(this.isParentBr){
        let distr = result.data.cstrCode;
        if (distr.length > 0) {
          let cstCode = [];
          const opt = {
            label: "Todo",
            value: "All"
          };
          cstCode = [...cstCode, opt];
          for (let i = 0; i < distr.length; i++) {
            const option = {
              label: distr[i],
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.distributorOptionsBr = cstCode;
        }
      }*/
      this.picValueOptions = tempPicVal;
      this.totalrecords = result.data.totalRecords;
      this.recordstart = result.data.RecordStart;
      this.recordend = result.data.RecordEnd;
      this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
      this.generatePageList(this.pagenumber, this.totalpages);
      this.isLoading = false;

    } else if (result.error) {
      this.isLoading = false;
      this.error = result.error;
      console.log("---error----", this.error);
    }
  }
  startDateChange(event) {
    this.validStartDate = event.target.value;
    var isInvalid = false;
    if(this.validStartDate < this.fiscalyearStartDate || this.validStartDate > this.fiscalyearEndDate){     
      const event = new ShowToastEvent({
        title: "Por favor introduzca una fecha valida",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    } else if (this.validStartDate > this.validEndDate) {
      const event = new ShowToastEvent({
        title: "La fecha de inicio no puede ser posterior a la fecha de finalización",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    } else if(this.validStartDate > this.todayDate){
      const event = new ShowToastEvent({
        title:
          "La fecha de inicio y la fecha de finalización deben ser inferiores a las de hoy.",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    var test;
    if(!isInvalid && this.validStartDate != this.startDate && this.validStartDate != null){
      console.log('hgd');
      this.startDate = this.validStartDate;
      this.isLoading = true;
      this.pagenumber = 1;
    }
    else{
      event.target.value = this.startDate;
    } 
  }
  endDateChange(event) {
    this.validEndDate = event.target.value;

    var isInvalid = false;

    if(this.validEndDate < this.fiscalyearStartDate || this.validEndDate > this.fiscalyearEndDate){     
      const event = new ShowToastEvent({
        title: "Por favor introduzca una fecha valida",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }else if(this.validEndDate > this.todayDate){
      const event = new ShowToastEvent({
        title:
          "La fecha de inicio y la fecha de finalización deben ser inferiores a las de hoy.",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    else if(this.validEndDate < this.validStartDate){
      const event = new ShowToastEvent({
        title:
          "La fecha de finalización no puede ser anterior a la fecha de inicio",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    if(!isInvalid && this.endDate != this.validEndDate && this.validEndDate != null){
      this.endDate = this.validEndDate;
      this.isLoading = true;
      this.pagenumber = 1;
    } 
    else{
      event.target.value = this.endDate;
    }
    //this.endDate = event.target.value;
  }
  handleChange(event) {
    this.isLoading = true;
    this.value = event.detail.value;
  }
  handleDistributor(event) {
    this.isLoading = true;
    this.distributorValue = event.target.value;
    this.pagenumber = 1;
  }
  handleChangeDate(event) {
    this.isLoading = true;
    this.datevalue = event.detail.value;
  }
    handleChangeinvoice(event) {
    this.isLoading = true;
      this.invoicevalue = event.detail.value;
  }
  handleFiscalYearChange(event) {
    this.isLoading = true;
    this.onLoadFiscalYear = event.detail.value;
    this.selectedFiscalYear = event.detail.value;
  }
  handleKeyChange(event) {
    var code = event.keyCode ? event.keyCode : event.which;
    if (code != 13) {
      return;
    }
    if (this.searchKey != event.target.value) {
      this.searchKey = event.target.value;
      this.isLoading = true;
    }
    if (this.searchKey == "") {
      this.isLoading = false;
    }
    this.pagenumber = 1;
  }
  clearClick(event) {
    this.isLoading = true;
    this.searchKey = "";
  }
  handleOrderDetail(event) {

    if(this.isMobile){
    this.recordId = event.detail;
    }else{
      this.recordId = event.currentTarget.dataset.value;
    }
   
    this.detailPageLink = "sales-order/" + this.recordId;
    if(this.isMobile){
      window.open(this.detailPageLink);
    }
  }
  buttonClick() {
    if (
      this.searchKey != this.template.querySelector("lightning-input").value
    ) {
      this.searchKey = this.template.querySelector("lightning-input").value;
      this.isLoading = true;
      this.pagenumber = 1;
    }
  }
  handleFirst(event) {
    this.isLoading = true;
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
      this.isLoading = true;
    }
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
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
    this.isLoading = true;
    this.pagenumber--;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }
  handleNext(event) {
    this.isLoading = true;
    this.pagenumber = this.pagenumber + 1;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }
  handleLast(event) {
    this.isLoading = true;
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
  SalesOrderPDF() {
    //window.location.href = this.ARpdfURL;
    if(this.isMobile){
      //window.location.href = this.SalesOrderpdfURL;
      var res = encodeURI(this.SalesOrderpdfURL);
      window.open(res,'_blank');
    }
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
  SalesOrderXLS() {
    //window.location.href = this.ARxlsURL;
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
}