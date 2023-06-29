import { LightningElement, track, api, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getLiquidationRecords from '@salesforce/apex/LiquidationUploadController.getLiquidationRecords';
import updateLiquidation from '@salesforce/apex/LiquidationUploadController.updateLiquidation';
import getTemplateToDownload from '@salesforce/apex/LiquidationUploadController.getTemplateToDownload';
import getSalesDistrictName from '@salesforce/apex/LiquidationUploadController.getSalesDistrictName';
import getLiquidationDetails from '@salesforce/apex/LiquidationUploadController.getLiquidationDetails';
import LiquidationRecordNotFound from '@salesforce/label/c.Liquidation_Records_Not_Found';
import ErrorT from '@salesforce/label/c.Error';
import ErrorReadingFile from '@salesforce/label/c.Error_reading_file';
import FileNotReadable from '@salesforce/label/c.File_is_not_readable';
import SelectFile from '@salesforce/label/c.Please_select_file';
import FileHasNullSalesOrgCode from '@salesforce/label/c.File_has_Null_Sales_Org_Code';
import FileHasNullYearValue from '@salesforce/label/c.File_has_Null_Year_value';
import FileHasNullMonthValue from '@salesforce/label/c.File_has_Null_Month_value';
import FileHasNullDistributorCode from '@salesforce/label/c.File_has_Null_Distributor_Code';
import FileHasNullSKUCode from '@salesforce/label/c.File_has_Null_SKU_Code';
import FileHasNullDistributorIventory from '@salesforce/label/c.File_has_Null_Distributor_Iventory';
import FileHasNullRetailerIventory from '@salesforce/label/c.File_has_Null_Retailer_Iventory';
import FileHasNullPlanForNextMonth from '@salesforce/label/c.File_has_Null_Plan_For_Next_Month';
import SalesOrgCodeMismatched from '@salesforce/label/c.Sales_Org_Code_Mismatched';
import YearMismatched from '@salesforce/label/c.Year_Mismatched';
import MonthMismatched from '@salesforce/label/c.Month_Mismatched';
import DistributorCodeMismatched from '@salesforce/label/c.Distributor_Code_Mismatched'; 
import SKUCodeMismatched from '@salesforce/label/c.SKU_Code_Mismatched'; 
import InvalidOrDecimalNumberFound from '@salesforce/label/c.Invalid_Or_Decimal_Number_Found_In_Distributor';
import InvalidOrDecimalNumberFoundInRetailers from '@salesforce/label/c.Invalid_Or_Decimal_Number_Found_In_Retailers';
import InvalidPlanForNextMonth from '@salesforce/label/c.Invalid_Or_Decimal_Number_Found_In_Plan_For_Next_Month'; 
import NumberofColumnsMismatchedCSV from '@salesforce/label/c.Number_of_Columns_Mismatched_in_CSV_File';
import SuccessT from '@salesforce/label/c.Success';
import UploadedSuccessfully from '@salesforce/label/c.File_uploaded_successfully';
import NoDataFound from '@salesforce/label/c.No_Data_Found_For_Uploading';
import FailToUpload from '@salesforce/label/c.File_Upload_Failed';
import RequestFailed from '@salesforce/label/c.Request_Failed';
import UnexpectedError from '@salesforce/label/c.ERROR_REQUEST_FAILED_NO_ERROR';
import MustBeCSV from '@salesforce/label/c.File_to_be_uploaded_must_be_in_CSV_format';
import ColumnSequense from '@salesforce/label/c.Please_follow_the_same_column_sequence_and_column_names_as_given_in_template';
import DecimalNotAllowed from '@salesforce/label/c.Decimal_Values_Are_Not_Allowed_In_The_File';
import DownloadTemplate from '@salesforce/label/c.Download_Template';
import Close from '@salesforce/label/c.Close';
import UploadLiquidation from '@salesforce/label/c.Upload_Liquidations';
import SalesDistrict from '@salesforce/label/c.Sales_District';
import Distributor from '@salesforce/label/c.Distributor';
import SalesOrgCode from '@salesforce/label/c.Sales_Org_Code';
import Year from '@salesforce/label/c.Year';
import Month from '@salesforce/label/c.Month';
import Attachment from '@salesforce/label/c.Attachments';
import Pleaseuploadfile from '@salesforce/label/c.Please_upload_file';
import Upload from '@salesforce/label/c.Upload';
import Instructions from '@salesforce/label/c.Instructions';
import Cancel from '@salesforce/label/c.Cancel';
import PleaseWait from '@salesforce/label/c.Please_wait';
import DuplicateSKU from '@salesforce/label/c.Duplicate_SKU_Found';
import MonthAsStandardAbbreviation from '@salesforce/label/c.Enter_the_Month_in_file_as_a_standard_abbreviation';
import DoNotIncludeEmptyRows from '@salesforce/label/c.Do_not_include_empty_rows_between_the_first_and_last_rows_of_data';
import DuplicateEntriesNotAllowed from '@salesforce/label/c.Duplicate_entries_are_not_allowed';
import CommunityResource from '@salesforce/resourceUrl/CommunityLiquidationUploadTemplate';
import Quarter from '@salesforce/label/c.Quarter';
import CsvUploadErrorMsg from '@salesforce/label/c.Grz_CsvUploadErrorMsg';	
import PartialUploadSuccessful from '@salesforce/label/c.PartialUploadSuccessful';
export default class LiquidationUpload extends LightningElement {
    @track isModalOpen = false;
    @track fileName = '';
    @track hideUpload = true;
    @api salesDistId = '';
    @track salesDistName = '';
    @api distributorId = '';
    @track distributorName = '';
    @track distributorCode = '';
    @api salesOrgCode = '';
    @track error = '';
    //@api salesOrgId = '';
    @api year = '';
    @api month = '';
    @track liquiMap = new Map();
    @track liquiList = {};
    @track showSpinner = false;
    @track liquiData = [];
    @track Dis_Code = []; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    @track Sku_Code = []; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    @track csv = '';
    @track liquiDataOut = [];
    @track combiKeyList = new Map();
    @track disableUpload = false;
    @track templateLink = '';
    @track flag = true;
    @track inputFiles = '';
    @track isCommunity = false;
    @track isPoland=false;
    @track partialRecords=false;
    @api communityTemplate = CommunityResource+'/Liquidation Upload Template Community.csv';
    @track Quarter1 = 'I kwartał kwiecień-czerwiec';
    @track Quarter2 = 'II kwartał lipiec-wrzesień';
    @track Quarter3 = 'III kwartał październik-grudzień';
    @track Quarter4 = 'IV kwartał styczeń-marzec';
    @track csvList = [];  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
@api quarter='';
@track polish_quarter_val='';
    label = {
        ErrorT,
        SuccessT,
        LiquidationRecordNotFound,
        ErrorReadingFile,
        FileNotReadable,
        SelectFile,
        FileHasNullSalesOrgCode,
        FileHasNullYearValue,
        FileHasNullMonthValue,
        FileHasNullDistributorCode,
        FileHasNullSKUCode,
        FileHasNullDistributorIventory,
        FileHasNullRetailerIventory,
        FileHasNullPlanForNextMonth,
        SalesOrgCodeMismatched,
        YearMismatched,
        MonthMismatched,
        DistributorCodeMismatched,
        SKUCodeMismatched,
        InvalidOrDecimalNumberFound,
        InvalidOrDecimalNumberFoundInRetailers,
        InvalidPlanForNextMonth,
        NumberofColumnsMismatchedCSV,
        UploadedSuccessfully,
        NoDataFound,
        FailToUpload,
        RequestFailed,
        UnexpectedError,
        MustBeCSV,
        ColumnSequense,
        DecimalNotAllowed,
        DownloadTemplate,
        Close,
        UploadLiquidation,
        SalesDistrict,
        Distributor,
        SalesOrgCode,
        Year,
        Month,
        Attachment,
        Pleaseuploadfile,
        Upload,
        Instructions,
        Cancel,
        PleaseWait,
        DuplicateSKU,
        MonthAsStandardAbbreviation,
        DoNotIncludeEmptyRows,
        DuplicateEntriesNotAllowed,
        Quarter,
        CsvUploadErrorMsg
    };

    connectedCallback(){
        console.log('aashima in liquidation upload this.salesDistId',this.salesDistId);
console.log('aashima in liquidation upload this.distributorId',this.distributorId);
console.log('aashima in liquidation upload this.salesOrgCode',this.salesOrgCode);
console.log('aashima in liquidation upload this.year',this.year);
console.log('aashima in liquidation upload this.quarter',this.quarter);
console.log('aashima in liquidation upload this.month',this.month);
        console.log('ConnectedCallBack Liquidation upload');
        if(this.salesDistId=='poland'){
            this.isPoland=true;
            if(this.quarter=='Quarter 1'){
                this.polish_quarter_val = this.Quarter1;
            }
            else if(this.quarter=='Quarter 2'){
                this.polish_quarter_val = this.Quarter2;
            }
            else if(this.quarter=='Quarter 3'){
                this.polish_quarter_val = this.Quarter3;
            }
            else if(this.quarter=='Quarter 4'){
                this.polish_quarter_val = this.Quarter4;
            }
            console.log('this.polish_quarter_val==>'+this.polish_quarter_val);
        }
            // this.baseUrl = window.location.origin;
             this.showSpinner = true;
        /* getTemplateToDownload({fileName : 'Liquidation_Upload_Template'}) // Dont try to chnage filename ever....
            .then(result => { 
                if(result.length>0){
                    this.templateLink = '/servlet/servlet.FileDownload?file='+result;
                }
                else{
                    this.templateLink ='';
                }
            })
            .catch(error => {
                console.log('js method catch');
                console.log(error);
                this.error = error;          
                //this.showToastmessage(ErrorT,error.body.message,'error');
                this.showSpinner = false;
            })

        getSalesDistrictName({distId : this.salesDistId}) 
            .then(result => { 
                if(result.length>0){
                    this.salesDistName = result;
                }
                else{
                    this.salesDistName = '';
                }
            })
            .catch(error => {
                console.log('js method catch');
                console.log(error);
                this.error = error;          
                //this.showToastmessage(ErrorT,error.body.message,'error');
                this.showSpinner = false;
            }) */

        getLiquidationDetails({distId : this.salesDistId}) 
        .then(result => { 
            console.log('getLiquidationDetails result -> ', result);
           
            if(result){
                if(result.salesDistName.length > 0){
                    this.salesDistName = result.salesDistName;
                }
                if(result.reportId.length > 0){
                    if(result.isCommunity == true){
                        let baseUrl = window.location.origin;
                        //console.log('baseUrl -> ', baseUrl);
                        if(baseUrl.includes("uat-upl") || baseUrl.includes("uat")){  // for UAT...
                            this.templateLink = 'https://uat-uplltd.cs117.force.com/MaterialRequisition/resource/1641189478000/LiquidationTemplateCommunity';
                        }
                        else if(baseUrl.includes("upl.my.salesforce") || baseUrl.includes("upl.lightning.force")){  // for Production..
                            this.templateLink = 'https://uplltd.secure.force.com/MaterialRequisition/resource/1641190625000/LiquidationTemplateCommunity';
                        }
                        else if(baseUrl.includes("hotfix")){  // for hotfix..
                            this.templateLink = 'https://hotfix-uplltd.cs72.force.com/MaterialRequisition/resource/1641191370000/LiquidationTemplateCommunity';
                        }
                    }
                    else{
                        if(this.salesDistId=='poland'){
                            this.templateLink = '/servlet/servlet.FileDownload?file='+result.reportId;
                        }else{
                            this.templateLink = '/servlet/servlet.FileDownload?file='+this.communityTemplate;
                        }
                        
                    }
                   
                }
                this.isCommunity = result.isCommunity;
                
            }
            else{
                this.salesDistName = '';
                this.templateLink = '';
            }
        })
        .catch(error => {
            console.log('getLiquidationDetails js method catch');
            console.log(error);
            this.error = error;          
            //this.showToastmessage(ErrorT,error.body.message,'error');
            this.showSpinner = false;
        })    
        this.isModalOpen = true;
        this.showSpinner = false;
    }

    liquidatioRecords(combiKeyList){
        this.showSpinner = true;
        let data = JSON.stringify(combiKeyList);
        let obj = {};
        let obj2 ={};
        this.liquiDataOut = [];
        getLiquidationRecords({sales_Dist : this.salesDistId, combi_key : data, month : this.month, year : this.year, quarter : this.quarter})
        .then(result => {
            console.log('result is - ' , JSON.stringify(result));
            if(result.length > 0){
                this.liquiList = result;
                              
                for(let liq of this.liquiList){
                    this.Sku_Code.push(liq.SKU__r.SKU_Code__c); /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
                    this.Dis_Code.push(liq.Distributor__r.SAP_Code__c); /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
					let key='';
					if(this.isPoland){
						key = liq.SKU__r.SKU_Code__c+liq.Distributor__r.SAP_Code__c+this.year+this.quarter;
					}
					else{
                    key = liq.SKU__r.SKU_Code__c+liq.Distributor__r.SAP_Code__c+this.year+this.month;
					}
                    if(!this.liquiMap.has(key)){
                        this.liquiMap.set(key,liq);
                    }
                } 

                if(this.liquiMap.size > 0 && this.combiKeyList.size > 0){
                    let myMap = new Map(this.liquiMap);
                    let outData = [];
                    let commu = this.isCommunity;
                    let yr = this.year;
                    this.combiKeyList.forEach(function(value2, key2) {
                        obj2 = {};
                        obj2 = myMap.get(key2);
                        console.log('obj2 - ', JSON.stringify(obj2));
                        if(obj2 != undefined){
                            obj = {};
                            obj.id = obj2.Id;
                            obj.distInv = value2.distInv;
                            obj.retailInv = value2.retailInv;
                            obj.planNxtMnth = value2.planNxtMnth;
                            obj.editAccess = obj2.Edit_Access__c;
                            if(obj2.Quarter__c!=''){
                                obj.editAccess = false;
                            }
                            
                            obj.community = commu;
                            obj.year = yr;
                            obj.month = obj2.Month__c;
							obj.quarter = obj2.Quarter__c;
                            obj.distbtrCode = obj2.Distributor__r.SAP_Code__c;
                            obj.skuCode = obj2.SKU__r.SKU_Code__c;
                            outData.push(obj);
                            console.log('obj2.Edit_Access__c - ' + obj2.Edit_Access__c + ' --*-- '+ commu);
                        } 
                    })
console.log('outData==>',outData.length);
console.log('this.combiKeyList.size==>',this.combiKeyList.size);
                    if(outData.length > 0 && this.flag ==true){
                        this.liquidationUpdate(outData,this.isPoland);
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

    

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
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
        //this.showSpinner = true;
        this.liquiDataOut = [];
        this.combiKeyList = new Map();
        this.inputFiles = this.template.querySelector("lightning-input[data-my-id=file_id]");
        //console.log('inputFiles.files - ', this.inputFiles.files);
        if (this.inputFiles.files != null) {
            let fileExtension = '';
            let file = this.inputFiles.files[0];
            //this.fileName = event.target.files[0].name;
            fileExtension = this.inputFiles.files[0].name.split('.').pop();
            console.log('File size .. - ', file.size);
            console.log('fileExtension==> inside'+fileExtension);
            if(fileExtension == 'csv' || fileExtension == 'CSV') { 
                console.log('fileExtension==> inside'+fileExtension);
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
       // this.showSpinner = true;
        //console.log('CSV length .. - ', csv.length);
        //console.log('CSV data .. - ', csv);
        if(csv != null){
            this.disableUpload = true;
            let arr = [];
            this.flag = true;
            let obj = {};
            let obj2 ={};
            let key ='';
            let distInv = 0;
            let retInv = 0;
            let plnNxtMnt = 0;
            let skuMap = new Map();
            let distCode = '';
            let skuCode = '';
            let combList = [];
            arr = csv.split('\n');
            if(this.isPoland) {
            if(arr[0]=='Year,Quarter,Distributor Code,SKU Code,Distributors Inventory,Plan for the next quarter\r'){
                console.log('correct order');
            }
            else{
                console.log('incorrect order');
                return this.showToastmessage(ErrorT,CsvUploadErrorMsg,'error');                            
            }
            }
           // console.log('@@@ arr file contains - ', csv);
            arr.pop();
            
            //console.log('@@@ arr file pop contains -', arr);
            // console.log('@@@ csv file contains'+ csv);
            for(let i = 1; i < arr.length; i++) {
             /* arr.forEach(element => {
                 
             }); */   
                distInv = 0;
                retInv = 0;
                plnNxtMnt = 0;
                key = '';
                distCode = '';
                skuCode = '';

                let re =/,(?=(?:(?:[^"]*"){2})*[^"]*$)/g;				// /,(?=(?:(?:[^"]*"){2})*[^"]*$)/; 
                let data = [].map.call(arr[i].split(re), function(el) {
                    return el.replace(/^"|"$/g, '');
                 }
                );
                //console.log('@@@ this.isCommunity -', this.isCommunity);
                //console.log('@@@ data.length -', data.length);
                if(!this.isPoland){
                    if((data.length == 7 && this.isCommunity == false) || (data.length == 5 && this.isCommunity == true)){
                    
                        for(let j = 0; j < data.length; j++) {
                            let val = data[j].trim();
                            
                            if(val.length == 0){
                                if(j == 0 && val.length == 0){
                                    this.flag = false;
                                   // this.showSpinner = false;
                                    this.showToastmessage(ErrorT,FileHasNullYearValue,'error');
                                }
                                else if(j == 1 && val.length == 0){
                                    this.flag = false;
                                   // this.showSpinner = false;
                                    this.showToastmessage(ErrorT,FileHasNullMonthValue,'error');
                                }
                                else if(j == 2 && val.length == 0){
                                    this.flag = false;
                                   // this.showSpinner = false;
                                    this.showToastmessage(ErrorT,FileHasNullDistributorCode,'error');
                                }
                                else if(j == 3 && val.length == 0){
                                    this.flag = false;
                                   // this.showSpinner = false;
                                    this.showToastmessage(ErrorT,FileHasNullSKUCode,'error');
                                }
                                else if(j == 4 && val.length == 0){
                                    this.flag = false;
                                   // this.showSpinner = false;
                                    this.showToastmessage(ErrorT,FileHasNullDistributorIventory,'error');
                                }
                                else if(j == 5 && val.length == 0){
                                    this.flag = false;
                                   // this.showSpinner = false;
                                    this.showToastmessage(ErrorT,FileHasNullRetailerIventory,'error');
                                }
                                else if(j == 6 && val.length == 0){
                                    this.flag = false;
                                    //this.showSpinner = false;                                
                                    this.showToastmessage(ErrorT,FileHasNullPlanForNextMonth,'error');
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
                                    if(val != this.month){
                                        this.flag = false;
                                        //this.showSpinner = false;
                                        this.showToastmessage(ErrorT,MonthMismatched,'error');
                                    }
                                }
                                else if(j == 2){
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
                                    /* if(val != this.distributorCode){
                                        this.flag = false;
                                        this.showSpinner = false;
                                        this.showToastmessage(ErrorT,DistributorCodeMismatched,'error');
                                    } */
                                }
                                else if(j == 3){
                                    
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
                                    key = skuCode+distCode+this.year+this.month;    // salesOrg+liq.Distributor__r.SAP_Code__c+liq.SKU__r.SKU_Code__c+year+month 
                                    
                                   // console.log('Key is - ', key);
                                   // console.log('liquiMap is - ', this.liquiMap.keys());
                                    
    
                                    /* if(!this.liquiMap.has(key)){
                                        this.flag = false;
                                        this.showSpinner = false;
                                        this.showToastmessage(ErrorT,SKUCodeMismatched,'error');
                                    }
                                    else if(skuMap.has(val)){
                                        this.flag = false;
                                        this.showSpinner = false;
                                        this.showToastmessage(ErrorT,DuplicateSKU,'error');
                                        
                                    }
                                    else{
                                        skuMap.set(val,val);
                                    } */
                                    
                                }
                                else if(j == 4){
                                    //console.log('Distributor Inventory Column - ', val);
                                    //console.log('Distributor Inventory  - ', (val% 1 !== 0));
                                    if(val % 1 !== 0){
                                        //this.showSpinner = false;
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,InvalidOrDecimalNumberFound,'error');
                                    }
                                    else{
                                        distInv = val;
                                    }
                                }
                                else if(j == 5){
                                    if(val % 1 !== 0){
                                        //this.showSpinner = false;
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,InvalidOrDecimalNumberFoundInRetailers,'error');
                                    }
                                    else{
                                        retInv = val;
                                    }
                                }
                                else if(j == 6){
                                    if(val % 1 !== 0){
                                        //this.showSpinner = false;
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,InvalidPlanForNextMonth,'error');
                                    }
                                    else{
                                        plnNxtMnt = val;
                                        
                                    }
                                }
                            }
    
                            if(this.flag == false){
                               // this.showSpinner = false;
                                break;
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
                        //this.combiKeyList.push(key);
                        let obj3 = {};
                        //console.log('combiKeyList 1st - ', this.combiKeyList);
                        if(this.combiKeyList.has(key)){
                            this.flag = false;
                            this.showSpinner = false;
                            this.showToastmessage(ErrorT,DuplicateEntriesNotAllowed,'error');
                            break;
                        }
                        else{
                            obj3.combKey = key;
                            obj3.distInv = distInv;
                            obj3.retailInv = retInv;
                            obj3.planNxtMnth = plnNxtMnt;
                            this.combiKeyList.set(key,obj3);
                        }
                        //console.log('combiKeyList 2nd - ', this.combiKeyList);
                        /* obj2 = {};
                        obj2 = this.liquiMap.get(key);
                        console.log('obj2 - ', obj2);
                        if(obj2 != undefined){
                            obj = {};
                            obj.id = obj2.Id;
                            obj.distInv = distInv;
                            obj.retailInv = retInv;
                            obj.planNxtMnth = plnNxtMnt;
    
                            this.liquiDataOut.push(obj);
                        } */
                        
                    }
                    else{
                        break;
                    }
                }
                else{
                    if(data.length == 6 && this.isCommunity == false){
                    
                        for(let j = 0; j < data.length; j++) {
                            let val = data[j].trim();
                            
                            if(val.length == 0){
                                if(j == 0 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullYearValue,'error');
                                }
                                else if(j == 1 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullMonthValue,'error');
                                }
                                else if(j == 2 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullDistributorCode,'error');
                                }
                                else if(j == 3 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullSKUCode,'error');
                                }
                                else if(j == 4 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullDistributorIventory,'error');
                                }
                                else if(j == 5 && val.length == 0){
                                    this.flag = false;
                                    this.showToastmessage(ErrorT,FileHasNullPlanForNextMonth,'error');
                                }
                            }
                            else{
                                if(j == 0){
                                    if(val != this.year){
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,YearMismatched,'error');
                                    }
                                }
                                else if(j == 1){
                                    if(val != this.quarter){
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,MonthMismatched,'error');
                                    }
                                }
                                else if(j == 2){
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
                                else if(j == 3){
                                    
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
                                    key = skuCode+distCode+this.year+this.quarter;    // salesOrg+liq.Distributor__r.SAP_Code__c+liq.SKU__r.SKU_Code__c+year+quarter 
                                    
                                  
                                    
                                }
                                else if(j == 4){
                                    if(val % 1 !== 0){
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,InvalidOrDecimalNumberFound,'error');
                                    }
                                    else{
                                        distInv = val;
                                    }
                                }
                                else if(j == 5){
                                    if(val % 1 !== 0){
                                        this.flag = false;
                                        this.showToastmessage(ErrorT,InvalidPlanForNextMonth,'error');
                                    }
                                    else{
                                        plnNxtMnt = val;
                                        
                                    }
                                }
                            }
    
                            if(this.flag == false){
                                break;
                            }
                            
                        }
                        
                    }
                    else{
                        this.showToastmessage(ErrorT,NumberofColumnsMismatchedCSV,'error');
                        this.flag = false;
                       
                        break;
                    }
    
                    if(this.flag == true){
                         /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
                        let csvObj = {};
                        csvObj.year = this.year;
                        csvObj.distbtrCode = distCode;
                        csvObj.skuCode = skuCode;
                        csvObj.planNxtMnth = plnNxtMnt;
                        csvObj.retailInv = retInv;
                        csvObj.distInv = distInv;
                        csvObj.quarter = this.quarter;
                        console.log('csvObj',csvObj)
                        this.csvList.push(csvObj);
                        /* -- */
                        console.log('flag - ', this.flag);
                        let obj3 = {};
                        if(this.combiKeyList.has(key)){
                           let o=this.combiKeyList.get(key);
                           obj3.combKey=key;
                           obj3.distInv=parseInt(o.distInv)+parseInt(distInv);
                           obj3.planNxtMnth=parseInt(o.planNxtMnth)+parseInt(plnNxtMnt);
                           this.combiKeyList.set(key,obj3);
                        }
                        else{
                            obj3.combKey = key;
                            obj3.distInv = distInv;
                            obj3.planNxtMnth = plnNxtMnt;
                            this.combiKeyList.set(key,obj3);
                        }
                       
                    }
                    else{
                        break;
                    }
                    console.log('this.combiKeyList==>',this.combiKeyList);
                }
                
            }
            this.clearSelectedFile();
            //console.log('liquiDataOut - ', this.liquiDataOut.length);
            /* if(this.liquiDataOut.length > 0 && this.flag ==true){
                this.disableUpload = true;
                this.liquidationUpdate(this.liquiDataOut);
            } */
            if(this.combiKeyList.size > 0 && this.flag ==true){
                this.disableUpload = true;
                for (let key5 of this.combiKeyList.keys()) {
                    combList.push(key5);
                }
               
                console.log('combList - ', combList);
                this.liquidatioRecords(combList);
            }
            //console.log('combiKeyList - ', this.combiKeyList);
        }
        
        //this.showSpinner = false;
    }

    liquidationUpdate(liqData,isPoland){
        this.showSpinner = true;
        let data = JSON.stringify(liqData);
        updateLiquidation({liquiData : data,isPoland:isPoland,dupList : JSON.stringify(this.csvList), Sku_Code : this.Sku_Code, Dis_Code : this.Dis_Code})  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
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
            console.log('liquidationUpdate js method catch');
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

    //this.template.querySelector("lightning-input[data-my-id=file_id]").value = "";
}