import { LightningElement, track, wire, api } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import getContractDetails from "@salesforce/apex/Grz_LoyaltyAndRebateBrazil.getContractDetails";

export default class Grz_RebateDetailPageBrazil extends LightningElement {
  @track error;
  @api title;
  @api designattributeimage;
  currentPageReference = null;
  urlStateParameters = null;
  urlId = null;
  urlLanguage = null;
  urlType = null;
  @api backgroundimage = null;
  @track contractNumber;
  @track distributor;
  @track sbuName;
  @track workflowStatus;
  @track type;
  @track zoneName;
  @track crncy;
  @track categoryName;
  @track regionalName;
  @track status;
  @track startDate;
  @track endDate;
  @track salesRep;
  @track GoalsL;
  @track ActualL;
  @track Attainment;
  @track Real;
  @track Returns;
  @track PercntReturns;
  @track Actual_RL;
  @track Actual_RR;
  @track Growth;
  @track AdjacentYear;
  @track LastYear;
  @track productData;
  @track otherProducts = [];
  @track finalTotal = [];
  connectedCallback() {
    this.backgroundimage = Icons + this.designattributeimage;
  }

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference) {
      this.urlStateParameters = currentPageReference.state;
      this.urlId = this.urlStateParameters.id || null;
      this.doSearch();
    }
  }
  doSearch() {
    getContractDetails({
      urlapex: this.urlId
    })
      .then((result) => {
        var last_year = result.liRebateContracts[0].Final_date;
        last_year = last_year.split("-", 1);
        this.AdjacentYear = last_year - 1;
        this.LastYear = last_year[0];
        this.contractNumber = result.liRebateContracts[0].Contract;
        this.distributor = result.liRebateContracts[0].DistributorCodeAndName;
        this.sbuName = result.liRebateContracts[0].Director;
        this.workflowStatus = result.liRebateContracts[0].Status;
        this.type = result.liRebateContracts[0].Type;
        this.zoneName = result.liRebateContracts[0].BU;
        this.crncy = result.liRebateContracts[0].curr;
        this.categoryName = result.liRebateContracts[0].Category_Name;
        this.regionalName = result.liRebateContracts[0].Branch;
        this.status = result.liRebateContracts[0].pStatus;
        this.startDate = result.liRebateContracts[0].Initial_date;
        this.endDate = result.liRebateContracts[0].Final_date;
        this.salesRep = result.liRebateContracts[0].CTC;
        this.GoalsL = result.liRebateContracts[0].GoalsL;
        this.ActualL = result.liRebateContracts[0].ActualL;
        this.Attainment = result.liRebateContracts[0].Attainment;
        this.Real = result.liRebateContracts[0].Real;
        this.Returns = result.liRebateContracts[0].Returns;
        this.PercntReturns = result.liRebateContracts[0].PercntReturns;
        this.Actual_RL = result.liRebateContracts[0].Actual_RL;
        this.Actual_RR = result.liRebateContracts[0].Actual_RR;
        this.Growth = result.liRebateContracts[0].Growth;

        this.productData = result.prodData;
        this.otherProducts.push(result.OtherProductCal);
        this.finalTotal.push(result.TotalCal);

        console.log("== Rebate Details ==", result.liRebateContracts);
        console.log("== Product Full Data ==", result.prodData);
        console.log("== Other Product Data ==", result.OtherProductCal);
        console.log("== Final Total ==", result.TotalCal);
      })
      .catch((error) => {
        this.error = error;
        console.log("---catch error ----", this.error);
      });
  }
}