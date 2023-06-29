import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import ProfileName from '@salesforce/schema/User.Profile.Name';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {FlowNavigationFinishEvent } from 'lightning/flowSupport';
import getDocumentsFromCrown from "@salesforce/apex/Grz_OnboardingCrownIntegration.getDocumentsFromCrown";
import deleteAllDocuments from "@salesforce/apex/Grz_OnboardingCrownIntegration.deleteAllDocuments";
export default class Grz_CrownIntegration extends LightningElement {
    @api strRecordId;
    @api recordId;
    currentPageReference = null; 
    @track isAdminUser=false;

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
                        this.isAdminUser=true;
                        this.deleteAllDocuments();
                        this.getDocumentsFromCrown();
                    }
                    else{
                        this.tostMsg( 'This functionality is available for System Administrators only', "info");
                        this.isLoading=false;
                    }
                }
            }
        }

       
    getDocumentsFromCrown() {
        getDocumentsFromCrown({ recordId: this.recordId })
    .then((result) => {
    this.isLoading = true;
    console.log('result ===> ',result);
if(result){
    this.tostMsg( result, "info");
}
else{
    this.tostMsg( "Crown details are getting updated in salesforce. Kindly check in some time", "info");
}
    
        this.isLoading = false;

    }).catch((error) => {
        console.log("----in error----", error);
    this.tostMsg(error, "error");
    this.isLoading = false;
    });
    
}
deleteAllDocuments() {
    deleteAllDocuments({ recordIdVal: this.recordId })
.then((result) => {
    console.log("----in result----", result);
}).catch((error) => {
console.log("----in error----", error);
this.tostMsg(error, "error");
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