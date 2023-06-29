import { LightningElement,api, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import deleteFile from '@salesforce/apex/SORAttachmentChildController.deleteContentDocument';
import File_Name from '@salesforce/label/c.File_Name';
import ErrorT from '@salesforce/label/c.Error';
import You_are_not_allowed_to_delete_record from '@salesforce/label/c.You_are_not_allowed_to_delete_record';
import Attachments from '@salesforce/label/c.Attachments';
import Download from '@salesforce/label/c.Download';

import Delete from '@salesforce/label/c.Delete';

export default class SorAttachmentChild extends NavigationMixin(LightningElement) {

    label = {
        ErrorT,
        You_are_not_allowed_to_delete_record,
        Attachments,
        Download,
        File_Name,
        Delete
    };

    @api columns = [
        { label: File_Name, fieldName: 'Title' }, 
        
        { label: Download, type:  'button', typeAttributes: { 
            label: Download, name: 'Download', variant: 'brand', cellAttributes:{iconName: 'action:download'}, 
            iconPosition: 'right' 
        } 
        },
        { label: Delete, type:  'button', typeAttributes: { 
            label: Delete,   name: 'Delete',   variant: 'destructive',cellAttributes:{iconName: 'standard:record_delete'}, 
            iconPosition: 'right' 
        }
        }
    ];
    
    @api getValueFromParent = [];
    @track filesList =[];
    @track isDisable = true;
    //@track columnsList = columns;
    
    
    get acceptedFormats() {
        return ['.pdf','.xls','.XLS','.xlsx','XLSX','.docx','.DOCX','.pptx','.PPTX','.PDF','.png','.PNG','.jpg','.JPG','.jpeg','.JPEG','.txt','.TXT','.msg','.MSG'];   // Updated for RITM0565348 GRZ(Dheeraj Sharma) 05-06-2023
    }

    connectedCallback(){
        //console.log('value from parent in attachment Child - ', this.getValueFromParent);
        if(this.getValueFromParent.length>0){
            let objList = JSON.parse(JSON.stringify(this.getValueFromParent));
            let arry = [];
            arry = JSON.parse(JSON.stringify(this.filesList));
            objList.forEach(function(item){
                //console.log('handleUploadFinished - ', item);
                let obj = {"ContentDocumentId":item.docId,"Title":item.name,"Download":window.location.origin+'/sfc/servlet.shepherd/document/download/'+item.docId};
                arry.push(obj);
            },this);
            //this.syncAllData();
            this.filesList = arry;
        }
    }

    @api
    getRecordDetailsFromParent(obj,flag,attchFlag) {
        
        if(flag == true || attchFlag == true){
            this.isDisable = false;
        }
        this.getValueFromParent = obj; 
        if(this.getValueFromParent.length>0){
            let objList = JSON.parse(JSON.stringify(this.getValueFromParent));
            let arry = [];
            let mainList = [];
            arry = JSON.parse(JSON.stringify(this.filesList));
            objList.forEach(function(item){
                //console.log('handleUploadFinished - ', item);
                let obj = {"ContentDocumentId":item.docId,"Title":item.name,"Download":window.location.origin+'/sfc/servlet.shepherd/document/download/'+item.docId};
                arry.push(obj);
            },this);
            //this.syncAllData();
            this.filesList = arry;
            arry = [];
            this.filesList.forEach(function(item2){
                //console.log('handleUploadFinished - ', item);
                let obj = {"docId":item2.ContentDocumentId,"sorId":"","name":item2.Title,"download":""};
                arry.push(obj);
            },this);
            mainList = arry;
            this.getValueFromParent = mainList;
        }       
    }

    triggerEvent(event){
        //create event
        const custEvent = new CustomEvent("getattachment",{
            detail: this.getValueFromParent
        });
console.log('event'+custEvent);
        // dispatch event
        this.dispatchEvent(custEvent);
    }

    handleUploadFinished(event) {
        console.log('inside handleUpload - ', event.detail.files);
        let mainList = [];
        mainList = JSON.parse(JSON.stringify(this.getValueFromParent));
        let objList = JSON.parse(JSON.stringify(event.detail.files));
        let arry = [];
        arry = JSON.parse(JSON.stringify(this.filesList));
        objList.forEach(function(item){
            console.log('handleUploadFinished 113 - ');
            let obj = {"ContentDocumentId":item.documentId,"Title":item.name,"Download":window.location.origin+'/sfc/servlet.shepherd/document/download/'+item.documentId};
            arry.push(obj);
        },this);
        //this.syncAllData();
        this.filesList = arry;
        arry = [];
        this.filesList.forEach(function(item2){
            console.log('handleUploadFinished 121 - ');
            let obj = {"docId":item2.ContentDocumentId,"sorId":"","name":item2.Title,"download":""};
            arry.push(obj);
        },this);
        mainList = arry;
        this.getValueFromParent = mainList;
        this.triggerEvent(event);
        console.log('this.filesList - ', JSON.parse(JSON.stringify(this.filesList)));
    }
 
    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if(actionName==='Download'){
            //console.log('RowId:',JSON.stringify(row));
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: row.Download
                }
            }, false 
        );
    
        }
        /* else if (actionName==='Preview'){
            this[NavigationMixin.Navigate]({ 
                type:'standard__namedPage',
                attributes:{ 
                    pageName:'filePreview'
                },
                state:{ 
                    selectedRecordId:row.ContentDocumentId
                }
            })
        } */
        else if(actionName==='Delete'){
            if(this.isDisable == false){
                deleteFile({recordId:row.ContentDocumentId})
                .then(result=>{
                    this.filesList  = this.filesList.filter(item => {
                        return item.ContentDocumentId !== row.ContentDocumentId ;
                    });
                    let mainList = [];
                    mainList = JSON.parse(JSON.stringify(this.getValueFromParent));
                    console.log('mainList'+JSON.stringify(mainList));
                    let arry = [];
                    this.filesList.forEach(function(item2){
                        //console.log('handleUploadFinished - ', item);
                        let obj = {"docId":item2.ContentDocumentId,"sorId":"","name":item2.Title,"download":""};
                        arry.push(obj);
                    },this);
                    mainList = arry;
                    this.getValueFromParent = mainList;
                    console.log('this.getValueFromParent'+JSON.stringify(this.getValueFromParent));
                    this.triggerEvent(event);
                })
            }
            else{
                this.showToastmessage(ErrorT,You_are_not_allowed_to_delete_record,'Error');
            }
        }
 
    }

    showToastmessage(title,message,varient){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    } 
 
    /* syncAllData(){
        fetchFiles({recordId:this.recordId})
        .then(data=>{
            let Filearr = [];
            console.log('data:',data);
            Filearr = Object.values(data).map(item=>{
                return {
                    ...item,Title:item.Title,Download:window.location.origin+'/sfc/servlet.shepherd/document/download/'+item.ContentDocumentId
                }
            })
            console.log('Values:',Filearr )
            this.filesList = Filearr;
     
        })     
    } */
}