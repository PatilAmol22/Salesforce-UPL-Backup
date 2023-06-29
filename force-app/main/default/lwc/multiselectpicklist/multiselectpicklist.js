import { LightningElement, api, track } from 'lwc';
 
export default class PicklistColumn extends LightningElement {
    @api label;
    @api placeholder;
    @api options;
    @api value;
    @api context;
    @track showPicklist = false;
 
    renderedCallback() {
        console.log('this.value ',this.value );
        if(!Array.isArray(this.value)&&this.value){
            console.log('this.splitvalue ',this.value );
            let val=this.value.split(';')
            this.value=val;
        }
        console.log('this.value1 ',this.value );
       // this.template.querySelector("lightning-dual-listbox")?.focus();
    }
 
    closePicklist() {
        this.showPicklist = false;
    }
    onmouseleavePic(){
        this.showPicklist = false;
    }
 
    handleChange(event) {
       
        //show the selected value on UI
        this.value = event.detail.value;
 
        //fire event to send context and selected value to the data table
        this.dispatchEvent(new CustomEvent('picklistchanged', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                data: { context: this.context, value: this.value }
            }
        }));
    }
 
    handleClick(event) {
        this.showPicklist = true;
    }
}