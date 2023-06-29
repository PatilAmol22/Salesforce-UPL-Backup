import { LightningElement,api, track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getAccountDetails from '@salesforce/apex/SORTabSectionChildController.getAccountDetails';
import getInvoicesAndDeposite from '@salesforce/apex/SORTabSectionChildController.getInvoicesAndDeposite';
import getOrderTypes from '@salesforce/apex/SORTabSectionChildController.getOrderTypes';
import deleteCustomerService from '@salesforce/apex/SORTabSectionChildController.deleteCustomerService';
import deleteSAPOrder from '@salesforce/apex/SORTabSectionChildController.deleteSAPOrder';
import checkInvoiceFullReturn from '@salesforce/apex/SORTabSectionChildController.checkInvoiceFullReturn';
import checkBalanceQuantity from '@salesforce/apex/SORTabSectionChildController.checkBalanceQuantity';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi'; 
import RSO_OBJECT from '@salesforce/schema/Return_Sales_Order__c';

import Proceed_with_Return from '@salesforce/schema/Return_Sales_Order__c.Proceed_with_Return__c';
import Necessary_Technical_Inspection from '@salesforce/schema/Return_Sales_Order__c.Necessary_Technical_Inspection__c';
import Logistics_OperatorEmail from '@salesforce/schema/Return_Sales_Order__c.Logistics_Operator_Email__c';

import PleaseWait from '@salesforce/label/c.Please_wait';
import ErrorT from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Warning from '@salesforce/label/c.Warning';
import FailToCreateRecord from '@salesforce/label/c.Failed_To_Create_Record';
import NoRecordsFound from '@salesforce/label/c.No_Records_Found';
import Fail_To_Delete_Record from '@salesforce/label/c.Fail_To_Delete_Record';
import Error_Occured_While_Deleting_Record from '@salesforce/label/c.Error_Occured_While_Deleting_Record';
import Record_Deleted_Successfully from '@salesforce/label/c.Record_Deleted_Successfully';
import Customer_Details from '@salesforce/label/c.CUSTOMER_DETAILS';
import Customer_Code from '@salesforce/label/c.Customer_Code';
import CNPJ_CPF from '@salesforce/label/c.CNPJ_CPF';
import Contact from '@salesforce/label/c.Contact';
import Email from '@salesforce/label/c.Email';
import Cost_Center from '@salesforce/label/c.Cost_center';
import Address from '@salesforce/label/c.Address';
import Postal_Code from '@salesforce/label/c.Postal_Code';
import State from '@salesforce/label/c.State';
import Branch from '@salesforce/label/c.Branch';
import Farm from '@salesforce/label/c.Farm';
import Suburb from '@salesforce/label/c.SUBURB';
import City from '@salesforce/label/c.City';
import Phone_Number from '@salesforce/label/c.Phone_Number';
import Commercial_Workflow_Approval from '@salesforce/label/c.Commercial_Workflow_Approval';
import Sales_District_Manager from '@salesforce/label/c.Sales_District_Manager';
import Sales_Office_Manager from '@salesforce/label/c.Sales_Office_Manager';
import Sales_Director from '@salesforce/label/c.Sales_Director';
import Return_Details from '@salesforce/label/c.Return_Details';
import Quality_Assessment from '@salesforce/label/c.Quality_Assessment';
import Return_Amount from '@salesforce/label/c.Return_Amount';
import Proceed_With_Return from '@salesforce/label/c.Proceed_With_Return';
import Necessary_TI from '@salesforce/label/c.Necessary_Technical_Inspection';
import Inspection_Date from '@salesforce/label/c.Inspection_Date';
import Cost_QA from '@salesforce/label/c.Cost_QA';
import Contention from '@salesforce/label/c.Contention';
import Logistics from '@salesforce/label/c.LOGISTICS';
import Estimated_Collection_Date from '@salesforce/label/c.ESTIMATED_COLLECTION_DATE';
import Logistics_Operator_Email from '@salesforce/label/c.Logistics_Operator_Email';
import Actual_Collection_Date from '@salesforce/label/c.Actual_Collection_Date';
import Date_of_Submission_To_Logistics_Partner from '@salesforce/label/c.Date_of_Submission_To_Logistics_Partner';
import Closing_Date from '@salesforce/label/c.Closing_Date';
import Customer_Service from '@salesforce/label/c.Customer_Service';
import Billing_Doc from '@salesforce/label/c.Billing_Doc';
import Invoice from '@salesforce/label/c.Invoice';
import Customer_Invoice from '@salesforce/label/c.Customer_invoice';
import Return_Sub_Type from '@salesforce/label/c.Return_Sub_Type';
import Action from '@salesforce/label/c.Action';
import Add from '@salesforce/label/c.Add';
import Delete from '@salesforce/label/c.Delete';
import SAP_Order_Number from '@salesforce/label/c.SAP_Order_Number';
import Select_an_Email from '@salesforce/label/c.Select_an_Email';
import Send_to_Material_Assessment from '@salesforce/label/c.Send_to_Material_Assessment';
import Save from '@salesforce/label/c.Save';
import Cancel from '@salesforce/label/c.Cancel';
import Close from '@salesforce/label/c.Close';
import Invoices_Not_Found from '@salesforce/label/c.Invoices_Not_Found';
import Select_Invoice from '@salesforce/label/c.Select_Invoice';
import Error_Occurred_While_Getting_Order_Types from '@salesforce/label/c.Error_Occurred_While_Getting_Order_Types';
import Order_Types_Not_Found from '@salesforce/label/c.Order_Types_Not_Found';
import Error_Occurred_While_Getting_Invoices from '@salesforce/label/c.Error_Occurred_While_Getting_Invoices';
import value_should_be_less_than_or_equal_to from '@salesforce/label/c.value_should_be_less_than_or_equal_to';
import You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return from '@salesforce/label/c.You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return';
import HelpText_Content from '@salesforce/label/c.You_Can_Not_Mark_This_Invoice_As_Full_Return_As_It_Is_Used_Partially_Before';
import You_Can_Not_Select_This_Product_There_Is_No_Balance_Quantity from '@salesforce/label/c.You_Can_Not_Select_This_Product_There_Is_No_Balance_Quantity';
import Once_you_mark_this_invoice_as_Full_Return_and_save_the_record from '@salesforce/label/c.Once_you_mark_this_invoice_as_Full_Return_and_save_the_record';
import Select_Account_First from '@salesforce/label/c.Select_Account_First';
import Edit from '@salesforce/label/c.Edit';
import New_Entry from '@salesforce/label/c.New_Entry';
import Full_Return from '@salesforce/label/c.Full_Return';
import Deposit from '@salesforce/label/c.Deposit';
import Deposit_Flag from '@salesforce/label/c.Deposit_Flag';
import Quantity_Flag from '@salesforce/label/c.Quantity_Flag';
import Billing_DOC_Item_Number from '@salesforce/label/c.Billing_DOC_Item_Number';
import Customer_Invoice_Date from '@salesforce/label/c.Customer_Invoice_Date';
import Inco_Term_2 from '@salesforce/label/c.Inco_Term_2';
import Select_Document_Type from '@salesforce/label/c.Select_Document_Type';
import Enter_Customer_Invoice from '@salesforce/label/c.Enter_Customer_Invoice';
import Enter_Customer_Invoice_Date from '@salesforce/label/c.Enter_Customer_Invoice_Date';
import Enter_Quantity from '@salesforce/label/c.Enter_Quantity';
import Invoice_Date from '@salesforce/label/c.Invoice_Date';
import Inco_Terms from '@salesforce/label/c.Inco_Terms';
import Document_Type from '@salesforce/label/c.Document_Type';
import Product from '@salesforce/label/c.Product';
import Quantity from '@salesforce/label/c.Quantity';
import Product_Details from '@salesforce/label/c.PRODUCT_Details';
import Select_Product from '@salesforce/label/c.Select_Product';
import None from '@salesforce/label/c.None';
import Duplicate_entries_are_not_allowed from '@salesforce/label/c.Duplicate_entries_are_not_allowed';

export default class SorTabSectionChild extends LightningElement {
    @api getValueFromParent = {};
    @track tabDetails = {};
    @track showSpinner = false;
    @track pwrOptions = [];
    @track ntiOptions = [];
    @track customerServiceList = [];
    @track isCustomerServList = false;
    @track custServObj = {};
    @track sapOrderList = [];
    @track isSAPOrderList = false;
    @track isDisable = true;
    /* @track isLOEEdit = true; // logistics operator email..
    @track isACDEdit = true; // actual collection date..
    @track isCDEdit = true; // closing date...
    @track isQualityEdit = true; // quality ...
    @track isCSEdit = true;  // customer service.. */
    @track showModal = false;
    @track emailOptions= []; // label and value format...
    @track selectedEmail = []; // must be comma seprated...'A','B','C'....
    @track recordId = '';
    @track invoiceOptions = [];
    @track invoiceMap = new Map();
    @track invoiceProductMap = new Map();
    @track invoiceData = [];
    @track productOptions = [];
    @track selectedInvoice = [];
    @track selectedProduct = [];
    @track orderTypOption = [];
    @track showProduct = false;
    @track helpText = false;
    @track required = true;
    @track invoiceValidation = false;
    @track productValidation = false;
    @track isRefusalNo = false;
    @track isFullReturn = false;
    @track disableFR = true;
    @track colspanCount = 17;
    @track itemIndex = 0;
    @track isEditCS = false;
    @track productQtyMap = new Map();
    @track fullInvoiceSet = new Set();
    @track refusal = '';
    @track zcerDocId = '';
    @track isEmail = true;
    @track refusalYesInvoiceSet = new Set();
    @track isNone = true;
    @track showInvoice = true;
    @track isCustInvoice = true;
    @track tempProductQtyMap = new Map();

    label = {
        PleaseWait,
        ErrorT,
        Success,
        Warning,
        FailToCreateRecord,
        NoRecordsFound,
        Fail_To_Delete_Record,
        Error_Occured_While_Deleting_Record,
        Record_Deleted_Successfully,
        Customer_Details,
        Customer_Code,
        CNPJ_CPF,
        Contact,
        Email,
        Cost_Center,
        Address,
        Postal_Code,
        State,
        Branch,
        Farm,
        Suburb,
        City,
        Phone_Number,
        Commercial_Workflow_Approval,
        Sales_District_Manager,
        Sales_Office_Manager,
        Sales_Director,
        Return_Details,
        Quality_Assessment,
        Return_Amount,
        Proceed_With_Return,
        Necessary_TI,
        Inspection_Date,
        Cost_QA,
        Contention,
        Logistics,
        Estimated_Collection_Date,
        Logistics_Operator_Email,
        Actual_Collection_Date,
        Date_of_Submission_To_Logistics_Partner,
        Closing_Date,
        Customer_Service,
        Billing_Doc,
        Invoice,
        Customer_Invoice,
        Return_Sub_Type,
        Action,
        Add,
        Delete,
        SAP_Order_Number,
        Select_an_Email,
        Send_to_Material_Assessment,
        Save,
        Cancel,
        Close,
        Invoices_Not_Found,
        Select_Invoice,
        Error_Occurred_While_Getting_Order_Types,
        Order_Types_Not_Found,
        Error_Occurred_While_Getting_Invoices,
        value_should_be_less_than_or_equal_to,
        You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return,
        HelpText_Content,
        You_Can_Not_Select_This_Product_There_Is_No_Balance_Quantity,
        Once_you_mark_this_invoice_as_Full_Return_and_save_the_record,
        Select_Account_First,
        Edit,
        New_Entry,
        Full_Return,
        Deposit,
        Deposit_Flag,
        Quantity_Flag,
        Billing_DOC_Item_Number,
        Customer_Invoice_Date,
        Inco_Term_2,
        Select_Document_Type,
        Enter_Customer_Invoice,
        Enter_Customer_Invoice_Date,
        Enter_Quantity,
        Invoice_Date,
        Inco_Terms,
        Document_Type,
        Product,
        Quantity,
        Product_Details,
        Select_Product,
        None,
        Duplicate_entries_are_not_allowed
    };

    connectedCallback(event){
        //this.isCustomerServList = false;
        //console.log('value from parent in Tab Section Child - ', this.getValueFromParent);
        this.tabDetails = this.getValueFromParent;      // assign value here...
        
        console.log('this.sapOrderList in Tab Section Child - ',this.tabDetails);
    }

    openModal(){ 
        this.showModal = true;
        if(this.refusal == 'Yes'){
            let obj = JSON.parse(JSON.stringify(this.custServObj));
            if(this.zcerDocId.length>0){
                obj.docType = this.zcerDocId;
                this.custServObj = obj;
            }
            
        }
        
    }

    closeModal() {    
        // to close modal window set 'showModal' tarck value as false
        this.custServObj = [];
        this.selectedInvoice = [];
        this.selectedProduct = [];
        this.productOptions = [];
        this.showProduct = false;
        this.disableFR = true;
        this.itemIndex = 0;
        this.isEditCS = false;
        this.isFullReturn = false;
        this.zcerDocId = '';
        this.showModal = false;
    }

    // getting the default record type id, if you dont' then it will get master
    @wire(getObjectInfo, { objectApiName: RSO_OBJECT })
    rsoMetadata;
 
    // now retriving the field picklist values of object
 
    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: Proceed_with_Return
        }
    )
    wiredPWR({error, data}){
        if(data){
            this.pwrOptions = data.values;
            //console.log('wiredPWR data- ', data.values);
        }
        else if(error){
            console.log('wiredPWR error- ', error);
        }
    }

    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: Necessary_Technical_Inspection
        }
    )
    wiredNTI({error, data}){
        if(data){
            this.ntiOptions = data.values;
            //console.log('wiredNTI data- ', data.values);
        }
        else if(error){
            console.log('wiredNTI error- ', error);
        }
    }    

    @wire(getPicklistValues,
        {
            recordTypeId: '012000000000000AAA',// hardcoded value for null recordTypeid...//'$rsoMetadata.data.defaultRecordTypeId', 
            fieldApiName: Logistics_OperatorEmail
        }
    )
    wiredLOE({error, data}){
        if(data){
            //console.log('Email Picklist -', JSON.stringify(data));
            let optn = [];
            optn.push({
                label: None,
                value: '',
            });

            data.values.forEach(r => {
                optn.push({
                  label: r.label,
                  value: r.value,
                });
            });
            this.emailOptions = optn;
        }
        else if(error){
            console.log('wiredLOE error- ', error);
        }
    }

    @api
    getRecordDetailsFromParent(obj,flag) {
        if(flag == true){
            this.isDisable = false;
        }
        this.tabDetails = obj;   
        this.recordId = obj.sorId;
        this.refusal = obj.refusal;
        this.customerServiceList = this.tabDetails.customerServiceList;
        this.sapOrderList = this.tabDetails.sapOrderList;
        if(this.tabDetails.customerServiceList.length>0){
            this.isCustomerServList = true;
            this.reInitializeProductQtyMap();
            this.resetRefusalYesInvoiceSet();
            this.createUIProductQtyMap();
        }  
        if(this.tabDetails.sapOrderList.length>0){
            this.isSAPOrderList = true;
        } 
        let str = obj.logisticOperatorMail;
        //console.log('logisticOperatorMail -', str);
        str = str.replaceAll(';',','); 
        this.selectedEmail = str.split(',');        
        
        if(this.refusal == 'No'){
            this.isRefusalNo = true;
            this.colspanCount = 18;
        }
        else{
            this.isRefusalNo = false;
            this.colspanCount = 12;
        }
        
        if(obj.isCSEdit == false){//Nik..
            this.loadInvoicesAndDeposit();
            this.loadOrderTypes();
        }
        
    }

    @api
    getTabData(strString) {
        //console.log('getTabData - ', JSON.parse(JSON.stringify(strString)));
        var obj = JSON.parse(JSON.stringify(strString));
        this.fetchCustomerDetails(obj.accountId,obj.distTerId);   // pass record id as 2nd parameter...
    }

    @api
    getReturnAmount(rtnAmt) {
        //console.log('getReturnAmount - ', rtnAmt);
        var obj = JSON.parse(JSON.stringify(this.tabDetails));
        obj.returnAmount = rtnAmt;
        if(rtnAmt > 0){
            obj.costQA = (parseFloat(rtnAmt) / 2).toFixed(2);
        }
        this.tabDetails = obj;
    }

    triggerEvent(events){
        //create event
        const custEvent = new CustomEvent("gettabsection",{
            detail: this.tabDetails
        });

        // dispatch event
        this.dispatchEvent(custEvent);
    }

    loadInvoicesAndDeposit(){
        this.showSpinner = true;
        getInvoicesAndDeposite({sorId : this.recordId})
            .then(result => {
                //console.log('getInvoicesAndDeposite result', JSON.stringify(result));
                if(result.length > 0){
                    this.invoiceData = result;
                    let optn = [];
                    result.forEach(r => {
                        if(!this.invoiceMap.has(r.invoice)){
                            optn.push({
                                label: r.invoiceName,
                                value: r.invoice,
                            });
                            this.invoiceMap.set(r.invoice,r);
                        } 
                        //this.invoiceProductMap.set(r.productId,r);                       
                    });
                    this.invoiceOptions = optn;
                }
                else{
                   // this.showToastmessage(ErrorT,Invoices_Not_Found,'Error');
                }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('loadInvoicesAndDeposit js method catch - ', error);
                //this.showToastmessage(ErrorT,Error_Occurred_While_Getting_Invoices,'Error');
            })
    }

    loadOrderTypes(){
        this.showSpinner = true;
        getOrderTypes()
            .then(result => {
                //console.log('loadOrderTypes result', JSON.stringify(result));
                if(result.length > 0){
                    let optn = [];
                    //let refsl = JSON.parse(JSON.stringify(this.tabDetails)).refusal;
                    //console.log('loadOrderTypes refusal - ', refsl);
                    result.forEach(r => {
                        if(this.refusal == 'Yes' && r.orderCode == 'ZCER'){
                            optn.push({
                                label: r.orderCode,
                                value: r.recId,
                            });
                            this.zcerDocId = r.recId;
                        }
                        if(this.refusal == 'No' && r.orderCode != 'ZCER'){
                            optn.push({
                                label: r.orderCode,
                                value: r.recId,
                            });
                        }
                        
                    });
                    this.orderTypOption = optn;
                }
                else{
                    this.showToastmessage(ErrorT,Order_Types_Not_Found,'Error');
                }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('loadOrderTypes js method catch - ', error);
                this.showToastmessage(ErrorT,Error_Occurred_While_Getting_Order_Types,'Error');
            })
    }

    handleCSChange(event){
        let obj = JSON.parse(JSON.stringify(this.custServObj));
        
        if(event.target.name == 'docTyp'){
            obj.docType = event.target.value;
            if(event.target.value.length > 15){
                let odTp = this.orderTypOption.find(data => data.value == event.target.value);
                obj.docTypeName = odTp.label;
                if(odTp.label == 'ZROB'){
                    this.isCustInvoice = false;
                    obj.custInvoice = '';
                }
                else{
                    this.isCustInvoice = true;
                }
            }           
        }
        else if(event.target.name == 'fullRetrn'){
            obj.fullReturn = event.target.checked; 
        }
        else if(event.target.name == 'custInvc'){
            obj.custInvoice = event.target.value;
        }
        else if(event.target.name == 'custInvcDt'){
            obj.custInvoiceDt = event.target.value;
        }

        this.custServObj = obj;
        //console.log('handleCSChange - ', JSON.stringify(this.custServObj));
    }

    addCustomerService(event){
        let obj = JSON.parse(JSON.stringify(this.custServObj));
        let count = this.customerServiceList.length;
        let msg = '';
        let flag = false;
        
        if(obj.invoice == '' || obj.invoice == null || obj.invoice == undefined){
            flag = true;
            msg = Select_Invoice;
        }
        else if(obj.docType == '' || obj.docType == null || obj.docType == undefined){
            flag = true;
            msg = Select_Document_Type;
        }
        else if(this.isRefusalNo == true && this.isCustInvoice == true && (obj.custInvoice == '' || obj.custInvoice == null)){
            flag = true;
            msg = Enter_Customer_Invoice;
        }
        else if(this.isRefusalNo == true &&  (obj.custInvoiceDt == '' || obj.custInvoiceDt == null)){
            flag = true;
            msg = Enter_Customer_Invoice_Date;
        }
        else if(this.isRefusalNo == true && this.isFullReturn == false && (obj.productId == '' || obj.productId == null || obj.productId == undefined)){
            flag = true;
            msg = Select_Product;
        }
        else if(this.isRefusalNo == true && this.isFullReturn == false && (obj.quantity == 0 || obj.quantity == null || obj.quantity == '')){
            flag = true;
            msg = Enter_Quantity;
        }

        if(flag == true){
            this.showToastmessage(ErrorT,msg,'Error');
        }
        else{
            obj.srNo = count+1;

            if(obj.fullReturn == true){
                obj.productId = '';
                obj.productName = '';
                obj.quantity = 0;
                obj.quantityFlag = '';
                obj.maxQuantity = 0;
                obj.billingDocNum = '';
            }

            if(this.isEditCS == true){
                this.customerServiceList[this.itemIndex] = obj;
            }
            else{
                //obj.recId = '';
                this.customerServiceList.push(obj);
            }
            
            this.isCustomerServList = true;

            let obj2 = JSON.parse(JSON.stringify(this.tabDetails));
            obj2.customerServiceList = this.customerServiceList;
            this.tabDetails = obj2;
            this.triggerEvent(event);
            this.reInitializeProductQtyMap();
            this.resetFullInvoiceSet();
            this.resetRefusalYesInvoiceSet();
            this.closeModal();
        }
    }

    editProduct(event){
        this.showSpinner = true;
        let array = this.customerServiceList;
        let index = event.target.name;
        this.itemIndex = index;
        this.isEditCS = true;
        let obj = JSON.parse(JSON.stringify(array[index]));   
        //console.log('editProduct obj - ', JSON.stringify(obj));     
        if(obj.docTypeName == 'ZROB'){
            this.isCustInvoice = false;
            obj.custInvoice = '';
        }
        this.selectedInvoice.push(obj.invoice);
        this.selectedProduct.push(obj.productId);
        let val = 0;
        checkBalanceQuantity({sorId : this.recordId,sorLiId:obj.productId})
            .then(result => {
                //console.log('editProduct result - ', result); 
                //if(result){
                    if(result <= 0){
                       // console.log('editProduct if result - ', obj.quantity);    
                        obj.maxQuantity = obj.quantity;
                    }
                    else{
                        if(this.productQtyMap.has(obj.productId)){
                            let exVal = 0;
                            if(this.tempProductQtyMap.has(obj.productId)){
                                exVal = this.tempProductQtyMap.get(obj.productId);
                            }
                            val = this.productQtyMap.get(obj.productId);
                            val = parseFloat(result) - parseFloat(val) + parseFloat(exVal);
                            val = val + parseFloat(obj.quantity);
                            if(val <= 0){
                                val = 0;
                            }
                            //console.log('editProduct else in map - ', val);   
                        }
                        else{
                            val = result + parseFloat(obj.quantity);
                            //console.log('editProduct else map - ', val);  
                        }
                        obj.maxQuantity = val;
                        //console.log('editProduct maxQuantity - ', obj.maxQuantity);  
                    }
                    this.custServObj = obj;
               // }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('editProduct checkBalanceQuantity js method catch - ', error);
            })

            let optn = [];
            this.invoiceData.filter(data => data.invoice == obj.invoice).forEach(r => {
                optn.push({
                    label: r.productName,
                    value: r.productId,
                });
            });
            this.productOptions = optn;
            this.showProduct = true;
                
        /* this.showSpinner = true;
        checkInvoiceFullReturn({invcId : obj.invoice})
            .then(result => {
                if(result.length > 0){
                    if(result === 'Full Return'){
                        this.disableFR = true;
                    }
                    else if(this.fullInvoiceSet.has(obj.invoice)){
                        this.disableFR = true;
                    }
                    else{
                        this.disableFR = false;
                        if(result === 'Partial Return'){
                            this.helpText = true;
                        }
                        else if(result === 'No Return'){
                            this.helpText = false;
                        }
                        
                        let optn = [];
                        this.invoiceData.filter(data => data.invoice == obj.invoice).forEach(r => {
                            optn.push({
                                label: r.productName,
                                value: r.productId,
                            });
                        });
                        this.productOptions = optn;
                        this.showProduct = true;
                    }
                }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('editProduct checkInvoiceFullReturn js method catch - ', error);
            })   */      

        if(obj.fullReturn == true){
            this.isFullReturn = true;
        }
        this.custServObj = obj;        
        this.openModal();
    }


    /* addCustomerService(event){
        var inp=this.template.querySelectorAll(".inp"); // get input with class name as inp....
        let count = this.customerServiceList.length;
        let billFlag = false;
        let invcFlag = false;
        let custInvFlag = false;
        let rtnTpFlag = false;
        inp.forEach(function(item){
            let fieldValue=item.value;
            let fieldName=item.name;
            if(!fieldValue){
                item.setCustomValidity('enter value for '+ fieldName);
            }
            else{
                item.setCustomValidity("");
                if(fieldName=="Billing Doc"){
                    this.custServObj.billingDoc = fieldValue;
                    billFlag = true;
                }
                else if(fieldName=="Invoice"){
                    this.custServObj.invoice = fieldValue;
                    invcFlag = true;
                }
                else if(fieldName=="Customer Invoice"){
                    this.custServObj.custInvoice = fieldValue;
                    custInvFlag = true;
                }
                else if(fieldName=="Return Type"){
                    this.custServObj.returnType = fieldValue;
                    rtnTpFlag = true;
                }
            }
            item.reportValidity();
        },this);

        if(billFlag && invcFlag && custInvFlag && rtnTpFlag){
            this.custServObj.srNo = count+1;
            this.custServObj.recId = '';
            this.customerServiceList.push(this.custServObj);
            this.isCustomerServList = true;

            let obj = JSON.parse(JSON.stringify(this.tabDetails));
            obj.customerServiceList = this.customerServiceList;
            this.tabDetails = obj;
            this.triggerEvent(event);
        }
        //console.log('customerServiceList - ', this.customerServiceList);
        this.custServObj = {};
    } */

    deleteCustService(event){
        let array = this.customerServiceList;
        let index = event.target.name;
        let csRecId = event.target.value;
        let tempObj = JSON.parse(JSON.stringify(array[index]));
        let flag = true;
        let delay = 0;
        if(csRecId.length>0){
            delay = 4000;
            this.showSpinner = true;
            flag = false;
            deleteCustomerService({recId : csRecId})
            .then(result => {
                //console.log('deleteCustService result', result);
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
                console.log('deleteCustService js method catch - ', error);
                this.showToastmessage(ErrorT,Error_Occured_While_Deleting_Record,'Error');
            })
        }
        setTimeout(() => {
            if(flag){
                if (index > -1) {
                    array.splice(index, 1);
                }
                this.showToastmessage(Success,Record_Deleted_Successfully,'Success');
                this.customerServiceList = array;
    
                let obj = JSON.parse(JSON.stringify(this.tabDetails));
                obj.customerServiceList = this.customerServiceList;
                this.tabDetails = obj;
                this.triggerEvent(event);
            }
            if(array.length == 0){
                this.isCustomerServList = false;
                this.productQtyMap.clear();
                this.tempProductQtyMap.clear();
            }
            else{
                this.reInitializeProductQtyMap();
            
                if(csRecId.length > 0 && this.tempProductQtyMap.has(tempObj.productId)){
                    let exVal = this.tempProductQtyMap.get(tempObj.productId);
                    exVal = parseFloat(exVal) - parseFloat(tempObj.quantity);
                    if(exVal <= 0){
                        exVal = 0;
                    }
                    this.tempProductQtyMap.set(tempObj.productId,(exVal).toFixed(2));
                }
            }
            
            this.resetFullInvoiceSet();
            this.resetRefusalYesInvoiceSet();
        }, delay);
        
    }

    resetFullInvoiceSet(){
        this.fullInvoiceSet.clear();
        if(this.customerServiceList.length > 1){
            this.customerServiceList.filter(data => data.fullReturn == true).forEach(r => {
                if(!this.fullInvoiceSet.has(r.invoice)){
                    this.fullInvoiceSet.add(r.invoice);
                }
            });
        }
    }

    resetRefusalYesInvoiceSet(){
        this.refusalYesInvoiceSet.clear();
        if(this.customerServiceList.length > 0 && (this.refusal == 'Yes' || this.refusal == 'Sim')){
            this.customerServiceList.forEach(r => {
                if(!this.refusalYesInvoiceSet.has(r.invoice)){
                    this.refusalYesInvoiceSet.add(r.invoice);
                }
            });
        }
    }

    deleteSAPOrdr(event){
        let array = this.sapOrderList;
       // console.log('deleteSAPOrdr - ', array);
        let index = event.target.name;
        let sapRecId = event.target.value;
        let flag = true;
        if(sapRecId.length>0){
            flag = false;
            deleteSAPOrder({recId : sapRecId})
            .then(result => {
                //console.log('deleteSAPOrdr result', result);
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
                console.log('deleteSAPOrdr js method catch - ', error);
                this.showToastmessage(ErrorT,Fail_To_Delete_Record,'Error');
            })
        }
        if(flag){
            if (index > -1) {
                array.splice(index, 1);
            }
            this.showToastmessage(Success,Record_Deleted_Successfully,'Success');
            this.sapOrderList = array;

            let obj = JSON.parse(JSON.stringify(this.tabDetails));
            obj.sapOrderList = this.sapOrderList;
            this.tabDetails = obj;
            this.triggerEvent(event);
        }
        
        if(array.length == 0){
            this.isSAPOrderList = false;
        }
    }

    handleChange(event){
        let obj = JSON.parse(JSON.stringify(this.tabDetails));
        //console.log('value in Order Details Child - ', obj);
        if(event.target.name == 'cnpjCPF'){
            obj.cnpjCPF = event.target.value;
        }
        else if(event.target.name == 'contact'){
            obj.contact = event.target.value;
        }
        else if(event.target.name == 'email'){
            obj.email = event.target.value;
        }
        else if(event.target.name == 'costCentr'){
            obj.costCenter = event.target.value;
        }
        else if(event.target.name == 'address'){
            obj.address = event.target.value;
        }
        else if(event.target.name == 'postCode'){
            obj.postCode = event.target.value;
        }
        else if(event.target.name == 'state'){
            obj.state = event.target.value;
        }
        else if(event.target.name == 'branch'){
            obj.branch = event.target.value;
        }
        else if(event.target.name == 'farm'){
            obj.farm = event.target.value;
        }
        else if(event.target.name == 'suburb'){
            obj.suburb = event.target.value;
        }
        else if(event.target.name == 'city'){
            obj.city = event.target.value;
        }
        else if(event.target.name == 'phone'){
            obj.phoneNumber = event.target.value;
        }
        else if(event.target.name == 'returnDetails'){
            obj.returnDetails = event.target.value;
        }
        else if(event.target.name == 'returnAmt'){
            obj.returnAmount = event.target.value;
        }
        else if(event.target.name == 'pwr'){
            obj.proceedWithRtrn = event.target.value;
        }
        else if(event.target.name == 'nti'){
            obj.necessaryTechInspectn = event.target.value;
            if(event.target.value == 'Yes'){
                var today = new Date();
                obj.inspectionDate = today.toISOString();
            }
            else{
                obj.inspectionDate = '';
            }
        }
        else if(event.target.name == 'inspectionDt'){
            obj.inspectionDate = event.target.value;
        }
        else if(event.target.name == 'costQA'){
            obj.costQA = event.target.value;
        }
        else if(event.target.name == 'contention'){
            obj.contention = event.target.value;
        }
        /* else if(event.target.name == 'loe'){
            obj.logisticOperatorMail = event.target.value;  
        } */
        else if(event.target.name == 'acd'){
            obj.actualCollectionDate = event.target.value;
        }
        else if(event.target.name == 'closingDt'){ //sendToMaterial
            obj.closingDate = event.target.value;
        }
        else if(event.target.name == 'sendToMA'){ //sendToMaterial
            obj.sendToMaterial = event.target.checked;
        }

        this.tabDetails = obj;
        this.triggerEvent(event);
       /*  //create event
        const custEvent = new CustomEvent("gettabsection",{
            detail: this.tabDetails
        });

        // dispatch event
        this.dispatchEvent(custEvent); */
    }

    handleEmailSelect(event){
        let strArry = JSON.parse(JSON.stringify(event.detail.payload.values));
        let flag = true;
        let str;
        //console.log('handleEmailSelect strArry- ', strArry);
        //console.log('handleEmailSelect strArry length - ', strArry.length);
        //if(strArry.length > 0){
            strArry.filter(val => val == '').forEach(r => {
                //console.log('handleEmailSelect inside if- ');
                if(r.length == 0){
                    flag = false;
                    return false;
                }
            });
            
            str = strArry.toString().replaceAll(',',';');
        /* }
        else{
            str = '';
            flag = false;
        } */
        //this.selectedEmail.push('');
        //console.log('this.selectedEmail -', this.selectedEmail);
        //console.log('flag - ', flag);
        /* if(flag == false){
            this.showSpinner = true;
            this.isEmail = false;
            setTimeout(() => {
                this.showSpinner = false;
                this.isEmail = true;
            }, 1000);
        } */
        
        let obj = JSON.parse(JSON.stringify(this.tabDetails));
        obj.logisticOperatorMail = str;
        if(str.length > 0){
            var today = new Date();
            obj.dateOfSubToLogisticPartner = today.toISOString();
        }
        else{
            obj.dateOfSubToLogisticPartner = '';
        }
        this.tabDetails = obj;
        this.triggerEvent(event);
    }
    
    handleInvoiceSelect(event){
        let invcId = event.detail.payload.value;
        if(invcId.length > 15){
            if(this.refusal == 'Yes' && this.refusalYesInvoiceSet.has(invcId)){
                this.showToastmessage(ErrorT,Duplicate_entries_are_not_allowed,'Error');
                this.resetInvoiceRelated();
            }
            else{
                this.showSpinner = true;
                checkInvoiceFullReturn({invcId : invcId})
                    .then(result => {
                        if(result.length > 0){
                            if(result == 'Full Return'){
                                this.disableFR = true;
                                this.showToastmessage(ErrorT,You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return,'Error');
                                this.resetInvoiceRelated();
                            }
                            else if(this.fullInvoiceSet.has(invcId)){
                                this.disableFR = true;
                                this.showToastmessage(ErrorT,You_Can_Not_Select_This_Account_It_Is_Already_Marked_As_Full_Return,'Error');
                                this.resetInvoiceRelated();
                            }
                            else{
                                this.disableFR = false;
                                if(result == 'Partial Return'){
                                    this.helpText = true;
                                }
                                else if(result == 'No Return'){
                                    this.helpText = false;
                                }
                                if(this.invoiceMap.has(invcId)){
                                    this.selectedInvoice.push(invcId);
                                    let invcObj = JSON.parse(JSON.stringify(this.invoiceMap.get(invcId)));
                                    //invcObj.maxQuantity = 0;
                                    invcObj.productId = '';
                                    invcObj.productName = '';
                                    invcObj.billingDocNum = '';
                                    this.custServObj = invcObj;
                                }
                                let optn = [];
                                this.invoiceData.filter(data => data.invoice == invcId).forEach(r => {
                                    optn.push({
                                        label: r.productName,
                                        value: r.productId,
                                    });
                                });
                                this.productOptions = optn;
                                this.showProduct = true;
                            }
                        }
                        else{
                            //this.showToastmessage(ErrorT,Invoices_Not_Found,'Error');
                        }
                        this.showSpinner = false;
                    })
                    .catch(error => {
                        this.showSpinner = false;
                        console.log('getInvoiceFullReturn js method catch - ', error);
                        //this.showToastmessage(ErrorT,Error_Occurred_While_Getting_Invoices,'Error');
                    })
            }    
        }
        else{
            this.resetInvoiceRelated();
        }
       
    } 
    
    resetInvoiceRelated(){
        this.selectedInvoice = [];
        this.selectedProduct = [];
        this.productOptions = [];
        this.showProduct = false;
        this.custServObj = {};
        this.disableFR = true;
        this.helpText = false;
        //this.productQtyMap.clear();
        this.showInvoice = false;
        setTimeout(() => {
            this.showInvoice = true;
        },1000);

    }

    handleProductSelect(event){
        let prodId = event.detail.payload.value;
        let flag = true;
        let val = 0;
        this.isFullReturn = false;
        if(prodId.length > 15){
            this.showSpinner = true;
            checkBalanceQuantity({sorId : this.recordId,sorLiId:prodId})
                .then(result => {
                    //console.log('handleProductSelect result - ', result);
                    //if(result){
                        if(result <= 0){
                            this.resetProductSelectionLWC();
                            this.showToastmessage(ErrorT,You_Can_Not_Select_This_Product_There_Is_No_Balance_Quantity,'Error');
                            this.selectedProduct = [];
                        }
                        else{
                            if(this.productQtyMap.has(prodId)){
                                let exVal = 0;
                                if(this.tempProductQtyMap.has(prodId)){
                                    exVal = this.tempProductQtyMap.get(prodId);
                                }
                                val = this.productQtyMap.get(prodId);
                                val = parseFloat(result) - parseFloat(val) + parseFloat(exVal);
                                if(val <= 0){
                                    flag = false;
                                    this.resetProductSelectionLWC();
                                    this.showToastmessage(ErrorT,You_Can_Not_Select_This_Product_There_Is_No_Balance_Quantity,'Error');
                                    this.selectedProduct = [];
                                }
                            }
                            else{
                                val = result;
                            }

                            if(flag == true){
                                this.selectedProduct.push(prodId);
                                let custServ = this.invoiceData.find(data => data.productId == prodId);
                                let obj = JSON.parse(JSON.stringify(this.custServObj));
                                obj.productId = custServ.productId;
                                obj.productName = custServ.productName;
                                obj.billingDocNum = custServ.billingDocNum;
                                obj.quantity = 0;
                                obj.maxQuantity = val;
                                this.custServObj = obj;
                            }
                        }
                    //}
                    //else{
                        //this.showToastmessage(ErrorT,Invoices_Not_Found,'Error');
                    //}
                    this.showSpinner = false;
                })
                .catch(error => {
                    this.showSpinner = false;
                    console.log('handleProductSelect js method catch - ', error);
                    //this.showToastmessage(ErrorT,Error_Occurred_While_Getting_Invoices,'Error');
                })
        }
        else{
            this.selectedProduct = [];
            let obj = JSON.parse(JSON.stringify(this.custServObj));
            obj.productId = '';
            obj.productName = '';
            obj.quantity = 0;
            obj.quantityFlag = '';
            obj.maxQuantity = 0;
            obj.billingDocNum = '';
            obj.custInvoice = '';
            obj.custInvoiceDt = '';
            this.custServObj = obj;
            this.isFullReturn = false;
        }
    }

    resetProductSelectionLWC(){
        this.selectedProduct = [];
        this.showProduct = false;
        setTimeout(() => {
            this.showProduct = true;
        },1000);
    }

    validateFullReturn(event){
        if(event.target.checked){
            let flag = false;
            if(this.customerServiceList.length > 1){
                this.customerServiceList.filter(data => data.invoice == this.selectedInvoice[0]).forEach(r => {
                    flag = true;
                });
            }
            if(flag == true){
                this.showToastmessage(ErrorT,HelpText_Content,'Error');
                this.template.querySelector('.flReturn').checked = false;
            }
            else{
                this.showToastmessage(Warning,Once_you_mark_this_invoice_as_Full_Return_and_save_the_record,'Warning');
                this.isFullReturn = true;
            }
        }
        else{
            this.isFullReturn = false;
        }
        this.handleCSChange(event);
    }

    validateQuantity(event){
        let obj = JSON.parse(JSON.stringify(this.custServObj));
        if(event.target.value == '' || event.target.value == null || event.target.value.length == 0){
            obj.quantity = 0;
        }
        else{
            obj.quantity = event.target.value;
            obj.quantityFlag = 'X';
        }

        if(obj.quantity > obj.maxQuantity){
            obj.quantity = 0;
            obj.quantityFlag = '';
            event.target.value = 0;
            event.target.setCustomValidity(value_should_be_less_than_or_equal_to+' '+ obj.maxQuantity);            
        }
        else{
            event.target.setCustomValidity('');
        }

        if(obj.quantity > 0){
            obj.quantityFlag = 'X';
        }
        else{
            obj.quantityFlag = '';
        }
        event.target.reportValidity();        
        this.custServObj = obj;
    }

    fetchCustomerDetails(customerId,distTerId){
        //console.log('fetchCustomerDetails- ', customerId);
        //console.log('fetchCustomerDetails distTerId- ', distTerId);
        getAccountDetails({accId : customerId, terId : distTerId})
            .then(result => {
                //console.log('fetchCustomerDetails result', JSON.stringify(result));
                this.tabDetails = result;
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('fetchCustomerDetails js method catch');
                
            })
    }

    reInitializeProductQtyMap(){
        this.productQtyMap.clear();
        //this.customerServiceList.filter(cs => cs.recId == '').forEach(data => {
        this.customerServiceList.forEach(data => {    
            //console.log('reInitializeProductQtyMap data - ', data);
            if(this.productQtyMap.has(data.productId)){
                let val = this.productQtyMap.get(data.productId);
                val = parseFloat(val) + parseFloat(data.quantity); 
                this.productQtyMap.set(data.productId,(val).toFixed(2));
            }
            else{
                this.productQtyMap.set(data.productId,parseFloat(data.quantity).toFixed(2));
            }
        });
        //console.log('reInitializeProductQtyMap - ', this.productQtyMap);
    }

    createUIProductQtyMap(){
        this.tempProductQtyMap.clear();
        this.customerServiceList.forEach(data => {
            if(this.tempProductQtyMap.has(data.productId)){
                let val = this.tempProductQtyMap.get(data.productId);
                val = parseFloat(val) + parseFloat(data.quantity); 
                this.tempProductQtyMap.set(data.productId,(val).toFixed(2));
            }
            else{
                this.tempProductQtyMap.set(data.productId,parseFloat(data.quantity).toFixed(2));
            }
        });
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