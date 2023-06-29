import { LightningElement, track, wire, api } from "lwc";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { NavigationMixin } from "lightning/navigation";
import Salesorders from "@salesforce/label/c.Grz_SalesOrder";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getSalesOrderRecord from "@salesforce/apex/Grz_SalesOrderListBrazil.getSalesOrderRecordBrazil";
import updateCheckbox from "@salesforce/apex/Grz_SalesOrderListBrazil.updateCheckbox";// Added to update user checkobx GRZ(Nikhil Verma) : APPS-1394
export default class Grz_SalesOrderListBrazil extends NavigationMixin(
  LightningElement
) {
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  @track searchKey = "";
 
  @api recordId;
  @track detailPageLink;
  Headertitle = Salesorders;
  @track pagenumber = 1;
  @track recordstart = 0;
  @track recordend = 0;
  @track totalpages = 1;
  @track totalrecords = 0;
  @track isLoading = false;
  @track currentpagenumber = 1;
  @track selectedFiscalYear = 0;
  @track onLoadFiscalYear = "0";
  @track pagesize = 20; //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track value = "All";
  @track invoicevalue = "All";
  @track isParentBr = false;
  @track distributorOptionsBr = [];
  @track distributorValue = "All";
  @track datevalue = "CreatedDate desc";
  @track picValueOptions;
  @track salesOrderList;
  @track error;
  @track SalesOrderxlsURL;
  @track SalesOrderpdfURL;
  @track startDate;
  @track endDate;
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;
  @track isSpinner = false;
  @track validStartDate;
  @track validEndDate;
  @track todayDate;
  @track salesNotification; isExternalUser;//GRZ(Nikhil Verma) : APPS-1394

  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track subGroupOption = [];
  @track isMainParent = false;
  @track pagesizeStr = "20";
  @track subDistributor = '';
  @track viewUndeliveredOrders = false;
  
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  get fiscalYearOptions() {
    return [
      { label: "Ano Fiscal Atual", value: "0" },
      { label: "Último Ano Fiscal", value: "1" }
    ];
  }
  get dateoptions() {
    return [
      { label: "Data de Criação - Desc", value: "CreatedDate desc" },
      { label: "Data de Criação - Asc", value: "CreatedDate asc" }
    ];
  }
   get invoiceoptions() {
     return [
      { label: "Todos", value: "All" },
      { label: "Pedido Faturado", value: "A" },
      { label: "Pedido em Processamento", value: "B" },
      { label: "Entrega prevista para", value: "Entrega prevista" },
      { label: "Entregue parcial em", value: "Entregue parcial" },//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      { label: "Entregue em", value: "Entregue em" }
    ];
  }
  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  get recordOption() {
    return [
      { label: "10", value: "10" },
      { label: "20", value: "20" },
      { label: "30", value: "30" },
      { label: "40", value: "40" },
      { label: "50", value: "50" }
    ];
  }
  
  connectedCallback() {
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, "0");
    var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
    var yyyy = today.getFullYear();
    this.endDate = yyyy + "-" + mm + "-" + dd;
    this.todayDate = yyyy + "-" + mm + "-" + dd;
    /*if (today.getMonth() + 1 <= 3) {
      this.currentFiscalYear = today.getFullYear() - 1;
    } else {
      this.currentFiscalYear = today.getFullYear();
    }*/
    this.currentFiscalYear = today.getFullYear();
    this.startDate = this.currentFiscalYear + "-01-01";
    this.fiscalyearStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
    this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
  }
  renderedCallback() {
    this.template.querySelectorAll(".testcss").forEach((but) => {
      but.style.backgroundColor =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "#F47920" : "white";
      but.style.color =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "white" : "black";
    });
  }
  @wire(getSalesOrderRecord, {
    searchKey: "$searchKey",
    datefilter: "$datevalue",
    sortby: "$value",
    pageNumber: "$pagenumber",
    pageSize: "$pagesize",
    startDate: "$startDate",
    endDate: "$endDate",
    distributor: "$distributorValue",
    invoicedata: "$invoicevalue",
    //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    subGroupId: "$subDistributor",
    viewUndeliveredOrders: "$viewUndeliveredOrders"
  })
  getSalesOrderRecord(result) {
    if (result.data) {
      this.salesOrderList = result.data.salesWrapList;
      if (this.salesOrderList.length == 0) {
        this.nodata = true;
      } else {
        this.nodata = false;
        this.SalesOrderpdfURL =
                  "/uplpartnerportal/apex/Grz_SalesOrderBrazilpdfDownload?searchKey=" +
                  this.searchKey +
                  "&datefilter=" +
                  this.datevalue +
                  "&sortby=" +
                  this.value +
                  "&startDate=" +
                  this.startDate +
                  "&endDate=" +
                  this.endDate +
                  "&distributor=" +
                  this.distributorValue +
                  "&invoicedata=" +
                  this.invoicevalue +
                  "&subGroupId=" +
                  this.subDistributor +
                  "&viewUndeliveredOrders=" +
                  this.viewUndeliveredOrders;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022

        this.SalesOrderxlsURL =
                  "/uplpartnerportal/apex/Grz_SalesOrderBrazilxlsDownload?searchKey=" +
                  this.searchKey +
                  "&datefilter=" +
                  this.datevalue +
                  "&sortby=" +
                  this.value +
                  "&startDate=" +
                  this.startDate +
                  "&endDate=" +
                  this.endDate +
                  "&distributor=" +
                  this.distributorValue +
                  "&invoicedata=" +
                  this.invoicevalue +
                  "&subGroupId=" +
                  this.subDistributor +
                  "&viewUndeliveredOrders=" +
                  this.viewUndeliveredOrders;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      }
      console.log("salesOrderList+++++ ", result.data);
      let allPicVal = result.data.picklistValues;
      let tempPicVal = [];
      const optionAll = {
        label: "Todos",
        value: "All"
      };
      tempPicVal.push(optionAll);
      for (let i = 0; i < allPicVal.length; i++) {
        const option = {
          label: allPicVal[i],
          value: allPicVal[i]
        };
        tempPicVal = [...tempPicVal, option];
      }
      this.isParentBr = result.data.isParentBr;
      this.isExternalUser = result.data.isExternalUser;
      this.salesNotification = result.data.salesNotification;
      this.isMainParent = result.data.isMainParent;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      if(this.isParentBr){
        let distr = result.data.cstrCode;
        if (distr.length > 0) {
          let cstCode = [];
          const opt = {
            label: "Todos",
            value: "All"
          };
          cstCode = [...cstCode, opt];
          for (let i = 0; i < distr.length; i++) {
            let arr = distr[i].split(' - ');
            const option = {
              label: arr[1].substr(0,13) + ' - ' + arr[2].substr(0,11) + ' - ' + arr[0].substr(arr[0].length - 7),//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.distributorOptionsBr = cstCode;
        }
      }
      //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      if(this.isMainParent){
        let subData = result.data.subGroupData;
        if (subData.length > 0) {
          let cstCode = [];
          for (let i = 0; i < subData.length; i++) {
            let arr = subData[i].split(' - ');
            const option = {
              label: arr[1].substr(0,13) + ' - ' + arr[2].substr(0,11) + ' - ' + arr[0].substr(arr[0].length - 7),
              value: subData[i].substr(0, subData[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.subGroupOption = cstCode;
        }
      }
      this.picValueOptions = tempPicVal;
      this.totalrecords = result.data.totalRecords;
      this.recordstart = result.data.RecordStart;
      this.recordend = result.data.RecordEnd;
      this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
      this.generatePageList(this.pagenumber, this.totalpages);
      this.isLoading = false;

    } else if (result.error) {
      this.error = result.error;
      console.log("---error----", this.error);
    }
  }

  // Added to update user checkobx GRZ(Nikhil Verma) : APPS-1394
  handleChangeCheckbox(event){
    this.salesNotification = event.target.checked;
    updateCheckbox({ 
      val: this.salesNotification 
    })
    .then(result => {
    })
  }
  startDateChange(event) {
    this.validStartDate = event.target.value;
    var isInvalid = false;
    if(this.validStartDate < this.fiscalyearStartDate || this.validStartDate > this.fiscalyearEndDate){     
      const event = new ShowToastEvent({
        title: "Insira uma data válida",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    } else if (this.validStartDate > this.validEndDate) {
      const event = new ShowToastEvent({
        title: "A data de início não pode ser posterior à data de término",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    } else if(this.validStartDate > this.todayDate){
      const event = new ShowToastEvent({
        title:
          "A data de início e a data de término devem ser menores que hoje",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    if(!isInvalid && this.validStartDate != this.startDate){
      this.startDate = this.validStartDate;
      this.isLoading = true;
      this.pagenumber = 1;
    }else{
      event.target.value = this.startDate;
    } 
  }
  endDateChange(event) {
    this.validEndDate = event.target.value;

    var isInvalid = false;

    if(this.validEndDate < this.fiscalyearStartDate || this.validEndDate > this.fiscalyearEndDate){     
      const event = new ShowToastEvent({
        title: "Insira uma data válida",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }else if(this.validEndDate > this.todayDate){
      const event = new ShowToastEvent({
        title:
          "A data de início e a data de término devem ser menores que hoje",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    else if(this.validEndDate < this.validStartDate){
      const event = new ShowToastEvent({
        title:
          "A data de término não pode ser anterior à data de início",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
    }
    if(!isInvalid && this.endDate != this.validEndDate){
      this.endDate = this.validEndDate;
      this.isLoading = true;
      this.pagenumber = 1;
    } 
    else{
      event.target.value = this.endDate;
    }
    //this.endDate = event.target.value;
  }
  handleChange(event) {
    this.isLoading = true;
    this.value = event.detail.value;
  }
  handleDistributor(event) {
    this.isLoading = true;
    this.distributorValue = event.target.value;
    this.subDistributor = '';
    this.pagenumber = 1;
  }
//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  handleCheckboxChange(event){
    this.isLoading = true;
    var check = event.target.checked;
    if(check){
      this.viewUndeliveredOrders = true;
    }else{
      this.viewUndeliveredOrders = false;
    }
    this.invoicevalue = "All";
    this.pagenumber = 1;
  }

  handleSubGroup(event) {
    this.isLoading = true;
    this.distributorValue = "All";
    this.subDistributor = event.target.value;
    this.pagenumber = 1;
  }
  // End-----GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022

  handleChangeDate(event) {
    this.isLoading = true;
    this.datevalue = event.detail.value;
  }
    handleChangeinvoice(event) {
    this.isLoading = true;
    this.invoicevalue = event.detail.value;
    //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    this.viewUndeliveredOrders = false;
    this.pagenumber = 1;
  }
  handleFiscalYearChange(event) {
    this.isLoading = true;
    this.onLoadFiscalYear = event.detail.value;
    this.selectedFiscalYear = event.detail.value;
  }
  handleKeyChange(event) {
    var code = event.keyCode ? event.keyCode : event.which;
    if (code != 13) {
      return;
    }
    if (this.searchKey != event.target.value) {
      this.searchKey = event.target.value;
      this.isLoading = true;
    }
    if (this.searchKey == "") {
      this.isLoading = false;
    }
    this.pagenumber = 1;
  }
  clearClick(event) {
    this.isLoading = true;
    this.searchKey = "";
  }
  handleOrderDetail(event) {
    this.recordId = event.currentTarget.dataset.value;
    this.detailPageLink = "sales-order/" + this.recordId;
  }
  buttonClick() {
    if (
      this.searchKey != this.template.querySelector("lightning-input").value
    ) {
      this.searchKey = this.template.querySelector("lightning-input").value;
      this.isLoading = true;
      this.pagenumber = 1;
    }
  }
  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  handleRecordPerPage(event) {
    this.pagesize = parseInt(event.detail.value);
    this.pagesizeStr = event.detail.value;
    this.isLoading = true;
    this.pagenumber = 1;
  }
  handleFirst(event) {
    this.isLoading = true;
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
      this.isLoading = true;
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
    this.isLoading = true;
    this.pagenumber--;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }
  handleNext(event) {
    this.isLoading = true;
    this.pagenumber = this.pagenumber + 1;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }
  handleLast(event) {
    this.isLoading = true;
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
  };
  SalesOrderPDF() {
    //window.location.href = this.ARpdfURL;
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
  SalesOrderXLS() {
    //window.location.href = this.ARxlsURL;
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 4000);
  }
}