import { LightningElement, track, wire } from "lwc";
import getCaseRecordAll from "@salesforce/apex/grz_SalesOrderSummary.getCaseRecordAll";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import LANG from "@salesforce/i18n/lang";
import CaseType from "@salesforce/label/c.Grz_Issue_Type";
import CaseOwner from "@salesforce/label/c.Grz_CaseOwner";
import CreateDate from "@salesforce/label/c.Grz_CreatedDate"
import CaseNumber from "@salesforce/label/c.Grz_CaseNumber"
import NoData from "@salesforce/label/c.Grz_NoItemsToDisplay"

export default class Grz_ticketsummarycomponent extends LightningElement {
  @track orderIcon = Icons + "/Grz_Resourse/Images/TicketSummaryBlack.png";
  @track TicketData;
  @track error;
  @track nodata = false;
  @track language = LANG;
  @track isBr = false;
  @track detailPageLink;
  @track fiscalYearStartDate;
  @track fiscalYearEndDate;
  @track CaseType = CaseType;
  @track CaseOwner = CaseOwner;
  @track CreateDate = CreateDate;
  @track CaseNumber = CaseNumber;
  @track NoData = NoData;

  @wire(getCaseRecordAll, { language: "$language" })
  getCaseRecordAll(results) {
    if (results.data) {
      this.TicketData = results.data.caseWrapList;
      if (this.TicketData.length == 0) {
        this.nodata = true;
      }
      console.log("this.TicketData : Mexico : ",this.TicketData);
    }
    if (results.error) {
      this.error = results.error;
    }
  }

  connectedCallback() {
    console.log('Language this.TicketData : Mexico : '+this.language);
    if (this.language == "pt-BR") {
      this.isBr = true;
    }
    else if(this.language== 'es-MX'){
      this.isBr = true;
    }
    else {
      this.isBr = false;
    }
    var today = new Date();
    if (today.getMonth() + 1 <= 3) {
      this.fiscalYearStartDate = today.getFullYear() - 2 + "-04-01";
      this.fiscalYearEndDate = today.getFullYear() + "-03-31";
    } else {
      this.fiscalYearStartDate = today.getFullYear() - 1 + "-04-01";
      this.fiscalYearEndDate = today.getFullYear() + 1 + "-03-31";
    }
    this.fiscalYearStartDate = this.formatDateFxn(this.fiscalYearStartDate);
    this.fiscalYearEndDate = this.formatDateFxn(this.fiscalYearEndDate);
  }

  formatDateFxn(dateVal) {
    var date = new Date(dateVal);
    const dtf = new Intl.DateTimeFormat("en", {
      year: "numeric",
      month: "short",
      day: "2-digit"
    });
    const [{ value: mo }, , { value: da }, , { value: ye }] = dtf.formatToParts(
      date
    );
    // var formattedDate = `${da}-${mo}-${ye}`;
    var formattedDate = `${mo} ${da}, ${ye}`;
    return formattedDate;
  }

  nnavigateToRecordView(event) {
    var recordid = event.target.dataset.id;
    this.detailPageLink = "case/" + recordid;
  }
}