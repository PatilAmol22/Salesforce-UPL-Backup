import { LightningElement, track, api, wire  } from 'lwc';

import getAllRecordId from '@salesforce/apex/brazil_RegionSKU_Upload.getAllRecordId';
import getDownloadURLForTemplates from '@salesforce/apex/brazil_RegionSKU_Upload.getDownloadURLForTemplates';
import readCSVFileBr from '@salesforce/apex/brazil_RegionSKU_Upload.readCSVFileBr';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import uploadBrazilCombo from '@salesforce/label/c.uploadBrazilCombo';
import attachBrazilComboTemp from '@salesforce/label/c.attachBrazilComboTemp';
import DownloadCSVLink from '@salesforce/label/c.DownloadCSVLink';
import DownloadTemplateOGS from '@salesforce/label/c.FU_Japan_Download_OGS_Template';
import SampleTemplateUpload from '@salesforce/label/c.SampleTemplateUpload';
import operationRun from '@salesforce/label/c.Japan_Operation_Run';
import uploadResult from '@salesforce/label/c.Japan_Check_Email';

export default class Brazil_RegionSKUCombination_Upload extends LightningElement {
     @track allRecId;
     @api brInsertURL;
	 @api recordIdBrazil;
     //Added by Atish@Wipro
     record;
     wiredAccount({ error, data }) {
         if (data) {
             this.record = data[0];
         } else if (error) {
             console.log('Something went wrong:', error);
         }
     }
     get myMaximumDate() {
        return this.record?.Maximum_Date__c;
    }


    label = {
        uploadBrazilCombo,
        attachBrazilComboTemp,
        DownloadTemplateOGS,
        SampleTemplateUpload,
        operationRun,
        uploadResult,
        DownloadCSVLink
    }

    activeSectionsMessage = '';
    connectedCallback(){
        this.getRecordIdForAll();
        this.getDownloadLinksForAll();
    }
	get acceptedFormats() {
        return ['.csv'];
    }

    handleSectionToggle(event) {
           const openSections = event.detail.openSections;
   
           if (openSections.length === 0) {
               this.activeSectionsMessage = 'All sections are closed';
           } else {
               this.activeSectionsMessage =
                   'Open sections: ' + openSections.join(', ');
           }
       } 
	
	 /*Retrieving record id of File_Attachment__c object records*/    
    getRecordIdForAll(){
        console.log('Js record method called')
        getAllRecordId()
        .then(result=>{
            this.allRecId=result;
             console.log('recordId-->',this.allRecId);
            this.recordIdBrazil=this.allRecId.Id;         
        });
    }

    getDownloadLinksForAll(){
        getDownloadURLForTemplates()
        .then(result=>{
            console.log(result);
           this.brInsertURL=result[0];
           //this.brUpdateURL=result[1];
        })
    }


    /*------------------------- CSV Upload --------------------------------*/
    handleUpload(event){
        const uploadedFilesBr = event.detail.files; 
        console.log(uploadedFilesBr+'checking') ; //addded by Atish
        readCSVFileBr({idContentDocument : uploadedFilesBr[0].documentId})
                 this.dispatchEvent(
            new ShowToastEvent({
                title: operationRun,
                message: uploadResult,
                variant: 'info',
            }),
       ); 
                
    }
       
}