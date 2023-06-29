import { LightningElement,track,api } from 'lwc';

export default class CustomTableColumn extends LightningElement {

    @api column;
    @api record;
    strValue
    @track value;
    @track field;
    @api rid;
    @api objectApiName;
    @api fieldType;
    connectedCallback() {
        this.strValue = this.record[ this.column ];
    }

    handleCellChanges(event) {
        //var theEvent = event || window.event;
        this.value = event.target.value;
        this.field = event.target.name;
        this.rid = event.target.dataset.id;
        // Handle key press
        //var key = theEvent.keyCode || theEvent.which;
        //key = String.fromCharCode(key);
    }

    @api
    inputValue() {
        return {value : this.value, field: this.field, rid:this.rid, objectAPIName:this.objectApiName};
    }

    get isText() {
        if(this.fieldType)
        {
            return this.fieldType.toLowerCase()=='text' || this.fieldType.toLowerCase()=='number' || this.fieldType.toLowerCase()=='email';
        }
        return false;
    }

}