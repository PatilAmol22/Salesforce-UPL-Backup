import { LightningElement, wire, api,track} from 'lwc';
import initiateSync from "@salesforce/apex/Grz_SAPSyncShipLocation.initiateSync";
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';

import { getRecordNotifyChange } from "lightning/uiRecordApi";
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class Grz_SapShippingSyncLwc extends LightningElement {
    @api recordId;
@track isLoading = true;
@api strRecordId;
currentPageReference = null; 
rerror=[];
renderedCallback() {
    if(!this.recordId)this.recordId=this.strRecordId;
    this.initiateSync();
}

/*
@wire(CurrentPageReference)
getPageReferenceParameters(currentPageReference) {
    this.isLoading = true;
if (currentPageReference) {
    this.recordId = currentPageReference.state.recordId || null;
       this.initiateSync();
    
}
}*/


@api
    async initiateSync() {
        await initiateSync({ recordId: this.recordId })
    .then((result) => {
    
        
    console.log('result ===> ',result);
        if(result.error==''){
            this.tostMsg( 'Shipping Location synced successfully!', "success");
            
    getRecordNotifyChange([{ recordId: this.recordId }]);
    this.isLoading = false;
    this.closeQuickAction();
        }
        else{
            var erList=result.error;
            if(erList.length==1){
                erList.forEach((value) => this.tostMsg(value, "warning"));
                this.closeQuickAction();
            }
            else{
            this.rerror=result.error;
            this.isLoading = false;
            
            }
            
        }
        

    }).catch((error) => {
        //alert("----in error----"+ JSON.stringify(error));
    this.tostMsg('Unexpected error, contact your Admin', "error");
    this.isLoading = false;
    this.closeQuickAction();
    });
}


tostMsg(msg, type) {
    const event = new ShowToastEvent({
        title: msg,
        variant: type,
        mode: 'pester',
    });
    
    this.dispatchEvent(event);
    
}

closeQuickAction() {
    //alert(this.recordId);
    this.dispatchEvent(new CloseActionScreenEvent());
    const navigateFinishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateFinishEvent);
       
        
}

}