import { LightningElement,track,api } from 'lwc';
import homePage from '@salesforce/resourceUrl/Grz_Resourse';
import home from "@salesforce/label/c.Grz_Home";
export default class Grz_breadCrumb extends LightningElement {
    labels = {
        home
      };
    @api labelone;
    @api labeltwo;
    @api labelthree;
    @api linkone;
    @api linktwo;
    @api linkthree;
    @track homeImg = homePage + '/Grz_Resourse/Images/Home.png';
    isStdPortal=false;//Added by Akhilesh

    //Added By Akhilesh to handle Menu redirection to be portal wise
    connectedCallback(){
       var moburl = (window.location.href).split('/s/')[0];
       console.log('url link'+moburl);
       if(moburl.includes('uplpartnerportalstd')){
        this.isStdPortal=true;
       }else{
        this.isStdPortal=false;
       }
    }

    renderedCallback(){
        if(this.labeltwo=='' || this.labeltwo==undefined){
            this.template.querySelector('[data-id="twoCls"]').classList.add('hideClass');
        }
        else{
            this.template.querySelector('[data-id="twoCls"]').classList.remove('hideClass');
        }
        if(this.labelthree=='' || this.labelthree==undefined){
            this.template.querySelector('[data-id="threeCls"]').classList.add('hideClass');
        }
        else{
            this.template.querySelector('[data-id="threeCls"]').classList.remove('hideClass');
        }
        if(this.linkone==''){
            this.template.querySelector('[data-id="oneClass"]').classList.add('emptyLink');
        }
        if(this.linktwo==''){
            this.template.querySelector('[data-id="twoClass"]').classList.add('emptyLink');
        }
        if(this.linkthree==''){
            this.template.querySelector('[data-id="threeClass"]').classList.add('emptyLink');
        }
        
    }
    
}