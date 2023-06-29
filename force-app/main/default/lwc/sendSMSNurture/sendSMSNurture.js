import { LightningElement } from 'lwc';
import csvFileRead from '@salesforce/apex/sendSMSNurture.csvFileRead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class SendSMSNurture extends LightningElement {
    uploadedFiles;
    displayFileName;
    showSpinner=false;
    sendSMSbuttonDisable=true;
    get acceptedFormats() {
        return ['.csv'];
    }
    handleUploadFinished(event) {
        // Get the list of uploaded files
        this.uploadedFiles = event.detail.files;
        this.displayFileName =true;
        
            this.sendSMSbuttonDisable=false;
       
        //alert('No. of files uploaded : ' + this.uploadedFiles.length);
        console.log('uploaded files :'+JSON.stringify(this.uploadedFiles));
    }
    sendSms(event){
        this.showSpinner =true;
        csvFileRead({contentDocumentId : this.uploadedFiles[0].documentId})
        .then(result => {
            this.showSpinner =false;
            this.showToastmessage('Success ','SMS sent Successfully.','success');
            console.log('result :'+result);
        })
        .catch(error => {
        });
    }
    showToastmessage(title, message, varient) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    }
}