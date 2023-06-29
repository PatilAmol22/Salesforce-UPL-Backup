import { LightningElement,track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getsalesforecastsetting from '@salesforce/apex/UpdateSalesAgreementMetricsController.getsalesforecastsetting';
import executeBatch from '@salesforce/apex/UpdateSalesAgreementMetricsController.executeBatch';
//Custom label
import Sales_Agreement_Update_Metrics from '@salesforce/label/c.Sales_Agreement_Update_Metrics';
import Update_Metrics from '@salesforce/label/c.Update_Metrics';
import Are_you_sure_you_want_to_process_it from '@salesforce/label/c.Are_you_sure_you_want_to_process_it';
import Update_Metrics_is_already_in_process from '@salesforce/label/c.Update_Metrics_is_already_in_process';
import Process_just_started_Please_wait_while_it_completes_is_execution from '@salesforce/label/c.Process_just_started_Please_wait_while_it_completes_is_execution';
import Metrics_Updated_Of_Sales_Agreement_Product_Schedule from '@salesforce/label/c.Metrics_Updated_Of_Sales_Agreement_Product_Schedule';
import Updated_Metrics from '@salesforce/label/c.Updated_Metrics';
import Success from '@salesforce/label/c.Success';
import The_record_has_been_updated_successfully from '@salesforce/label/c.The_record_has_been_updated_successfully';
import Period from '@salesforce/label/c.Period';
import click_here from '@salesforce/label/c.click_here';
import Month from '@salesforce/label/c.Month';
import Close from '@salesforce/label/c.Close';
import Error_Message from '@salesforce/label/c.Error_Message';
import Confirm from '@salesforce/label/c.Confirm';
import No from '@salesforce/label/c.No';
import Yes from '@salesforce/label/c.Yes';
import Processing from '@salesforce/label/c.Processing';
import Processing_Message from '@salesforce/label/c.Processing_Message';
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

export default class UpdateSalesAgreementMetrics extends LightningElement {
    
    @track currentYear;
    @track nextYear; // added By Nik(SKI)...18-10-2022...
    @track yearVal = new Date().getFullYear();  // added By Nik(SKI)...18-10-2022...
    @track currentMonth;
    @track currentMonthName;
    @track startDate;
    @track endDate;
    @track showSpinner=false;
    @track isModalOpen=false;
    @track isProcessingModalOpen=false;
    @track isSuretyModalOpen=false;
    
    label = {
        Sales_Agreement_Update_Metrics,
        Update_Metrics,
        Period,
        Month,
        Are_you_sure_you_want_to_process_it,
        Update_Metrics_is_already_in_process,
        Process_just_started_Please_wait_while_it_completes_is_execution,
        Metrics_Updated_Of_Sales_Agreement_Product_Schedule,
        click_here,
        Updated_Metrics,
        Success,
        The_record_has_been_updated_successfully,
        Close,
        Error_Message,
        Confirm,
        No,
        Yes,
        Processing,
        Processing_Message,
        Cancel
    };

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

    @api
    run(){                             // ** work like connectedcallback. called on tab click of parent component.....
        this.setYearOptions();
        getsalesforecastsetting()
        .then(result => {
            console.log('result[0] :',result);
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

    /* connectedCallback(){
        var newDate = new Date(); 
        this.currentYear = newDate.getFullYear();
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
    }  */

    /* get options() {   // commnented by Nik(SKI) on 18-10-2022...
        return [
            { label: this.currentYear, value: this.currentYear},
            { label: this.nextYear, value: this.nextYear}
        ];
    } */
    /* ------ Start Nik(SKI)...new function to add previous and next yrar value..18-10-2022 ----------*/
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

    get salesAgreementList2(){
        console.log('salesAgreementList2 :');
        for (var i = 0; i < this.salesAgreementList.length; i++) {
            console.log('this.currentMonth :',this.currentMonth);
            if(this.startDate!='' && this.endDate!=''){
                if(this.currentMonth==this.salesAgreementList[i].monthName){
                    this.currentMonthName=this.salesAgreementList[i].month;
                    this.salesAgreementList[i].upload=false;
                }
            }
        }
        return this.salesAgreementList;
    }
    /* ---------- Start Nik(SKI)..new function added to handle year value---18-10-2022 */
    handleYearChange(event){
        this.yearVal = event.detail.value;
        console.log('yearVal .. - ', this.yearVal);
    }
    /* ------------- End Nik (SKI)----18-10-2022 ------------------------ */

    closeSuretyModal(){
        this.isSuretyModalOpen=false;
    }
    suretyModalOpen(){
        this.isSuretyModalOpen=true;
    }
    executeBatch(){
        this.isSuretyModalOpen=false;
        var year=this.yearVal;
        var month=this.currentMonth;
        console.log('year: ',year+',month :',month);
        executeBatch({month:month,year:year})
        .then(result => {
            console.log('result :',result);
            if(result=='Processing'){
                console.log('isProcessingModalOpen');
                this.isProcessingModalOpen=true;
            }else{
                let _title=Processing_Message;
                let message=Process_just_started_Please_wait_while_it_completes_is_execution;
                let success='Success';
                this.showNotification(_title,message,success);
            }
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            let _title=Error_Message;
            let message=this.error;
            let erMsg='Error';
            this.showNotification(_title,message,erMsg);
        });
    }

    closeProcessingModal(){
        this.isProcessingModalOpen=false;
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