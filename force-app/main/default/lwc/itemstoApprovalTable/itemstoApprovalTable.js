import { LightningElement,api } from 'lwc';
import process from '@salesforce/apex/GetProcessInstanceeData.process';
import getsobject from '@salesforce/apex/GetProcessInstanceeData.getContactIds';
import getCaseList from '@salesforce/apex/GetProcessInstanceeData.getCaseList';
import getProcessItemData from '@salesforce/apex/GetProcessInstanceeData.getProcessItemData';
import approve from '@salesforce/label/c.Approve';
import reject from '@salesforce/label/c.Reject';
import reassign from '@salesforce/label/c.Reassign';
import noApproval from '@salesforce/label/c.No_Approval_Label';
import Items_To_Approve from '@salesforce/label/c.Items_To_Approve';
import Submitted_By from '@salesforce/label/c.Submitted_By';	
import viewAll from '@salesforce/label/c.View_all';
import {ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';

export default class ItemsToApprovalTable extends LightningElement {

    
    @api actorId=Id;
    @api recordId;
    @api contextObjectType;
    @api fieldNames; //field names provided by called to be rendered as columns
    @api disableReassignment;
    isLoaded = false;
    ismanageButtonClick = false;
    rowData;
    mainData;
    showtable;
    columns;
    showSpinner=false;
    approvelabel = approve;
    rejectlabel = reject;
    reassignlabel = reassign;
    noApproval=noApproval;
    Items_To_Approve=Items_To_Approve;
    viewAll=viewAll;
    Submitted_By=Submitted_By;
    actionReassignValue=false;
    fieldDescribes;
    workitemid;
    windowURL;
    ishomepage=false;
    isShowModal=false;

    settings = {
        reactionOk: {label: 'Ok', variant: 'brand', value: 'Ok'},
        actionApprove: this.approvelabel,
        actionReject: this.rejectlabel,
        actionReassign: this.reassignlabel,
        stringDataType: 'String',
        referenceDataType: 'reference',
        singleMode: 'single',
        mixedMode: 'mixed',
        fieldNameSubmitter: '__Submitter',
        fieldNameSubmitterURL: '__SubmitterURL',
        fieldNameLastActor: '__LastActor',
        fieldNameLastActorURL: '__LastActorURL',
        fieldNameType: '__Type',
        fieldNameRecordName: '__Name',
        fieldNameRecordURL: '__RecordURL',
        fieldNameRecentApproverURL: '__RecentApproverUrl',
        processinstanceURL: 'processinstanceURL',
        objName:'objName',
        reasonToApprove:'reasonToApprove',
        defaultDateAttributes: {weekday: "long", year: "numeric", month: "long", day: "2-digit"},
        defaultDateTimeAttributes: {year: "numeric", month: "long", day: "2-digit", hour: "2-digit", minute: "2-digit"}
    };

    mandatoryColumnDescriptors = [
        {
            label: "Nome do registro",
            fieldName: this.settings.fieldNameRecordURL,
            type: "url",
            typeAttributes: {label: {fieldName: this.settings.fieldNameRecordName}, target: "_blank"}
        },
        {label: "Tipo", fieldName: this.settings.objName, type: "text"},
          {label: "Razão para aprovação", fieldName: this.settings.reasonToApprove, type: "text"},
        {
            label: "Data Enviada",
            fieldName: 'dateSubmitted',
            type: "date",
            typeAttributes: this.settings.defaultDateTimeAttributes
        },
        {
            label: "Remetente",
            fieldName: this.settings.fieldNameSubmitterURL,
            type: "url",
            typeAttributes: {label: {fieldName: this.settings.fieldNameSubmitter}, target: "_blank"}
        } ,
        {
            label: "Aprovador real",
            fieldName: this.settings.fieldNameLastActorURL,
            type: "url",
            typeAttributes: {label: {fieldName: this.settings.fieldNameLastActor}, target: "_blank"}
        } 
    ];


/* Second Attempt */
apActions = [
    {label: this.settings.actionApprove, value: this.settings.actionApprove, name: this.settings.actionApprove},
    {label: this.settings.actionReject, value: this.settings.actionReject, name: this.settings.actionReject},
    {label: this.settings.actionReassign, value: this.settings.actionReassign, name: this.settings.actionReassign}
];
/* Second Attempt */



    currentAction = this.settings.actionApprove;
    errorApex;
    errorJavascript;
    selectedRows;
    apCount;
    commentVal = '';
    reassignActorId;

        connectedCallback() {
            this.showSpinner=true;
console.log('Component Load'+window.location);
this.windowURL=window.location;
if(String(this.windowURL).indexOf("home") > -1){
    console.log('truetrue');
this.ishomepage=true;
}
else{
    console.log('false');
    this.ishomepage=false;
}

            getsobject({

                Recordids: this.recordId
        
                }).then(result => {
        
                this.contextObjectType=result;
               
                this.getCaseFieldsName();
        
                }).catch(error => {
                console.log('error is:2 ' + JSON.stringify(error));
                });
        }

            getCaseFieldsName (){
            getCaseList({
            objectTypeName :this.contextObjectType
            }).then(result => {
            this.fieldNames = result;
            this.getServerData();
            console.log('getCaseFieldsName ' + JSON.stringify(result));
            }).catch(error => {

            });
            }
        
    getServerData() {
        console.log('error is:3 ' +this.recordId+'@@@@'+this.actorId);
        console.log('error is:34 ' +this.contextObjectType+'@@@@'+this.fieldNames);
        getProcessItemData({
            actorId: this.actorId,
            recordId: this.recordId,
            objectName: this.contextObjectType,
            fieldNames: this.fieldNames,
            mode: this.mode
        }).then(result => {
            let processData = JSON.parse(result);
            console.log('processData----: ' +JSON.stringify(processData));
            this.fieldDescribes = processData.fieldDescribes;
            this.createColumns();
            this.rowData = this.generateRowData(processData.processInstanceData);
            console.log('createColumns is: ' +JSON.stringify(this.columns));
            console.log('error is: ' +JSON.stringify(this.rowData));
            console.log('Table Length---->>> ' +this.rowData.length);
            if(this.rowData.length >0){
                this.showtable=true;
                if(this.rowData.length >5){   
                for(var i=0; i<=5;i++){
                   this.mainData = this.rowData.slice(0,5);
                }
            }
            else{
                this.mainData=this.rowData;
            }
            console.log('@@@@this142---'+this.mainData);
                this.showtable=true;
            }
            else{
                this.showtable=false; 
            }
            this.showSpinner=false;
        }).catch(error => {
            console.log('error is: ' + JSON.stringify(error));
            this.showSpinner=false;
        });
    }

    /* Second Attempt */
    createColumns() {
        this.columns = [...this.mandatoryColumnDescriptors.filter(curDescriptor => {
            return this.mode !== this.settings.singleMode || !(this.mode === this.settings.singleMode && curDescriptor.fieldName === this.settings.fieldNameType)
        }), ...this.getCustomFieldColumns(), this.getActionMenuItems()];
    }

    getCustomFieldColumns() {
        let resultFields = [];
        if (this.fieldNames) {
            this.fieldNames.replace(/\s+/g, '').split(',').forEach(curFieldName => {
                let fieldDescribe = this.getFieldDescribe(this.contextObjectType, curFieldName);
                if (fieldDescribe) {
                    resultFields.push({
                            ...{
                                label: fieldDescribe.label,
                                fieldName: curFieldName
                            }, ...this.getDefaultTypeAttributes(fieldDescribe.type)
                        }
                    );
                }
            });
        }
        return resultFields;
    }

    getDefaultTypeAttributes(type) {
        if (type.includes('date')) {
            return {
                type: "date",
                typeAttributes: this.settings.defaultDateTimeAttributes
            };
        } else {
            return {type: 'text'};
        }
    }

    getFieldDescribe(objectName, fieldName) {
        if (this.fieldDescribes && this.fieldDescribes[objectName]) {
            let fieldDescribe = this.fieldDescribes[objectName].find(curFieldDescribe => curFieldDescribe.name.toLowerCase() === fieldName.toLowerCase());
            return fieldDescribe;
        }
    }

    get allowedActions() {
        if (this.apActions && this.apActions.length) {
            if (this.disableReassignment) {
                return this.apActions.filter(curAction => curAction.value != this.settings.actionReassign);
            } else {
                return this.apActions;
            }
        }
        return [];
    }
/* Second Attempt */

    get mode() {
        if (this.contextObjectType && this.fieldNames)
            return this.settings.singleMode; //display items to approve for a single type of object, enabling additional fields to be displayed
        else if (!this.contextObjectType && this.fieldNames) {
            this.errorJavascript = 'Flow Configuration error: You have specified fields without providing the name of an object type.';
        } else {
            return this.settings.mixedMode;
        }

        
    }

    updateSelectedRows(event) {
        this.selectedRows = event.detail.selectedRows;
        this.apCount = event.detail.selectedRows.length;
    }

    /* Second Attempt */
    handleRowAction(event) {
        this.currentAction = event.detail.action.value;
        this.actionReassignValue=false;
        console.log('@@@@@this.currentAction'+this.currentAction);
        console.log('@@@@@this.event.detail.row'+JSON.stringify(event.detail.row.WorkItemId));
        this.workitemid=event.detail.row.WorkItemId;
        this.isShowModal=true;
        
if(this.currentAction==this.settings.actionReassign){
    this.actionReassignValue=true;
}
      //  this.processApprovalAction(this.workitemid);

        // if (this.currentAction === this.settings.actionApprove || this.currentAction === this.settings.actionReject) {
        //     this.processApprovalAction(event.detail.row);
        // } else {
        //     this.selectedRows = event.detail.row;
        //     this.modalAction(true);
        // }
    }

    handleModalBatch() {
        if( this.ismanageButtonClick){
            this.processApprovalAction();
        }
        else{
            this.processApprovalAction(this.selectedRows);
        }
    }
    /* Second Attempt */

    processApprovalAction(workitem) {
        console.log('workitem 234: ' +workitem);
        console.log('curRow: ' + this.reassignActorId);
    //    var workItemIds= curRow ? [curRow.WorkItemId] : this.selectedRows.map(curRow => curRow.WorkItemId);
        console.log('curRow: ' + this.commentVal);

        if (workitem  && this.currentAction) {
            this.isLoaded=true;
            process({
                reassignActorId: this.reassignActorId,
                action: this.currentAction,
                workItemIds: workitem,
                comment: this.commentVal
            })
                .then(result => {
                    this.isLoaded=false;
                    this.showToast('Approval Management', this.currentAction + ' Complete', 'success', true);
                    this.getServerData();
                })
                .catch(error => {
                    this.isLoaded=false;
                    console.log('error returning from process work item apex call is: ' + JSON.stringify(error));
                });
        }
        this.commentVal='';
        this.reassignActorId='';
    }

    showToast(title, message, variant) {
        console.log('Toast Message Enter '+message);
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
      
    }

    /* Second Attempt */

    getActionMenuItems() {
        return {
            type: "action",
            typeAttributes: {rowActions: this.allowedActions, menuAlignment: "right"}
        };
    }

/* Second Attempt */


    getRecordURL(sObject) {
        return '/lightning/r/' + sObject.attributes.type + '/' + sObject.Id + '/view';
    }

    getObjectUrl(objectTypeName, recordId) {
        return '/lightning/r/' + objectTypeName + '/' + recordId + '/view';
    }

    generateRowData(rowData) {
        return rowData.map(curRow => {
            let resultData = {
                ...{
                    WorkItemId: curRow.workItem.Id,
                    ActorId: curRow.workItem.ActorId,
                    TargetObjectId: curRow.sObj.Id,
                    dateSubmitted: curRow.processInstance.CreatedDate
                }, ...curRow.sObj
            };
            console.log('TargetObjectId'+TargetObjectId);
            resultData[this.settings.fieldNameSubmitter] = curRow.createdByUser.Name;
            resultData[this.settings.fieldNameSubmitterURL] = this.getObjectUrl('User', curRow.createdByUser.Id);
            if (curRow.lastActorUser) {
                resultData[this.settings.fieldNameLastActor] = curRow.lastActorUser.Name;
                resultData[this.settings.fieldNameLastActorURL] = this.getObjectUrl('User', curRow.lastActorUser.Id);
            }
            resultData[this.settings.fieldNameType] = curRow.sObj.attributes.type;
            resultData[this.settings.fieldNameRecordName] = curRow.sObj[curRow.mainField];
            resultData[this.settings.fieldNameRecordURL] = this.getRecordURL(curRow.sObj);
            resultData[this.settings.processinstanceURL]=window.location.origin+'/'+curRow.workItem.Id;
            resultData[this.settings.objName]=curRow.nameField;
             resultData[this.settings.reasonToApprove]=curRow.sObj.Approval_Reason__c;
            
            return resultData;
        });
    }

    get modalReactions() {
        return [this.settings.reactionOk];
    }

    handleModalReactionButtonClick(event) {
        this.handleModalBatch();
    }

    // handleButtonClick(event) {
    //     this.ismanageButtonClick=true;
    //     this.currentAction = this.settings.actionApprove;
    //     this.modalAction(true);
    //     console.log('this.selectedRows: ' + this.selectedRows);
    // }





    handleComment(event) {
        this.commentVal = event.detail.value;
    }

    modalAction(isOpen) {
        const existing = this.template.querySelector('c-uc-modal');
        console.log('this.selectedRows: ' + this.selectedRows);
        if (existing) {
            if (isOpen) {
                existing.openModal(this.selectedRows);
            } else {
                this.ismanageButtonClick=false;
                existing.closeModal();
            }
        }
    }

    handleSelectionChange(event) {
        this.reassignActorId = event.detail.value;
        console.log('@@@@@reassignActorId343'+this.reassignActorId);
    }




    handleOnselect(event) {
        this.actionReassignValue=false;
        this.currentAction=event.detail.value;;
       this.workitemid = event.currentTarget.dataset.idd;
       if(this.currentAction==this.settings.actionReassign){
        this.actionReassignValue=true;
    }
       this.isShowModal=true;
            
        console.log('Line 351@@@@'+ event.detail.value+'%%%%'+ this.workitemid);
    }
    hideModalBox(){
        console.log('Line Number 360 @@@@'+this.workitemid );
        this.isShowModal=false;
        this.commentVal='';
        this.reassignActorId='';
    }
    actionClick(){
        console.log('Line Number 365 @@@@'+this.commentVal );
        console.log('Line Number 366 @@@@'+this.reassignActorId );
        console.log('Line Number 367 @@@@'+this.currentAction );
        console.log('Line Number 368 @@@@'+this.workitemid );
        this.processApprovalAction(this.workitemid);
        this.isShowModal=false;
       
    }
    handleClick(){
        var uurl=window.location.origin+'/lightning/n/Approval_Pending';
        window.open(uurl);
    }

}