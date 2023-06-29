import { api, LightningElement, track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getSORDetails from '@salesforce/apex/SORParentController.getSORDetails';
import createSOR from '@salesforce/apex/SORParentController.createSOR';
import processRecord from '@salesforce/apex/ApprovalInterface.processRecord';

import PleaseWait from '@salesforce/label/c.Please_wait';
import ErrorT from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Warning from '@salesforce/label/c.Warning';
import Submit from '@salesforce/label/c.Submit';
import SaveAsDraft from '@salesforce/label/c.Save_as_Draft_SOR';
import Cancel from '@salesforce/label/c.Cancel';
import FailToCreateRecord from '@salesforce/label/c.Failed_To_Create_Record';
import Select_Account_First from '@salesforce/label/c.Select_Account_First';
import Select_Return_Type from '@salesforce/label/c.Select_Return_Type';
import Select_Return_Sub_Type from '@salesforce/label/c.Select_Return_Sub_Type';
import Select_Sub_Type from '@salesforce/label/c.Select_Sub_Type';
import Select_Refusal from '@salesforce/label/c.Select_Refusal';
import Add_SOR_Items from '@salesforce/label/c.Add_SOR_Items';
import Enter_Contact from '@salesforce/label/c.Enter_Contact';
import Enter_Return_Details from '@salesforce/label/c.Enter_Return_Details';
import Enter_Return_Amount from '@salesforce/label/c.Enter_Return_Amount';
import Select_Logistics_Operator_Email from '@salesforce/label/c.Select_Logistics_Operator_Email';
import Select_Actual_Collection_Date from '@salesforce/label/c.Select_Actual_Collection_Date';
import Select_Closing_Date from '@salesforce/label/c.Select_Closing_Date';
import Add_Customer_Service_Data from '@salesforce/label/c.Add_Customer_Service_Data';
import Attachments_are_mandatory_for_Quality_Return_type from '@salesforce/label/c.Attachments_are_mandatory_for_Quality_Return_type';
import Record_Created_Successfully from '@salesforce/label/c.Record_Created_Successfully';
import SalesPerson from '@salesforce/label/c.Brazil_Sales_Person';
import SalesDistrictManager from '@salesforce/label/c.Brazil_Sales_District_Manager';
import LogisticsManager from '@salesforce/label/c.Brazil_Logistics_Manager';
import CustomerService from '@salesforce/label/c.Brazil_Customer_Service_User';
import BrazilAdmin from '@salesforce/label/c.Brazil_System_Administrator';
import Close from '@salesforce/label/c.Close';
import Approval_History from '@salesforce/label/c.Approval_History';
import Select_Credit_Analyst from '@salesforce/label/c.Select_Credit_Analyst';
import Approved_Rejected from '@salesforce/label/c.Approved_Rejected';
import You_are_about_to_Approve_Reject_the_seleted_records from '@salesforce/label/c.You_are_about_to_Approve_Reject_the_seleted_records';
import Comments from '@salesforce/label/c.COMMENTS';
import Approve from '@salesforce/label/c.Approve';
import Reject from '@salesforce/label/c.Reject';
import Approved from '@salesforce/label/c.Approved';
import Rejected from '@salesforce/label/c.Rejected';
import Record from '@salesforce/label/c.Record';
import Approval_History_Not_Found from '@salesforce/label/c.Approval_History_Not_Found';
import For_The_Below_Mentioned_Item_Volume_Limit_Exceed_Please_Delete_Record  from '@salesforce/label/c.For_The_Below_Mentioned_Item_Volume_Limit_Exceed_Please_Delete_Record';
import Select_Document_Type from '@salesforce/label/c.Select_Document_Type';
import Enter_Customer_Invoice from '@salesforce/label/c.Enter_Customer_Invoice';
import Enter_Customer_Invoice_Date from '@salesforce/label/c.Enter_Customer_Invoice_Date';
import Enter_Quantity from '@salesforce/label/c.Enter_Quantity';
import For_The_Customer_Service_Item  from '@salesforce/label/c.For_The_Customer_Service_Item';

export default class SorParent extends LightningElement {
    @api valueForOrderDetailsChild = {};
    @api valueForProductDetailsChild = [];
    @api valueForTabSectionChild = {};
    @api valueForAttachmentChild = [];
    @api recordId = '';
    @track accountId = '';
    @track sorDetails = {};
    @track showSpinner = false;
    @track isDisable = true;
    @track showDraft = false;
    @track enableButton = true;
    @track hideButtons = false;
    @track showHistory = false;
    @track recordArray = [];
    @track comment = '';
    @track showApproveModal = false;
    @track status = '';
    @track isApprove = false;
    @track aggregateMap = new Map();
    @track orderTrackForSave;   // Added   for RITM0565348 GRZ(Dheeraj Sharma) 05-06-2023

    label = {
        PleaseWait,
        ErrorT,
        Success,
        Warning,
        FailToCreateRecord,
        SalesPerson,
        SalesDistrictManager,
        LogisticsManager,
        CustomerService,
        BrazilAdmin,
        Submit,
        SaveAsDraft,
        Cancel,
        Select_Account_First,
        Select_Return_Type,
        Select_Return_Sub_Type,
        Select_Sub_Type,
        Select_Refusal,
        Add_SOR_Items,
        Enter_Contact,
        Enter_Return_Details,
        Enter_Return_Amount,
        Select_Logistics_Operator_Email,
        Select_Actual_Collection_Date,
        Select_Closing_Date,
        Add_Customer_Service_Data,
        Attachments_are_mandatory_for_Quality_Return_type,
        Record_Created_Successfully,
        Close,
        Approval_History,
        Select_Credit_Analyst,
        Approved_Rejected,
        You_are_about_to_Approve_Reject_the_seleted_records,
        Comments,
        Approve,
        Reject,
        Approval_History_Not_Found,
        For_The_Below_Mentioned_Item_Volume_Limit_Exceed_Please_Delete_Record,
        Select_Document_Type,
        Enter_Customer_Invoice,
        Enter_Customer_Invoice_Date,
        Enter_Quantity,
        For_The_Customer_Service_Item
    };

    connectedCallback(){
        //console.log('Record id in connectedCallback Parent - ', window.location.origin);
        //if(this.recordId.length>0){
            this.reloadSOR();
        //}
    }

    /* renderedCallback(){
        console.log('Record id in renderedCallback Parent - ', this.recordId);
    } */

    /* @wire(getSORDetails,{sorId:'$recordId'})
    wiredSORDetails({ error, data }) {
        if (data) {
            console.log('Record id in Parent - ', this.recordId);
            console.log('Record  in Parent - ', data);
            this.sorDetails = data;
            this.valueForOrderDetailsChild = data.orderDetailsWrap;
            this.valueForTabSectionChild = data.tabSectionWrap;
            this.valueForProductDetailsChild = data.productWrapList;
            this.valueForAttachmentChild = data.attachmentWrapList;
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    } */

    reloadSOR(){
        this.showSpinner = true;
        getSORDetails({sorId:this.recordId})
            .then(result => {
                
                this.sorDetails = result;
                this.isApprove = result.isApproveReject;
                this.accountId = result.orderDetailsWrap.accountId;

                if(result.isEdit == true){
                    this.isDisable = false;
                    this.enableButton = false;

                    let conts = result.invItemAggregateMap;
                    for(var key in conts){
                        this.aggregateMap.set(key,conts[key]);
                    }
                }
                if(result.orderDetailsWrap.status == 'Draft' || result.orderDetailsWrap.status == null || result.orderDetailsWrap.status == ''){
                    this.showDraft = true;
                }

                if(result.tabSectionWrap.qualityFlag == false || result.tabSectionWrap.isLOEEdit == false || result.tabSectionWrap.isACDEdit == false || result.tabSectionWrap.isCSEdit == false || result.tabSectionWrap.isCDEdit == false || result.tabSectionWrap.isQualityEdit == false){
                    this.enableButton = false;
                }

                this.template.querySelector('c-sor-attachment-child').getRecordDetailsFromParent(result.attachmentWrapList,result.isEdit,result.isAttachment);   
                this.template.querySelector('c-sor-order-details-child').getRecordDetailsFromParent(result.orderDetailsWrap,result.isEdit,result.isKeyAccountMngr);        // Updated  for INC0479929 GRZ(Dheeraj Sharma) 01-06-2023
                this.template.querySelector('c-sor-tab-section-child').getRecordDetailsFromParent(result.tabSectionWrap,result.isEdit);
                this.template.querySelector('c-sor-product-details-child').getRecordDetailsFromParent(result.productWrapList,this.accountId,result.isEdit,result.tabSectionWrap.isQualityEdit);
                
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('fetchCustomerDetails js method catch');
            })
    }    

    handleOrderDetails(event){
        let obj = JSON.parse(JSON.stringify(this.sorDetails));
        obj.orderDetailsWrap = JSON.parse(JSON.stringify(event.detail));
        this.sorDetails = obj;
       
        //console.log('value from Order Details - ', JSON.stringify(this.sorDetails));        
    }

    handleAccountDetails(event){
        //let objOd = JSON.parse(JSON.stringify(this.sorDetails));
        let obj = JSON.parse(JSON.stringify(this.valueForTabSectionChild));
        //console.log('handleAccountDetails - ', JSON.stringify(event.detail));
       //alert('event.detail:'+JSON.stringify(event.detail));
        if(event.detail.accountId.length > 0){
            obj.accountId = event.detail.accountId;
            obj.distTerId = event.detail.distTerId;

            this.accountId = event.detail.accountId;
           
            //objOd.orderDetailsWrap.accountId = event.detail.accountId;
        }
        else{
            obj.accountId = '';
            obj.distTerId = '';
            this.accountId = '';
            //objOd.orderDetailsWrap.accountId = '';
        }
        obj.sorId = '';
        this.valueForTabSectionChild = obj;
        //this.sorDetails = objOd;
        //console.log('this.valueForTabSectionChild - ', JSON.stringify(this.valueForTabSectionChild));
        this.template.querySelector('c-sor-tab-section-child').getTabData(this.valueForTabSectionChild);
        this.template.querySelector('c-sor-product-details-child').getAccountId(this.accountId);
        this.handleOrderDetails(event);
    }

    handleInvoiceSelection(event){
        //console.log('handleInvoiceSelection - ', event.detail);
        if(event.detail == true){
            this.template.querySelector('c-sor-order-details-child').disableAccount(true);
        }
        else{
            this.template.querySelector('c-sor-order-details-child').disableAccount(false);
        }
    }

    handleReturnAmountChange(event){
        this.template.querySelector('c-sor-tab-section-child').getReturnAmount(event.detail);
    }

    handleProductDetails(event){
        let obj = JSON.parse(JSON.stringify(this.sorDetails));
        obj.productWrapList = JSON.parse(JSON.stringify(event.detail));
        this.sorDetails = obj;
        //console.log('value from Product Details - ', JSON.stringify(this.sorDetails));
    }

    handleTabSection(event){
        let obj = JSON.parse(JSON.stringify(this.sorDetails));
        obj.tabSectionWrap = JSON.parse(JSON.stringify(event.detail));
        this.sorDetails = obj;
        //console.log('value from TabSection - ', JSON.stringify(this.sorDetails));  
    }

    handleAttachments(event){
        let obj = JSON.parse(JSON.stringify(this.sorDetails));
        obj.attachmentWrapList = JSON.parse(JSON.stringify(event.detail));
        this.sorDetails = obj;
        //console.log('value from Attachments - ', JSON.stringify(this.sorDetails));
    }

    handleSubmit(event){
        
        if (event.target.label == Submit) {
            this.orderTrackForSave = event.target.label; // Added   for RITM0565348 GRZ(Dheeraj Sharma) 05-06-2023
        }
       

        let flag = true;
        let obj = JSON.parse(JSON.stringify(this.sorDetails));

        if(obj.orderDetailsWrap.accountId == '' || obj.orderDetailsWrap.accountId == null){
            flag = false;
            this.showToastmessage(ErrorT,Select_Account_First,'Error');
        }
        else if(obj.orderDetailsWrap.returnType == '' || obj.orderDetailsWrap.returnType == null){
            flag = false;
            this.showToastmessage(ErrorT,Select_Return_Type,'Error');
        }
        else if(obj.orderDetailsWrap.returnSubType == '' || obj.orderDetailsWrap.returnSubType == null){
            flag = false;
            this.showToastmessage(ErrorT,Select_Return_Sub_Type,'Error');
        }
        else if(obj.orderDetailsWrap.returnType == 'Credit' && (obj.orderDetailsWrap.creditAnalyst == '' || obj.orderDetailsWrap.creditAnalyst == null)){
            flag = false;
            this.showToastmessage(ErrorT,Select_Credit_Analyst,'Error');
        }
        else if((obj.orderDetailsWrap.profileName == LogisticsManager || obj.orderDetailsWrap.profileName == CustomerService) && (obj.orderDetailsWrap.refusal == '' || obj.orderDetailsWrap.refusal == null)){
            flag = false;
            this.showToastmessage(ErrorT,Select_Refusal,'Error');
        }
        else if(obj.orderDetailsWrap.returnDetails == '' || obj.orderDetailsWrap.returnDetails == null){
            flag = false;
            this.showToastmessage(ErrorT,Enter_Return_Details,'Error');
        }
        else if(this.orderTrackForSave!=SaveAsDraft  && obj.productWrapList.length <= 0 ){
            flag = false;                                                                      // Updated   for RITM0565348 GRZ(Dheeraj Sharma) 05-06-2023
            this.showToastmessage(ErrorT,Add_SOR_Items,'Error');
        }
        else if(obj.tabSectionWrap.contact == '' || obj.tabSectionWrap.contact == null){
            flag = false;
            this.showToastmessage(ErrorT,Enter_Contact,'Error');
        }
       /* else if(obj.tabSectionWrap.returnAmount <= 0 || obj.tabSectionWrap.returnAmount == null){
            flag = false;                                                                        // Updated   for RITM0565348 GRZ(Dheeraj Sharma) 05-06-2023
            this.showToastmessage(ErrorT,Enter_Return_Amount,'Error');
        }*/
        else if(obj.orderDetailsWrap.subStatus == 'Pending At Collection' && obj.profileName == 'Brazil Logistics' && (obj.tabSectionWrap.actualCollectionDate == '' || obj.tabSectionWrap.actualCollectionDate == null)){
            flag = false;
            this.showToastmessage(ErrorT,Select_Actual_Collection_Date,'Error');
        }
       /*  else if(obj.tabSectionWrap.logisticOperatorMail == '' || obj.tabSectionWrap.logisticOperatorMail == null){
            flag = false;
            this.showToastmessage(ErrorT,Select_Logistics_Operator_Email,'Error');
        }
        else if(obj.tabSectionWrap.closingDate == '' || obj.tabSectionWrap.closingDate == null){
            flag = false;
            this.showToastmessage(ErrorT,Select_Closing_Date,'Error');
        }
        else if(obj.tabSectionWrap.customerServiceList.length <= 0){
            flag = false;
            this.showToastmessage(ErrorT,Add_Customer_Service_Data,'Error');
        } */
        else if((obj.orderDetailsWrap.returnType == 'Logistics' || obj.orderDetailsWrap.returnType == 'Packaging' || obj.orderDetailsWrap.returnType == 'Formulation' || obj.orderDetailsWrap.returnType == 'Missing') && obj.attachmentWrapList.length <= 0){
            flag = false;
            this.showToastmessage(ErrorT,Attachments_are_mandatory_for_Quality_Return_type,'Error');
        }

        if(flag == true && this.isDisable == false){
            let msg = For_The_Below_Mentioned_Item_Volume_Limit_Exceed_Please_Delete_Record;
            obj.productWrapList.forEach(r => {
                if(this.aggregateMap.has(r.invoiceItemId)){
                    if((this.aggregateMap.get(r.invoiceItemId)) <= 0){
                        flag = false;
                        msg += '\n '+ r.productDescription;
                        this.showToastmessage(ErrorT,msg,'Error');
                        return false;
                    }
                }
            });
        }
        /* else if(flag == true && obj.tabSectionWrap.isCSEdit == false){
            
            let msgs = For_The_Customer_Service_Item;
            //  obj.tabSectionWrap.customerServiceList.forEach(cs => {
            //     console.log(' CS validation - ', cs.quantity);
            //     console.log(' CS validation - ', cs.custInvoice);
            //     console.log(' CS validation - ', cs.custInvoiceDt);
            //     console.log(' CS validation - ', cs.docType);
            //     msgs = For_The_Customer_Service_Item;
            //     if(obj.tabSectionWrap.refusal == 'No' && (cs.quantity == 0 || cs.quantity == '')){
            //         msgs += ' '+ Enter_Quantity;
            //         flag = false;
            //         return false;
            //     }
            //     else if(obj.tabSectionWrap.refusal == 'No' && cs.custInvoice.length <= 0){
            //         msgs += ' '+ Enter_Customer_Invoice;
            //         flag = false;
            //         return false;
            //     }
            //     else if(obj.tabSectionWrap.refusal == 'No' && cs.custInvoiceDt.length <= 0){
            //         msgs += ' '+ Enter_Customer_Invoice_Date;
            //         flag = false;
            //         return false;
            //     }
            //     else if(cs.docType.length <= 0){
            //         msgs += ' '+ Select_Document_Type;
            //         flag = false;
            //         return false;
            //     }
            // }); 

            for(var i = 0; i < obj.tabSectionWrap.customerServiceList.length; i++){
                if(obj.tabSectionWrap.refusal == 'No' && obj.tabSectionWrap.fullReturn == false && (obj.tabSectionWrap.customerServiceList[i].quantity == 0 || obj.tabSectionWrap.customerServiceList[i].quantity == '')){
                    msgs += ' '+ Enter_Quantity;
                    flag = false;
                    break;
                }
                else if(obj.tabSectionWrap.refusal == 'No' && obj.tabSectionWrap.customerServiceList[i].custInvoice.length <= 0 && obj.tabSectionWrap.customerServiceList[i].docTypeName != 'ZROB'){
                    msgs += ' '+ Enter_Customer_Invoice;
                    flag = false;
                    break;
                }
                else if(obj.tabSectionWrap.refusal == 'No' && obj.tabSectionWrap.customerServiceList[i].custInvoiceDt.length <= 0){
                    msgs += ' '+ Enter_Customer_Invoice_Date;
                    flag = false;
                    break;
                }
                else if(obj.tabSectionWrap.customerServiceList[i].docType.length <= 0){
                    msgs += ' '+ Select_Document_Type;
                    flag = false;
                    break;
                }
            }
            if(flag == false){
                this.showToastmessage(ErrorT,msgs,'Error');
            }
        } */
        
        if(flag == true){
            this.saveSOR();
        }    
    }

    saveSOR(){
        this.hideButtons = true;
        this.showSpinner = true;
        createSOR({sorDetailsString : JSON.stringify(this.sorDetails)})
            .then(result => {
                //console.log('saveMapping result', result);
                if(result.length>0){
                    if(result == 'error'){
                        this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
                        this.hideButtons = false;
                        this.showSpinner = false;
                    }
                    else{
                        setTimeout(() => {
                            this.showToastmessage(Success,Record_Created_Successfully,'Success'); 
                            this.showSpinner = false; 
                            let str = window.location.origin+'/lightning/r/Return_Sales_Order__c/'+result+'/view'; 
                            this.openRecord(str);
                        }, 4000);
                    }
                }
                else{
                    this.hideButtons = false;
                    this.showSpinner = false;
                }                
            })
            .catch(error => {
                this.hideButtons = false;
                this.showSpinner = false;
                console.log('createSOR js method catch');
                this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
            })

    }

    handleDraft(event){
        let obj = JSON.parse(JSON.stringify(this.sorDetails));
        obj.orderDetailsWrap.isDraft = true;
        this.sorDetails = obj;
         var saveOrderType = SaveAsDraft;
        console.log('saveOrderType',saveOrderType);                   
        if (event.target.label == saveOrderType) {                  // Added for RITM0565348 GRZ(Dheeraj Sharma) 05-06-2023
            this.orderTrackForSave = event.target.label;
        }
        this.handleSubmit(event);
    }

    handleCancel() {
        let str = window.location.origin+'/lightning/o/Return_Sales_Order__c/list?filterName=Recent'; 
        this.openRecord(str);
    }

    openRecord(url){
        window.open(url,"_self");
        window.history.forward();
    }

    openHistory(){
        if(this.recordId.length>0){
            this.showHistory = true;
        }
        else{
            this.showToastmessage(Warning,Approval_History_Not_Found,'Warning');
        }
    }

    closeHistory(){
        this.showHistory = false;
    }

    handleChangeComment(event) {
        this.comment = event.target.value;
    }

    handleApproveClick(evet){
        this.status = 'Approve';
        this.processApproveReject();
    }

    handleRejectClick(evet){
        this.status = 'Reject';
        this.processApproveReject();
    }

    processApproveReject() {
        this.showSpinner = true;
        let arry = [];
        arry.push(this.recordId);
        processRecord({ records: JSON.stringify(arry), status: this.status, comment: this.comment }).then(result => {
            if(result.length>0){
                let msg = '';
                if(this.status == 'Approve'){
                    msg = Record+' '+ Approved;
                }
                else{
                    msg = Record+' '+ Rejected;
                }
                this.showToastmessage(Success, msg, 'success');
                this.showSpinner = false;
                this.handleCancel();
            }
            else{
                this.showSpinner = false;
            }
        }).catch(error => {
                console.log('error processApproveReject ', error);
                this.showToastmessage(ErrorT, 'Error' + error, 'error');
                this.showSpinner = false;
        })
    }

    openApproveReject(){
        this.showApproveModal = true; 
    }

    closeApproveReject(){
        this.comment = '';
        this.status = '';
        this.showApproveModal = false; 
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