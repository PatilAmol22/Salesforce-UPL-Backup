import { LightningElement, api, track } from 'lwc';
import searchPackSizeRecordsApex from '@salesforce/apex/CustomlookupControllerUpl.searchPackSizeRecordsApex';
import cropSearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.cropSearchHandlerApex';
import pestSearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.pestSearchHandlerApex';
import aISearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.aISearchHandlerApex';
import familySearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.familySearchHandlerApex';
import marketSearchHandlerApex from '@salesforce/apex/CustomlookupControllerUpl.marketSearchHandlerApex';
import Create_New from '@salesforce/label/c.Create_New';
import Company from '@salesforce/label/c.Company';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';
import Active_Ingredient from '@salesforce/label/c.Active_Ingredient';
import Target_description from '@salesforce/label/c.Target_description';
import Crop_description from '@salesforce/label/c.Crop_description';
import Packsize from '@salesforce/label/c.Packsize';
import Formulation from '@salesforce/label/c.Formulation';
import Brand from '@salesforce/label/c.Brand';

export default class CustomLookup extends LightningElement {
    label = {
        No_Result_Found,
        Company,
        Create_New,
        Brand,
        Formulation,
        Packsize,
        Crop_description,
        Target_description,
        Active_Ingredient
    }
    
    zindexclass;
    @api objectApiName;
    @api selectedValue;
    @api recordExist;
    @api selectedRecordName = '';
    @track searchResults;
    @api selectedId = '';
    @api companyId;
    @api brandId;
    @api formulationId;
    @api isCompany;
    @api isBrand;
    @api isPackSize;
    @api isFormulation;
    @api isCrop;
    @api cropId;
    @api isPest;
    @api pestId;
    @api isAI;
    @api aIId;
    @api isFamily;
    @api familyId;
    @api isMarket;
    @api marketId;
    isRecordNotFound = false;
    isCreateCompanyRecord = false;
    isCreateBrandRecord = false;
    isCreateFormulationRecord = false;
    isCreatePackSizeRecord = false;
    isCreateCropRecord = false;
    isCreatePestRecord = false;
    isCreateAIRecord = false;
    isCreateFamilyRecord = false;
    isCreateMarketRecord = false;
    @track blurTimeout;
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

    
    handleBlurEvent() {
        //this.isEnableShowOptions = false;
        this.selectedValue = false;
        this.searchResults ='';
    }

    changeHandler(event) {
        if (this.isPackSize) {
            this.zindexclass="slds-form-element zindex96";
            this.packSizeSearchHandler(event.target.value);
        }
        if (this.isCrop) {
            this.zindexclass="slds-form-element zindex96";
            this.cropSearchHandler(event.target.value);
        }
        if (this.isPest) {
            this.zindexclass="slds-form-element zindex97";
            this.pestSearchHandler(event.target.value);
        }
        if (this.isAI) {
            this.zindexclass="slds-form-element zindex95";
            this.aISearchHandler(event.target.value);
        }
        if (this.isFamily) {
            this.familySearchHandler(event.target.value);

        }
        if (this.isMarket) {
            this.marketSearchHandler(event.target.value);
        }
    }

    changeHandler1(event) {
        if (this.isPackSize) {
            this.packSizeSearchHandler(event.target.value);
        }
        if (this.isCrop) {
            this.cropSearchHandler(event.target.value);
        }
        if (this.isPest) {
            this.pestSearchHandler(event.target.value);
        }
        if (this.isAI) {
            this.aISearchHandler(event.target.value);
        }
        if (this.isFamily) {
            this.familySearchHandler(event.target.value);

        }
        if (this.isMarket) {
            this.marketSearchHandler(event.target.value);
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



    cropSearchHandler(searchKey) {
        cropSearchHandlerApex({
            searchKey: searchKey,
            objName: this.objectApiName,
        })
            .then(result => {
                if (result && result.length > 0) {
                    this.recordExist = true;
                    this.searchResults = result;
                    this.isRecordNotFound = false;

                } else {
                    this.recordExist = false;
                    this.searchResults = [];
                    this.isRecordNotFound = true;
                }
            });
    }

    packSizeSearchHandler(searchKey) {
        searchPackSizeRecordsApex(
            {
                searchKey: searchKey,
                objName: this.objectApiName,
            }
        )
            .then(result => {
                if (result && result.length > 0) {
                    this.recordExist = true;
                    this.searchResults = result;
                    this.isRecordNotFound = false;
                } else {
                    this.recordExist = false;
                    this.searchResults = [];
                    this.isRecordNotFound = true;
                }
            });
    }

    pestSearchHandler(searchKey) {
        pestSearchHandlerApex({
            searchKey: searchKey,
            objName: this.objectApiName,
        })
            .then(result => {
                console.log('result', result);
                if (result && result.length > 0) {
                    this.recordExist = true;
                    this.searchResults = result;
                    this.isRecordNotFound = false;

                } else {
                    this.recordExist = false;
                    this.searchResults = [];
                    this.isRecordNotFound = true;
                }
            });
    }

    aISearchHandler(searchKey) {
        aISearchHandlerApex({
            searchKey: searchKey,
            objName: this.objectApiName,
        })
            .then(result => {
                console.log('result', result);
                if (result && result.length > 0) {
                    this.recordExist = true;
                    this.searchResults = result;
                    this.isRecordNotFound = false;

                } else {
                    this.recordExist = false;
                    this.searchResults = [];
                    this.isRecordNotFound = true;
                }
            });
    }

    familySearchHandler(searchKey) {
        familySearchHandlerApex({
            searchKey: searchKey,
            objName: this.objectApiName,
            parentId: this.brandId
        })
            .then(result => {
                if (result && result.length > 0) {
                    this.recordExist = true;
                    this.searchResults = result;
                    this.isRecordNotFound = false;
                } else {
                    this.recordExist = false;
                    this.searchResults = [];
                    this.isRecordNotFound = true;
                }
            });
    }

    marketSearchHandler(searchKey) {
        marketSearchHandlerApex({
            searchKey: searchKey,
            objName: this.objectApiName,
            parentId: this.brandId
        })
            .then(result => {
                if (result && result.length > 0) {
                    this.recordExist = true;
                    this.searchResults = result;
                    this.isRecordNotFound = false;

                } else {
                    this.recordExist = false;
                    this.searchResults = [];
                    this.isRecordNotFound = true;
                }
            });
    }

    onSelectValue(event) {
        this.selectedId = event.currentTarget.dataset.recordId
        let index = event.currentTarget.dataset.index;
        this.selectedValue = true;
        this.recordExist = false;
        this.selectedRecordName = this.searchResults[index].Name;

        if (this.isPackSize) {
            const selectedEvent = new CustomEvent("packsizevaluechanged", {
                detail:
                {
                    value: this.searchResults[index],
                }
            });
            this.dispatchEvent(selectedEvent);
            if(this.blurTimeout) {
                clearTimeout(this.blurTimeout);
            }
            this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        }

        if (this.isCrop) {
            const selectedEvent = new CustomEvent("cropvaluechanged", {
                detail:
                {
                    value: this.searchResults[index],
                }
            });
            this.dispatchEvent(selectedEvent);
            if(this.blurTimeout) {
                clearTimeout(this.blurTimeout);
            }
            this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        }

        if (this.isPest) {
            const selectedEvent = new CustomEvent("pestvaluechanged", {
                detail:
                {
                    value: this.searchResults[index],
                }
            });
            this.dispatchEvent(selectedEvent);
            if(this.blurTimeout) {
                clearTimeout(this.blurTimeout);
            }
            this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        }

        if (this.isAI) {
            const selectedEvent = new CustomEvent("aivaluechanged", {
                detail:
                {
                    value: this.searchResults[index],
                }
            });
            this.dispatchEvent(selectedEvent);
            if(this.blurTimeout) {
                clearTimeout(this.blurTimeout);
            }
            this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        }

        if (this.isFamily) {
            const selectedEvent = new CustomEvent("familyvaluechanged", {
                detail:
                {
                    value: this.searchResults[index],
                }
            });
            this.dispatchEvent(selectedEvent);
            if(this.blurTimeout) {
                clearTimeout(this.blurTimeout);
            }
            this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        }

        if (this.isMarket) {
            const selectedEvent = new CustomEvent("marketvaluechanged", {
                detail:
                {
                    value: this.searchResults[index],
                }
            });
            this.dispatchEvent(selectedEvent);
            if(this.blurTimeout) {
                clearTimeout(this.blurTimeout);
            }
            this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        }
        this.recordExist = false;
        this.searchResults = [];
    }


    removeValue() {
        if (this.isPackSize) {
            this.selectedValue = false;
            this.selectedRecordName = undefined;
            this.searchResults = [];
            this.recordExist = false;
            this.selectedId = undefined;
            const selectedEvent = new CustomEvent("packsizevaluechanged", {
                detail:
                {
                    isClear: true,
                }
            });
            this.dispatchEvent(selectedEvent);
        }

        if (this.isCrop) {
            this.selectedValue = false;
            this.selectedRecordName = undefined;
            this.searchResults = [];
            this.recordExist = false;
            this.selectedId = undefined;
            const selectedEvent = new CustomEvent("cropvaluechanged", {
                detail:
                {
                    isClear: true,
                }
            });
            this.dispatchEvent(selectedEvent);
        }

        if (this.isPest) {
            this.selectedValue = false;
            this.selectedRecordName = undefined;
            this.searchResults = [];
            this.recordExist = false;
            this.selectedId = undefined;
            const selectedEvent = new CustomEvent("pestvaluechanged", {
                detail:
                {
                    isClear: true,
                }
            });
            this.dispatchEvent(selectedEvent);
        }

        if (this.isAI) {
            this.selectedValue = false;
            this.selectedRecordName = undefined;
            this.searchResults = [];
            this.recordExist = false;
            this.selectedId = undefined;
            const selectedEvent = new CustomEvent("aivaluechanged", {
                detail:
                {
                    isClear: true,
                }
            });
            this.dispatchEvent(selectedEvent);
        }

        if (this.isFamily) {
            this.selectedValue = false;
            this.selectedRecordName = undefined;
            this.searchResults = [];
            this.recordExist = false;
            this.selectedId = undefined;
            const selectedEvent = new CustomEvent("familyvaluechanged", {
                detail:
                {
                    isClear: true,
                }
            });
            this.dispatchEvent(selectedEvent);
        }

        if (this.isMarket) {
            this.selectedValue = false;
            this.selectedRecordName = undefined;
            this.searchResults = [];
            this.recordExist = false;
            this.selectedId = undefined;
            const selectedEvent = new CustomEvent("marketvaluechanged", {
                detail:
                {
                    isClear: true,
                }
            });
            this.dispatchEvent(selectedEvent);
        }
    }

    createNewPackSizeRecord() {
        let searchKey = this.searchKey;
        const selectedEvent = new CustomEvent("packsizevaluechanged", {
            detail: {
                searchKey: searchKey,
                isCreatePackSizeRecord: true
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    createNewCropRecord() {
        let searchKey = this.searchKey;
        const selectedEvent = new CustomEvent("cropvaluechanged", {
            detail: {
                searchKey: searchKey,
                isCreateCropRecord: true
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    createNewPestRecord(event) {
        let searchKey = this.searchKey;
        const selectedEvent = new CustomEvent("pestvaluechanged", {
            detail: {
                searchKey: searchKey,
                isCreatePestRecord: true
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    createNewAIRecord() {
        console.log('createNewAIRecord', this.searchKey);
        let searchKey = this.searchKey;
        const selectedEvent = new CustomEvent("aivaluechanged", {
            detail: {
                searchKey: searchKey,
                isCreateAIRecord: true
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    createNewFamilyRecord() {
        let searchKey = this.searchKey;
        const selectedEvent = new CustomEvent("familyvaluechanged", {
            detail: {
                searchKey: searchKey,
                isCreateFamilyRecord: true
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    createNewMarketRecord() {
        let searchKey = this.searchKey;
        const selectedEvent = new CustomEvent("marketvaluechanged", {
            detail: {
                searchKey: searchKey,
                isCreateMarketRecord: true
            }
        });
        this.dispatchEvent(selectedEvent);
    }

    @api clearPackSize() {
        this.selectedValue = false;
        this.selectedRecordName = undefined;
        this.searchResults = [];
        this.recordExist = false;
        this.selectedId = undefined;
    }

}