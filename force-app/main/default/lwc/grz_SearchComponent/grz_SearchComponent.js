import { LightningElement, track } from 'lwc';
import fieldLabel from "@salesforce/label/c.GrzFieldLabel";
import fieldPlaceholder from "@salesforce/label/c.GrzFieldPlaceholder";
export default class Grz_SearchComponent extends LightningElement {
    @track searchKey;
    @track fieldLabel = fieldLabel;
    @track fieldPlaceholder = fieldPlaceholder;
    handleChange(event){
        /*eslint-disable no-console*/
        //console.log('Search Event Started');
        const searchKey = event.target.value;
        /*eslint-disable no-console*/
        event.preventDefault();
        const searchEvent = new CustomEvent(
            'change',
            {
                detail : searchKey
            }
        );
        this.dispatchEvent(searchEvent);
    }
}