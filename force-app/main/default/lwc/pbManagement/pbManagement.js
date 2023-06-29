import { LightningElement, track, wire,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import readCSV from '@salesforce/apex/PBUpload_Brazil.readCSVFile';
import activeMonthSalesForecast from '@salesforce/apex/PBUpload_Brazil.activeMonthSalesForecast';
import getAllRecordId from '@salesforce/apex/PBUpload_Brazil.getAllRecordId';
import getYearList from '@salesforce/apex/PBUpload_Brazil.getYearList';
import getCurrentYear from '@salesforce/apex/PBUpload_Brazil.getCurrentYear';
import getReportId from '@salesforce/apex/PBUpload_Brazil.getReportId';
import getDownloadURLForTemplates from '@salesforce/apex/PBUpload_Brazil.getDownloadURLForTemplates';

//import getSetYear from '@salesforce/apex/PBUpload_Brazil.getSetYear';

import Period from '@salesforce/label/c.Period';
import Select_Progress from '@salesforce/label/c.Select_Progress';
import Year from '@salesforce/label/c.Year';
import Year_Detail from '@salesforce/label/c.Year_Detail';
import Month from '@salesforce/label/c.Month';
import Upload_Overwrite from '@salesforce/label/c.Upload_Overwrite';
import Download from '@salesforce/label/c.Download';
import SKUS_NOT_INCLUDED_IN_PRICE_BOOK from '@salesforce/label/c.SKUS_NOT_INCLUDED_IN_PRICE_BOOK';
import click_here from '@salesforce/label/c.click_here';
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
import You_are_uploading_a_Price_book_for from '@salesforce/label/c.You_are_uploading_a_Price_book_for';
import Upload_Price_Book_Data_Here from '@salesforce/label/c.Upload_Price_Book_Data_Here';
import File_Upload_Detail from '@salesforce/label/c.File_Upload_Detail';
import Price_Book_Upload from '@salesforce/label/c.Price_Book_Upload';
import Instructions_for_uploading_Price_Book_CSV from '@salesforce/label/c.Instructions_for_uploading_Price_Book_CSV';
import File_to_be_uploaded_must_be_in_CSV_format from '@salesforce/label/c.File_to_be_uploaded_must_be_in_CSV_format';
import Please_follow_the_same_column_sequence_and_column_names_as_given_in_template from '@salesforce/label/c.Please_follow_the_same_column_sequence_and_column_names_as_given_in_template';
import Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value from '@salesforce/label/c.Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value';
import Once_the_file_gets_uploaded_you_will_receive_an_email_notification from '@salesforce/label/c.Once_the_file_gets_uploaded_you_will_receive_an_email_notification';
import Sample_Price_Book_CSV_file_template from '@salesforce/label/c.Sample_Price_Book_CSV_file_template';
import Download_Template from '@salesforce/label/c.Download_Template';
import Cancel from '@salesforce/label/c.Cancel';
import Close from '@salesforce/label/c.Close';
import Error1 from '@salesforce/label/c.Error';
import Please_check_your_Email from '@salesforce/label/c.Please_check_your_Email';
import Success from '@salesforce/label/c.Success';
import File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P from '@salesforce/label/c.File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P';
import Please_change_the_xls_template_to_csv_while_uploading_the_Price_Book_file from '@salesforce/label/c.Please_change_the_xls_template_to_csv_while_uploading_the_Price_Book_file';
import Upload_In_Progress from '@salesforce/label/c.Upload_In_Progress';

export default class PbManagement extends LightningElement {
    @track isModalOpen = false;
    @track dataPriceBook;
    @track activeMonth;
    @track allReport;
    @track idDownload;
    @track idSku;

    @track disableButton1=true;
    @track disableButton2=true;
    @track disableButton3=true;
    @track disableButton4=true;
    @track disableButton5=true;
    @track disableButton6=true;
    @track disableButton7=true;
    @track disableButton8=true;
    @track disableButton9=true;
    @track disableButton10=true;
    @track disableButton11=true;
    @track disableButton12=true;

    @track disableButton_ds1=true;
    @track disableButton_ds2=true;
    @track disableButton_ds3=true;
    @track disableButton_ds4=true;
    @track disableButton_ds5=true;
    @track disableButton_ds6=true;
    @track disableButton_ds7=true;
    @track disableButton_ds8=true;
    @track disableButton_ds9=true;
    @track disableButton_ds10=true;
    @track disableButton_ds11=true;
    @track disableButton_ds12=true;
    @track currentMonth;
    @track currentMonthText;
    @track currentYear;
    @track currentYearString;
    @track selectedYearValueCB='';//='2021';
    @track showDetails=true;
    @track allRecId;
    @track recordIdPB;
    @track selectedMonth;
    @track YearData=[];
    @track monthNumber;
    @track monthString;
    @track sDate;
    @track eDate;
    @track value='';//='2021';//this.currentYear;
    @api Link;
    @track labels = {
        Period : Period,
        Select_Progress:Select_Progress,
        Year:Year,
        Year_Detail:Year_Detail,
        Month:Month,
        Upload_Overwrite:Upload_Overwrite,
        Download:Download,
        SKUS_NOT_INCLUDED_IN_PRICE_BOOK:SKUS_NOT_INCLUDED_IN_PRICE_BOOK,
        click_here:click_here,
        January:January,
        Febuary:Febuary,
        March:March,
        April:April,
        May:May,
        June:June,
        July:July,
        August:August,
        September:September,
        October:October,
        November:November,
        December:December,
        You_are_uploading_a_Price_book_for:You_are_uploading_a_Price_book_for,
        Upload_Price_Book_Data_Here:Upload_Price_Book_Data_Here,
        File_Upload_Detail:File_Upload_Detail,
        Price_Book_Upload:Price_Book_Upload,
        Instructions_for_uploading_Price_Book_CSV:Instructions_for_uploading_Price_Book_CSV,
        File_to_be_uploaded_must_be_in_CSV_format:File_to_be_uploaded_must_be_in_CSV_format,
        Please_follow_the_same_column_sequence_and_column_names_as_given_in_template:Please_follow_the_same_column_sequence_and_column_names_as_given_in_template,
        Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value:Blank_values_are_not_accepted_for_price_columns_in_the_CSV_Please_use_the_value,
        Once_the_file_gets_uploaded_you_will_receive_an_email_notification:Once_the_file_gets_uploaded_you_will_receive_an_email_notification,
        Sample_Price_Book_CSV_file_template:Sample_Price_Book_CSV_file_template,
        Download_Template:Download_Template,
        Cancel:Cancel,
        Close:Close,
        Error:Error1,
        Please_check_your_Email:Please_check_your_Email,
        Success:Success,
        File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P:File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P,
        Please_change_the_xls_template_to_csv_while_uploading_the_Price_Book_file:Please_change_the_xls_template_to_csv_while_uploading_the_Price_Book_file,
        Upload_In_Progress:Upload_In_Progress
    }
    get acceptedFormats() {
        return ['.csv'];
    }
    
    /*get options() {
        return [
            { label: '2019', value: '2019' },
            { label: '2020', value: '2020' },
            { label: '2021', value: '2021' },
        ];
    }*/
    constructor() {
        super();
        console.log('result---->');
        
    }

    /*@wire(getCurrentYear)
    wiredCurrentYear({data}){
        this.value=data;
    }*/

    CurrentYearValue(){
        getCurrentYear().then(result => {
            console.log('CurrentYearValue<--->Line166');
            this.value=result;
            console.log('Current year--->',result);

        }).catch(error => {
            this.error = error;
            //console.log('Error',error);    
        })
    }

    /*@wire(getSetYear)
    wiredSetYear({data}){
        this.selectedYearValueCB=data;
         console.log('selectedYearValueCB1-->',this.selectedYearValueCB);
    }*/

    /*@wire(getYearList)        // for retriveing calender year
    wiredYearList({data})
    {
        this.YearData=data;
        console.log(' year--->',data);
    }*/

    AllYearList(){
        getYearList().then(result => {
            console.log('CurrentYearValue<--->Line191');
            this.YearData=result;
            console.log(' year--->',result);

        }).catch(error => {
            this.error = error;
            //console.log('Error',error);    
        })
    }
    getDownloadLinksForAll(){
        getDownloadURLForTemplates()
        .then(result=>{
            console.log('Link-->',result);
           this.Link=result[0];
        })
    }
    
    connectedCallback(){
        //console.log('selectedYearValueCB--',selectedYearValueCB);

        this.getRecordIdForAll();
        this.CurrentYearValue();
        this.AllYearList();
        this.getDownloadLinksForAll();
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
        //this.value=this.currentYearString;
        //this.selectedYearValueCB=this.currentYearString;
        // this.currentMonth=cMonth;
        // this.currentMonthText=cMonthText;
        // console.log('Current Month-->',this.currentMonth);
        // console.log('Current Month t-->',this.currentMonthText);
        
        
        getReportId().then(result => { 
            console.log('result---->',result);
            this.allReport=result;
            this.idDownload=this.allReport[0];
            console.log('idDownload---->',this.idDownload);
            this.idSku=this.allReport[1];
            console.log('idSku---->',this.idSku);
               
        }).catch(error => {
            this.error = error;
            //console.log('Error',error);    
        })

        this.showLinks();

    }
    
    showLinks(){
        console.log('ActiveMonth-->',this.activeMonth);
        var nextYear=parseInt(this.currentYear)+1;
        console.log('nextYear-->',nextYear);
        if(this.selectedYearValueCB===this.currentYearString){
            console.log('c1->',this.selectedYearValueCB===this.currentYearString);
            this.tableView();
        }
        if(this.activeMonth==='December' ){
            console.log('c4.1->',this.activeMonth==='December');
            //console.log('c4.1.1->',this.selectedYearValueCB==nextYear);
            if(this.selectedYearValueCB==nextYear){
                console.log('c4->',this.selectedYearValueCB==nextYear);
                this.disableButton1=false;
                this.disableButton2=true;
                this.disableButton3=true;
                this.disableButton4=true;
                this.disableButton5=true;
                this.disableButton6=true;
                this.disableButton7=true;
                this.disableButton8=true;
                this.disableButton9=true;
                this.disableButton10=true;
                this.disableButton11=true;
                this.disableButton12=true;
                this.disableButton_ds1=false;
                this.disableButton_ds2=true;
                this.disableButton_ds3=true;
                this.disableButton_ds4=true;
                this.disableButton_ds5=true;
                this.disableButton_ds6=true;
                this.disableButton_ds7=true;
                this.disableButton_ds8=true;
                this.disableButton_ds9=true;
                this.disableButton_ds10=true;
                this.disableButton_ds11=true;
                this.disableButton_ds12=true;
            }
            if(this.selectedYearValueCB > nextYear){
                console.log('c4.2->',this.selectedYearValueCB > nextYear);
                this.disableButton1=true;
                this.disableButton2=true;
                this.disableButton3=true;
                this.disableButton4=true;
                this.disableButton5=true;
                this.disableButton6=true;
                this.disableButton7=true;
                this.disableButton8=true;
                this.disableButton9=true;
                this.disableButton10=true;
                this.disableButton11=true;
                this.disableButton12=true;
                this.disableButton_ds1=true;
                this.disableButton_ds2=true;
                this.disableButton_ds3=true;
                this.disableButton_ds4=true;
                this.disableButton_ds5=true;
                this.disableButton_ds6=true;
                this.disableButton_ds7=true;
                this.disableButton_ds8=true;
                this.disableButton_ds9=true;
                this.disableButton_ds10=true;
                this.disableButton_ds11=true;
                this.disableButton_ds12=true;
            }
        }
        if(this.selectedYearValueCB < this.currentYearString ){
            console.log('c2->',this.selectedYearValueCB < this.currentYearString);
            this.disableButton1=true;
            this.disableButton2=true;
            this.disableButton3=true;
            this.disableButton4=true;
            this.disableButton5=true;
            this.disableButton6=true;
            this.disableButton7=true;
            this.disableButton8=true;
            this.disableButton9=true;
            this.disableButton10=true;
            this.disableButton11=true;
            this.disableButton12=true;
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=false;
            this.disableButton_ds9=false;
            this.disableButton_ds10=false;
            this.disableButton_ds11=false;
            this.disableButton_ds12=false;
        }
        if(this.activeMonth!='December' ){
            console.log('c3.1->',this.activeMonth!='December');
            if(this.selectedYearValueCB > this.currentYearString ){
                console.log('c3->',this.selectedYearValueCB > this.currentYearString);
                this.disableButton1=true;
                this.disableButton2=true;
                this.disableButton3=true;
                this.disableButton4=true;
                this.disableButton5=true;
                this.disableButton6=true;
                this.disableButton7=true;
                this.disableButton8=true;
                this.disableButton9=true;
                this.disableButton10=true;
                this.disableButton11=true;
                this.disableButton12=true;
                this.disableButton_ds1=true;
                this.disableButton_ds2=true;
                this.disableButton_ds3=true;
                this.disableButton_ds4=true;
                this.disableButton_ds5=true;
                this.disableButton_ds6=true;
                this.disableButton_ds7=true;
                this.disableButton_ds8=true;
                this.disableButton_ds9=true;
                this.disableButton_ds10=true;
                this.disableButton_ds11=true;
                this.disableButton_ds12=true;
            }
        }
    }

    tableView(){
        var c=0;
        activeMonthSalesForecast().then(result => { 
            //console.log('result---->',result);
               this.activeMonth=result;
                console.log('activeMonth ----->',this.activeMonth);
               
                /* UPLOAD/OVERWRITE */
                //console.log('Condition-->',this.selectedYearValueCB===this.currentYearString);

        if(this.activeMonth==='January'){
            c=1;
            var a1=true;
            if(a1==true){
                this.disableButton1=false;
                this.disableButton2=false;
            }else{
                this.disableButton1=true;
                this.disableButton2=true;
            }

        }else if(this.activeMonth==='February'){
            c=2;
            var a2=true;
            if(a2==true){
                this.disableButton2=false;
                this.disableButton3=false;
            }else{
                this.disableButton2=true;
                this.disableButton3=true;
            }
        }else if(this.activeMonth==='March'){
            c=3;
            var a3=true;
            if(a3==true){
                this.disableButton3=false;
                this.disableButton4=false;
            }else{
                this.disableButton3=true;
                this.disableButton4=true;
            }
        }else if(this.activeMonth==='April'){
            c=4;
            var a4=true;
            if(a4==true){
                this.disableButton4=false;
                this.disableButton5=false;
            }else{
                this.disableButton4=true;
                this.disableButton5=true;
            }
        }else if(this.activeMonth==='May'){
            c=5;
            var a5=true;
            if(a5==true){
                this.disableButton5=false;
                this.disableButton6=false;
            }else{
                this.disableButton5=true;
                this.disableButton6=true;
            }
        }else if(this.activeMonth==='June'){
            c=6;
            var a6=true;
            if(a6==true){
                this.disableButton6=false;
                this.disableButton7=false;
            }else{
                this.disableButton6=true;
                this.disableButton7=true;
            }
        }else if(this.activeMonth==='July'){
            c=7;
            var a7=true;
            if(a7==true){
                this.disableButton7=false;
                this.disableButton8=false;
            }else{
                this.disableButton7=true;
                this.disableButton8=true;
            }
        }else if(this.activeMonth==='August'){
            c=8;
            var a8=true;
            if(a8==true){
                this.disableButton8=false;
                this.disableButton9=false;
            }else{
                this.disableButton8=true;
                this.disableButton9=true;
            }
        }else if(this.activeMonth==='September'){
            c=9;
            var a9=true;
            if(a9==true){
                this.disableButton9=false;
                this.disableButton10=false;
            }else{
                this.disableButton9=true;
                this.disableButton10=true;
            }
        }else if(this.activeMonth==='October'){
            c=10;
            var a10=true;
            if(a10==true){
                this.disableButton10=false;
                this.disableButton11=false;
            }else{
                this.disableButton10=true;
                this.disableButton11=true;
            }
        }else if(this.activeMonth==='November'){
            c=11;
            var a11=true;
            if(a11==true){
                this.disableButton11=false;
                this.disableButton12=false;
            }else{
                this.disableButton11=true;
                this.disableButton12=true;
            }
        }else if(this.activeMonth==='December'){
            c=12;
            var a12=true;
            if(a12==true){
                this.disableButton12=false;
                this.disableButton1=true;
            }else{
                this.disableButton12=true;
                //this.disableButton1=true;
            }
        } 
console.log('value of c-->',c);

        if(c==1){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=true;
            this.disableButton_ds4=true;
            this.disableButton_ds5=true;
            this.disableButton_ds6=true;
            this.disableButton_ds7=true;
            this.disableButton_ds8=true;
            this.disableButton_ds9=true;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==2){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=true;
            this.disableButton_ds5=true;
            this.disableButton_ds6=true;
            this.disableButton_ds7=true;
            this.disableButton_ds8=true;
            this.disableButton_ds9=true;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==3){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=true;
            this.disableButton_ds6=true;
            this.disableButton_ds7=true;
            this.disableButton_ds8=true;
            this.disableButton_ds9=true;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==4){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=true;
            this.disableButton_ds7=true;
            this.disableButton_ds8=true;
            this.disableButton_ds9=true;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==5){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=true;
            this.disableButton_ds8=true;
            this.disableButton_ds9=true;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==6){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=true;
            this.disableButton_ds9=true;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==7){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=false;
            this.disableButton_ds9=true;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==8){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=false;
            this.disableButton_ds9=false;
            this.disableButton_ds10=true;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==9){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=false;
            this.disableButton_ds9=false;
            this.disableButton_ds10=false;
            this.disableButton_ds11=true;
            this.disableButton_ds12=true;
        }else if(c==10){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=false;
            this.disableButton_ds9=false;
            this.disableButton_ds10=false;
            this.disableButton_ds11=false;
            this.disableButton_ds12=true;
        }else if(c==11){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=false;
            this.disableButton_ds9=false;
            this.disableButton_ds10=false;
            this.disableButton_ds11=false;
            this.disableButton_ds12=false;
        }else if(c==12){
            this.disableButton_ds1=false;
            this.disableButton_ds2=false;
            this.disableButton_ds3=false;
            this.disableButton_ds4=false;
            this.disableButton_ds5=false;
            this.disableButton_ds6=false;
            this.disableButton_ds7=false;
            this.disableButton_ds8=false;
            this.disableButton_ds9=false;
            this.disableButton_ds10=false;
            this.disableButton_ds11=false;
            this.disableButton_ds12=false;
        }
    
                
            });
    }

    resetData(){
        
        this.isModalOpen = false;
        this.dataPriceBook;
        this.activeMonth;
        this.allReport;
        this.idDownload;
        this.idSku;

        this.disableButton1=true;
        this.disableButton2=true;
        this.disableButton3=true;
        this.disableButton4=true;
        this.disableButton5=true;
        this.disableButton6=true;
        this.disableButton7=true;
        this.disableButton8=true;
        this.disableButton9=true;
        this.disableButton10=true;
        this.disableButton11=true;
        this.disableButton12=true;
    
        this.disableButton_ds1=true;
        this.disableButton_ds2=true;
        this.disableButton_ds3=true;
        this.disableButton_ds4=true;
        this.disableButton_ds5=true;
        this.disableButton_ds6=true;
        this.disableButton_ds7=true;
        this.disableButton_ds8=true;
        this.disableButton_ds9=true;
        this.disableButton_ds10=true;
        this.disableButton_ds11=true;
        this.disableButton_ds12=true;

        this.currentMonth;
        this.currentMonthText;
        this.currentYear;
        this.currentYearString;
        this.selectedYearValueCB='';//='2021';
        this.showDetails=true;
        this.allRecId;
        this.recordIdPB;
        this.selectedMonth;
        this.monthNumber;
        this.monthString;
        this.sDate;
        this.eDate;
        this.YearData=[];
        this.value='';
    }

    @api
    run(){                             // ** work like connectedcallback. called on tab click of parent component.....
        console.log('run called in Child');
       // eval("$A.get('e.force:refreshView').fire();");
        
        this.resetData();

        this.connectedCallback();
        this.showLinks();
        this.tableView();
        
    }

    handleChange(event) {
        //console.log(this.selectedYearValueCB.length);
        this.selectedYearValueCB = event.detail.value;
        console.log('selectedYearValueCB-->',this.selectedYearValueCB);
        this.showLinks();
        //eval("$A.get('e.force:refreshView').fire();");
        //this.connectedCallback();
        //console.log(this.selectedYearValueCB.length);
        /*if(this.selectedYearValueCB.length !=0){
            this.showDetails=true;
        }*/
        
    }
    
    openModal(event) {
        console.log(event.target.value);
        this.selectedMonth=event.target.value;
        console.log('selected month-->',this.selectedMonth);
        const words = this.selectedMonth.split('-');
        console.log(words[1]);
        console.log(words[0]);
        this.monthNumber=words[1];
        //this.monthString=words[0];
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        if(this.monthNumber==='01'){
            this.monthString=this.labels.January;
        }
        if(this.monthNumber==='02'){
            this.monthString=this.labels.Febuary;
        }
        if(this.monthNumber==='03'){
            this.monthString=this.labels.March;
        }
        if(this.monthNumber==='04'){
            this.monthString=this.labels.April;
        }
        if(this.monthNumber==='05'){
            this.monthString=this.labels.May;
        }
        if(this.monthNumber==='06'){
            this.monthString=this.labels.June;
        }
        if(this.monthNumber==='07'){
            this.monthString=this.labels.July;
        }
        if(this.monthNumber==='08'){
            this.monthString=this.labels.August;
        }
        if(this.monthNumber==='09'){
            this.monthString=this.labels.September;
        }
        if(this.monthNumber==='10'){
            this.monthString=this.labels.October;
        }
        if(this.monthNumber==='11'){
            this.monthString=this.labels.November;
        }
        if(this.monthNumber==='12'){
            this.monthString=this.labels.December;
        }
        /*if(this.activeMonth==='December' ){
            if(this.selectedMonth==='January-01'){
                var a=parseInt(this.currentYear)+1;
                console.log(a);
                this.selectedYearValueCB=a;
            }else{
                this.selectedYearValueCB=this.selectedYearValueCB;
            }
            console.log(this.selectedYearValueCB);
        }*/
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.connectedCallback();
    }

    openDownloadReport(event){
        console.log('selectedYearValueCB--',this.selectedYearValueCB);
        var m=event.target.value;
       // var downloadURI='https://upl--uat.lightning.force.com/00O0K00000BOtW8?pv1='+m+'&pv2='+this.selectedYearValueCB+'&csv=1&exp=1&enc=UTF-8&isdtp=p1';https://upl.my.salesforce.com
        var downloadURI='https://upl.my.salesforce.com/'+this.idDownload+'?pv1='+m+'&pv2='+this.selectedYearValueCB+'&export=1&enc=UTF-8&xf=xls&isdtp=p1';
        //var downloadURI='https://upl--uat.lightning.force.com/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId=00O0k000000du0X';
        var res = encodeURI(downloadURI);
        window.open(res);
    }

    openSKUNotIncludedReport(event){
        console.log('selectedYearValueCB--',this.selectedYearValueCB);
        var m=event.target.value;
       // var downloadURI='https://upl--uat.lightning.force.com/00O0K00000BOtW7?pv2='+m+'&pv3='+this.selectedYearValueCB+'&csv=1&exp=1&enc=UTF-8&isdtp=p1';
        var downloadURI='https://upl.my.salesforce.com/'+this.idSku+'?pv3='+m+'&pv4='+this.selectedYearValueCB+'&export=1&enc=UTF-8&xf=xls&isdtp=p1';
        var res = encodeURI(downloadURI);
        window.open(res);
    }
    
    getRecordIdForAll(){
        getAllRecordId()
        .then(result=>{
            this.allRecId=result;
            console.log('allRecId--',this.allRecId);
            this.recordIdPB=this.allRecId[0].Id;
            console.log('recordIdPB--',this.recordIdPB);
        });
    }


    handleUploadFinished(event){
        /*if(this.activeMonth==='December' ){
            if(this.selectedMonth==='January-01'){
                var a=parseInt(this.currentYear)+1;
                console.log(a);
                this.selectedYearValueCB=a;
            }else{
                this.selectedYearValueCB=this.selectedYearValueCB;
            }
            console.log(this.selectedYearValueCB);
        }*/
        const uploadedFilesPB = event.detail.files;
        readCSV({idContentDocument : uploadedFilesPB[0].documentId,Month:this.selectedMonth,Year:this.selectedYearValueCB})
               .then(result => {
                
                   console.log('result ===> '+result);
                   this.dataPriceBook = result;
                   if(this.dataPriceBook.length>0 && this.dataPriceBook[0]==='Upload In Progress'){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: this.labels.Error1,
                            message: this.labels.Upload_In_Progress,
                            variant: 'error',
                        }),
                    );
                   }else if(this.dataPriceBook.length>0 ){        
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: this.labels.Error1,
                            message: this.labels.Please_check_your_Email,
                            variant: 'error',
                        }),
                    ); 
                   }else{
                   this.dispatchEvent(
                       new ShowToastEvent({
                           title: this.labels.Success,
                           message: this.labels.File_uploaded_successfully_Please_check_your_inbox_for_Data_Upload_Details_of_P,
                           variant: 'success',
                       }),
                   );
                }
                   
               })
               .catch(error => {
                   this.error = error;
                   //console.log('Error',error);    
               })
    }

}