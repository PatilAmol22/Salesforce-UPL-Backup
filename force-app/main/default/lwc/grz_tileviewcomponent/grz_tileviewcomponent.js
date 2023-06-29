import { LightningElement, track, wire } from "lwc";
import getOrderAndTicketCountAll from "@salesforce/apex/grz_TileViewCountController.getOrderAndTicketCountAll";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import OrdersLabel from "@salesforce/label/c.Grz_Orders";
import TicketLable from "@salesforce/label/c.Grz_Tickets";
import LANG from "@salesforce/i18n/lang";
export default class Grz_TileViewComponent extends LightningElement {
  @track label = { OrdersLabel, TicketLable };
  @track orderSummary = Icons + "/Grz_Resourse/Images/OrderSummaryWhite.png";
  @track ticketSummary = Icons + "/Grz_Resourse/Images/TicketSummaryWhite.png";
  @track profileIcon = Icons + "/Grz_Resourse/Images/profileIcon.png";
  @track salesOrderCount;
  @track openOrdersCountCl;
  @track completelyProcessedCount;
  @track ticketCount;
  @track totalCount;
  @track userText;
  @track sapCode;
  @track language = LANG;
  @track error;
  @track isBr = false;
  @track isCl = false;
  @track isIn = false;
  @track isInternal = false;
  connectedCallback() {
    if (this.language == "pt-BR" || this.language =="es-MX") {
      this.isBr = true;
    } else if(this.language =="es"){
      this.isCl = true;
    }
    else {
      this.isIn = true;
    }
  }
  renderedCallback(){
    var whichTile;
    var firstTileHeight;
    var temp;
    var widthofPage;
    setTimeout(() => {
      widthofPage = Math.max(
        document.body.scrollWidth,
        document.documentElement.scrollWidth,
        document.body.offsetWidth,
        document.documentElement.offsetWidth,
        document.body.clientWidth,
        document.documentElement.clientWidth
      );

    if(this.isIn==true && widthofPage>767){
      var seconTile=this.template.querySelector(".childDiv3");
    var secondTileMaxHeight=Math.max(seconTile.scrollHeight,seconTile.offsetHeight,seconTile.clientHeight);
    console.log('secondTileMaxHeight==>'+secondTileMaxHeight);
      if(this.isInternal==true){
        temp=this.template.querySelector(".childDiv1");
        whichTile='first';
      }
      else{
        temp=this.template.querySelector(".childDiv2");
        whichTile='second';
      }
      firstTileHeight=Math.max(temp.scrollHeight,temp.offsetHeight,temp.clientHeight);
      console.log('firstTileHeight==>'+firstTileHeight);
      if(secondTileMaxHeight>firstTileHeight){
        console.log('inside if');
        if(whichTile=='first'){
          this.template.querySelector(".sapTabcolorInternal").style.height=(secondTileMaxHeight-1) + "px";
        }
        else if(whichTile=='second'){
          this.template.querySelector(".sapTabcolor-en").style.height=(secondTileMaxHeight-1) + "px";
        }
      }
    }
    else if(this.isBr==true && widthofPage>767){
      var seconTile=this.template.querySelector(".BrazilTileTwo");
    var secondTileMaxHeight=Math.max(seconTile.scrollHeight,seconTile.offsetHeight,seconTile.clientHeight);
    console.log('secondTileMaxHeight==>'+secondTileMaxHeight);
    var firstTile=  this.template.querySelector(".BrazilTileOne");
    firstTileHeight=Math.max(firstTile.scrollHeight,firstTile.offsetHeight,firstTile.clientHeight);
      console.log('firstTileHeight==>'+firstTileHeight);
      if(secondTileMaxHeight>firstTileHeight){
        console.log('inside if');
       this.template.querySelector(".BrazilTileOne").style.height=(secondTileMaxHeight) + "px";
          }
         else if(secondTileMaxHeight<firstTileHeight){
            console.log('inside else if');
           this.template.querySelector(".BrazilTileTwo").style.height=(firstTileHeight) + "px";
              }
    }
  },1000);
}
  @wire(getOrderAndTicketCountAll, { language: "$language" })
  getOrderAndTicketCountAll(results) {
    if (results.data) {
      console.log("Tile View wire result ===> ", results.data);
      this.completelyProcessedCount =  results.data.salesOrderCompletelyProcessedCount;
      this.salesOrderCount = results.data.salesOrderCount;
      this.openOrdersCountCl = results.data.openOrdersCountCl;
      this.ticketCount = results.data.ticketCount;
      this.totalCount = results.data.ticketTotalCount;
      this.sapCode = results.data.sapCode;
      this.userText = results.data.userText;
      this.isInternal = results.data.isInternal;
    }
    if (results.error) {
      this.error = results.error;
      console.log("Tile view wire error ===> ", this.error);
    }
  }
}