import {LightningElement, api, track} from 'lwc';
import fetchApprovals from '@salesforce/apex/Grz_RsoApprovalController.fetchApprovals';
import processApprovals from '@salesforce/apex/Grz_RsoApprovalController.processApprovals';
export default class Grz_RsoApprovalLWC extends LightningElement {
    showSpinner=true;
    pendingApproval=false;
    processDataF=[];
    connectedCallback() {
        this.getServerData();
    }

    handleClick(event) {
        var obl=[];
        this.processDataF.forEach(function (element) {
            if(element.rsoName===event.target.title){
                element.disable=true;
                if(event.target.label==='Approve'){
                    element.status='Approved'
                element.theme='slds-theme_success slds-theme_alert-texture slds-border_top slds-border_right slds-border_bottom slds-border_left';
                }
                if(event.target.label==='Reject'){
                    element.theme='slds-theme_error slds-theme_alert-texture slds-border_top slds-border_right slds-border_bottom slds-border_left';
                    element.status='Rejected';
                }
                processApprovals({
                    insId: element.wi,
                action1: event.target.label,
                comment: element.newComment,
                }).then(result => {
                }).catch(error => {
                    alert('error is: ' + JSON.stringify(error));
                });
                }
            obl.push(element);
        });
        this.processDataF=[];
        this.processDataF=obl;
        //alert(JSON.stringify(obl));
    }


    handleText(event) {
        var obl=[];
        this.processDataF.forEach(function (element) {
            if(element.rsoName===event.target.dataset.targetId){
                element.newComment=event.target.value;
                }
            obl.push(element);
        });
        this.processDataF=[];
        this.processDataF=obl;
        
    }

    getServerData() {
        fetchApprovals({
            
        }).then(result => {
            if(result.length>0){
                this.pendingApproval=true;
                let processData = (result);
                //alert(JSON.stringify(result));
                this.processDataF=processData;
                this.showSpinner=false;

            }else{
                //alert('no toast');//this.showToast('Validation Error', 'No Result Found', 'error', true);
                this.showSpinner=false;
            }
            
        }).catch(error => {
            //alert('error is: ' + JSON.stringify(error));
            this.showSpinner=false;
        });
    }


}