import { LightningElement, wire, track } from 'lwc';
import getCount from '@salesforce/apex/OpenOrderCount.getCount';
import Open_Order_By_Status from '@salesforce/label/c.Open_Order_By_Status';
import Partially_processed from '@salesforce/label/c.Partially_processed';
import Completed from '@salesforce/label/c.Completed';
import Not_Delivered from '@salesforce/label/c.Not_Delivered';
export default class OpenOrderCount extends LightningElement {
    @track partiallyProcessed=0;
    @track notYetProcessed=0;
    @track completelyProcessed=0;

    @track label = {
        Open_Order_By_Status,
        Partially_processed,
        Completed,
        Not_Delivered
    }

    @wire(getCount)
    wiredContacts({ error, data }) {
        if (data) {
            this.partiallyProcessed = data.partiallyProcessed;
            this.notYetProcessed = data.notYetProcessed;
            this.completelyProcessed = data.completelyProcessed;     
        } else if (error) {
            this.error = error;
        }
    }

}