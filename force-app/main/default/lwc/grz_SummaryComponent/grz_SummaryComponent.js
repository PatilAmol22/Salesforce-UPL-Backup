import { api, LightningElement, track, wire } from 'lwc';
import getSummaryTabsList from '@salesforce/apex/grz_SummaryTabsController.getSummaryTabsList'
import Icons from '@salesforce/resourceUrl/Grz_Resourse';
//import getSurveyData from "@salesforce/apex/grz_FooterController.getSurveyData";
import getNotice from "@salesforce/apex/grz_SummaryTabsController.getNotice";
import LANG from '@salesforce/i18n/lang';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class OrderSummaryComponent extends LightningElement {

    @track displaySaleOrderdata = true;
    @track displayCaseOrderdata = false;
    @track tabData;
    @track CaseData;
    @track CreditData;
    @track error;
    @track language = LANG;
    @track activeValueMessage = '';
    @track urlname;
    @track summarylink;
    @track customLabel;
    @track currentLabel;

    // @track isInExternal = false;
    // @track highligthSurveyIn = false;
    // @track surveyURLIn;
    // @track LastModifiedDateIn;

    
    @wire(getSummaryTabsList,{language : '$language'})
    SummaryTabsRecord(results){
        if(results.data){
           // console.log('orderSummary img path : '+this.orderSummary);
           // console.log('Summary Tabs Record : '+JSON.stringify(results.data));
            this.tabData=results.data.summaryTabsList;
            this.customLabel = results.data.CustomLabel;
        }
        if(results.error){
            this.error=results.error;
        }
    }
    //Changes by Grazitti team for India SWOT changes 11 Oct 22
    @track showNotice=false;
    @wire(getNotice, { language: "$language" })
    getNotice(results) {
      if (results.data) {
        this.noticeData = results.data;
        console.log('this.noticeData==>',this.noticeData);
        if(this.noticeData.length > 0){
          this.showNotice = true;
        }else{
          this.showNotice = false;
        }
      }
      if (results.error) {
        this.error = results.error;
      }
    }
//     @wire(getSurveyData, { language: "$language" ,placeOfCalling:false})
//   getSurveyData(results) {
//     if (results.data) {
//        console.log('xxx',results.data);
//         let dt;
//         this.isInExternal = results.data.isInExternal;
//         this.highligthSurveyIn = results.data.highligthSurveyIn;
//         this.surveyURLIn = results.data.surveyURLIn;
//         if(results.data.LastModifiedDateIn != null && results.data.LastModifiedDateIn != ' ' && results.data.LastModifiedDateIn != undefined)
//         dt = new Date(results.data.LastModifiedDateIn.substring(0,10));
     
     
//         const dtf = new Intl.DateTimeFormat('en', {
//             year: 'numeric',
//             month: 'short',
//             day: '2-digit'
//         })
//         const [{value: mo}, , {value: da}, , {value: ye}] = dtf.formatToParts(dt);
//         let formatedDate = `${mo} ${da}, ${ye}`;

//         this.LastModifiedDateIn = formatedDate;
    

//     }
//     else{
//          this.error = results.error;
//     }
//     if (results.error) {
//       this.error = results.error;
//     }
//   }

    renderedCallback() {
        Promise.all([
            loadStyle(this, Icons+'/Grz_Resourse/CSS/SummaryTabs.css') 
        ])
    }

    handleActive(event) {
        this.urlname = event.target.value;
        console.log("this.urlname : "+this.urlname);
        this.activeValueMessage = event.target.dataset.name;
        console.log('this.activeValueMessage==>'+this.activeValueMessage);
        if( this.activeValueMessage=='Order Summary'){
            this.displaySaleOrderdata = true;
            this.displayCaseOrderdata = false;
        }
        else{
            this.displaySaleOrderdata = false;
            this.displayCaseOrderdata = true;
        }
    }

    handleViewAllClick(event){
        console.log('on link click');
        this.summarylink = this.urlname;
    }

    handleTabsClick(event){
        var dataid = event.target.dataset.id;
        var dataName = event.target.dataset.name; 
        console.log("dataName : "+dataName);
        if( dataid=='Order Summary'){
            this.template.querySelector('[data-name="' +dataid+ '"]').classList.add('selectedBorderclr');
            this.template.querySelector('[data-name="' +dataid+ '"]').classList.remove('selectedBorderclr');
            this.displaySaleOrderdata = true;
            this.displayCaseOrderdata = false;
        }
        else{
            this.template.querySelector('[data-name="' +dataid+ '"]').classList.add('selectedBorderclr');
            this.template.querySelector('[data-name="' +dataid+ '"]').classList.remove('selectedBorderclr');
            this.displaySaleOrderdata = false;
            this.displayCaseOrderdata = true;
        }
        
    }

}