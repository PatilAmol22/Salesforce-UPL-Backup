import { LightningElement,api,track } from 'lwc';
import sendEmail from '@salesforce/apex/EmailToCustomer.SendEmail';
import uploadFiles from '@salesforce/apex/EmailToCustomer.uploadFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FileUploadIndia extends LightningElement {
    @api
    myRecordId;
    @api selectedData;
    documentId;
    documentIds = [];
    @track showSpinner;
    @track onfileUpload;
    userList = [];
    @track selectCust;
    @track emailDisabled = true;
    loadedFiles;
    @track noteMessage ='Please enter body to enable Send Email';
    @track reload;
    userVsContentDocId = {};
    userVsContentDocName = {};
    get acceptedFormats() {
        return ['.pdf', '.png','.csv','.JPEG','.JPG'];
    }
    totalRecords = 0; 
    pageSize; 
    totalPages; 
    pageNumber = 1; 
    recordsToDisplay = [];
    currentPage='10'; 
    totalSelectedRecords = 0;
    customSelectedAccList = [];
    
    get pageSizeOptions() {
        return [
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '50', value: '50' },
            { label: '100', value: '100' },
        ];
    }
    handlePageChange(event)
    {
     this.pageSize=event.detail.value;
     console.log('selected size :' +this.pageSize);
     this.paginationHelper();
    }
    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    connectedCallback(){
                this.totalRecords = this.selectedData?.length; // update total records count  
                console.log('Total Records :'+this.totalRecords);            
                this.pageSize = this.currentPage; //set pageSize with default value as first option
                let data = JSON.parse(JSON.stringify(this.selectedData));
                data.forEach(each=>{
                    each.check = false;
                });
                this.selectedData = data;
                this.paginationHelper(); // call helper menthod to update pagination logic 
                
    }
    paginationHelper() {
        this.recordsToDisplay = [];
        this.template.querySelector('[data-name="pagecheck"]') != null && this.template.querySelector('[data-name="pagecheck"]') != undefined ? this.template.querySelector('[data-name="pagecheck"]').checked = false: '';
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        console.log('Selected Data on Pagination => ',this.selectedData);
        // set records to display on current page --2,5  5   10
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.selectedData[i]);
          
           
        }
        var count = 0;
        this.recordsToDisplay.forEach(each=>{
            if(each.check){
                count++;
            }
        })
        if(count == this.recordsToDisplay.length){
            this.template.querySelector('[data-name="pagecheck"]') != null && this.template.querySelector('[data-name="pagecheck"]') != undefined ? this.template.querySelector('[data-name="pagecheck"]').checked = true: '';
        }
        console.log('recordsToDisplay :' +JSON.stringify(this.recordsToDisplay));
    }
    handleUploadFinished(event) {
        // Get the list of uploaded files
        //this.documentIds = [];
        const uploadedFiles = event.detail.files;
        //alert('No. of files uploaded : ' + uploadedFiles.length);
        console.log('UploadedFiles =>> ', uploadedFiles);
        //this.documentId = uploadedFiles[0].documentId;
        let accList =[];
        this.selectedData.forEach(each=>{
            accList.push(each.Id);
        });
        this.loadedFiles = uploadedFiles;
        uploadedFiles.forEach(each=>{
            this.documentIds.push(each.documentId);
        });
        console.log('accList =>',accList);
        console.log('documentIds =>',this.documentIds);
        if(!uploadedFiles[0].name.includes('.csv')){
            this.onfileUpload = true;
        }else{

        }
      
    }
    
    handlePrevious(event){
        const previousEvent = new CustomEvent("previous",{});
        this.dispatchEvent(previousEvent);
    }
    handleEmail(){
        this.showSpinner = true;
        this.emailBody = this.template.querySelector('lightning-input-rich-text').value;
        console.log(' Body=>> '+this.emailBody);
        let UserListToPass = [];
        if(this.userList?.length > 0){
            this.userList.forEach(each=>{
                UserListToPass.push(JSON.stringify(each));
            })
        }else{
            this.selectedData.forEach(each=>{
                UserListToPass.push(JSON.stringify(each));
            })
        }
       
        sendEmail({
            emailBody: this.emailBody,
            userList:UserListToPass,
            ContentDocumentIds: this.documentIds,
            CustVsContentIds : JSON.stringify(this.userVsContentDocId)
        }).then(result =>{
            console.log('result=> '+result);
            this.showSpinner = false;
            this.emailDisabled = true;
            this.noteMessage = 'If you want to resend the email please click previous and then click next page.';
            this.showToastmessage('Success','Email Sent Successfully','success');

        }).catch(error=>{
            this.showSpinner = false;
            console.log('error=> ',error);
            this.showToastmessage('Error','Error while sending an Email','error');

        });
    }
    handleRecordSelection(event){
        let checked = event.target.checked;
        
        if(checked){
            this.recordsToDisplay.forEach(each=>{
                if(!each.check){
                    each.check = true;
                    this.template.querySelector('[data-acc="'+each.Id+'"]') != null && this.template.querySelector('[data-acc="'+each.Id+'"]') != undefined ? this.template.querySelector('[data-acc="'+each.Id+'"]').checked = true: '';
                    this.customSelectedAccList.push(each.Id);
                }
               
            });
        }else{
            this.recordsToDisplay.forEach(each=>{
                each.check = false;
                this.customSelectedAccList.splice(this.customSelectedAccList.indexOf(each.Id),1);
                this.template.querySelector('[data-acc="'+each.Id+'"]') != null && this.template.querySelector('[data-acc="'+each.Id+'"]') != undefined ? this.template.querySelector('[data-acc="'+each.Id+'"]').checked = false: '';


            });
        }
        console.log('Selected Data => ',this.selectedData);
        this.totalSelectedRecords = this.customSelectedAccList!= null ? this.customSelectedAccList.length : 0
        this.reload++;
    }
    showToastmessage(title, message, varient) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    }
    showModalBox() {  
        this.onfileUpload = true;
    }

    hideModalBox() {  
        this.onfileUpload = false;
    }
    hideModal(){
        this.selectCust = false;
    }
    emailBodychange(event){
        let body = event.target.value;
        if(body != null && body.length > 0){
            this.emailDisabled = false;
        }
    }
    handleFileMapping(event){
        let action = event.target.dataset.action;
        var selectedSAPCode;
        console.log('Action =>> '+action);
        if(action === 'YES'){
            this.selectedData.forEach(each=>{
                selectedSAPCode = each.SAPCode;
                //this.userList.push(each);
                if(this.userList.length == 0){
                    this.userList.push(each);
                }else{
                    let data = this.userList.filter(res => res.Id == each.Id);
                    if(data?.length == 0){
                        this.userList.push(each);
                    }
                }
                //this.userList.push(JSON.stringify(each));
                //this.userVsContentDocId[each.SAPCode]= this.documentIds;
                if(this.userVsContentDocId != null && Object.keys(this.userVsContentDocId).length >0){
                    Object.entries(this.userVsContentDocId).forEach(([k,v])=>{
                        if(k === each.SAPCode){
                            //v.push(this.loadedFiles[0].documentId);
                            this.loadedFiles.forEach(load=>{
                                    
                                    v.push(load.documentId);
                               
                            })
                        }else if(!Object.keys(this.userVsContentDocId).includes(each.SAPCode)){
                            this.loadedFiles.forEach(load=>{
                                let docIds= [];
                                docIds.push(load.documentId);
                                this.userVsContentDocId[each.SAPCode] = docIds;
                           
                            })
                        }
                    })
                }else{
                    this.loadedFiles.forEach(load=>{
                        let docIds= [];
                        docIds.push(load.documentId);
                        this.userVsContentDocId[each.SAPCode] = docIds;
                   
                    })
                }
            })

           
            
            console.log('this.userVsContentDocId for custom with Logic =>> ',this.userVsContentDocId);
            this.handleSelectedData(null);

        }else{
            this.onfileUpload = false;
            this.selectCust = true;
        }
        console.log('userList => ',this.userList);
        console.log('this.userVsContentDocId =>> ',this.userVsContentDocId);
    }
    handleCheckBoxSelection(event){
        let acc = event.target.dataset.acc;
        if(event.target.checked){
            this.customSelectedAccList.push(acc);
            this.totalSelectedRecords = this.totalSelectedRecords + 1;
        }else{
            this.customSelectedAccList.splice(this.customSelectedAccList.indexOf(acc),1);
            this.totalSelectedRecords = this.totalSelectedRecords + 1;
        }
        
    }
    handleCustomerSelection(event){
        let SAPCodes = [];
        this.selectedData.filter(res=> this.customSelectedAccList.includes(res.Id)).forEach(each=>{
            SAPCodes.push(each.SAPCode);
        });
        console.log('Selected SAP Codes => ',SAPCodes);
        this.selectedData.forEach(each=>{
            if(this.userList.length == 0){
                this.userList.push(each);
            }else{
               let data = this.userList.filter(res => this.customSelectedAccList.includes(res.Id));
               if(data?.length == 0){
                 this.userList.push(each);
               }
               let data1 = this.userList.filter(res => res.Id == each.Id);
               if(data1?.length == 0){
                this.userList.push(each);
              }
            }
            
        })
        console.log('userList => ',this.userList);
        console.log('Loaded Files ',this.loadedFiles);
        console.log('userVsContentDocId=>',this.userVsContentDocId);
        if(SAPCodes!= null && SAPCodes != undefined && SAPCodes.length >0){
            SAPCodes.forEach(selectedSAPCode=>{
                if(this.userVsContentDocId != null && Object.keys(this.userVsContentDocId).length >0){
                    Object.entries(this.userVsContentDocId).forEach(([k,v])=>{
                        if(k === selectedSAPCode){
                            this.loadedFiles.forEach(load=>{
                                    
                                    v.push(load.documentId);
                               
                            })
                        }else if(!Object.keys(this.userVsContentDocId).includes(selectedSAPCode)){
                            this.loadedFiles.forEach(load=>{
                                let docIds= [];
                                docIds.push(load.documentId);
                                this.userVsContentDocId[selectedSAPCode] = docIds;
                           
                            })
                        }
                    })
                }else{
                    this.loadedFiles.forEach(load=>{
                        let docIds= [];
                        docIds.push(load.documentId);
                        this.userVsContentDocId[selectedSAPCode] = docIds;
                   
                    })
                }
            })
        }
        console.log('this.userVsContentDocId for custom with Logic =>> ',this.userVsContentDocId);
        this.customSelectedAccList = [];
        this.handleSelectedData();
        this.hideModal();
       // let acc = event.target.dataset.acc;
       /* var selectedSAPCode;
        // if(event.target.checked){
        //     this.totalSelectedRecords = this.totalSelectedRecords + 1;
        // }else{
        //     this.totalSelectedRecords = this.totalSelectedRecords - 1;
        // }
        //this.userList = [];
        this.selectedData.forEach(each=>{
            if(this.userList.length == 0){
                this.userList.push(each);
            }else{
               let data = this.userList.filter(res => res.Id == acc);
               if(data?.length == 0){
                 this.userList.push(each);
               }
               let data1 = this.userList.filter(res => res.Id == each.Id);
               if(data1?.length == 0){
                this.userList.push(each);
              }
            }
            if(each.Id == acc){
                
                //this.userList.push(JSON.stringify(each));
                selectedSAPCode = each.SAPCode;
               
            }
        })
        console.log('userList => ',this.userList);

        console.log('SAP Code => ',selectedSAPCode);
        console.log('Loaded Files ',this.loadedFiles);
        console.log('userVsContentDocId=>',this.userVsContentDocId);
        console.log('userVsContentDocId[selectedSAPCode',this.userVsContentDocId[selectedSAPCode]);

       if(event.target.checked){
        if(this.userVsContentDocId != null && Object.keys(this.userVsContentDocId).length >0){
            Object.entries(this.userVsContentDocId).forEach(([k,v])=>{
                if(k === selectedSAPCode){
                    this.loadedFiles.forEach(load=>{
                            
                            v.push(load.documentId);
                       
                    })
                }else if(!Object.keys(this.userVsContentDocId).includes(selectedSAPCode)){
                    this.loadedFiles.forEach(load=>{
                        let docIds= [];
                        docIds.push(load.documentId);
                        this.userVsContentDocId[selectedSAPCode] = docIds;
                   
                    })
                }
            })
        }else{
            this.loadedFiles.forEach(load=>{
                let docIds= [];
                docIds.push(load.documentId);
                this.userVsContentDocId[selectedSAPCode] = docIds;
           
            })
        }
       }else{
            if(this.userVsContentDocId != null){
                this.userVsContentDocId.splice(this.userVsContentDocId.indexOf(acc),1);
            }
       }
      
        console.log('this.userVsContentDocId for custom with Logic =>> ',this.userVsContentDocId);

        this.handleSelectedData(selectedSAPCode);
        //this.userVsContentDocId = {"0001115750":["0695D000001IKZLQA4","0695D000001IKZQQA4"],"0001115589":["0695D000001IKZLQA4"]};
        console.log('this.userVsContentDocId for custom =>> ',this.userVsContentDocId);
       */
    }
    handleSelectedData(selectedAccId){
        console.log('Handle SelectedData => ',this.selectedData);
        console.log('SAP code vs FIle ID => ',this.userVsContentDocId)
        var accList;

        
        Object.entries(this.userVsContentDocId).forEach(([k,v])=>{ 
            console.log(v);
            let names=[]; 
            if(Object.keys(this.userVsContentDocName).includes(k)){
                names = this.userVsContentDocName[k];
            }
            
                        this.loadedFiles.forEach(file=>{
                            if(v.includes(file.documentId)){
                            
                                names.push(file.name);
                            } this.userVsContentDocName[k] = names;
                            })
            })
        
        console.log('userVsContentDocName => ',this.userVsContentDocName);
        accList = JSON.parse(JSON.stringify(this.selectedData));
        Object.entries(this.userVsContentDocName).forEach(([k,v])=>{
            let accData = this.selectedData.find(res=> res.SAPCode == k);
            console.log('accData',accData);
            Object.entries(accList).forEach(([k1,v1])=>{console.log('ACC =>> ',v1);
            if(accData != undefined && v1.SAPCode == accData.SAPCode){
                v1.fileNames =v;
                console.log('updated V1 value of'+k+' => ',v1);
            }
            
            })
            
        })
       
        console.log('accList => ',accList);
        this.selectedData = accList;
        console.log('After Handle SelectedData => ',this.selectedData);
        this.paginationHelper();
        this.reload++;
        this.hideModalBox();
        //this.hideModal();
        

    }
    renderedCallback(){
        console.log('in Rerender call back');
        this.recordsToDisplay.forEach(each=>{
            if(each.check){
                this.template.querySelector('[data-acc="'+each.Id+'"]') != null && this.template.querySelector('[data-acc="'+each.Id+'"]') != undefined ? this.template.querySelector('[data-acc="'+each.Id+'"]').checked = true: '';
            }else{
                this.template.querySelector('[data-acc="'+each.Id+'"]') != null && this.template.querySelector('[data-acc="'+each.Id+'"]') != undefined ? this.template.querySelector('[data-acc="'+each.Id+'"]').checked = false: '';
            }
        })
       
    }
}