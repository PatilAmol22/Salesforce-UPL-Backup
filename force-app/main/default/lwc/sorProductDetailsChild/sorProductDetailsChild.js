import { LightningElement, api, track, wire} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi'; 
import getInvoiceProductDetails from '@salesforce/apex/SORProductDetailsChildController.getInvoiceProductDetails';
import getFullReturnInvoices from '@salesforce/apex/SORProductDetailsChildController.getFullReturnInvoices';
import deleteRSOItem from '@salesforce/apex/SORProductDetailsChildController.deleteRSOItem';
import RSOLI_OBJECT from '@salesforce/schema/Return_Sales_Order_Line_Item__c';
//import CURRENCY_CODE from '@salesforce/schema/Return_Sales_Order_Line_Item__c.Currency__c';
import AT_AG from '@salesforce/schema/Return_Sales_Order_Line_Item__c.AT_AG__c';
import PRODUCT_DAMAGE from '@salesforce/schema/Return_Sales_Order_Line_Item__c.Product_Damaged__c';
import PACKAGING_CONDITION from '@salesforce/schema/Return_Sales_Order_Line_Item__c.Packing_Condition__c';
import PRODUCT_CONDITION from '@salesforce/schema/Return_Sales_Order_Line_Item__c.Product_Condition__c';
import SLOW_MOVING from '@salesforce/schema/Return_Sales_Order_Line_Item__c.Slow_Moving__c';
import PRODUCT_CONTENTION from '@salesforce/schema/Return_Sales_Order_Line_Item__c.Product_Contention__c';
import PRODUCT_REWORK from '@salesforce/schema/Return_Sales_Order_Line_Item__c.Product_can_be_reworked__c';

import PleaseWait from '@salesforce/label/c.Please_wait';
import ErrorT from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Warning from '@salesforce/label/c.Warning';
import FailToCreateRecord from '@salesforce/label/c.Failed_To_Create_Record';
import NoRecordsFound from '@salesforce/label/c.No_Records_Found';
import Select_Account_First from '@salesforce/label/c.Select_Account_First';
import Select_Invoice from '@salesforce/label/c.Select_Invoice';
import Select_Product from '@salesforce/label/c.Select_Product';
import Currency_Not_Found from '@salesforce/label/c.Currency_Not_Found';
import Unit_value_should_be_greater_than_zero from '@salesforce/label/c.Unit_value_should_be_greater_than_zero';
import Total_value_should_be_greater_than_zero from '@salesforce/label/c.Total_value_should_be_greater_than_zero';
import Expire_Date_Not_Found from '@salesforce/label/c.Expire_Date_Not_Found';
import Volume_should_be_greater_than_zero from '@salesforce/label/c.Volume_should_be_greater_than_zero';
import Select_At_AG from '@salesforce/label/c.Select_At_AG';
import Select_Product_Damage from '@salesforce/label/c.Select_Product_Damage';
import Select_Packaging_Condition from '@salesforce/label/c.Select_Packaging_Condition';
import Select_Product_Condition from '@salesforce/label/c.Select_Product_Condition';
import Fail_To_Delete_Record from '@salesforce/label/c.Fail_To_Delete_Record';
import Record_Deleted_Successfully from '@salesforce/label/c.Record_Deleted_Successfully';
import value_should_be_less_than_or_equal_to from '@salesforce/label/c.value_should_be_less_than_or_equal_to';
import Can_not_use_this_Item_Volume_limit_exceed from '@salesforce/label/c.Can_not_use_this_Item_Volume_limit_exceed';
import Record_Details_Not_Found from '@salesforce/label/c.Record_Details_Not_Found';
import Failed_To_Get_Record_Details from '@salesforce/label/c.Failed_To_Get_Record_Details';
import Products_Details from '@salesforce/label/c.Products_Details';
import ADD from '@salesforce/label/c.Add';
import Invoice from '@salesforce/label/c.Invoice';
import Product_Code from '@salesforce/label/c.Product_Code';
import Product_Name from '@salesforce/label/c.Product_Name';
import Volume_KG_LT from '@salesforce/label/c.Volume_KG_LT';
import Unit_Value from '@salesforce/label/c.Unit_Value';
import Total_Value from '@salesforce/label/c.Total_Value';
import Expire_Date from '@salesforce/label/c.Expire_Date';
import Batch from '@salesforce/label/c.Batch';
import Action from '@salesforce/label/c.Action';
import Edit from '@salesforce/label/c.Edit';
import Delete from '@salesforce/label/c.Delete';
import Close from '@salesforce/label/c.Close';
import Product_Selection_Form from '@salesforce/label/c.Product_Selection_Form';
import Search_Invoice from '@salesforce/label/c.Search_Invoice';
import Search_Product from '@salesforce/label/c.Search_Product';
import Commercial from '@salesforce/label/c.Commercial';
import Currency from '@salesforce/label/c.Currency';
import Volume from '@salesforce/label/c.Volume';
import UOM from '@salesforce/label/c.UOM';
import At_AG from '@salesforce/label/c.At_AG';
import Product_Damaged from '@salesforce/label/c.Product_Damaged';
import Packaging_Conditions from '@salesforce/label/c.Packaging_Conditions';
import Product_Conditions from '@salesforce/label/c.Product_Conditions';
import Comments from '@salesforce/label/c.COMMENTS';
import Quality from '@salesforce/label/c.Quality';
import Slow_Moving from '@salesforce/label/c.Slow_Moving';
import Product_Contention from '@salesforce/label/c.Product_Contention';
import Product_Can_Be_Reworked from '@salesforce/label/c.Product_Can_Be_Reworked';
import Rework_Cost from '@salesforce/label/c.Rework_Cost';
import Write_Off from '@salesforce/label/c.Write_Off';
import Save from '@salesforce/label/c.Save';
import Cancel from '@salesforce/label/c.Cancel';
import You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return from '@salesforce/label/c.You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return';

export default class SorProductDetailsChild extends LightningElement {
    @api getValueFromParent = {};
    @track bShowModal = false;   
    @track productList = [];
    @track isProductList = false; 
    //@track currencyOptions = [];
    @track atAgOptions = [];
    @track prodDamageOptions = [];
    @track packgCondtnOptions = [];
    @track prodCondtnOptions = [];
    @track slowMovOptions = [];
    @track prodContentnOptions = [];
    @track prodReworkOptions = [];
    @track reworkYes = false;
    @track reworkNo = false;
    @track productObj = {};
    @track currentDate = '';
    @track accountId = '';
    @track invcSerarchField = 'Nota_Fiscal__c';  // default....
   // @track invcFilter = ' Sales_Org__r.Sales_Org_Code__c = \'5191\' AND CurrencyIsoCode != \'INR\' ORDER BY Name ASC ';
    @track invcFilter = ' Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC '; // remove CurrencyIsoCode check for  RITM0543661 GRZ(Javed Ahmed) 25-04-2023
    @track invcDisable = false;
    @track invcName = '';
    @track invcItemSerarchField = 'SKU_Description__c';  // default....
    @track invcItemFilter = ' Invoice__r.Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC ';
    @track invcItemName = '';
    @track showSpinner = false;
    @track isEdit = false;
    @track itemIndex = 0;
    @track maxVolume = 0;
    @track isDisable = true;
    @track productVolMap = new Map();
    @track qualityEdit = true;
    @track disableSave = true;
    @track fullInvcMap = new Map();
    @track showProduct = true;
    @track tempProductVolMap = new Map();

    label = {
        PleaseWait,
        ErrorT,
        Success,
        Warning,
        FailToCreateRecord,
        NoRecordsFound,
        Select_Account_First,
        Select_Invoice,
        Select_Product,
        Currency_Not_Found,
        Unit_value_should_be_greater_than_zero,
        Total_value_should_be_greater_than_zero,
        Expire_Date_Not_Found,
        Volume_should_be_greater_than_zero,
        Select_At_AG,
        Select_Product_Damage,
        Select_Packaging_Condition,
        Select_Product_Condition,
        Fail_To_Delete_Record,
        Record_Deleted_Successfully,
        value_should_be_less_than_or_equal_to,
        Can_not_use_this_Item_Volume_limit_exceed,
        Record_Details_Not_Found,
        Failed_To_Get_Record_Details,
        Products_Details,
        ADD,
        Invoice,
        Product_Code,
        Product_Name,
        Volume_KG_LT,
        Unit_Value,
        Total_Value,
        Expire_Date,
        Batch,
        Action,
        Edit,
        Delete,
        Close,
        Product_Selection_Form,
        Search_Invoice,
        Search_Product,
        Products_Details,
        Commercial,
        Currency,
        Volume,
        UOM,
        At_AG,
        Product_Damaged,
        Packaging_Conditions,
        Product_Conditions,
        Comments,
        Quality,
        Slow_Moving,
        Product_Contention,
        Product_Can_Be_Reworked,
        Rework_Cost,
        Write_Off,
        Save,
        Cancel,
        You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return
    };

    // getting the default record type id, if you dont' then it will get master
    @wire(getObjectInfo, { objectApiName: RSOLI_OBJECT})
    rsoMetadata;

    // now retriving the field picklist values of object
    /* @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: CURRENCY_CODE
        }
    )
    wiredCurrency({error, data}){
        if(data){
            this.currencyOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredCurrency error- ', error);
        }
    } */
 
    // now retriving the field picklist values of object
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: AT_AG
        }
    )
    wiredAG({error, data}){
        if(data){
            this.atAgOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredAG error- ', error);
        }
    }

    // now retriving the field picklist values of object
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: PRODUCT_DAMAGE
        }
    )
    wiredProdDamage({error, data}){
        if(data){
            this.prodDamageOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredProdDamage error- ', error);
        }
    }

    // now retriving the field picklist values of object
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: PRODUCT_CONDITION
        }
    )
    wiredProdCondtn({error, data}){
        if(data){
            this.prodCondtnOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredProdCondtn error- ', error);
        }
    }

    // now retriving the field picklist values of object
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: PACKAGING_CONDITION
        }
    )
    wiredPackCondtn({error, data}){
        if(data){
            this.packgCondtnOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredPackCondtn error- ', error);
        }
    }

    // now retriving the field picklist values of object
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: SLOW_MOVING
        }
    )
    wiredSloMo({error, data}){
        if(data){
            this.slowMovOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredSloMo error- ', error);
        }
    }

    // now retriving the field picklist values of object
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: PRODUCT_CONTENTION
        }
    )
    wiredProdConten({error, data}){
        if(data){
            this.prodContentnOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredProdConten error- ', error);
        }
    }

    // now retriving the field picklist values of object
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: PRODUCT_REWORK
        }
    )
    wiredProdRewrk({error, data}){
        if(data){
            this.prodReworkOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredProdRewrk error- ', error);
        }
    }

    /* javaScipt functions start */ 
    openModal() {    
        if(this.accountId == '' || this.accountId == null){
            this.showToastmessage(ErrorT,Select_Account_First,'Error');
        }
        else{
            let array = this.productList;
            if(array.length > 0){
                let obj = JSON.parse(JSON.stringify(array[0]));
                this.invcFilter = 'CurrencyIsoCode =\''+obj.currencyCode+'\' AND Sold_To_Party__c=\''+this.accountId+'\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC ';
            }
            else{
               // this.invcFilter = 'Sold_To_Party__c=\''+this.accountId+'\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\' AND CurrencyIsoCode != \'INR\' ORDER BY Name ASC ';
                this.invcFilter = 'Sold_To_Party__c=\''+this.accountId+'\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC '; // remove CurrencyIsoCode check for  RITM0543661 GRZ(Javed Ahmed) 25-04-2023
            }
            // to open modal window set 'bShowModal' tarck value as true
            if(this.invcName == '' || this.invcName == null){
                this.showProduct = false;
            }
            else{
                this.showProduct = true;
            }
            
            this.bShowModal = true;
        }
        
    }

    closeModal() {    
        // to close modal window set 'bShowModal' tarck value as false
        this.bShowModal = false;
        this.reworkYes = false;
        this.reworkNo = false;
        this.resetProductObj();
        this.invcName = '';
        this.invcItemName = '';
    }

    connectedCallback(){
        var today = new Date();
        this.currentDate = today.toISOString();
        //console.log('value from parent in Product Details Child - ', this.getValueFromParent);
        //this.productList = this.getValueFromParent;
        //console.log('this.productList in Product Details Child - ', this.productList);
        this.resetProductObj();
    }

    @api
    getRecordDetailsFromParent(obj,accId,flag,qualityFlag) {
        
        if(flag == true){
            this.isDisable = false;
            this.disableSave = false;
        }
        if(qualityFlag == false){
            this.disableSave = false;
        }
        this.qualityEdit = qualityFlag;
        this.productList = obj;  
        if(this.productList.length>0){
            this.isProductList = true;
            this.reInitializeProductVolMap();
            this.createUIProductVolMap();
        } 
        this.accountId = accId;
        if(this.accountId == '' || this.accountId == null){
            //this.invcFilter = ' Sales_Org__r.Sales_Org_Code__c = \'5191\' AND CurrencyIsoCode != \'INR\' ORDER BY Name ASC ';
            this.invcFilter = ' Sales_Org__r.Sales_Org_Code__c = \'5191\'   ORDER BY Name ASC '; // remove CurrencyIsoCode check for  RITM0543661 GRZ(Javed Ahmed) 25-04-2023
            this.fullInvcMap.clear();
        }
        else{
           // this.invcFilter = 'Sold_To_Party__c=\''+this.accountId+'\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\' AND CurrencyIsoCode != \'INR\' ORDER BY Name ASC ';
            this.invcFilter = 'Sold_To_Party__c=\''+this.accountId+'\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC '; // remove CurrencyIsoCode check for  RITM0543661 GRZ(Javed Ahmed) 25-04-2023
            
            if(this.isDisable == false){
                this.getFullInvoices();
            }
        }     
    }

    resetProductObj(){
        this.productObj = {"srNo": 0,"recId": "","sorId": "","invoiceId": "","invoiceName": "","productCode": "","productName": "","productDescription": "","batch": "","currencyCode": "","volume": 0,
        "unitValue": 0,"totalValue": 0,"expireDate": "","atAG": "","productDamage": "","packagingCondition": "","productCondition": "","comments": "","slowMoving": "","productContention": "",
        "productRework": "NA","reworkCost": 0,"writeOff": "","invoiceItemId":""};
    }

    triggerEvent(events){
        //create event
        const custEvent = new CustomEvent("getproductdetails",{
            detail: this.productList
        });

        // dispatch event
        this.dispatchEvent(custEvent);
    }

    @api
    getAccountId(strString) {
        //console.log('getAccountId - ', strString);
        this.accountId = strString;
        if(this.accountId == '' || this.accountId == null){
            //this.invcFilter = ' Sales_Org__r.Sales_Org_Code__c = \'5191\' AND CurrencyIsoCode != \'INR\' ORDER BY Name ASC ';
            this.invcFilter = ' Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC '; // remove CurrencyIsoCode check for  RITM0543661 GRZ(Javed Ahmed) 25-04-2023
            this.fullInvcMap.clear();
        }
        else{
           // this.invcFilter = 'Sold_To_Party__c=\''+this.accountId+'\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\' AND CurrencyIsoCode != \'INR\' ORDER BY Name ASC ';
            this.invcFilter = 'Sold_To_Party__c=\''+this.accountId+'\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC '; // remove CurrencyIsoCode check for  RITM0543661 GRZ(Javed Ahmed) 25-04-2023
            this.getFullInvoices();
        }
        //nik**
        //console.log('invoice filter - ', this.invcFilter);
    }

    getFullInvoices(){
        this.showSpinner = true;
        getFullReturnInvoices({accId : this.accountId})
        .then(result => {
            if(result.length>0){
                result.forEach(inv => {
                    this.fullInvcMap.set(inv,inv);
                });
            }
            this.showSpinner = false;
        })
        .catch(error => {
            this.showSpinner = false;
            console.log('getFullInvoices js method catch - ', error);
        })
    }

    handleChange(event){
        let obj = JSON.parse(JSON.stringify(this.productObj));
        //console.log('value in Order Details Child - ', obj);
        if(event.target.name == 'batch'){
            obj.batch = event.target.value;
        }
        else if(event.target.name == 'currencyCode'){
            obj.currencyCode = event.target.value;
        }
        else if(event.target.name == 'unitVal'){
            obj.unitValue = event.target.value;
        }
        else if(event.target.name == 'totalVal'){
            obj.totalValue = event.target.value;
        }
        else if(event.target.name == 'expDate'){
            obj.expireDate = event.target.value;
        }
        else if(event.target.name == 'atAg'){
            obj.atAG = event.target.value;
        }
        else if(event.target.name == 'prodDamage'){
            obj.productDamage = event.target.value;
        }
        else if(event.target.name == 'packCondtn'){
            obj.packagingCondition = event.target.value;
        }
        else if(event.target.name == 'prodCondtn'){
            obj.productCondition = event.target.value;
        }
        else if(event.target.name == 'comments'){
            obj.comments = event.target.value;
        }
        else if(event.target.name == 'sloMo'){
            obj.slowMoving = event.target.value;
        }
        else if(event.target.name == 'prodConten'){
            obj.productContention = event.target.value;
        }
        else if(event.target.name == 'prodRewrk'){
            obj.productRework = event.target.value;
            obj.writeOff = '';
            obj.reworkCost = 0;
            this.reworkToggle(event.target.value);
        }
        else if(event.target.name == 'reworkCost'){
            obj.reworkCost = event.target.value;
        }
        else if(event.target.name == 'writeOff'){
            obj.writeOff = event.target.value;
        }
        
        this.productObj = obj;
        //console.log('value in handleChange - ', this.productObj);
        /* //create event
        const custEvent = new CustomEvent("getproductdetails",{
            detail: event.target.value
        });

        // dispatch event
        this.dispatchEvent(custEvent); */
    }

    saveProduct(event){
        this.showSpinner = true;
        let flag = true;
        let volFlag = false;
        let agFlag = false;
        let pdFlag = false;
        let pcFlag = false;
        let prcFlag = false;
        let obj = JSON.parse(JSON.stringify(this.productObj));
        let element = this.template.querySelectorAll(".validt");
        
        if(obj.invoiceId == '' || obj.invoiceId == null){
            flag = false;
            this.showToastmessage(ErrorT,Select_Invoice,'Error');
        }
        else if(obj.invoiceItemId == '' || obj.invoiceItemId == null){
            flag = false;
            this.showToastmessage(ErrorT,Select_Product,'Error');
        }
        else if(obj.currencyCode == '' || obj.currencyCode == null){
            flag = false;
            this.showToastmessage(ErrorT,Currency_Not_Found,'Error');
        }
        else if(obj.unitValue <=0 || obj.unitValue == '' || obj.unitValue == null){
            flag = false;
            this.showToastmessage(ErrorT,Unit_value_should_be_greater_than_zero,'Error');
        }
        else if(obj.totalValue <=0 || obj.totalValue == '' || obj.totalValue == null){
            flag = false;
            this.showToastmessage(ErrorT,Total_value_should_be_greater_than_zero,'Error');
        }
        else if(obj.expireDate == '' || obj.expireDate == null){
            flag = false;
            this.showToastmessage(ErrorT,Expire_Date_Not_Found,'Error');
        }

        if(flag){
            element.forEach(function(item){
                let fieldValue=item.value;
                let fieldName=item.name;

                if(fieldName == 'volume'){
                    if(obj.volume <= 0 || obj.volume == '' || obj.volume == null){
                        volFlag = false;
                        item.setCustomValidity(Volume_should_be_greater_than_zero);
                    }
                    else{
                        volFlag = true;
                        item.setCustomValidity('');
                    }
                }
                else if(fieldName == 'atAg'){
                    if(obj.atAG == '' || obj.atAG == null){
                        agFlag = false;
                        item.setCustomValidity(Select_At_AG);
                    }
                    else{
                        agFlag = true;
                        item.setCustomValidity('');
                    }
                } 
                else if(fieldName == 'prodDamage'){
                    if(obj.productDamage == '' || obj.productDamage == null){
                        pdFlag = false;
                        item.setCustomValidity(Select_Product_Damage);
                    }
                    else{
                        pdFlag = true;
                        item.setCustomValidity('');
                    }
                } 
                else if(fieldName == 'packCondtn'){
                    if(obj.packagingCondition == '' || obj.packagingCondition == null){
                        pcFlag = false;
                        item.setCustomValidity(Select_Packaging_Condition);
                    }
                    else{
                        pcFlag = true;
                        item.setCustomValidity('');
                    }
                } 
                else if(fieldName == 'prodCondtn'){
                    if(obj.productCondition == '' || obj.productCondition == null){
                        prcFlag = false;
                        item.setCustomValidity(Select_Product_Condition);
                    }
                    else{
                        prcFlag = true;
                        item.setCustomValidity('');
                    }
                }  
                item.reportValidity();
            },this);
            this.showSpinner = false;
        }
        else{
            this.showSpinner = false;
        }

        if(flag && volFlag && agFlag && pdFlag && pcFlag && prcFlag){
            let array = this.productList;
            let count = 0;
            if(array.length > 0){
                let pdObj = JSON.parse(JSON.stringify(array[array.length - 1]));
                count = parseInt(pdObj.srNo);
            }
             
            let plist = [];
            plist = JSON.parse(JSON.stringify(this.productList));
            obj.srNo = count + 10;
            obj.accountId = this.accountId;
            
            if(this.isEdit){
                this.productObj = obj;
                plist[this.itemIndex] = this.productObj;
                //plist.splice(this.itemIndex, 0, this.productObj); //arr.splice(index, 0, item)..
            }
            else{
                //obj.recId = '';
                this.productObj = obj;
                plist.push(this.productObj);
                //console.log('push in update...');
            }
            
            this.productList = plist;
            this.reInitializeProductVolMap();
            this.isProductList = true;
            this.triggerEvent();
            this.closeModal();
            this.isEdit = false;
            this.itemIndex = 0;
            this.triggerInvoiceEvent(event,true);
            this.calculateReturnAmount();
            this.showSpinner = false;
        }
    }

    editProduct(event){
        let array = this.productList;
        let index = event.target.name;
        let prdRecId = event.target.value;
        let flag = true;
        let obj;
        this.isEdit = true;
        this.itemIndex = index;
        obj = JSON.parse(JSON.stringify(array[index])); 
        this.invcName = obj.invoiceName;
        this.invcItemName = obj.productName; //obj.productCode;
        this.reworkToggle(obj.productRework);
        obj.recId = prdRecId;
        let ivncItmId = obj.invoiceItemId;

        this.showSpinner = true;
        getInvoiceProductDetails({recId : ivncItmId})
            .then(result => {
                if(result){
                    if(result.maxVolume <= 0){
                        this.maxVolume = obj.volume;
                    }
                    else{
                        if(this.productVolMap.has(ivncItmId)){
                            let exVal = 0;
                            if(this.tempProductVolMap.has(ivncItmId)){
                                exVal = this.tempProductVolMap.get(ivncItmId);
                            }
                            flag = false;
                            let val = this.productVolMap.get(ivncItmId);
                            val = parseFloat(result.maxVolume) - parseFloat(val) + parseFloat(exVal);
                            val = val + parseFloat(obj.volume);
                            if(val <= 0){
                                this.maxVolume = 0;
                            }
                            else{
                                this.maxVolume = val;
                            }
                        }
                        if(flag == true){
                            this.maxVolume = result.maxVolume + parseFloat(obj.volume);
                        }
                    }
                }
                else{
                    this.showToastmessage(ErrorT,Record_Details_Not_Found,'Error');
                }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('editProduct getInvoiceProductDetails js method catch - ', error);
                this.showToastmessage(ErrorT,Failed_To_Get_Record_Details,'Error');
            })

        this.productObj = obj;
        
        this.openModal();
    }

    removeProduct(event){
        
        let array = this.productList;
        let index = event.target.name;
        let exObj = JSON.parse(JSON.stringify(array[index]));
        let prdRecId = event.target.value;
        let flag = true;
        let delay = 0;
        if(prdRecId.length>0){
            delay = 4000;
            this.showSpinner = true;
            flag = false;
            deleteRSOItem({recId : prdRecId})
            .then(result => {
                //console.log('deleteRSOItem result', result);
                if(result === 'success'){
                    flag = true;
                }
                else{
                    this.showToastmessage(ErrorT,Fail_To_Delete_Record,'Error');
                }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('deleteRSOItem js method catch - ', error);
                this.showToastmessage(ErrorT,Fail_To_Delete_Record,'Error');
            })
        }

        setTimeout(() => {
            if(flag){
                if (index > -1) {
                    array.splice(index, 1);
                }
                this.showToastmessage(Success,Record_Deleted_Successfully,'Success');
                let pList = JSON.parse(JSON.stringify(this.productList));
                pList = array;
                this.productList = pList;
                this.triggerEvent();
                this.calculateReturnAmount();
            }
            
            if(array.length == 0){
                this.isProductList = false;
                this.triggerInvoiceEvent(event,false);
                this.productVolMap.clear();
                this.tempProductVolMap();
            }
            else{
                this.reInitializeProductVolMap();
                
                if(prdRecId.length > 0 && this.tempProductVolMap.has(exObj.invoiceItemId)){
                    let exVal = this.tempProductVolMap.get(exObj.invoiceItemId);
                    exVal = parseFloat(exVal) - parseFloat(exObj.volume); 
                    if(exVal <= 0){
                        exVal = 0;
                    }
                    this.tempProductVolMap.set(exObj.invoiceItemId,(exVal).toFixed(2));
                }
            }
        }, delay);
        
    }

    reInitializeProductVolMap(){
        this.productVolMap.clear();
        //this.productList.filter(prd => prd.recId == '').forEach(data => {
        this.productList.forEach(data => {    
            if(this.productVolMap.has(data.invoiceItemId)){
                let val = this.productVolMap.get(data.invoiceItemId);
                val = parseFloat(val) + parseFloat(data.volume); 
                this.productVolMap.set(data.invoiceItemId,(val).toFixed(2));
            }
            else{
                this.productVolMap.set(data.invoiceItemId,parseFloat(data.volume).toFixed(2));
            }
        });
    }

    createUIProductVolMap(){
        this.tempProductVolMap.clear();
        this.productList.forEach(data => {
            if(this.tempProductVolMap.has(data.invoiceItemId)){
                let val = this.tempProductVolMap.get(data.invoiceItemId);
                val = parseFloat(val) + parseFloat(data.volume); 
                this.tempProductVolMap.set(data.invoiceItemId,(val).toFixed(2));
            }
            else{
                this.tempProductVolMap.set(data.invoiceItemId,parseFloat(data.volume).toFixed(2));
            }
        });
    }

    calculateReturnAmount(){
        let rtnAmt = 0;
        let plist = [];
        plist = JSON.parse(JSON.stringify(this.productList));
        if(plist.length>0){
            plist.forEach(function(item){
                rtnAmt = parseFloat(rtnAmt) + parseFloat(item.totalValue);
            },this);
        }

        const custEvent = new CustomEvent("getreturnamount",{
            detail: (rtnAmt).toFixed(2)
        });
        // dispatch event
        this.dispatchEvent(custEvent);
    }

    reworkToggle(strVal){
        if(strVal == 'Yes'){
            this.reworkYes = true;
            this.reworkNo = false;
        }
        else if(strVal == 'No'){
            this.reworkYes = false;
            this.reworkNo = true;
        }
        else{
            this.reworkYes = false;
            this.reworkNo = false;
        }
    }

    handleVolumeChange(event){
        let obj = JSON.parse(JSON.stringify(this.productObj));
        if(event.target.value == '' || event.target.value == null || event.target.value.length == 0){
            obj.volume = parseFloat(0);
        }
        else{
            obj.volume = parseFloat(event.target.value);
        }
       
        if(obj.volume > parseFloat(this.maxVolume)){
            obj.volume = 0;
            event.target.value = 0;
            event.target.setCustomValidity(value_should_be_less_than_or_equal_to +' '+this.maxVolume);            
        }
        else{
            event.target.setCustomValidity('');
            if(obj.unitValue == '' || obj.unitValue == null){
                obj.unitValue = 0;
            }
            
            obj.totalValue = (parseFloat(obj.volume) * parseFloat(obj.unitValue)).toFixed(2);
        }
        event.target.reportValidity();        
        this.productObj = obj;
    }

    handleReworkChange(event){
        if(event.target.value == 'Yes'){
            this.reworkYes = true;
            this.reworkNo = false;
        }
        else if(event.target.value == 'No'){
            this.reworkYes = false;
            this.reworkNo = true;
        }
        else{
            this.reworkYes = false;
            this.reworkNo = false;
        }
        this.handleChange(event);
    }

    triggerInvoiceEvent(event,flag){
        //create event
        const custEvent = new CustomEvent("getinvoiceselection",{
            detail: flag
        });

        // dispatch event
        this.dispatchEvent(custEvent);
    }

    handleInvoiceSelected(event){
        if(this.fullInvcMap.has(event.detail.recId)){
            this.showToastmessage(ErrorT,You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return,'Error');
        }
        else{
            let obj = JSON.parse(JSON.stringify(this.productObj));
            obj.invoiceId = event.detail.recId;
            obj.invoiceName = event.detail.recName;
            this.productObj = obj;
            this.invcName = event.detail.recName;
            this.invcItemFilter = 'Invoice__c =\''+event.detail.recId+'\' AND Invoice__r.Sales_Org__r.Sales_Org_Code__c = \'5191\'  ORDER BY Name ASC ';
            this.showProduct = true;
            //this.triggerInvoiceEvent(event,true); // event trigger to pass value to Order details lwc...to disable account selection....
            //console.log('this.invcItemFilter - ', this.invcItemFilter);
        }
    }

    handleRemoveInvoice(event){
        //console.log('handleRemoveInvoice - ', event.detail.recId);
        let obj = JSON.parse(JSON.stringify(this.productObj));
        obj.invoiceId = '';
        obj.invoiceName = '';
        this.productObj = obj;
        this.invcName = '';
        this.maxVolume = 0;
        this.productVolMap.clear();
        this.showProduct = false;
        /* setTimeout(() => {
            this.showProduct = true;
        }, 1000); */
        //this.invcItemName = '';
        this.handleRemoveInvoiceItem(event);
        //this.triggerInvoiceEvent(event,false);
        //console.log('handleRemoveInvoice - ', this.productObj);
    }

    handleInvoiceItemSelected(event){
        let obj = JSON.parse(JSON.stringify(this.productObj));
        obj.invoiceItemId = event.detail.recId;
        //obj.productCode = event.detail.recName;
        obj.productName = event.detail.recName;
        this.productObj = obj;
        this.invcItemName = event.detail.recName;
        this.getProductDetails(event.detail.recId);
    }

    handleRemoveInvoiceItem(event){
        let obj = JSON.parse(JSON.stringify(this.productObj));
        obj.invoiceItemId = '';
        //obj.productCode = '';
        obj.productName = '';
        this.productObj = obj;
        this.invcItemName = '';
        this.resetProductObj();
        this.maxVolume = 0;
    }

    getProductDetails(ivncItmId){
        this.showSpinner = false;
        let flag = true;
        getInvoiceProductDetails({recId : ivncItmId})
            .then(result => {
                //console.log('getProductDetails map -', this.productVolMap);
                if(result){
                    if(result.maxVolume <= 0){
                        this.showToastmessage(ErrorT,Can_not_use_this_Item_Volume_limit_exceed,'Error');
                    }
                    else{
                        if(this.productVolMap.has(ivncItmId)){
                            let exVal = 0;
                            if(this.tempProductVolMap.has(ivncItmId)){
                                exVal = this.tempProductVolMap.get(ivncItmId);
                            }
                            flag = false;
                            let val = this.productVolMap.get(ivncItmId);
                            val = parseFloat(result.maxVolume) - parseFloat(val) + parseFloat(exVal);
                            //console.log('val map -', val);
                            if(val <= 0){
                                this.showToastmessage(ErrorT,Can_not_use_this_Item_Volume_limit_exceed,'Error');
                            }
                            else{
                                this.productObj = result;
                                this.maxVolume = val;
                            }
                        }
                        if(flag == true){
                            this.productObj = result;
                            this.maxVolume = result.maxVolume;
                        }
                        //console.log('this.maxVolume -', this.maxVolume);
                    }
                }
                else{
                    this.showToastmessage(ErrorT,Record_Details_Not_Found,'Error');
                }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('getInvoiceProductDetails js method catch - ', error);
                this.showToastmessage(ErrorT,Failed_To_Get_Record_Details,'Error');
            })
    }

    showToastmessage(title,message,varient){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    } 
   
}