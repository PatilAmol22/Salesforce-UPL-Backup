import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getChildSKUList from '@salesforce/apex/ParentChildSkuMappingController.getChildSKUList';
import saveMapping from '@salesforce/apex/ParentChildSkuMappingController.saveMapping';
import uploadCSV from '@salesforce/apex/ParentChildSkuMappingController.uploadCSV';
import PleaseWait from '@salesforce/label/c.Please_wait';
import NoRecordsFound from '@salesforce/label/c.No_Records_Found';
import ErrorT from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Warning from '@salesforce/label/c.Warning';
import FailToCreateRecord from '@salesforce/label/c.Failed_To_Create_Record';
import MappingSaved from '@salesforce/label/c.Mapping_Saved_Successfully';
import Savemapping from '@salesforce/label/c.Save_the_mapping';
import ChildSKU from '@salesforce/label/c.Child_SKU';  // new
import ParentSKU from '@salesforce/label/c.Parent_SKU'; // new
import SearchSKU from '@salesforce/label/c.Search_SKU'; // new
import PrentChildMapping from '@salesforce/label/c.Parent_Child_SKU_Mapping'; // new
import SearchFields from '@salesforce/label/c.Search_Fields'; // new
import Cancel from '@salesforce/label/c.Cancel';
import SKUNotFound from '@salesforce/label/c.SKU_Not_Found';  // new
import Name from '@salesforce/label/c.Name';
import SKUCode from '@salesforce/label/c.SKU_Code';
/* ----------------------------*******************************------------------------------- */
import ErrorReadingFile from '@salesforce/label/c.Error_reading_file';
import FileNotReadable from '@salesforce/label/c.File_is_not_readable';
import SelectFile from '@salesforce/label/c.Please_select_file';
import NumberofColumnsMismatchedCSV from '@salesforce/label/c.Number_of_Columns_Mismatched_in_CSV_File';
import DuplicateEntriesNotAllowed from '@salesforce/label/c.Duplicate_entries_are_not_allowed';
import ChildSKUCanNotBeBlank from '@salesforce/label/c.Child_SKU_can_not_be_blank';
import OneChildOneParent from '@salesforce/label/c.One_child_can_not_have_multiple_parent';
import ChildSKUCode from '@salesforce/label/c.Child_SKU_Code';
import ParentSKUCode from '@salesforce/label/c.Parent_SKU_Code';
import FailedToUploadFile from '@salesforce/label/c.Failed_to_upload_file_Please_check_your_email_for_more_details';

export default class ParentChildSkuMapping extends LightningElement {
    @track product_filter = 'RecordType.Name=\'SKU\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\' AND Is_Forecast_Required__c = true';
    @track productName= '';
    @track productId= '';
    @track disableProduct = false;
    @track skuList = [];
    @track showSpinner = false;
    @track isSKUList = false;
    @track serarchField = 'Name';  // default....
    @track productChildFilter = 'RecordType.Name=\'SKU\' AND Sales_Org__r.Sales_Org_Code__c = \'5191\' AND Is_Forecast_Required__c = false';
    @track fileName = '';
    @track disableUpload = false;
    @track skuMap = new Map();
    @track childSKU = new Map();

    label = {
        PleaseWait,
        NoRecordsFound,
        ErrorT,
        Success,
        Warning,
        FailToCreateRecord,
        MappingSaved,
        Savemapping,
        ChildSKU,
        ParentSKU,
        SearchSKU,
        PrentChildMapping,
        SearchFields,
        Cancel,
        SKUNotFound,
        Name,
        SKUCode,
        ErrorReadingFile,
        FileNotReadable,
        SelectFile,
        ChildSKUCanNotBeBlank,
        OneChildOneParent,
        ChildSKUCode,
        ParentSKUCode,
        FailedToUploadFile
    };

    csvHeaders ={
        prodCode:ChildSKUCode,
        prodCodeParent:ParentSKUCode
    }

    @track value = 'Name';
    get options() {
        return [
            { label: Name, value: 'Name' },
            { label: SKUCode, value: 'Product_Code__c' }
        ];
    }

    @api
    run(){                             // ** work like connectedcallback. called on tab click of parent component.....
        //console.log('run called in Child');
        this.showSpinner = true;
        this.fetchSKUList();
    }

    handleProductSelected(event){
        //console.log(`handleProductSelected ${event.detail.recId}-${event.detail.recName}`);
        //this.productName = event.detail.recName;
        let indx = event.target.dataset.targetId;
        let obj = new Object();
        if(indx != '' || indx != null){
            obj = this.skuList[indx];
            obj.prodNameParent = event.detail.recName;
            obj.prodIdParent = event.detail.recId;
            this.skuList[indx] = obj;
        }
    }

    handleRemoveProduct(event){
        //console.log('Removing product ');
        let indx = event.target.dataset.targetId;
        let obj = new Object();
        if(indx != '' || indx != null){
            obj = this.skuList[indx];
            obj.prodNameParent = '';
            obj.prodIdParent = '';
            this.skuList[indx] = obj;
        }
    }

    handleChildSelected(event){
        
        this.productName = event.detail.recName;
        this.productId = event.detail.recId;
        this.fetchSKUList();
    }

    handleRemoveChild(event){
        this.productName = '';
        this.productId = '';
        this.fetchSKUList();
    }

    handleRadioChange(event) {
        this.serarchField = event.detail.value;
    }

    fetchSKUList(){
        getChildSKUList({prId : this.productId})                     
        .then(result => { 
            //console.log('getChildSKUList result.length - ', result.length);
            //console.log('result - ', result);
             
            if(result.length>0){              
                this.skuList = result;
                this.isSKUList = true;
            }
            else{
                this.showToastmessage(ErrorT,SKUNotFound,'Error');
            }
            this.showSpinner = false;
        })
        .catch(error => {
            console.log('fetchSKUList js method catch');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })
    }

    handleSaveMapping(){
        this.showSpinner = true;
        saveMapping({skuMapping : JSON.stringify(this.skuList)})
        .then(result => {
            //console.log('saveMapping result', result);
            if(result.length>0){
                if(result == 'success'){
                    this.showToastmessage(Success,MappingSaved,'Success');
                    setTimeout(function() {
                        window.location.reload();
                    }, 1000);
                }
                else{
                    this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
                }
            }
            else{
                this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
            }
            this.showSpinner = false;                
                
        })
        .catch(error => {
            this.showSpinner = false;
            console.log('saveMapping js method catch');
            this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
        })
        
    }

    handleFileChange(event){
        if(event.target.files.length > 0) {
            this.fileName = event.target.files[0].name;
            let fileExtension = '';
            let file = event.target.files[0];
            fileExtension = event.target.files[0].name.split('.').pop();
            //console.log('File size .. - ', file.size);

            if(fileExtension == 'csv' || fileExtension == 'CSV') { 
                
                let reader = new FileReader();
                reader.readAsText(file, "UTF-8");
                /* reader.onload = function (evt) {
                    
                    this.csv = evt.target.result;
                } */
                reader.onload = (event) => {
                    this.csv2JSON(reader.result); // This is valid
                };
                                
                reader.onerror = (event) => {
                    this.showToastmessage(ErrorT,ErrorReadingFile,'error');
                };
            }
            else{
                //this.showSpinner = false;
                this.showToastmessage(ErrorT,FileNotReadable,'error');
            }
        }
        else{
            //this.showSpinner = false;
            this.showToastmessage(ErrorT,SelectFile,'error');
        }
    }

    csv2JSON(csv){
        console.log('csv2JSON .. - ');
        if(csv != null){
            this.showSpinner = true;
            this.disableUpload = true;
            this.skuMap = new Map();
            let arr = [];
            let mapValues = [];
            let errorFlag = false;
            let key ='';
            let childSKU = '';
            let parentSKU = '';
            arr = csv.split('\n');
            arr.pop();

            for(let i = 1; i < arr.length; i++) {
                key = '';
                childSKU = '';
                parentSKU = '';

                let re = ';';  // /,(?=(?:(?:[^"]*"){2})*[^"]*$)/g;				// /,(?=(?:(?:[^"]*"){2})*[^"]*$)/; 
                let data = [].map.call(arr[i].split(re), function(el) {
                    return el.replace(/^"|"$/g, '');
                 }
                );
                 //console.log('data length - ', data.length);
                if(data.length == 2){
                    for(let j = 0; j < data.length; j++) {
                        let val = data[j].trim();
                        if(j == 0 && val.length == 0){
                            errorFlag = true;
                            //this.showSpinner = false;
                            this.showToastmessage(ErrorT,ChildSKUCanNotBeBlank,'error');
                        }
                        else{
                            if(j == 0){
                                if(val.length > 0){
                                    childSKU = this.appendZero(val.length)+val; 
                                    //console.log('childSKU after append .. - ', childSKU);
                                }
                            }
                            else if(j == 1){
                                if(val.length > 0){
                                    parentSKU = this.appendZero(val.length)+val; 
                                    //console.log('parentSKU after append .. - ', parentSKU);
                                }
                            }
                        }
                        if(errorFlag == true){
                             this.showSpinner = false;
                             break;
                        }
                    }
                }
                else{
                    this.showSpinner = false;
                    this.disableUpload = false;
                    this.showToastmessage(ErrorT,NumberofColumnsMismatchedCSV,'error');
                    errorFlag = true;
                    break;
                }

                if(errorFlag == false){
                    key = childSKU+parentSKU;
                    key = key.trim();

                    if(this.skuMap.has(key)){
                        errorFlag = true;
                        this.showSpinner = false;
                        this.disableUpload = false;
                        this.showToastmessage(ErrorT,DuplicateEntriesNotAllowed,'error');
                        break;
                    }
                    else{
                        if(this.childSKU.has(childSKU.trim())){
                            //console.log('this.childSKU - ', this.childSKU);
                            //console.log('childSKU.trim() - ', childSKU.trim());
                            errorFlag = true;
                            this.showSpinner = false;
                            this.disableUpload = false;
                            this.showToastmessage(ErrorT,OneChildOneParent,'error');
                            break;
                        }
                        else{
                            let obj = {};
                            obj.prodCode = childSKU.trim();
                            obj.prodCodeParent = parentSKU.trim();
                            this.skuMap.set(key,obj);
                            mapValues.push(obj);
                            if(parentSKU.trim().length>0){
                                this.childSKU.set(childSKU.trim(),parentSKU.trim());
                            }
                        }
                    }
                }
                else{
                    this.showSpinner = false;
                    this.disableUpload = false;
                }
            }

            if(mapValues.length > 0 && errorFlag == false){
                //console.log('mapValues .. - ', JSON.stringify(mapValues));
                this.uploadCSVData(mapValues);
            }
        }
    }

    uploadCSVData(records){
        console.log('uploadCSVData .. - ');
        this.showSpinner = true;
        let data = JSON.stringify(records);
        //console.log('data .. - ', data);
        uploadCSV({skuData : data})
        .then(result => {
            this.showSpinner = false;
            
            if(result == 'success'){
                this.clearSelectedFile();
                this.showToastmessage(Success,MappingSaved,'Success');
                setTimeout(function() {
                    window.location.reload();
                }, 1000);
            }
            else if(result == 'error'){
                this.disableUpload = false;
                this.showToastmessage(ErrorT,FailedToUploadFile,'Error');
            }
            else if(result == 'exception'){
                this.disableUpload = false;
                this.showToastmessage(ErrorT,FailToCreateRecord,'Error');
            }
            
        })
        .catch(error => {
            console.log('uploadCSVData js method catch 1');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })
    }

    appendZero(valLength){
        let totalLength = 18 - valLength;
        let str = '';
        if(totalLength > 0){
            for(let k = 0; k < totalLength; k++){
                str += '0';
            }
        }
        return str;
    }

    clearSelectedFile(){
        this.template.querySelector("lightning-input[data-my-id=file_id]").value = '';
        this.fileName = '';
        this.disableUpload = false;
        
    }

    showToastmessage(title,message,varient){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    }

    handleCancel(){
        this.showSpinner = true;
        this.productName = '';
        this.productId = '';
        this.fetchSKUList();
    }

    downloadCSV(){
        this.exportCSVFile(this.csvHeaders, this.skuList, "Parent Child SKU Mapping")
    }

    exportCSVFile(headers, totalData, fileTitle){
        if(!totalData || !totalData.length){
            return null
        }
        const jsonObject = JSON.stringify(totalData)
        const result = this.convertToCSV(jsonObject, headers)
        if(result === null) return
        const blob = new Blob([result])
        const exportedFilename = fileTitle ? fileTitle+'.csv' :'export.csv'
        if(navigator.msSaveBlob){
            navigator.msSaveBlob(blob, exportedFilename)
        } else if (navigator.userAgent.match(/iPhone|iPad|iPod/i)){
            const link = window.document.createElement('a')
            link.href='data:text/csv;charset=utf-8,' + encodeURI(result);
            link.target="_blank"
            link.download=exportedFilename
            link.click()
        } else {
            const link = document.createElement("a")
            if(link.download !== undefined){
                const url = URL.createObjectURL(blob)
                link.setAttribute("href", url)
                link.setAttribute("download", exportedFilename)
                link.style.visibility='hidden'
                document.body.appendChild(link)
                link.click()
                document.body.removeChild(link)
            }
        }
        
    
    }

    convertToCSV(objArray, headers){
        const columnDelimiter = ';';//',';
        const lineDelimiter = '\r\n';
        const actualHeaderKey = Object.keys(headers);
        const headerToShow = Object.values(headers);
        let str = ''
        str+=headerToShow.join(columnDelimiter) 
        str+=lineDelimiter
        const data = typeof objArray !=='object' ? JSON.parse(objArray):objArray
    
        data.forEach(obj=>{
            let line = ''
            actualHeaderKey.forEach(key=>{
                if(line !=''){
                    line+=columnDelimiter
                }
                let strItem = obj[key]+''
                line+=strItem? strItem.replace(/,/g, ''):strItem
            })
            str+=line+lineDelimiter
        })
        console.log("str", str)
        return str
    }
    
}