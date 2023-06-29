import { LightningElement ,api,track} from 'lwc';
import brandSearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.brandSearchHandlerApex';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';
import Brand from '@salesforce/label/c.Brand';
import Create_New from '@salesforce/label/c.Create_New';


export default class BrandCustomLookup extends LightningElement {

    @api brandSelectedRecordName ;
    @api brandSelectedId ;
    @api brandSelectedValue ;
    @api brandRecordExist ;
    @track brandSearchResults = [];
    @api objectApiName;
    @api companyId;
    @api brandId;
    @api isBrandRecordNotFound ;
    @track blurTimeout;
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';


    label = {
        No_Result_Found,
        Brand,
        Create_New
    }
    changeHandler(event) {
        this.SearchHandler(event.target.value);
    }
    changeHandler1(event){
        this.SearchHandler1(event.target.value);
    }

    handleClick() {
        //this.searchTerm = '';
        //this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }
    
    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    SearchHandler(searchKey){
        brandSearchHandlerApex({ 
            searchKey : searchKey,
            objName : this.objectApiName,
            parentId : this.companyId
        })
        .then(result => {
            if(result && result.length > 0){
                this.brandRecordExist = true;
                this.brandSearchResults = result;
                this.isBrandRecordNotFound = false;
            }else{
                this.brandRecordExist = false;
                this.brandSearchResults = [];
                this.isBrandRecordNotFound = true;
            }
        }).catch(error =>{
            console.log('error',error);
        });
    }

    SearchHandler1(searchKey){
        if(searchKey){
            brandSearchHandlerApex({ 
                searchKey : searchKey,
                objName : this.objectApiName,
                parentId : this.companyId
            })
            .then(result => {
                if(result && result.length > 0){
                    this.brandRecordExist = true;
                    this.brandSearchResults = result;
                    this.isBrandRecordNotFound = false;
                }else{
                    this.brandRecordExist = false;
                    this.brandSearchResults = [];
                    this.isBrandRecordNotFound = true;
                }
            }).catch(error =>{
                console.log('error',error);
            });
        }else{
            this.brandRecordExist = false;
            this.brandSearchResults = [];
            this.isBrandRecordNotFound = false;
        }
    }

  
    onSelectValue(event){
        event.preventDefault();
        this.brandSelectedId = event.currentTarget.dataset.recordId
        let index = event.currentTarget.dataset.index;
        this.brandSelectedValue = true;
        this.brandRecordExist = false;
        this.isBrandRecordNotFound = false;
        this.brandSelectedRecordName = this.brandSearchResults[index].Name;
        const selectedEvent = new CustomEvent("brandvaluechanged", {
            detail: 
            {
                value : this.brandSearchResults[index],
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
            this.brandSelectedValue = false;
            this.brandSelectedRecordName = '';
            this.searchResults = [];
            this.brandRecordExist = false;
            this.brandSelectedId = '';
            const selectedEvent = new CustomEvent("brandvaluechanged", {
                detail: 
                {
                    isClear :true, 
                }  
            });
            this.dispatchEvent(selectedEvent);  
    }

    createNewBrandRecord(event){
        event.preventDefault();
        let  searchKey =  this.searchKey;
        this.brandRecordExist = false;
        this.isBrandRecordNotFound = false;
        const selectedEvent = new CustomEvent("brandvaluechanged", {
            detail: {
                isCreateBrandRecord : true
              }
        });
        this.dispatchEvent(selectedEvent);
    }
}