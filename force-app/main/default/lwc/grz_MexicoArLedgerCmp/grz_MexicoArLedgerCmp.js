import { LightningElement, track, wire } from 'lwc';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getArAndLedgerData from '@salesforce/apex/Grz_MexicoArAndLedgerController.getArAndLedgerData';
import getMexicoArData from '@salesforce/apex/Grz_MexicoAccountReceivable.getMexicoArData';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import ArSearchLabel from "@salesforce/label/c.Grz_ArSearch";
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from "lightning/navigation";


export default class Grz_MexicoArLedgerCmp extends NavigationMixin(LightningElement) {
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
    @track yearType;
    @track monthType;
    @track disableButton=true;
    @track isDistributorFound = true;
    @track ledgerRecords = [];
    @track accountOptions = [];
    @track tempLedYear;
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

    //Added by Vaishnavi for Mobile APP
     isMobile;
     @track pageData =[];
     @track page = 1; //this is initialize for 1st page
     @track startingRecord = 1; //start record position per page
     @track pageSize = '10'; //default value we are assigning
     @track totalRecountCount=0; //total record count received from all retrieved records
     @track totalPage = 0; //total number of page is needed to display all records
     @track endingRecord = 0; //end record position per page
     @track rowNumberOffset;
     @track isDataSorted = false;

    @track columnAcc = [
      { label: 'Número del documento', fieldName: 'AccountingDocNumber', type: 'text'  },
      { label: 'Descripción del documento', fieldName: 'DocType', type: 'text'  },
      { label: 'Asignación de documentos', fieldName: 'Assignment', type: 'text'  },
      { label: 'Fecha de Facturacion', fieldName: 'PostDate', type: 'text'  },
      { label: 'Fecha de vencimiento', fieldName: 'NetDueDate', type: 'text'  },
      { label: 'Moneda', fieldName: 'DocCurrency', type: 'text'  },
      { label: 'Días', fieldName: 'Days', type: 'Number',fractionDigit:"0"  },
      { label: 'Importe del documento', fieldName: 'AmtInDocCurrency', type: 'Number',fractionDigit:"1"  },
      { label: 'Importe MXN', fieldName: 'AmtInLocalCurrency', type: 'Number',fractionDigit:"1"  }];
   
    @wire(getMexicoArData, {
        executedfrom : "ArLedgerCmp"
      })
    getMexicoArData(result) {
      if (result.data) {

          this.data = result.data;
          console.log('this.data : ',this.data);
          this.CustomerCode = this.data.customerCode;
          this.CustomerName = this.data.customerName;
          this.City = this.data.customerCity;
          this.isSuccessArData = this.data.isSuccess;
          this.errorMessage = this.data.Message;
          this.checkexternaluser = this.data.checkexternaluser;
          this.customerZone = this.data.customerZone;
          this.customerServiceExecutive = this.data.customerServiceExecutive;
          this.totalOverdue = this.data.totalOverdue;
          this.notYetDue = this.data.notYetDue;
          this.upto_0_15 = this.data.upto_0_15;
          this.upto_16_30 = this.data.upto_16_30;
          this.upto_31_60 = this.data.upto_31_60;
          this.upto_61_90 = this.data.upto_61_90;
          this.upto_91_180 = this.data.upto_91_180;
          this.upto_181_270 = this.data.upto_181_270;
          this.after_271 = this.data.after_271;
          this.isSpinner = false;
          /*var relatedaccList = this.data.relatedAccounts;

          for(const item of relatedaccList){
                //var item = relatedaccList[i];
                var option = {label: item.SAPCustomerCode, value: item.SAPCustomerCode};      
                  //Push each account to the array.
                this.accountOptions = [ ...this.accountOptions, option ];
          }
          console.log('this.accountOptions : ',this.accountOptions);*/

      }else if(result.error){
          this.isSpinner = false;
          this.error = result.error;
          console.log('this.error : ',this.error);
      }
    }
    get showFirstButton() {
      if (this.page == 1 || this.page == 0) {
          return true;
      }else if(this.totalRecountCount===0){
          return true;
      }else{
          return false;
      }
  }
   
  get showLastButton() {
     if(this.totalRecountCount===undefined || this.totalRecountCount === 0){
          return true;
     }
      if (Math.ceil(this.totalRecountCount / this.pageSize) === this.page || Math.ceil(this.totalRecountCount / this.pageSize)===0) {
          return true;
      }
      return false;
  }
  handleFirst(event) {
    if (this.page > 1) {
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }          
}

handleLast(event) {
    if ((this.page < this.totalPage) && this.page !== this.totalPage) {
        this.page = this.totalPage;
        this.displayRecordPerPage(this.page);
    }         
}

handleNext(event) {
    if ((this.page < this.totalPage) && this.page !== this.totalPage) {
        this.page = this.page + 1; //increase page by 1
        this.displayRecordPerPage(this.page);
    }        
}

handlePrevious(event) {
    if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1
        this.displayRecordPerPage(this.page);
    }
}
displayRecordPerPage(page) {

  /*let's say for 2nd page, it will be => "Displaying 6 to 10 of 23 records. Page 2 of 5"
  page = 2; pageSize = 5; startingRecord = 5, endingRecord = 10
  so, slice(5,10) will give 5th to 9th records.
  */
  //this.HandleButton();
  this.startingRecord = ((page - 1) * this.pageSize);
  this.endingRecord = (this.pageSize * page);

  this.endingRecord = ((this.pageSize * page) > this.totalRecountCount)
      ? this.totalRecountCount : (this.pageSize * page);
  if(this.isDataSorted===true){
      this.pageData = this.parseData.slice(this.startingRecord, this.endingRecord);
      this.rowNumberOffset = this.startingRecord;
  }else{
      this.pageData = this.ledgerRecords.slice(this.startingRecord, this.endingRecord);
      this.rowNumberOffset = this.startingRecord;
  }
  

  //increment by 1 to display the startingRecord count, 
  //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
  this.startingRecord = this.startingRecord + 1;

  //added by Vaishnavi w.r.t Mobile UI
  if(this.isMobile){
      this.template.querySelector('c-responsive-card').tableData = this.pageData;
      this.template.querySelector('c-responsive-card').updateValues();
  }
}
    connectedCallback(){

       //added by Vaishnavi w.r.t Mobile UI
      console.log('The device form factor is: ' + FORM_FACTOR);
      if(FORM_FACTOR == 'Large'){
          this.isMobile = false;
      }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
          this.isMobile = true;
      }
      console.log('this.isMobile ' + this.isMobile);

    }
    handleCustomerCode(event) {
      this.customerCodeValue = event.detail.value; 
      console.log('-----this.customerCodeValue---- '+this.customerCodeValue);
      if(this.customerCodeValue!=undefined && this.yearType!=undefined && this.monthType!=undefined){
        this.disableButton=false;
      }
      else{
        this.disableButton=true;
      }       
    }

    onChangeSearch(event) {
      this.searchKeyBar = event.target.value;
      console.log('this.searchKeyBar : '+this.searchKeyBar);
      if(this.searchKeyBar !='' || this.searchKeyBar !=undefined){
        this.disableButton=false;
      }
      else{
        this.disableButton=true;
      }
    }

    getFiscalYearStart() {
        var fiscalyearStart = "";
        var today = new Date();
        
        if ((today.getMonth() + 1) <= 3) {
        fiscalyearStart = today.getFullYear() - 1;
        } else {
        fiscalyearStart = today.getFullYear()
        }
        return fiscalyearStart;
    }

    handleYearOption(event) {
        this.yearType = event.detail.value;
        this.tempLedYear = event.detail.value;
        console.log('-----this.yearType---- '+this.yearType);
        if(this.yearType!=undefined && this.monthType!=undefined){
          this.disableButton=false;
        }
        else{
          this.disableButton=true;
        }
      }
      handleMonthOption(event) {
        this.monthType = event.detail.value; 
        console.log('-----this.monthType---- '+this.monthType);
        if(this.yearType!=undefined && this.monthType!=undefined){
          this.disableButton=false;
        }
        else{
          this.disableButton=true;
        }       
      }
      get MonthOptions() {
        return [
          { label: "Enero", value: "10" },
          { label: "Febrero", value: "11" },
          { label: "Marzo", value: "12" },
          { label: "Abril", value: "1" },
          { label: "Mayo", value: "2" },
          { label: "Junio", value: "3" },
          { label: "Julio", value: "4" },
          { label: "Agosto", value: "5" },
          { label: "Septiembre", value: "6" },
          { label: "Octubre", value: "7" },
          { label: "Noviembre", value: "8" },
          { label: "Diciembre", value: "9" }
        ];
      }

    get YearOptions() {
        return [
          { label: (this.getFiscalYearStart()-1).toString(), value: (this.getFiscalYearStart()-1).toString() },
          { label: this.getFiscalYearStart().toString(), value: this.getFiscalYearStart().toString() }
        ];
    }

    handleButtonClick(){

      if(this.monthType == "10" || this.monthType == "11" || this.monthType == "12"){
        this.tempLedYear = this.yearType - 1;
      }else{
        this.tempLedYear = this.yearType;
      }
      
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
      var selectedYear = this.tempLedYear;
      var selectedMonth = this.monthType;

      console.log('selectedYear==>',selectedYear);
      console.log('selectedMontht==>',selectedMonth);
      if((this.customerCodeValue != undefined && this.customerCodeValue != '') && selectedYear != undefined && selectedMonth != undefined) {
        getArAndLedgerData({CustomerCode: this.customerCodeValue,fiscalYear: this.tempLedYear,fiscalMonth: this.monthType}).then((result) => {

            console.log('getArAndLedgerData result==>',result);
            this.ledgerRecords = result.ItemInfo;
            this.isSuccess  = result.isSuccess;
            if(!this.isSuccess){
              this.isLoading = result.isSuccess;
            }
            if (this.ledgerRecords.length > 0) {
                this.isDataNull = true;
                this.nodata = false;
                if(this.isMobile){
                  this.totalRecountCount = this.ledgerRecords.length;
                  this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
                  //this.HandleButton();
                  this.pageData = this.ledgerRecords.slice(0, this.pageSize);
                  this.rowNumberOffset = 0;
                  this.endingRecord = this.pageSize;
                  this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount)
                      ? this.totalRecountCount : (this.pageSize * this.page);
  
                  if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
                        this.template.querySelector('c-responsive-card').tableData = this.pageData;
                        this.template.querySelector('c-responsive-card').updateValues();
                  }   
                }
              
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

      if(this.isMobile){
        this.ARpdfURL = '/uplpartnerportalstd/apex/Grz_AccountLedgerMexicoPDF?CustomerCode='+ this.customerCodeValue
        +'&fiscalYear='+this.tempLedYear+'&fiscalMonth='+this.monthType;

        this.ARxlsURL = '/uplpartnerportalstd/apex/Grz_AccountLedgerMexicoXLS?CustomerCode='+ this.customerCodeValue
        +'&fiscalYear='+this.tempLedYear+'&fiscalMonth='+this.monthType;
      }else{
        this.ARpdfURL = '/uplpartnerportal/apex/Grz_AccountLedgerMexicoPDF?CustomerCode='+ this.customerCodeValue
        +'&fiscalYear='+this.tempLedYear+'&fiscalMonth='+this.monthType;

        this.ARxlsURL = '/uplpartnerportal/apex/Grz_AccountLedgerMexicoXLS?CustomerCode='+ this.customerCodeValue
        +'&fiscalYear='+this.tempLedYear+'&fiscalMonth='+this.monthType;
      }
     

     

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

      /*if(this.monthType == "10" || this.monthType == "11" || this.monthType == "12"){
        this.tempLedYear = this.yearType - 1;
      }else{
        this.tempLedYear = this.yearType;
      }*/

      this.isSpinner = true;
      this.disableButton=true;
      var searchval = this.searchKeyBar;
      /*var selectedYear = this.tempLedYear;
      var selectedMonth = this.monthType;
      var searchval = this.searchKeyBar;
      console.log('searchval==>',searchval);
      console.log('selectedYear==>',selectedYear);
      console.log('selectedMontht==>',selectedMonth);*/
      if((searchval != '' && searchval != undefined)) {
        getMexicoArData({executedfrom: this.searchKeyBar}).then((result) => {

            console.log('getArAndLedgerData result==>',result);

            this.isSuccess  = result.isSuccess;
            this.CustomerCode = result.customerCode;
            this.CustomerName = result.customerName;
            this.City = result.customerCity;
            this.customerServiceExecutive = result.customerServiceExecutive;
            this.isSuccessArData = result.isSuccess;
            //this.checkexternaluser = result.checkexternaluser;
            this.customerZone = result.customerZone;
            this.totalOverdue = result.totalOverdue;
            this.notYetDue = result.notYetDue;
            this.upto_0_15 = result.upto_0_15;
            this.upto_16_30 = result.upto_16_30;
            this.upto_31_60 = result.upto_31_60;
            this.upto_61_90 = result.upto_61_90;
            this.upto_91_180 = result.upto_91_180;
            this.upto_181_270 = result.upto_181_270;
            this.after_271 = result.after_211;
            this.isDistributorFound = result.isDistributorFound;
            if(!result.isDistributorFound){
              const event = new ShowToastEvent({
                title:"No se encontró distribuidora",
                variant: "error"
              });
              this.dispatchEvent(event);
            }
            if(!this.isSuccess){
              this.isSpinner = result.isSuccess;
            }
            if (this.ledgerRecords.length > 0) {
                this.isDataNull = true;
                //this.nodata = false;
            }
            else{
              this.isDataNull = false;
              //this.nodata = true;
            }
            this.isSpinner = false;

        })
        .catch(error => {
          this.isSpinner = false;
          console.log('error in AR : ',error);
      });

      /*getArAndLedgerData({CustomerCode: this.searchKeyBar,fiscalYear: this.tempLedYear,fiscalMonth: this.monthType}).then((result) => {

        console.log('getArAndLedgerData result==>',result);
        this.ledgerRecords = result.ItemInfo;
        this.isSuccess  = result.isSuccess;
        if(!this.isSuccess){
          this.isLoading = result.isSuccess;
        }
        if (this.ledgerRecords.length > 0) {
            this.isDataNull = true;
            this.nodata = false;
        }
        else{
          this.isDataNull = false;
          this.nodata = true;
        }
        this.isLoading = false;

      });*/
        
      }
      else{
        this.isSpinner = false;
      }
      this.disableButton=false;
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
}