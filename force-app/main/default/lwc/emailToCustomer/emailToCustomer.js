import { LightningElement,track,api,wire } from 'lwc';
import fecthCountryData from '@salesforce/apex/EmailToCustomer.fetchCountryData';
import fetchCustomerData from '@salesforce/apex/EmailToCustomer.fetchCustomerData';
import fetchSearchData from '@salesforce/apex/EmailToCustomer.fetchSearchData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import ProfileName from '@salesforce/schema/User.Profile.Name';
import Id from '@salesforce/user/Id';

export default class EmailToCustomer extends LightningElement {
    @track value = '--None--';
    SalesOrgType ='';
    countryData = [];  
    @track accountSearchResult;
    @track isAccountSearchResult;
    @track showSpinner;
    @track isFileUpload;
    @track selectedAccList = [];
    @track emailBody;
    @track isDisabled = true;
    @track totalSelectedRecords;
    @track reload;
    @track globalChecked;
    SelectedSize;
    //Added by Nandhini
    totalRecords = 0; 
    pageSize; 
    totalPages; 
    pageNumber = 1; 
    recordsToDisplay = [];
    currentPage='10'; 
    minChar = 2;
    @track showDropdown = false;
    @track showTDropdown = false;
    @track showSDropdown = false;
    @track showRDropdown = false;
    @track showStDropdown = false;
    @track message;
    @track zoneListOptions = [];
    @track SBUListOptions =[];
    @track terrirtoryListOptions = [];
    @track RegionListOptions = [];
    @track StateListOptions = [];
    @track SelectedZoListOptions = [];
    @track SelectedSBUListOptions =[];
    @track SelectedTerListOptions = [];
    @track SelectedRegListOptions = [];
    @track SelectedStListOptions = [];
    userProfileName;
    showUI;

    selectedSBUValues = [];
    selectedSBUIds = [];
    sbuSearchString;

    selectedZoneValues = [];
    selectedZoneIds = [];
    zoneSearchString;

    territorySearchString;
    selectedTerValues = [];
    selectedTerIds = [];

    regionSearchString;
    selectedRegValues = [];
    selectedRegIds = [];

    StateSearchString;
    selectedStValues = [];
    selectedStIds = [];

    showZOption;
    showSOption;
    showStOption;
    showTOption;
    showROption;

    @wire(getRecord, { recordId: Id, fields: [ProfileName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
          
            if (data.fields.Profile.value != null) {
                this.userProfileName = data.fields.Profile.value.fields.Name.value;
                if(this.userProfileName == 'System Administrator'){
                    this.showUI = true;
                }else{
                    this.showToastmessage('Error ! ','You are not authorized to access this page. Please contact your System Administrator','error');
                }
            }
           
        }
    }
    
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
     //this.globalChecked = false;
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
    get options() {
        return [
            { label: 'AF', value: '1410' },
            { label: 'SWAL', value: '1210' }
        ];
    }
    
    handleTypeChange(event){
        console.log('handle Type change');
        this.SalesOrgType = event.target.value;
        console.log('SalesOrgType ===> '+this.SalesOrgType);
        this.showSpinner = true;

        fecthCountryData({
            salesOrg:this.SalesOrgType
        }).then(result=>{
            
            this.countryData = result;
            this.showSpinner = false;
            console.log('result=> ',this.countryData);
        }).catch(error=>{

        });
        
    }
   
    handleSearch(){
        this.showSpinner = true;
        this.isAccountSearchResult = false;
        this.recordsToDisplay = null;
        this.accountSearchResult = null;
        this.isDisabled = this.accountSearchResult != null && this.accountSearchResult != undefined && this.accountSearchResult.length > 0 ? false : true;
        this.totalSelectedRecords = 0;
        fetchCustomerData({
            salesOrgCode:this.SalesOrgType,
            sbuIds:this.selectedSBUIds,
            zoneIds:this.selectedZoneIds,
            regionIds:this.selectedRegIds,
            stateIds:this.selectedStIds,
            TerIds: this.selectedTerIds
        }).then(result=>{
            console.log('Account Result=>> ',result);
            if(result === '[]'){
                this.showSpinner = false;
                this.showToastmessage('INFO ! ','No result found for searched parameter','infor');
                
            }else{
                let accountList = [];
                //this.accountSearchResult = result;
                this.showSpinner = false;
                this.isAccountSearchResult = true;
                let data = [];
                data= JSON.parse(result);
                console.log('Data=>> '+data);
                this.accountSearchResult = data;
                data.forEach(each=>{
                    let obj={};
                    obj.Id = each.Id;
                    obj.Name = each.Name;
                    obj.SBUName = (each.Territory_Distributor__c !=null && each.Territory_Distributor__r.SBU__c!=null)? each.Territory_Distributor__r.SBU__r.Name : 'NA';
                    obj.ZoneName = (each.Territory_Distributor__c !=null && each.Territory_Distributor__r.Zone__c!=null)? each.Territory_Distributor__r.Zone__r.Name : 'NA';
                    obj.TerritoryName = (each.Territory_Distributor__c !=null)? each.Territory_Distributor__r.Name : 'NA';
                    obj.stateName = (each.State__c !=null)? each.State__r.Name : 'NA';
                    obj.Email = each.Email__c;
                    obj.check = false;
                    obj.SAPCode = each.SAP_Customer_Code__c;
                    obj.fileNames = [];
                    accountList.push(obj);
                })
                this.accountSearchResult = accountList;
                this.isDisabled = this.accountSearchResult != null && this.accountSearchResult != undefined && this.accountSearchResult.length > 0 ? false : true;
                this.totalRecords = this.accountSearchResult?.length; // update total records count  
                console.log('Total Records :'+this.totalRecords);            
                this.pageSize = this.currentPage; //set pageSize with default value as first option
                this.paginationHelper(); // call helper menthod to update pagination logic 
                
            }
           
        }).catch(error=>{
            console.log('Error=>> '+error);
            this.showSpinner = false;
        })
    }
    handleRecordSelection(event){
        let checked = event.target.checked;
        
        if(checked){
            this.recordsToDisplay.forEach(each=>{
                if(!each.check){
                    each.check = true;
                    this.selectedAccList.push(each);
                }
               
            });
        }else{
            this.recordsToDisplay.forEach(each=>{
                each.check = false;
                this.selectedAccList.splice(this.selectedAccList?.indexOf(each.id),1);
                

            });
        }
        this.totalSelectedRecords = this.selectedAccList != null ? this.selectedAccList.length : 0;

        this.reload++;
    }
   
    handleDataSelection(event){
        let checked = event.target.checked;
        this.globalChecked = false;
        if(checked){
            this.selectedAccList = [];
            this.accountSearchResult.forEach(each=>{
                each.check = true;
                this.selectedAccList.push(each);
            });
        }else{
            this.accountSearchResult.forEach(each=>{
                each.check = false;
                this.selectedAccList = [];

            });
        }
        this.totalSelectedRecords = this.selectedAccList != null ? this.selectedAccList.length : 0;

        this.reload++;
    }
    paginationHelper() {
        this.template.querySelector('[data-name="pagecheck"]') != null && this.template.querySelector('[data-name="pagecheck"]') != undefined ? this.template.querySelector('[data-name="pagecheck"]').checked = false: '';
        //this.globalChecked = false;
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page --2,5  5   10
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.accountSearchResult[i]);
           
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
        console.log('this.accountSearchResult :' +JSON.stringify(this.accountSearchResult));
        console.log('recordsToDisplay :' +JSON.stringify(this.recordsToDisplay));
        //this.reload++;
    }
    handleNext(){
        this.isFileUpload = true;
    }
    handlePrevious(){
        this.isFileUpload = false;
    }
    handleCustomerSelection(event){
        let checked = event.target.checked;
        console.log('Checkbox value => '+checked);
        let acc = event.target.dataset.acc;
        if(checked){
            let filteredData = this.accountSearchResult.find(result=>result.Id == acc);
            console.log('FIltered Data=>> ',filteredData);
            this.selectedAccList.push(filteredData);
            if(this.accountSearchResult?.find(rec=>rec.Id == acc)){
                this.accountSearchResult.find(rec=>rec.Id == acc).check = true 
            }
            console.log('accountSearchResult =>> ',this.accountSearchResult);

            
        }else{
            this.selectedAccList.splice(this.selectedAccList?.indexOf(acc),1);
            if(this.accountSearchResult?.find(rec=>rec.Id == acc)){
            this.accountSearchResult.find(rec=>rec.Id == acc).check=false;
            }
            console.log('accountSearchResult =>> ',this.accountSearchResult);
        }
        console.log('this.selectedAccList =>> ',this.selectedAccList);
        this.totalSelectedRecords = this.selectedAccList != null ? this.selectedAccList.length : 0;
        
    }
    handleReset(event){

        //this.isFileUpload = false;
        this.value=null;
        this.SalesOrgType = null;
        this.isAccountSearchResult = false;
        this.recordsToDisplay = [];
        this.accountSearchResult = [];
        this.isDisabled = this.accountSearchResult != null && this.accountSearchResult != undefined && this.accountSearchResult.length > 0 ? false : true;
        this.selectedAccList = [];
        this.countryData = [];
        this.totalSelectedRecords = 0;

        this.template.querySelectorAll('lightning-combobox').forEach(each=>{
            each.value = null;
        })

        this.selectedRegIds = [];
        this.selectedSBUIds = [];
        this.selectedStIds = [];
        this.selectedZoneIds = [];
        this.selectedTerIds = [];

        this.selectedRegValues = [];
        this.selectedSBUValues = [];
        this.selectedStValues = [];
        this.selectedTerValues = [];
        this.selectedZoneValues = [];

        this.zoneSearchString = null;
        this.regionSearchString = null;
        this.StateSearchString = null;
        this.territorySearchString = null;
        this.sbuSearchString = null;

        this.zoneListOptions =[];
        this.StateListOptions = [];
        this.terrirtoryListOptions = [];
        this.SBUListOptions = [];
        this.RegionListOptions = [];

        this.SelectedTerListOptions = [];
        this.SelectedRegListOptions = [];
        this.SelectedSBUListOptions = [];
        this.SelectedStListOptions = [];
        this.SelectedZoListOptions = [];

        this.message=null;
        this.showDropdown =false;
        this.showRDropdown = false;
        this.showSDropdown = false;
        this.showTDropdown=false;
        this.showStDropdown=false;


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
    handleZoneSearch(event){
        var timer;
        let searchterm = event.target.value;
        let objName = event.target.dataset.name;
        console.log('searchterm --> ' + searchterm);
        console.log('objName --> ' + objName);
        console.log('SalesOrgType ===> '+this.SalesOrgType);
       
        this.showDropdown = false;
        this.showSDropdown = false;
        this.showTDropdown = false;
        this.showStDropdown = false;
        this.showRDropdown = false;
        if (searchterm && searchterm.length > 0) {
            this.message = '';

            if (searchterm.length >= this.minChar) {
                this.fetchData(searchterm,objName);

            }
        }
    }
    fetchData(searchterm,objName){
        let salesOrgName = this.SalesOrgType == '1210'? 'SWAL':'AF';
        let filterCriteria='';
       

        fetchSearchData({
            salesOrg: this.SalesOrgType,
            ObjName:objName,
            searchKey: searchterm,
            sbuList : JSON.stringify(this.selectedSBUValues),
            zoneList: JSON.stringify(this.selectedZoneValues),
            regionList: JSON.stringify(this.selectedRegValues)
        })
        .then(result=>{
            let sbuList = [{'label':'--None--','value':''}];
            
            if(result != null && result != undefined ){
                if(objName == 'Zone__c' && result.mapListZone != null){
                    Object.entries(result.mapListZone).forEach(each=>{
                        let obj = {'label':'--None--','value':''};
                        obj['label']=each[1].Name;
                        obj['value']=each[1].Id;
                        sbuList.push(obj);
                    })
                    console.log('sbuList =>> ',sbuList);
    
                    if(sbuList != null  && sbuList.length>0){
                        this.zoneListOptions = sbuList;
                       
                    }else{
                        this.zoneListOptions =  [{ label: 'No Value found', value: 'NA' }];
                        this.message = "No Zone record found for this Type : "+ salesOrgName;
                    }
                    this.showDropdown = true;
                }else if(objName == 'Territory_Distributor__c' && result.mapListTer != null){
                    Object.entries(result.mapListTer).forEach(each=>{
                        let obj = {'label':'--None--','value':''};
                        obj['label']=each[1].Name;
                        obj['value']=each[1].Id;
                        sbuList.push(obj);
                    })
                    console.log('sbuList =>> ',sbuList);
    
                    if(sbuList != null  && sbuList.length>0){
                        this.terrirtoryListOptions = sbuList;
                      

                    }else{
                        this.terrirtoryListOptions =  [{ label: 'No Value found', value: 'NA' }];
                        this.message = "No Territory record found for this Type : "+ salesOrgName;

                    }
                    this.showTDropdown = true;
                }else if(objName == 'SBU__c' && result.mapListSBU != null){
                    Object.entries(result.mapListSBU).forEach(each=>{
                        let obj = {'label':'--None--','value':''};
                        obj['label']=each[1].Name;
                        obj['value']=each[1].Id;
                        sbuList.push(obj);
                    })
                    console.log('sbuList =>> ',sbuList);
    
                    if(sbuList != null  && sbuList.length>0){
                        this.SBUListOptions = sbuList;
                        

                    }else{
                        this.SBUListOptions =  [{ label: 'No Value found', value: 'NA' }];
                        this.message = "No SBU record found for this Type : "+ salesOrgName;

                    }
                    this.showSDropdown = true;
                }else if(objName == 'State__c' && result.mapListState != null){
                    Object.entries(result.mapListState).forEach(each=>{
                        let obj = {'label':'--None--','value':''};
                        obj['label']=each[1].Name;
                        obj['value']=each[1].Id;
                        sbuList.push(obj);
                    })
                    console.log('sbuList =>> ',sbuList);
    
                    if(sbuList != null  && sbuList.length>0){
                        this.StateListOptions = sbuList;

                    }else{
                        this.StateListOptions =  [{ label: 'No Value found', value: 'NA' }];
                        this.message = "No State record found for this Type : "+ salesOrgName;

                    }
                    this.showStDropdown = true;

                }else if(objName == 'Region__c' && result.mapListReg != null){
                    Object.entries(result.mapListReg).forEach(each=>{
                        let obj = {'label':'--None--','value':''};
                        obj['label']=each[1].Name;
                        obj['value']=each[1].Id;
                        sbuList.push(obj);
                    })
                    console.log('sbuList =>> ',sbuList);
    
                    if(sbuList != null  && sbuList.length>0){
                        this.RegionListOptions = sbuList;

                    }else{
                        this.RegionListOptions =  [{ label: 'No Value found', value: 'NA' }];
                        this.message = "No Region record found for this Type : "+ salesOrgName;

                    }
                    this.showRDropdown = true;

                }
               
              
            }
           
            
            console.log('Result on zone search =>',result);
        }).catch(error=>{
            console.log('error on zone search =>',error);
            this.message = "No results found for '" + searchterm + "'";

        });
    }
    handleZoneSelect(event) {
        try {
            var selectedVal = event.currentTarget.dataset.id;
            var selectedlabel = event.currentTarget.dataset.label;
            console.log('handleAccountSelect Value --> ' + selectedVal);
            console.log('handleAccountSelect Label --> ' + selectedlabel);
            
            this.showDropdown = false;
            if(selectedVal != null && selectedVal != ''){
                if(!(this.selectedZoneIds.includes(selectedVal))){
                    this.selectedZoneValues.push(selectedlabel);
                    this.selectedZoneIds.push(selectedVal);
                }
            }
                console.log('selected Zone values => ',this.selectedZoneValues);
                console.log('selected Zone Ids => ',this.selectedZoneIds);
    
                this.zoneListOptions.forEach(res=>{
                        if(selectedVal != '' && res.value == selectedVal){
                            res.selected = true;
                            let data = this.SelectedZoListOptions.find(result=> result.value === res.value);
                            console.log('data => ',data);
                            if(data == null || data == undefined){
                                this.SelectedZoListOptions.push(res);
                            }
                        }
                     
                    })
            
           
                console.log('this.SelectedZoListOptions- >> ',this.SelectedZoListOptions);
            this.zoneSearchString = this.selectedZoneValues != null && this.selectedZoneValues != undefined && this.selectedZoneValues.length>1 ? this.selectedZoneValues.length+' option Selected' : this.selectedZoneValues != null && this.selectedZoneValues != undefined && this.selectedZoneValues.length == 1 ? this.selectedZoneValues[0]:'';
        } catch (e) {
            console.log(e);
        }
    }
    handleTerritorySelect(event){
        try {
            var selectedVal = event.currentTarget.dataset.id;
            var selectedlabel = event.currentTarget.dataset.label;
            console.log('handleAccountSelect Value --> ' + selectedVal);
            console.log('handleAccountSelect Label --> ' + selectedlabel);
            this.showTDropdown = false;

            if(selectedVal != null && selectedVal != ''){
                if(!(this.selectedTerIds.includes(selectedVal))){
                    this.selectedTerValues.push(selectedlabel);
                    this.selectedTerIds.push(selectedVal);








                }
            }   
                this.terrirtoryListOptions.forEach(res=>{
                    if(selectedVal != '' && res.value == selectedVal){
                        res.selected = true;
                        let data = this.SelectedTerListOptions.find(result=> result.value === res.value);
                        console.log('data => ',data);
                        if(data == null || data == undefined){
                            this.SelectedTerListOptions.push(res);
                        }
                    }
                 
                })
            
           
            console.log('this.SelectedTerListOptions- >> ',this.SelectedTerListOptions);
            console.log('selected Zone values => ',this.selectedTerValues);
            console.log('selected Zone Ids => ',this.selectedTerIds);
            this.territorySearchString =   this.selectedTerValues != null && this.selectedTerValues != undefined && this.selectedTerValues.length>1 ? this.selectedTerValues.length+' option Selected' : this.selectedTerValues != null && this.selectedTerValues != undefined && this.selectedTerValues.length == 1 ? this.selectedTerValues[0]:'';
        } catch (e) {
            console.log(e);
        }
    }
    handleSBUSelect(event){
        try {
            var selectedVal = event.currentTarget.dataset.id;
            var selectedlabel = event.currentTarget.dataset.label;
            console.log('handleAccountSelect Value --> ' + selectedVal);
            console.log('handleAccountSelect Label --> ' + selectedlabel);
            this.showSDropdown = false;
            if(selectedVal != null && selectedVal != ''){
                if(!(this.selectedSBUIds.includes(selectedVal))){
                    this.selectedSBUValues.push(selectedlabel);
                    this.selectedSBUIds.push(selectedVal);
                }
            }
                this.SBUListOptions.forEach(res=>{
                    if(selectedVal != '' && res.value == selectedVal){
                        res.selected = true;
                        let data = this.SelectedSBUListOptions.find(result=> result.value === res.value);
                        console.log('data => ',data);
                        if(data == null || data == undefined){
                            this.SelectedSBUListOptions.push(res);
                        }
                    }
                 
                
                })
            
            
            console.log('this.SelectedSBUListOptions- >> ',this.SelectedSBUListOptions);
            console.log('selected Zone values => ',this.selectedSBUValues);
            console.log('selected Zone Ids => ',this.selectedSBUIds);
            this.sbuSearchString =   this.selectedSBUValues != null && this.selectedSBUValues != undefined && this.selectedSBUValues.length>1 ? this.selectedSBUValues.length+' option Selected' : this.selectedSBUValues != null && this.selectedSBUValues != undefined && this.selectedSBUValues.length == 1 ? this.selectedSBUValues[0]:'';
        } catch (e) {
            console.log(e);
        }
    }
    handleStateSelect(event){
        try {
            var selectedVal = event.currentTarget.dataset.id;
            var selectedlabel = event.currentTarget.dataset.label;
            console.log('handleAccountSelect Value --> ' + selectedVal);
            console.log('handleAccountSelect Label --> ' + selectedlabel);
          
            this.showStDropdown = false;
            if(selectedVal != null && selectedVal != ''){
                if(!(this.selectedStIds.includes(selectedVal))){
                    this.selectedStValues.push(selectedlabel);
                    this.selectedStIds.push(selectedVal);









                }
            }    
                this.StateListOptions.forEach(res=>{
                    if(selectedVal != '' && res.value == selectedVal){
                        res.selected = true;
                        let data = this.SelectedStListOptions.find(result=> result.value === res.value);
                        console.log('data => ',data);
                        if(data == null || data == undefined){
                            this.SelectedStListOptions.push(res);
                        }
                    }
                })
            
          
            console.log('this.SelectedStListOptions- >> ',this.SelectedStListOptions);
            console.log('selected Zone values => ',this.selectedStValues);
            console.log('selected Zone Ids => ',this.selectedStIds);
            this.StateSearchString =   this.selectedStValues != null && this.selectedStValues != undefined && this.selectedStValues.length>1 ? this.selectedStValues.length+' option Selected' : this.selectedStValues != null && this.selectedStValues != undefined && this.selectedStValues.length == 1 ? this.selectedStValues[0]:'';
        } catch (e) {
            console.log(e);
        }
    }
    handleRegionSelect(event){
        console.log('In Handle region select');
        try {
            var selectedVal = event.currentTarget.dataset.id;
            var selectedlabel = event.currentTarget.dataset.label;
            console.log('handleAccountSelect Value --> ' + selectedVal);
            console.log('handleAccountSelect Label --> ' + selectedlabel);
           
            this.showRDropdown = false;
            if(selectedVal != null && selectedVal != ''){
                if(!(this.selectedRegIds.includes(selectedVal))){
                    this.selectedRegValues.push(selectedlabel);
                    this.selectedRegIds.push(selectedVal);









                }
            }   
                this.RegionListOptions.forEach(res=>{
                    if(selectedVal != '' && res.value == selectedVal){
                        res.selected = true;
                        let data = this.SelectedRegListOptions.find(result=> result.value === res.value);
                        console.log('data => ',data);
                        if(data == null || data == undefined){
                            this.SelectedRegListOptions.push(res);
                        }
                    }
                })
            
            
            console.log('this.SelectedRegListOptions- >> ',this.SelectedRegListOptions);
            console.log('selected Zone values => ',this.selectedRegValues);
            console.log('selected Zone Ids => ',this.selectedRegIds);
            this.regionSearchString =   this.selectedRegValues != null && this.selectedRegValues != undefined && this.selectedRegValues.length>1 ? this.selectedRegValues.length+' option Selected' : this.selectedRegValues != null && this.selectedRegValues != undefined && this.selectedRegValues.length == 1 ? this.selectedRegValues[0]:'';
        } catch (e) {
            console.log(e);
        }
    }
    showZoneOption(event){
        let sbuList = [{'label':'--None--','value':''}];
        this.zoneSearchString = '';
        this.showZOption = true;
        this.showROption = false;
        this.showSOption = false;
        this.showStOption = false;
        this.showTOption = false;
        this.blurEvent();
        let salesOrgName = this.SalesOrgType == '1210'? 'SWAL':'AF';
        if(this.SalesOrgType == null || this.SalesOrgType == undefined){
            this.showToastmessage('INFO ! ','Please Select Sales Org Type','infor');
            
        }else{
            this.fetchData('','Zone__c');
            
























        }
      
       
    }
    showTerritoryOption(event){
        let sbuList = [{'label':'--None--','value':''}];
        this.territorySearchString = '';
        this.showZOption = true;
        this.showROption = false;
        this.showSOption = false;
        this.showStOption = false;
        this.showTOption = true;
        this.blurEvent();

        let salesOrgName = this.SalesOrgType == '1210'? 'SWAL':'AF';
        if(this.SalesOrgType == null || this.SalesOrgType == undefined){
            this.showToastmessage('INFO ! ','Please Select Sales Org Type','infor');
            
        }else{
            this.fetchData('','Territory_Distributor__c');
            
























        }
        
       
    }
    
    showSBUOption(event){
        console.log('In handle Click');
        let sbuList = [{'label':'--None--','value':''}];
        this.sbuSearchString = '';
        this.showZOption = false;
        this.showROption = false;
        this.showSOption = true;
        this.showStOption = false;
        this.showTOption = false;     
        this.blurEvent();
   
        let salesOrgName = this.SalesOrgType == '1210'? 'SWAL':'AF';
        if(this.SalesOrgType == null || this.SalesOrgType == undefined){
            this.showToastmessage('INFO ! ','Please Select Sales Org Type','infor');
            
        }else{
            if(this.countryData != null && this.countryData != undefined ){
                if(this.countryData.mapListSBU != null){
                    Object.entries(this.countryData.mapListSBU).forEach(each=>{
                        let obj = {'label':'--None--','value':''};
                        obj['label']=each[1].Name;
                        obj['value']=each[1].Id;
                        if(this.selectedSBUIds.includes(each[1].Id)){
                            obj['selected']=true;
                        }
                        sbuList.push(obj);
                    })
                    console.log('sbuList =>> ',sbuList);
    
                    if(sbuList != null  && sbuList.length>0){
                        this.SBUListOptions = sbuList;
                       
                    }else{
                        //this.SBUListOptions =  [{ label: 'No Value found', value: 'NA' }];
                        this.message = "No SBU record found for this Type : "+ salesOrgName;
                    }
                    this.showSDropdown = true;
                }
               
              
            }
        }
       
       
    }
    showRegionOption(event){
        console.log('Show region option');
        let sbuList = [{'label':'--None--','value':''}];
        this.regionSearchString = '';
        this.showZOption = false;
        this.showROption = true;
        this.showSOption = false;
        this.showStOption = false;
        this.showTOption = false;    
        this.blurEvent();
    
        let salesOrgName = this.SalesOrgType == '1210'? 'SWAL':'AF';
        if(this.SalesOrgType == null || this.SalesOrgType == undefined){
            this.showToastmessage('INFO ! ','Please Select Sales Org Type','infor');
            
        }else{
            this.fetchData('','Region__c');
            























        }
        
       
    }
    showStateOption(event){
        let sbuList = [{'label':'--None--','value':''}];
        this.StateSearchString = '';
        this.showZOption = false;
        this.showROption = false;
        this.showSOption = false;
        this.showStOption = true;
        this.showTOption = false;   
        this.blurEvent();
     
        let salesOrgName = this.SalesOrgType == '1210'? 'SWAL':'AF';
        if(this.SalesOrgType == null || this.SalesOrgType == undefined){
            this.showToastmessage('INFO ! ','Please Select Sales Org Type','infor');
            
        }else{
            if(this.countryData != null && this.countryData != undefined ){
                if(this.countryData.mapListState != null){
                    Object.entries(this.countryData.mapListState).forEach(each=>{
                        let obj = {'label':'--None--','value':''};
                        obj['label']=each[1].Name;
                        obj['value']=each[1].Id;
                        if(this.selectedStIds.includes(each[1].Id)){
                            obj['selected']=true;
                        }
                        sbuList.push(obj);
                    })
                    console.log('sbuList =>> ',sbuList);
    
                    if(sbuList != null  && sbuList.length>0){
                        this.StateListOptions = sbuList;
                       
                    }else{
                        this.StateListOptions =  [{ label: 'No Value found', value: 'NA' }];
                        this.message = "No State record found for this Type : "+ salesOrgName;
                    }
                    this.showStDropdown = true;
                }
               
              
            }
        }
        
       
    }
    blurEvent(event){
        console.log('In handle blur');
        this.message = null;
        if(!this.showZOption){
            this.showDropdown = false;
        }
        if(!this.showROption){
            this.showRDropdown = false;
        }
        if(!this.showSOption){
            this.showSDropdown = false;
        }
        if(!this.showStOption){
            this.showStDropdown = false;
        }
        if(!this.showTOption){
            this.showTDropdown = false;
        }
    }
    removePill(event){
        console.log('In remove Pill');
        var value = event.currentTarget.name;
        var objname = event.currentTarget.dataset.objname;
        var count = 0;
        var options;
        if(objname == 'Zone__c'){
            options= JSON.parse(JSON.stringify(this.SelectedZoListOptions));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === value) {
                    options[i].selected = false;
                    this.selectedZoneValues.splice(this.selectedZoneValues.indexOf(options[i].label), 1);
                    this.selectedZoneIds.splice(this.selectedZoneIds.indexOf(options[i].value),1);
                }
                if(options[i].selected) {
                    count++;
                }
               
            }
           
            if(count > 1){
                this.zoneSearchString = count + ' Option(s) Selected';
            }else if(count == 1){
                this.zoneSearchString = this.selectedZoneValues[0];
            }else{
                this.zoneSearchString = null;
            }
            let finalData = options.filter(op=> op.selected == true);
            console.log('finalData =>> ',finalData);
            this.SelectedZoListOptions = finalData;
            //this.zoneSearchString = count + ' Option(s) Selected';
        }else if(objname == 'Territory_Distributor__c'){
            options= JSON.parse(JSON.stringify(this.SelectedTerListOptions));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === value) {
                    options[i].selected = false;
                    this.selectedTerValues.splice(this.selectedTerValues.indexOf(options[i].label), 1);
                    this.selectedTerIds.splice(this.selectedTerIds.indexOf(options[i].value),1);
                }
                if(options[i].selected) {
                    count++;
                }
            }
            if(count > 1){
                this.territorySearchString = count + ' Option(s) Selected';
            }else if(count == 1){
                this.territorySearchString = this.selectedTerValues[0];
            }else{
                this.territorySearchString =null;
            }
            let finalData = options.filter(op=> op.selected == true);
            console.log('finalData =>> ',finalData);
            this.SelectedTerListOptions = finalData;
            //this.territorySearchString = count + ' Option(s) Selected';
        }else if(objname == 'SBU__c'){
            options= JSON.parse(JSON.stringify(this.SelectedSBUListOptions));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === value) {
                    options[i].selected = false;
                    this.selectedSBUValues.splice(this.selectedSBUValues.indexOf(options[i].label), 1);
                    this.selectedSBUIds.splice(this.selectedSBUIds.indexOf(options[i].value),1);
                }
                if(options[i].selected) {
                    count++;
                }   







            }
            if(count > 1){
                this.sbuSearchString = count + ' Option(s) Selected';
            }else if(count == 1){
                this.sbuSearchString = this.selectedSBUValues[0];
            }else{
                this.sbuSearchString = null;
            }
            let finalData = options.filter(op=> op.selected == true);
            console.log('finalData =>> ',finalData);
            this.SelectedSBUListOptions = finalData;
            //this.sbuSearchString = count + ' Option(s) Selected';
        }else if(objname == 'State__c'){
            options= JSON.parse(JSON.stringify(this.SelectedStListOptions));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === value) {
                    options[i].selected = false;
                    this.selectedStValues.splice(this.selectedStValues.indexOf(options[i].label), 1);
                    this.selectedStIds.splice(this.selectedStIds.indexOf(options[i].value),1);
                }
                if(options[i].selected) {
                    count++;
                }
            }
            if(count > 1){
                this.StateSearchString = count + ' Option(s) Selected';
            }else if(count == 1){
                this.StateSearchString = this.selectedStValues[0];
            }else{
                this.StateSearchString = null;
            }
            let finalData = options.filter(op=> op.selected == true);
            console.log('finalData =>> ',finalData);
            this.SelectedStListOptions = finalData;
            //this.StateSearchString = count + ' Option(s) Selected';
        }
        else if(objname == 'Region__c'){
            options= JSON.parse(JSON.stringify(this.SelectedRegListOptions));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === value) {
                    options[i].selected = false;
                    this.selectedRegValues.splice(this.selectedRegValues.indexOf(options[i].label), 1);
                    this.selectedRegIds.splice(this.selectedRegIds.indexOf(options[i].value),1);
                }
                if(options[i].selected) {
                    count++;
                }
            }
           
            if(count > 1){
                this.regionSearchString = count + ' Option(s) Selected';
            }else if(count == 1){
                this.regionSearchString = this.selectedRegValues[0];
            }else{
                this.regionSearchString = null;
            }
            let finalData = options.filter(op=> op.selected == true);
            console.log('finalData =>> ',finalData);
            this.SelectedRegListOptions = finalData;
        }
        this.reload++;
       
    }
    
}