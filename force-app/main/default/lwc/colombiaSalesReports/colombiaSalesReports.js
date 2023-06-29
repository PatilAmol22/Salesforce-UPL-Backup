import {
    LightningElement,
    wire,
    track
} from 'lwc';
import SalesReport from '@salesforce/apex/Section_Controller.fetchSalesAmtMontly';
import SalesReportByProduct from '@salesforce/apex/Section_Controller.fetchSalesAmtProductWise';
import TotalYear from "@salesforce/label/c.Total_Year_Amount";
import Monthly_Sales_Information_in_USD from "@salesforce/label/c.Monthly_Sales_Information_in_USD";
import Monthly_Sales_Information_in_Volume from "@salesforce/label/c.Monthly_Sales_Information_in_Volume";
import Sales_Information_Top_15_Product from "@salesforce/label/c.Sales_Information_Top_15_Product";
import Sales_Information_top_15_product_in_Volumne from "@salesforce/label/c.Sales_Information_top_15_product_in_Volumne";
import Last_Year_Sale from "@salesforce/label/c.Last_Year_Sale";
import Currrent_Year_Sales from "@salesforce/label/c.Currrent_Year_Sales";
import Variation_current_Vs_Last from "@salesforce/label/c.Variation_current_Vs_Last";
import Month from "@salesforce/label/c.Month";
import Product from "@salesforce/label/c.Product";


export default class ColombiaSalesReports extends LightningElement {

    @track monthlySalesReport;
    @track productSalesReport;
    @track error;
    totalLastYear = 0.0;
    totalcurrentyear = 0.0;
    totalgrowth = 0.0;
    currentmonth = '';
    YTDcurrentyear = 0.0;
    YTDLastYear = 0.0;
    YTDgrowth = 0.0;
    totalcurrentQuantity = 0;
    totalLastYearQuantity = 0;
    totalquanitytgrowth = 0;
    YTDtotalcurrentQuantity = 0;
    YTDtotalLastYearQuantity = 0;
    YTDgrowthquantity = 0;
    totalLastYearbyProduct = 0.0;
    totalcurrentyearbyProduct = 0.0;
    totalgrowthbyProduct = 0.0;

    YTDcurrentyearbyProduct = 0.0;
    YTDLastYearbyProduct = 0.0;
    YTDgrowthbyProduct = 0.0;
    totalcurrentQuantitybyProduct = 0;
    totalLastYearQuantitybyProduct = 0;
    totalquanitytgrowthbyProduct = 0;
    YTDtotalcurrentQuantitybyProduct = 0;
    YTDtotalLastYearQuantitybyProduct = 0;
    YTDgrowthquantitybyProduct = 0;
    monthlyinformation = false;
    monthlyInfomrationVolume = false;
    topproductInformation = false;
    topproductInformationVolume = false
    YTDLoop = 0;
    financial_year = '';
    lastfinancial_year = '';
    secondlastfinancial_year='';
    currentYear='';
    lastYear='';
    labels = {
        TotalYear,
        Monthly_Sales_Information_in_USD,
Monthly_Sales_Information_in_Volume,
Sales_Information_Top_15_Product,
Sales_Information_top_15_product_in_Volumne,
Last_Year_Sale,
Currrent_Year_Sales,
Variation_current_Vs_Last,
Month,
Product
    }

    connectedCallback() {
//Calculate financial year, last financial year 
        var today = new Date();
        if ((today.getMonth() + 1) <= 3) {
            this.YTDLoop = (today.getMonth() + 1) + 9;
            this.financial_year = (today.getFullYear() - 1).toString().substr(-2) + "-" + today.getFullYear().toString().substr(-2);
            this.lastfinancial_year = (today.getFullYear() - 2).toString().substr(-2) + "-" + (today.getFullYear() - 1).toString().substr(-2);
            this.secondlastfinancial_year=(today.getFullYear() - 3).toString().substr(-2) + "-" + (today.getFullYear() - 2).toString().substr(-2);
        } else {
            this.YTDLoop = (today.getMonth() + 1) - 3;
            this.financial_year = today.getFullYear().toString().substr(-2) + "-" + (today.getFullYear() + 1).toString().substr(-2);
            this.lastfinancial_year = (today.getFullYear() - 1).toString().substr(-2) + "-" + (today.getFullYear()).toString().substr(-2);
            this.secondlastfinancial_year=(today.getFullYear() - 2).toString().substr(-2) + "-" + (today.getFullYear() - 1).toString().substr(-2);
        }
        console.log('financial_year--------->' + this.financial_year);

    }
    //call apex method fetchSalesAmtMontly
    @wire(SalesReport)
    wiredmonthlySalesReport({
        error,
        data
    }) {

        if (data) {
            this.monthlySalesReport = data;
            if(this.monthlySalesReport[0].isCurrentYearSalePresent==true)
            {
this.currentYear=this.financial_year;
this.lastYear=this.lastfinancial_year;
            }
            else{
                this.currentYear=this.lastfinancial_year;
                this.lastYear=this.secondlastfinancial_year;
            }
           //Calculate total current year and last year sale/volume
            for (let i = 0; i < this.monthlySalesReport.length; i++) {
                this.totalcurrentyear = (this.totalcurrentyear + this.monthlySalesReport[i].currentYearSales);
                this.totalLastYear = (this.totalLastYear + this.monthlySalesReport[i].lstYearSales);
                this.totalcurrentQuantity = this.totalcurrentQuantity + this.monthlySalesReport[i].CurrentQuantity;
                this.totalLastYearQuantity = this.totalLastYearQuantity + this.monthlySalesReport[i].LastQuantity;
            }
          //Calculate total variance 
            this.totalgrowth = ((this.totalcurrentyear - this.totalLastYear) * 100 / this.totalLastYear).toFixed(2);
            this.totalquanitytgrowth = ((this.totalcurrentQuantity - this.totalLastYearQuantity) * 100 / this.totalLastYearQuantity).toFixed(2);
        //Calculation for YTD currentyear and lastyear sale
            for (let i = 0; i < this.YTDLoop; i++) {

                this.YTDcurrentyear = this.YTDcurrentyear + this.monthlySalesReport[i].currentYearSales;
                this.YTDLastYear = this.YTDLastYear + this.monthlySalesReport[i].lstYearSales;
                this.YTDtotalcurrentQuantity = this.YTDtotalcurrentQuantity + this.monthlySalesReport[i].CurrentQuantity;
                this.YTDtotalLastYearQuantity = this.YTDtotalLastYearQuantity + this.monthlySalesReport[i].LastQuantity;
            }
           // Calculate total variance of  YTD
            this.YTDgrowth = ((this.YTDcurrentyear - this.YTDLastYear) * 100 / this.YTDLastYear).toFixed(2);
            this.YTDgrowthquantity = ((this.YTDtotalcurrentQuantity - this.YTDtotalLastYearQuantity) * 100 / this.YTDtotalLastYearQuantity).toFixed(2);

        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }
//call apex method fetchSalesAmtProductWise
    @wire(SalesReportByProduct)
    wiredproductSalesReport({
        error,
        data
    }) {

        if (data) {
            this.productSalesReport = data;
// Calculate sum of top 15 product sales/quantity
            for (let i = 0; i < this.productSalesReport.length; i++) {
                this.totalcurrentyearbyProduct = this.totalcurrentyearbyProduct + this.productSalesReport[i].currentYearSales;
                this.totalLastYearbyProduct = this.totalLastYearbyProduct + this.productSalesReport[i].lstYearSales;
                this.totalcurrentQuantitybyProduct = this.totalcurrentQuantitybyProduct + this.productSalesReport[i].CurrentQuantity;
                this.totalLastYearQuantitybyProduct = this.totalLastYearQuantitybyProduct + this.productSalesReport[i].LastQuantity;
            }
            //Calculate total variance of top 15 product
            this.totalgrowthbyProduct = ((this.totalcurrentyearbyProduct - this.totalLastYearbyProduct) * 100 / this.totalLastYearbyProduct).toFixed(2);
            this.totalquanitytgrowthbyProduct = ((this.totalcurrentQuantitybyProduct - this.totalLastYearQuantitybyProduct) * 100 / this.totalLastYearQuantitybyProduct).toFixed(2);


        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }






    monthlySalesInformation() {
        this.monthlyinformation = true;
        this.monthlyInfomrationVolume = false;
        this.topproductInformation = false;
        this.topproductInformationVolume = false;
    }
    monthlySalesInformationinVolume() {
        this.monthlyinformation = false;
        this.monthlyInfomrationVolume = true;
        this.topproductInformation = false;
        this.topproductInformationVolume = false;
    }
    salesInformationproduct() {
        this.monthlyinformation = false;
        this.monthlyInfomrationVolume = false;
        this.topproductInformation = true;
        this.topproductInformationVolume = false;
    }
    salesInformationproductinVolume() {
        this.monthlyinformation = false;
        this.monthlyInfomrationVolume = false;
        this.topproductInformation = false;
        this.topproductInformationVolume = true;
    }

}