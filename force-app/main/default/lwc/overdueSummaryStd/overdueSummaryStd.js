/* eslint-disable vars-on-top */
/* eslint-disable @lwc/lwc/no-async-operation */

import { LightningElement, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import strUserId from '@salesforce/user/Id';
import getODSData from '@salesforce/apex/OverDueSummaryLWC_Controller.getODSData';
import fetchUser from '@salesforce/apex/OverDueSummaryLWC_Controller.fetchUser';
import fetchURL from '@salesforce/apex/OverDueSummaryLWC_Controller.fetchURL';
import fetchSapData from '@salesforce/apex/OverDueSummaryLWC_Controller.fetchSapData';
import dislike from '@salesforce/resourceUrl/dislike';
import like from '@salesforce/resourceUrl/like';
/* Already deployed custom labels */
import Overdue_Summary from '@salesforce/label/c.Overdue_Summary';
import Search from '@salesforce/label/c.Search';
import Status from '@salesforce/label/c.Status';
import Amount from '@salesforce/label/c.Amount'
import Overdue from '@salesforce/label/c.Overdue';
import Due_Date from '@salesforce/label/c.Due_Date';
import Total_Amount from '@salesforce/label/c.Total_Amount';
import Download_as_PDF from '@salesforce/label/c.Download_as_PDF';
import Download_as_CSV from '@salesforce/label/c.Download_as_Excel';
import Toast_Warning from '@salesforce/label/c.Toast_Warning';
import Toast_Info from '@salesforce/label/c.Toast_Info';
import None from '@salesforce/label/c.None';

/*New Custom labels */
import Payment_Terms_Days from '@salesforce/label/c.Payment_Terms_Days';
import Invoice_No from '@salesforce/label/c.Invoice_No';
import Invoice_Date from '@salesforce/label/c.Invoice_Date';
import Billing_Date_From from '@salesforce/label/c.Billing_Date_From';
import Billing_Date_To from '@salesforce/label/c.Billing_Date_To';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';
import Billing_Date_Validation_1 from '@salesforce/label/c.Billing_Date_Validation_1';
import Billing_Date_Validation_2 from '@salesforce/label/c.Billing_Date_Validation_2';
import Search_Overdue from '@salesforce/label/c.Search_Overdue';
import Due from '@salesforce/label/c.Due';
import Not_Due from '@salesforce/label/c.Not_Due';
import Paid from '@salesforce/label/c.Paid';
import Unpaid from '@salesforce/label/c.Unpaid';
import Paid_Unpaid from '@salesforce/label/c.Paid_Unpaid';
import ArrowUp from '@salesforce/resourceUrl/ArrowUp';
import ArrowDown from '@salesforce/resourceUrl/ArrowDown';
//Change by Aashima(Grazitti) APPS-1316
import Grz_SapUserIdError from '@salesforce/label/c.Grz_SapUserIdError';
import Error from '@salesforce/label/c.Error';
import FORM_FACTOR from '@salesforce/client/formFactor';//Added by akhilesh for mobile

export default class OverdueSummary extends LightningElement {
    sortedDirection = 'asc';
    sortedColumn;
    data = [];
    userId=strUserId;
    BillingDateFrom = '';
    BillingDateTo = '';
    Status = '';
    PaidUnpaidStatus = '';
    userAccountId='';
    userCountry='';
    @track showTotalAmount=false;
    @track showPaidUnpaid=false;
    @track showPaymentStatus=false;
    @track showDateFilter=false;
    @track dataLoaded=false;
    @track minDate='';
    @track maxDate='';
    query='';
    @track image1 = dislike ;
    @track image2 = like ;
    @track Up = ArrowUp;
    @track Down = ArrowDown;
    @track src = '';
    @track showColumn1Icon = false;
    @track showColumn2Icon = false;
    @track showColumn3Icon = false;
    @track showColumn4Icon = false;
    @track showColumn5Icon = false;
    @track code = '';
    @api recordSize;//Added by akhilesh w.r.t pagination
    visibleOverdueRecs;//Added by akhilesh w.r.t pagination
    isMobile;
    //Change by Aashima(Grazitti) APPS-1316
    label = {
        Search_Overdue,
        Download_as_PDF,
        Download_as_CSV,
        Billing_Date_From,
        Billing_Date_To,
        Invoice_No,
        Invoice_Date,
        Payment_Terms_Days,
        Total_Amount,
        Overdue_Summary,
        Search,
        Status,
        Amount,      
        Overdue,
        Due_Date,
        Paid,
        Unpaid,
        Paid_Unpaid,
        Grz_SapUserIdError,
        Error
    }
   
    get optionsStatus() {
        return [
            { label: None, value: '' },
            { label: Not_Due, value: Not_Due },
            { label: Due, value: Due },                     
        ];
    }
    get optionsPaidUnpaid() {
        return [
            { label: None, value: '' },
            { label: Paid, value: Paid },
            { label: Unpaid, value: Unpaid },                     
        ];
    }
    @track Overdue_Data;
    @track Overdue_Data_Table;
    @track Overdue_Data_Table_temp;
    @track CustName;
    @track CustCode;
    @track Currency;
    @track TotalAmount=0;
    @track showResult=false;
    @track okValidation = 0;
    @track url= '';

    connectedCallback() {
        //Added by Akhilesh w.r.t. Mobile handling
        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile = false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile = true;
        }
        console.log('this.isMobile ' + this.isMobile);

        fetchUser().then(result => { 
            console.log('result---->',result);
               this.userAccountId=result[0].AccountId;
                if(this.userAccountId==undefined){
                    this.userAccountId='';
                }
                console.log('user Id ----->'+this.userAccountId);
                this.userCountry=result[0].Country;
                console.log('user country ---->'+ this.userCountry)
                if(this.userCountry=='Poland'){
                    this.showTotalAmount=false;
                }else{
                    this.showTotalAmount=true;
                }
                if(this.userCountry=='Poland'){
                    this.code = 'PLN';
                    
                }
                if(this.userCountry=='Spain' ||this.userCountry=='Portugal'){
                    this.code = 'EUR';
                    console.log( 'this is my country----',this.code);
                }
                if(this.userCountry=='Colombia'){
                    this.code = 'COP';
                }
                if(this.userCountry=='Turkey'){
                    this.showDateFilter=false;
                    this.showPaymentStatus = true;
                }else{
                    this.showDateFilter=true;
                    this.showPaidUnpaid=true;
                    //this.dataLoaded=true;
                }
            });
            
        fetchURL().then(result => { 
                console.log('result---->',result);
                   this.url=result[0].URL__c;
                    console.log('url ----->', this.url);
                   
                    if(this.url==undefined){
                        this.url='';
                    }
                    //console.log('url ----->', this.url);
                });

         //Change by Aashima(Grazitti) APPS-1316
        setTimeout(() => { 
            if(this.userCountry=='Turkey' || this.userCountry=='Spain' || this.userCountry=='Poland' || this.userCountry=='Portugal' || this.userCountry=='Colombia'){ 
            fetchSapData().then(result => {
               // console.log('result==>',result[0].Status);
                if(result!=undefined && result[0].Status=='Insufficient data on account'){
                    const evt = new ShowToastEvent({
                        title: this.label.Error,
                        message: this.label.Grz_SapUserIdError,
                        variant: 'error',
                        mode: 'sticky'
                    });
                    this.dispatchEvent(evt);
                } 
                else{
                    console.log('result---->',result); 
                    this.Overdue_Data = result;
                    console.log('length---'+this.Overdue_Data.length);
                    this.Overdue_Data_Table_temp = [];    
                    if(this.Overdue_Data.length>0){
                        this.Overdue_Data.forEach(element => { 
                            this.TotalAmount+=parseFloat(element.Amount);
                            this.Overdue_Data_Table_temp.push({
                                //'Id':element.InvoiceNo + element.DueDate,
                                'DocNumber__c': element.InvoiceNo,
                                //'Billing_Date__c': new Date(element.Billing_Date__c).toLocaleString('en-GB',{day:'numeric',month:'short',year:'numeric'}),
                                'Billing_Date__c': element.InvoiceDate,
                                'Amount__c': parseFloat(element.Amount),
                                // eslint-disable-next-line radix
                                'Payment_Term__c': parseInt(element.Payterm),
                                //'Overdue_Date__c': new Date(element.Overdue_Date__c).toLocaleString('en-GB',{day:'numeric',month:'short',year:'numeric'}),
                                'Overdue_Date__c': element.DueDate,
                                'Status_Formula__c': element.Status,
                                'Paid_Unpaid_Symbol__c' : element.PaidUnpaid,
                                'Paid_Unpaid_Status__c' : element.PaidUnpaid===this.label.Paid?true:false,      
                                'PaymentStatus__c' : element.PaidUnpaid===this.label.Paid?true:false,
                            });
                           
                        });
                    }
                        this.Overdue_Data_Table = this.Overdue_Data_Table_temp; 
                        this.dataLoaded=true;
                        if(this.Overdue_Data_Table.length>0){
                            this.showResult=true;
                        }else{
                            this.showResult = false;
                            this.showErrorToast3();
                        }
                }
                
            });  
        
            }          
        }, 1000);
        
    }

/*---------------- All event handlers----------------- */
handleBDFromChange(event){
    this.BillingDateFrom=event.target.value;
    //Change by Aashima(Grazitti) APPS-1316
    if(this.BillingDateFrom==null){
        this.BillingDateFrom='';
    }
    console.log(this.BillingDateFrom);
}

handleBDToChange(event){
    this.BillingDateTo=event.target.value;
    //Change by Aashima(Grazitti) APPS-1316
    if(this.BillingDateTo==null){
        this.BillingDateTo='';
    }
    console.log(this.BillingDateTo);
}

    handleStatusChange(event){
        this.Status=event.target.value;
        console.log(this.Status);
    }

    handlePaidUnpaidChange(event){
        this.PaidUnpaidStatus=event.target.value;
        console.log(this.PaidUnpaidStatus);
    }

    
/*---------------- function to get records data----------------- */
    getData(){
        getODSData({
            query: this.query,
            uId:this.userAccountId,
        }).then(result => {
            this.Overdue_Data = result;
            console.log('DATA-->',this.Overdue_Data);
            this.Overdue_Data_Table=this.Overdue_Data.ctList;
            console.log('data table '+this.Overdue_Data_Table);
            console.log('Search result-->',this.Overdue_Data_Table.length);         
            this.Overdue_Data_Table_temp = []; 
                if(this.userCountry!='Poland'){     
                    this.Overdue_Data_Table.forEach(element => {     
                        this.Overdue_Data_Table_temp.push({
                            'Id': element.Id,
                            'DocNumber__c': element.DocNumber__c,
                            //'Billing_Date__c': new Date(element.Billing_Date__c).toLocaleString('en-GB',{day:'numeric',month:'short',year:'numeric'}),
                            'Billing_Date__c': element.Billing_Date__c,
                            'Amount__c': parseFloat(element.Amount__c),
                            // eslint-disable-next-line radix
                            'Payment_Term__c': parseInt(element.Payment_Term__c),
                            //'Overdue_Date__c': new Date(element.Overdue_Date__c).toLocaleString('en-GB',{day:'numeric',month:'short',year:'numeric'}),
                            'Overdue_Date__c': element.Overdue_Date__c,
                            'Status_Formula__c': element.Status_Formula__c,
                            'Paid_Unpaid_Symbol__c' : element.Paid_Unpaid_Symbol__c
                        });
                    });
                    this.Overdue_Data_Table = this.Overdue_Data_Table_temp;
                }else{

                    this.Overdue_Data_Table.forEach(element => {
                        this.Overdue_Data_Table_temp.push({
                            'Id': element.Id,
                            'DocNumber__c': element.DocNumber__c,
                            //'Billing_Date__c': new Date(element.Billing_Date__c).toLocaleString('pl-PL',{day:'numeric',month:'short',year:'numeric'}),
                            'Billing_Date__c': element.Billing_Date__c,
                            'Amount__c': element.Amount__c,
                            'Payment_Term__c': element.Payment_Term__c,
                            //'Overdue_Date__c': new Date(element.Overdue_Date__c).toLocaleString('pl-PL',{day:'numeric',month:'short',year:'numeric'}),
                            'Overdue_Date__c': element.Overdue_Date__c,
                            'Status_Formula__c': element.Status_Formula__c,
                            'Paid_Unpaid_Symbol__c' : element.Paid_Unpaid_Symbol__c
                        });
                    });
                    this.Overdue_Data_Table = this.Overdue_Data_Table_temp;
                }
            if(this.Overdue_Data_Table.length != 0 ){
                this.showResult = true;
            }
            else{
                this.showResult = false;
                this.showErrorToast3();
            }
            this.CustName=this.Overdue_Data.mCustomerName;
            this.CustCode=this.Overdue_Data.mCustomerCode;
            this.Currency=this.Overdue_Data.mCurrency;
            this.TotalAmount=this.Overdue_Data.TotalAmount;
            console.log(this.CustName);
            console.log(this.CustCode);
            console.log(this.Currency);
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.Overdue_Data = undefined;
        });
    }


    handleSearch(){ 
        this.TotalAmount = 0;
        //Change by Aashima(Grazitti) APPS-1316
        if(this.userCountry=='Turkey' || this.userCountry=='Spain' || this.userCountry=='Poland' || this.userCountry=='Portugal' || this.userCountry=='Colombia'){
            var filter='';     
            if(this.BillingDateFrom){
                filter={ "BillingDateFrom" : this.BillingDateFrom };
            }
            //Change by Aashima(Grazitti) APPS-1316
            if(this.BillingDateTo){
                filter={ ...filter,"BillingDateTo" : this.BillingDateTo };
            } 
            if(this.Status){
                filter={ ...filter,"Status" : this.Status };
            }
            if(this.PaidUnpaidStatus){
                filter={ ...filter,"PaidUnpaidStatus" : this.PaidUnpaidStatus };
            }
            console.log(filter);
            
            if(this.Overdue_Data_Table_temp.length>0){
                this.Overdue_Data_Table=this.Overdue_Data_Table_temp.filter( order => 
                    Object.keys(filter).every(key => {
                        if(key==='Status'){
                            if(order.Status_Formula__c === filter[key]){
                                return true;
                            }
                        }
                        if(key==='PaidUnpaidStatus'){
                            if(order.Paid_Unpaid_Symbol__c === filter[key]){
                                return true;
                            }
                        }
                        if(key==='BillingDateFrom'){
                            if(order.Billing_Date__c >= filter[key]){
                                return true;
                            }
                        }
                        if(key==='BillingDateTo'){
                            if(order.Billing_Date__c <= filter[key]){
                                return true;
                            }
                        }    
                    })
                ); 
                if(this.Overdue_Data_Table.length != 0 ){
                    this.showResult = true;
                    this.Overdue_Data_Table.forEach(element => {     
                        this.TotalAmount+=parseFloat(element.Amount__c);
                        console.log(this.TotalAmount);
                    });
                }
                else{
                this.showResult = false;
                this.showErrorToast3();
                }
            }else{
                console.log('---');
                this.showResult = false;
                this.showErrorToast3();
            }
            console.log('this.Overdue_Data_Table==>handlesearch==>',this.Overdue_Data_Table);
        }else{  
        this.query = 'SELECT Billing_Date__c, Paid_Unpaid_Symbol__c ,DocNumber__c, Clearing_doc__c, Amount__c, Payment_Term__c, Overdue_Date__c, Status_Formula__c FROM CustomerTransaction__c ';
        var filter = '';
        this.okValidation=0;
       if((this.BillingDateFrom!='' && this.BillingDateFrom!=null)&&(this.BillingDateTo!='' && this.BillingDateTo!=null)){
         if(this.BillingDateTo>=this.BillingDateFrom){
           this.okValidation=0;
           if(filter==''){
               if(this.userCountry=='Spain' || this.userCountry=='Portugal'){
                filter+=' WHERE (DocType__c != \'BR\' AND DocType__c != \'ZT\') AND Billing_Date__c >= '+this.BillingDateFrom+' AND Billing_Date__c <= '+this.BillingDateTo;
               }
               else if(this.userCountry=='Colombia'){
                filter+=' WHERE DocType__c != \'BR\' AND Billing_Date__c >= '+this.BillingDateFrom+' AND Billing_Date__c <= '+this.BillingDateTo;
               }
               else{
                filter+=' WHERE DocType__c != \'DG\' AND Billing_Date__c >= '+this.BillingDateFrom+' AND Billing_Date__c <= '+this.BillingDateTo;             
               }
            this.query+=filter;
             console.log(this.query);
           }
         }
         else{
             this.showErrorToast2();
             this.okValidation++;
         }
       }
       else{
        this.showErrorToast1();
        this.okValidation++;
       }
       if(this.Status!='' && this.Status!=null){
        if(filter==''){
            filter=' WHERE Status_Formula__c=\''+this.Status+'\'';
            this.query+=filter;
            console.log(this.query);
        }else{
            filter=' AND Status_Formula__c=\''+this.Status+'\'';
            this.query+=filter;
            console.log(this.query);
        }
        
    }
    if(this.PaidUnpaidStatus!='' && this.PaidUnpaidStatus!=null){
        if(filter==''){
            filter=' WHERE Payment_Status__c=\''+this.PaidUnpaidStatus+'\'';
            this.query+=filter;
            console.log(this.query);
        }else{
            filter=' AND Payment_Status__c=\''+this.PaidUnpaidStatus+'\'';
            this.query+=filter;
            console.log(this.query);
        }
    }
    if(filter==''){
        this.query+=' WHERE Customer__c='+'\''+this.userAccountId+'\'';
       }
       else{
       this.query+=' AND Customer__c='+'\''+this.userAccountId+'\'';
       }
       if(this.okValidation==0){
        console.log('final query--->'+this.query);
        this.query+=' Order By Billing_Date__c asc';
        this.getData();
       }
    }
    }


    /*get showDownload(){
        if(this.totalrecords===undefined || this.totalrecords === 0){
            return true;
           }
    }*/


    downloadPDFFile() {   
        console.log('this.url--------'+this.url);
        window.open(this.url+'/apex/InvoicePaymentDueReport?DateFrom='+this.BillingDateFrom+'&DateTo='+this.BillingDateTo+'&AccId='+this.userAccountId+'&Status='+this.Status+'&PaymentStatus='+this.PaidUnpaidStatus+'&FileType=PDF');
    }
    downloadCSVFile() {  
        console.log('this.url--------'+this.url);
        window.open(this.url+'/apex/InvoicePaymentDueReportExcel?DateFrom='+this.BillingDateFrom+'&DateTo='+this.BillingDateTo+'&AccId='+this.userAccountId+'&Status='+this.Status+'&PaymentStatus='+this.PaidUnpaidStatus+'&FileType=Excel');
    }

    //Change by Aashima(Grazitti) APPS-1316
    showErrorToast1() {
        const evt = new ShowToastEvent({
            title: Toast_Warning,
            message: Billing_Date_Validation_2,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showErrorToast2() {
        const evt = new ShowToastEvent({
            title: Toast_Warning,
            message: Billing_Date_Validation_2,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

        showErrorToast3() {
        const evt = new ShowToastEvent({
            title: Toast_Info,
            message: No_Result_Found,
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    sort(e) {
console.log('e.currentTarget.dataset.id==>',e.currentTarget.dataset.id);
         if(this.sortedColumn === e.currentTarget.dataset.id){
             this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
         }else{
             this.sortedDirection = 'asc';
         }

        
         let isReverse = this.sortedDirection === 'asc' ? 1 : -1;
         console.log('this.Overdue_Data_Table-==>before==>',this.Overdue_Data_Table);
         this.Overdue_Data_Table = JSON.parse( JSON.stringify( this.Overdue_Data_Table ) ).sort( ( a, b ) => {
            a = a[ e.currentTarget.dataset.id ] ? a[ e.currentTarget.dataset.id ] : ''; // Handle null values
            b = b[ e.currentTarget.dataset.id ] ? b[ e.currentTarget.dataset.id ] : '';
            this.sortedColumn = e.currentTarget.dataset.id;
            return isReverse * ((a > b) - (b > a));  
         });
         console.log('this.Overdue_Data_Table-==>after==>',this.Overdue_Data_Table);

        console.log('Up---'+this.Up);
        console.log('Down---'+this.Down);
        if(e.currentTarget.dataset.id){

            if(e.currentTarget.dataset.id === 'DocNumber__c'){
                this.showColumn1Icon = true;
                this.showColumn2Icon = false;
                this.showColumn3Icon = false;
                this.showColumn4Icon = false;
                this.showColumn5Icon = false;
            }
            if(e.currentTarget.dataset.id === 'Billing_Date__c'){
                this.showColumn1Icon = false;
                this.showColumn2Icon = true;
                this.showColumn3Icon = false;
                this.showColumn4Icon = false;
                this.showColumn5Icon = false;
            }
            if(e.currentTarget.dataset.id === 'Amount__c'){
                this.showColumn1Icon = false;
                this.showColumn2Icon = false;
                this.showColumn3Icon = true;
                this.showColumn4Icon = false;
                this.showColumn5Icon = false;
            }
            if(e.currentTarget.dataset.id === 'Payment_Term__c'){
                this.showColumn1Icon = false;
                this.showColumn2Icon = false;
                this.showColumn3Icon = false;
                this.showColumn4Icon = true;
                this.showColumn5Icon = false;
            }
            if(e.currentTarget.dataset.id === 'Overdue_Date__c'){
                this.showColumn1Icon = false;
                this.showColumn2Icon = false;
                this.showColumn3Icon = false;
                this.showColumn4Icon = false;
                this.showColumn5Icon = true;
            }
            if(this.sortedDirection === 'asc'){this.src=this.Up;}
            if(this.sortedDirection === 'desc'){this.src=this.Down;}

        }
        console.log('----end---');
    }   

    //Added By Akhilesh w.r.t to pagination
    changeHandler2(event){
        const det = event.detail;
        recordSize = det;
    }
    updateOverdueHandler(event){
        this.visibleOverdueRecs=[...event.detail.records]
        console.log('records :'+json.Stringify(event.detail.records))
    }

}