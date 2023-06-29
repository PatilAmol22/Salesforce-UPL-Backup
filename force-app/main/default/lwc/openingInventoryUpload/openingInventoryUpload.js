import { LightningElement,api,track } from 'lwc';
import Upload_Opening_Inventory from '@salesforce/label/c.Upload_Opening_Inventory';
import Year from '@salesforce/label/c.Year';
import Close from '@salesforce/label/c.Close';
import PleaseWait from '@salesforce/label/c.Please_wait';
import Pleaseuploadfile from '@salesforce/label/c.Please_upload_file';
import Upload from '@salesforce/label/c.Upload';
import Instructions from '@salesforce/label/c.Instructions';
import Cancel from '@salesforce/label/c.Cancel';
import MustBeCSV from '@salesforce/label/c.File_to_be_uploaded_must_be_in_CSV_format';
import ColumnSequense from '@salesforce/label/c.Please_follow_the_same_column_sequence_and_column_names_as_given_in_template';
import DecimalNotAllowed from '@salesforce/label/c.Decimal_Values_Are_Not_Allowed_In_The_File';
import DownloadTemplate from '@salesforce/label/c.Download_Template';
import DoNotIncludeEmptyRows from '@salesforce/label/c.Do_not_include_empty_rows_between_the_first_and_last_rows_of_data';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getOIDetails from '@salesforce/apex/OpeningInventoryUploadController.getOIDetails';
import getOpeningInvRecords from '@salesforce/apex/OpeningInventoryUploadController.getOpeningInvRecords';
import updateOpeningInv from '@salesforce/apex/OpeningInventoryUploadController.updateOpeningInv';
import ErrorT from '@salesforce/label/c.Error';
import SuccessT from '@salesforce/label/c.Success';
import ErrorReadingFile from '@salesforce/label/c.Error_reading_file';
import FileNotReadable from '@salesforce/label/c.File_is_not_readable';
import SelectFile from '@salesforce/label/c.Please_select_file';
import FileHasNullYearValue from '@salesforce/label/c.File_has_Null_Year_value';
import FileHasNullDistributorCode from '@salesforce/label/c.File_has_Null_Distributor_Code';
import FileHasNullSKUCode from '@salesforce/label/c.File_has_Null_SKU_Code';
import YearMismatched from '@salesforce/label/c.Year_Mismatched';
import InvalidOrDecimalNumberFound from '@salesforce/label/c.Invalid_Or_Decimal_Number_Found_In_Distributor';
import FileHasNullOpeningInventory from '@salesforce/label/c.File_has_null_opening_inventory';
import UnexpectedError from '@salesforce/label/c.ERROR_REQUEST_FAILED_NO_ERROR';
import UploadedSuccessfully from '@salesforce/label/c.File_uploaded_successfully';
import PartialUploadSuccessful from '@salesforce/label/c.PartialUploadSuccessful';
import NumberofColumnsMismatchedCSV from '@salesforce/label/c.Number_of_Columns_Mismatched_in_CSV_File';
import NoDataFound from '@salesforce/label/c.No_Data_Found_For_Uploading';
import FailToUpload from '@salesforce/label/c.File_Upload_Failed';
import RequestFailed from '@salesforce/label/c.Request_Failed';
import CsvUploadErrorMsg from '@salesforce/label/c.Grz_CsvUploadErrorMsg';	
import Attachment from '@salesforce/label/c.Attachments';
export default class openingInventoryUpload extends LightningElement {
    @api distributorId = '';
    @api salesOrgCode = '';
    @api year = '';
    @track templateLink = '';
    @track isModalOpen = false;
    @track showSpinner = false;
    @track Dis_Code = []; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    @track Sku_Code = []; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    @track error = '';
    @track fileName = '';
    @track disableUpload = false;
    @track inputFiles = '';    
    @track flag = true;
    @track combiKeyList = new Map();
    @track liquiMap = new Map();
    @track partialRecords=false;
    @track csvList = [];  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    label = {
        Upload_Opening_Inventory,
        Year,
        Close,
        PleaseWait,
        Pleaseuploadfile,
        Upload,
        Instructions,
        Cancel,
        MustBeCSV,
        ColumnSequense,
        DecimalNotAllowed,
        DownloadTemplate,
        DoNotIncludeEmptyRows,
        Attachment
    }
    connectedCallback(){
        getOIDetails() 
        .then(result => { 
            console.log('getOIDetails result -> ', result);
           
            if(result){
                  this.templateLink = '/servlet/servlet.FileDownload?file='+result;
               }
            else{
                this.templateLink = '';
            }
        })
        .catch(error => {
            console.log('getOIDetails js method catch');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })    
        this.isModalOpen = true;
        this.showSpinner = false;
    
    }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent('closemodel',{detail:this.isModalOpen}));
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

    clearSelectedFile(){
        this.template.querySelector("lightning-input[data-my-id=file_id]").value = '';
        this.fileName = '';
        this.inputFiles ='';   
    }

    handleSubmitClick(event){
        this.combiKeyList = new Map();
        this.inputFiles = this.template.querySelector("lightning-input[data-my-id=file_id]");
        //console.log('inputFiles.files - ', this.inputFiles.files);
        if (this.inputFiles.files != null) {
            let fileExtension = '';
            let file = this.inputFiles.files[0];
            //this.fileName = event.target.files[0].name;
            fileExtension = this.inputFiles.files[0].name.split('.').pop();
            console.log('File size .. - ', file.size);
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
        if(csv != null){
            this.disableUpload = true;
            let arr = [];
            this.flag = true;
            let obj = {};
            let obj2 ={};
            let key ='';
            let openInv = 0;
            let skuMap = new Map();
            let distCode = '';
            let skuCode = '';
            let combList = [];
            arr = csv.split('\n');

            if(arr[0]=='Year,Distributor Code,SKU Code,Opening Inventory\r'){
                console.log('inside correct order');
            }
            else{
                console.log('inside incorrect order');
                return this.showToastmessage(ErrorT,CsvUploadErrorMsg,'error');
            }

            arr.pop();
           
            for(let i = 1; i < arr.length; i++) {
             
                openInv = 0;
                key = '';
                distCode = '';
                skuCode = '';

                let re =/,(?=(?:(?:[^"]*"){2})*[^"]*$)/g;				
                let data = [].map.call(arr[i].split(re), function(el) {
                    return el.replace(/^"|"$/g, '');
                 }
                );
				 if(data.length == 4){
                    
                        for(let j = 0; j < data.length; j++) {
                            let val = data[j].trim();
                            
                            if(val.length == 0){
                                if(j == 0 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullYearValue,'error');
                                }
                                else if(j == 1 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullDistributorCode,'error');
                                }
                                else if(j == 2 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullSKUCode,'error');
                                }
                                else if(j == 3 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullOpeningInventory,'error');
                                }
                            }
                            else{
                                if(j == 0){
                                    if(val != this.year){
                                        this.flag = false;
                                        //this.showSpinner = false;
                                        this.showToastmessage(ErrorT,YearMismatched,'error');
                                    }
                                }
                                else if(j == 1){
                                    if(val.length == 5){
                                        val='00000'+val;   // if length is 5 then added 5 zeros. 
                                    }
                                    else if(val.length == 6){
                                        val='0000'+val;   // if length is 6 then added 4 zeros. 
                                    }
                                    else if(val.length == 7){
                                        val='000'+val;    // if length is 7 then added 3 zeros.
                                    }
                                    else if(val.length == 8){
                                        val='00'+val;    // if length is 8 then added 2 zeros.
                                    }
                                    else if(val.length == 9){
                                        val='0'+val;    // if length is 9 then added 1 zeros.
                                    }
                                    distCode = val;
                                    
                                }
                                else if(j == 2){
                                    
                                    if(val.length == 5){
                                        val='0000000000000'+val;   // if length is 6 then added 13 zeros. 
                                    }
                                    else if(val.length == 6){
                                        val='000000000000'+val;   // if length is 6 then added 12 zeros. 
                                    }
                                    else if(val.length == 7){
                                        val='00000000000'+val;    // if length is 7 then added 11 zeros.
                                    }
                                    skuCode = val;
                                    key = skuCode+distCode+this.year+this.salesOrgCode;    // salesOrg+liq.Distributor__r.    
                                    
                                }
                                else if(j == 3){
                                    if(val % 1 !== 0){
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,InvalidOrDecimalNumberFound,'error');
                                    }
                                    else{
                                        openInv = val;
                                    }
                                }                           
    
                            if(this.flag == false){
                               // this.showSpinner = false;
                                break;
                            }
                            
                        }
                        
                    }
				 }
                    else{
                       // this.showSpinner = false;
                        this.showToastmessage(ErrorT,NumberofColumnsMismatchedCSV,'error');
                        this.flag = false;
                       
                        break;
                    }
    
                    if(this.flag == true){
                        console.log('flag - ', this.flag);
                         /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
                        let csvObj = {};
                        csvObj.openInv = openInv;
                        csvObj.year = this.year;
                        csvObj.distbtrCode = distCode;
                        csvObj.skuCode = skuCode;
                        console.log('csvObj',csvObj)
                        this.csvList.push(csvObj);
                        console.log('this.csvList',this.csvList);
                        /* -- */
                        let obj3 = {};
                        if(this.combiKeyList.has(key)){
                            let o=this.combiKeyList.get(key);
                           obj3.combKey=key;
                           obj3.openInv=parseInt(o.openInv)+parseInt(openInv);
                           this.combiKeyList.set(key,obj3);
                        }
                        else{
                            obj3.combKey = key;
                            obj3.openInv = openInv;
                            this.combiKeyList.set(key,obj3);
                        }
                      
                    }
                    else{
                        break;
                    }
			}
            this.clearSelectedFile();
           
            if(this.combiKeyList.size > 0 && this.flag ==true){
                this.disableUpload = true;
                for (let key5 of this.combiKeyList.keys()) {
                    combList.push(key5);
                }
               
                console.log('combList - ', combList);
                this.openingInvRecords(combList);
            }
            //console.log('combiKeyList - ', this.combiKeyList);
        }
        
        //this.showSpinner = false;
    }

    openingInvUpdate(oiData){
        this.showSpinner = true;
        let data = JSON.stringify(oiData);
        updateOpeningInv({oiData : data, dupList : JSON.stringify(this.csvList), Sku_Code : this.Sku_Code, Dis_Code : this.Dis_Code}) /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
        .then(result => {
            console.log('liquidationUpdate result', result);
            this.showSpinner = false;
            if(result == 'success'){
                if(this.partialRecords){
                    this.showToastmessage(SuccessT,PartialUploadSuccessful,'success');
                }
                else{
                    this.showToastmessage(SuccessT,UploadedSuccessfully,'success');
                }
                this.closeModal();
                this.dispatchEvent(new CustomEvent('uploadfile',{detail:true}));
            }
            else if(result == 'data not found'){
                this.showToastmessage(ErrorT,NoDataFound,'error');
                this.disableUpload = false;
                this.dispatchEvent(new CustomEvent('uploadfile',{detail:false}));
            }
            else if(result == 'fail'){
                this.disableUpload = false;
                this.showToastmessage(ErrorT,FailToUpload,'error');
                this.dispatchEvent(new CustomEvent('uploadfile',{detail:false}));
            }
            else{
                this.disableUpload = false;
                this.showToastmessage(ErrorT,RequestFailed,'error');
                this.dispatchEvent(new CustomEvent('uploadfile',{detail:false}));
                // unexpectd error
            }

        })
        .catch(error => {
            console.log('liquidationUpdate js method catch',error);
            this.disableUpload = false;
            this.showToastmessage(ErrorT,UnexpectedError,'error');
            this.showSpinner = false;
        })
       // this.showSpinner = false;
    }

    handleFileChange(event){
        if (event.target.files.length > 0) {
            this.fileName = event.target.files[0].name;
            this.disableUpload = false;
        }
        else{
            this.fileName = '';
            this.disableUpload = true;
        }
    }

    openingInvRecords(combiKeyList){
        this.showSpinner = true;
        let data = JSON.stringify(combiKeyList);
        let obj = {};
        let obj2 ={};
        this.liquiDataOut = [];
        getOpeningInvRecords({combi_key : data, year : this.year})
        .then(result => {
            console.log('result is - ' , JSON.stringify(result));
            if(result.length > 0){
                this.liquiList = result;
                              
                for(let liq of this.liquiList){
                    this.Sku_Code.push(liq.SKU__r.SKU_Code__c); /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
                    this.Dis_Code.push(liq.Distributor__r.SAP_Code__c); /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
					let key='';
						key = liq.SKU__r.SKU_Code__c+liq.Distributor__r.SAP_Code__c+this.year+this.salesOrgCode;
					
                    if(!this.liquiMap.has(key)){
                        this.liquiMap.set(key,liq);
                    }
                } 
console.log('this.liquiMap==>',this.liquiMap);
                if(this.liquiMap.size > 0 && this.combiKeyList.size > 0){
                    let myMap = new Map(this.liquiMap);
                    console.log('myMap==>',myMap);
                    let outData = [];
                    let yr = this.year;
                    this.combiKeyList.forEach(function(value2, key2) {
                        obj2 = {};
                        obj2 = myMap.get(key2);
                        console.log('obj2 - ', JSON.stringify(obj2));
                        if(obj2 != undefined){
                            obj = {};
                            obj.id = obj2.Id;
                            obj.openInv = value2.openInv;
                            obj.year = yr;
                            obj.distbtrCode = obj2.Distributor__r.SAP_Code__c;
                            obj.skuCode = obj2.SKU__r.SKU_Code__c;
                            outData.push(obj);
                        } 
                    })
console.log('this.combiKeyList.size==>',this.combiKeyList.size);
                    if(outData.length > 0 && this.flag ==true){
                        this.openingInvUpdate(outData,this.isPoland);
                        if(outData.length!=this.combiKeyList.size){
                            console.log('partial success');
                            this.partialRecords=true;
                        }
                    }
                }
               
            }
            else{
                this.disableUpload = true;
                this.showSpinner = false;
              
                
            }
          
        })
        .catch(error => {
            console.log('getLiquidationRecords js method catch 1');
            console.log(error);
            this.error = error;          
            this.showSpinner = false;
        })
    }


}