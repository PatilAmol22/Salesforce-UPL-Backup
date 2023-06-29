import { LightningElement,track,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getActiveMonth from '@salesforce/apex/SalesForeCastController.getActiveMonth';
//import getYearOptions from '@salesforce/apex/SalesForeCastController.getYearOptions';
import getReportID from '@salesforce/apex/SalesForeCastController.getReportID';
import callForecastBatch from '@salesforce/apex/SalesForeCastController.callForecastBatch';
import callForecastDeleteBatch from '@salesforce/apex/SalesForeCastController.callForecastDeleteBatch';
import PleaseWait from '@salesforce/label/c.Please_wait';
import Year from '@salesforce/label/c.Year';
import Month from '@salesforce/label/c.Month';
import SelectYear from '@salesforce/label/c.Select_Year';
import Detail from '@salesforce/label/c.Year_Detail';
import GenerateSalesForecast from '@salesforce/label/c.Generate_Sales_Forecast';
import DownloadEntireForecast from '@salesforce/label/c.Download_Entire_Forecast';
import MonitorForecast from '@salesforce/label/c.Monitor_Forecast';
import ClickHere from '@salesforce/label/c.click_here';
import Close from '@salesforce/label/c.Close';
import Cancel from '@salesforce/label/c.Cancel';
import Ok from '@salesforce/label/c.Ok';
import Alert from '@salesforce/label/c.Alert';
import WanCreateSalesForecast from '@salesforce/label/c.Are_you_sure_Do_You_want_to_create_Sales_Forecast';
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
import Period from '@salesforce/label/c.Period';
import ErrorT from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Warning from '@salesforce/label/c.Warning';
import FailToCreateRecord from '@salesforce/label/c.Failed_To_Create_Record';
import ProcessInitiated from '@salesforce/label/c.Process_Has_Been_Initiated';
import ProcessInitiatedForDelete from '@salesforce/label/c.Process_Has_Been_Initiated_for_delete';
import MonthNotSelected from '@salesforce/label/c.Month_not_selected';
import None from '@salesforce/label/c.None';
import FailedToGetYearOptions from '@salesforce/label/c.Failed_To_Get_Year_Options';
import ReportNotFound from '@salesforce/label/c.CSV_Report_Not_Found';
import ActionInProcess from '@salesforce/label/c.Action_Taken_is_already_in_Process';
import {NavigationMixin} from 'lightning/navigation'; 
import WanDeleteSalesForecast from '@salesforce/label/c.Are_you_sure_Do_You_want_to_Delete_Sales_Forecast';
import DeleteForecast from '@salesforce/label/c.Delete_Forecast';

export default class SalesForecast extends NavigationMixin(LightningElement) {

    @track yearVal = new Date().getFullYear();
    @track monthVal;
    @track monthName;
    @track isModalOpen = false;
    @track showSpinner = false;
    @track options = [];
    @track isJanDisable = true;
    @track isFebDisable = true;
    @track isMarDisable = true;
    @track isAprDisable = true;
    @track isMayDisable = true;
    @track isJunDisable = true;
    @track isJulDisable = true;
    @track isAugDisable = true;
    @track isSepDisable = true;
    @track isOctDisable = true;
    @track isNovDisable = true;
    @track isDecDisable = true;
    @track reportId;
    @track isDeleteOpen = false;
    
    label = {
        PleaseWait,
        Period,
        Year,
        Month,
        SelectYear,
        Detail,
        GenerateSalesForecast,
        DownloadEntireForecast,
        MonitorForecast,
        ClickHere,
        Close,
        Cancel,
        Ok,
        Alert,
        WanCreateSalesForecast,
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
        December,
        ErrorT,
        Success,
        Warning,
        FailToCreateRecord,
        ProcessInitiated,
        MonthNotSelected,
        None,
        FailedToGetYearOptions,
        ReportNotFound,
        ActionInProcess,
        WanDeleteSalesForecast,
        DeleteForecast,
        ProcessInitiatedForDelete
    };

    
    /* ------ Start Nik(SKI)...changes made to the function to add previous and next yrar value..18-10-2022 ----------*/
    setYearOptions(){
        this.yearVal = this.yearVal.toString();
        var nextYr = new Date().getFullYear()+1;
        var prevYr = new Date().getFullYear()-1;
        this.options = [];
        const option1 = {
            label: prevYr,
            value: prevYr.toString()
        };
        const option2 = {
            label: this.yearVal,
            value: this.yearVal.toString()
        };
        const option3 = {
            label: nextYr,
            value: nextYr.toString()
        };
        this.options.push(option1);
        this.options.push(option2);
        this.options.push(option3);
        
    }
    /* -------------------- End Nik(SKI)---18-10-2022 -------------------------------------------------- */
    fetchReportId(){
        getReportID()                     
        .then(result => { 
            console.log('getReportID result.length - ', result.length);
            console.log('result - ', result);
             
            if(result.length>0){              
                this.reportId = result;
            }
            else{
                this.showToastmessage(ErrorT,ReportNotFound,'Error');
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

    fetchActiveMonth(){
        getActiveMonth() 
        .then(result => { 
            if(result.length>0){
                if(result == 'January'){
                    this.isJanDisable = false;
                    this.monthName = 'January';
                }
                else if(result == 'February'){
                    this.isFebDisable = false;
                    this.monthName = 'February';
                }
                else if(result == 'March'){
                    this.isMarDisable = false;
                    this.monthName = 'March';
                }
                else if(result == 'April'){
                    this.isAprDisable = false;
                    this.monthName = 'April';
                }
                else if(result == 'May'){
                    this.isMayDisable = false;
                    this.monthName = 'May';
                }
                else if(result == 'June'){
                    this.isJunDisable = false;
                    this.monthName = 'June';
                }
                else if(result == 'July'){
                    this.isJulDisable = false;
                    this.monthName = 'July';
                }
                else if(result == 'August'){
                    this.isAugDisable = false;
                    this.monthName = 'August';
                }
                else if(result == 'September'){
                    this.isSepDisable = false;
                    this.monthName = 'September';
                }
                else if(result == 'October'){
                    this.isOctDisable = false;
                    this.monthName = 'October';
                }
                else if(result == 'November'){
                    this.isNovDisable = false;
                    this.monthName = 'November';
                }
                else if(result == 'December'){
                    this.isDecDisable = false;
                    this.monthName = 'December';
                }
                
            }
            else{
                
            }
        })
        .catch(error => {
            console.log('js method catch getActiveMonth ');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })
    }
    
    /* constructor() {
        super();
        console.log('Constructor called in Child');
    } */

    resetData(){
        this.yearVal = new Date().getFullYear();
        this.monthVal;
        this.monthName;
        this.isModalOpen = false;
        this.showSpinner = false;
        this.options = [];
        this.isJanDisable = true;
        this.isFebDisable = true;
        this.isMarDisable = true;
        this.isAprDisable = true;
        this.isMayDisable = true;
        this.isJunDisable = true;
        this.isJulDisable = true;
        this.isAugDisable = true;
        this.isSepDisable = true;
        this.isOctDisable = true;
        this.isNovDisable = true;
        this.isDecDisable = true;
        this.reportId = '';
    }

    @api
    run(){                             // ** work like connectedcallback. called on tab click of parent component.....
        console.log('run called in Child');
       // eval("$A.get('e.force:refreshView').fire();");
        this.resetData();

        this.showSpinner = true;
        this.setYearOptions();
        this.fetchReportId();
        this.fetchActiveMonth();  
        this.showSpinner = false;
    }

    

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.isDeleteOpen = false;
        this.monthVal = '';
    }

    showToastmessage(title,message,varient){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    }

    handleYearChange(event){
        this.yearVal = event.detail.value;
        console.log('yearVal .. - ', this.yearVal);
    }

    handleSFGClick(event){
        
        this.monthVal = event.target.value;
        console.log('yearVal .. - ', this.yearVal);
        console.log('this.monthVal .. - ', this.monthVal);

        if(this.yearVal == '' || this.yearVal == null){
            this.showToastmessage(ErrorT,SelectYear,'error');
        }
        else{
            this.isModalOpen = true;
        }
    }

    createSF(event){
        console.log('yearVal1 .. - ', this.yearVal);
        console.log('this.monthVal1 .. - ', this.monthVal);
        this.isModalOpen = false;
        if(this.yearVal == '' || this.yearVal == null){
            this.showToastmessage(ErrorT,SelectYear,'error');
        }
        else if(this.monthVal == '' || this.monthVal == null){
            this.showToastmessage(ErrorT,MonthNotSelected,'error');
        }
        else{
            callForecastBatch({month : this.monthVal, year : this.yearVal})
            .then(result => {
                console.log('callForecastBatch result', result);
                if(result.length>0){
                    if(result == 'Initiated'){
                        this.showToastmessage(Success,ProcessInitiated,'Success');
                    }
                    else{
                        this.showToastmessage(Success,ActionInProcess,'Warning');
                    }
                }
                
                    
            })
            .catch(error => {
                console.log('callForecastBatch js method catch');
                this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
            })
        }
    }

    downloadSFCSV(){
        console.log('downloadSFCSV....');
        if(this.reportId.length == 0){
            this.showToastmessage(ErrorT,ReportNotFound,'Error');
        }
        else{
        
            let urlString = window.location.href;
            console.log(urlString);
            let baseURL = urlString.substring(0, urlString.indexOf('/lightning/n/Forecast_Admin_Panel'));
            console.log(baseURL);
            let downloadElement = document.createElement('a');
            var report_url=baseURL+'/'+this.reportId+'?pv0='+this.monthName+'&pv1='+this.yearVal+'&export=1&enc=UTF-8&xf=xls&isdtp=p1';
            console.log('report_url :',report_url);
            downloadElement.href =report_url;
            downloadElement.target = '_self';
            document.body.appendChild(downloadElement);
            downloadElement.click(); 
            console.log('Download');
        }
    }

    handleCallComponent(event){
        var compDetails = {
            componentDef: "c:monitoringForecastUploadedData",
            attributes: {
                month:event.target.dataset.monthname,
                year:this.yearVal
            }
        };
        var encodedCompDetails = btoa(JSON.stringify(compDetails));
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDetails
            }
        }).then(url=>{
            window.open(url, "_blank");
        });
    }

    confirmDeleteSF(event){
        console.log('confirmDeleteSF....');
        this.monthVal = event.target.value;
        console.log('yearVal .. - ', this.yearVal);
        console.log('this.monthVal .. - ', this.monthVal);

        if(this.yearVal == '' || this.yearVal == null){
            this.showToastmessage(ErrorT,SelectYear,'error');
        }
        else{
            this.isDeleteOpen = true;
        }
    }

    deleteSF(){
        console.log('deleteSF....');
        this.isDeleteOpen = false;
        if(this.yearVal == '' || this.yearVal == null){
            this.showToastmessage(ErrorT,SelectYear,'error');
        }
        else if(this.monthVal == '' || this.monthVal == null){
            this.showToastmessage(ErrorT,MonthNotSelected,'error');
        }
        else{
            callForecastDeleteBatch({month : this.monthVal, year : this.yearVal})
            .then(result => {
                console.log('callForecastDeleteBatch result', result);
                if(result.length>0){
                    if(result == 'Initiated'){
                        this.showToastmessage(Success,ProcessInitiatedForDelete,'Success');
                    }
                    else{
                        this.showToastmessage(Success,ActionInProcess,'Warning');
                    }
                }
                    
            })
            .catch(error => {
                console.log('callForecastDeleteBatch js method catch');
                this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
            })
        }
    }
}