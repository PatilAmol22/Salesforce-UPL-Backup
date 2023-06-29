import { LightningElement, track, wire, api } from 'lwc';
import deletePriceBookMasters from '@salesforce/apex/Grz_PriceBookMasterClass.deletePriceBookMasters';
import updatePriceBookMasters from '@salesforce/apex/Grz_PriceBookMasterClass.updatePriceBookMasters';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import ItalyLabel from '@salesforce/label/c.Grz_ItalyPrice';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class Grz_deletepricebookmaster extends LightningElement {


@track testdetails;
@api recordId;
 @track isShowModal = false;
@track pricevalue;
   @track labellist= []; 
   @track updateLabel;
   @track updateSection;
   @track deleteSection;
    @track clickupdateSection;
   @track clickexpireSection;
    @track isLoading = false;

    hideModalBox() {  
        this.isShowModal = false;
    }

connectedCallback() {
    try{
    console.log('ItalyLabel',ItalyLabel);
    this.labellist = ItalyLabel.toString().split(',');
    this.updateLabel = this.labellist[0];
    this.updateSection= this.labellist[1];
    this.deleteSection= this.labellist[2];
    this.clickupdateSection= this.labellist[3];
    this.clickexpireSection= this.labellist[4];

    }
    catch(e){
        console.log('Exception---',e.getMessage());
    }
  
}
closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
  doDelete() {
         this.isLoading = true;
       deletePriceBookMasters({ skurecordid: this.recordId})
          .then(result=>{
              console.log('resultd del',result);
              if(result){
                  this.showToast("Success",'Price Book Masters Deleted',"success");
                  this.isLoading = false;  
                  this.isShowModal = false;
                  setTimeout(() => {
                 this.dispatchEvent(new CloseActionScreenEvent());
                 }, 5000);  
              }
              else{
                   this.showToast("Error","No Price Book Master found","error");
                    this.isLoading = false;
                    this.isShowModal = false;
                    setTimeout(() => {
                    this.dispatchEvent(new CloseActionScreenEvent());
                    }, 5000);

              }
                     
          }).catch(error=>{
              //error handling
              this.showToast("Error",error.message,"error");
              this.isLoading = false;
              this.isShowModal = false;
              setTimeout(() => {
                 this.dispatchEvent(new CloseActionScreenEvent());
                 }, 5000);
          });
           
     }
     showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title, message, variant
        }))
    }
doUpdate(){
    
    console.log('this.pricevalue----',this.pricevalue);
     this.isLoading = true;
    console.log('this.isLoading----',this.isLoading);
   if(this.pricevalue){
      
       updatePriceBookMasters({ skurecordid: this.recordId, newmaterialprice: this.pricevalue})
        
          .then(result=>{
             console.log('result---',result);
             if(result){
                this.showToast("Success",'Price Book Masters Updated',"success");
                this.isLoading = false;  
                setTimeout(() => {
                this.dispatchEvent(new CloseActionScreenEvent());
                }, 5000);
             }
             else{
            this.showToast("Error","No Price Book Master found","error");
              this.isLoading = false;
              setTimeout(() => {
                this.dispatchEvent(new CloseActionScreenEvent());
                }, 5000);
             }
                    
          }).catch(error=>{
              
              this.showToast("Error",error.message,"error");
              this.isLoading = false;
              setTimeout(() => {
                this.dispatchEvent(new CloseActionScreenEvent());
                }, 5000);
          });
     
      console.log('this.isLoading--2--',this.isLoading);  
   }
   else{
        this.showToast("Error",'Please enter the Price',"error");
        setTimeout(() => {
                this.dispatchEvent(new CloseActionScreenEvent());
                }, 5000);
         //this.isLoading = false;
   }
   
     
    
}
  handlePriceChange(event){
    
       this.pricevalue = event.target.value;
       
   }
   
  
showmodal(){
this.isShowModal = true;
}


}