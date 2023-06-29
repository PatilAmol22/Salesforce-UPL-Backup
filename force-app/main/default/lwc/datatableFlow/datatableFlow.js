import { LightningElement, api, track } from 'lwc';

export default class DatatableFlow extends LightningElement {

    @api mydata;
    @api columns;
    @api keyfield;
    @api recordData;
    @api columnNamesCSV;
    @track isChecked=false;
    @track isCheckedAll=false;
    @track page = 1; 
    @track items = []; 
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 50; 
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track hasRendered=false;
    @track selectedArray = [];
    isAsc = false;
    isDsc = false;
    isNameSort = false;
    isDepotSort= false;
    isTerritorySort= false;
    isTMSort= false;
    isSDateSort=false;

    renderedCallback(){
        console.log('mydata : ',this.mydata);
        if(this.mydata!=undefined){
            if(this.hasRendered==false){
                this.hasRendered=true;
                this.items = this.mydata;
                this.totalRecountCount = this.mydata.length; 
                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
                
                this.mydata = this.items.slice(0,this.pageSize); 
                this.endingRecord = this.pageSize;
                console.log('this.mydata : ',this.mydata);
            }
            
        }
        
    }

    getRecordURL(event) {
        console.log('event.currentTarget.id :',event.currentTarget.id)
        const id=event.currentTarget.id;
        if(id.includes('-')){
            const ids= id.split('-');
            var url ='/lightning/r/Free_Sample_Management__c/' + ids[0]+ '/edit';
            window.open(url, '_blank');
        }
    }
    get disablePrevious(){ 
        return this.page<=1
    }

    get disableNext(){ 
        return this.page>=this.totalPage
    }

    handleRowAction(event){
        const action = event.detail.action;
        const row = event.detail.row;
        //rowactions should be handled by the parent.  
        this.dispatchRowActionEvent(row, action);

    }

    dispatchRowActionEvent(row, action) {
        const rowActionTaken = new CustomEvent('rowactiontaken', {
            bubbles: false, 
            detail: {row, action}
        });
        this.dispatchEvent(rowActionTaken);
    }
   

    getSelectedName(event) {
        var checked = event.target.checked;
        console.log("checked:- " + checked);
        var wid=event.target.dataset.id;
        console.log("wid:- " + wid);
        if (checked) {
            this.selectedArray.push(wid);
        } else {
            this.isCheckedAll=false;
            console.log("this.isCheckedAll :- " , this.isCheckedAll);
            var index = this.selectedArray.indexOf(wid);
            this.selectedArray.splice(index, 1);
        }
        this.dispatchRowSelectedEvent(this.selectedArray);
    }

    handleSelectAll(event){
    this.selectedArray = [];
    var checked = event.target.checked;
    if(checked){
        this.mydata.forEach(aList => {
            console.log("aList : " , JSON.stringify(aList));
        this.isChecked = true;
        this.selectedArray.push(aList.WorkItemId);
        });
    }else{
        this.mydata.forEach(aList => {
            console.log("aList : " , JSON.stringify(aList));
        this.isChecked = false;
        });
    }
    this.dispatchRowSelectedEvent(this.selectedArray);
    }
    dispatchRowSelectedEvent(selectedRows) {
        console.log('selectedrows is: ' + JSON.stringify(selectedRows));
        const rowSelected = new CustomEvent('rowselected', {
            bubbles: false, 
            detail: {selectedRows}
        });
        this.dispatchEvent(rowSelected);
    }

    sortName(event) {
        this.isNameSort = true;
        this.isDepotSort=false;
        this.isTerritorySort=false;
        this.isTMSort=false;
        this.isSDateSort=false;
        this.sortData(event.currentTarget.dataset.id);
    }

    sortDepot(event){
        this.isDepotSort=true;
        this.isNameSort=false;
        this.isTerritorySort=false;
        this.isTMSort=false;
        this.isSDateSort=false;
        this.sortData(event.currentTarget.dataset.id);
    }

    sortTerritory(event){
        this.isTerritorySort=true;
        this.isDepotSort=false;
        this.isNameSort=false;
        this.isTMSort=false;
        this.isSDateSort=false;
        this.sortData(event.currentTarget.dataset.id);
    }
    
    sortTM(event){
        this.isTMSort=true;
        this.isDepotSort=false;
        this.isNameSort=false;
        this.isTerritorySort=false;
        this.isSDateSort=false;
        this.sortData(event.currentTarget.dataset.id);
    }

    sortSDate(event){
        this.isSDateSort=true;
        this.isDepotSort=false;
        this.isNameSort=false;
        this.isTerritorySort=false;
        this.isTMSort=false;
        this.sortData(event.currentTarget.dataset.id);
    }

    sortData(sortColumnName) {
        // check previous column and direction
        if (this.sortedColumn === sortColumnName) {
            this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        } 
        else {
            this.sortedDirection = 'asc';
        }

        // check arrow direction
        if (this.sortedDirection === 'asc') {
            this.isAsc = true;
            this.isDsc = false;
        } 
        else {
            this.isAsc = false;
            this.isDsc = true;
        }

        // check reverse direction
        let isReverse = this.sortedDirection === 'asc' ? 1 : -1;

        this.sortedColumn = sortColumnName;

        // sort the data
        this.mydata = JSON.parse(JSON.stringify(this.mydata)).sort((a, b) => {
            a = a[sortColumnName] ? a[sortColumnName].toLowerCase() : ''; // Handle null values
            b = b[sortColumnName] ? b[sortColumnName].toLowerCase() : '';

            return a > b ? 1 * isReverse : -1 * isReverse;
        });;
    }

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }             
    }

    //this method displays records page by page
    displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.mydata = this.items.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    }    
}