import { LightningElement, track, wire } from 'lwc';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getArgentinaArData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArgentinaArData';
import getArAndLedgerData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArAndLedgerData';
import getArgentinaPDFData from '@salesforce/apex/Grz_ArgentinaAccountReceivable.getArgentinaPDFData';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import ArSearchLabel from "@salesforce/label/c.Grz_ArSearch";
import { loadStyle } from 'lightning/platformResourceLoader'; //Added By Nishi
import MobileCardCSS from '@salesforce/resourceUrl/CustomMobileCardCSS'; //Added By Nishi

export default class Grz_AccountLedgerArgentinaCmp extends LightningElement {
  yearType;
 fiscalYear;
fiscalyearStartDate;
fiscalyearEndDate;
 startDate;
endDate;
sm;
em;
  @track LedgerYearOptions = [];
  
    DownloadPDF = DownloadPDF;
    DownloadXLS = DownloadXLS;
    backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
    downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
    ArSearchLabel = ArSearchLabel;
    @track data;
    @track error;
    @track CustomerCode;
    @track CustomerName;
    @track City;
    @track customerZone;
    @track customerServiceExecutive;
    @track isSpinner = true;
    @track isLoading = false
    @track disableButton=true;
    @track disableButton1=true;
    @track buttonClass='buttonClass2 componentNotoSansBold';
    @track buttonClass1='buttonClass2 componentNotoSansBold';
    @track isDistributorFound = true;
    @track ledgerRecords = [];
    @track accountOptions = [];
    @track customerCodeValue;
    @track searchKeyBar;
    @track ARpdfURL;
    @track ARxlsURL;
    upto_0_15;
    upto_16_30;
    upto_31_60;
    upto_61_90;
    upto_91_180;
    upto_181_270;
    after_271;
    checkexternaluser = false;
    isDataNull = false;
    isSuccess = true;
    isSuccessArData = false;
    nodata = false;
    message = 'No se encontraron registros';
    errorMessage;
    totalOverdue;
    notYetDue;
    strimg;


    //Added by Nishi for Mobile responsive cards css
    /*@track pagenumber = 1;
    @track pagesize = 10;
    @track recordstart = 0;
    @track recordend = 0;
    @track totalpages = 1;
    @track totalrecords = 0;
    @track isLoading = false;
    @track currentpagenumber = 1;*/
    
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

    /*handleFirst(event) {
      //this.isLoading = true;
      var pagenumber = 1;
      this.pagenumber = pagenumber;
      const scrollOptions = {
        left: 0,
        top: 0,
        behavior: "smooth"
      };
      window.scrollTo(scrollOptions);
    }
    processMe(event) {
      var checkpage = this.pagenumber;
      this.pagenumber = parseInt(event.target.name);
      if (this.pagenumber != checkpage) {
        //this.isLoading = true;
      }
      const scrollOptions = {
        left: 0,
        top: 0,
        behavior: "smooth"
      };
      window.scrollTo(scrollOptions);
    }
  
    get disableFirst() {
      if (this.pagenumber == 1) {
        return true;
      }
      return false;
    }
    get disableNext() {
      if (
        this.pagenumber == this.totalpages ||
        this.pagenumber >= this.totalpages
      ) {
        return true;
      }
      return false;
    }
    handlePrevious(event) {
      //this.isLoading = true;
      this.pagenumber--;
      const scrollOptions = {
        left: 0,
        top: 0,
        behavior: "smooth"
      };
      window.scrollTo(scrollOptions);
    }
    handleNext(event) {
      //this.isLoading = true;
      this.pagenumber = this.pagenumber + 1;
      const scrollOptions = {
        left: 0,
        top: 0,
        behavior: "smooth"
      };
      window.scrollTo(scrollOptions);
    }
    handleLast(event) {
      //this.isLoading = true;
      this.pagenumber = this.totalpages;
      const scrollOptions = {
        left: 0,
        top: 0,
        behavior: "smooth"
      };
      window.scrollTo(scrollOptions);
    }
    generatePageList = (pagenumber, totalpages) => {
      var pagenumber = parseInt(pagenumber);
      var pageList = [];
      var totalpages = this.totalpages;
      this.pagelist = [];
      if (totalpages > 1) {
        if (totalpages < 3) {
          if (pagenumber == 1) {
            pageList.push(1, 2);
          }
          if (pagenumber == 2) {
            pageList.push(1, 2);
          }
        } else {
          if (pagenumber + 1 < totalpages && pagenumber - 1 > 0) {
            pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
          } else if (pagenumber == 1 && totalpages > 2) {
            pageList.push(1, 2, 3);
          } else if (pagenumber + 1 == totalpages && pagenumber - 1 > 0) {
            pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
          } else if (pagenumber == totalpages && pagenumber - 1 > 0) {
            pageList.push(pagenumber - 2, pagenumber - 1, pagenumber);
          }
        }
      }
      this.pagelist = pageList;
    };*/

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
      this.searchKeyBar = event.target.value;
      this.isSuccessArData=false;
      this.isDataNull=false;
      this.nodata=false;
      if(this.searchKeyBar !=''&& this.searchKeyBar !=undefined && this.searchKeyBar !=null && this.searchKeyBar.trim().length>0){
        this.disableButton1=false;
        this.buttonClass1='buttonClass1 componentNotoSansBold';
      }
      else{
        this.disableButton1=true;
        this.buttonClass1='buttonClass2 componentNotoSansBold';
        this.disableButton=true;
        this.buttonClass='buttonClass2 componentNotoSansBold';
        
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
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
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
              this.isSuccessArData=false;
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
      this.disableButton=false;
      this.buttonClass='buttonClass1 componentNotoSansBold';

    }

  LedgerPDF() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
  LedgerXLS() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }

  handleCustomerCode(event) {
    this.customerCodeValue = event.detail.value; 
    console.log('-----this.customerCodeValue---- '+this.customerCodeValue);
    if(this.customerCodeValue!=undefined){
      this.disableButton=false;
      this.buttonClass='buttonClass1 componentNotoSansBold';
    }
    else{
      this.disableButton=true;
      this.buttonClass='buttonClass2 componentNotoSansBold';
    }       
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
    console.log('=====#######====='+result.base64);
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
handleButtonClick(){

  if((this.searchKeyBar == '' || this.searchKeyBar ==null || this.searchKeyBar ==undefined) && this.checkexternaluser){
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


  if((this.customerCodeValue != undefined && this.customerCodeValue != '')) {
    getArAndLedgerData({CustomerCode: this.customerCodeValue,fiscalYear: this.yearType,fiscalMonthStart: this.sm,fiscalMonthEnd: this.em,startDt: this.startDate,endDt: this.endDate}).then((result) => {

        console.log('getArAndLedgerData result==>',result);
        this.ledgerRecords = result.ItemInfo;
        //this.totalrecords= result.ItemInfo.length;
        //this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
        //this.generatePageList(this.pagenumber, this.totalpages);
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
        this.isLoading = false;

    });
  }
  else{
    this.isLoading = false;
  }
  this.disableButton=false;
  this.buttonClass='buttonClass1 componentNotoSansBold';
  this.ARpdfURL = '/uplpartnerportalstd/apex/Grz_AccountLedgerArgentinaPDF?CustomerCode='+ this.customerCodeValue
  +'&fiscalYear='+this.yearType+'&fiscalMonthStart='+this.sm+'&fiscalMonthEnd='+this.em+'&sDate='+this.startDate+'&eDate='+this.endDate;

 

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
}