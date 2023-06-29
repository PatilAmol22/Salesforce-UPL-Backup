import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getsalesforecastsetting from '@salesforce/apex/MassUploadSalesAgreementController.getsalesforecastsetting';
import readCSVFile from '@salesforce/apex/MassUploadSalesAgreementController.readCSVFile';
//Custom Labels starts here
import Sales_Forecast_Mass_Upload from '@salesforce/label/c.Sales_Forecast_Mass_Upload';
import Period from '@salesforce/label/c.Period';
import Year from '@salesforce/label/c.Year';
import Month from '@salesforce/label/c.Month';
import Download_Draft_Sales_Forecast_Plans from '@salesforce/label/c.Download_Draft_Sales_Forecast_Plans';
import Upload_Draft_Sales_Forecast_Plans from '@salesforce/label/c.Upload_Draft_Sales_Forecast_Plans';
import Download_Complete_Entire_Sales_Forecast_Plans from '@salesforce/label/c.Download_Complete_Entire_Sales_Forecast_Plans';
import click_here from '@salesforce/label/c.click_here';
import Sales_Forecast_Schedule from '@salesforce/label/c.Sales_Forecast_Schedule';
import You_are_uploading_a_Sales_Forecast_Schedule_for from '@salesforce/label/c.You_are_uploading_a_Sales_Forecast_Schedule_for';
import File_Upload_Detail from '@salesforce/label/c.File_Upload_Detail';
import Important_Instructions from '@salesforce/label/c.Important_Instructions';
import File_to_be_uploaded_must_be_in_CSV_format from '@salesforce/label/c.File_to_be_uploaded_must_be_in_CSV_format';
import Please_ensure_to_NOT_include_any_special_characters_alphabets_or_blank_values_i from '@salesforce/label/c.Please_ensure_to_NOT_include_any_special_characters_alphabets_or_blank_values_i';
import Please_keep_only_Update_Id_and_Planned_Quantity_columns_in_the_upload_file from '@salesforce/label/c.Please_keep_only_Update_Id_and_Planned_Quantity_columns_in_the_upload_file';//Label used on html
import Improper_Format from '@salesforce/label/c.Improper_Format';
import Please_keep_only_Update_Id_and_Planned_Quantity_columns from '@salesforce/label/c.Please_keep_only_Update_Id_and_Planned_Quantity_columns';
import Processing_Message from '@salesforce/label/c.Processing_Message';
import Process_started_You_will_recieve_an_email_once_all_records_get_updated_successf from '@salesforce/label/c.Process_started_You_will_recieve_an_email_once_all_records_get_updated_successf';
import Error_Message from '@salesforce/label/c.Error_Message';
import Download from '@salesforce/label/c.Download';
import Downloading_Please_check_Excel_file_in_downloads_folder from '@salesforce/label/c.Downloading_Please_check_Excel_file_in_downloads_folder';
import Cancel from '@salesforce/label/c.Cancel';
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


export default class MassUploadSalesAgreementForecast extends LightningElement {
    
    @track currentYear;
    @track nextYear;      // added By Nik(SKI)...12-12-2022...for next year value...
    @track previousYear;  // added By Nik(SKI)...12-12-2022...for previous year value...
    @track yearVal;       // added By Nik(SKI)...12-12-2022...for current year value...
    @track currentMonth;
    @track currentMonthName;
    @track startDate;
    @track endDate;
    @track showSpinner=false;
    @track isModalOpen=false;

    label = {
        Sales_Forecast_Mass_Upload,
        Period,
        Year,
        Month,
        Download_Draft_Sales_Forecast_Plans,
        Upload_Draft_Sales_Forecast_Plans,
        Download_Complete_Entire_Sales_Forecast_Plans,
        click_here,
        Sales_Forecast_Schedule,
        You_are_uploading_a_Sales_Forecast_Schedule_for,
        File_Upload_Detail,
        Important_Instructions,
        File_to_be_uploaded_must_be_in_CSV_format,
        Please_ensure_to_NOT_include_any_special_characters_alphabets_or_blank_values_i,
        Please_keep_only_Update_Id_and_Planned_Quantity_columns_in_the_upload_file,
        Cancel
    };

    get acceptedFormats() {
        return ['.csv'];
    }
    
    salesAgreementList = [
        {
            Id: 1,
            monthName: 'January',
            month: January,
            download: true,
            upload: true,
        },
        {
            Id: 2,
            monthName: 'February',
            month: Febuary,
            download: true,
            upload: true,
        },
        {
            Id: 3,
            monthName: 'March',
            month: March,
            download: true,
            upload: true,
        },{
            Id: 4,
            monthName: 'April',
            month: April,
            download: true,
            upload: true,
        },
        {
            Id: 5,
            monthName: 'May',
            month: May,
            download: true,
            upload: true,
        },
        {
            Id: 6,
            monthName: 'June',
            month: June,
            download: true,
            upload: true,
        },{
            Id: 7,
            monthName: 'July',
            month: July,
            download: true,
            upload: true,
        },
        {
            Id: 8,
            monthName: 'August',
            month: August,
            download: true,
            upload: true,
        },
        {
            Id: 9,
            monthName: 'September',
            month: September,
            download: true,
            upload: true,
        },{
            Id: 10,
            monthName: 'October',
            month: October,
            download: true,
            upload: true,
        },
        {
            Id: 11,
            monthName: 'November',
            month: November,
            download: true,
            upload: true,
        },
        {
            Id: 12,
            monthName: 'December',
            month: December,
            download: true,
            upload: true,
        }
    ];
    
    connectedCallback(){
        var newDate = new Date(); 
        this.currentYear = newDate.getFullYear().toString();
        this.yearVal = newDate.getFullYear();      // added By Nik(SKI)...12-12-2022...for current year value...
        this.nextYear = newDate.getFullYear() + 1;  // added By Nik(SKI)...12-12-2022...for next year value...
        this.previousYear = newDate.getFullYear() - 1;  // added By Nik(SKI)...12-12-2022...for previous year value...
        console.log('this.currentYear :',this.currentYear);
        getsalesforecastsetting()
        .then(result => {
            this.currentMonth = result[0].Active_Forecast_Month__c;
            this.startDate=result[0].Start_Day_of_Submission__c;
            this.endDate=result[0].End_Day_of_Submission__c;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.currentMonth = undefined;
        });
    } 
    get options() {  // modified by Nik(SKI)...12-12-2022...for next and previous year value....
        return [
            { label: this.previousYear, value: this.previousYear.toString() },
            { label: this.yearVal, value: this.yearVal.toString() },
            { label: this.nextYear, value: this.nextYear.toString() }

        ];
    }

    /* ---------- Start Nik(SKI)..new function added to handle year value---12-12-2022 */
    handleYearChange(event){
        this.currentYear = event.detail.value;
        console.log('yearVal .. - ', this.currentYear);
    }
    /* ------------- End Nik (SKI)----12-12-2022 ------------------------ */

    get salesAgreementList2(){
        for (var i = 0; i < this.salesAgreementList.length; i++) {
            console.log('this.currentMonth :',this.currentMonth);
            if(this.startDate!='' && this.endDate!=''){
                if(this.currentMonth==this.salesAgreementList[i].monthName){
                    this.currentMonthName=this.salesAgreementList[i].month;
                    this.salesAgreementList[i].download=false;
                    this.salesAgreementList[i].upload=false;
                }
            }
        }
        return this.salesAgreementList;
    }

    downloadCSVMethod(){
        var year=this.currentYear;
        //year=year-2000;
        var month=this.currentMonth;
        //month=month.substring(0, 3);
        var singleInvertedComma='\'';
        var name=month+' '+singleInvertedComma+''+year;
        console.log('name :',name);
        let urlString = window.location.href;
        console.log(urlString);
        let baseURL = urlString.substring(0, urlString.indexOf('/lightning/n/Sales_Agreement_Mass_Upload'));
        console.log(baseURL);
        let downloadElement = document.createElement('a');
        //var report_url=baseURL+'/00O1m000000XMjR?pv1='+year+'&pv0='+month+'&export=1&enc=UTF-8&xf=xls&isdtp=p1';//Used in uat
        var report_url=baseURL+'/00O0K00000BOtVx?pv1='+year+'&pv0='+month+'&export=1&enc=UTF-8&xf=xls&isdtp=p1';//Used in production
        console.log('report_url :',report_url);
        downloadElement.href =report_url;
        downloadElement.target = '_self';
        document.body.appendChild(downloadElement);
        downloadElement.click(); 
        console.log('Download');
        let _title=Download;
        let message=Downloading_Please_check_Excel_file_in_downloads_folder;
        let success='Success';
        this.showNotification(_title,message,success);
    }

    downloadCSVWithoutDraftMethod(){
        var year=this.currentYear;
        //year=year-2000;
        var month=this.currentMonth;
        //month=month.substring(0, 3);
        var singleInvertedComma='\'';
        var name=month+' '+singleInvertedComma+''+year;
        console.log('name :',name);
        let urlString = window.location.href;
        console.log(urlString);
        let baseURL = urlString.substring(0, urlString.indexOf('/lightning/n/Sales_Agreement_Mass_Upload'));
        console.log(baseURL);
        let downloadElement = document.createElement('a');
        //var report_url=baseURL+'/00O1m000000YChK?pv1='+year+'&pv0='+month+'&export=1&enc=UTF-8&xf=xls&isdtp=p1';//Used in uat
        var report_url=baseURL+'/00O0K00000BOtVy?pv1='+year+'&pv0='+month+'&export=1&enc=UTF-8&xf=xls&isdtp=p1';//Used in production
        console.log('report_url :',report_url);
        downloadElement.href =report_url;
        downloadElement.target = '_self';
        document.body.appendChild(downloadElement);
        downloadElement.click(); 
        console.log('Download');
        let _title=Download;
        let message=Downloading_Please_check_Excel_file_in_downloads_folder;
        let success='Success';
        this.showNotification(_title,message,success);
    }

    openCSVModal(){
        this.isModalOpen=true;
    }
    closeModal() {
        this.isModalOpen=false;
    }
    handleUploadFinished(event){
        const uploadedFiles = event.detail.files;
        console.log('uploadedFiles :',uploadedFiles);
        //this.showSpinner=true;
        readCSVFile({documentId:uploadedFiles[0].documentId}).then(result => {
            console.log('result : ',result);
            //this.showSpinner=false;
            this.isModalOpen=false;
            if(result==false){
                let _title=Improper_Format;
                let message=Please_keep_only_Update_Id_and_Planned_Quantity_columns;
                let error='Error';
                this.showNotification(_title,message,error);
            }else if(result==true){
                let _title=Processing_Message;
                let message=Process_started_You_will_recieve_an_email_once_all_records_get_updated_successf;
                let success='Success';
                this.showNotification(_title,message,success);
            }
        })
        .catch(error => {
            this.error = error;
            let _title=Error_Message;
            let message=this.error;
            let erMsg='Error';
            this.showNotification(_title,message,erMsg);
            console.log('Error :',error);    
        })
    }
    showNotification(titles,messages,variants) {
        const evt = new ShowToastEvent({
            title: titles,
            message: messages,
            variant: variants
        });
        this.dispatchEvent(evt);
    }
}