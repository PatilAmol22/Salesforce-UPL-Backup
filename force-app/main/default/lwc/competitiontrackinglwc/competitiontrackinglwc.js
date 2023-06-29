import { LightningElement, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
const activeSections = ['Basic Information', 'Product Details', 'Pack Details', 'Price & Scheme Details', 'Update Label Claim'];
import createCompanyRecord from '@salesforce/apex/CompetitiontrackingController.createCompanyRecord';
import createFormulationRecord from '@salesforce/apex/CompetitiontrackingController.createFormulationRecord';
import createBrandRecord from '@salesforce/apex/CompetitiontrackingController.createBrandRecord';
import createPackSizeRecord from '@salesforce/apex/CompetitiontrackingController.createPackSizeRecord';
import createCropRecord from '@salesforce/apex/CompetitiontrackingController.createCropRecord';
import createPestRecord from '@salesforce/apex/CompetitiontrackingController.createPestRecord';
import createAIRecord from '@salesforce/apex/CompetitiontrackingController.createAIRecord';
import createFamilyRecord from '@salesforce/apex/CompetitiontrackingController.createFamilyRecord';
import createMarketRecord from '@salesforce/apex/CompetitiontrackingController.createMarketRecord';
import saveCompetitorDataApex from '@salesforce/apex/CompetitiontrackingController.saveCompetitorDataApex';
import savePriceSchemeDataApex from '@salesforce/apex/CompetitiontrackingController.savePriceSchemeDataApex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveUpdateLabelClaimDataApex from '@salesforce/apex/CompetitiontrackingController.saveUpdateLabelClaimDataApex';
import Company from '@salesforce/label/c.Company';
import Brand from '@salesforce/label/c.Brand';
import Formulation from '@salesforce/label/c.Formulation';
import Imported_Product from '@salesforce/label/c.Imported_Product';
import Price_Scheme_Details from '@salesforce/label/c.Price_Scheme_Details';
import Packsize from '@salesforce/label/c.Packsize';
import Scheme_Details from '@salesforce/label/c.Scheme_Details';
import Supplier from '@salesforce/label/c.Supplier_price';
import SupplierRPD from '@salesforce/label/c.Supplier_Price_with_RPD';
import SupplierWoRPD from '@salesforce/label/c.Supplier_Price_without_RPD';
import SupplierTentitive from '@salesforce/label/c.Supplier_price_Tentative_Per_Ha_Cost_Ha';

import Distributor_price from '@salesforce/label/c.Distributor_price';
import Distributor_priceRPD from '@salesforce/label/c.Distributor_price_with_RPD';
import Distributor_priceWoRPD from '@salesforce/label/c.Distributor_price_without_RPD';
import Distributor_priceTentitive from '@salesforce/label/c.Distributor_price_Tentative_Per_Ha_Cost_Ha';
import Distributor_Name from '@salesforce/label/c.Distributor_Name';

import Farmer_Price from '@salesforce/label/c.Farmer_Price';
import Farmer_PriceRPD from '@salesforce/label/c.Farmer_price_with_RPD';
import Farmer_PriceWoRPD from '@salesforce/label/c.Farmer_price_without_RPD';
import Farmer_PriceTentitive from '@salesforce/label/c.Farmer_price_Tentative_Per_Ha_Cost_Ha';
import Farmer_Name from '@salesforce/label/c.Farmer_Name';
import Import_price from '@salesforce/label/c.Import_price';
import Import_priceRPD from '@salesforce/label/c.Import_price_with_RPD';
import Import_priceWoRPD from '@salesforce/label/c.Import_price_without_RPD';
import Import_priceTentitive from '@salesforce/label/c.Import_price_Tentative_Per_Ha_Cost_Ha';


import Information_reliability_Scale from '@salesforce/label/c.Information_reliability_Scale';
import COMMENTS from '@salesforce/label/c.COMMENTS';
import Upload_Files_or_drop_files from '@salesforce/label/c.Upload_Files_or_drop_files';
import PRODUCT_Details from '@salesforce/label/c.PRODUCT_Details';
import Crop_description from '@salesforce/label/c.Crop_description';
import Target_description from '@salesforce/label/c.Target_description';
import Active_Ingredient from '@salesforce/label/c.Active_Ingredient';
import Market from '@salesforce/label/c.Market';
import Family from '@salesforce/label/c.Family';
import Dose_Ha from '@salesforce/label/c.Dose_Ha';
import Number_of_applications_per_year from '@salesforce/label/c.Number_of_applications_per_year';
import Other_information_DRE_ZNT_DVP from '@salesforce/label/c.Other_information_DRE_ZNT_DVP';
import AMM_End_date from '@salesforce/label/c.AMM_End_date';
import Use_end_date from '@salesforce/label/c.Use_end_date';
import Sale_end_date from '@salesforce/label/c.Sale_end_date';
import Company_Name from '@salesforce/label/c.Company_Name';
import Brand_Name from '@salesforce/label/c.Brand_Name';
import Formulation_Name from '@salesforce/label/c.Formulation_Name';
import Pack_Size_Name from '@salesforce/label/c.Pack_Size_Name';
import Crop_Name from '@salesforce/label/c.Crop_Name';
import Pest_Name from '@salesforce/label/c.Pest_Name';
import Active_Ingredient_Name from '@salesforce/label/c.Active_Ingredient_Name';
import Family_Name from '@salesforce/label/c.Family_Name';
import Market_Name from '@salesforce/label/c.Market_Name';
import With_RPD from '@salesforce/label/c.With_RPD';
import Without_RPD from '@salesforce/label/c.Without_RPD';
import Tentative_Ha_Cost from '@salesforce/label/c.Tentative_Ha_Cost';
import IRS from '@salesforce/label/c.IRS';
import Basic_Information from '@salesforce/label/c.Basic_Information';
import Reporting_Date from '@salesforce/label/c.Reporting_Date';
import Supplier_details from '@salesforce/label/c.Supplier_details';
import Import_details from '@salesforce/label/c.Import_details';
import Distributor_Details from '@salesforce/label/c.Distributor_Details';
import Farmer_details from '@salesforce/label/c.Farmer_details';
import Other_details from '@salesforce/label/c.Other_details';
import Crop_category from '@salesforce/label/c.Crop_category';
import Add from '@salesforce/label/c.Add';
import Reset from '@salesforce/label/c.Reset';
import Save from '@salesforce/label/c.Save';
import Cancel from '@salesforce/label/c.Cancel';
import Website from '@salesforce/label/c.Website';
import Update_Label_Claim from '@salesforce/label/c.Update_Label_Claim';


export default class competitiontrackinglwc extends NavigationMixin(LightningElement) {
    //Company lookup attribute
    label = {
        Website,
        Add,
        Reset,
        Save,
        Cancel,
        Company,
        Brand,
        Formulation,
        Imported_Product,
        Price_Scheme_Details,
        Update_Label_Claim,
        Packsize,
        Scheme_Details,
        Supplier,
        SupplierRPD,
        SupplierWoRPD,
        SupplierTentitive,
        Distributor_price,
        Distributor_priceRPD,
        Distributor_priceWoRPD,
        Distributor_priceTentitive,
        Distributor_Name,
        Farmer_Price,
        Farmer_PriceRPD,
        Farmer_PriceWoRPD,
        Farmer_PriceTentitive,
        Farmer_Name,
        Import_price,
        Import_priceRPD,
        Import_priceWoRPD,
        Import_priceTentitive,
        Information_reliability_Scale,
        COMMENTS,
        Upload_Files_or_drop_files,
        PRODUCT_Details,
        Crop_description,
        Target_description,
        Active_Ingredient,
        Market,
        Family,
        Dose_Ha,
        Number_of_applications_per_year,
        Other_information_DRE_ZNT_DVP,
        AMM_End_date,
        Use_end_date,
        Sale_end_date,
        Company_Name,
        Brand_Name,
        Formulation_Name,
        Pack_Size_Name,
        Crop_Name,
        Pest_Name,
        Active_Ingredient_Name,
        Family_Name,
        Market_Name,
        With_RPD,
        Without_RPD,
        Tentative_Ha_Cost,
        IRS,
        Basic_Information,
        Reporting_Date,
        Supplier_details,
        Import_details,
        Distributor_Details,
        Farmer_details,
        Other_details,
        Crop_category,
        Pest_Name
    };

    companySelectedRecordName = '';
    companySelectedId = '';
    companySelectedValue = false;
    companyRecordExist = false;
    companyId = '';
    isCompanyRecordNotFound = false;

    //brand lookup attribute

    brandSelectedRecordName = '';
    brandSelectedId = '';
    brandSelectedValue = false;
    brandRecordExist = false;
    brandId = '';
    isBrandRecordNotFound = false;

    //formulation lookup attribute

    formulationSelectedRecordName = '';
    formulationSelectedId = '';
    formulationSelectedValue = false;
    formulationRecordExist = false;
    formulationId = '';
    isFormulationRecordNotFound = false;


    //family lookup attribute

    familySelectedRecordName = '';
    familySelectedId = '';
    familySelectedValue = false;
    familyRecordExist = false;
    familyId = '';
    isFamilyRecordNotFound = false;

    //market lookup attribute

    marketSelectedRecordName = '';
    marketSelectedId = '';
    marketSelectedValue = false;
    marketRecordExist = false;
    marketId = '';
    isMarketRecordNotFound = false;

    //pack lookup attribute ID
    packSizeId;
    //corp Id lookup 
    cropId;

    pestId;
    aIId;
    familyId;
    marketId;
    isBrand;
    isFormulation;
    isPackSize;
    isCrop;
    isPest;
    isAI;
    isFamily;
    isMarket;
    isOpenCompanyModel = false;
    isOpenPackSizeModel = false;
    isOpenBrandModel = false;
    isOpenFormulationModel = false;
    isOpenCropModel = false;
    isOpenPestModel = false;
    isOpenAIModel = false;
    isOpenMarketModel = false;
    isOpenFamilyModel = false;
    selectedRecordName;
    selectedValue = false;

    isDisplayTable = false
    isDisplayTableClaim = false
    todayDate;
    @track activeSections = activeSections

    @track companyObj = { 'Name': '', 'Website': '' };
    @track brandObj = { 'Name': '' };
    @track formulationObj = { 'Name': '' };
    @track packSizeObj = { 'Name': '' };
    @track cropObj = { 'Name': '', 'crop_categorey__c': '' };
    @track pestObj = { 'Name': '' };
    @track AIObj = { 'Name': '' };
    @track familyObj = { 'Name': '' };
    @track marketObj = { 'Name': '' };
    @track UpdateClaimList = [];
    @track priceSchemeDetailList = [];

    @track priceSchemeDetailObj =
        {
            PackSizeId: '',
            PackSizeName: '',
            SupplierPrice: '',
            SupplierPriceRPD: '',
            SupplierPriceWoRPD: '',
            SupplierPriceTentitive: '',
            ImportPrice: '',
            ImportPriceWoRPD: '',
            ImportPriceRPD:'',
            ImportPriceTentitive: '',
            DistributorPrice: '',
            DistributorPriceTentitive:'',
            DistributorPriceWoRPD:'',
            DistributorPriceRPD:'',
            DistributorName:'',
            SchemeDetail: '',
            Comments: '',
            FarmerPrice: '',
            FarmerPriceRPD:'',
            FarmerPriceWoRPD:'',
            FarmerPriceTentitive:'',
            FarmerName:'',
            InformationReliabilityScale: '',
            contentDocumentIds: [],
            documentNames: []

        };

    @track competitorObject =
        {
            Company__c: '',
            Brand__c: '',
            Formulation__c: '',
            Import_Product__c: false,
            Reporting_Date__c:''
        };

    @track updateLabelClaimObject =
        {
            CropId: '',
            CropName: '',
            PestId: '',
            PestName: '',
            AIId: '',
            AIName: '',
            FamilyId: '',
            FamilyName: '',
            MarketId: '',
            MarketName: '',
            Dose: '',
            NoOfApplications: '',
            AMMEndDate: '',
            SaleEndDate: '',
            UseEndDate: '',
            OtherInformation: '',
            Comments: ''
        };

    contentDocumentsId = [];
    contentDocumentName = [];

    connectedCallback() {
        var dateVar = new Date();
        //Current Date 
        this.todayDate = new Date(dateVar.getTime() + dateVar.getTimezoneOffset() * 60000).toISOString();
        this.competitorObject.Reporting_Date__c = this.todayDate;
    }

    get options() {
        return [
            { label: '--None--', value: '--None--' },
            { label: 'Haute', value: 'High' },
            { label: 'Moyenne', value: 'Middle' },
            { label: 'Faible', value: 'Low' },
        ];
    }

    get CropOptions() {
        return [
            { label: 'Fruit', value: 'Fruit' },
            { label: 'Kharif', value: 'Kharif' },
            { label: 'Oil', value: 'Oil' },
            { label: 'Other', value: 'Other' },
            { label: 'Paddy', value: 'Paddy' },
            { label: 'Pulses', value: 'Pulses' },
            { label: 'Rabi', value: 'Rabi' },
            { label: 'Sugar', value: 'Sugar' },
            { label: 'Vegetables', value: 'Vegetables' },
            { label: 'Plantation', value: 'Plantation' },
            { label: 'Food', value: 'Food' },
        ];
    }

    changeHandler(e) {
        if (e.target.type === 'checkbox') {
            this[e.currentTarget.dataset.object][e.currentTarget.dataset.fieldapi] = e.target.checked;
        } else {
            this[e.currentTarget.dataset.object][e.currentTarget.dataset.fieldapi] = e.target.value;
        }
    }

    /*handleChange(e){
        let entry = e.target.value;
        let lastChar = entry.slice(-1);
        console.log(entry, entry.slice(0,-1), lastChar, isNaN(lastChar));
        console.log('isfinite'+isFinite(lastChar));
        console.log('isNaN'+isNaN(lastChar));
        console.log('lastChar'+lastChar);
        if(!isNaN(lastChar) && lastChar!= ' '){
            this.template.querySelector('[data-entry]').value = entry.slice(0,-1);
        }
        this[e.currentTarget.dataset.object][e.currentTarget.dataset.fieldapi] = e.target.value;
    }

    handleChangeFarm(e){
        let entry = e.target.value;
        let lastChar = entry.slice(-1);
        console.log(entry, entry.slice(0,-1), lastChar, isNaN(lastChar));
        if(!isNaN(lastChar) && lastChar!= ' ') {
            this.template.querySelector('[data-entryfarm]').value = entry.slice(0,-1);
        }
        this[e.currentTarget.dataset.object][e.currentTarget.dataset.fieldapi] = e.target.value;
    }*/

    handleBlurEvent() {
        this.isEnableShowOptions = false;
        this.searchTerm ='';
    }

    companyEventHandler(event) {
        if (event.detail.isClear) {
            this.companyId = '';
            this.companySelectedValue = false;
            this.companySelectedRecordName = '';
            this.companyRecordExist = false;
            this.companySelectedId = '';
            this.isCompanyRecordNotFound = false;
        } else if (event.detail.isCreateCompanyRecord) {
            this.isOpenCompanyModel = true;
        } else {
            this.companyId = event.detail.value.Id;
            this.competitorObject.Company__c = event.detail.value.Id;
        }
    }

    brandEventHandler(event) {
        if (event.detail.isClear) {
            this.brandId = '';
            this.brandSelectedRecordName = '';
            this.brandSelectedId = '';
            this.brandSelectedValue = false;
            this.brandRecordExist = false;
            this.isBrandRecordNotFound = false;
        } else if (event.detail.isCreateBrandRecord) {
            this.isOpenBrandModel = true;
        } else {
            console.log(event.detail.value.Id);
            this.brandId = event.detail.value.Id;
            console.log(this.brandId);
            this.competitorObject.Brand__c = event.detail.value.Id;
        }
    }

    formulationEventHandler(event) {
        if (event.detail.isClear) {
            this.formulationSelectedRecordName = '';
            this.formulationSelectedId = '';
            this.formulationSelectedValue = false;
            this.formulationRecordExist = false;
            this.formulationId = '';
            this.isFormulationRecordNotFound = false;
        } else if (event.detail.isCreateFormulationRecord) {
            this.isOpenFormulationModel = true;
            this.isFormulationRecordNotFound = false;
        } else {
            this.formulationId = event.detail.value.Id;
            this.competitorObject.Formulation__c = event.detail.value.Formulation__c;
            console.log('event.detail.value.Id:***' + event.detail.value.Id);
            console.log('event.detail.value.Formulation__c:***' + event.detail.value.Formulation__c);
        }
    } 
    familyEventHandler(event) {
        if (event.detail.isClear) {
            this.familySelectedRecordName = '';
            this.familySelectedId = '';
            this.familySelectedValue = false;
            this.familyRecordExist = false;
            this.familyId = '';
            this.isFamilyRecordNotFound = false;
        } else if (event.detail.isCreateFamilyRecord) {
            this.isOpenFamilyModel = true;
        } else {
            this.familyId = event.detail.value.Family__c; //Id
            this.updateLabelClaimObject.Family__c = event.detail.value.Family__c; //Id
            this.updateLabelClaimObject.FamilyId = event.detail.value.Family__c;  //Id
            this.updateLabelClaimObject.FamilyName = event.detail.value.Family__r.Name;  //changed now
        }
    }
    marketEventHandler(event) {
        if (event.detail.isClear) {
            this.marketSelectedRecordName = '';
            this.marketSelectedId = '';
            this.marketSelectedValue = false;
            this.marketRecordExist = false;
            this.marketId = '';
            this.isMarketRecordNotFound = false;
        } else if (event.detail.isCreateMarketRecord) {
            this.isOpenMarketModel = true;
        } else {
            this.marketId = event.detail.value.Market__c;
            this.updateLabelClaimObject.Market__c = event.detail.value.Market__c;
            this.updateLabelClaimObject.MarketId = event.detail.value.Market__c;
            this.updateLabelClaimObject.MarketName = event.detail.value.Market__r.Name;
            console.log('event.detail.value.Market__r.Name**'+event.detail.value.Market__r.Name);
            console.log('event.detail.value.Market__c'+event.detail.value.Market__c);
        }
    } 
    /*marketEventHandler(event) {
        if (event.detail.isClear) {
            this.marketId = undefined;
        } else if (event.detail.isCreateMarketRecord) {
            this.isOpenMarketModel = true;
        } else {
            this.marketId = event.detail.value.Id;
            this.updateLabelClaimObject.MarketId = event.detail.value.Id;
            this.updateLabelClaimObject.MarketName = event.detail.value.Name;
        }
    }*/
    /*familyEventHandler(event) {
        if (event.detail.isClear) {
            this.familyId = undefined;
        } else if (event.detail.isCreateFamilyRecord) {
            this.isOpenFamilyModel = true;
        } else {
            this.familyId = event.detail.value.Id;
            this.updateLabelClaimObject.FamilyId = event.detail.value.Id;
            this.updateLabelClaimObject.FamilyName = event.detail.value.Name;
        }
    }*/
    cropEventHandler(event) {
        if (event.detail.isClear) {
            this.cropId = undefined;
        } else if (event.detail.isCreateCropRecord) {
            this.isOpenCropModel = true;
        } else {
            this.cropId = event.detail.value.Id;
            this.updateLabelClaimObject.CropId = event.detail.value.Id;
            this.updateLabelClaimObject.CropName = event.detail.value.Name;
        }
    }

    pestEventHandler(event) {
        if (event.detail.isClear) {
            this.pestId = undefined;
        } else if (event.detail.isCreatePestRecord) {
            this.isOpenPestModel = true;
        } else {
            this.pestId = event.detail.value.Id;
            this.updateLabelClaimObject.PestId = event.detail.value.Id;
            this.updateLabelClaimObject.PestName = event.detail.value.Name;
        }
    }

    AIEventHandler(event) {
        if (event.detail.isClear) {
            this.AIId = undefined;
        } else if (event.detail.isCreateAIRecord) {
            this.isOpenAIModel = true;
        } else {
            this.AIId = event.detail.value.Id;
            this.updateLabelClaimObject.AIId = event.detail.value.Id;
            this.updateLabelClaimObject.AIName = event.detail.value.Name;
        }
    }

    packSizeEventHandler(event) {
        if (event.detail.isClear) {
            this.brandId = undefined;
        } else if (event.detail.isCreatePackSizeRecord) {
            this.isOpenPackSizeModel = true;
        } else {
            this.packSizeId = event.detail.value.Id;
            this.priceSchemeDetailObj.PackSizeId = event.detail.value.Id;
            this.priceSchemeDetailObj.PackSizeName = event.detail.value.Name;
        }
    }

    handleClick(event) {
        if (this.isOpenCompanyModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenCompanyModel = false;
            }
            if (event.target.name === 'Save') {
                console.log('companyObj', this.companyObj);
                if (this.companyObj.Name === '') {
                    this.showNotification('error', 'Veuillez saisir le nom de l\'entreprise');
                }
                else {
                    createCompanyRecord({ companyObj: this.companyObj }).then(result => {
                        console.log('result', result);
                        if (result) {
                            this.showNotification('success', 'Société enregistrée');
                            this.isOpenCompanyModel = false;
                            this.companyId = result.Id;
                            this.competitorObject.Company__c = this.companyId;
                            this.companySelectedId = this.companyId;
                            this.companySelectedRecordName = result.Name;
                            this.companySelectedValue = true;
                            this.companyRecordExist = false;
                            this.isCompanyRecordNotFound = false;
                        } else {
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenCompanyModel = true;
                        }
                    })
                        .catch(error => {
                            this.error = error;
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenCompanyModel = true;
                        });
                }
            }
        }
        if (this.isOpenBrandModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenBrandModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.companyId) {
                    if (this.brandObj.Name === '') {
                        this.showNotification('error', 'Veuillez saisir le nom de la marque');
                    }
                    else {
                        createBrandRecord({ brandObj: this.brandObj, companyId: this.companyId }).then(result => {
                            if (result) {
                                this.showNotification('success', 'Marque enregistrée!');
                                this.isOpenBrandModel = false;
                                this.brandId = result.Id;
                                this.competitorObject.Brand__c = this.brandId;
                                this.brandSelectedId = this.brandId;
                                this.brandSelectedRecordName = result.Name;
                                this.brandSelectedValue = true;
                                this.brandRecordExist = false;
                                this.isBrandRecordNotFound = false;
                            } else {
                                this.showNotification('error', 'something went wrong!');
                                this.isOpenBrandModel = true;
                            }
                        }).catch(error => {
                            this.error = error;
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenBrandModel = true;
                        });
                    }
                } else {
                    this.showNotification('error', 'Merci de séléctionner une société !!!');
                    this.isOpenBrandModel = true;
                }
            }
        }

        if (this.isOpenFormulationModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenFormulationModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.brandId) {
                    if (this.formulationObj.Name === '') {
                        this.showNotification('error', 'Merci de saisir une formulation');
                    }
                    else {
                        createFormulationRecord({ formulationObj: this.formulationObj, brandId: this.brandId }).then(result => {
                            if (result) {
                                this.showNotification('success', 'Formulation enregistée!');
                                this.isOpenFormulationModel = false;
                                this.formulationId = result.Id;
                                this.competitorObject.Formulation__c = this.formulationId;
                                this.formulationSelectedId = this.formulationId;
                                this.formulationSelectedRecordName = result.Name;
                                this.formulationSelectedValue = true;
                                this.formulationRecordExist = false;
                                this.isFormulationRecordNotFound = false;
                                console.log('This:::', this.isFormulationRecordNotFound);

                            } else {
                                this.showNotification('error', 'something went wrong!');
                                this.isOpenFormulationModel = true;
                                this.isFormulationRecordNotFound = false;
                            }
                        }).catch(error => {
                            this.error = error;
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenFormulationModel = true;
                        });
                    }
                } else {
                    this.showNotification('error', 'Merci de selectionner une marque !');
                    this.isOpenFormulationModel = true;
                }
            }
        }

        if (this.isOpenPackSizeModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenPackSizeModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.packSizeObj.Name === '') {
                    this.showNotification('error', 'Veuillez saisir un conditionnement');
                }
                /* else if ( RegExp(this.packSizeObj.Name, "[a-z A-Z]" )) { // "^[a-z A-Z]*$"
                     this.showNotification('error','Please enter only numbers');
                 } */
                else {
                    createPackSizeRecord({ packSizeObj: this.packSizeObj }).then(result => {
                        if (result) {
                            this.showNotification('success', 'Conditionnement enregisté!');
                            this.isOpenPackSizeModel = false;
                            this.selectedRecordName = result.Name;
                            this.packSizeId = result.Id;
                        } else {
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenPackSizeModel = true;
                        }
                    }).catch(error => {
                        this.error = error;
                        this.showNotification('error', 'something went wrong! ');
                        this.isOpenPackSizeModel = true;
                    });
                }
            }
        }

        if (this.isOpenCropModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenCropModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.cropObj.Name === '') {
                    this.showNotification('error', 'Veuillez sélectionner une culture');
                }
                else {
                    createCropRecord({ cropObj: this.cropObj }).then(result => {
                        if (result) {
                            this.showNotification('success', 'Culture enregistée!');
                            this.isOpenCropModel = false;
                            this.cropId = result.Id;
                        } else {
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenCropModel = true;
                        }
                    }).catch(error => {
                        this.error = error;
                        this.showNotification('error', 'something went wrong!');
                        this.isOpenCropModel = true;
                    });
                }
            }
        }

        if (this.isOpenPestModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenPestModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.pestObj.Name === '') {
                    this.showNotification('error', 'Veuillez selectionner une cible');
                }
                else {
                    createPestRecord({ pestObj: this.pestObj }).then(result => {
                        if (result) {
                            this.showNotification('success', 'Cible enregistée!');
                            this.isOpenPestModel = false;
                            this.pestId = result.Id;
                        } else {
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenPestModel = true;
                        }
                    }).catch(error => {
                        this.error = error;
                        this.showNotification('error', 'something went wrong!');
                        this.isOpenPestModel = true;
                    });
                }
            }
        }

        if (this.isOpenAIModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenAIModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.AIObj.Name === '') {
                    this.showNotification('error', 'Veuillez sélectionner une matière active');
                }
                else {
                    createAIRecord({ aIObj: this.AIObj }).then(result => {
                        if (result) {
                            this.showNotification('success', 'Matière active enregistée' );
                            this.isOpenAIModel = false;
                            this.AIId = result.Id;
                        } else {
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenAIModel = true;
                        }
                    }).catch(error => {
                        this.error = error;
                        this.showNotification('error', 'something went wrong!');
                        this.isOpenAIModel = true;
                    });
                }
            }
        }

        if (this.isOpenFamilyModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenFamilyModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.brandId) {
                    if (this.familyObj.Name === '') {
                        this.showNotification('error', 'Veuillez selectionner une famille');
                    }
                    else {
                        createFamilyRecord({ familyObj: this.familyObj, brandId: this.brandId }).then(result => {
                            console.log('isFamilyRecordNotFound', result)
                            if (result) {
                                this.showNotification('success', 'Famille enregistée!');
                                this.isOpenFamilyModel = false;
                                this.familyId = result.Id;
                                this.updateLabelClaimObject.FamilyId = this.familyId; 
                                this.updateLabelClaimObject.FamilyName = result.Name; 
                                this.familySelectedId = this.familyId;
                                this.familySelectedRecordName = result.Name;
                                this.familySelectedValue = true;
                                this.familyRecordExist = false;
                                this.isFamilyRecordNotFound = false;
                                console.log('isFamilyRecordNotFound', this.isFamilyRecordNotFound);
                            } else {
                                this.showNotification('error', 'something went wrong!');
                                this.isOpenFamilyModel = true;
                            }
                        }).catch(error => {
                            this.error = error;
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenFamilyModel = true;
                        });
                    }
                } else {
                    this.showNotification('error', 'Veuillez selectionner une marque !');
                    this.isOpenFamilyModel = true;
                }
            }
        }

        if (this.isOpenMarketModel) {
            if (event.target.name === 'Cancel') {
                this.isOpenMarketModel = false;
            }
            if (event.target.name === 'Save') {
                if (this.brandId) {
                    if (this.marketObj.Name === '') {
                        this.showNotification('error', 'Veuillez sélectionner un marché');
                    }
                    else {
                        createMarketRecord({ marketObj: this.marketObj, brandId: this.brandId }).then(result => {
                            if (result) {
                                this.showNotification('success', 'Marché enregistré!');
                                this.isOpenMarketModel = false;
                                this.marketId = result.Id;
                                this.updateLabelClaimObject.MarketId = this.marketId; 
                                this.updateLabelClaimObject.MarketName = result.Name;
                                this.marketSelectedId = this.marketId;
                                this.marketSelectedRecordName = result.Name;
                                this.marketSelectedValue = true;
                                this.marketRecordExist = false;
                                this.isMarketRecordNotFound = false;
                                console.log('isMarketRecordNotFound', this.isMarketRecordNotFound);
                            } else {
                                this.showNotification('error', 'something went wrong!');
                                this.isOpenMarketModel = true;
                            }
                        }).catch(error => {
                            this.error = error;
                            this.showNotification('error', 'something went wrong!');
                            this.isOpenMarketModel = true;
                        });
                    }
                } else {
                    this.showNotification('error', 'Veuillez selectionner une marque !');
                    this.isOpenMarketModel = true;
                }
            }
        }
    }

    handleclickValidation() {
        let isFound = false;
        let ispackfound = false;
      
        if (this.priceSchemeDetailObj.SupplierPriceRPD === '' && this.priceSchemeDetailObj.SupplierPriceWoRPD === '' && this.priceSchemeDetailObj.SupplierPriceTentitive === '' && this.priceSchemeDetailObj.ImportPriceRPD === '' && this.priceSchemeDetailObj.ImportPriceWoRPD === '' && this.priceSchemeDetailObj.ImportPriceTentitive === '' && this.priceSchemeDetailObj.DistributorPriceRPD === '' && this.priceSchemeDetailObj.DistributorPriceWoRPD === '' && this.priceSchemeDetailObj.DistributorPriceTentitive === '' && this.priceSchemeDetailObj.FarmerPriceRPD === '' && this.priceSchemeDetailObj.FarmerPriceWoRPD === '' && this.priceSchemeDetailObj.FarmerPriceTentitive === '') {
            isFound = true;
        }
        if (this.priceSchemeDetailObj.PackSizeId === '') {
            ispackfound = true;
        }
        if (isFound == true) {
            this.showNotification('error', 'Au moins un champ est obligatoire à remplir : Prix Agriculteur / Prix Fournisseur / Prix Import / Prix Distributeur');
        }
        else if (ispackfound == true) {
            this.showNotification('error', 'Veuillez selectionner un conditionnement');
        }
        else if (this.packSizeObj.FarmerName ){
            this.showNotification('error', 'Veuillez saisir du texte uniquement');
        }
        else {
            this.addRows();
        }   
    }
    addRows() {
        let priceSchemeDetailList = this.priceSchemeDetailList;
        if (this.priceSchemeDetailObj) {
            this.priceSchemeDetailObj.contentDocumentIds = this.contentDocumentsId;
            this.priceSchemeDetailObj.documentNames = this.contentDocumentName;
            this.contentDocumentsId = [];
            this.contentDocumentName = [];
            console.log('this.priceSchemeDetailObj' + JSON.stringify(this.priceSchemeDetailObj));
            priceSchemeDetailList.push(this.priceSchemeDetailObj);
        }
        this.priceSchemeDetailList = priceSchemeDetailList;
        console.log('priceSchemeDetailList', this.priceSchemeDetailList);
        if (this.priceSchemeDetailList && this.priceSchemeDetailList.length > 0) {
            this.isDisplayTable = true;
            this.resetPackSizeSection();
        }
    }

    handleclickValidationClaim() {
        let isFound = false;

        console.log('this.competitorObject.Formulation__c' + this.competitorObject.Formulation__c);

        console.log(' this.marketId' + this.marketId);
        console.log(' this.familyId' + this.familyId);
       
        //this.updateLabelClaimObject.MarketId = this.marketId;
        //this.updateLabelClaimObject.FamilyId = this.familyId;
        console.log('this.updateLabelClaimObject.MarketId' + this.updateLabelClaimObject.MarketId);
        console.log('this.updateLabelClaimObject.FamilyId' + this.updateLabelClaimObject.FamilyId);
        console.log('this.updateLabelClaimObject.CropId' + this.updateLabelClaimObject.CropId);
        if (this.updateLabelClaimObject.CropId === '' || this.updateLabelClaimObject.MarketId === '' || this.updateLabelClaimObject.PestId === '' || this.updateLabelClaimObject.AIId === '' || this.updateLabelClaimObject.FamilyId === '') {
            isFound = true;
        }
        if (isFound == true) {
            this.showNotification('error', 'Veuillez remplir les champs obligatoires..!!');
        }
        else {
            this.addRowsUpdateClaim();
        }
    }

    addRowsUpdateClaim() {
        let UpdateClaimList = this.UpdateClaimList;
        if (this.updateLabelClaimObject) {
            UpdateClaimList.push(this.updateLabelClaimObject);
        }
        this.UpdateClaimList = UpdateClaimList;
        if (this.UpdateClaimList && this.UpdateClaimList.length > 0) {
            this.isDisplayTableClaim = true;
            this.resetSectionClaim();
        }
    }

    resetPackSizeSection() {
        this.selectedValue = false;
        this.selectedRecordName = undefined;
        this.selectedId = undefined;
        let priceSchemeDetailObj =
        {
            PackSizeId: '',
            PackSizeName: '',
            SupplierPrice: '',
            SupplierPriceRPD: '',
            SupplierPriceWoRPD: '',
            SupplierPriceTentitive: '',
            ImportPrice: '',
            ImportPriceWoRPD: '',
            ImportPriceRPD:'',
            ImportPriceTentitive: '',
            DistributorPrice: '',
            DistributorPriceTentitive:'',
            DistributorPriceWoRPD:'',
            DistributorPriceRPD:'',
            DistributorName:'',
            SchemeDetail: '',
            Comments: '',
            FarmerPrice: '',
            FarmerPriceRPD:'',
            FarmerPriceWoRPD:'',
            FarmerPriceTentitive:'',
            FarmerName:'',
            InformationReliabilityScale: ''
        };
        this.priceSchemeDetailObj = priceSchemeDetailObj;
        this.contentDocumentsId = [];
        this.contentDocumentName = [];
        this.template.querySelectorAll('c-custom-lookup')[0].clearPackSize();
    }

    resetSectionClaim() {
        this.selectedValue = false;
        this.selectedRecordName = undefined;
        this.selectedId = undefined;
        let updateLabelClaimObject =
        {
            CropId: '',
            PestId: '',
            AIId: '',
            FamilyId: '',
            MarketId: '',
            CropName: '',
            PestName: '',
            AIName: '',
            FamilyName: '',
            MarketName: '',
            Dose: '',
            NoOfApplications: '',
            AMMEndDate: '',
            SaleEndDate: '',
            UseEndDate__c: '',
            OtherInformation: '',
            Comments: ''
        };
        this.updateLabelClaimObject = updateLabelClaimObject;
        this.template.querySelectorAll('c-custom-lookup')[1].clearPackSize();
        this.template.querySelectorAll('c-custom-lookup')[2].clearPackSize();
        this.template.querySelectorAll('c-custom-lookup')[3].clearPackSize();
        this.template.querySelectorAll('c-family-custom-lookup')[0].clearFamily();
        this.template.querySelectorAll('c-market-custom-lookup')[0].clearMarket();
    }

    deleteClickHandler(event) {
        let defaultRowsTemp = [];
        this.priceSchemeDetailList.forEach(function (elem, i) {
            if (event.target.name != i) {
                defaultRowsTemp.push(elem);
            }
        });
        this.priceSchemeDetailList = [...defaultRowsTemp];
        if (this.priceSchemeDetailList.length === 0) {
            this.isDisplayTable = false;
        }
    }

    deleteClickHandlerClaim(event) {
        let defaultRowsTemp = [];
        this.UpdateClaimList.forEach(function (elem, i) {
            if (event.target.name != i) {
                defaultRowsTemp.push(elem);
            }
        });
        this.UpdateClaimList = [...defaultRowsTemp];
        if (this.UpdateClaimList.length === 0) {
            this.isDisplayTableClaim = false;
        }
    }

    handleSaveValidation() {
        let isFoundcomp = false;
        console.log('repo', this.competitorObject.Reporting_Date__c);
        if (this.competitorObject.Company__c === '' || this.competitorObject.Brand__c === '' || this.competitorObject.Formulation__c === '' || this.competitorObject.Reporting_Date__c === '' ) {
            isFoundcomp = true;
        }
        if (isFoundcomp == true) {
            this.showNotification('error', 'Veuillez remplir les informations requises..!');
        } else {
            this.saveDataHandle();
        }
    }

    saveDataHandle() {
        var priceSchemeDetailList = this.priceSchemeDetailsListOsObject();
        console.log('priceSchemeDetailList', priceSchemeDetailList);
        var updateClaimList = this.updateClaimListOfsObject();
        console.log('updateClaimList', updateClaimList);
        console.log('competitorObject', this.competitorObject);
        if (this.competitorObject && priceSchemeDetailList && priceSchemeDetailList.length > 0 && updateClaimList && updateClaimList.length > 0) {
            saveCompetitorDataApex({ competitorObj: this.competitorObject }).then(result => {
                console.log('result001', result);
                if (result) {
                    this.showNotification('success', 'Concurrent enregistré!');
                    this.competitorId = result.Id;
                } else {
                    this.showNotification('error', 'something went wrong!');
                    this.competitorId = '';
                }
            }).then((result) => {
                savePriceSchemeDataApex({ priceSchemeDetailList: priceSchemeDetailList, competitorId: this.competitorId }).then(result1 => {
                    console.log('result002', result1);
                    if (result1) {
                        this.showNotification('success', 'Prix et packaging enregistrés!');
                    } else {
                        this.showNotification('error', 'something went wrong!');
                    }
                }).catch(error => {
                    this.error = error;
                });
            }).then((result1) => {
                saveUpdateLabelClaimDataApex({ updateClaimList: updateClaimList, competitorId: this.competitorId }).then(result2 => { 
                    if (result2) {


                        this.showNotification('success', 'Information etiquette enregistée!');
                        window.location.href = window.location.origin + '/lightning/r/Competitor_Price__c/' + this.competitorId + '/view';
                        /*this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: this.competitorId,
                                objectApiName: 'Competitor_Price__c',
                                actionName: 'view'
                            }
                        });*/
                        this.updateRecordView();

                    } else {
                        this.showNotification('error', 'something went wrong!');
                    }
                }).catch(error => {
                    this.error = error;
                });
            }).catch(error => {
                this.error = error;
                this.showNotification('error', 'something went wrong!');
            });
        } else {
            this.showNotification('error', 'Veuillez remplir les informations requises');
        }

    }

    priceSchemeDetailsListOsObject() {
        if (this.priceSchemeDetailList && this.priceSchemeDetailList.length > 0) {
            let finalPriceSchemeList = [];
            this.priceSchemeDetailList.forEach(function (elem) {
                let priceSchemeObj = { 'sobjectType': 'Price_Scheme_Detail__c' };
                priceSchemeObj.Pack_Size__c = elem.PackSizeId;
                priceSchemeObj.Supplier_Price__c = elem.SupplierPrice;
                priceSchemeObj.Supplier_Price_with_RPD__c = elem.SupplierPriceRPD;
                priceSchemeObj.Supplier_Price_without_RPD__c = elem.SupplierPriceWoRPD;
                priceSchemeObj.Supplier_Price_Tentative__c = elem.SupplierPriceTentitive;

                priceSchemeObj.Import_Price__c = elem.ImportPriceRPD;
                priceSchemeObj.Import_Price_without_RPD__c = elem.ImportPriceWoRPD;
                priceSchemeObj.Import_Price_Tentative_Ha_Cost__c = elem.ImportPriceTentitive;

                priceSchemeObj.Distributor_Price_with_RPD__c = elem.DistributorPriceRPD;
                priceSchemeObj.Distributor_Price_without_RPD__c = elem.DistributorPriceWoRPD;
                priceSchemeObj.Distributor_PriceTentative__c = elem.DistributorPriceTentitive;
                priceSchemeObj.Distributor_Name__c = elem.DistributorName;

                priceSchemeObj.Scheme__c = elem.SchemeDetail;
                priceSchemeObj.Comment__c = elem.Comments;
                priceSchemeObj.Farmer_Price_with_RPD__c = elem.FarmerPriceRPD;
                priceSchemeObj.Farmer_Price_without_RPD__c = elem.FarmerPriceWoRPD;
                priceSchemeObj.Farmer_Price_Tentative_Ha_Cost__c = elem.FarmerPriceTentitive;
                priceSchemeObj.Farmer_Name__c = elem.FarmerName;

                priceSchemeObj.Information_Reliability_Scale__c = elem.InformationReliabilityScale;
                console.log('Main Ids' + JSON.stringify(elem.contentDocumentIds));
                priceSchemeObj.Content_Documents_Id__c = '';

                for (var key in elem.contentDocumentIds) {
                    priceSchemeObj.Content_Documents_Id__c += elem.contentDocumentIds[key] + ',';
                }
                finalPriceSchemeList.push(priceSchemeObj);
            });
            return finalPriceSchemeList;
        }
    }

    updateClaimListOfsObject() {
        if (this.UpdateClaimList && this.UpdateClaimList.length > 0) {
            let finalUpdateClaimList = [];

            this.UpdateClaimList.forEach(function (elem) {
                let updateClaimObj = { 'sobjectType': 'Update_Label_Claim__c' };
                updateClaimObj.Crop__c = elem.CropId;
                updateClaimObj.Pest__c = elem.PestId;
                updateClaimObj.Active_Ingredient__c = elem.AIId;
                updateClaimObj.Family__c = elem.FamilyId;
                updateClaimObj.Market__c = elem.MarketId;
                updateClaimObj.Dose__c = elem.Dose;
                updateClaimObj.No_of_applications__c = elem.NoOfApplications;
                updateClaimObj.AMM_End_Date__c = elem.AMMEndDate;
                updateClaimObj.Sale_End_Date__c = elem.SaleEndDate;
                updateClaimObj.Use_End_Date__c = elem.UseEndDate;
                updateClaimObj.Other_Information__c = elem.OtherInformation;
                updateClaimObj.Comments__c = elem.Comments;
                finalUpdateClaimList.push(updateClaimObj);
            });
            return finalUpdateClaimList;
        }
    }


    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        let uploadedFileNames = '';

        for (var key in uploadedFiles) {
            console.log(JSON.stringify(uploadedFiles[key]));
            this.contentDocumentName.push(uploadedFiles[key].name);
            this.contentDocumentsId.push(uploadedFiles[key].documentId);
            uploadedFileNames += uploadedFiles[key].name + ', ';

        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: uploadedFiles.length + ' Fichier enregistré ' + uploadedFileNames,
                variant: 'success',
            }),
        );
    }

    showNotification(variant, message) {
        const evt = new ShowToastEvent({
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    refreshComponent() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Competitor_Price__c',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            }
        });
    }

    updateRecordView() {
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        }, 1000);
    }
}