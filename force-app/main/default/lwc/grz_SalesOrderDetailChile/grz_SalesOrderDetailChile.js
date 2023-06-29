import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getProductDetailList from "@salesforce/apex/Grz_SalesOrderDetailChile.getProductDetailList";
import getPDF from "@salesforce/apex/Grz_SalesOrderDetailChile.getPDF";
import getPoDocument from "@salesforce/apex/Grz_SalesOrderDetailChile.getPoDocument";
import getLineItems from "@salesforce/apex/Grz_SalesOrderListChile.getLineItems";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import FORM_FACTOR from '@salesforce/client/formFactor';//Added by Akhilesh w.r.t Mobile UI

export default class Grz_SalesOrderDetailChile extends LightningElement {
  @track billingid;
  wiredresult;
  @track contentdoc;
  @track detailPageLink;
  @track accid;
  @track contentdocid;
  @track nodata;
  @track noinvoice;
  @track lineitemdata;
  @track isbrazil;
  @track data;
  @track invoicesarray = [];
  @track mapData = [];
  @track error;
  @track customerTaxNumber;
  @api title;
  @track invoicesdata;
  @api designattributeimage;
  @track Billinginvoice;
  @track isModalOpen = false;
  @track noInfo = false;
  @track lineItems;
  @track isSpinner = false;
  currentPageReference = null;
  urlStateParameters = null;
  urlId = null;
  urlLanguage = null;
  urlType = null;
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  ordericon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  ready = false;
  isMobile;
  @track navUrl = '/uplpartnerportal/s/salesordershome';
  @track lineitemColumn=[{label:'Entrega', fieldName: 'Id',  type: 'iconbutton',iconName:'action:following', name:'deliveryDoc', actionName: 'View'},
  {label:'Código del producto', fieldName:'skuCode', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'Nombre del producto', fieldName:'productName', type: 'text', cellAttributes: { alignment: 'left' }},        
  {label:'Estado de entrega', fieldName:'deliveryStatus', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'Cantidad', fieldName:'quantity', type: 'Number', cellAttributes: { alignment: 'left' }},
  {label:'UM', fieldName:'uom', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'Precio unitario', fieldName:'unitPrice', type: 'Number', cellAttributes: { alignment: 'left' }},
  {label:'Valor', fieldName:'totalValue', type: 'Number', cellAttributes: { alignment: 'left' }},
  {label:'DESPACHO PDF', fieldName:'Id', type: 'iconbutton',iconName:"doctype:pdf", name:'pdfDownload', cellAttributes: { alignment: 'left' }}
  ];

  @track invoicesarrayColumn=[{label:'Folio', fieldName:'billingDocNumber', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'Número de entrega', fieldName:'deliveryNumber', type: 'text', cellAttributes: { alignment: 'left' }},
  {label:'Fecha de emisión', fieldName:'billingDate', type: 'text', cellAttributes: { alignment: 'left' }},        
  {label:'Valor Total', fieldName:'totalAmount', type: 'Number', cellAttributes: { alignment: 'left' }},
  {label:'FACTURA PDF', fieldName:'ivId', type: 'iconbutton',iconName:"doctype:pdf", name:'Download', cellAttributes: { alignment: 'left' }}
  ];

  //Added By Akhilesh for Mobile compatibilti
  connectedCallback(){
    //Added by Akhilesh  w.r.t Mobile resposiveness
    console.log('The device form factor is: ' + FORM_FACTOR);
    if(FORM_FACTOR == 'Large'){
        this.isMobile = false;
    }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
        this.isMobile = true;
    }

     //Added by Akhilesh  w.r.t Mobile resposiveness
     let url = window.location.href;
     if(url.includes("uplpartnerportalstd")){
         this.navUrl = '/uplpartnerportalstd/s/salesordershome';
     }
  }

  //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
  renderedCallback() {
    var list = this.template.querySelector(".statusClass");
    if(list){
      var children = list.children;
      var lastChild = children.length - 1;
      children[lastChild].classList.remove('border-btm');
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
      console.log("==OrderDetails==", result);
      this.SFDCOrderNo = result.SFDCOrderNo;
      this.SAPOrderNo = result.SAPOrderNo;
      this.poNumber = result.poNumber;
      this.poDate = result.poDate;
      this.orderTotal = result.orderTotal;
      this.repName = result.repName;
      this.soldToParty = result.soldToParty;
      this.customerTaxNumber = result.customerTaxNumber;
      this.city = result.city;
      this.crncy = result.crncy;
      this.invoicesarray = result.InvoiceDetails;
      if(this.isMobile){
      this.template.querySelector('c-responsive-card').tableData = result.InvoiceDetails;
      this.template.querySelector('c-responsive-card').updateValues();
      }
      this.lineitemdata = result.lineItemList;
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
 /* handleOrderDetail(event) {
    this.recordId = event.currentTarget.dataset.value;
    this.detailPageLink =
      "/uplpartnerportal/s/invoicedetailPage?id=" + this.recordId;
  }*/

  //Added by Akhilesh
  handleOrderDetail(event) { 
    var moburl = (window.location.href).split('/s/')[0];
    if(this.isMobile){
      this.recordId = event.detail;
        //console.log("record id"+recordId);
        this.detailPageLink = "/s/invoicedetailpage?id=" + this.recordId;
        moburl = (window.location.href).split('/s/')[0];
        window.open(moburl+this.detailPageLink);
    }else{
        this.recordId = event.currentTarget.dataset.value;
        if(moburl.includes('uplpartnerportalstd')){
          this.detailPageLink = "/uplpartnerportalstd/s/invoicedetailpage?id=" + this.recordId;
        }else{
          this.detailPageLink = "/uplpartnerportal/s/invoicedetailPage?id=" + this.recordId;
        }
      } 
  }
  handleInvoiceClick(event){
      //Added by Akhilesh for PDF donwload
      this.isSpinner = true;
      let reference;
      if(this.isMobile){
        reference = event.detail.Id;
      }else{
        reference = event.currentTarget.dataset.value;
    }
    this.handlePdfFile('Invoice',reference);
  }
  handleDeliveryClick(event){
    //Added By Akhilesh for PDF Downloading
    this.isSpinner = true;
        let reference;
        if(this.isMobile){
          if(event.detail.actionName == 'deliveryDoc'){
            this.handleViewClick(event);
          }else{
            reference = event.detail.Id;
            this.handlePdfFile('Delivery',reference);
          }
        }else{
            reference = event.currentTarget.dataset.value
            this.handlePdfFile('Delivery',reference);
        }
    
  }
  
  handlePdfFile(type,reference) {
    console.log('type=>',type);
    console.log('reference=>',reference);
    this.isSpinner = true;
    getPDF({
      type: type,
      reference: reference,
      customerTaxNumber: this.customerTaxNumber,
    }).then((result) => {
      console.log('result====> ',result);
      if (result.success) {
        //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
        for(let i=0; i< result.dbWrap.length; i++){
          if(result.dbWrap[i].success){
            const downloadLink = document.createElement("a");
            downloadLink.download = result.dbWrap[i].fileName;
            downloadLink.href = "data:application/pdf;base64," + result.dbWrap[i].fileContent;
            downloadLink.click();
          }else{
            const event = new ShowToastEvent({
              title: "Algo salió mal con algunos archivos. Vuelva a intentarlo más tarde.",//Something went wrong with some files. Try again later.
              variant: "error",
            });
            this.dispatchEvent(event);
          }
        }
      } else {
        const event = new ShowToastEvent({
          title: "Algo salió mal. Vuelve a intentarlo más tarde.",//Something went wrong, please try again later
          variant: "error",
        });
        this.dispatchEvent(event);
      }
      this.isSpinner = false;
    });
  }
  handleViewClick(event) {
    this.lineItems = [];
    var lineItemId;
    this.isSpinner =false;
    if(this.isMobile){
      lineItemId = event.detail.Id;
    }else{
      lineItemId = event.currentTarget.dataset.value;
    }
     
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
  closeModal() {
    this.isModalOpen = false;
  }
  downldPOFile(){
    getPoDocument({
      orderId: this.urlId,
    }).then((result) => {
      if (result.success) {
        var url;
        if( (window.location.href).split('/s/')[0].includes("uplpartnerportalstd")){
            url = "/uplpartnerportalstd/servlet/servlet.FileDownload?file=" +
            result.fileContent;
        }else{
            url = "/uplpartnerportal/servlet/servlet.FileDownload?file=" +
            result.fileContent;
        }
        window.open(url, '_blank');
      } else {
        const event = new ShowToastEvent({
          title: "Algo salió mal. Vuelve a intentarlo más tarde.", //Something went wrong, please try again later
          variant: "error",
        });
        this.dispatchEvent(event);
      }
    });
  }
}