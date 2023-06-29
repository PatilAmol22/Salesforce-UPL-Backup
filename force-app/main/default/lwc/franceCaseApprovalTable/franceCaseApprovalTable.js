import { LightningElement, track, api, wire } from 'lwc';
import getWrapperClassList from '@salesforce/apex/FranceCaseApprovalController.getSubmittedRecords';
import processRecords from '@salesforce/apex/FranceCaseApprovalController.processRecords';
import gettotalcount from '@salesforce/apex/FranceCaseApprovalController.gettotalcount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
export default class franceCaseApprovalTable extends LightningElement {
    lstSelectedCase=[];
    @api wrapperList = [];
    @api draftValues = [];
    @track error;
    @track sortBy;
    @track sortDirection;
    @track bShowModal = false;
    @track selectedcommentrowno;
    @track icomments = '';
    @track record;
    @track queryOffset;
    @track queryLimit;
    @track totalRecordCount;
    @track showinfiniteLoadingSpinner = true;
    @track showLoadingSpinner = false;
    @track isDialogVisible = false;
    @track originalMessage;
    @track wrapperListtrue = false;
    @track title;
    @api footertext;
    @track enable_app_rej = true;
     pageSizeOptions = [10]; 
     resultFromController=[];
    totalRecords = 0; 
    pageSize;
    totalPages;
    pageNumber = 1;
    recordsToDisplay = [];
    @track columns = [
       
     
       
        {
            label: 'Item Name',
            fieldName: 'recordName',
            type: 'text',
           
            wrapText: true,
            sortable: true
        },
        {
            label: 'Related to',
            fieldName: 'relatedTo',
            type: 'text',
            
            sortable: true
        },
        {
            label: 'Submitter',
            fieldName: 'submittedBy',
            type: 'text',
           
            sortable: true
        },
        {
            label: 'Submitted on',
            fieldName: 'submittedDate',
            type: 'date',
           
            typeAttributes: {
                day: 'numeric',
                month: 'short',
                year: 'numeric'
               
            },
            sortable: true
        },
        {
            label: 'Approver Comment',
            fieldName: 'comments',
            type: 'text',
          
            wrapText: true,
            editable: true
        }
    ];
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
    wiredcountResults;
    // @wire(gettotalcount) totalcount(result) {
    //     console.log('result.data' + result.data);
    //     this.wiredcountResults = result;
    //     if (result.data != undefined) {
    //         this.totalRecordCount = result.data;
    //         console.log('tota' + this.totalRecordCount);
    //         this.title = 'Your Pending Approvals';
    //         if (result.data > 0)
    //             this.wrapperListtrue = true;
    //         else {
    //             this.totalRecordCount = 0;
    //             this.title = 'Your Pending Approvals';
    //             this.wrapperListtrue = false;
    //             console.log('tota' + this.totalRecordCount);
    //         }
    //     } else if (result.error) {
    //         this.error = result.error;
    //         this.totalRecordCount = 0;
    //         this.title = 'Your Pending Approvals (' + this.totalRecordCount + ')';
    //         this.wrapperListtrue = false;
    //         console.log('tota' + this.totalRecordCount);
    //     }
    // }
    constructor() {
        super();
        this.title = 'Your Pending Approvals';
        this.showinfiniteLoadingSpinner = true;
        this.wrapperList = [];
        // this.queryOffset = 0;
        // this.queryLimit = 5;
        this.loadRecords();
    }
    reloadrecords() {
        this.showLoadingSpinner = true;
        this.showinfiniteLoadingSpinner = true;
        this.queryOffset = 0;
        this.queryLimit = 5;
        let flatData;
        this.wrapperList = [];
        console.log(this.totalRecordCount);
        return getWrapperClassList()
            .then(result => {
                console.log(result);
                console.log(this.totalRecordCount);
                flatData = result;
                if (flatData != undefined) {
                    for (var i = 0; i < flatData.length; i++) {
                        flatData[i].recordId = '/' + flatData[i].recordId;
                    }
                    this.wrapperList = flatData;
                }
                this.showLoadingSpinner = false;
                console.log('wrapperList'+JSON.stringify(this.wrapperList));
                this.showLoadingSpinner = false;
                return refreshApex(this.wiredcountResults);
                //this.error = undefined;
            }).catch(error => {
                console.log(error);
                this.showLoadingSpinner = false;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: result,
                        variant: 'info'
                    })
                );
                return refreshApex(this.wiredcountResults);
            })
    }
    loadRecords() {
        console.log('test');
        this.showLoadingSpinner = true;
        let flatData;
        console.log('lr' + this.queryOffset);
        console.log('lr' + this.queryLimit);
        return getWrapperClassList()
            .then(result => {
                console.log('result'+result);
                this.resultFromController=result;
                flatData = result;
                if (flatData != undefined) {
                    for (var i = 0; i < flatData.length; i++) {
                        flatData[i].recordId = '/' + flatData[i].recordId;
                    }
                    let updatedRecords = [...this.wrapperList, ...flatData];
                    this.wrapperList = updatedRecords;
                }
                this.showLoadingSpinner = false;
                console.log('wrapper result'+JSON.stringify(this.wrapperList));
                this.totalRecords = this.wrapperList.length; 
                if(this.wrapperList.length>0){

                this.wrapperListtrue=true;
                }
            console.log('this.totalRecords'+this.totalRecords);                 
            this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
            console.log('this.pageSize'+this.pageSize);
            
            this.paginationHelper();
                refreshApex(this.wiredcountResults);
                this.title = 'Your Pending Approvals' ;
            }).catch(error => {
                 
                console.log(error);
                this.showLoadingSpinner = false;
                this.error = error;
                this.wrapperListtrue=false;
                refreshApex(this.wiredcountResults);
                this.title = 'Your Pending Approvals';
                /*this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: result,
                        variant: 'info'
                    })
                );*/
            })
    }
    // loadMoreData(event) {
    //     const { target } = event;
    //     this.showinfiniteLoadingSpinner = true;
    //     //Display a spinner to signal that data is being loaded
    //     console.log('lmr totalRecordCount' + this.totalRecordCount);
    //     console.log('lmr queryLimit' + this.queryLimit);
    //     console.log('lmr queryOffset' + this.queryOffset);
    //     if (this.totalRecordCount < this.queryLimit) {
    //         console.log(this.wrapperList);
    //         this.showinfiniteLoadingSpinner = false;
    //         return refreshApex(this.wiredcountResults);
    //     }
    //     else if (this.totalRecordCount > this.queryOffset) {
    //         this.queryOffset = this.queryOffset + 5;
    //         console.log('lmir queryLimit' + this.queryLimit);
    //         console.log('lmir queryOffset' + this.queryOffset);
    //         let flatData;
    //         return getWrapperClassList({ queryLimit: this.queryLimit, queryOffset: this.queryOffset })
    //             .then(result => {
    //                 target.isLoading = false;
    //                 console.log(result);
    //                 console.log(this.totalRecordCount);
    //                 flatData = result;
    //                 if (flatData != undefined) {
    //                     for (var i = 0; i < flatData.length; i++) {
    //                         flatData[i].recordId = '/' + flatData[i].recordId;
    //                     }
    //                     //this.wrapperList = this.wrapperList.concat(flatData);
    //                     let updatedRecords = [...this.wrapperList, ...flatData];
    //                     this.wrapperList = updatedRecords;
    //                 }
    //                 target.isLoading = false;
    //                 console.log(this.wrapperList);
    //                 this.showinfiniteLoadingSpinner = false;
    //                 return refreshApex(this.wiredcountResults);
    //             }).catch(error => {
    //                 console.log(error);
    //                 this.showinfiniteLoadingSpinner = false;
    //                 this.dispatchEvent(
    //                     new ShowToastEvent({
    //                         title: 'Error',
    //                         message: result,
    //                         variant: 'info'
    //                     })
    //                 );
    //                 return refreshApex(this.wiredcountResults);
    //             })
    //     } else {
    //         this.showinfiniteLoadingSpinner = false;
    //         target.isLoading = false;
    //         return refreshApex(this.wiredcountResults);
    //     }

    // }

    // handleSave(event) {
    //     this.showLoadingSpinner = true;
    //     console.log(event.detail.draftValues);
    //     console.log(this.wrapperList);
    //     var draftlst = [];
    //     draftlst = event.detail.draftValues;
    //     for (var i = 0; i < this.wrapperList.length; i++) {
    //         console.log(this.wrapperList[i].workItemId);
    //         for (var j = 0; j < draftlst.length; j++) {
    //             console.log(draftlst[j].workItemId);
    //             if (this.wrapperList[i].workItemId === draftlst[j].workItemId) {
    //                 this.wrapperList[i].comments = draftlst[j].comments;
    //             }
    //         }
    //     }
    //     for (var i = 0; i < this.wrapperList.length; i++) {
    //         console.log(this.wrapperList[i].comments);
    //     }
    //     this.draftValues = [];
    //     this.showLoadingSpinner = false;
    //     this.dispatchEvent(
    //         new ShowToastEvent({
    //             title: 'Success',
    //             message: 'Approver comments Added.',
    //             variant: 'success'
    //         })
    //     );
    // }
    enablebuttons(event)
    {
        console.log('enter in enable');
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();  
this.lstSelectedCase = selectedRecords;
      console.log('selectedRecords are '+JSON.stringify(selectedRecords));
      for(let i=0;i<this.lstSelectedCase.length;i++){
      var CaseRecordId= this.lstSelectedCase[i].workItemId;
      console.log('CaseRecordId'+CaseRecordId);
      }

      
         const selectedRows = event.detail.selectedRows;
         var recordsCount = event.detail.selectedRows.length;
         if(recordsCount > 0)
         this.enable_app_rej = false;
         else
         this.enable_app_rej = true;
         
    }
    processrec() {
        console.log('processor onm');
        this.showLoadingSpinner = true;
        console.log('test');
       var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();  

      console.log('selectedRecords are ',selectedRecords);

      this.lstSelectedCase = selectedRecords;
        console.log(this.lstSelectedCase);
        
        // console.log(event.target.label);
        var varprocessType = this.originalMessage;// event.target.label;
        console.log('varprocessType'+varprocessType);
        var processrows = [];
      for(let i=0;i<this.lstSelectedCase.length;i++){
            processrows.push(this.lstSelectedCase[i]);
        }
        if (processrows.length > 0) {
            var str = JSON.stringify(processrows);
            console.log('str'+str);
            processRecords({ processType: varprocessType, strwraprecs: str })
                .then(result => {
                    this.showinfiniteLoadingSpinner = true;
                    this.queryOffset = 0;
                    this.queryLimit = 5;
                    let flatData;
                    this.wrapperList = [];
                    console.log(this.totalRecordCount);
                    return getWrapperClassList()
                        .then(result => {
                            console.log('result'+result);
                            console.log('count'+this.totalRecordCount);
                            flatData = result;
                            if (flatData != undefined) {
                                for (var i = 0; i < flatData.length; i++) {
                                    flatData[i].recordId = '/' + flatData[i].recordId;
                                }
                                this.wrapperList = flatData;
                            }
                            this.showLoadingSpinner = false;
                            console.log(this.wrapperList);
                            this.showLoadingSpinner = false;
                            var messagetitle;
                            var ivariant;
                            if(varprocessType == 'Approve')
                            {
                                console.log('enter in console');
                                messagetitle = 'Selected records are Approved.';
                                ivariant = 'success';
                            }
                            else if(varprocessType == 'Reject')
                            {
                                messagetitle = 'Selected records are Rejected.';
                                ivariant = 'error';
                            }
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: messagetitle,
                                    message: messagetitle,
                                    variant: ivariant
                                })
                            );
                            return refreshApex(this.wiredcountResults);
                        }).catch(error => {
                            console.log(error);
                            this.showLoadingSpinner = false;
                            this.error = error;
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error',
                                    message: result,
                                    variant: 'info'
                                })
                            );
                            return refreshApex(this.wiredcountResults);
                        })
                })
                .catch(error => {
                    this.showLoadingSpinner = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: result,
                            variant: 'error'
                        })
                    );
                    return refreshApex(this.wiredcountResults);
                });
        }
        else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'No Records chosen.',
                    message: 'Please select records to proceed.',
                    variant: 'warning'
                })
            );
            this.showLoadingSpinner = false;
        }
    }

    handleSortdata(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }
    sortData(fieldname, direction) {
        this.showLoadingSpinner = true;
        let parseData = JSON.parse(JSON.stringify(this.wrapperList));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';

            return isReverse * ((x > y) - (y > x));
        });
        this.wrapperList = parseData;
        this.showLoadingSpinner = false;
    }
    openModal() { this.bShowModal = true; }
    closeModal() { this.bShowModal = false; }
    handleRowAction(event) {
        console.log('enetr in row action');
        const actionName = event.detail.action.name;
        var row = event.detail.row.workItemId;
        console.log('row'+row);
        switch (actionName) {
            case 'view_record':
                this.viewrecord(row);
                break;
            case 'submitter_comments':
                this.opencomment(row);
                break;
            default:
        }
    }
    // opencomment(row) {
    //     this.bShowModal = true;
    //     console.log(row);
    //     const { workItemId } = row;
    //     console.log(workItemId);
    //     this.record = row;
    //     console.log(this.record);
    //     this.icomments = this.record.submittercomment;
    //     console.log(this.bShowModal);
    // }
    // viewrecord(row) {
    //     this.record = row;
    //     console.log(this.record.recordId);
    //     window.open(this.record.recordId, '_blank');

    // }
    handleconformClick(event) {
        try {
        if (event.target.label === 'Approve') {
            console.log('label' + event.target.label);
            this.originalMessage = event.target.label;
            this.isDialogVisible = true;
        }
        else if (event.target.label === 'Reject') {
            console.log('label' + event.target.label);
            this.originalMessage = event.target.label;
            this.isDialogVisible = true;
        }
        else if (event.target.name === 'confirmModal') {
            console.log(event.detail);
            //when user clicks outside of the dialog area, the event is dispatched with detail value  as 1
            if (event.detail !== 1) {
                console.log('status' + event.detail.status); 
                if (event.detail.status === 'confirm') {
                    this.processrec();
                    this.isDialogVisible = false;
                } else if (event.detail.status === 'cancel') {
                    //do something else
                    this.isDialogVisible = false;
                }
            }
            
        }
        }
        catch(e) {
            console.log(e);
        }
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
   
}