import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getInvoiceDetailList from "@salesforce/apex/Grz_InvoiceDetailClassMexico.getInvoiceDetailList";
import getMexicoInvoicePDF from "@salesforce/apex/Grz_InvoiceDeliveryInfoMexico.getMexicoInvoicePDF";
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class Grz_InvoiceDetailMexico extends LightningElement {
  @api backgroundimage1 = null;
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
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
  @track isSpinner = false;
  @track invoiceBase64Response = '';
  @track pdfname;
  ordericon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  @track invoiceValue = "0";
  @track EstimatedDelivery = "Entrega Prevista para";
  @track Delivered = "Entregue em";
  @track navUrl = '/uplpartnerportal/s/salesordershome';

  get allInvoiceOptions() {
    return [
      { label: "Pedido em Processamento", value: "0" },
      { label: "Pedido Faturado", value: "1" },
      { label: this.EstimatedDelivery, value: "2" },
      { label: this.Delivered, value: "3" }
    ];
  }
  //Added by Vaishnavi for Mobile APP
  isMobile;
  showInvoice = false;
  @track invoiceColumn = [
    { label: 'Código de producto', fieldName: 'skuName', type: 'text'  },
    { label: 'Nombre del producto', fieldName: 'productName', type: 'text'  },
    { label: 'Cantidad', fieldName: 'quantity', type: 'Number'  },
    { label: 'Precio unitario', fieldName: 'unitPrice', type: 'number'  },
    { label: 'Valor', fieldName: 'netValue', type: 'Number'  }
    
  ];
  connectedCallback() {
    //this.backgroundimage1 = Icons + this.designattributeimage;
    //console.log('this.backgroundimage1 : ',this.backgroundimage1);
   
    if(!window.location.href.includes('uplpartnerportalstd')){
      Promise.all([
        loadStyle(this, Icons + "/Grz_Resourse/CSS/PathIndicator.css")
      ]);
    }else{
       //added by Vaishnavi w.r.t Mobile UI
       console.log('The device form factor is: ' + FORM_FACTOR);
       if(FORM_FACTOR == 'Large'){
           this.isMobile = true;
       }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
           this.isMobile = true;
       }
       console.log('this.isMobile ' + this.isMobile);
         //Added by Akhilesh  w.r.t Mobile resposiveness
    
   }
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
        console.log('Invoice result : ',result);
        this.currentInvoiceStatus = result.invoiceStatus;
        /*if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entrega Prevista para")) {
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
        }*/
        this.invoiceStatus = this.currentInvoiceStatus;
        this.InvoiceName = result.InvoiceName;
        this.billNumber = result.billNumber;
        this.soldToParty = result.soldToParty;
        this.totalValue = result.totalValue;
        this.billDate = result.billDate;
        this.salesOrderId = "sales-order/" + result.salesOrderId;
        /*var strbase64 = 'data:application/pdf;base64,';
        if(result.invoicePDF){
            this.isPdf = true;
            this.pdfname = this.billNumber+'.pdf';
            this.invoiceBase64Response = strbase64+result.invoicePDF;
        }else{
          this.isPdf = false;
        }*/
        this.invoiceLineData = result.invoiceLineItem;
        if(this.invoiceLineData.length >0 ){
          this.showInvoice = true;
        }
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


  handledownloadInvoice(event){
    this.isSpinner = true;
    this.Billinginvoice = event.currentTarget.dataset.value;
    console.log('this.Billinginvoice : ',this.Billinginvoice);
    const downloadLink = document.createElement("a");
    getMexicoInvoicePDF({billingDocNumber: this.Billinginvoice}).then((result) => {
      console.log('getMexicoInvoicePDF==>',result);
      if(!result.isSuccess){
        this.isSpinner = false;
        return this.dispatchEvent(
          new ShowToastEvent({
            title: "Error en la descarga de PDF",
            message: "Informacion no disponible",
            variant: "error",
            mode: "dismissable"
          })
        );
      }
      var str;
      if(result.isSuccess){
        str = 'data:application/pdf;base64,';
        var Base64 = result.item[0].Base64;
        console.log('getMexicoInvoice Base64 ==>',Base64);
        this.invoicePDFBase64 = str+Base64;
        this.invoicePDFName = this.Billinginvoice+'.pdf';
        downloadLink.href = this.invoicePDFBase64;
        downloadLink.download = this.invoicePDFName;
        downloadLink.click();
        this.invoicePDFBase64 = "";
        this.invoicePDFName = "";
      }else{
        this.isSpinner = false;
      }
        this.isSpinner = false;
    })
    .catch(error => {
      this.isSpinner = false;
      console.log('Error in SaleOrder Invoice Download : ',error);
  });

  }
}