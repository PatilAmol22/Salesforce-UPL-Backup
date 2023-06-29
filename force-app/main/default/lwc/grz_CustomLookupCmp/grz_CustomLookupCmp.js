import { LightningElement, track, api } from 'lwc';
import findRecord from '@salesforce/apex/CustomLookupController.findRecords';

export default class Grz_CustomLookupCmp extends LightningElement {
    @track records;
    @track error;
    @track selectedRecord;
    @api index;
    @api relationshipfield;
    @api iconname = "standard:account";
    @api objectName = 'Account';
    @api searchField = 'Name';

    handleOnChange(event){
        const searchKey = event.detail.value;
        findRecord({
            searchKey : searchKey,
            objectName : this.objectName,
            searchField : this.searchField
        })
        .then(result => {
            this.records = result;
            for(let i = 0; i< this.records.length; i++){
                const rec = this.records[i];
                this.records[i].Name=rec[this.searchField];
                console.log('records['+i+'].Name: ', this.records[i].Name);
            }
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.records = undefined;
        });
    }

    handleSelect(event){
        const selectedRecordId = event.detail;
        this.selectedRecord = this.records.find(record => record.Id === selectedRecordId);
        const selectedRecordEvent = new CustomEvent(
            "selectedrec",
            {
                detail : { recordId : selectedRecordId, index : this.index, relationshipfield : this.relationshipfield}
            }
        );
        this.dispatchEvent(selectedRecordEvent);
    }

    handleRemove(event){
        event.preventDefault();
        this.selectedRecord = undefined;
        this.records = undefined;
        this.error = undefined;
        /* fire the event with the values of undefined for the selected record Id */
        const selectedRecordEvent = new CustomEvent(
            "selectedrec",
            {
                detail : { recordId : undefined, index : this.index, relationshipfield : this.relationshipfield}
            }
        );
        this.dispatchEvent(selectedRecordEvent);
    }
}