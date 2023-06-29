import { LightningElement,api } from 'lwc';
import search from '@salesforce/apex/SearchController.searchUsers';
const DELAY = 300;

export default class SearchComponent extends LightningElement {

    @api labelName='Search By Ownership';
    @api placeholder = 'Search';
    @api objName = 'User';
    @api fields = ['Name'];



    @api indexid;


    field;
    field1;
    field2;

    delayTimeout;

    objectLabel;

    selectedRecord;
    searchRecords;

   // ICON_URL = '/apexpages/slds/latest/assets/icons/{0}-sprite/svg/symbols.svg#{1}';




    connectedCallback(){
       
        // let icons           = this.iconName.split(':');
        // this.ICON_URL       = this.ICON_URL.replace('{0}',icons[0]);
        // this.ICON_URL       = this.ICON_URL.replace('{1}',icons[1]);
        console.log('index in users ',this.indexid);


    }



    handleInputChange(event){
       console.log('in handle input change');
       window.clearTimeout(this.delayTimeout);
       const searchKey = event.target.value;
        console.log('search key is '+searchKey);
        this.delayTimeout = setTimeout(() => {
            if(searchKey.length >= 2){
                console.log('more than 2 character in text box');
                search({ 
                    objectName : this.objName,
                    fields     : this.fields,
                    searchTerm : searchKey 
                })
                .then(result => {
                    let stringResult = JSON.stringify(result);
                    let allResult    = JSON.parse(stringResult);
                    console.log('allResult aksjdghkasgd'+stringResult);

                    // allResult.forEach( record => {
                    //     record.FIELD1 = record[this.field];
                    //     record.FIELD2 = record[this.field1];
                    //     if( this.field2 ){
                    //         record.FIELD3 = record[this.field2];
                    //     }else{
                    //         record.FIELD3 = '';
                    //     }
                    // });
                    this.searchRecords = allResult;
                    
                })

            }

        },DELAY)

    }




    handleSelect(event){
        console.log('in handleSelect method');
        let recordId = event.currentTarget.dataset.recordId;
      
        let selectRecord = this.searchRecords.find((item) => {
            return item.Id === recordId;
        });

        console.log('in handle select record Id is '+recordId);
        this.selectedRecord = selectRecord;
        const selectedEvent = new CustomEvent('lookup', {
            bubbles    : true,
            composed   : true,
            cancelable : true,
            detail: {  
                data : {
                    record          : selectRecord,
                    recordId        : recordId,
                    currentRecordId : this.currentRecordId,
                    indexId         : this.indexid

                }
            }
        });
        this.dispatchEvent(selectedEvent);


       
    }


    @api
    handleClose(){
       console.log('in handle close method');
       this.selectedRecord = undefined;
       this.searchRecords  = undefined;
       const selectedEvent = new CustomEvent('lookup', {
           bubbles    : true,
           composed   : true,
           cancelable : true,
           detail: {  
               record :'' ,
               recordId:'',
               currentRecordId : this.currentRecordId
           }
       });
       this.dispatchEvent(selectedEvent);
    }


}