import { LightningElement,api,track } from 'lwc';
import PO_Number_and_Documents from '@salesforce/label/c.PO_Number_and_Documents';
import Po_Number_Uk from '@salesforce/label/c.Po_Number_Uk';
import Po_DocumentsUk from '@salesforce/label/c.Po_DocumentsUk';
import Po_Number_error from '@salesforce/label/c.Po_Number_error';
import userId from '@salesforce/user/Id';

/* -------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------------------- */
import poDateL from '@salesforce/label/c.Purchase_Order_Date'; 
import poRequired from '@salesforce/label/c.Purchase_Order_date_is_required'; 
import poDateNotLessThanToday from '@salesforce/label/c.PO_Date_should_not_be_less_than_todays_date'; 
import errorT from '@salesforce/label/c.Error'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
/* ------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 --------------------------- */

export default class SalesOrderUkPoComponent extends LightningElement {
    @api recordid;
    @api objectname;
    @api salesorederdata;
    @api showPODate;            // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...
    @api isPODateReq;           // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...

    divclass="slds-box boxstyle";
    textclass="labelstyle";
    strUserId  = userId;
    MAX_FILE_SIZE= 25000000;
    fileUploderlist=[];
    ponumber='';
    isdisabledtrue=false;
    fileData;
    required = false;
    poDate = '';        // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...
    currentdate = '';   // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...
   
    openfileUpload(event) {
        var filelist=[];
        this.fileUploderlist=[];
        const file = event.target.files[0];

        var name='';
        if(file.name.length > 10){
            name = file.name.substring(0, 10);
        }
        console.log(JSON.stringify(file));
        var reader = new FileReader()
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                this.fileData = {
                    'name': name,
                    'base64': base64,
                    'documentId':'',
                    'contentVersionId':'',
                };
                filelist.push(this.fileData);
                this.fileUploderlist=filelist;
                console.log('data==>'+JSON.stringify(this.fileUploderlist));
            }
        reader.readAsDataURL(file);
    }
    
    handleClick(){
        const {base64, filename, recordId} = this.fileData
    }

    label = {
        PO_Number_and_Documents,
        Po_Number_Uk,
        Po_DocumentsUk,
        Po_Number_error,
        /* ------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----- */
        poDateL,
        poRequired,
        poDateNotLessThanToday,
        errorT
        /* ------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------- */
    };

    /* ---------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------- */
    connectedCallback(){
        console.log('CR#152 connectedCallback');
        var crDt = new Date();
        var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentdt = (yyyy + "-" + MM + "-" + dd);
        this.currentdate = currentdt;
        //this.poDate = currentdt;
        console.log(this.poDate + ' --- '+ this.currentdate);
    }

    
    @api
    checkPoDateField(show_poDt,poDt_req){
               
        this.showPODate = show_poDt;                  
        this.isPODateReq = poDt_req; 
        
    }
    /* ----------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------- */

    @api
    checkmethodtofil(salesorederdata,doclist,show_poDt){
        this.salesorederdata=salesorederdata;
                
            if(this.objectname==='SalesOrder'){
                if(this.salesorederdata){
                    if(this.salesorederdata.PONumber__c){
                        this.ponumber=this.salesorederdata.PONumber__c;
                    }
                    console.log('this.ponumber==='+this.ponumber);
                    this.isdisabledtrue=true;
                    /* -------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------- */
                    if(show_poDt == true && this.salesorederdata.Purchase_Order_Date__c != null){
                        this.poDate = this.salesorederdata.Purchase_Order_Date__c;
                    }
                    /* -------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------ */
                }
                if(doclist){
                    this.fileUploderlist=doclist;
                }
            }
        }
        @api
    iseditcalled(){
        if(this.salesorederdata.Order_Status__c ==='Draft' || this.salesorederdata.Order_Status__c ==='Blocked' || this.salesorederdata.Order_Status__c ==='Rejected'){
            this.isdisabledtrue=false;
        }
        else{
            this.isdisabledtrue=true;
        }
    }
    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg','.xlsx', '.xls', '.csv', '.doc', '.docx',];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        console.log('file===>'+JSON.stringify(event.detail.files));
        const uploadedFiles = event.detail.files;
        var filelist=[];
       // this.fileUploderlist=uploadedFiles;
        let uploadedFileNames = '';
        for(let i = 0; i < uploadedFiles.length; i++) {
            var name=uploadedFiles[i].name;
            console.log('file===>'+name);
            if(name.length > 10){
                name = name.substring(0, 10);
            }
            this.fileData = {
                'name': name,
                //'base64': uploadedFiles.base64,
                'documentId':uploadedFiles[i].documentId,
                'contentVersionId':uploadedFiles[i].contentVersionId,
            };
            filelist.push(this.fileData);
            uploadedFileNames += name + ', ';
        }
        this.fileUploderlist=filelist;
        //alert(JSON.stringify(this.fileUploderlist));
    }

    handleRemove(event){
        if(!this.isdisabledtrue){
            var rec=event.currentTarget.dataset.record;
            console.log('contentid===>'+rec);
            var filelist=this.fileUploderlist;
            console.log('contentid===>'+JSON.stringify(this.fileUploderlist));
            filelist.splice(rec, 1);
            this.fileUploderlist=[];
            this.fileUploderlist= filelist;
           console.log('contentid===>'+JSON.stringify(this.fileUploderlist));
        }
        
    }
    @api
    methodToChangeColorpo(istrue){
        if(istrue){
            if(this.divclass!='slds-box boxstylecolored'){
                this.divclass="slds-box boxstylecolored";
                this.textclass="labelstylecolored";
            }
        }
        else{
            if(this.divclass!='slds-box boxstyle'){
                this.divclass="slds-box boxstyle";
                this.textclass="labelstyle";
            }
        }
       
    }
    @api
    methodTogetvalues(OrderStatus){

        var iscall=false;
        if(OrderStatus==='Submitted'){
            this.required = true;
            Promise.resolve().then(() => {
                const inputEle = this.template.querySelector('lightning-input');
                inputEle.reportValidity();
                console.log('inputEle@@'+inputEle);
            });
            if(this.ponumber==''){
                iscall=false; 
            }
            /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------------------------------- */
            else if(this.showPODate == true && this.isPODateReq == true && (this.poDate == null || this.poDate == '')){
                iscall=false;
                this.showToastmessage(errorT,poRequired,'Error');
            }
            /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------------------- */
            else{
                iscall=true;
            }
            console.log('iscall@@'+iscall);
        } else{
            this.required = false;
            Promise.resolve().then(() => {
                const inputEle = this.template.querySelector('lightning-input');
                inputEle.reportValidity();
            });
            iscall=true;
        }
            if(iscall){
                console.log('this.fileUploderlist===>'+JSON.stringify(this.fileUploderlist));
                console.log('this.poNumber===>'+this.ponumber);
                // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022....added method parameter..poDate...
                var skuSelectedRowData={'poNumber':this.ponumber,'poDoc':this.fileUploderlist,'poDate':this.poDate};
                iscall=skuSelectedRowData;
            }
            return iscall;
    }
    handlechange(event){
        this.ponumber=event.target.value;
    }

    /* ------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------- */
    handlePODatechange(event){
        console.log('handlePODatechange - ', event.target.value);
        var error = false;
        var errMsg = '';

        var crDt = new Date();
        var d = (crDt.getDate() < 10 ? '0' : '') + crDt.getDate();
        var M = ((crDt.getMonth() + 1) < 10 ? '0' : '') + (crDt.getMonth() + 1);
        var y = crDt.getFullYear();
        var currentDt = (y + "-" + M + "-" + d);
        var yy = new Date(currentDt);

        var today = new Date(crDt.getTime() + 86400000); // for current date + 1 ...
        var dd = (today.getDate() < 10 ? '0' : '') + today.getDate();
        var MM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        var yyyy = today.getFullYear();
        var currentDate = (yyyy + "-" + MM + "-" + dd);
        var y = new Date(currentDate);
        var w = '';

        if(event.target.value == null){
            //ordWrap.poDate = "";
            w = "";
        } 
        else{
            w = new Date(event.target.value);
        }
        if(this.showPODate == true && this.isPODateReq == true && (event.target.value == null || event.target.value == '')){
            event.target.value = '';
            this.poDate = '';
            error = true;
            //component.find("po_date").focus();
            errMsg = poRequired;
        }
        /* else if(this.showPODate == true && event.target.value != null && +w < +y){ // commented on request by client...
            error = true;
            this.poDate = '';
            event.target.value = '';
            //component.find("po_date").focus();
            errMsg = poDateNotLessThanToday;
        } */
        else if(event.target.value != null){
            this.poDate = event.target.value;
        }
        else{
            this.poDate = '';
        }

        if(error == true){
            this.showToastmessage(errorT,errMsg,'Error');
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
    /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------ */

    callmethod(){
        window.location.origin + "/" + "a2v6D0000005xbEQAQ";
    }
    @api
    clearmethod(){
        this.fileUploderlist=[];
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if(element.type === 'checkbox' || element.type === 'checkbox-button'){
              element.checked = false;
            }else{
              element.value = null;
            }      
          });
    }
}