import { LightningElement, api,track} from 'lwc';
import marketSearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.marketSearchHandlerApex';
import Create_New from '@salesforce/label/c.Create_New';
import Market from '@salesforce/label/c.Market';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';

export default class MarketCustomLookup extends LightningElement {
    
    @api marketSelectedRecordName ;
    @api marketSelectedId ;
    @api marketSelectedValue ;
    @api marketRecordExist ;
    @track marketSearchResults = [];
    @api objectApiName;
    @api companyId;
    @api brandId;
    @api isMarketRecordNotFound ;
    @track MarketName ;
    @track blurTimeout;
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

    label = {
        Create_New,
        Market,
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
       
            marketSearchHandlerApex({ 
                searchKey : searchKey,
                objName : this.objectApiName,
                parentId : this.brandId
            })
            .then(result => {
                if(result && result.length > 0){
                    this.marketRecordExist = true;
                    this.marketSearchResults = result;
                    this.isMarketRecordNotFound = false;
                }else{
                    this.marketRecordExist = false;
                    this.marketSearchResults = [];
                    this.isMarketRecordNotFound = true;
                }
            }).catch(error =>{
                console.log('error',error);
            });
       
    }

  
    onSelectValue(event){
        event.preventDefault();
        this.marketSelectedId = event.currentTarget.dataset.recordId
        let index = event.currentTarget.dataset.index;
        this.marketSelectedValue = true;
        this.marketRecordExist = false;
        this.isMarketRecordNotFound = false;
        this.marketSelectedRecordName = this.marketSearchResults[index].Market__r.Name;
        const selectedEvent = new CustomEvent("marketvaluechanged", {
            detail: 
            {
                value : this.marketSearchResults[index],
            }  
        });
        this.dispatchEvent(selectedEvent);
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'; 
    }   
    @api clearMarket() {
        this.marketSelectedValue = false;
        this.marketSelectedRecordName = undefined;
        this.marketSearchResults = [];
        this.marketRecordExist = false;
        this.marketSelectedId = undefined;
    }

    removeValue(event)
    {
       // event.preventDefault();
        this.marketSelectedValue = false;
        this.marketSelectedRecordName = '';
        this.marketSearchResults = [];
        this.marketRecordExist = false;
        this.marketSelectedId = '';
        this.isMarketRecordNotFound = false;
        const selectedEvent = new CustomEvent("marketvaluechanged", {
            detail: 
            {
                isClear :true, 
            }  
        });
        this.dispatchEvent(selectedEvent);  
    }

    createNewMarketRecord(event){
        event.preventDefault();
        this.isMarketRecordNotFound = false; 
        this.marketRecordExist = false;
        const selectedEvent = new CustomEvent("marketvaluechanged", {
            detail: {
                isCreateMarketRecord : true
              }
        });
        this.dispatchEvent(selectedEvent);
    }
}