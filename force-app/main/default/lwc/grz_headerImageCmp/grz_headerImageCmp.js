import { LightningElement, track, wire, api } from 'lwc';
import LANG from "@salesforce/i18n/lang";
export default class Grz_headerImageCmp extends LightningElement {
    @api imglabel;
    @api bgimg;
    @api customcss;
    //RITM0575970 Grz(Nikhil Verma) 21-06-2023-->
    @track language = LANG;
    @track isIndia = false;
    renderedCallback(){
        if(this.language == "en-US"){
            this.isIndia = true;
        }
    }
}