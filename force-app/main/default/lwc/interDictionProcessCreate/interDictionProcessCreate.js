import { LightningElement,track,wire,api} from 'lwc';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import 	DATEOFREQUEST from '@salesforce/label/c.BRZ_DATE_OF_REQUEST';
import IsAnInterDiction from '@salesforce/label/c.BRZ_IS_AN_INTERDICTION';
import termNumber from '@salesforce/label/c.Brz_Term_Number';
import DueDate from '@salesforce/label/c.BRZ_DUE_DATE';
import reason from '@salesforce/label/c.BRZ_REASON';
import 	Priority from '@salesforce/label/c.BRZ_PRIORITY';
import 	street from '@salesforce/label/c.BRZ_STREET';
import 	CNPJ_CPF from '@salesforce/label/c.CNPJ_CPF';
import SUBURB from '@salesforce/label/c.BRZ_SUBURB';
import Save from '@salesforce/label/c.BRZ_SAVE';
import POSTCODE from '@salesforce/label/c.BRZ_POSTCODE';
import Contact from '@salesforce/label/c.BRZ_CONTACT';
import InterCity from '@salesforce/label/c.Inter_City';
import InterDictionState from '@salesforce/label/c.InterDiction_State';
import ESTIMATEDCOLLECTIONDATE from '@salesforce/label/c.BRZ_ESTIMATED_COLLECTION_DATE';
import 	DATEOFREALCOLLECTION from '@salesforce/label/c.BRZ_DATE_OF_REAL_COLLECTION';
import getPicklistTypeFields from '@salesforce/apex/InderdictionProcessController.getPicklistTypeFields';
import 	DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR from '@salesforce/label/c.BRZ_DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR';
import 	ENTRY_CLOSED from '@salesforce/label/c.BRZ_ENTRY_CLOSED';
import 	EMAIL_LOGISTICS_OPERATOR from '@salesforce/label/c.BRZ_EMAIL_LOGISTICS_OPERATOR';
import 	Interdiction_UpperCase_only from '@salesforce/label/c.Interdiction_UpperCase_only';
import interdiction_COMMENTS from '@salesforce/label/c.interdiction_COMMENTS';
import AGENT_EMAIL from '@salesforce/label/c.BRZ_AGENT_EMAIL';
import 	LOGISTICS from '@salesforce/label/c.BRZ_LOGISTICS';
import INTER_ATTACHMENTS from '@salesforce/label/c.INTER_ATTACHMENTS';
import Number from '@salesforce/label/c.BRZ_NUMBER';
import Create_Interdiction_Process from '@salesforce/label/c.Create_Interdiction_Process';
import Legal from '@salesforce/label/c.BRZ_LEGAL';
import Product from '@salesforce/label/c.BRZ_PRODUCT';
import Quantity from '@salesforce/label/c.BRZ_QUANTITY';
import Batch from '@salesforce/label/c.BRZ_BATCH';
import Expire_Date from '@salesforce/label/c.BRZ_Expire_Date';
import saveDetails from '@salesforce/apex/InderdictionProcessController.saveDetails';
import saveProductDetails from '@salesforce/apex/InderdictionProcessController.saveProductDetails';
import getProduct from '@salesforce/apex/InderdictionProcessController.getProduct';
import DeleteFilesOnChange from '@salesforce/apex/InderdictionProcessController.DeleteFilesOnChange';
import updatecheckBoxFileRecord from '@salesforce/apex/InderdictionProcessController.updatecheckBoxFileRecord';
import updateFileRecord from '@salesforce/apex/InderdictionProcessController.updateFileRecord';
import { NavigationMixin } from 'lightning/navigation';
import Raise_Interdiction_Process from '@salesforce/label/c.Raise_Interdiction_Process';
import record_Created from '@salesforce/label/c.Record_was_saved';
import recordwasnot_Created from '@salesforce/label/c.Record_was_not_saved';
import Fill_mandatory_fields from '@salesforce/label/c.Fill_mandatory_fields';
import Vendor from '@salesforce/label/c.BRZ_VENDOR_CODE';
import CUSTOMER_DETAILS from '@salesforce/label/c.INTER_CUSTOMER_DETAILS';
import ADD_PRODUCT from '@salesforce/label/c.BRZ_ADD_PRODUCT';
import 	Interdiction_Numeric_Value from '@salesforce/label/c.Interdiction_Numeric_Value';
import Delete from '@salesforce/label/c.Delete';
import File_Name from '@salesforce/label/c.File_Name';
import ErrorT from '@salesforce/label/c.Error';
import You_are_not_allowed_to_delete_record from '@salesforce/label/c.You_are_not_allowed_to_delete_record';
const COLUMNS=[
  { label:"Ação",type: "button", typeAttributes: {  
    variant:'base',
  label: 'Selecione',  
  name: 'Select',  
  title: 'Select',  
  disabled: false,  
  value: 'Select',  
  iconPosition: 'left'  
} },
{ label: 'SKU', fieldName: 'Name', type: 'text' },
{ label: 'CÓDIGO SKU', fieldName: 'SKU_Code__c', type: 'text' }];
export default class InterDictionProcessCreate  extends NavigationMixin(LightningElement) {
  COLUMNS=COLUMNS;

  skuCode;
  objList=[];
  showfileForTable=false;
 @track listOfAccounts;
 @track filesData = [];
 @track DocIdList=[];
 @track contentId=[];
 @track docId;
 @track arrayToPass=[];
 @track tableRowIndex=1; 
    dateval;
     @track visibleProducts;
    label = {
        DATEOFREQUEST,
        IsAnInterDiction,
        termNumber,
        DueDate,
        reason,
        Priority,
        street,
        CNPJ_CPF,
        SUBURB,
        POSTCODE,
        Contact,
        InterCity,
        InterDictionState,
        ESTIMATEDCOLLECTIONDATE,
        DATEOFREALCOLLECTION,
        DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR,	
        ENTRY_CLOSED,	
        EMAIL_LOGISTICS_OPERATOR,
        CUSTOMER_DETAILS,
        interdiction_COMMENTS,
        AGENT_EMAIL,INTER_ATTACHMENTS,
        LOGISTICS,
        INTER_ATTACHMENTS,
        Create_Interdiction_Process,
        Raise_Interdiction_Process,
      Number,
      Legal,
    Save,
    Product,
    Quantity,
    Expire_Date,
    Batch,
    record_Created,
    recordwasnot_Created,
    Vendor,
    ADD_PRODUCT,Fill_mandatory_fields,Interdiction_UpperCase_only,Interdiction_Numeric_Value,Delete,File_Name,ErrorT,You_are_not_allowed_to_delete_record};
     
       @api columns = [
        { label: File_Name, fieldName: 'Title' }, 
        
        // { label: Download, type:  'button', typeAttributes: { 
        //     label: Download, name: 'Download', variant: 'brand', cellAttributes:{iconName: 'action:download'}, 
        //     iconPosition: 'right' 
        // } 
        // },
        { label: Delete, type:  'button', typeAttributes: { 
            label: Delete,   name: 'Delete',   variant: 'destructive',cellAttributes:{iconName: 'standard:record_delete'}, 
            iconPosition: 'right' 
        }
        }
    ];
       Logistica=false;
       Legal=false;
 @track showTable = false;
  @track recordsToDisplay = []; //Records to be displayed on the page
     rowNumberOffset=1; //Row number
    @track bool=false;
    @track isModalOpen=false;
    @track showTableVar=false;
    @track showFields=false;
    @track recordid;
   @track fileData=[];
 
    @track error;
    @track dateOfRequest;
    @track dateOfRealCollection;
    @track Term;
    @track street1;
  @track submission;
    @track picklistResult;
    @track priorMapdata=[];
    @track ReasonPick=[];
    @track interPick=[];
    @track StatePick=[];
   @track showError=false;
    showLoadingSpinner = false;
    @track fileNames = '';
    @track filesUploaded = [];
    @track validateList=[];
    @track dateOfRequest;
    @track dueDate;
    @track showIntError=false;
    @track showResError=false;
    @track showStateError=false;
    @track reason;
    @track priority;
    @track insc;
    @track number;
    @track cnpj;
    @track sub;
    @track razao;
    @track POSTCODE;
    @track con;
    @track city;
    @track State;
    @track ecd;
    @track EntryClosed;
    @track elo;
    @track comm;
    @track aEmail;
    @track isAnInter;
    @track uploadedNames=[];
filesList=[];
   @track saveProgress=[];
log;
@track productName;
@track ProductQuantity;
@track productBatch;
@track productExpireDate;
@track productArray=[];
@track fileForTable=[];

    connectedCallback(){
      this.showIntError = false;
      getPicklistTypeFields() 
      .then((result)=>{
        for (let key in result) {
          console.log('result'+JSON.stringify(result));
         console.log('var 1'+result["PRIORITY__c"]+key);
         if(key=='PRIORITY__c'){
          
          this.priorMapdata.push({value:result[key], key:key});
          console.log('priorMapdata'+JSON.stringify(this.priorMapdata));
         }
          if(key=='REASON__c'){
          this.ReasonPick.push({label:result[key], value:result[key]});
         }
         if(key=='IS_AN_INTERDICTION__c'){
          this.interPick.push({value:result[key], key:key});

         }
         if(key=='STATE__c'){
          this.StatePick.push({value:result[key], key:key});

         }
       
          
       }
       
      this.picklistResult=result;
      console.log('this.picklistResult'+JSON.stringify(this.mapData));
      })
      .catch((error) => {
        console.log('In connected call back error....');
        this.error = error;
        // This way you are not to going to see [object Object]
        console.log('Error is', this.error); 
    });
      this.initData();
    }
     initData() {
        let listOfAccounts = [];
        this.createRow(listOfAccounts);
        this.listOfAccounts = listOfAccounts;
    }

    createRow(listOfAccounts) {
        let prodObject = {};
        if(listOfAccounts.length > 0) {
          prodObject.index = listOfAccounts[listOfAccounts.length - 1].index + 1;
        } else {
          prodObject.index = 1;
        }
        prodObject.Name ='';
        prodObject.SKU_Code__c='';
        prodObject.Batch__c = null;
        prodObject.Quantity__c = null;
        prodObject.Expire_Date__c = null;
        console.log('prodobject'+JSON.stringify(prodObject));
        listOfAccounts.push(prodObject);
        console.log('this.prodObj'+JSON.stringify(this.listOfAccounts));

    }
   
  
    addNewRow() {
      //this.listOfAccounts=[];
     
    
        this.createRow(this.listOfAccounts);
        this.tableRowIndex =this.tableRowIndex+1;
    }
 
  get dateValue(){
    if(this.dateval == undefined)
    {
      this.dateval = new Date().toISOString().substring(0, 10);
    }
    return this.dateval;
  }
  Priorityvalue(event){
    this.priority = event.target.value;
  console.log('is bb'+JSON.stringify(this.priority));
  this.saveProgress.push({value:this.priority,key:'PRIORITY__c'});
  if(this.template.querySelector('.prioVal').value == ''){
    console.log('gv error');
    this.showError=true;

  }else{
    this.showError = false;
    this.template.querySelector('[data-id="myDiv3"]').classList.remove('slds-has-error');
  }
  }
  onValueChangeInter(event){
    this.isAnInter = event.target.value;
    console.log('is bb'+JSON.stringify(this.isAnInter));
    this.saveProgress.push({value:this.isAnInter,key:'IS_AN_INTERDICTION__c'});
    if(event.target.value=='Sim')
    {
      this.showFields=true;
      
    }

    else{
      this.showFields=false;
    }
    if(this.template.querySelector('.interselect').value == ''){
      console.log('inter error');
     // this.template.querySelector('[data-id="myDiv1"]').classList.add('div1');
     
      this.showIntError=true;
  
    }else{
      this.template.querySelector('[data-id="myDiv1"]').classList.remove('slds-has-error'); 
      this.showIntError = false;
    }
  }
  onValueChangeReason(event){
    this.reason = event.target.value;
  console.log('is bb'+JSON.stringify(this.reason));
  this.saveProgress.push({value:this.reason,key:'REASON__c'});
  if(this.template.querySelector('.reasonSel').value == ''){
    console.log('rwasonsel error');
    this.showResError=true;

  }else{
    this.showResError = false;
    this.template.querySelector('[data-id="myDiv2"]').classList.remove('slds-has-error');
  }
  }
  onValueChangeState(event){
    this.State = event.target.value;
  console.log('is bb'+JSON.stringify(this.State));
  this.saveProgress.push({value:this.State,key:'STATE__c'});
  if(this.template.querySelector('.reasonSel').value == ''){
    console.log('rwasonsel error');
    this.showStateError=true;

  }else{
    this.showStateError = false;
    this.template.querySelector('[data-id="myDivState"]').classList.remove('slds-has-error');
  }
  }
  onValueChange(event){
    
    if(event.target.name == 'DATE_OF_REQUEST__c'){
      this.dateOfRequest = event.target.value;
      var d=new Date( this.dateOfRequest).toLocaleDateString('en-GB');
      console.log('d'+d);
      this.saveProgress.push({value:d,key:'DATE_OF_REQUEST__c'});
      console.log('123'+ JSON.stringify(this.saveProgress));
  }
   if(event.target.name == 'DATE_OF_REAL_COLLECTION__c'){
    this.dateOfRealCollection  = event.target.value;
    console.log('uyftf'+this.dateOfRealCollection);
    var d=new Date( this.dateOfRealCollection).toLocaleDateString('en-GB');
    this.saveProgress.push({value:d,key:'DATE_OF_REAL_COLLECTION__c' });
    console.log('tttt'+JSON.stringify(this.saveProgress));
}
 if(event.target.name == 'TERM_NUMBER__c'){
  const inputBox = event.currentTarget;
  console.log('term'+inputBox);
  inputBox.setCustomValidity('');
  this.Term = event.target.value;
  this.saveProgress.push({value:this.Term,key:'TERM_NUMBER__c'});
  console.log('tttt'+JSON.stringify(this.saveProgress));
}
 if(event.target.name == 'DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR__c'){
  this.submission = event.target.value;
  console.log('this.submission'+this.submission);
  var d=new Date(this.submission ).toLocaleDateString('en-GB');
  console.log('d'+d);
  this.saveProgress.push({value:this.submission,key:'DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR__c'});
}
 if(event.target.name == 'DUE_DATE__c'){
  
  this.dueDate= event.target.value;
  var d=new Date( this.dueDate).toLocaleDateString('en-GB');
  console.log('vvv'+this.dueDate);
  this.saveProgress.push({value:d,key:'DUE_DATE__c'});
  if(this.dueDate!=''){
     this.template.querySelector('.dDate').setCustomValidity('');
  }
  
}
else if(event.target.name == 'REASON__c'){
  this.reason = event.target.value;
  console.log('is bb'+this.reason);
  this.saveProgress.push({value:this.reason,key:'REASON__c'});
}

else if(event.target.name == 'CNPJ_CPF__c'){
  this.cnpj = event.target.value;
  this.saveProgress.push({value:this.cnpj,key:'CNPJ_CPF__c'});
}
else if(event.target.name == 'NUMBER__c'){
  this.number = event.target.value;
  this.saveProgress.push({value:this.number,key:'NUMBER__c'});
}
else if(event.target.name == 'STREET__c'){
  this.street1 = event.target.value;
  this.saveProgress.push({value:this.street1,key:'STREET__c'});
}
else if(event.target.name == 'INSCRI_O_ESTADUAL__c'){
  this.insc = event.target.value;
  this.saveProgress.push({value:this.insc,key:'INSCRI_O_ESTADUAL__c'});
}
else if(event.target.name == 'SUBURB__c'){
  this.sub = event.target.value;
  this.saveProgress.push({value:this.sub,key:'SUBURB__c'});
}
else if(event.target.name == 'RAZ_O_SOCIAL__c'){
  this.razao = event.target.value;
  this.saveProgress.push({value:this.razao,key:'RAZ_O_SOCIAL__c'});
}
else if(event.target.name == 'POSTCODE__c'){
  this.POSTCODE = event.target.value;
  this.saveProgress.push({value:this.POSTCODE,key:'POSTCODE__c'});
}
else if(event.target.name == 'CONTACT__c'){
  this.con = event.target.value;
  this.saveProgress.push({value:this.con,key:'CONTACT__c'});
}
else if(event.target.name == 'CITY__c'){
  this.city = event.target.value;
  this.saveProgress.push({value:this.city,key:'CITY__c'});
}
else if(event.target.name == 'STATE__c'){
  this.State = event.target.value;
  this.saveProgress.push({value:this.State,key:'STATE__c'});
}
else if(event.target.name == 'ESTIMATED_COLLECTION_DATE__c'){
  this.ecd = event.target.value;
  var d=new Date( this.ecd).toLocaleDateString('en-GB');

  this.saveProgress.push({value:d,key:'ESTIMATED_COLLECTION_DATE__c'});
}
else if(event.target.name == 'ENTRY_CLOSED__c'){
  this.EntryClosed = event.target.value;
  var d=new Date( this.EntryClosed).toLocaleDateString('en-GB');
  this.saveProgress.push({value:d,key:'ENTRY_CLOSED__c'});

}
else if(event.target.name == 'EMAIL_LOGISTICS_OPERATOR_Brazil__c'){
  this.elo = event.target.value;
  this.elo=this.elo.replaceAll(',',';');
  console.log('email logic'+this.elo);
  this.saveProgress.push({value:this.elo,key:'EMAIL_LOGISTICS_OPERATOR_Brazil__c'});
}

else if(event.target.name == 'AGENT_EMAIL_Brazil__c'){
  this.aEmail = event.target.value;
  this.aEmail=this.aEmail.replaceAll(',',';');
  this.saveProgress.push({value:this.aEmail,key:'AGENT_EMAIL_Brazil__c'});
}

else if(event.target.name == 'COMMENTS__c'){
  this.comm = event.target.value;
  this.saveProgress.push({value:this.comm,key:'COMMENTS__c'});
}
else if(event.target.name == 'Vendor__c'){
  this.comm = event.target.value;
  this.saveProgress.push({value:this.comm,key:'Vendor__c'});
}
  }

showTableFunc(){
  this.showTableVar=true;
  
}

 removeRow(event) {
  console.log('remove row');
        let toBeDeletedRowIndex = event.target.name;

        let listOfAccounts = [];
        for(let i = 0; i < this.listOfAccounts.length; i++) {
            let tempRecord = Object.assign({}, this.listOfAccounts[i]); //cloning object
            if(tempRecord.index !== toBeDeletedRowIndex) {
                listOfAccounts.push(tempRecord);
            }
        }

        for(let i = 0; i < listOfAccounts.length; i++) {
            listOfAccounts[i].index = i + 1;
        }

        this.listOfAccounts = listOfAccounts;
        this.tableRowIndex=this.tableRowIndex-1;
    }

  
  handleForSave()
  {
   
    const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
    .reduce((validSoFar, inputField) => {

    
        inputField.reportValidity();
        console.log('add'+inputField.reportValidity()+'@@@@@2 '+validSoFar+ '****** '+inputField.checkValidity());
       if(inputField.reportValidity()==false){
        const toastEvent = new ShowToastEvent({
          //title: 'Erro',
        message: this.label.Fill_mandatory_fields,
        variant: 'error',
        //mode: 'dismissable'
        });
        this.dispatchEvent(toastEvent);
      }
        return validSoFar && inputField.checkValidity();

      
        
    }, true);
    this.validateFields();
    console.log('thiss.validate'+this.validateList);
    if(this.validateList.includes('true')){
      const toastEvent = new ShowToastEvent({
        //title: 'Erro',
      message: this.label.Fill_mandatory_fields,
      variant: 'error',
      //mode: 'dismissable'
      });
      this.dispatchEvent(toastEvent);
    } 
    console.log('this.validateFields()'+!this.validateList.includes('true'))
    if(isInputsCorrect && !this.validateList.includes('true')){
      
      console.log('test save');
    saveDetails({fields:JSON.stringify(this.saveProgress)})
    .then(result=>{
      console.log('enters un save');
      console.log('enterrrr');
        this.getInterRecords={};
        this.recordid=result;
        this.saveProgress=[];
        window.console.log('after save' + this.recordid);
        //this.productArray.push({value:this.recordid,key:'Interdiction_Process__c'});
        //console.log('thos.productArray'+JSON.stringify(this.productArray)+"*******"+JSON.stringify(this.listOfAccounts));
        if(this.recordid!=null){
        saveProductDetails({recordId:this.recordid,productFields:JSON.stringify(this.listOfAccounts)})
        .then(result=>{
console.log('entereeeeee in product');
console.log('success');
        })
        .catch(error=>{
          console.log('product error');

        });
      }
        if(this.recordid!=null && this.DocIdList.length>0 ){
        updateFileRecord({recordId:this.recordid,filedata:JSON.stringify(this.DocIdList)})
        .then(result=>{
console.log('entereeeeee');
console.log('success');
        })
        .catch(error=>{
          console.log('error while uploadeing file');

        });
        
      }
      
       
        
        const toastEvent = new ShowToastEvent({
          title:'Sucesso!',
          message:this.label.record_Created,
          variant:'success'
        });
        this.dispatchEvent(toastEvent);
        this.handleNavigate();
        this.saveProgress=[];

    })
    .catch(error=>{
       this.error=error.message;
       const evt = new ShowToastEvent({
        title: 'Erro',
        message: this.label.recordwasnot_Created,
        variant: 'error',
        mode: 'dismissable'

      });
      this.dispatchEvent(evt);
       console.log(this.error);
    });

     }
  
  }
  
  handleNavigate() {
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.recordid,
            actionName: 'view',
        }
    })
  
}

    validateFields() {
      
     this.validateList=[];
      if(this.template.querySelector('.prioVal').value == ''){
        console.log('gv error');
        this.template.querySelector('[data-id="myDiv3"]').className='slds-has-error';
        this.validateList.push('true');
        this.showError=true;

      }else{
        console.log('enter in pri else');
        this.showError = false;
        this.validateList.push('false');
      }
      if(this.template.querySelector('.interselect').value == ''){
        this.validateList.push('true');
        console.log('gv error');
         this.template.querySelector('[data-id="myDiv1"]').className='slds-has-error';
        this.showIntError=true;

      }else{
        console.log('enter in inter else');
        this.showIntError = false;
        this.validateList.push('false');
      }
      if(this.template.querySelector('.reasonSel').value == ''){
        this.validateList.push('true');
        console.log('res error');
        this.template.querySelector('[data-id="myDiv2"]').className='slds-has-error';
        this.showResError=true;

      }else{
        console.log('enter in reason else');
        this.showResError = false;
        this.validateList.push('false');
      }
      if(this.template.querySelector('.interstate').value == ''){
        this.validateList.push('true');
        console.log('res error');
        this.template.querySelector('[data-id="myDivState"]').className='slds-has-error';
        this.showStateError=true;

      }else{
        console.log('enter in reason else');
        this.showStateError = false;
        this.validateList.push('false');
      }
      
    if(this.showFields==true){
     if(this.isAnInter=='Sim' && this.Term==undefined && this.dueDate==undefined ){
      console.group('validity');
      this.template.querySelector('.term1').setCustomValidity('Para valor Sim este campo é obrigatório');
      this.template.querySelector('.dDate').setCustomValidity('Para valor Sim este campo é obrigatório');
      this.validateList.push('true');
      console.log('vali'+this.validateList);
     
     }
     else if(this.isAnInter=='Sim'  && (this.Term==undefined || this.dueDate==undefined)){
      if(this.Term==undefined){
        this.template.querySelector('.term1').setCustomValidity('Para valor Sim este campo é obrigatório');
        this.validateList.push('true');
      }
      else if(this.dueDate==undefined){
        this.template.querySelector('.dDate').setCustomValidity('Para valor Sim este campo é obrigatório');
        this.validateList.push('true');
      }
     }
  
   
     this.template.querySelector('.term1').reportValidity('');
     this.template.querySelector('.dDate').reportValidity('');
     this.validateList.push('false');
     //this.template.querySelector('.prioVal').reportValidity();
    }
      }
    
     
      handleUploadFinished(event){
        console.log('ressssssss upload'+JSON.stringify(this.fileForTable));
        const uploadedFiles = event.detail.files;
        const jsonObject = JSON.parse(JSON.stringify(uploadedFiles));
        console.log('jsonObje'+JSON.stringify(jsonObject));
        console.log('evee'+JSON.stringify(event.detail.files));
        let mainList = [];
        
        let objList = JSON.parse(JSON.stringify(event.detail.files));
        let arry = [];
        arry = JSON.parse(JSON.stringify(this.filesList));
        objList.forEach(function(item){
            console.log('handleUploadFinished 113 - ');
            let obj = {"ContentDocumentId":item.documentId,"Title":item.name};
            arry.push(obj);
        },this);
        //this.syncAllData();
        this.filesList = arry;
        arry = [];
        this.filesList.forEach(function(item2){
            console.log('handleUploadFinished 121 - ');
            let obj = {"docId":item2.ContentDocumentId,"name":item2.Title};
            arry.push(obj);
        },this);
        mainList = arry;
       
        console.log('this.filesList - ', JSON.parse(JSON.stringify(this.filesList)));
        for(let i=0;i<this.filesList.length;i++){
          this.DocIdList.push(this.filesList[i].ContentDocumentId);
        }
        console.log(' this.DocIdList 705'+ JSON.stringify(this.DocIdList));
    //     for(let i=0;i<uploadedFiles.length;i++){
    //        this.objList.push({'Title':uploadedFiles[i].name,'ContentDocumentId':uploadedFiles[i].documentId,index:i});
    //     }
    //     this.fileForTable=this.objList;
        if(this.filesList.length>0){
          this.showfileForTable=true;
        }
    //     console.log('this.filee'+JSON.stringify(this.fileForTable));
    //     //this.objList=JSON.stringify(event.detail.files);
    //     console.log('this.objList'+JSON.stringify(this.objList));
        
    //    let uploadedFileNames='';
    //    if(uploadedFiles.length==1){
    //     if(this.fileData.length>0){
    //       console.log('lengh 1');
    //     uploadedFileNames =this.fileData+',' +uploadedFiles[0].name;
    //     }
    //     else{
    //       console.log('lengh 2');
    //       uploadedFileNames +=uploadedFiles[0].name;
    //     }
    //     this.fileData=uploadedFileNames;
    //     console.log('fileData'+this.fileData);
    //         this.docId=uploadedFiles[0].documentId;
    //         this.DocIdList.push( this.docId);
    //         this.contentId.push(uploadedFiles[0].contentVersionId);
    //    }
    //    else{
    //     for(let i = 0; i < uploadedFiles.length; i++) {
    //         uploadedFileNames =   this.fileData +','+uploadedFiles[i].name ;
    //       this.fileData=uploadedFileNames;
    //       this.fileData=this.fileData.replace(/^,|,$/g, '');
    //         this.docId=uploadedFiles[i].documentId;
    //         this.DocIdList.push( this.docId);
    //         this.contentId.push(uploadedFiles[i].contentVersionId);
    //         console.log('uplo'+ this.fileData);
            
        
    //   }
    // }
      
    //     console.log('uploaded files'+ JSON.stringify(this.fileData));
        
            //this.syncAllData();
            //this.filesList = arry;
       
      //  for(let i=0;i<this.objList;i++){

      //  }
            console.log('this.file',JSON.stringify(this.filesList));
        updatecheckBoxFileRecord({filedata:JSON.stringify(this.DocIdList)})
        .then(result=>{
     console.log('updated filess');
        })
        .catch(error=>{
          console.log('error while auto update'+error);

        });
        console.log('doc id'+this.DocIdList);
        console.log('con id'+this.contentId);
        sessionStorage.setItem('DocIdList',this.DocIdList);
        console.log('test default'+sessionStorage.getItem('DocIdList'));
        window.onbeforeunload=function(event) {
         event.preventDefault();
           console.log('docc'+sessionStorage.getItem('DocIdList'));
           this.arrayToPass=sessionStorage.getItem('DocIdList');
           console.log('array'+JSON.stringify(this.arrayToPass));
        DeleteFilesOnChange({filedata:sessionStorage.getItem('DocIdList')})
        .then(result=>{
     console.log('deleted filess'+sessionStorage.getItem('DocIdList'));
        })
        .catch(error=>{
          console.log('error while auto update'+error);

        });
       
        }

        window.addEventListener('popstate', function (ev) { 
          console.log('windoww'+sessionStorage.getItem('DocIdList'));
          DeleteFilesOnChange({filedata:sessionStorage.getItem('DocIdList')})
        .then(result=>{
     console.log('deleted filess');
        })
        .catch(error=>{
          console.log('error while auto update'+error);

        });
    
});
    
      }
     
     
     closeModal()
     {
        this.isModalOpen=false;
     }
    
     skuId;
     proName;
    changeProduct(event){
   console.log('change');
    let index = event.target.dataset.id;
    let fieldName = event.target.name;
    let value = event.target.value;
console.log('this.li'+JSON.stringify(this.listOfAccounts)+'@@@@@@' +fieldName+ '####' +value);
    for(let i = 0; i < this.listOfAccounts.length; i++) {
      this.listOfAccounts.map(e => {
        if(e.index == this.tableRowIndex){
       e[fieldName]=value;
        }
      // console.log('this.listOfAccounts[i][fieldName]'+this.listOfAccounts[i][fieldName]);

      //   if(this.listOfAccounts[i].index === parseInt(index)) {
         
      //       this.listOfAccounts[i][fieldName] = value;
      //       this.listOfAccounts[i].SKU_Code__c=this.proName;
      //       this.listOfAccounts[i].Name=this.skuId;
            
        }
      )}
    
   
    console.log('this.lost'+JSON.stringify(this.listOfAccounts));

    }
    showProducts(){
      this.isModalOpen=true;
      getProduct()
       .then(result=>{
         console.log('resultt'+JSON.stringify(result));
           this.error = undefined;
           this.log=result;
           console.log('proddd'+this.log);
           this.showTable=true;
           console.log('this.log'+JSON.stringify(this.log));
           
       }) 
      .catch(error=>{
         console.log('error while auto update'+error);

       });
   }
    closeModal()
    {
       this.isModalOpen=false;
    }
    productFromModal;
  handleRowAction(event){
   
    console.log('changee'+this.tableRowIndex);
    this.listOfAccounts.map(e => {
      if(e.index==this.tableRowIndex){
      e.SKU_Code__c=event.detail.row.Id;
      e.Name=event.detail.row.Name;
      }
      
    })
    // this.listOfAccounts[0].push({value:event.detail.row.Name,key:'Name'})
    // this.listOfAccounts[0].push({value:event.detail.row.Id,key:'SKU_Code__c'})
    console.log('listOfAccounts'+JSON.stringify(this.listOfAccounts));
    this.isModalOpen=false;
    //this.productName=event.detail.row.Name;
    // this.productFromModal=this.productName;
    // this.skuCode=event.detail.row.Id;
  
   
    console.log('prodd'+this.productName);
    //this.productName=[];
  } 
   handlePaginatorChange(event){
console.log('event.detail'+event.detail);
      this.recordsToDisplay = event.detail;
      // console.log('this.recordsToDisplayssssssss '+JSON.stringify(this.recordsToDisplay));
      // this.rowNumberOffset = this.recordsToDisplay[0].length-1;
  }
  handleInputFocus(event){
    console.log('focus');
  }
   handleRowActionForFileDelete(event){
     
        const actionName = event.detail.action.name;
        let row = event.detail.row;
        console.log('row'+JSON.stringify(row));
        
       this.filesList  = this.filesList.filter(item => {
                        return item.ContentDocumentId !== row.ContentDocumentId ;
                    });
                    console.log('this.fileList 891' +JSON.stringify(this.filesList));
                    let mainList = [];
                    mainList = JSON.parse(JSON.stringify(this.filesList));
                    console.log('mainList'+JSON.stringify(mainList));
                   this.fileData=mainList;
                   console.log('this.fileData'+JSON.stringify(this.fileData)+'length'+this.fileData.length);
                    console.log('this before dos'+JSON.stringify(this.DocIdList));
                    this.DocIdList=[]
                   for(let i=0;i<this.fileData.length;i++){
                     
                     
                     this.DocIdList.push(this.fileData[i].ContentDocumentId);
                     
                   }
                  // console.log('this before dos'+JSON.stringify(this.DocIdList));
                  //  this.DocIdList  = this.DocIdList.filter(item => {
                  //       return item.ContentDocumentId !== row.ContentDocumentId ;
                  //   });
                   console.log('this dos'+JSON.stringify(this.DocIdList));
                   if(this.fileData.length==0){
                     console.log('enter in length zero');
                   this.DocIdList=[];
                   }
                   if(this.filesList==''){
                     this.showfileForTable=false;
                   }
                    
            }
            
        
 
    
   
    removeReceiptImage(){
      var index = event.currentTarget.dataset.id;
        this.fileData.splice(index, 1);
    }
}