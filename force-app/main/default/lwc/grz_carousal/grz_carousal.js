import { LightningElement, track, wire, api } from "lwc";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import LANG from "@salesforce/i18n/lang";

const CARD_VISIBLE_CLASS = "slds-show";
const CARD_HIDDEN_CLASS = "slds-hide";

const DEFAULT_SLIDER_TIMER = 7000; // 7-seconds
export default class Grz_carousal extends LightningElement {
  @track language = LANG;

  leftIcon = Icons + "/Grz_Resourse/Images/LeftCarousalIcon.png";
  rightIcon = Icons + "/Grz_Resourse/Images/RightCarousalIcon.png";
  slides = [];
  slideIndex = 1;
  showArrow = false;
  timer;
  @api sliderTimer = DEFAULT_SLIDER_TIMER;
  enableAutoScroll = true;
  //Change by Aashima(Grazitti) for RITM0517576 7 march 2023
@track isIndia=false;


renderedCallback(){

  //Change by Aashima(Grazitti) for RITM0517576 7 march 2023
if(this.language=="en-US"){
  this.isIndia=true;
}

    if (this.language == "pt-BR") {
      this.template.querySelectorAll('[data-id="imgHeightGen"]').forEach(element => {
        element.classList.remove('carousal-img'); //Contains HTML elements
      });

    this.template.querySelectorAll('[data-id="imgHeightGen"]').forEach(element => {
      element.classList.add('carousal-img-br'); //Contains HTML elements
     });

     this.template.querySelectorAll('[data-id="testFontGen"]').forEach(element => {
      element.classList.remove('label-div'); //Contains HTML elements
    });

    this.template.querySelectorAll('[data-id="testFontGen"]').forEach(element => {
      element.classList.add('label-div-br'); //Contains HTML elements
    });
  
    }
     
}

  @api get slidesData() {
    if(this.slides.length > 1){
      this.showArrow = true;
    }else{
      this.showArrow = false;
    }
    return this.slides;
  }
  set slidesData(data) {
    this.slides = data.map((item, index) => {
      return index === 0
        ? {
            ...item,
            slideIndex: index + 1,
            cardClass: CARD_VISIBLE_CLASS
          }
        : {
            ...item,
            slideIndex: index + 1,
            cardClass: CARD_HIDDEN_CLASS
          };
    });
     console.log("slidesData------------------------->>>>>>>",this.slidesData);
  }
  connectedCallback() {
    console.log("slidesData------------------------->>>>>>>",JSON.stringify(this.slidesData));

    if (this.enableAutoScroll) {
      this.timer = window.setInterval(() => {
        this.slideSelectionHandler(this.slideIndex + 1);
      }, Number(this.sliderTimer));
    }
  }
  disconnectedCallback() {
    if (this.enableAutoScroll) {
      window.clearInterval(this.timer);
    }
  }
  backSlide() {
    let slideIndex = this.slideIndex + 1;
    this.slideSelectionHandler(slideIndex);
  }
  forwardSlide() {
    let slideIndex = this.slideIndex + 1;
    this.slideSelectionHandler(slideIndex);
  }
  slideSelectionHandler(id) {
    if (id > this.slides.length) {
      this.slideIndex = 1;
    } else if (id < 1) {
      this.slideIndex = this.slides.length;
    } else {
      this.slideIndex = id;
    }
    this.slides = this.slides.map((item) => {
      return this.slideIndex === item.slideIndex
        ? {
            ...item,
            cardClass: CARD_VISIBLE_CLASS
          }
        : {
            ...item,
            cardClass: CARD_HIDDEN_CLASS
          };
    });
  }
}