import { LightningElement, api, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import checkAccount from '@salesforce/apex/ManualSalesForecastController.checkAccount';
import getCustomerRegions from '@salesforce/apex/ManualSalesForecastController.getCustomerRegions';
import getActiveMonth from '@salesforce/apex/ManualSalesForecastController.getActiveMonth';
import createForecastManual from '@salesforce/apex/ManualSalesForecastController.createForecastManual';
import PleaseWait from '@salesforce/label/c.Please_wait';
import Year from '@salesforce/label/c.Year';
import Month from '@salesforce/label/c.Month';
import Close from '@salesforce/label/c.Close';
import Cancel from '@salesforce/label/c.Cancel';
import GenerateSalesForecast from '@salesforce/label/c.Generate_Sales_Forecast';
import SelectRegion from '@salesforce/label/c.Select_Region';
import Region from '@salesforce/label/c.Region';
import Submit from '@salesforce/label/c.Submit';
import ErrorT from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Warning from '@salesforce/label/c.Warning';
import FailToGetRegionREcord from '@salesforce/label/c.Failed_To_Get_Region_Records';
import ProcessInitiated from '@salesforce/label/c.Process_Has_Been_Initiated';
import FailToCreateRecord from '@salesforce/label/c.Failed_To_Create_Record';
import None from '@salesforce/label/c.None';
import SFNotPermittedForAccount from '@salesforce/label/c.Sales_Forecast_generation_is_not_permitted_for_this_account';

export default class ManualSalesForecast extends LightningElement {
    @api recordId;
    @track monthName;
    @track rgnOptions = [];
    @track showSpinner = false;
    @track isModalOpen = false;
    @track yearVal;
    @track error = '';
    @track selectedRgn = '';

    label = {
        PleaseWait,
        Year,
        Month,
        Close,
        Cancel,
        GenerateSalesForecast,
        SelectRegion,
        Region,
        Submit,
        ErrorT,
        Success,
        Warning,
        FailToGetRegionREcord,
        ProcessInitiated,
        FailToCreateRecord,
        None,
        SFNotPermittedForAccount

    };

    fetchRegions(){
        this.showSpinner = true;
        getCustomerRegions({accId : this.recordId}) 
        .then(result => { 
            console.log('result.length - ', result.length);
            console.log('result - ', result);

            this.rgnOptions = [];
            const option2 = {
                label: None,
                value: ''
            };
            this.rgnOptions.push(option2);
            
            if(result.length>0){
                for(const list of result){
                    const option = {
                        label: list.Territory__r.Name,
                        value: list.Territory__c
                    };
                    this.rgnOptions.push(option);
                    console.log('option :- ', option);

                    if(result.length == 1){
                        this.selectedRgn = list.Territory__c;
                    }
                }
                this.rgnOptions = JSON.parse(JSON.stringify(this.rgnOptions));
                console.log('this.rgnOptions :- ', JSON.parse(JSON.stringify(this.rgnOptions)));
                this.showSpinner = false;
            }
            else{
                this.showSpinner = false;
                this.showToastmessage(ErrorT,FailToGetRegionREcord,'Error');
            }
        })
        .catch(error => {
            console.log('js method catch');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })
    }

    fetchMonthYear(){
        this.showSpinner = true;
        getActiveMonth() 
        .then(result => { 
            if(result.length>0){
                this.monthName = result;
                let d = new Date();
                let n = d.getFullYear();
                this.yearVal = n;
            }
            else{
                this.monthName = '';
            }
            this.showSpinner = false;
        })
        .catch(error => {
            console.log('js method catch getActiveMonth ');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })
    }

    connectedCallback(){
        // this.baseUrl = window.location.origin;
        console.log('ManualSalesForecast recordId :- ', this.recordId);
         this.showSpinner = true;
         

        checkAccount({accId : this.recordId}) 
        .then(result => { 
            console.log('js method checkAccount :- ', result);
            if(result == true){
                this.isModalOpen = true;
                this.fetchRegions();
                this.fetchMonthYear();
            }
            else{
                this.showToastmessage(ErrorT,SFNotPermittedForAccount,'Error');
            }
        })
        .catch(error => {
            console.log('js method catch checkAccount ');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })

        
    
        this.showSpinner = false;
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.yearVal = '';
        this.monthName = '';
        this.rgnOptions = [];
        this.selectedRgn = '';
        const closeQA = new CustomEvent('close')
        this.dispatchEvent(closeQA);
    }

    handleSubmitClick(event){
        // this.baseUrl = window.location.origin;
        console.log('handleSubmitClick ');
        console.log('this.selectedRgn.length :- ', this.selectedRgn.length);

        //this.selectedRgn = this.template.querySelector("lightning-combobox[data-my-id=combo_id]");

        if(this.selectedRgn.length == 0){
            this.showToastmessage(ErrorT,SelectRegion,'error');
        }
        else{

            this.showSpinner = true;
            createForecastManual({accId : this.recordId, terId : this.selectedRgn, yr : this.yearVal}) 
            .then(result => { 
                console.log('result.length - ', result.length);
                console.log('result - ', result);
                
                if(result.length>0){
                    if(result == 'Success'){
                        this.showToastmessage(Success,ProcessInitiated,'Success');
                    }
                    else{
                        this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
                    }
                }
                else{
                    this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
                }
                
            })
            .catch(error => {
                console.log('js method catch');
                console.log(error);
                this.error = error;          
                //this.showToastmessage(ErrorT,error.body.message,'error');
                this.showSpinner = false;
            })
            this.showSpinner = false;
            
        }
    }

    showToastmessage(title,message,varient){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
        this.closeModal();
    }

    handleRgnChange(event) {
        this.selectedRgn = event.detail.value;
    }
}