import {LightningElement, track, wire } from "lwc";
import getStockData from "@salesforce/apex/grz_StockManagement.getStockData";
import updateCheckbox from "@salesforce/apex/grz_StockManagement.updateCheckbox";// Added to update user checkobx GRZ(Nikhil Verma) : APPS-1394
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class Grz_LiquidityAndStockManagementBrazil extends LightningElement {
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  green = Icons + "/Grz_Resourse/Images/greenlight.png";
  red = Icons + "/Grz_Resourse/Images/redlight.png";
  @track searchKeyProduct = "";
  @track searchKeyLote = "";
  @track productChange = "";
  @track loteChange = "";
  @track pagenumber = 1;
  @track recordstart = 0;
  @track recordend = 0;
  @track totalpages = 1;
  @track totalrecords = 0;
  @track isLoading = true;
  @track nodata = false;
  @track isSpinner = false;
  @track error;
  @track stockList;
  @track typevalue = "No";
  @track isParentBr = false;
  @track distributorOptionsBr = [];
  @track distributorValue = "All";
  @track dueDate = "";
  @track endDate = "";
  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  @track pagesize = 20;
  @track pagesizeStr = "20";
  @track clientName = "All";
  @track isMainParent = false;
  @track subGroupOption = [];
  @track subDistributor = '';
  @track options;
  @track nameAndCity;
  @track tempXlsUrl;
  @track inventryNotification; isExternalUser;//GRZ(Nikhil Verma) : APPS-1394

  get recordOption() {
    return [
      { label: "10", value: "10" },
      { label: "20", value: "20" },
      //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      { label: "30", value: "30" },
      { label: "40", value: "40" },
      { label: "50", value: "50" }
    ];
  }
  get picValueOptions() {
    return [
      //{ label: "Todos", value: "All" },
      { label: "Sim", value: "Yes" },
      { label: "Não", value: "No" }
    ];
  }
  connectedCallback() {
    var today = new Date();
    this.currentFiscalYear = today.getFullYear();
    this.dueDate = Number(this.currentFiscalYear) -1 + "-01-01";
    this.endDate = Number(this.currentFiscalYear) +2 + "-12-31";
    //this.fiscalyearStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
    //this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
  }
  renderedCallback() {
    this.template.querySelectorAll(".testcss").forEach((but) => {
      but.style.backgroundColor =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "#F47920" : "white";
      but.style.color =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "white" : "black";
    });
  }
  @wire(getStockData, {
    pageNumber: "$pagenumber",
    pageSize: "$pagesize",
    product: "$searchKeyProduct",
    lote: "$searchKeyLote",
    dueDate: "$dueDate",
    endDate: "$endDate",
    type: "$typevalue",
    //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    distributor:"$distributorValue",
    clientCityAndName:"$clientName",
    subGroupId: "$subDistributor"
  })
  getStockData(result) {
    if (result.data) {
      //console.log("===stock data => ", result.data);
      this.stockList = result.data.stockWrapList;
      //alert('this.stockList:'+this.stockList);
       this.tempXlsUrl =
      "/uplpartnerportal/apex/grz_StockManagementXLSVF?product=" +
      this.searchKeyProduct +
      "&batch=" +this.searchKeyLote +
      "&dueDate=" +this.dueDate +
      "&endDate=" +this.endDate +
      "&type=" +this.typevalue +
      "&distributor=" +this.distributorValue +
      "&nameAndCity=" +this.clientName +
      "&subGroupId=" + this.subDistributor;
      //alert(' this.tempXlsUrl:'+ this.tempXlsUrl);
      this.totalrecords = result.data.totalRecords;
      this.recordstart = result.data.RecordStart;
      this.recordend = result.data.RecordEnd;
      this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
      this.isParentBr = result.data.isParentBr;
      this.isMainParent = result.data.isMainParent;
      this.nameAndCity = result.data.clientNameAndCity;
      this.inventryNotification=result.data.inventryNotification;
      this.isExternalUser = result.data.isExternalUser;
      let lstOption = [];
      const opt = {
        label: "Todos",
        value: "All"
      };
      lstOption = [...lstOption, opt];
      for (var i = 0; i <  this.nameAndCity.length; i++) {
        let arr = this.nameAndCity[i].split(' | ');
        const option = {
          label: arr[0].substr(0,27) + ' | ' + arr[1].substr(0,16),
          value: this.nameAndCity[i]
        };
        lstOption = [...lstOption, option];
      }
        this.options = lstOption;
      if(this.isParentBr){
        let distr = result.data.taxMap;
          let cstCode = [];
          const opt = {
            label: "Todos",
            value: "All"
          };
          cstCode = [...cstCode, opt];
          for (let i = 0; i < distr.length; i++) {
            let arr = distr[i].split(' - ');
            const option = {
              label: arr[2].substr(0,20) + ' - ' + arr[3].substr(0,14)  + ' - ' + arr[1].substr(arr[1].length - 7),//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
          }
          this.distributorOptionsBr = cstCode;
      }
      //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
      if(this.isMainParent){
        let distr = result.data.subGroupData;
          let cstCode = [];
          for (let i = 0; i < distr.length; i++) {
            let arr = distr[i].split(' - ');
            const option = {
              label: arr[2].substr(0,20) + ' - ' + arr[3].substr(0,14) + ' - ' + arr[1].substr(arr[1].length - 7),
              value: distr[i].substr(0, distr[i].indexOf(' -'))
            };
            cstCode = [...cstCode, option];
        }
        this.subGroupOption = cstCode;
      }
      this.generatePageList(this.pagenumber, this.totalpages);
      if (this.stockList.length == 0) {
        this.nodata = true;
      } else {
        this.nodata = false;
      }
      this.isLoading = false;
    } else if (result.error) {
      this.error = result.error;
      console.log("---error----", this.error);
    }
  }
// Added to update user checkobx GRZ(Nikhil Verma) : APPS-1394
  handleChangeCheckbox(event){
    this.inventryNotification = event.target.checked;
    updateCheckbox({ 
      val: this.inventryNotification 
    })
    .then(result => {
    })
  }
  handleRecordPerPage(event) {
    this.pagesize = parseInt(event.detail.value);
    this.pagesizeStr = event.detail.value;
    this.isLoading = true;
    this.pagenumber = 1;
  }
  handleDistributor(event) {
    this.isLoading = true;
    this.distributorValue = event.target.value;
    this.subDistributor = '';//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    this.pagenumber = 1;
  }
  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  handleSubGroup(event) {
    this.isLoading = true;
    this.distributorValue = "All";
    this.subDistributor = event.target.value;
    this.pagenumber = 1;
  }
  handleChange(event) {
    this.typevalue = event.detail.value;
    this.isLoading = true;
    this.pagenumber = 1;
  }
  //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
  handleChangeClinteName(event) {
    this.clientName = event.detail.value;
    this.isLoading = true;
    this.pagenumber = 1;
  }
  handleDueDate(event) {
    this.validStartDate = event.target.value;
    var isInvalid = false;
    if (this.validStartDate > this.endDate) {
      const event = new ShowToastEvent({
        title: "A data de início não pode ser posterior à data de término",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
      this.dueDate = this.dueDate;
    }

    if(!isInvalid && this.dueDate != this.validStartDate){
      this.dueDate = this.validStartDate;
      this.isLoading = true;
      this.pagenumber = 1;
    }else{
      event.target.value = this.dueDate;
    } 
  }
  endDateChange(event) {
    this.validEndDate = event.target.value;
    var isInvalid = false;
    if(this.validEndDate < this.dueDate){
      const event = new ShowToastEvent({
        title:
          "A data de término não pode ser inferior à data de início",
        variant: "error"
      });
      this.dispatchEvent(event);
      isInvalid = true;
      
    }
    if(!isInvalid && this.endDate != this.validEndDate){
      this.endDate = this.validEndDate;
      this.isLoading = true;
      this.pagenumber = 1;
    } else{
      event.target.value = this.endDate;
    }
  }
  handleProductKeyChange(event) {
    var code = event.keyCode ? event.keyCode : event.which;
    if (code != 13) {
      return;
    }
    if (this.searchKeyProduct != event.target.value) {
      this.searchKeyProduct = event.target.value;
      this.isLoading = true;
    }
    if (this.searchKeyProduct == "") {
      this.isLoading = false;
    }
    this.pagenumber = 1;
  }
  prochange(event) {
    this.productChange = event.target.value;
  }
  clearClickProduct(event) {
    this.isLoading = true;
    this.searchKeyProduct = "";
    this.productChange = "";
  }
  buttonClickProduct() {
    if (this.searchKeyProduct != this.productChange) {
      this.searchKeyProduct = this.productChange;
      this.isLoading = true;
      this.pagenumber = 1;
    }
  }
  handleLoteKeyChange(event) {
    var code = event.keyCode ? event.keyCode : event.which;
    if (code != 13) {
      return;
    }
    if (this.searchKeyLote != event.target.value) {
      this.searchKeyLote = event.target.value;
      this.isLoading = true;
    }
    if (this.searchKeyLote == "") {
      this.isLoading = false;
    }
    this.pagenumber = 1;
  }
  lotechange(event) {
    this.loteChange = event.target.value;
  }
  clearClickLote(event) {
    this.isLoading = true;
    this.searchKeyLote = "";
    this.loteChange = "";
  }
  buttonClickLote(event) {
    if (this.searchKeyLote != this.loteChange) {
      this.searchKeyLote = this.loteChange;
      this.isLoading = true;
      this.pagenumber = 1;
    }
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

  xlsOnClick(){
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 3000);
  }
}