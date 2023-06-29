import { LightningElement,api,track,wire} from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import futureUpdateHistoryCallout from '@salesforce/apex/BrazilRebateIntegrationCallController.futureUpdateHistoryCallout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';

export default class BrazilRebateIntegrationCallThroughButton extends LightningElement {
  closeAction=false;
  error;
  @api recordId;
  isModalOpen = false;
  connectedCallback() {
  console.log('eneter in 1611'+this.recordId);
  this.invoke();
  }

 @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
       if (currentPageReference) {
          console.log('@@@@@@@@@@@@@'+JSON.stringify(currentPageReference));
          this.recordId = currentPageReference.state.recordId;
          console.log('@@@@@@@@@@@@@'+this.recordId); 
       }
    }



   @api invoke() {
     console.log('eneter in 1622'+this.recordId);
       this.isModalOpen = true;
     futureUpdateHistoryCallout({ContractId:this.recordId})

.then((result)=> {
    this.isModalOpen = false;
   console.log('eneter in 16');
   if(result=='success'){
   this.closeQuickAction();
    this.showToast();
   console.log('result'+result);
   }
   
    
   
})

 .catch((error) => {
     this.isModalOpen = false;
     console.log('error'+JSON.stringify(error));
     this.error=JSON.stringify(error.body.message);
     this.closeQuickAction();
   console.error(error.body.message);
   const event = new ShowToastEvent({
        title: 'Error',
        message: this.error,
        variant: 'Error',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);

   
 })


this.updateRecordView(this.recordId);

  }

//     @api set recordId(value) {
       
//     this._recordId = value;
// console.log(this._recordId);

// futureUpdateHistoryCallout({ContractId:this._recordId})

// .then((result)=> {
//    console.log('eneter in 16');
//    if(result=='success'){
//    this.closeQuickAction();
//     this.showToast();
//    console.log('result'+result);
//    }
   
    
   
// })

//  .catch((error) => {
//      console.log('error'+JSON.stringify(error));
//      this.error=JSON.stringify(error.body.message);
//      this.closeQuickAction();
//    console.error(error.body.message);
//    const event = new ShowToastEvent({
//         title: 'Erro',
//         message: this.error,
//         variant: 'Error',
//         mode: 'dismissable'
//     });
//     this.dispatchEvent(event);

   
//  })


// this.updateRecordView(this._recordId);


// }
    
closeQuickAction() {
    this.closeAction=true;
    this.dispatchEvent(new CloseActionScreenEvent());
}


// get recordId() {
//     return this._recordId;
// }
updateRecordView(recordId) {
    updateRecord({ fields: { Id:this.recordId}});
  }
  showToast() {
      console.log('enter in toast');
    const event = new ShowToastEvent({
        title: 'Sucesso',
        message: 'O registro foi enviado com sucesso',
        variant: 'success',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}

}