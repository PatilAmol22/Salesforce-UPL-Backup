import { LightningElement, wire } from "lwc";
import getCarouselData from "@salesforce/apex/Grz_CarousalController.getCarouselData";
import updateTerms from "@salesforce/apex/Grz_CarousalController.updateTerms";
import LANG from "@salesforce/i18n/lang";
export default class Grz_HomePageTopComponent extends LightningElement {
  carouselData;
  error;
  language = LANG;
  contactId;
  showCarousel = false;
  showAcceptBtn = false;
  isModalOpen = false;
  isSpinner = false;

  @wire(getCarouselData, { language: "$language" })
  carlData(result) {
    if (result.data) {
      this.carouselData = result.data.wrapList;
      this.isModalOpen = result.data.showTerms;
      this.contactId = result.data.contactId;
      if (this.carouselData.length > 1) {
        this.showArrow = true;
      } else {
        this.showArrow = false;
      }
      this.showCarousel = true;
    }
    if (result.error) {
      this.error = result.error;
    }
  }
  termsCheckbox(event) {
    if (event.target.checked) {
      this.showAcceptBtn = true;
    } else {
      this.showAcceptBtn = false;
    }
  }
  submitAccept(){
    this.isSpinner = true;
    updateTerms({
      contactId: this.contactId,
    }).then(() => {
      this.isSpinner = false;
      this.isModalOpen = false;
    });
  }
}