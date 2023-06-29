import { api, LightningElement } from 'lwc';

export default class LiquidationCustomErrorCmp extends LightningElement {
    @api errorTitle;
    @api errorMesssage = [];
    @api showErrorModal = false;

    closeErrorModal(){
        this.dispatchEvent(new CustomEvent('closeerrormsg'));
        this.showErrorModal = false;
    }
}