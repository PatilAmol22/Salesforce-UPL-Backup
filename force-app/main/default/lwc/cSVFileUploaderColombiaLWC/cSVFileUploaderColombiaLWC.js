import { LightningElement, track, api } from 'lwc';

import saveFile from '@salesforce/apex/lwcCSVUploaderColombiaController.saveFile';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import 	uploadFile from '@salesforce/label/c.Columbia_Upload_CSV_File';
import 	uploadFileHeader from '@salesforce/label/c.Colombia_Upload_File';
import 	ErrorMessage from '@salesforce/label/c.Columbia_Error_Message_for_no_file';
import 	CellsFilled from '@salesforce/label/c.Columbia_Error_Message_for_all_cells_to_be_filled';
import 	ErrorMessageAfterUpload from '@salesforce/label/c.Columbia_Error_Message_on_upload';
import 	SuccessMessage from '@salesforce/label/c.colombia_File_uploaded_successfully_message';
export default class CSVFileUploaderColombiaLWC extends LightningElement {
    @api recordid;
   ErrorMessage=ErrorMessage;
   CellsFilled=CellsFilled;
   SuccessMessage=SuccessMessage;
   ErrorMessageAfterUpload=ErrorMessageAfterUpload;
   uploadFileHeader=uploadFileHeader;
    @track data;
    error;
 
    @track fileName = '';
 
    UploadFile = uploadFile;
 
    @track showLoadingSpinner = false;
 
    @track isTrue = false;
 
    selectedRecords;
 
    filesUploaded = [];
 
    file;
 
    fileContents;
 
    fileReader;
 
    content;
 
    MAX_FILE_SIZE = 1500000;
 
  
    handleFilesChange(event) {
 
        if(event.target.files.length > 0) {
 
            this.filesUploaded = event.target.files;
 
            this.fileName = event.target.files[0].name;
 
        }
 
    }
 
  
 
    handleSave() {
 
        if(this.filesUploaded.length > 0) {
 
            this.uploadHelper();
 
        }
 
        else {
 
            this.fileName = this.ErrorMessage;
 
        }
 
    }
 
  
 
    uploadHelper() {
 
        this.file = this.filesUploaded[0];
 
       if (this.file.size > this.MAX_FILE_SIZE) {
 
            window.console.log('File Size is to long');
 
            return ;
 
        }
 
        this.showLoadingSpinner = true;
 
  
 
        this.fileReader= new FileReader();
 
  
 
        this.fileReader.onloadend = (() => {
        
            var flag = 0;
            this.fileContents = this.fileReader.result;
            console.log('this.fileContents'+this.fileContents);
            var rows=this.fileContents.split("\n");
            for (var i = 1; i < rows.length; i++) {
                console.log('rows.length;'+i);
                var cells = rows[i].split(",");
                // if(cells.length < 2){
                //    flag = 1;
                //    break;
                // }
            
                
              
            }
        
       
               
            this.saveToFile();
            
 
        });
 
  
 
        this.fileReader.readAsText(this.file);
 
    }
 
  
 
    saveToFile() {
 
        saveFile({ base64Data: JSON.stringify(this.fileContents), cdbId: this.recordid})
 
        .then(result => {
 
            window.console.log('result ====> ');
 
            window.console.log(result);
 
  
 
            this.data = result;
 
  
 
            this.fileName = this.fileName + ' - '+this.SuccessMessage;
 
            this.isTrue = false;
 
            this.showLoadingSpinner = false;
 
  
 
            this.dispatchEvent(
 
                new ShowToastEvent({
 
                    title: 'Success!!',
 
                    message: this.fileName,
 
                    variant: 'success',
 
                }),
 
            );
 
        })
 
        .catch(error => {
 
            window.console.log('error'+JSON.stringify(error));
           this.error=error;
           console.log('this.error'+error.message+'# '+JSON.stringify(this.error.body.message));
            this.dispatchEvent(
 
                new ShowToastEvent({
 
                    title: this.ErrorMessageAfterUpload,
                    
                    message: this.error.body.message,
 
                    variant: 'error',
 
                }),
 
            );
 
        });
 
    }
 
  
 
 }