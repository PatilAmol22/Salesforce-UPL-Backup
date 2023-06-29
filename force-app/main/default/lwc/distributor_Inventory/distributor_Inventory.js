import { LightningElement,track, wire,api } from 'lwc';
import Distributor_Inventory_lbl from '@salesforce/label/c.Distributor_Inventory';
import Distributor_Name from '@salesforce/label/c.Distributor_Name';
import Distributor_Code from '@salesforce/label/c.Distributor_Code';
import Material_Name from '@salesforce/label/c.Material_Name';//Sayan RITM0212196
import Material_Code from '@salesforce/label/c.Material_Code';//Sayan RITM0212196
import Office_Code from '@salesforce/label/c.Office_Code';
import Fiscal_Year from '@salesforce/label/c.Fiscal_Year';
import Month from '@salesforce/label/c.Month';
import Distributor from '@salesforce/label/c.Distributor';
import Distributors_Office from '@salesforce/label/c.Distributors_Office';
import Region from '@salesforce/label/c.Region';
import Area from '@salesforce/label/c.Area';
import Material from '@salesforce/label/c.Material';
import Single_Pack_Size from '@salesforce/label/c.Single_Pack_Size';
import Single_Pack_Number from '@salesforce/label/c.Single_Pack_Number';
import Pesticidal_Year from '@salesforce/label/c.Pesticidal_Year';
import Page_size from '@salesforce/label/c.Page_size';
import Page from '@salesforce/label/c.Page';
import First from '@salesforce/label/c.First';
import Previous from '@salesforce/label/c.Previous';
import Next from '@salesforce/label/c.Next';
import Last from '@salesforce/label/c.Last';
import Selected_Records from '@salesforce/label/c.Selected_Records';
import Delete_Selected_Records from '@salesforce/label/c.Delete_Selected_Records';
import Success from '@salesforce/label/c.Success';
import Records_deleted from '@salesforce/label/c.Records_deleted';  
import Price_Per_Single_Bottle from '@salesforce/label/c.Price_Per_Single_Bottle';
import Amount_JPY from '@salesforce/label/c.Amount_JPY';
import Single_Bottle_In_Case from '@salesforce/label/c.Single_Bottle_In_Case';
import Calendar_Year from '@salesforce/label/c.Calendar_Year';
import Number_In_Case from '@salesforce/label/c.Number_In_Case';
import Area_Name from '@salesforce/label/c.Area_Name';

import onfilter from '@salesforce/apex/GetDistributorInventoryRecords.onfilter';
import getTotalRecordcount from '@salesforce/apex/GetDistributorInventoryRecords.getTotalRecordcount';
import getLastRecord from '@salesforce/apex/GetDistributorInventoryRecords.getLastRecord';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import FISCAL_YEAR from '@salesforce/schema/Distributor_Inventory__c.Fiscal_Year__c';
import delSelectedRecs from '@salesforce/apex/GetDistributorInventoryRecords.deleteRecords';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';


export default class Distributor_Inventory extends LightningElement {
    @track page = 1;
    @track distributor_inventory_data = [];
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track pageSize = '5';
    @track endingRecord = 0;
    @track startingRecord  = 0;
    @track items = [];
    @track nextbtn_disable = true;
    @track previousbtn_disable = true;
    @track firstbtn_disable = true;
    @track lastbtn_disable = true;
    @track latest_sequence = 1;
    @track pervious_sequence = 1;
    @track di_name;
    @track di_material_name;//Sayan RITM0212196
    @track di_material_code;//Sayan RITM0212196
    @track di_code;
    @track is_loading = false;
    @track last_record_sequence = 0;
    @track sortBy='DistributorName';
    @track sortDirection='asc';
    @track di_month='';
    @track di_fiscal_year='';
    @track di_fiscal_yearOptions='';
    @track di_name_value;
    @track di_material_name_value;//Sayan RITM0212196
    @track di_material_code_value;//Sayan RITM0212196
    @track di_code_value;

    
    @track isTrue = true;
    @track recordsCount = 0;
    // non-reactive variables
    selectedRecords = [];
    refreshTable;
    error;
    
    //columns = columns;

    @wire(getPicklistValues, { recordTypeId : '012000000000000AAA',fieldApiName : FISCAL_YEAR})
    wirePicklistFiscalYearValues({data,error}){
        if(data){
            let noneOption = {label:'なし',value:''};
            //console.log(` Picklist values are `, data.values); removed console logs after RITM0212196
            data.values.forEach(element => {
                this.di_fiscal_yearOptions = [...this.di_fiscal_yearOptions,{label:element.value,value:element.value}]
            });
            this.di_fiscal_yearOptions.unshift(noneOption);
        }
        if(error){
            //console.log(` Error while fetching Picklist values  ${error}`); removed console logs after RITM0212196
            this.di_fiscal_yearOptions = undefined;
        }
    }

    @track labels = {
        Distributor_Inventory_lbl : Distributor_Inventory_lbl,
        Distributor_Name : Distributor_Name,
        Distributor_Code : Distributor_Code,
        Material_Name : Material_Name,//Sayan RITM0212196
        Material_Code : Material_Code,//Sayan RITM0212196
        Office_Code :Office_Code,
        Fiscal_Year :Fiscal_Year,
        Month :Month,
        Distributor :Distributor,
        Distributors_Office :Distributors_Office,
        Region :Region,
        Area :Area,
        Material :Material ,
        Single_Pack_Size :Single_Pack_Size,
        Single_Pack_Number :Single_Pack_Number,
        Pesticidal_Year :Pesticidal_Year,
        Page_size:Page_size,
        Page:Page,
        First:First,
        Previous:Previous,
        Next:Next,
        Last:Last,
        Selected_Records : Selected_Records,
        Delete_Selected_Records : Delete_Selected_Records,
        Success : Success,
        Records_deleted : Records_deleted,
        Single_Bottle_In_Case : Single_Bottle_In_Case,
        Amount_JPY : Amount_JPY,
        Price_Per_Single_Bottle : Price_Per_Single_Bottle,
		Calendar_Year : Calendar_Year,
		Number_In_Case: Number_In_Case,
        Area_Name: Area_Name

    }
    @track buttonLabel = this.labels.Delete_Selected_Records;
    @track columns = [
        { label: this.labels.Office_Code, fieldName: 'OfficeName', type:'text' },
        { label: this.labels.Fiscal_Year, fieldName: 'Fiscal_Year__c', type: 'text' },
        { label: this.labels.Month, fieldName: 'Month_value__c', type: 'text' },
        { label: this.labels.Distributor, fieldName: 'DistributorName', type: 'text',sortable:true },
        { label: this.labels.Distributor_Code, fieldName: 'DistributorCode', type: 'text' },//Sayan RITM0212196
        { label: this.labels.Distributors_Office, fieldName: 'Distributors_Office__c', type: 'text' },
        { label: this.labels.Area_Name, fieldName: 'Region__c', type:'text' },
        { label: this.labels.Area, fieldName: 'AreaName', type:'text' },
        { label: this.labels.Material, fieldName: 'MaterialName', type:'text' },
        { label: this.labels.Material_Code, fieldName: 'MaterialCode', type: 'text' },//Sayan RITM0212196
        { label: this.labels.Single_Pack_Size, fieldName: 'Single_Pack_SizeName', type:'text' },
        { label: this.labels.Single_Pack_Number, fieldName: 'Single_pack_number__c', type:'text' },
        { label: this.labels.Pesticidal_Year, fieldName: 'Pesticidal_Year__c', type:'text' },
        { label: this.labels.Price_Per_Single_Bottle, fieldName: 'Price_Per_Single_Bottle__c', type:'text' },
        { label: this.labels.Amount_JPY, fieldName: 'Amount_JPY__c', type:'text' },
        { label: this.labels.Single_Bottle_In_Case, fieldName: 'Single_Bottle_In_Case__c', type:'text' },
        { label: this.labels.Calendar_Year, fieldName: 'Calendar_Year__c', type:'text' },
		{ label: this.labels.Region, fieldName: 'Japan_Region__c', type:'text' },
		{ label: this.labels.Number_In_Case, fieldName: 'Number_in_case__c', type:'text' }
    ];

    handleDistributorName(e) {
        this.di_code_value = '';
        this.di_code = '';
        this.di_material_code_value = '';
        this.di_material_code = '';
            //console.log('handleDistributorName ',e.target.value.length +'pagesize',this.pageSize); removed console logs after RITM0212196
            if(e.target.value.length>=3 || e.target.value.length ==0){
                this.di_name_value = e.target.value?e.target.value:'';
                //this.di_name = e.target.value?e.target.value+'%':'';
                this.di_name = e.target.value?e.target.value:'';
                this.getRecordOnAction(this.pageSize,0,'>');
                this.page = 1;
            }
    }
    
    handleDistributorCode(e) {
        this.di_name = '';
        this.di_name_value = '';
        this.di_material_name_value = '';
        this.di_material_name = '';
        //console.log('handleDistributorCode ',e.target.value.length); removed console logs after RITM0212196
        if(e.target.value.length>=3 || e.target.value.length==0){
            this.di_code_value = e.target.value?e.target.value:'';
            //this.di_code = e.target.value?e.target.value+'%':'';
            this.di_code = e.target.value?e.target.value:'';
            this.getRecordOnAction(this.pageSize,0,'>');
            this.page = 1;
        }
    }

    //Sayan added for RITM0212196
    handleMaterialName(e) {
        this.di_material_code_value = '';
        this.di_material_code = '';
        this.di_code_value = '';
        this.di_code = '';
            //console.log('handleMaterialName ',e.target.value.length +'pagesize',this.pageSize); removed console logs after RITM0212196
            if(e.target.value.length>=3 || e.target.value.length ==0){
                this.di_material_name_value = e.target.value?e.target.value:'';
                this.di_material_name = e.target.value?e.target.value:'';
                this.getRecordOnAction(this.pageSize,0,'>');
                this.page = 1;
            }
    }

    handleMaterialCode(e) {
        this.di_material_name_value = '';
        this.di_material_name = '';
        this.di_name = '';
        this.di_name_value = '';
            //console.log('handleMaterialCode ',e.target.value.length +'pagesize',this.pageSize); removed console logs after RITM0212196
            if(e.target.value.length>=3 || e.target.value.length ==0){
                this.di_material_code_value = e.target.value?e.target.value:'';
                this.di_material_code = e.target.value?e.target.value:'';
                this.getRecordOnAction(this.pageSize,0,'>');
                this.page = 1;
            }
    }
    //RITM0212196


    get page_size_Option() {
        return [
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '50', value: '50' },
            { label: '100', value: '100' },
            { label: '150', value: '150' },
            { label: '200', value: '200' },
        ];
    }

    get monthOption(){
        return [
            { label:"なし",  value:""},
            { label:"1月",  value:"1月"},
            { label:"2月",  value:"2月"},
            { label:"3月",  value:"3月"},
            { label:"4月",  value:"4月"},
            { label:"5月",  value:"5月"},
            { label:"6月",  value:"6月"},
            { label:"7月",  value:"7月"},
            { label:"8月",  value:"8月"},
            { label:"9月",  value:"9月"},
            { label:"10月",  value:"10月"},
            { label:"11月",  value:"11月"},
            { label:"12月",  value:"12月"}
        ]
    }

    // get fiscalYearOption(){
    // return [
    //     { label:"None",  value:""},
    //     { label:"2019",  value:"2019"},
    //     { label:"2020",  value:"2020"}
    // ]
    // }

    handleChangeMonthOption(event){
        this.di_month = event.detail.value;
        this.getRecordOnAction(this.pageSize,0,'>');
        this.page = 1;
    }

    handleChangeFiscalYearOption(event){
        this.di_fiscal_year = event.detail.value;
        this.getRecordOnAction(this.pageSize,0,'>');
        this.page = 1;
    }

    handleChangePageSize(event){
        this.pageSize = event.detail.value;
        //console.log('Page size '+this.pageSize+' total page ',this.totalPage+' page '+this.page); removed console logs after RITM0212196
        this.getRecordOnAction(this.pageSize,0,'>');
        if(this.page==1){
            this.getRecordOnAction(this.pageSize,0,'>');
        }
        if(this.page<this.totalPage){
            this.getRecordOnAction(this.pageSize,0,'>');
        }
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
        if(this.page>this.totalPage){
            this.page = 1;
            this.getRecordOnAction(this.pageSize,0,'>');
            //this.displayRecordPerPage(this.page);
        }
        this.page = 1;
    }

    updateColumnSorting(event){
        let fieldName = event.detail.fieldName;
        let sortDirection = event.detail.sortDirection;
        this.sortBy = fieldName;
        this.sortDirection = sortDirection;
        this.sortData(fieldName, sortDirection)
      }

      sortData(fieldName, sortDirection) {
        let sortResult = Object.assign([], this.items);
        this.items = sortResult.sort(function(a,b){
          if(a[fieldName] < b[fieldName])
            return sortDirection === 'asc' ? parseInt("-1") : 1;
          else if(a[fieldName] > b[fieldName])
            return sortDirection === 'asc' ? 1 : parseInt("-1");
          else
            return 0;
        });
    }
      

    connectedCallback() {
        this.getRecordOnAction(this.pageSize,0,'>');
        getLastRecord().then(rec=>{
            this.last_record_sequence = rec;
            //console.log('last rec '+this.last_record_sequence); removed console logs after RITM0212196
        }).catch(err=>{
            console.log('last rec err '+this.last_record_sequence);
        })
    }
    
    getRecordOnAction(page_size,last_rec,operator){
        this.is_loading = true;
        //console.log(`d_name :${this.di_name}, d_code :${this.di_code},di_material_name :${this.di_material_name},di_material_code :${this.di_material_code}, d_month :${this.di_month}, d_year :${this.di_year}, str_limit :${page_size}, last_record :${last_rec}, op :${operator}`); removed console logs after RITM0212196
        onfilter({d_name:this.di_name,d_code:this.di_code,di_material_name:this.di_material_name,di_material_code:this.di_material_code,d_month:this.di_month,d_year:this.di_fiscal_year,str_limit:page_size,last_record:last_rec,op:operator}).then(temp=>{
            //console.log('Data-->',temp); removed console logs after RITM0212196
            let data = [];
            temp.forEach(element => {
                data.push({
                    "AreaName":element.Area__r.Name,
                    "DistributorName":element.Distributor__r.Name,
                    "DistributorCode":element.Distributor__r.SAP_Code__c,//Sayan RITM0212196
                    "Distributors_Office__c":element.Distributors_Office__c,
                    "Fiscal_Year__c":element.Fiscal_Year__c,
                    "Id":element.Id,
                    "MaterialName":element.Material__r.SKU_Description__c,
                    "MaterialCode":element.Material__r.SKU_Code__c,//Sayan RITM0212196
                    "Month_value__c":element.Month_value__c,
                    "OfficeName":element.Office__r.Name,
                    "Pagination_Formula__c":element.Pagination_Formula__c,
                    "Pesticidal_Year__c":element.Pesticidal_Year__c,
                    "Region__c":element.Region__c,
                    "Single_Pack_SizeName":element.Single_Pack_Size__c,
                    "Single_pack_number__c":element.Single_pack_number__c,
                    "Price_Per_Single_Bottle__c":element.Price_Per_Single_Bottle__c,
                    "Amount_JPY__c":element.Amount_JPY__c,
                    "Single_Bottle_In_Case__c":element.Single_Bottle_In_Case__c,
                    "Calendar_Year__c":element.Calendar_Year__c,
                    "Japan_Region__c":element.Japan_Region__c,
                    "Number_in_case__c":element.Number_in_case__c

                 })
            });


            this.distributor_inventory_data = data;
            this.latest_sequence = data.length!==0 ? parseInt(data[data.length -1].Pagination_Formula__c):1;    
            this.pervious_sequence = data.length!==0 ? parseInt(data[0].Pagination_Formula__c):1;
            //console.log('first rec',this.pervious_sequence +' last record '+this.latest_sequence); removed console logs after RITM0212196
            if(this.latest_sequence<this.pervious_sequence){
                this.distributor_inventory_data = data.reverse();
                let temp = this.pervious_sequence;
                this.pervious_sequence = this.latest_sequence;
                this.latest_sequence = temp;
            }
            //console.log('latest seq',this.latest_sequence); removed console logs after RITM0212196
            
            getTotalRecordcount({d_name:this.di_name,d_code:this.di_code,di_material_name:this.di_material_name,di_material_code:this.di_material_code,d_month:this.di_month,d_year:this.di_fiscal_year}).then(total=>{
                //total = '20';
            //console.log('tottal ',total); removed console logs after RITM0212196
            this.totalRecountCount = parseInt(total);
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

            this.items = this.distributor_inventory_data.slice(0,this.pageSize);
            //console.log('this.distributor_inventory_data ',this.distributor_inventory_data); removed console logs after RITM0212196
            this.endingRecord = this.pageSize;
            this.is_loading = false;
            if(this.totalRecountCount==0){
                this.page = 0;
            }
        })
        }).catch(err=>{
            console.log(err);
            this.is_loading = false;
        });
    }

    renderedCallback(){
        //console.log('previous sequence->'+this.pervious_sequence); removed console logs after RITM0212196
        this.checkNextPreviousbtn(this.page,this.totalPage);
    }

    firstPage(){
        //console.log('first page'); removed console logs after RITM0212196
        this.page = 1;
        //this.displayRecordPerPage(this.page,this.pageSize);
        this.getRecordOnAction(this.pageSize,0,'>');
    }
      
    lastPage(){
        //console.log('Last page'); removed console logs after RITM0212196
        this.page = this.totalPage;
        //console.log('last rec--> sign desc',this.pageSize,parseInt(this.last_record_sequence)); removed console logs after RITM0212196
        // this.getRecordOnAction(this.pageSize,parseInt(this.last_record_sequence) - parseInt(this.pageSize) > 0 ?parseInt(this.last_record_sequence) - parseInt(this.pageSize):1,'>');
        this.getRecordOnAction(this.pageSize,parseInt(this.last_record_sequence)+1,'<');
        //this.displayRecordPerPage(this.page,this.pageSize);
    }

    previousPage(){
        //console.log('Previous page'); removed console logs after RITM0212196
        if(this.page>1){
            this.page = this.page - 1;
            //this.displayRecordPerPage(this.page);
            
            if(this.page==1){
                this.getRecordOnAction(this.pageSize,0,'>');
                this.checkNextPreviousbtn(this.page,this.totalPage);
            }else{
                this.getRecordOnAction(this.pageSize,this.pervious_sequence,'<');
            this.checkNextPreviousbtn(this.page,this.totalPage);
            }
        }
    }
    nextPage(){
        //console.log('Next page'); removed console logs after RITM0212196
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; 
            //this.displayRecordPerPage(this.page); 
            this.getRecordOnAction(this.pageSize,this.latest_sequence,'>');
            this.checkNextPreviousbtn(this.page,this.totalPage);           
        } 
    }
      
    displayRecordPerPage(page){
        //console.log('Starting record '+this.startingRecord+' Ending record '+this.endingRecord); removed console logs after RITM0212196
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
        this.items = this.distributor_inventory_data.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }

    checkNextPreviousbtn(page,totalpage){
        if(totalpage>=page+1){
          this.nextbtn_disable = false;
        }else{
          this.nextbtn_disable = true;
        }
        if(page>1){
          this.previousbtn_disable = false;
        }else{
          this.previousbtn_disable = true;
        }
      
        if(page==1||page==0){
            this.firstbtn_disable = true;
        }else{
          this.firstbtn_disable = false;
        }
      
        if(page==totalpage){
          this.lastbtn_disable = true;
        }else{
          this.lastbtn_disable = false;
        }
      }

       /*Delete Selected Rows*/


    // Getting selected rows 
    getSelectedRecords(event) {
        // getting selected rows
        const selectedRows = event.detail.selectedRows;
        
        this.recordsCount = event.detail.selectedRows.length;
        //console.log('selected Rows-->',this.recordsCount);
        if(this.recordsCount > 0){
            this.isTrue=false;
        }else{
            this.isTrue=true;
        }
        // this set elements the duplicates if any
        let recIds = new Set();

        // getting selected record id
        for (let i = 0; i < selectedRows.length; i++) {
            recIds.add(selectedRows[i].Id);
        }

        // coverting to array
        this.selectedRecords = Array.from(recIds);

        //window.console.log('selectedRecords ====> ' +this.selectedRecords);
    }

    // delete records process function
    deleteAccounts() {
        if (this.selectedRecords) {
            // setting values to reactive variables
            this.buttonLabel = 'Processing....';
            this.isTrue = true;

            // calling apex class to delete selected records.
            this.deleteRecs();
        }
    }


    deleteRecs() {
        this.is_loading=true;
        delSelectedRecs({lstIds: this.selectedRecords})
        .then(result => {
            //window.console.log('result ====> ' + result);

            this.buttonLabel = this.labels.Delete_Selected_Records;
            this.isTrue = false;
            this.is_loading=false;
            // showing success message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: this.labels.Success, 
                    message: this.recordsCount +' '+this.labels.Records_deleted, 
                    variant: 'success'
                }),
            );
            
            // Clearing selected row indexs 
            this.template.querySelector('lightning-datatable').selectedRows = [];

            this.recordsCount = 0;
            this.isTrue=true;
            // refreshing table data using refresh apex
            return this.connectedCallback();

        })
        .catch(error => {
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while getting Contacts', 
                    message: error.message, 
                    variant: 'error'
                }),
            );
        });
    }
}