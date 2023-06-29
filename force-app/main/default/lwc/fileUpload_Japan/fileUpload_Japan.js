import { LightningElement, track, api, wire  } from 'lwc';
import readCSVFileDistributorInventory from '@salesforce/apex/FileUpload_Japan.readCSVFileDistributorInventory';
import readCSVFileExDistributorShipmentData from '@salesforce/apex/FileUpload_Japan.readCSVFileExDistributorShipmentData';
import getAllRecordId from '@salesforce/apex/FileUpload_Japan.getAllRecordId';
import getDownloadURLForTemplates from '@salesforce/apex/FileUpload_Japan.getDownloadURLForTemplates';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import DistributorInventoryLabel from '@salesforce/label/c.FU_Japan_Distributor_Inventory';
import OGSLabel from '@salesforce/label/c.FU_Japan_Ex_distributor_Shipment_Data_OGS';
import UploadDistributorInventory from '@salesforce/label/c.FU_Japan_Upload_Distributor_Inventory';
import UploadOGS from '@salesforce/label/c.FU_Japan_Upload_OGS';
import AttachDistributorInventory from '@salesforce/label/c.FU_Japan_Attach_Distributor_Inventory';
import AttachOGS from '@salesforce/label/c.FU_Japan_Attach_OGS';
import OperationTypeLabel from '@salesforce/label/c.FU_Japan_OperationType';
import InsertLabel from '@salesforce/label/c.FU_Japan_Insert';
import UpdateLabel from '@salesforce/label/c.FU_Japan_Update';
import DeleteLabel from '@salesforce/label/c.FU_Japan_Delete';
import InstructionCSV from '@salesforce/label/c.FU_Japan_Instructions_CSV';
import Instruction1 from '@salesforce/label/c.FU_Japan_Instruction_1';
import Instruction2 from '@salesforce/label/c.FU_Japan_Instruction_2';
import Instruction3 from '@salesforce/label/c.FU_Japan_Instruction_3';
import Instruction4 from '@salesforce/label/c.FU_Japan_Instruction_4';
import AdditionalInformationDI from '@salesforce/label/c.FU_Japan_Additional_Information_DI';
import AdditionalInformationOGS from '@salesforce/label/c.FU_Japan_Additional_Information_OGS';
import AdditionalInformation1 from '@salesforce/label/c.FU_Japan_AI_1';
import AdditionalInformation2 from '@salesforce/label/c.FU_Japan_AI_2';
import SampleTemplateDI from '@salesforce/label/c.FU_Japan_Sample_Template_DI';
import SampleTemplateOGS from '@salesforce/label/c.FU_Japan_Sample_Template_OGS';
import DownloadTemplateDI from '@salesforce/label/c.FU_Japan_Download_Distributor_Inventory_Template';
import DownloadTemplateOGS from '@salesforce/label/c.FU_Japan_Download_OGS_Template';
import DownloadUpdateCSV from '@salesforce/label/c.FU_Japan_Download_Update_CSV';
import DownloadDeleteCSV from '@salesforce/label/c.FU_Japan_Download_Delete_CSV';
import ErrorLabel from '@salesforce/label/c.FU_Japan_Error';
import SuccessLabel from '@salesforce/label/c.FU_Japan_Success';
import checkEmail from '@salesforce/label/c.FU_Japan_Email';
import DIInbox from '@salesforce/label/c.FU_Japan_DI_Inbox';
import OGSInbox from '@salesforce/label/c.FU_Japan_OGS_inbox';
import Incorrect_CSV from '@salesforce/label/c.FU_Japan_Incorrect_CSV';
import operationRun from '@salesforce/label/c.Japan_Operation_Run';
import uploadResult from '@salesforce/label/c.Japan_Check_Email';

export default class FileUpload_Japan extends LightningElement {
    @track dataDistributorInventory;
    @track dataExDistributorShipmentData;
    @track error;
    @track allRecId;
    @track operationType = 'Insert';
    @api recordIdDistributorInventory;
    @api recordIdExDistributorShipmentData;
    @api DIDeleteURL;
    @api DIInsertURL;
    @api DIUpdateURL;
    @api OGSDeleteURL;
    @api OGSInsertURL;
    @api OGSUpdateURL;
    label = {
        DistributorInventoryLabel,
        OGSLabel,
        UploadDistributorInventory,
        UploadOGS,
        AttachDistributorInventory,
        AttachOGS,
        OperationTypeLabel,
        InstructionCSV,
        Instruction1,
        Instruction2,
        Instruction3,
        Instruction4,
        AdditionalInformationDI,
        AdditionalInformationOGS,
        AdditionalInformation1,
        AdditionalInformation2,
        SampleTemplateDI,
        SampleTemplateOGS,
        DownloadTemplateDI,
        DownloadTemplateOGS,
        DownloadUpdateCSV,
        DownloadDeleteCSV,
        ErrorLabel,
        operationRun,
        uploadResult

    };

    get comboboxoptions() {
        return [
            { label: InsertLabel, value: 'Insert' },
            { label: UpdateLabel, value: 'Update' },
            { label: DeleteLabel, value: 'Delete' },
        ];
    }

    handleChangeCombobox(event){
       this.operationType=event.detail.value;
       console.log('operationType--->'+this.operationType)
    }

    activeSectionsMessage = '';
    connectedCallback(){
        console.log('optype--->'+OperationTypeLabel);
        this.getRecordIdForAll();
        this.getDownloadLinksForAll();
    }

     // accepted files
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
            // this.recordIdTarget=this.allRecId[0].Id;
             console.log('recordId-->',this.allRecId);
            this.recordIdExDistributorShipmentData=this.allRecId[0].Id;
            this.recordIdDistributorInventory=this.allRecId[1].Id;
           
        });
    }

    getDownloadLinksForAll(){
        getDownloadURLForTemplates()
        .then(result=>{
            console.log(result);
           this.DIDeleteURL=result[0];
           this.DIInsertURL=result[1];
           this.DIUpdateURL=result[2];
           this.OGSDeleteURL=result[3]
           this.OGSInsertURL=result[4];
           this.OGSUpdateURL=result[5];
        })
    }



    /*------------------------- Distributor Inventory CSV Upload--------------------------------*/
handleUploadFinishedDistributorInventory(event){
    const uploadedFilesDistributorInventory = event.detail.files;   
    readCSVFileDistributorInventory({idContentDocument : uploadedFilesDistributorInventory[0].documentId, operationType : this.operationType})
    /*.then(result => {
                this.dataDistributorInventory = result;
                //console.log('dataTarget ===> ',this.dataTarget);
                if(this.dataDistributorInventory.length>0){
                    console.log('DI --->',this.dataDistributorInventory);
                    if(this.dataDistributorInventory[0]=='Incorrect CSV'){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: ErrorLabel,
                                message: Incorrect_CSV,
                                variant: 'error',
                            }), 
                       ); 
                    }
                    else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: ErrorLabel,
                            message: checkEmail,
                            variant: 'error',
                        }), 
                   ); 
                    }
                }else{
                    console.log('Js if success ');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: SuccessLabel,
                        message: DIInbox,
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
                        title: ErrorLabel,
                        message: error.body.message,
                        variant: 'error',
                    }),
                ); 
           //     console.log('Error',this.error.body.message);    
            }) 
            */
             this.dispatchEvent(
        new ShowToastEvent({
            title: operationRun,
            message: uploadResult,
            variant: 'info',
        }),
   ); 
            
}


    /*-------------------------Ex-Distributor Shipment Data CSV Upload--------------------------------*/
    handleUploadFinishedExDistributorShipmentData(event){
        const uploadedFilesExDistributorShipmentData = event.detail.files;
        readCSVFileExDistributorShipmentData({idContentDocument : uploadedFilesExDistributorShipmentData[0].documentId, operationType : this.operationType})
                /* .then(result => {
                    this.dataExDistributorShipmentData = result;
                    console.log('Result--->'+this.dataExDistributorShipmentData)
                    //console.log('dataTarget ===> ',this.dataTarget);
                    if(this.dataExDistributorShipmentData.length>0){
                        console.log('Js if error ');
                        if(this.dataExDistributorShipmentData[0]=='Incorrect CSV'){
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: ErrorLabel,
                                    message: Incorrect_CSV,
                                    variant: 'error',
                                }), 
                           ); 
                        }
                        else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: ErrorLabel,
                                message: checkEmail,
                                variant: 'error',
                            }),
                        ); 
                        }
                    }else{
                        console.log('Js if success ');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: SuccessLabel,
                            message: OGSInbox,
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
                            title: ErrorLabel,
                            message: error.body.message,
                            variant: 'error',
                        }),
                    ); 
               //     console.log('Error',this.error.body.message);    
                }) */
                

          this.dispatchEvent(
        new ShowToastEvent({
            title: operationRun,
            message: uploadResult,
            variant: 'info',
        }),
   ); 
    } 

}