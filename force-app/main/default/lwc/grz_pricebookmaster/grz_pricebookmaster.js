import { LightningElement, track, wire, api } from 'lwc';
import getPriceBookDetailList from '@salesforce/apex/Grz_PriceBookMasterClass.getPriceBookDetailList';
import updatePriceBookMastersonAccount from '@salesforce/apex/Grz_PriceBookMasterClass.updatePriceBookMastersonAccount';
import deletePriceBookMastersonAccount from '@salesforce/apex/Grz_PriceBookMasterClass.deletePriceBookMastersonAccount';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import ItalyLabel from '@salesforce/label/c.Grz_ItalyPriceBookMaster';

export default class Grz_pricebookmaster extends LightningElement {

label = {
        ItalyLabel
    };
@track testdetails;
@api recordId;
@track editvalue;
@track delvalue;
@track saveval;
@track currentedit= true;
@track pricevalue;
@track isLoading = false;

@wire(getPriceBookDetailList,{Accountrecord: "$recordId"})
    getPriceBookDetailList(result) {
           this.isLoading = true; 
          console.log('result+++++ ',result);
           console.log('result.data+++++ ',result.data);
        if (result.data) {
            this.isLoading = false;
             console.log('lenth+++++ ',result.data.length);
            this.testdetails = result.data.PriceBookDetailList;
            console.log('testdetails+++++ ',this.testdetails.length);
            
        
    }
 
            
        else if (result.error) {
            this.error = result.error;
        }
    } 
     showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title, message, variant
        }))
    }
    handleMethod(event){
         this.pricevalue = event.target.value;
         console.log('this.pricevalue-----',this.pricevalue);
    }
    handleEditAction(event){
        
        //this.currentedit = false;
         this.editvalue = event.currentTarget.dataset.id;
          console.log('this.editvalue-----',this.editvalue);
      // temp = this.template.querySelector(`[data-id="${editvalue}"]`);
      // console.log("tem--",temp);
        this.template.querySelector("[data-id="+this.editvalue+"]").disabled = false;
       
     
        console.log('this.editvalue-----',this.template.querySelector("lightning-input[data-id]"));
    }
     handleCellChanges(event) {
        
        var theEvent = event || window.event;
        
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
        console.log('Key cell ', key);
        // var regex = /[0-9]|\./;
          var regex = /[0-9]/;
        if (!regex.test(key)) {
            theEvent.returnValue = false;
        }
      
    }
     handleDeleteAction(event){
        this.delvalue = event.currentTarget.dataset.id;
        console.log('this.delvalue-----',this.delvalue);
         deletePriceBookMastersonAccount({ pricerecordid: this.delvalue})
          .then((result)=>{
                const res = result;
                console.log('res---',res);
                console.log(res.includes('Update failed'));
                if(res.includes('Update failed')){
                    this.showToast("Error",error.message,"error")
                }else{
                    this.showToast("Success",'Price Book Master Deleted',"success");
                    this.template.querySelector('[data-id='+this.delvalue+']').parentNode.parentNode.style.display = 'none';
                }
                          
          }).catch(error=>{
              //error handling
              this.showToast("Error",error.message,"error")
          });
        
    }
    handleSaveAction(event){
        this.saveval= event.currentTarget.dataset.id;
        console.log('this.savevalue-----',this.saveval);
         updatePriceBookMastersonAccount({ pricerecordid: this.saveval, newmaterialprice: this.pricevalue})
          .then(()=>{
              this.showToast("Success",'Price Book Masters Updated',"success")             
          }).catch(error=>{
              //error handling
              this.showToast("Error",error.message,"error")
          });
        
          this.template.querySelector("[data-id="+this.saveval+"]").disabled = true;
    }


}