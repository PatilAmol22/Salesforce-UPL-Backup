import { LightningElement , api, track, wire} from 'lwc';
import getRSO from '@salesforce/apex/RecallRSOController.getRSO';
import getPicklistValue from '@salesforce/apex/RecallRSOController.getPicklistValue';
import updateRSO from '@salesforce/apex/RecallRSOController.updateRSO';
import {CurrentPageReference} from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import Sub_Status__c from '@salesforce/schema/Return_Sales_Order__c.Sub_Status__c';
import Return_Type from '@salesforce/label/c.Return_Type';
import Status from '@salesforce/label/c.Status';
import Sub_Status from '@salesforce/label/c.Sub_Status';
import RSO_SAP_Number_SFDC from '@salesforce/label/c.RSO_SAP_Number_SFDC';
import Save from '@salesforce/label/c.Save';
import Cancel from '@salesforce/label/c.Cancel';
import Comment from '@salesforce/label/c.Comment';




export default class RecallApprovalComp extends LightningElement {
    @track isModalOpen = false;
    @api recordId;
    @track RSOData={RSOOrderNo:'',RSOSapNO:'',Status:'',SubStatus1:'',
                    Comment:'',ReturnType:'',RaisedBy:'',ReturnAmount:'',
                    IsTechnical:''};
    @track SubStatus=[];
    @track picklistValue;
    @track cardTitle;
    @track Type;
    @track RsoRaisedBy;
    @track RecSubStatus;
    @track Amount;
    @track TechnicalInspection;
    @track IsRefusal;

    label={
        Return_Type:Return_Type,
        RSO_SAP_Number_SFDC:RSO_SAP_Number_SFDC,
        Status:Status,
        Sub_Status:Sub_Status,
        Comment:Comment,
        Save:Save,
        Cancel:Cancel
    }
   

//     @wire(CurrentPageReference)
//      getStateParameters(currentPageReference) {
//      if (currentPageReference) {
//           this.recordId = currentPageReference.state.recordId;     }
//    };

//  @wire(getPicklistValues, {recordTypeId: '012000000000000AAA', fieldApiName: Sub_Status__c })
//     propertyOrFunction1({error,data}){ 
//      if(data)      {
//        console.log('Status data',data.values);
//         this.SubStatus=data.values.slice(0,13);      }
     
//     };


    
    

    connectedCallback() {
        
        this.isModalOpen = true;
        console.log('Record',this.recordId);
        getRSO({recordId:this.recordId}
            ).then((result)=> {
                console.log('@@RSOData ',JSON.stringify(result));
                this.RSOData = JSON.parse(JSON.stringify(result));
                this.RSOData.RSOOrderNo=result.RSO_SFDC_Number__c;
                this.RSOData.RSOSapNO=result.RSO_SAP_Number__c;
                this.RSOData.Status=result.Order_Status__c;
                this.RSOData.SubStatus1=result.Sub_Status__c;
                this.RSOData.Comment=result.Comment__c;
                this.RSOData.ReturnType=result.Return_Type__c;
                this.cardTitle=result.Name;
                this.Type=result.Return_Type__c;
                console.log('##Type',this.Type);
                this.RsoRaisedBy=result.RSO_Raised_By__c;
                console.log('##RaisedBy',this.RsoRaisedBy);
                this.Amount=result.Return_Amount__c;
                this.TechnicalInspection=result.Necessary_Technical_Inspection__c;
                console.log('Technical',this.TechnicalInspection);
                this.IsRefusal=result.Refusal__c;
                console.log('Refusal==>',this.IsRefusal);
                this.RecSubStatus=result.Sub_Status__c;
                console.log('SubStatus',this.RecSubStatus);
            })
            .catch(error=>{
                console.log('Error occure ',error);
              });
    }

    @wire(getPicklistValue,{Type1:'$Type',RsoRaisedBy:'$RsoRaisedBy',RecStatus:'$RecSubStatus',Refusal:'$IsRefusal'}) 
    propertyOrFunction({error,data}){
  
    if(data){
       let tempdata=data[0]?.Sub_Status__c?.split(';')
   
       let valueToRemove=[];
     console.log('ValuesToRemove',valueToRemove);
      
     let index = tempdata.indexOf(this.RecSubStatus);
     console.log('@@@index ',index);
     const newArray = tempdata.slice(0, index);
     console.log('@@@New Array ',newArray);
      
       console.log('picklist',tempdata);
       if(this.Amount<300000){
              console.log('Amount',this.Amount);
      
        valueToRemove.push('Pending At CFO','Pending At Supply Director');
        tempdata=tempdata?.filter(op=>(valueToRemove.includes(op)==false))
       }

       if(this.TechnicalInspection=='No'){
        console.log('In Technical',this.TechnicalInspection);
        valueToRemove.push('Pending At Inspection Team');
        tempdata=tempdata?.filter(op=>(valueToRemove.includes(op)==false))

       }
      
      let options=newArray.map(ele=>{
       return{label:ele,value:ele}
       
      })
      this.SubStatus=options;
      console.log('Options',this.SubStatus);
         
  }if(error){
   console.log(error);
  }
};

    handleChange(event){
        this.RSOData.SubStatus1=event.target.value;
        
        console.log('In Handle', this.RSOData.SubStatus1);
    }
    
    handleFocus(event){
        this.RSOData.Comment=event.target.value;
        console.log('@@Comment:',this.RSOData.Comment);

    }

    

    handleSave(event){
        console.log('Record Id',this.recordId);
        console.log('Pick value',this.RSOData.SubStatus1);

        updateRSO({recordId:this.recordId,picklistValue:this.RSOData.SubStatus1,comment:this.RSOData.Comment}
            ).then(result => {
                         
                    console.log('@@Result',result);
                    if(this.recordId!=''){
                        if(result!=''){
                              console.log('in Success',result); 
                              this.showToastmessage('Success','Record Updated Successfully.','Success');                    
                        }
                        else{
                           console.log('in Else Part');
                           this.showToastmessage('ErrorT','Fail To Update Record','Error');
                        }
                    }
                    this.dispatchEvent(new CustomEvent('close',{detail:false}))     
                   
            })
            .catch(error => {
                
                console.log('in Catch BLock',error);
                   
                })
    }

    // handleCancel(event){
    //     console.log( 'Record Id is' + this.recordId );
    //     this.dispatchEvent(new CloseActionScreenEvent());
    // }

    showToastmessage(title,message,varient){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
        
    }   
   
    
    

    closeModal() {
        // to close modal set isModalOpen track value as false
        // this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent('close',{detail:false}))
    }
    
}