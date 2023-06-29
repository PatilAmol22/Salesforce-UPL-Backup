import { LightningElement } from 'lwc';
import close from '@salesforce/label/c.Close';
import Are_you_sure_want_to_submit from '@salesforce/label/c.Are_you_sure_want_to_submit';
import No from '@salesforce/label/c.No';
import Yes from '@salesforce/label/c.Yes';

export default class GenericModelPopup extends LightningElement {
    
    labels = {
        close,
        Are_you_sure_want_to_submit,
        No,
        Yes
    }

    closeModalBox(){
        this.dispatchEvent(new CustomEvent('close',{detail:false}))
    }
    handleModelsubmit(){
        this.dispatchEvent(new CustomEvent('modelsubmit',{detail:false}))
    }
}