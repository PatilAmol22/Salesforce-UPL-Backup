import { LightningElement, track, wire } from 'lwc';
import Liquidation_title from '@salesforce/label/c.Liquidation_title';
import Year from '@salesforce/label/c.Year';
import Select_Year from '@salesforce/label/c.Select_Year';
import Quarter from '@salesforce/label/c.Quarter';
import Select_Quarter from '@salesforce/label/c.Select_Quarter';
import All from '@salesforce/label/c.All';
import None from '@salesforce/label/c.None';
import Distributor from '@salesforce/label/c.Distributor';
import no_data from '@salesforce/label/c.No_liquidation_found';
import Brand from '@salesforce/label/c.Brand';
import SKU_Code from '@salesforce/label/c.SKU_Code';
import SKU_Description from '@salesforce/label/c.SKU_Description';
import Opening_Inventory from '@salesforce/label/c.Opening_Inventory';
import ytd_sales from '@salesforce/label/c.YTD_sales';
import Total_Available_Stock from '@salesforce/label/c.Total_Available_Stock';
import Distributor_Inventory from '@salesforce/label/c.Distributor_Inventory';
import Plan_YTD_Quarter from '@salesforce/label/c.Plan_YTD_Quarter';
import Liquidation_YTD_Selected_Quarter from '@salesforce/label/c.Liquidation_YTD_Selected_Quarter';
import Liquidation_YTD_Selected_Quarter_Percent from '@salesforce/label/c.Liquidation_YTD_Selected_Quarter_Percent';
import Plan_for_Next_Quarter from '@salesforce/label/c.Plan_for_Next_Quarter';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import object_liquidationAnnualPlan from '@salesforce/schema/Liquidation_Annual_Plan__c';
import FIscal_Year__c from '@salesforce/schema/Liquidation_Annual_Plan__c.FIscal_Year__c';
import getLiquidationData from '@salesforce/apex/Grz_PolandLiquidation.getLiquidationData';
import Distributor_inventory_field from '@salesforce/schema/Liquidation2__c.Distributors_Inventory__c';
import Plan_for_the_Next_Quarter_field from '@salesforce/schema/Liquidation2__c.Plan_for_the_Next_Quarter__c';
import loading_data from '@salesforce/label/c.Loading';
import LANG from "@salesforce/i18n/lang";
import Search from '@salesforce/label/c.Search';
import getLiquidationEditDates from '@salesforce/apex/Grz_PolandLiquidation.getLiquidationEditDates';
import getOpeningInventoryEditDates from '@salesforce/apex/Grz_PolandLiquidation.getOpeningInventoryEditDates';
import toast_err from '@salesforce/label/c.Error';
import Distributor_inventory_validation from '@salesforce/label/c.Distributor_inventory_validation';
import valid_value from '@salesforce/label/c.valid_value';
import updateOpeningInventory from '@salesforce/apex/Grz_PolandLiquidation.updateOpeningInventory';
import saveLiquidation from '@salesforce/apex/Grz_PolandLiquidation.saveLiquidation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserCountry from '@salesforce/apex/Grz_PolandLiquidation.getUserCountry';
import updatePlanForQuarter from '@salesforce/apex/Grz_PolandLiquidation.updatePlanForQuarter';
import Submit from '@salesforce/label/c.Poland_Submit';
import submitLiquidation from '@salesforce/apex/Grz_PolandLiquidation.submitLiquidation';
import Upload_Opening_Inventory from '@salesforce/label/c.Upload_Opening_Inventory';
import Upload_Liquidation from '@salesforce/label/c.Upload_Liquidation';
import Liquidation_submitted_Successfully from '@salesforce/label/c.Liquidation_submitted_Successfully';
import Error_while_submitting_Liquidation from '@salesforce/label/c.Error_while_submitting_Liquidation';
import getUserRole from '@salesforce/apex/Grz_PolandLiquidation.getUserRole';
import toast_success from '@salesforce/label/c.Success';
import PolandEditProfile from '@salesforce/label/c.PolandEditProfile';
import Grz_PolandSalesOrgCode from '@salesforce/label/c.Grz_PolandSalesOrgCode';
import Select_Year_and_Quarter from '@salesforce/label/c.Select_Year_and_Quarter';
import Select_Year_value from '@salesforce/label/c.Select_Year_value';
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD"; /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS"; /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
import Icons from "@salesforce/resourceUrl/Grz_Resourse"; /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
export default class Grz_LiquidationPoland extends LightningElement {
    @track labels = { All: All, None: None };
    @track year = '';
    @track quarter = '';
    @track yearOption = [{ label: this.labels.None, value: '' }];          // label:name value:Id
    @track quarterOption = [];
    @track distributor_filter = '';
    @track distributor = '';
    @track distributorName = '';
    @track liquidation_found = true;
    @track liquidation_data = [];
    @track disable_year = false;
    @track disable_quarter = true;
    @track record_type = '';
    @track number_saperator_code = 'pl-PL';
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
    @track is_submitted = false;
    @track is_active_liquidation = false;
    @track is_active_openingInv = false;
    @track userRoleName = '';
    @track openModel = false;
    @track openModelOI = false;
    @track Sales_Org = '';
    @track selected_year = '';
    @track sales_district = 'poland';
    @track quarterPolish = '';
    @track isSingleAccount = false;
    @track Quarter1 = 'I kwartał kwiecień-czerwiec';
    @track Quarter2 = 'II kwartał lipiec-wrzesień';
    @track Quarter3 = 'III kwartał październik-grudzień';
    @track Quarter4 = 'IV kwartał styczeń-marzec';
    @track pogPDFUrl = ''; /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */



    downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png"; /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
    labels = {
        Liquidation_title: Liquidation_title,
        Year: Year,
        Select_Year: Select_Year,
        Quarter: Quarter,
        Select_Quarter: Select_Quarter,
        Distributor: Distributor,
        no_data: no_data,
        Brand: Brand,
        SKU_Code: SKU_Code,
        SKU_Description: SKU_Description,
        Opening_Inventory: Opening_Inventory,
        ytd_sales: ytd_sales,
        Total_Available_Stock: Total_Available_Stock,
        Distributor_Inventory: Distributor_Inventory,
        Plan_YTD_Quarter: Plan_YTD_Quarter,
        Liquidation_YTD_Selected_Quarter: Liquidation_YTD_Selected_Quarter,
        Liquidation_YTD_Selected_Quarter_Percent: Liquidation_YTD_Selected_Quarter_Percent,
        Plan_for_Next_Quarter: Plan_for_Next_Quarter,
        None: None,
        loading: loading_data,
        Search: Search,
        toast_err: toast_err,
        toast_success: toast_success,
        Distributor_inventory_validation: Distributor_inventory_validation,
        valid_value: valid_value,
        Submit: Submit,
        Upload_Opening_Inventory: Upload_Opening_Inventory,
        Upload_Liquidation: Upload_Liquidation,
        Liquidation_submitted_Successfully: Liquidation_submitted_Successfully,
        Error_while_submitting_Liquidation: Error_while_submitting_Liquidation,
        PolandEditProfile: PolandEditProfile,
        Grz_PolandSalesOrgCode: Grz_PolandSalesOrgCode,
        Select_Year_and_Quarter: Select_Year_and_Quarter,
        Select_Year_value: Select_Year_value,
        DownloadPDF: DownloadPDF,   /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
        DownloadXLS: DownloadXLS    /* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
    }
    @track fieldsapiname = {
        'Opening_inventory': 'Opening_Inventory2__c',
        'Distributor_inventory': Distributor_inventory_field.fieldApiName,
        'Plan_for_the_Next_Quarter': Plan_for_the_Next_Quarter_field.fieldApiName,
    }
    connectedCallback() {
        this.is_editable = true;
        this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.RecordType.Name='Distributor' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;

        // this.quarterOption.unshift({ label: 'IV kwartał październik-grudzień', value: 'Quarter 4' });
        // this.quarterOption.unshift({ label: 'III kwartał lipiec-wrzesień', value: 'Quarter 3' });
        // this.quarterOption.unshift({ label: 'II kwartał kwiecień-czerwiec', value: 'Quarter 2' });
        // this.quarterOption.unshift({ label: 'I kwartał styczeń-marzec', value: 'Quarter 1' });
        //this.quarterOption.unshift({ label: this.labels.None, value: '' });
        this.distributorName = All;
        console.log('this.distributorName==>' + this.distributorName == All);
        console.log('this.distributor==>' + this.distributor);
        console.log('this.year==>' + this.year);
        console.log('this.quarter==>' + this.quarter);
    }
    renderedCallback() {
        if (!this.labels.PolandEditProfile.includes(this.userRoleName)) {
            this.disable_fields = true;
            this.disable_openingInventory = true;
            this.disable_submit_btn = true;
        }
        console.log('userRoleName==>', this.userRoleName);
        this.Sales_Org = this.labels.Grz_PolandSalesOrgCode;
        console.log('this.Sales_Org==>', this.Sales_Org);
    }
    @wire(getUserCountry)
    getUserCountry({ error, data }) {
        this.spinner = true;
        console.log('getUserCountry data ', data, ' Err ', error);
        if (data) {
            let user_country = data.toLocaleLowerCase();
            if (user_country == 'poland') {
                this.number_saperator_code = 'pl-PL';
            } else {
                this.number_saperator_code = 'en-US';
            }
            this.spinner = false;
        }
        if (error) {
            //  this.user_country = '';
            this.spinner = false;
        }
    }
    @wire(getUserRole)
    userRole({ error, data }) {
        this.spinner = true;
        console.log('userProfile data ', data, ' Err ', error);
        if (data) {
            this.userRoleName = data;
            this.spinner = false;
        }
        if (error) {
            this.userRoleName = '';
            this.spinner = false;
        }
    }
    @wire(getLiquidationEditDates)
    getLiquidationDate({ error, data }) {
        this.spinner = true;
        console.log('Error ', error, 'Data', data);
        if (data == false) {
            this.spinner = false;
            this.disable_fields = true;
            //this.disable_submit_btn=true;
            this.is_active_liquidation = false;
            console.log('multi country setting', data);
        }
        else if (data == true) {
            this.spinner = false;
            this.disable_fields = false;
            //this.disable_submit_btn=false;
            this.is_active_liquidation = true;
            console.log('multi country setting', data);
        }
        if (error) {
            console.log('getLiquidationDate ', error);
            this.spinner = false;
        }
    }
    @wire(getOpeningInventoryEditDates)
    getOpeningInventoryDate({ error, data }) {
        this.spinner = true;
        console.log('getOpeningInventoryDate Error ', error, 'getOpeningInventoryDate Data', data);
        if (data == false) {
            this.spinner = false;
            this.disable_openingInventory = true;
            this.is_active_openingInv = false;
            console.log('getOpeningInventoryDate multi country setting', data);
        }
        else if (data == true) {
            this.spinner = false;
            this.disable_openingInventory = false;
            this.is_active_openingInv = true;
            console.log('getOpeningInventoryDate multi country setting', data);
        }
        if (error) {
            console.log('getOpeningInventoryDate ', error);
            this.spinner = false;
        }
    }
    handleChangeYear(event) {
        this.year = event.detail.value;
        this.selected_year = event.target.options.find(opt => opt.value.split('-')[0] === event.detail.value).label;
        console.log('this.selected_year==>', this.selected_year);
        this.spinner = true;
        if (this.year != '') {
            this.disable_quarter = false;
        }
        else {
            this.disable_quarter = true;
        }
        console.log('this.distributorName==>' + this.distributorName == this.labels.All);
        console.log('this.distributor==>' + this.distributor);
        console.log('this.year==>' + this.year);
        console.log('this.quarter==>' + this.quarter);
        if ((this.distributor != '' || this.distributorName == All) && this.year != '' && this.quarter != '') {
            setTimeout(() => {
                this.getLiquidation(this.distributor, this.distributorName, this.year, this.quarter);
                this.spinner = false;
            }, 2000);
        }
        else {
            this.liquidation_data = [];
            this.spinner = false;
        }
        //this.spinner = false;
    }
    handleChangeQuarter(event) {
        this.quarter = event.detail.value;
        this.spinner = true;
        console.log('this.distributor==>' + this.distributor);
        console.log('this.year==>' + this.year);
        console.log('this.quarter==>' + this.quarter);
        if ((this.distributor != '' || this.distributorName == All) && this.year != '' && this.quarter != '') {
            setTimeout(() => {
                this.getLiquidation(this.distributor,this.distributorName, this.year, this.quarter);
                this.spinner = false;
            }, 2000);
        }
        else {
            this.liquidation_data = [];
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
        if (data) {
            console.log('Year options ', data.values);
            data.values.forEach(element => {
                //this.yearOption = [...this.yearOption, { label: element.value, value: element.value.split('-')[0] }];

                // if (element.value.split('-')[0] == new Date().getFullYear() || element.value.split('-')[0] == new Date().getFullYear()-1) {
                //     console.log('inside set year');
                if (element.value.split('-')[0] == new Date().getFullYear() - 1 || element.value.split('-')[0] == new Date().getFullYear()) {
                    if (new Date().getMonth() >= 3 && new Date().getMonth() <= 5) {
                        let a = element.value.split('-')[0] - 1;
                        let b = element.value.split('-')[1] - 1;
                        this.yearOption.push({ label: String.valueOf(a) + String.valueOf(b), value: String.valueOf(a) });
                        //this.year = String.valueOf(a);
                        //this.year = element.value.split('-')[0];  // commented by sumit
                        //console.log('String.valueOf(a) : ',a.toString());
                        //this.selected_year = String.valueOf(a)+String.valueOf(b);
                        //this.selected_year = element.value;     // commented by sumit
                        if (element.value.split('-')[1] == new Date().getFullYear() + 1) {
                            console.log('this.year in if[1] : ' + this.year);
                        } else {
                            this.year = element.value.split('-')[0];
                            console.log('this.year in else : ' + this.year);
                            this.selected_year = element.value;
                            console.log('this.selected_year in else : ', this.selected_year);
                        }

                        console.log('this.selected_year = ', this.selected_year);
                        this.quarterOption.push({ label: this.Quarter4, value: 'Quarter 4' });
                        this.quarter = 'Quarter 4';
                        this.quarterPolish = this.Quarter4;
                    }
                    else {
                        this.yearOption.push({ label: element.value, value: element.value.split('-')[0] });
                        this.year = element.value.split('-')[0];
                        this.selected_year = element.value;
                        if (new Date().getMonth() >= 0 && new Date().getMonth() <= 2) {
                            this.quarterOption.push({ label: this.Quarter3, value: 'Quarter 3' });
                            this.quarter = 'Quarter 3';
                            this.quarterPolish = this.Quarter3;
                        }
                        else if (new Date().getMonth() >= 6 && new Date().getMonth() <= 8) {
                            this.quarterOption.push({ label: this.Quarter1, value: 'Quarter 1' });
                            this.quarter = 'Quarter 1';
                            this.quarterPolish = this.Quarter1;
                        }
                        else if (new Date().getMonth() >= 9 && new Date().getMonth() <= 11) {
                            this.quarterOption.push({ label: this.Quarter2, value: 'Quarter 2' });
                            this.quarter = 'Quarter 2';
                            this.quarterPolish = this.Quarter2;
                        }
                    }
                    console.log('this.quarterOption==>', this.quarterOption);
                }


                //}

            });
            console.log("2");
            this.yearOption.unshift({ label: this.labels.None, value: '' });
            if (this.year != '') {
                this.disable_quarter = false;
            }
            if ((this.distributor != '' || this.distributorName == All) && this.year != '' && this.quarter != '') {
                setTimeout(() => {
                    this.getLiquidation(this.distributor, this.distributorName, this.year, this.quarter);
                    this.spinner = false;
                }, 2000);
            }
        }
        if (error) {
            console.log('error ', error);
        }
    };
    handleChangeDistributor(event) {//Edit
        console.log('event==>', event.detail.recName);
        this.spinner = true;
        this.distributor = event.detail.recId;
        this.distributorName = event.detail.recName;
        this.disable_year = false;
        if (this.year != '')
            this.disable_quarter = false;
        else
            this.disable_quarter = true;
        console.log('this.distributorName==>' + this.distributorName == All);
        console.log('this.distributor==>' + this.distributor);
        console.log('this.year==>' + this.year);
        console.log('this.quarter==>' + this.quarter);
        if (this.distributorName == All || this.isSingleAccount == true) {
            if (this.disable_fields == false) {
                this.disable_submit_btn = false;
            }
        }
        else {
            this.disable_submit_btn = true;
        }
        if ((this.distributor != '' || this.distributorName == All) && this.year != '' && this.quarter != '') {
            setTimeout(() => {
                this.getLiquidation(this.distributor, this.distributorName, this.year, this.quarter);
                this.spinner = false;
            }, 2000);
        }
        this.spinner = false;

    }
    handleRemoveDistributor() {
        this.distributor = '';
        this.distributorName = '';
        this.disable_year = true;
        // this.year='';
        this.disable_quarter = true;
        this.liquidation_data = [];
        this.disable_submit_btn = true;
        //this.search_str='';
    }
    @track columns = [
        { Id: 1, label: this.labels.Brand, fieldName: 'Brand', type: 'text', initialWidth: 100, sortable: true },
        { Id: 2, label: this.labels.SKU_Code, fieldName: 'SKU_Code', type: 'text', initialWidth: 120, sortable: true },
        { Id: 3, label: this.labels.SKU_Description, fieldName: 'SKU_Description', type: 'text', initialWidth: 150, sortable: true },
        { Id: 4, label: this.labels.Opening_Inventory, fieldName: 'Opening_inventory', type: 'text', initialWidth: 180, editable: this.is_editable, largewidth: true },
        { Id: 5, label: this.labels.ytd_sales, fieldName: 'YTD_sales', type: 'text', initialWidth: 280 },
        { Id: 6, label: this.labels.Total_Available_Stock, fieldName: 'Total_Available_Stock', type: 'text', initialWidth: 200, sortable: true },
        { Id: 7, label: this.labels.Distributor_Inventory, fieldName: 'Distributor_Inventory', type: 'text', initialWidth: 125, editable: this.is_editable },
        { Id: 8, label: this.labels.Plan_YTD_Quarter, fieldName: 'Plan_for_the_Quarter', type: 'text', initialWidth: 150 },
        { Id: 9, label: this.labels.Liquidation_YTD_Selected_Quarter, fieldName: 'Liquidation_YTD', type: 'text', initialWidth: 280 },
        { Id: 10, label: this.labels.Liquidation_YTD_Selected_Quarter_Percent, fieldName: 'Liquidation_percentage_YTD', type: 'text', initialWidth: 280, sortable: true },
        { Id: 11, label: this.labels.Plan_for_Next_Quarter, fieldName: 'Plan_for_the_Next_Quarter', type: 'text', initialWidth: 200, editable: this.is_editable }
    ];

    getLiquidation(t_distributor, t_distributorName, t_year, t_quarter) {
        this.spinner = true;
        this.liquidation_data = [];
        this.liquidation_to_submit = [];

        console.log('number_saperator_code==>' + this.number_saperator_code);
        if ((t_distributor != '' || t_distributorName != '') && t_year != '' && t_quarter != '') {

            getLiquidationData({ distributor: t_distributor, distributorName: t_distributorName, year: t_year, quarter: t_quarter }).then(data => {

                console.log('Liquidation data', data);
                let temp = [];
                let temp_for_submit = [];
                data.forEach(element => {
                    temp.push({
                        'Id': element.Id,
                        //'Month__c': element.Month__c !== undefined ? element.Month__c : '',
                        'Brand': element.SKU__r.Brand_Name__c !== undefined ? element.SKU__r.Brand_Name__c : '',
                        'SKU_Code': element.SKU__r.SKU_Code__c !== undefined ? element.SKU__r.SKU_Code__c * 1 : '',
                        'SKU_Description': element.SKU__r.SKU_Description__c !== undefined ? element.SKU__r.SKU_Description__c : '',
                        'Opening_inventoryId': element.Opening_Inventory2__c !== undefined ? element.Opening_Inventory2__c : '',
                        'Opening_inventory': element.Opening_Inventory2__c !== undefined ? Number(element.Opening_Inventory2__r.Opening_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        'YTD_sales': element.YTD_Sales_Poland__c !== undefined ? Number(element.YTD_Sales_Poland__c).toLocaleString(this.number_saperator_code) : '',
                        'Total_Available_Stock': element.Total_Available_Stock__c !== undefined ? Number(element.Total_Available_Stock__c).toLocaleString(this.number_saperator_code) : '',
                        'Distributor_Inventory': element.Distributors_Inventory__c !== undefined ? Number(element.Distributors_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        //'Retailers_Inventory': element.Retailers_Inventory__c !== undefined ? Number(element.Retailers_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        //'Total_market_Inventory': element.Total_Market_Inventory__c !== undefined ? Number(element.Total_Market_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        'Plan_for_the_Quarter': element.Plan_for_the_Quarter__c !== undefined ? Number(element.Plan_for_the_Quarter__c).toLocaleString(this.number_saperator_code) : '',
                        'Liquidation_YTD': element.Liquidation_YTD__c !== undefined ? Number(element.Liquidation_YTD__c).toLocaleString(this.number_saperator_code) : '',
                        'Liquidation_percentage_YTD': element.Liquidation_Percent_YTD__c !== undefined ? Number(element.Liquidation_Percent_YTD__c) + ' %' : '0 %',
                        // 'Liquidation_YTD_per_plan_YTD': isFinite(element.Liquidation_YTD__c / element.Plan_for_the_month__c) ? Number(((element.Liquidation_YTD__c / element.Plan_for_the_month__c) * 100).toFixed(2)).toLocaleString(this.number_saperator_code) + ' %' : '0 %',
                        'Plan_for_the_Next_Quarter': element.Plan_for_the_Next_Quarter__c !== undefined ? Number(element.Plan_for_the_Next_Quarter__c).toLocaleString(this.number_saperator_code) : '',
                        'key_di': element.Id + '-di',
                        'key_ri': element.Id + '-ri',
                        'key_pfnm': element.Id + '-pfnm'
                    })
                    temp_for_submit.push(element.Id);
                    if (element.submitted__c == true) {
                        this.is_submitted = true;
                        this.disable_submit_btn = true;
                        this.disable_fields = true;
                        this.disable_openingInventory = true;
                        console.log("line number 911" + this.disable_openingInventory);
                    } else {
                        this.is_submitted = false;
                        if (this.is_active_liquidation == true) {
                            this.disable_submit_btn = false;
                            this.disable_fields = false;
                        }
                        else {
                            this.disable_submit_btn = true;
                            this.disable_fields = true;
                        }
                        if (this.is_active_openingInv == true) {
                            this.disable_openingInventory = false;
                        }
                        else {
                            this.disable_openingInventory = true;
                        }
                    }
                });

                this.liquidation_data = temp;
                this.search_data = temp;
                //this.search_str = '';
                if (this.search_str != '') {
                    this.liquidation_data = this.serachInlist(this.search_str);
                }
                setTimeout(() => {
                    this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
                    this.spinner = false;
                }, 2000);

                this.liquidation_to_submit = temp_for_submit;


            }).catch(err => {
                console.log('Err ', err);

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
        if ((this.distributor != '' || this.distributorName == All) && this.year != '' && this.quarter != '') {
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

    }
    doActionSearch(target) {
        console.log('Search str ', target.value);
        this.search_str = target.value;
        console.log('this.search_str' + this.search_str);
        this.spinner = true;
        if (this.search_str != '') {
            setTimeout(() => {
                this.liquidation_data = this.serachInlist(this.search_str);
                this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
                this.spinner = false;
            }, 500);
        } else {
            setTimeout(() => {
                this.getLiquidation(this.distributor, this.distributorName, this.year, this.quarter);
                this.flag_search = false;
                this.spinner = false;
            }, 2000);
            // this.liquidation_data = this.search_data;
            this.spinner = false;
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

    handlePlaceholder(event) {
        // console.log('Key ',event.target.dataset.key);
        if (event.target.name == this.fieldsapiname.Opening_inventory) {
            if (event.target.value == 0) {
                this.template.querySelector(`lightning-input[data-id=${event.target.dataset.id}]`).value = '';
            }
        }
        if (event.target.name == this.fieldsapiname.Distributor_inventory) {
            if (event.target.value == 0) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = '';
            }
        }
        if (event.target.name == this.fieldsapiname.Plan_for_the_Next_Quarter) {
            if (event.target.value == 0) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = '';
            }
        }
    }
    handlePlaceholderSpace(event) {
        if (event.target.name == this.fieldsapiname.Opening_inventory) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-id=${event.target.dataset.id}]`).value = 0;
            }
        }
        if (event.target.name == this.fieldsapiname.Distributor_inventory) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = 0;
            }
        }
        if (event.target.name == this.fieldsapiname.Plan_for_the_Next_Quarter) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = 0;
            }
        }
    }

    handleCellChanges(event) {
        // this.spinner = true;
        //  clearTimeout(this.timeoutId);
        var theEvent = event || window.event;
        // this.case_record.ID_Number__c = event.target.value;
        // Handle key press
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
        console.log('Key cell ', key);

        var regex = /[0-9]|\./;
        if (!regex.test(key)) {
            theEvent.returnValue = false;
            // if(theEvent.preventDefault) theEvent.preventDefault();
        }
        this.timeoutId = setTimeout(this.doActionCellChange.bind(this, event.target, true), 1500);
    }
    doActionCellChange(target, para) {
        if (para) {
            console.log(`Id ${target.id.split('-')[0]} fieldName ${target.name} data ${target.value}`);
            console.log('target.value -->', target.value);
            if (target.id.split('-')[0] != undefined && target.name != '' && target.name != this.fieldsapiname.Opening_inventory) {
                this.handleSaveChanges(target.id.split('-')[0], target.name, target.value.replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, ''), target.dataset.key);
            }
            if (target.dataset.id) {
                console.log(`Liquidation Id ${target.id.split('-')[0]} Opening_inventoryId ${target.dataset.id}Name ${target.name} Value ${target.value}`);
                let liq = JSON.parse(JSON.stringify(this.liquidation_data));
                console.log('liqi ', liq);
                let temp = liq.find(ele => ele.Id == target.id.split('-')[0]);
                console.log('temp ', temp);
                if (parseInt(temp.Distributor_Inventory.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) <= parseInt(target.value.replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) + parseInt(temp.YTD_sales.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, ''))) {
                    console.log('aashima==>', target.value.replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, ''));
                    updateOpeningInventory({ oi_id: target.dataset.id, value: target.value.replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '') }).then(data => {
                        console.log('Update value ', data);
                        // this.spinner = true;
                        setTimeout(() => {
                            let update_val = this.search_data.find(ele => ele.Id == target.id.split('-')[0]);
                            console.log('OpIN1', Number(target.value.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')).toLocaleString(this.number_saperator_code), 'val ', target.value);
                            update_val.Opening_inventory = Number(target.value.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')).toLocaleString(this.number_saperator_code);
                            console.log('update val ', update_val);
                            // this.spinner = false;
                        }, 1000);
                    }).catch(err => {
                        console.log('Update Opening Inventory ERR', err)
                        // this.spinner = false;
                    });
                } else {
                    if (!Number.isNaN(parseInt(target.value.replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) + parseInt(temp.YTD_sales.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')))) {
                        this.showToastmessage(this.labels.toast_err, this.labels.Distributor_inventory_validation, 'error');
                    }
                    console.log('op ->', this.template.querySelector(`lightning-input[data-id=${target.dataset.id}]`));
                    this.template.querySelector(`lightning-input[data-id=${target.dataset.id}]`).value = '0';
                }
            }
            // this.spinner = true;
            setTimeout(() => {
                this.implement_formula(target.id.split('-')[0], target.value.replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, ''), target.name);
                // this.spinner = false;
            }, 1000);
        }

    }
    handleSaveChanges(record_id, fieldname, value, key) {
        this.liqidation_obj = {
            Id: record_id
        }
        this.liqidation_obj[fieldname] = value;
        console.log('liquidation obj', this.liqidation_obj);
        if (fieldname != this.fieldsapiname.Plan_for_the_Next_Quarter) {
            let liq = JSON.parse(JSON.stringify(this.liquidation_data));
            let temp = liq.find(ele => ele.Id == record_id);

            if (fieldname == this.fieldsapiname.Distributor_inventory) {
                // console.log('obj -->',this.liqidation_obj);
                if (parseInt(temp.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) >= parseInt(value)) {
                    saveLiquidation({ liq: this.liqidation_obj }).then(data => {
                        let update_val = this.search_data.find(ele => ele.Id == record_id);
                        update_val.Distributor_Inventory = Number(value).toLocaleString(this.number_saperator_code);
                        console.log('update val ', update_val);
                        // console.log('Data ',value);
                    }).catch(err => {
                        console.log('saveLiquidation ERR', err);
                    });
                } else {
                    if (!Number.isNaN(parseInt(value))) {
                        this.showToastmessage(this.labels.toast_err, this.labels.Distributor_inventory_validation, 'error');
                    }
                    console.log('Key ', key);
                    console.log('Di starts', this.template.querySelector(`lightning-input[data-key=${key}]`));
                    // this.template.querySelector(`lightning-input[data-key=${key}]`).value = 0;
                }
            }

        } else {
            console.log('update plan for next quarter', this.liqidation_obj.Plan_for_the_next_quarter__c);
            if (value != '') {
                //  this.spinner = true;
                //  setTimeout(() => {
                updatePlanForQuarter({ liq: this.liqidation_obj }).then(data => {
                    let update_val = this.search_data.find(ele => ele.Id == record_id);
                    update_val.Plan_for_next_quarter = Number(value).toLocaleString(this.number_saperator_code);
                    console.log('update val ', update_val);
                    console.log('Data ', value);
                }).catch(err => {
                    console.log('saveLiquidation plan for next month ERR', err);
                });
                // this.spinner = false;
                //  }, 1000);
            } else {
                this.template.querySelector(`lightning-input[data-key=${key}]`).value = 0;
            }
        }
    }

    implement_formula(temp_id, temp_val, temp_name) {
        this.liquidation_data.forEach(liq => {
            if (liq.Id == temp_id && temp_name == this.fieldsapiname.Distributor_inventory) {
                liq.Distributor_Inventory = Number(temp_val.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')).toLocaleString(this.number_saperator_code);
                //  liq.Total_market_Inventory = parseFloat(temp_val) + parseFloat(liq.Retailers_Inventory.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, ''));
                // liq.Total_market_Inventory = Number.isNaN(liq.Total_market_Inventory.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) ? 0 : Number(liq.Total_market_Inventory).toLocaleString(this.number_saperator_code);
            }
            if (liq.Id == temp_id && temp_name == this.fieldsapiname.Opening_inventory) {
                console.log('OpIN2', Number(temp_val.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')).toLocaleString(this.number_saperator_code), 'val ', temp_val);
                liq.Opening_inventory = Number(temp_val.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')).toLocaleString(this.number_saperator_code);
                liq.Total_Available_Stock = parseFloat(temp_val) + parseFloat(liq.YTD_sales.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, ''));
                console.log('Total_Available_Stock ', liq.Total_Available_Stock);
                liq.Total_Available_Stock = Number.isNaN(liq.Total_Available_Stock) ? 0 : Number(liq.Total_Available_Stock).toLocaleString(this.number_saperator_code);
            }
            if (liq.Id == temp_id) {
                liq.Liquidation_YTD = parseFloat(liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) - parseFloat(liq.Distributor_Inventory.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, ''));
                liq.Liquidation_YTD = Number.isNaN(liq.Liquidation_YTD) ? 0 : Number(liq.Liquidation_YTD).toLocaleString(this.number_saperator_code);

                liq.Liquidation_percentage_YTD = isFinite(Number(parseFloat(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '') / liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) * 100).toFixed(2)))) ? Number(parseFloat(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '') / liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) * 100).toFixed(2))) + '%' : '0 %';

                //liq.Liquidation_YTD_per_plan_YTD = isFinite(liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '') / liq.Plan_for_the_Quarter.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) ? Number(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '') / liq.Plan_for_the_Quarter.toString().replaceAll(',', '').replaceAll('.', '').replaceAll(/\s/g, '')) * 100).toFixed(2)).toLocaleString(this.number_saperator_code) + ' %' : '0 %';
            }
        });
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
    handleSubmit(event) {
        console.log('submit ->', JSON.stringify(this.liquidation_to_submit));
        this.spinner = true;
        submitLiquidation({ lst_liq: JSON.stringify(this.liquidation_to_submit) }).then(is_success => {
            console.log('submit status ', is_success);
            setTimeout(() => {
                if (is_success == true) {
                    this.is_submitted = true;
                    this.disable_submit_btn = true;
                    this.disable_fields = true;
                    this.disable_openingInventory = true;
                    this.showToastmessage(this.labels.toast_success, this.labels.Liquidation_submitted_Successfully, 'success');
                }
                this.spinner = false;
            }, 1000);

        }).catch(err => {
            this.disable_submit_btn = false;
            this.showToastmessage(this.labels.toast_err, this.labels.Error_while_submitting_Liquidation, 'error');
        });
    }


    handleUploadCSVLiquidation() {
        if (this.year == '' || this.quarter == '') {
            this.showToastmessage(this.labels.toast_err, this.labels.Select_Year_and_Quarter, 'error');
        } else {
            this.spinner = true;
            setTimeout(() => {
                this.spinner = false;
                this.openModel = true;
            }, 1500);
        }

    }
    handleCloseModel() {
        this.openModel = false;
    }
    refreshLiquidation(event) {
        this.spinner = true;
        setTimeout(() => {
            if (event.detail == true) {
                this.getLiquidation(this.distributor, this.distributorName, this.year, this.quarter);
            }
            this.spinner = false;
        }, 2000);
    }
    handleUploadCSVOI() {
        if (this.year == '') {
            this.showToastmessage(this.labels.toast_err, this.labels.Select_Year_value, 'error');
        } else {
            this.spinner = true;
            setTimeout(() => {
                this.spinner = false;
                this.openModelOI = true;
            }, 1500);
        }

    }
    handleCloseModelOI() {
        this.openModelOI = false;
    }

/* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
    downloadPDF() {
        this.pogPDFUrl = '/apex/Grz_LiquidationPolandPDF?distributor=' + this.distributor + '&distributorName=' + this.distributorName
            + '&year=' + this.year + '&quarter=' + this.quarter + '&searchValue=' + this.search_str;


        console.log('value' + this.pogPDFUrl);
        /*this.spinner = true;
        const downloadLink = document.createElement("a");
        downloadLink.href = this.pogPDFUrl;
        downloadLink.target = '_blank';
        downloadLink.download = 'POGReport.pdf';
        downloadLink.click();*/
        window.open(this.pogPDFUrl, '_blank');
        setTimeout(() => {
            this.spinner = false;
        }, 4000);

    }
    
/* Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :17-07-2022 */
    downloadXLS() {

        this.pogXLSUrl = '/apex/Grz_LiquidationPolandXLS?distributor=' + this.distributor + '&distributorName=' + this.distributorName
            + '&year=' + this.year + '&quarter=' + this.quarter + '&searchValue=' + this.search_str;



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

    /* -- */

}