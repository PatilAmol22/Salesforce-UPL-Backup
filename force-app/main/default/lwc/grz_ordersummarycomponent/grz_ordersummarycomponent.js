import { LightningElement, track, wire, api } from "lwc";
import getSalesOrderRecordAll from "@salesforce/apex/grz_SalesOrderSummary.getSalesOrderRecordAll";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import LANG from "@salesforce/i18n/lang";
export default class Grz_OrderSummaryComponent extends LightningElement {
  @track orderIcon = Icons + "/Grz_Resourse/Images/OrderSummaryBlack.png";
  @track SalesData;
  @track error;
  @track detailPageLink;
  @track nodata = false;
  @track language = LANG;
  @track isBr = false;
  @track isCl = false;
  @track isIn = false;
  @track isMx = false;
  @track fiscalYearStartDate;
  @track fiscalYearEndDate;

  connectedCallback() {
    if (this.language == "pt-BR") {
      this.isBr = true;
    } 
    else if(this.language== 'es-MX'){
      this.isMx = true;
    }else if(this.language == 'es'){
      this.isCl = true;
    }
    else {
      this.isIn = true;
    }
    var today = new Date();
    //var today = new Date('2025-05-27T10:20:30Z');
    console.log("today : " +today);
    if((today.getMonth() + 1) <= 3) {
      this.fiscalYearStartDate = (today.getFullYear() - 2)+'-04-01';
      this.fiscalYearEndDate = today.getFullYear()+'-03-31';
    } 
    else {
      this.fiscalYearStartDate = (today.getFullYear()-1)+'-04-01';
      this.fiscalYearEndDate = (today.getFullYear()+1)+'-03-31';
    }
    this.fiscalYearStartDate = this.formatDateFxn(this.fiscalYearStartDate);
    this.fiscalYearEndDate = this.formatDateFxn(this.fiscalYearEndDate);
  }

  @wire(getSalesOrderRecordAll, { language: "$language" })
  SalesOrderRecordAll(results) {
    if (results.data) {
      console.log("Home Sales Order result ===> ", results.data);
      this.SalesData = results.data;
      console.log('this.SalesData==>',this.SalesData);
      console.log('this.isMx==>'+this.isMx);
      if (this.SalesData.length == 0) {
        this.nodata = true;
      }
    }
    if (results.error) {
      this.error = results.error;
      console.log("Home sales order wire error ===> ", this.error);
    }
  }

  formatDateFxn(dateVal){
    var date = new Date(dateVal);
    const dtf = new Intl.DateTimeFormat('en', {
        year: 'numeric',
        month: 'short',
        day: '2-digit'
    })
    const [{value: mo}, , {value: da}, , {value: ye}] = dtf.formatToParts(date);   
    // var formattedDate = `${da}-${mo}-${ye}`;
    var formattedDate = `${mo} ${da}, ${ye}`;
    return formattedDate;
}


  openSubMenu(event) {
    var icon = event.target.dataset.name;
    var countId = event.target.dataset.id;
    var geticonname = event.target.iconName;

    try {
      this.template
        .querySelector(".childdivstyle")
        .classList.remove("my-menu2hover");
      this.template
        .querySelector(".childdivstyle")
        .classList.remove("childdivstyle");
      this.template
        .querySelector(".divstyleParent")
        .classList.remove("divstyleParent");
      this.template.querySelector(".icon-clsr").iconName =
        "utility:chevrondown";
      this.template.querySelector(".icon-clsr").classList.remove("icon-clsr");
    } catch (e) {
      // console.error("An error occurred"); //This will not be executed
    }

    if (geticonname == "utility:chevrondown") {
      this.template.querySelector('[data-name="' + icon + '"]').iconName =
        "utility:chevronup";
      this.template
        .querySelector('[data-name="' + icon + '"]')
        .classList.add("icon-clsr");
      this.template
        .querySelector('[data-id="' + icon + '"]')
        .classList.add("my-menu2hover");
      this.template
        .querySelector('[data-id="' + icon + '"]')
        .classList.add("childdivstyle");
      this.template
        .querySelector('[data-id="' + countId + '"]')
        .classList.add("divstyleParent");
    }
    if (geticonname == "utility:chevronup") {
      this.template.querySelector('[data-name="' + icon + '"]').iconName =
        "utility:chevrondown";
      this.template
        .querySelector('[data-name="' + icon + '"]')
        .classList.remove("icon-clsr");
      this.template
        .querySelector('[data-id="' + icon + '"]')
        .classList.remove("my-menu2hover");
      this.template
        .querySelector('[data-id="' + icon + '"]')
        .classList.remove("childdivstyle");
      this.template
        .querySelector('[data-id="' + countId + '"]')
        .classList.remove("divstyleParent");
    }
  }
  navigateToRecordView(event) {
    var recordID = event.currentTarget.name;
    console.log("recordID : " + recordID);
    this.detailPageLink = "sales-order/" + recordID;
  }
  navigateToRecordViewBr(event) {
    var recordID = event.currentTarget.name;
    console.log("recordID : " + recordID);
    this.detailPageLink = "sales-order/" + recordID;
  }
}