import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { loadStyle } from "lightning/platformResourceLoader";
import getInvoiceDetailList from "@salesforce/apex/Grz_InvoiceDetailClassBrazil.getInvoiceDetailList";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getFiles from "@salesforce/apex/Grz_ProductDetailClassBrazil.getFiles";

export default class Grz_InvoiceDetailBrazil extends LightningElement {
  @api backgroundimage = null;
  @api designattributeimage;
  currentPageReference = null;
  urlStateParameters = null;
  urlId = null;
  urlLanguage = null;
  urlType = null;
  @api title;
  @track isSpinner = false;
  wiredresult;
  ready = false;
  salesOrderId = null;
  @track invoiceLineData;
  @track nodata = false;
  ordericon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  @track invoiceValue = "0";
  @track EstimatedDelivery = "Entrega Prevista para";
  @track Delivered = "Entregue em";
  @track desktopTracker = false; mobileTracker = false;
  get allInvoiceOptions() {
    return [
      { label: "Pedido em Processamento", value: "0" },
      { label: "Pedido Faturado", value: "1" },
      { label: this.EstimatedDelivery, value: "2" },
      { label: this.Delivered, value: "3" }
    ];
  }

  connectedCallback() {
    this.backgroundimage = Icons + this.designattributeimage;
    Promise.all([
      loadStyle(this, Icons + "/Grz_Resourse/CSS/PathIndicator.css")
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
      this.urlStateParameters = currentPageReference.state;
      this.urlId = this.urlStateParameters.id || null;
      this.doSearch();
    }
  }
  doSearch() {
    getInvoiceDetailList({ urlapex: this.urlId })
      .then((result) => {
        this.currentInvoiceStatus = result.invoiceStatus;
        if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entrega Prevista")) {
          this.invoiceValue = "2";
          this.invoiceStatus = this.currentInvoiceStatus;
          this.EstimatedDelivery = this.currentInvoiceStatus;
        } else if (this.currentInvoiceStatus && (this.currentInvoiceStatus.includes("Entregue em") || this.currentInvoiceStatus == 'Entregue')) {//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
          this.invoiceValue = "3";
          this.Delivered = this.currentInvoiceStatus;
          this.invoiceStatus = this.currentInvoiceStatus;
        }else if (this.currentInvoiceStatus == "NF Emitida") {
          this.invoiceValue = "1";
          this.invoiceStatus = "Pedido Faturado";
        } 
        else{
          this.invoiceValue = "0";
          this.invoiceStatus = "Pedido em Processamento";
        }
        this.InvoiceName = result.InvoiceName;
        this.billNumber = result.billNumber;
        this.soldToParty = result.soldToParty;
        this.totalValue = result.totalValue;
        this.billDate = result.billDate;
        this.salesOrderId = "sales-order/" + result.salesOrderId;
        this.invoiceLineData = result.invoiceLineItem;
        if (this.invoiceLineData == "") {
          this.nodata = true;
        }
        this.error = undefined;
      })
      .catch((error) => {
        console.log("----in error----" + JSON.stringify(error));
        this.error = error;
      });
  }
  downldFilePdf() {
    this.handleFiles(this.urlId, 'PDF');
  }
  downldFileXml() {
    this.handleFiles(this.urlId, 'XML');
  }
  handleFiles(invoiceId, fileType) {
    this.isSpinner = true;
    getFiles({
      invoiceId: invoiceId,
      fileType: fileType,
    }).then((result) => {
      console.log("dataTest=>", result);
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