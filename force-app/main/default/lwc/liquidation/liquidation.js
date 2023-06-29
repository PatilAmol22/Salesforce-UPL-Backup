import { LightningElement, track, wire } from 'lwc';
import Brand from '@salesforce/label/c.Brand';
import CloseAt from '@salesforce/label/c.CloseAt';
import Distributor from '@salesforce/label/c.Distributor';
import Liquidation_YTD_Selected_Month from '@salesforce/label/c.Liquidation_YTD_Selected_Month';
import Liquidation_YTD from '@salesforce/label/c.Liquidation_YTD';
import Opening_Inventory from '@salesforce/label/c.Opening_Inventory';
import distributor_Inventory from '@salesforce/label/c.Distributor_Inventory';
import Plan_for_Next_Month from '@salesforce/label/c.Plan_for_Next_Month';
import Plan_YTD_May from '@salesforce/label/c.Plan_YTD_May';
import Retailer_Inventory from '@salesforce/label/c.Retailer_Inventory';
import SKU_Code from '@salesforce/label/c.SKU_Code';
import SKU_Description from '@salesforce/label/c.SKU_Description';
import Total_Available_Stock from '@salesforce/label/c.Total_Available_Stock';
import Total_Market_Inventory from '@salesforce/label/c.Total_Market_Inventory';
import Liquidation_title from '@salesforce/label/c.Liquidation_title';
import Submit from '@salesforce/label/c.Submit';
import Select_Distributor from '@salesforce/label/c.Select_Distributor';
import Sales_District from '@salesforce/label/c.Sales_District';
import Select_Sales_District from '@salesforce/label/c.Select_Sales_District';
import Year from '@salesforce/label/c.Year';
import Select_Year from '@salesforce/label/c.Select_Year';
import Month from '@salesforce/label/c.Month';
import Select_Month from '@salesforce/label/c.Select_Month';
import Search from '@salesforce/label/c.Search';
import Sales_Org from '@salesforce/label/c.Sales_Org';
import upload_file from '@salesforce/label/c.Upload_File';
import Liquidation_submitted_Successfully from '@salesforce/label/c.Liquidation_submitted_Successfully';
import Error_while_submitting_Liquidation from '@salesforce/label/c.Error_while_submitting_Liquidation';
import no_data from '@salesforce/label/c.No_liquidation_found';
import loading_data from '@salesforce/label/c.Loading';
import market_inventory_validation from '@salesforce/label/c.market_inventory_validation';
import toast_err from '@salesforce/label/c.Error';
import toast_success from '@salesforce/label/c.Success';
import Liquidation_YTD_Plan_YTD from '@salesforce/label/c.Liquidation_YTD_Plan_YTD';
import ytd_sales from '@salesforce/label/c.YTD_sales';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import object_liquidationAnnualPlan from '@salesforce/schema/Liquidation_Annual_Plan__c';
import FIscal_Year__c from '@salesforce/schema/Liquidation_Annual_Plan__c.FIscal_Year__c';
import getSalesDistrict from '@salesforce/apex/Liquidation_Indo_turkey.getSalesDistrict';
import getDistributor from '@salesforce/apex/Liquidation_Indo_turkey.getDistributor';
import getAllLiquidation from '@salesforce/apex/Liquidation_Indo_turkey.getAllLiquidation';
import LIQUIDATION_OBJECT from '@salesforce/schema/Liquidation2__c';
import Distributor_inventory_field from '@salesforce/schema/Liquidation2__c.Distributors_Inventory__c';
import Retailer_inventory_field from '@salesforce/schema/Liquidation2__c.Retailers_Inventory__c';
import Plan_for_next_month_field from '@salesforce/schema/Liquidation2__c.Plan_for_the_next_month__c';
import All from '@salesforce/label/c.All';
import None from '@salesforce/label/c.None';

import saveLiquidation from '@salesforce/apex/Liquidation_Indo_turkey.saveLiquidation';
import submitLiquidation from '@salesforce/apex/Liquidation_Indo_turkey.submitLiquidation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLiquidationEditDates from '@salesforce/apex/Liquidation_Indo_turkey.getLiquidationEditDates';
import rollUpLiquidation from '@salesforce/apex/Liquidation_Indo_turkey.rollUpLiquidation';
import updateOpeningInventory from '@salesforce/apex/Liquidation_Indo_turkey.updateOpeningInventory';
import getOpeningInventoryEditDates from '@salesforce/apex/Liquidation_Indo_turkey.getOpeningInventoryEditDates';
import getSalesDistrictOnAccount from '@salesforce/apex/Liquidation_Indo_turkey.getSalesDistrictOnAccount';
import getLogedInUserId from '@salesforce/apex/Liquidation_Indo_turkey.getLogedInUserId';
import updatePlanForMonth from '@salesforce/apex/Liquidation_Indo_turkey.updatePlanForMonth'
import getUserProfile from '@salesforce/apex/Liquidation_Indo_turkey.getUserProfile';
import getcountry from '@salesforce/apex/Liquidation_Indo_turkey.getUserCountry';
import getSalesOrg from '@salesforce/apex/Liquidation_Indo_turkey.getSalesOrg';
import getUserCountry from '@salesforce/apex/Liquidation_Indo_turkey.getUserCountry';
import isCommunityUser from '@salesforce/apex/Liquidation_Indo_turkey.isCommunityUser';
import getCommunityDistributor from '@salesforce/apex/Liquidation_Indo_turkey.getCommunityDistributor';
import isActiveCommunity from '@salesforce/apex/Liquidation_Indo_turkey.isActiveCommunity';
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD"; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS"; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
import Icons from "@salesforce/resourceUrl/Grz_Resourse"; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */

const monthmaptemp = new Map();
monthmaptemp.set("Apr", 3); // start of 1st year
monthmaptemp.set("May", 4);
monthmaptemp.set("Jun", 5);
monthmaptemp.set("Jul", 6);
monthmaptemp.set("Aug", 7);
monthmaptemp.set("Sept", 8);
monthmaptemp.set("Oct", 9);
monthmaptemp.set("Nov", 10);
monthmaptemp.set("Dec", 11); // End of 1st year
monthmaptemp.set("Jan", 0);  // start of 2nd year
monthmaptemp.set("Feb", 1);
monthmaptemp.set("Mar", 2);
const profileCanEditLiquidation = ['National sales Manager indonesia', 'Supply Chain & QM Turkey', 'Regional/Zonal Indonesia', 'District Manager for Turkey','Vietnam National Sales Manager(NSM)','Vietnam Regional Sales Manager(RSM)'];
export default class Liquidation extends LightningElement {
    @track labels = {All:All,None:None};
    @track sales_district = ''; // Id of Sales_district
    @track sales_district_name = '';
    @track distributor = ''; // Id of Distibutor
    @track Sales_Org = '';
    @track year = ''; // Store year e.g 2019,2020
    @track month = '';
    @track salesDistrictOption = [{ label: this.labels.All, value: '' }]; // label:name value:Id
    @track distributorOption = [{ label: this.labels.All, value: '' }];   // label:name value:Id  
    @track salesOrgOption = [{ label: this.labels.All, value: '' }];
    @track yearOption = [{ label: this.labels.None, value: '' }];          // label:name value:Id
    @track monthOption = [{ label: this.labels.None, value: '' }];         // label:name value:Id
    @track disable_salesDistrict = false;
    @track disable_distributor = false;
    @track disable_Sales_Org = false;
    @track disable_year = false;
    @track disable_month = false;
    @track is_editable = true;
    @track liquidation_data = [];
    @track liqidation_obj = LIQUIDATION_OBJECT;
    @track liquidation_to_submit = [];
    @track disable_submit_btn = false;
    @track disable_upload_btn = false;
    @track disable_fields = false;
    @track active_date_liquidation = false;
    @track active_date_OpeningInventory = false;
    @track disable_openingInventory = true;
    @track liquidation_found = false;
    @track spinner = false;
    @track lst_salesDistrictId = [];
    @track record_type = '';
    @track userProfileName = '';
    @track search_str = '';
    @track hasRendered = true;
    @track user_country = '';
    @track salesdistrict_filter = '';
    @track distributor_filter = '';
    @track disable_Product = false;
    @track distributorName = '';
    @track flag_search = false;
    @track temp_data = [];
    @track hide_uploadbtn = false;
    @track user_id = '';
    @track hasRenderedMonth = true;
    @track hasRenderedProfile = true;
    @track salesorg_arr = [];
    @track brand_sortDirection = true;
    @track SKU_Code_sortDirection = true;
    @track SKU_Description_sortDirection = true;
    @track Total_Available_Stock_sortDirection = true;
    @track Total_Market_Inventory_sortDirection = true;
    @track Liquidation_percentage_YTD_sortDirection = true;
    @track openModel = false;
    @track is_submitted = false;
    @track search_data = [];
    @track hide_col = 'hideCommunityColumn';
    @track hidebyid = '13';
    @track hasColumnhide = true;
    @track emptysales_district = false;
    @track number_saperator_code = '';
    @track selected_year = '';
    @track isCommunityUsr = false;
    @track disable_fieldsdistributorInventory = false;
    isActiveCommunity = '';
  columnTrue=false;  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    @track ColumnTrue=false;  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    // @track opening_inventory_value = '';
    // @track distributor_inventory_value = '';
    // @track retailer_inventory_value = '';
    // @track plan_for_next_month_value = '';
    labels = {
        Brand: Brand,
        CloseAt: CloseAt,
        Distributor: Distributor,
        Liquidation_YTD_Selected_Month: Liquidation_YTD_Selected_Month,
        Liquidation_YTD: Liquidation_YTD,
        Opening_Inventory: Opening_Inventory,
        Distributor_Inventory: distributor_Inventory,
        Plan_for_Next_Month: Plan_for_Next_Month,
        Plan_YTD_May: Plan_YTD_May,
        Retailer_Inventory: Retailer_Inventory,
        SKU_Code: SKU_Code,
        SKU_Description: SKU_Description,
        Total_Available_Stock: Total_Available_Stock,
        Total_Market_Inventory: Total_Market_Inventory,
        Liquidation_title: Liquidation_title,
        Submit: Submit,
        Select_Distributor: Select_Distributor,
        Sales_District: Sales_District,
        Select_Sales_District: Select_Sales_District,
        Year: Year,
        Select_Year: Select_Year,
        Month: Month,
        Select_Month: Select_Month,
        Search: Search,
        Liquidation_submitted_Successfully: Liquidation_submitted_Successfully,
        Error_while_submitting_Liquidation: Error_while_submitting_Liquidation,
        Sales_Org: Sales_Org,
        upload_file: upload_file,
        no_data: no_data,
        loading: loading_data,
        ytd_sales: ytd_sales,
        market_inventory_validation: market_inventory_validation,
        toast_err: toast_err,
        toast_success: toast_success,
        Liquidation_YTD_Plan_YTD: Liquidation_YTD_Plan_YTD,
        All:All,
        None:None,
        DownloadPDF: DownloadPDF, /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
        DownloadXLS: DownloadXLS /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    }

    downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png"; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    @track columns = [
        { Id: 1, label: this.labels.Brand, fieldName: 'Brand', type: 'text', initialWidth: 100, sortable: true,class:"" },
        { Id: 2, label: this.labels.SKU_Code, fieldName: 'SKU_Code', type: 'text', initialWidth: 120, sortable: true ,class:"" },
        { Id: 3, label: this.labels.SKU_Description, fieldName: 'SKU_Description', type: 'text', initialWidth: 150, sortable: true,class:"" },
        { Id: 4, label: this.labels.Opening_Inventory, fieldName: 'Opening_inventory', type: 'text', initialWidth: 180, editable: this.is_editable, largewidth: true,class:"" },
        { Id: 5, label: this.labels.ytd_sales, fieldName: 'YTD_sales', type: 'text', initialWidth: 280,class:"hideCommunityColumn"},
        { Id: 6, label: this.labels.Total_Available_Stock, fieldName: 'Total_Available_Stock', type: 'text', initialWidth: 200, sortable: true,class:"hideCommunityColumn"},
        { Id: 7, label: this.labels.Distributor_Inventory, fieldName: 'Distributor_Inventory', type: 'text', initialWidth: 125, editable: this.is_editable,class:"" },
        { Id: 8, label: this.labels.Retailer_Inventory, fieldName: 'Retailers_Inventory', type: 'text', initialWidth: 180, editable: this.is_editable,class:"hideCommunityColumn" },
        { Id: 9, label: this.labels.Total_Market_Inventory, fieldName: 'Total_market_Inventory', type: 'text', sortable: true,class:"hideCommunityColumn" },
        { Id: 10, label: this.labels.Plan_YTD_May, fieldName: 'plan_for_month', type: 'text', initialWidth: 150,class:"hideCommunityColumn" },
        { Id: 11, label: this.labels.Liquidation_YTD, fieldName: 'Liquidation_YTD', type: 'text', initialWidth: 280,class:"hideCommunityColumn" },
        { Id: 12, label: this.labels.Liquidation_YTD_Selected_Month, fieldName: 'Liquidation_percentage_YTD', type: 'text', initialWidth: 280, sortable: true,class:"hideCommunityColumn" },
        { Id: 13, label: this.labels.Liquidation_YTD_Plan_YTD, fieldName: 'Liquidation_YTD_per_plan_YTD', type: 'text', initialWidth: 280,class:"hideCommunityColumn" },
        { Id: 14, label: this.labels.Plan_for_Next_Month, fieldName: 'Plan_for_next_month', type: 'text', initialWidth: 200, editable: this.is_editable,class:"hideCommunityColumn" }
    ];

    @track fieldsapiname = {
        'Opening_inventory': 'Opening_Inventory2__c',
        'Distributor_inventory': Distributor_inventory_field.fieldApiName,
        'Retailerinventory': Retailer_inventory_field.fieldApiName,
        'plan_for_next_month': Plan_for_next_month_field.fieldApiName,
    }
    @wire(getcountry)
    getUserCountry({ error, data }) {
        this.spinner = true;
        console.log('getUserCountry data ', data, ' Err ', error);
        if (data) {
            this.user_country = data.toLocaleLowerCase();
            if (this.user_country == 'turkey') {
                this.number_saperator_code = 'tr-TR';
            } else if (this.user_country == 'indonesia') {
                this.number_saperator_code = 'en-IN';
            } else {
                this.number_saperator_code = 'en-IN';
            }
            this.spinner = false;
        }
        if (error) {
            this.user_country = '';
            this.spinner = false;
        }
    }

    @wire(getLogedInUserId)
    getLogedInUsers({ error, data }) {
        this.spinner = true;
        console.log('getUserId', data, ' Err ', error);
        if (data) {
            this.user_id = data;
            this.spinner = false;
        }
        if (error) {
            this.user_id = '';
            this.spinner = false;
        }
    }

    @wire(getUserProfile)
    userProfile({ error, data }) {
        this.spinner = true;
        console.log('userProfile data ', data, ' Err ', error);
        if (data) {
            this.userProfileName = data;
            this.spinner = false;
        }
        if (error) {
            this.userProfileName = '';
            this.spinner = false;
        }
    }

    @wire(getSalesOrg)
    getsalesorg({ error, data }) {
        this.spinner = true;
        console.log('salesorg data ', data, ' Err ', error);
        this.salesOrgOption = [];
        if (data) {
            data.forEach(ele => {
                this.salesOrgOption = [...this.salesOrgOption, { label: ele.Name, value: ele.Sales_Org_Code__c }];
            });
            if (data.length > 1) {
                this.salesOrgOption.unshift({ label: this.labels.All, value: '' });
            } else {
                if (data[0]) {
                    this.Sales_Org = data[0].Sales_Org_Code__c;
                }
            }
            this.spinner = false;
        }
        if (error) {
            console.log('Sales org ERR ', error);
            this.spinner = false;
        }
    }

    // @wire(getObjectInfo,{objectApiName:object_liquidationAnnualPlan}) objectInfo;
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
    }
    // $objectInfo.data.defaultRecordTypeId
    @wire(getPicklistValues, { recordTypeId: '$record_type', fieldApiName: FIscal_Year__c })
    TypePicklistValues_city({ data, error }) {
        this.yearOption = [];
        this.spinner = true;
        if (data) {
            console.log('Year options ', data.values);
            console.log('Year options ', this.user_country);
            // data.values = data.values.sort();
            data.values.forEach(element => {
                this.yearOption = [...this.yearOption, { label: element.value, value: element.value.split('-')[0] }];
                if (element.value.split('-')[0] == new Date().getFullYear() || element.value.split('-')[0] == new Date().getFullYear()-1) {
                    this.year = element.value.split('-')[0];
                    this.selected_year = element.value;
                    // this.getMonthOptionByYear(this.year);
                }
            });
            console.log("2");
            this.yearOption.unshift({ label: this.labels.None, value: '' });
            this.spinner = false;
        }
        if (error) {
            console.log('error ', error);
            this.spinner = false;
        }
    };

    @wire(getSalesDistrict)
    getSalesDistricts({ error, data }) {
        this.spinner = true;
        console.log('Sales District 330', data);
        this.salesDistrictOption = [];
        this.lst_salesDistrictId = [];
        this.sales_district = '';
        if (data) {
            data.forEach(ele => {
                // this.salesDistrictOption = [...this.salesDistrictOption,{label:ele.Name,value:ele.Id}];
                this.lst_salesDistrictId.push(ele.Id);
            });
            this.salesDistrictOption.unshift({ label: this.labels.All, value: '' });
            this.spinner = false;
            if (data.length == 0) {
                console.log('Empty sales District',data);
                this.emptysales_district = true;
            }
        }

        if (error) {
            console.log('Sales District err', error);
            this.spinner = false;
        }
    }

    @wire(getLiquidationEditDates)
    getLiquidationDate({ error, data }) {
        this.spinner = true;
        console.log('getLiquidationDate Error ', error, 'Data', data);
        if (data) {
            this.spinner = false;
            this.active_date_liquidation = JSON.parse(data);
        }
        if (error) {
            console.log('getLiquidationDate ', error);
            this.spinner = false;
        }
    }

    @wire(getOpeningInventoryEditDates)
    getOpeningInventoryDates({ error, data }) {
        console.log('Error ', error, 'Data', data);
        this.spinner = true;
        if (data) {
            this.active_date_OpeningInventory = JSON.parse(data);
            console.log('this.active_date_OpeningInventory -----> ', this.active_date_OpeningInventory = JSON.parse(data))
            isCommunityUser().then(isCommunity=>{
            if (this.active_date_OpeningInventory == true && isCommunity) {
                this.disable_openingInventory = false;
            } else {
                this.disable_openingInventory = true;
            }
            this.spinner = false;
            })
        }
        if (error) {
            console.log('getLiquidationDate ', error);
            this.spinner = false;
        }
    }

    constructor() {
        super();
    }

    connectedCallback() {
        this.disable_distributor = true;
        this.is_editable = true;
        // console.log('country name', this.user_country);
        this.template.querySelectorAll('.hideCommunityColumn').forEach(ele=>{
            ele.style="display:none"
            console.log('style 403 ',ele);
        })
        if (this.user_country.toLocaleLowerCase().includes('indonesia')) {
            if (this.lst_salesDistrictId.length > 0) {
                this.salesdistrict_filter = `User__r.Country = 'indonesia' `;
            }
        }
        if (this.user_country.toLocaleLowerCase().includes('turkey')) {
            if (this.lst_salesDistrictId.length > 0) {
                this.salesdistrict_filter = `User__r.Country = 'Turkey' `;
            }
        }
        if (this.user_country.toLocaleLowerCase().includes('Vietnam')) {
            if (this.lst_salesDistrictId.length > 0) {
                this.salesdistrict_filter = `User__r.Country = 'Vietnam' `;
            }
        }

        this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.RecordType.Name='Distributor' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;
        
        isCommunityUser().then(isCommunity=>{
            this.isCommunityUsr = isCommunity;
            console.log('isCommunityUsr '+this.isCommunityUsr);
            getCommunityDistributor().then(account=>{
                console.log('getCommunityDistributor '+account);
                if(account){
                    this.distributor = account.Id;
                    this.distributorName = account.Name;
                    this.disable_Sales_Org = true;
                    this.disable_distributor = true;
                    this.disable_salesDistrict = true;
                }
            }).catch(err=>{
                console.log('error in getCommunityDistributor',err);
            })
        }).catch(err=>{
            console.log('error in isCommunityUser promise');
        });
        
    }

    renderedCallback() {
        // console.log('All column to be hide ',this.template.querySelectorAll('.hideCommunityColumn'));
        
            this.template.querySelectorAll('.hideCommunityColumn').forEach(ele=>{
                if(this.isCommunityUsr){
                ele.style="display:none"
                }
            })
       
        console.log('month ',this.month);
        console.log('country code ', this.number_saperator_code);
        console.log('User Profile ', this.userProfileName);
        // console.log('sales district filter ',this.salesdistrict_filter);
        // console.log('Distributor district filter ',this.distributor_filter);
        // if(this.liquidation_data.length>0){
        //     console.log('this.liquidation_data ',JSON.stringify(this.liquidation_data));
        // }
        if (this.user_country.toLocaleLowerCase().includes('turkey')) {
            this.columnTrue=true; /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
            if (this.hasColumnhide = true) {

                this.template.querySelectorAll('th').forEach(ele => {
                    if (ele.id.split('-')[0] == '13') {
                        ele.style.display = 'none';
                        
                    }
                });
                this.template.querySelectorAll('td').forEach(ele => {
                    if (ele.id.split('-')[0] == '13') {
                        ele.style.display = 'none';
                    }
                });
                this.hasColumnhide = false;
            }
        }
        if (this.is_submitted == false) {
            // console.log('active_date_OpeningInventory '+this.active_date_OpeningInventory);
            if (this.active_date_OpeningInventory == true) {
                if (this.sales_district == '' || this.distributor == '' || this.year == '' || this.month == '') {
                    this.disable_openingInventory = true;
                } else {
                    // console.log('isCommunityUser 453'+this.isCommunityUsr);
                    if (this.userProfileName == 'Regional/Zonal Indonesia' || this.userProfileName == 'District Manager for Turkey' || this.userProfileName == 'Vietnam Regional Sales Manager(RSM)' || this.isCommunityUsr) {
                        let monthval = new Date().getMonth(); // current month
                        let monthmap = monthmaptemp.get(this.month) + 1;
                        if (monthmap == 12) {
                            monthmap = monthmaptemp.get('Jan');
                        }
                        if (monthval == monthmap) {
                            this.disable_openingInventory = false;
                            console.log('disable_openingInventory 466'+this.disable_openingInventory);
                        } else {
                            this.disable_openingInventory = true;
                            this.disableAccesstoEdit(true, true,true, true);
                        }
                    }
                    // Supply Chain & QM Turkey
                    if (this.userProfileName.toLocaleLowerCase().includes('national sales manager') || this.userProfileName.toLocaleLowerCase().includes('Supply Chain & QM Turkey'.toLocaleLowerCase()) || this.userProfileName.includes('Vietnam National Sales Manager(NSM)')) {
                        console.log('Current month1  - ', monthmaptemp.get(this.month) + 2); // one prev month
                        console.log('Current month2  - ', new Date().getMonth());
                        let monthval = new Date().getMonth(); // current month
                        let monthmap = monthmaptemp.get(this.month) + 2;
                        if (monthmap == 12) {
                            monthmap = monthmaptemp.get('Jan');
                        }
                        if (monthmap == 13) {
                            monthmap = monthmaptemp.get('Feb');
                        }
                        if (monthval == monthmap) {
                            this.disable_openingInventory = false;
                            console.log('disable_openingInventory 482'+this.disable_openingInventory);
                        } else {
                            this.disable_openingInventory = true;
                            this.disableAccesstoEdit(true, true,true, true);
                        }
                    }
                }
            }

            if (profileCanEditLiquidation.includes(this.userProfileName) == false) {
                if(this.isCommunityUsr==false){
                this.disable_fields = false;
                this.disable_submit_btn = true;
                this.disable_upload_btn = true;
                this.hide_uploadbtn = true;
                this.disable_openingInventory = true;
                this.disable_fieldsdistributorInventory = true;
                }
            }


            if (this.userProfileName == 'Regional/Zonal Indonesia' || this.userProfileName == 'District Manager for Turkey' || this.userProfileName == 'Vietnam Regional Sales Manager(RSM)' || this.isCommunityUsr) {
                this.hide_uploadbtn = false;
                // console.log('Current month1  - ', monthmaptemp.get(this.month) + 1); // one prev month
                let monthval = new Date().getMonth(); // current month
                let monthmap = monthmaptemp.get(this.month) + 1;
                if (monthmap == 12) {
                    monthmap = monthmaptemp.get('Jan'); // Edit 02-01-2021
                }
                // console.log('Current month2 ', monthval);
                // console.log('Current month  res ', monthmap != monthval);
                if ((this.sales_district != '' || this.sales_district != 'none') && (this.distributor != '' && this.distributor != 'none')) {
                    if (monthmap != monthval) {
                        this.disable_fields = true;
                        this.disable_fieldsdistributorInventory = true;
                        this.disable_submit_btn = true;
                        this.disable_upload_btn = true; // edit on 02/01/2021
                        // this.active_date_OpeningInventory = true;
                        if (this.hasRenderedProfile == true) {
                            this.disable_openingInventory = true;
                            this.hasRenderedProfile = false;
                        }
                        // if(this.hasRenderedProfile==true){
                        //     this.disable_openingInventory = true;
                        //     this.hasRenderedProfile = false;
                        // }

                        // console.log('this.active_date_OpeningInventory = true;');
                    } else {
                        if (this.active_date_liquidation == true) {
                            if (this.liquidation_found == true) {
                                this.disableAccesstoEdit(false, false,false, false);
                            } else {
                                this.disableAccesstoEdit(true, true,true, true);
                            }
                           
                        }
                        //this.disable_openingInventory = this.active_date_OpeningInventory == true ? false : true; // Edited on 16-03-21
                    }
                    //    }else{
                    //     // this.active_date_OpeningInventory = false;
                    //     console.log('this.active_date_OpeningInventory = false;');
                    //    }
                } else {
                    this.disable_submit_btn = true;
                    // this.disable_upload_btn = true;
                    this.disable_fields = true;
                    this.disable_fieldsdistributorInventory = true;
                    if (this.sales_district != '' && this.year != '' && this.month != '') {
                        this.disable_upload_btn = false;
                    } else {
                        this.disable_upload_btn = true;
                    }
                }
            }
            // Start
            if (this.userProfileName.toLocaleLowerCase().includes('national sales manager') || this.userProfileName.toLocaleLowerCase().includes('Supply Chain & QM Turkey'.toLocaleLowerCase()) || this.userProfileName.includes('Vietnam National Sales Manager(NSM)')) {
                this.hide_uploadbtn = true;
                
                // console.log('Current month1  - ', monthmaptemp.get(this.month) + 2); // one prev month
                let monthval = new Date().getMonth(); // current month
                let monthmap = monthmaptemp.get(this.month) + 2;
                if (monthmap == 12) {
                    monthmap = monthmaptemp.get('Jan');
                }
                if (monthmap == 13) {
                    monthmap = monthmaptemp.get('Feb');
                }
                // console.log('Current month2 558', monthval);
                // console.log('Current month  res 559', monthmaptemp.get(this.month) != monthval); // Need to change logic
                if ((this.sales_district != '') && (this.distributor != '')) {
                    if (monthmap != monthval) {
                        console.log("Liquidation should not editable 562");
                        this.disable_fields = true;
                        this.disable_fieldsdistributorInventory = true;
                        if (this.hasRenderedProfile == true) {
                            this.disable_openingInventory = true;
                            this.hasRenderedProfile = false;
                        }
                    } else {
                        console.log("Liquidation should editable 568");
                        if (this.active_date_liquidation == true) {
                            this.disableAccesstoEdit(false, false,false, false);
                        }
                    }
                }
            }
        } else {
            this.disableAccesstoEdit(true, true, true);
            this.disable_openingInventory = true;
            // this.hide_uploadbtn = true;
        }
        // End
        // console.log(`sales_district ${this.sales_district} this.distributor ${this.distributor} this.Sales_Org ${this.Sales_Org} this.year ${this.year} this.month ${this.month}`)
        console.log('Year', this.year, 'Month ', this.month, 'has rendered ', this.hasRenderedMonth);
        if (this.year != '' && this.hasRenderedMonth == true) {
            getUserCountry().then(country_name => {
                console.log('Country name *********', country_name);
                this.user_country = country_name;
                if (this.user_country.toLocaleLowerCase().includes('indonesia')) {
                    this.salesorg_arr = [];
                    this.salesorg_arr = ['6451', '6410'];
                }
                if (this.user_country.toLocaleLowerCase().includes('turkey')) {
                    this.salesorg_arr = [];
                    this.salesorg_arr = ['7110', '7120'];
                }
                if (this.user_country.toLocaleLowerCase().includes('vietnam')) {
                    this.salesorg_arr = ['6610', '6631'];
                }
                this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and (SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[0]}' OR SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[1]}') group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;
                if (this.sales_district != '' && this.Sales_Org == '') {
                    this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.Sales_District__c = '${this.sales_district}' and (SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[0]}' OR SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[1]}') group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;
                }
                if (this.sales_district != '' && this.Sales_Org != '') {
                    this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.Sales_District__c = '${this.sales_district}' and SalesOrg__r.Sales_Org_Code__c = '${this.Sales_Org}' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`
                }
                // console.log('filter distributor ', this.distributor_filter);
                this.getMonthOptionByYear(this.year);
                this.hasRenderedMonth = false;
            }).catch(err => {
                console.log('ERR Country', err);
            });
        }
        if (this.year != '' && this.month != '' && this.hasRendered == true && this.user_id != '') {
            console.log('year ', this.year)
            //Marketing Manager Turkey ,Regional tech & technical sales Turkey
            if (this.user_country.toLocaleLowerCase().includes('indonesia') || this.user_country.toLocaleLowerCase().includes('turkey') || this.user_country.toLocaleLowerCase().includes('vietnam')) {
                if (this.userProfileName.toLocaleLowerCase().includes('national sales manager') || this.userProfileName.toLocaleLowerCase().includes('sales head indonesia') || this.userProfileName.toLocaleLowerCase().includes('Supply Chain & QM Turkey'.toLocaleLowerCase()) || this.userProfileName.toLocaleLowerCase().includes('Country Head For Turkey'.toLocaleLowerCase()) || this.userProfileName.toLocaleLowerCase().includes('Marketing Manager Turkey'.toLocaleLowerCase()) || this.userProfileName.toLocaleLowerCase().includes('Regional tech & technical sales Turkey'.toLocaleLowerCase()) || this.userProfileName.toLocaleLowerCase().includes('Marketing Manager Indonesia'.toLocaleLowerCase()) ||  this.userProfileName.includes('Vietnam National Sales Manager(NSM)') || this.userProfileName.includes('Vietnam Country Head') || this.userProfileName.includes('Vietnam Sales Admin User') || this.userProfileName.includes('Vietnam Sales Manager(B2B)') || this.isCommunityUsr) {
                    console.log('Query on profile');
                    this.salesdistrict_filter = `User__r.Country = '${this.user_country}' `;
                } else {
                    console.log('user_id ', this.user_id);
                    this.salesdistrict_filter = `User__r.Country = '${this.user_country}' and User__c= '${this.user_id}' `;
                    console.log(`Query without profile country ${this.user_country} profile ${this.userProfileName}`);
                }
            } else {
                console.log(`Query without profile country ${this.user_country} profile ${this.userProfileName}`);
            }

            // console.log(`Onload sales_district ${this.sales_district} this.distributor ${this.distributor} this.year ${this.year} this.month ${this.month}`)
            this.spinner = true;
            setTimeout(() => {
                this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
                this.spinner = false;
            }, 1000);

            this.hasRendered = false;
        }

    }

    handleChangeYear(event) {
        console.log('Year selected ', event.target.options.find(opt => opt.value.split('-')[0] === event.detail.value).label);
        this.month = '';
        this.year = event.detail.value;
        this.selected_year = event.target.options.find(opt => opt.value.split('-')[0] === event.detail.value).label;
        this.monthOption = [];
        if (this.year != '') {
            this.disable_month = false;
            this.getMonthOptionByYear(this.year);
        } else {
            this.disable_month = true;
            this.monthOption.unshift({ label: this.labels.None, value: '' });
        }
        this.spinner = true;
        setTimeout(() => {
            this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
            this.spinner = false;
        }, 2000);

    }
    handleChangeMonth(event) {
        this.month = event.detail.value;
        console.log('this.month ', this.month);
        this.spinner = true;
        setTimeout(() => {
            this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
            this.spinner = false;
        }, 2000);

    }
    handleChangeSalesdistrict(event) {
        console.log('id', event.detail.recId, ' Name ', event.detail.recName);
        this.sales_district = event.detail.recId;
        this.sales_district_name = event.detail.recName;
        this.distributorOption = [];
        this.distributor = '';
        this.disable_distributor = true;
        console.log('sales District 721 ' + this.sales_district);
        if (this.sales_district_name != '') {
            // getDistributor({sales_distric_id:this.sales_district}).then(distributors=>{
            //     console.log('Distributors ',distributors);
            //     distributors.forEach(ele=>{
            //         this.distributorOption = [...this.distributorOption,{label:ele.Name,value:ele.Id}];
            //     });
            //     this.disable_distributor = false;
            // }).catch(err=>{
            //     console.log('distributorOption err ',err);
            // });
            // }
            // this.distributorOption.unshift({label:'-All-',value:''});
            if (this.sales_district != '' && this.Sales_Org != '') {

                this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.Sales_District__c = '${this.sales_district}' and SalesOrg__r.Sales_Org_Code__c = '${this.Sales_Org}' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`
            } else if (this.sales_district != '' && this.Sales_Org == '') {
                this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.Sales_District__c = '${this.sales_district}' and (SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[0]}' OR SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[1]}') group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;
            } else {
                this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and (SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[0]}' OR SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[1]}') group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;
            }
            this.disable_distributor = this.isCommunityUsr?true:false;
        }
        this.spinner = true;
        setTimeout(() => {
            this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
            this.spinner = false;
        }, 2000);

    }
    handleChangeDistributor(event) {//Edit
        this.distributor = event.detail.recId;
        this.distributorName = event.detail.recName;
        console.log('Distributor ', this.distributor);
        this.spinner = true;
        setTimeout(() => {
            getSalesDistrictOnAccount({ acc_id: this.distributor }).then(data => {
                console.log('getSalesDistrictOnAccount ', data);
                if (data.Sales_District__c) {
                    this.sales_district = data.Sales_District__c;
                    this.sales_district_name = data.Sales_District__r.Name;
                    console.log(`763 sales_district ${this.sales_district} this.distributor ${this.distributor} this.Sales_Org ${this.Sales_Org} this.year ${this.year} this.month ${this.month}`)
                    console.log('Sales_District__r.Name ', data.Sales_District__r.Name);
                    // this.handleChangeSalesdistrict({detail:{recId:data.Sales_District__c,recName:data.Sales_District__r.Name}})
                }
                this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
                isActiveCommunity({accid:event.detail.recId}).then(isActive=>{
                    this.isActiveCommunity=isActive;
                    console.log('isActiveCommunity ',this.isActiveCommunity);
                }).catch(err=>{console.log('error isActiveCommunity'+err)});
               
            }).catch(err => {
                console.log('ERR ', err);
            });
            this.spinner = false;
        }, 2000);
        // this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
    }
    handleChangeSalesOrg(event) {
        this.Sales_Org = event.detail.value;
        console.log('Sales_Org ', this.Sales_Org);
        if (this.distributor != 'none' && this.emptysales_district == false) {
            this.distributor = '';
            this.distributorName = 'All';
        }
        if (this.Sales_Org != '') {

            this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and SalesOrg__r.Sales_Org_Code__c = '${this.Sales_Org}' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;
            if (this.sales_district != '') {
                this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.Sales_District__c = '${this.sales_district}' and SalesOrg__r.Sales_Org_Code__c = '${this.Sales_Org}' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`
            }
        } else {
            console.log('sales org array ', this.salesorg_arr);

            this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and (SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[0]}' OR SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[1]}') group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;

            if (this.sales_district != '') {
                this.distributor_filter = `AccountType__c='Sold To Party' and Distributor__r.RecordType.Name='Distributor' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.Sales_District__c = '${this.sales_district}' and (SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[0]}' OR SalesOrg__r.Sales_Org_Code__c = '${this.salesorg_arr[1]}') group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1`;
            }

        }
        this.spinner = true;
        this.liquidation_data = [];
        setTimeout(() => {
            this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
            this.spinner = false;
        }, 2000);

    }

    getMonthOptionByYear(year) {
        console.log('Year 762',year);
        this.spinner = true;
        if (this.user_country.toLocaleLowerCase().includes('indonesia') || this.user_country.toLocaleLowerCase().includes('turkey') || this.user_country.toLocaleLowerCase().includes('vietnam')) {
            getUserProfile().then(profile_name => {
                this.userProfileName = profile_name;
                this.monthOption = [];
                let monthval = new Date().getMonth();
                console.log('Profile  Name ', this.userProfileName);
                if (year == new Date().getFullYear()) {
                    for (let [key, val] of monthmaptemp) {
                        if (val == monthval) {
                            console.log('MOnth ', key);
                            break;
                        }
                        this.monthOption = [...this.monthOption, { label: key, value: key }];
                        this.month = key;
                    }
                } else {
                    for (let [key, val] of monthmaptemp) {
                        this.monthOption = [...this.monthOption, { label: key, value: key }];
                    }
                }
                if (this.userProfileName.includes('National sales Manager indonesia') || this.userProfileName.toLocaleLowerCase().includes('Supply Chain & QM Turkey'.toLocaleLowerCase() || this.userProfileName.includes('Vietnam National Sales Manager(NSM)') || this.isCommunityUsr)) {
                    if (monthval == 3) {
                        this.monthOption = [];
                        for (let [key, val] of monthmaptemp) {
                            this.monthOption = [...this.monthOption, { label: key, value: key }];
                        }
                        this.month = 'Mar';
                    }
                    if (monthval == 2) {
                        this.monthOption = [];
                        for (let [key, val] of monthmaptemp) {
                            this.monthOption = [...this.monthOption, { label: key, value: key }];
                        }
                        this.monthOption.pop();
                        this.month = 'Feb';
                    }
                } else {
                    if (monthval == 3) {
                        this.monthOption = [];
                        for (let [key, val] of monthmaptemp) {
                            this.monthOption = [...this.monthOption, { label: key, value: key }];
                        }
                        this.month = 'Mar';
                    }
                }
                console.log('month picklist ', this.monthOption);
                this.monthOption.unshift({ label: this.labels.None, value: '' });
                setTimeout(() => {
                    this.spinner = false;
                }, 2000);
            }).catch(err => {
                console.log('Prfile ERR', err);
            });
        } else {
            console.log('Country Name ------->', this.user_country);
        }
    }

    getLiquidation(t_salesDistrict, t_distributor, t_saleOrgCode, t_year, t_month, search_str) {
console.log('t_saleOrgCode'+t_saleOrgCode);
        this.liquidation_data = [];
        this.liquidation_to_submit = [];
        console.log('this.emptysales_district'+this.emptysales_district);
        // this.liquidation_found = false;
        // console.log(`LiquidationOnload select fields from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c ='${t_month}' and Distributor__c='${t_distributor}' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='2020-04-01' and Sales_District__c='${t_salesDistrict}' and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c= '${t_saleOrgCode}'  and RecordTypeId=:rec_type`);
        if (t_salesDistrict != '' && t_distributor != '' && t_year != '' && t_month !== '') {
            console.log('liquidationsdata');
            getAllLiquidation({ sales_district: t_salesDistrict, distributor: t_distributor, sales_org_code: t_saleOrgCode, year: t_year, month: t_month, searchstr: search_str }).then(data => {
                console.log('Liquidation data 878', data);
                let temp = [];
                let temp_for_submit = [];
                data.forEach(element => {
                    temp.push({
                        'Id': element.Id,
                        'Month__c': element.Month__c !== undefined ? element.Month__c : '',
                        'Brand': element.SKU__r.Brand_Name__c !== undefined ? element.SKU__r.Brand_Name__c : '',
                        'SKU_Code': element.SKU__r.SKU_Code__c !== undefined ? element.SKU__r.SKU_Code__c * 1 : '',
                        'SKU_Description': element.SKU__r.SKU_Description__c !== undefined ? element.SKU__r.SKU_Description__c : '',
                        'Opening_inventoryId': element.Opening_Inventory2__c !== undefined ? element.Opening_Inventory2__c : '',
                        'Opening_inventory': element.Opening_Inventory2__c !== undefined ? Number(element.Opening_Inventory2__r.Opening_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        'YTD_sales': element.YTD_Sales_formula__c !== undefined ? Number(element.YTD_Sales_formula__c).toLocaleString(this.number_saperator_code) : '',
                        'Total_Available_Stock': element.Total_Available_Stock__c !== undefined ? Number(element.Total_Available_Stock__c).toLocaleString(this.number_saperator_code) : '',
                        'Distributor_Inventory': element.Distributors_Inventory__c !== undefined ? Number(element.Distributors_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        'Retailers_Inventory': element.Retailers_Inventory__c !== undefined ? Number(element.Retailers_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        'Total_market_Inventory': element.Total_Market_Inventory__c !== undefined ? Number(element.Total_Market_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                        'plan_for_month': element.Plan_for_the_month__c !== undefined ? Number(element.Plan_for_the_month__c).toLocaleString(this.number_saperator_code) : '',
                        'Liquidation_YTD': element.Liquidation_YTD__c !== undefined ? Number(element.Liquidation_YTD__c).toLocaleString(this.number_saperator_code) : '',
                        'Liquidation_percentage_YTD': element.Liquidation_Percent_YTD__c !== undefined ? Number(element.Liquidation_Percent_YTD__c).toLocaleString(this.number_saperator_code) + ' %' : '0 %',
                        'Liquidation_YTD_per_plan_YTD': isFinite(element.Liquidation_YTD__c / element.Plan_for_the_month__c) ? Number(((element.Liquidation_YTD__c / element.Plan_for_the_month__c) * 100).toFixed(2)).toLocaleString(this.number_saperator_code) + ' %' : '0 %',
                        'Plan_for_next_month': element.Plan_for_the_next_month__c !== undefined ? Number(element.Plan_for_the_next_month__c).toLocaleString(this.number_saperator_code) : '',
                        'key_di': element.Id + '-di',
                        'key_ri': element.Id + '-ri',
                        'key_pfnm': element.Id + '-pfnm',
                        'loggedinRecord':(((element.LastModifiedBy.Id==this.user_id)||(element.LastModifiedBy.Profile.Name=='System Administrator'))||(element.LastModifiedBy.Profile.Name=='Sistem Yöneticisi') && ((element.Opening_Inventory2__r.LastModifiedBy.Id==this.user_id)||(element.Opening_Inventory2__r.LastModifiedBy.Profile.Name=='System Administrator')||(element.Opening_Inventory2__r.LastModifiedBy.Profile.Name=='Sistem Yöneticisi'))),
                        est:console.log("test 906",element.LastModifiedBy.Profile.Name,' System Administrator')
                    })
                    temp_for_submit.push(element.Id);
                    if (element.submitted__c == true) {
                        this.is_submitted = true;
                        this.disableAccesstoEdit(true, true,true, true);
                        this.disable_openingInventory = true;
                    } else {
                        this.is_submitted = false;
                        if (this.active_date_liquidation == true) {
                            this.disableAccesstoEdit(false, false,false, false);

                        } else {
                            this.disableAccesstoEdit(true, true,true, true);
                            console.log('disable all fields ', this.disable_fields);
                        }
                    }
                });
                console.log('temp',temp);
                this.liquidation_data = JSON.parse(JSON.stringify(temp));
                
                console.log('this.liquidation_data 903',this.liquidation_data);
                this.search_data = JSON.parse(JSON.stringify(temp));
                this.search_str = '';
                this.spinner = true;
                setTimeout(() => {
                    this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
                    if (this.liquidation_found == false) {
                        this.disable_submit_btn = true;
                    }
                    this.spinner = false;
                }, 2000);
                this.liquidation_to_submit = temp_for_submit;

            }).catch(err => {
                console.log('Err ', err);

            });
            
        } else if (t_salesDistrict == '' && this.emptysales_district == false) {
            // }if(t_salesDistrict==''){
                console.log('this.emptysales_district'+this.emptysales_district);
            console.log('Liquidation*** Roll up for All sales district only', this.sales_district);
            this.getRollUpLiquidation(t_salesDistrict);
        } else {
            console.log('waiting for All input!!');
        }
        // start
        if (t_salesDistrict != '' && t_distributor == '') {
            console.log('elseIf');
            console.log('this.emptysales_district'+this.emptysales_district);
            if (t_salesDistrict != 'none') {
                console.log('Liquidation*** Roll up SalesDistrict ', t_salesDistrict, 'And All Distributor');
                this.getRollUpLiquidation(t_salesDistrict);
            }
        }
        // End

    }

    getRollUpLiquidation(salesDistrict) {
        this.spinner = true;
        this.disableAccesstoEdit(true, true,true, true);
        console.log('this.lst_salesDistrictId ', this.lst_salesDistrictId);
        let str_salesdistrictids;
        console.log('map_rollupData ');
        if (salesDistrict != '') {
            str_salesdistrictids = JSON.stringify([]);
           
        } else {
            str_salesdistrictids = JSON.stringify(this.lst_salesDistrictId);
            
        }
        rollUpLiquidation({ lst_salesDistricts: str_salesdistrictids, sales_districts: salesDistrict, start_year: this.year, month: this.month, distributor: this.distributor, sales_org: this.Sales_Org }).then(map_rollupData => {

            // console.log('map_rollupData size', map_rollupData.size);
            let temp = [];
            // map_rollupData.forEach(element=>{
            let count = 0;
            for (let [key, element] of Object.entries(map_rollupData)) {
                temp.push({
                    'Id': element.Id,
                    'Month__c': element.Month__c !== undefined ? element.Month__c : '',
                    'Brand': element.Brand_Name__c !== undefined ? element.Brand_Name__c : '',
                    'SKU_Code': element.SKU_Code__c !== undefined ? element.SKU_Code__c * 1 : '',
                    'SKU_Description': element.SKU_Description__c !== undefined ? element.SKU_Description__c : '',
                    'Opening_inventoryId': element.Opening_Inventory2__c !== undefined ? element.Opening_Inventory2__c : '',
                    'Opening_inventory': element.Opening_Inventory_Wrap__c !== undefined ? Number(element.Opening_Inventory_Wrap__c).toLocaleString(this.number_saperator_code) : '',
                    'YTD_sales': element.YTD_Sales_Wrap__c !== undefined ? Number(element.YTD_Sales_Wrap__c).toLocaleString(this.number_saperator_code) : '',
                    'Total_Available_Stock': element.Total_Available_Stock_Wrap__c !== undefined ? Number(element.Total_Available_Stock_Wrap__c).toLocaleString(this.number_saperator_code) : '',
                    'Distributor_Inventory': element.Distributors_Inventory__c !== undefined ? Number(element.Distributors_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                    'Retailers_Inventory': element.Retailers_Inventory__c !== undefined ? Number(element.Retailers_Inventory__c).toLocaleString(this.number_saperator_code) : '',
                    'Total_market_Inventory': element.Total_Market_Inventory_Wrap__c !== undefined ? Number(element.Total_Market_Inventory_Wrap__c).toLocaleString(this.number_saperator_code) : '',
                    'plan_for_month': element.Plan_for_the_month__c !== undefined ? Number(element.Plan_for_the_month__c).toLocaleString(this.number_saperator_code) : '',
                    'Liquidation_YTD': element.Liquidation_YTD_Wrap__c !== undefined ? Number(element.Liquidation_YTD_Wrap__c).toLocaleString(this.number_saperator_code) : '',
                    'Liquidation_percentage_YTD': element.Liquidation_YTD_Percent_Wrap__c !== undefined ? Number(element.Liquidation_YTD_Percent_Wrap__c).toLocaleString(this.number_saperator_code) + ' %' : '0 %',
                    'Liquidation_YTD_per_plan_YTD': isFinite(element.Liquidation_YTD_Wrap__c / element.Plan_for_the_month__c) ? Number(((element.Liquidation_YTD_Wrap__c / element.Plan_for_the_month__c) * 100).toFixed(2)).toLocaleString(this.number_saperator_code) + ' %' : '0 %',
                    'Plan_for_next_month': element.Plan_for_the_next_month__c !== undefined ? Number(element.Plan_for_the_next_month__c).toLocaleString(this.number_saperator_code) : ''
                });
                count++;
            }
            console.log('map_rollupDatatemp', temp);
            this.liquidation_data = temp;
            this.search_data = temp;
            this.search_str = '';
            this.sortData('Total_Available_Stock', 'desc');
            this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
            if (this.liquidation_found == false) {
                this.disable_submit_btn = true;
            }

        }).then(err => {
            console.log('map_rollupERR ', err);
            this.spinner = false;
        });
    }

    handleCellChanges(event) {
        var theEvent = event || window.event;
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
        console.log('Key cell ', key);
        var regex = /[0-9]|\./;
        if (!regex.test(key)) {
            theEvent.returnValue = false;
        }
        this.timeoutId = setTimeout(this.doActionCellChange.bind(this, event.target), 1500);
    }
    doActionCellChange(target) {
        console.log(`Id ${target.id.split('-')[0]} fieldName ${target.name} data ${target.value}`);
        console.log('target.value -->', target.value);
        if (target.id.split('-')[0] != undefined && target.name != '' && target.name != this.fieldsapiname.Opening_inventory) {
            this.handleSaveChanges(target.id.split('-')[0], target.name, target.value.replaceAll(',', '').replaceAll('.', ''), target.dataset.key);
        }
        if (target.dataset.id) {
            console.log(`Liquidation Id ${target.id.split('-')[0]} Opening_inventoryId ${target.dataset.id}Name ${target.name} Value ${target.value}`);
            let liq = JSON.parse(JSON.stringify(this.liquidation_data));
            console.log('liqi ', liq);
            let temp = liq.find(ele => ele.Id == target.id.split('-')[0]);
            console.log('temp ', temp);
            if (parseInt(temp.Total_market_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) <= parseInt(target.value.replaceAll(',', '').replaceAll('.', '')) + parseInt(temp.YTD_sales.toString().replaceAll(',', '').replaceAll('.', ''))) {
                updateOpeningInventory({ oi_id: target.dataset.id, value: target.value.replaceAll(',', '').replaceAll('.', '') }).then(data => {
                    console.log('Update value ', data);
                    setTimeout(() => {
                        let update_val = this.search_data.find(ele => ele.Id == target.id.split('-')[0]);
                        console.log('OpIN1', Number(target.value.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code), 'val ', target.value);
                        update_val.Opening_inventory = Number(target.value.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code);
                        console.log('update val ', update_val);
                    }, 1000);
                }).catch(err => {
                    console.log('Update Opening Inventory ERR', err)
                });
            } else {
                if (!Number.isNaN(parseInt(target.value.replaceAll(',', '').replaceAll('.', '')) + parseInt(temp.YTD_sales.toString().replaceAll(',', '').replaceAll('.', '')))) {
                    this.showToastmessage(this.labels.toast_err, this.labels.market_inventory_validation, 'error');
                }
                console.log('op ->', this.template.querySelector(`lightning-input[data-id=${target.dataset.id}]`));
                this.template.querySelector(`lightning-input[data-id=${target.dataset.id}]`).value = '0';
            }
        }
        
        setTimeout(() => {
            this.implement_formula(target.id.split('-')[0], target.value.replaceAll(',', '').replaceAll('.', ''), target.name);
        }, 1000);
    }
    handleSaveChanges(record_id, fieldname, value, key) {
        this.liqidation_obj = {
            Id: record_id
        }
        this.liqidation_obj[fieldname] = value;
        console.log('liquidation obj', this.liqidation_obj);
        if (fieldname != this.fieldsapiname.plan_for_next_month) {
            let liq = JSON.parse(JSON.stringify(this.liquidation_data));
            let temp = liq.find(ele => ele.Id == record_id);

            if (fieldname == this.fieldsapiname.Distributor_inventory) {
                // console.log('obj -->',this.liqidation_obj);
                if (parseInt(temp.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) >= parseInt(temp.Retailers_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) + parseInt(value)) {
                    saveLiquidation({ liq: this.liqidation_obj }).then(data => {
                        let update_val = this.search_data.find(ele => ele.Id == record_id);
                        update_val.Distributor_Inventory = Number(value).toLocaleString(this.number_saperator_code);
                        console.log('update val ', update_val);
                    }).catch(err => {
                        console.log('saveLiquidation ERR', err);
                    });
                } else {
                    if (!Number.isNaN(parseInt(temp.Retailers_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) + parseInt(value))) {
                        this.showToastmessage(this.labels.toast_err, this.labels.market_inventory_validation, 'error');
                    }
                    console.log('Key ', key);
                    console.log('Di starts', this.template.querySelector(`lightning-input[data-key=${key}]`));
                    this.template.querySelector(`lightning-input[data-key=${key}]`).value = 0;
                }
            }
            if (fieldname == this.fieldsapiname.Retailerinventory) {
                if (parseInt(temp.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) >= parseInt(temp.Distributor_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) + parseInt(value)) {
                    saveLiquidation({ liq: this.liqidation_obj }).then(data => {
                        let update_val = this.search_data.find(ele => ele.Id == record_id);
                        update_val.Retailers_Inventory = Number(value).toLocaleString(this.number_saperator_code);
                        console.log('update val ', update_val);
                        // console.log('Data ',value);
                    }).catch(err => {
                        console.log('saveLiquidation ERR', err);
                    });
                } else {
                    if (!Number.isNaN(temp.Distributor_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) + parseInt(value)) {
                        this.showToastmessage(this.labels.toast_err, this.labels.market_inventory_validation, 'error');
                    }
                    this.template.querySelector(`lightning-input[data-key=${key}]`).value = 0;
                }
            }
        } else {
            console.log('update plan for next month', this.liqidation_obj.Plan_for_the_next_month__c);
            if (value != '') {
                updatePlanForMonth({ liq: this.liqidation_obj }).then(data => {
                    let update_val = this.search_data.find(ele => ele.Id == record_id);
                    update_val.Plan_for_next_month = Number(value).toLocaleString(this.number_saperator_code);
                    console.log('update val ', update_val);
                    console.log('Data ', value);
                }).catch(err => {
                    console.log('saveLiquidation plan for next month ERR', err);
                });
            } else {
                this.template.querySelector(`lightning-input[data-key=${key}]`).value = 0;
            }
        }
    }
    handleSubmit(event) {
        console.log('submit ->', JSON.stringify(this.liquidation_to_submit));
        this.spinner = true;
        submitLiquidation({ lst_liq: JSON.stringify(this.liquidation_to_submit) }).then(is_success => {
            console.log('submit status ', is_success);
            setTimeout(() => {
                if (is_success == true) {
                    this.disableAccesstoEdit(true, true,true, true);
                    this.is_submitted = true;
                    this.showToastmessage(this.labels.toast_success, this.labels.Liquidation_submitted_Successfully, 'success');
                }
                this.spinner = false;
            }, 1000);

        }).catch(err => {
            this.disable_submit_btn = false;
            this.showToastmessage(this.labels.toast_err, this.labels.Error_while_submitting_Liquidation, 'error');
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
    disableAccesstoEdit(submit_btn, fields,distributorInventory, upload_btn) {
        // this.disable_submit_btn = submit_btn;
        this.disable_submit_btn = this.isActiveCommunity&&this.isCommunityUsr==false?true:submit_btn;
        this.disable_fields = this.isCommunityUsr?true:fields;
        this.disable_fieldsdistributorInventory = this.isCommunityUsr && !this.is_submitted ?false:distributorInventory;
        this.disable_upload_btn = upload_btn;
    }
    handlesearch(event) {
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
                this.spinner = false;
            }, 500);
        } else {
            setTimeout(() => {
                this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
                this.flag_search = false;
                this.spinner = false;
            }, 2000);
            // this.liquidation_data = this.search_data;
            this.spinner = false;
        }
    }
    implement_formula(temp_id, temp_val, temp_name) {
        this.liquidation_data.forEach(liq => {
            if (liq.Id == temp_id && temp_name == this.fieldsapiname.Distributor_inventory) {
                liq.Distributor_Inventory = Number(temp_val.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code);
                liq.Total_market_Inventory = parseFloat(temp_val) + parseFloat(liq.Retailers_Inventory.toString().replaceAll(',', '').replaceAll('.', ''));
                liq.Total_market_Inventory = Number.isNaN(liq.Total_market_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) ? 0 : Number(liq.Total_market_Inventory).toLocaleString(this.number_saperator_code);
            }
            if (liq.Id == temp_id && temp_name == this.fieldsapiname.Retailerinventory) {
                liq.Retailers_Inventory = Number(temp_val.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code);
                liq.Total_market_Inventory = parseFloat(liq.Distributor_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) + parseFloat(temp_val);
                liq.Total_market_Inventory = Number.isNaN(liq.Total_market_Inventory.toString().replaceAll(',', '').replaceAll('.', '')) ? 0 : Number(liq.Total_market_Inventory).toLocaleString(this.number_saperator_code);
            }
            if (liq.Id == temp_id && temp_name == this.fieldsapiname.Opening_inventory) {
                console.log('OpIN2', Number(temp_val.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code), 'val ', temp_val);
                liq.Opening_inventory = Number(temp_val.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code);
                liq.Total_Available_Stock = parseFloat(temp_val) + parseFloat(liq.YTD_sales.toString().replaceAll(',', '').replaceAll('.', ''));
                // console.log('Total_Available_Stock ', liq.Total_Available_Stock);
                liq.Total_Available_Stock = Number.isNaN(liq.Total_Available_Stock) ? 0 : Number(liq.Total_Available_Stock).toLocaleString(this.number_saperator_code);
            }
            if (liq.Id == temp_id) {
                liq.Liquidation_YTD = parseFloat(liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) - parseFloat(liq.Total_market_Inventory.toString().replaceAll(',', '').replaceAll('.', ''));
                liq.Liquidation_YTD = Number.isNaN(liq.Liquidation_YTD) ? 0 : Number(liq.Liquidation_YTD).toLocaleString(this.number_saperator_code);

                liq.Liquidation_percentage_YTD = isFinite(Number(parseFloat(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) * 100).toFixed(2)))) ? Number(parseFloat(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) * 100).toFixed(2))).toLocaleString(this.number_saperator_code) + '%' : '0 %';

                liq.Liquidation_YTD_per_plan_YTD = isFinite(liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.plan_for_month.toString().replaceAll(',', '').replaceAll('.', '')) ? Number(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.plan_for_month.toString().replaceAll(',', '').replaceAll('.', '')) * 100).toFixed(2)).toLocaleString(this.number_saperator_code) + ' %' : '0 %';
            }
        });
    }
    handleRemoveSalesdistrict() {
        this.sales_district = '';
        this.sales_district_name = '';
        this.distributorOption = [];
        this.distributor = '';
        this.distributorName = '';
        this.disable_distributor = true;
    }
    handleRemoveDistributor() {
        this.distributor = '';
        this.distributorName = '';
    }

    serachInlist(str) {
        let templiq = [];
        this.search_data.forEach(element => {
            element = JSON.parse(JSON.stringify(element));
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
        if (fieldname == 'Total_market_Inventory') {
            this.Total_Market_Inventory_sortDirection = !this.Total_Market_Inventory_sortDirection;
            str = this.Total_Market_Inventory_sortDirection == true ? 'asc' : 'des';
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
                // console.log('liquidation ele ', ele);
            });
            this.liquidation_data = this.search_data;
        }
        // console.log('sort data ->', JSON.parse(JSON.stringify(this.liquidation_data)));
    }
    sortData(fieldName, sortDirection) {
        if (fieldName == 'Liquidation_percentage_YTD') {
            this.search_data = [];
            this.liquidation_data.forEach(ele => {
                ele.Liquidation_percentage_YTD = parseInt(ele.Liquidation_percentage_YTD.replace(' %', ''));
                this.search_data.push(ele);
                // console.log('liquidation ele ', ele);
            });
            this.liquidation_data = this.search_data;
        }
        // console.log('sort search', this.search_data);
        // console.log('sort liq ', this.liquidation_data);
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



    handleUploadCSV() {
        this.spinner = true;
        setTimeout(() => {
            this.spinner = false;
            this.openModel = true;
        }, 1500);
    }
    handleCloseModel() {
        this.openModel = false;
    }
    refreshLiquidation(event) {
        this.spinner = true;
        setTimeout(() => {
            if (event.detail == true) {
                this.getLiquidation(this.sales_district, this.distributor, this.Sales_Org, this.year, this.month, '');
            }
            this.spinner = false;
        }, 2000);
    }
    handlePlaceholder(event) {
        console.log('Placeholder onclick')
        if (event.target.name == this.fieldsapiname.Opening_inventory) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-id=${event.target.dataset.id}]`).value = '';
            }
        }
        if (event.target.name == this.fieldsapiname.Distributor_inventory) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = '';
            }
        }
        if (event.target.name == this.fieldsapiname.Retailerinventory) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = '';
            }
        }
        if (event.target.name == this.fieldsapiname.plan_for_next_month) {
            if (event.target.value == 0 && event.target.disabled == false) {
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
        if (event.target.name == this.fieldsapiname.Retailerinventory) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = 0;
            }
        }
        if (event.target.name == this.fieldsapiname.plan_for_next_month) {
            if (event.target.value == 0 && event.target.disabled == false) {
                this.template.querySelector(`lightning-input[data-key=${event.target.dataset.key}]`).value = 0;
            }
        }
    }

    /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    downloadPDF() {
        this.pogPDFUrl = '/apex/GRZ_Vietnam_Indo_TurkeyPDF?sales_district=' + this.sales_district+ '&distributor=' + this.distributor
            + '&year=' + this.year + '&Sales_Org=' + this.Sales_Org + '&month=' + this.month + '&searchValue=' + this.search_str  + '&columnTrue=' +this.columnTrue;
             

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

    downloadXLS() {

        this.pogXLSUrl = '/apex/GRZ_Vietnam_Indo_TurkeyXLS?sales_district=' + this.sales_district+ '&distributor=' + this.distributor
        + '&year=' + this.year + '&Sales_Org=' + this.Sales_Org + '&month=' + this.month + '&searchValue=' + this.search_str+ '&columnTrue=' +this.columnTrue;

 console.log('value' + this.pogXLSUrl);

        this.spinner = true;
        const downloadLink = document.createElement("a");
        downloadLink.href = this.pogXLSUrl;
        downloadLink.target = '_new';
        downloadLink.download = 'POGReport.xls';
        downloadLink.click();
        setTimeout(() => {
            this.spinner = false;
        }, 6000);
    }

    /* --*/
	

}