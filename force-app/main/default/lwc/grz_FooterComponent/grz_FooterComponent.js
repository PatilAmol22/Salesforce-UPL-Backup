import { LightningElement, track, wire } from "lwc";
import getUPLFooterList from "@salesforce/apex/grz_FooterController.getUPLFooterList";
//import getSurveyData from "@salesforce/apex/grz_FooterController.getSurveyData";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import LANG from "@salesforce/i18n/lang";
import LOCALE from "@salesforce/i18n/locale";
import SystemModstamp from "@salesforce/schema/Account.SystemModstamp";

export default class Grz_FooterComponent extends LightningElement {
  youtube = Icons + "/Grz_Resourse/Images/YouTube.png";
  facebook = Icons + "/Grz_Resourse/Images/Facebook.png";
  twiter = Icons + "/Grz_Resourse/Images/Twiter.png";
  linkdin = Icons + "/Grz_Resourse/Images/Linkdin.png";
  instagram = Icons + "/Grz_Resourse/Images/Instagram.png";
  youtubeGray = Icons + "/Grz_Resourse/Images/YouTubeGray.png";
  facebookGray = Icons + "/Grz_Resourse/Images/FacebookGray.png";
  twiterGray = Icons + "/Grz_Resourse/Images/TwiterGray.png";
  linkdinGray = Icons + "/Grz_Resourse/Images/LinkdinGray.png";
  instagramGray = Icons + "/Grz_Resourse/Images/InstagramGray.png";
  surveyIcon = Icons + "/Grz_Resourse/Images/surveyIcon.png";
  @track language = LANG;
  @track data;
  @track leftDataAR;
  @track rightDataAR;
  @track error;
  @track locale = LOCALE;
  @track iconname = "utility:chevronup";
  @track currentYear = new Date().getFullYear();
  @track isBr = false;
  @track isCl = false;
  @track isIn = false;
  @track isMX = false;
  @track isAR = false;
  @track isBrExternal = false;
  @track btnEnable = false;
  @track surveyURL;
  @track iconURL = [];
  

  connectedCallback() {
    if (this.language == "pt-BR") {
      this.isBr = true;
    } 
    else if (this.language == "es-MX"){
      this.isMX = true;
    }
    // added condition for argentina in grz_FoterComponent, Mohit Garg(Grazitti) : APPS-1757 added on: 10-08-2022
    
    else if (this.language == "es-AR" || this.locale == "es-AR") {
      this.isAR = true;
      this.isIn = false;
      this.isBr = false;
      this.isMx = false;

      this.language = "es-AR";
    } 
    else if (this.language == "es") {
      this.isCl = true;
    } 
    
    else {
      this.isIn = true;
    }
    
  }
  @wire(getUPLFooterList, { language: "$language" })
  uplfooter(results) {
    if (results.data) {
      this.data = results.data;
      
    }
    console.log('results ', results);
    if (results.error) {
      this.error = results.error;
    }
  }


  
  openSubMenu(event) {
    var icon = event.target.dataset.name;
    var geticonname = event.target.iconName;
    if (geticonname == "utility:chevrondown") {
      this.template.querySelector('[data-name="' + icon + '"]').iconName =
        "utility:chevronup";
      this.template
        .querySelector('[data-id="' + icon + '"]')
        .classList.add("show-child");
    }
    if (geticonname == "utility:chevronup") {
      this.template.querySelector('[data-name="' + icon + '"]').iconName =
        "utility:chevrondown";
      this.template
        .querySelector('[data-id="' + icon + '"]')
        .classList.remove("show-child");
    }
  }
 /* renderedCallback(){
    var d = document.documentElement;
    var offset = d.scrollTop + window.innerHeight;
    var height = d.offsetHeight;
    var x = window.screenY;
    console.log('offset = ' + offset);
    console.log('height = ' + height);
    console.log('height = ' + x);
    if (offset >= height) {
      console.log('At the bottom');
    }
  }*/
  handleBackToTop() {
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }
}