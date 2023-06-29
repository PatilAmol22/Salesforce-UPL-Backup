import { LightningElement,track,wire } from 'lwc';
import Liquidation_title from '@salesforce/label/c.Liquidation_title';
import Year from '@salesforce/label/c.Year';
import Select_Year from '@salesforce/label/c.Select_Year';
import Quarter from '@salesforce/label/c.Quarter';
import Select_Quarter from '@salesforce/label/c.Select_Quarter';
import All from '@salesforce/label/c.All';
import None from '@salesforce/label/c.None';
import Distributor from '@salesforce/label/c.Distributor';
import no_data from '@salesforce/label/c.Grz_NoDataForThisComb';
import Brand from '@salesforce/label/c.Brand';
import SKU_Code from '@salesforce/label/c.SKU_Code';
import SKU_Description from '@salesforce/label/c.SKU_Description';
import Opening_Inventory from '@salesforce/label/c.Opening_Inventory';
import OpeningInventoryPLN from '@salesforce/label/c.Grz_OpeningInventoryPLN';
import ytd_sales from '@salesforce/label/c.YTD_sales';
import YTD_SalesPLN from '@salesforce/label/c.Grz_YTD_Sales';
import Total_Available_Stock from '@salesforce/label/c.Total_Available_Stock';
import TotalAvailableStockPLN from '@salesforce/label/c.Grz_TotalAvailableStockPLN';
import Distributor_Inventory from '@salesforce/label/c.Distributor_Inventory';
import DistributorInventoryPLN from '@salesforce/label/c.Grz_DistributorInventoryPLN';
import Plan_YTD_Quarter from '@salesforce/label/c.Plan_YTD_Quarter';
import Liquidation_YTD_Selected_Quarter from '@salesforce/label/c.Liquidation_YTD_Selected_Quarter';
import Liquidation_YTDSelectedQuarterPLN from '@salesforce/label/c.Grz_Liquidation_YTDSelectedQuarterPLN';
import Liquidation_YTD_Selected_Quarter_Percent from '@salesforce/label/c.Liquidation_YTD_Selected_Quarter_Percent';
import Plan_for_Next_Quarter from '@salesforce/label/c.Plan_for_Next_Quarter';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import object_liquidationAnnualPlan from '@salesforce/schema/Liquidation_Annual_Plan__c';
import FIscal_Year__c from '@salesforce/schema/Liquidation_Annual_Plan__c.FIscal_Year__c';
import getPOGLiquidationReportDataBrand from '@salesforce/apex/Grz_POGLiquidationReportController.getPOGLiquidationReportDataBrand';
import checkPriceloaded from '@salesforce/apex/Grz_POGLiquidationReportController.checkPriceloaded';
import Distributor_inventory_field from '@salesforce/schema/Liquidation2__c.Distributors_Inventory__c';
import Plan_for_the_Next_Quarter_field from '@salesforce/schema/Liquidation2__c.Plan_for_the_Next_Quarter__c';
import loading_data from '@salesforce/label/c.Loading';
import Search from '@salesforce/label/c.Search';
import toast_err from '@salesforce/label/c.Error';
import Distributor_inventory_validation from '@salesforce/label/c.Distributor_inventory_validation';
import valid_value from '@salesforce/label/c.valid_value';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserCountry from '@salesforce/apex/Grz_PolandLiquidation.getUserCountry';
import Submit from '@salesforce/label/c.Poland_Submit';
import Upload_Opening_Inventory from '@salesforce/label/c.Upload_Opening_Inventory';
import Upload_Liquidation from '@salesforce/label/c.Upload_Liquidation';
import Liquidation_submitted_Successfully from '@salesforce/label/c.Liquidation_submitted_Successfully';
import Error_while_submitting_Liquidation from '@salesforce/label/c.Error_while_submitting_Liquidation';
import toast_success from '@salesforce/label/c.Success';
import PolandEditProfile from '@salesforce/label/c.PolandEditProfile';
import Grz_PolandSalesOrgCode from '@salesforce/label/c.Grz_PolandSalesOrgCode';
import Select_Year_and_Quarter from '@salesforce/label/c.Select_Year_and_Quarter';
import Select_Year_value from '@salesforce/label/c.Select_Year_value';
import ExcludeEmptyStock from '@salesforce/label/c.Grz_ExcludeEmptyStock';
import POGReport from '@salesforce/label/c.Grz_ReportByBrand';
import MultiSelectPicklistLabel from '@salesforce/label/c.Grz_MultiSelectPicklistLabel';
import Grz_SelectBrand from '@salesforce/label/c.Grz_SelectBrand';
import CheckIsSubmitted from '@salesforce/apex/Grz_PolandLiquidation.checkIsSubmitTrueLiquidation';
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import Warning from "@salesforce/label/c.Warning";
import WarningMessage from "@salesforce/label/c.Grz_WarningMessage";

export default class Grz_reportByBrandTable extends LightningElement {
    @track labels = {All:All,None:None};
    @track year = ''; 
    @track quarter = '';
    @track yearOption = [{ label: this.labels.None, value: '' }];          // label:name value:Id
    @track yearOptionRemoveCurrent = [{ label: this.labels.None, value: '' }];
    @track quarterOption = []; 
    @track distributor_filter = '';
    @track distributor =''; 
    @track distributorName = '';
    @track liquidation_found=true;
    @track liquidation_data = [];
    @track disable_year = false;
    @track disable_quarter = true;
    @track record_type = '';
    @track number_saperator_code='pl-PL';
    @track spinner = false;
    @track disable_fields = true;
    @track search_str = '';
    @track search_data = [];
    @track brand_sortDirection = true;
    @track SKU_Code_sortDirection = true;
    @track SKU_Description_sortDirection = true;
    @track Total_Available_Stock_sortDirection = true;
    @track Liquidation_percentage_YTD_sortDirection = true;
    @track is_editable = true;
    @track flag_search = false;
    @track disable_openingInventory = true;
    @track disable_submit_btn = true;
    @track liquidation_to_submit = [];
    @track is_submitted=false;
    @track is_active_liquidation=false;
    @track is_active_openingInv=false;
    @track userRoleName = '';
    @track openModel = false;
    @track openModelOI=false;
    @track Sales_Org = '';
    @track selected_year = '';
    @track sales_district='poland';
    @track ischecked = true;
    @track liquidation_data_Updated = [];
    @track Q1 = [3,4,5];
    @track Q2 = [6,7,8];
    @track Q3 = [9,10,11];
    @track Q4 = [0,1,2];
    @track Quarter1 = 'I kwartał kwiecień-czerwiec';
    @track Quarter2 = 'II kwartał lipiec-wrzesień';
    @track Quarter3 = 'III kwartał październik-grudzień';
    @track Quarter4 = 'IV kwartał styczeń-marzec';
    @track isLQUSubmitted = false;
    @track currentfiscalYear;
    @track currentfiscalQuarter;
    @track pogPDFUrl = '';
    @track pogXLSUrl = '';
    @track value;
    @track selectedSkuList1 = [];
    @track selectedAccountList1 = [];
    @track allValues = [];
    @track isVisiblePDFandXLS = false;
    @track selectedCols = [];   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
    @track SelectedColumnValue = '';   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
    downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";
    labels = {
        Liquidation_title: Liquidation_title,
        Year: Year,
        Select_Year: Select_Year,
        Quarter: Quarter,
        Select_Quarter: Select_Quarter,
        Distributor:Distributor,
        no_data:no_data,
        Brand:Brand,
        SKU_Code:SKU_Code,
        SKU_Description:SKU_Description,
        Opening_Inventory:Opening_Inventory,
        OpeningInventoryPLN : OpeningInventoryPLN,
        ytd_sales:ytd_sales,
        YTD_SalesPLN:YTD_SalesPLN,
        Total_Available_Stock:Total_Available_Stock,
        TotalAvailableStockPLN:TotalAvailableStockPLN,
        Distributor_Inventory:Distributor_Inventory,
        DistributorInventoryPLN : DistributorInventoryPLN,
        Plan_YTD_Quarter:Plan_YTD_Quarter,
        Liquidation_YTD_Selected_Quarter:Liquidation_YTD_Selected_Quarter,
        Liquidation_YTDSelectedQuarterPLN:Liquidation_YTDSelectedQuarterPLN,
        Liquidation_YTD_Selected_Quarter_Percent:Liquidation_YTD_Selected_Quarter_Percent,
        Plan_for_Next_Quarter:Plan_for_Next_Quarter,
        None:None,
        loading: loading_data,
        Search: Search,
        toast_err: toast_err,
        toast_success: toast_success,
        Distributor_inventory_validation:Distributor_inventory_validation,
        valid_value:valid_value,
        Submit: Submit,
        Upload_Opening_Inventory:Upload_Opening_Inventory,
        Upload_Liquidation: Upload_Liquidation,
        Liquidation_submitted_Successfully: Liquidation_submitted_Successfully,
        Error_while_submitting_Liquidation: Error_while_submitting_Liquidation,
        PolandEditProfile:PolandEditProfile,
        Grz_PolandSalesOrgCode:Grz_PolandSalesOrgCode,
        Select_Year_and_Quarter:Select_Year_and_Quarter,
        Select_Year_value:Select_Year_value,
        ExcludeEmptyStock : ExcludeEmptyStock,
        POGReportLabel : POGReport,
        MultiSelectPicklistLabel : MultiSelectPicklistLabel,
        Grz_SelectBrand: Grz_SelectBrand,
        DownloadPDF:DownloadPDF,
        DownloadXLS:DownloadXLS,
        All:All,
        Warning:Warning,
        WarningMessage:WarningMessage
    }

    @track options = [
        { label: this.labels.All, value: 'All' },
        { label: this.labels.Brand, value: 'Brand' },
        // { label: this.labels.SKU_Code, value: 'SKU_Code' },
        // { label: this.labels.SKU_Description, value: 'SKU_Description' },
        { label: this.labels.Opening_Inventory, value: 'Opening_inventory' },
        { label: this.labels.OpeningInventoryPLN, value: 'OpeningInventoryPLN' },
        { label: this.labels.ytd_sales, value: 'YTD_sales' },
        { label: this.labels.YTD_SalesPLN, value: 'YTD_SalesPLN' },
        { label: this.labels.Total_Available_Stock, value: 'Total_Available_Stock' },
        { label: this.labels.TotalAvailableStockPLN, value: 'TotalAvailableStockPLN' },
        { label: this.labels.Distributor_Inventory, value: 'Distributor_Inventory' },
        { label: this.labels.DistributorInventoryPLN, value: 'DistributorInventoryPLN' },
        { label: this.labels.Liquidation_YTD_Selected_Quarter, value: 'Liquidation_YTD' },
        { label: this.labels.Liquidation_YTDSelectedQuarterPLN, value: 'Liquidation_YTD_PLN' },
        { label: this.labels.Liquidation_YTD_Selected_Quarter_Percent, value: 'Liquidation_percentage_YTD' }
    ];

    @track fieldsapiname = {
        'Opening_inventory': 'Opening_Inventory2__c',
        'Distributor_inventory': Distributor_inventory_field.fieldApiName,
        'Plan_for_the_Next_Quarter': Plan_for_the_Next_Quarter_field.fieldApiName,
    }

    @track selectedValue;
    @track selectedValueList ;
    @track selectedSKUValueList;
    @track selectedAccountValueList; 
    //for single select picklist
    /*handleSelectOption(event){
        console.log(event.detail);
        this.selectedValue = event.detail;
    }*/

    handleSelectAccountOptionList(event){

        let checkboxes = this.template.querySelector('[data-id="checkbox"]');
        checkboxes.checked = true;
        this.ischecked = true;

        this.selectedAccountValueList = JSON.parse(JSON.stringify(event.detail));
        console.log('this.selectedAccountValueList : ',this.selectedAccountValueList);

        var selectedAccountList = [];
        for(var i in this.selectedAccountValueList){
            console.log('value : ',this.selectedAccountValueList[i]);
            selectedAccountList.push(this.selectedAccountValueList[i]);
        }
        this.selectedAccountList1 = selectedAccountList;

        console.log('this.selectedAccountList1 : ',this.selectedAccountList1);

        if (this.year != '' && this.quarter != ''){
            this.getLiquidation(this.selectedAccountList1,this.year, this.quarter,this.selectedSkuList1,this.ischecked);
        }

    }

    handleSelectSKUOptionList(event){

        let checkboxes = this.template.querySelector('[data-id="checkbox"]');
        checkboxes.checked = true;
        this.ischecked = true;

        this.selectedSKUValueList = JSON.parse(JSON.stringify(event.detail));
        console.log('this.selectedSKUValueList : ',this.selectedSKUValueList);
        var selectedSkuList = [];
        for(var i in this.selectedSKUValueList){
            console.log('value : ',this.selectedSKUValueList[i]);
            selectedSkuList.push(this.selectedSKUValueList[i]);
        }
        console.log('selectedSkuList : ',selectedSkuList);
        this.selectedSkuList1 = selectedSkuList;
        console.log('this.selectedSkuList1 : ',this.selectedSkuList1);

        if ( this.year != '' && this.quarter != ''){
            this.getLiquidation(this.selectedAccountList1,this.year, this.quarter,this.selectedSkuList1,this.ischecked);
        }

    }
 
    //for multiselect picklist
    handleSelectOptionList(event){

        this.selectedCols = [];   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
        this.selectedValueList = JSON.parse(JSON.stringify(event.detail));
        console.log('this.selectedValueList : ',this.selectedValueList);
       
        for(var i in this.selectedValueList){
            var j = [];   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
            if(this.selectedValueList[i].selected){
                j.push(this.selectedValueList[i]);   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
                this.selectedCols.push((JSON.parse(JSON.stringify(j)))[0].label);   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
                this.template.querySelectorAll('[data-id="' +this.selectedValueList[i].value+ '"]').forEach(element => {
                    element.classList.remove('displayColumnCss'); //Contains HTML elements
                });
            }else if(!this.selectedValueList[i].selected){
                this.template.querySelectorAll('[data-id="' +this.selectedValueList[i].value+ '"]').forEach(element => {
                    element.classList.add('displayColumnCss'); //Contains HTML elements
                });
            }

        }
        this.SelectedColumnValue = JSON.stringify(this.selectedCols).replace('%','-@-').replace('+','--@@--');   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
    }

    handleChange(event) {
        var ischeck = event.target.checked;
        this.ischecked = ischeck;
        console.log('ischeck : ',ischeck);
        console.log('this.liquidation_data : ',this.liquidation_data);
        var temdata = [];
        console.log('this.year : ',this.year);
        console.log('this.quarter : ',this.quarter);

        if(this.year && this.quarter){
            this.getLiquidation(this.selectedAccountList1,this.year, this.quarter,this.selectedSkuList1,this.ischecked);
            /*this.liquidation_data_Updated.forEach(ele => {
                if(!ischeck){
                    temdata.push(ele);
                }else{
                    if(ele.Distributor_Inventory != '0' && ele.Distributor_Inventory !='' && ele.Distributor_Inventory != null){
                        temdata.push(ele);
                    } 
                }                   
            });
            console.log('temdata : ',temdata);
            this.liquidation_data = temdata;*/
        }        
    }

    getFiscalYearStart() {
        var fiscalyearStart = "";
        var today = new Date();
        
        if ((today.getMonth() + 1) <= 6) {
        fiscalyearStart = today.getFullYear() - 1;
        } else {
        fiscalyearStart = today.getFullYear()
        }
        console.log('-----fiscalyearStart---- '+fiscalyearStart);
        return fiscalyearStart;
    }

    getCurrentFiscalQuater(){
        var currentquater;
        console.log('this.Q1 : ',this.Q1);
        if(this.Q1.includes(new Date().getMonth())){
            currentquater = 'Quarter 4';
        }else if(this.Q2.includes(new Date().getMonth())){
            currentquater = 'Quarter 1';
        }else if(this.Q3.includes(new Date().getMonth())){
            currentquater = 'Quarter 2';
        }else if(this.Q4.includes(new Date().getMonth())){
            currentquater = 'Quarter 3';
        }

        return currentquater;
    }

    connectedCallback() {
        this.currentfiscalYear = this.getFiscalYearStart();
        this.currentfiscalQuarter = this.getCurrentFiscalQuater();
        console.log('this.currentfiscalYear',this.currentfiscalYear);
        console.log('this.currentfiscalQuarter',this.currentfiscalQuarter);

        CheckIsSubmitted({year: this.currentfiscalYear,quarter: this.currentfiscalQuarter}).then((result) => {
            console.log('CheckIsSubmitted==>',result);
            if(result){
                this.isLQUSubmitted = true;
            }else{
                this.isLQUSubmitted = false;
            }
          })
          .catch(error => {
            console.log('Error : ',error);
        });


        this.is_editable = true;
        this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.RecordType.Name='Distributor' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;

        this.quarterOption.unshift({ label: this.Quarter4, value: 'Quarter 4' });
        this.quarterOption.unshift({ label: this.Quarter3, value: 'Quarter 3' });
        this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2' });
        this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1' });
        this.quarterOption.unshift({ label: this.labels.None, value: '' });
        this.distributorName = All;
        console.log('this.distributorName==>'+this.distributorName == All);
        console.log('this.distributor==>'+this.distributor);
        console.log('this.year==>'+this.year);
        console.log('this.quarter==>'+this.quarter);
    }
   renderedCallback(){
       if(!this.labels.PolandEditProfile.includes(this.userRoleName)){
            this.disable_fields=true;
            this.disable_openingInventory=true;
            this.disable_submit_btn=true;
       }
       console.log('userRoleName==>',this.userRoleName);
       this.Sales_Org=this.labels.Grz_PolandSalesOrgCode;
       console.log('this.Sales_Org==>',this.Sales_Org);

       for(var i in this.selectedValueList){

            if(this.selectedValueList[i].selected){
                this.template.querySelectorAll('[data-id="' +this.selectedValueList[i].value+ '"]').forEach(element => {
                    element.classList.remove('displayColumnCss'); //Contains HTML elements
                });
            }else {
                this.template.querySelectorAll('[data-id="' +this.selectedValueList[i].value+ '"]').forEach(element => {
                    element.classList.add('displayColumnCss'); //Contains HTML elements
                });
            }
        }
   }
    @wire(getUserCountry)
    getUserCountry({ error, data }) {
        this.spinner = true;
        console.log('getUserCountry data ', data, ' Err ', error);
        if (data) {
            let user_country = data.toLocaleLowerCase();
            if (user_country == 'poland') {
                this.number_saperator_code = 'pl-PL';
            }  else {
                this.number_saperator_code = 'en-US';
            }
            this.spinner = false;
        }
        if (error) {
          //  this.user_country = '';
            this.spinner = false;
        }
    }

    @wire(checkPriceloaded,{year: "$currentfiscalYear"})
    checkPriceloaded({ error, data }) {
        if (data) {
            console.log('checkPriceloaded : ',data);
        }else{
            this.showToastmessage(this.labels.Warning,this.labels.WarningMessage,'warning');
        }
        if (error) {
          //  this.user_country = '';
        }
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

    handleOnfocus(){
        console.log('this.year in focus: '+this.year);
        console.log('this.isLQUSubmitted : '+this.isLQUSubmitted);

       // if(this.year == new Date().getFullYear() || this.year == new Date().getFullYear()-1) { // Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
            if(this.year == new Date().getFullYear()){ // Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
            if(this.Q4.includes(new Date().getMonth())){
                this.quarterOption = [];
                if(this.isLQUSubmitted){
                    this.quarterOption.unshift({ label: this.Quarter3, value: 'Quarter 3'});
                }
                this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2' });
                this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1' });
                this.quarterOption.unshift({ label: this.labels.None, value: '' });
            }else if(this.Q3.includes(new Date().getMonth())){
                this.quarterOption = [];
                if(this.isLQUSubmitted){
                    this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2'});
                }
                this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1' });
                this.quarterOption.unshift({ label: this.labels.None, value: '' });
            }else if(this.Q1.includes(new Date().getMonth())){
                this.quarterOption = [];
                if(this.isLQUSubmitted){
                    this.quarterOption.unshift({ label: this.Quarter4, value: 'Quarter 4'});
                }
                this.quarterOption.unshift({ label: this.Quarter3, value: 'Quarter 3' });
                this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2' });
                this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1' });
                this.quarterOption.unshift({ label: this.labels.None, value: '' });
            }else if(this.Q2.includes(new Date().getMonth())){
                this.quarterOption = [];
                if(this.isLQUSubmitted && this.year == new Date().getFullYear()){
                    this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1'});
                }else if(this.year == new Date().getFullYear()-1){
                this.quarterOption.unshift({ label: this.Quarter4, value: 'Quarter 4' });
                this.quarterOption.unshift({ label: this.Quarter3, value: 'Quarter 3' });
                this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2' });
                this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1'});
                }
                this.quarterOption.unshift({ label: this.labels.None, value: '' });
            }
        }
        else{
            console.log('in else if focus');
            if(parseInt(this.year) + 1 == new Date().getFullYear()){
                if(this.Q1.includes(new Date().getMonth())){
                    console.log('in 1st if focus');
                    this.quarterOption = [];
                    if(this.isLQUSubmitted){
                        this.quarterOption.unshift({ label: this.Quarter4, value: 'Quarter 4'});
                    }
                    this.quarterOption.unshift({ label: this.Quarter3, value: 'Quarter 3' });
                    this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2' });
                    this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1' });
                    this.quarterOption.unshift({ label: this.labels.None, value: '' });
                }
                else{                                             // Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
                    console.log('in edefault');
                this.quarterOption = [];// Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
                this.quarterOption.unshift({ label: this.Quarter4, value: 'Quarter 4' });// Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
                this.quarterOption.unshift({ label: this.Quarter3, value: 'Quarter 3' });// Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
                this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2' });// Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
                this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1' });// Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
                this.quarterOption.unshift({ label: this.labels.None, value: '' });// Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
                }// Updated for INC0413721 GRZ(Dheeraj Sharma) 22-11-2022
            }else{
                console.log('in edefault');
                this.quarterOption = [];
                this.quarterOption.unshift({ label: this.Quarter4, value: 'Quarter 4' });
                this.quarterOption.unshift({ label: this.Quarter3, value: 'Quarter 3' });
                this.quarterOption.unshift({ label: this.Quarter2, value: 'Quarter 2' });
                this.quarterOption.unshift({ label: this.Quarter1, value: 'Quarter 1' });
                this.quarterOption.unshift({ label: this.labels.None, value: '' });
            }
                
        }
    }

    handleChangeYear(event){
        this.year = event.detail.value;
        let checkboxes = this.template.querySelector('[data-id="checkbox"]');
        checkboxes.checked = true;
        this.ischecked = true;
        
        this.selected_year = event.target.options.find(opt => opt.value.split('-')[0] === event.detail.value).label;
        console.log('this.selected_year==>',this.selected_year);
        if(this.year == new Date().getFullYear() || this.year == new Date().getFullYear()-1){
            this.quarter = '';
        }
        this.spinner = true;
        if(this.year!=''){
            this.disable_quarter=false;
        }
        else{
            this.disable_quarter=true;
        }
        console.log('this.distributorName==>'+this.distributorName==this.labels.All);
        console.log('this.distributor==>'+this.distributor);
        console.log('this.year==>'+this.year);
        console.log('this.quarter==>'+this.quarter);
        if ( this.year != '' && this.quarter != ''){
            this.getLiquidation(this.selectedAccountList1,this.year, this.quarter,this.selectedSkuList1,this.ischecked);
            // setTimeout(() => {
            //     this.getLiquidation( this.distributor,this.distributorName, this.year, this.quarter);
            //     this.spinner = false;
            // }, 2000);
        }
        else{
            this.liquidation_data=[];
            this.spinner = false;
        }
        //this.spinner = false;
    }

    handleChangeQuarter(event){
        this.quarter = event.detail.value;
        this.spinner = true;
        let checkboxes = this.template.querySelector('[data-id="checkbox"]');
        checkboxes.checked = true;
        console.log('this.selectedAccountList1==>'+this.selectedAccountList1);
        console.log('this.year==>'+this.year);
        console.log('this.quarter==>'+this.quarter);
        if (this.year != '' && this.quarter != ''){
            this.getLiquidation(this.selectedAccountList1,this.year, this.quarter,this.selectedSkuList1,this.ischecked);
            // setTimeout(() => {
            //     this.getLiquidation( this.distributor,this.distributorName, this.year, this.quarter);
            //     this.spinner = false;
            // }, 2000);
        }
        else{
            this.liquidation_data=[];
            this.spinner = false;
        }
       // this.spinner = false;
        
    }

    @wire(getObjectInfo, { objectApiName: object_liquidationAnnualPlan })
    getRecordtype({ error, data }) {
        this.spinner = true;
        console.log('Record type ', data, 'Record Type ERR ', error)
        if (data) {
            console.log('Record type ', data);
            let rtis = data.recordTypeInfos;
            this.record_type = Object.keys(rtis).find(rti => rtis[rti].name === 'Multi Country');
            console.log('Record type Multi country ', this.record_type);
            this.spinner = false;
        }
        if (error) {
            console.log('Record Type ERR ', error);
            this.spinner = false;
        }
        this.spinner = false;
    }

    @wire(getPicklistValues, { recordTypeId: '$record_type', fieldApiName: FIscal_Year__c })
    TypePicklistValues_city({ data, error }) {
        this.yearOption = [];
        this.yearOptionRemoveCurrent = [];
        if (data) {
            var flag = false;
            console.log('Year options ', data.values);
            data.values.forEach(element => {
                this.yearOption = [...this.yearOption, { label: element.value, value: element.value.split('-')[0] }];
              
                if (element.value.split('-')[0] == new Date().getFullYear() || element.value.split('-')[0] == new Date().getFullYear()-1) {
                    console.log('inside set year');
                    console.log('Current Month : ',new Date().getMonth());
                    if(element.value.split('-')[1] == new Date().getFullYear()+1 && this.Q1.includes(new Date().getMonth())){
                        console.log('this.year in if[1] : '+this.year);
                    }else{
                        this.year = element.value.split('-')[0];
                        console.log('this.year : '+this.year);
                        this.selected_year = element.value;
                        console.log('this.selected_year : ',this.selected_year);
                    }
                }
                else{
                    //this.yearOptionRemoveCurrent = [...this.yearOptionRemoveCurrent, { label: element.value, value: element.value.split('-')[0] }];
                    //console.log('this.yearOptionRemoveCurrent 1 : ',this.yearOptionRemoveCurrent);
                }

                if((element.value.split('-')[1] == new Date().getFullYear()+1 && this.Q1.includes(new Date().getMonth())) && (element.value.split('-')[0] == new Date().getFullYear() || element.value.split('-')[0] == new Date().getFullYear()-1)){
                    console.log('Current Fiscal Year Q1',element.value);
                    flag = true;
                }else{
                    this.yearOptionRemoveCurrent = [...this.yearOptionRemoveCurrent, { label: element.value, value: element.value.split('-')[0] }];
                    console.log('this.yearOptionRemoveCurrent 2 : ',this.yearOptionRemoveCurrent);
                }

            });
            this.yearOptionRemoveCurrent.unshift({ label: this.labels.None, value: '' });
            this.yearOption.unshift({ label: this.labels.None, value: '' });

            if(!flag){
                this.yearOptionRemoveCurrent = this.yearOption;
            }
            console.log('this.yearOption : ',this.yearOptionRemoveCurrent);

            if(this.year!='')
            {
                this.disable_quarter=false;
            }
        }
        if (error) {
            console.log('error ', error);
        }
    };

    @track columns = [
        { Id: 1, label: this.labels.Brand, fieldName: 'Brand', type: 'text', initialWidth: 100, sortable: true },
        { Id: 2, label: this.labels.Opening_Inventory, fieldName: 'Opening_inventory', type: 'text', initialWidth: 180, editable: this.is_editable, largewidth: true },
        { Id: 3, label: this.labels.OpeningInventoryPLN, fieldName: 'OpeningInventoryPLN', type: 'text', initialWidth: 180, editable: this.is_editable, largewidth: true },
        { Id: 4, label: this.labels.ytd_sales, fieldName: 'YTD_sales', type: 'text', initialWidth: 280 },
        { Id: 5, label: this.labels.YTD_SalesPLN, fieldName: 'YTD_SalesPLN', type: 'text', initialWidth: 280 },
        { Id: 6, label: this.labels.Total_Available_Stock, fieldName: 'Total_Available_Stock', type: 'text', initialWidth: 200, sortable: true },
        { Id: 7, label: this.labels.TotalAvailableStockPLN, fieldName: 'TotalAvailableStockPLN', type: 'text', initialWidth: 200},
        { Id: 8, label: this.labels.Distributor_Inventory, fieldName: 'Distributor_Inventory', type: 'text', initialWidth: 125, editable: this.is_editable },
        { Id: 9, label: this.labels.DistributorInventoryPLN, fieldName: 'DistributorInventoryPLN', type: 'text', initialWidth: 125, editable: this.is_editable },
        //{ Id: 8, label: this.labels.Plan_YTD_Quarter, fieldName: 'Plan_for_the_Quarter', type: 'text', initialWidth: 150 },
        { Id: 10, label: this.labels.Liquidation_YTD_Selected_Quarter, fieldName: 'Liquidation_YTD', type: 'text', initialWidth: 280 },
        { Id: 11, label: this.labels.Liquidation_YTDSelectedQuarterPLN, fieldName: 'Liquidation_YTD_PLN', type: 'text', initialWidth: 280 },
        { Id: 12, label: this.labels.Liquidation_YTD_Selected_Quarter_Percent, fieldName: 'Liquidation_percentage_YTD', type: 'text', initialWidth: 280, sortable: true },
        //{ Id: 11, label: this.labels.Plan_for_Next_Quarter, fieldName: 'Plan_for_the_Next_Quarter', type: 'text', initialWidth: 200, editable: this.is_editable }
    ];

    getLiquidation(t_distributor, t_year, t_quarter, selectedSkuList,ischeckDisInventory) {
        this.spinner = true;
        this.liquidation_data = [];
        this.liquidation_to_submit = [];
        
        console.log('number_saperator_code==>'+this.number_saperator_code);
        if (t_year != '' && t_quarter != '') {
            
            getPOGLiquidationReportDataBrand({ distributor: t_distributor, year: t_year, quarter: t_quarter,brandList: selectedSkuList,excludeDisInventory: ischeckDisInventory}).then(data => {

                console.log('Liquidation data', data);
                let temp = [];
                let temp_for_submit = [];
                data.forEach(element => {
                    temp.push({
                        'Id': element.Brand,
                        //'Month__c': element.Month__c !== undefined ? element.Month__c : '',
                        'Brand': element.Brand !== undefined ? element.Brand : '',
                        //'SKU_Code': element.SKU_Code !== undefined ? element.SKU_Code * 1 : '',
                       // 'SKU_Description': element.SKU_Description !== undefined ? element.SKU_Description : '',
                        //'Opening_inventoryId': element.Opening_Inventory2__c !== undefined ? element.Opening_Inventory2__c : '',
                        'Opening_inventoryId': element.SKU_Code !== undefined ? element.SKU_Code : '',
                        'Opening_inventory': element.Opening_inventory !== undefined ? element.Opening_inventory : '',
                        'OpeningInventoryPLN': element.Opening_inventory_PLN !== undefined ? element.Opening_inventory_PLN : '',                       
                        'YTD_sales': element.YTD_sales !== undefined ? element.YTD_sales : '',
                        'YTD_SalesPLN': element.YTD_sales_PLN !== undefined ? element.YTD_sales_PLN : '',
                        'Total_Available_Stock': element.Total_Available_Stock !== undefined ? element.Total_Available_Stock : '',
                        'TotalAvailableStockPLN': element.Total_Available_Stock_PLN !== undefined ? element.Total_Available_Stock_PLN : '',
                        'Distributor_Inventory': element.Distributor_Inventory !== undefined ? element.Distributor_Inventory : '',
                        'DistributorInventoryPLN': element.Distributor_Inventory_PLN !== undefined ? element.Distributor_Inventory_PLN : '',
                        'Liquidation_YTD': element.Liquidation_YTD !== undefined ? element.Liquidation_YTD : '',
                        'Liquidation_YTD_PLN': element.Liquidation_PLN !== undefined ? element.Liquidation_PLN : '',
                        'Liquidation_percentage_YTD': element.Liquidation_YTD_per_plan_YTD !== undefined ? Number(element.Liquidation_YTD_per_plan_YTD) + ' %' : '0 %',
                    })
                    temp_for_submit.push(element.Id);
                });
                
                this.liquidation_data = temp;
                /*this.liquidation_data_Updated = temp;
                var temdata = [];
                this.liquidation_data_Updated.forEach(ele => {
                    if(!this.ischecked){
                        temdata.push(ele);
                    }else{
                        if(ele.Distributor_Inventory != '0' && ele.Distributor_Inventory !='' && ele.Distributor_Inventory != null){
                            temdata.push(ele);
                        } 
                    }                   
                });
                this.liquidation_data = temdata;*/

                console.log('liquidation_data==>',this.liquidation_data);
                this.search_data = temp;
                this.search_str = '';
                this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
                this.spinner = false;
                this.isVisiblePDFandXLS = this.liquidation_found;
                
                // this.pogPDFUrl = '/apex/Grz_LiquidationBrandPolandPDF?distributor='+ t_distributor
                // +'&year='+t_year+'&quarter='+t_quarter+'&brandList='+selectedSkuList+'&excludezero='+this.ischecked;
                // console.log('this.pogPDFUrl : '+this.pogPDFUrl);

                // this.pogXLSUrl = '/apex/Grz_LiquidationBrandPolandXLS?distributor='+ t_distributor
                // +'&year='+t_year+'&quarter='+t_quarter+'&brandList='+selectedSkuList+'&excludezero='+this.ischecked;

            }).catch(err => {
                console.log('Err ', err);
                this.spinner = false;
            });
        } 

    }

    handlesortData(event) {
        let fieldname = event.target.dataset.fieldname;
        console.log('fiels name', fieldname);
        let str = '';
        if (fieldname == 'Brand') {
            this.brand_sortDirection = !this.brand_sortDirection;
            str = this.brand_sortDirection == true ? 'asc' : 'des';
        }
        if (fieldname == 'SKU_Code') {
            this.SKU_Code_sortDirection = !this.SKU_Code_sortDirection;
            str = this.SKU_Code_sortDirection == true ? 'asc' : 'des';
        }
        if (fieldname == 'SKU_Description') {
            this.SKU_Description_sortDirection = !this.SKU_Description_sortDirection;
            str = this.SKU_Description_sortDirection == true ? 'asc' : 'des';
        }
        if (fieldname == 'Total_Available_Stock') {
            this.Total_Available_Stock_sortDirection = !this.Total_Available_Stock_sortDirection;
            str = this.Total_Available_Stock_sortDirection == true ? 'asc' : 'des';
        }
        if (fieldname == 'Liquidation_percentage_YTD') {
            this.Liquidation_percentage_YTD_sortDirection = !this.Liquidation_percentage_YTD_sortDirection;
            str = this.Liquidation_percentage_YTD_sortDirection == true ? 'asc' : 'des';
        }
        this.sortData(fieldname, str);
        if (fieldname == 'Liquidation_percentage_YTD') {
            this.search_data = [];
            this.liquidation_data.forEach(ele => {
                ele.Liquidation_percentage_YTD = ele.Liquidation_percentage_YTD + ' %';
                this.search_data.push(ele);
                console.log('liquidation ele ', ele);
            });
            this.liquidation_data = this.search_data;
        }
        if (fieldname == 'Total_Available_Stock') {
            this.search_data = [];
            this.liquidation_data.forEach(ele => {
                var num = ele.Total_Available_Stock;
                ele.Total_Available_Stock = num !== undefined ? num.toLocaleString(this.number_saperator_code) : '';
                this.search_data.push(ele);
                console.log('Total_Available_Stock ele ', ele);
            });
            this.liquidation_data = this.search_data;
        }
        console.log('sort data ->', JSON.parse(JSON.stringify(this.liquidation_data)));
    }

    
    sortData(fieldName, sortDirection) {
        if (fieldName == 'Liquidation_percentage_YTD') {
            this.search_data = [];
            this.liquidation_data.forEach(ele => {
                ele.Liquidation_percentage_YTD = parseFloat(ele.Liquidation_percentage_YTD.replace(' %', ''));
                this.search_data.push(ele);
                console.log('liquidation ele ', ele);
            });
            this.liquidation_data = this.search_data;
        }

        if (fieldName == 'Total_Available_Stock') {
            this.search_data = [];
            this.liquidation_data.forEach(ele => {
                var num = ele.Total_Available_Stock.toString();
                num = num.replace(/\s/g, '');
                ele.Total_Available_Stock = parseInt(num);
                this.search_data.push(ele);
                console.log('Total_Available_Stock ele ', ele);
            });
            this.liquidation_data = this.search_data;
        }
        
        console.log('sort search', this.search_data);
        console.log('sort liq ', this.liquidation_data);
        let sortResult = Object.assign([], this.liquidation_data);
        this.liquidation_data = sortResult.sort(function (a, b) {
            if (a[fieldName] < b[fieldName])
                return sortDirection === 'asc' ? parseInt("-1") : 1;
            else if (a[fieldName] > b[fieldName])
                return sortDirection === 'asc' ? 1 : parseInt("-1");
            else
                return 0;
        });
    }

    handlesearch(event) {
        //this.spinner = true;
        /*let checkboxes = this.template.querySelector('[data-id="checkbox"]');
        if(event.target.value == ""){
            checkboxes.checked = true;
        }else{
            checkboxes.checked = false;
        }*/
        
        clearTimeout(this.timeoutId);
        var theEvent1 = event || window.event;
        var key1 = theEvent1.keyCode || theEvent1.which;
        console.log('key code ', key1);
        key1 = String.fromCharCode(key1);
        console.log('key code ', key1);
        if (key1 == 8 || key1 == 46) {
            console.log('handle backspace');
            this.flag_search = false;
        }
        this.timeoutId = setTimeout(this.doActionSearch.bind(this, event.target), 1000);
    }

    doActionSearch(target) {
        console.log('Search str ', target.value);
        this.search_str = target.value;
        this.spinner = true;
        if (this.search_str != '') {
            setTimeout(() => {
                this.liquidation_data = this.serachInlist(this.search_str);
                this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
                this.spinner = false;
            }, 500);
        } else {
            setTimeout(() => {
                this.getLiquidation(this.selectedAccountList1,this.year, this.quarter,this.selectedSkuList1,this.ischecked);
                this.flag_search = false;
                this.spinner = false;
            }, 2000);
            // this.liquidation_data = this.search_data;
            //this.spinner = false;
        }
    }

    serachInlist(str) {
        let templiq = [];
        this.search_data.forEach(element => {
            element = JSON.parse(JSON.stringify(element));
            // console.log('element ',element.SKU_Description);
            if (String(element.SKU_Description).toLowerCase().includes(str.toLowerCase())) {
                let temp = templiq.find(ele => ele.Id == element.Id);
                console.log('temp find -->', temp);
                if (!temp) {
                    console.log('push ele desc');
                    templiq.push(element);
                }
            }
            if (String(element.Brand).toLowerCase().includes(str.toLowerCase())) {
                let temp = templiq.find(ele => ele.Id == element.Id);
                console.log('temp find -->', temp);
                if (!temp) {
                    console.log('push ele brand');
                    templiq.push(element);
                }
            }
            if (String(element.SKU_Code).toLowerCase().includes(str.toLowerCase())) {
                let temp = templiq.find(ele => ele.Id == element.Id);
                console.log('temp find -->', temp);
                if (!temp) {
                    console.log('push ele sku');
                    templiq.push(element);
                }
            }
        });
        return templiq;
    }
    downloadPDF() {
        this.pogPDFUrl = '/apex/Grz_LiquidationBrandPolandPDF?distributor='+ this.selectedAccountList1
        +'&year='+this.year+'&quarter='+this.quarter+'&brandList='+this.selectedSkuList1+'&excludezero='+this.ischecked+'&selectedColumn='+ this.SelectedColumnValue+'&search='+this.search_str;   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
        console.log('this.pogPDFUrl : '+this.pogPDFUrl);
        window.open(this.pogPDFUrl, '_blank');
        setTimeout(() => {
        this.spinner = false;
        }, 4000);
        
    }

    downloadXLS() {
        this.pogXLSUrl = '/apex/Grz_LiquidationBrandPolandXLS?distributor='+ this.selectedAccountList1
        +'&year='+this.year+'&quarter='+this.quarter+'&brandList='+this.selectedSkuList1+'&excludezero='+this.ischecked+'&selectedColumn='+ this.SelectedColumnValue+'&search='+this.search_str;   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
        this.spinner = true;
        const downloadLink = document.createElement("a");
        downloadLink.href = this.pogXLSUrl;
        downloadLink.target = '_new';
        downloadLink.download = 'POGReport.xls';
        downloadLink.click();
        setTimeout(() => {
        this.spinner = false;
        }, 4000);
    }
}