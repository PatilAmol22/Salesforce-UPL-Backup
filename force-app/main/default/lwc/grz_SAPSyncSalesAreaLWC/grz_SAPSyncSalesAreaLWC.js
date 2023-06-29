import { LightningElement, wire, api,track} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import checkPreConditions from "@salesforce/apex/Grz_SAPSyncSalesArea.checkPreConditions";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import ProfileName from '@salesforce/schema/User.Profile.Name';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import {FlowNavigationFinishEvent } from 'lightning/flowSupport';
export default class Grz_SAPSyncSalesAreaLWC extends LightningElement {
    @api recordId;
    currentPageReference = null; 
    @track isLoading = true;
    @track emptyAccountValues=[];
    @track emptySalesAreaValues=[];
    @track displayAccountValues=false;
    @track displaySalesAreaValues=false;
    @track isTMOrAdmin=false;
    @api strRecordId;

    @wire(CurrentPageReference)
        getPageReferenceParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId || null;
            console.log('this.recordId==>',this.recordId);
            if(!this.recordId)this.recordId=this.strRecordId;
        }
    }

        @wire(getRecord, { recordId: Id, fields: [ ProfileName] })
        userDetails({ error, data }) {
            if (data) {
                if (data.fields.Profile.value != null) {
                    var profileName = data.fields.Profile.value.fields.Name.value;
                    if(profileName=='System Administrator'){
                        this.isTMOrAdmin=true;
                        this.checkPreConditions();
                    }
                    else{
                        this.tostMsg( 'This functionality is available System Administrators only', "info");
                        this.isLoading=false;
                    }
                }
            }
        }



    checkPreConditions() {
        checkPreConditions({ recordId: this.recordId })
    .then((result) => {
    this.isLoading = true;
    console.log('result ===> ',result);
    if(result.Status==false){
    if(result.emptyDataListAccount.length==0 && result.emptyDataListSalesArea.length==0 && result.AnnexureDataFilled==true){
        this.tostMsg( result.Message, "error");
    }
    else{
        this.emptyAccountValues=result.emptyDataListAccount;
        this.emptySalesAreaValues=result.emptyDataListSalesArea;
        if(this.emptyAccountValues.length>0){
            this.displayAccountValues=true;
        }
        if(this.emptySalesAreaValues.length>0){
            this.displaySalesAreaValues=true;
        }
        if(result.AnnexureDataFilled==false){
            this.tostMsg( 'Kindly fill data under declaration for Signing Authority', "warning");
        }
    }
    }
    else{
    this.tostMsg( result.Message, "info");
    }

        this.isLoading = false;

    }).catch((error) => {
    console.log("----in error----", error);
    this.tostMsg(error.statusText, "error");
    this.isLoading = false;
    });
    }

    tostMsg(msg, type) {
        const event = new ShowToastEvent({
            title: msg,
            variant: type,
        });
        this.dispatchEvent(event);
        this.closeQuickAction();
    }
    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
        const navigateFinishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateFinishEvent);
    }
    }