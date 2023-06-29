import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getProductDetailList from "@salesforce/apex/Grz_SalesOrderDetailMexico.getProductDetailList";
import getInvoiceInfo from "@salesforce/apex/Grz_InvoiceDeliveryInfoMexico.getInvoiceDelivery";
import getMexicoInvoicePDF from "@salesforce/apex/Grz_InvoiceDeliveryInfoMexico.getMexicoInvoicePDF";
import FORM_FACTOR from '@salesforce/client/formFactor';


export default class Grz_SalesOrderDetailMexico extends LightningElement {
  @track billingid;
  wiredresult;
  @track contentdoc;
  @track detailPageLink;
  @track accid;
  @track contentdocid;
  @track btnLabel = "Acknowledge";
  @track nodata;
  @track noinvoice;
  @track lineitemdata;
  @track isbrazil;
  @track data;
  @track invoicesarray = [];
  @track mapData = [];
  @track error;
  @track isSpinner = false;
  @api title;
  @track invoicesdata;
  @api designattributeimage;
  @track acknowledgement = false;
  @track Billinginvoice;
  @track invoiceBase64Response;
  @track invoicePDFBase64;
  @track invoicePDFName;
  @track invoiceCargoStatus;
  @track deliveryDate;
  @track invoiceId;
  @track noInfo = false;
  @track isModalOpen = false;
  PONumber;
  invoiceName;
  currentPageReference = null;
  urlStateParameters = null;
  urlId = null;
  urlLanguage = null;
  urlType = null;
  @track AllInvoiceFile;
  @api backgroundimage = null;
  @track invoiceValue = "0";
  @track EstimatedDelivery = "Entrega prevista para";
  @track Delivered = "Entregue em";
  //Added by Vaishnavi for Mobile APP
  isMobile;
  @track navUrl = '/uplpartnerportal/s/salesordershome';

  @track productColumn = [
    { label: 'Código de Producto', fieldName: 'skuCode', type: 'text'  },
    { label: 'Nombre del Producto', fieldName: 'productName', type: 'text'  },
    { label: 'Cantidad', fieldName: 'quantity', type: 'Number'  },
    { label: 'Precio Unitario', fieldName: 'unitPrice', type: 'Number'  },
    { label: 'Valor', fieldName: 'totalValue', type: 'Number'  },
    { label: 'Estado', fieldName: 'status', type: 'text'  },
    { label: 'Número de Entrega', fieldName: 'deliveryNumber', type: 'number'  },
    { label: 'Información de Entrega', fieldName: 'deliveryNumber',  type: 'iconbutton',iconName:"action:following", name:'Download'  }
];
@track invoiceColumn = [
  { label: 'Factura', fieldName: 'billingDocNumber', type: 'text'  },
  { label: 'Fecha de asunto', fieldName: 'billingDate', type: 'text'  },
  { label: 'Monto', fieldName: 'totalAmount', type: 'number'  },
  { label: 'Descargar PDF', fieldName: 'billingDocNumber', type: 'iconbutton',iconName:"doctype:pdf", name:'Download'  }
  
];
showInvoice =false;
  ordericon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  acked = Icons + "/Grz_Resourse/Images/greyack.svg";
  notacked = Icons + "/Grz_Resourse/Images/Orangeack.svg";
  ready = false;
  get allInvoiceOptions() {
    return [
      { label: "Pedido em Processamento", value: "0" },
      { label: "Pedido Faturado", value: "1" },
      //{ label: "Pedido Faturado Parcialmente", value: "2" },
      { label: this.EstimatedDelivery, value: "2" },
      { label: this.Delivered, value: "3" }
    ];
  }
  connectedCallback() {
     
    this.backgroundimage = Icons + this.designattributeimage;
    if(!window.location.href.includes('uplpartnerportalstd')){
       Promise.all([loadStyle(this, Icons + "/Grz_Resourse/CSS/PathIndicator.css")]);
    }else{
        //added by Vaishnavi w.r.t Mobile UI
        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile = false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile = true;
        }
        console.log('this.isMobile ' + this.isMobile);
    }
      //Added by Akhilesh  w.r.t Mobile resposiveness
      let url = window.location.href;
      if(url.includes("uplpartnerportalstd")){
          this.navUrl = '/uplpartnerportalstd/s/salesordershome';
      }
  }

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference) {
      var urlParameters = window.location.href;
      this.urlStateParameters = urlParameters.split('sales-order/');
      var urlIDValue = this.urlStateParameters[1] || null;
      urlIDValue = urlIDValue.split('/');
      this.urlId = urlIDValue[0];
      console.log('---this.urlId--', this.urlId);
      this.doSearch();
    }
  }
  doSearch() {
    getProductDetailList({ urlapex: this.urlId }).then((result) => {
      console.log("====", result);
      this.currentInvoiceStatus = result.invoiceStatus;
      if (
        this.currentInvoiceStatus == "Pedido em Análise" ||
        this.currentInvoiceStatus == "Crédito Bloqueado" ||
        this.currentInvoiceStatus == "Crédito Liberado"
      ) {
        this.invoiceValue = "0";
        //this.invoiceStatus = "Pedido em Processamento";
      } else if (this.currentInvoiceStatus == "Faturado") {
        this.invoiceValue = "1";
        //this.invoiceStatus = "Pedido Faturado";
      } else if (this.currentInvoiceStatus == "Faturado Parcial") {
        this.invoiceValue = "1";
        //this.invoiceStatus = "Pedido Faturado Parcialmente";
      } else if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entrega prevista para")) {
        this.invoiceValue = "2";
        this.EstimatedDelivery = this.currentInvoiceStatus;
        //this.invoiceStatus = this.currentInvoiceStatus;
      } else if (this.currentInvoiceStatus && this.currentInvoiceStatus.includes("Entregue em")) {
        this.invoiceValue = "3";
        this.Delivered = this.currentInvoiceStatus;
        //this.invoiceStatus = this.currentInvoiceStatus;
      } else {
        //this.invoiceStatus = this.currentInvoiceStatus;
      }
      console.log("====", this.allInvoiceOptions);
      this.orderType = result.orderType;
      this.orderDate = result.orderDate;
      this.orderStatus = result.orderStatus;
      this.orderTotal = result.orderTotal;
      this.SAPOrderNo = result.SAPOrderNo;
      this.SFDCOrderNo = result.SFDCOrderNo;
      this.PONumber = result.PONumber;
      this.repName = result.repName;
      this.soldToParty = result.soldToParty;
      this.city = result.city;
      this.crncy = result.crncy;
      this.paymentTerm = result.paymentTerm;
      this.invoicesarray = result.InvoiceDetails;
      if(this.invoicesarray.length > 0){
        this.showInvoice = true;
      }
      this.lineitemdata = result.lineItemList;
      this.AllInvoiceFile = result.contentDocumentIds;
      console.log("=====Invoice=====", result.InvoiceDetails);
      console.log("=====Line Item=====", result.lineItemList);
      if (this.lineitemdata == "") {
        this.nodata = true;
      }
      if (this.invoicesarray == "") {
        this.noinvoice = true;
      }
    });
  }
  downldFilePdf(event) {
    this.pdfUrl = null;
    this.invoiceId = event.target.dataset.value;
           //= this.invoicePDF;
    /*var abc = this.AllInvoiceFile;
    for (var key in abc) {
      if (key == this.invoiceId) {
        var conts = abc[key];
        for (var key in conts) {
          //this.mapData.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
          if (key == "PDF") {
            this.pdfUrl =
              "/uplpartnerportal/sfc/servlet.shepherd/document/download/" +
              conts[key] +
              "?operationContext=S1";
          }
        }
      } else {
        const event = new ShowToastEvent({
          title: "Nenhum anexo disponível",
          variant: "error"
        });
        this.dispatchEvent(event);
      }
    }
    if (this.pdfUrl != null) {
      this.downloadInvoicePdf();
    }*/
  }
  handleViewClick(event) {
    this.xmlUrl = null;
    this.isSpinner = true;
    //this.invoiceId = event.target.dataset.value;
    if(this.isMobile){
      this.invoiceId = event.detail.Id;
    }else{
        this.invoiceId = event.currentTarget.dataset.value;
      }
    if(this.invoiceId){
        this.isSpinner = true;
        //this.invoiceName = this.invoiceId+'.pdf';
    }else{
      this.isSpinner = false;
      return this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message: "Número de entrega no disponible",
          variant: "error",
          mode: "dismissable"
        })
      );
    }
    console.log('this.invoiceId : '+ this.invoiceId);
    getInvoiceInfo({deliveryNumber: this.invoiceId}).then((result) => {
      console.log('getArAndLedgerData result==>',result);
      var str;
      if(result.isSuccess){
        this.noInfo = false;
        if(result.DataRemission.Extension == 'pdf'){
          str = 'data:application/pdf;base64,';
          this.invoiceName = this.invoiceId+'.pdf';
        }
        else if(result.DataRemission.Extension == 'gif'){
          str = 'data:image/gif;base64,';
          this.invoiceName = this.invoiceId+'.gif';
        }
        else if(result.DataRemission.Extension == 'jpeg'){
          str = 'data:image/jpeg;base64,';
          this.invoiceName = this.invoiceId+'.jpeg';
        }
        else{
          str = 'data:image/png;base64,';
          this.invoiceName = this.invoiceId+'.png';
        }
        if(result.DataRemission.FileBase64){
          this.invoiceBase64Response = str+result.DataRemission.FileBase64;
        }    
        this.invoiceCargoStatus = result.DataRemission.Status;
        this.deliveryDate = result.DataRemission.DateDelivery;
      }else{
        this.noInfo = true;
      }
  
      console.log('this.invoiceCargoStatus==>',this.invoiceCargoStatus);
      this.isSpinner = false;
      this.isModalOpen = true;
    })
    .catch(error => {
      this.isSpinner = false;
      console.log('error in SaleOrderLineItem Delivery Status : ',error);
  });
    /*var abc = this.AllInvoiceFile;
    for (var key in abc) {
      if (key == this.invoiceId) {
        var conts = abc[key];
        for (var key in conts) {
          //this.mapData.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
          if (key == "XML") {
            this.xmlUrl =
              "/uplpartnerportal/sfc/servlet.shepherd/document/download/" +
              conts[key] +
              "?operationContext=S1";
          }
        }
      } else {
        const event = new ShowToastEvent({
          title: "Nenhum anexo disponível",
          variant: "error"
        });
        this.dispatchEvent(event);
      }
    }
    if (this.xmlUrl != null) {
      this.downloadInvoiceXml();
    }*/
  }
  closeModal() {
    this.isModalOpen = false;
  }
  downloadInvoicePdf() {
    console.log("----PDF----" + this.pdfUrl);
    window.location.href = this.pdfUrl;
  }
  downloadInvoiceXml() {
    console.log("----XML----" + this.xmlUrl);
    window.location.href = this.xmlUrl;
  }
  handleOrderDetail(event) {
    
    var moburl = (window.location.href).split('/s/')[0];
    if(moburl.includes("uplpartnerportalstd")){
      this.recordId = event.detail;
        //console.log("record id"+recordId);
        this.detailPageLink = "/s/invoicedetailpage?id=" + this.recordId;
        moburl = (window.location.href).split('/s/')[0];
        window.open(moburl+this.detailPageLink);
    }else{
        this.recordId = event.currentTarget.dataset.value;
        this.detailPageLink = "/uplpartnerportal/s/invoicedetailPage?id=" + this.recordId;
      } 
  }
  handledownloadInvoice(event){
    this.isSpinner = true;
    if(this.isMobile){
      this.Billinginvoice = event.detail.Id;
    }else{
      this.Billinginvoice = event.currentTarget.dataset.value;
  }
  
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
        this.noInfo = false;
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
        this.noInfo = true;
      }
        this.isSpinner = false;
    })
    .catch(error => {
      this.isSpinner = false;
      console.log('Error in SaleOrder Invoice Download : ',error);
  });

  }
}