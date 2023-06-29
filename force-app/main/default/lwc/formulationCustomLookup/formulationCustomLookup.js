import { LightningElement, api,track} from 'lwc';
import formulationSearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.formulationSearchHandlerApex';
import Create_New from '@salesforce/label/c.Create_New';
import Formulation from '@salesforce/label/c.Formulation';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';

export default class FormulationCustomLookup extends LightningElement {
    
    @api formulationSelectedRecordName ;
    @api formulationSelectedId ;
    @api formulationSelectedValue ;
    @api formulationRecordExist ;
    @track formulationSearchResults = [];
    @api objectApiName;
    @api companyId;
    @api brandId;
    @api isFormulationRecordNotFound ;
    @track blurTimeout;
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

    label = {
        Create_New,
        Formulation,
        No_Result_Found
    }

    connectedCallback(){
        console.log('isFormulationRecordNotFound',this.isFormulationRecordNotFound);
    }

    changeHandler(event) {
        this.SearchHandler(event.target.value);
    }

    changeHandler1(event){
        this.SearchHandler(event.target.value);
       /* console.log('changeHandler1');
        if(event.target.value === '' || event.target.value === null || event.target.value ===undefined){
            this.formulationSearchResults = [];
            this.formulationRecordExist = false;
            this.isFormulationRecordNotFound = false;
        }*/
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
            formulationSearchHandlerApex({ 
                searchKey : searchKey, 
                objName : this.objectApiName,  //BrandFormulation__c
                parentId : this.brandId
            })
            .then(result => {
                if(result && result.length > 0){
                    this.formulationRecordExist = true;
                    this.formulationSearchResults = result;
                    this.isFormulationRecordNotFound = false;
                }else{
                    this.formulationRecordExist = false;
                    this.formulationSearchResults = [];
                    this.isFormulationRecordNotFound = true;
                }
            }).catch(error =>{
                console.log('error',error);
            });
       
    }

  
    onSelectValue(event){
        event.preventDefault();
        this.formulationSelectedId = event.currentTarget.dataset.recordId
        let index = event.currentTarget.dataset.index;
        this.formulationSelectedValue = true;
        this.formulationRecordExist = false;
        this.isFormulationRecordNotFound = false;
        console.log('isFormulationRecordNotFound',this.isFormulationRecordNotFound);
        this.formulationSelectedRecordName = this.formulationSearchResults[index].Formulation__r.Name;
        const selectedEvent = new CustomEvent("formulationvaluechanged", {
            detail: 
            {
                value : this.formulationSearchResults[index],
            }  
        });
        this.dispatchEvent(selectedEvent); 

        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        console.log('name:'+this.formulationSearchResults[index].Name);
        console.log('formulation:'+this.formulationSearchResults[index].Formulation__r.Name);
    }   
    

    removeValue(event){
        event.preventDefault();
        this.formulationSelectedValue = false;
        this.formulationSelectedRecordName = '';
        this.formulationSearchResults = [];
        this.formulationRecordExist = false;
        this.formulationSelectedId = '';
        this.isFormulationRecordNotFound = false;
        const selectedEvent = new CustomEvent("formulationvaluechanged", {
            detail: 
            {
                isClear :true, 
            }  
        });
        this.dispatchEvent(selectedEvent);  
    }

    createNewFormulationRecord(event){
        event.preventDefault();
        this.isFormulationRecordNotFound = false;
        this.formulationRecordExist = false;
        const selectedEvent = new CustomEvent("formulationvaluechanged", {
            detail: {
                isCreateFormulationRecord : true
              }
        });
        this.dispatchEvent(selectedEvent);
    }
}