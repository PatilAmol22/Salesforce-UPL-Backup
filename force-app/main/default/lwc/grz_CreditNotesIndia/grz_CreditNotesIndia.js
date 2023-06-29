// RITM0575970 Grz(Nikhil Verma) 21-06-2023-->
import { api, LightningElement, track, wire } from "lwc";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getLedgerStatement from "@salesforce/apex/Grz_CreditNotesIndiaController.getLedgerStatement";
import getAccInfo from "@salesforce/apex/Grz_CreditNotesIndiaController.getAccInfo";
import getSalesArea from "@salesforce/apex/Grz_OutstandingSummaryInternal.getSalesAreaValues";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import LANG from "@salesforce/i18n/lang";
const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
export default class Grz_CreditNotesIndia extends LightningElement {
    backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
    filterIcon = Icons + "/Grz_Resourse/Images/FilterIcon.png";
    isScreen = false;
    @track language = LANG;
    @track companyCode;
    @track quaterType = "1";
    @track endDate;
    @track startDate;
    @track accNoRecordError = false;
    @track ledgerNoRecordError = false;
    @track isSpinner = false;
    @track lstOptions = [];
    @track ledgerTableScroll;
    @track accTableScroll;
    @track CustomerCode;
    @track CustomerName;
    @track sapUserId;
    @track City;
    @track ledgerData;
    @track ledgerYearType;
    @track ledgerFiscalYear;
    @track ledgerFiscalYearFrom = "1";
    @track ledgerFiscalYearTo = "3";
    @track showLedgerTable = false;
    @track accError = false;
    @track doctyperecordcheck = false;
    @track documentid;
    @track YearOptions = [];
    @track LedgerYearOptions = [];
    @track SalesAreaOptions = [];
    @track customerSapCode;

    @track fiscalYear;
    @track fiscalYearFrom;
    @track fiscalYearTo;

    @track yearType;
    @track fiscalyearStartDate;
    @track fiscalyearEndDate;
    @track errorMessage;
    @track accountId;
    @track salesArea;
    connectedCallback() {
        window.addEventListener("resize", this.myFunction);
        if (screen.width < 768) this.isScreen = true;
        else this.isScreen = false;
        var today = new Date();
        this.endDate = today.toISOString();
        var last30days = new Date(today.setDate(today.getDate() - 30));
        this.startDate = last30days.toISOString();
    }

    myFunction = () => {
        if (screen.width < 768) this.isScreen = true;
        else this.isScreen = false;
    };
    @wire(getAccInfo)
    uplAccStatment(results) {
        if (results.data) {
            this.accountId = results.data.Id;
            console.log("this.accountId----", this.accountId);
            this.companyCode = results.data.companyCode;
            this.sapUserId = results.data.sapUserId;
            this.customerSapCode = results.data.customerCode;
            this.City = results.data.city;
            this.CustomerName = results.data.name;
            this.CustomerCode = results.data.customerCode;
            let intCurYear = results.data.currentFiscalYear;
            let curtYear = String(results.data.currentFiscalYear);
            this.ledgerYearType = curtYear;
            this.ledgerFiscalYear = this.ledgerYearType;
            this.fiscalYear = curtYear;
            this.yearType = curtYear;
            this.fiscalyearStartDate = this.fiscalYear + "-04-01";
            this.fiscalyearEndDate = Number(this.fiscalYear) + 1 + "-03-31";
            let yy = [];
            for (let i = 1; i <= 2; i++) {
                if (i == 1) {
                    yy.push(intCurYear - 1);
                } else {
                    yy.push(intCurYear);
                }
            }
            console.log(
                "currentFiscalYear---" + results.data.currentFiscalYear
            );
            console.log("customerCode---" + results.data.customerCode);
            console.log("companyCode---" + this.companyCode);
            console.log("sapUserId---" + this.sapUserId);
            let yearArr = [];
            for (let i = 0; i < yy.length; i++) {
                const option = {
                    label: String(yy[i]) + "-" + String(yy[i] + 1),
                    value: String(yy[i]),
                };
                yearArr = [...yearArr, option];
            }
            this.LedgerYearOptions = yearArr;
            this.YearOptions = yearArr;
        }
        if (results.error) {
            this.error = results.error;
        }
        this.getSalesAreaOptions();
    }
    getSalesAreaOptions() {
        getSalesArea({
            recordId: this.accountId,
        }).then((result) => {
            let saArr = [];
            for (let i = 0; i < result.length; i++) {
                const option = {
                    label: String(result[i].SalesOrg__r.Name),
                    value: String(result[i].Company_Code__c),
                };
                saArr = [...saArr, option];
            }
            this.SalesAreaOptions = saArr;
            if (this.SalesAreaOptions.length != 0)
                this.salesArea = this.SalesAreaOptions[0].value;
        });
    }
    handleSalesAreaOption(event) {
        this.showLedgerTable = false;
        this.salesArea = event.detail.value;
    }
    get QuaterOptions() {
        return [
            { label: "Quarter 1", value: "1" },
            { label: "Quarter 2", value: "2" },
            { label: "Quarter 3", value: "3" },
            { label: "Quarter 4", value: "4" },
        ];
    }
    handleLedgerYearOption(event) {
        this.ledgerYearType = event.detail.value;
        this.ledgerFiscalYear = this.ledgerYearType;
    }
    handleQuaterOption(event) {
        this.quaterType = event.detail.value;
        console.log("Selected Option --- ", this.quaterType);
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
        this.doctyperecordcheck = false;
        if (
            this.ledgerFiscalYear != null &&
            this.ledgerFiscalYearFrom != null &&
            this.ledgerFiscalYearTo != null
        ) {
            this.isSpinner = true;
            getLedgerStatement({
                customerCode: this.customerSapCode,
                companyCode: this.salesArea,
                fiscalYear: this.ledgerFiscalYear,
                fiscalYearFrom: this.ledgerFiscalYearFrom,
                fiscalYearTo: this.ledgerFiscalYearTo,
                getDoc: true,
                sapUserId: this.sapUserId,
                accountidinfo: this.accountId,
            }).then((result) => {
                if (result.isSuccess == false) {
                    const event = new ShowToastEvent({
                        title: result.msg,
                        variant: "error",
                    });
                    this.dispatchEvent(event);
                    this.isSpinner = false;
                } else if (result.isSuccess == true) {
                    window.console.log("result ====> ", result);
                    this.ledgerData = result.ItemInfo;
                    for (var r = 0; r < result.ItemInfo.length; r++) {
                        if (result.ItemInfo[r].Doctyperecordcheck == true) {
                            this.doctyperecordcheck = true;
                            break;
                        }
                    }
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
                }
            });
        }
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
        console.log("-----fiscalyearStart---- " + fiscalyearStart);
        return fiscalyearStart;
    }

    downloaddocument(event) {
        this.documentid = event.target.dataset.value;
        window.location.href = "/uplpartnerportal/sfc/servlet.shepherd/document/download/" + this.documentid + "?operationContext=S1";
    }
}