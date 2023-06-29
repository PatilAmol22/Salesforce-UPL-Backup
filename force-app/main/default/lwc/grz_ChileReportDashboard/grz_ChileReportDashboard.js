import { LightningElement, track, wire, api } from "lwc";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getSalesOrder from "@salesforce/apex/Grz_ChileReportController.getSalesOrder";
import getPoDocument from "@salesforce/apex/Grz_SalesOrderDetailChile.getPoDocument";
import getPDF from "@salesforce/apex/Grz_SalesOrderDetailChile.getPDF";
import FORM_FACTOR from '@salesforce/client/formFactor'//Added By Akhilesh for Mobile UI compatibilty

export default class Grz_ChileReportDashboard extends LightningElement {
    @track poTabel = true;
    @track deliveryTabel = false;
    @track invoiceTabel = false;
    @track pagesizeStr = "10";
    @track typeValue = "Sales_Order__c";
    @track orderStatus = "All";
    @track startDate;
    @track endDate;
    @track searchKey = "";
    @track detailPageLink;
    @track pagenumber = 1;
    @track recordstart = 0;
    @track recordend = 0;
    @track totalpages = 1;
    @track totalrecords = 0;
    @track isLoading = false;
    @track currentpagenumber = 1;
    @track pagesize = 10;

    @track fiscalyearStartDate;
    @track fiscalyearEndDate;
    @track isSpinner = false;
    @track validStartDate;
    @track validEndDate;
    @track todayDate;
    @track noInfo = false;
    @track resultList;
    backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
    isMobile;
    @track ClientName;

    get typeOption() {
        return [
            { label: "Orden de compra", value: "Sales_Order__c" },
            { label: "Entrega", value: "Sales_Order_Line_Item__c" },
            { label: "Factura", value: "Invoice__c" },
        ];
    }
    get orderStatusOptions() {
        return [
            { label: "Toda", value: "All" },
            { label: "Pedido en proceso", value: "Pedido en proceso" },
            { label: "Entrega en Ruta", value: "Entrega en Ruta" },
            { label: "Entrega Exitosa", value: "Entrega Exitosa" },
            { label: "Pedido facturado", value: "Pedido facturado" },
            { label: "Otra", value: "Other" }, //<!--GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022-->
        ];
    }

    //Added by Akhilesh for responsive card UI
  @track poTableColumn=[{label:'Pedido', fieldName:'Name', type: 'text', cellAttributes: { alignment: 'left' }},
            {label:'Cliente', fieldName:'Sold_to_Party__r.Name', type: 'chileClient', cellAttributes: { alignment: 'left' }},
            {label:'Creación', fieldName:'CreatedDate', type: 'date-local', cellAttributes: { alignment: 'left' }},        
            {label:'PO Número', fieldName:'Purchase_Order_no__c', type: 'text', cellAttributes: { alignment: 'left' }},
            {label:'PO Fecha', fieldName:'Purchase_Order_Date__c', type: 'date-local', cellAttributes: { alignment: 'left' }},
            {label:'Divisa', fieldName:'CurrencyIsoCode', type: 'text', cellAttributes: { alignment: 'left' }},
            {label:'Monto', fieldName:'Total_Amount__c', type: 'currencyChile', cellAttributes: { alignment: 'left' }},
            {label:'Documento PO', fieldName:'Id', type: 'iconbutton',iconName:"doctype:pdf", name:'Download', cellAttributes: { alignment: 'left' }}
        ];

    @track invoiceTabelColumn=[{label:'Nota Fiscal', fieldName:'Billing_Doc_Number__c', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Número de entrega', fieldName:'Delivery_Number__c', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Cliente', fieldName:'Sold_To_Party__r.Name', type: 'text', cellAttributes: { alignment: 'left' }},        
    {label:'Número de Ref / Chq', fieldName:'Folio__c', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Fecha de emisión', fieldName:'Billing_Date__c', type: 'date-local', cellAttributes: { alignment: 'left' }},
    {label:'Pedido', fieldName:'Sales_Order__r.Name', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'PO Número', fieldName:'Sales_Order__r.Purchase_Order_no__c', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'PO Fecha', fieldName:'Sales_Order__r.Purchase_Order_Date__c', type: 'date-local', cellAttributes: { alignment: 'left' }},
    {label:'Divisa', fieldName:'CurrencyIsoCode', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Valor Total', fieldName:'TotalSalesAmount__c', type: 'currencyChile', cellAttributes: { alignment: 'left' }},
    {label:'FACTURA PDF', fieldName:'Id', type: 'iconbutton',iconName:"doctype:pdf", name:'Download', cellAttributes: { alignment: 'left' }}
    ];

    @track deliveryTabelColumn=[{label:'Pedido', fieldName:'sFDCOrderNumber', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Cliente', fieldName:'clientName', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Producto', fieldName:'productName', type: 'text', cellAttributes: { alignment: 'left' }},        
    {label:'PO Número', fieldName:'purchaseOrderNumber', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'PO Fecha', fieldName:'purchaseOrderDate', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Número de entrega', fieldName:'deliveryNumber', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Fecha del doc', fieldName:'documentDate', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Estado de entrega', fieldName:'orderStatus', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Fecha de entrega', fieldName:'arrivedAt', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Divisa', fieldName:'orderCurrency', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Valor Total', fieldName:'amount', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'Receipt', fieldName:'receipt', type: 'text', cellAttributes: { alignment: 'left' }},
    {label:'DESPACHO PDF', fieldName:'lineItemId', type: 'iconbutton',iconName:"doctype:pdf", name:'Download', cellAttributes: { alignment: 'left' }}
    ];


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
        this.fiscalyearStartDate =
            Number(this.currentFiscalYear) - 1 + "-01-01";
        this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
        //Added By Akhilesh
        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile =false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile =true;
        }//End
    }
    renderedCallback() {
        this.template.querySelectorAll(".testcss").forEach((but) => {
            but.style.backgroundColor =
                this.pagenumber === parseInt(but.dataset.id, 10)
                    ? "#F47920"
                    : "white";
            but.style.color =
                this.pagenumber === parseInt(but.dataset.id, 10)
                    ? "white"
                    : "black";
        });
    }
    @wire(getSalesOrder, {
        searchKey: "$searchKey",
        typeValue: "$typeValue",
        pageNumber: "$pagenumber",
        pageSize: "$pagesize",
        startDate: "$startDate",
        endDate: "$endDate",
        orderStatus: "$orderStatus",
    })
    getSalesOrderRecord({ data, error }) {
        if (data) {
            console.log("ChileReport => Result =>", data);
            try {
                if (data.success) {
                    this.resultList = [];
                    this.nodata = false;
                    if (data.data.length > 0) {
                        this.resultList = data.data;
                        this.totalrecords = data.totalRecords;
                        this.recordstart = data.RecordStart;
                        this.recordend = data.RecordEnd;
                        this.totalpages = Math.ceil(
                            this.totalrecords / this.pagesize
                        );
                        this.generatePageList(this.pagenumber, this.totalpages);
                    } else {
                        this.nodata = true;
                    }
                } else {
                    console.log("ChileReport => WireMessage =>" + data.message);
                    this.nodata = true;
                }
                this.isLoading = false;
            } catch (error) {
                this.nodata = true;
                console.log("ChileReport ==>  WireError >>", error);
                this.isLoading = false;
            }
        } else if (error) {
            this.nodata = true;
            console.log("ChileReport ==>  WireError >>", error);
            this.isLoading = false;
        }
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
    handleType(event) {
        this.isLoading = true;
        this.typeValue = event.detail.value;
        if (this.typeValue == "Sales_Order__c") {
            this.poTabel = true;
            this.deliveryTabel = false;
            this.invoiceTabel = false;
        } else if (this.typeValue == "Sales_Order_Line_Item__c") {
            this.poTabel = false;
            this.deliveryTabel = true;
            this.invoiceTabel = false;
        } else if (this.typeValue == "Invoice__c") {
            this.poTabel = false;
            this.deliveryTabel = false;
            this.invoiceTabel = true;
        }
        this.pagenumber = 1;
    }
    handleStatus(event) {
        this.isLoading = true;
        this.orderStatus = event.detail.value;
        this.pagenumber = 1;
    }
    handleKeyChange(event) {
        this.searchKey = event.detail.value;
        this.isLoading = true;
        this.pagenumber = 1;
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
    downldPOFile(event) {
        this.isSpinner = true;
        let reference;
        if(this.isMobile){
            reference = event.detail.Id;
        }else{
            reference = event.currentTarget.dataset.value
        }
        
        getPoDocument({
            orderId: reference,
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
                   
                window.open(url, "_blank");
                this.isSpinner = false;
            } else {
                const event = new ShowToastEvent({
                    title: "Algo salió mal. Vuelve a intentarlo más tarde.", //Something went wrong, please try again later
                    variant: "error",
                });
                this.dispatchEvent(event);
                this.isSpinner = false;
            }
        });
    }
    handleOrderDetail(event) {
        let recordId;
        var moburl = (window.location.href).split('/s/')[0];
        if(this.isMobile){
            recordId= event.detail;
            console.log("record id"+recordId);
            this.detailPageLink = "/s/sales-order/" + recordId;
            moburl = (window.location.href).split('/s/')[0];
            window.open(moburl+this.detailPageLink);
        }else{
            recordId = event.currentTarget.dataset.value;
        this.detailPageLink = "sales-order/" + recordId;
    }
        
    }
        
    handleInvoiceDetail(event) {
        let recordId;
        var moburl = (window.location.href).split('/s/')[0];
        if(this.isMobile){
            recordId= event.detail;
            console.log("record id"+recordId);
            this.detailPageLink ="/uplpartnerportalstd/s/invoicedetailpage?id=" + recordId;
            window.open(this.detailPageLink);
        }else{
        recordId = event.currentTarget.dataset.value;
        if(moburl.includes('uplpartnerportalstd')){
            this.detailPageLink ="/uplpartnerportalstd/s/invoicedetailpage?id=" + recordId;
        }else{
            this.detailPageLink ="/uplpartnerportal/s/invoicedetailPage?id=" + recordId;
            }
    }
    }
    handleInvoiceClick(event) {
        let reference;
        if(this.isMobile){
            reference = event.detail.Id;
        }else{
            reference = event.currentTarget.dataset.value
        }
        
       
        this.handlePdfFile("Invoice", reference);
    }
    handleDeliveryClick(event) {
        let reference;
        if(this.isMobile){
            reference = event.detail.Id;
        }else{
            reference = event.currentTarget.dataset.value
        }
        
        this.handlePdfFile("Delivery", reference);
    }

    handlePdfFile(type, reference) {
        console.log("type=>", type);
        console.log("reference=>", reference);
        this.isSpinner = true;
        getPDF({
            type: type,
            reference: reference,
        }).then((result) => {
            console.log('result====> ',result);
            if (result.success) {
                //<!--GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022-->
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
}