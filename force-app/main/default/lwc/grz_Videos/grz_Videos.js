import { LightningElement, api, track, wire } from "lwc";
import getVideoUrls from "@salesforce/apex/Grz_homePageYTVideos.getYTVideoData";
import getProdSpotData from "@salesforce/apex/Grz_ProductSpotImgs.getProdSpotData";
import videoLabel from "@salesforce/label/c.Grz_Videos";
import knowMore from "@salesforce/label/c.Grz_KnowMore";
import prodLabel from "@salesforce/label/c.Grz_Product_Spotlight";
import LANG from "@salesforce/i18n/lang";
const DEFAULT_SLIDER_TIMER = 7000; // 8-seconds
export default class Video_File extends LightningElement {
  label = {
    videoLabel,
    prodLabel,
    knowMore
  };
  @track language = LANG;
  vid;
  @track videos;
  @track globalIndex = 0;
  @track globalIndex1 = 0;
  @track maxIndex = 2;
  @track hide = false;
  @track linkList = [];
  @track videoClicked = false;

  @api sliderTimer = DEFAULT_SLIDER_TIMER;
  enableAutoScroll = true;

  @wire(getVideoUrls, { language: "$language" })
  records(result) {
    console.log('language==>'+this.language);
    if (result.data) {
      this.videos = [];
      result.data.forEach((item) => {
        let vido1 = {};
        vido1 = {
          id: item.id,
          title: item.title,
          embedded_url: item.embedded_url
        };
        this.linkList.push(item.embedded_url);
        this.videos.push(vido1);
      });
    }
  }
  @track prodImgLink = [];
  @track logoImgLink = [];
  @track nameImgLink = [];
  @track factImgLink = [];
  @track viewImgLink = [];
  @wire(getProdSpotData, { language: "$language" })
  records1(result) {
    console.log('result.data-->>',result.data);
    console.log('product result',result);
    if (result.data) {
       console.log('result.data-->>',result.data);
      result.data.forEach((item) => {
        this.prodImgLink.push(item.image);
        this.logoImgLink.push(item.product.product_type_logo);
        this.nameImgLink.push(item.product.name.toUpperCase());
        if(null!=item.product.fact)
        this.factImgLink.push(item.product.fact.split("\n")[0]);
        else
        this.factImgLink.push('');
        this.viewImgLink.push(
          "https://www.upl-ltd.com/" + item.product.view_link
        );
      });
    }
  }

  renderedCallback() {
    this.vid = this.template.querySelector("video");
    if (this.language == "pt-BR") {
      this.hide = true;
    } 
  }
  playVideo() {
    this.vid.play();
  }
  previousHandler1() {
    if (this.globalIndex1 > 0) {
      this.globalIndex1 = this.globalIndex1 - 1;
      if (this.globalIndex1 == 0) {
        this.template.querySelector(
          "lightning-button-icon.Previous1"
        ).disabled = true;
        this.template.querySelector(
          "lightning-button-icon.Next1"
        ).disabled = false;
      } else {
        this.template.querySelector(
          "lightning-button-icon.Previous1"
        ).disabled = false;
        this.template.querySelector(
          "lightning-button-icon.Next1"
        ).disabled = false;
      }
    } else {
      this.template.querySelector(
        "lightning-button-icon.Previous1"
      ).disabled = true;
      this.template.querySelector(
        "lightning-button-icon.Next1"
      ).disabled = false;
    }
  }

  nextHandler1() {
    if (this.globalIndex1 < this.prodImgLink.length - 1) {
      this.globalIndex1 = this.globalIndex1 + 1;
      if (this.globalIndex1 == this.prodImgLink.length - 1) {
        this.template.querySelector(
          "lightning-button-icon.Next1"
        ).disabled = true;
        this.template.querySelector(
          "lightning-button-icon.Previous1"
        ).disabled = false;
      } else {
        this.template.querySelector(
          "lightning-button-icon.Next1"
        ).disabled = false;
        this.template.querySelector(
          "lightning-button-icon.Previous1"
        ).disabled = false;
      }
    } else if (this.globalIndex1 == this.prodImgLink.length - 1) {
      this.template.querySelector(
        "lightning-button-icon.Next1"
      ).disabled = true;
      this.template.querySelector(
        "lightning-button-icon.Previous1"
      ).disabled = false;
    }
  }

  previousHandler() {
    this.videoClicked = false;
    if (this.globalIndex > 0) {
      this.globalIndex = this.globalIndex - 1;
      if (this.globalIndex == 0) {
        this.template.querySelector(
          "lightning-button-icon.Previous"
        ).disabled = true;
        this.template.querySelector(
          "lightning-button-icon.Next"
        ).disabled = false;
      } else {
        this.template.querySelector(
          "lightning-button-icon.Previous"
        ).disabled = false;
        this.template.querySelector(
          "lightning-button-icon.Next"
        ).disabled = false;
      }
    } else {
      this.template.querySelector(
        "lightning-button-icon.Previous"
      ).disabled = true;
      this.template.querySelector(
        "lightning-button-icon.Next"
      ).disabled = false;
    }
  }

  nextHandler() {
    this.videoClicked = false;
    if (this.globalIndex < this.linkList.length - 1) {
      this.globalIndex = this.globalIndex + 1;
      if (this.globalIndex == this.linkList.length - 1) {
        this.template.querySelector(
          "lightning-button-icon.Next"
        ).disabled = true;
        this.template.querySelector(
          "lightning-button-icon.Previous"
        ).disabled = false;
      } else {
        this.template.querySelector(
          "lightning-button-icon.Next"
        ).disabled = false;
        this.template.querySelector(
          "lightning-button-icon.Previous"
        ).disabled = false;
      }
    } else if (this.globalIndex == this.linkList.length - 1) {
      this.template.querySelector("lightning-button-icon.Next").disabled = true;
      this.template.querySelector(
        "lightning-button-icon.Previous"
      ).disabled = false;
    }
  }

  get videoURL() {
    return this.linkList[this.globalIndex];
  }

  get prodUse() {
    return this.prodImgLink[this.globalIndex1];
  }

  get nameImg() {
    return this.nameImgLink[this.globalIndex1];
  }
  get logoImg() {
    return this.logoImgLink[this.globalIndex1];
  }
  get factImg() {
    return this.factImgLink[this.globalIndex1];
  }
  get viewLinkImg() {
    return this.viewImgLink[this.globalIndex1];
  }

  knowMoreAction() {
    window.open(this.viewLinkImg);
  }
  connectedCallback() {
    if (this.enableAutoScroll) {
      this.timer = window.setInterval(() => {
        this.productSlideHandler();
        if(!this.videoClicked && document.body.offsetWidth > 1024){
          this.videoSlideHandler();
        }
      }, Number(this.sliderTimer));
    }
  }
  disconnectedCallback() {
    if (this.enableAutoScroll) {
      window.clearInterval(this.timer);
    }
  }
  productSlideHandler() {
    if (this.globalIndex1 < this.prodImgLink.length - 1) {
      this.globalIndex1 = this.globalIndex1 + 1;
      if (this.globalIndex1 == this.prodImgLink.length - 1) {
        this.template.querySelector(
          "lightning-button-icon.Next1"
        ).disabled = true;
        this.template.querySelector(
          "lightning-button-icon.Previous1"
        ).disabled = false;
      } else {
        this.template.querySelector(
          "lightning-button-icon.Next1"
        ).disabled = false;
        this.template.querySelector(
          "lightning-button-icon.Previous1"
        ).disabled = false;
      }
    }else {
      this.globalIndex1 = 0;
      this.template.querySelector(
        "lightning-button-icon.Previous1"
      ).disabled = true;
      this.template.querySelector(
        "lightning-button-icon.Next1"
      ).disabled = false;
    }
  }
  videoSlideHandler(){
    if (this.globalIndex < this.linkList.length - 1) {
      this.globalIndex = this.globalIndex + 1;
      if (this.globalIndex == this.linkList.length - 1) {
        this.template.querySelector(
          "lightning-button-icon.Next"
        ).disabled = true;
        this.template.querySelector(
          "lightning-button-icon.Previous"
        ).disabled = false;
      } else {
        this.template.querySelector(
          "lightning-button-icon.Next"
        ).disabled = false;
        this.template.querySelector(
          "lightning-button-icon.Previous"
        ).disabled = false;
      }
    }else{
      this.globalIndex = 0;
      this.template.querySelector(
        "lightning-button-icon.Previous"
      ).disabled = true;
      this.template.querySelector(
        "lightning-button-icon.Next"
      ).disabled = false;
    }
  }
  videoHover(){
    this.videoClicked = true;
  }
}