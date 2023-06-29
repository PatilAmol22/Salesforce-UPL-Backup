import { LightningElement, api,track} from 'lwc';
import familySearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.familySearchHandlerApex';

import Create_New from '@salesforce/label/c.Create_New';
import Family from '@salesforce/label/c.Family';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';

export default class FamilyCustomLookup extends LightningElement {
    
    @api familySelectedRecordName ;
    @api familySelectedId ;
    @api familySelectedValue ;
    @api familyRecordExist ;
    @track familySearchResults = [];
    @api objectApiName;
    @api companyId;
    @api brandId;
    @api isFamilyRecordNotFound ;
    @track blurTimeout;
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

    label = {
        Create_New,
        Family,
        No_Result_Found
    }
    changeHandler(event) {
        this.SearchHandler(event.target.value);
    }

    changeHandler1(event){
        this.SearchHandler(event.target.value);
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
        
            familySearchHandlerApex({ 
                searchKey : searchKey,
                objName : this.objectApiName,
                parentId : this.brandId
            })
            .then(result => {
                if(result && result.length > 0){
                    this.familyRecordExist = true;
                    this.familySearchResults = result;
                    this.isFamilyRecordNotFound = false;
                }else{
                    this.familyRecordExist = false;
                    this.familySearchResults = [];
                    this.isFamilyRecordNotFound = true;
                }
            }).catch(error =>{
                console.log('error',error);
            });
       
    }

  
    onSelectValue(event){
        event.preventDefault();
        this.familySelectedId = event.currentTarget.dataset.recordId
        let index = event.currentTarget.dataset.index;
        this.familySelectedValue = true;
        this.familyRecordExist = false;
        this.isFamilyRecordNotFound = false;
        this.familySelectedRecordName = this.familySearchResults[index].Family__r.Name;
        const selectedEvent = new CustomEvent("familyvaluechanged", {
            detail: 
            {
                value : this.familySearchResults[index],
            }  
        });
        this.dispatchEvent(selectedEvent); 
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }   
    
    @api clearFamily() {
        this.familySelectedValue = false;
        this.familySelectedRecordName = undefined;
        this.familySearchResults = [];
        this.familyRecordExist = false;
        this.familySelectedId = undefined;
    }

     removeValue(event){
        event.preventDefault();
        this.familySelectedValue = false;
        this.familySelectedRecordName = '';
        this.familySearchResults = [];
        this.familyRecordExist = false;
        this.familySelectedId = '';
        this.isFamilyRecordNotFound = false;
        const selectedEvent = new CustomEvent("familyvaluechanged", {
            detail: 
            {
                isClear :true, 
            }  
        });
        this.dispatchEvent(selectedEvent);  
    }

    createNewFamilyRecord(event){
        event.preventDefault();
        this.isFamilyRecordNotFound = false;
        this.familyRecordExist = false;

        const selectedEvent = new CustomEvent("familyvaluechanged", {
            detail: {
                isCreateFamilyRecord : true 
              }
        });
        this.dispatchEvent(selectedEvent);
    }
}