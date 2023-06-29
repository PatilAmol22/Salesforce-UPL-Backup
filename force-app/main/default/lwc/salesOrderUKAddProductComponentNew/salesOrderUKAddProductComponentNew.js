import { LightningElement ,wire,api,track } from 'lwc';
import FetchSkuData from '@salesforce/apex/SalesorderUkController.getSkuData'; 
import SaveOrderCart from '@salesforce/apex/SalesorderUkController.saveOrder'; 
import deleteOrderLineItem from '@salesforce/apex/SalesorderUkController.deleteOrderLineItem'; 
import getCartOrderItems from '@salesforce/apex/SalesorderUkController.getCartOrderItems'; 
import updateOrderLineItems from '@salesforce/apex/SalesorderUkController.updateOrderLineItems'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import Qty_should_be_in_multiple_of_UK from '@salesforce/label/c.Qty_should_be_in_multiple_of_UK';
import Do_you_want_to_proceed_with_the_entered_quantity_Uk from '@salesforce/label/c.Do_you_want_to_proceed_with_the_entered_quantity_Uk';
import ORDER_SUMMARY_UK from '@salesforce/label/c.ORDER_SUMMARY_UK';
import Discount_Error_UK from '@salesforce/label/c.Discount_Error_UK';
import Discount_Header_UK from '@salesforce/label/c.Discount_Header_UK';
import Quantity_header_Uk from '@salesforce/label/c.Quantity_header_Uk';
import DeletecontentUK from '@salesforce/label/c.DeletecontentUK';
import Delete_UK from '@salesforce/label/c.Delete_UK';
import ErrorOnHolidayDateHeaderUK from '@salesforce/label/c.ErrorOnHolidayDateHeaderUK';
import ErrorOnHolidayDate from '@salesforce/label/c.ErrorOnHolidayDate';
import show_Number_of_orderin_cart from '@salesforce/label/c.show_Number_of_orderin_cart';
import ADD_A_NEW_PRODUCT_UK from '@salesforce/label/c.ADD_A_NEW_PRODUCT_UK';
import View_All_Uk from '@salesforce/label/c.View_All_Uk';
import View_Less_UK from '@salesforce/label/c.View_Less_UK';
import Enter_Quantity_UK from '@salesforce/label/c.Enter_Quantity_UK';
import Add_Product_UK from '@salesforce/label/c.Add_Product_UK';
import Products_Uk from '@salesforce/label/c.Products_Uk';
import Previous_Uk from '@salesforce/label/c.Previous_Uk';
import Next_Uk from '@salesforce/label/c.Next_Uk';
import Search_Sku_UK from '@salesforce/label/c.Search_Sku_UK';
import Showing_Page_UK from '@salesforce/label/c.Showing_Page_UK';
import UOM_UK from '@salesforce/label/c.UOM_UK';
import Net_Base_Price_UOM_UK from '@salesforce/label/c.Net_Base_Price_UOM_UK';
import Net_Unit_Price_UK from '@salesforce/label/c.Net_Unit_Price_UK';
import Approx_Stock_Quantity_UK from '@salesforce/label/c.Approx_Stock_Quantity_UK';
import Net_Total_Price_UK from '@salesforce/label/c.Net_Total_Price_UK';
import Qty_UOM_Box_UK from '@salesforce/label/c.Qty_UOM_Box_UK';
import Quantity_UK from '@salesforce/label/c.Quantity_UK';
import Per_Unit_Discount_Value_UK from '@salesforce/label/c.Per_Unit_Discount_Value_UK';
import Delivery_Date_UK from '@salesforce/label/c.Delivery_Date_UK';
import Comment_UK from '@salesforce/label/c.Comment_UK';
import Order_Quantity_UK from '@salesforce/label/c.Order_Quantity_UK';
import Order_Total_UK from '@salesforce/label/c.Order_Total_UK';
import Add_Products_UK from '@salesforce/label/c.Add_Products_UK';
import Discount_UK from '@salesforce/label/c.Discount_UK';
import Total_UK from '@salesforce/label/c.Total_UK';
import SKU_UK from '@salesforce/label/c.SKU_UK';
import Base_Price_UOM_UK from '@salesforce/label/c.Base_Price_UOM_UK';
import Date_of_Shipment_cannot_be_less_than_today_UK from '@salesforce/label/c.Date_of_Shipment_cannot_be_less_than_today_UK';
import Date_of_Shipment_cannot_be_less_than_today_UK2 from '@salesforce/label/c.Date_of_Shipment_cannot_be_less_than_today_UK2';
import { refreshApex } from '@salesforce/apex';

/* --------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------------------- */
import ErrorT from '@salesforce/label/c.Error';
import DeliveryDateReq from '@salesforce/label/c.Delivery_Date_is_Required';
import DeliveryNotLessThanToday from '@salesforce/label/c.Date_of_delivery_should_not_be_less_than_todays_date';
import CustomerDeliveryDate from '@salesforce/label/c.Customer_Expected_Delivery_Date';
/* --------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------------------------- */

const actions = [
    { label: 'Select', name: 'select'} 
];
const COLS = [
    { label: 'SKU Code', fieldName:'skuCode',type:'text', hideDefaultActions: true},
    { label: 'SKU Description', fieldName:'skuDescription', type:'text', hideDefaultActions: true},
    { label: 'Approx. Stock Quantity', fieldName:'approxStock', type:'number', hideDefaultActions: true,cellAttributes: { alignment: 'left' }},
    {
        label: 'Select',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            iconName: 'utility:add',
            title: 'Select',
            variant: 'brand',
            alternativeText: 'Select'
        }
    },
];

export default class SalesOrderUKAddProductComponentNew extends LightningElement {
    @api recordid;
    @api currencycodesymbol;
    @api objectname;
    @api showDelDate;            // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022.....
    @api isDelDateReq;           // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022.....

    skuData=[];
    tempskuData=[];
    columns=COLS;
    openAllskuproduct=false;
    skuSelectedRowData=[];
    skuBrand='';
    UOM='';
    materialPrice='';
    helptext='';
    multipleOf='';
    skuDescription='';
    unitPrice='';
    totalPrice='';
    approxQuantity='';
    discountvalue=0;
    quantityvalue=0;
    findallData=false;
    isdiabled=true;
    warningMessage=false;
    isQuantitymultipleof=false;
    isdiscountgreater=false;
    isloaderReq=false;
    shipdate;
    comment='';
    savedcartproducts=[];
    allsavedProduct=[];
    itemsLength;
    Headermessage='';
    divclass="slds-box boxstylecolored";
    textclass="labelstylecolored";
    page = 1;
    pageSize =0;
    totalRecountCount = 0;
    totalPage = 0;
    searchKey='';
    totalRecords = 0;
    startingRecord = 1;
    endingRecord = 0; 
    isprevdisable = true; 
    isnextdisable = true; 
    Quantitynew='';
    hasitem=false;
    warningdeleteMessage=false;
    isalltype=false;
    orderlineItemdataId='';
    totalLineItemResult=[];
    showLineItemResult=[];
    value = '5';
    ViewName=View_All_Uk;
    isviewmore=false;
    isdisabledField=false;
    isdisabledtrue=false;
    isvalidateError=false;
    founddata=true;
    ismultipleofreq=true;
    discountnewf=0;
    newoliId='';
    QuantityNew=0;
    commenttext='';
    sipdatenew='';
    multipleofNewValue;
    currentdate='';
    deliveryDate = ''; // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...
    get options() {
        return [
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '15', value: '15' },
        ];
    }

    label = {
        Qty_should_be_in_multiple_of_UK,
        Do_you_want_to_proceed_with_the_entered_quantity_Uk,
        ORDER_SUMMARY_UK,
        Discount_Error_UK,
        Quantity_header_Uk,
        Discount_Header_UK,
        Delete_UK,
        DeletecontentUK,
        ErrorOnHolidayDate,
        ErrorOnHolidayDateHeaderUK,
        show_Number_of_orderin_cart,
        View_Less_UK,
        View_All_Uk,
        Enter_Quantity_UK,
        Add_Product_UK,
        Date_of_Shipment_cannot_be_less_than_today_UK,
        Products_Uk,
        Previous_Uk,
        Next_Uk,
        ADD_A_NEW_PRODUCT_UK,
        Search_Sku_UK,
        Showing_Page_UK,
        UOM_UK,
        Qty_UOM_Box_UK,
        Net_Base_Price_UOM_UK,
        Net_Unit_Price_UK,
        Approx_Stock_Quantity_UK,
        Net_Total_Price_UK,
        Quantity_UK,
        Per_Unit_Discount_Value_UK,
        Delivery_Date_UK,
        Comment_UK,
        Order_Quantity_UK,
        Order_Total_UK,
        Add_Products_UK,
        SKU_UK,
        Discount_UK,
        Total_UK,
        Base_Price_UOM_UK,
        Date_of_Shipment_cannot_be_less_than_today_UK2,
        /* ------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------- */
        ErrorT,
        DeliveryDateReq,
        DeliveryNotLessThanToday,
        CustomerDeliveryDate
        /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------ */
    };
    @api
    methodToChangeColoradd(istrue){
        if(istrue){
            if(this.divclass!='slds-box boxstylecolored'){
                this.divclass="slds-box boxstylecolored";
                this.textclass="labelstylecolored";
            }
        }
        else{
            if(this.divclass!='slds-box boxstyle'){
                this.divclass="slds-box boxstyle";
                this.textclass="labelstyle";
            }
        }
       
    }
   
    @api
    currencygetmethod(currencycodename){
        this.currencycode=currencycodename;
    }

    @api
    ceckmethod(salesorederdata,currencycodename){
        console.log('this.salesorederdata==='+JSON.stringify(this.salesorederdata));
        this.salesorederdata=salesorederdata;
        this.isdisabledtrue=true;
        this.isdisabledField=true;
        this.currencycode=currencycodename;
        this.callskudata();
    }
    @api
    iseditcalled(){
        if(this.salesorederdata.Order_Status__c ==='Draft' || this.salesorederdata.Order_Status__c ==='Rejected'){
            this.isdisabledtrue=false;
            this.isdisabledField=false;
        }
        else{
            this.isdisabledtrue=true;
            this.isdisabledField=true;
        }
    }
    onblurvatidatedate(event){
        this.checkvalidatedate(event.target.value);
        if(this.isQuantitymultipleof){
            this.Headermessage=this.label.Quantity_header_Uk;
            this.multipleofNewValue=this.skuSelectedRowData.multipleOf;
            this.warningMessage= this.label.Qty_should_be_in_multiple_of_UK+" "+this.skuSelectedRowData.multipleOf+". "+this.label.Do_you_want_to_proceed_with_the_entered_quantity_Uk;
        }
        else if(this.isdiscountgreater){
            this.Headermessage=this.label.Discount_Header_UK;
            this.warningMessage= this.label.Discount_Error_UK;
        }
    }
    checkValidationOnBlur(){
        if(this.isQuantitymultipleof){
            this.Headermessage=this.label.Quantity_header_Uk;
            this.multipleofNewValue=this.skuSelectedRowData.multipleOf;
            this.warningMessage= this.label.Qty_should_be_in_multiple_of_UK+" "+this.skuSelectedRowData.multipleOf+". "+this.label.Do_you_want_to_proceed_with_the_entered_quantity_Uk;
        }
        else if(this.isdiscountgreater){
            this.Headermessage=this.label.Discount_Header_UK;
            this.warningMessage= this.label.Discount_Error_UK;
        }else if(this.isvalidateError){
            this.Headermessage=this.label.ErrorOnHolidayDateHeaderUK;
            this.warningMessage= this.label.Date_of_Shipment_cannot_be_less_than_today_UK;
        }
    }

    checkvalidatedate(selectddate){
        this.isvalidateError=false;
        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var x = new Date(selectddate);
        var y = new Date(currentDate);
        var flag = true;
        // is less than today?
        if (+x < +y) {
            this.isvalidateError=true;
            this.Headermessage=this.label.ErrorOnHolidayDateHeaderUK;
            this.warningMessage= this.label.Date_of_Shipment_cannot_be_less_than_today_UK;
          // alert('ERROR')
        } 
        else{
            this.isvalidateError=false; 
        }
    }
  connectedCallback(){
    this.skuSelectedRowData=[];
    this.discountvalue=0;
    this.quantityvalue=0;
    this.totalPrice='';
    this.unitPrice='';
    this.shipdate='';
    this.deliveryDate = '';         // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...
    this.comment='';
    this.helptext=this.label.Enter_Quantity_UK;
    if(this.currencycodesymbol==='£'){
        this.currencycode='GBP';
    }
    else{
        this.currencycode='EUR';
    }
    // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...added field....deliveryDate...
    this.skuSelectedRowData.push({'skuId':'','skuCategory':'','skuDescription':'','skuCode':'','skuBrand':'',
        'unitCost':'','UOM':'','customerCode':'','unitValue':0,'unitPrice':0,'materialPrice':0,
        'pricebookId':'','multipleOf':0,'approxStock':0,'discountvalue':0,'qty':0,'shipDate':'','shipDateformatted':'',
        'personalNotes':'','netPrice':0, 'deliveryDate':'',
        'CurrencyIsoCode':this.currencycode,
    });
    this.getCartData();
    }
    
    handleKeyChange( event ) {
        this.searchKey = event.target.value;
        //this.isloaderReq=true;
        this.callskudata();
        this.displayRecordPerPage(this.page);
    }

    getCartData(){
        getCartOrderItems({recordId:this.recordid,objectName:this.objectname})
    .then(result => {
        this.isviewmore=false;
        this.savedcartproducts=[];
        this.QuantityNew=0;
                this.sipdatenew='';
                this.discountnewf=0;
                this.commenttext='';
        this.helptext=this.label.Enter_Quantity_UK;
        this.ismultipleofreq=true;
        this.savedcartproducts=result;
        this.totalLineItemResult=this.savedcartproducts.soiList;
        
        var totalrec=parseInt(this.label.show_Number_of_orderin_cart);
        this.showLineItemResult=this.totalLineItemResult.slice(0,totalrec);
        this.Quantitynew="";
        this.Quantitynew="";
        if(this.savedcartproducts){
            if(this.savedcartproducts.Net_QuantityLiters!="0L" && this.savedcartproducts.Net_QuantityKgs!="0KG"){
                this.Quantitynew=this.savedcartproducts.Net_QuantityLiters+'/'+this.savedcartproducts.Net_QuantityKgs;
            }
            else if(this.savedcartproducts.Net_QuantityLiters!="0L"){
                this.Quantitynew=this.savedcartproducts.Net_QuantityLiters;
            } 
            else if(this.savedcartproducts.Net_QuantityKgs!="0KG"){
                this.Quantitynew=this.savedcartproducts.Net_QuantityKgs;

            }    
        }

        var today = new Date();
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        
        // Custom date format for ui:inputDate
        var currentDate = (yyyy + "-" + MM + "-" + dd);
		this.currentdate=currentDate;
        
        this.isloaderReq=false;
        this.itemsLength=this.savedcartproducts.soiList.length;
        if(this.itemsLength > totalrec){
            this.isviewmore=true;
        }
        
        if(this.itemsLength>0){
            this.hasitem=true;
            this.dispatchEvent(new CustomEvent('mycartnotempty'));
        }
        else{
            this.hasitem=false;
            this.dispatchEvent(new CustomEvent('mycartempty'));
        }
        this.ViewName=this.label.View_All_Uk;
        this.callskudata();
        Promise.resolve().then(() => {
            const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
                }, true);
        });
    })
    .catch(error =>{
        console.log('error===>'+JSON.stringify(error));
    })

    }

    //clicking on previous button this method will be called
    handlePrev() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
        if(this.page==1){
            this.isprevdisable = true; 
            this.isnextdisable = false; 
        } 
        else if(this.page==this.totalPage){
            this.isprevdisable = false; 
            this.isnextdisable = true; 
        }
        else{
            this.isprevdisable = false; 
            this.isnextdisable = false; 
        }    
    }

    //clicking on next button this method will be called
    handleNext() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }
       /* if(this.page==this.totalPage){
            this.isprevdisable = false; 
            this.isnextdisable = true; 
        }*/
        if(this.page==1){
            this.isprevdisable = true; 
            this.isnextdisable = false; 
        } 
        else if(this.page==this.totalPage){
            this.isprevdisable = false; 
            this.isnextdisable = true; 
        }
        else{
            this.isprevdisable = false; 
            this.isnextdisable = false; 
        }             
    }
    displayRecordPerPage(page){
        console.log('this.pageSize',this.pageSize);   
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.skuData = this.tempskuData.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }    

    handleChange2(event){
        this.value = event.detail.value;
        this.pageSize = this.value;
        console.log('result.error==>'+this.totalRecords+'  =='+this.pageSize);
        if(this.totalRecords> this.pageSize){
            this.isprevdisable = true; 
            this.isnextdisable = false; 
        }
        else if(this.totalRecords<= this.pageSize){
            this.isprevdisable = true; 
            this.isnextdisable = true; 
        }
        this.page = 1;
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
        this.displayRecordPerPage(this.page);
    }

    @api
    getcartproducts(){
        console.log('result.error==>'+this.isdiabled);
        var iscall=true;
        var iscartnotempty=false;
        /* ------------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------------- */
        var error = false;
        var errMsg = '';
        if(this.showDelDate == true){
            var crDt = new Date();
            var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            var y = new Date(currentDate);

            if(this.totalLineItemResult.length>0){
                for(let obj of this.totalLineItemResult){
                    if(obj.deliveryDate == ''){
                        //
                    }
                    else{
                        var z = new Date(obj.deliveryDate);
                        if(+z < +y){
                            error = true;
                            errMsg = DeliveryNotLessThanToday;
                            break;
                        }
                    }
                }

                if(error == true){
                    this.showToast(ErrorT,errMsg,'Error'); 
                }
            }
        }

        if(error == false){
        /* ------------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 --------------- */
            const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
                }, true);
                if (allValid) {
                    iscall=true;
                } else {
                    iscall=false;
                }
                console.log('iscall=>', iscall);
            if(this.itemsLength > 0){
                var iscartvalidate=false;
                if(this.itemsLength > 5){
                    for(let oli of this.totalLineItemResult){
                        this.checkvalidatedate(oli.shipDate);
                        if(this.isvalidateError){
                            iscartvalidate=true;
                        }
                        console.log('iscall=>', this.isvalidateError);
                    }   
                }
                console.log('iscall=>', this.savedcartproducts);
                if(this.isvalidateError || iscartvalidate){
                    iscartnotempty=false; 
                    iscall=false;
                    this.Headermessage=this.label.ErrorOnHolidayDateHeaderUK;
                    if(iscartvalidate){
                        this.warningMessage= this.label.Date_of_Shipment_cannot_be_less_than_today_UK2;
                    }
                    else{
                        this.warningMessage= this.label.Date_of_Shipment_cannot_be_less_than_today_UK;
                    }
                    
                }
                else if(this.isQuantitymultipleof){
                    iscartnotempty=false; 
                    iscall=false;
                    this.Headermessage=this.label.Quantity_header_Uk;
                    this.warningMessage= this.label.Qty_should_be_in_multiple_of_UK+" "+this.multipleofNewValue+". "+this.label.Do_you_want_to_proceed_with_the_entered_quantity_Uk;
                }
                else if(this.isdiscountgreater){
                    iscartnotempty=false; 
                    iscall=false;
                    this.Headermessage=this.label.Discount_Header_UK;
                    this.warningMessage= this.label.Discount_Error_UK;
                }
                else{
                    console.log('iscall=>', this.savedcartproducts);
                    iscartnotempty=this.savedcartproducts;
                }
            } 
            if(!iscall){
                iscartnotempty=false;  
            }
        } // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...closing bracket...
        console.log('result.error==>', JSON.stringify(iscartnotempty));
        return iscartnotempty;
    }

    openPriceDeatilsPopUp(){
        this.page=1;
        this.openAllskuproduct=true;
        this.findallData=false;
    }
    callskudata(){
        console.log('currencycodesymbol=='+this.currencycode);
        var recordId=this.recordid
        if(this.objectname==='SalesOrder'){
            if(this.salesorederdata){
                recordId=this.salesorederdata.Sold_to_Party__c;
            }
        }
        else{
            var recordId=this.recordid 
        }
        FetchSkuData({accId:recordId,searchKey: this.searchKey})
        .then(result => {
            this.tempskuData=result;
            this.findallData=false;
            this.totalRecords = this.tempskuData.length;
            console.log('tempskuData==>', this.totalRecords)
            this.totalRecountCount = result.length; 
            this.pageSize = this.value;
            if(this.totalRecords > this.pageSize){
                this.isprevdisable = true; 
                this.isnextdisable = false; 
            }
            if(this.totalRecords > 0){
                this.founddata=true;
            }
            else{
                this.founddata=false;
            }
            this.isloaderReq=false;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            this.skuData = this.tempskuData.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;
            let style = document.createElement('style');
            style.innerText = '.slds-th__action{background-color: slategray; color:white;pointer-events: none;}';
            this.template.querySelector('lightning-datatable').appendChild(style);
            let style2 = document.createElement('style');
            style2.innerText = '.slds-cell-fixed{pointer-events: none;}';
            this.template.querySelector('lightning-datatable').appendChild(style2);
            console.log('result==>', this.skuData)
            
        })
        .catch(error => {
            console.log('result==>',error)
            this.isloaderReq=false;
            this.error = error;
        });
    }
    handleRowActions(event){
        this.searchKey='';
        this.skuData=[];
        this.callskudata();
        this.isdiabled=false;
        this.openAllskuproduct=false;
        this.skuSelectedRowData = event.detail.row;
        this.skuBrand=this.skuSelectedRowData.skuDescription;
        this.unitPrice=this.skuSelectedRowData.materialPrice;
        this.totalPrice=this.skuSelectedRowData.materialPrice;
        this.shipdate=this.skuSelectedRowData.shipDate;
        this.deliveryDate = '';                         // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...
        if(this.skuSelectedRowData.multipleOf){
            this.ismultipleofreq=true;
            this.helptext=this.label.Qty_should_be_in_multiple_of_UK+' '+this.skuSelectedRowData.multipleOf;
        }
        else{
            this.ismultipleofreq=false;
        }
        console.log('Test3 result==>',JSON.stringify(this.skuSelectedRowData));
    }

    /* --------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------- */
    handleDelvryDateChange(event){
        var errMsg = ''; 
        var error = false;
        var crDt = new Date();
        var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var y = new Date(currentDate);
        var val = event.target.value;
        var z = '';

        if(this.showDelDate == true){
            if(val == null){
                z = '';
                val = '';
            }
            else{
                z = new Date(val);
            }  
            if(this.isDelDateReq == true && (val == null || val == '')){
                errMsg = DeliveryDateReq;
                error = true;
                event.target.value = '';
            }
            else if((val != null || val != '') && +z < +y){
                error = true;
                errMsg = DeliveryNotLessThanToday;
                event.target.value = '';
            }
            else if(val == ''){
                z = '';
            }
        }  
        
        /* this.shipdate = z;
        this.skuSelectedRowData.shipDate = this.shipdate; */

        if(error == true){
            this.showToast(ErrorT,errMsg,'Error');            
        }
        else{
            this.deliveryDate = val;
            this.skuSelectedRowData.deliveryDate = this.deliveryDate;
            this.handlechange(event);
        }
    }
    /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------------- */

    handlechange(event){
       // this.isdiscountgreater=false;
       
        if(event.target.dataset.name === 'quantity'){
            if(this.skuSelectedRowData.multipleOf!='' || this.skuSelectedRowData.multipleOf!=0){
                if(event.target.value){
                    this.checkQuantityError(event.target.value,this.skuSelectedRowData.multipleOf)
                }
            }
            this.quantityvalue = event.target.value;
            this.totalPrice=this.skuSelectedRowData.materialPrice * this.quantityvalue -this.discountvalue;
            this.unitPrice=this.skuSelectedRowData.materialPrice-this.discountvalue; 
            if(this.totalPrice<0){
                this.isdiscountgreater=true;
            } 
            else{
                this.isdiscountgreater=false;
            }              
        }
        else if(event.target.dataset.name === 'discount'){
            this.isdiscountgreater=false;
            if(event.target.value !=null && event.target.value !=''){
                this.discountvalue = event.target.value;
            }
            else{
                this.discountvalue = 0;
            }
            this.unitPrice=this.skuSelectedRowData.materialPrice-this.discountvalue;
            this.totalPrice=this.skuSelectedRowData.materialPrice * this.quantityvalue -this.discountvalue;
           if(this.totalPrice<0){
            this.isdiscountgreater=true;
           }           
        }
        else if(event.target.dataset.name === 'shipDate'){
            this.shipdate=event.target.value;
        }
        else if(event.target.dataset.name === 'comment'){
            this.comment=event.target.value;
        }
        /* ---------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------- */
        else if(this.showDelDate == true && event.target.dataset.name === 'delvryDate'){
            //this.deliveryDate = event.target.value;
            this.skuSelectedRowData.deliveryDate = this.deliveryDate;
        }
        /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------- */
        if(this.discountvalue!=null){
            this.skuSelectedRowData.discountvalue=this.discountvalue;
        }
        else{
            this.skuSelectedRowData.discountvalue=0;
        }
            this.skuSelectedRowData.qty=this.quantityvalue;
            this.skuSelectedRowData.netPrice=this.totalPrice;
            this.skuSelectedRowData.unitPrice=this.unitPrice;
            this.skuSelectedRowData.unitValue=this.unitPrice;
            this.skuSelectedRowData.shipDate=this.shipdate;
            this.skuSelectedRowData.personalNotes=this.comment;
            this.skuSelectedRowData.CurrencyIsoCode=this.currencycode;
            
          }
    checkQuantityError(value,maltipleof){
        var qty=value;
        if(qty==0){

        }
        else{
            var qtyString = qty.toString(); 
            if(qtyString!=''){
                qty = parseFloat(qtyString.replace("-", "")); //Replace negative sign
                var multipleOf = maltipleof;
                var flag = false;
                this.isQuantitymultipleof=false;
                var modValue = (qty%multipleOf).toFixed(2);
                
                if(multipleOf && modValue!=0){
                    if(modValue != multipleOf){
                        flag = true;
                        this.isQuantitymultipleof=flag;
                    }
                }
            }
        }
    }

    /* ------------------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 --------------------- */
    validateDelvryDate(event){
        var val = event.currentTarget.value;  
        var index = event.currentTarget.dataset.index; 
        var ordItem = this.showLineItemResult; 
        var obj = new Object(ordItem[index]); 
        var flag = false;
        if(val == null){
            val = '';
        }
        
        var crDt = new Date();
        var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var yy = new Date(currentDate);
        var z = '';
        console.log('val - ', val);
        if(this.showDelDate == true && val != ''){
            
            z = new Date(val);
            console.log('dates - ', z + ' -- '+ yy);
            if(+z < +yy){     // delivery date greated than today+1...
                flag = true;
                event.currentTarget.value = '';
                //target.focus();
                //target.set("v.value","");
                //var errMsg = $A.get("{!$Label.c.Date_of_delivery_should_not_be_less_than_todays_date}");
                this.showToast(ErrorT,DeliveryNotLessThanToday,'Error');
            }
            else{
                flag = false
                obj.deliveryDate = z;
                ordItem[index].deliveryDate = z;
            }
        }
        if(flag == false){
            this.updateOnblur(event);
        }

       }
       /* ----------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------------- */
   
    updateOnblur(event){
       
                    var isemptyfield=false;
                        var name= event.currentTarget.dataset.name;
                        var index= event.currentTarget.dataset.index;
                        var SinglelineItem=this.showLineItemResult[index];
                        let valueenterd=0;
                        valueenterd=event.target.value;
                        
                        var isupdated=false;
                      //  if(valueenterd!='' && valueenterd!=null){
                        if(name==='comment' && valueenterd!=SinglelineItem.personalNotes){
                            if(valueenterd!='' && valueenterd!=null){
                                SinglelineItem.personalNotes=valueenterd;
                            }
                            isupdated=true;
                        }
                        else if(name==='Discount' && valueenterd!=SinglelineItem.discountvalue){
                            if(valueenterd!='' && valueenterd!=null){
                                SinglelineItem.discountvalue=valueenterd;
                            }
                            else{
                                SinglelineItem.discountvalue=0;
                            }
                            SinglelineItem.unitPrice=this.showLineItemResult[index].materialPrice- SinglelineItem.discountvalue;
                            console.log('+++'+this.showLineItemResult[index].materialPrice +'==='+ SinglelineItem.qty+'=='+SinglelineItem.discountvalue);
                            SinglelineItem.netPrice=this.showLineItemResult[index].materialPrice * SinglelineItem.qty-SinglelineItem.discountvalue;
                            if(SinglelineItem.netPrice < 0){
                                this.isdiscountgreater=true;
                                this.Headermessage=this.label.Discount_Header_UK;
                                this.warningMessage= this.label.Discount_Error_UK;
                            }
                            else{
                                this.isdiscountgreater=false;
                                isupdated=true;
                            }
                        }
                        else if(name==='Deliverydate'  && valueenterd!=SinglelineItem.shipDate){
                            if(valueenterd!='' && valueenterd!=null){
                                SinglelineItem.shipDate=valueenterd;
                            }
                            isupdated=true;
                        }
                        /* ------------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------------------- */
                        else if(name==='delivryDate'  && valueenterd!=SinglelineItem.deliveryDate){
                            if(this.showDelDate == true && this.isDelDateReq == true && (valueenterd =='' || valueenterd ==null)){
                                isupdated=false;
                                this.showToast(ErrorT,DeliveryDateReq,'Error');
                            }
                            else if(this.showDelDate == true && valueenterd!='' && valueenterd!=null && valueenterd != 0){
                                SinglelineItem.deliveryDate=valueenterd;
                                isupdated=true;
                            }
                            else if(valueenterd == null || valueenterd == ''){
                                SinglelineItem.deliveryDate = '';
                                isupdated=true;
                            }
                            
                        }
                        /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------------- */
                        else if(name==='Quantity'  && valueenterd!=SinglelineItem.qty){
                            if(valueenterd!='' && valueenterd!=null){
                                SinglelineItem.qty=valueenterd;
                                isemptyfield=false;
                            }
                            else{
                                SinglelineItem.qty=0;
                            }
                            this.checkQuantityError(SinglelineItem.qty,this.showLineItemResult[index].multipleOf);
                            SinglelineItem.netPrice=this.showLineItemResult[index].materialPrice * SinglelineItem.qty-SinglelineItem.discountvalue;
                            if(SinglelineItem.netPrice < 0){
                                this.isdiscountgreater=true;
                                this.Headermessage=this.label.Discount_Header_UK;
                                this.warningMessage= this.label.Discount_Error_UK;
                            }
                            else{
                                this.isdiscountgreater=false;
                                isupdated=true;
                            }
                        }
                        if(isupdated){
                            if(this.isQuantitymultipleof){
                                this.Headermessage=this.label.Quantity_header_Uk;
                                this.multipleofNewValue=this.showLineItemResult[index].multipleOf;
                                this.warningMessage= this.label.Qty_should_be_in_multiple_of_UK+" "+this.showLineItemResult[index].multipleOf+". "+this.label.Do_you_want_to_proceed_with_the_entered_quantity_Uk;
                            }
                            else if(this.isdiscountgreater){
                                this.Headermessage=this.label.Discount_Header_UK;
                                this.warningMessage= this.label.Discount_Error_UK;
                            }
                            else{
                                var iloid= event.currentTarget.dataset.id;
                                var valueindex='.'+iloid;
                                const allValid = [...this.template.querySelectorAll(valueindex)]
                                    .reduce((validSoFar, inputCmp) => {
                                        inputCmp.reportValidity();
                                        return validSoFar && inputCmp.checkValidity();
                                        }, true);
                                        if (allValid) {
                                            isupdated=false;
                                            console.log("datada=====>"+JSON.stringify(SinglelineItem));
                                            this.isloaderReq=true;
                                            this.updateOrderLineItemdata(SinglelineItem);
                                        }
                            }
                        }
    }

    updateOrderLineItemdata(SinglelineItem){
            updateOrderLineItems({orderItemListString:JSON.stringify(SinglelineItem),objectName:this.objectname})
            .then(result => {
                if(result.errorMessage===this.label.ErrorOnHolidayDate){
                    this.isloaderReq=false;
                    this.Headermessage=this.label.ErrorOnHolidayDateHeaderUK;
                    this.warningMessage= this.label.ErrorOnHolidayDate;
                } else if(result.errorMessage!=''){
                    console.log('data===eror'+result.errorMessage);
                    this.isloaderReq=false;
                      alert('Failed to update please check the data.');
                }
                else{
                    this.showToast('Success!!','Record Updated','success');
                    this.isloaderReq=false;
                    //refreshApex(this.allsavedProduct);
                   // this.showLineItemResult=[];
                    this.getCartData();
            }           
            })
            .catch(error => {
                this.isloaderReq=false;
                this.error = error;
            });
        
    }

    cancelModal(){
        this.searchKey='';
        this.skuData=[];
        this.callskudata();
        this.openAllskuproduct=false;
        this.warningMessage=false;
        this.warningdeleteMessage=false;
    }
    onAddProductCart(){
        var iscall;
        /* ---------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------------ */
        var errMsg = ''; 
        var error = false;
        
        if(this.showDelDate == true){
            var crDt = new Date();
            var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
            var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            var yyyy = today.getFullYear();
            var currentDate = (yyyy + "-" + MM + "-" + dd);
            var y = new Date(currentDate);
            var val = this.skuSelectedRowData.deliveryDate;
            var z = '';

            if(val == ''){
                z = '';
            }
            else{
                z = new Date(val);
                this.skuSelectedRowData.deliveryDate = z;
            }  
            if(this.isDelDateReq == true && (val == null || val == '')){
                iscall=false;
                errMsg = DeliveryDateReq;
                error = true;
            }
            else if((val != null || val != '') && +z < +y){
                iscall=false;
                error = true;
                errMsg = DeliveryNotLessThanToday;
            }
            else if(val == ''){
                z = '';
            }
        }      

        if(error == true){
            this.showToast(ErrorT,errMsg,'Error');            
        }
        else{
        /* ---------------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------------------- */    
            const allValid = [...this.template.querySelectorAll('.lightningaddproduct')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
                }, true);
                if (allValid) {
                    iscall=true;
                } else {
                    iscall=false;
                }
                if(this.isQuantitymultipleof){
                    this.Headermessage=this.label.Quantity_header_Uk;
                    this.multipleofNewValue=this.skuSelectedRowData.multipleOf;
                    this.warningMessage= this.label.Qty_should_be_in_multiple_of_UK+" "+this.skuSelectedRowData.multipleOf+". "+this.label.Do_you_want_to_proceed_with_the_entered_quantity_Uk;
                }
                else if(this.isdiscountgreater){
                    this.Headermessage=this.label.Discount_Header_UK;
                    this.warningMessage= this.label.Discount_Error_UK;
                }
                else if(this.isvalidateError){
                    this.Headermessage=this.label.ErrorOnHolidayDateHeaderUK;
                    this.warningMessage= this.label.Date_of_Shipment_cannot_be_less_than_today_UK;
                }
                if(iscall && !this.isQuantitymultipleof && !this.isdiscountgreater && !this.isvalidateError){
                    this.isloaderReq=true;
                    var orderdata=JSON.stringify(this.skuSelectedRowData);
                    SaveOrderCart({accountId:this.recordid,OrderItemString:orderdata,orderType:'ZOR1',OrderId:this.savedcartproducts.cartOrderId,currencycode:this.currencycode,objectName:this.objectname})
                    .then(result => {
                        if(result.errorMessage===this.label.ErrorOnHolidayDate){
                            this.isloaderReq=false;
                            this.Headermessage=this.label.ErrorOnHolidayDateHeaderUK;
                            this.warningMessage= this.label.ErrorOnHolidayDate;
                        }
                        else if(result.errorMessage!=''){
                            this.isloaderReq=false;
                            alert('Failed to update please check the data.');
                      }
                        else{
                            //this.showToast('Success!!','Record Saved','success');
                            this.connectedCallback();
                            this.unitPrice='';
                            this.totalPrice='';
                            this.skuBrand='';
                            this.isdiabled=true;
                           // refreshApex(this.allsavedProduct);
                            this.getCartData();
                        }
                       
                    })
                    .catch(error => {
                        this.isloaderReq=false;
                        this.error = error;
                    });
                }
        } // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022
    }

    opendeletepopup(event){
        this.warningdeleteMessage=true;
        var orderlineItemtype=event.currentTarget.dataset.type;
       // window.scrollTo(0, 0);
       if(orderlineItemtype==='single'){
            this.isalltype=false;
            this.orderlineItemdataId=event.currentTarget.dataset.order;
        }else{
            this.isalltype=true;
        }
    }
    handleView(event){
        var viewName =event.currentTarget.dataset.type;
        if(viewName===this.label.View_All_Uk){
            this.ViewName=this.label.View_Less_UK;
            this.showLineItemResult= this.totalLineItemResult;
        }
        else if(viewName===this.label.View_Less_UK){
            this.ViewName=this.label.View_All_Uk;
            var totalrec=parseInt(this.label.show_Number_of_orderin_cart);
            this.showLineItemResult=this.totalLineItemResult.slice(0,totalrec);
        }
    }

    deleteOrderLineItemmethod(){
        this.isloaderReq=true;
        this.warningdeleteMessage=false;
        var isalltype;
        deleteOrderLineItem({oliId:this.orderlineItemdataId,orderId:this.savedcartproducts.cartOrderId,itemsLength:this.itemsLength,isall:this.isalltype,objectName:this.objectname})
                    .then(result => {
                        this.showToast('Success!!','Record Deleted','success');
                        //return refreshApex(this.allsavedProduct);
                        this.getCartData();
                    })
                    .catch(error => {
                        this.error = error;
                    });
    }

    showToast(title,message,variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
      }
      @api 
      clearmethod(){
          this.isloaderReq=true;
         // return refreshApex(this.allsavedProduct);
          this.getCartData();
      }  

    /* ------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------- */
     @api
     checkDelDateField(show_delDt,delDt_req){
        
        this.showDelDate = show_delDt;                  
        this.isDelDateReq = delDt_req;                  
        
     }
     /* ------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------ */  
}