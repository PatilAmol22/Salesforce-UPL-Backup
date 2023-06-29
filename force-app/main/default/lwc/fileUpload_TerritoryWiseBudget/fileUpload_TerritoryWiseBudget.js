import { LightningElement, track, api, wire  } from 'lwc';
import readCSVFile from '@salesforce/apex/FileUpload_TWB.readCSVFile';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getAllRecordId from '@salesforce/apex/FileUpload_TWB.getAllRecordId';
import getDownloadURLForTemplates from '@salesforce/apex/FileUpload_TWB.getDownloadURLForTemplates';

export default class FileUpload_TerritoryWiseBudget extends LightningElement {
    @track recordId;
    @api Link;

    connectedCallback(){
        this.getRecordIdForAll();
        this.getDownloadLinksForAll()
    }

     // accepted files
     get acceptedFormats() {
        return ['.csv'];
    }

    /*Retrieving record id of File_Attachment__c object records*/    
    getRecordIdForAll(){
        console.log('Js record method called')
        getAllRecordId()
        .then(result=>{
            this.recordId=result[0].Id;
            // this.recordIdTarget=this.allRecId[0].Id;
           
        });
    }

    getDownloadLinksForAll(){
        getDownloadURLForTemplates()
        .then(result=>{
            console.log(result);
           this.Link=result[0];
        })
    }

    handleUploadFinished(event){
        const uploadedFiles = event.detail.files;
        readCSVFile({idContentDocument : uploadedFiles[0].documentId})
                .then(result => {
                    this.data = result;
                    //console.log('dataTarget ===> ',this.dataTarget);
                    if(this.data.length>0){
                        console.log('DI --->',this.data);
                        if(this.data[0]=='Incorrect CSV'){
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: "Error!",
                                    message: "Incorrect CSV",
                                    variant: 'error',
                                }), 
                           ); 
                        }
                        else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: "Error!",
                                message: "Please check you email.",
                                variant: 'error',
                            }), 
                       ); 
                        }
                    }else{
                        console.log('Js if success ');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Success!",
                            message: "Please check your email for upload details.",
                            variant: 'success',
                        }),
                    );
                    }
                })
                .catch(error => {
                    console.log('js method catch');
                    console.log(error);
                    this.error = error;          
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Error!",
                            message: error.body.message,
                            variant: 'error',
                        }),
                    ); 
               //     console.log('Error',this.error.body.message);    
                })
    }
    
    

}