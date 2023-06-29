import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getProductDetailList from '@salesforce/apex/Grz_ProductDetailClass.getProductDetailList';
import setAcknowledgement from '@salesforce/apex/Grz_ProductDetailClass.setAcknowledgement';

//import downloadinvoice from '@salesforce/apex/Grz_ProductDetailClass.downloadinvoice';
//import getInvoices from '@salesforce/apex/Grz_ProductDetailClass.getInvoices';
export default class Grz_productdetailpage extends LightningElement {
  isScreen=false;
    @track finaldata;
    @track billingid;
  wiredresult;
  @track totalamt;
  @track totalinvoice;
    @track isExternal;
    @track contentdoc;
    @track accid;
   @track statuscolor;
    @track showinvoices;
    @track contentdocid;
    @track btnLabel = 'Acknowledge';
    @track nodata;
    @track noinvoice;
    @track lineitemdata = [];
    @track isbrazil;
    @track data;
    @track invoicesarray = [];
    @track mapData= [];
    @track error;
    @api title;
    @track salesorderName;
    @track invoicesdata;
    @api designattributeimage;
    @track acknowledgement = false;
    @track Billinginvoice;
    currentPageReference = null; 
    urlStateParameters = null;
    /* Params from Url */
    urlId = null;
    urlLanguage = null;
    urlType = null;
    
   
    @api backgroundimage = null;
    
    ordericon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
    editicon = Icons + "/Grz_Resourse/Images/editicon.png";
    deleteicon = Icons + "/Grz_Resourse/Images/deleteicon.png";
    acked = Icons + "/Grz_Resourse/Images/greyack.svg";
    notacked = Icons + "/Grz_Resourse/Images/Orangeack.svg";
     ready = false;
  
    connectedCallback() {
      window.addEventListener('resize', this.myFunction);

        console.log('screen================='+screen.width);
        if(screen.width<768)this.isScreen=true;

     
        this.backgroundimage = Icons + this.designattributeimage;
      setTimeout(() => {
             document.title = 'Order Detail Page';
           this.ready = true;
          }, 5000);
      
       
    }
   

    myFunction = () => {
      if(screen.width<768)this.isScreen=true; 
      else this.isScreen=false; 
  
      console.log('isScreen=========='+this.isScreen);
   };
  
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
             
        if (currentPageReference) {           
          //this.urlStateParameters = currentPageReference.state;
          console.log('---this.urlStateParameters--',window.location.href);
          var urlParameters = window.location.href;
          console.log('---this.urlStateParameters--', urlParameters.split('sales-order/'));
          this.urlStateParameters = urlParameters.split('sales-order/');
          console.log('---this.urlStateParameters--', this.urlStateParameters);         
          //this.urlId = this.urlStateParameters.id || null;
          var urlIDValue = this.urlStateParameters[1] || null;
          urlIDValue = urlIDValue.split('/');
          this.urlId = urlIDValue[0];
          console.log('---this.urlId--', this.urlId);
          this.doSearch();
       }
    }

   

    doSearch() {
       
         console.log('this.urlId+++++ ',this.urlId);
         getProductDetailList({ urlapex: this.urlId })
            .then(result => {
                
              console.log('----result.salesList----',result.salesList);
              console.log('----result----', result);
              var temp = result.salesList[0].Total_Amount__c;
              console.log('----temp----', temp);
              if (temp != null) {
                var amount = this.formatNumber(temp.toFixed(2));
                console.log('----amount----', amount);
             
              this.totalamt = amount;
              }
              else {
                this.totalamt = 0;
              }
              var salesorder = result.salesList[0].Name;
              console.log('salesorder',salesorder.length);
              if (salesorder.length > 10) {
                this.salesorderName = salesorder.substring(salesorder.length - 8);
              }
              console.log('salesordername--0', this.salesordername);
              var tempstatus = result.salesList[0].Order_Status__c;
              console.log('tempstatus',tempstatus);
              if (tempstatus == 'Partially processed' || tempstatus == 'Pending' || tempstatus == 'Open' ||
                tempstatus == 'Not yet processed' || tempstatus == 'Submitted' || tempstatus == 'Draft')
                {
               
                  document.documentElement.style.setProperty('--bgColor2', 'orange');
              }
              else if (tempstatus == 'Not Relevant' || tempstatus == 'Order Cancelled' || tempstatus == 'Rejected' ||
                tempstatus == 'Cancelled' || tempstatus == 'Error from SAP' || tempstatus == 'Blocked')
                {
               
                 document.documentElement.style.setProperty('--bgColor2', 'red');
              }
                else if (tempstatus == 'Completely processed' || tempstatus == 'Approved')
                {
               
                 document.documentElement.style.setProperty('--bgColor2', 'green');
                }
              else {
              
                document.documentElement.style.setProperty('--bgColor2', 'grey');
                  }
              console.log('statuscolor', this.statuscolor);
             
              this.finaldata = result.salesList;
             this.isExternal = result.isExternalUser;
              this.showinvoices = result.isSuccess;
              const event = new ShowToastEvent({
                title: result.msg,
                variant: 'error',
                });
                this.dispatchEvent(event);
              
                try {
                     this.invoicesdata = result.InvoiceDetails;
                      console.log('this.invoicesdata--- ',this.invoicesdata);
                }
                catch (e) {
                     console.error("An error occurred");
                }
               
              var totalinvoice1 = 0;
              this.invoicesarray = [];
                for (var i = 0; i < this.invoicesdata.length; i++)
                {
                  if (this.invoicesdata[i].InvoiceTotalValue != null) {
                    var invoicetotal1 = this.formatNumber(this.invoicesdata[i].InvoiceTotalValue.toFixed(2));
                    var invoicetotal = this.invoicesdata[i].InvoiceTotalValue.toFixed(2);
                    totalinvoice1 +=  parseFloat(invoicetotal);
                      console.log('totalinvoice1', totalinvoice1);
                   
                     
                    
                  }
                   
                  console.log('this.totalinvoice', this.totalinvoice);
               let inv = {};
               
                 inv={
	                        BillingDocNumber : this.invoicesdata[i].BillingDocNumber,
                            ackcheckbox:this.invoicesdata[i].ackcheckbox,
                            BillingDate : this.invoicesdata[i].BillingDate,
                             InvoiceTotalValue: invoicetotal1,
                             invoiceaccountid: this.invoicesdata[i].invoiceaccountid,
                            cancelledboolean: this.invoicesdata[i].cancelledboolean,
                              invoicecontentdocid: this.invoicesdata[i].invoicecontentdocid,
                              invoicecontentdocname: this.invoicesdata[i].invoicecontentdocname,
                             sfrecord: this.invoicesdata[i].sfrecord
                 }
                  
                    this.invoicesarray.push(inv);
                }
               this.totalinvoice = this.formatNumber(totalinvoice1.toFixed(2).toString());
              console.log('--  this.invoicesarray---', JSON.stringify(this.invoicesarray));
              console.log('result.lineItemList', result.lineItemList);
             this.lineitemdata = [];
              for (var i = 0; i < result.lineItemList.length; i++)
              {
                console.log('hi',result.lineItemList[i].SKU_Description__c);
                if (result.lineItemList[i].Quantity__c != null) {
                  var quantity = this.formatNumber(result.lineItemList[i].Quantity__c.toFixed(2));
               }
                if (result.lineItemList[i].Value_Number__c != null) {
                  
                  var value = this.formatNumber(result.lineItemList[i].Value_Number__c.toFixed(2));
                }
                 
                let pro = {};
                if (result.lineItemList[i].SKU_Code__c.startsWith('0')) {
                  var skucode = (result.lineItemList[i].SKU_Code__c * 1).toString();
                   console.log('skucode in if',skucode);
                }
                else {
                  var skucode = result.lineItemList[i].SKU_Code__c;
                   console.log('skucode in else',skucode);
                }
               
                pro = {
                         Id : result.lineItemList[i].Id,
	                        SKU_Code__c : skucode,
                            ProductName__c: result.lineItemList[i].SKU_Description__c,
                             Quantity__c: quantity,
                             UOM__c: result.lineItemList[i].UOM__c,
                             
                            Value_Number__c : value
                           
                             
                }
                  
                this.lineitemdata.push(pro);
                 console.log(' this.lineitemdata', this.lineitemdata);
                }
                
             // this.lineitemdata = result.salesList[0].Sales_Order_Line_Item__r;
              
                if(this.lineitemdata == '' ){
                    this.nodata = true;
                     console.log('this.nodata ', this.nodata);
                }
                 if(this.invoicesarray == '' ){
                    this.noinvoice = true;
                     console.log('this.noinvoice ', this.noinvoice);
                 }
              console.log('this.lineitemdata+++++ ', JSON.stringify(this.lineitemdata));
              
                this.isbrazil = result.IsBrazilUser;
                console.log('--is brazitl---', this.isbrazil);
                 console.log('invoicesdata+++++ ', JSON.stringify(this.invoicesdata));
               
               
                console.log('finaldata+++++ ',JSON.stringify(this.finaldata));
                this.error = undefined;
               
            })
            .catch(error => {
                console.log('----in error----' + JSON.stringify(error));
                this.error = error;
               // this.finaldata = undefined;
            });
    }
formatNumber(val){
    var x=val.toString();
    var dec=x.split('.');
    var lastThree = dec[0].substring(dec[0].length-3);
    var otherNumbers = dec[0].substring(0,dec[0].length-3);
    var res='0.00';
    if(dec[0].length>3){
        if(otherNumbers != '')
        lastThree = ',' + lastThree;
        res = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree;
        res=res+'.'+dec[1];
    }
    else{
        res=x;
    }
    return res;
}
    
   
    handleAcknowledgment(event) {
      this.Billinginvoice = event.target.value;
        console.log('this.Billinginvoice', this.Billinginvoice);
         
        setAcknowledgement({ Billinginvoiceid: this.Billinginvoice})
        .then(result => {
            console.log('success:- ');
            
           // this.doSearch();
            for (var i = 0; i < this.invoicesarray.length; i++) {
                if ( this.Billinginvoice == this.invoicesarray[i].BillingDocNumber)
                    this.invoicesarray[i].ackcheckbox = true;

            }
            
           
        })
        .catch(error => {
           // console.log('Errorured:- '+error.body.message);
        });
    }
    downloadinvoice(event)
    {
        
        this.contentdocid = event.target.dataset.value;
        window.location.href = '/uplpartnerportal/sfc/servlet.shepherd/document/download/' + this.contentdocid + '?operationContext=S1';
        console.log(' window.location.href--', window.location.href);
        // this.accid = event.target.dataset.value;
        //  this.billingid =  event.target.dataset.id;
        // console.log(' this.accid', this.accid);
        // console.log(' this.billingid', this.billingid);
        // if (this.accid != undefined) {
        //     downloadinvoice({ accid: this.accid , billingid: this.billingid})
        //         .then(result => {
        //             console.log('result', result);
        //             if (result == 'ERROR') {
        //                 const event = new ShowToastEvent({
        //                  title: 'PDF not Found',
        //                      variant: 'error',
        //                      });
        //                     this.dispatchEvent(event);
                        
        //             }
        //             else {
        //                 this.contentdoc = result;

        //             console.log('this.contentdoc', JSON.stringify(this.contentdoc));
        //             window.location.href = '/sfc/servlet.shepherd/document/download/' + this.contentdoc + '?operationContext=S1';
                        
        //             }
                    
        //         })
        //         .catch(error => {
        //             // console.log('Errorured:- '+error.body.message);
        //         });
       
            
        // }
        // else {
        //      const event = new ShowToastEvent({
        //         title: 'Account ID not Found',
        //         variant: 'error',
        //           });
        //       this.dispatchEvent(event);
        // }
            
      
      
    }

    
   
   
  
}