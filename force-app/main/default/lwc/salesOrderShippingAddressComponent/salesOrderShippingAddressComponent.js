import { LightningElement,api } from 'lwc';
import Shipment_Details from '@salesforce/label/c.Shipment_Details';
import Storage_Location_Uk from '@salesforce/label/c.Storage_Location_Uk';
import Shipping_Address_UK from '@salesforce/label/c.Shipping_Address_UK';
import Inco_Terms_UK from '@salesforce/label/c.Inco_Terms_UK';
import Ship_To_Party_Uk from '@salesforce/label/c.Ship_To_Party_Uk';
import Remark_Uk from '@salesforce/label/c.Remark_Uk';
import characters_UK from '@salesforce/label/c.characters_UK';
import storagelocUK12 from '@salesforce/label/c.storagelocUK12';

export default class SalesOrderShippingAddressComponent extends LightningElement {
    @api shippingloclist = [];
    @api incotermlist = [];
    @api incodefaultvalue;
    @api recordid ='';
    @api objectname ='';
    @api salesorederdata;
    divclass="slds-box boxstyle";
    textclass="labelstyle";
    shipdetailvalue="";
    shippingfulldata="";
    remarkvalue='';
    incovalue='';
    isdisabledtrue=false;
    storageLocation=storagelocUK12;
    required=true;

    label = {
        Shipment_Details,
        Storage_Location_Uk,
        Inco_Terms_UK,
        Ship_To_Party_Uk,
        Remark_Uk,
        characters_UK,
        storagelocUK12,
        Shipping_Address_UK,
    };

    connectedCallback(){
        console.log('incodefaultvalue=='+this.incodefaultvalue);
        if(this.objectname==='SalesOrder'){
            console.log('salesorederdata==='+JSON.stringify(this.salesorederdata));
           // this.incovalue=this.salesorederdata.Inco_Term__c;
            if(this.salesorederdata.Inco_Term__c && this.salesorederdata.Inco_Term__c!=''){
                this.incovalue=this.salesorederdata.Inco_Term__c;
            }
            else{
                this.incovalue=this.incodefaultvalue;
            }
            if(this.salesorederdata.Ship_To_Party__c){
                this.shipdetailvalue=this.salesorederdata.Ship_To_Party__c;
            }
            if(this.salesorederdata.Remarks__c){
                this.remarkvalue=this.salesorederdata.Remarks__c;
            }
           // this.shipdetailvalue=this.salesorederdata.Ship_To_Party__c;
           // this.remarkvalue=this.salesorederdata.Remarks__c;
            this.isdisabledtrue=true;
            if(this.shippingloclist){
                if(this.shipdetailvalue!='' && this.shipdetailvalue!=null){
                    if(this.shippingloclist.find(opt => opt.value === this.shipdetailvalue)!=null){
                        this.shippingfulldata=this.shippingloclist.find(opt => opt.value === this.shipdetailvalue).fulldata;
                    }
                }
            }
        }
        else{
            this.incovalue=this.incodefaultvalue;
            this.isdisabledtrue=false;
        }
    }
    @api
    checkmethodtofil(salesorederdata,objetname,shippingloclist){
        if(objetname==='SalesOrder'){
            this.isdisabledtrue=true;
            console.log('salesorederdata==='+JSON.stringify(salesorederdata));
            if(salesorederdata.Inco_Term__c && salesorederdata.Inco_Term__c!=''){
                this.incovalue=salesorederdata.Inco_Term__c;
            }
            else{
                this.incovalue=this.incodefaultvalue;
            }
            if(salesorederdata.Ship_To_Party__c){
                this.shipdetailvalue=salesorederdata.Ship_To_Party__c;
            }
            if(salesorederdata.Remarks__c){
                this.remarkvalue=salesorederdata.Remarks__c;
            }
           
            this.isdisabledtrue=true;
            if(this.shipdetailvalue!='' && this.shipdetailvalue!=null){
                this.shippingfulldata=shippingloclist.find(opt => opt.value === this.shipdetailvalue).fulldata;
            }
        }else{
            this.incovalue=this.incodefaultvalue;
            this.isdisabledtrue=false;
        }

    }
    @api
    iseditcalled(){
        if(this.salesorederdata.Order_Status__c ==='Draft' ||  this.salesorederdata.Order_Status__c ==='Rejected'){
            this.isdisabledtrue=false;
        }
        else{
            this.isdisabledtrue=true;
        }
    }

    @api
    methodToChangeColorship(istrue){
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
    iscomboclick(){
        //alert('click');
        if(this.divclass!='slds-box boxstylecolored'){
            this.divclass="slds-box boxstylecolored";
            this.textclass="labelstylecolored";
        }
        this.dispatchEvent(new CustomEvent('clickoncombo'));
    }

    handleChange(event) {
        var type=event.target.dataset.type;
        if(type==='incoterm'){
            this.iscomboclick();
            this.incovalue=event.detail.value;
        }
        else if(type==='shiptoparty'){
            this.iscomboclick();
            this.shipdetailvalue=event.detail.value;
            this.shippingfulldata=event.target.options.find(opt => opt.value === event.detail.value).fulldata;
            //this.shippingfulldata=event.target.options.find(opt => opt.value === event.detail.value).label;
        }
        else if(type==='remark'){
            this.remarkvalue=event.detail.value;
        }
    }

    @api
    methodTogetvaluesship(OrderStatus){
        var iscall=false;
        if(OrderStatus==='Submitted'){
            this.required = true;
           /* Promise.resolve().then(() => {
                const inputEle = this.template.querySelector('lightning-combobox');
                inputEle.reportValidity();
            });*/
            Promise.resolve().then(() => {
                const allValid = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
                }, true);
                if (allValid) {
                    iscall=true;
                } else {
                    iscall=false;
                }
            });
            
               console.log('iscall====>>>>>>'+this.shipdetailvalue+'   ++++'+this.incovalue);
            if(this.shipdetailvalue==''){
                iscall=false; 
            }else if(this.incovalue==''){
                iscall=false; 
            }
            else{
                iscall=true;
            }
           
        }
        else{
            this.required = false;
            Promise.resolve().then(() => {
                const allValid = [...this.template.querySelectorAll('lightning-combobox')]
                .reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
                    }, true);
            });
            iscall=true;
        }
       
            if(iscall){
                var skuSelectedRowData={'Incotermvalue':this.incovalue,'shippingdetailsid':this.shipdetailvalue,'storageLocation':this.storageLocation,'remarkvalue':this.remarkvalue};
                iscall=skuSelectedRowData;
            }
            return iscall;
    }

    @api 
    clearmethod(){
       // this.incodefaultvalue='';
        this.incovalue=this.incodefaultvalue;
        this.shipdetailvalue='';
        this.shippingfulldata='';
        this.template.querySelectorAll('lightning-textarea').forEach(element => {
              element.value = null;
          });
    }
}