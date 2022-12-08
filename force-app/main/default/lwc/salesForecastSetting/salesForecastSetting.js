/* eslint-disable no-unused-vars */
/* eslint-disable vars-on-top */
/* eslint-disable no-console */
import { LightningElement ,wire,track} from 'lwc';
import getSalesForecast from '@salesforce/apex/SalesForecast.getSalesForecast';
import updateSalesForecast from '@salesforce/apex/SalesForecast.updateSalesForecast';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Admin_Configuration from '@salesforce/label/c.Admin_Configuration';
import Sales_Org from '@salesforce/label/c.Sales_Org';
import Sales_Agreement from '@salesforce/label/c.Sales_Agreement';
import Sales_Agreement_Schedule_Frequency_Allowed from '@salesforce/label/c.Sales_Agreement_Schedule_Frequency_Allowed';
import Active_Forecast_Month from '@salesforce/label/c.Active_Forecast_Month';
import Schedule_Frequency_Allowed from '@salesforce/label/c.Schedule_Frequency_Allowed';
import Currency_Allowed from '@salesforce/label/c.Currency_Allowed';
import Forecast_Submission_Date from '@salesforce/label/c.Forecast_Submission_Date';
import Start_Day_of_Submission from '@salesforce/label/c.Start_Day_of_Submission';
import End_Day_of_Submission from '@salesforce/label/c.End_Day_of_Submission';
import Forecast_Approval_Date from '@salesforce/label/c.Forecast_Approval_Date';
import Start_Day_of_Approval from '@salesforce/label/c.Start_Day_of_Approval';
import End_Day_of_Approval from '@salesforce/label/c.End_Day_of_Approval';
import Configuration_on_Sales_Forecast_Metric from '@salesforce/label/c.Configuration_on_Sales_Forecast_Metric';
import Please_select_how_to_generate_the_Forecast from '@salesforce/label/c.Please_select_how_to_generate_the_Forecast';
import Clone_the_existing_Forecast_Previous_month from '@salesforce/label/c.Clone_the_existing_Forecast_Previous_month';
import Create_a_forecast_based_on_the_Product_Price_book_Account_and_User_Setting_if from '@salesforce/label/c.Create_a_forecast_based_on_the_Product_Price_book_Account_and_User_Setting_if';
import Note_This_is_based_on_the_value_is_Forecast_required_True_for_all_the_above_o from '@salesforce/label/c.Note_This_is_based_on_the_value_is_Forecast_required_True_for_all_the_above_o';
import Save from '@salesforce/label/c.Save';
import Cancel from '@salesforce/label/c.Cancel';
import Success from '@salesforce/label/c.Success';
import Updated_successfully from '@salesforce/label/c.Updated_successfully';
import Warning from '@salesforce/label/c.Warning';
import Start_Day_of_Submission_Should_be_Less_Than_End_Day_of_Submission from '@salesforce/label/c.Start_Day_of_Submission_Should_be_Less_Than_End_Day_of_Submission';
import Start_Day_of_Approval_Should_be_Less_Than_End_Day_of_Approval from '@salesforce/label/c.Start_Day_of_Approval_Should_be_Less_Than_End_Day_of_Approval';
import Configuration_On_Sales_Forecast_Matric_Should_Be_Between_0_And_100 from '@salesforce/label/c.Configuration_On_Sales_Forecast_Matric_Should_Be_Between_0_And_100';
import Start_Day_of_Approval_should_not_be_less_than_End_Day_of_Submission from '@salesforce/label/c.Start_Day_of_Approval_should_not_be_less_than_End_Day_of_Submission';
import Please_enter_valid_number from '@salesforce/label/c.Please_enter_valid_number';
import Monthly from '@salesforce/label/c.Monthly';
import Quarterly from '@salesforce/label/c.Quarterly';
import Yearly from '@salesforce/label/c.Yearly';
import One_Time from '@salesforce/label/c.One_Time';
import January from '@salesforce/label/c.January';
import Febuary from '@salesforce/label/c.Febuary';
import March from '@salesforce/label/c.March';
import April from '@salesforce/label/c.April';
import May from '@salesforce/label/c.May';
import June from '@salesforce/label/c.June';
import July from '@salesforce/label/c.July';
import August from '@salesforce/label/c.August';
import September from '@salesforce/label/c.September';
import October from '@salesforce/label/c.October';
import November from '@salesforce/label/c.November';
import December from '@salesforce/label/c.December';
export default class SalesForecastSetting extends LightningElement {
@track SalesAgreement = '';    
@track salesorg = '';
@track salesforecast = [];
@track ActiveForecastMonth = '';
@track ScheduleFrequencyAllowed = '';
@track currency='';
@track StartDayOfSubmission = '';
@track EndDayOfSubmission = '';
@track StartDayOfApproval = '';
@track EndDayOfApproval = '';
@track ConfigurationOnSalesForecastMatrix = '';
@track SalesForecastMatrix = '';
@track checkbox1 = false;
@track checkbox2 = false;
@track submissionOption1 = [];
@track submissionOption2 = [];
@track submissionOption3 = [];
@track submissionOption4 = [];
@track disableSave=false;
@track result='';
@track optioncall=false;

@track label = {
    Admin_Configuration,
    Sales_Org,
    Sales_Agreement,
    Sales_Agreement_Schedule_Frequency_Allowed,
    Active_Forecast_Month,
    Schedule_Frequency_Allowed,
    Currency_Allowed,
    Forecast_Submission_Date,
    Start_Day_of_Submission,
    End_Day_of_Submission,
    Forecast_Approval_Date,
    Start_Day_of_Approval,
    End_Day_of_Approval,
    Configuration_on_Sales_Forecast_Metric,
    Please_select_how_to_generate_the_Forecast,
    Clone_the_existing_Forecast_Previous_month,
    Create_a_forecast_based_on_the_Product_Price_book_Account_and_User_Setting_if,
    Note_This_is_based_on_the_value_is_Forecast_required_True_for_all_the_above_o,
    Save,
    Cancel,
    Success,
    Updated_successfully,
    Warning,
    Start_Day_of_Submission_Should_be_Less_Than_End_Day_of_Submission,
    Start_Day_of_Approval_Should_be_Less_Than_End_Day_of_Approval,
    Configuration_On_Sales_Forecast_Matric_Should_Be_Between_0_And_100,
    Start_Day_of_Approval_should_not_be_less_than_End_Day_of_Submission,
    Please_enter_valid_number,
    Monthly,
    Quarterly,
    Yearly,
    One_Time,
    January,
    Febuary,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December
};

year = new Date().getFullYear();

showToast1() {
    const event = new ShowToastEvent({
        title: this.label.Success,
        message: this.label.Updated_successfully,
        variant: 'success',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}

showToast2() {
    const event = new ShowToastEvent({
        title: this.label.Warning,
        message: this.label.Start_Day_of_Submission_Should_be_Less_Than_End_Day_of_Submission,
        variant: 'warning',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}

showToast3() {
    const event = new ShowToastEvent({
        title: this.label.Warning,
        message: this.label.Start_Day_of_Approval_Should_be_Less_Than_End_Day_of_Approval,
        variant: 'warning',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}

showToast4() {
    const event = new ShowToastEvent({
        title: this.label.Warning,
        message:  this.label.Configuration_On_Sales_Forecast_Matric_Should_Be_Between_0_And_100,
        variant: 'warning',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}

showToast5() {
    const event = new ShowToastEvent({
        title: this.label.Warning,
        message: this.label.Start_Day_of_Approval_should_not_be_less_than_End_Day_of_Submission,
        variant: 'warning',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}

showToast6() {
    const event = new ShowToastEvent({
        title: this.label.Warning,
        message: this.label.Please_enter_valid_number,
        variant: 'warning',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}



@wire (getSalesForecast)
Wiredsalesforecast({ error, data }) {
    if (data) {
        this.salesforecast = data;
        console.log('data----'+data);
        console.log('sales forecast data---'+this.salesforecast);
        this.salesorg = this.salesforecast[0].Sales_Org__r.Name;
        this.SalesAgreement = this.salesforecast[0].Sales_Agreement_Schedule_Frequency_Allow__c;
        this.ActiveForecastMonth = this.salesforecast[0].Active_Forecast_Month__c;
        this.ScheduleFrequencyAllowed = this.salesforecast[0].Schedule_Frequency_Allowed__c;
        this.currency=this.salesforecast[0].Currency_Allowed__c;
        this.StartDayOfSubmission=''+this.salesforecast[0].Start_Day_of_Submission__c;
        this.EndDayOfSubmission=''+this.salesforecast[0].End_Day_of_Submission__c;
        this.StartDayOfApproval=''+this.salesforecast[0].Start_Day_Of_Approval__c;
        this.EndDayOfApproval=''+this.salesforecast[0].End_Day_Of_Approval__c;
        this.ConfigurationOnSalesForecastMatrix = String(this.salesforecast[0].Configuration_on_Sales_Forecast_Metric__c).replace('.',',');
        this.checkbox1=this.salesforecast[0].Clone_the_existing_Forecast_Previous_mon__c;
        this.checkbox2=this.salesforecast[0].Create_a_forecast_based_on_the__c;
        console.log('sales org----'+this.salesorg)
        this.error = undefined;
    } else if (error) {
        this.error = error;
        console.log('error');
    }
}
get salesagreement() {
    return [
        { label: this.label.Monthly, value: 'Monthly' },
        { label: this.label.Quarterly, value: 'Quarterly' },
        { label: this.label.Yearly, value: 'Yearly' },
        { label: this.label.One_Time, value: 'One-Time' }
    ];
}

handleSalesAgreementChange(event){
    this.SalesAgreement=event.target.value;
    console.log(this.SalesAgreement);
}

get activeforecastmonths() {
    return [
        { label: this.label.January, value: 'January' },
        { label: this.label.Febuary, value: 'February' },
        { label: this.label.March, value: 'March' },
        { label: this.label.April, value: 'April' },
        { label: this.label.May, value: 'May' },
        { label: this.label.June, value: 'June' },
        { label: this.label.July, value: 'July' },
        { label: this.label.August, value: 'August' },
        { label: this.label.September, value: 'September' },
        { label: this.label.October, value: 'October' },
        { label: this.label.November, value: 'November' },
        { label: this.label.December, value: 'December' }
    ];
}

handleActiveForecastMonthChange(event){
    this.ActiveForecastMonth=event.target.value;
    console.log(this.ActiveForecastMonth);
    this.submissionOption1=[];
    this.submissionOption2=[];
    this.submissionOption3=[];
    this.submissionOption4=[];
    this.optioncall=false;
}

get schedulefrequencyallowed() {
    return [
        { label: '1', value: '1' },
        { label: '2', value: '2' },
        { label: '3', value: '3' },
        { label: '4', value: '4' },
        { label: '5', value: '5' },
        { label: '6', value: '6' },
        { label: '7', value: '7' },
        { label: '8', value: '8' },
        { label: '9', value: '9' },
        { label: '10', value: '10' },
        { label: '11', value: '11' },
        { label: '12', value: '12' },
        { label: '13', value: '13' },
        { label: '14', value: '14' },
        { label: '15', value: '15' },
        { label: '16', value: '16' },
        { label: '17', value: '17' },
        { label: '18', value: '18' }
    ];
}

handleScheduleFrequencyAllowedChange(event){
    this.ScheduleFrequencyAllowed=event.target.value;
    console.log(this.ScheduleFrequencyAllowed);
}

get currencyallowed() {
    return[
        { label:'USD', value:'USD'}
    ]
}

handleCurrencyAllowedChange(event){
    this.currency=event.target.value;
    console.log(this.currency);
}

get Option1() {
    console.log('option1');
    if(this.optioncall===false){
    if(this.ActiveForecastMonth==='January' || this.ActiveForecastMonth==='March' || this.ActiveForecastMonth==='May' || this.ActiveForecastMonth==='July' || this.ActiveForecastMonth==='August' || this.ActiveForecastMonth==='October' || this.ActiveForecastMonth==='December'){
       // console.log('month---'+this.ActiveForecastMonth);
        for(var x=1;x<32;x++){
            this.submissionOption1=[...this.submissionOption1,{label:''+x, value:''+x}];    
        }
        console.log(this.submissionOption1);
    }
    if(this.ActiveForecastMonth==='April' || this.ActiveForecastMonth==='June'|| this.ActiveForecastMonth==='September'|| this.ActiveForecastMonth==='November'){
        for(var y=1;y<31;y++){
            this.submissionOption1=[...this.submissionOption1,{label:''+y, value:''+y}];
        }
    }
    if(this.ActiveForecastMonth==='February' ){
        if(((this.year % 4 === 0) && (this.year % 100 !== 0)) || (this.year % 400 === 0)){
            for(var z=1;z<30;z++){
                    this.submissionOption1=[...this.submissionOption1,{label:''+z, value:''+z}];
    
            }
        }else{
            for(var a=1;a<29;a++){
                
                    this.submissionOption1=[...this.submissionOption1,{label:''+a, value:''+a}];
                }
                
            }
        }
    }
    return this.submissionOption1;
    
 
}

get Option2() {
    if(this.optioncall===false){
    if(this.ActiveForecastMonth==='January' || this.ActiveForecastMonth==='March' || this.ActiveForecastMonth==='May' || this.ActiveForecastMonth==='July' || this.ActiveForecastMonth==='August' || this.ActiveForecastMonth==='October' || this.ActiveForecastMonth==='December'){
        console.log(this.ActiveForecastMonth);
        for(var x=1;x<32;x++){
            
                this.submissionOption2=[...this.submissionOption2,{label:''+x, value:''+x}];
            
        }
    }
    if(this.ActiveForecastMonth==='April' || this.ActiveForecastMonth==='June'|| this.ActiveForecastMonth==='September'|| this.ActiveForecastMonth==='November'){
        for(var y=1;y<31;y++){
            
                this.submissionOption2=[...this.submissionOption2,{label:''+y, value:''+y}];
            
        }
    }
    if(this.ActiveForecastMonth==='February' ){
        if(((this.year % 4 === 0) && (this.year % 100 !== 0)) || (this.year % 400 === 0)){
            for(var z=1;z<30;z++){

                    this.submissionOption2=[...this.submissionOption2,{label:''+z, value:''+z}];
                
            }
        }else{
            for(var a=1;a<29;a++){

                    this.submissionOption2=[...this.submissionOption2,{label:''+a, value:''+a}];
                
            }
        }
    }
    }
    return this.submissionOption2;
    
}

get Option3() {
    if(this.optioncall===false){
    if(this.ActiveForecastMonth==='January' || this.ActiveForecastMonth==='March' || this.ActiveForecastMonth==='May' || this.ActiveForecastMonth==='July' || this.ActiveForecastMonth==='August' || this.ActiveForecastMonth==='October' || this.ActiveForecastMonth==='December'){
        console.log(this.ActiveForecastMonth);
        for(var x=1;x<32;x++){

                this.submissionOption3=[...this.submissionOption3,{label:''+x, value:''+x}];
             
        }
    }
    if(this.ActiveForecastMonth==='April' || this.ActiveForecastMonth==='June'|| this.ActiveForecastMonth==='September'|| this.ActiveForecastMonth==='November'){
        for(var y=1;y<31;y++){
        
                this.submissionOption3=[...this.submissionOption3,{label:''+y, value:''+y}];
            
        }
    }
    if(this.ActiveForecastMonth==='February' ){
        if(((this.year % 4 === 0) && (this.year % 100 !== 0)) || (this.year % 400 === 0)){
            for(var z=1;z<30;z++){
        
                    this.submissionOption3=[...this.submissionOption3,{label:''+z, value:''+z}];
                
            }
        }else{
            for(var a=1;a<29;a++){
            
                    this.submissionOption3=[...this.submissionOption3,{label:''+a, value:''+a}];
                
            }
        }
    }
    }
    return this.submissionOption3;
    
}

get Option4() {
    if(this.optioncall===false){
    if(this.ActiveForecastMonth==='January' || this.ActiveForecastMonth==='March' || this.ActiveForecastMonth==='May' || this.ActiveForecastMonth==='July' || this.ActiveForecastMonth==='August' || this.ActiveForecastMonth==='October' || this.ActiveForecastMonth==='December'){
        console.log(this.ActiveForecastMonth);
        for(var x=1;x<32;x++){
            
                this.submissionOption4=[...this.submissionOption4,{label:''+x, value:''+x}];
            
        }
    }
    if(this.ActiveForecastMonth==='April' || this.ActiveForecastMonth==='June'|| this.ActiveForecastMonth==='September'|| this.ActiveForecastMonth==='November'){
        for(var y=1;y<31;y++){
            
                this.submissionOption4=[...this.submissionOption4,{label:''+y, value:''+y}];
            
        }
    }
    if(this.ActiveForecastMonth==='February' ){
        if(((this.year % 4 === 0) && (this.year % 100 !== 0)) || (this.year % 400 === 0)){
            for(var z=1;z<30;z++){
    
                    this.submissionOption4=[...this.submissionOption4,{label:''+z, value:''+z}];
                
            }
        }else{
            for(var a=1;a<29;a++){
                
                    this.submissionOption4=[...this.submissionOption4,{label:''+a, value:''+a}];
                
            }
        }
    }
    }
    return this.submissionOption4;
    
}

handlesfm(event){

    var smf=event.target.value;
    if(smf.includes('.')){
        console.log('349--'+this.disableSave);
        this.disableSave=true;
        this.showToast6();
    }else if(isNaN(smf.replace(',','.'))){
        this.showToast6();
        this.disableSave=true;
    }else if(smf.length>5){
        this.showToast6();
        this.disableSave=true;
    }else{
        this.ConfigurationOnSalesForecastMatrix=event.target.value;
        console.log('360--'+this.disableSave);
    }
    if(parseFloat(this.ConfigurationOnSalesForecastMatrix.replace(',','.'))<=0 || parseFloat(this.ConfigurationOnSalesForecastMatrix.replace(',','.'))>=100){      
        this.disableSave=true;
        this.showToast4();
    }else if(!isNaN(smf.replace(',','.')) && smf.length<=5 && !smf.includes('.')){
        this.disableSave=false;
        console.log('366--'+this.disableSave);
    }
    console.log(this.ConfigurationOnSalesForecastMatrix);
}


handleStartDayOfSubmissionChange(event){
    this.optioncall = true;
    this.StartDayOfSubmission=event.target.value;
    var num1=Number(this.StartDayOfSubmission);
    var num2=Number(this.EndDayOfSubmission);
    if(num1>num2){
        this.showToast2();
        this.disableSave=true;
    }else{
        this.disableSave=false;
    }  
}


handleEndDayOfSubmissionChange(event){
    this.optioncall = true;
    this.EndDayOfSubmission=event.target.value;
    var num1=Number(this.StartDayOfSubmission);
    var num2=Number(this.EndDayOfSubmission);
    if(num1>num2){
        this.showToast2();
        this.disableSave=true;
    }else{
        
        this.disableSave=false;
    }
    console.log(this.EndDayOfSubmission);
}

handleStartDayOfApprovalChange(event){
    this.optioncall = true;
    this.StartDayOfApproval=event.target.value;
    var num1=Number(this.StartDayOfApproval);
    var num2=Number(this.EndDayOfApproval);
    var num3=Number(this.EndDayOfSubmission);
    if(num1>num2){
        this.showToast3();
        this.disableSave=true;
    }else{
        this.disableSave=false;
    }
    if(num1<num3){
        this.disableSave=true;
        this.showToast5();
    }else{
        this.disableSave=false;
    }
    
    console.log(this.StartDayOfApproval);
}

handleEndDayOfApprovalChange(event){
    this.optioncall = true;
    this.EndDayOfApproval=event.target.value;
    var num1=Number(this.StartDayOfApproval);
    var num2=Number(this.EndDayOfApproval);
    if(num1>num2){
        this.showToast3();
        this.disableSave=true;
    }else{
        
        this.disableSave=false;
    }
    
    console.log(this.EndDayOfApproval);
}

handlecheckbox1Change(event){
    this.checkbox1=event.target.checked;
    if(this.checkbox1==false && this.checkbox2==false){
        this.disableSave=true;
    }else{
        this.disableSave=false;
    }
    console.log(this.checkbox1);
}

handlecheckbox2Change(event){
    this.checkbox2=event.target.checked;
    if(this.checkbox1==false && this.checkbox2==false){
        this.disableSave=true;
    }else{
        this.disableSave=false;
    }
    console.log(this.checkbox2);
}


handleSave(){
    console.log('save');
    console.log(this.ConfigurationOnSalesForecastMatrix);
    if(this.checkbox1==false && this.checkbox2==false){
        this.disableSave=true;
    }else{
        updateSalesForecast({sa:this.SalesAgreement,Month :this.ActiveForecastMonth,Frequency :this.ScheduleFrequencyAllowed,C :this.currency,sds:this.StartDayOfSubmission,eds:this.EndDayOfSubmission,sda:this.StartDayOfApproval,eda:this.EndDayOfApproval,sfm:parseFloat(this.ConfigurationOnSalesForecastMatrix.replace(',','.')),cef:this.checkbox1,cf:this.checkbox2})
            .then(result => {
                this.result= result;
                this.showToast1();
                console.log(this.result);
            })
            .catch(error => {
                this.error = error;
            });
    }
    
}

}