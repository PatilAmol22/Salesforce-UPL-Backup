import { LightningElement, track, wire } from "lwc";
import getuserInfo from "@salesforce/apex/Grz_AccountReceivablesChile.getuserInfo";
import getAccountReceivables from "@salesforce/apex/Grz_AccountReceivablesChile.getAccountReceivables";
import getCustomerRecord from "@salesforce/apex/Grz_AccountReceivablesChile.getCustomerRecord";
import SendEMail from "@salesforce/apex/grz_SapIntegration.SendEMail";//GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import FORM_FACTOR from '@salesforce/client/formFactor';//Added By Akhilesh w.r.t Mobile UI
//For Pagination added by Akhilesh
import First from '@salesforce/label/c.First';
import Previous from '@salesforce/label/c.Previous';
import Next from '@salesforce/label/c.Next';
import Last from '@salesforce/label/c.Last';
import Page from '@salesforce/label/c.Page';
//Pagination labels ends here

export default class Grz_AccountReceivablesChile extends LightningElement {
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  filterIcon = Icons + "/Grz_Resourse/Images/FilterIcon.png";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";

  @track searchKey;

  @track fiscalYear;
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;

  @track searchKeyBar;
  @track dueDateStart;
  @track dueDateEnd;
  @track documentDate;
  @track sortBy = 'DocDate';
  @track sortOrder = 'Asc';
  @track documentDate;
  @track recordCount = 0;

  @track documentStartDate;
  @track documentEndDate;

  @track isLoading = false;
  @track isDataNull = false;
  @track showBlock = false;
  @track isSuccess = true;
  @track isSpinner = false;
  @track ARxlsURL;
  @track ARpdfURL;
  @track notValidStartDate = false;
  @track notValidEndDate = false;
  @track selectedFiscalYear = 0;
  @track onLoadFiscalYear = "0";
  @track nodata = false;
  @track companyCode;
  @track sapUserId;
  @track city;
  @track CustomerName;
  @track CustomerCode;

  @track arPayloads = [];
  @track filtertempRecords = [];
  @track tempRecords = [];
  @track totalOverdue;
  @track finalTotal;
  @track finalTotalUSD;
  @track finalTotalCLP;
  @track notYetDue;
  @track upto_0_30;
  @track upto_31_60;
  @track after_61;
  @track totalOverdueUSD;
  @track notYetDueUSD;
  @track upto_0_30USD;
  @track upto_31_60USD;
  @track after_61USD;
  @track totalOverdueCLP;
  @track notYetDueCLP;
  @track upto_0_30CLP;
  @track upto_31_60CLP;
  @track after_61CLP;
  @track currentFiscalYear;
  @track sapInternalInput;
  @track keySearch = "";
  @track ARdataChile;

  @track distributorOptionsBr = [];
  @track validDueDates = true;
  @track message;
  @track overValue = "No";
  @track validUserDetails = true;
  @track isInternal;
  @track userInfoDiv;
  @track urlLink = '';//Added by Akhilesh
  isMobile;
  Nombre;

    @track page = 1; //this is initialize for 1st page
    @track data = []; //data to be display in the table
    @track startingRecord = 1; //start record position per page
    @track pageSize = '10'; //default value we are assigning
    @track totalRecountCount=0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track endingRecord = 0; //end record position per page
    @track showSpinner = false;
    @track label = {
        First,
        Previous,
        Next,
        Last,
        Page
    };

  //Added by Akhilesh for responsive card UI
  @track column =[{label:'Fecha del documento', fieldName:'DocDate', type: 'date-local', cellAttributes: { alignment: 'left' }},
            {label:'Nombre', fieldName:'Nombre', type: 'CustomerCodeCl', cellAttributes: { alignment: 'left' }},
            {label:'Factura', fieldName:'BillDoc', type: 'text', cellAttributes: { alignment: 'left' }},        
            {label:'Referencia', fieldName:'RefDocNo', type: 'text', cellAttributes: { alignment: 'left' }},
            {label:'Vencida', fieldName:'overDued', type: 'ExpiredImg', cellAttributes: { alignment: 'left' }},
            {label:'Vencimiento', fieldName:'DueDate', type: 'date-local', cellAttributes: { alignment: 'left' }},
            {label:'Moneda', fieldName:'Currenci', type: 'text', cellAttributes: { alignment: 'left' }},
            {label:'Valor de la factura', fieldName:'AmtDoccur', type: 'currencyChile', cellAttributes: { alignment: 'left' }}
        ];

  value = "USD";
  options = [
    { label: "USD", value: "USD" },
    { label: "CLP", value: "CLP" },
  ];
  sortValue = "DocDate-Asc";
  sortOptions = [
    { label: "Fecha del documento - Asc", value: "DocDate-Asc" },
    { label: "Fecha del documento - Desc", value: "DocDate-Desc" },
    { label: "Referencia - Asc", value: "RefDocNo-Asc" },
    { label: "Referencia - Desc", value: "RefDocNo-Desc" },
    { label: "Vencimiento - Asc", value: "DueDate-Asc" },
    { label: "Vencimiento - Desc", value: "DueDate-Desc" },
  ];
  connectedCallback() {
    console.log('User Language ==> ',this.language);
    //Added by vaishnavi w.r.t Mobile resposiveness
    console.log('The device form factor is: ' + FORM_FACTOR);
    if(FORM_FACTOR == 'Large'){
        this.isMobile = false;
    }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
        this.isMobile = true;
    }
  }

  //Added By Akhilesh for pagination
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

//Added By Akhilesh for pagination code 
getdata(){
    this.page=1;                    
        this.showSpinner = false;
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
        this.data = JSON.parse(JSON.stringify(this.tempRecords.slice(0, this.pageSize)));
        this.rowNumberOffset = 0;
        this.endingRecord = this.pageSize;
        this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount)
            ? this.totalRecountCount : (this.pageSize * this.page);
     
      this.template.querySelector('c-responsive-card').tableData = this.data;
      this.template.querySelector('c-responsive-card').updateValues();
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
        this.data = this.tempRecords.slice(this.startingRecord, this.endingRecord);
        this.rowNumberOffset = this.startingRecord;
    

    //increment by 1 to display the startingRecord count, 
    //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
    this.startingRecord = this.startingRecord + 1;

    //added by Vaishnavi w.r.t Mobile UI
    if(this.isMobile){
        this.template.querySelector('c-responsive-card').tableData = this.data;
        this.template.querySelector('c-responsive-card').updateValues();
    }
}
//Pagination change ends here
  setData() {
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, "0");
    var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
    var yyyy = today.getFullYear();
    this.documentEndDate = yyyy + "-" + mm + "-" + dd;
    this.currentFiscalYear = today.getFullYear();
    //this.documentStartDate = this.currentFiscalYear + "-01-01";
    this.fiscalyearStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
    this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
  }
  @wire(getuserInfo, {})
  fetchCustomerInfo(results) {
    if (results.data) {
      this.setData();
      this.isInternal = results.data.isInternal;
      this.userInfoDiv =  results.data.isInternal;
      if (!this.isInternal) {
        this.companyCode = results.data.companyCode;
        this.sapUserId = results.data.sapUserId;
        this.City = results.data.city;
        this.CustomerName = results.data.name;
        this.CustomerCode = results.data.customerCode;
        if (
          results.data.customerCode == undefined ||
          results.data.customerCode == null ||
          results.data.customerCode == "" ||
          results.data.companyCode == undefined ||
          results.data.companyCode == null ||
          results.data.companyCode == "" ||
          results.data.sapUserId == undefined ||
          results.data.sapUserId == null ||
          results.data.sapUserId == ""
        ) {
          this.validUserDetails = false;
          this.tostMsg(
            "El código de cliente / código de empresa / ID de usuario está vacío. Comuníquese con el administrador",
            "error"
          );
        }
      }
    }
    if (results.error) {
      console.log("Error==>", results.error);
    }
  }
  onChangeSAPInternal(event) {
    this.sapInternalInput = event.target.value;
  }
  handleARSearchInternal() {
    this.userInfoDiv = true;
    this.showBlock = false;
    if (this.sapInternalInput != undefined && this.sapInternalInput != "") {
      this.isLoading = true;
      getCustomerRecord({
        customerCode: this.sapInternalInput,
      }).then((result) => {
        if (result.noDistributor) {
          this.tostMsg("Distribuidor não encontrado", "error");
          this.isLoading = false;
        } else {
          this.companyCode = result.companyCode;
          this.sapUserId = result.sapUserId;
          this.City = result.city;
          this.CustomerName = result.name;
          this.CustomerCode = result.customerCode;
          if (
            result.customerCode == undefined ||
            result.customerCode == null ||
            result.customerCode == "" ||
            result.companyCode == undefined ||
            result.companyCode == null ||
            result.companyCode == "" ||
            result.sapUserId == undefined ||
            result.sapUserId == null ||
            result.sapUserId == ""
          ) {
            this.validUserDetails = false;
            this.tostMsg(
              "El código de cliente / código de empresa / ID de usuario está vacío. Comuníquese con el administrador",
              "error"
            );
            this.isLoading = false;
          } else {
            this.validUserDetails = true;
            this.handleARSearch();
          }
        }
      });
    } else {
      this.tostMsg("cliente no puede estar vacío", "error");
      this.isLoading = false;
    }
  }
  handleResult(event){
    const abc = event.detail;
    console.log('abccc===>',abc.recordId);
    this.sapInternalInput = abc.recordId;
  }
  handleARSearch() {
    this.isLoading = false;
    if (this.validUserDetails) {
      this.searchKeyBar = "";
      this.tempRecords = [];
      this.isDataNull = false;
      this.arPayloads = [];
      if (this.documentStartDate != null && this.documentEndDate != null) {
        var start = new Date(this.documentStartDate.slice(0, 10));        
        var end = new Date(this.documentEndDate);
        var today = new Date();
        if (start > today || end > today) {
          this.tostMsg(
            "La fecha de inicio y la fecha de finalización deben ser inferiores a las de hoy",
            "error"
          );
          this.showBlock = false;
        } else if (start > end) {
          this.tostMsg(
            "La fecha de inicio no puede ser posterior a la fecha de finalización",
            "error"
          );
          this.showBlock = false;
        } else if (this.notValidStartDate || this.notValidEndDate) {
          this.tostMsg("Por favor introduzca una fecha valida", "error");
          this.showBlock = false;
        } else {
          this.getAllArData();
        }
      }else if((this.documentStartDate == null || this.documentStartDate == undefined) && this.documentEndDate != null){
        this.getAllArData();
      } 
      else {
        this.tostMsg("La fecha no puede estar vacía", "error");
      }
    } else {
      this.tostMsg(
        "El código de cliente / código de empresa / ID de usuario está vacío. Comuníquese con el administrador",
        "error"
      );
    }
  }

  getAllArData(){
    this.userInfoDiv = false;
    this.isLoading = true;
    this.dueDateStart = Number(this.currentFiscalYear) - 1 + "-01-01";
    this.dueDateEnd = Number(this.currentFiscalYear) + 1 + "-12-31";
    setTimeout(() => {
      getAccountReceivables({
        customerCode: this.CustomerCode,
        sapUserId: this.sapUserId,
        companyCode: this.companyCode,
        refSearch: "",
        dueDateStart: "",
        dueDateEnd: "",
        startDate: "",
        endDate: "",
        forDownload: false,
      }).then((result) => {
        if (result.isSuccess) {
          this.isSuccess = true;

          this.arPayloads = result.ar.Lineitems;
          this.data = this.arPayloads.slice(0, this.pageSize);//for Pagination
          this.totalRecountCount = this.arPayloads.length;               
            if(this.totalRecountCount==0){
                this.page=0;                   
                this.showSpinner = false;;
                this.isDataNull = false;
                this.nodata = true;
                this.message = "Datos no encontrados";              
            }else{
                    console.log("this.arPayloads-->>", result.ar.Lineitems);
                    this.totalOverdue = result.totalOverdue;
                    this.finalTotal = result.totalOverdue + result.notYetDue;
                    this.finalTotalUSD = result.totalOverdue + result.notYetDue;
                    this.finalTotalCLP = result.totalOverdueCLP + result.notYetDueCLP;
                    this.notYetDue = result.notYetDue;
                    this.upto_0_30 = result.upto_0_30;
                    this.upto_31_60 = result.upto_31_60;
                    this.after_61 = result.after_61;
                    this.totalOverdueUSD = result.totalOverdue;
                    this.notYetDueUSD = result.notYetDue;
                    this.upto_0_30USD = result.upto_0_30;
                    this.upto_31_60USD = result.upto_31_60;
                    this.after_61USD = result.after_61;
                    this.totalOverdueCLP = result.totalOverdueCLP;
                    this.notYetDueCLP = result.notYetDueCLP;
                    this.upto_0_30CLP = result.upto_0_30CLP;
                    this.upto_31_60CLP = result.upto_31_60CLP;
                    this.after_61CLP = result.after_61CLP;
                    let filteredData;
                    if(this.documentStartDate != null || this.documentStartDate != undefined){
                    filteredData = this.arPayloads.filter((obj) => {
                        return (
                        obj.DocDate >= this.documentStartDate &&
                        obj.DocDate <= this.documentEndDate &&
                        obj.DueDate >= this.dueDateStart &&
                        obj.DueDate <= this.dueDateEnd
                        );
                    });
                    }else{
                    filteredData = this.arPayloads.filter((obj) => {
                        return (
                        obj.DocDate <= this.documentEndDate &&
                        obj.DueDate >= this.dueDateStart &&
                        obj.DueDate <= this.dueDateEnd
                        );
                    });
                    }
                    filteredData.sort(this.dynamicsort(this.sortBy,this.sortOrder));
                    this.tempRecords = filteredData;
                    //Below code is added by Akhilesh For Pagination
                    this.recordCount = this.tempRecords.length;
                    this.totalRecountCount = this.recordCount;
                    console.log('details in tempreords'+JSON.stringify(this.tempRecords));
                    this.page=1;                    
                    this.showSpinner = false;
                     this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
                this.data = this.tempRecords.slice(0, this.pageSize);
                this.rowNumberOffset = 0;
                this.endingRecord = this.pageSize;
                this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount)
                    ? this.totalRecountCount : (this.pageSize * this.page);

                this.error = undefined;  
            //Added by Akhilesh For Mobile data updation w.r.t search
            if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
                this.template.querySelector('c-responsive-card').tableData = this.data;
                this.template.querySelector('c-responsive-card').updateValues();
            }           
                    if (this.tempRecords.length > 0) {
                    this.isDataNull = true;
                    this.nodata = false;
                    this.generateFileURL();
                    } else {
                    this.isDataNull = false;
                    this.nodata = true;
                    this.message = "Datos no encontrados";
                    }
                    this.isLoading = false;
                    this.showBlock = true;
                    const event = new ShowToastEvent({
                    title: "Datos actualizados",
                    variant: "success",
                    });
                    this.dispatchEvent(event);
            }
        } else {
                this.isSuccess = false;
                this.nodata = true;
                this.message = "Erro en SAP";
                this.isLoading = false;
                this.showBlock = true;
            }
            });
        }, 100);        
  }
  handleChange(event) {
    if (event.target.value == "CLP") {
      this.totalOverdue = this.totalOverdueCLP;
      this.finalTotal = this.finalTotalCLP;
      this.notYetDue = this.notYetDueCLP;
      this.upto_0_30 = this.upto_0_30CLP;
      this.upto_31_60 = this.upto_31_60CLP;
      this.after_61 = this.after_61CLP;
    } else {
      this.totalOverdue = this.totalOverdueUSD;
      this.finalTotal = this.finalTotalUSD;
      this.notYetDue = this.notYetDueUSD;
      this.upto_0_30 = this.upto_0_30USD;
      this.upto_31_60 = this.upto_31_60USD;
      this.after_61 = this.after_61USD;
    }
  }
  handleARCancel() {
    this.showBlock = false;
    this.userInfoDiv = true;
    this.searchKeyBar = "";
    this.dueDate = "";
    this.sortBy ="DocDate";
    this.sortOrder = "Asc";
  }
  startDateChange(event) {
    this.documentStartDate = event.target.value;
    if (
      this.documentStartDate < this.fiscalyearStartDate ||
      this.documentStartDate > this.fiscalyearEndDate
    ) {
      this.notValidStartDate = true;
    } else {
      this.notValidStartDate = false;
    }
  }
  endDateChange(event) {
    this.documentEndDate = event.target.value;
    if (
      this.documentEndDate < this.fiscalyearStartDate ||
      this.documentEndDate > this.fiscalyearEndDate
    ) {
      this.notValidEndDate = true;
    } else {
      this.notValidEndDate = false;
    }
  }
  tostMsg(msg, type) {
    const event = new ShowToastEvent({
      title: msg,
      variant: type,
    });
    this.dispatchEvent(event);
  }
  onChangeSearch(event) {
     this.searchKeyBar = event.target.value;;
    if (this.validDueDates) {
      this.dateFilterData();
    } else {
      this.isDataNull = false;
      this.nodata = true;
      this.message = "Proporcione una fecha de vencimiento válida";
    }  
  }
  onSortChange(event) {
    let tarValue = event.target.value;
    var sortArray = tarValue.split("-");
   if (this.validDueDates) {
     this.sortBy = sortArray[0];
     this.sortOrder = sortArray[1];
     this.dateFilterData();
   } else {
     this.isDataNull = false;
     this.nodata = true;
     this.message = "Proporcione una fecha de vencimiento válida";
   }  
 }
  getDueDateStart(event) {
    this.dueDateStart = event.target.value;
    if (this.dueDateStart == null || this.dueDateEnd == null) {
      this.isDataNull = false;
      this.nodata = true;
      this.message = "Proporcione una fecha de vencimiento válida";
      this.validDueDates = false;
    } else {
      if (this.dueDateStart > this.dueDateEnd) {
        this.isDataNull = false;
        this.nodata = true;
        this.message =
          "La fecha de inicio no puede ser posterior a la fecha de finalización";
        this.validDueDates = false;
      } else {
        this.validDueDates = true;
        this.dateFilterData();
      }
    }
  }
  getDueDateEnd(event) {
    this.dueDateEnd = event.target.value;
    if (this.dueDateEnd == null || this.dueDateStart == null) {
      this.isDataNull = false;
      this.nodata = true;
      this.message = "Proporcione una fecha de vencimiento válida";
      this.validDueDates = false;
    } else {
      if (this.dueDateEnd < this.dueDateStart) {
        this.isDataNull = false;
        this.nodata = true;
        this.message =
          "La fecha de inicio no puede ser posterior a la fecha de finalización";
        this.validDueDates = false;
      } else {
        this.validDueDates = true;
        this.dateFilterData();
      }
    }
  }
  dateFilterData() {
    if (this.searchKeyBar == null) {
      this.searchKeyBar = "";
    }
   // var search = tempsearch;
    this.keySearch = this.searchKeyBar;
    let filteredData;
    if(this.documentStartDate == null || this.documentStartDate == undefined){
      filteredData = this.arPayloads.filter(
        (obj) =>
          obj.DocDate <= this.documentEndDate &&
          obj.DueDate >= this.dueDateStart &&
          obj.DueDate <= this.dueDateEnd &&
          obj.BillDoc &&
          obj.BillDoc.toLowerCase().includes(this.keySearch.toLowerCase())
      );
    }else{
      filteredData = this.arPayloads.filter(
        (obj) =>
          obj.DocDate >= this.documentStartDate &&
          obj.DocDate <= this.documentEndDate &&
          obj.DueDate >= this.dueDateStart &&
          obj.DueDate <= this.dueDateEnd &&
          obj.BillDoc &&
          obj.BillDoc.toLowerCase().includes(this.keySearch.toLowerCase())
      );
    }
    filteredData.sort(this.dynamicsort(this.sortBy,this.sortOrder));
    this.tempRecords = filteredData;
     //Added by Akhilesh For Mobile data updation w.r.t search
     if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
        console.log('In sorting mobile UI');
        this.data = this.tempRecords;
        this.recordCount = this.tempRecords.length;
        this.totalRecountCount = this.recordCount;
        console.log('details in tempreords pagination check'+JSON.stringify(this.tempRecords));
        if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
            this.getdata();//Pagination logic
        }
        
    }
    console.log('details in tempreords'+this.tempRecords);
    this.recordCount = this.tempRecords.length;
    console.log('Record Count'+this.recordCount);
    this.totalRecountCount = this.recordCount;//For Pagination
    console.log(this.tempRecords.length);
    if (this.recordCount > 0) {
      this.isDataNull = true;
      this.nodata = false;
      this.generateFileURL();
      //Added By Akhilesh For Pagination after Search Buscar cleared
      this.data=this.tempRecords;
      if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
        this.getdata();//Pagination logic
        }
    } else {
      this.isDataNull = false;
      this.nodata = true;
      this.message = "Datos no encontrados";
    }
  }
  dynamicsort(property,order) {
    var sort_order = 1;
    if(order === "Desc"){
        sort_order = -1;
    }
    return function (a, b){
        if(a[property] < b[property]){
            return -1 * sort_order;
        }else if(a[property] > b[property]){
            return 1 * sort_order;
        }else{
            return 0 * sort_order;
        }
    }
  }
  ARPDF() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 6000);
  }
  ARXLS() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 6000);
  }
  generateFileURL() {
    //if-else Added By Akhilesh to handle downloading on Standard Portal also
    this.urlLink = (window.location.href).split('/s/')[0];
    console.log('url ----->', this.urlLink);
    if(this.urlLink.includes('uplpartnerportalstd')){
        var pdfUrl = "/uplpartnerportalstd/apex/Grz_ARpdfDownloadChile?companyCode=";
        var xclUrl = "/uplpartnerportalstd/apex/Grz_ARxlsDownloadChile?companyCode=";
    }else{
        pdfUrl = "/uplpartnerportal/apex/Grz_ARpdfDownloadChile?companyCode=";
        xclUrl = "/uplpartnerportal/apex/Grz_ARxlsDownloadChile?companyCode=";
    }

    this.ARpdfURL = pdfUrl +
      this.companyCode +
      "&customerCode=" +
      this.CustomerCode +
      "&sapUserId=" +
      this.sapUserId +
      "&startDate=" +
      this.documentStartDate +
      "&endDate=" +
      this.documentEndDate +
      "&refSearch=" +
      this.keySearch +
      "&dueDateStart=" +
      this.dueDateStart +
      "&dueDateEnd=" +
      this.dueDateEnd+
      "&isInternal=" +
      this.isInternal;
    
      this.ARxlsURL = xclUrl +
      this.companyCode +
      "&customerCode=" +
      this.CustomerCode +
      "&sapUserId=" +
      this.sapUserId +
      "&startDate=" +
      this.documentStartDate +
      "&endDate=" +
      this.documentEndDate +
      "&refSearch=" +
      this.keySearch +
      "&dueDateStart=" +
      this.dueDateStart +
      "&dueDateEnd=" +
      this.dueDateEnd+
      "&isInternal=" +
      this.isInternal;
  }

  //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
  GetARPDFAsPDF(){
    this.callEmail(this.ARpdfURL, 'pdf');
  }
  GetARPDFAsXLS(){
    this.callEmail(this.ARxlsURL, 'xls');
  }
  
  callEmail(fileUrl,filetype){
    this.isSpinner = true;
    SendEMail({ 
      Url : fileUrl, 
      fileType : filetype,
      fileName : 'Estado de Cuenta',
      subjectName : 'Estado de Cuenta',
    });
    setTimeout(() => {
      this.isSpinner = false;
      this.tostMessage("Archivo adjunto enviado por correo electrónico.", "success");
    }, 3000);
  }
}