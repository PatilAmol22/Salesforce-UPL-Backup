import { LightningElement,track,api,wire } from 'lwc';
import updateCaseRecord from '@salesforce/apex/CaseEditPageNurtureController.updateCaseRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { updateRecord } from 'lightning/uiRecordApi';
import Interaction_Related_To from '@salesforce/label/c.Interaction_Related_To';
export default class CaseEditPageNurture extends LightningElement {

    
    @track activeSections = ['General Case Information', 'Description Information', 'Additional Information','System Information'];
    @api recordId;
    @track editStartTime;
    fields_per_section = [
        {
            label: "General Case Information",
            fields: [
                "CaseNumber",
                "AccountId",
                "Department__c",
                "RecordTypeId",
                "QRC_Category__c",
                "Case_Owner_Formula__c",
                "QRC_sub_category__c",
                "Order_number__c",
                "Reason_for_calling__c",
                "Status",
                "Customer_Related_To__c",
                "QRC_type__c",
                "Multibrand_Name__c",
                "QRC_Time_Slot__c",
                "Crop_Name__c",
                "Subscription_type__c",
                "Expiry_date__c",
            ]
        },
        {
            label: "Description Information",
            fields: [
                "Description",
                "Level_1_Comments__c",
                "Level_2_Comments__c",
            ]
        },
        {
            label: "Additional Information",
            fields: [
                "Origin",
                "State_Head__c",
                "Follow_Up_Status__c",
            ]
        },
        {
            label: "System Information",
            fields: [
                "CreatedById",
                "LastModifiedById",
            ]
        },

    ];

    handleSave(event)
    {
        event.preventDefault();
        const fields = event.detail.fields;
        console.log('fields check '+JSON.stringify(fields));
        //RITM0466996  -Added by Nandhini
        let customerrRelatedTo=event.detail.fields.Customer_Related_To__c;
        var now=new Date();
        this.editStartTime=now;
        console.log('Date:'+this.editStartTime);
        console.log('FIELDS:'+JSON.stringify(event.detail));
        //RITM0466996  -Added by Nandhini to make Customer_Related_To__c field as Mandatory
        if(!customerrRelatedTo)
        {
            this.title = 'Error';
            this.msg = Interaction_Related_To;
            this.variant = 'Error';
            this.toastMessage();
        } 
       else{
        updateCaseRecord({
            caseToUpdate:fields, recId: this.recordId, startTime: this.editStartTime
        })
        .then(result => {
            console.log('RESULT:'+result);
            if(result=='success')
            {
                this.title = 'Success';
                this.msg = 'Case updated successfully';
                this.variant = 'Success';
                this.toastMessage();
                this.closeQuickAction();
                this.updateRecordView(this.recordId);
                
            }
            else if(result=='error')
            {
                this.title = 'Error';
                this.msg = 'For querys, the status should be closed.';
                this.variant = 'Error';
                this.toastMessage();
                this.closeQuickAction();
                
            }
        })
        .catch(error => {
            console.log(error);
            console.log(JSON.stringify(error));
            this.title = 'Error';
            this.msg = 'Error occurred. Please try again.';
            this.variant = 'Error';
            this.toastMessage();
            this.closeQuickAction();
            this.updateRecordView(this.recordId);
            
        });
    }
    }

    toastMessage()
    {
        const event = new ShowToastEvent({
            title: this.title,
            message: this.msg,
            variant: this.variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    updateRecordView(recordId) {
        updateRecord({fields: { Id: recordId }});
    }
}