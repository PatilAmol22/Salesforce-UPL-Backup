import { LightningElement, track, wire, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import CASE from '@salesforce/schema/Case';
import CALLER_TYPE from '@salesforce/schema/Case.Caller_Type__c';
import PRODUCTNAME1 from '@salesforce/schema/Case.Product_Name_1__c';
import PRODUCTNAME2 from '@salesforce/schema/Case.Product_Name_2__c';
import ORIGIN from '@salesforce/schema/Case.Origin__c';
import CASE_STATUS from '@salesforce/schema/Case.Status';
import PRODUCT_MEASURE1 from '@salesforce/schema/Case.Product_1_Measure__c';
import PRODUCT_MEASURE2 from '@salesforce/schema/Case.Product_2_Measure__c';
import STATEHEAD from '@salesforce/schema/Case.State_Head__c';
import BRANDNAMES from '@salesforce/schema/Case.Multibrand_Name__c';
//import PREF_LANG from '@salesforce/schema/Account.Preferred_Language__pc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getAccRecordTypes from '@salesforce/apex/NewCaseCreationController.getAccRecordTypes';
import getExistAccDetails from '@salesforce/apex/NewCaseCreationController.getExistAccDetails';
import getCaseRecTypeName from '@salesforce/apex/NewCaseCreationController.getCaseRecTypeName';
import getIssueTypeDescFromMetaData from '@salesforce/apex/NewCaseCreationController.getIssueTypeFromMetaData';
import insertAcc from '@salesforce/apex/NewCaseCreationController.insertAcc';
import updateAcc from '@salesforce/apex/NewCaseCreationController.updateAcc';
import insertCase1 from '@salesforce/apex/NewCaseCreationController.insertCase1';
import insertCase2 from '@salesforce/apex/NewCaseCreationController.insertCase2';
import getCallId from '@salesforce/apex/NewCaseCreationController.getCallId';
import updateCaseRecs from '@salesforce/apex/NewCaseCreationController.updateCaseRecs';
//Added by Mahes
import getMetadataInfo from '@salesforce/apex/NewCaseCreationController.getMetadataInfo';

import getPrefLangOptions from '@salesforce/apex/NewCaseCreationController.getPrefLangOptions';
import Nurture_Logo from '@salesforce/resourceUrl/nurturecarelogo';
import NurtureFarmCareLogo1 from '@salesforce/resourceUrl/NurtureFarmCareLogo1';

export default class NewCaseCreationLwc extends NavigationMixin(LightningElement) {

    @track activeSections = ['Caller Info', 'Account', 'Case1'];
    //nurtureLogo = Nurture_Logo;
    nurtureLogo = NurtureFarmCareLogo1;
    @api rectype;
    @api recid;
    @api objname;
    @track qrc1;
    @track timeSlot1;
    @track timeSlot2;
    @track cropName1;
    @track cropName2;
    @track qrc2;
    @track stateHead1;
    @track stateHead2;
    @track brandName1;
    @track brandName2;
    @track department2;
    @track category2;
    @track subCategory2;
    @track reasonForCall2;
    @track department1;
    @track category1;
    @track subCategory1;
    @track reasonForCall1;
    callerType = '';
    mobileNum='';
    ordNum1 = '';
    ordNum2 = '';
    distriProduct = null;
    rectypeName = '';
    distriNameAcc = '';
    accChangeFlag = false;
    showSpinner = false;
    disableAccRecType = false;
    callerDetailInfoFlag = true;
    prefLangFlag = false;
    accountDetailFlag = false;
    showProductRecommendation1 = false;
    flagForCheckBox1 = false;
    showComplaintSection = false;
    akcFlag = false;
    unRegReqFlag = true;
    unRegFlag = false;
    isValid = true;
    orderIdFlag1 = false;
    orderIdFlag2 = false;
    productListFlag1=false;
    productListFlag2=false;
    stateHeadFlag1=false;
    stateHeadFlag2=false;
    multibrandFlag1=false;
    multibrandFlag2=false;
    prodListOptions11=[];
    prodListOptions12=[];
    prodListOptions21=[];
    prodListOptions22=[];
    callerTypeOptions = [];
    contactOriginOptions = [];
    recordTypeOptions = [];
    tempAccRecordTypes = [];
    departmentOptions1 = [];
    categoryOptions1 = [];
    caseStatusOptions = [];
    /*Added By Ishu Mittal
Ticket no APPS4721*/ 
    caseIssueTypeOption=[];
    productTypeOptions1 = [];
    product1Options1 = [];
    product2Options2 = [];
    dose1Options1 = [];
    dose2Options2 = [];
    comDeptOptions = [];
    comCatOptions = [];
    comSubCatOptions = [];
    comReasonOptions = [];
    comDeptOptions2 = [];
    comCatOptions2 = [];
    comSubCatOptions2 = [];
    comReasonOptions2 = [];
    stateHeadOptions2 = [];
    stateHeadOptions1 = [];
    brandNameOptions1 = [];
    brandNameOptions2 = [];
    preferredLanguageOptions = [];
    IssueTypeDescriptionMap=[];
    //RITM0466996-Added by nandhini
    customerRelatedToOptions=[];
    timeSlotOption=[];
    cropNameOption=[];
    test1 = false;
    dField1 = true;
    dField2 = true;
    dField3 = true;
    dField4 = true;
    dField5 = true;
    dField6 = true;
    dField7 = true;
    dField8 = true;
    dField9 = true;
    dField10 = true;
    dField11 = true;
    dField12 = true;
    dField21 = true;
    dField22 = true;
    dField23 = true;
    dField24 = true;
    dField25 = true;
    dField26 = true;
    dField27 = true;
    dField28 = true;
    dField29 = true;
    dField210 = true;
    dField211 = true;
    dField212 = true;
    secondCase = false;
    caseIssueType='';
    caseIssueType1='';
    //tempOrigin=[];
    //tempCallerType=[];
    //timeSlotDisabled1=true;
    isTimeSlotRequired=false;
   // timeSlotDisabled2=true;
    isTimeSlotRequired2=false;
    isCropNameRequired=false;
    isCropNameRequired2=false;
//Added by Mahes
@track metadataInfo;
displayCropStage=false;
displayInsect=false;
    get optionForSmartphoneOrWhatsapp() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },

        ];
    }

    connectedCallback() {
        console.log('recid1' + this.recid);
        console.log('rectype1' + this.rectype);
        console.log('obj1' + this.objname);
        getPrefLangOptions({})
            .then(result => {
                this.tempPrefLang = result;
                for (let i = 0; i < this.tempPrefLang.length; i++) {

                    this.preferredLanguageOptions = [...this.preferredLanguageOptions, { value: this.tempPrefLang[i], label: this.tempPrefLang[i] }];
                }
            })
            .catch(error => {
                console.log('err ' + JSON.stringify(error));
            });
/* Added by Ishu Mittal for CR-APPS4721*/
            getIssueTypeDescFromMetaData({})
            .then(result => {
                this.IssueTypeDescriptionMap = result;
                console.log('IssueType-------->'+JSON.stringify(this.IssueTypeDescriptionMap));
                for(var key in result)
                {
                   this.caseIssueTypeOption=[...this.caseIssueTypeOption,{value:result[key],label:key}] ;
                   console.log('Map--->'+result[key]+'----------'+result);
                }
                


            })
            .catch(error => {
                console.log('err ' + JSON.stringify(error));
            });
        if (this.recid != null && this.recid != undefined && this.objname != null && this.objname != undefined) {
            getExistAccDetails({ recId: this.recid, objName: this.objname })
                .then(result => {
                    if (result.statusMsg == 'success') {
                        console.log('first callback');
                        this.accountDetailFlag = true;
                        this.custName = result.name;
                        this.personMobile = result.mobile;
                        this.subscriptionType=result.subscription;
                        this.expiryDate=result.expiryDate;
                        this.village = result.village;
                        this.state=result.state;
                        this.usingSmartPhone = result.usingSmartPhone;
                        this.usingWhatsapp = result.usingWhatsapp;
                        this.preferredLanguage = result.prefLang;
                        this.recordType = result.recTypeIdAcc;
                        console.log('farmer' + this.recordType);
                        this.disableAccRecType = true;
                        if (result.recTypeNameAcc != 'AKC Retailer' && result.recTypeNameAcc != 'PreRegistered Farmer' && result.recTypeNameAcc != 'F3/C3/Sales Team' && result.recTypeNameAcc != 'UnRegistered Farmer/Retailer') {
                            this.recordTypeOptions = [...this.recordTypeOptions, { value: this.recordType, label: result.recTypeNameAcc }];
                        }

                        if (result.recTypeNameAcc == 'PreRegistered Farmer') {
                            this.prefLangFlag = true;

                        }
                        else {
                            this.prefLangFlag = false;
                        }
                    }


                })
                .catch(error => {
                    console.log('err ' + JSON.stringify(error));
                });
        }
        if (this.rectype != null && this.rectype != undefined) {
            getCaseRecTypeName({ recTypeId: this.rectype })
                .then(result => {
                    if (result != 'error') {
                        this.rectypeName = result;
                        console.log('djhc' + this.rectypeName);
                    }

                })
                .catch(error => {
                    console.log('err ' + JSON.stringify(error));
                });
        }

    }

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: CASE_STATUS })
    wiredCaseStatus({ error, data }) {
        if (data) {
            this.caseStatusOptions = data.values;
        }
    }
    

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: PRODUCT_MEASURE1 })
    wiredProductMeasure1({ error, data }) {
        if (data) {
            this.measure1Options1 = data.values;
            this.measure1Options2 = data.values;
        }
    }
//Added by Mahes

   @wire(getMetadataInfo)
    wiredInfo({ error, data }) {
        if (data) {
            this.metadataInfo = data;
            //this.measure1Options2 = data.values;
            console.log('metadataInfo :'+JSON.stringify(this.metadataInfo));
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: PRODUCT_MEASURE2 })
    wiredProductMeasure2({ error, data }) {
        if (data) {
            this.measure2Options2 = data.values;
            this.measure2Options1 = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: CALLER_TYPE })
    caller({ error, data }) {
        if (data) {
            this.callerTypeOptions = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: ORIGIN })
    origin({ error, data }) {
        if (data) {
            this.contactOriginOptions = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: PRODUCTNAME1 })
    prodName1({ error, data }) {
        if (data) {
            this.prodListOptions11 = data.values;
            this.prodListOptions21 = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: PRODUCTNAME2 })
    prodName2({ error, data }) {
        if (data) {
            this.prodListOptions12 = data.values;
            this.prodListOptions22 = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: STATEHEAD })
    stateHeadVal({ error, data }) {
        if (data) {
            this.stateHeadOptions1 = data.values;
            this.stateHeadOptions2 = data.values;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$rectype', fieldApiName: BRANDNAMES })
    brandNameVal({ error, data }) {
        if (data) {
            this.brandNameOptions1 = data.values;
            this.brandNameOptions2 = data.values;
        }
    }

    @wire(getAccRecordTypes, {})
    wiredAccRecTypes({ error, data }) {
        if (data) {
            console.log('First wire');
            this.tempAccRecordTypes = data;
            for (let i = 0; i < this.tempAccRecordTypes.length; i++) {
                if (this.tempAccRecordTypes[i].Name == 'PreRegistered Farmer') {
                    this.recordTypeOptions = [...this.recordTypeOptions, { value: this.tempAccRecordTypes[i].Id, label: 'PreRegistered Farmer' }];

                    this.preRegFarmerId = this.tempAccRecordTypes[i].Id;
                }
                else {
                    this.recordTypeOptions = [...this.recordTypeOptions, { value: this.tempAccRecordTypes[i].Id, label: this.tempAccRecordTypes[i].Name }];
                    if (this.tempAccRecordTypes[i].Name == 'AKC Retailer') {
                        this.akcRetId = this.tempAccRecordTypes[i].Id;
                    }
                    else if (this.tempAccRecordTypes[i].Name == 'UnRegistered Farmer/Retailer') {
                        this.unRegAcc = this.tempAccRecordTypes[i].Id;
                    }
                }

            }
        } else if (error) {
            this.error = error;
            console.log('errror' + JSON.stringify(this.error));
        }
    };

    @wire(getPicklistValuesByRecordType, { objectApiName: CASE, recordTypeId: '$rectype' })
    fetchPicklist({ error, data }) {
        if (data && data.picklistFieldValues) {
            data.picklistFieldValues["Department__c"].values.forEach(optionData => {
                this.departmentOptions1.push({ label: optionData.label, value: optionData.value });
            });
            this.categoryPicklist = data.picklistFieldValues["QRC_Category__c"];
            this.subCategoryPicklist = data.picklistFieldValues["QRC_sub_category__c"];
            this.reasonForCallPicklist = data.picklistFieldValues["Reason_for_calling__c"];
            this.qrcTypePicklist = data.picklistFieldValues["QRC_type__c"];
            this.test1 = true;
            data.picklistFieldValues["Product_Type__c"].values.forEach(optionData => {
                this.productTypeOptions1.push({ label: optionData.label, value: optionData.value });
            });
            this.product1Picklist1 = data.picklistFieldValues["Product_1__c"];
            this.product2Picklist1 = data.picklistFieldValues["Product_2__c"];
            this.Dose1Picklist1 = data.picklistFieldValues["Product_1_Size__c"];
            this.Dose2Picklist1 = data.picklistFieldValues["Product_2_Size__c"];

            //complaint section
            data.picklistFieldValues["Complaint_Department__c"].values.forEach(optionData => {
                this.comDeptOptions.push({ label: optionData.label, value: optionData.value });
                this.comDeptOptions2.push({ label: optionData.label, value: optionData.value });
            });
            this.dField9 = false;
            this.complaintCategoryPicklist1 = data.picklistFieldValues["Complaint_Category__c"];
            this.complaintSubCategoryPicklist1 = data.picklistFieldValues["Complaint_Sub_category__c"];
            this.complaintReasonPicklist1 = data.picklistFieldValues["Complaint_Reason_for_call__c"];
            //RITM0466996-Added by nandhini
            this.customerRelatedToOptions=data.picklistFieldValues["Customer_Related_To__c"];
            console.log('this.customerRelatedToOptions'+JSON.stringify(this.customerRelatedToOptions.values));
            console.log('tdata.picklistFieldValues :'+JSON.stringify(data.picklistFieldValues));
            //RITM0562254-added by Mahesh
            this.timeSlotAllValues=data.picklistFieldValues["QRC_Time_Slot__c"];//fetching all picklist values from org
            //RITM0572481-added by Mahesh
            this.cropNameAllValues=data.picklistFieldValues["Crop_Name__c"];

        }
    }

    handleComSectionChange(event) {
        if (event.target.label == 'Complaint Department') {
            this.comCatOptions = [];
            this.comReason1='';
            this.comSubCat1='';
            this.comCat1='';
            
            
            const selectedVal = event.target.value;
            let controllerValues = this.complaintCategoryPicklist1.controllerValues;
            this.complaintCategoryPicklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.comCatOptions.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.comDept1 = selectedVal;
            this.dField10 = true;
            this.dField10 = false;

        }

        else if (event.target.label == 'Complaint Category') {
            this.comSubCatOptions = [];
            this.comReason1='';
            this.comSubCat1='';
            
            const selectedVal = event.target.value;
            let controllerValues = this.complaintSubCategoryPicklist1.controllerValues;
            this.complaintSubCategoryPicklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.comSubCatOptions.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.comCat1 = selectedVal;
            this.dField11 = true;
            this.dField11 = false;
        }

        else if (event.target.label == 'Complaint Sub category') {
            this.comReasonOptions = [];
            this.comReason1='';
            const selectedVal = event.target.value;
            let controllerValues = this.complaintReasonPicklist1.controllerValues;
            this.complaintReasonPicklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.comReasonOptions.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.comSubCat1 = selectedVal;
            this.dField12 = true;
            this.dField12 = false;
        }

        else if (event.target.label == 'Complaint Reason for call') {
            this.comReason1 = event.target.value;
        }

    }

    handleComSectionChange2(event) {
        if (event.target.label == 'Complaint Department') {
            this.comCatOptions2 = [];
            this.comReason2='';
            this.comSubCat2='';
            this.comCat2='';
            
            
            const selectedVal = event.target.value;
            let controllerValues = this.complaintCategoryPicklist1.controllerValues;
            this.complaintCategoryPicklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.comCatOptions2.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.comDept2 = selectedVal;
            this.dField210 = true;
            this.dField210 = false;

        }

        else if (event.target.label == 'Complaint Category') {
            this.comSubCatOptions2 = [];
            this.comReason2='';
            this.comSubCat2='';
            
            const selectedVal = event.target.value;
            let controllerValues = this.complaintSubCategoryPicklist1.controllerValues;
            this.complaintSubCategoryPicklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.comSubCatOptions2.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.comCat2 = selectedVal;
            this.dField211 = true;
            this.dField211 = false;
        }

        else if (event.target.label == 'Complaint Sub category') {
            this.comReasonOptions2 = [];
            this.comReason2='';
            const selectedVal = event.target.value;
            let controllerValues = this.complaintReasonPicklist1.controllerValues;
            this.complaintReasonPicklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.comReasonOptions2.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.comSubCat2 = selectedVal;
            this.dField212 = true;
            this.dField212 = false;
        }

        else if (event.target.label == 'Complaint Reason for call') {
            this.comReason2 = event.target.value;
        }

    }

    handleProductChanges1(event) {
        if (event.target.label == 'Product Type') {
            this.product1Options1 = [];
            this.product2Options2 = [];
            const selectedVal = event.target.value;
            let controllerValues = this.product1Picklist1.controllerValues;
            this.product1Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.product1Options1.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.productType1 = selectedVal;
            this.dField5 = false;
            const selectedVal2 = event.target.value;
            let controllerValues2 = this.product2Picklist1.controllerValues;
            this.product2Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues2[selectedVal2]) {

                        this.product2Options2.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.dField6 = false;
        }

        else if (event.target.label == 'Product 1') {
            this.dose1Options1 = [];
            this.dose1Val1='';
            const selectedVal = event.target.value;
            let controllerValues = this.Dose1Picklist1.controllerValues;
            this.Dose1Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.dose1Options1.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.product1Val1 = selectedVal;
            this.dField7 = true;
            this.dField7 = false;
        }

        else if (event.target.label == 'Product 2') {
            this.dose2Options2 = [];
            this.dose2Val2='';
            const selectedVal = event.target.value;
            let controllerValues = this.Dose2Picklist1.controllerValues;
            this.Dose2Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.dose2Options2.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.product2Val2 = selectedVal;
            this.dField8 = true;
            this.dField8 = false;
        }

        else if (event.target.label == 'Dose 1') {
            this.dose1Val1 = event.target.value;
        }

        else if (event.target.label == 'Dose 2') {
            this.dose2Val2 = event.target.value;
        }

        else if (event.target.label == 'Measure 1') {
            this.measure1Val1 = event.target.value;
        }

        else if (event.target.label == 'Measure 2') {
            this.measure2Val2 = event.target.value;
        }
    }

    handleProductChanges2(event) {
        if (event.target.label == 'Product Type') {
            this.product1Options2 = [];
            this.product2Options1 = [];
            const selectedVal = event.target.value;
            let controllerValues = this.product1Picklist1.controllerValues;
            this.product1Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.product1Options2.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.productType2 = selectedVal;
            this.dField25 = false;
            const selectedVal2 = event.target.value;
            let controllerValues2 = this.product2Picklist1.controllerValues;
            this.product2Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues2[selectedVal2]) {

                        this.product2Options1.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.dField26 = false;
        }

        else if (event.target.label == 'Product 1') {
            this.dose1Options2 = [];
            this.dose1Val12='';
            const selectedVal = event.target.value;
            let controllerValues = this.Dose1Picklist1.controllerValues;
            this.Dose1Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.dose1Options2.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.product1Val12 = selectedVal;
            this.dField27 = true;
            this.dField27 = false;
        }

        else if (event.target.label == 'Product 2') {
            this.dose2Options1 = [];
            this.dose2Val22='';
            const selectedVal = event.target.value;
            let controllerValues = this.Dose2Picklist1.controllerValues;
            this.Dose2Picklist1.values.forEach(subVal => {
                subVal.validFor.forEach(subKey => {
                    if (subKey === controllerValues[selectedVal]) {

                        this.dose2Options1.push({ label: subVal.label, value: subVal.value });
                    }
                });

            });
            this.product2Val22 = selectedVal;
            this.dField28 = true;
            this.dField28 = false;
        }

        else if (event.target.label == 'Dose 1') {
            this.dose1Val12 = event.target.value;
        }

        else if (event.target.label == 'Dose 2') {
            this.dose2Val22 = event.target.value;
        }

        else if (event.target.label == 'Measure 1') {
            this.measure1Val12 = event.target.value;
        }

        else if (event.target.label == 'Measure 2') {
            this.measure2Val22 = event.target.value;
        }
    }


    handleCaseStatusChanges(event) {
        this.caseStatus = event.target.value;

    }
    /*Added By Ishu Mittal*/

    handleIssueTypeChanges(event) {
        this.caseIssueType = event.target.value;
        if( this.caseIssueType!=null || this.caseIssueType!='')
        {
        this.description1=this.caseIssueType;
        }

    }

    handleIssueTypeChanges1(event) {
        this.caseIssueType1 = event.target.value;
        if( this.caseIssueType1!=null || this.caseIssueType1!='')
        {
        this.description2=this.caseIssueType1;
        }

    }

    handleCaseStatusChanges2(event) {
        this.caseStatus2 = event.target.value;
    }
    //RITM0466996-Added by nandhini
    handlecustomerRelatedChange(event){
       this.customerRelatedTo=event.target.value;
    }
    handlecustomerRelatedChange2(event)
    {
        this.customerRelatedTo2=event.target.value;
    }
    handleDepartmentChanges1(event) {
        this.categoryOptions1 = [];
        this.category1 = '';
        this.subCategory1 = '';
        this.reasonForCall1 = '';
        this.qrc1 = '';
        this.qrcOptions1 = [];
        this.timeSlotOption1=[];
        this.cropNameOption1=[];
        this.dField1 = true;
        this.dField2 = true;
        this.dField3 = true;
        this.dField4 = true;
       // this.timeSlotDisabled1=true;
        this.dField12 = true;
        this.dField10 = true;
        this.dField11 = true;
        const selectedVal = event.target.value;
        let controllerValues = this.categoryPicklist.controllerValues;
        this.categoryPicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.categoryOptions1.push({ label: subVal.label, value: subVal.value });
                }
            });

        });

        

        this.department1 = selectedVal;
        
        this.dField1 = false;
        
    }

    handleCategoryChanges1(event) {
        this.subCategoryOptions1 = [];
        this.reasonForCallOptions1 = [];
        this.subCategory1 = '';
        this.reasonForCall1 = '';
        this.qrc1 = '';
        this.qrcOptions1 = [];
        this.timeSlotOption1=[];
        this.cropNameOption1=[];
        this.dField2 = true;
        this.dField3 = true;
        this.dField4 = true;
        //this.timeSlotDisabled1=true;
        const selectedVal = event.target.value;
        //Added selectedVal=Crop Health by Ishu Mittal on 13-02-2023 for ticket RITM0505527
        if (selectedVal == 'Agronomy' || selectedVal=='Crop Health') {
            this.flagForCheckBox1 = true;
            this.activeSections = [];
            this.activeSections = ['Caller Info', 'Account', 'Case1', 'Product Recommendation Display1'];
        }
        else {
            this.flagForCheckBox1 = false;
        }

        this.orderIdFlag1 = false;
        this.multibrandFlag1=false;
        this.brandName1='';

        
        
        /*if (selectedVal == 'Payments and Refunds') {
            this.orderIdFlag1 = true;
            this.multibrandFlag1=true;
        }
        else {
            this.orderIdFlag1 = false;
            this.multibrandFlag1=false;
            this.brandName1='';
        }*/
        
        let controllerValues = this.subCategoryPicklist.controllerValues;
        this.subCategoryPicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.subCategoryOptions1.push({ label: subVal.label, value: subVal.value });
                }
            });

        });
        this.category1 = selectedVal;
        this.dField2 = false;
    }

    handleSubCategoryChanges1(event) {
        this.reasonForCallOptions1 = [];
        this.reasonForCall1 = '';
        console.log('reason options:' + JSON.stringify(this.reasonForCallOptions1));
        this.qrc1 = '';
        this.qrcOptions1 = [];
        this.timeSlotOption1=[];
        this.cropNameOption1=[];
        this.dField4 = false;
        this.dField4 = true;
       // this.timeSlotDisabled1=true;
        console.log('new reason options:' + JSON.stringify(this.reasonForCallOptions1));
        const selectedVal = event.target.value;
        let controllerValues = this.reasonForCallPicklist.controllerValues;
        this.reasonForCallPicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.reasonForCallOptions1.push({ label: subVal.label, value: subVal.value });
                }
            });

        });
        console.log('latest reason options:' + JSON.stringify(this.reasonForCallOptions1));
        this.subCategory1 = selectedVal;
        this.dField3 = false;
        if (this.category1 == 'Order Related' && (this.subCategory1 == 'Post Order' || this.subCategory1 == 'Invoicing Related')) {
            this.orderIdFlag1 = true;
            this.multibrandFlag1=true;
        }
        else {
            this.orderIdFlag1 = false;
            this.multibrandFlag1=false;
            this.brandName1='';
        }
    }

    handleReasonForCallChanges1(event) {
        
       
        var tempQrcVal='';
        this.qrc1 = tempQrcVal;
        this.qrcOptions1 = [];
        this.timeSlotOption1=[];
        this.cropNameOption1=[];
        this.dField4 = true;
        this.dField4 = false;
        this.dField4 = true;
        
        this.qrc1 = tempQrcVal;
        this.qrcOptions1 = [];
        
        const selectedVal = event.target.value;
        let controllerValues = this.qrcTypePicklist.controllerValues;
        this.qrcTypePicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.qrcOptions1.push({ label: subVal.label, value: subVal.value });
                }
            });

        });
        //RITM0562254-Added by Mahesh
        let controllerValuesOfTimeSlot = this.timeSlotAllValues.controllerValues; 
        console.log('controllerValuesOfTimeSlot :'+controllerValuesOfTimeSlot);
        this.timeSlotAllValues.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValuesOfTimeSlot[selectedVal]) {
                    console.log('label :'+subVal.label);
                    this.timeSlotOption1.push({ label: subVal.label, value: subVal.value });
                }
            });

        });


        //RITM0572481- added by Mahesh
        let controllerValuesOfCropName = this.cropNameAllValues.controllerValues; 
        this.cropNameAllValues.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValuesOfCropName[selectedVal]) {
                    this.cropNameOption1.push({ label: subVal.label, value: subVal.value });
                }
            });

        });
        




        this.reasonForCall1 = selectedVal;
        if (this.reasonForCall1 == 'Product Complaint' ) {
            this.productListFlag1 = true;
        }
        else {
            this.productListFlag1 = false;
        }
        if (this.reasonForCall1 == 'Booking Denied' || this.reasonForCall1 == 'Booking Delayed' || this.reasonForCall1 == 'Service Complaint' || this.reasonForCall1 == 'Operator Complaint' ) {
            this.stateHeadFlag1 = true;
        }
        else {
            this.stateHeadFlag1 = false;
            this.stateHead2='';
        }
        if (this.category1 != 'Order Related') {
            if (this.category1 == 'Payments and Refunds' && (this.reasonForCall1 != 'Unable to use credit balance' && this.reasonForCall1 != 'Onboarding & KYC' && this.reasonForCall1 != 'Credit Related'
                && this.reasonForCall1 != 'Credit Line concern' && this.reasonForCall1 != 'General Information')) {
                this.orderIdFlag1 = true;
                this.multibrandFlag1 = true;
            }
            else {
                this.orderIdFlag1 = false;
                this.multibrandFlag1 = false;
                this.brandName1 = '';
            }
        }

        
        this.dField4 = false;
        //RITM0562254-added by mahesh
        if(selectedVal == 'Request for Video call'){
           // this.timeSlotDisabled1=false;
            this.isTimeSlotRequired=true;
        }else{
            //this.timeSlotDisabled1=true;
            this.isTimeSlotRequired=false;
        }
        
          //RITM0572481-added by mahesh
          if(selectedVal == 'Unable to scan a product'){   
            this.isCropNameRequired=true;
        }else if(selectedVal =='How to scan product'){
            this.isCropNameRequired=true;
        }
        else if(selectedVal =='Bar Code Missing'){
            this.isCropNameRequired=true;
        }
        else if(selectedVal =='Mandi Price info'){
            this.isCropNameRequired=true;
        }
        else if(selectedVal =='Mandi Price Incorrect'){
            this.isCropNameRequired=true;
        }
        else if(selectedVal =='Rainfall info'){
            this.isCropNameRequired=true;
        }
        else if(selectedVal =='Wind speed info'){
            this.isCropNameRequired=true;
        }
        else if(selectedVal =='Temperature info'){
            this.isCropNameRequired=true;
        }
        else{
            this.isCropNameRequired=false;
        }


    }

    handleQRCChanges1(event) {
        const selectedVal = event.target.value;
        this.qrc1 = selectedVal;
        if (this.department1 == 'Outbound (Connected)' && this.qrc1 == 'Complaint') {
            this.showComplaintSection = true;
        }
        else {
            this.showComplaintSection = false;
        }

      //Added by Mahes
      /*const tempValue=this.category1 + '-'+this.subCategory1 + '-'+ this.reasonForCall1+ '-'+this.qrc1;
      console.log('temp sub and reason :'+tempValue);
      console.log('temp sub and reason :'+JSON.stringify(this.metadataInfo[tempValue]));
      const metaInfo=this.metadataInfo[tempValue];
      this.displayCropStage=metaInfo.Crop_Stage__c;
      this.displayInsect=metaInfo.Insect_List__c;*/


    }
    //RITM0572481-added by Mahesh
    handleCropNameChanges1(event){
        const selectedVCropName = event.target.value;
        this.cropName1=selectedVCropName;
    }

    //RITM0562254-added by mahesh
    handleTimeSlotChanges1(event){
        const selectedVTimeSlot = event.target.value;
        this.timeSlot1=selectedVTimeSlot;
    }
    handleProdListChange11(event) {
        const selectedVal = event.target.value;
        this.prodList11=selectedVal;
    }
    handleProdListChange12(event) {
        const selectedVal = event.target.value;
        this.prodList12=selectedVal;
    }
    handleProdListChange21(event) {
        const selectedVal = event.target.value;
        this.prodList21=selectedVal;
    }
    handleProdListChange22(event) {
        const selectedVal = event.target.value;
        this.prodList22=selectedVal;
    }

    handleOrdNumChange1(event) {
        this.ordNum1 = event.detail.value;
    }

    handleOrdNumChange2(event) {
        this.ordNum2 = event.detail.value;
    }

    handleDepartmentChanges2(event) {
        this.categoryOptions2 = [];
        this.category2 = '';
        this.subCategory2 = '';
        this.reasonForCall2 = '';
        this.qrc2 = '';
        this.dField21 = true;
        this.dField22 = true;
        this.dField23 = true;
        this.dField24 = true;
        this.dField212 = true;
        this.timeSlotDisabled2=true;
        this.cropNameOption2=[];
        this.dField210 = true;
        this.dField211 = true;
        const selectedVal = event.target.value;
        let controllerValues = this.categoryPicklist.controllerValues;
        this.categoryPicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.categoryOptions2.push({ label: subVal.label, value: subVal.value });
                }
            });

        });

         
        this.department2 = selectedVal;
        
        this.dField21 = false;
       

    }

    handleCategoryChanges2(event) {
        this.subCategoryOptions2 = [];
        this.subCategory2 = '';
        this.reasonForCall2 = '';
        this.qrc2 = '';
        this.qrcOptions2 = [];
        this.timeSlotOption2 =[];
        this.cropNameOption2=[];
        this.dField22 = true;
        this.dField23 = true;
        this.dField24 = true;
       // this.timeSlotDisabled2=true;
        const selectedVal = event.target.value;
         //Added selectedVal=Crop Health by Ishu Mittal on 13-02-2023 for ticket 
         
        if (selectedVal == 'Agronomy' || selectedVal=='Crop Health') {
            this.flagForCheckBox2 = true;
            this.activeSections = [];
            this.activeSections = ['Caller Info', 'Account', 'Case1', 'Product Recommendation Display1'];

        }
        else {
            this.flagForCheckBox2 = false;
        }
        this.orderIdFlag2 = false;
        this.multibrandFlag2=false;
        this.brandName2='';

        
        /*if (selectedVal == 'Payments and Refunds') {
            this.orderIdFlag2 = true;
            this.multibrandFlag2=true;
        }
        else {
            this.orderIdFlag2 = false;
            this.multibrandFlag2=false;
            this.brandName2='';
        }*/
        let controllerValues = this.subCategoryPicklist.controllerValues;
        this.subCategoryPicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.subCategoryOptions2.push({ label: subVal.label, value: subVal.value });
                }
            });

        });
        this.category2 = selectedVal;
        this.dField22 = false;
    }

    handleSubCategoryChanges2(event) {
        this.reasonForCallOptions2 = [];
        this.reasonForCall2 = '';
        this.qrc2 = '';
        this.qrcOptions2 = [];
        this.timeSlotOption2=[];
        this.cropNameOption2=[];
        this.dField23 = false;
        this.dField23 = true;
        this.dField24 = false;
        this.dField24 = true;
        //this.timeSlotDisabled2=true;
        const selectedVal = event.target.value;
        let controllerValues = this.reasonForCallPicklist.controllerValues;
        this.reasonForCallPicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.reasonForCallOptions2.push({ label: subVal.label, value: subVal.value });
                }
            });

        });
        this.subCategory2 = selectedVal;
        this.dField23 = false;
        if (this.category2 == 'Order Related' && (this.subCategory2 == 'Post Order' || this.subCategory2 == 'Invoicing Related')) {
            this.orderIdFlag2 = true;
            this.multibrandFlag2=true;
        }
        else {
            this.orderIdFlag2 = false;
            this.multibrandFlag2=false;
            this.brandName2='';
        }
    }
       
        


    handleReasonForCallChanges2(event) {
        

        var tempQrcVal2='';
        this.qrc2 = tempQrcVal2;
        this.qrcOptions2 = [];
        this.timeSlotOption2=[];
        this.cropNameOption2=[];
        this.dField24 = true;
        this.dField24 = false;
        this.dField24 = true;
        
        this.qrc2 = tempQrcVal2;
        this.qrcOptions2 = [];
        
        

        const selectedVal = event.target.value;
        let controllerValues = this.qrcTypePicklist.controllerValues;
        this.qrcTypePicklist.values.forEach(subVal => {
            subVal.validFor.forEach(subKey => {
                if (subKey === controllerValues[selectedVal]) {

                    this.qrcOptions2.push({ label: subVal.label, value: subVal.value });
                }
            });

        });

         //RITM0562254-Added by Mahesh
         let controllerValuesOfTimeSlot = this.timeSlotAllValues.controllerValues; 
         console.log('controllerValuesOfTimeSlot :'+controllerValuesOfTimeSlot);
         this.timeSlotAllValues.values.forEach(subVal => {
             subVal.validFor.forEach(subKey => {
                 if (subKey === controllerValuesOfTimeSlot[selectedVal]) {
                     console.log('label :'+subVal.label);
                     this.timeSlotOption2.push({ label: subVal.label, value: subVal.value });
                 }
             });
 
         });

         //RITM0572481- added by Mahesh
         let controllerValuesOfCropName = this.cropNameAllValues.controllerValues; 
         this.cropNameAllValues.values.forEach(subVal => {
             subVal.validFor.forEach(subKey => {
                 if (subKey === controllerValuesOfCropName[selectedVal]) {
                     this.cropNameOption2.push({ label: subVal.label, value: subVal.value });
                 }
             });
 
         });



        this.reasonForCall2 = selectedVal;
        if (this.reasonForCall2 == 'Product Complaint' ) {
            this.productListFlag2 = true;
        }
        else {
            this.productListFlag2 = false;
        }
        if (this.reasonForCall2 == 'Booking Denied' || this.reasonForCall2 == 'Booking Delayed' || this.reasonForCall2 == 'Service Complaint' || this.reasonForCall2 == 'Operator Complaint' ) {
            this.stateHeadFlag2 = true;
        }
        else {
            this.stateHeadFlag2 = false;
            this.stateHead2='';
        }

        if (this.category2 != 'Order Related') {

            if (this.category2 == 'Payments and Refunds' && (this.reasonForCall2 != 'Unable to use credit balance' && this.reasonForCall2 != 'Onboarding & KYC' && this.reasonForCall2 != 'Credit Related'
                && this.reasonForCall2 != 'Credit Line concern' && this.reasonForCall2 != 'General Information')) {
                this.orderIdFlag2 = true;
                this.multibrandFlag2 = true;
            }
            else {
                this.orderIdFlag2 = false;
                this.multibrandFlag2 = false;
                this.brandName2 = '';
            }

        }
        this.dField24 = false;
        //RITM0562254-added by mahesh
        if(selectedVal == 'Request for Video call'){
            //this.timeSlotDisabled2=false;
            this.isTimeSlotRequired2=true;
        }else{
           // this.timeSlotDisabled2=true;
            this.isTimeSlotRequired2=false;
        }

          //RITM0572481-added by mahesh
          if(selectedVal == 'Unable to scan a product'){   
            this.isCropNameRequired2=true;
        }else if(selectedVal =='How to scan product'){
            this.isCropNameRequired2=true;
        }
        else if(selectedVal =='Bar Code Missing'){
            this.isCropNameRequired2=true;
        }
        else if(selectedVal =='Mandi Price info'){
            this.isCropNameRequired2=true;
        }
        else if(selectedVal =='Mandi Price Incorrect'){
            this.isCropNameRequired2=true;
        }
        else if(selectedVal =='Rainfall info'){
            this.isCropNameRequired2=true;
        }
        else if(selectedVal =='Wind speed info'){
            this.isCropNameRequired2=true;
        }
        else if(selectedVal =='Temperature info'){
            this.isCropNameRequired2=true;
        }
        else{
            this.isCropNameRequired2=false;
        }
        

    }
    //RITM0562254-added by Mahesh
    handleTimeSlotChanges2(event){
        const selectedVTimeSlot = event.target.value;
        this.timeSlot2=selectedVTimeSlot;
    }

    //RITM0572481-added by Mahesh
    handleCropNameChanges2(event){
        const selectedVCropName = event.target.value;
        this.cropName2=selectedVCropName;
    }

    handleQRCChanges2(event) {
        const selectedVal = event.target.value;
        this.qrc2 = selectedVal;
        if (this.department2 == 'Outbound (Connected)' && this.qrc2 == 'Complaint') {
            this.showComplaintSection2 = true;
        }
        else {
            this.showComplaintSection2 = false;
        }

    }

    handleCallerDetails(event) {
        if (event.target.label == 'Caller Type') {
            this.callerType = event.target.value;
            if (this.callerType === 'Account Holder') {
                this.callerDetailInfoFlag = false;
            }
            else {
                this.callerDetailInfoFlag = true;
            }
        }
        else if (event.target.label == 'Contact Origin') {
            this.contactOrigin = event.target.value;
        }
        else if (event.target.label == 'Caller Name') {
            this.callerName = event.detail.value;
        }
        else if (event.target.label == 'Caller Mobile') {
            this.mobileNum = event.detail.value;
        }


    }

    handleRecordTypeChange(event) {
        this.recordType = event.detail.value;
        this.accountDetailFlag = true;
        if (this.preRegFarmerId == this.recordType) {
            this.prefLangFlag = true;
        }
        else {
            this.prefLangFlag = false;
        }
        if (this.akcRetId == this.recordType) {
            this.akcFlag = true;
        }
        else {
            this.akcFlag = false;
        }
        if (this.unRegAcc == this.recordType) {
            this.unRegFlag = true;
            this.unRegReqFlag = false;
            this.callerType = '';
            this.callerName = '';
            this.mobileNum = '';
        }
        else {
            this.unRegFlag = false;
            this.unRegReqFlag = true;
        }
    }

    handleCheckBoxChange1(event) {
        this.activeSections = [];

        this.showProductRecommendation1 = event.detail.checked;
        if (this.showProductRecommendation1 == false) {
            this.productType1 = '';
            this.product1Val1 = '';
            this.dose1Val1 = '';
            this.measure1Val1 = '';
            this.product2Val2 = '';
            this.dose2Val2 = '';
            this.measure2Val2 = '';
        }
        this.activeSections = ['Caller Info', 'Account', 'Case1', 'Product Recommendation Display1', 'Product Recommendation1'];
    }

    handleCheckBoxChange2(event) {
        this.activeSections = [];

        this.showProductRecommendation2 = event.detail.checked;
        if (this.showProductRecommendation2 == false) {
            this.productType2 = '';
            this.product1Val12 = '';
            this.dose1Val12 = '';
            this.measure1Val12 = '';
            this.product2Val22 = '';
            this.dose2Val22 = '';
            this.measure2Val22 = '';
        }
        this.activeSections = ['Caller Info', 'Account', 'Case1', 'Product Recommendation Display1', 'Product Recommendation1'];
    }

    handleVillageChange(event) {
        this.village = event.target.value;
        this.accChangeFlag = true;
    }

    handleStateChange(event) {
        this.state = event.target.value;
        this.accChangeFlag = true;
    }

    handleDistriProductChange(event) {
        this.distriProduct = event.target.value;
    }

    handleDistriNameAccChange(event) {
        this.distriNameAcc = event.detail.value;
    }

    handleAccountDetails(event) {

        if (event.target.label == 'Person Mobile') {
            this.personMobile = event.detail.value;

        }
        else if (event.target.label == 'Name') {
            this.custName = event.detail.value;

        }
        else if (event.target.label == 'Preferred Language') {
            this.preferredLanguage = event.target.value;

        }
        else if (event.target.label == 'Using smart phone') {
            this.usingSmartPhone = event.target.value;

        }
        else if (event.target.label == 'Using Whatsapp') {
            this.usingWhatsapp = event.target.value;

        }
        this.accChangeFlag = true;
    }

    handleAddNewCase(event) {
        this.secondCase = true;
    }

    handleDescChange1(event) {
        this.description1 = event.detail.value;
    }

    handleDescChange2(event) {
        this.description2 = event.detail.value;
    }

    handleStateHeadChange1(event){
        this.stateHead1 = event.target.value;
    }

    handleStateHeadChange2(event){
        this.stateHead2 = event.target.value;
    }

    handleBrandNameChange1(event){
        this.brandName1 = event.target.value;
    }

    handleBrandNameChange2(event){
        this.brandName2 = event.target.value;
    }


    handleSaveCases(event) {

        if (this.isInputValid()) {
            if ((this.qrc1 == 'Query' && this.caseStatus != 'Closed') || (this.qrc2 == 'Query' && this.caseStatus2 != 'Closed')) {
                this.title = 'Error';
                this.msg = 'For Querys, the case status should be closed';
                this.variant = 'Error';
                this.toastMessage();
            }
            else {


                console.log('Inside valid condition');
                console.log('qrc Val:'+this.qrc1);
                this.showSpinner = true;
                if (this.recid == undefined && this.recid == null) {
                    insertAcc({
                        recType: this.recordType, mobile: this.personMobile, language: this.preferredLanguage, village: this.village, state:this.state,
                        name: this.custName, useSmartPhone: this.usingSmartPhone, useWhatsApp: this.usingWhatsapp, distProd: this.distriProduct, distribName: this.distriNameAcc
                    })
                        .then(result => {
                            console.log('newAcc' + result);
                            this.newAccId = result;
                            this.title = 'Success';
                            this.msg = 'Account created successfully';
                            this.variant = 'Success';
                            this.toastMessage();
                            this.recid = result;
                            //RITM0466996-Added by nandhini
                            this.caseinfo={
                                            description: this.description1,
                                            customerRelated:this.customerRelatedTo,
                                            timeSlotValue:this.timeSlot1,
                                            cropNameValue:this.cropName1

                                         };
                                         console.log('this.caseinfo' +JSON.stringify(this.caseinfo));
                            insertCase1({
                                callerType: this.callerType, origin: this.contactOrigin, callerName: this.callerName, callerPhone: this.mobileNum,
                                recordtypeId: this.rectype, accId: this.newAccId, department: this.department1, category: this.category1, subCategory: this.subCategory1,
                                reasonForCall: this.reasonForCall1, qRC: this.qrc1, status: this.caseStatus, complaintFlag: this.showComplaintSection,
                                comDepartment: this.comDept1, comCategory: this.comCat1, comSubCategory: this.comSubCat1, comReasonForCall: this.comReason1,
                                productFlag: this.showProductRecommendation1, productType: this.productType1, product1: this.product1Val1, product2: this.product2Val2,
                                dose1: this.dose1Val1, dose2: this.dose2Val2, measure1: this.measure1Val1, measure2: this.measure2Val2, caseinfos: this.caseinfo,
                                callId: this.callId, orderNum: this.ordNum1, prodName1: this.prodList11, prodName2: this.prodList12, stateHead: this.stateHead1, brandName: this.brandName1
                            })
                                .then(result => {
                                    this.caseNum = 1;
                                    this.caseRec1 = result;
                                    console.log('newCase' + result);
                                    this.caseInfoSecondCase={
                                        description: this.description2,
                                        customerRelated:this.customerRelatedTo2,
                                        timeSlotValue:this.timeSlot2,
                                        cropNameValue:this.cropName2
                                     };
                                     console.log('this.caseInfoSecondCase' +JSON.stringify(this.caseInfoSecondCase));
                                    if (this.secondCase == true) {
                                        insertCase2({
                                            callerType: this.callerType, origin: this.contactOrigin, callerName: this.callerName, callerPhone: this.mobileNum,
                                            recordtypeId: this.rectype, accId: this.newAccId, department: this.department2, category: this.category2, subCategory: this.subCategory2,
                                            reasonForCall: this.reasonForCall2, qRC: this.qrc2, status: this.caseStatus2, complaintFlag: this.showComplaintSection2,
                                            comDepartment: this.comDept2, comCategory: this.comCat2, comSubCategory: this.comSubCat2, comReasonForCall: this.comReason2,
                                            productFlag: this.showProductRecommendation2, productType: this.productType2, product1: this.product1Val12, product2: this.product2Val22,
                                            dose1: this.dose1Val12, dose2: this.dose2Val22, measure1: this.measure1Val12, measure2: this.measure2Val22, caseinfos: this.caseInfoSecondCase,
                                            callId: this.callId, orderNum: this.ordNum2, prodName1: this.prodList21, prodName2: this.prodList22, stateHead: this.stateHead2, brandName: this.brandName2
                                        })
                                            .then(result => {
                                                this.caseNum = 2;
                                                this.caseRec2 = result;
                                                this.showSpinner = false;
                                                this[NavigationMixin.Navigate]({
                                                    type: 'standard__recordPage',
                                                    attributes: {
                                                        recordId: this.newAccId,
                                                        objectApiName: 'Account',
                                                        actionName: 'view'
                                                    }
                                                });
                                                const saveEvent = new CustomEvent('save', {
                                                    detail: {},
                                                });
                                                // Fire the custom event
                                                this.dispatchEvent(saveEvent);

                                                //Genesys Callout
                                            })
                                            .catch(error => {
                                                console.log('err ' + JSON.stringify(error));
                                                this.showSpinner = false;
                                                this.showSpinner = false;
                                                this.title = 'Error';
                                                this.msg = 'Error Occurred. Please refresh the page.';
                                                this.variant = 'Error';
                                                this.toastMessage();
                                                this[NavigationMixin.Navigate]({
                                                    type: 'standard__recordPage',
                                                    attributes: {
                                                        recordId: this.newAccId,
                                                        objectApiName: 'Account',
                                                        actionName: 'view'
                                                    }
                                                });
                                                const saveEvent = new CustomEvent('save', {
                                                    detail: {},
                                                });
                                                // Fire the custom event
                                                this.dispatchEvent(saveEvent);
                                            });
                                    }
                                    else {
                                        this.showSpinner = false;
                                        this[NavigationMixin.Navigate]({
                                            type: 'standard__recordPage',
                                            attributes: {
                                                recordId: this.newAccId,
                                                objectApiName: 'Account',
                                                actionName: 'view'
                                            }
                                        });
                                        const saveEvent = new CustomEvent('save', {
                                            detail: {},
                                        });
                                        // Fire the custom event
                                        this.dispatchEvent(saveEvent);
                                        //Genesys callout
                                    }

                                })
                                .catch(error => {
                                    console.log('err ' + JSON.stringify(error));
                                    this.showSpinner = false;
                                    this.title = 'Error';
                                    this.msg = 'Error Occurred while creating case. Please refresh the page.';
                                    this.variant = 'Error';
                                    this.toastMessage();
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId: this.newAccId,
                                            objectApiName: 'Account',
                                            actionName: 'view'
                                        }
                                    });
                                    const saveEvent = new CustomEvent('save', {
                                        detail: {},
                                    });
                                    // Fire the custom event
                                    this.dispatchEvent(saveEvent);
                                });


                        })
                        .catch(error => {
                            console.log('err ' + JSON.stringify(error));
                            this.showSpinner = false;
                            this.title = 'Error';
                            this.msg = 'Error Occurred while creating Account. Please refresh the page.';
                            this.variant = 'Error';
                            this.toastMessage();
                        });

                }
                else {
                    console.log('acc edit flg' + this.accChangeFlag);
                    updateAcc({
                        accId: this.recid, mobile: this.personMobile, language: this.preferredLanguage, village: this.village,state:this.state,
                        name: this.custName, useSmartPhone: this.usingSmartPhone, useWhatsApp: this.usingWhatsapp, accChangeFlag: this.accChangeFlag
                    })
                        .then(result => {
                            console.log('account updated');
                            this.title = 'Success';
                            this.msg = 'Account updated successfully';
                            this.variant = 'Success';
                            this.toastMessage();
                            //RITM0466996-Added by nandhini
                             this.caseinfo1={
                                description: this.description1,
                                customerRelated:this.customerRelatedTo,
                                timeSlotValue:this.timeSlot1,
                                cropNameValue:this.cropName1
                             };
                            insertCase1({
                                callerType: this.callerType, origin: this.contactOrigin, callerName: this.callerName, callerPhone: this.mobileNum,
                                recordtypeId: this.rectype, accId: this.recid, department: this.department1, category: this.category1, subCategory: this.subCategory1,
                                reasonForCall: this.reasonForCall1, qRC: this.qrc1, status: this.caseStatus, complaintFlag: this.showComplaintSection,
                                comDepartment: this.comDept1, comCategory: this.comCat1, comSubCategory: this.comSubCat1, comReasonForCall: this.comReason1,
                                productFlag: this.showProductRecommendation1, productType: this.productType1, product1: this.product1Val1, product2: this.product2Val2,
                                dose1: this.dose1Val1, dose2: this.dose2Val2, measure1: this.measure1Val1, measure2: this.measure2Val2, caseinfos:this.caseinfo1,
                                callId: this.callId, orderNum: this.ordNum1, prodName1: this.prodList11, prodName2: this.prodList12, stateHead: this.stateHead1, brandName: this.brandName1
                            })
                                .then(result => {
                                    this.caseNum = 1;
                                    console.log('newCase1' + result);
                                    this.caseRec1 = result;
                                    this.caseInfoSecondCase1={
                                        description: this.description2,
                                        customerRelated:this.customerRelatedTo2,
                                        timeSlotValue:this.timeSlot2,
                                        cropNameValue:this.cropName2
                                     };
                                    if (this.secondCase == true) {
                                        insertCase2({
                                            callerType: this.callerType, origin: this.contactOrigin, callerName: this.callerName, callerPhone: this.mobileNum,
                                            recordtypeId: this.rectype, accId: this.recid, department: this.department2, category: this.category2, subCategory: this.subCategory2,
                                            reasonForCall: this.reasonForCall2, qRC: this.qrc2, status: this.caseStatus2, complaintFlag: this.showComplaintSection2,
                                            comDepartment: this.comDept2, comCategory: this.comCat2, comSubCategory: this.comSubCat2, comReasonForCall: this.comReason2,
                                            productFlag: this.showProductRecommendation2, productType: this.productType2, product1: this.product1Val12, product2: this.product2Val22,
                                            dose1: this.dose1Val12, dose2: this.dose2Val22, measure1: this.measure1Val12, measure2: this.measure2Val22, caseinfos: this.caseInfoSecondCase1,
                                            callId: this.callId, orderNum: this.ordNum2, prodName1: this.prodList21, prodName2: this.prodList22, stateHead: this.stateHead2, brandName: this.brandName2
                                        })
                                            .then(result => {
                                                this.caseNum = 2;
                                                this.caseRec2 = result;
                                                this.showSpinner = false;
                                                this[NavigationMixin.Navigate]({
                                                    type: 'standard__recordPage',
                                                    attributes: {
                                                        recordId: this.recid,
                                                        objectApiName: 'Account',
                                                        actionName: 'view'
                                                    }
                                                });
                                                const saveEvent = new CustomEvent('save', {
                                                    detail: {},
                                                });
                                                // Fire the custom event
                                                this.dispatchEvent(saveEvent);

                                                //Genesys Callout
                                            })
                                            .catch(error => {
                                                console.log('err ' + JSON.stringify(error));
                                                this.showSpinner = false;
                                                this.title = 'Error';
                                                this.msg = 'Error Occurred. Please refresh the page.';
                                                this.variant = 'Error';
                                                this.toastMessage();
                                                this[NavigationMixin.Navigate]({
                                                    type: 'standard__recordPage',
                                                    attributes: {
                                                        recordId: this.recid,
                                                        objectApiName: 'Account',
                                                        actionName: 'view'
                                                    }
                                                });
                                                const saveEvent = new CustomEvent('save', {
                                                    detail: {},
                                                });
                                                // Fire the custom event
                                                this.dispatchEvent(saveEvent);
                                            });
                                    }
                                    else {
                                        this.showSpinner = false;
                                        this[NavigationMixin.Navigate]({
                                            type: 'standard__recordPage',
                                            attributes: {
                                                recordId: this.recid,
                                                objectApiName: 'Account',
                                                actionName: 'view'
                                            }
                                        });
                                        const saveEvent = new CustomEvent('save', {
                                            detail: {},
                                        });
                                        // Fire the custom event
                                        this.dispatchEvent(saveEvent);
                                    }
                                })
                                .catch(error => {
                                    console.log('err2 ' + JSON.stringify(error));
                                    this.showSpinner = false;
                                    this.title = 'Error';
                                    this.msg = 'Error Occurred while creating case. Please refresh the page.';
                                    this.variant = 'Error';
                                    this.toastMessage();
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId: this.recid,
                                            objectApiName: 'Account',
                                            actionName: 'view'
                                        }
                                    });
                                    const saveEvent = new CustomEvent('save', {
                                        detail: {},
                                    });
                                    // Fire the custom event
                                    this.dispatchEvent(saveEvent);
                                    
                                });


                        })
                        .catch(error => {
                            console.log('err1 ' + JSON.stringify(error));
                            this.showSpinner = false;
                            this.title = 'Error';
                            this.msg = 'Error Occurred while updating Account. Please refresh the page.';
                            this.variant = 'Error';
                            this.toastMessage();
                        });


                }

                if (this.secondCase) {
                    this.dispositionVal = this.department2 + '|' + this.category2 + '|' + this.subCategory2 + '|' + this.reasonForCall2 + '|' + this.qrc2 + '|' + this.caseStatus2;
                    console.log('dispo2' + this.dispositionVal);
                    getCallId({
                        mobile: this.personMobile, disposition: this.dispositionVal, accId: this.recid, callerNum: this.mobileNum
                    })
                        .then(result => {
                            console.log('new call id' + result);
                            if (result != 'error') {
                                this.callId = result;
                                updateCaseRecs({ accId: this.recid, callId: this.callId })
                                    .then(result => {
                                        console.log('success call id');
                                    })
                                    .catch(error => {
                                        console.log('err ' + JSON.stringify(error));
                                    });
                            }

                        })
                        .catch(error => {
                            console.log('err ' + JSON.stringify(error));
                        });
                }
                else {
                    this.dispositionVal = this.department1 + '|' + this.category1 + '|' + this.subCategory1 + '|' + this.reasonForCall1 + '|' + this.qrc1 + '|' + this.caseStatus;
                    console.log('dispo1' + this.dispositionVal);
                    getCallId({
                        mobile: this.personMobile, disposition: this.dispositionVal, accId: this.recid,callerNum: this.mobileNum
                    })
                        .then(result => {
                            console.log('new call id' + result);
                            if (result != 'error') {
                                this.callId = result;
                                updateCaseRecs({ accId: this.recid, callId: this.callId })
                                    .then(result => {
                                        console.log('success call id');
                                    })
                                    .catch(error => {
                                        console.log('err ' + JSON.stringify(error));
                                    });
                            }
                        })
                        .catch(error => {
                            console.log('err ' + JSON.stringify(error));
                        });
                }


            }
        }
        else {
            this.title = 'Error';
            this.msg = 'Please fill all the mandatory fields with valid values.';
            this.variant = 'Error';
            this.toastMessage();
        }

    }

    handleRemoveCase2(event) {
        this.secondCase = false;
        this.department2 = '';
        this.description2 = '';
        //Added by Nandhini
        this.customerRelatedTo2='';
        this.timeSlot2='';
        this.cropName2='';
        this.category2 = '';
        this.subCategory2 = '';
        this.reasonForCall2 = '';
        this.qrc2 = '';
        this.dField21 = true;
        this.dField22 = true;
        this.dField23 = true;
        this.dField24 = true;
        this.dField27 = true;
        this.dField28 = true;
        this.dField212 = true;
        this.dField210 = true;
        this.dField211 = true;
        this.showProductRecommendation2 = false;
        this.productType2 = '';
        this.product1Val12 = '';
        this.dose1Val12 = '';
        this.measure1Val12 = '';
        this.product2Val22 = '';
        this.dose2Val22 = '';
        this.measure2Val22 = '';
        this.caseStatus2 = '';
        this.comDept2 = '';
        this.comCat2 = '';
        this.comSubCat2 = '';
        this.comReason2 = '';
        this.ordNum2 = '';
        this.stateHead2='';
        this.brandName2='';
        this.orderIdFlag2 = false;
        this.stateHeadFlag2=false;
        this.multibrandFlag2=false;
    }

    handleCancel(event) {
        this.recid = '';
        this.rectype = '';
        this.objname = '';
        this.secondCase = false;
        this.department2 = '';
        this.category2 = '';
        this.subCategory2 = '';
        this.reasonForCall2 = '';
        this.qrc2 = '';
        this.dField21 = true;
        this.dField22 = true;
        this.dField23 = true;
        this.dField24 = true;
        this.dField27 = true;
        this.dField28 = true;
        this.dField212 = true;
        this.dField210 = true;
        this.dField211 = true;
        this.showProductRecommendation2 = false;
        this.productType2 = '';
        this.product1Val12 = '';
        this.dose1Val12 = '';
        this.measure1Val12 = '';
        this.product2Val22 = '';
        this.dose2Val22 = '';
        this.measure2Val22 = '';
        this.caseStatus2 = '';
        this.description1 = '';
        this.description2 = '';
        //Added by nandhini
        this.customerRelatedTo2='';
        this.customerRelatedTo='';
       //added by Mahesh
        this.timeSlot1='';
        this.timeSlot2='';
        this.cropName1='';
        this.cropName2='';
        this.comDept2 = '';
        this.comCat2 = '';
        this.comSubCat2 = '';
        this.comReason2 = '';
        this.department1 = '';
        this.category1 = '';
        this.subCategory1 = '';
        this.reasonForCall1 = '';
        this.qrc1 = '';
        this.dField1 = true;
        this.dField2 = true;
        this.dField3 = true;
        this.dField4 = true;
       // this.timeSlotDisabled1=true;
       // this.timeSlotDisabled2=true;
        this.dField7 = true;
        this.dField8 = true;
        this.dField12 = true;
        this.dField10 = true;
        this.dField11 = true;
        this.showProductRecommendation2 = false;
        this.productType1 = '';
        this.product1Val1 = '';
        this.dose1Val1 = '';
        this.measure1Val1 = '';
        this.product2Val2 = '';
        this.dose2Val2 = '';
        this.measure2Val2 = '';
        this.caseStatus = '';
        this.comDept1 = '';
        this.comCat1 = '';
        this.comSubCat1 = '';
        this.comReason1 = '';
        this.ordNum1 = '';
        this.ordNum2 = '';
        this.orderIdFlag1 = false;
        this.orderIdFlag2 = false;
        this.stateHead1='';
        this.stateHead2='';
        this.brandName1='';
        this.brandName2='';
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            },
            state: {

                filterName: 'Recent'
            }
        });

        const closeEvent = new CustomEvent('close', {
            detail: {},
        });
        // Fire the custom event
        this.dispatchEvent(closeEvent);
    }

    isInputValid() {
        this.isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            inputField.reportValidity();
            if (!inputField.checkValidity()) {

                this.isValid = false;
                console.log('error field:' + JSON.stringify(inputField));

            }
        });
        if ((this.village == null || this.village == '' || this.village == undefined) && (this.unRegReqFlag)) {
            this.isValid = false;
        }

        if((this.prodList11 == null || this.prodList11 == '' || this.prodList11 == undefined) && (this.prodList12 == null || this.prodList12 == '' || this.prodList12 == undefined) && (this.productListFlag1))
        {
            this.isValid = false;

        }
        if (this.secondCase) {
            if ((this.prodList21 == null || this.prodList21 == '' || this.prodList21 == undefined) && (this.prodList22 == null || this.prodList22 == '' || this.prodList22 == undefined) && (this.productListFlag2)) {
                this.isValid = false;

            }
        }
        return this.isValid;
    }

    toastMessage() {
        const event = new ShowToastEvent({
            title: this.title,
            message: this.msg,
            variant: this.variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}