import { LightningElement,track,wire,api } from 'lwc';
import getTableData from '@salesforce/apex/Grz_OnboardingDataDynamic.getTableData'

export default class Grz_createDynamicTableOnboarding extends LightningElement {
    @track isData = true;
    @api objectApiName;
    @api fieldNames;
    @api query;
    @api columns;
    @track columnList;
    @track tableData;
    @track rows = [{ uuid: this.createUUID()}];
    @track isTurnovertable=false;
    @api recordId;
    @track deletedDataList = [];
    @track deletedRecord;
    colsArr;

    createUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
          });
    }

    connectedCallback(){
        if(this.objectApiName=='Particulars_of_the_Business__c'){
            this.isTurnovertable=true;
        }
        console.log('query',this.query);
        this.colsArr = this.fieldNames.split(",");  // use only for field api Names 
        var cleanedColumnList = this.columns[0] === '\\' ? this.columns.substring(1) : this.columns;
        if(cleanedColumnList){
            this.columnList = cleanedColumnList; // can utilize field type dynamically in input if required
        }
        getTableData({ObjectAPIName : this.objectApiName,query : this.query,recordId:this.recordId}).then((result) => {
            if(result){
                //this.tableData = result;
                this.tableData = [...result].map(record => ({...record}));
                console.log('tableData : ',this.tableData); 
            }
          })
          .catch(error => {
            console.log('Error : ',error);
        });
    }

    addRow() {
        this.tableData.push({ Id: this.createUUID()});
    }
    removeRow(event) {
        //this.deletedDataList.push({ 'Id' : event.target.dataset.id, 'ObjectName': event.target.dataset.fieldname});
        this.deletedRecord = {'Id' : event.target.dataset.id, 'objectAPIName': event.target.dataset.fieldname};
        //console.log('this.deletedDataList : ', this.deletedRecord);
        this.tableData.splice(event.target.value, 1);
        let ev = new CustomEvent('deletedrecords', {detail:this.deletedRecord});
        this.dispatchEvent(ev);
    }

    @api
    retrieveRecords() {
        try{
            let rows = Array.from(this.template.querySelectorAll("tr.inputRows") );
            var records=[];
            rows.map(row => {
                let texts = Array.from(row.querySelectorAll(".fields"));
                if(texts)
                {
                    var textVal=this.fieldValues(texts);
                    //console.log('textVal : ',textVal);
                    records=[...records,textVal];
                }
            });  
        return records;
        }
        catch(e){
            console.log('Error : '+e);
        }
    }

    fieldValues(cells){
        return cells.reduce((record, cell) => {
            let inputVal = cell.inputValue();
            if(inputVal.value!=undefined)
            {
                record[inputVal.field] = inputVal.value;
                record['Id'] = inputVal.rid;
                record['objectAPIName'] = inputVal.objectAPIName;
            }
            return record;
        }, {});
    }

}