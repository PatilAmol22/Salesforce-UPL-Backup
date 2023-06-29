import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { loadStyle } from "lightning/platformResourceLoader";
import getInvoiceDetailList from "@salesforce/apex/Grz_InvoiceDetailClassChile.getInvoiceDetailList";
import FORM_FACTOR from '@salesforce/client/formFactor'//Added By Akhilesh for Mobile UI compatibilty

export default class Grz_InvoiceDetailChile extends LightningElement {
  
  @api designattributeimage;
  currentPageReference = null;
  urlStateParameters = null;
  urlId = null;
  urlLanguage = null;
  urlType = null;
  @api title;
  wiredresult;
  ready = false;
  salesOrderId = null;
  @track contentdocid;
  @track invoiceLineData;
  @track nodata = false;
  @track pdfUrl;
  @track xmlUrl;
  @track isPdf = false;
  @track isXml = false;
  @track isDwnld = false;
  ordericon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  @track invoiceValue = "0";
  @track EstimatedDelivery = "Entrega Prevista para";
  @track Delivered = "Entregue em";
  @track navUrl = '/uplpartnerportal/s/salesordershome';

  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  get allInvoiceOptions() {
    return [
      { label: "Pedido em Processamento", value: "0" },
      { label: "Pedido Faturado", value: "1" },
      { label: this.EstimatedDelivery, value: "2" },
      { label: this.Delivered, value: "3" }
    ];
  }

  //Added By Akhilesh
  @track invoiceLineColumn=[{label:'Código del producto', fieldName:'skuName', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'Nombre del producto', fieldName:'productName', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'La cantidad', fieldName:'quantity', type: 'Number', cellAttributes: { alignment: 'left' }},        
  {label:'UM', fieldName:'uom', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'Valor', fieldName:'netValue', type: 'Number', cellAttributes: { alignment: 'left' }}
  ];

  connectedCallback() {
   // this.backgroundimage = Icons + this.designattributeimage;
    Promise.all([
      loadStyle(this, Icons + "/Grz_Resourse/CSS/PathIndicator.css")
    ]);
    //Added By Akhilesh
    console.log('The device form factor is: ' + FORM_FACTOR);
    if(FORM_FACTOR == 'Large'){
        this.isMobile =false;
    }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
        this.isMobile =true;
    }//End

    //Added by Akhilesh  w.r.t Mobile resposiveness
    let url = window.location.href;
    if(url.includes("uplpartnerportalstd")){
        this.navUrl = '/uplpartnerportalstd/s/salesordershome';
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
        if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entrega Prevista para")) {
          this.invoiceValue = "2";
          this.invoiceStatus = this.currentInvoiceStatus;
          this.EstimatedDelivery = this.currentInvoiceStatus;
        } else if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entregue em")) {
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
        console.log('this.invoiceLineData-->>',result.invoiceLineItem);
        if (this.invoiceLineData == "") {
          this.nodata = true;
        }
        this.contentdocid = result.contentDocumentId;
        console.log("------content links------", result.contentDocumentId);
        console.log("------content Map------", result.contentMap);
        var conts = result.contentMap;
        for (var key in conts) {
          //this.mapData.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
          if (key == "PDF") {
            this.pdfUrl =
              "/uplpartnerportal/sfc/servlet.shepherd/document/download/" +
              conts[key] +
              "?operationContext=S1";
            this.isPdf = true;
            //this.isDwnld = true;
          }
          if (key == "XML") {
            this.xmlUrl =
              "/uplpartnerportal/sfc/servlet.shepherd/document/download/" +
              conts[key] +
              "?operationContext=S1";
            this.isXml = true;
            //this.isDwnld = true;
          }
        }
        this.error = undefined;
      })
      .catch((error) => {
        console.log("----in error----" + JSON.stringify(error));
        this.error = error;
      });
  }
  downloadAttachment() {
    if (this.pdfUrl != null) {
      this.downloadInvoicePdf();
    }
    setTimeout(() => {
      if (this.xmlUrl != null) {
        this.downloadInvoiceXml();
      }
    }, 3000);
  }
  downloadInvoicePdf() {
    console.log("----PDF----" + this.pdfUrl);
    window.location.href = this.pdfUrl;
  }
  downloadInvoiceXml() {
    console.log("----XML----" + this.xmlUrl);
    window.location.href = this.xmlUrl;
  }
}