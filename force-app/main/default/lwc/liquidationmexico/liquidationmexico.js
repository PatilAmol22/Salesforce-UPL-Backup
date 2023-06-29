import { LightningElement, track, wire } from 'lwc';
import UOM from '@salesforce/label/c.UOM';
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
import Ship_to_Party from '@salesforce/label/c.Ship_To_Party';
import getSalesOrg from '@salesforce/apex/LiquidationMexico.getSalesOrg';
import object_liquidationAnnualPlan from '@salesforce/schema/Liquidation_Annual_Plan__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import FIscal_Year__c from '@salesforce/schema/Liquidation_Annual_Plan__c.FIscal_Year__c';
import getcountry from '@salesforce/apex/LiquidationMexico.getUserCountry';
import getUserProfile from '@salesforce/apex/LiquidationMexico.getUserProfile';
import getLogedInUserId from '@salesforce/apex/LiquidationMexico.getLogedInUserId';
import getLiquidationEditDates from '@salesforce/apex/LiquidationMexico.getLiquidationEditDates';
import getOpeningInventoryEditDates from '@salesforce/apex/LiquidationMexico.getOpeningInventoryEditDates';
import getAllLiquidation from '@salesforce/apex/LiquidationMexico.getAllLiquidation';
import Distributor_inventory_field from '@salesforce/schema/Liquidation2__c.Distributors_Inventory__c';
import Retailer_inventory_field from '@salesforce/schema/Liquidation2__c.Retailers_Inventory__c';
import Plan_for_next_month_field from '@salesforce/schema/Liquidation2__c.Plan_for_the_next_month__c';
import LIQUIDATION_OBJECT from '@salesforce/schema/Liquidation2__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateOpeningInventory from '@salesforce/apex/LiquidationMexico.updateOpeningInventory';
import saveLiquidation from '@salesforce/apex/LiquidationMexico.saveLiquidation';
import submitLiquidation from '@salesforce/apex/LiquidationMexico.submitLiquidation';
import updatePlanForMonth from '@salesforce/apex/LiquidationMexico.updatePlanForMonth';
import getSalesDistrict from '@salesforce/apex/LiquidationMexico.getSalesDistrict';
import getDistributor from '@salesforce/apex/LiquidationMexico.getDistributor';
import rollUpLiquidation from '@salesforce/apex/LiquidationMexico.rollUpLiquidation';
import getSalesDisctrictForShipToParty from '@salesforce/apex/LiquidationMexico.getSalesDisctrictForShipToParty';
import getDistributorForShipToParty from '@salesforce/apex/LiquidationMexico.getDistributorForShipToParty';
import All from '@salesforce/label/c.All';
import None from '@salesforce/label/c.None';
import DownloadPDF from "@salesforce/label/c.Grz_DownloadPFD";  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
import DownloadXLS from "@salesforce/label/c.Grz_DownloadXLS";  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
import Icons from "@salesforce/resourceUrl/Grz_Resourse";  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */

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
const profileCanEditLiquidation = ['Regional/Zonal Managers for Mexico', 'Territory Manager for Mexico'];
export default class Liquidationmexico extends LightningElement {
    @track labels = { All: All, None: None };
    @track Sales_Org = '';
    @track sales_district = '';
    @track distributor = '';
    @track ship_to_Party = '';
    @track sales_district_name = this.labels.All;
    @track distributorName = '';
    @track shipToPartyName = '';
    @track spinner = false;
    @track salesdistrict_filter = '' //`Sales_District__c!=null  and Sales_Org_Code__c='5100'`;
    @track distributor_filter = '' //`Distributor__c!=null`;
    @track ship_to_party_filter = ''//`Sales_Org__r.Sales_Org_Code__c='5100'`;
    @track record_type = '';
    @track salesDistrictOption = [{ label: this.labels.All, value: '' }]; // label:name value:Id
    @track distributorOption = [{ label: this.labels.All, value: '' }];   // label:name value:Id  
    @track salesOrgOption = [{ label: this.labels.All, value: '' }];
    @track yearOption = [{ label: this.labels.None, value: '' }];          // label:name value:Id
    @track monthOption = [{ label: this.labels.None, value: '' }];
    @track user_country = '';
    @track number_saperator_code = '';
    @track month = '';
    @track year = '';
    @track disable_month = false;
    @track userProfileName = '';
    @track user_id = '';
    @track hasRenderedMonth = false;
    @track liquidation_found = true;
    @track liquidation_data = [];
    @track active_date_liquidation = false;
    @track active_date_OpeningInventory = false;
    @track is_submitted = false;
    @track disable_fields = false;
    @track disable_upload_btn = false;
    @track disable_submit_btn = false;
    @track disable_openingInventory = true;
    @track disable_salesDistrict = false;
    @track disable_distributor = false;
    @track disable_shipToParty = false;
    @track is_editable = true;
    @track liqidation_obj = LIQUIDATION_OBJECT;
    @track liquidation_to_submit = [];
    @track lst_salesDistrictId = [];
    @track lst_distributorId = [];
    @track search_str = '';
    @track hasRendered = true;
    @track flag_search = false;
    @track temp_data = [];
    @track hide_uploadbtn = false;
    @track hasRenderedProfile = true;
    @track salesorg_arr = [];
    @track brand_sortDirection = true;
    @track SKU_Code_sortDirection = true;
    @track SKU_Description_sortDirection = true;
    @track Total_Available_Stock_sortDirection = true;
    @track Total_Market_Inventory_sortDirection = true;
    @track Liquidation_percentage_YTD_sortDirection = true;
    @track search_data = [];
    @track hide_col = '';
    @track hidebyid = '13';
    @track hasColumnhide = true;
    @track emptysales_district = false;
    @track selected_year = '';
    @track salesDistrictOption = [];
    @track first_filter = true;

    downloadIcon = Icons + "/Grz_Resourse/Images/DownloadIcon.png";  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    labels = {
        UOM: UOM,
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
        Ship_to_Party: Ship_to_Party,
        All: All,
        None: None,
        DownloadPDF: DownloadPDF,  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
        DownloadXLS: DownloadXLS  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    }

    @track columns = [
        { Id: 1, label: this.labels.SKU_Code, fieldName: 'SKU_Code', type: 'text', initialWidth: 120, sortable: true },
        { Id: 2, label: this.labels.SKU_Description, fieldName: 'SKU_Description', type: 'text', initialWidth: 150, sortable: true },
        { Id: 3, label: this.labels.UOM, fieldName: 'UOM', type: 'text', initialWidth: 100, sortable: true },
        { Id: 4, label: this.labels.Opening_Inventory, fieldName: 'Opening_inventory', type: 'text', initialWidth: 180, editable: this.is_editable, largewidth: true },
        { Id: 5, label: this.labels.ytd_sales, fieldName: 'YTD_sales', type: 'text', initialWidth: 280 },
        { Id: 6, label: this.labels.Total_Available_Stock, fieldName: 'Total_Available_Stock', type: 'text', initialWidth: 200, sortable: true },
        { Id: 7, label: this.labels.Distributor_Inventory, fieldName: 'Distributor_Inventory', type: 'text', initialWidth: 125, editable: this.is_editable },
        { Id: 8, label: this.labels.Retailer_Inventory, fieldName: 'Retailers_Inventory', type: 'text', initialWidth: 180, editable: this.is_editable },
        { Id: 9, label: this.labels.Total_Market_Inventory, fieldName: 'Total_market_Inventory', type: 'text', sortable: true },
        { Id: 10, label: this.labels.Plan_YTD_May, fieldName: 'plan_for_month', type: 'text', initialWidth: 150 },
        { Id: 11, label: this.labels.Liquidation_YTD, fieldName: 'Liquidation_YTD', type: 'text', initialWidth: 280 },
        { Id: 12, label: this.labels.Liquidation_YTD_Selected_Month, fieldName: 'Liquidation_percentage_YTD', type: 'text', initialWidth: 280, sortable: true },
        { Id: 13, label: this.labels.Plan_for_Next_Month, fieldName: 'Plan_for_next_month', type: 'text', initialWidth: 200, editable: this.is_editable }
    ];
    @track fieldsapiname = {
        'Opening_inventory': 'Opening_Inventory2__c',
        'Distributor_inventory': Distributor_inventory_field.fieldApiName,
        'Retailerinventory': Retailer_inventory_field.fieldApiName,
        'plan_for_next_month': Plan_for_next_month_field.fieldApiName,
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
                if (element.value.split('-')[0] == new Date().getFullYear() || element.value.split('-')[0] == new Date().getFullYear() - 1) {
                    this.year = element.value.split('-')[0];
                    this.selected_year = element.value;
                    // this.getMonthOptionByYear(this.year);
                }
            });
            // console.log("2");
            this.yearOption.unshift({ label: '-None-', value: '' });
            this.spinner = false;
        }
        if (error) {
            console.log('error ', error);
            this.spinner = false;
        }
    };

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
    @wire(getLiquidationEditDates)
    getLiquidationDate({ error, data }) {
        this.spinner = true;
        console.log('Error ', error, 'Data Liquidation', data);
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
        console.log('Error ', error, 'Data OpeningInventory', data);
        this.spinner = true;
        if (data) {
            this.active_date_OpeningInventory = JSON.parse(data);
            console.log('this.active_date_OpeningInventory -----> ', this.active_date_OpeningInventory = JSON.parse(data))
            if (this.active_date_OpeningInventory == true) {
                this.disable_openingInventory = false;
            } else {
                this.disable_openingInventory = true;
            }
            this.spinner = false;
        }
        if (error) {
            console.log('getLiquidationDate ', error);
            this.spinner = false;
        }
    }
    @wire(getSalesDistrict)
    getSalesDistricts({ error, data }) {
        this.spinner = true;
        console.log('list of sales_district', data);
        this.salesDistrictOption = [];
        this.lst_salesDistrictId = [];
        this.sales_district = '';
        if (data) {
            data.forEach(ele => {
                // this.salesDistrictOption = [...this.salesDistrictOption,{label:ele.Name,value:ele.Id}];
                // this.lst_salesDistrictId.push(ele. Distributor__r.Sales_District__c);
                this.lst_salesDistrictId.push(ele.Distributor__r.Sales_District__c);
            });
            this.salesDistrictOption.unshift({ label: this.labels.All, value: '' });
            this.spinner = false;
            if (data.length == 0) {
                this.emptysales_district = true;
            }
        }

        if (error) {
            console.log('Sales District err', error);
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

    @wire(getDistributor)
    getAllDistributor({ error, data }) {
        console.log('list of distributor ', data);
        if (data) {
            data.forEach(ele => {
                this.lst_distributorId.push(ele.Distributor__c);
            });
        }
        if (error) {
            console.log('ERR getAllDistributor ', error);
        }
    }



    renderedCallback() {
        console.log('when select All sales district ', this.sales_district_name, 'translated label ', this.labels.All)
        if (this.user_id != '' && this.userProfileName != '') {
            console.log(`sales_district ${this.sales_district} this.distributor ${this.distributor} this.ship_to_party ${this.ship_to_Party} this.Sales_Org ${this.Sales_Org} this.year ${this.year} this.month ${this.month}`)
            if (this.first_filter) {
                if (this.userProfileName == 'Territory Manager for Mexico') {
                    this.salesdistrict_filter = ` Distributor__r.Sales_District__c!=null and User__c='${this.user_id}' and Sales_Org_Code__c='5100' and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    this.distributor_filter = ` Distributor__c!=null and User__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true `;
                } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                    this.distributor_filter = ` Distributor__c!=null and Regional_manager__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    this.salesdistrict_filter = ` Distributor__r.Sales_District__c!=null and Regional_manager__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                } else {
                    this.distributor_filter = ` Distributor__c!=null and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    this.salesdistrict_filter = ` Distributor__r.Sales_District__c!=null and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                }
                this.first_filter = false;
            }
            console.log('query updated -->', this.ship_to_party_filter);
            if (this.year != '' && this.hasRenderedMonth == false) {
                if (this.sales_district_name == this.labels.All) {
                    // this.distributor_filter = `SalesOrg__r.Sales_Org_Code__c='5100' and Distributor__r.RecordType.Name='Distributor' and AccountOwner__c='${this.user_id}' and  Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"',"'").replaceAll("[","(").replaceAll("]",")")}`;
                    if (this.userProfileName == 'Territory Manager for Mexico') {
                        this.distributor_filter = ` Distributor__c!=null and User__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                        this.distributor_filter = ` Distributor__c!=null and Regional_manager__c='${this.user_id}' and Sales_Org_Code__c='5100' and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else {
                        this.distributor_filter = ` Distributor__c!=null and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    }

                } else {
                    // this.distributor_filter = `SalesOrg__r.Sales_Org_Code__c='5100' and Distributor__r.RecordType.Name='Distributor' and AccountOwner__c='${this.user_id}'`;
                    if (this.userProfileName == 'Territory Manager for Mexico') {
                        this.distributor_filter = ` Distributor__c!=null and User__c='${this.user_id}' and Distributor__r.Sales_District__c = '${this.sales_district}' and Sales_Org_Code__c='5100' and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                        this.distributor_filter = ` Distributor__c!=null and Regional_manager__c='${this.user_id}' and Distributor__r.Sales_District__c = '${this.sales_district}' and Sales_Org_Code__c='5100' and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else {
                        this.distributor_filter = ` Distributor__c!=null and Distributor__r.Sales_District__c = '${this.sales_district}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    }
                }
                if (this.userProfileName == 'Territory Manager for Mexico') {
                    this.salesdistrict_filter = ` Distributor__r.Sales_District__c!=null and User__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                    this.salesdistrict_filter = ` Distributor__r.Sales_District__c!=null and Regional_manager__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                } else {
                    this.salesdistrict_filter = ` Distributor__r.Sales_District__c!=null  and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                }
                if (this.sales_district_name == this.labels.All && this.distributorName == this.labels.All) {
                    if (this.userProfileName == 'Territory Manager for Mexico') {
                        this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and (Distributor__c IN ${JSON.stringify(this.lst_distributorId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")} OR Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")})  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                        this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}' and (Distributor__c IN ${JSON.stringify(this.lst_distributorId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")} OR Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")})  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else {
                        this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100'  and (Distributor__c IN ${JSON.stringify(this.lst_distributorId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")} OR Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")})  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    }
                } else if (this.hasRenderedMonth == false) {
                    if (this.userProfileName == 'Territory Manager for Mexico') {
                        this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                        this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    } else {
                        this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                    }
                }
                this.getMonthOptionByYear(this.year);
                if (this.month != '') {
                    console.log('get liquidation')
                    this.getLiquidation(this.Sales_Org, this.sales_district, this.distributor, this.ship_to_Party, this.year, this.month, '');
                    this.hasRenderedMonth = true;
                }
            }
        }
        if (this.userProfileName) {
            if (this.is_submitted == false) {
                if (this.active_date_OpeningInventory == true) {
                    if (this.sales_district == '' || this.distributor == '' || this.ship_to_Party == '' || this.year == '' || this.month == '') {
                        this.disable_openingInventory = true;
                    } else {

                        if (this.userProfileName == 'Territory Manager for Mexico') {
                            let monthval = new Date().getMonth(); // current month
                            let monthmap = monthmaptemp.get(this.month) + 1;
                            if (monthmap == 12) {
                                monthmap = monthmaptemp.get('Jan');
                            }
                            if (monthval == monthmap) {
                                this.disable_openingInventory = false;
                            } else {
                                this.disable_openingInventory = true;
                                this.disableAccesstoEdit(true, true, true);
                            }
                        }
                        // Supply Chain & QM Turkey
                        if (this.userProfileName.toLocaleLowerCase().includes('Regional/Zonal Managers for Mexico'.toLowerCase())) {
                            console.log('this.month -->', this.month);
                            console.log('Current month1  - ', monthmaptemp.get(this.month) + 2); // one prev month
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
                            } else {
                                this.disable_openingInventory = true;
                                this.disableAccesstoEdit(true, true, true);
                            }
                        }
                    }
                }
                if (profileCanEditLiquidation.includes(this.userProfileName) == false) {
                    this.disable_fields = true;
                    this.disable_submit_btn = true;
                    this.hide_uploadbtn = true;
                    this.disable_upload_btn = true;
                    this.disable_openingInventory = true;
                }
                if (this.userProfileName == 'Territory Manager for Mexico') {
                    console.log('Current month2  - ', monthmaptemp.get(this.month) + 1); // one prev month
                    let monthval = new Date().getMonth(); // current month
                    let monthmap = monthmaptemp.get(this.month) + 1;
                    if (monthmap == 12) {
                        monthmap = monthmaptemp.get('Jan'); // Edit 02-01-2021
                    }
                    console.log('Current month2 ', monthval);
                    console.log('Current month  res ', monthmap != monthval);
                    if ((this.sales_district != '' || this.sales_district != 'none') && (this.distributor != '' && this.distributor != 'none') && (this.ship_to_Party != '' && this.ship_to_Party != 'none')) {
                        if (monthmap != monthval) {
                            this.disable_fields = true;
                            this.disable_submit_btn = true;
                            this.hide_uploadbtn = false;
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

                            console.log('this.active_date_OpeningInventory = true;');
                        } else {
                            if (this.active_date_liquidation == true) {
                                if (this.liquidation_found == true) {
                                    this.disableAccesstoEdit(false, false, false);
                                } else {
                                    this.disableAccesstoEdit(true, true, true);
                                }
                                this.hide_uploadbtn = false;
                            }
                            this.disable_openingInventory = this.active_date_OpeningInventory == true ? false : true;
                        }
                        //    }else{
                        //     // this.active_date_OpeningInventory = false;
                        //     console.log('this.active_date_OpeningInventory = false;');
                        //    }
                    } else {
                        this.disable_submit_btn = true;
                        // this.disable_upload_btn = true;
                        this.disable_fields = true;
                        this.hide_uploadbtn = false;
                        if (this.sales_district != '' && this.year != '' && this.month != '') {
                            this.disable_upload_btn = false;
                        } else {
                            this.disable_upload_btn = true;
                        }
                    }
                }
                // Start
                if (this.userProfileName.toLocaleLowerCase().includes('Regional/Zonal Managers for Mexico'.toLowerCase())) {
                    // this.hide_uploadbtn = true; 
                    this.hide_uploadbtn = false;//added by srinkanth
                    // this.disable_submit_btn = true;
                    // one prev month
                    let monthval = new Date().getMonth(); // current month
                    let monthmap = monthmaptemp.get(this.month) + 2;
                    console.log('Current month3  this month - ', this.month);
                    console.log('Current month3  - ', monthmap);
                    if (monthmap == 12) {
                        monthmap = monthmaptemp.get('Jan');
                    }
                    if (monthmap == 13) {
                        monthmap = monthmaptemp.get('Feb');
                    }
                    console.log('Current month2 ', monthval);
                    console.log('Current month  res ', monthmaptemp.get(this.month) != monthval); // Need to change logic
                    if ((this.sales_district != '' && this.sales_district != 'none') && (this.distributor != '' && this.distributor != 'none') && (this.ship_to_Party != '' && this.ship_to_Party != 'none')) {
                        if (monthmap != monthval) {
                            this.disable_fields = true;
                            // this.active_date_OpeningInventory = true;
                            // if(this.hasRenderedProfile==true){
                            //     this.disable_openingInventory = true;
                            //     this.hasRenderedProfile = false;
                            // }else{
                            //     this.active_date_OpeningInventory = false;
                            // }
                            if (this.hasRenderedProfile == true) {
                                this.disable_openingInventory = true;
                                this.hasRenderedProfile = false;
                            }
                        } else {
                            if (this.active_date_liquidation == true) {
                                this.disableAccesstoEdit(false, false, false);
                            }
                            // this.disable_openingInventory = this.active_date_OpeningInventory==true?false:true;
                            // this.hide_uploadbtn = false;
                        }
                    }
                }
            } else {
                this.disableAccesstoEdit(true, true, true);
                this.disable_openingInventory = true;
                // this.hide_uploadbtn = true;
            }
        }
    }

    handleChangeSalesdistrict(event) {
        console.log('id', event.detail.recId, ' Name ', event.detail.recName);
        this.sales_district = event.detail.recId;
        this.sales_district_name = event.detail.recName;
        if (this.sales_district_name != '') {
            // this.distributor_filter = `SalesOrg__r.Sales_Org_Code__c='5100' and Distributor__r.RecordType.Name='Distributor' and AccountOwner__c='${this.user_id}' and  Distributor__r.Sales_District__c='${this.sales_district}'`;
            if (this.userProfileName == 'Territory Manager for Mexico') {
                this.distributor_filter = ` Distributor__c!=null and User__c='${this.user_id}' and Distributor__r.Sales_District__c = '${this.sales_district}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                this.distributor_filter = ` Distributor__c!=null and Regional_manager__c='${this.user_id}' and Distributor__r.Sales_District__c = '${this.sales_district}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else {
                this.distributor_filter = ` Distributor__c!=null and  Distributor__r.Sales_District__c = '${this.sales_district}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            }
            if (this.sales_district_name == this.labels.All) {
                // this.distributor_filter = `SalesOrg__r.Sales_Org_Code__c='5100' and Distributor__r.RecordType.Name='Distributor' and AccountOwner__c='${this.user_id}' and  Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"',"'").replaceAll("[","(").replaceAll("]",")")}`;
                if (this.userProfileName == 'Territory Manager for Mexico') {
                    this.distributor_filter = ` Distributor__c!=null and User__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                    this.distributor_filter = ` Distributor__c!=null and Regional_manager__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                } else {
                    this.distributor_filter = ` Distributor__c!=null and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
                }

            }
            this.getLiquidation(this.Sales_Org, this.sales_district, this.distributor, this.ship_to_Party, this.year, this.month, '');
            this.disable_distributor = false;
        }
    }
    handleRemoveSalesdistrict() {
        this.sales_district = '';
        this.sales_district_name = '';
        this.distributorName = '';
        this.distributor = '';
        this.shipToPartyName = '';
        this.ship_to_Party = '';
        this.disable_distributor = true;
        this.disable_shipToParty = true;
        // this.distributor_filter = `SalesOrg__r.Sales_Org_Code__c='5100' and Distributor__r.RecordType.Name='Distributor' and AccountOwner__c='${this.user_id}'`;
        if (this.userProfileName == 'Territory Manager for Mexico') {
            this.distributor_filter = ` Distributor__c!=null and User__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
        } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
            this.distributor_filter = ` Distributor__c!=null and Regional_manager__c='${this.user_id}' and Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
        } else {
            this.distributor_filter = ` Distributor__c!=null and  Sales_Org_Code__c='5100'`;
            this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
        }
    }
    handleChangeDistributor(event) {
        console.log('id', event.detail.recId, ' Name ', event.detail.recName);
        this.distributor = event.detail.recId;
        this.distributorName = event.detail.recName;
        // if(this.distributorName!=''){
        // this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and Distributor__c='${this.distributor}'`;
        // if(this.sales_district_name!='' && this.sales_district_name!='All'){
        //     this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and Distributor__c='${this.distributor}' and Distributor__r.Sales_District__c='${this.sales_district}'`;
        // }
        // if(this.distributorName=='All'){
        //     this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}'`;
        //     if(this.sales_district_name!='' && this.sales_district_name!='All'){
        //         this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and Distributor__r.Sales_District__c='${this.sales_district}'`;
        //     }
        // }
        if (this.sales_district_name == this.labels.All && this.distributorName == this.labels.All) {
            if (this.userProfileName == 'Territory Manager for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and (Distributor__c IN ${JSON.stringify(this.lst_distributorId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")} OR Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")})  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}' and (Distributor__c IN ${JSON.stringify(this.lst_distributorId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")} OR Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")})  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and (Distributor__c IN ${JSON.stringify(this.lst_distributorId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")} OR Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")})  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            }
        }
        if (this.sales_district_name == this.labels.All && this.distributorName != '' && this.distributorName != this.labels.All) {
            if (this.userProfileName == 'Territory Manager for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and Distributor__c='${this.distributor}' and Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")}  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}' and Distributor__c='${this.distributor}' and Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")}  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100'  and Distributor__c='${this.distributor}' and Distributor__r.Sales_District__c IN ${JSON.stringify(this.lst_salesDistrictId).replaceAll('"', "'").replaceAll("[", "(").replaceAll("]", ")")}  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            }
        }
        if (this.sales_district_name != this.labels.All && this.sales_district_name != '' && this.distributorName == this.labels.All) {
            if (this.userProfileName == 'Territory Manager for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and  Distributor__r.Sales_District__c='${this.sales_district}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}' and  Distributor__r.Sales_District__c='${this.sales_district}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100'  and  Distributor__r.Sales_District__c='${this.sales_district}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            }
        }
        if (this.sales_district_name != this.labels.All && this.sales_district_name != '' && this.distributorName != this.labels.All && this.distributorName != '') {
            if (this.userProfileName == 'Territory Manager for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and User__c='${this.user_id}' and Distributor__c='${this.distributor}' and Distributor__r.Sales_District__c='${this.sales_district}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else if (this.userProfileName == 'Regional/Zonal Managers for Mexico') {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100' and Regional_manager__c='${this.user_id}' and Distributor__c='${this.distributor}' and Distributor__r.Sales_District__c='${this.sales_district}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            } else {
                this.ship_to_party_filter = `Sales_Org__r.Sales_Org_Code__c='5100'  and Distributor__c='${this.distributor}' and Distributor__r.Sales_District__c='${this.sales_district}'  and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true`;
            }
        }
        this.getLiquidation(this.Sales_Org, this.sales_district, this.distributor, this.ship_to_Party, this.year, this.month, '');
        this.disable_shipToParty = false;
    }
    handleRemoveDistributor() {
        this.distributorName = '';
        this.distributor = '';
        this.shipToPartyName = '';
        this.ship_to_Party = '';
        this.disable_shipToParty = true;
    }

    handleChangeShipToParty(event) {
        console.log('id', event.detail.recId, ' Name ', event.detail.recName);
        this.shipToPartyName = event.detail.recName;
        this.ship_to_Party = event.detail.recId;
        if (this.ship_to_Party != '' && this.shipToPartyName != 'None') {
            getSalesDisctrictForShipToParty({ shipt_to_party: this.ship_to_Party }).then(data => {
                console.log('getSalesDisctrictForShipToParty ', data);
                if (data) {
                    this.sales_district = data.Distributor__r.Sales_District__c;
                    this.sales_district_name = data.Distributor__r.Sales_District__c !== undefined ? data.Distributor__r.Sales_District__r.Name : '';
                }
                getDistributorForShipToParty({ shipt_to_party: this.ship_to_Party }).then(data => {
                    if (data) {
                        this.distributor = data.Distributor__c;
                        this.distributorName = data.Distributor__r.Name != undefined ? data.Distributor__r.Name : '';
                        this.getLiquidation(this.Sales_Org, this.sales_district, this.distributor, this.ship_to_Party, this.year, this.month, '');
                    }
                });
            });
        }
        // this.getLiquidation(this.Sales_Org, this.sales_district, this.distributor, this.ship_to_Party, this.year, this.month, '');
    }

    handleRemoveShipToParty() {
        console.log('remove ship to party');
        this.shipToPartyName = '';
        this.ship_to_Party = '';
    }
    handleChangeMonth(event) {
        this.month = event.detail.value;
        console.log('this.month ', this.month);
        this.spinner = true;
        setTimeout(() => {
            this.getLiquidation(this.Sales_Org, this.sales_district, this.distributor, this.ship_to_Party, this.year, this.month, '');
            this.spinner = false;
        }, 2000);

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
            this.monthOption.unshift({ label: '-None-', value: '' });
        }
    }

    getMonthOptionByYear(year) {
        this.spinner = true;
        if (this.user_country.toLocaleLowerCase().includes('mexico')) {
            getUserProfile().then(profile_name => {
                this.userProfileName = profile_name;
                this.monthOption = [];
                let monthval = new Date().getMonth();
                console.log('Profile  Name ', this.userProfileName);
                if (year == new Date().getFullYear() || year == new Date().getFullYear() - 1) {
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
                if (this.userProfileName.toLowerCase().includes('Regional/Zonal Managers for Mexico'.toLowerCase())) {
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
                this.monthOption.unshift({ label: '-None-', value: '' });
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

    getLiquidation(t_saleOrgCode, t_salesDistrict, t_distributor, t_ship_to_party, t_year, t_month, search_str) {
        this.liquidation_data = [];
        this.liquidation_to_submit = [];
        this.liquidation_found = false;
        console.log('t_saleOrgCode-->>', t_saleOrgCode);
        console.log('t_salesDistrict-->>', t_salesDistrict);
        console.log('t_distributor-->>', t_distributor);
        console.log('t_ship_to_party-->>', t_ship_to_party);
        console.log('t_year-->>', t_year);
        console.log('t_month-->>', t_month);
        console.log('search_str-->>', search_str);
        if (t_salesDistrict != '' && t_distributor != '' && t_ship_to_party != '' && t_year != '' && t_month !== '') {
            console.log(`Liquidation*** select fields from Liquidation2__c where SKU__r.Active_for_Liquidation__c = true and Month__c ='${t_month}' and Distributor__c='${t_distributor}' and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c='2020-04-01' and Distributor__r.Sales_District__c='${t_salesDistrict}' and Ship_To_Party__c= '${t_ship_to_party}' and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c= '${t_saleOrgCode}'  and RecordTypeId=:rec_type`);
            getAllLiquidation({ sales_org_code: t_saleOrgCode, sales_district: t_salesDistrict, distributor: t_distributor, ship_to_party: t_ship_to_party, year: t_year, month: t_month, searchstr: search_str }).then(data => {
                console.log('Liquidation data', data);
                let temp = [];
                let temp_for_submit = [];
                data.forEach(element => {
                    temp.push({
                        'Id': element.Id,
                        'Month__c': element.Month__c !== undefined ? element.Month__c : '',
                        'SKU_Code': element.SKU__r.SKU_Code__c !== undefined ? element.SKU__r.SKU_Code__c * 1 : '',
                        'SKU_Description': element.SKU__r.SKU_Description__c !== undefined ? element.SKU__r.SKU_Description__c : '',
                        'UOM': element.SKU__r.UOM__c,
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
                        'key_pfnm': element.Id + '-pfnm'
                    })
                    temp_for_submit.push(element.Id);
                    if (element.submitted__c == true) {
                        this.is_submitted = true;
                        this.disableAccesstoEdit(true, true, true);
                        this.disable_openingInventory = true;
                    } else {
                        this.is_submitted = false;
                        if (this.active_date_liquidation == true) {
                            this.disableAccesstoEdit(false, false, false);

                        } else {
                            this.disableAccesstoEdit(true, true, true);
                            console.log('disable all fields ', this.disable_fields);
                        }
                    }
                });
                this.liquidation_data = temp;
                this.search_data = temp;
                this.search_str = '';
                this.spinner = true;
                setTimeout(() => {
                    this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
                    if (this.liquidation_found == false) {
                        this.disable_submit_btn = true;
                        if (this.active_date_OpeningInventory == true) {
                            this.disable_openingInventory = false;
                        } else {
                            this.disable_openingInventory = true;
                        }
                    } else {
                        if (this.active_date_OpeningInventory == true) {
                            this.disable_openingInventory = false;
                        } else {
                            this.disable_openingInventory = true;
                        }
                    }
                    this.spinner = false;
                }, 2000);
                this.liquidation_to_submit = temp_for_submit;
                // console.log('this.liquidation_data ',JSON.stringify(JSON.parse(this.liquidation_data)));

            }).catch(err => {
                console.log('Err ', err);
            });
        } else {
            console.log('Roll up');
            if (this.year != '' && this.month != '') {
                this.getRollUpLiquidation();
            } else {
                console.log('please select year and month');
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
                    // this.spinner = true;
                    setTimeout(() => {
                        let update_val = this.search_data.find(ele => ele.Id == target.id.split('-')[0]);
                        console.log('OpIN1', Number(target.value.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code), 'val ', target.value);
                        update_val.Opening_inventory = Number(target.value.toString().replaceAll(',', '').replaceAll('.', '')).toLocaleString(this.number_saperator_code);
                        console.log('update val ', update_val);
                        // this.spinner = false;
                    }, 1000);
                }).catch(err => {
                    console.log('Update Opening Inventory ERR', err)
                    // this.spinner = false;
                });
            } else {
                if (!Number.isNaN(parseInt(target.value.replaceAll(',', '').replaceAll('.', '')) + parseInt(temp.YTD_sales.toString().replaceAll(',', '').replaceAll('.', '')))) {
                    this.showToastmessage(this.labels.toast_err, this.labels.market_inventory_validation, 'error');
                }
                console.log('op ->', this.template.querySelector(`lightning-input[data-id=${target.dataset.id}]`));
                this.template.querySelector(`lightning-input[data-id=${target.dataset.id}]`).value = '0';
            }
        }
        // this.spinner = true;
        setTimeout(() => {
            this.implement_formula(target.id.split('-')[0], target.value.replaceAll(',', '').replaceAll('.', ''), target.name);
            // this.spinner = false;
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
                        // console.log('Data ',value);
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
                //  this.spinner = true;
                //  setTimeout(() => {
                updatePlanForMonth({ liq: this.liqidation_obj }).then(data => {
                    let update_val = this.search_data.find(ele => ele.Id == record_id);
                    update_val.Plan_for_next_month = Number(value).toLocaleString(this.number_saperator_code);
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

    handleSubmit(event) {
        console.log('submit ->', JSON.stringify(this.liquidation_to_submit));
        this.spinner = true;
        submitLiquidation({ lst_liq: JSON.stringify(this.liquidation_to_submit) }).then(is_success => {
            console.log('submit status ', is_success);
            setTimeout(() => {
                if (is_success == true) {
                    this.disableAccesstoEdit(true, true, true);
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

    disableAccesstoEdit(submit_btn, fields, upload_btn) {
        this.disable_submit_btn = submit_btn;
        this.disable_fields = fields;
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
                this.getLiquidation(this.Sales_Org, this.sales_district, this.distributor, this.ship_to_Party, this.year, this.month, '');
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
                console.log('Total_Available_Stock ', liq.Total_Available_Stock);
                liq.Total_Available_Stock = Number.isNaN(liq.Total_Available_Stock) ? 0 : Number(liq.Total_Available_Stock).toLocaleString(this.number_saperator_code);
            }
            if (liq.Id == temp_id) {
                liq.Liquidation_YTD = parseFloat(liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) - parseFloat(liq.Total_market_Inventory.toString().replaceAll(',', '').replaceAll('.', ''));
                liq.Liquidation_YTD = Number.isNaN(liq.Liquidation_YTD) ? 0 : Number(liq.Liquidation_YTD).toLocaleString(this.number_saperator_code);
                // liq.Liquidation_percentage_YTD = Number(parseFloat(((liq.Liquidation_YTD.toString().replaceAll(',','').replaceAll('.','') / liq.Total_Available_Stock.toString().replaceAll(',','').replaceAll('.',''))*100).toFixed(2))).toLocaleString(this.number_saperator_code);
                // console.log('percent YTD ',liq.Liquidation_percentage_YTD);
                // if(liq.Liquidation_percentage_YTD=='-Infinity' || Number.isNaN(liq.Liquidation_percentage_YTD.toString().replaceAll(',','').replaceAll('.',''))){
                //     liq.Liquidation_percentage_YTD = 0+' %';
                // }else{
                //     liq.Liquidation_percentage_YTD = Number(liq.Liquidation_percentage_YTD).toLocaleString(this.number_saperator_code) + ' %';
                // }

                liq.Liquidation_percentage_YTD = isFinite(Number(parseFloat(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) * 100).toFixed(2)))) ? Number(parseFloat(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.Total_Available_Stock.toString().replaceAll(',', '').replaceAll('.', '')) * 100).toFixed(2))).toLocaleString(this.number_saperator_code) + '%' : '0 %';

                liq.Liquidation_YTD_per_plan_YTD = isFinite(liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.plan_for_month.toString().replaceAll(',', '').replaceAll('.', '')) ? Number(((liq.Liquidation_YTD.toString().replaceAll(',', '').replaceAll('.', '') / liq.plan_for_month.toString().replaceAll(',', '').replaceAll('.', '')) * 100).toFixed(2)).toLocaleString(this.number_saperator_code) + ' %' : '0 %';
            }
        });
    }

    serachInlist(str) {
        let templiq = [];
        // if(!this.flag_search){
        //     //this.getLiquidation(this.sales_district,this.distributor,this.Sales_Org,this.year,this.month,'');
        //     this.temp_data = this.liquidation_data;
        //     this.flag_search = true;
        // }
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

    handlesortData(event) {
        let fieldname = event.target.dataset.fieldname;
        console.log('fieldName', fieldname);
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
                console.log('liquidation ele ', ele);
            });
            this.liquidation_data = this.search_data;
        }
        console.log('sort data ->', JSON.parse(JSON.stringify(this.liquidation_data)));
    }
    sortData(fieldName, sortDirection) {
        if (fieldName == 'Liquidation_percentage_YTD') {
            this.search_data = [];
            this.liquidation_data.forEach(ele => {
                ele.Liquidation_percentage_YTD = parseInt(ele.Liquidation_percentage_YTD.replace(' %', ''));
                this.search_data.push(ele);
                //    console.log('liquidation ele ',ele);
            });
            this.liquidation_data = this.search_data;
        }
        // console.log('sort search',this.search_data);
        // console.log('sort liq ',this.liquidation_data);
        let sortResult = Object.assign([], this.liquidation_data);
        this.liquidation_data = sortResult.sort(function (a, b) {
            console.log('ele ', a[fieldName]);
            if (fieldName == 'Total_Available_Stock' || fieldName == 'SKU_Code' || fieldName == 'Total_market_Inventory') {
                if (Number(a[fieldName].toString().replaceAll(',', '')) < Number(b[fieldName].toString().replaceAll(',', '')))
                    return sortDirection === 'asc' ? parseInt("-1") : 1;
                else if (Number(a[fieldName].toString().replaceAll(',', '')) > Number(b[fieldName].toString().replaceAll(',', '')))
                    return sortDirection === 'asc' ? 1 : parseInt("-1");
                else
                    return 0;
            } else {
                if (a[fieldName] < b[fieldName])
                    return sortDirection === 'asc' ? parseInt("-1") : 1;
                else if (a[fieldName] > b[fieldName])
                    return sortDirection === 'asc' ? 1 : parseInt("-1");
                else
                    return 0;
            }
        });
    }

    handlePlaceholder(event) {
        // console.log('Key ',event.target.dataset.key);
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
        if (event.target.dataset.id) {
            if (event.target.name == this.fieldsapiname.Opening_inventory) {
                if (event.target.value == 0 && event.target.disabled == false) {
                    this.template.querySelector(`lightning-input[data-id=${event.target.dataset.id}]`).value = 0;
                }
            }
        }
        if (event.target.dataset.key) {
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
    lst_districtsIds;
lst_distributorIds;
    getRollUpLiquidation() {
        this.spinner = true;
        this.disableAccesstoEdit(true, true, true);
        console.log('this.lst_salesDistrictId ', this.lst_salesDistrictId);
        let str_salesdistrictids;
        let str_distributorids;
        if (this.sales_district != '') {
            str_salesdistrictids = JSON.stringify([]);
        } else {
            str_salesdistrictids = JSON.stringify(this.lst_salesDistrictId)
        }
        if (this.distributor != '') {
            str_distributorids = JSON.stringify([]);
        } else {
            str_distributorids = JSON.stringify(this.lst_distributorId);

        }
        this.lst_districtsIds=str_salesdistrictids;  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
        this.lst_distributorIds=str_distributorids;  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */



        
        rollUpLiquidation({ lst_salesDistricts: str_salesdistrictids, lst_distributor: str_distributorids, sales_districts: this.sales_district, start_year: this.year, month: this.month, distributor: this.distributor, ship_to_party: this.ship_to_Party, sales_org: this.Sales_Org }).then(map_rollupData => {
            console.log('Roll up', map_rollupData);
            let temp = [];
            let count = 0;
            for (let [key, element] of Object.entries(map_rollupData)) {
                temp.push({
                    'Id': element.Id,
                    'Month__c': element.Month__c !== undefined ? element.Month__c : '',
                    'Brand': element.Brand_Name__c !== undefined ? element.Brand_Name__c : '',
                    'SKU_Code': element.SKU_Code__c !== undefined ? element.SKU_Code__c * 1 : '',
                    'SKU_Description': element.SKU_Description__c !== undefined ? element.SKU_Description__c : '',
                    'UOM': element.UOM_Wrap__c != undefined ? element.UOM_Wrap__c : '',
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
            console.log('map_rollupData size', count);
            this.liquidation_data = temp;
            this.search_data = temp;
            this.search_str = '';
            this.sortData('Total_Available_Stock', 'desc');
            this.liquidation_found = this.liquidation_data.length > 0 ? true : false;
            if (this.liquidation_found == false) {
                this.disable_submit_btn = true;
                this.disable_fields = true;
            } else {
                this.disable_openingInventory = true;
            }
            this.spinner = false;
        }).catch(err => {
            console.log('Err rollup', err);
            this.spinner = false;
        });
    }

 /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :11-07-2022 */
    downloadPDF() {
        this.pogPDFUrl = '/apex/GRZ_liquidationMexicoPDF?saleOrgCode=' + this.Sales_Org + '&salesDistrict=' + this.sales_district +
             '&distributor=' + this.distributor + '&shipToParty=' + this.ship_to_Party + '&year=' + this.year + '&month=' + this.month + '&searchStr=' + this.search_str;


        console.log('value' + this.pogPDFUrl);
        // this.spinner = true;
        // const downloadLink = document.createElement("a");
        // downloadLink.href = this.pogPDFUrl;
        // downloadLink.target = '_blank';
        // downloadLink.download = 'POGReport.pdf';
        // downloadLink.click();
        window.open(this.pogPDFUrl, '_blank');
        setTimeout(() => {
            this.spinner = false;
        }, 4000);

    }


    downloadXLS() {

        this.pogXLSUrl = '/apex/GRZ_liquidationMexicoXLS?saleOrgCode=' + this.Sales_Org + '&salesDistrict=' + this.sales_district 
        + '&distributor=' + this.distributor + '&shipToParty=' + this.ship_to_Party + '&year=' + this.year + '&month=' + this.month + '&searchStr=' + this.search_str;




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


     /* --- */

}