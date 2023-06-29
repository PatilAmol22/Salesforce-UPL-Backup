import { LightningElement,track,wire,api } from 'lwc';
import Grz_IndiaSalesOrgCode from "@salesforce/label/c.Grz_IndiaSalesOrgCode";
import getSAandAccData from "@salesforce/apex/Grz_AdobeContractDetails.getSAandAccData";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
import modal from "@salesforce/resourceUrl/OnboardingResource";
import { loadStyle } from "lightning/platformResourceLoader";
import updateFileName from "@salesforce/apex/Grz_AdobeContractDetails.updateFileName";
import deleteFiles from "@salesforce/apex/Grz_AdobeContractDetails.deleteFiles";
import checkAttachmentsSize from "@salesforce/apex/Grz_AdobeContractDetails.checkAttachmentsSize";
import saveData from "@salesforce/apex/Grz_AdobeContractDetails.saveData";
import { CurrentPageReference } from 'lightning/navigation';
import { getRecordNotifyChange } from "lightning/uiRecordApi";
import { refreshApex } from '@salesforce/apex';
import ProfileName from '@salesforce/schema/User.Profile.Name';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import FORM_FACTOR from '@salesforce/client/formFactor';
import fileSize from '@salesforce/label/c.Grz_OnboardingFileSize';
import fileSizeProfilePhoto from '@salesforce/label/c.Grz_OnboardingProfilePhotoSize';
export default class Grz_AdobeContractDetails extends LightningElement {
@track checkDevice=false;
label = {
    fileSize,
    fileSizeProfilePhoto
};
currentPageReference = null; 
@track isTMOrAdmin=false;
@track personalGuaranteeNumberCheck = false;
@track wholeDataResultWire=[];
@track Grz_IndiaSalesOrgCode=Grz_IndiaSalesOrgCode;
@track isLoading = true;
@api strRecordId;
@api recordId;
@track salesAreaRecord;
@track constOfBusiness;
@track companyName;
@track emailVal;
@track phoneVal;
@track gstNumber;
@track panNumber;
@track companyAddress;
@track salesOrgCompanyName;
@track companyCity;
@track documentDetailsMap=new Map();
@track corporateAddress;
@track registeredAddress;
@track companyFirstName;
//Upload disabling parameters
@track profilePhotoDisabled=false;

@track yearOfEstablishmentFileDisabled=true;
@track gstNumberFileDisabled=false;
@track shopEstablishmentFileDisabled=true;
@track pesticideFileDisabled=false;
@track fertilizerFileDisabled=true;
@track seedsLicenseFileDisabled=true;
@track incomeTaxFileDisabled=false;
@track bankFileDisabled=false;
@track DPNFileDisabled = true;
@track adhaarFileDisabled=false;
//Check variables
@track yearOfEstablishmentCheck=false;
@track shopEstablishmentCheck=false;
@track seedsLicenseCheck=false;
@track fertilizerCheck=false;
//@track pesticideCheck=false;
@track relativeWorkingCheck=false;
@track DPNCheck=false;

@track yearOfEstablishmentCheckNot=true;
@track shopEstablishmentCheckNot=true;
@track seedsLicenseCheckNot=true;
@track fertilizerCheckNot=true;
//@track pesticideCheckNot=true;
@track relativeWorkingCheckNot=true;
@track DPNCheckNot=true;

//Input variables
@track bankName='';
@track bankName2='';
@track bankName3='';
@track validTillDatePesticide='';
@track validTillDateFertilizer='';
@track validTillDateSeed='';
@track totalInput1='';
@track totalInput2='';
@track totalInput3='';
@track totalInput4='';
@track totalInput5='';
@track ratioInput1='';
@track ratioInput2='';
@track ratioInput3='';
@track ratioInput4='';
@track ratioInput5='';
@track personalGuaranteeInput1='';
@track relationInput1='';
@track relationInput2='';
@track relationInput3='';
@track relationInput4='';
@track relationInput5='';

@track DPNFile = {Id : '',Name : ''};
@track isDPNFileDelete = true;
@track isbankFileDelete = true;
@track isadhaarFileDelete = true;
@track isincomeTaxFileDelete = true;
@track isseedsLicenseFileDelete = true;
@track isfertilizerFileDelete = true;
@track ispesticideFileDelete = true;
@track isshopEstablishmentFileDelete = true;
@track isgstNumberFileDelete = true;
@track isyearOfEstablishmentFileDelete = true;
@track isprofilePhotoDelete = true;

@track ProfilePhotoLabel='';
@track markee='';
//Related Table Parameters
@track columnsPartners = [
{ Id: 1, label: 'Name  of Proprietor / Partner / Director', fieldName: 'Name', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 2, label: 'Address', fieldName: 'Address__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 3, label: 'PAN', fieldName: 'PAN__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 4, label: 'Aadhar', fieldName: 'Adhaar__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 5, label: 'Relationship', fieldName: 'Relationship__c', type: 'picklist', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 6, label: 'Profit Sharing Ratio', fieldName: 'Profit_Sharing_Ratio__c', type: 'number', initialWidth: 100, sortable: false, editable: this.is_editable }
];
@track queryPartners;

@track columnsParticulars = [
{ Id: 1, label: 'Name of parties', fieldName: 'Name', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 2, label: 'No. of Years in business', fieldName: 'No_of_Years_in_Business__c', type: 'number', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 3, label: 'Year 1', fieldName: 'Year_1__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 4, label: 'Year 2', fieldName: 'Year_2__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 5, label: 'Year 3', fieldName: 'Year_3__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 6, label: 'Year 4', fieldName: 'Year_4__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable }
];
@track queryParticulars;

@track columnsOtherBusiness = [
{ Id: 1, label: 'Name Of the Firm', fieldName: 'Name', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 2, label: 'Status (Partners / Proprietor, etc.)', fieldName: 'Status__c', type: 'picklist', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 3, label: 'Capital Invested', fieldName: 'Capital_Invested__c', type: 'number', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 4, label: 'Shares of his Profit(%)', fieldName: 'Shares_of_his_Profit__c', type: 'number', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 5, label: 'Nature of its business', fieldName: 'Nature_of_its_business__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable }
];
@track queryOtherBusiness;

@track columnsLegalCases = [
{ Id: 1, label: 'Civil / Criminal', fieldName: 'Type__c', type: 'picklist', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 2, label: 'Case No. & Date', fieldName: 'Case_No_Date__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 3, label: 'Complaint / Plaintiff', fieldName: 'Complaint_Plaintiff__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 4, label: 'Accused / Defendants', fieldName: 'Accused_Defendants__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 5, label: 'Remarks', fieldName: 'Remarks__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable }
];
@track queryLegalCases;

@track columnsAnnexure3 = [
{ Id: 1, label: 'Name of the Person', fieldName: 'Name', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 2, label: 'Relationship', fieldName: 'Relationship__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 3, label: 'Age', fieldName: 'Age__c', type: 'number', initialWidth: 100, sortable: false, editable: this.is_editable },
{ Id: 3, label: 'Specimen Signature(Complete Name)', fieldName: 'Specimen_Signature__c', type: 'text', initialWidth: 100, sortable: false, editable: this.is_editable }
];
@track queryAnnexure3;


/* Variables by himanshu */
@track sectionKeys =[];



/* Himanshu Variables ends*/

//Bank Name Options
get options() {
return [
    { label: 'AU SMALL FINANCE BANK', value: 'AU SMALL FINANCE BANK' },
{ label: 'AXIS BANK LTD', value: 'AXIS BANK LTD' },
{ label: 'BANDHAN BANK', value: 'BANDHAN BANK' },
{ label: 'BANK OF BARODA ', value: 'BANK OF BARODA ' },
{ label: 'BANK OF INDIA', value: 'BANK OF INDIA' },
{ label: 'BANK OF MAHARASHTRA', value: 'BANK OF MAHARASHTRA' },
{ label: 'CANARA BANK', value: 'CANARA BANK' },
{ label: 'CENTRAL BANK OF INDIA', value: 'CENTRAL BANK OF INDIA' },
{ label: 'CITY UNION BANK', value: 'CITY UNION BANK' },
{ label: 'COSMOS BANK', value: 'COSMOS BANK' },
{ label: 'DBS BANK', value: 'DBS BANK' },
{ label: 'DCB BANK LTD', value: 'DCB BANK LTD' },
{ label: 'DENA BANK', value: 'DENA BANK' },
{ label: 'DHANLAXMI BANK LTD', value: 'DHANLAXMI BANK LTD' },
{ label: 'EQUITAS SMALL FINANCE BANK', value: 'EQUITAS SMALL FINANCE BANK' },
{ label: 'ESAF SMALL FINANCE BANK', value: 'ESAF SMALL FINANCE BANK' },
{ label: 'HDFC BANK', value: 'HDFC BANK' },
{ label: 'ICICI BANK', value: 'ICICI BANK' },
{ label: 'IDBI BANK', value: 'IDBI BANK' },
{ label: 'IDFC FIRST BANK', value: 'IDFC FIRST BANK' },
{ label: 'INDIAN BANK', value: 'INDIAN BANK' },
{ label: 'INDIAN OVERSEAS BANK', value: 'INDIAN OVERSEAS BANK' },
{ label: 'INDUSIND BANK', value: 'INDUSIND BANK' },
{ label: 'ING VYSYA BANK LTD', value: 'ING VYSYA BANK LTD' },
{ label: 'KARNATAKA BANK LTD', value: 'KARNATAKA BANK LTD' },
{ label: 'KARUR VYSYA BANK', value: 'KARUR VYSYA BANK' },
{ label: 'KOTAK MAHINDRA BANK', value: 'KOTAK MAHINDRA BANK' },
{ label: 'PUNJAB AND SIND BANK', value: 'PUNJAB AND SIND BANK' },
{ label: 'PUNJAB NATIONAL BANK', value: 'PUNJAB NATIONAL BANK' },
{ label: 'RBL BANK', value: 'RBL BANK' },
{ label: 'STATE BANK OF INDIA', value: 'STATE BANK OF INDIA' },
{ label: 'TAMILNAD MERCANTILE BANK LTD', value: 'TAMILNAD MERCANTILE BANK LTD' },
{ label: 'THE FEDERAL BANK LTD', value: 'THE FEDERAL BANK LTD' },
{ label: 'THE Jammu & Kashmir Bank LTD', value: 'THE Jammu & Kashmir Bank LTD' },
{ label: 'THE SOUTH INDIAN BANK', value: 'THE SOUTH INDIAN BANK' },
{ label: 'UCO BANK', value: 'UCO BANK' },
{ label: 'UJJIVAN SMALL FINANCE BANK', value: 'UJJIVAN SMALL FINANCE BANK' },
{ label: 'UNION BANK OF INDIA', value: 'UNION BANK OF INDIA' },
{ label: 'YES BANK LTD', value: 'YES BANK LTD' },
];
}


@wire(CurrentPageReference)
getPageReferenceParameters(currentPageReference) {
this.isLoading = true;
if (currentPageReference) {
this.recordId = currentPageReference.state.recordId || null;
if(!this.recordId)this.recordId=this.strRecordId;
console.log('currentPageReference==>',currentPageReference);
}
}

@wire(getRecord, { recordId: Id, fields: [ ProfileName] })
    userDetails({ error, data }) {
        if (data) {
            if (data.fields.Profile.value != null) {
                var profileName = data.fields.Profile.value.fields.Name.value;
                if(profileName=='Territory Manager' || profileName=='Territory Manager SWAL' || profileName=='System Administrator'){
                    this.isTMOrAdmin=true;
                }
                else{
                    this.tostMsg( 'This functionality is available for TMs and System Administrators only', "info");
                    this.closeQuickAction();
                }
            }
        }
    }

connectedCallback(){
    loadStyle(this, modal);
    console.log('this.recordId==>'+this.recordId);
    this.queryPartners='Select Name,Address__c,PAN__c,Adhaar__c,Relationship__c,Profit_Sharing_Ratio__c from On_Boarding_Partner__c';
    this.queryParticulars='Select Name,No_of_Years_in_Business__c,Year_1__c,Year_2__c,Year_3__c,Year_4__c from Particulars_of_the_Business__c';
    this.queryOtherBusiness='Select Name,Status__c,Capital_Invested__c,Shares_of_his_Profit__c,Nature_of_its_business__c from On_Boarding_Other_Business__c';
    this.queryLegalCases='Select Type__c,Case_No_Date__c,Complaint_Plaintiff__c,Accused_Defendants__c,Remarks__c from On_Boarding_Legal_Cases__c';
    this.queryAnnexure3='Select Name,Relationship__c,Age__c,Specimen_Signature__c from On_Boarding_Annexure_3__c';
    this.tableFinalUpsertData = [];
    this.tableFinalInsertData = [];
    this.deletedRecordsAllList = [];

    this.ProfilePhotoLabel='Attach Customer Photograph(max. size '+this.label.fileSizeProfilePhoto+'kb)';
    this.markee='*Total upload size of the attachments should not exceed '+(this.label.fileSize/1000)+'MB';
}

@track signingAuthRecordsOnLoad=0;
@track partnerRecordsOnLoad=0;

@wire(getSAandAccData, {
    recordId: "$recordId"
})
getData(result) {
    this.wholeDataResultWire=result;
    this.isLoading = true;
    console.log('result ===> ',result);
    if(result.data){
        console.log('check for Wrapper ',result.data.mobileviewSection);
        console.log('this.checkDevice-----',this.checkDevice);
        if(result.data.mobileviewSection && (FORM_FACTOR=='Small' || FORM_FACTOR=='Medium')){
            this.checkDevice = true;
            console.log('this.checkDevice-----',this.checkDevice);
            this.template.querySelector('[data-id="wrapOnPhone"]').classList.add('wordbreakClass');
            this.sectionKeys = Object.keys(result.data.mobileviewSection);
            for(var i=0;i<this.sectionKeys.length;i++){
                if(result.data.mobileviewSection[this.sectionKeys[i]]==false && this.sectionKeys[i]!='Active__c' && this.template.querySelector('[data-id='+this.sectionKeys[i]+']') != null ){
                    console.log(' check section id',this.template.querySelector('[data-id='+this.sectionKeys[i]+']'));
                    this.template.querySelector('[data-id='+this.sectionKeys[i]+']').classList.add('hideSectionMobileView');
                }
            }
        }


        
        if(result.data.Status==false){
            this.tostMsg( result.data.Message, "error");
            this.closeQuickAction();
        }
        else{
            this.signingAuthRecordsOnLoad=result.data.signingAuthorityRecords;
            this.partnerRecordsOnLoad=result.data.partnerRecords;
            this.salesAreaRecord=result.data.SalesAreaRecord;
            this.constOfBusiness=result.data.SalesAreaRecord.Distributor__r.Constitution_of_Business__c;
            this.companyName=result.data.SalesAreaRecord.Distributor__r.Name;
            this.emailVal=result.data.SalesAreaRecord.Distributor__r.Email__c;
            this.phoneVal=result.data.SalesAreaRecord.Distributor__r.Mobile__c;
            this.gstNumber=result.data.SalesAreaRecord.Distributor__r.Tax_Number_3__c;
            this.panNumber=result.data.SalesAreaRecord.Distributor__r.PAN_Number__c;
            this.companyCity=result.data.SalesAreaRecord.Distributor__r.BillingCity;
            var addressString=result.data.SalesAreaRecord.Distributor__r.Billing_Street_2__c+' '+result.data.SalesAreaRecord.Distributor__r.BillingStreet+' '+result.data.SalesAreaRecord.Distributor__r.BillingCity+' '+result.data.SalesAreaRecord.Distributor__r.BillingPostalCode+' '+result.data.SalesAreaRecord.Distributor__r.BillingState+' '+result.data.SalesAreaRecord.Distributor__r.BillingCountry;
            this.companyAddress=addressString.replaceAll('undefined','');
            console.log('this.salesAreaRecord==>',this.salesAreaRecord);
            this.corporateAddress=result.data.SalesAreaRecord.SalesOrg__r.Corporate_Office_Address__c;
            this.registeredAddress=result.data.SalesAreaRecord.SalesOrg__r.Registered_office_Address__c;
            this.companyFirstName=result.data.SalesAreaRecord.Distributor__r.First_Name__c;
            if(result.data.SalesAreaRecord.Distributor__r.Non_GST_Customer__c==true){
                this.gstNumber='Non GST Customer';
            }
            this.salesOrgCompanyName=result.data.SalesAreaRecord.SalesOrg__r.Company_Name__c;

            console.log('result.data.SalesAreaRecord.Year_of_Establishment__c----',result.data.SalesAreaRecord.Year_of_Establishment__c);
            console.log('bank details ',result.data.SalesAreaRecord.Bank_Name__c);
            //Sales Area details fetching work
            if(result.data.SalesAreaRecord.Year_of_Establishment__c!=null && result.data.SalesAreaRecord.Year_of_Establishment__c!='' && result.data.SalesAreaRecord.Year_of_Establishment__c!=undefined){
                this.yearOfEstablishmentCheck=true;
                this.yearOfEstablishmentCheckNot=false;
                this.yearOfEstablishmentName=result.data.SalesAreaRecord.Year_of_Establishment__c;
                this.template.querySelector('[data-id="yearOfEstablishmentCheck"]').checked=true;
            }
            if(result.data.SalesAreaRecord.Shop_Establishment_Act_License_No__c!=null && result.data.SalesAreaRecord.Shop_Establishment_Act_License_No__c!='' && result.data.SalesAreaRecord.Shop_Establishment_Act_License_No__c!=undefined){
                this.shopEstablishmentCheck=true;
                this.shopEstablishmentCheckNot=false;
                this.shopEstablishmentName=result.data.SalesAreaRecord.Shop_Establishment_Act_License_No__c;
                this.template.querySelector('[data-id="shopEstablishmentCheck"]').checked=true;
            }
            if(result.data.SalesAreaRecord.Insectticides_License_No__c!=null && result.data.SalesAreaRecord.Insectticides_License_No__c!='' && result.data.SalesAreaRecord.Insectticides_License_No__c!=undefined){
                //this.pesticideCheck=true;
                //this.pesticideCheckNot=false;
                this.pesticideName=result.data.SalesAreaRecord.Insectticides_License_No__c;
                this.validTillDatePesticide=result.data.SalesAreaRecord.Insectticides_Valid_till_date__c;
                //this.template.querySelector('[data-id="pesticideCheck"]').checked=true;
            }
            if(result.data.SalesAreaRecord.Fertilizer_License_No__c!=null && result.data.SalesAreaRecord.Fertilizer_License_No__c!='' && result.data.SalesAreaRecord.Fertilizer_License_No__c!=undefined){
                this.fertilizerCheck=true;
                this.fertilizerCheckNot=false;
                this.fertilizerName=result.data.SalesAreaRecord.Fertilizer_License_No__c;
                this.validTillDateFertilizer=result.data.SalesAreaRecord.Fertilizer_Valid_till_date__c;
                this.template.querySelector('[data-id="fertilizerCheck"]').checked=true;
            }
            if(result.data.SalesAreaRecord.Seeds_License_No__c!=null && result.data.SalesAreaRecord.Seeds_License_No__c!='' && result.data.SalesAreaRecord.Seeds_License_No__c!=undefined){
                this.seedsLicenseCheck=true;
                this.seedsLicenseCheckNot=false;
                this.seedsLicenseName=result.data.SalesAreaRecord.Seeds_License_No__c;
                this.validTillDateSeed=result.data.SalesAreaRecord.Seeds_Valid_till_date__c;
                this.template.querySelector('[data-id="seedsLicenseCheck"]').checked=true;
            }
            
            this.bankName=result.data.SalesAreaRecord.Bank_Name__c;
            if(result.data.SalesAreaRecord.Account_Number__c!=0)
            this.bankName2=result.data.SalesAreaRecord.Account_Number__c;
            this.bankName3=result.data.SalesAreaRecord.IFSC_Code__c;

            if(result.data.SalesAreaRecord.Total_No_of_years_in_business__c!=0.00)
            this.totalInput1=result.data.SalesAreaRecord.Total_No_of_years_in_business__c;
            if(result.data.SalesAreaRecord.Total_Business_in_Year_1__c!=0.00)
            this.totalInput2=result.data.SalesAreaRecord.Total_Business_in_Year_1__c;
            if(result.data.SalesAreaRecord.Total_Business_in_Year_2__c!=0.00)
            this.totalInput3=result.data.SalesAreaRecord.Total_Business_in_Year_2__c;
            if(result.data.SalesAreaRecord.Total_Business_in_Year_3__c!=0.00)
            this.totalInput4=result.data.SalesAreaRecord.Total_Business_in_Year_3__c;
            if(result.data.SalesAreaRecord.Total_Business_in_Year_4__c!=0.00)
            this.totalInput5=result.data.SalesAreaRecord.Total_Business_in_Year_4__c;

            if(result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchase_in_busines__c!=0.00)
            this.ratioInput1=result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchase_in_busines__c;
            if(result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_1__c!=0.00)
            this.ratioInput2=result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_1__c;
            if(result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_2__c!=0.00)
            this.ratioInput3=result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_2__c;
            if(result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_3__c!=0.00)
            this.ratioInput4=result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_3__c;
            if(result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_4__c!=0.00)
            this.ratioInput5=result.data.SalesAreaRecord.Ratio_of_Cash_Credit_Purchases_in_Year_4__c;

            if(result.data.SalesAreaRecord.Total_of_liability__c!=0.00 && result.data.SalesAreaRecord.Total_of_liability__c!=0)
            this.personalGuaranteeInput1=result.data.SalesAreaRecord.Total_of_liability__c;
            
            if(result.data.SalesAreaRecord.Relative_Name__c!='' && result.data.SalesAreaRecord.Relative_Name__c!=null && result.data.SalesAreaRecord.Relative_Name__c!=undefined)
            this.relationInput1=result.data.SalesAreaRecord.Relative_Name__c;
            if(result.data.SalesAreaRecord.Relative_Position__c!='' && result.data.SalesAreaRecord.Relative_Position__c!=null && result.data.SalesAreaRecord.Relative_Position__c!=undefined)
            this.relationInput2=result.data.SalesAreaRecord.Relative_Position__c;
            if(result.data.SalesAreaRecord.Relative_Head_quartered_Address__c!='' && result.data.SalesAreaRecord.Relative_Head_quartered_Address__c!=null && result.data.SalesAreaRecord.Relative_Head_quartered_Address__c!=undefined)
            this.relationInput3=result.data.SalesAreaRecord.Relative_Head_quartered_Address__c;
            if(result.data.SalesAreaRecord.Relative_Department__c!='' && result.data.SalesAreaRecord.Relative_Department__c!=null && result.data.SalesAreaRecord.Relative_Department__c!=undefined)
            this.relationInput4=result.data.SalesAreaRecord.Relative_Department__c;
            if(result.data.SalesAreaRecord.Relative_Relationship__c!='' && result.data.SalesAreaRecord.Relative_Relationship__c!=null && result.data.SalesAreaRecord.Relative_Relationship__c!=undefined)
            this.relationInput5=result.data.SalesAreaRecord.Relative_Relationship__c;
            this.template.querySelector('[data-id="relativeWorkingCheck"]').checked=result.data.SalesAreaRecord.Is_relative_worked_with_UPL__c;
            this.relativeWorkingCheck=result.data.SalesAreaRecord.Is_relative_worked_with_UPL__c;

            //Documents fetching
            if(result.data.SalesAreaRecord.ContentDocumentLinks!=undefined){
                for(var i=0;i<result.data.SalesAreaRecord.ContentDocumentLinks.length;i++){
                    let docDetails=result.data.SalesAreaRecord.ContentDocumentLinks[i];
                    this.documentDetailsMap.set(docDetails.ContentDocument.Title,docDetails.ContentDocument.Id);
                    if(docDetails.ContentDocument.Title=='profilePhoto' && this.profilePhotoDisabled==false){
                        this.isprofilePhotoDelete=false;
                        this.profilePhotoDisabled=true;
                    }
                    else if(docDetails.ContentDocument.Title=='yearOfEstablishmentFile'){
                        this.isyearOfEstablishmentFileDelete = false;
                        if(this.yearOfEstablishmentFileDisabled==false){
                            this.yearOfEstablishmentFileDisabled=true;
                        }
                    }
                    else if(docDetails.ContentDocument.Title=='gstNumberFile' && this.gstNumberFileDisabled==false){
                        this.isgstNumberFileDelete=false;
                        this.gstNumberFileDisabled=true;
                    }
                    else if(docDetails.ContentDocument.Title=='shopEstablishmentFile'){
                        this.isshopEstablishmentFileDelete = false;
                        if(this.shopEstablishmentFileDisabled==false){
                            this.shopEstablishmentFileDisabled=true;
                        }
                    }
                    else if(docDetails.ContentDocument.Title=='pesticideFile'){
                        this.ispesticideFileDelete = false;
                        if(this.pesticideFileDisabled==false){
                            this.pesticideFileDisabled=true;
                        }
                    }
                    else if(docDetails.ContentDocument.Title=='fertilizerFile'){
                        this.isfertilizerFileDelete=false;
                        if(this.fertilizerFileDisabled==false){
                            this.fertilizerFileDisabled=true;
                        }
                    }
                    else if(docDetails.ContentDocument.Title=='seedsLicenseFile'){
                        this.isseedsLicenseFileDelete = false;
                    }
                    else if(docDetails.ContentDocument.Title=='incomeTaxFile' && this.incomeTaxFileDisabled==false){
                        this.incomeTaxFileDisabled=true;
                        this.isincomeTaxFileDelete = false;
                    }
                    else if(docDetails.ContentDocument.Title.includes('bankFile') && this.bankFileDisabled==false){
                        this.bankFileDisabled=true;
                        this.isbankFileDelete=false;
                    }
                    else if(docDetails.ContentDocument.Title.includes('adhaarFile') && this.adhaarFileDisabled==false){
                        this.adhaarFileDisabled=true;
                        this.isadhaarFileDelete=false;
                    }
                    else if(docDetails.ContentDocument.Title=='DPNFile'){
                        this.template.querySelector('[data-id="DPNCheck"]').checked=true;
                        this.DPNFile.Id = docDetails.ContentDocument.Id;
                        this.DPNFile.Name = docDetails.ContentDocument.Title;
                        this.isDPNFileDelete = false;
                    }
                }
            }
            
        }
        this.isLoading = false;
    }else if(result.error){
        this.isLoading = false;
        this.tostMsg( result.error, "error");
        console.log('error ===> ',JSON.stringify(result.error));
    }
    refreshApex(this.wholeDataResultWire);
}
tostMsg(msg, type) {
    const event = new ShowToastEvent({
        title: msg,
        variant: type,
        mode:'pester'
    });
    this.dispatchEvent(event);
}
closeQuickAction() {
    this.dispatchEvent(new CloseActionScreenEvent());
    const navigateFinishEvent = new FlowNavigationFinishEvent();
    this.dispatchEvent(navigateFinishEvent);
    
}
get acceptedFormats() {
    return ['.jpeg', '.png', '.jpg', '.pdf'];
}
handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    console.log('event==>' , event.target.name);
    console.log('uploadedFiles==>' , uploadedFiles);
    var documentIdList=[];
    for(var i=0;i< event.detail.files.length;i++){
        documentIdList.push(event.detail.files[i].documentId);
    }
    this.updateFileName(event.target.name,documentIdList);  
}

checkDeleteEnableDisable(filenameval,isDeleted){
    var deleteVar = 'is'+ filenameval + 'Delete';
    console.log('deleteVar : ',deleteVar);
    this[deleteVar] = isDeleted;

    /*if(filenameval == 'DPNFile' && isDeleted){
        this.isDPNFileDelete = true;
    }else if(filenameval == 'DPNFile' && !isDeleted){
        this.isDPNFileDelete = false;
    }

    if(filenameval == 'bankFile' && isDeleted){
        this.isbankFileDelete = true;
    }else if(filenameval == 'bankFile' && !isDeleted){
        this.isbankFileDelete = false;
    }

    if(filenameval == 'incomeTaxFile' && isDeleted){
        this.isincomeTaxFileDelete = true;
    }else if(filenameval == 'incomeTaxFile' && !isDeleted){
        this.isincomeTaxFileDelete = false;
    }

    if(filenameval == 'seedsLicenseFile' && isDeleted){
        this.isseedsLicenseFileDelete = true;
    }else if(filenameval == 'seedsLicenseFile' && !isDeleted){
        this.isseedsLicenseFileDelete = false;
    }

    if(filenameval == 'fertilizerFile' && isDeleted){
        this.isfertilizerFileDelete = true;
    }else if(filenameval == 'fertilizerFile' && !isDeleted){
        this.isfertilizerFileDelete = false;
    }*/
}

handleDeleteFile(event){
    this.isLoading = true;
    console.log('handle delete event==>' , event.target.name);
    console.log('current ID==>' , event.currentTarget.dataset.id);
    var fileName = event.target.name;
    fileName = fileName.split('Del')[0];
    console.log('fileName : ',fileName);
    var contentDocId = this.documentDetailsMap.get(fileName);
    var contentDocIdList = [];
    //this.documentDetailsMap.has(fileName)

    for (let [key, value] of this.documentDetailsMap) {
        console.log(key + " = " + value);
        if(key.includes(fileName)){
            console.log('Contains Values : ',value);
            contentDocIdList.push(value);
        }
    }
    console.log('contentDocIdList : ',contentDocIdList);

    deleteFiles({ sdocumentIdList:contentDocIdList})
    .then((result) => {
        console.log('result==>',result);
        if(result = 'deleted'){
            let varName = fileName+'Disabled';
            this[varName] = false;
            this.checkDeleteEnableDisable(fileName,true);
            
            for (let [key, value] of this.documentDetailsMap) {
                console.log(key + " = " + value);
                if(key.includes(fileName)){
                    console.log('Contains Values : ',value);
                    this.documentDetailsMap.delete(key);
                }
            }
            console.log('this.documentDetailsMap updated : ',this.documentDetailsMap);
    
        }else{
            this.checkDeleteEnableDisable(fileName,false); 
        }
        this.isLoading = false;
    }).catch((error) => {
            console.log("----in error----", error);
            this.tostMsg(error.body.message, "error");
            this.isLoading = false;
    });
}

updateFileName(filename,documentIdVal){
    updateFileName({ filename:filename,documentIdVal:documentIdVal,salesAreaId:this.recordId})
    .then((result) => {
        console.log('result==>',result);
        console.log('upload successful'+filename);
        if(result.Status=='Upload Successful'){
            this.checkDeleteEnableDisable(filename,false);
            let varName=filename+'Disabled';
            var value=true;
            //window[varName]=+value;
            //eval(varName+'='+value);
            this[varName]=value;
            for(var i=0;i<result.documentList.length;i++){
                this.documentDetailsMap.set(result.documentList[i].Title,result.documentList[i].Id);
            }
            console.log('this.documentDetailsMap==>',this.documentDetailsMap);
            this.tostMsg( result.Status, "info");
        }
        else{
            this.tostMsg( result.Status, "error");
        }
    }).catch((error) => {
    console.log("----in error----", error);
    this.tostMsg(error.body.message, "error");
    this.isLoading = false;
    });
}

@track deleteCheckBoxDocs=[];
handlecheckboxchange(event){
    /*console.log('this.year==>',event.target);
    console.log('this.year==>',event.target.checked);
    console.log('this.year==>',event.target.value);*/
    var checkboxName=event.target.name;
    var checkboxNameNot=event.target.name+'Not';
    var checkboxValue=event.target.checked;
    this[checkboxName]=checkboxValue;
    console.log('this[checkboxName] ',this[checkboxName]);
    this[checkboxNameNot]=!checkboxValue;
    console.log('this[checkboxNameNot] ',this[checkboxNameNot]);
    var fileName=checkboxName.split('Check')[0]+'FileDisabled';
    console.log('------ ',checkboxName.split('Check')[0]+'FileDisabled');
    if(!this.documentDetailsMap.has(checkboxName.split('Check')[0]+'File'))
    this[fileName]=!checkboxValue;
    console.log('this[fileName] ',this[fileName]);
    if(!event.target.checked){
        var inputName=checkboxName.split('Check')[0]+'Name';
        
        this[inputName]='';
        
        /*if(checkboxName=='pesticideCheck'){
            this.validTillDatePesticide='';
        }
        else*/
            if(checkboxName=='fertilizerCheck')
        {
            this.validTillDateFertilizer='';
        }
        else if(checkboxName=='seedsLicenseCheck'){
            this.validTillDateSeed='';
        }
        if(checkboxName=='relativeWorkingCheck'){
            this.relationInput1='';
            this.relationInput2='';
            this.relationInput3='';
            this.relationInput4='';
            this.relationInput5='';
        }

        var fileName=checkboxName.split('Check')[0]+'File';
        if(this.documentDetailsMap.has(fileName)){
            this.deleteCheckBoxDocs.push(this.documentDetailsMap.get(fileName));
            console.log('this.deleteCheckBoxDocs==>',this.deleteCheckBoxDocs);
        }
        
    }
}
handleinputchange(event){
    //debugger;
    console.log('event==>',event);
    console.log('event.target==>',event.target);
    console.log('event.target.value==>',event.target.value);
    console.log('event.target.name==>',event.target.name);
    var mobileValue ;
    if(FORM_FACTOR=='Small' || FORM_FACTOR=='Medium'){
        mobileValue = this.template.querySelector('[data-id="blankText"]').value;
    }
    
    var regExp = /[a-zA-Z]/g;
    
    //alert(mobileValue);
    //alert(regExp.test(mobileValue));
    if((FORM_FACTOR=='Small' || FORM_FACTOR=='Medium') && event.target.name=='personalGuaranteeInput1' && (mobileValue =='' ||  regExp.test(mobileValue))){
        this.template.querySelector('[data-id="blankText"]').value="";
    }
    
    var inputName=event.target.name;
    var inputValue=event.target.value;
    this[inputName]=inputValue;
    console.log(' this[inputName]==>', this[inputName]);
}

    
@track salesAreaDetails=new Map();
//Dynamic Table work
@track is_editable = true;
//@track deletedRecordsList;
@track deletedRecordsAllList = [];
@track tableFinalInsertData = [];
@track tableFinalUpsertData = [];
@track records;
@api
async handleSave(){{
    this.isLoading = true;
    var resultinfo;
    await checkAttachmentsSize({ linkedRecordId:this.recordId})
            .then((result) => {
                //this.tostMsg("Data submitted successfully", "info");
                console.log('result Attachment==>',result);
                resultinfo=result;
                return result;
                //this.closeQuickAction();
            }).catch((error) => {
                console.log("----in error----", error);
                //this.tostMsg(error.body.message, "error");
                //this.isLoading = false;
                return error;
            });

    console.log('resultinfo : '+resultinfo);
    if(resultinfo == 'ERROR'){
        console.log('If Error');
        this.tostMsg("All uploaded files size should be less than "+(this.label.fileSize/1000)+" mb", "error");
    }

    if(this.checkRequiredFieldsBeforeSave() && resultinfo=='SUCCESS'){
        this.getContractData();
        this.submit();    
        console.log('this.salesAreaDetails==>',this.salesAreaDetails);
        console.log('this.tableFinalInsertData==>',this.tableFinalInsertData);
        await saveData({ deleteCheckBoxDocs:this.deleteCheckBoxDocs,salesAreaDetails:JSON.stringify(Object.fromEntries(this.salesAreaDetails)),salesAreaId:this.recordId, deletedRecordList : JSON.stringify(this.deletedRecordsAllList), upsertedRecordList : JSON.stringify(this.tableFinalUpsertData), insertedRecordList: JSON.stringify(this.tableFinalInsertData)})
                .then((result) => {
                    this.isLoading = false;
                    this.tostMsg("Data saved successfully", "info");
                    console.log('result==>',result);
                    this.closeQuickAction();
                }).catch((error) => {
                    console.log("----in error----", error);
                    this.tostMsg(error.body.message, "error");
                    this.isLoading = false;
                    this.tableFinalInsertData=[];
                    this.tableFinalUpsertData=[];
                });
    }
    else{
        this.isLoading = false;
    }
    const notifyChangeIds = this.deletedRecordsAllList.map((row) => {
        return { recordId: row.Id };
        });
        const notifyChangeIds1 = this.tableFinalUpsertData.map((row) => {
        return { recordId: row.Id };
        });
        const notifyChangeIds2 = this.tableFinalInsertData.map((row) => {
        return { recordId: row.Id };
        });
        
    getRecordNotifyChange([{ recordId: this.recordId }]);
    getRecordNotifyChange(notifyChangeIds);
    getRecordNotifyChange(notifyChangeIds1);
    getRecordNotifyChange(notifyChangeIds2);
    // var notifyRecIdsList=[];
    // let keys = Array.from( this.documentDetailsMap.values() );
    // for(var i=0;i<keys.size;i++){
    //     notifyRecIdsList.push({'recordId':keys[i]});
    // }
    // console.log('notifyRecIdsList==>',notifyRecIdsList);

    // getRecordNotifyChange(notifyRecIdsList); 
    // const resultList = [];
    // this.documentDetailsMap.forEach((value) => resultList.push({'recordId':value}));
    // console.log('resultList==>',resultList);
    // getRecordNotifyChange(resultList); 
    // var listOfDocIDs=Array.from( this.documentDetailsMap.values() );
    // const notifyChangeIds4 = listOfDocIDs.map((row) => {
    //     return { recordId: row.Id };
    //   });
    //   getRecordNotifyChange(notifyChangeIds4);
}}

getContractData(){
    this.salesAreaDetails.set('Is_relative_worked_with_UPL__c',this.relativeWorkingCheck);
    this.salesAreaDetails.set('Relative_Name__c',this.relationInput1);
    this.salesAreaDetails.set('Relative_Position__c',this.relationInput2);
    this.salesAreaDetails.set('Relative_Head_quartered_Address__c',this.relationInput3);
    this.salesAreaDetails.set('Relative_Department__c',this.relationInput4);
    this.salesAreaDetails.set('Relative_Relationship__c',this.relationInput5);

    this.salesAreaDetails.set('Total_of_liability__c',this.personalGuaranteeInput1);

    this.salesAreaDetails.set('Total_No_of_years_in_business__c',this.totalInput1);
    this.salesAreaDetails.set('Total_Business_in_Year_1__c',this.totalInput2);
    this.salesAreaDetails.set('Total_Business_in_Year_2__c',this.totalInput3);
    this.salesAreaDetails.set('Total_Business_in_Year_3__c',this.totalInput4);
    this.salesAreaDetails.set('Total_Business_in_Year_4__c',this.totalInput5);

    this.salesAreaDetails.set('Ratio_of_Cash_Credit_Purchase_in_busines__c',this.ratioInput1);
    this.salesAreaDetails.set('Ratio_of_Cash_Credit_Purchases_in_Year_1__c',this.ratioInput2);
    this.salesAreaDetails.set('Ratio_of_Cash_Credit_Purchases_in_Year_2__c',this.ratioInput3);
    this.salesAreaDetails.set('Ratio_of_Cash_Credit_Purchases_in_Year_3__c',this.ratioInput4);
    this.salesAreaDetails.set('Ratio_of_Cash_Credit_Purchases_in_Year_4__c',this.ratioInput5);

    this.salesAreaDetails.set('Year_of_Establishment__c',this.yearOfEstablishmentName);
    this.salesAreaDetails.set('Shop_Establishment_Act_License_No__c',this.shopEstablishmentName);
    this.salesAreaDetails.set('Insectticides_License_No__c',this.pesticideName);
    this.salesAreaDetails.set('Fertilizer_License_No__c',this.fertilizerName);
    this.salesAreaDetails.set('Seeds_License_No__c',this.seedsLicenseName);
    this.salesAreaDetails.set('Bank_Name__c',this.bankName);
    this.salesAreaDetails.set('Account_Number__c',this.bankName2);
    this.salesAreaDetails.set('IFSC_Code__c',this.bankName3);

    this.salesAreaDetails.set('Insectticides_Valid_till_date__c',this.validTillDatePesticide);
    this.salesAreaDetails.set('Fertilizer_Valid_till_date__c',this.validTillDateFertilizer);
    this.salesAreaDetails.set('Seeds_Valid_till_date__c',this.validTillDateSeed);
}


checkRequiredFieldsBeforeSubmit(){
    if(!this.documentDetailsMap.has('profilePhoto')){
        this.tostMsg('Kindly upload customer photograph', "error");
        return false;
    }
    else if(!this.documentDetailsMap.has('gstNumberFile')){
        this.tostMsg('Kindly upload document for GST Number', "error");
        return false;
    }
    else if(this.pesticideName=='' || !this.documentDetailsMap.has('pesticideFile') || this.validTillDatePesticide==''){
        this.tostMsg('Kindly enter Pesticides/Insecticides License No. details and upload document for the same before saving', "error");
        return false;
    }
    
    else if(!this.documentDetailsMap.has('incomeTaxFile')){
        this.tostMsg('Kindly upload document for Income Tax No. (PAN)', "error");
        return false;
    }
    else if(!this.documentDetailsMap.has('bankFile') || this.bankName=='' || this.bankName2=='' || this.bankName3==''){
        this.tostMsg('Kindly enter bank details and upload documents for the same', "error");
        return false;
    }
    else if(!this.documentDetailsMap.has('adhaarFile')){
        this.tostMsg('Kindly upload adhaar copy', "error");
        return false;
    }
    var isSigningEntryPresent=false;
    var isPartnerEntryPresent=false;
    for(var i=0;i<this.tableFinalInsertData.length;i++){
        if(isSigningEntryPresent==false && this.tableFinalInsertData[i].objectAPIName=='On_Boarding_Annexure_3__c'){
            isSigningEntryPresent=true;
        }
        if(isPartnerEntryPresent==false && this.tableFinalInsertData[i].objectAPIName=='On_Boarding_Partner__c'){
            isPartnerEntryPresent=true;
        }
    }

        var deletedRecordEntries=0;
        var deletedRecordEntries1=0;
        for(var i=0;i<this.deletedRecordsAllList.length;i++){
            if(isSigningEntryPresent==false && this.deletedRecordsAllList[i].objectAPIName=='On_Boarding_Annexure_3__c'){
                deletedRecordEntries=deletedRecordEntries+1;
            }
            if(isPartnerEntryPresent==false && this.deletedRecordsAllList[i].objectAPIName=='On_Boarding_Partner__c'){
                deletedRecordEntries1=deletedRecordEntries1+1;
            }
        }
        if(isSigningEntryPresent==false && this.signingAuthRecordsOnLoad>0 && this.signingAuthRecordsOnLoad>deletedRecordEntries){
            isSigningEntryPresent=true;
        }

    if(isSigningEntryPresent==false){
        this.tostMsg('Kindly enter atleast one entry under declaration of signing authority', "error");
        return false;
    }

        if(isPartnerEntryPresent==false && this.partnerRecordsOnLoad>0 && this.partnerRecordsOnLoad>deletedRecordEntries1){
            isPartnerEntryPresent=true;
        }
    if(isPartnerEntryPresent==false){
        this.tostMsg('Kindly enter atleast one entry under partner details', "error");
        return false;
    }


    var insertAndUpdateRecordsPartner=[];
    insertAndUpdateRecordsPartner=this.tableFinalInsertData.concat(this.tableFinalUpsertData);
    var partnerRatioTotal=0;
    for(var k=0;k<insertAndUpdateRecordsPartner.length;k++){
        if(insertAndUpdateRecordsPartner[k].objectAPIName=='On_Boarding_Partner__c' && insertAndUpdateRecordsPartner[k].Profit_Sharing_Ratio__c!='' && insertAndUpdateRecordsPartner[k].Profit_Sharing_Ratio__c!=undefined){
            partnerRatioTotal=parseFloat(partnerRatioTotal)+parseFloat(insertAndUpdateRecordsPartner[k].Profit_Sharing_Ratio__c);
        }
    }
    if(partnerRatioTotal!=100){
        this.tostMsg('Please make sure the sum of profit sharing ratio is 100', "error");
        return false;
    }



    return true;
}

checkUploadedAttachmentsSize(){
    console.log('Sales Area Id ==> ',this.recordId);
    checkAttachmentsSize({ linkedRecordId:this.recordId})
            .then((result) => {
                //this.tostMsg("Data submitted successfully", "info");
                console.log('result Attachment==>',result);
                return result;
                //this.closeQuickAction();
            }).catch((error) => {
                console.log("----in error----", error);
                //this.tostMsg(error.body.message, "error");
                //this.isLoading = false;
                return error;
            });
    
}

checkRequiredFieldsBeforeSave(){
    console.log('this yearOfEstablishmentCheck ',this.yearOfEstablishmentCheck);
    console.log('this.fertilizerCheck ',this.fertilizerCheck + 'this.fertilizerName ',this.fertilizerName + '!fertilizerFile ',!this.documentDetailsMap.has('fertilizerFile') +'this.validTillDateFertilizer ',this.validTillDateFertilizer);
    if(this.yearOfEstablishmentCheck && (this.yearOfEstablishmentName=='' || !this.documentDetailsMap.has('yearOfEstablishmentFile'))){
        this.tostMsg('Kindly enter Year of Establishment details and upload document for the same before saving', "error");
        return false;
    }
    // else if(this.documentDetailsMap.containskey('gstNumberFile')){
    //     this.tostMsg('Kindly upload document for GST Number', "error");
    //     return false;
    // }
    else if(this.shopEstablishmentCheck && (this.shopEstablishmentName=='' || !this.documentDetailsMap.has('shopEstablishmentFile'))){
        this.tostMsg('Kindly enter Shop & Establishment Act. License No. details and upload document for the same before saving', "error");
        return false;
    }
    
    else if(this.fertilizerCheck && (this.fertilizerName=='' || !this.documentDetailsMap.has('fertilizerFile') || this.validTillDateFertilizer=='')){
        this.tostMsg('Kindly enter Fertilizer License No. details and upload document for the same before saving', "error");
        return false;
    }
    else if(this.seedsLicenseCheck && (this.seedsLicenseName=='' || !this.documentDetailsMap.has('seedsLicenseFile')  || this.validTillDateSeed=='')){
        this.tostMsg('Kindly enter Seeds License No. details and upload document for the same before saving', "error");
        return false;
    }
    // else if(this.documentDetailsMap.containskey('incomeTaxFile')){
    //     this.tostMsg('Kindly upload document for Income Tax No. (PAN)', "error");
    //     return false;
    // }
    // else if(this.documentDetailsMap.containskey('bankFile') || this.bankName=='' || this.bankName2=='' || this.bankName3==''){
    //     this.tostMsg('Kindly enter bank details and upload documents for the same', "error");
    //     return false;
    // }
    return true;
}

@api
async handleSubmit(){{
    this.isLoading = true;
    //var resultinfo = this.checkUploadedAttachmentsSize();
    //console.log('resultinfo : '+resultinfo);
    this.submit();
    if(this.checkRequiredFieldsBeforeSave() && this.checkRequiredFieldsBeforeSubmit()){
            this.getContractData();     
            this.salesAreaDetails.set('Contract_Details_Submitted__c',true);
            console.log('this.tableFinalInsertData==>',this.tableFinalInsertData);
    console.log('this.salesAreaDetails==>',this.salesAreaDetails);
    await saveData({ salesAreaDetails:JSON.stringify(Object.fromEntries(this.salesAreaDetails)),salesAreaId:this.recordId,  deletedRecordList : JSON.stringify(this.deletedRecordsAllList), upsertedRecordList : JSON.stringify(this.tableFinalUpsertData), insertedRecordList: JSON.stringify(this.tableFinalInsertData)})
            .then((result) => {
                this.isLoading = false;
                this.tostMsg("Data submitted successfully", "info");
            console.log('result==>',result);
            this.closeQuickAction();
            }).catch((error) => {
            console.log("----in error----", error);
            this.tostMsg(error.body.message, "error");
            this.isLoading = false;
            });
        }
        else{
            this.isLoading = false;
            this.tableFinalUpsertData=[];
            this.tableFinalInsertData=[];
        }
        const notifyChangeIds = this.deletedRecordsAllList.map((row) => {
            return { recordId: row.Id };
            });
            const notifyChangeIds1 = this.tableFinalUpsertData.map((row) => {
            return { recordId: row.Id };
            });
            const notifyChangeIds2 = this.tableFinalInsertData.map((row) => {
            return { recordId: row.Id };
            });
            
        getRecordNotifyChange([{ recordId: this.recordId }]);
        getRecordNotifyChange(notifyChangeIds);
        getRecordNotifyChange(notifyChangeIds1);
        getRecordNotifyChange(notifyChangeIds2);
        
    }
}



handleDeleteRecords(event){
    //this.deletedRecordsList = JSON.parse(JSON.stringify(event.detail));
    var deltedRecord = JSON.parse(JSON.stringify(event.detail));
    if(!deltedRecord.Id.includes('-')){
        this.deletedRecordsAllList.push(deltedRecord);
    }
    
    console.log('deltedRecord : ',deltedRecord);
    console.log('deletedRecordsAllList : ',this.deletedRecordsAllList);
}

submit() {
    var table = this.template.querySelectorAll("c-grz_create-Dynamic-Table-Onboarding");
    

    if(table!=undefined){
        
        for(var i=0; i<=table.length-1 ; i++)  {
            this.records = table[i].retrieveRecords();
            this.records.forEach(element => {
                if(element.Id!=undefined){
                    if(element.Id.includes('-')){
                        this.tableFinalInsertData.push(element);
                    }
                    else if(element.Id!=''){
                        var existAlready=false;
                        for(var j=0;j<this.tableFinalUpsertData.length;j++){
                            if(this.tableFinalUpsertData[j].Id==element.Id){
                                existAlready=true; 
                                this.tableFinalUpsertData.splice(j,1);
                            }
                        }
                        this.tableFinalUpsertData.push(element);
                    }
                }
            });
            console.log('this.tableFinalInsertData : ',this.tableFinalInsertData);
            console.log('this.tableFinalUpsertData : ',this.tableFinalUpsertData);
        }
        console.log('All this.deletedRecordsList on submit : ',this.deletedRecordsAllList);           
    }

}
}