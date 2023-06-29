import { LightningElement, track, wire } from "lwc";
import getSummaryTabsList from "@salesforce/apex/grz_SummaryTabsController.getSummaryTabsList";
import getNotice from "@salesforce/apex/grz_SummaryTabsController.getNotice";
import currUserId from "@salesforce/user/Id";
import {getRecord,getFieldValue} from "lightning/uiRecordApi";
import CURR_USER_PROFILE from '@salesforce/schema/User.Profile.Name';
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import LANG from "@salesforce/i18n/lang";
export default class Grz_summaryListCmp extends LightningElement {
  @track summarylink;
  @track customLabel;
  @track orderLabel;
  @track ticketLabel;
  @track orderLink;
  @track ticketLink;
  @track language = LANG;
  @track showData = false;
  @track ticketVisible = false;
  @track noticeData;
  @track showNotice = false;
  notice = Icons + "/Grz_Resourse/Images/Notice.png";

  connectedCallback(){
    if(this.language == 'es'){
      this.ticketVisible = false;
    }else{
      this.ticketVisible = true;
    }
  }
  @wire(getRecord,{recordId: currUserId, fields:[CURR_USER_PROFILE]})
  userData;
  get userValid(){
    var canAccess;
    var proName = getFieldValue(this.userData.data, CURR_USER_PROFILE);
    if(proName == 'Brazil Partner Community Distributor Finance Profile' || proName == 'Chile Partner Community Distributor Finance Profile'){ //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
      canAccess = false;
    }else{
      canAccess = true;
    }
    return canAccess;
  }
  @wire(getSummaryTabsList, { language: "$language" })
  SummaryTabsRecord(results) {
    if (results.data) {
      this.customLabel = results.data.CustomLabel;
      this.orderLabel = results.data.summaryTabsList[0].Name;
      this.orderLink = results.data.summaryTabsList[0].URL;
      if(this.ticketVisible){
        this.ticketLabel = results.data.summaryTabsList[1].Name;
        this.ticketLink = results.data.summaryTabsList[1].URL;
      }
      this.showData = true;
    }
    if (results.error) {
      this.error = results.error;
    }
  }
  @wire(getNotice, { language: "$language" })
  getNotice(results) {
    if (results.data) {
      this.noticeData = results.data;
      if(this.noticeData.length > 0){
        this.showNotice = true;
      }else{
        this.showNotice = false;
      }
    }
    if (results.error) {
      this.error = results.error;
    }
  }
}