import { LightningElement, track,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import readCSV from '@salesforce/apex/MassUploadSalesAgreementController.readCSVFile';
import setYear from '@salesforce/apex/SalesAgreementBatch.setYear';
import getAllRecordId from '@salesforce/apex/BudgetUpload_Brazil.getAllRecordId';
import getYearList from '@salesforce/apex/BudgetUpload_Brazil.getYearList';
import getCurrentYear from '@salesforce/apex/BudgetUpload_Brazil.getCurrentYear';
import getDownloadURLForTemplates from '@salesforce/apex/BudgetUpload_Brazil.getDownloadURLForTemplates';
// import getMonthList from '@salesforce/apex/BudgetUpload_Brazil.getMonthList';
// import getCurrentMonth from '@salesforce/apex/BudgetUpload_Brazil.getCurrentMonth';

import Error1 from '@salesforce/label/c.Error';
import Please_check_your_Email from '@salesforce/label/c.Please_check_your_Email';
import Success from '@salesforce/label/c.Success';
import File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P from '@salesforce/label/c.File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P';
import File_to_be_uploaded_must_be_in_CSV_format from '@salesforce/label/c.File_to_be_uploaded_must_be_in_CSV_format';
import Please_follow_the_same_column_sequence_and_column_names_as_given_in_template from '@salesforce/label/c.Please_follow_the_same_column_sequence_and_column_names_as_given_in_template';
import Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value from '@salesforce/label/c.Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value';
import Once_the_file_gets_uploaded_you_will_receive_an_email_notification from '@salesforce/label/c.Once_the_file_gets_uploaded_you_will_receive_an_email_notification';
import Select_Progress from '@salesforce/label/c.Select_Progress';
import Year from '@salesforce/label/c.Year';
import Download_Template from '@salesforce/label/c.Download_Template';
import Budget_Upload_Detail from '@salesforce/label/c.Budget_Upload_Detail';
import Upload_Budget_Data_Here from '@salesforce/label/c.Upload_Budget_Data_Here';
import Instructions_for_uploading_Budget_CSV from '@salesforce/label/c.Instructions_for_uploading_Budget_CSV';
import Sample_Budget_XLS_file_template from '@salesforce/label/c.Sample_Budget_XLS_file_template';
import In_the_CSV_file_please_use_numeric_values_for_the_Month_column_Use_values_be from '@salesforce/label/c.In_the_CSV_file_please_use_numeric_values_for_the_Month_column_Use_values_be';
import Blank_zero_0_values_are_not_accepted_for_the_Month_column_in_the_CSV from '@salesforce/label/c.Blank_zero_0_values_are_not_accepted_for_the_Month_column_in_the_CSV';
import Blank_values_are_not_accepted_for_the_Quantity_column_in_the_CSV_Please_use_the from '@salesforce/label/c.Blank_values_are_not_accepted_for_the_Quantity_column_in_the_CSV_Please_use_the';
// import January from '@salesforce/label/c.January';
// import Febuary from '@salesforce/label/c.Febuary';
// import March from '@salesforce/label/c.March';
// import April from '@salesforce/label/c.April';
// import May from '@salesforce/label/c.May';
// import June from '@salesforce/label/c.June';
// import July from '@salesforce/label/c.July';
// import August from '@salesforce/label/c.August';
// import September from '@salesforce/label/c.September';
// import October from '@salesforce/label/c.October';
// import November from '@salesforce/label/c.November';
// import December from '@salesforce/label/c.December';
// import Month from '@salesforce/label/c.Month';
import Improper_Format_Please_follow_the_same_column_sequence_and_column_names_as_give from '@salesforce/label/c.Improper_Format_Please_follow_the_same_column_sequence_and_column_names_as_give';

export default class BudgetUpload extends LightningElement {
    @track budgetData;
    @track allRecId;
    @track recordIdBudget;
    @track YearData=[];
    @track yearValue='';
    @track selectedYearValueCB='';
    // @track MonthData=[];
    //@track value='';
    @track selectedMonthValueCB='';
    //@track s1=true;
    //@track s2=false;
    //@track showUploadBudget=true;
    @track currentYear;
    @api Link;
    @track currentYearString;

    @track labels = {
        Select_Progress:Select_Progress,
        Year:Year,
        File_to_be_uploaded_must_be_in_CSV_format:File_to_be_uploaded_must_be_in_CSV_format,
        Please_follow_the_same_column_sequence_and_column_names_as_given_in_template:Please_follow_the_same_column_sequence_and_column_names_as_given_in_template,
        Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value:Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value,
        Once_the_file_gets_uploaded_you_will_receive_an_email_notification:Once_the_file_gets_uploaded_you_will_receive_an_email_notification,
        Download_Template:Download_Template,
        Error:Error1,
        Please_check_your_Email:Please_check_your_Email,
        Success:Success,
        File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P:File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P,
        Budget_Upload_Detail:Budget_Upload_Detail,
        Upload_Budget_Data_Here:Upload_Budget_Data_Here,
        Instructions_for_uploading_Budget_CSV:Instructions_for_uploading_Budget_CSV,
        Sample_Budget_XLS_file_template:Sample_Budget_XLS_file_template,
        // January:January,
        // Febuary:Febuary,
        // March:March,
        // April:April,
        // May:May,
        // June:June,
        // July:July,
        // August:August,
        // September:September,
        // October:October,
        // November:November,
        // December:December,
        // Month:Month,
        Improper_Format_Please_follow_the_same_column_sequence_and_column_names_as_give:Improper_Format_Please_follow_the_same_column_sequence_and_column_names_as_give,
        In_the_CSV_file_please_use_numeric_values_for_the_Month_column_Use_values_be:In_the_CSV_file_please_use_numeric_values_for_the_Month_column_Use_values_be,
        Blank_zero_0_values_are_not_accepted_for_the_Month_column_in_the_CSV:Blank_zero_0_values_are_not_accepted_for_the_Month_column_in_the_CSV,
        Blank_values_are_not_accepted_for_the_Quantity_column_in_the_CSV_Please_use_the:Blank_values_are_not_accepted_for_the_Quantity_column_in_the_CSV_Please_use_the,
    
    }
    

    get acceptedFormats() {
        return ['.csv'];
    }

    /*get options() {
        return [
            { label: this.labels.January, value: '1' },
            { label: this.labels.Febuary, value: '2' },
            { label: this.labels.March, value: '3' },
            { label: this.labels.April, value: '4' },
            { label: this.labels.May, value: '5' },
            { label: this.labels.June, value: '6' },
            { label: this.labels.July, value: '7' },
            { label: this.labels.August, value: '8' },
            { label: this.labels.September, value: '9' },
            { label: this.labels.October, value: '10' },
            { label: this.labels.November, value: '11' },
            { label: this.labels.December, value: '12' },

        ];
    }*/

    CurrentYearValue(){
        getCurrentYear().then(result => {
            //console.log('CurrentYearValue<--->Line167');
            this.yearValue=result;
            console.log('Current year--->',result);

        }).catch(error => {
            this.error = error;
            //console.log('Error',error);    
        })
    }
    AllYearList(){
        getYearList().then(result => {
            //console.log('CurrentYearValue<--->Line191');
            this.YearData=result;
            console.log(' year--->',result);

        }).catch(error => {
            this.error = error;
            //console.log('Error',error);    
        })
    }
    /*CurrentMonthValue(){
        getCurrentMonth().then(result => {
            //console.log('CurrentYearValue<--->Line167');
            this.MonthValue=result;
            console.log('Current Month--->',result);

        }).catch(error => {
            this.error = error;
            //console.log('Error',error);    
        })
    }*/
    /*AllMonthList(){
        getMonthList().then(result => {
            //console.log('CurrentYearValue<--->Line191');
            this.MonthData=result;
            console.log(' Months--->',result);

        }).catch(error => {
            this.error = error;
            //console.log('Error',error);    
        })
    }*/
    getRecordIdForAll(){
        getAllRecordId()
        .then(result=>{
            this.allRecId=result;
            console.log('allRecId--',this.allRecId);
            this.recordIdBudget=this.allRecId[0].Id;
            console.log('recordIdBudget--',this.recordIdBudget);
        });
    }
    getDownloadLinksForAll(){
        getDownloadURLForTemplates()
        .then(result=>{
            console.log('Link-->',result);
           this.Link=result[0];
        })
    }
    connectedCallback(){
        console.log(this.yearValue);
        //console.log(this.value);
        //this.resetData();
        this.getRecordIdForAll();
        this.CurrentYearValue();
        this.AllYearList();
        this.getDownloadLinksForAll();
        //this.CurrentMonthValue();
        //this.AllMonthList();
        var today = new Date();
        var cm=new Date(today);
        // var cMonth = (cm.getMonth()+1);
        // var cMonthText=cm.toLocaleString('default', { month: 'long' });
        var cYear = cm.getFullYear();
        this.currentYear = cYear;
        console.log('this.currentYear--',this.currentYear);
        this.currentYearString=this.currentYear.toString();
        this.selectedYearValueCB=this.currentYearString;
        console.log('selectedYearValueCB-->',this.selectedYearValueCB);
        setYear({year:this.selectedYearValueCB}).then(year=>{
        })
    }
    handleContinueEntry() {
        this.template.querySelectorAll('lightning-combobox').forEach(each => {
            each.value = null;

        });
    }
    resetData(){
        this.handleContinueEntry();
        this.budgetData;
        this.allRecId;
        this.recordIdBudget;
        this.YearData=[];
        this.yearValue=null;
        this.selectedYearValueCB='';
        //this.value=null;
        this.selectedMonthValueCB='';
        //this.s1=true;
        //this.s2=false;
        //this.showUploadBudget=true;
        this.currentYear;
        this.currentYearString;
    }
    @api
    run(){                             // ** work like connectedcallback. called on tab click of parent component.....
        console.log('run called in Child');
       // eval("$A.get('e.force:refreshView').fire();");
        this.resetData();
        this.connectedCallback();
    }
    handleChange(event) {
        //console.log(this.selectedYearValueCB.length);
        this.selectedYearValueCB = event.detail.value;
        this.s1=true;
        console.log('selectedYearValueCB-->',this.selectedYearValueCB);
        setYear({year:this.selectedYearValueCB}).then(year=>{
        })
        // this.showUpload();
    }
    /*handleChangeMonth(event){
        this.selectedMonthValueCB = event.detail.value;
        this.s2=true;
        console.log('selectedMonthValueCB-->',this.selectedMonthValueCB);
        this.showUpload();
    }*/
    /*showUpload(){
        if(this.s1==true){
            this.showUploadBudget=false;
            console.log('****',this.showUploadBudget);
        }
    }*/
    handleUploadFinished(event){
        console.log('selectedYearValueCB-->',this.selectedYearValueCB);
        const uploadedFilesPB = event.detail.files;
        console.log('uploadedFilesPB -->',uploadedFilesPB);
        
        readCSV({documentId : uploadedFilesPB[0].documentId})
               .then(result => {
                
                //    console.log('result ===> ',result);
                //    this.budgetData = result;
                //    console.log('budgetData size ===> ',this.budgetData.length);
                   if(!result){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: this.labels.Error1,//'Error',
                            message:this.labels.Please_check_your_Email, //'Please check your Email',
                            variant: 'error',
                        }),
                    );
                  //  this.run();
                   }else{
                   this.dispatchEvent(
                       new ShowToastEvent({
                           title: this.labels.Success,//'Success',
                           message: this.labels.File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P, //'File uploaded successfully Please check your inbox for Data Upload Details of Budget',
                           variant: 'success',
                       }),
                   );
                  // this.run();
                }
                   
               })
               .catch(error => {
                   this.error = error;
                   console.log('Error',error); 
                   this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!',
                        message: this.labels.Improper_Format_Please_follow_the_same_column_sequence_and_column_names_as_give,
                        variant: 'error',
                    }),
                );    
               })
            
               
    }
    
}