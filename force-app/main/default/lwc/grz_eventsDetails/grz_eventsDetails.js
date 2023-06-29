import { LightningElement, track, wire } from "lwc";
import getEventsDetails from "@salesforce/apex/Grz_EventsDetail.getEventsDetails";
import eventLabel from "@salesforce/label/c.Grz_Events";
import viewAllLabel from "@salesforce/label/c.Grz_ViewAll";
import LANG from "@salesforce/i18n/lang";
export default class Grz_eventsDetails extends LightningElement {
  label = {
    eventLabel,
    viewAllLabel
  };
  @track language = LANG;
  @track isInd = false;
  @track isBr = false;
  @track isMx = false;
  @track eventDet = [];
  @track titleList = [];
  @track descriptionList = [];
  @track from_dateList = [];
  @track event_addressList = [];
  @track event_imageList = [];
  @track eventLinkMx = 'https://www.upl-ltd.com/mx/M%C3%A1s-informaci%C3%B3n-de-las-noticias/iii-simposio-de-manejo-de-papa';

  connectedCallback(){
    if (this.language == "en-US") {
      this.isInd = true;
    }else if(this.language == 'pt-BR'){
      this.isBr = true;
    }else if(this.language == 'es-MX'){
      this.isMx = true;
    }
    
    if(this.isMx){
      let eventMx = {};
      eventMx = {
          id: 'MX-Event',
          title: 'III Simposio de Manejo de Papa',
          description: 'el evento contó aproximadamente con 120 participantes.',
          from_date: '04 Oct 2018',
          event_address: 'III Simposio de Manejo de Papa en Los Mochis, Sinaloa',
          event_image: 'https://mx.uplonline.com/files/news_images/984559484ebdc017e3f33613a238ee73.jpg'
        };
        this.titleList.push(eventMx.title);
        this.descriptionList.push(eventMx.description);
        this.from_dateList.push(eventMx.from_date);
        this.event_addressList.push(eventMx.event_address);
        this.event_imageList.push(eventMx.event_image);
        //this.eventDataMx.push(eventMx);
    }
  }

  @wire(getEventsDetails, { language: "$language" })
  records(result) {
    if (result.data) {
      this.eventDet = [];
      result.data.forEach((item) => {
        let vido1 = {};
        vido1 = {
          id: item.id,
          title: item.title,
          description: item.description,
          from_date: item.from_date,
          event_address: item.event_address,
          event_image: item.event_image
        };
        this.eventDet.push(vido1);

        this.titleList.push(item.title);
        this.descriptionList.push(item.description);
        this.from_dateList.push(item.from_date);
        this.event_addressList.push(item.event_address);
        this.event_imageList.push(item.event_image);
      });
    }
  }

  get imageLink() {
    return this.event_imageList[0];
  }
  get titleData() {
    return this.titleList[0];
  }
  get descriptionData() {
    return this.descriptionList[0];
  }
  get event_addressData() {
    return this.event_addressList[0];
  }
  get from_dateData() {
    return this.from_dateList[0];
  }
}