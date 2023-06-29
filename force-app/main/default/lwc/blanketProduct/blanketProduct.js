/*
* Name: BlanketProductController
* Created On: 16 August 2022
* Author: Kalpesh Chande (Kalpesh.Chande@skinternational.com)
* Description: Component is used for declare time period for expired SKUs.
*/
import { LightningElement,wire,track,api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllActiveSku from '@salesforce/apex/BlanketProductController.getAllActiveSku';
import updateSku from '@salesforce/apex/BlanketProductController.updateSku';
import uploadDownloadedCsvFile from '@salesforce/apex/BlanketProductController.uploadDownloadedCsvFile';
import getBlanketSkuBySearch from '@salesforce/apex/BlanketProductController.getBlanketSkuBySearch';
import getSalesOrg from '@salesforce/apex/BlanketProductController.getSalesOrg';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getFieldValue, getPicklistValues } from 'lightning/uiObjectInfoApi';
import BlanketSKUObj from '@salesforce/schema/Blanket_SKU__c';
import expiredReason from '@salesforce/schema/Blanket_SKU__c.Expired_Reason__c';

//labels
import 	Division_Code from '@salesforce/label/c.Division_Code';
import 	Sku_Blanket from '@salesforce/label/c.Sku_Blanket';
import 	Sales_Org from '@salesforce/label/c.Sales_Org';
import 	SKU_Code_Blanket from '@salesforce/label/c.SKU_Code_Blanket';
import 	Distribution_Channel_Code from '@salesforce/label/c.Distribution_Channel_Code';
import 	Blanket_Product_Start_Date from '@salesforce/label/c.Blanket_Product_Start_Date';
import 	Blanket_Product_End_Date from '@salesforce/label/c.Blanket_Product_End_Date';
import 	Status from '@salesforce/label/c.Status';
import 	Blanket_Products from '@salesforce/label/c.Blanket_Products';
import 	Select_sku from '@salesforce/label/c.Select_sku';
import 	Select_Start_Date from '@salesforce/label/c.Select_Start_Date';
import 	Select_End_Date from '@salesforce/label/c.Select_End_Date';
import 	Blanket_Download from '@salesforce/label/c.Blanket_Download';
import 	Search_blanket from '@salesforce/label/c.Search_blanket';
import 	Blanket_Reset from '@salesforce/label/c.Blanket_Reset';
import 	Instructions_for_uploading_CSV_file from '@salesforce/label/c.Instructions_for_uploading_CSV_file';
import 	File_to_be_uploaded_must_be_in_CSV_format_Blanket from '@salesforce/label/c.File_to_be_uploaded_must_be_in_CSV_format_Blanket';
import 	No_rows_will_be_uploaded from '@salesforce/label/c.No_rows_will_be_uploaded';
import 	Please_do_not_change_combination_key from '@salesforce/label/c.Please_do_not_change_combination_key';
import 	First from '@salesforce/label/c.First';
import 	Blanket_Product_Previous_Button from '@salesforce/label/c.Blanket_Product_Previous_Button';
import 	Page from '@salesforce/label/c.Page';
import 	of from '@salesforce/label/c.of';
import 	Next from '@salesforce/label/c.Next';
import 	Last from '@salesforce/label/c.Last';
import 	Combination_Key from '@salesforce/label/c.Combination_Key';
import End_date_must_be_greater_than_start_date from '@salesforce/label/c.End_date_must_be_greater_than_start_date';
import Blanket_Products_Updated_Successfully from '@salesforce/label/c.Blanket_Products_Updated_Successfully';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';
import Error_while_updating_records from '@salesforce/label/c.Error_while_updating_records';
import Error_while_getting_Records from '@salesforce/label/c.Error_while_getting_Records';
import Data_not_found from '@salesforce/label/c.Data_not_found';
import Start_date_and_end_date_are_compulsory from '@salesforce/label/c.Start_date_and_end_date_are_compulsory';
import Start_date_and_end_date_should_be_in_yyyy_mm_dd_format from '@salesforce/label/c.Start_date_and_end_date_should_be_in_yyyy_mm_dd_format';
import Loading from '@salesforce/label/c.Loading';
import Expired_Reason from '@salesforce/label/c.Expired_Reason';
import Expired_reason_is_required from '@salesforce/label/c.Expired_reason_is_required';
import File_upload_is_in_progress_You_will_be_receiving_a_confirmation_email_once_uplo from '@salesforce/label/c.File_upload_is_in_progress_You_will_be_receiving_a_confirmation_email_once_uplo';

// const actions = [
//     { label: Status, name: 'skuStatus' }
// ];
    const columns = [
        { label:  Sales_Org, fieldName: 'salesOrgName',type: 'text', editable:false, hideDefaultActions: "true"},
        { label:  Sku_Blanket,fieldName: 'skuName',type: 'text',sortable:true,editable:false, hideDefaultActions: "true"},
        { label:  SKU_Code_Blanket,fieldName: 'skuCode',type: 'text', editable:false, hideDefaultActions: "true"},
        { label:  Division_Code,fieldName: 'divisionCode', type: 'text', editable:false, hideDefaultActions: "true"},
        { label:  Distribution_Channel_Code,fieldName: 'distChannelCode', type: 'text', editable:false, hideDefaultActions: "true"},
        { label:  Blanket_Product_Start_Date, fieldName: 'startDate' ,type: 'date-local', sortable:true, editable:true, hideDefaultActions: "true"},
        { label:  Blanket_Product_End_Date , fieldName: 'endDate', type: 'date-local', sortable:true, editable:true, hideDefaultActions: "true"},
        { label:  Status, fieldName: 'skuStatus', type: 'boolean', sortable:true, editable:true, hideDefaultActions: "true" },
        {label: Expired_Reason,
        fieldName: 'Type1',type:'multiselectpicklist',hideDefaultActions: "true",editable:false,
        typeAttributes: {
             label:{fieldName: 'Type1'},
             options: { fieldName: 'pickListOptions' }, 
             placeholder: 'Choose Type',
             value: { fieldName: 'Type1' },
             context: { fieldName: 'Id' } 
    } 
} 
    ];
 export default class BlanketProduct extends LightningElement {
    label = {Division_Code,Sku_Blanket,Sales_Org,SKU_Code_Blanket,Distribution_Channel_Code,Blanket_Product_Start_Date,Blanket_Product_End_Date,
        Status,Blanket_Products,Select_sku,Select_Start_Date,Select_End_Date,Blanket_Download,Search_blanket,Blanket_Reset,
        Instructions_for_uploading_CSV_file,File_to_be_uploaded_must_be_in_CSV_format_Blanket,
        No_rows_will_be_uploaded,Please_do_not_change_combination_key,First,Blanket_Product_Previous_Button ,Page,of,Next,Last,Combination_Key,
        End_date_must_be_greater_than_start_date,Blanket_Products_Updated_Successfully,Success,Error,
        Error_while_updating_records,Error_while_getting_Records,Data_not_found,Start_date_and_end_date_are_compulsory,
        Start_date_and_end_date_should_be_in_yyyy_mm_dd_format,Loading,Expired_Reason,Expired_reason_is_required,File_upload_is_in_progress_You_will_be_receiving_a_confirmation_email_once_uplo
   }

  

@track draftValuePicklist = [];
draftValues = [];   //inline editing
lastSavedData = [];
@track pickListOptions=[];   //picklist
//datatable
@track columns=columns; 
@track skuList=[];
@track showTable=false;
@track showData=false;
//pagination 
@track items=[];
@track page = 1; 
@track startingRecord = 1;
@track endingRecord = 0; 
@track pageSize = 10; 
@track totalRecountCount = 0;
@track totalPage = 0;
@track recordsCount = 0;
@track rowNumberOffset=0;
disabled = false;
isPageChanged = false;
//Sorting
@track isDataSorted=false;
@track parseData;
@track data;
@track sortDirection='';
@track sortBy='';
//For File Download
@track skuFileData = {};
columnHeader = [ Combination_Key,Sku_Blanket,SKU_Code_Blanket,Blanket_Product_Start_Date, Blanket_Product_End_Date,Status,Expired_Reason];
//For File Upload
@track fileName = '';
filesUploaded = [];
//For Searching
@api skuNames;
@api startDateSku;
@api endDateSku;
@api bSkuStatus;
@track SKU_data = [];
//spinner
@track spinner = false;

//looK up
@track Sales_Org_Code = '';
@track filter='';
@track SkuId='';
@track disable_SKU=false;
@track SKUName='';



 
         
    //For Refreshing Table
    @wire (getAllActiveSku,{ pickList: '$pickListOptions' }) 
    refreshTable;

    /*
    * @Description  Fetching All SKU and Blanket Sku records and download data in file
    * @Param        NA 
    */
    @wire (getAllActiveSku,{ pickList: '$pickListOptions' }) 
    wiredActiveSku({error,data}){
        
        this.spinner = true;
    if (data) {
        if(data.length>0){
            
             var expire_values = this.pickListOptions;


             this.skuList = data.map(row=>{
             return{...row,  skuName: row && row.SKU_Description__c ? row.SKU_Description__c : '',
                skuCode:row.SKU_Code__c.slice(-7),
                salesOrgName:row.Sales_Org__r.Name,
                divisionCode:row && row.Division__r ? row.Division__r.Division_Code__c : '',
                distChannelCode:row && row.Distribution_Channel__r ? row.Distribution_Channel__r.Distribution_Channel_Code__c : '',
                startDate: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Start_Date__c : '',
                endDate: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].End_Date__c : '',
                skuStatus: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Status__c: null,
                pickListOptions: expire_values,
                Type1:row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Expired_Reason__c: '',
            }
        })
        console.log('ouside',this.skuList);
        console.log('ouside',this.skuList);
        this.processRecords(data);
        this.spinner = false;
    }else{
        this.page=0;
        this.dispatchEvent(
            new ShowToastEvent({
            title: Error,
            message: Data_not_found,
            variant: 'error',
            mode: 'dismissable'
        })
    );

    }
    
    } else if(error) {
            console.log(error);
        }
    }

    @wire(getObjectInfo, { objectApiName: BlanketSKUObj })
    blanketSkuMetadata;

    @wire(getPicklistValues, { recordTypeId: '$blanketSkuMetadata.data.defaultRecordTypeId', 
                               fieldApiName: expiredReason })
            expReasonPick({data,error}){
            if(data){
                this.pickListOptions=data.values;
                console.log('####',data)
                // this.refreshTable;
                    
            }else if(error){
    
            }
        }
           
    handleCellChange(event) {
        this.updateDraftValues(event.detail.draftValues[0]);
    }
    handleCancel(event) {
        //remove draftValues & revert data changes
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
        this.lastSavedData=[];
        refreshApex(this.refreshTable);
        this.processRecords(this.skuList);
    }

    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));
 
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
 
        //write changes back to original data
        this.data = [...copyData];
    }
 
    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        //store changed value to do operations
        //on save. This will enable inline editing &
        //show standard cancel & save button
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
 
        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }
 
     //listener handler to get the context and data
     //updates datatable
     picklistChanged(event) {
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        let updatedItem = { Id: dataRecieved.context, Type1: dataRecieved.value };
        console.log(updatedItem);
        this.updateDraftValues(updatedItem);
        this.updateDataValues(updatedItem);
    }

    /*
    * @Description  Upsert record in Blanket_SKU__c object.
    * @Param        String custWrapObjList - represents updated blanket sku records in string.
    * @return       returns success/error message.
    */ 
    handleSave(event) {

        const updatedFields = event.detail.draftValues;

        let rocordInputs=this.draftValues.slice().map(draft=>{
            let fields = Object.assign({},draft);
            return fields;
        })
        console.log('rocordInputs',rocordInputs);
        console.log('updatedFields',updatedFields);
        updatedFields.picklistValues=this.draftValues;
        this.draftValues = [];
       let rocords=rocordInputs.map(ele=>{
       
            let obj={
                Id:ele.Id,
                startDate:ele.startDate,
                endDate:ele.endDate,
                skuStatus:ele.skuStatus,
                Type1:ele.Type1 !=null ? (JSON.parse(JSON.stringify(ele.Type1)).join(';')):ele.Type1
            }
            console.log('obj',obj)
            return obj;
           
        })
        console.log('rocordInputs',rocords); 
        if(rocords[0]?.Type1==''){
            this.dispatchEvent(
                new ShowToastEvent({
                title: Error,
                message: Expired_reason_is_required,
                variant: 'error',
                mode: 'dismissable'
            })
        );
        this.page=1;
        this.rowNumberOffset=0;
        this.processRecords(this.skuList);
        return this.skuList;
        }
    try {
        
            updateSku({ custWrapObjList:JSON.stringify(rocords)})
            .then(result => {
                console.log('custWrapObjList',this.custWrapObjList);
               // console.log('startDate',updatedFields[0].startDate);
                if((rocords[0]?.startDate!=null || rocords[0]?.endDate!=null) || rocords[0]?.skuStatus!=null || rocords[0]?.Type1!=null){
                if(result=='SUCCESS'){
                    this.processRecords(this.data);
            refreshApex(this.refreshTable);
            this.page=1;
            this.rowNumberOffset=0;
            //this.displayRecordPerPage(this.page);
            this.dispatchEvent(
            new ShowToastEvent({
            title: Success,
            message: Blanket_Products_Updated_Successfully,
            variant: 'success',
            mode: 'dismissable'
        })
    );
  }
        else{
            refreshApex(this.refreshTable);
            this.dispatchEvent(
                new ShowToastEvent({
                title: Error,
                message: result,
                variant: 'error',
                mode: 'dismissable'
            })
        );
        }
                }else{
                     this.page=1;
                     this.rowNumberOffset = 0;
                    this.processRecords(this.skuList);
                    console.log('@@@@')
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: Error,
                        message: Start_date_and_end_date_are_compulsory,
                        variant: 'error',
                        mode: 'dismissable'
                    })
                );
                  
                }
})
}

        catch (error) {
            this.dispatchEvent(
            new ShowToastEvent({
            title: Error_while_updating_records,
            message: error.body.message,
            variant: 'error'
           })
         );
    }
}

    doSorting(event) {
        this.isDataSorted = true;
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        this.parseData = JSON.parse(JSON.stringify(this.skuList));
        // Return the value stored in the field
        let keyValue = (a) => {
        return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        this.parseData.sort((x, y) => {
        x = keyValue(x) ? keyValue(x) : ''; // handling null values
        y = keyValue(y) ? keyValue(y) : '';
        // sorting values based on direction
        return isReverse * ((x > y) - (y > x));
        });
        this.data = this.parseData.slice(0, this.pageSize);
        }


    //paginationCmp
    processRecords(skuList){
        this.items = this.skuList;
        this.totalRecountCount = skuList.length; 
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
        this.data = this.items.slice(0,this.pageSize); 
        this.endingRecord = this.pageSize;
        this.columns = columns;
   }

   //this method displays records page by page
    displayRecordPerPage(page){
        
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
    
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
        ? this.totalRecountCount : this.endingRecord; 
        if(this.isDataSorted==true){
            this.rowNumberOffset = this.startingRecord;
            this.data = this.parseData.slice(this.startingRecord, this.endingRecord);
        }else{
            this.rowNumberOffset = this.startingRecord;
            this.data = this.skuList.slice(this.startingRecord, this.endingRecord);
        }
        
        this.startingRecord = this.startingRecord + 1;
   } 

    firstHandler() {
        this.spinner = true;
        this.isPageChanged = true;
        if (this.page > 1) {
        this.page = 1; //display first page
        this.displayRecordPerPage(this.page);
        }
        this.spinner = false;
    }

    previousHandler() {
        this.spinner = true;
        this.isPageChanged = true;
        if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1
        this.displayRecordPerPage(this.page);
        }
        this.spinner = false;
    }

    nextHandler() {
        this.spinner = true;
        this.isPageChanged = true;
        if((this.page<this.totalPage) && this.page !== this.totalPage){
        this.page = this.page + 1; //increase page by 1
        this.displayRecordPerPage(this.page); 
        }
        this.spinner = false;
    }

    lastHandler() {
        this.spinner = true;
        this.isPageChanged = true;
        if((this.page<this.totalPage) && this.page !== this.totalPage){
        this.page = this.totalPage; //display last page
        this.displayRecordPerPage(this.page); 
        }
        this.spinner = false;
    }
    get isFirstDisable(){
        return (this.page == 1 ? true : false);
    }
       
    get isNextDisable(){
        return (this.page === this.totalPage || (this.page > this.totalPage)) ? true : false;
    } 
        
    //Download data in file    
    downloadCSVFile(){
        console.log('this.skuFileData',this.skuFileData);
            let doc = '';
            this.columnHeader.forEach(element => { 
                doc += element +',' ;    
            });
            doc+= '\n';
            // Add the data rows
            this.skuList.forEach(record => {
                doc += '\''+record.Combination_Key__c+'\''+','; 
                if(record.SKU_Description__c  != null && record.SKU_Description__c  != undefined  && record.SKU_Description__c.length > 0 ){
                   
                    doc += record.SKU_Description__c.replaceAll(',','.')+','; 
                } else{
                    doc += ','; 
                }
                doc += '\''+record.SKU_Code__c+'\''+',';
                
                if(record.Blanket_SKU__r  != null && record.Blanket_SKU__r  != undefined  && record.Blanket_SKU__r.length > 0 ){
                   
                    doc += record.Blanket_SKU__r[0].Start_Date__c+','; 
                } else{
                    doc += ','; 
                }
                if(record.Blanket_SKU__r  != null && record.Blanket_SKU__r  != undefined  && record.Blanket_SKU__r.length > 0 ){
                    doc += record.Blanket_SKU__r[0].End_Date__c+','; 
                } else{
                    doc += ',';
                }
                if(record.Blanket_SKU__r  != null && record.Blanket_SKU__r  != undefined  && record.Blanket_SKU__r.length > 0 ){
                    doc += record.Blanket_SKU__r[0].Status__c ? 'Active' : 'Inactive';
                    doc +=','; 
                } else{
                    doc += ',';
                }   
                if(record.Blanket_SKU__r  != null && record.Blanket_SKU__r[0].Expired_Reason__c  != undefined  && record.Blanket_SKU__r.length > 0 ){
                    console.log('11111',record.Blanket_SKU__r[0].Expired_Reason__c);
                    doc += record.Blanket_SKU__r[0].Expired_Reason__c;
                } else{
                    doc += '';
                }           
                    doc += '\n'; 

        });
            var element = 'data:text/csv;charset=utf-8,' + encodeURI(doc);
            let downloadElement = document.createElement('a');
            downloadElement.href = element;
            downloadElement.target = '_self';
            
            downloadElement.download = 'BlanketProducts.csv';
            document.body.appendChild(downloadElement);
            downloadElement.click();
        }

    //Upload downloaded csv file in blanKet SKU obj
    get acceptedFormats() {
        return ['.csv'];
    }
     /*
    * @Description  Upsert Records through Uploaded File.
    * @Param        Id idContentDocument - represents id of uploaded file 
    * @return       returns success/error message.
    */
    uploadBlanketSkuFile(event) {
                if(event.detail.files.length > 0) {
                    this.spinner = true;
                    this.filesUploaded = event.detail.files;
                    this.fileName = event.detail.files[0].name;
                    this.file = this.filesUploaded[0];
                    console.log('this.file',this.file);
            uploadDownloadedCsvFile({idContentDocument : this.filesUploaded[0].documentId})
                        .then(result => {
                            this.data = result;
                            if(result=='SUCCESS'){
                                this.spinner = false;
                                this.page=1;
                                this.processRecords(this.skuList);
                                refreshApex(this.refreshTable);
                                
                                this.dispatchEvent(
                                new ShowToastEvent({
                                title: Success,
                                message: File_upload_is_in_progress_You_will_be_receiving_a_confirmation_email_once_uplo,
                                variant: 'success',
                                mode: 'dismissable'
                            })
                        );
                      }
                      else {
                        this.spinner = false;
                        this.page=1;


                        this.processRecords(this.skuList);
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title:Error,
                            message: result,
                            variant: 'error',
                            mode: 'dismissable'
                        })
                    );
                    
                      }
                    })
            .catch(error => {
                        this.error = error;
                        this.page=1;
                        this.processRecords(this.skuList);
                        this.spinner = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: Error,
                                message: JSON.stringify(error),
                                variant: 'error',
                                mode: 'dismissable'
                            }),
                        ); 
            })
    
        }
    } 
   
   
//Searching
    handleStartDateChange( event ) {
                this.page = 1; 
                this.startDateSku = event.target.value;
      
    }

    handleEndDateChange(event){
                this.page = 1; 
                this.endDateSku = event.target.value;
       
    }

    handleStatusChange(event){
        this.page = 1; 
        this.bSkuStatus = event.target.checked;
   
    }

handleSKUChange(event){
    console.log('Id',event.detail.recId);
    this.SkuId=event.detail.recId;
    this.SKUName=event.detail.recName;
}
handleRemoveSKU() {
    this.SkuId='';
    console.log('remove');
    this.SKUName='';

}


 /*
    * @Description  Method used to fetch log-in user sales org.
    * @return       returns log-in user sales org.
    */
@wire(getSalesOrg)
getUserCountry({ error, data }) {
    if(data){
        this.Sales_Org_Code=data.Sales_Org_Code__c;
        this.filter='Sales_Org_Code__c='+'\''+this.Sales_Org_Code+'\''+'Limit 15';
    } 
    if (error) {
        this.Sales_Org_Code = '';
        this.spinner = false;
    }
}


    resetFields(){
        eval("$A.get('e.force:refreshView').fire();"); 
        console.log('inside');
        this.SkuId='';
        this.SKUName='';
        this.startDateSku=null;
        this.endDateSku=null;
        this.bSkuStatus=null;
        this.template.querySelectorAll('input').forEach(element => {
            if(element.type === 'checkbox' || element.type === 'checkbox-button'){
              element.checked = false;
            }else{
              element.value = null;
            }      
          });
          refreshApex(this.refreshTable);
        console.log('s SkuId '+this.SkuId);
        console.log('s startDateSku '+this.startDateSku);
        console.log('s endDateSku '+this.endDateSku);
        console.log('s bSkuStatus '+this.bSkuStatus);               
    }

   /*
    * @Description  Method used to search blanket SKU based on filters.
    * @return       Returns list of SKUs.
    */

    searchRecords(){
        console.log('s SkuId '+this.SkuId);
        console.log('s startDateSku '+this.startDateSku);
        console.log('s endDateSku '+this.endDateSku);
        console.log('s bSkuStatus '+this.bSkuStatus);
        if(this.SkuId=='' && this.startDateSku==null && this.endDateSku==null && this.bSkuStatus==null){
            this.page=1;
            this.showData=false;
                this.showTable=false;
                this.isDataSorted=false;
            this.rowNumberOffset = 0;
            this.processRecords(this.skuList);
            return refreshApex(this.refreshTable);
        }
        getBlanketSkuBySearch({SkuId: this.SkuId,startDateSku: this.startDateSku,endDateSku:this.endDateSku,bSkuStatus:this.bSkuStatus})
            .then(data=>{
                console.log('s data '+data);
              
             if(this.SkuId!='' || this.bSkuStatus!=null || this.endDateSku>=this.startDateSku){
                this.spinner = true;
                if(data.length>0){
                    this.spinner = false;
                this.showData=false;
                this.showTable=false;
                this.isDataSorted=false;
                this.rowNumberOffset = 0;
                var expire_values = this.pickListOptions;
                this.page=1;
                this.skuList = data.map(row=>{
                    return{...row,  skuName: row && row.SKU_Description__c ? row.SKU_Description__c : '',
                    skuCode:row.SKU_Code__c.slice(-7),
                    salesOrgName:row.Sales_Org__r.Name,
                    divisionCode:row && row.Division__r ? row.Division__r.Division_Code__c : '',
                    distChannelCode:row && row.Distribution_Channel__r ? row.Distribution_Channel__r.Distribution_Channel_Code__c : '',
                    startDate: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Start_Date__c : '',
                    endDate: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].End_Date__c : '',
                    skuStatus: row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Status__c: null,
                    pickListOptions: expire_values,
                    Type1:row && row.Blanket_SKU__r && row.Blanket_SKU__r.length ? row.Blanket_SKU__r[0].Expired_Reason__c: '',
                }
               })
               //this.page = 1; 
            //    console.log('123',this.refreshTable);
               refreshApex(this.refreshTable);
               this.processRecords(data);
               
              
            }else{
                this.spinner = false;
                this.showTable=true;
                this.showData=true;
                this.page=0;
                this.skuList='';
                this.dispatchEvent(
                    new ShowToastEvent({
                    title: Error,
                    message: Data_not_found,
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
            }}else{
                this.spinner = false;
                this.showTable=true;
                this.showData=true;
                this.skuList='';
                this.dispatchEvent(
                    new ShowToastEvent({
                    title: Error,
                    message: End_date_must_be_greater_than_start_date,
                    variant: 'error',
                    mode: 'dismissable'
                })
            );
               }
               
            }) 
            .catch(error=>{
            console.log(error);
            this.error = error;
            this.data = undefined;
     })
   
}          
}