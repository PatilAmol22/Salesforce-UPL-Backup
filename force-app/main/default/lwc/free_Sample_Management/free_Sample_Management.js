import { LightningElement,track } from 'lwc';
import fetchDataHelper from './fetchDataHelper';
import Page_size from '@salesforce/label/c.Page_size';
import Page from '@salesforce/label/c.Page';
import First from '@salesforce/label/c.First';
import Previous from '@salesforce/label/c.Previous';
import Next from '@salesforce/label/c.Next';
import Last from '@salesforce/label/c.Last';

import Trial_No from '@salesforce/label/c.Trial_No';
import Report_Stored_In_Folder from '@salesforce/label/c.Report_Stored_In_Folder';
import Report_Accepted from '@salesforce/label/c.Report_Accepted';
import Control_Plot from '@salesforce/label/c.Control_Plot';
import Comparison_To_Standard from '@salesforce/label/c.Comparison_To_Standard';
import Comparison_To_control from '@salesforce/label/c.Comparison_To_control';
import Farmers_Impression from '@salesforce/label/c.Farmers_Impression';
import Possibility_of_Market_Penetration from '@salesforce/label/c.Possibility_of_Market_Penetration';
import Other_Comments from '@salesforce/label/c.Other_Comments';
import Application_Date_for_Trail from '@salesforce/label/c.Application_Date_for_Trail';
import Applicant from '@salesforce/label/c.Applicant';
import Sales_Office from '@salesforce/label/c.Sales_Office';
import Trial_Conducted_Region from '@salesforce/label/c.Trial_Conducted_Region';
import Area from '@salesforce/label/c.Area';
import Ja_Name from '@salesforce/label/c.Ja_Name';
import Crop from '@salesforce/label/c.Crop';
import Priority from '@salesforce/label/c.Priority';
import Market_Acreage_Ha from '@salesforce/label/c.Market_Acreage_Ha';
import Mpv_M from '@salesforce/label/c.Mpv_M';
import Farmers_Name from '@salesforce/label/c.Farmer_Name';
import Acreage_For_Trail_Are from '@salesforce/label/c.Acreage_For_Trail_Are';
import Purpose_To_Use from '@salesforce/label/c.Purpose_To_Use';
import Product_Category from '@salesforce/label/c.Product_Category';
import Product_Provided_For_Trail from '@salesforce/label/c.Product_Provided_For_Trail';
import SKU from '@salesforce/label/c.SKU';
import Volume from '@salesforce/label/c.Volume';
import Delivery_Date_Requested from '@salesforce/label/c.Delivery_Date_Requested';
import Shipping_Address from '@salesforce/label/c.Shipping_Address';
import Phone_Number from '@salesforce/label/c.Phone_Number';
import Place_To_Receive_Sample from '@salesforce/label/c.Place_To_Receive_Sample';
import Representative_To_Receive_Sample from '@salesforce/label/c.Representative_To_Receive_Sample';
import Responsible_Person_For_Trail from '@salesforce/label/c.Responsible_Person_For_Trail';
import Nets_For_Greenhouse from '@salesforce/label/c.Nets_For_Greenhouse';
import Sticky_Plate from '@salesforce/label/c.Sticky_Plate';
import Others from '@salesforce/label/c.Others';
import Product_name from '@salesforce/label/c.Product_Name';
import Product_code from '@salesforce/label/c.Product_Code';
import free_sample_management from '@salesforce/label/c.Free_Sample_Management';
import Need_AM_arrival from '@salesforce/label/c.Need_AM_arrival';
import Arrangement_confirmed from '@salesforce/label/c.Arrangement_confirmed';
import Arrangement_Date from '@salesforce/label/c.Arrangement_Date';
import Assessment_of_effect from '@salesforce/label/c.Assessment_of_effect';
import Case_Conversion from '@salesforce/label/c.Case_Conversion';
import Cost from '@salesforce/label/c.Cost';
import Delivery_Date from '@salesforce/label/c.Delivery_Date';
import Information_about_cultivation from '@salesforce/label/c.Information_about_cultivation';
import Planned_Timing from '@salesforce/label/c.Planned_Timing';
import Process_Timing from '@salesforce/label/c.Process_Timing';
import Requested_Delivery_Time from '@salesforce/label/c.Requested_Delivery_Time';
import Sample_code from '@salesforce/label/c.Sample_code';
import UOM from '@salesforce/label/c.UOM';


import onfilter from '@salesforce/apex/GetFreesampleManagementRecords.onfilter';
import getTotalRecordcount from '@salesforce/apex/GetFreesampleManagementRecords.getTotalRecordcount';
import getLastRecord from '@salesforce/apex/GetFreesampleManagementRecords.getLastRecord';


export default class Free_Sample_Management extends LightningElement {
    @track page = 1;
    @track free_sample_data = [];
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
    @track fs_name;
    @track fs_code;
    @track is_loading = false;
    @track last_record_sequence = 0;
    @track sortBy='MaterialName';
    @track sortDirection='asc';
    @track fs_name_value = '';
    @track fs_code_value = '';

    @track labels = {
        Page_size:Page_size,
        Page:Page,
        First:First,
        Previous:Previous,
        Next:Next,
        Last:Last,
        free_sample_management:free_sample_management,
        Product_name:Product_name,
        Product_code :Product_code,
        // fields-->

        Trial_No : Trial_No,
        Report_Stored_In_Folder : Report_Stored_In_Folder,
        Report_Accepted : Report_Accepted,
        Control_Plot : Control_Plot,
        Comparison_To_Standard : Comparison_To_Standard,
        Comparison_To_control : Comparison_To_control,
        Farmers_Impression : Farmers_Impression,
        Possibility_of_Market_Penetration : Possibility_of_Market_Penetration,
        Other_Comments : Other_Comments,
        Application_Date_for_Trail : Application_Date_for_Trail,
        Applicant : Applicant,
        Sales_Office : Sales_Office,
        Trial_Conducted_Region : Trial_Conducted_Region,
        Area : Area,
        Ja_Name : Ja_Name,
        Crop : Crop,
        Priority : Priority,
        Market_Acreage_Ha : Market_Acreage_Ha,
        Mpv_M : Mpv_M,
        Farmers_Name : Farmers_Name,
        Acreage_For_Trail_Are : Acreage_For_Trail_Are,
        Purpose_To_Use : Purpose_To_Use,
        Product_Category : Product_Category,
        Product_Provided_For_Trail : Product_Provided_For_Trail,
        SKU : SKU,
        Volume : Volume,
        Delivery_Date_Requested : Delivery_Date_Requested,
        Shipping_Address : Shipping_Address,
        Phone_Number : Phone_Number,
        Place_To_Receive_Sample : Place_To_Receive_Sample,
        Representative_To_Receive_Sample : Representative_To_Receive_Sample,
        Responsible_Person_For_Trail : Responsible_Person_For_Trail,
        Nets_For_Greenhouse : Nets_For_Greenhouse,
        Sticky_Plate : Sticky_Plate,
        Others : Others,
        Need_AM_arrival:Need_AM_arrival,
        Arrangement_confirmed:Arrangement_confirmed,
        Arrangement_Date:Arrangement_Date,
        Assessment_of_effect:Assessment_of_effect,
        Case_Conversion:Case_Conversion,
        Cost:Cost,
        Delivery_Date:Delivery_Date,
        Information_about_cultivation:Information_about_cultivation,
        Planned_Timing:Planned_Timing,
        Process_Timing:Process_Timing,
        Requested_Delivery_Time:Requested_Delivery_Time,
        Sample_code:Sample_code,
        UOM:UOM
    }


    @track columns = [
        { label:  this.labels.Trial_No, fieldName: 'Trial_No', type:'text' },
        { label: this.labels.Report_Stored_In_Folder, fieldName: 'Report_Stored_In_Folder', type: 'text' },
        { label: this.labels.Report_Accepted, fieldName: 'Report_accepted', type: 'text' },
        { label: this.labels.Control_Plot, fieldName: 'Control_Plot', type: 'text' },
        { label: this.labels.Comparison_To_control , fieldName: 'Comparison_To_Control', type: 'text' },
        { label: this.labels.Farmers_Impression, fieldName: 'Farmers_Impression', type:'text' },
        { label: this.labels.Possibility_of_Market_Penetration, fieldName: 'Possibility_Of_Market_Penetration', type:'text' },
        { label: this.labels.Other_Comments, fieldName: 'Other_Comments', type:'text' },
        { label: this.labels.Application_Date_for_Trail, fieldName: 'Application_Date_For_Trial', type:'text' },
        { label: this.labels.Applicant, fieldName: 'Applicant', type:'text' },
        { label: this.labels.Sales_Office, fieldName: 'Sales_Office', type:'text' },
        { label: this.labels.Trial_Conducted_Region, fieldName: 'Trial_Conducted_Region', type:'text' },
        { label: this.labels.Area, fieldName: 'Area', type:'text' },
        { label: this.labels.Ja_Name, fieldName: 'Ja_Name', type:'text' },
        { label: this.labels.Crop, fieldName: 'Crop', type:'text' },
        { label: this.labels.Priority, fieldName: 'Priority', type:'text' },
        { label: this.labels.Market_Acreage_Ha, fieldName: 'Market_Acreage_Ha', type:'text' },
        { label: this.labels.Mpv_M , fieldName: 'Mpv', type:'text' },
        { label: this.labels.Farmers_Name, fieldName: 'Farmers_Name', type:'text' },
        { label: this.labels.Acreage_For_Trail_Are , fieldName: 'Acreage_For_Trial', type:'text' },
        { label: this.labels.Purpose_To_Use, fieldName: 'Purpose_to_Use', type:'text' },
        { label: this.labels.Product_Category, fieldName: 'Product_Category', type:'text' },
        { label: this.labels.Product_Provided_For_Trail, fieldName: 'Product_Provided_For_Trial', type:'text' },
        { label: this.labels.SKU, fieldName: 'SKU', type:'text' },
        { label: this.labels.Volume, fieldName: 'Volume', type:'text' },
        { label: this.labels.UOM, fieldName: 'UOM', type:'text' },
        { label: this.labels.Delivery_Date_Requested, fieldName: 'Delivery_Date_Requested', type:'text' },
        { label: this.labels.Shipping_Address, fieldName: 'Shipping_Address', type:'text' },
        { label: this.labels.Phone_Number, fieldName: 'Phone_Number', type:'text' },
        { label: this.labels.Place_To_Receive_Sample, fieldName: 'Place_To_Receive_Sample', type:'text' },
        { label: this.labels.Representative_To_Receive_Sample, fieldName: 'Representative_To_Receive_Sample', type:'text' },
        { label: this.labels.Responsible_Person_For_Trail, fieldName: 'Responsible_Person_For_Trial', type:'text' },
        { label: this.labels.Nets_For_Greenhouse, fieldName: 'Nets_For_Greenhouse', type:'text' },
        { label: this.labels.Sticky_Plate, fieldName: 'Sticky_Plate', type:'text' },
        { label: this.labels.Others, fieldName: 'Others', type:'text' },

        { label: this.labels.Need_AM_arrival, fieldName: 'Need_AM_arrival__c', type:'text' },
        { label: this.labels.Arrangement_confirmed, fieldName: 'Arrangement_confirmed__c', type:'text' },
        { label: this.labels.Arrangement_Date, fieldName: 'Arrangement_Date__c', type:'text' },
        { label: this.labels.Assessment_of_effect, fieldName: 'Assessment_of_effect__c', type:'text' },
        { label: this.labels.Case_Conversion, fieldName: 'Case_Conversion__c', type:'text' },
        { label: this.labels.Cost, fieldName: 'Cost__c', type:'text' },
        { label: this.labels.Delivery_Date, fieldName: 'Delivery_Date__c', type:'text' },
        { label: this.labels.Information_about_cultivation, fieldName: 'Information_about_cultivation__c', type:'text' },
        { label: this.labels.Planned_Timing, fieldName: 'Planned_Timing__c', type:'text' },
        { label: this.labels.Process_Timing, fieldName: 'Process_Timing__c', type:'text' },
        { label: this.labels.Requested_Delivery_Time, fieldName: 'Requested_Delivery_Time__c', type:'text' },
        { label: this.labels.Sample_code, fieldName: 'Sample_code__c', type:'text' },

    ];
    
  

    handleMaterialName(e) {
        console.log('handleDistributorName ',e.target.value.length +'pagesize',this.pageSize);
        this.fs_code_value = '';
        if(e.target.value.length>=3 || e.target.value.length ==0){
            this.fs_name_value = e.target.value?e.target.value:'';
            this.fs_name = e.target.value?e.target.value+'%':'';
            this.getRecordOnAction(this.pageSize,0,'>');
            this.page = 1;
        }
    }
    
    handleMaterialCode(e) {
        console.log('handleDistributorCode ',e.target.value.length);
        this.fs_name_value = '';
        if(e.target.value.length>=3 || e.target.value.length==0){
        this.fs_code = e.target.value?e.target.value:'';
        this.fs_code = e.target.value?e.target.value+'%':'';
        this.getRecordOnAction(this.pageSize,0,'>');
        this.page = 1;
        }
    }    

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

    handleChangePageSize(event){
        this.pageSize = event.detail.value;
        console.log('Page size '+this.pageSize+' total page ',this.totalPage+' page '+this.page);
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
        getLastRecord().then(rec=>{                  // Edit
            this.last_record_sequence = rec;
            console.log('last rec '+this.last_record_sequence);
        }).catch(err=>{
            console.log('Last rec err ',err);
        })
        //this.last_record_sequence = '20';
    }

    getRecordOnAction(page_size,last_rec,operator){
        this.is_loading = true;
        console.log(`d_name :${this.fs_name}, d_code :${this.fs_code}, str_limit :${page_size}, last_record :${last_rec}, op :${operator}`);
        onfilter({d_name:this.fs_name,d_code:this.fs_code,str_limit:page_size,last_record:last_rec,op:operator}).then(temp=>{
            console.log('free sample data ',temp);
           
            let data = [];
            temp.forEach(element => {
                data.push({
                    "Trial_No"  :element.Name,
                    "Report_Stored_In_Folder" :element.Report_Stored_In_Folder__c,
                    "Report_accepted" :element.Report_accepted__c,
                    "Control_Plot" :element.Control_Plot__c,
                    "Comparison_To_Control" :element.Comparison_to_control__c,
                    "Farmers_Impression" :element.Farmers_Impression__c,
                    "Possibility_Of_Market_Penetration" :element.Possibility_of_market_penetration__c,
                    "Other_Comments" :element.Other_Comments__c,
                    "Application_Date_For_Trial" :element.Application_date_for_trial__c,
                    "Applicant" :'Test ',
                    "Sales_Office" :element.Sales_Office__c!==undefined?element.Sales_Office__r.Name:'',
                    "Trial_Conducted_Region" :'Test ',
                    "Area" :element.Area__c!==undefined?element.Area__r.Name:'',
                    "Ja_Name" :element.JA_Name__c,
                    "Crop" :element.Crop__c,
                    "Priority" :element.Priority__c,
                    "Market_Acreage_Ha" :element.Market_Acrage_ha__c,
                    "Mpv" :element.MPV_M__c,
                    "Farmers_Name" :element.Farmers_Name__c,
                    "Acreage_For_Trial" :element.Acrage_for_Trial_are__c,
                    "Purpose_to_Use" :'Test ',
                    "Product_Category" :element.Product_Category__c,
                    "Product_Provided_For_Trial" :element.Product_provided_for_trial__c!==undefined?element.Product_provided_for_trial__r.Name:'',
                    "SKU" :element.SKU__c,
                    "Volume" :element.Volume__c,
                    "UOM" :element.UOM__c,
                    "Delivery_Date_Requested" :element.Delivery_date_requested__c,
                    "Shipping_Address" :element.Shipping_address__c,
                    "Phone_Number" :element.Phone_number__c,
                    "Place_To_Receive_Sample" :element.Place_to_receive_sample__c,
                    "Representative_To_Receive_Sample" :element.Representative_to_receive_sample__c,
                    "Responsible_Person_For_Trial" :element.Responsible_person_for_trial__c,
                    "Nets_For_Greenhouse" :element.Nets_for_greenhouse__c,
                    "Sticky_Plate" :element.Sticky_plate__c,
                    "Others" :element.Others__c,
                    "Pagination_Formula__c":element.Pagination_Formula__c,
                    "Need_AM_arrival__c": element.Need_AM_arrival__c ,
                    "Arrangement_confirmed__c":element.Arrangement_confirmed__c,
                    "Arrangement_Date__c":element.Arrangement_Date__c,
                    "Assessment_of_effect__c":element.Assessment_of_effect__c,
                    "Case_Conversion__c":element.Case_Conversion__c,
                    "Cost__c":element.Cost__c,
                    "Delivery_Date__c":element.Delivery_Date__c,
                    "Information_about_cultivation__c":element.Information_about_cultivation__c,
                    "Planned_Timing__c":element.Planned_Timing__c,
                    "Process_Timing__c":element.Process_Timing__c,
                    "Requested_Delivery_Time__c":element.Requested_Delivery_Time__c,
                    "Sample_code__c":element.Sample_code__c
                })
                console.log("Delivery_Date__c",element.Delivery_Date__c);
            });


           
            //let data = fetchDataHelper();
            this.free_sample_data = data;
            this.latest_sequence = data.length!==0 ? parseInt(data[data.length -1].Pagination_Formula__c):1;    
            this.pervious_sequence = data.length!==0 ? parseInt(data[0].Pagination_Formula__c):1;
            console.log('first rec',this.pervious_sequence +' last record '+this.latest_sequence);
            if(this.latest_sequence<this.pervious_sequence){
                this.free_sample_data = data.reverse();
                let temp = this.pervious_sequence;
                this.pervious_sequence = this.latest_sequence;
                this.latest_sequence = temp;
            }
            console.log('latest seq',this.latest_sequence);
            
            getTotalRecordcount({d_name:this.fs_name,d_code:this.fs_code}).then(total=>{
            // total = '16';
                
            console.log('tottal ',total);
            this.totalRecountCount = parseInt(total);
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

            this.items = this.free_sample_data.slice(0,this.pageSize);
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
        console.log('previous sequence->'+this.pervious_sequence);
        this.checkNextPreviousbtn(this.page,this.totalPage);
    }

    firstPage(){
        console.log('first page');
        this.page = 1;
        //this.displayRecordPerPage(this.page,this.pageSize);
        this.getRecordOnAction(this.pageSize,0,'>');
    }

    lastPage(){
        console.log('Last page');
        this.page = this.totalPage;
        console.log('last rec-->',this.pageSize,parseInt(this.last_record_sequence));
        // this.getRecordOnAction(this.pageSize,parseInt(this.last_record_sequence) - parseInt(this.pageSize) > 0 ?parseInt(this.last_record_sequence) - parseInt(this.pageSize):1,'>');
        //this.displayRecordPerPage(this.page,this.pageSize);
        this.getRecordOnAction(this.pageSize,parseInt(this.last_record_sequence)+1,'<');
    }

    previousPage(){
        console.log('Previous page');
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
        console.log('Next page');
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; 
            //this.displayRecordPerPage(this.page); 
            this.getRecordOnAction(this.pageSize,this.latest_sequence,'>');
            this.checkNextPreviousbtn(this.page,this.totalPage);           
        } 
    }

    displayRecordPerPage(page){
        console.log('Starting record '+this.startingRecord+' Ending record '+this.endingRecord);
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
        this.items = this.free_sample_data.slice(this.startingRecord, this.endingRecord);
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
      
        if(page==1){
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
}