import { LightningElement, track, wire } from 'lwc';
import getPOGSkuPriceList from '@salesforce/apex/Grz_POGSkuPriceListController.getPOGSkuPriceList'
import getUserRole from '@salesforce/apex/Grz_PolandLiquidation.getUserRole';
import loading_data from '@salesforce/label/c.Loading';
import All from '@salesforce/label/c.All';
import None from '@salesforce/label/c.None';
import Year from '@salesforce/label/c.Year';
import no_data from '@salesforce/label/c.No_data_found';
import Select_Year from '@salesforce/label/c.Select_Year';
import SKU_Code from '@salesforce/label/c.SKU_Code';
import SKUPrice from '@salesforce/label/c.Grz_SKUPrice';
import SKUPriceList from '@salesforce/label/c.Grz_SKUPriceList';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import FIscal_Year__c from '@salesforce/schema/Liquidation_Annual_Plan__c.FIscal_Year__c';
import object_liquidationAnnualPlan from '@salesforce/schema/Liquidation_Annual_Plan__c';
import PolandEditProfile from '@salesforce/label/c.PolandEditProfile';
import NoAccessForScreen from '@salesforce/label/c.Grz_NoAccessForScreen';
import UploadButton from '@salesforce/label/c.Grz_UploadSKUPrice';

export default class Grz_POGSkuPriceList extends LightningElement {
    @track data;
    @track error;
    @track openModelOI=false;
    @track spinner = false;
    @track userRoleName = '';
    All = All;
    None = None;
    Year = Year;
    Select_Year = Select_Year;
    SKU_Code = SKU_Code;
    NoDataFound = no_data;
    SKUPrice = SKUPrice;
    SKUPriceList = SKUPriceList;
    NoAccessForScreen = NoAccessForScreen;
    UploadButton = UploadButton;
    @track PolandEditProfile = PolandEditProfile;
    labels = {loading: loading_data};
    @track record_type = '';
    @track year = ''; 
    @track selectedyearvalue;
    @track selected_year = '';
    @track quarter = '';
    @track yearOption = [{ label: None, value: '' }];          // label:name value:Id
    @track yearOptionRemoveCurrent = [{ label: None, value: '' }];
    @track isDatafound = false;
    @track isDisplayScreen = false;
    /*@wire(getPOGSkuPriceList,{year: "$year"})
    getPOGSkuPriceList(result) {
        if (result.data) {
            this.data = result.data;
            console.log('this.data : ',this.data);
            this.error = undefined;

        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }*/

    /*connectedCallback(){
        this.spinner = true;
        getPOGSkuPriceList({year: this.year})
            .then(result => {
                console.log('connectedCallback results : ',result);
                this.data = result;
                this.spinner = false;
                })
                .catch(error => {
                this.spinner = false;
                console.log('Error : ',error);
        });
    }*/

    @wire(getUserRole)
    userRole({ error, data }) {
        this.spinner = true;
        console.log('userProfile data ', data, ' Err ', error);
        if (data) {
            this.userRoleName = data;
            this.spinner = false;
        }
        if (error) {
            this.userRoleName = '';
            this.spinner = false;
        }
    }

    renderedCallback(){
        console.log('PolandEditProfile==>',this.PolandEditProfile);
        console.log('userRoleName==>',this.userRoleName);
        if(this.PolandEditProfile.includes(this.userRoleName)){
            console.log('inside if');
             this.isDisplayScreen = true;
        }else{
            console.log('inside else');

            this.isDisplayScreen = false;
        }
        console.log('userRoleName==>',this.isDisplayScreen);

    }

    getSkuPriceList(year){
        this.spinner = true;
        this.year = year;
        getPOGSkuPriceList({year: this.year})
            .then(result => {
                console.log('connectedCallback results : ',result);
                this.data = result;
                if(this.data.length > 0){
                    this.isDatafound = true;
                }else{
                    this.isDatafound = false;
                }
                this.spinner = false;
                })
                .catch(error => {
                this.spinner = false;
                console.log('Error : ',error);
        });
    }

    handleUploadCSVOI(){
        if(this.year==''){
            this.showToastmessage('Error', 'Error', 'error');
        }else{
            this.spinner = true;
            setTimeout(() => {
                this.spinner = false;
                this.openModelOI = true;
            }, 1500);
        }
        
    }
    

    handleCloseModelOI() {
        this.openModelOI = false;
    }

	refreshLiquidation(event) {
        this.spinner = true;
        setTimeout(() => {
            if (event.detail == true) {
                this.getSkuPriceList(this.selected_year);
                /*getPOGSkuPriceList({year: this.year})
                .then(result => {
                    console.log('Refresh results : ',result);
                    this.data = result;
                 })*/
                console.log('Refresh true');
            }
            this.spinner = false;
        }, 2000);
    }

    showToastmessage(title, message, varient) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    }

    @wire(getObjectInfo, { objectApiName: object_liquidationAnnualPlan })
    getRecordtype({ error, data }) {
        this.spinner = true;
        console.log('Record type ', data, 'Record Type ERR ', error)
        if (data) {
            console.log('Record type ', data);
            let rtis = data.recordTypeInfos;
            this.record_type = Object.keys(rtis).find(rti => rtis[rti].name === 'Multi Country');
            console.log('Record type Multi country ', this.record_type);
            this.spinner = false;
        }
        if (error) {
            console.log('Record Type ERR ', error);
            this.spinner = false;
        }
        this.spinner = false;
    }

    @wire(getPicklistValues, { recordTypeId: '$record_type', fieldApiName: FIscal_Year__c })
    TypePicklistValues_city({ data, error }) {
        this.yearOption = [];
        this.yearOptionRemoveCurrent = [];
        if (data) {

            console.log('Year options ', data.values);
            data.values.forEach(element => {
                this.yearOption = [...this.yearOption, { label: element.value, value: element.value.split('-')[0] }];
              
                if (element.value.split('-')[0] == new Date().getFullYear() || element.value.split('-')[0] == new Date().getFullYear()-1) {
                    console.log('inside set year');
                    console.log('Current Month : ',new Date().getMonth());

                        this.year = element.value.split('-')[0];
                        console.log('this.year : '+this.year);
                        this.selected_year = element.value;
                        this.selectedyearvalue =  element.value.split('-')[0];
                        console.log('this.selected_year : ',this.selected_year);
                }
                else{
                    //this.yearOptionRemoveCurrent = [...this.yearOptionRemoveCurrent, { label: element.value, value: element.value.split('-')[0] }];
                    //console.log('this.yearOptionRemoveCurrent 1 : ',this.yearOptionRemoveCurrent);
                }

            });
            this.yearOption.unshift({ label: None, value: '' });

            console.log('this.yearOption : ',this.yearOption);
        }

        if (this.year != ''){
            this.getSkuPriceList(this.selected_year);
        }
        else{
            this.spinner = false;
        }
        if (error) {
            console.log('error ', error);
        }
    };

    handleChangeYear(event){
        this.year = event.detail.value;
        this.selectedyearvalue = event.detail.value;
        this.selected_year = event.target.options.find(opt => opt.value.split('-')[0] === event.detail.value).label;
        console.log('this.selected_year==>',this.selected_year);
        this.spinner = true;
        console.log('this.year==>'+this.year);

        if (this.year != ''){
            this.getSkuPriceList(this.selected_year);
        }
        else{
            this.spinner = false;
        }
        //this.spinner = false;
    }
}