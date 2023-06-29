import { LightningElement , track , wire , api} from 'lwc';
import viewOrderSummary from '@salesforce/apex/Poland_SalesOrder_Controller.viewOrderSummary';
import getOrderFields1 from '@salesforce/apex/Poland_SalesOrder_Controller.getOrderFields1';
import getUserInfo from '@salesforce/apex/Poland_SalesOrder_Controller.getUserInfo';
import VIEW_ORDER from '@salesforce/label/c.VIEW_ORDER';  
import Order_No from '@salesforce/label/c.Order_No';  
import SAP_Order_Number from '@salesforce/label/c.SAP_Order_Number'; 
import Select_Inco_Term  from '@salesforce/label/c.Select_Inco_Term'; 
import Multiple  from '@salesforce/label/c.Multiple'; 
//Added BY Paresh Sondigara : CR#152 : PO & Delivery date
import Delivery_Date  from '@salesforce/label/c.Delivery_Date'; 
import Purchase_Order_Date from '@salesforce/label/c.Purchase_Order_Date';
import UPL_is_not_responsible_for_late_delivery  from '@salesforce/label/c.UPL_is_not_responsible_for_late_delivery'; 


import Step  from '@salesforce/label/c.Step'; 
import Account_Credit_Summary  from '@salesforce/label/c.Account_Credit_Summary'; 
import Account_Name  from '@salesforce/label/c.Account_Name'; 
import SAP_Code  from '@salesforce/label/c.SAP_Code'; 
import Total_Credit_Limit  from '@salesforce/label/c.Total_Credit_Limit'; 
import Credit_Limit_Used  from '@salesforce/label/c.Credit_Limit_Used'; 
import Credit_Limit_Balance  from '@salesforce/label/c.Credit_Limit_Balance'; 


import Total_Outstanding  from '@salesforce/label/c.Total_Outstanding'; 
import Net_Overdue  from '@salesforce/label/c.Net_Overdue'; 
import Order_Summary  from '@salesforce/label/c.Order_Summary'; 
import SKU  from '@salesforce/label/c.SKU'; 
import UOM  from '@salesforce/label/c.UOM'; 
import Base_Price  from '@salesforce/label/c.Base_Price'; 
import Quantity  from '@salesforce/label/c.Quantity'; 
import Pallet_Size  from '@salesforce/label/c.Pallet_Size'; 
import Early  from '@salesforce/label/c.Early'; 
import Order  from '@salesforce/label/c.Order';

import Big  from '@salesforce/label/c.Big';
import Volume  from '@salesforce/label/c.Volume';
import Manual_Discount  from '@salesforce/label/c.Manual_Discount'; 
import Logistic_Discount  from '@salesforce/label/c.Logistic_Discount';
import Final_Price  from '@salesforce/label/c.Final_Price';
import Net_Value  from '@salesforce/label/c.Net_Value';
import Payment_Terms  from '@salesforce/label/c.Payment_Terms';
import Total_Net_Price  from '@salesforce/label/c.Total_Net_Price'; 
import Litre  from '@salesforce/label/c.Litre';
import KG  from '@salesforce/label/c.KG';
import Total_Amount  from '@salesforce/label/c.Total_Amount';
import Shipping_Address  from '@salesforce/label/c.Shipping_Address';
import PO_Number  from '@salesforce/label/c.PO_NUMBER'; 
import This_order_value_is_exclusive_of_taxes_Taxes_are_applicable_as_extra  from '@salesforce/label/c.This_order_value_is_exclusive_of_taxes_Taxes_are_applicable_as_extra';
import Remark  from '@salesforce/label/c.Remark';


import Note  from '@salesforce/label/c.Note';
import Only_128_character_allow  from '@salesforce/label/c.Only_128_character_allow';
// import Remark  from '@salesforce/label/c.Remark ';




export default class ViewOrderSummary extends LightningElement {
@track OrderNo = '';
@track salesOrder =  [];
@track salesOrderList =  [];
@api recordId;
@track Incoterm = '';
@track SalesOrderNo = '';
@track Remarks_Long='';
@track SAP_Order_Number='';
@track PONumber='';
//Added By Paresh Sondigara : CR#152  : PO & Delivery Date
@track PODate='';
@track shippingLocation='';
@track Billing_Street_1='';
@track Billing_Street_2='';
@track Billing_Street_3='';
@track Billing_Street_4='';
@track Billing_Street_5='';
@track Billing_Street_6='';
@track City='';
@track Pincode='';
@track State='';
@track Region='';
@track Country='';
@track b1=false;
@track b2=false;
@track b3=false;
@track b4=false;
@track b5=false;
@track b6=false;
@track ci=false;
@track p=false;
@track s=false;
@track r=false;
@track co=false;
@track accid='';
@track distributorName='';
@track sapCode='';
@track creditLimit;
@track internalCredit;
@track creditUsed;
@track creditBalance;
@track paymentOutstanding;
@track greaterThan90;
@track ltrDisplay=false;
@track kgDisplay=false;
@track qun_ltr1;
@track qun_ltr_amt1 ;
@track qun_kg1 ;
@track qun_kg_amt1 ;
@track orderFieldsData=[];
@track Gross_Net_Value;
@track createdfrom;
@track isSfdcCreated = false;
@track isSAPCreated = false;
@track UserRole;
@track showCreditLimit = false;
label = {
    VIEW_ORDER,
    Order_No,
    SAP_Order_Number,
    Select_Inco_Term,
    Step,
	Account_Credit_Summary,
	Account_Name,
	SAP_Code,
	Total_Credit_Limit,
	Credit_Limit_Used,
	Credit_Limit_Balance,
	Total_Outstanding,
	Net_Overdue,
	Order_Summary,
	SKU,
	UOM,
	Base_Price,
	Quantity,
	Pallet_Size,
	Early,
	Order,
	Big,
	Volume,
	Manual_Discount,
	Logistic_Discount,
	Final_Price,
	Net_Value,
	Payment_Terms,
	Total_Net_Price,
	Litre,
	KG,
	Total_Amount,
	Shipping_Address,
	PO_Number,
	This_order_value_is_exclusive_of_taxes_Taxes_are_applicable_as_extra,
	Remark,
	Note,
	Only_128_character_allow,
    Multiple,
    //Added BY Paresh Sondigara : CR#152 : PO & Delivery date
    Delivery_Date,
    Purchase_Order_Date,
    UPL_is_not_responsible_for_late_delivery
};

@wire(getUserInfo)
WiredUser({ error, data }){
    if(data){
        this.UserRole=data[0].Community_Role__c;
        console.log('User Role---'+this.UserRole);
        if(this.UserRole==2){
            this.showCreditLimit=false;
        }else{
            this.showCreditLimit=true;
        }
    }
}

@wire(viewOrderSummary,{ recordId : '$recordId'})
wiredOrders({ error, data }) {
    if (data) {
        console.log('wired function');
        console.log('Data----'+JSON.stringify(data));
        this.salesOrder = data;
        //console.log('Data Sales order----'+data.soObj);
        //console.log('Data Sales order List----',data[0].soiList);
        this.salesOrderList = data[0].soiList;
        // console.log('Data Sales order List---->>',this.salesOrderList);
        this.createdfrom = this.salesOrder[0].soObj.CreatedFrom__c;

        //console.log('qwewqwewqr---'+JSON.stringify(this.salesOrder[0].soObj.Ship_To_Party__r.Billing_Street_3__c));
        //console.log('qwewqwewqr---'+JSON.stringify(this.salesOrder[0].soObj.Name));
        //console.log('qwewqwewqr---'+JSON.stringify(this.salesOrder[0].soObj.Inco_Term_Code__c));

        this.accid=this.salesOrder[0].soObj.Sold_to_Party__c;
        this.SalesOrderNo = this.salesOrder[0].soObj.Name;

        console.log('Incot term description checking '+this.salesOrder[0].soObj.Inco_Term__c);
        if(this.salesOrder[0].soObj.Inco_Term__c!=undefined){
            this.Incoterm = this.salesOrder[0].soObj.Inco_Term__r.IncoTerm_Desc__c ;
        }
            
        
        

        this.SAP_Order_Number=this.salesOrder[0].soObj.SAP_Order_Number__c;
        this.PONumber=this.salesOrder[0].soObj.PONumber__c;
        this.Remarks_Long=this.salesOrder[0].soObj.Remarks_Long__c;
        //Added BY Paresh Sondigara : CR#152 : PO & Delivery date
        this.PODate=this.salesOrder[0].soObj.Purchase_Order_Date__c;
        console.log('this.createdfrom '+this.createdfrom);
        if(this.createdfrom=='SFDC'){
            this.Gross_Net_Value=this.salesOrder[0].soObj.Gross_Net_Value__c;
            this.isSfdcCreated = true;
            // this.isSAPCreated = false;
        }
        if(this.createdfrom=='SAP'){
            // this.isSfdcCreated = false;
            this.isSAPCreated = true;
            this.Gross_Net_Value=this.salesOrder[0].soObj.Total_Amount__c;
        }


        console.log('@@@@ Inshipping location '+this.salesOrder[0].soObj.Ship_To_Party__c);
        if(this.salesOrder[0].soObj.Ship_To_Party__c!=undefined){
            this.shippingLocation=this.salesOrder[0].soObj.Ship_To_Party__r.Location_Name__c;

            this.Billing_Street_1=this.salesOrder[0].soObj.Ship_To_Party__r.Billing_Street_1__c;

            
    
            console.log('this.Billing_Street_1-->',this.Billing_Street_1);
            if(this.Billing_Street_1 !=undefined){
                this.b1=true;
            }
            this.Billing_Street_2=this.salesOrder[0].soObj.Ship_To_Party__r.Billing_Street_2__c;
            console.log('this.Billing_Street_2-->',this.Billing_Street_2);
            if(this.Billing_Street_2 !=undefined){
                this.b2=true;
            }
            this.Billing_Street_3=this.salesOrder[0].soObj.Ship_To_Party__r.Billing_Street_3__c;
            console.log('this.Billing_Street_3-->'+this.Billing_Street_3);
            if(this.Billing_Street_3 !=undefined){
                this.b3=true;
            }
            this.Billing_Street_4=this.salesOrder[0].soObj.Ship_To_Party__r.Billing_Street_4__c;
            console.log('this.Billing_Street_4-->'+this.Billing_Street_4);
            if(this.Billing_Street_4 !=undefined){
                this.b4 = true;
            }
            this.Billing_Street_5=this.salesOrder[0].soObj.Ship_To_Party__r.Billing_Street_5__c;
            console.log('this.Billing_Street_5-->',this.Billing_Street_5);
            if(this.Billing_Street_5 !=undefined){
                this.b5=true;
            }
            this.Billing_Street_6=this.salesOrder[0].soObj.Ship_To_Party__r.Billing_Street_6__c;
            console.log('this.Billing_Street_6-->',this.Billing_Street_6);
            if(this.Billing_Street_6 !=undefined){
                this.b6=true;
            }
            this.City=this.salesOrder[0].soObj.Ship_To_Party__r.City__c;
            console.log('this.City-->',this.City);
            if(this.City !=undefined){
                this.ci=true;
            }
            this.Pincode=this.salesOrder[0].soObj.Ship_To_Party__r.Pincode__c;
            console.log('this.Pincode-->',this.Pincode);
            if(this.Pincode !=undefined){
                this.p=true;
            }
            this.State=this.salesOrder[0].soObj.Ship_To_Party__r.State__c;
            console.log('this.State-->',this.State);
            if(this.State !=undefined){
                this.s=true;
            }
            this.Region=this.salesOrder[0].soObj.Ship_To_Party__r.Region__c;
            console.log('this.Region-->',this.Region);
            if(this.Region !=undefined){
                this.r=true;
            }
            this.Country=this.salesOrder[0].soObj.Ship_To_Party__r.Country__c;
            console.log('this.Country-->',this.Country);
            if(this.Country !=undefined){
                this.co=true;
            }
        }


       

        this.error = undefined;

        var ordItem = this.salesOrderList;
       var i;
       var qun_ltr = 0;
       var qun_ltr_amt = 0;
       var qun_kg = 0;
       var qun_kg_amt = 0;
       
       
       
       for (i = 0; i < ordItem.length; i++) {
           var obj = new Object(ordItem[i]);
           
           if(obj.UOM__c.toUpperCase() == 'L'){
               
               qun_ltr = qun_ltr + parseFloat(obj.Quantity__c);
               this.qun_ltr1=qun_ltr;
                if(this.createdfrom=='SFDC'){
                    qun_ltr_amt = qun_ltr_amt + parseFloat(obj.FinalPrice__c);
                }else{
                    qun_ltr_amt = qun_ltr_amt + parseFloat(obj.Price__c);
                }
                
               
               
               this.qun_ltr_amt1=qun_ltr_amt;
           }//end of Liter
           else if(obj.UOM__c.toUpperCase() == 'KG'){
               qun_kg = qun_kg + parseFloat(obj.Quantity__c);
               this.qun_kg1=qun_kg;
               if(this.createdfrom=='SFDC'){
               qun_kg_amt = qun_kg_amt + parseFloat(obj.FinalPrice__c);
               }else{
                qun_kg_amt = qun_kg_amt + parseFloat(obj.Price__c);
               }
               this.qun_kg_amt1=qun_kg_amt;
           }
       }
       console.log('@@@qun_ltr--',qun_ltr);
       console.log('@@@qun_ltr_amt--',qun_ltr_amt);
       console.log('@@@qun_kg--',qun_kg);
       console.log('@@@qun_kg_amt--',qun_kg_amt);
       
       if(qun_ltr_amt>0){
        this.ltrDisplay=true;
       }

       if(qun_kg_amt>0){
        this.kgDisplay=true;
       }

    } else if (error) {
        this.error = error;
        this.OrderNo = undefined;
    }
}

@wire(getOrderFields1,{ accId : '$accid'})
wiredOrdersFields({ error, data }) {
    if (data) {
    this.orderFieldsData=data;
        console.log('this.orderFieldsData-->',this.orderFieldsData);
        console.log('this.orderFieldsData-->',this.orderFieldsData.DistributorData);

        this.distributorName=this.orderFieldsData.DistributorData.distributorName;
        // console.log('this.distributorName-->',this.orderFieldsData.DistributorData.distributorName);
        this.sapCode=this.orderFieldsData.DistributorData.sapCode;
        // console.log('this.sapCode-->',this.orderFieldsData.DistributorData.sapCode);
        this.creditLimit=this.orderFieldsData.DistributorData.creditLimit;
        // console.log('this.creditLimit-->',this.orderFieldsData.DistributorData.creditLimit);
        this.internalCredit=this.orderFieldsData.DistributorData.internalCredit;
        // console.log('this.internalCredit-->',this.orderFieldsData.DistributorData.internalCredit);
        this.creditUsed=this.orderFieldsData.DistributorData.creditUsed;
        // console.log('this.creditUsed-->',this.orderFieldsData.DistributorData.creditUsed);
        this.creditBalance=this.orderFieldsData.DistributorData.creditBalance;
        // console.log('this.creditBalance-->',this.orderFieldsData.DistributorData.creditBalance);
        this.paymentOutstanding=this.orderFieldsData.DistributorData.paymentOutstanding;
        // console.log('this.paymentOutstanding-->',this.orderFieldsData.DistributorData.paymentOutstanding);
        this.greaterThan90=this.orderFieldsData.DistributorData.greaterThan90;
        // console.log('this.greaterThan90-->',this.orderFieldsData.DistributorData.greaterThan90);

    }else if (error) {
        this.error = error;
    }
}
    
}