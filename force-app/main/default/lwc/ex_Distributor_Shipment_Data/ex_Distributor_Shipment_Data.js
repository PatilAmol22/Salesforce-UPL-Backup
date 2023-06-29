import { LightningElement, track, wire } from 'lwc';
import Distributor_Shipment_Data from '@salesforce/label/c.Ex_Distributor_Shipment_Data';
import Distributor_Area from '@salesforce/label/c.Distributor_Area';
import Chemical_Ipm from '@salesforce/label/c.Chemical_Ipm';
import Sales_Office_for_Ex_Distributor_Customer from '@salesforce/label/c.Sales_Office_for_Ex_Distributor_Customer';
import Area_In_Ex_Distributors_Customer from '@salesforce/label/c.Area_In_Ex_Distributors_Customer';
import Sales_Office_Area_in_Distributor_Customer from '@salesforce/label/c.Sales_Office_Area_in_Distributor_Customer';
import UPL_FY from '@salesforce/label/c.UPL_FY';
import Calendar_Year from '@salesforce/label/c.Calendar_Year';
import Month_In_Calendar_Year from '@salesforce/label/c.Month_In_Calendar_Year';
import Distributor from '@salesforce/label/c.Distributor';
import Distributors_Office from '@salesforce/label/c.Distributors_Office';
import Region_In_Ex_Distributors_Customer from '@salesforce/label/c.Region_In_Ex_Distributors_Customer';
import Area_Or_District_In_Ex_Distributors_Customer from '@salesforce/label/c.Area_Or_District_In_Ex_Distributors_Customer';
import Customer_Category from '@salesforce/label/c.Customer_Category';
import Ja_Area_Name from '@salesforce/label/c.Ja_Area_Name';
import Material_Name from '@salesforce/label/c.Material_Name';
import Single_Package_Size from '@salesforce/label/c.Single_Package_Size';
import Volume_Single_Bottle_or_Bag from '@salesforce/label/c.Volume_Single_Bottle_or_Bag';
import Pesticidal_Year_From_Oct_To_Sep from '@salesforce/label/c.Pesticidal_Year_From_Oct_To_Sep';
import Price_Per_Single_Bottle_Bag from '@salesforce/label/c.Price_Per_Single_Bottle_Bag';
import Amount_Jpy_Standard_Price_Base from '@salesforce/label/c.Amount_Jpy_Standard_Price_Base';
import Order_Type from '@salesforce/label/c.Order_Type';
import Material_Code from '@salesforce/label/c.Material_Code';
import Customer_Address from '@salesforce/label/c.Customer_Address';
import Ipm_New from '@salesforce/label/c.Ipm_New';
import Single_Bottle_Bag_Number_In_Case from '@salesforce/label/c.Single_Bottle_Bag_Number_In_Case';
import Distributor_Name from '@salesforce/label/c.Distributor_Name';
import Distributor_Code from '@salesforce/label/c.Distributor_Code';
import Page_size from '@salesforce/label/c.Page_size';
import Page from '@salesforce/label/c.Page';
import First from '@salesforce/label/c.First';
import Previous from '@salesforce/label/c.Previous';
import Next from '@salesforce/label/c.Next';
import Last from '@salesforce/label/c.Last';
import Select_Page_Size from '@salesforce/label/c.Select_Page_Size';
import Select_Month from '@salesforce/label/c.Select_Month';
import Select_Year from '@salesforce/label/c.Select_Year';
import Distributors_Customer_Name from '@salesforce/label/c.Distributors_Customer_Name';   
import Selected_Records from '@salesforce/label/c.Selected_Records';
import Delete_Selected_Records from '@salesforce/label/c.Delete_Selected_Records';
import Success from '@salesforce/label/c.Success';
import Records_deleted from '@salesforce/label/c.Records_deleted';
import UOM from '@salesforce/label/c.UOM';

import getTotalRecCount from '@salesforce/apex/DistributorShipmentDataController.getTotalRecCount';
import getDistributorShipmentData from '@salesforce/apex/DistributorShipmentDataController.getDistributorShipmentData';
import getFiscalYearList from '@salesforce/apex/DistributorShipmentDataController.getFiscalYearList';
import getMonthList from '@salesforce/apex/DistributorShipmentDataController.getMonthList';
import fetchDataHelper from './fetchDataHelper';
import delSelectedRecs from '@salesforce/apex/DistributorShipmentDataController.deleteRecords';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import UPL_FY__c from '@salesforce/schema/Ex_Distributor_Shipment_Data__c.UPL_FY__c';

/*const columns = [
    { label: 'Distributor Area', fieldName: 'Distributor_Area_Name__c', type:'text', sortable: true },
    { label: 'Chemical/Ipm', fieldName: 'Chemical_IPM__c', type: 'text', sortable: true },
    { label: 'Sales Office For Ex-Distributor Customer', fieldName: 'Sales_Office_of_Ex_Distributor__c', type: 'text', sortable: true },
    { label: 'Area In Ex-Distributors Customer', fieldName: 'Area_Name__c', type: 'text', sortable: true },
    { label: 'Sales Office Area in Distributor Customer', fieldName: 'Sales_Office_Name__c', type: 'text', sortable: true },
    { label: 'Upl Fy', fieldName: 'UPL_FY__c', type:'text', sortable: true },
    { label: 'Calendar Year', fieldName: 'Calendar_Year__c', type:'text', sortable: true },
    { label: 'Month (In Calendar Year)', fieldName: 'Month__c', type:'text', sortable: true },
    { label: 'Distributor', fieldName: 'Distributor_Name__c', type:'text', sortable: true },
    { label: 'Distributors Office', fieldName: 'Distributor_Office_Name__c', type:'text', sortable: true },
    { label: 'Region In Ex-Distributors Customer', fieldName: 'Region_in_Ex_Distributor_s_Customer__c', type:'text', sortable: true },
    { label: 'Area Or District In Ex-Distributors Customer', fieldName: 'District_in_Ex_Distributor_s_Customer__c', type:'text' },
    { label: 'Customer Category', fieldName: 'Customer_Category__c', type:'text', sortable: true },
    { label: 'Ja Area Name', fieldName: 'JA_Area_Name__c', type:'text', sortable: true },
    { label: 'Material Name', fieldName: 'Material_Name__c', type:'text', sortable: true },
    { label: 'Single Package Size', fieldName: 'Single_Pack_Size__c', type:'text', sortable: true },
    { label: 'Volume (Single Bottle Or Bag)', fieldName: 'Volume__c', type:'number', sortable: true},
    { label: 'Pesticidal Year (From Oct To Sep)', fieldName: 'Pesticidal_Year__c', type:'text', sortable: true },
    { label: 'Price Per Single Bottle/Bag', fieldName: 'Price_per_single_bottle_bag__c', type:'currency', sortable: true },
    { label: 'Amount Jpy (Standard Price Base)', fieldName: 'Amount_JPY__c', type:'currency', sortable: true },
    { label: 'Order Type', fieldName: 'Order_Type__c', type:'text', sortable: true },
    { label: 'Material Code', fieldName: 'Material_Code__c', type:'text', sortable: true },
    { label: 'Customer Address', fieldName: 'Customer_Address__c', type:'text', sortable: true },
    { label: 'Ipm New', fieldName: 'IPM_NEW__c', type:'text', sortable: true  },
    { label: 'Single Bottle/Bag Number In Case', fieldName: 'Single_bottle_bag_number_in_Case__c', type:'text', sortable: true  },
];*/

export default class Ex_Distributor_Shipment_Data extends LightningElement {

    @track Data;
    @track pagesize;
    @track pageNumber = 1;
    @track offSet = 0;
    @track currentpage;
    @track totalpages;
    @track totalrecords;
    @track noRecordsFound = false;
    @track showData = false;
    @track searchKeyCode;
    @track searchKeyMaterialCode;
    @track searchKeyMaterialName;
    @track searchKeyName;
    @track searchKeyMonth='';
    @track searchKeyYear='';
    @track sortBy;
    @track flag=false;
    @track FiscalYearData=[];
    @track MonthData=[];
    @track offset=0;
    //@track monthValue;
    //@track yearValue;
    @track isTrue = true;
    @track recordsCount = 0;
    @track Upl_Fy_Options='';
    @track showDelButton=true;
    // non-reactive variables
    selectedRecords = [];
    refreshTable;
    error;
    
    @track labels = {
        Distributor_Shipment_Data : Distributor_Shipment_Data,
        Distributor_Area : Distributor_Area,
        Chemical_Ipm : Chemical_Ipm,
        Sales_Office_for_Ex_Distributor_Customer : Sales_Office_for_Ex_Distributor_Customer,
        Area_In_Ex_Distributors_Customer : Area_In_Ex_Distributors_Customer,
        Sales_Office_Area_in_Distributor_Customer : Sales_Office_Area_in_Distributor_Customer,
        UPL_FY : UPL_FY,
        Calendar_Year : Calendar_Year,
        Month_In_Calendar_Year : Month_In_Calendar_Year,
        Distributor : Distributor,
        Distributors_Office : Distributors_Office,
        Region_In_Ex_Distributors_Customer : Region_In_Ex_Distributors_Customer,
        Area_Or_District_In_Ex_Distributors_Customer : Area_Or_District_In_Ex_Distributors_Customer,
        Customer_Category : Customer_Category,
        Ja_Area_Name : Ja_Area_Name,
        Material_Name : Material_Name,
        Single_Package_Size : Single_Package_Size,
        Volume_Single_Bottle_or_Bag : Volume_Single_Bottle_or_Bag,
        Pesticidal_Year_From_Oct_To_Sep : Pesticidal_Year_From_Oct_To_Sep,
        Price_Per_Single_Bottle_Bag : Price_Per_Single_Bottle_Bag,
        Amount_Jpy_Standard_Price_Base : Amount_Jpy_Standard_Price_Base,
        Order_Type : Order_Type,
        Material_Code : Material_Code,
        Customer_Address : Customer_Address,
        Ipm_New : Ipm_New,
        Single_Bottle_Bag_Number_In_Case : Single_Bottle_Bag_Number_In_Case,
        Distributor_Name : Distributor_Name,
        Distributor_Code : Distributor_Code,
        Page_size:Page_size,
        Page:Page,
        First:First,
        Previous:Previous,
        Next:Next,
        Last:Last,
        Select_Page_Size:Select_Page_Size,
        Select_Month:Select_Month,
        Select_Year:Select_Year,
        Distributors_Customer_Name : Distributors_Customer_Name,
        Selected_Records : Selected_Records,
        Delete_Selected_Records : Delete_Selected_Records,
        Success : Success,
        Records_deleted : Records_deleted,
        UOM : UOM
    }
    @track buttonLabel = this.labels.Delete_Selected_Records ;
    
    @track columns = [
        { label:  this.labels.Distributor_Area, fieldName: 'Distributor_Area_Name__c', type:'text', sortable: true },
        { label:  this.labels.Chemical_Ipm, fieldName: 'Chemical_IPM__c', type: 'text', sortable: true },
        { label:  this.labels.Sales_Office_for_Ex_Distributor_Customer, fieldName: 'Sales_Office_of_Ex_Distributor__c', type: 'text', sortable: true },//check
        { label:  this.labels.Area_In_Ex_Distributors_Customer, fieldName: 'Area_Name__c', type: 'text', sortable: true },
        { label:  this.labels.Sales_Office_Area_in_Distributor_Customer, fieldName: 'Sales_Office_Area_in_Distributor_Text__c', type: 'text', sortable: true },
        { label:  this.labels.UPL_FY, fieldName: 'UPL_FY__c', type:'text', sortable: true },
        { label:  this.labels.Calendar_Year, fieldName: 'Calendar_Year__c', type:'text', sortable: true },
        { label:  this.labels.Month_In_Calendar_Year, fieldName: 'Month_Value__c', type:'text', sortable: true },
        { label:  this.labels.Distributor, fieldName: 'Distributor_Name__c', type:'text', sortable: true },
        { label:  this.labels.Distributor_Code, fieldName: 'Distributor_Code__c', type:'text', sortable: true },
        { label:  this.labels.Distributors_Customer_Name, fieldName: 'Customer_Name__c', type:'text', sortable: true },
        { label:  this.labels.Distributors_Office, fieldName: 'Distributor_s_Office_Text__c', type:'text', sortable: true },
        { label:  this.labels.Region_In_Ex_Distributors_Customer, fieldName: 'Region_in_Ex_Distributor_s_Customer__c', type:'text', sortable: true },
        { label:  this.labels.Area_Or_District_In_Ex_Distributors_Customer, fieldName: 'District_in_Ex_Distributor_s_Customer__c', type:'text' },
        { label:  this.labels.Customer_Category, fieldName: 'Customer_Category__c', type:'text', sortable: true },
        { label:  this.labels.Ja_Area_Name, fieldName: 'JA_Area_Name__c', type:'text', sortable: true },
        { label:  this.labels.Material_Name, fieldName: 'Material_Name__c', type:'text', sortable: true },
        //{ label:  this.labels.Single_Package_Size, fieldName: 'Single_Pack_Size__c', type:'text', sortable: true },
        { label:  this.labels.Volume_Single_Bottle_or_Bag, fieldName: 'Volume__c', type:'number', sortable: true},
        { label:  this.labels.Pesticidal_Year_From_Oct_To_Sep, fieldName: 'Pesticidal_Year__c', type:'text', sortable: true },
        { label:  this.labels.Price_Per_Single_Bottle_Bag, fieldName: 'Price_per_single_bottle_bag__c', type:'currency', sortable: true },
        { label:  this.labels.Amount_Jpy_Standard_Price_Base, fieldName: 'Amount_JPY__c', type:'currency', sortable: true },
        { label:  this.labels.Order_Type, fieldName: 'Order_Type__c', type:'text', sortable: true },
        { label:  this.labels.Material_Code, fieldName: 'Material_Code__c', type:'text', sortable: true },
        { label:  this.labels.Customer_Address, fieldName: 'Customer_Address__c', type:'text', sortable: true },
        //{ label:  this.labels.Ipm_New, fieldName: 'IPM_NEW__c', type:'text', sortable: true  },
        { label:  this.labels.Single_Bottle_Bag_Number_In_Case, fieldName: 'Single_bottle_bag_number_in_Case__c', type:'text', sortable: true  },
        { label:  this.labels.UOM, fieldName: 'Unit_Of_Measurement__c', type:'text', sortable: true  }
    ];
    connectedCallback() {
        this.value='5';
        this.getTotalCountRecords();
    }

    handleKeyUp(evt) {
        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            this.queryTerm = evt.target.value;
        }
    }

    get options3() {
        return [
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '50', value: '50' },
            { label: '100', value: '100' },
            { label: '150', value: '150' },
            { label: '200', value: '200' },
        ];
    }

     
    get months()                                                 //column options
    {   
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
         //return this.MonthData;
    } 
    /*@wire(getMonthList)        // for retriveing Month
    wiredMonthDataList({data})
    {
        this.MonthData=data;
        //console.log('Month--->',data);
    }*/
    @wire(getPicklistValues, { recordTypeId : '012000000000000AAA',fieldApiName : UPL_FY__c})
    wirePicklistFiscalYearValues({data,error}){
        if(data){
            let noneOption = {label:'なし',value:''};
            //console.log(` Picklist values are `, data.values);
            data.values.forEach(element => {
                this.Upl_Fy_Options = [...this.Upl_Fy_Options,{label:element.value,value:element.value}]
            });
            this.Upl_Fy_Options.unshift(noneOption);
        }
        if(error){
            //console.log(` Error while fetching Picklist values  ${error}`);
            this.Upl_Fy_Options = undefined;
        }
    }

    /*get FiscalYear()                                                 //column options
    {  
           return this.FiscalYearData;
    } 
    @wire(getFiscalYearList)        // for retriveing calender year
    wiredFiscalYearList({data})
    {
        this.FiscalYearData=data;
        //console.log('UPL Fiscal year--->',data);
    }*/

    getTotalCountRecords(){
        
        //console.log('this.searchKeyYear --> ' + this.searchKeyYear);
        getTotalRecCount({
                searchKeyName: this.searchKeyName,
                searchKeyCode: this.searchKeyCode,
                searchKeyMaterialCode: this.searchKeyMaterialCode,
                searchKeyMaterialName: this.searchKeyMaterialName,
                searchKeyYear: this.searchKeyYear,
                searchKeyMonth: this.searchKeyMonth
        }).then(result => {
            //console.log('*---getTotalRecCount--->'+result);
            this.totalrecords = result;
            //console.log('--> getTotalRecCount --> ',this.totalrecords);
            this.currentpage = 1;
            this.offset = 0;
            this.pagesize = this.value;
            this.totalpages = 1;
            this.totalpages = Math.ceil(parseInt(this.totalrecords,10) / parseInt(this.pagesize,10));
            //console.log('total totalrecords--->',this.totalrecords);
            //console.log('total pages--->',this.totalpages);
            //console.log('total pagesize--->',this.pagesize);
            if(this.totalrecords===0){
                this.pageNumber=0;
            }
            this.getData(this.pageNumber,this.offset);
           
        });
    }

    getData(pageNumber,offSet) {
        //console.log('--> getData --> ');
        this.pagesize = this.value;
        //console.log('pagesize --> ' + this.pagesize);
        //console.log('pageNumber --> ' + pageNumber);
        //console.log('this.searchKeyYear --> ' + this.searchKeyYear);
        //console.log('this.offSet --> ' + offSet);
        this.flag=true;
        getDistributorShipmentData({                                              //fetching data from class
                pageNumber: pageNumber,
                pageSize: this.pagesize,
                searchKeyName: this.searchKeyName,
                searchKeyCode: this.searchKeyCode,
                searchKeyMaterialCode: this.searchKeyMaterialCode,
                searchKeyMaterialName: this.searchKeyMaterialName,
                searchKeyYear: this.searchKeyYear,
                searchKeyMonth: this.searchKeyMonth,
                pageoffSet: offSet
            })
            .then(result => {
                //console.log('Data Result -->  ' , result);
                //this.refreshTable = result;
                if (result) {
                    this.Data = result;
                    //console.log("this.Data.length-->",this.Data.length);
                    console.log("this.Data-->",this.Data);
                    console.log('MOnth vl-->',result[0].IPM_NEW__c);
                    //console.log('MOnth vl-->',result[0].Month_Value__c);

                    /*if(this.Data.length !== 0)
                        {
                               this.noRecordsFound = false;
                               this.showData=true;
                              //console.log('this.showData-->',this.showData );
                       }
                       if(this.Data.length===0){     
                        this.Data = undefined;
                        //console.log('Data is undefined');
                        this.noRecordsFound = true;
                        this.showData=false;
                       }*/
                       this.flag=false;
                }
            })
            .catch(error => {
                this.error = error;
                this.flag=false;
                //console.log('this.error -->  ' + JSON.stringify(this.error));
            });
    }

    handleFirst(event) {
        // this.flag = true;
        // console.log('Flag Value first-->',this.flag);
        this.pageNumber = 1;
        this.offset=0;
        //console.log('first page offset-->',this.offset);
        this.getTotalCountRecords();
        this.getData(this.pageNumber,this.offset);
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
    }
    handleLast(event) {
        // this.flag = true;
        // console.log('Flag Value last-->',this.flag);
        this.pageNumber = this.totalpages;
        //Updated by Varun Shrivastava start : 1 April 2021 SCTASK0429583
        //this.offset = this.totalrecords-this.offset;
        this.offset = this.totalrecords-parseInt(this.pagesize);
        //Updated by Varun Shrivastava End : 1 April 2021 SCTASK0429583
        //console.log('last page offset-->',this.offset);
        //console.log('total pages--->',this.pageNumber);
        this.getTotalCountRecords();
        this.getData(this.pageNumber,this.offset);
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
        
    }
    handleNext(event) {
        // this.flag = true;
        // console.log('Flag Value next-->',this.flag);
        this.pageNumber = this.pageNumber + 1;
        this.offset = parseInt(this.offset)+parseInt(this.pagesize);
        //console.log('next page offset-->',this.offset);
        this.getTotalCountRecords();
        this.getData(this.pageNumber,this.offset);
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
    }
    handlePrevious(event) {
        // this.flag = true;
        // console.log('Flag Value prev-->',this.flag);
        this.pageNumber = this.pageNumber - 1;
        this.offset = parseInt(this.offset)-parseInt(this.pagesize);
        //console.log('previous page offset-->',this.offset);
        this.getTotalCountRecords();
        this.getData(this.pageNumber,this.offset);
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
    }
    get showFirstButton() {
        if (this.pageNumber == 1 || this.pageNumber == 0) {
            return true;
        }
            return false;
    }
    // getter  
    get showLastButton() {
       if(this.totalrecords===undefined){
        this.totalrecords = 0;
       }
        //console.log('pageSize --> ' + this.pagesize);
        //console.log('pageNumber --> ' + this.pageNumber);
        
        if (Math.ceil(this.totalrecords / this.pagesize) === this.pageNumber) {
            //console.log('totalrecords showLastButton--> ' + this.totalrecords);
            return true;
        }
        return false;
    }

    handleSearchKeyDistributorName(event) { 
        // this.flag = true;
        // console.log('Flag Value name-->',this.flag);
        const searchKey = event.target.value;
        this.searchKeyName = searchKey;
        //console.log("search Key--->>"+this.searchKey);
        this.getTotalCountRecords();
        this.offset = 0;
        this.getData(this.pageNumber,this.offset); 
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300); 
    }

    handleSearchKeyDistributorCode(event) { 
        // this.flag = true;
        // console.log('Flag Value code-->',this.flag);
        const searchKey = event.target.value;
        this.searchKeyCode = searchKey;
        //console.log("search Key--->>"+this.searchKey);
        this.getTotalCountRecords();
        this.offset = 0;
        this.getData(this.pageNumber,this.offset);
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);  
    }

    handleSearchKeyMaterialCode(event) { 
        // this.flag = true;
        // console.log('Flag Value code-->',this.flag);
        const searchMKey = event.target.value;
        this.searchKeyMaterialCode = searchMKey;
        //console.log("search Key--->>"+this.searchKey);
        this.getTotalCountRecords();
        this.offset = 0;
        this.getData(this.pageNumber,this.offset);
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);  
    }

    handleSearchKeyMaterialName(event) { 
        // this.flag = true;
        // console.log('Flag Value code-->',this.flag);
        const searchMName = event.target.value;
        this.searchKeyMaterialName = searchMName;
        //console.log("search Key--->>"+this.searchKey);
        this.getTotalCountRecords();
        this.offset = 0;
        this.getData(this.pageNumber,this.offset);
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);  
    }

    handleSearchKeyYear(event) { 
        // this.flag = true;
        // console.log('Flag Value year-->',this.flag);
        //this.searchKeyMonth = ''; 
        //this.monthValue='';
       // console.log("searchKeyMonth--->>"+this.searchKeyMonth);
        //const searchKey = event.target.value;
        this.searchKeyYear = event.target.value;
        //console.log("searchKeyYear--->>"+searchKey);
        //console.log("searchKeyYear--->>"+this.searchKeyYear);
        this.getTotalCountRecords();
        this.offset=0;
        this.getData(this.pageNumber,this.offset);
        this.pageNumber=1; 
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300); 
    }

    handleSearchKeyMonth(event) {
        // this.flag = true;
        // console.log('Flag Value month-->',this.flag);
        //this.searchKeyYear = '';
        //this.yearValue='';
        //console.log("searchKeyYear--->>"+this.searchKeyYear); 
        //const searchKey = event.target.value;
        this.searchKeyMonth = event.target.value;
        //console.log("searchKeyMonth--->>"+searchKey);
        //console.log("searchKeyMonth--->>"+this.searchKeyMonth);
        this.getTotalCountRecords();
        this.offset=0;
        this.getData(this.pageNumber,this.offset);
        this.pageNumber=1;
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);    
    }

    /*handleClearYear()
    {
        this.searchKeyMonth = ""; 
    }
    handleClearMonth()
    {
        this.searchKeyYear = ""; 
    }*/

    handleComboBox(event)
    {   
        // this.flag = true;
        // console.log('Flag Value page-->',this.flag);
        this.pageNumber=1;
        this.value=event.detail.value;
        this.pagesize = this.value;
        this.totalpages = Math.ceil(parseInt(this.totalrecords,10) / parseInt(this.pagesize,10));
        this.getTotalCountRecords();
        this.getData(this.pageNumber);
        this.pageNumber=1;
        // setTimeout(() => {
        //     this.flag = false;
        // }, 500);
    }

    handleSortdata(event) {
        
        this.sortBy = event.detail.fieldName;
        //console.log(this.sortBy);
        this.sortDirection = event.detail.sortDirection;
        //console.log(this.sortDirection);
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }
    sortData(fieldname, direction) {

        let parseData = JSON.parse(JSON.stringify(this.Data));
        //console.log(parseData);
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.Data = parseData;
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
        this.flag=true;
        delSelectedRecs({lstIds: this.selectedRecords})
        .then(result => {
            //window.console.log('result ====> ' + result);

            this.buttonLabel = this.labels.Delete_Selected_Records;
            this.isTrue = false;
            this.flag=false;
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
            this.isTrue = true;
            // refreshing table data using refresh apex
            return this.connectedCallback();

        })
        .catch(error => {
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while getting Records', 
                    message: error.message, 
                    variant: 'error'
                }),
            );
        });
    } 

}