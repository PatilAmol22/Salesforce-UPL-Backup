import { LightningElement, track } from "lwc";
import getAccountReceivables from "@salesforce/apex/Grz_ColombiaControllerAR.getAccountReceivables";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import dislike from "@salesforce/resourceUrl/dislike";
import like from "@salesforce/resourceUrl/like";
import FORM_FACTOR from '@salesforce/client/formFactor';
const SCROLL_TABLE_CLASS = "table-data-scroll";
const NO_SCROLL_TABLE_CLASS = "table-no-scroll";
export default class Grz_ColombiaAR extends LightningElement {
    @track dislike = dislike;
    @track like = like;
    @track fiscalYear;
    @track overdueTableScroll;
    @track fiscalyearStartDate;
    @track fiscalyearEndDate;
    @track searchKeyBar;
    @track dueDateStart;
    @track dueDateEnd;
    @track recordCount = 0;
    @track documentStartDate;
    @track documentEndDate;
    @track isLoading = false;
    @track isDataNull = false;
    @track showBlock = false;
    @track isSuccess = true;
    @track isSpinner = false;
    @track isProgressBar = false;
    @track notValidStartDate = false;
    @track notValidEndDate = false;
    @track nodata = false;

    @track arPayloads = [];
    @track tempRecords = [];
    @track totalOverdue;
    @track notYetDue;
    @track upto_0_30;
    @track upto_31_60;
    @track upto_61_90;
    @track after_91;
    @track currentFiscalYear;
    @track validDueDates = true;
    @track message;
    @track progress = 0;
    @track processStatus = "In Progress";
    isMobile;

    connectedCallback() {
        //For Mobile view handling
        console.log('The device form factor is: ' + FORM_FACTOR);
        if(FORM_FACTOR == 'Large'){
            this.isMobile = false;
        }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
            this.isMobile = true;
        }
        console.log('this.isMobile ' + this.isMobile);
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, "0");
        var mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
        var yyyy = today.getFullYear();
        this.documentEndDate = yyyy + "-" + mm + "-" + dd;
        this.currentFiscalYear = today.getFullYear();
        this.documentStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
        this.fiscalyearStartDate = Number(this.currentFiscalYear) - 2 + "-01-01";
        this.fiscalyearEndDate = this.currentFiscalYear + "-12-31";
        this.handleARSearch();
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
                    title:
                        "La fecha de inicio no puede ser posterior a la fecha de finalización",
                    variant: "error",
                });
                this.dispatchEvent(event);
                this.showBlock = false;
            } else if (this.notValidStartDate || this.notValidEndDate) {
                const event = new ShowToastEvent({
                    title: "Insertar un dato válido",
                    variant: "error",
                });
                this.dispatchEvent(event);
                this.showBlock = false;
            } else {
                this.isLoading = true;
                this.isProgressBar = true;
                this.progress = 0;
                this._interval = setInterval(() => {
                    this.progress = this.progress + 5;
                    this.processStatus = "Buscando registros, por favor espere";
                    if (this.progress === 100) {
                        this.progress = 0;
                    }
                }, 500);
                this.dueDateStart = Number(this.currentFiscalYear) - 2 + "-01-01";
                this.dueDateEnd = Number(this.currentFiscalYear) + 1 + "-12-31";
                setTimeout(() => {
                    getAccountReceivables({}).then((result) => {
                        console.log("result===>", result);
                        if (result.success) {
                            this.isSuccess = true;
                            this.arPayloads = result.lineitems;
                            this.totalOverdue = result.totalOverdue;
                            this.notYetDue = result.notYetDue;
                            this.upto_0_30 = result.upto_0_30;
                            this.upto_31_60 = result.upto_31_60;
                            this.upto_61_90 = result.upto_61_90;
                            this.after_91 = result.after_91;
                            let filteredData = this.arPayloads.filter((obj) => {
                                return (
                                    obj.DocDate >= this.documentStartDate &&
                                    obj.DocDate <= this.documentEndDate &&
                                    obj.DueDate >= this.dueDateStart &&
                                    obj.DueDate <= this.dueDateEnd
                                );
                            });
                            filteredData.sort(
                                this.dynamicsort("DueDate", "Asc")
                            );
                            this.tempRecords = filteredData;
                            this.recordCount = this.tempRecords.length;
                            if (this.recordCount > 12) {
                                this.overdueTableScroll = SCROLL_TABLE_CLASS;
                            } else {
                                this.overdueTableScroll = NO_SCROLL_TABLE_CLASS;
                            }
                            if (this.tempRecords.length > 0) {
                                this.isDataNull = true;
                                this.nodata = false;
                            } else {
                                this.isDataNull = false;
                                this.nodata = true;
                                this.message = "Nenhum dado encontrado";
                            }
                            this.isLoading = false;
                            this.isProgressBar = false;
                            clearInterval(this._interval);
                            this.showBlock = true;
                            const event = new ShowToastEvent({
                                title: "Dados atualizados",
                                variant: "success",
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
                title: "Una fecha no puede estar vacía",
                variant: "error",
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
            this.dateFilterData(
                this.dueDateStart,
                this.dueDateEnd,
                this.searchKeyBar
            );
        } else {
            this.isDataNull = false;
            this.nodata = true;
            this.message = "Proporcione una fecha de caducidad válida";
        }
    }
    getDueDateStart(event) {
        this.dueDateStart = event.target.value;
        if (this.dueDateStart == null || this.dueDateStart == null) {
            this.isDataNull = false;
            this.nodata = true;
            this.message = "Proporcione una fecha de caducidad válida";
            this.validDueDates = false;
        } else {
            if (this.dueDateStart > this.dueDateEnd) {
                this.isDataNull = false;
                this.nodata = true;
                this.message = "La fecha de inicio no puede ser posterior a la fecha final";
                this.validDueDates = false;
            } else {
                this.validDueDates = true;
                this.dateFilterData(
                    this.dueDateStart,
                    this.dueDateEnd,
                    this.searchKeyBar
                );
            }
        }
    }
    getDueDateEnd(event) {
        this.dueDateEnd = event.target.value;
        if (this.dueDateEnd == null || this.dueDateStart == null) {
            this.isDataNull = false;
            this.nodata = true;
            this.message = "Proporcione una fecha de caducidad válida";
            this.validDueDates = false;
        } else {
            if (this.dueDateEnd < this.dueDateStart) {
                this.isDataNull = false;
                this.nodata = true;
                this.message = "La fecha de finalización no puede ser anterior a la fecha de inicio";
                this.validDueDates = false;
            } else {
                this.validDueDates = true;
                this.dateFilterData(
                    this.dueDateStart,
                    this.dueDateEnd,
                    this.searchKeyBar
                );
            }
        }
    }
    dateFilterData(dueStart, dueEnd, tempsearch) {
        if (tempsearch == null) {
            tempsearch = "";
        }
        let filteredData = this.arPayloads.filter(
            (obj) =>
                obj.DueDate &&
                obj.DueDate >= dueStart &&
                obj.DueDate <= dueEnd &&
                obj.DocNo &&
                obj.DocNo.toLowerCase().includes(tempsearch.toLowerCase())
        );
        filteredData.sort(this.dynamicsort("DueDate", "Asc")); // GRZ(Nikhil Verma) : APPS-1394
        this.tempRecords = filteredData;
        this.recordCount = this.tempRecords.length;
        if (this.recordCount > 0) {
            this.isDataNull = true;
            this.nodata = false;
        } else {
            this.isDataNull = false;
            this.nodata = true;
            this.message = "Nenhum dado encontrado";
        }
    }

    dynamicsort(property, order) {
        var sort_order = 1;
        if (order === "Desc") {
            sort_order = -1;
        }
        return function (a, b) {
            if (a[property] < b[property]) {
                return -1 * sort_order;
            } else if (a[property] > b[property]) {
                return 1 * sort_order;
            } else {
                return 0 * sort_order;
            }
        };
    }
}