import { LightningElement,wire,track} from 'lwc';
import generateData from '@salesforce/apex/EventDataRepresentationIndiaSwal.GetEventData';
import GetFilterData from '@salesforce/apex/EventDataRepresentationIndiaSwal.GetFilterData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
  
 
    { label: 'Manager Name', fieldName: 'ManagerName' },
    { label: ' Manger UGDN', fieldName: ' MangerUGDNNumber' },
    { label: 'Activity start date', fieldName: 'StartDateTime' },
    { label: 'Start Time', fieldName: 'StartTime' },
    { label: 'Activity end date', fieldName: 'EndDateTime' },
    { label: 'End Time', fieldName: 'EndTime' },
    { label: 'Location', fieldName: 'Location__c' },
    { label: 'Meeting Purpose', fieldName: 'Meeting_Purpose__c' },
    { label: 'Expenses', fieldName: 'Expenses__c' },
    { label: 'Meeting Notes', fieldName: 'Meeting_Notes__c'},
    { label: 'Createdby Name', fieldName: 'CreatedbyName' },
    { label: 'Createdby UGDN ', fieldName: 'UGDN_Number__c' },
    { label: 'Subject', fieldName: 'Subject' },
    { label: 'Approval Status', fieldName: 'others__c' },
    { label: 'Activity Status', fieldName: 'Activity_Status__c' },
    { label: 'Owner Name', fieldName: 'OwnerName' },
    { label: 'Createddate', fieldName: 'Createddate' },
    { label: 'Created Time', fieldName: 'CreatedTime' },
    
];
export default class EventDataRepresentation extends LightningElement {
    isLoaded = false;
    data = [];
    ActualData = [];
    columns = columns;EnddateTime
    startDateTimeValue = '';
    StartTime = '';
    EndTime = '';
    currentPage = 1;
    totalPage = 0;
    recordSize = 10;
    enddataTimevalue = '';
    ApprovalStatusvalue = '';
    Createddatevalue = '';
    totalRecords = [];
    columnHeader = ['Manager Name', 'Manger UGDN', 'Activity start date','StartTime','Activity end date','EndTime','Location','Meeting Purpose' ,'Expenses','Meeting Notes', 'Createdby Name','Createdby UGDN','Subject','Approval Status','Activity Status','Owner Name','Createddate','Created Time'];
     
   
   
    get optionsForApprovalStatus() {
        return [
            { label: 'None', value: 'None' },
            { label: 'Approved', value: 'Approved' },
            { label: 'Pending', value: 'Pending' },
            { label: 'Rejected', value: 'Rejected' },   
        ];
    }
    get optionsForCreatedate() {
        return [
            { label: 'This Month', value: 'THIS_MONTH' },
            { label: 'Last Month', value: 'LAST_MONTH' },
        ];
    }
    get disablePrevious(){ 
        return this.currentPage<=1
    }
    get disableNext(){ 
        return this.currentPage>=this.totalPage
    }
    @wire(generateData)
    wiredAccounts({ error, data }) {
        if (data) {
             this.totalRecords = data;
             this.ActualData = data;
            this.recordSize = Number(this.recordSize);
            this.totalPage = Math.ceil(data.length/this.recordSize);
            this.updateRecords();
        } else if (error) {
            console.log(error);
            this.data = error;
        }
    }
    handleChangeStartDateTime(event) {
        console.log('insie the else---1234567');
       this.startDateTimeValue = event.detail.value;
       if( this.enddataTimevalue!='' && this.enddataTimevalue != undefined)
       {
        console.log('insie the if ------again');
        if( this.startDateTimeValue >  this.enddataTimevalue)
        {
 
            const event = new ShowToastEvent({
                title: 'Toast message',
                message: 'Please select start date less than End Date ',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            this.StartTime ='';
        }
        else
        {
            this.StartTime = `${this.startDateTimeValue}T00:00:00`;
            console.log( this.StartTime);
         
        }
       }
       else{
        this.StartTime = `${this.startDateTimeValue}T00:00:00`;
        console.log( this.StartTime);
       }
       
     
     
        
    }

    handleChangeEndDateTime(event)
    {
        this.enddataTimevalue = event.detail.value;
        if( this.startDateTimeValue >  this.enddataTimevalue)
        {

            const event = new ShowToastEvent({
                title: 'Toast message',
                message: 'Please select End Date greater than start date ',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            this.EndTime ='';
        }
        else{

            this.EndTime = `${this.enddataTimevalue}T00:00:00`;
              
        }
     
    }
    handleChangeApprovalStatus(event)
    {
      
       
      
            this.ApprovalStatusvalue = event.detail.value;
        
        
        console.log('  this.ApprovalStatusvalue'+   this.ApprovalStatusvalue);
    }
    handleChangeCreatedate(event)

    {
       
        this.Createddatevalue = event.detail.value;
    }
    handleClickSearchFilter()
    {
        console.log('SDFGHJKSXCVBN-------------------12345');
       
       if((this.startDateTimeValue == undefined || this.startDateTimeValue =='') && (this.enddataTimevalue == ''|| this.enddataTimevalue == undefined) &&(this.ApprovalStatusvalue=='' || this.ApprovalStatusvalue== undefined) )
        {
            console.log('SDFGHJKSXCVBN-------------------1');
           
                const event = new ShowToastEvent({
                    title: 'Toast message',
                    message: 'Please select at least one filter ',
                    variant: 'warning',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            
        }
       else if(( this.startDateTimeValue =='') && (this.EndTime != '') )
         {
            console.log('enddataTimevalue',this.enddataTimevalue);
            const event = new ShowToastEvent({
                title: 'Toast message',
                message: 'Please select Start Date ',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
        else{
            
               
            console.log('SDFGHJKSXCVBN------------------2');
            this.isLoaded = true;
            console.log('inside the handleClickSearchFilter');
            GetFilterData({startDateTimeValue:this.StartTime,enddataTimevalue : this.EndTime,ApprovalStatusvalue: this.ApprovalStatusvalue,Createddatevalue:this.Createddatevalue})
                .then(data =>{
                    this.totalRecords = data;
                    this.isLoaded = false;
                    this.recordSize = Number(this.recordSize);
                    this.totalPage = Math.ceil(data.length/this.recordSize);
                    this.updateRecords();
                    console.log('inside the handleClickSearchFilter---1',this.totalRecords );
                })
                .catch((error) =>{
                    this.data = undefined;
                    console.log('inside the handleClickSearchFilter---2');
                })
        }

       
    }

    previousHandler(){ 
        if(this.currentPage>1){
            this.currentPage = this.currentPage-1;
            this.updateRecords();
        }
    }
    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage+1;
            this.updateRecords();
        }
    }
    updateRecords(){ 
        const start = (this.currentPage-1)*this.recordSize;
        const end = this.recordSize*this.currentPage;
        this.data = this.totalRecords.slice(start, end);
        
    }
    handleClickResetFilter()
    {
        if(this.ActualData!= undefined && this.ActualData!= null)
        {
            this.totalPage = 0;
            this.startDateTimeValue = '';
            this.ApprovalStatusvalue = ''; 
            this.enddataTimevalue = '';
            this.EndTime = '';
            this.StartTime = '';
            this.totalRecords = this.ActualData;
            this.recordSize = Number(this.recordSize);
            this.totalPage = Math.ceil(this.totalRecords.length/this.recordSize);
            this.updateRecords();
        }
       
    }
    exportData(){
       
      
        // Prepare a html table
        let doc = '<table>';
        // Add styles for the table
        doc += '<style>';
        doc += 'table, th, td {';
        doc += '    border: 1px solid black;';
        doc += '    border-collapse: collapse;';
        doc += '}';          
        doc += '</style>';
        // Add all the Table Headers
        doc += '<tr>';
        this.columnHeader.forEach(element => {            
            doc += '<th>'+ element +'</th>'           
        });
        doc += '</tr>';
        // Add the data rows
        this.totalRecords.forEach(record => {
            console.log('record MangerUGDNNumber',record);
           
            doc += '<tr>';
              
                if(record['ManagerName']!= undefined)
                {
                    doc += '<th>'+record.ManagerName+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['MangerUGDNNumber']!= undefined){
                    doc += '<th>'+record.MangerUGDNNumber+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['StartDateTime']!= undefined){
                    doc += '<th>'+record.StartDateTime+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                if(record['StartTime']!= undefined){
                    doc += '<th>'+record.StartTime+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['EndDateTime']!= undefined){
                    doc += '<th>'+record.EndDateTime+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                if(record['EndTime']!= undefined){
                    doc += '<th>'+record.EndTime+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['Location__c']!= undefined){
                    doc += '<th>'+record.Location__c+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['Meeting_Purpose__c']!= undefined){
                    doc += '<th>'+record.Meeting_Purpose__c+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                if(record['Expenses__c']!= undefined){
                    doc += '<th>'+record.Expenses__c+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                } if(record['Meeting_Notes__c']!= undefined){
                    doc += '<th>'+record.Meeting_Notes__c+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['CreatedbyName']!= undefined){
                    doc += '<th>'+record.CreatedbyName+'</th>'; 
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['UGDN_Number__c']!= undefined){
                    doc += '<th>'+record.UGDN_Number__c+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                if(record['Subject']!= undefined){
                    doc += '<th>'+record.Subject+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['others__c']!= undefined){
                    doc += '<th>'+record.others__c+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                 if(record['Activity_Status__c']!= undefined){
                    console.log('inside the Activity_Status__c----1' ,record['Activity_Status__c']);
                    doc += '<th>'+record.Activity_Status__c+'</th>';
                }
                else{
                    console.log('inside the Activity_Status__c----1',record['Activity_Status__c']);
                    doc += '<th>'+' '+'</th>';
                }
                if(record['OwnerName']!= undefined){
                    doc += '<th>'+record.OwnerName+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';CreatedTime
                }
                 if(record['Createddate']!= undefined){
                    doc += '<th>'+record.Createddate+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }
                if(record['Createddate']!= undefined){
                    doc += '<th>'+record.CreatedTime+'</th>';
                }
                else{
                    doc += '<th>'+' '+'</th>';
                }

                doc += '</tr>';
            
            
 
          
          
           
         
        
         
           
         
           
           
           
           

           
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'EventData.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
}