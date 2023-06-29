import { LightningElement,wire, track } from 'lwc';
import getSalesOrder from "@salesforce/apex/Grz_BrazilGlobalSearchResultController.getSalesOrder";
import getCase from "@salesforce/apex/Grz_BrazilGlobalSearchResultController.getCase";
import currUserId from "@salesforce/user/Id";
import {getRecord,getFieldValue} from "lightning/uiRecordApi";
import CURR_USER_PROFILE from '@salesforce/schema/User.Profile.Name';
export default class Grz_BrazilGlobalSearchResult extends LightningElement {

  @track recId;
  @track salesData;
  @track caseData;
  @track datalenght = 0;
  @track salesOrderTile = false;
  @track caseTile = false;
  @track salesNoData = false;
  @track caseNoData = false;
  @track caseDetailPageLink;
  @track salesOrderdetailPageLink;
  connectedCallback() {
    const urlParameters = window.location.href;
    var urlcaseId = urlParameters.split('search/');
    var urlIDValue = urlcaseId[1] || null;
    urlIDValue = urlIDValue.split('/');
    this.recId = urlIDValue[0];
  }
  @wire(getRecord,{recordId: currUserId, fields:[CURR_USER_PROFILE]})
  userData;
  get userValid(){
    var canAccess;
    var proName = getFieldValue(this.userData.data, CURR_USER_PROFILE);
    if(proName == 'Brazil Partner Community Distributor Finance Profile'){
      canAccess = false;
    }else{
      canAccess = true;
    }
    return canAccess;
  }
  handleSalesOrder() {
    this.caseNoData = false;
    this.datalenght = 0;
    this.caseTile = false;
    getSalesOrder({ searchKey: this.recId }).then((result) => {
      if (result) {
        if (result.length > 0) {
          this.salesOrderTile = true

          console.log('res--->>', result);
          this.salesData = result;
          this.datalenght = result.length;
        }

        else {
          this.salesNoData = true;
        }
      }
    })
  }

  handleCase() {
    this.salesNoData = false;
    this.datalenght = 0;
    this.salesOrderTile = false
    getCase({ searchKey: this.recId }).then((result) => {
      if (result) {
        if (result.length > 0) {

          this.caseTile = true;
          console.log('res--->>', result);
          this.caseData = result;
          this.datalenght = result.length;
        }

        else {
          this.caseNoData = true;
        }
      }
    })
  }

  handleOrderDetail(event) {
    var link = window.location.href;
    link = link.replace("global-search/" + this.recId, "");
    link = link + "sales-order/" + event.currentTarget.dataset.value;
    this.salesOrderdetailPageLink = link;
  }

  handleCaseDetail(event) {
    var link = window.location.href;
    link = link.replace("global-search/" + this.recId, "");
    link = link + "case/" + event.currentTarget.dataset.value;
    this.caseDetailPageLink = link;
  }


}