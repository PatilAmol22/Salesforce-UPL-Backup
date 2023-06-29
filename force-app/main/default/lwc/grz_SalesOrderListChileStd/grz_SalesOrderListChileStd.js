import { LightningElement, track, wire, api } from "lwc";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { NavigationMixin } from "lightning/navigation";
import Salesorders from "@salesforce/label/c.Grz_SalesOrder";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getSalesOrderRecord from "@salesforce/apex/Grz_SalesOrderListChile.getSalesOrderRecord";
import getLineItems from "@salesforce/apex/Grz_SalesOrderListChile.getLineItems";
import SendEMail from "@salesforce/apex/grz_SapIntegration.SendEMail";//GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
import FORM_FACTOR from '@salesforce/client/formFactor';//Added by Akhilesh w.r.t Mobile UI

export default class Grz_SalesOrderListChile extends NavigationMixin(
  LightningElement
) {
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
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
  @track pagesize = 10;
  @track pagesizeStr = "10";
  @track datevalue = "CreatedDate desc";
  @track salesOrderList;
  @track error;
  @track SalesOrderxlsURL;
  @track SalesOrderpdfURL;
  @track startDate;
  @track endDate;
  @track orderStatus = "All";
  @track distributorId = "All";
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;
  @track isSpinner = false;
  @track validStartDate;
  @track validEndDate;
  @track todayDate;
  @track isModalOpen = false;
  @track noInfo = false;
  @track isInternalUser = false;
  @track lineItems;
  isMobile;
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  get dateoptions() {
    return [
      { label: "Fecha de creación - Desc", value: "CreatedDate desc" },
      { label: "Fecha de creación - Asc", value: "CreatedDate asc" },
    ];
  }
  get orderStatusOptions() {
    return [
      { label: "Toda", value: "All" },
      { label: "Pedido en proceso", value: "Pedido en proceso" },
      { label: "Entrega en Ruta", value: "Entrega en Ruta" },
      { label: "Entrega Exitosa", value: "Entrega Exitosa" },
      { label: "Pedido facturado", value: "Pedido facturado" },
      { label: "Otra", value: "Other" },//GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
      
    ];
  }
  get recordOption() {
    return [
      { label: "10", value: "10" },
      { label: "20", value: "20" },
      { label: "50", value: "50" },
      { label: "100", value: "100" }
    ];
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
  connectedCallback() {
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, "0");
    var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
    var yyyy = today.getFullYear();
    this.endDate = yyyy + "-" + mm + "-" + dd;
    this.todayDate = yyyy + "-" + mm + "-" + dd;
    this.currentFiscalYear = today.getFullYear();
    //this.startDate = this.currentFiscalYear + "-01-01";
    this.startDate = this.currentFiscalYear + "-" + mm + "-01";
    this.fiscalyearStartDate = Number(this.currentFiscalYear) - 1 + "-01-01";
    this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
      console.log('User Language ==> ',this.language);
      //Added by Akhilesh  w.r.t Mobile resposiveness
      console.log('The device form factor is: ' + FORM_FACTOR);
      if(FORM_FACTOR == 'Large'){
          this.isMobile = false;
      }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
          this.isMobile = true;
      }
  }
  renderedCallback() {
    this.template.querySelectorAll(".testcss").forEach((but) => {
      but.style.backgroundColor =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "#F47920" : "white";
      but.style.color =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "white" : "black";
    });
    //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
    var list = this.template.querySelector(".statusClass");
    if(list){
      var children = list.children;
      var lastChild = children.length - 1;
      children[lastChild].classList.remove('border-btm');
    }
  }
  @wire(getSalesOrderRecord, {
    searchKey: "$searchKey",
    datefilter: "$datevalue",
    pageNumber: "$pagenumber",
    pageSize: "$pagesize",
    startDate: "$startDate",
    endDate: "$endDate",
    orderStatus: "$orderStatus",
    distributorId: "$distributorId",
  })
  getSalesOrderRecord(result) {
    if (result.data) {
      this.salesOrderList = result.data.salesWrapList;
      console.log("salesOrderList+++++ ", result.data.salesWrapList);
      this.totalrecords = result.data.totalRecords;
      this.isInternalUser = result.data.isInternalUser; //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
      this.recordstart = result.data.RecordStart;
      this.recordend = result.data.RecordEnd;
      this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
      this.generatePageList(this.pagenumber, this.totalpages);
      this.isLoading = false;
      if (this.salesOrderList.length == 0) {
        this.nodata = true;
      } else {
        this.nodata = false;
        var portalUrl= (window.location.href).split('/s/')[0];
        console.log('url ----->',portalUrl);
         if(portalUrl.includes('uplpartnerportalstd')){
          this.generateFileURl("/uplpartnerportalstd/apex/Grz_SalesOrderChilePDF?searchKey=","/uplpartnerportalstd/apex/Grz_SalesOrderChileXLS?searchKey=");
        }else{
          this.generateFileURl("/uplpartnerportal/apex/Grz_SalesOrderChilePDF?searchKey=","/uplpartnerportal/apex/Grz_SalesOrderChileXLS?searchKey=");
        }
      }
    } else if (result.error) {
      this.nodata = true;
      this.error = result.error;
      console.log("---error----", this.error);
    }
  }
  handleViewClick(event) {
    this.lineItems = [];
    var lineItemId = event.currentTarget.dataset.value;
    console.log(lineItemId);
    getLineItems({
      lineItemId: lineItemId,
    }).then((result) => {
      console.log(result);
      //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
      if(result.deliveryInfoPresent){
        this.lineItems = result.lineItemWrapper;
        this.noInfo = false;
      }else{
        this.noInfo = true;
      }
    });
    this.isModalOpen = true;
  }
  onChangeAccount(event){
    const abc = event.detail;
    if(abc.recordId != undefined){
      this.distributorId = abc.recordId;
    }else{
      this.distributorId = 'All';
      this.pagenumber = 1;
    }
    this.isLoading = true;
  }
  handleRecordPerPage(event) {
    this.pagesize = parseInt(event.detail.value);
    this.pagesizeStr = event.detail.value;
    this.isLoading = true;
    this.pagenumber = 1;
  }
  startDateChange(event) {
    this.validStartDate = event.target.value;
    var isInvalid = false;
    if (
      this.validStartDate < this.fiscalyearStartDate ||
      this.validStartDate > this.fiscalyearEndDate
    ) {
      this.tostMessage("Por favor introduzca una fecha valida", "error");
      isInvalid = true;
    } else if (this.validStartDate > this.validEndDate) {
      this.tostMessage(
        "La fecha de inicio no puede ser posterior a la fecha de finalización",
        "error"
      );
      isInvalid = true;
    } else if (this.validStartDate > this.todayDate) {
      this.tostMessage(
        "La fecha de inicio y la fecha de finalización deben ser inferiores a las de hoy.",
        "error"
      );
      isInvalid = true;
    }
    if (!isInvalid && this.validStartDate != this.startDate) {
      this.startDate = this.validStartDate;
      this.isLoading = true;
      this.pagenumber = 1;
    } else {
      event.target.value = this.startDate;
    }
  }
  endDateChange(event) {
    this.validEndDate = event.target.value;
    var isInvalid = false;
    if (
      this.validEndDate < this.fiscalyearStartDate ||
      this.validEndDate > this.fiscalyearEndDate
    ) {
      this.tostMessage("Por favor introduzca una fecha valida", "error");
      isInvalid = true;
    } else if (this.validEndDate > this.todayDate) {
      this.tostMessage(
        "La fecha de inicio y la fecha de finalización deben ser inferiores a las de hoy.",
        "error"
      );
      isInvalid = true;
    } else if (this.validEndDate < this.validStartDate) {
      this.tostMessage(
        "La fecha de finalización no puede ser anterior a la fecha de inicio",
        "error"
      );
      isInvalid = true;
    }
    if (!isInvalid && this.endDate != this.validEndDate) {
      this.endDate = this.validEndDate;
      this.isLoading = true;
      this.pagenumber = 1;
    } else {
      event.target.value = this.endDate;
    }
  }
  handleChangeDate(event) {
    this.isLoading = true;
    this.datevalue = event.detail.value;
    this.pagenumber = 1;
  }
  handleOrderStatus(event) {
    this.isLoading = true;
    this.orderStatus = event.detail.value;
    this.pagenumber = 1;
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
  clearClick() {
    this.isLoading = true;
    this.searchKey = "";
  }
  handleOrderDetail(event) {
    this.recordId = event.currentTarget.dataset.value;
    this.detailPageLink = "sales-order/" + this.recordId;
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
  handleFirst() {
    this.isLoading = true;
    var pagenumber = 1;
    this.pagenumber = pagenumber;
  }
  processMe(event) {
    var checkpage = this.pagenumber;
    this.pagenumber = parseInt(event.target.name);
    if (this.pagenumber != checkpage) {
      this.isLoading = true;
    }
    this.scrollToTop();
  }
  handlePrevious() {
    this.isLoading = true;
    this.pagenumber--;
    this.scrollToTop();
  }
  handleNext() {
    this.isLoading = true;
    this.pagenumber = this.pagenumber + 1;
    this.scrollToTop();
  }
  handleLast() {
    this.isLoading = true;
    this.pagenumber = this.totalpages;
    this.scrollToTop();
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
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
  SalesOrderXLS() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
  scrollToTop() {
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth",
    };
    window.scrollTo(scrollOptions);
  }
  tostMessage(msg, type) {
    const event = new ShowToastEvent({
      title: msg,
      variant: type,
    });
    this.dispatchEvent(event);
  }
  closeModal() {
    this.isModalOpen = false;
  }
  generateFileURl(vfPDF, vfXLS) {
    this.SalesOrderpdfURL =
      vfPDF +
      this.searchKey +
      "&datefilter=" +
      this.datevalue +
      "&pageNumber=" +
      this.pagenumber +
      "&pageSize=" +
      this.pagesize+
      "&startDate=" +
      this.startDate +
      "&endDate=" +
      this.endDate +
      "&orderStatus=" +
      this.orderStatus +
      "&distributorId=" +
      this.distributorId;
      

    this.SalesOrderxlsURL =
      vfXLS +
      this.searchKey +
      "&datefilter=" +
      this.datevalue +
      "&pageNumber=" +
      this.pagenumber +
      "&pageSize=" +
      this.pagesize+
      "&startDate=" +
      this.startDate +
      "&endDate=" +
      this.endDate +
      "&orderStatus=" +
      this.orderStatus +
      "&distributorId=" +
      this.distributorId;
  }

  //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
  GetEmailAsPDF(){
    this.callEmail(this.SalesOrderpdfURL, 'pdf');
  }
  GetEmailAsXLS(){
    this.callEmail(this.SalesOrderxlsURL, 'xls');
  }
  callEmail(fileUrl,filetype){
    this.isSpinner = true;
    SendEMail({ 
      Url : fileUrl, 
      fileType : filetype,
      fileName : 'Pedidos de Venda',
      subjectName : 'Pedidos de Venda',
    });
    setTimeout(() => {
      this.isSpinner = false;
      this.tostMessage("Archivo adjunto enviado por correo electrónico.", "success");
    }, 3000);
  }
}