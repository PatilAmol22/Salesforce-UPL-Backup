import { api, LightningElement } from 'lwc';
import updateLiquidationApproval from '@salesforce/apex/LiquidationAF.updateLiquidationApproval';
import approvedConfirmationLabel from '@salesforce/label/c.ApprovedConfirmation';
import rejectedConfirmationLabel from '@salesforce/label/c.RejectedConfirmation';

export default class LiquidationApproveRejectCmp extends LightningElement {
    //label
    label = {approvedConfirmationLabel,
            rejectedConfirmationLabel}

    //All JS variables
    @api showAppModal = false;
    @api showEditAppModal = false;
    @api showRejModal = false;
    @api terrCode;
    @api fisyear;
    @api liqMonth;

    remarks;
    approvalEditRemarks;
    rejectRemarks;
    actionName;
    hideSpinner = true;

    //handle Change event
    handleRemarkChange(event){
        var fieldname = event.target.name;

        if(fieldname == 'appRemarks'){
            this.remarks = event.target.value;
        }else if(fieldname == 'appEditRemarks'){
            this.remarks = event.target.value;
        }else if(fieldname == 'rejRemarks'){
            this.remarks = event.target.value;
        }
    }

    //handle Yes click for Approved Pop up
    submitApproved(){
        this.hideSpinner = false;
        this.actionName = 'Approved';
        console.log(this.actionName);
        this.updateApprovalHistory(this.actionName, this.terrCode, this.fisyear, this.liqMonth, this.remarks, this.salesOrgCodeFrmJs);

    }

    //handle No click for Approved Pop up
    closeAppModal(){
        this.dispatchEvent(new CustomEvent('closeapppopup'));
        this.showAppModal = false;
    }

    //handle Yes click for Reject Pop up
    submitReject(){
        this.hideSpinner = false;
        this.actionName = 'Rejected';
        this.updateApprovalHistory(this.actionName, this.terrCode, this.fisyear, this.liqMonth, this.remarks, this.salesOrgCodeFrmJs);
    }

    //handle No click for Reject Pop up
    closeRejAppModal(){
        this.dispatchEvent(new CustomEvent('closerejpopup'));
        this.showRejModal = false;
    }

    updateApprovalHistory(actionName, terrCode, fiscalYear, liqMonth, remarks, salesOrgCodeFrmJs){
        console.log(actionName);
        console.log(terrCode);
        console.log(fiscalYear);
        console.log(liqMonth);
        console.log(remarks);
        updateLiquidationApproval({
            actionName : actionName,
            terrCode : terrCode,
            fiscalYear : fiscalYear,
            liqMonth : liqMonth,
            remarks : remarks
        })
        .then(result => {
            console.log('result = '+result);
            //action after approval or reject
            this.hideSpinner = true;
            if(actionName == 'Approved'){
                this.closeAppModal();
            }else{
                this.closeRejAppModal();
            }
            this.dispatchEvent(new CustomEvent('fromapprej'));
        })
        .catch(error => {
            console.log('Something went wrong. Please contact system admin... '+error);
        })
    }
}