/* eslint-disable no-redeclare */
/* eslint-disable no-unused-vars */
/* eslint-disable no-useless-concat */
/* eslint-disable eqeqeq */
/* eslint-disable vars-on-top */
/* eslint-disable no-console */
import { LightningElement, track, wire } from 'lwc';
import strUserId from '@salesforce/user/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import fetchAL from '@salesforce/apex/AccountLedger.fetchAL';
//import getCountAL from '@salesforce/apex/AccountLedger.getCountAL';
import getALData from '@salesforce/apex/AccountLedger.getALData';
import fetchUser from '@salesforce/apex/AccountLedger.fetchUser';
import fetchComm from '@salesforce/apex/AccountLedger.fetchCommunityObj';
import fetchURL from '@salesforce/apex/AccountLedger.fetchURL';
import LANG from '@salesforce/i18n/lang';
import LOCALE from '@salesforce/i18n/locale';

import Posting_Date_From from '@salesforce/label/c.Posting_Date_From';
import Posting_Date_To from '@salesforce/label/c.Posting_Date_To';
import Opening_Balance_b_f from '@salesforce/label/c.Opening_Balance_b_f';
import Post_Date from '@salesforce/label/c.Post_Date';
import Doc_Type from '@salesforce/label/c.Doc_Type';
import Doc_No from '@salesforce/label/c.Doc_No';
import Reference from '@salesforce/label/c.Reference';
import Doc_Header_Text from '@salesforce/label/c.Doc_Header_Text';
import Debit_Amount from '@salesforce/label/c.Debit_Amount';
import Credit_Amount from '@salesforce/label/c.Credit_Amount';
import Running_Balance from '@salesforce/label/c.Running_Balance';
import Opening_Balance from '@salesforce/label/c.Opening_Balance';
import Debit from '@salesforce/label/c.Debit';
import Credit from '@salesforce/label/c.Credit';
import Closing_Balance from '@salesforce/label/c.Closing_Balance';
import To_Balance_c_f from '@salesforce/label/c.To_Balance_c_f';
import Currency from '@salesforce/label/c.Currency';
import Download from '@salesforce/label/c.Download'; 
import Customer_Name from '@salesforce/label/c.Customer_Name';
import Customer_Code from '@salesforce/label/c.Customer_Code';
import Period_from from '@salesforce/label/c.Period_from';
import Report_Date from '@salesforce/label/c.Report_Date';
import Search from '@salesforce/label/c.Search';
import Download_as_PDF from '@salesforce/label/c.Download_as_PDF';
import Download_as_Excel from '@salesforce/label/c.Download_as_Excel';
import AL_Toast1 from '@salesforce/label/c.AL_Toast';
import AL_Toast2 from '@salesforce/label/c.AL_Toast2';
import Toast_Warning from '@salesforce/label/c.Toast_Warning';
import Toast_Info from '@salesforce/label/c.Toast_Info';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';
import Disclaimer from '@salesforce/label/c.Disclaimer';
import Account_Ledger from '@salesforce/label/c.Account_Ledger';
import Search_Ledger from '@salesforce/label/c.Search_Ledger';
import AL_Toast3 from '@salesforce/label/c.AL_Toast3';
import AL_Toast4 from '@salesforce/label/c.AL_Toast4';
import AL_Toast5 from '@salesforce/label/c.AL_Toast5';
import AL_Toast6 from '@salesforce/label/c.AL_Toast6';
import AL_Toast7 from '@salesforce/label/c.AL_Toast7';
import FORM_FACTOR from '@salesforce/client/formFactor';

//import Download_as_Excel from '@salesforce/label/c.Download_as_Excel';


//import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
//import jQueryUI from '@salesforce/resourceUrl/jQueryLibraryUI_community';
//import jQuery from '@salesforce/resourceUrl/jQueryLibrary_community';

/*const columns1 = [
    { label: 'Post Date', fieldName: 'wPostDate', type: 'date', cellAttributes: { alignment: 'left' }},
    { label: 'Doc Type', fieldName: 'wDocType', type: 'text', cellAttributes: { alignment: 'left' }},
    { label: 'Doc No', fieldName: 'wDocNo', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Reference', fieldName: 'wReference', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Doc Header Text', fieldName: 'wDocHeaderText', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Debit Amount', fieldName: 'wDebitAmount', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Credit Amount', fieldName: 'wCreditAmount', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Running Balance', fieldName: 'wRunningBalance', type: 'text' , cellAttributes: { alignment: 'left' }}
];*/

export default class AccountLedger extends LightningElement {
    data = [];
    //columns1 = columns1;
    //@track record;
    //@track records;
    //@track recordId;
    //@track LineItems;
    @track columns;
    @track searchResult;
    @track showResult = false;
    @track showResult1 = false;
    @track Account_Ledger_Data;
    @track openingBalance;
    @track totalDebit;
    @track totalCredit;
    @track closingBalance;
    @track toBalance;
    @track Account_Ledger_Data_table;
    @track CustName;
    @track CustCode;
    @track Currency;
    @track reportDate;
    @track row;
    @track pagesize;
    @track pageNumber = 1;
    @track currentpage;
    @track totalpages;
    @track totalrecords;
    @track offset=0;
    userAccountId='';
    userId=strUserId;
    PostingDateFrom = '';
    PostingDateTo = '';
    DueDate = '';
    DocType = '';
    @track currentMonth='';
    @track dData;
    @track PostingDateFromHtml = '';
    @track PostingDateToHtml = '';
    @track calendarDate = '';
    @track p_DocType = '';
    query = '';
    @track setValueAR=[];
    @track setValueAR1=[];
    @track dateEmptyError=false;
    //@track dateGreterError=false;
    @track fromDateForPDF_excel;
    @track toDateForPDF_excel;
    @track showRunningBal=false;
    @track hideClass='';
    @track lang='';
    @track locale='';
    @track url='';
    @track date;
 @track m1;
    @track fyd;
    @track country='';

    @track labels = {
        Posting_Date_From:	Posting_Date_From,
        Posting_Date_To:	Posting_Date_To,
        Opening_Balance_b_f:	Opening_Balance_b_f,
        Post_Date:	Post_Date,
        Doc_Type:	Doc_Type,
        Doc_No:	Doc_No,
        Reference:	Reference,
        Doc_Header_Text:	Doc_Header_Text,
        Debit_Amount:	Debit_Amount,
        Credit_Amount:	Credit_Amount,
        Running_Balance:	Running_Balance,
        Opening_Balance:	Opening_Balance,
        Debit:	Debit,
        Credit:	Credit,
        Closing_Balance:	Closing_Balance,
        To_Balance_c_f:	To_Balance_c_f,
        Currency:	Currency,
        Download:	Download,
        Customer_Name:	Customer_Name,
        Customer_Code:	Customer_Code,
        Period_from:	Period_from,
        Report_Date:	Report_Date,
        Search: Search,
        Download_as_PDF: Download_as_PDF,
        Download_as_Excel:Download_as_Excel,
        AL_Toast1:AL_Toast1,
        AL_Toast2:AL_Toast2,
        Toast_Warning:Toast_Warning,
        Toast_Info:Toast_Info,
        No_Result_Found:No_Result_Found,
        Disclaimer:Disclaimer,
        Search_Ledger:Search_Ledger,
        Account_Ledger:Account_Ledger,
        AL_Toast3 : AL_Toast3,
        AL_Toast4 : AL_Toast4,
        AL_Toast5 : AL_Toast5,
        AL_Toast6 : AL_Toast6,
        AL_Toast7 : AL_Toast7
    }
    @track Download_as_PDF = this.labels.Download_as_PDF ;
    @track columns1 = [
        { label: this.labels.Post_Date, fieldName: 'wPostDate',type: "date",typeAttributes:{day: "2-digit",month: "short",year: "numeric"}, cellAttributes: { alignment: 'left' }},
        { label: this.labels.Doc_Type, fieldName: 'wDocType', type: 'text', cellAttributes: { alignment: 'left' }},
        { label: this.labels.Doc_No, fieldName: 'wDocNo', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Reference, fieldName: 'wReference', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Doc_Header_Text, fieldName: 'wDocHeaderText', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Debit_Amount, fieldName: 'wDebitAmount', type: 'text' , cellAttributes: { alignment: 'right' }},
        { label: this.labels.Credit_Amount, fieldName: 'wCreditAmount', type: 'text' , cellAttributes: { alignment: 'right' }},
        { label: this.labels.Running_Balance, fieldName: 'wRunningBalance', type: 'text' , cellAttributes: { alignment: 'right' }}
    ];

    @track columns2 = [
        { label: this.labels.Post_Date, fieldName: 'wPostDate',type: "date",typeAttributes:{day: "2-digit",month: "short",year: "numeric"}, cellAttributes: { alignment: 'left' }},
        { label: this.labels.Doc_Type, fieldName: 'wDocType', type: 'text', cellAttributes: { alignment: 'left' }},
        { label: this.labels.Doc_No, fieldName: 'wDocNo', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Reference, fieldName: 'wReference', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Doc_Header_Text, fieldName: 'wDocHeaderText', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Debit_Amount, fieldName: 'wDebitAmount', type: 'text' , cellAttributes: { alignment: 'right' }},
        { label: this.labels.Credit_Amount, fieldName: 'wCreditAmount', type: 'text' , cellAttributes: { alignment: 'right' }}
    ];

    @track columns3 = [
        { label: this.labels.Post_Date, fieldName: 'wPostDate',type: "date",typeAttributes:{day: "2-digit",month: "short",year: "numeric"}, cellAttributes: { alignment: 'left' }},
        { label: this.labels.Doc_No, fieldName: 'wDocNo', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Reference, fieldName: 'wReference', type: 'text' , cellAttributes: { alignment: 'left' }},
        { label: this.labels.Debit_Amount, fieldName: 'wDebitAmount', type: 'text' , cellAttributes: { alignment: 'right' }},
        { label: this.labels.Credit_Amount, fieldName: 'wCreditAmount', type: 'text' , cellAttributes: { alignment: 'right' }},
        { label: this.labels.Running_Balance, fieldName: 'wRunningBalance', type: 'text' , cellAttributes: { alignment: 'right' }}
    ];
 
    connectedCallback() {
        /*loadScript(this, jQuery, jQueryUI)
        .then(() => {
            //console.log('JQuery loaded.');
            $(document).ready(function(){
                //Restrict past date selection in date picker  
                  $( "#datepickerId" ).datepicker({
                      beforeShowDay: function(date) {
                          var today = new Date();
                          if(date > today){
                              return [true];
                          }
                          else{
                              return [false];
                          }
                      },
                  });          
              });
        })
        .catch(error=>{
            //console.log('Failed to load the JQuery : ' +error);
        });*/

       //Added by Akhilesh w.r.t Mobile resposiveness
       console.log('The device form factor is: ' + FORM_FACTOR);
       if(FORM_FACTOR == 'Large'){
           this.isMobile = false;
       }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
           this.isMobile = true;
       }

        var today = new Date();
        //this.date=today.toISOString();
        var monthString1=(today.getMonth()+1);
        var dateString=today.getDate();
        console.log('dateString--',dateString);
        console.log('monthString1--',monthString1);
        if(monthString1.toString().length===1){
            if(dateString.toString().length===1){
                this.date=today.getFullYear()+"-0"+(today.getMonth()+1)+"-0"+today.getDate();
            }else{
                this.date=today.getFullYear()+"-0"+(today.getMonth()+1)+"-"+today.getDate();
            }
        }
        else if(monthString1.toString().length!==1){
            if(dateString.toString().length===1){
                this.date=today.getFullYear()+"-"+(today.getMonth()+1)+"-0"+today.getDate();
            }else{
                this.date=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
            }
         }
        this.PostingDateTo=this.date;
        console.log('PostingDateTo--',this.PostingDateTo);
        var dMonth=today.getMonth()+1;
         this.m1=dMonth;
        console.log('m1--',this.m1);
        console.log('dMonth--',dMonth);
        var dYear=today.getFullYear();
        console.log('dYear--',dYear);
        
        if(this.m1 == 1 || this.m1 == 2 || this.m1 == 3){
            //console.log('dYear111--',dYear);
            // var fm=today.getFullYear()-1;
            // console.log('fm--',fm);
            this.fyd=(today.getFullYear()-1)+"-"+'04'+"-"+'01';
            this.PostingDateFrom=this.fyd;
            console.log('PostingDateFrom--',this.PostingDateFrom);
            console.log('fyd--',this.fyd);
            // this.setFiscalDate=new Date(fyd).toLocaleString(this.lang,{day:'numeric',month:'short',year:'numeric'});
            // console.log('setFiscalDate=--',this.setFiscalDate);
        }else{
            this.fyd=today.getFullYear()+"-"+'04'+"-"+'01';
            this.PostingDateFrom=this.fyd;
            console.log('PostingDateFrom--',this.PostingDateFrom);
            console.log('fyd--',this.fyd);
        }
        

        fetchUser().then(result => { 
            //console.log('result---->',result);
               this.userAccountId=result[0].AccountId;
               this.country=result[0].Country;
               console.log('country-----'+this.country);
                //console.log('user Id ----->',this.userAccountId);
               
                if(this.userAccountId==undefined){
                    this.userAccountId='';
                }
                //console.log('user Id ----->',this.userAccountId);
            });

            fetchComm().then(result => {
                console.log('Result-->',result);
                this.showRunningBal=result[0].Show_Running_Balance__c;
                //console.log('showRunningBal ----->',this.showRunningBal);
                if(this.showRunningBal){
                    if(this.country=='Spain' || this.country=='Portugal'){
                        this.columns=this.columns3;
                    }else{
                        this.columns=this.columns1;
                    }
                    
                }else{
                    this.columns=this.columns2;
                }
            });

            fetchURL().then(result => { 
                console.log('result---->',result);
                    
                   //this.url=result[0].URL__c; commented by Akhilesh bcz of URL redirection
                   this.url= (window.location.href).split('/s/')[0];
                    console.log('url ----->', this.url);
                   
                    if(this.url==undefined){
                        this.url='';
                    }
                    //console.log('url ----->', this.url);
                });


            this.lang = LANG;
            console.log('lang-->',this.lang);
            this.locale = LOCALE;
            console.log('locale-->',this.locale);

            

            const date1 = new Date('7/13/2010');
            const date2 = new Date('12/15/2010');
            const diffTime = Math.abs(date2 - date1);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
            console.log(diffDays);
            //console.log(diffTime + " milliseconds");
            //console.log(diffDays + " days");
            
        //this.getTotalCountRecords();
        
       
    }

    getUser(){
        fetchUser().then(result => { 
            //console.log('result---->',result);
               this.userAccountId=result[0].AccountId;
               //console.log('user Id ----->',this.userAccountId);
                if(this.userAccountId==undefined){
                    this.userAccountId='';
                }
                //console.log('user Id ----->',this.userAccountId);
                this.value='10';
                
            });
    }
    

    getData(){
        //console.log('1-->',pdate);
        //console.log('this.userAccountId --> ' + this.userAccountId);
        //var d= new Date();
         var d= new Date(this.PostingDateFrom);
         var monthString=(d.getMonth()+1);
         var dd='';
         console.log('Length',monthString.toString().length);
         console.log('monthString',monthString);
         if(monthString.toString().length===1){
            dd=d.getFullYear()+'-0'+(d.getMonth()+1)+'-'+'01';
         }else{
            dd=d.getFullYear()+'-'+(d.getMonth()+1)+'-'+'01';
         }
         
        //console.log('1-->',dd);
        // this.fromDateForPDF_excel=new Date(dd).toLocaleString('en-GB',{day:'numeric',month:'short',year:'numeric'});
        // //console.log('this.fromDateForPDF_excel-->',this.fromDateForPDF_excel);
        // var ddd=new Date(this.PostingDateTo);
        // this.toDateForPDF_excel=ddd.toLocaleString('en-GB',{day:'numeric',month:'short',year:'numeric'});
        // //console.log('this.toDateForPDF_excel-->',this.toDateForPDF_excel);
        var cMonth = (d.getMonth()+1);
        this.currentMonth=cMonth;
        //console.log('selected Month-->',cMonth);
        getALData({
            PostingDateFrom: dd,
            PostingDateTo: this.PostingDateTo,
            uId:this.userAccountId,
            currentMonth:cMonth
            //showRunningBal:this.showRunningBal
        }).then(result => {
            this.Account_Ledger_Data=result;
            this.Account_Ledger_Data_table = this.Account_Ledger_Data.mWrapperAccountLedgerList;
            if(this.Account_Ledger_Data_table.length != 0){
                this.showResult=true;
            }else{
                this.showResult=false;
                this.showErrorToast1(this.labels.Toast_Warning,this.labels.No_Result_Found,'warning','dismissable');
            }
            this.openingBalance=this.Account_Ledger_Data.mOpeningBalance;
            this.totalDebit=this.Account_Ledger_Data.mToalDebitAmount;
            this.totalCredit=this.Account_Ledger_Data.mTotalCreditAmount;
            this.toBalance=this.Account_Ledger_Data.mToBalance;
            this.closingBalance=this.Account_Ledger_Data.mClosingBalance;
            this.CustName=this.Account_Ledger_Data.mCustomerName;
            this.CustCode=this.Account_Ledger_Data.mCustomerCode;
            this.Currency=this.Account_Ledger_Data.mCurrency;
            //console.log('DATA result1-->',result.mWrapperAccountLedgerList);
            //console.log('opening balance-->',result.mOpeningBalance);
            //console.log('mToBalance-->',result.mToBalance);
            //console.log('mTotalCreditAmount-->',result.mTotalCreditAmount);
            //console.log('mToalDebitAmount-->',result.mToalDebitAmount);
            //console.log('DATA-->',this.Account_Ledger_Data);
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            //console.log('error--',this.error)
            this.Account_Ledger_Data = undefined;
        });

    }

   
    handlePDFromChange(event){
        this.PostingDateFrom=event.target.value;
        console.log(this.PostingDateFrom);
        this.showResult = false;

    }
    handlePDToChange(event){
        this.PostingDateTo=event.target.value;
        console.log(this.PostingDateTo);
        this.showResult = false;
    }
    

    handleSearch(){
        
            var today = new Date();
            const date1 = new Date(today);
            const date2 = new Date(this.PostingDateFrom);
            const diffTime = Math.abs(date2 - date1);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
            console.log(diffDays);
            //console.log(diffTime + " milliseconds");
            //console.log(diffDays + " days");
         /*var timestamp = new Date();
        //  timestamp=setDate(today.getDate()+ 30);
        // ////console.log(Date.today().add(-180).days());
        // //console.log('timestamp-->',timestamp);
        var dateObj = new Date(timestamp);                           
        dateObj.setDate(dateObj.getDate() - 180);  
        //console.log('timestamp-->',dateObj);

        var dateObjFormatted= new Date(dateObj);
        //console.log('dateObjFormatted1-->',dateObjFormatted1);
        var dateObjFormatted1=new Date();
        dateObjFormatted1=dateObjFormatted.getFullYear()+"-"+(dateObjFormatted.getMonth()+1)+"-"+dateObjFormatted.getDate();
        //console.log('dateObjFormatted1-->',dateObjFormatted1);
        */
       var dateObj = new Date(today);
       var dateObjFormatted= new Date(dateObj);
       //console.log('dateObjFormatted1-->',dateObjFormatted);
       var dateObjFormatted1=dateObjFormatted.getFullYear()+'-'+(dateObjFormatted.getMonth()+1)+'-'+dateObjFormatted.getDate();
       //console.log('dateObjFormatted1-->',dateObjFormatted1);
       var currentDateMonth1=(dateObjFormatted.getMonth()+1);
       var currentDateYear=dateObjFormatted.getFullYear();
       //console.log('currentDateMonth1-->',currentDateMonth1);

        var pdformatted= new Date(this.PostingDateFrom);
        console.log('pdformatted-->',pdformatted);
        var pdformatted1
        try {
             pdformatted1=pdformatted.getFullYear()+'-'+(pdformatted.getMonth()+1)+'-'+pdformatted.getDate();
            console.log('pdformatted1-->',pdformatted1);
        } catch (error) {
            console.log(error);
        }
        // var pdformatted1=pdformatted.getFullYear()+'-'+(pdformatted.getMonth()+1)+'-'+pdformatted.getDate();
        // console.log('pdformatted1-->',pdformatted1);
        console.log('postingDate-->',this.PostingDateFrom);
        var pdMonth=(pdformatted.getMonth()+1);
        var pdYear=pdformatted.getFullYear();
        //var cDay=pdformatted.getDate();
        // eslint-disable-next-line radix
        var cDay=parseInt(this.PostingDateFrom.split('-')[2]);
        console.log('Day---'+cDay);
        //console.log('pdMonth-->',pdMonth);
        //console.log('Day-->',pdformatted.getDate());

        var tdformatted= new Date(this.PostingDateTo);
        //console.log('tdformatted-->',tdformatted);
        var tdformatted1=tdformatted.getFullYear()+'-'+(tdformatted.getMonth()+1)+'-'+tdformatted.getDate();
        //console.log('tdformatted1-->',tdformatted1);
        //console.log('dateEmptyError-->',this.dateEmptyError);
        //console.log('PostingDateTo-->',this.PostingDateTo);
        this.dateEmptyError = false;
        //console.log('dateEmptyError-->',this.dateEmptyError);

         if((this.PostingDateFrom==='' || this.PostingDateFrom===null) || (this.PostingDateTo==='' || this.PostingDateTo===null) ){
                 this.dateEmptyError=true;
                 this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast1,'warning','dismissable');
                
         }
         if(pdformatted > dateObjFormatted && this.dateEmptyError === false){
             this.dateEmptyError=true;
             this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast3,'warning','dismissable');//AL_Toast3
            
         }
         if(tdformatted > dateObjFormatted && this.dateEmptyError === false){
             this.dateEmptyError=true;
             this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast4,'warning','dismissable');//AL_Toast4
           
         } 
          if(cDay != 1 && this.dateEmptyError === false ){
             this.dateEmptyError=true;
             this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast5,'warning','dismissable');//AL_Toast5
         }
         if(currentDateMonth1 <= 3 && pdMonth <= 3 && currentDateYear > pdYear && this.dateEmptyError === false){
             this.dateEmptyError=true;
             this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast6,'warning','dismissable');//AL_Toast6
          
         }
         if(currentDateMonth1 >= 9 && pdMonth <= 3 && this.dateEmptyError === false){
             this.dateEmptyError=true;
             this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast6,'warning','dismissable');//AL_Toast6
          
         } 
         if(diffDays <= 185 && this.dateEmptyError === false ){
            console.log('entered-->');
            if(this.PostingDateFrom!='' && this.PostingDateTo!=''){
                if(this.PostingDateFrom!=null && this.PostingDateTo!=null){
                    if(this.PostingDateFrom < this.PostingDateTo){
                        this.PostingDateFrom=this.PostingDateFrom;
                        this.PostingDateTo=this.PostingDateTo;

                        var dF = new Date(this.PostingDateFrom);
                        var pdF =dF.getDate()+"/"+(dF.getMonth()+1)+"/"+dF.getFullYear();
                        var dT = new Date(this.PostingDateTo);
                        var pdT = dT.getDate()+"/"+(dT.getMonth()+1)+"/"+dT.getFullYear();
                        this.PostingDateFromHtml=pdF;
                        this.PostingDateToHtml=pdT;
                            dT.setDate(dT.getDate()+1);
                        // var date=dT.getDate()+"/"+(dT.getMonth()+1)+"/"+dT.getFullYear();
                        //console.log("Date-->",date);

                        var d1= new Date(this.PostingDateFrom);
                        var dd=d1.getFullYear()+"-"+(d1.getMonth()+1)+"-"+'01';
                        console.log('entered 338-->');
                        this.fromDateForPDF_excel=new Date(dd).toLocaleString(this.lang,{day:'numeric',month:'short',year:'numeric'});
                        //console.log('this.fromDateForPDF_excel-->',this.fromDateForPDF_excel);
                        
                        var ddd=new Date(this.PostingDateTo);
                        //console.log('entered 343-->');
                        this.toDateForPDF_excel=ddd.toLocaleString(this.lang,{day:'numeric',month:'short',year:'numeric'});
                        //console.log('this.toDateForPDF_excel-->',this.toDateForPDF_excel);

                        var d=new Date();
                        //this.reportDate=d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate();
                        //console.log('entered 349-->');
                        this.reportDate=d.toLocaleString(this.lang,{day:'numeric',month:'short',year:'numeric'})
                        this.getData();

                    }else{
                        this.dateEmptyError = true;
                        this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast2,'warning','dismissable');
                    }
                }
            
        }
         }else if(this.dateEmptyError === false && currentDateMonth1 >= 4 && currentDateMonth1 <= 9){
             //console.log('434');
             this.dateEmptyError = true;
             this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast7,'warning','dismissable');//AL_Toast7

         }else if(this.dateEmptyError === false && (currentDateMonth1 >= 10 || currentDateMonth1 <= 3)){
             //console.log('438');
                 if(this.PostingDateFrom!='' && this.PostingDateTo!=''){
                     if(this.PostingDateFrom!=null && this.PostingDateTo!=null){
                         if(this.PostingDateFrom < this.PostingDateTo){
                             this.PostingDateFrom=this.PostingDateFrom;
                             this.PostingDateTo=this.PostingDateTo;

                             var dF = new Date(this.PostingDateFrom);
                             var pdF =dF.getDate()+"/"+(dF.getMonth()+1)+"/"+dF.getFullYear();
                             var dT = new Date(this.PostingDateTo);
                             var pdT = dT.getDate()+"/"+(dT.getMonth()+1)+"/"+dT.getFullYear();
                             this.PostingDateFromHtml=pdF;
                             this.PostingDateToHtml=pdT;
                                 dT.setDate(dT.getDate()+1);
                             // var date=dT.getDate()+"/"+(dT.getMonth()+1)+"/"+dT.getFullYear();
                             // //console.log("Date-->",date);

                             var d1= new Date(this.PostingDateFrom);
                             var dd=d1.getFullYear()+"-"+(d1.getMonth()+1)+"-"+'01';
                             //console.log('entered 456-->');
                             this.fromDateForPDF_excel=new Date(dd).toLocaleString(this.lang,{day:'numeric',month:'short',year:'numeric'});
                             //console.log('this.fromDateForPDF_excel-->',this.fromDateForPDF_excel);
                            
                             var ddd=new Date(this.PostingDateTo);
                             //console.log('entered 461-->');
                             this.toDateForPDF_excel=ddd.toLocaleString(this.lang,{day:'numeric',month:'short',year:'numeric'});
                             //console.log('this.toDateForPDF_excel-->',this.toDateForPDF_excel);

                             var d=new Date();
                             //this.reportDate=d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate();
                             //console.log('entered 467-->');
                             this.reportDate=d.toLocaleString(this.lang,{day:'numeric',month:'short',year:'numeric'})
                             this.getData();

                         }else{
                             this.dateEmptyError = true;
                             this.showErrorToast1(this.labels.Toast_Warning,this.labels.AL_Toast2,'warning','dismissable');
                         }
                     }
            
                 }
         }
        
    }
    showErrorToast1( tit, mes, vari, tostmode) {
            const evt = new ShowToastEvent({
                title: tit,
                message: mes,
                variant: vari,
                mode: tostmode
                /*title: this.labels.Toast_Warning,
                message: this.labels.AL_Toast1,
                variant: 'warning',
                mode: 'dismissable'*/
            });
            this.dispatchEvent(evt);
        }
    /*showErrorToast1() {
        const evt = new ShowToastEvent({
            title: this.labels.Toast_Warning,
            message: this.labels.AL_Toast1,
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    showErrorToast2() {
        const evt = new ShowToastEvent({
            title: this.labels.Toast_Warning,
            message: this.labels.AL_Toast2,
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    showErrorToast3() {
        const evt = new ShowToastEvent({
            title: this.labels.Toast_Info,
            message: this.labels.No_Result_Found,
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    showErrorToast4() {
        const evt = new ShowToastEvent({
            title: this.labels.Toast_Warning,
            message: 'From date should be less than last 180 days.',
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    showErrorToast5() {
        const evt = new ShowToastEvent({
            title: this.labels.Toast_Warning,
            message: 'Please select current financial year date.',
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }*/

    

    /*@wire(fetchAL)
    wiredAL({ error, data }) {
        if (data) {
            this.Account_Ledger_Data = data;
            //console.log('--->',this.Account_Ledger_Data)
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.Account_Ledger_Data = undefined;
        }
    }*/

//https://upl.force.com uat
//https://uat-upl.cs117.force.com  prod
    

    downloadPDFFile() {
        var downloadURI=this.url+'/apex/CustomerLedgerReport?DateFrom='+this.PostingDateFrom+'&DateTo='+this.PostingDateTo+'&AccId='+this.userAccountId+'&Month='+this.currentMonth+'&reportDate='+this.reportDate+'&fDate='+this.fromDateForPDF_excel+'&tDate='+this.toDateForPDF_excel;
        var res = encodeURI(downloadURI);
        window.open(res);
        //window.open(this.url+'/apex/CustomerLedgerReport?DateFrom='+this.PostingDateFrom+'&DateTo='+this.PostingDateTo+'&AccId='+this.userAccountId+'&Month='+this.currentMonth+'&reportDate='+this.reportDate+'&fDate='+this.fromDateForPDF_excel+'&tDate='+this.toDateForPDF_excel);
    }
    downloadExcelFile() {
        var downloadURI=this.url+'/apex/CustomerLedgerReportExcel?DateFrom='+this.PostingDateFrom+'&DateTo='+this.PostingDateTo+'&AccId='+this.userAccountId+'&Month='+this.currentMonth+'&reportDate='+this.reportDate+'&fDate='+this.fromDateForPDF_excel+'&tDate='+this.toDateForPDF_excel;
        var res = encodeURI(downloadURI);
        window.open(res);
        //window.open(this.url+'/apex/CustomerLedgerReportExcel?DateFrom='+this.PostingDateFrom+'&DateTo='+this.PostingDateTo+'&AccId='+this.userAccountId+'&Month='+this.currentMonth+'&reportDate='+this.reportDate+'&fDate='+this.fromDateForPDF_excel+'&tDate='+this.toDateForPDF_excel);
    }
    
    // this method validates the data and creates the csv file to download
    downloadCSVFile() {   
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.Account_Ledger_Data.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        
        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for(let i=0; i < this.Account_Ledger_Data.length; i++){
            let colValue = 0;

            // validating keys in data
            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if(colValue > 0){
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.Account_Ledger_Data[i][rowKey] === undefined ? '' : this.Account_Ledger_Data[i][rowKey];
                    csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'Account_Ledger_Data.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 
    }
    /*handleRowAction(event){
        const row = event.detail.row;        
        this.record = row;
        this.recordId = row.Id;
        //console.log(this.recordId);
        this.bShowModal = true;

        fetchSalesOrder({recordId : this.recordId})
        .then(result => {
            this.records = result;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
        });

        fetchLineItem({recordId : this.recordId})
        .then(result => {
            this.LineItems=result;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
        });
        //console.log('end');
    }
   
    closeModal() {
        this.bShowModal = false;
    }*/
}