import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {  getRecordNotifyChange } from 'lightning/uiRecordApi';
import updateMetrics from '@salesforce/apex/UpdateMetricsController.updateMetrics';
export default class UpdateMetricsLWC extends LightningElement {
    @api recordId ;
    @api showSpinner;
    @track hasRendered = true;
    renderedCallback() {
        if (this.hasRendered) {
        console.log('clicked');
        updateMetrics({
            sAID: this.recordId  
        }) 

        .then((result) => {
            this.showSpinner=false;
            const custEvt=new CustomEvent('showSpinner',{detail:{showSpinner:this.showSpinner}});
            this.dispatchEvent(custEvt);
            /*const event = new ShowToastEvent({
                title: 'Success',
                message: 'Update Successfully',
                variant: 'success',
            });
            this.dispatchEvent(event);*/

            getRecordNotifyChange([{recordId: this.recordId}]);

        })
     
        .catch((error) => {
            this.isLoaded=false;
            const event = new ShowToastEvent({
                title: "Error on update",
                message: error.body.message,
                variant: "error",
                mode: 'sticky',
            });
            this.dispatchEvent(event);
        });
        this.hasRendered = false;
    }
    }
}