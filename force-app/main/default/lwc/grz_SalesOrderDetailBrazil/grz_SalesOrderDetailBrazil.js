import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getProductDetailList from "@salesforce/apex/Grz_ProductDetailClassBrazil.getProductDetailList";
import getFiles from "@salesforce/apex/Grz_ProductDetailClassBrazil.getFiles";
export default class Grz_SalesOrderDetailBrazil extends LightningElement {
  currentPageReference = null;
  urlStateParameters = null;
  urlId = null;
  @track detailPageLink;
  @track accid;
  @track nodata;
  @track noinvoice;
  @track lineitemdata;
  @track data;
  @track invoicesarray = [];
  @track error;
  @track isSpinner = false;
  @api title;
  @track invoicesdata;
  @api designattributeimage;
  @track soUrl;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @api backgroundimage = null;
  @track desktopTracker = false; mobileTracker = false;

  @track invoiceValue = "0";
  @track EstimatedDelivery = "Entrega prevista para";
  @track PartiallyDelivery = "Entregue parcial em";//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track Delivered = "Entregue em";

  ordericon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  acked = Icons + "/Grz_Resourse/Images/greyack.svg";
  notacked = Icons + "/Grz_Resourse/Images/Orangeack.svg";
  ready = false;
  get allInvoiceOptions() {
    return [
      { label: "Pedido em Processamento", value: "0" },
      { label: "Pedido Faturado", value: "1" },
      { label: this.EstimatedDelivery, value: "2" },
      { label: this.PartiallyDelivery, value: "3" },//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      { label: this.Delivered, value: "4" },
    ];
  }
  connectedCallback() {
    this.backgroundimage = Icons + this.designattributeimage;
    Promise.all([
      loadStyle(this, Icons + "/Grz_Resourse/CSS/PathIndicator.css"),
    ]);
    if (document.body.offsetWidth <= 767){
      this.mobileTracker = true;
      this.desktopTracker = false;
    }else{
      this.desktopTracker = true;
      this.mobileTracker = false;
    }
  }
  renderedCallback(){
    var list = this.template.querySelector(".progress");
    if(list){
      var children = list.children;
      var completed = parseInt(this.invoiceValue) * 2;
      var lastChild = children.length - 1;
      children[lastChild].classList.add('disNone');
      for (var i = 0; i <= completed; i++) {
          children[i].children[0].classList.remove('grey');
          children[i].children[0].classList.add('green');
      }
    }
  }

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference) {
      var urlParameters = window.location.href;
      this.urlStateParameters = urlParameters.split("sales-order/");
      var urlIDValue = this.urlStateParameters[1] || null;
      urlIDValue = urlIDValue.split("/");
      this.urlId = urlIDValue[0];
      this.doSearch();
    }
  }
  doSearch() {
    getProductDetailList({ urlapex: this.urlId }).then((result) => {
      this.currentInvoiceStatus = result.invoiceStatus;
      this.soUrl = '/uplpartnerportal/apex/Grz_SalesOrderPDF?Id=' + this.urlId;
      //Stsrt------Logic update----GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      if (this.currentInvoiceStatus == "Pedido em Análise" || this.currentInvoiceStatus == "Crédito Bloqueado" || this.currentInvoiceStatus == "Crédito Liberado" ){
        this.invoiceValue = "0";
      } else if (this.currentInvoiceStatus == "Faturado" || this.currentInvoiceStatus == "Faturado Parcial") {
        this.invoiceValue = "1";
      } else if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entrega prevista")) {
        this.invoiceValue = "2";
        this.EstimatedDelivery = this.currentInvoiceStatus;
      } else if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entregue parcial")) {
        this.invoiceValue = "3";
        this.PartiallyDelivery = this.currentInvoiceStatus;
      } else if (this.currentInvoiceStatus && (this.currentInvoiceStatus.includes("Entregue em") || this.currentInvoiceStatus == 'Entregue')) {
        this.invoiceValue = "4";
        this.Delivered = this.currentInvoiceStatus;
      }
      //---------End----//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      this.orderType = result.orderType;
      this.orderDate = result.orderDate;
      this.orderStatus = result.orderStatus;
      this.orderTotal = result.orderTotal;
      this.SAPOrderNo = result.SAPOrderNo;
      this.SFDCOrderNo = result.SFDCOrderNo;
      this.repName = result.repName;
      this.soldToParty = result.soldToParty;
      this.city = result.city;
      this.crncy = result.crncy;
      this.paymentTerm = result.paymentTerm;
      this.invoicesarray = result.InvoiceDetails;
      this.lineitemdata = result.lineItemList;
      if (this.lineitemdata == "") {
        this.nodata = true;
      }
      if (this.invoicesarray == "") {
        this.noinvoice = true;
      }
    });
  }
  handleOrderDetail(event) {
    this.recordId = event.currentTarget.dataset.value;
    this.detailPageLink =
      "/uplpartnerportal/s/invoicedetailPage?id=" + this.recordId;
  }

  downldFilePdf(event) {
    let invoiceId = event.currentTarget.dataset.value;
    this.handleFiles(invoiceId, 'PDF');
  }
  downldFileXml(event) {
    let invoiceId = event.currentTarget.dataset.value;
    this.handleFiles(invoiceId, 'XML');
  }

  handleFiles(invoiceId, fileType) {
    this.isSpinner = true;
    getFiles({
      invoiceId: invoiceId,
      fileType: fileType,
    }).then((result) => {
      if (result.success) {
        window.location.href =
          "/uplpartnerportal/sfc/servlet.shepherd/document/download/" +
          result.contentId +
          "?operationContext=S1";
      } else {
        const event = new ShowToastEvent({
          title: "Algo deu errado, tente novamente mais tarde", //Something went wrong, please try again later
          variant: "error",
        });
        this.dispatchEvent(event);
      }
      this.isSpinner = false;
    });
  }
}