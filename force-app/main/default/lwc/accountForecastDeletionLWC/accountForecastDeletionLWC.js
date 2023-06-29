import { LightningElement,track,wire } from 'lwc';
import getForecastAccount from '@salesforce/apex/ForecastAccountDeleteController.getForecastAccount';
import deleteForecastAccount from '@salesforce/apex/ForecastAccountDeleteController.deleteForecastAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
const columns = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Account', fieldName: 'AccName' },
    { label: 'SAP Code', fieldName: 'SAPCode' },
    { label: 'Combination Key', fieldName: 'combKey'},
    { label: 'Territory', fieldName: 'Territory' },
    
];
export default class AccountForecastDeletionLWC extends NavigationMixin(LightningElement) {
    @track resultFromController;
    data = [];
    rowOffset = 0;
    norecordMessage=false;
    buttonClick=false;
    dataToShow=true;
    columns = columns;
    pageSizeOptions = [5,10]; 
    totalRecords = 0; 
    pageSize;
    totalPages;
    pageNumber = 1;
    recordsToDisplay = [];
    
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    //      connectedCallback() {
    
    // getForecastAccount()
    // .then(result => {
    //      this.resultFromController=result;
    //      console.log('eneter in imperative'+this.resultFromController);
    //             console.log('result'+result);
    //         })
    //         .catch(error => {
    //             this.error = error;
    
    //         });
    //      }
    
    @wire(getForecastAccount) ForecastedAccount ({ error, data }) {
        console.log('eneter in wire');
        if (data) {
            console.log('enter in data'+data);
            this.resultFromController = data; 
            console.log('resultFromController'+JSON.stringify(this.resultFromController));
            if(this.resultFromController.length==0){
                console.log('66 length is zero');
                this.buttonClick=true;
                this.dataToShow=false;
            }
            this.totalRecords = data.length; 
            console.log('this.totalRecords'+this.totalRecords);                 
            this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
            console.log('this.pageSize'+this.pageSize);
            
            this.paginationHelper();
        } else if (error) { 
            this.error = error;  
        }   }
    handleDeleteClick(){
        console.log('Delete'+JSON.stringify(this.resultFromController));
        deleteForecastAccount({fAList:this.resultFromController})
            .then(result => {
                
                console.log('result'+result);
                const event = new ShowToastEvent({
                    title: 'Success',
                        message: 'Records Delete Successfully',
                            variant: 'Success',
                                mode: 'dismissable'
                                    });
                this.dispatchEvent(event);
                this.recordsToDisplay=[];
                this.handleNavigate();
            })
            .catch(error => {
                this.error=JSON.stringify(error.body.message);
                
                const event = new ShowToastEvent({
                    title: 'Error',
                        message: this.error,
                            variant: 'Error',
                                mode: 'dismissable'
                                    });
                this.dispatchEvent(event);
                
            });
    }
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    // JS function to handel pagination logic 
    paginationHelper() {
        console.log('enetr in pagination'+ this.recordsToDisplay);
        this.recordsToDisplay = [];
        
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        console.log('this.totalPages'+this.totalPages);
        
            if (this.pageNumber <= 1) {
                this.pageNumber = 1;
            } else if (this.pageNumber >= this.totalPages) {
                this.pageNumber = this.totalPages;
            }
        
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.resultFromController[i]);
            
        }
    }
    handleNavigate() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
                attributes: {
                    pageName: 'home'
                        },
                            });
        
    }
}