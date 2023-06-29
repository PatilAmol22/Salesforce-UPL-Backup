import { api, LightningElement, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import detailsLabel from "@salesforce/label/c.Grz_AccountInformation";
import { loadStyle } from "lightning/platformResourceLoader";
import getAccountStatement from "@salesforce/apex/Grz_BrazilAccountLedgerStatement.getAccountStatement";
import getLedgerStatement from "@salesforce/apex/Grz_BrazilAccountLedgerStatement.getLedgerStatement";
import getAccInfo from "@salesforce/apex/Grz_BrazilAccountLedgerStatement.getAccInfo";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import LANG from "@salesforce/i18n/lang";

const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
const ACC_SCROLL_TABLE_CLASS = "acc-table-data-scroll";
const ACC_NO_SCROLL_TABLE_CLASS = "acc-table-no-scroll";
export default class Grz_BrazilAccountLedgerComponent extends NavigationMixin(
  LightningElement
) {
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
  filterIcon = Icons + "/Grz_Resourse/Images/FilterIcon.png";
  Headlabel = {
    detailsLabel
  };
  @track language = LANG;
  @track companyCode;

  @track statementType = "Both";

  @track endDate;
  @track startDate;
  @track accNoRecordError = false;
  @track ledgerNoRecordError = false;
  @track isSpinner = false;
  queryTerm;
  @track lstOptions = [];
  @track ledgerTableScroll;
  @track accTableScroll;
  /*For Ledger*/
  @track ledgerData;
  @track showLedgerTable = false;
  @track displayPDF = false;
  @track totalCredit;
  @track totalDebit;
  @track openingBal;
  @track closingBal;
  @track ledgerURL;
  @track ledgerDocType;
  @track accDocType;

  @track listOfSearchRecords = [];
  @track SearchKeyWord = "";
  @track AccStatementData;
  @track showAccountStatementTable = false;
  @track openingNegativeBalance = false;
  @track openingPositiveBalance = false;
  @track closingNegativeBalance = false;
  @track closingPositiveBalance = false;
  @track accTotalCredit;
  @track accTotalDebit;
  @api lstSelectedRecords = [];
  @track selecteditem = [];
  @track allDocType;
  @track accStatementURL;
  @track YearOptions = [];

  @track customerSapCode;

  @track fiscalYear;
  @track fiscalYearFrom;
  @track fiscalYearTo;

  @track yearType;
  @track isCredit = true;
  @track isDebit = true;

  @track docCol1;
  @track docCol2;
  @track docCol3;
  @track docCol4;
  @track docCol5;

  @track currentFiscalYear;
  @track fiscalyearStartDate;
  @track fiscalyearEndDate;
  @track customerSap;
  @track customerSapAcc;
  @track ledgerYearType;
  @track LedgerYearOptions = [];
  @track quaterType = "1";
  @track ledgerFiscalYear;
  @track ledgerFiscalYearFrom = "1";
  @track ledgerFiscalYearTo = "3";
  @track displayLedgerStatement;
  @track displayAccountStatement;
  @track ledgerCustInfo = [];
  @track accountCustInfo = [];
  @track isCstAvl = false;
  @track isAccCstAvl = false;

  working() {
    var today = new Date();
    this.endDate = today.toISOString();
    var last30days = new Date(today.setDate(today.getDate() - 30));
    this.startDate = last30days.toISOString();
    if (today.getMonth() + 1 <= 3) {
      this.currentFiscalYear = today.getFullYear() - 1;
    } else {
      this.currentFiscalYear = today.getFullYear();
    }
    this.fiscalyearStartDate = this.currentFiscalYear + "-04-01";
    this.fiscalyearEndDate = Number(this.currentFiscalYear) + 1 + "-03-31";
  }
  renderedCallback() {
    Promise.all([loadStyle(this, Icons + "/Grz_Resourse/CSS/SummaryTabs.css")]);
  }
  @wire(getAccInfo)
  uplAccStatment(results) {
    if (results.data) {
      this.working();
      this.allDocType = results.data.docTypeInfo;
      let l1 = [];
      let l2 = [];
      let l3 = [];
      let l4 = [];
      let s = Math.floor(this.allDocType.length / 4);
      for (let i = 0; i < this.allDocType.length; i++) {
        if (l1.length < s) {
          l1.push(this.allDocType[i]);
        } else if (l2.length < s) {
          l2.push(this.allDocType[i]);
        } else if (l3.length < s) {
          l3.push(this.allDocType[i]);
        } else {
          l4.push(this.allDocType[i]);
        }
      }
      this.docCol1 = l1;
      this.docCol2 = l2;
      this.docCol3 = l3;
      this.docCol4 = l4;
      let yearArr = [];
      for (let i = 0; i <= 1; i++) {
        const option = {
          label: String(Number(this.currentFiscalYear) - i),
          value: String(Number(this.currentFiscalYear) - i)
        };
        yearArr = [...yearArr, option];
      }
      this.LedgerYearOptions = yearArr;
      this.ledgerYearType = String(this.currentFiscalYear);
      this.ledgerFiscalYear = this.ledgerYearType;
      //this.QuaterOptionsBr;
      this.YearOptions = yearArr;
      this.yearType = String(this.currentFiscalYear);
      this.fiscalYear = this.yearType;
      let accDocInfo = [];
      for (let i = 0; i < this.allDocType.length; i++) {
        const option = {
          label: this.allDocType[i].Short_Form__c,
          value: this.allDocType[i].Short_Form__c
        };
        accDocInfo = [...accDocInfo, option];
      }
      this.lstOptions = accDocInfo;
    }
    if (results.error) {
      this.error = results.error;
    }
  }
  get QuaterOptionsBr() {
    var b = Number(this.ledgerFiscalYear) + 1;
    return [
      { label: "Abril-junho(" + this.ledgerFiscalYear + ")", value: "1" },
      { label: "Julho-setembro(" + this.ledgerFiscalYear + ")", value: "2" },
      { label: "Outubro-dezembro(" + this.ledgerFiscalYear + ")", value: "3" },
      { label: "Janeiro-Março(" + b + ")", value: "4" }
    ];
  }
  handleLedgerActive() {
    this.displayAccountStatement = false;
    this.displayLedgerStatement = true;
  }
  onChangeSAP(event) {
    this.customerSap = event.target.value;
  }
  handleLedgerYearOption(event) {
    this.ledgerYearType = event.detail.value;
    this.ledgerFiscalYear = this.ledgerYearType;
    QuaterOptionsBr();
  }
  handleQuaterOption(event) {
    this.quaterType = event.detail.value;
    if (this.quaterType == "1") {
      this.ledgerFiscalYearFrom = "1";
      this.ledgerFiscalYearTo = "3";
    } else if (this.quaterType == "2") {
      this.ledgerFiscalYearFrom = "4";
      this.ledgerFiscalYearTo = "6";
    } else if (this.quaterType == "3") {
      this.ledgerFiscalYearFrom = "7";
      this.ledgerFiscalYearTo = "9";
    } else if (this.quaterType == "4") {
      this.ledgerFiscalYearFrom = "10";
      this.ledgerFiscalYearTo = "12";
    }
  }
  handleGetLedgerClick(event) {
    this.showLedgerTable = false;
    if (this.customerSap != undefined && this.customerSap != "") {
      this.isSpinner = true;
      console.log("ledgerFiscalYear---", this.ledgerFiscalYear);
      console.log("ledgerFiscalYearFrom --- ", this.ledgerFiscalYearFrom);
      console.log("ledgerFiscalYearTo --- ", this.ledgerFiscalYearTo);
      console.log("customerSap --- ", this.customerSap);
      getLedgerStatement({
        customerCode: this.customerSap,
        fiscalYear: this.ledgerFiscalYear,
        fiscalYearFrom: this.ledgerFiscalYearFrom,
        fiscalYearTo: this.ledgerFiscalYearTo,
        getDoc: true
      }).then((result) => {
        if (result.noDistributor) {
          const event = new ShowToastEvent({
            title: "Distribuidor não encontrado",
            variant: "error"
          });
          this.dispatchEvent(event);
          this.isCstAvl = false;
          this.ledgerNoRecordError = false;
          this.isSpinner = false;
        } else {
          if (result.isSuccess == false) {
            const event = new ShowToastEvent({
              title: result.msg,
              variant: "error"
            });
            this.dispatchEvent(event);
            this.isSpinner = false;
            this.isCstAvl = false;
            this.ledgerNoRecordError = false;
          } else if (result.isSuccess == true) {
            if (result.isSAPSuccess) {
              window.console.log("result ====> ", result);
              this.ledgerCustInfo = [];
              this.ledgerCustInfo.push(result.customerInfo);
              var csCode = result.customerInfo.CustomerCode;
              if (csCode != "" && csCode != undefined) {
                this.isCstAvl = true;
              } else {
                this.isCstAvl = false;
              }
              this.totalCredit = result.totalCredit;
              this.totalDebit = result.totalDebit;
              this.openingBal = result.customerInfo.OpeningBalance;
              this.closingBal = result.customerInfo.ClosingBalance;
              this.ledgerDocType = result.MetaDocType;
              if (
                this.closingBal.includes("-") &&
                this.openingBal.includes("-")
              ) {
                this.openingNegativeBalance = true;
                this.openingPositiveBalance = false;
                this.closingNegativeBalance = true;
                this.closingPositiveBalance = false;
                this.closingBal = this.closingBal.replace("-", "");
                this.openingBal = this.openingBal.replace("-", "");
              } else {
                this.openingNegativeBalance = false;
                this.openingPositiveBalance = true;
                this.closingNegativeBalance = false;
                this.closingPositiveBalance = true;
              }
              if (
                this.openingBal.includes("-") &&
                !this.closingBal.includes("-")
              ) {
                this.openingNegativeBalance = true;
                this.openingPositiveBalance = false;
                this.closingNegativeBalance = false;
                this.closingPositiveBalance = true;
                this.openingBal = this.openingBal.replace("-", "");
              } else if (
                !this.openingBal.includes("-") &&
                this.closingBal.includes("-")
              ) {
                this.openingNegativeBalance = false;
                this.openingPositiveBalance = true;
                this.closingNegativeBalance = true;
                this.closingPositiveBalance = false;
                this.closingBal = this.closingBal.replace("-", "");
              }
              this.ledgerData = result.ItemInfo;
              if (this.ledgerData.length > 12) {
                this.ledgerTableScroll = SCROLL_TABLE_CLASS;
              } else {
                this.ledgerTableScroll = NO_SCROLL_TABLE_CLASS;
              }
              if (this.ledgerData.length == 0) {
                this.ledgerNoRecordError = true;
                this.showLedgerTable = false;
              } else {
                this.ledgerNoRecordError = false;
                this.showLedgerTable = true;
              }
              this.isSpinner = false;
              this.ledgerURL =
                "/uplpartnerportal/apex/Grz_BrazilLedgerStatementDownload?fiscalYear=" +
                this.ledgerFiscalYear +
                "&customerCode=" +
                this.customerSap +
                "&fiscalYearFrom=" +
                this.ledgerFiscalYearFrom +
                "&fiscalYearTo=" +
                this.ledgerFiscalYearTo;
            } else {
              const event = new ShowToastEvent({
                title: "Erro no SAP",
                variant: "error"
              });
              this.dispatchEvent(event);
              this.isSpinner = false;
              this.isCstAvl = false;
              this.ledgerNoRecordError = false;
            }
          }
        }
      });
    } else {
      const event = new ShowToastEvent({
        title: "O número do cliente não pode estar vazio",
        variant: "error"
      });
      this.dispatchEvent(event);
      this.isSpinner = false;
    }
  }
  handleAccountActive() {
    this.displayAccountStatement = true;
    this.displayLedgerStatement = false;
    if (this.lstSelectedRecords.length > 0) {
      this.lstSelectedRecords = "";
    }
  }
  get StatementOptions() {
    return [
      { label: "Ambos", value: "Both" },
      { label: "Crédito", value: "Credit" },
      { label: "Débito", value: "Debit" }
    ];
  }
  handleResetFilter() {
    this.yearType = String(this.currentFiscalYear);
    this.customerSapAcc = "";
    this.isAccCstAvl = false;
    this.accNoRecordError = false;
    var today = new Date();
    this.endDate = today.toISOString();
    var last30days = new Date(today.setDate(today.getDate() - 30));
    this.startDate = last30days.toISOString();
    this.statementType = "Both";
    this.showAccountStatementTable = false;
    this.listOfSearchRecords = [];
    if (this.lstSelectedRecords.length > 0) {
      this.lstSelectedRecords = "";
    }
    if (this.lstSelectedRecords.length == 0) {
      this.template
        .querySelector('[data-id="defaultValue1"]')
        .classList.remove("hidedefaultvalue");
    }
  }
  searchHelper(SearchKeyWord) {
    var excludeitemsList = this.lstSelectedRecords;
    var excludeitemsListValues = [];
    for (var i = 0; i < excludeitemsList.length; i++) {
      excludeitemsListValues.push(excludeitemsList[i].value);
    }
    var searchList = [];
    var searchList1 = [];
    if (SearchKeyWord.length > 0) {
      var term = SearchKeyWord.toLowerCase();
    }
    var listOfOptions = this.lstOptions;
    for (var i = 0; i < listOfOptions.length; i++) {
      var option = listOfOptions[i].label.toLowerCase();
      if (
        option.indexOf(term) !== -1 &&
        excludeitemsListValues.indexOf(listOfOptions[i].value) < 0
      ) {
        searchList.push(listOfOptions[i]);
      }
      if (!term && excludeitemsListValues.indexOf(listOfOptions[i].value) < 0) {
        searchList1.push(listOfOptions[i]);
      }
    }
    this.template
      .querySelector('[data-id="mySpinner"]')
      .classList.add("slds-show");
    this.listOfSearchRecords = searchList;
    if (!term) {
      this.listOfSearchRecords = searchList1;
    }
  }
  onblurclick() {
    this.listOfSearchRecords = [];
    this.SearchKeyWord = "";
    this.template.querySelector(".searchRes").classList.add("slds-is-close");
    this.template.querySelector(".searchRes").classList.remove("slds-is-open");
  }
  keyPressController(event) {
    debugger;
    this.template
      .querySelector('[data-id="mySpinner"]')
      .classList.add("slds-show");
    this.SearchKeyWord = event.target.value;

    if (this.SearchKeyWord.length > 0 && this.SearchKeyWord.length <= 2) {
      this.template.querySelector(".searchRes").classList.add("slds-is-open");
      this.template
        .querySelector(".searchRes")
        .classList.remove("slds-is-close");
      this.searchHelper(this.SearchKeyWord);
    } else {
      this.listOfSearchRecords = [];
      this.template.querySelector(".searchRes").classList.add("slds-is-close");
      this.template
        .querySelector(".searchRes")
        .classList.remove("slds-is-open");
    }
  }
  clear(event) {
    var selectedPillId = event.target.name;
    var AllPillsList = this.lstSelectedRecords;
    var removepilllist = [];
    for (var i = 0; i < AllPillsList.length; i++) {
      removepilllist.push(AllPillsList[i]);
    }
    for (var i = 0; i < removepilllist.length; i++) {
      if (removepilllist[i].value == selectedPillId) {
        removepilllist.splice(i, 1);
        this.lstSelectedRecords = removepilllist;
      }
    }
    if (this.lstSelectedRecords.length == 0) {
      this.template
        .querySelector('[data-id="defaultValue1"]')
        .classList.remove("hidedefaultvalue");
    }
    this.listOfSearchRecords = [];
    this.SearchKeyWord = "";
  }
  selectRecord(event) {
    this.template
      .querySelector('[data-id="defaultValue1"]')
      .classList.add("hidedefaultvalue");
    this.SearchKeyWord = "";
    var selectedItem = event.currentTarget.dataset.value;
    var selectedItem2 = event.currentTarget.dataset.label;
    var includeitemsList = this.lstSelectedRecords;
    var listselecteditems = [];

    for (var i = 0; i < includeitemsList.length; i++) {
      listselecteditems.push(includeitemsList[i]);
    }
    listselecteditems.push({ label: selectedItem2, value: selectedItem });

    this.lstSelectedRecords = listselecteditems;
    this.template
      .querySelector('[data-id="lookup-pill"]')
      .classList.add("slds-show");
    this.template
      .querySelector('[data-id="lookup-pill"]')
      .classList.remove("slds-hide");

    this.template.querySelector(".searchRes").classList.add("slds-is-close");
    this.template.querySelector(".searchRes").classList.remove("slds-is-open");
  }

  handleYearOption(event) {
    this.yearType = event.detail.value;
    this.fiscalYear = this.yearType;
    this.fiscalyearStartDate = this.fiscalYear + "-04-01";
    this.fiscalyearEndDate = Number(this.fiscalYear) + 1 + "-03-31";
    this.startDate = this.fiscalyearStartDate;
    this.endDate = this.fiscalyearEndDate;
  }
  handleStatementOption(event) {
    this.statementType = event.detail.value;
  }
  handleKeyUp(event) {
    const isEnterKey = event.keyCode === 13;
    if (isEnterKey) {
      this.queryTerm = event.target.value;
    }
  }
  onChangeSAPAcc(event) {
    this.customerSapAcc = event.target.value;
  }
  startdateChange(event) {
    this.startDate = event.target.value;
    if (
      this.startDate < this.fiscalyearStartDate ||
      this.startDate > this.fiscalyearEndDate
    ) {
      this.notValidStartDate = true;
    } else {
      this.notValidStartDate = false;
    }
  }
  enddateChange(event) {
    this.endDate = event.target.value;
    if (
      this.endDate < this.fiscalyearStartDate ||
      this.endDate > this.fiscalyearEndDate
    ) {
      this.notValidEndDate = true;
    } else {
      this.notValidEndDate = false;
    }
  }

  handleGetStatementClick(event) {
    this.showAccountStatementTable = false;
    if (this.customerSapAcc != undefined && this.customerSapAcc != "") {
      this.isSpinner = true;
      var listselecteditems = [];
      if (this.lstSelectedRecords.length != 0) {
        for (var i = 0; i < this.lstSelectedRecords.length; i++) {
          listselecteditems.push(this.lstSelectedRecords[i].value);
        }
      }
      var start = new Date(this.startDate.slice(0, 10));
      var end = new Date(this.endDate);
      var today = new Date();
      var StartThreeMon = new Date(this.startDate);
      StartThreeMon.setMonth(StartThreeMon.getMonth() + 3);
      StartThreeMon.setDate(StartThreeMon.getDate() - 1);
      var threemonStart = StartThreeMon.toISOString().slice(0, 10);
      var EndThreeMon = new Date(this.endDate);
      EndThreeMon.setMonth(EndThreeMon.getMonth() - 3);
      var threemonEnd = EndThreeMon.toISOString().slice(0, 10);
      if (start < new Date(threemonEnd) || end > new Date(threemonStart)) {
        const event = new ShowToastEvent({
          title:
            "A data de início e a duração da data de término devem ser de três meses ou menos",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      } else if (start > today || end > today) {
        const event = new ShowToastEvent({
          title:
            "A data de início e a data de término devem ser menores que hoje",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      } else if (start > end) {
        const event = new ShowToastEvent({
          title: "A data de início não pode ser posterior à data de término",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      } else if (this.notValidStartDate || this.notValidEndDate) {
        const event = new ShowToastEvent({
          title: "Insira uma data válida",
          variant: "error"
        });
        this.dispatchEvent(event);
        this.isSpinner = false;
      } else {
        if (this.startDate.substring(5, 7) == "01") {
          this.fiscalYearFrom = "10";
        } else if (this.startDate.substring(5, 7) == "02") {
          this.fiscalYearFrom = "11";
        } else if (this.startDate.substring(5, 7) == "03") {
          this.fiscalYearFrom = "12";
        } else if (this.startDate.substring(5, 7) == "10") {
          this.fiscalYearFrom = "7";
        } else {
          let st = this.startDate.substring(5, 7);
          let ab = Number(st.replace("0", "")) - 3;
          this.fiscalYearFrom = String(ab);
        }
        if (this.endDate.substring(5, 7) == "01") {
          this.fiscalYearTo = "10";
        } else if (this.endDate.substring(5, 7) == "02") {
          this.fiscalYearTo = "11";
        } else if (this.endDate.substring(5, 7) == "03") {
          this.fiscalYearTo = "12";
        } else if (this.endDate.substring(5, 7) == "10") {
          this.fiscalYearTo = "7";
        } else {
          let st = this.endDate.substring(5, 7);
          let ab = Number(st.replace("0", "")) - 3;
          this.fiscalYearTo = String(ab);
        }
        if (this.statementType == "Credit") {
          this.isCredit = true;
          this.isDebit = false;
        } else if (this.statementType == "Debit") {
          this.isDebit = true;
          this.isCredit = false;
        } else if (this.statementType == "Both") {
          this.isCredit = true;
          this.isDebit = true;
        }
        getAccountStatement({
          customerCode: this.customerSapAcc,
          fiscalYear: this.fiscalYear,
          fiscalYearFrom: this.fiscalYearFrom,
          fiscalYearTo: this.fiscalYearTo,
          docFilter: listselecteditems,
          startDate: this.startDate,
          endDate: this.endDate,
          getDoc: true
        }).then((result) => {
          if (result.noDistributor) {
            const event = new ShowToastEvent({
              title: "Distribuidor não encontrado",
              variant: "error"
            });
            this.dispatchEvent(event);
            this.isAccCstAvl = false;
              this.accNoRecordError = false;
            this.isSpinner = false;
          } else {
            if (result.isSuccess == false) {
              const event = new ShowToastEvent({
                title: result.msg,
                variant: "error"
              });
              this.dispatchEvent(event);
              this.isSpinner = false;
              this.isAccCstAvl = false;
              this.accNoRecordError = false;
            } else if (result.isSuccess == true) {
              if (result.isSAPSuccess) {
                window.console.log("result ====> ", result);
                this.accountCustInfo = [];
                this.accountCustInfo.push(result.customerInfo);
                var csCode = result.customerInfo.CustomerCode;
                if (csCode != "" && csCode != undefined) {
                  this.isAccCstAvl = true;
                } else {
                  this.isAccCstAvl = false;
                }
                this.accTotalCredit = result.totalCredit;
                this.accTotalDebit = result.totalDebit;
                this.AccStatementData = result.ItemInfo;
                this.accDocType = result.MetaDocType;
                if (this.AccStatementData.length > 12) {
                  this.accTableScroll = ACC_SCROLL_TABLE_CLASS;
                } else {
                  this.accTableScroll = ACC_NO_SCROLL_TABLE_CLASS;
                }
                if (this.AccStatementData.length == 0) {
                  this.accNoRecordError = true;
                  this.showAccountStatementTable = false;
                } else {
                  this.accNoRecordError = false;
                  this.showAccountStatementTable = true;
                }

                this.isSpinner = false;
                this.accStatementURL =
                  "/uplpartnerportal/apex/Grz_BrazilAccountStatementDownload?fiscalYear=" +
                  this.fiscalYear +
                  "&customerCode=" +
                  this.customerSapAcc +
                  "&fiscalYearFrom=" +
                  this.fiscalYearFrom +
                  "&fiscalYearTo=" +
                  this.fiscalYearTo +
                  "&docFilter=" +
                  listselecteditems +
                  "&startDate=" +
                  this.startDate +
                  "&endDate=" +
                  this.endDate +
                  "&isCredit=" +
                  this.isCredit +
                  "&isDebit=" +
                  this.isDebit;
              } else {
                const event = new ShowToastEvent({
                  title: "Erro no SAP",
                  variant: "error"
                });
                this.dispatchEvent(event);
                this.isSpinner = false;
                this.isAccCstAvl = false;
                this.accNoRecordError = false;
              }
            }
          }
        });
      }
    } else {
      const event = new ShowToastEvent({
        title: "O número do cliente não pode estar vazio",
        variant: "error"
      });
      this.dispatchEvent(event);
      this.isSpinner = false;
    }
  }
  ledPDF() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 3000);
  }
  accPDF() {
    this.isSpinner = true;
    setTimeout(() => {
      this.isSpinner = false;
    }, 3000);
  }
  get fiscalyearStartDate() {
    return this.getFiscalYearStart() - 1 + "-04-01";
  }

  get fiscalyearEndDate() {
    return this.getFiscalYearStart() + 1 + "-03-31";
  }

  getFiscalYearStart() {
    var fiscalyearStart = "";
    var today = new Date();

    if (today.getMonth() + 1 <= 3) {
      fiscalyearStart = today.getFullYear() - 1;
    } else {
      fiscalyearStart = today.getFullYear();
    }
    return fiscalyearStart;
  }
}