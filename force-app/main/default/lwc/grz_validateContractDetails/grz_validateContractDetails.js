import { LightningElement,track,api,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import createTemplate from '@salesforce/apex/grz_validateContractDetails.createTemplate';
import getTemplateDetails from '@salesforce/apex/grz_validateContractDetails.getTemplateDetails';
import { NavigationMixin } from 'lightning/navigation';
import { FlowNavigationFinishEvent } from 'lightning/flowSupport';



const FIELDS = [
'DistributorSalesAreaMapping__c.Contract_Details_Submitted__c',
'DistributorSalesAreaMapping__c.Distributor__c',
'DistributorSalesAreaMapping__c.Stage__c',
'DistributorSalesAreaMapping__c.Territory__c',
];

export default class ValidateContractDetails extends NavigationMixin(LightningElement) {
@track isLoading = true;
@api recordId;
@track salesAreaAccount ; 
@track  title ='';
@track message ='';
@track loadingmessage ='';
@track variant = '';
@api triggered = false;
@track progress = 0;
@track isProgressing = false;

@api strRecordId;

@wire(CurrentPageReference)
getPageReferenceParameters(currentPageReference) {
this.isLoading = true;
if (currentPageReference) {
    this.recordId = currentPageReference.state.recordId || null;
    console.log('currentPageReference==>', currentPageReference);
    console.log('this.recordId ',this.recordId);
    if(!this.recordId)this.recordId=this.strRecordId;
}
}

@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
setTemplatesVariables({ error, data }) {
if (data) {
    this.salesAreaAccount = data.fields.Distributor__c.value;
    if(data.fields.Stage__c.value=='Initiation with TM'){
        if(data.fields.Contract_Details_Submitted__c.value==true && data.fields.Territory__c.value!=null){
            this.loadingmessage='Generating Contract';
            this.handleLoad();
            this.toggleProgress();
            //setTimeout(() => {this.handleLoad()}, 5000);
        }else{
        // this.handleAlertClick();
        if(data.fields.Contract_Details_Submitted__c.value==false){
            this.message ='Please Fill contract Details ';
        }
        else{
            this.message ='Please select your Territory';
        }
            this.title = 'Error';
            this.variant = 'Error';
            this.isLoading = false;
            this.closeQuickAction();
        }
        // console.log('this.salesAreaAccount ',this.salesAreaAccount);
    }else if(data.fields.Stage__c.value=='SAP status'){
            this.message ='Contract is already Signed';
            this.title = 'Error';
            this.variant = 'Error';
            this.isLoading = false;
            this.closeQuickAction();
            
    }
    else{
            this.message ='Contract is already sent and '+data.fields.Stage__c.value;
            this.title = 'Error';
            this.variant = 'Error';
            this.isLoading = false;
            this.closeQuickAction();
        
    }
    
} else if (error) {
        
}
}


handleLoad(){
createTemplate({ salesArea: this.recordId ,Distributer: this.salesAreaAccount})
    .then(result => {
        console.log('SuccessFull'+JSON.stringify(result));
        // Generate a URL to a User record page
        this.loadingmessage='Hold Tight! It may take some time to send contract'
        setTimeout(() => {this.navigateToConfirmation(result)}, 50000);
        
    })
    .catch(error => {
        console.log('error>>>>>>'+JSON.stringify(error));
        if(error!=null && JSON.stringify(error)!='{}'){
            if(error.body.message=='Document Builder:INVALID_IMAGE_DATA'){
                    this.message ='Please upload profile photo on Contract';
            }
            else{
                this.message =error.body.message;
            }
        this.title = 'Error';
        this.variant = 'Error';
        this.isLoading = false;
        this.closeQuickAction();
        }
    });
}
navigateToConfirmation(AgrementId){
    this.closeQuickAction();
    console.log('this.salesAreaAccount');
    this.toggleProgress();
    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: AgrementId,
                            actionName: 'view'
                    }
                })
}
checkErrorMessage(AgrementId){
    getTemplateDetails({ aggrementId: AgrementId})
    .then(result => {
        console.log('SuccessFull'+JSON.stringify(result) );
        this.message ='Document sent';
        this.title = 'Success';
        this.isLoading = false;
        this.closeQuickAction();
        
    })
    .catch(error => {
        
        console.log('error>>>>>>'+error.body.message);
        this.message =error.body.message;
        this.title = 'Error';
        this.variant = 'Error';
        this.isLoading = false;
        this.closeQuickAction();
    });
}
toggleProgress() {
    console.log('this.isProgressing>>>>>>'+this.isProgressing);
    if (this.isProgressing) {
        // stop
        this.isProgressing = false;
        clearInterval(this._interval);
        console.log('this.isProgressing>>>>>>1111'+this.progress);
    } else {
        // start
        this.isProgressing = true;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this._interval = setInterval(() => {
            this.progress = this.progress === 100 ? 0 : this.progress + 1;
        }, 625);
        console.log('this.progress>>>>>>'+this.progress);
    }
}
disconnectedCallback() {
    // it's needed for the case the component gets disconnected
    // and the progress is being increased
    // this code doesn't show in the example
    clearInterval(this._interval);
}


closeQuickAction() { 
    //this.loadingmessage='Quick';
this.dispatchEvent(
    new ShowToastEvent({
        title: this.title,
        message: this.message,
        variant: this.variant,
    })
);   
this.dispatchEvent(new CloseActionScreenEvent());
    const navigateFinishEvent = new FlowNavigationFinishEvent();
this.dispatchEvent(navigateFinishEvent);
console.log('after fire');
}

}