import {LightningElement, track, wire } from "lwc";
import getuserInfo from "@salesforce/apex/Grz_BrazilAccountReceivables.getuserInfo";
import getAccountReceivables from "@salesforce/apex/Grz_BrazilAccountReceivables.getAccountReceivables";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class Grz_AccountReceivables extends LightningElement {
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
  @track recordCount = 0;

  @track documentStartDate;
  @track documentEndDate;

  @track isLoading = false;
  @track isDataNull = false;
  @track showBlock = false;
  @track isSuccess = true;
  @track isSpinner = false;
  @track isProgressBar = false;
  @track ARxlsURL;
  @track ARpdfURL;
  @track notValidStartDate = false;
  @track notValidEndDate = false;
  @track selectedFiscalYear = 0;
  @track onLoadFiscalYear = "0";
  @track nodata = false;
  @track companyCode;
  @track sapUserId;
  @track customerSapCode;
  @track city;
  @track CustomerName;
  @track CustomerCode;

  @track arPayloads = [];
  @track tempRecords = [];
  @track totalOverdue;
  @track notYetDue;
  @track upto_0_30;
  @track upto_31_60;
  @track after_61;
  @track currentFiscalYear;

  @track isParentBr = false;
  @track isMainParent = false;//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track distributorOptionsBr = [];
  @track subGroupOption = [];//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track distributorValue = "All";
  @track subDistributor = '';//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track cstCity;
  @track validDueDates = true;
  @track message;
  @track overValue = "No";
  @track progress = 0;
  @track processStatus = 'In Progress';
  get overOptionsBr() {
    return [
      /*{ label: "Todos", value: "All" },*/
      { label: "Sim", value: "Yes" },
      { label: "Não", value: "No" }
    ];
  }
  handleOver(event) {
    this.overValue = event.detail.value;
  }
  renderedCallback() {
    if (this.recordCount >= 12) {
      this.template.querySelectorAll(".scbar-width").forEach((element) => {
        element.style.width = "101%";
      });
      this.template.querySelectorAll(".tabel-h").forEach((element) => {
        element.style.height = "485px";
      });
    } else {
      this.template.querySelectorAll(".scbar-width").forEach((element) => {
        element.style.width = "100%";
      });
      this.template.querySelectorAll(".tabel-h").forEach((element) => {
        element.style.height = "unset";
      });
    }
  }
  setData() {
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, "0");
    var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
    var yyyy = today.getFullYear();
    this.documentEndDate = yyyy + "-" + mm + "-" + dd;
    this.currentFiscalYear = today.getFullYear();
    this.documentStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
    this.fiscalyearStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
    this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
  }
  @wire(getuserInfo, {})
  fetchCustomerInfo(results) {
    if (results.data) {
      this.setData();
      this.companyCode = results.data.companyCode;
      this.sapUserId = results.data.sapUserId;
      this.customerSapCode = results.data.customerCode;
      this.City = results.data.city;
      this.CustomerName = results.data.name;
      this.CustomerCode = results.data.customerCode;
      this.isParentBr = results.data.isParentBr;
      this.isMainParent = results.data.isMainParent;
      this.cstCity = results.data.cstCity;
      if(this.isParentBr){
        let distr = results.data.cstrCode;
        if (distr.length > 0) {
          let cstCode = [];
          const opt = {
            label: "Todos",
            value: "All"
          };
          cstCode = [...cstCode, opt];
          for (let i = 0; i < distr.length; i++) {
            let arr = distr[i].split(' - ');//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
            const option = {
              label: arr[1].substr(0,20) + ' - ' + arr[2].substr(0,17) + ' - ' + arr[0].substr(arr[0].length - 7),//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.distributorOptionsBr = cstCode;
        }
      }
      //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      if(this.isMainParent){
        let distr = results.data.subGroupData;
        if (distr.length > 0) {
          let cstCode = [];
          for (let i = 0; i < distr.length; i++) {
            let arr = distr[i].split(' - ');
            const option = {
              label: arr[1].substr(0,20) + ' - ' + arr[2].substr(0,17) + ' - ' + arr[0].substr(arr[0].length - 7),
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.subGroupOption = cstCode;
        }
      }
      this.handleARSearch();
    }
    if (results.error) {
      console.log("Error==>", results.error);
    }
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
  handleDistributor(event) {
    this.distributorValue = event.target.value;
    this.subDistributor = '';//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  }
  //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  handleSubGroup(event) {
    this.distributorValue = "All";
    this.subDistributor = event.target.value;
  }
  handleARSearch() {
    this.searchKeyBar = "";
    this.tempRecords = [];
    this.isDataNull = false;
    this.arPayloads = [];
    if (this.documentStartDate != null && this.documentEndDate != null) {
      var start = new Date(this.documentStartDate);
      var end = new Date(this.documentEndDate);
       if (start > end) {
        const event = new ShowToastEvent({
          title: "A data de início não pode ser posterior à data de término",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.showBlock = false;
      } else if (this.notValidStartDate || this.notValidEndDate) {
        const event = new ShowToastEvent({
          title: "Insira uma data válida",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.showBlock = false;
      } else {
        this.isLoading = true;
        this.isProgressBar = true;
        this.progress = 0;
        this._interval = setInterval(() => {
          this.progress = this.progress + 5;
          this.processStatus = 'Buscando dados, aguarde';
          if(this.progress === 100) {
            this.progress = 0;
          }
        }, 500);
        this.dueDateStart = Number(this.currentFiscalYear) - 1 + "-01-01";
        this.dueDateEnd = Number(this.currentFiscalYear) + 1 + "-12-31";
        setTimeout(() => {
          getAccountReceivables({
            customerCode: this.CustomerCode,
            sapUserId: this.sapUserId,
            companyCode: this.companyCode,
            distributorValue: this.distributorValue,
            cstCity: this.cstCity,
            subGroupId: this.subDistributor//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
          }).then((result) => {
            if (result.isSuccess) {
              this.isSuccess = true;
              this.arPayloads = result.ar.Account_Receivables;
              this.totalOverdue = result.totalOverdue;
              this.notYetDue = result.notYetDue;
              this.upto_0_30 = result.upto_0_30;
              this.upto_31_60 = result.upto_31_60;
              this.after_61 = result.after_61;
              let filteredData = this.arPayloads.filter((obj) => {
                return (
                  obj.document_date_in_document >= this.documentStartDate &&
                  obj.document_date_in_document <= this.documentEndDate &&
                  obj.dueDate >= this.dueDateStart &&
                  obj.dueDate <= this.dueDateEnd
                );
              });
              filteredData.sort(this.dynamicsort('dueDate','Asc')); // GRZ(Nikhil Verma) : APPS-1394
              this.tempRecords = filteredData;
              this.recordCount = this.tempRecords.length;
              if (this.tempRecords.length > 0) {
                this.isDataNull = true;
                this.nodata = false;
                this.ARpdfURL =
                  "/uplpartnerportal/apex/Grz_ARpdfDownload?companyCode=" +
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
                  this.searchKeyBar +
                  "&dueDateStart=" +
                  this.dueDateStart +
                  "&dueDateEnd=" +
                  this.dueDateEnd +
                  "&distributorValue=" +
                  this.distributorValue + 
                  "&subGroupId=" +
                  this.subDistributor;//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022

                this.ARxlsURL =
                  "/uplpartnerportal/apex/Grz_ARxlsDownload?companyCode=" +
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
                  this.searchKeyBar +
                  "&dueDateStart=" +
                  this.dueDateStart +
                  "&dueDateEnd=" +
                  this.dueDateEnd +
                  "&distributorValue=" +
                  this.distributorValue + 
                  "&subGroupId=" +
                  this.subDistributor;//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
              } else {
                this.isDataNull = false;
                this.nodata = true;
                this.message = 'Nenhum dado encontrado';
              }
              this.isLoading = false;
              this.isProgressBar = false;
              clearInterval(this._interval);
              this.showBlock = true;
              const event = new ShowToastEvent({
                title: "Dados atualizados",
                variant: "success"
              });
              this.dispatchEvent(event);
            } else {
              this.isSuccess = false;
              this.isLoading = false;
              this.isProgressBar = false;
              clearInterval(this._interval);
              this.showBlock = true;
            }
          });
        }, 1000);
      }
    } else {
      const event = new ShowToastEvent({
        title: "A data não pode estar vazia",
        variant: "error"
      });
      this.dispatchEvent(event);
    }
  }
  handleARCancel() {
    this.showBlock = false;
    this.searchKeyBar = "";
    this.dueDate = "";
  }
  onChangeSearch(event) {
    this.searchKeyBar = event.target.value;
    if (this.validDueDates) {
      this.dateFilterData(this.dueDateStart, this.dueDateEnd, this.searchKeyBar);
    }else{
      this.isDataNull = false;
      this.nodata = true;
      this.message = 'Forneça uma data de vencimento válida';
    }
  }
  getDueDateStart(event) {
    this.dueDateStart = event.target.value;
    if(this.dueDateStart == null || this.dueDateStart == null){
      this.isDataNull = false;
      this.nodata = true;
      this.message = 'Forneça uma data de vencimento válida';
      this.validDueDates = false;
    }else{
      if(this.dueDateStart > this.dueDateEnd){
        this.isDataNull = false;
        this.nodata = true;
        this.message = 'A data de início não pode ser posterior à data final';
        this.validDueDates = false;
      }else{
        this.validDueDates = true;
        this.dateFilterData(this.dueDateStart, this.dueDateEnd, this.searchKeyBar);
      }
    }
  }
  getDueDateEnd(event) {
    this.dueDateEnd = event.target.value;  
    if(this.dueDateEnd == null || this.dueDateStart == null){
      this.isDataNull = false;
      this.nodata = true;
      this.message = 'Forneça uma data de vencimento válida';
      this.validDueDates = false;
    }else{
      if(this.dueDateEnd < this.dueDateStart){
        this.isDataNull = false;
        this.nodata = true;
        this.message = 'A data final não pode ser inferior à data de início';
        this.validDueDates = false;
      }else{
        this.validDueDates = true;
        this.dateFilterData(this.dueDateStart, this.dueDateEnd, this.searchKeyBar);
      }
    }
  }
  dateFilterData(dueStart, dueEnd, tempsearch){
    if(tempsearch == null){
      tempsearch = "";
    }
    let filteredData = this.arPayloads.filter((obj) =>
        obj.dueDate &&
        obj.dueDate >= dueStart &&
        obj.dueDate <= dueEnd &&
        obj.Reference_Document_Number &&
        obj.Reference_Document_Number.toLowerCase().includes(tempsearch.toLowerCase())
    );
    filteredData.sort(this.dynamicsort('dueDate','Asc')); // GRZ(Nikhil Verma) : APPS-1394
    this.tempRecords = filteredData;
    this.recordCount = this.tempRecords.length;
    if (this.recordCount > 0) {
      this.isDataNull = true;
      this.nodata = false;
      this.ARpdfURL =
        "/uplpartnerportal/apex/Grz_ARpdfDownload?companyCode=" +
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
         tempsearch +
        "&dueDateStart=" +
        this.dueDateStart +
        "&dueDateEnd=" +
        this.dueDateEnd +
        "&distributorValue=" +
        this.distributorValue + 
        "&subGroupId=" +
        this.subDistributor;//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022

      this.ARxlsURL =
        "/uplpartnerportal/apex/Grz_ARxlsDownload?companyCode=" +
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
        this.searchKeyBar +
        "&dueDateStart=" +
        this.dueDateStart +
        "&dueDateEnd=" +
        this.dueDateEnd +
        "&distributorValue=" +
        this.distributorValue + 
        "&subGroupId=" +
        this.subDistributor;//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    } else {
      this.isDataNull = false;
      this.nodata = true;
      this.message = 'Nenhum dado encontrado';
    }
  }
  ARPDF() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
  ARXLS() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }

  // for data sorting GRZ(Nikhil Verma) : APPS-1394
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
}