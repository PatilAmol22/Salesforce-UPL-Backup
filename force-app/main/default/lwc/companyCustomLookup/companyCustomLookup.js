import { LightningElement,api,track } from 'lwc';
import companySearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.companySearchHandlerApex';

import Create_New from '@salesforce/label/c.Create_New';
import Company from '@salesforce/label/c.Company';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';

export default class CompanyCustomLookup extends LightningElement {
    @api companySelectedRecordName ;
    @api companySelectedId ;
    @api companySelectedValue ;
    @api companyRecordExist ;
    @track companySearchResults = [];
    @api objectApiName;
    @api companyId;
    @api isCompanyRecordNotFound ;
    @track blurTimeout;
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

    label = {
        Company,
        Create_New,
        No_Result_Found
    }

    changeHandler(event) {
        this.SearchHandler(event.target.value);
    }
    changeHandler1(event){
        this.SearchHandler1(event.target.value);
    }

    changeHandler2(event){
        console.log('changeHandler2--'+ event.target.value);
        if(event.target.value === '' || event.target.value === null || event.target.value ===undefined){
            this.companySearchResults = [];
            this.companyRecordExist = false;
            this.isCompanyRecordNotFound = false;
        }
    }

    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    handleClick() {
        //this.searchTerm = '';
        //this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }
    
    SearchHandler(searchKey){
            console.log('searchKey',searchKey);
            companySearchHandlerApex({ 
                searchKey : searchKey,
                objName : this.objectApiName,
            })
            .then(result => {
                console.log('result',result);
                if(result && result.length > 0){
                    this.companyRecordExist = true;
                    this.companySearchResults = result;
                    this.isCompanyRecordNotFound = false;
                }else{
                    this.companyRecordExist = false;
                    this.companySearchResults = [];
                    this.isCompanyRecordNotFound = true;
                }
            }).catch(error =>{
                console.log('error',error);
            });
        
        
    }

    SearchHandler1(searchKey){
       if(searchKey){
        console.log('searchKey',searchKey);
            companySearchHandlerApex({ 
                searchKey : searchKey,
                objName : this.objectApiName,
            })
            .then(result => {
                console.log('result',result);
                if(result && result.length > 0){
                    this.companyRecordExist = true;
                    this.companySearchResults = result;
                    this.isCompanyRecordNotFound = false;
                }else{
                    this.companyRecordExist = false;
                    this.companySearchResults = [];
                    this.isCompanyRecordNotFound = true;
                }
            }).catch(error =>{
                console.log('error',error);
            });
    }else{
        this.companyRecordExist = false;
        this.companySearchResults = [];
        this.isCompanyRecordNotFound = false;
    }
}

  
    onSelectValue(event){
        event.preventDefault();
        this.companySelectedId = event.currentTarget.dataset.recordId
        let index = event.currentTarget.dataset.index;
        this.companySelectedValue = true;
        this.companyRecordExist = false;
        this.isCompanyRecordNotFound = false;
        this.companySelectedRecordName = this.companySearchResults[index].Name;
        const selectedEvent = new CustomEvent("companyvaluechanged", {
            detail: 
            {
                value : this.companySearchResults[index],
            }  
        });
        this.dispatchEvent(selectedEvent); 
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }   
    

    removeValue(event){
            event.preventDefault();
            this.companySelectedValue = false;
            this.companySelectedRecordName = '';
            this.companyRecordExist = false;
            this.companySelectedId = '';
            this.isCompanyRecordNotFound = false;
            this.companySearchResults = [];
            const selectedEvent = new CustomEvent("companyvaluechanged", {
                detail: 
                {
                    isClear :true, 
                }  
            });
            this.dispatchEvent(selectedEvent);  
    }

    createNewCompanyRecord(event){
        event.preventDefault();
        this.companyRecordExist = false;
        this.isCompanyRecordNotFound = false;
        const selectedEvent = new CustomEvent("companyvaluechanged", {
            detail: {
                 isCreateCompanyRecord : true
              }
        });
        this.dispatchEvent(selectedEvent);
    }
}