import { LightningElement, track, wire, api } from "lwc";
import getEventsDetails from "@salesforce/apex/Grz_NewsUpdatesDetails.getEventsDetails";
import backgroundImage from "@salesforce/resourceUrl/Grz_Resourse";
import updateLabel from "@salesforce/label/c.Grz_News_Updates";
import learnMore from "@salesforce/label/c.Grz_LearnMore";
import viewLabel from "@salesforce/label/c.Grz_ViewAll";
import FORM_FACTOR from "@salesforce/client/formFactor";
import LANG from "@salesforce/i18n/lang";
import LOCALE from "@salesforce/i18n/locale";
export default class Grz_latestupdate extends LightningElement {
  label = {
    updateLabel,
    viewLabel,
    learnMore
  };
  newsClass1='descClass slds-p-around_xx-small';
  newsClass2='descClass slds-p-around_xx-small borderClass';
  newsClass3='titleClass componentNotoSansBold slds-p-around_xx-small';
  @track language = LANG;
  @track locale = LOCALE;
  @track isInd = false;
  @track isBr = false;
  //Introduced the variable below to use the component in Argentina community ,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 16-08-2022
  @track isAr = false;
  @track isMx = false;
  @track newsDet = [];
  @track titleList = [];
  @track descList = [];
  @track linkList = [];
  @track screenSize = FORM_FACTOR;
  @track IsInternalUser;
  @track data = [];
  @track isLink;
  @track newsBgImg = backgroundImage + "/Grz_Resourse/Images/NewsBG.png";
  @track newsBgImg2 = backgroundImage + "/Grz_Resourse/Images/NewsBG2.png";
  @track newsBgImg4 = backgroundImage + "/Grz_Resourse/Images/NewsBG4.png";
  @track whitearrowimage =
  backgroundImage + "/Grz_Resourse/Images/ArrowRight.png";

      connectedCallback() {
      if (this.language == "en-US") {
      this.isInd = true;
    } else if(this.language == "pt-BR"){
      this.isBr = true;
    }
    else if(this.language == "es-MX"){
      this.isMx = true;
    }
    //Using the country in addition to lang locale because some users in Argentina have en_US set as 
    //default language ,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 16-08-2022
    if(this.language == "es-AR" || this.locale == "es-AR"){
      this.isAr = true;
      this.isInd = false;
      this.isBr = false;
      this.isMx = false;

      this.language = "es-AR";
    }
  }
  @wire(getEventsDetails, { language: "$language" })
  records(result) {
    if (result.data) {
      this.newsDet = [];
      this.IsInternalUser = result.data.IsInternalUser;
      result.data.newupdateList.forEach((row, index) => {
        let rowData = {};
        rowData.id = row.id;
        if(this.language=="es-AR"){
          this.newsClass1=this.newsClass1+' bgblack';
          this.newsClass2=this.newsClass2+' bgblack';
          this.newsClass3=this.newsClass3+' bgblack';
        }
                  if (index == 0) {
          rowData.bgimg = this.newsBgImg;
          if(this.language=="es-AR"){
            this.newsBgImg=result.data.newupdateList[0].image.url;
            rowData.bgimg = result.data.newupdateList[0].image.url;
          }
        }
        if (index == 1) {
          rowData.bgimg = this.newsBgImg2;
          if(this.language=="es-AR"){
            this.newsBgImg2=result.data.newupdateList[1].image.url;
            rowData.bgimg = result.data.newupdateList[1].image.url;
          }        }
        if (index == 2) {
          rowData.bgimg = this.newsBgImg4;
          if(this.language=="es-AR"){
            rowData.bgimg = result.data.newupdateList[2].image.url;
          }
        }

        var titlestr;
        if (row.title.length > 25) {
          titlestr = row.title.substring(0, 25);
          if (titlestr.endsWith(" ")) {
            titlestr = titlestr.substring(0, titlestr.length - 1);
          }
          titlestr = titlestr + "...";
        } else {
          titlestr = row.title;
        }
        rowData.title = titlestr;
        rowData.titlehover = row.title;
        var originalString = row.article;
        var str;
        if(originalString){
          var updateddes =  originalString.replace(/(<([^>]+)>)/gi, "");
            if (updateddes.length > 100) {
              str = updateddes.substring(0, 180);
              if (str.endsWith(" ")) {
                  str = str.substring(0, str.length - 1);
              }
                  str = str + "...";
            }
            else{
                  str = updateddes;
            }
              rowData.description = str;
        }
        else{
          if (row.description.length > 100) {
            str = row.description.substring(0, 180);
            if (str.endsWith(" ")) {
              str = str.substring(0, str.length - 1);
            }
            str = str + "...";
          } 
          else {
            str = row.description;
          }
          rowData.description = str;
        }
        
        if (rowData.link == undefined) {
          this.isLink = false;
        } else {
          this.isLink = true;
        }
        rowData.link = row.link;
        rowData.islink = this.isLink;

        if (this.data.length < 3) {
          this.data.push(rowData);
        }
        
      });
      // this.data = result.data.newupdateList;
      result.data.newupdateList.forEach((item) => {
        let vido1 = {};
        vido1 = {
          id: item.id,
          title: item.title,
          news_date: item.news_date,
          description: item.description,
          link: item.link
        };
        this.newsDet.push(vido1);
        var titlestr;
        if(item.title.length > 25){
            titlestr=item.title.substring(0,25);
            if(titlestr.endsWith(' ')){
                titlestr=titlestr.substring(0,titlestr.length-1);
            }
            titlestr = titlestr+'...';
        }else{
            titlestr = item.title;
        }
        var originalString = item.article;
        var str;
        if(originalString){
          var updateddes =  originalString.replace(/(<([^>]+)>)/gi, "");
            if (updateddes.length > 100) {
              str = updateddes.substring(0, 180);
              if (str.endsWith(" ")) {
                  str = str.substring(0, str.length - 1);
              }
                  str = str + "...";
            }
            else{
                  str = updateddes;
            }
        }
        else{
          if (item.description.length > 100) {
            str = item.description.substring(0, 180);
            if (str.endsWith(" ")) {
              str = str.substring(0, str.length - 1);
            }
            str = str + "...";
          } else {
            str = item.description;
          }
        }
        if(this.isMx || this.isAr){
          this.titleList.push(titlestr);
        }else{
          this.titleList.push(item.title);
        }
        
        this.descList.push(str);
        this.linkList.push(item.link);
      });
    }
  }

  get titleData() {
    return this.titleList[0];
  }
  get descData() {
    return this.descList[0];
  }
  get linkData() {
    return this.linkList[0];
  }

  get titleData1() {
    return this.titleList[1];
  }
  get descData1() {
    return this.descList[1];
  }
  get linkData1() {
    return this.linkList[1];
  }
}