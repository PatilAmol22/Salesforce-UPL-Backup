import { LightningElement,track,api } from 'lwc';
import getApprovalHistory from '@salesforce/apex/OrderArgentinaController.getApprovalHistory';

export default class ArgentinaApprovalProcess extends LightningElement {
    data=[];
    isApprovalProcess=false;
    @api recordId;
    connectedCallback(){
        getApprovalHistory({
            recordId : this.recordId
        }).then(result=>{
            console.log('Result => ',result);
            if(result!=null || result!='')
            {this.isApprovalProcess=true;
                this.data = JSON.parse(result);
                console.log('data=> ',this.data);
            }
           

        }).catch(Error => {
            console.log('Error => ',Error);
        })
    }

}