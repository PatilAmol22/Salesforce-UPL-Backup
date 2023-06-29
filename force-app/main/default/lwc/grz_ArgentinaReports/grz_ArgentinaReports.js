import { LightningElement, track, wire } from 'lwc';
import getReportData from '@salesforce/apex/Grz_ArgentinaReportController.getReportData';
import getArgentinaArData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArgentinaArData';
import loggedUserData from '@salesforce/apex/Grz_ArgentinaReportController.loggedUserData';
import Reports from "@salesforce/label/c.Grz_Reports";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getArgentinaPDFData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArgentinaPDFData';
import ArSearchLabel from "@salesforce/label/c.Grz_ArSearch";
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import { loadStyle } from 'lightning/platformResourceLoader'; //Added By Nishi
import MobileCardCSS from '@salesforce/resourceUrl/CustomMobileCardCSS'; //Added By Nishi

export default class Grz_ArgentinaReports extends LightningElement {
  yearType;
  fiscalYear;
 fiscalyearStartDate;
 fiscalyearEndDate;
  startDate;
 endDate;
 sm;
 em;
    
    @track isExternal=true;
    
    @track ledgerRecords1 = [];
    @track data;
    @track error;
    Headertitle = Reports;
    @track CustomerCode;
    @track CustomerName;
    @track City;
    @track customerZone;
    @track customerServiceExecutive;
    @track isSpinner = true;
    @track isLoading = false;
    @track buttonClass='buttonClass2 componentNotoSansBold';
    @track buttonClass1='buttonClass2 componentNotoSansBold';
    @track yearType;
    @track monthType;
    @track disableButton=true;
    @track disableButton1=true;
    @track isDistributorFound = true;
    @track ledgerRecords = [];
    @track accountOptions = [];
    @track tempLedYear;
    @track customerCodeValue;
    @track searchKeyBar;
    errorMessage = 'No se encontraron registros';
    isSuccessArData = false;
    isSuccess = true;
    isDataNull1 = false;
    isDataNull = false;
    nodata = false;
    nodata1 = false;
    ArSearchLabel = ArSearchLabel;

    //Added by Nishi for Mobile responsive cards css
    connectedCallback() {        
      Promise.all([
          loadStyle( this, MobileCardCSS )
          ]).then(() => {
              console.log( 'Files loaded' );
          })
          .catch(error => {
              console.log( error.body.message );
      });
    }
    //Added by Nishi for Mobile responsive cards css- End

    @wire(getArgentinaArData, {
      executedfrom : "ArLedgerCmp"
    })
    getArgentinaArData(result) {
    if (result.data) {
      this.yearType=(this.YearStart()).toString();
      this.fiscalYear=Number(this.yearType);
      this.disableButton=false;
      this.buttonClass='buttonClass1 componentNotoSansBold';
this.fiscalyearEndDate=(this.fiscalYear+1) + "-03-31";
this.fiscalyearStartDate=this.fiscalYear+ "-04-01";
this.startDate = this.todayDt();
this.endDate = this.todayDt();
        this.data = result.data;
        console.log('this.data : ',this.data);
        this.CustomerCode = this.data.customerCode;
        this.CustomerName = this.data.customerName;
        this.City = this.data.customerCity;
        this.isSuccessArData = this.data.isSuccess;
        this.checkexternaluser = this.data.checkexternaluser;
        this.customerZone = this.data.customerZone;
        this.customerServiceExecutive = this.data.customerServiceExecutive;
        this.isSpinner = false;
        console.log(JSON.stringify(this.data)+'isExternal============='+this.checkexternaluser);
    }else if(result.error){
        this.isSpinner = false;
        this.error = result.error;
        console.log('this.error123456789 : ',this.error);
    }
  }

    onChangeSearch(event) {
       this.isSuccessArData = false;
        this.searchKeyBar = event.target.value;
        this.isDataNull = false;
        this.isDataNull1 = false;
        this.nodata = false;
        this.nodata1 = false;
        this.disableButton1=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        this.disableButton=true;
        this.buttonClass1 = 'buttonClass2 componentNotoSansBold';
        console.log('this.searchKeyBar : '+this.searchKeyBar);
        if(this.searchKeyBar !=''&& this.searchKeyBar !=undefined && this.searchKeyBar !=null && this.searchKeyBar.trim().length>0 ){
          this.disableButton1=false;
          this.buttonClass1='buttonClass1 componentNotoSansBold';
          this.disableButton=false;
          this.buttonClass='buttonClass1 componentNotoSansBold';
        }
        else{
          this.disableButton1=true;
          this.buttonClass='buttonClass2 componentNotoSansBold';
          this.disableButton=true;
          this.buttonClass1 = 'buttonClass2 componentNotoSansBold';
        }
        this.yearType=(this.YearStart()).toString();
                this.fiscalYear=Number(this.yearType);
                this.disableButton=false;
        this.fiscalyearEndDate=(this.fiscalYear+1) + "-03-31";
  this.fiscalyearStartDate=this.fiscalYear+ "-04-01";
  this.startDate = this.todayDt();
  this.endDate = this.todayDt();
      }


      handleCustomerData(){
        this.ledgerRecords = [];
        if(this.searchKeyBar == '' || this.searchKeyBar ==null || this.searchKeyBar ==undefined){
          const event = new ShowToastEvent({
            title:
              "Ingrese el código de cliente",
            variant: "error"
          });
          this.dispatchEvent(event);
        }
  
        this.isSpinner = true;
        this.disableButton1=true;
        this.buttonClass1='buttonClass2 componentNotoSansBold';
        var searchval = this.searchKeyBar;
       
        if((searchval != '' && searchval != undefined)) {
          getArgentinaArData({executedfrom: this.searchKeyBar}).then((result) => {
  
              console.log('getArAndLedgerData result==>',result);
  
              this.isSuccess  = result.isSuccess;
              this.CustomerCode = result.customerCode;
              this.CustomerName = result.customerName;
              this.City = result.customerCity;
              this.customerServiceExecutive = result.customerServiceExecutive;
              this.isSuccessArData = result.isSuccess;
              this.customerZone = result.customerZone;
              this.checkexternaluser = this.data.checkexternaluser;
              this.isSuccessArData=true;
              this.isDistributorFound = result.isDistributorFound;
              if(!result.isDistributorFound){
                const event = new ShowToastEvent({
                  title:"No se encontró distribuidora",
                  variant: "error"
                });
                this.dispatchEvent(event);
                this.isSuccessArData = false;
              }
              if(!this.isSuccess){
                this.isSpinner = result.isSuccess;
              }
              this.isSpinner = false;
  
          })
          .catch(error => {
            this.isSpinner = false;
            console.log('error in AR : ',error);
        });
  
         
        }
        else{
          this.isSpinner = false;
        }
        this.disableButton1=false;
        this.buttonClass1='buttonClass1 componentNotoSansBold';
      }

      handleCustomerCode(event) {
        this.customerCodeValue = event.detail.value; 
        console.log('-----this.customerCodeValue---- '+this.customerCodeValue);
        if(this.customerCodeValue!=undefined){
          this.disableButton1=false;
          this.buttonClass1='buttonClass1 componentNotoSansBold';
        }
        else{
          this.disableButton1=true;
          this.buttonClass1='buttonClass2 componentNotoSansBold';
        }       
      }

    handleButtonClick(event){

        
        
        if((this.searchKeyBar == '' || this.searchKeyBar ==null || this.searchKeyBar ==undefined)){
            this.customerCodeValue = 'Customer';
          }else{
            this.customerCodeValue = this.searchKeyBar;
            if(this.customerCodeValue==''){
              const event = new ShowToastEvent({
                title:
                  "Ingrese el código de cliente",
                variant: "error"
              });
              this.dispatchEvent(event);
            }
          }
        
  
        this.isLoading = true;
        this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';


        if (this.startDate.substring(5, 7) == "01") {
          this.sm = "10";
        } else if (this.startDate.substring(5, 7) == "02") {
          this.sm = "11";
        } else if (this.startDate.substring(5, 7) == "03") {
          this.sm = "12";
        } else if (this.startDate.substring(5, 7) == "10") {
          this.sm = "7";
        } else {
          let st = this.startDate.substring(5, 7);
          let ab = Number(st.replace("0", "")) - 3;
          this.sm = String(ab);
        }
        if (this.endDate.substring(5, 7) == "01") {
          this.em = "10";
        } else if (this.endDate.substring(5, 7) == "02") {
          this.em = "11";
        } else if (this.endDate.substring(5, 7) == "03") {
          this.em = "12";
        } else if (this.endDate.substring(5, 7) == "10") {
          this.em = "7";
        } else {
          let st = this.endDate.substring(5, 7);
          let ab = Number(st.replace("0", "")) - 3;
          this.em = String(ab);
        }
      

        if((this.searchKeyBar != undefined && this.searchKeyBar != '')) {
            getReportData({CustomerCode: this.searchKeyBar,fiscalYear: this.yearType,fiscalMonthS: this.sm,fiscalMonthE: this.em}).then((result) => {
  
              console.log('getReportData result==>',result);
              console.log('getReportData resultItemInfo==>',result.ItemInfo);
              console.log('getReportData resultItemInfo1==>',result.ItemInfo1);
              //this.ledgerRecords = result.ItemInfo;
              //this.ledgerRecords1 = result.ItemInfo1;
              this.ledgerRecords = [];
              this.ledgerRecords1 =[];

              if(result.ItemInfo){
                result.ItemInfo.forEach((item) => {
        // the snippet below is introduced to filter start and end date with PostDate field in Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 28-12-2022
                  var ndd=new Date(item.PostDate.slice(0, 10));
                  var start = new Date(this.startDate.slice(0, 10));
                  var end = new Date(this.endDate.slice(0, 10));
              
                  if(ndd>=start && end>=ndd){
                    this.ledgerRecords.push(item);
                  }
              
                });
              }
              if(result.ItemInfo1){
                result.ItemInfo1.forEach((item) => {
                          // the snippet below is introduced to filter start and end date with PostDate field in Argentina community,GRZ(Mohit Garg) : APPS-1757 added on: 28-12-2022
                  var ndd=new Date(item.PostDate.slice(0, 10));
                  var start = new Date(this.startDate.slice(0, 10));
                  var end = new Date(this.endDate.slice(0, 10));
              
                  if(ndd>=start && end>=ndd){
                    this.ledgerRecords1.push(item);
                  }
              
                });
              }

              this.isSuccess  = result.isSuccess;
              if(!this.isSuccess){
                this.isLoading = result.isSuccess;
              }
              if (this.ledgerRecords&&this.ledgerRecords.length > 0) {
                  this.isDataNull = true;
                  this.nodata = false;
              }
              else{
                this.isDataNull = false;
                this.nodata = true;
              }
              if (this.ledgerRecords1.length > 0) {
                this.isDataNull1 = true;
                this.nodata1 = false;
            }
            else{
              this.isDataNull1 = false;
              this.nodata1 = true;
            }
              this.isLoading = false;
  
          });
        }
        else{
          this.isLoading = false;
        }
        this.disableButton1=false;
        this.buttonClass1='buttonClass1 componentNotoSansBold';
      }


    @wire(loggedUserData, {
        
    })
    loggedUserData(result) {
    if (result.data) {
      if(result.data.AccountId==undefined){
          this.isExternal=false;
          console.log('==================',JSON.stringify(result.data))
          this.isSpinner=false;

      }else{
          this.isExternal=true;
          console.log('*********CustomerCode*********',result.data.CustomerCode);
          this.searchKeyBar=result.data.CustomerCode;
          console.log('+++++++++++searchKeyBar +++++++++++++++', this.searchKeyBar);
      }
    }
  }

  handleYearOption(event) {
    console.log('yt========='+this.yearType);
    console.log('yt=========',event.detail.value);
  
    this.yearType = event.detail.value;
    console.log('yt========='+this.yearType);
    this.fiscalYear = Number(this.yearType);
    this.fiscalyearStartDate = this.fiscalYear + "-04-01";
    this.fiscalyearEndDate = (this.fiscalYear+1)+ "-03-31";
    this.startDate = this.fiscalyearStartDate;
    this.endDate = this.fiscalYear + "-07-01";
  }
  get YearOptions(){
    var y1=(this.YearStart() - 1).toString();
    var y2=(this.YearStart()).toString();
      return [ {
        label: (y1),
        value: (y1)
      }, {
        label: (y2),
        value: (y2)
      }];
    
  }
  YearStart() {
    var fiscalyearStart0 = "";
    var today = new Date();
  
    if (today.getMonth() + 1 <= 3) {
      fiscalyearStart0 = today.getFullYear() - 1;
    } else {
      fiscalyearStart0 = today.getFullYear();
    }
    console.log("-----fiscalyearStart---- " + fiscalyearStart0);
    return fiscalyearStart0;
  }
  startdateChange(event) {
    this.startDate = event.target.value;
    var start;
    var end;
    if(this.startDate){ start = new Date(this.startDate.slice(0, 10));}
    if(this.endDate){ end = new Date(this.endDate.slice(0, 10));}
    var fs = new Date(this.fiscalyearStartDate);
    var fe = new Date(this.fiscalyearEndDate);
    console.log(start+'===='+fs+'====='+fe);
    if(!this.startDate){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
    }else if(start>fe||fs>start)
    {
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
    }else{
      this.disableButton=false;
        this.buttonClass='buttonClass1 componentNotoSansBold';
    }
  
    if(!this.endDate){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
    }
    
    if(this.endDate){
      if(start>end){
        console.log('errot   ');
        this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        const event0 = new ShowToastEvent({
          title: "La fecha de inicio debe ser anterior a la fecha de finalización",
          variant: "error"
        });
        this.dispatchEvent(event0);
      }
      if(fe<end||end<fs)
    {
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
    }
    if(this.getDaysDifference(start, end)>92){
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
      const event1 = new ShowToastEvent({
        title: "La diferencia entre la fecha de inicio y finalización no debe ser mayor a 3 meses",
        variant: "error"
      });
      this.dispatchEvent(event1);
    }
    }
    var today = new Date();
    if(start>today){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        const event2 = new ShowToastEvent({
          title: "La fecha de inicio no debe ser posterior a hoy",
          variant: "error"
        });
        this.dispatchEvent(event2);
    }
    if(end>today){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        const event3 = new ShowToastEvent({
          title: "La fecha de finalización no debe ser posterior a hoy",
          variant: "error"
        });
        this.dispatchEvent(event3);
    }
  }
  enddateChange(event) {
    this.endDate = event.target.value;
    var start;
    var end;
    if(this.startDate){ start = new Date(this.startDate.slice(0, 10));}
    if(this.endDate){ end = new Date(this.endDate.slice(0, 10));}
    var fs = new Date(this.fiscalyearStartDate);
    var fe = new Date(this.fiscalyearEndDate);
    console.log(start+'===='+fs+'====='+fe);
    if(!this.endDate){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
    }else if(end>fe||fs>end)
    {
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
    }else{
      this.disableButton=false;
        this.buttonClass='buttonClass1 componentNotoSansBold';
    }
    if(!this.startDate){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
    }
    
    if(this.startDate){
      if(start>end){
        console.log('errot   ');
        this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        const event0 = new ShowToastEvent({
          title: "La fecha de inicio debe ser anterior a la fecha de finalización",
          variant: "error"
        });
        this.dispatchEvent(event0);
      }
      if(fe<end||end<fs)
    {
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
    }
    if(this.getDaysDifference(start, end)>92){
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
      const event1 = new ShowToastEvent({
        title: "La diferencia entre la fecha de inicio y finalización no debe ser mayor a 3 meses",
        variant: "error"
      });
      this.dispatchEvent(event1);
    }
    }
    if(!this.endDate){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
    }
    if(!this.startDate){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
    }
    
    var today = new Date();
    if(start>today){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        const event2 = new ShowToastEvent({
          title: "La fecha de inicio no debe ser posterior a hoy",
          variant: "error"
        });
        this.dispatchEvent(event2);
    }
    if(end>today){
      this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        const event3 = new ShowToastEvent({
          title: "La fecha de finalización no debe ser posterior a hoy",
          variant: "error"
        });
        this.dispatchEvent(event3);
    }
  }
  getMonthDifference(startDate, endDate) {
    return (
      endDate.getMonth() -
      startDate.getMonth() +
      12 * (endDate.getFullYear() - startDate.getFullYear())
    );
  }
  getDaysDifference(date1,date2){
    // To calculate the time difference of two dates
    var Difference_In_Time = date2.getTime() - date1.getTime();
      
    // To calculate the no. of days between two dates
    var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
      return Difference_In_Days;
  }
  
  todayDt() {
    var d = new Date(),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();
  
    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;
  
    return [year, month, day].join('-');
  }

  handleDownloadClick(event) {
    this.isSpinner=true;
    var asn=event.currentTarget.dataset.id;
    var docType = event.currentTarget.dataset.name;
    console.log('******************clicked******************'+docType);
    console.log(this.CustomerCode+'******************clicked******************'+asn);
    //code added by Sumit Kumar for ticket no. RITM0512279
    getArgentinaPDFData({assignment: asn,CustomerCode: this.CustomerCode,fiscalYear: this.yearType,docType: docType}).then((result) => {
   
     console.log('PDF Data result==>',result);
     
     if(result.isSuccess){
       //console.log('=====#######====='+result.base64);
       var str = 'data:application/pdf;base64,';
       const downloadLink = document.createElement("a");    
       var Base64 = result.base64;
           //console.log(' Base64 ==>',Base64);
           var invoicePDFBase64 = str+Base64;
           var invoicePDFName = asn+'.pdf';
           downloadLink.href = invoicePDFBase64;
           downloadLink.download = invoicePDFName;
           downloadLink.click();
       this.isSpinner=false;
     }else{
       this.isSpinner=false;
       const event = new ShowToastEvent({
         title:
           result.Message,
         variant: "error"
       });
       this.dispatchEvent(event);
     }
     
   });
   }
}