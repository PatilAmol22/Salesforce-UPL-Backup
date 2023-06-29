import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import runningUserId from '@salesforce/user/Id';
import { NavigationMixin } from 'lightning/navigation';
import getCurrentUser from '@salesforce/apex/SampleMaterialRequisition.getCurrentUser';

export default class PlaceOrderSWAL extends NavigationMixin (LightningElement) {

    loggedinuser ='';
    @api objectApiName;
    @api recordId;

    @track currentObjectName;
    @track currentRecordId;
    accountRecordId = '';

    @wire(getCurrentUser)
    getUser({error,data}){
        if(data){
            this.loggedinuser = data;
            console.log('current user ',this.loggedinuser);
            if(this.loggedinuser){// Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
                this.accountRecordId = this.recordId;
                this.eventhandler(this.accountRecordId);
            }
        }
    }
    
    closeAction(){
        console.log('loggedinuser>>>>>>>>>>>' +this.loggedinuser);
        console.log('this.recordId>>>>>>>>>>>' +this.recordId);
        console.log('this.accountRecordId >>>>>>'+this.accountRecordId);
        //console.log('currenRecordId>>>>>>>>>>>' +this.currentRecordId);
        //console.log('currenObjectName>>>>>>>>>>>' +this.currentObjectName);
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    eventhandler(accountId) {
        console.log('accountId >>>>>>>>>.' +accountId);
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/OrderSWAL?acid=' +accountId
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
    }
}