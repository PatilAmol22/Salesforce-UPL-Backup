import { LightningElement, track, wire } from 'lwc';
import getInvoiceSummary from '@salesforce/apex/InvoiceSummary.getInvoiceSummary';
import getInvoice from '@salesforce/apex/InvoiceSummary.getInvoice';
import getInvoiceLineItem from '@salesforce/apex/InvoiceSummary.getInvoiceLineItem';
import getProductList from '@salesforce/apex/InvoiceSummary.getProductList';
import findChildAccounts from '@salesforce/apex/OrderSummary.findChildAccounts';
import fetchUser from '@salesforce/apex/InvoiceSummary.fetchUser';
import fetchURL from '@salesforce/apex/InvoiceSummary.fetchURL';
import getInvoiceSummaryCount from '@salesforce/apex/InvoiceSummary.getInvoiceSummaryCount';
import contentVersionIdsList from '@salesforce/apex/InvoiceSummary.getContentVersionIds';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import Bill_to_Party from '@salesforce/label/c.Bill_to_Party';
import Billing_Doc_No from '@salesforce/label/c.Billing_Doc_No';
import Delivery_No from '@salesforce/label/c.Delivery_No';
import Description from '@salesforce/label/c.Description';
import Doc_Amount from '@salesforce/label/c.Doc_Amount';
import Download_Invoice from '@salesforce/label/c.Download_Invoice';
import First from '@salesforce/label/c.First';
import Invoice from '@salesforce/label/c.Invoice';
import Invoice_Date from '@salesforce/label/c.Invoice_Date';
import Invoice_Doc_No from '@salesforce/label/c.Invoice_Doc_No';
import Invoice_Date_From from '@salesforce/label/c.Invoice_Date_From';
import Invoice_Date_To from '@salesforce/label/c.Invoice_Date_To';
import Invoice_Details from '@salesforce/label/c.Invoice_Details';
import Invoice_Line_Item from '@salesforce/label/c.Invoice_Line_Item';
import Invoice_Summary from '@salesforce/label/c.Invoice_Summary';
import Last from '@salesforce/label/c.Last';
import Net_Value from '@salesforce/label/c.Net_Value';
import Next from '@salesforce/label/c.Next';
import Order_Value_From from '@salesforce/label/c.Order_Value_From';
import Order_Value_To from '@salesforce/label/c.Order_Value_To';
import PO_No from '@salesforce/label/c.PO_No';
import Page from '@salesforce/label/c.Page';
import Payment_Method from '@salesforce/label/c.Payment_Method';
import Previous from '@salesforce/label/c.Previous';
import Quantity from '@salesforce/label/c.Quantity';
import Record_Detail from '@salesforce/label/c.Record_Detail';
import SKU_Code from '@salesforce/label/c.SKU_Code';
import Sales_Order_No from '@salesforce/label/c.Sales_Order_No';
import Search_Result from '@salesforce/label/c.Search_Result';
import Ship_to_Party from '@salesforce/label/c.Ship_To_Party';
import Sold_To_Party from '@salesforce/label/c.Sold_To_Party';
import Total_Invoice_Amount from '@salesforce/label/c.Total_Invoice_Amount';
import UOM from '@salesforce/label/c.UOM';
import View_Invoice from '@salesforce/label/c.View_Invoice';
import Toast_Warning from '@salesforce/label/c.Toast_Warning';
import Toast_Info from '@salesforce/label/c.Toast_Info';
import No_Result_Found from '@salesforce/label/c.No_Result_Found';
import IS_Toast1 from '@salesforce/label/c.IS_Toast1';
import IS_Toast4 from '@salesforce/label/c.IS_Toast4';
import IS_Toast6 from '@salesforce/label/c.IS_Toast6';
import IS_Toast7 from '@salesforce/label/c.IS_Toast7';
import Search_Invoice_Bill from '@salesforce/label/c.Search_Invoice_Bill';
import select_Product_Line_Item from '@salesforce/label/c.select_Product_Line_Item';
import Search from '@salesforce/label/c.Search';
import Currency from '@salesforce/label/c.Currency';
import Action_IS from '@salesforce/label/c.Action_IS';
import Invoice_No from '@salesforce/label/c.Invoice_No';
import Close from '@salesforce/label/c.Close';
import None from '@salesforce/label/c.None';
import SAP_Order_Number from '@salesforce/label/c.SAP_Order_Number';
import Payment_Terms from '@salesforce/label/c.Payment_Terms';
import Tax_value from '@salesforce/label/c.Tax_value';
import Download_All_Invoices from '@salesforce/label/c.Download_All_Invoices';
import Sales_Order_No_SAP from '@salesforce/label/c.Sales_Order_No_SAP';
import Select_Branch from '@salesforce/label/c.Select_Branch';
import Headquarter_Name from '@salesforce/label/c.Headquarter_Name';
//Change by Grazitti team for Community adoption RITM0429236 12Oct22
import Ship_To_Party from '@salesforce/label/c.Ship_To_Party';
import All from '@salesforce/label/c.All';
import FORM_FACTOR from '@salesforce/client/formFactor';

/*const columns1 = [
    { label: 'Billing Doc No', fieldName: 'Billing_Doc_Number', type: 'text', cellAttributes: { alignment: 'left' }},
    { label: 'Sales Order No', fieldName: 'Sales_Order_No', type: 'text', cellAttributes: { alignment: 'left' }},
    { label: 'PO No', fieldName: 'PO_Number', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Invoice Date', fieldName: 'Invoice_Date', type: "date",typeAttributes:{day: "2-digit",month: "short",year: "numeric"}, cellAttributes: { alignment: 'left' }},
    { label: 'Doc Amount', fieldName: 'Doc_Amount' ,type: 'currency', cellAttributes: { alignment: 'left' }},
    { label: 'Action', type: "button", typeAttributes: {
        label: 'View',
        name: 'View',
        title: 'View',
        disabled: false,
        value: 'View',
        iconPosition: 'center',
        
        
    }}, 
    { label: '', type: "button", typeAttributes:{
        label: 'Download',
        name: 'Download',
        title: 'Download',
        disabled: false,
        value: 'Download',
        iconPosition: 'center'
    }}
];*/

/* , 

    { label: 'Currency', fieldName: 'wCurrency', type: 'text' , cellAttributes: { alignment: 'left' }},
    
    { label: '', type: "button", typeAttributes:{
        label: 'Download Invoice',
        name: 'Download Invoice',
        title: 'Download Invoice',
        disabled: false,
        value: 'Download Invoice',
        iconPosition: 'center'
    }}, 
    { label: ' ', type: "button", typeAttributes:{
        label: 'Acknowledge The Delivery',
        name: 'Acknowledge The Delivery',
        title: 'Acknowledge The Delivery',
        disabled: false,
        value: 'Acknowledge The Delivery',
        iconPosition: 'center'
        
    }} */

/*const columns2 = [
    { label: 'SKU Code', fieldName: 'SKU_Code__c', type: 'text', cellAttributes: { alignment: 'left' }},
    { label: 'Description', fieldName: 'SKU_Description__c', type: 'text', cellAttributes: { alignment: 'left' }},
    { label: 'UOM', fieldName: 'UOM__c', type: 'text', cellAttributes: { alignment: 'left' }},
    { label: 'Quantity', fieldName: 'Quantity__c', type: 'number', cellAttributes: { alignment: 'left' }},
    { label: 'Currency', fieldName: 'CurrencyIsoCode', type: 'text', cellAttributes: { alignment: 'left' }},
    { label: 'Net Value', fieldName: 'Net_Value__c', type: 'currency', cellAttributes: { alignment: 'left' }},, typeAttributes: {currencyDisplayAs: "symbol"}
];*/

export default class InvoiceSummary extends LightningElement {
    @track invoiceData;
    @track invoiceDataLength;
    @track invoiceLineDataLength;
    // @track columns1 = columns1;
    // @track columns2 = columns2;
    @track record;
    @track invoice;
    @track recordId;
    @track invoiceLineItems = [];
    @track searchResult;
    @track bShowModal = false;
    @track bShowModal1 = false;
    @track orders;
    @track row;
    @track pagesize = '10';
    @track invoiceLinePageSize= '5';
    @track pageNumber = 1;
    @track currentpage;
    @track totalpages;
    @track totalrecords;
    @track offset = 0;
    @track InvoiceNo = '';
    @track SalesOrderNo = '';
    @track SAPOrderNo = '';
    @track InvoiceDateFrom = '';
    @track InvoiceDateTo = '';
    @track product = '';
    @track OrderValueFrom = '';
    @track OrderValueTo = '';
    @track PONumber = '';
    @track ProductListOption;
    @track userAccountId = '';
    @track shipToParty;
    @track showResult = false;
    @track from;
    @track to;
    @track country = '';
    @track showIN = false;
    @track showSO = false;
    @track column;
    @track column2;
    @track url = '';
    @track rowNumberOffset = 0;
    @track showBillToParty = false;
    @track showTotalAmountCurrency = false;
    @track showSAPON = false;
    @track showSON = false;
    @track showSpinneer = false;
    @track currencyCode;
    @track isParent = false;
    @track child = '';
    @track currentAccount = '';
    @track returnChildAccounts = [];
    @track returnChilds = [];
    @track allAccountList = [];
    @track  isKaneko=false;
    @track InvoiceReflectioncode='';
    @track labels = {
        Bill_to_Party: Bill_to_Party,
        Billing_Doc_No: Billing_Doc_No,
        Delivery_No: Delivery_No,
        Description: Description,
        Doc_Amount: Doc_Amount,
        Download_Invoice: Download_Invoice,
        First: First,
        Invoice: Invoice,
        Invoice_Date: Invoice_Date,
        Invoice_Date_From: Invoice_Date_From,
        Invoice_Date_To: Invoice_Date_To,
        Invoice_Details: Invoice_Details,
        Invoice_Doc_No: Invoice_Doc_No,
        Invoice_Line_Item: Invoice_Line_Item,
        Invoice_Summary: Invoice_Summary,
        Invoice_No: Invoice_No,
        Last: Last,
        Net_Value: Net_Value,
        Next: Next,
        Order_Value_From: Order_Value_From,
        Order_Value_To: Order_Value_To,
        PO_No: PO_No,
        Page: Page,
        Payment_Method: Payment_Method,
        Previous: Previous,
        Quantity: Quantity,
        Record_Detail: Record_Detail,
        SKU_Code: SKU_Code,
        Sales_Order_No: Sales_Order_No,
        Search_Result: Search_Result,
        Ship_to_Party: Ship_to_Party,
        Sold_To_Party: Sold_To_Party,
        Total_Invoice_Amount: Total_Invoice_Amount,
        UOM: UOM,
        View_Invoice: View_Invoice,
        Toast_Warning: Toast_Warning,
        Toast_Info: Toast_Info,
        IS_Toast1: IS_Toast1,
        IS_Toast4: IS_Toast4,
        IS_Toast6: IS_Toast6,
        IS_Toast7: IS_Toast7,
        No_Result_Found: No_Result_Found,
        Search_Invoice_Bill: Search_Invoice_Bill,
        select_Product_Line_Item: select_Product_Line_Item,
        Search: Search,
        Currency: Currency,
        Action_IS: Action_IS,
        Close: Close,
        None: None,
        SAP_Order_Number: SAP_Order_Number,
        Sales_Order_No_SAP: Sales_Order_No_SAP,
        Payment_Terms: Payment_Terms,
        Tax_value: Tax_value,
        Download_All_Invoices: Download_All_Invoices,
        Select_Branch: Select_Branch,
        Headquarter_Name: Headquarter_Name,
        //Change by Grazitti team for Community adoption RITM0429236 12Oct22
        Ship_To_Party:Ship_To_Party,
        All: All
    }
    @track page = 1; //this is initialize for 1st page
    @track data = []; //data to be display in the table
    @track startingRecord = 1; //start record position per page
    @track pageSize = '10'; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track endingRecord = 0; //end record position per page
    @track isDataSorted = false;
    option = [];

    @track columns1 = [
        { label: this.labels.Invoice_No, fieldName: 'Billing_Doc_Number', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.SAP_Order_Number, fieldName: 'SAP_Order_No', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Sales_Order_No, fieldName: 'Sales_Order_No', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Invoice_Date, fieldName: 'Invoice_Date', type: "date", wrapText: true, sortable: 'true', hideDefaultActions: 'true', typeAttributes: { day: "2-digit", month: "short", year: "numeric" }, cellAttributes: { alignment: 'left' } },
        { label: this.labels.PO_No, fieldName: 'PO_Number', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Doc_Amount, fieldName: 'Doc_Amount', type: 'currency', wrapText: true, sortable: 'true', hideDefaultActions: 'true', typeAttributes: { currencyDisplayAs: "code", currencyCodeCountry:this.country }, cellAttributes: { alignment: 'left' } },
        {
            label: this.labels.View_Invoice,
            type: "button",
            typeAttributes: {
                label: this.labels.View_Invoice,
                name: 'View',
                title: 'View',
                disabled: false,
                value: 'View',
                iconPosition: 'center',


            }
        },
        {
            label: this.labels.Download_Invoice,
            type: "button",
            typeAttributes: {
                label: this.labels.Download_Invoice,
                name: 'Download',
                title: 'Download',
                disabled: false,
                value: 'Download',
                iconPosition: 'center'
            }
        }
    ];

//Change by Grazitti team for Community adoption RITM0429236 12Oct22
    @track JPcolumns = [
        { label: this.labels.Invoice_No, fieldName: 'Billing_Doc_Number', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.PO_No, fieldName: 'PO_Number', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Description, fieldName: 'SKUDesc', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Ship_To_Party, fieldName: 'ShiptoParty', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Quantity, fieldName: 'Quantity', type: 'number', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Invoice_Date, fieldName: 'Invoice_Date', type: "date", wrapText: true, sortable: 'true', hideDefaultActions: 'true', typeAttributes: { day: "2-digit", month: "short", year: "numeric" }, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Doc_Amount, fieldName: 'Doc_Amount', type: 'currency', wrapText: true, sortable: 'true', hideDefaultActions: 'true', typeAttributes: { currencyDisplayAs: "code", minimumFractionDigits: 0, maximumFractionDigits: 0, currencyCodeCountry:this.country }, cellAttributes: { alignment: 'left' } },
        {
            label: this.labels.View_Invoice,
            type: "button",
            typeAttributes: {
                label: this.labels.View_Invoice,
                name: 'View',
                title: 'View',
                disabled: false,
                value: 'View',
                iconPosition: 'center',


            }
        }
    ];

    @track columns2 = [
        //{ label: this.labels.SKU_Code , fieldName: 'SKU_Code__c', type: 'text', cellAttributes: { alignment: 'left' }},
        { label: this.labels.Description, fieldName: 'SKU_Description__c', type: 'text', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.UOM, fieldName: 'UOM__c', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Quantity, fieldName: 'Quantity__c', type: 'number', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        //{ label: this.labels.Currency, fieldName: 'CurrencyIsoCode', type: 'text', cellAttributes: { alignment: 'left' }},Sales_Order__r.Payment_Term__r.Payment_Term__c
        { label: this.labels.Payment_Terms, fieldName: 'Payment_Term__c', type: 'text', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Net_Value, fieldName: 'Net_Value_Cal__c', type: 'currency', sortable: 'true', hideDefaultActions: 'true', wrapText: true, typeAttributes: { currencyDisplayAs: "code", currencyCodeCountry:this.country }, cellAttributes: { alignment: 'left' } },
    ];

    @track columns5 = [
        //{ label: this.labels.SKU_Code , fieldName: 'SKU_Code__c', type: 'text', cellAttributes: { alignment: 'left' }},
        { label: this.labels.Description, fieldName: 'SKU_Description__c', type: 'text', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.UOM, fieldName: 'UOM__c', type: 'text', wrapText: true, sortable: 'true', hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Quantity, fieldName: 'Quantity__c', type: 'number', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        //{ label: this.labels.Currency, fieldName: 'CurrencyIsoCode', type: 'text', cellAttributes: { alignment: 'left' }},Sales_Order__r.Payment_Term__r.Payment_Term__c
        //{ label: this.labels.Payment_Terms, fieldName: 'Payment_Term__c', type: 'text', wrapText: true, cellAttributes: { alignment: 'left' }},
        { label: this.labels.Net_Value, fieldName: 'Net_Value_Cal__c', type: 'currency', sortable: 'true', hideDefaultActions: 'true', wrapText: true, typeAttributes: { currencyDisplayAs: "code" }, cellAttributes: { alignment: 'left' } },
    ];

    @track columns3 = [
        { label: this.labels.Invoice_No, fieldName: 'Billing_Doc_Number', type: 'text', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.SAP_Order_Number, fieldName: 'SAP_Order_No', type: 'text', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Sales_Order_No, fieldName: 'Sales_Order_No', type: 'text', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Invoice_Date, fieldName: 'Invoice_Date', type: "date", sortable: 'true', hideDefaultActions: 'true', wrapText: true, typeAttributes: { day: "2-digit", month: "short", year: "numeric" }, cellAttributes: { alignment: 'left' } },
        { label: this.labels.PO_No, fieldName: 'PO_Number', type: 'text', sortable: 'true', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Doc_Amount, fieldName: 'Doc_Amount', type: 'currency', sortable: 'true', hideDefaultActions: 'true', wrapText: true, typeAttributes: { currencyDisplayAs: "code", currencyCodeCountry:this.country}, cellAttributes: { alignment: 'left' } },
        {
            label: this.labels.View_Invoice,
            type: "button",
            typeAttributes: {
                label: this.labels.View_Invoice,
                name: 'View',
                title: 'View',
                disabled: false,
                value: 'View',
                iconPosition: 'center',


            }
        }
    ];

    @track columns4 = [
        //{ label: this.labels.SKU_Code , fieldName: 'SKU_Code__c', type: 'text', cellAttributes: { alignment: 'left' }},
        { label: this.labels.Description, fieldName: 'SKU_Description__c', type: 'text', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.UOM, fieldName: 'UOM__c', type: 'text', wrapText: true, hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Quantity, fieldName: 'Quantity__c', type: 'number', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        //{ label: this.labels.Currency, fieldName: 'CurrencyIsoCode', type: 'text', cellAttributes: { alignment: 'left' }},Sales_Order__r.Payment_Term__r.Payment_Term__c
        { label: this.labels.Payment_Terms, fieldName: 'Payment_Term__c', type: 'text', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Tax_value, fieldName: 'Tax_Value__c', type: 'currency', hideDefaultActions: 'true', wrapText: true, typeAttributes: { currencyDisplayAs: "code" }, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Net_Value, fieldName: 'Net_Value__c', type: 'currency', hideDefaultActions: 'true', wrapText: true, typeAttributes: { currencyDisplayAs: "code" }, cellAttributes: { alignment: 'left' } },
    ];

    @track JPcolumns2 = [
        //{ label: this.labels.SKU_Code , fieldName: 'SKU_Code__c', type: 'text', cellAttributes: { alignment: 'left' }},
        { label: this.labels.Description, fieldName: 'SKU_Description__c', type: 'text', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        { label: this.labels.UOM, fieldName: 'UOM__c', type: 'text', wrapText: true, hideDefaultActions: 'true', cellAttributes: { alignment: 'left' } },
        { label: this.labels.Quantity, fieldName: 'Quantity__c', type: 'number', hideDefaultActions: 'true', wrapText: true, cellAttributes: { alignment: 'left' } },
        //{ label: this.labels.Currency, fieldName: 'CurrencyIsoCode', type: 'text', cellAttributes: { alignment: 'left' }},Sales_Order__r.Payment_Term__r.Payment_Term__c
        { label: this.labels.Net_Value, fieldName: 'Net_Value_Cal__c', type: 'currency', hideDefaultActions: 'true', wrapText: true, typeAttributes: { currencyDisplayAs: "code", minimumFractionDigits: 0, maximumFractionDigits: 0 }, cellAttributes: { alignment: 'left' } },
        { label: this.labels.Tax_value, fieldName: 'Tax_value_formula__c', type: 'currency', hideDefaultActions: 'true', wrapText: true, typeAttributes: { currencyDisplayAs: "code", minimumFractionDigits: 0, maximumFractionDigits: 0 }, cellAttributes: { alignment: 'left' } },
    ];

    //added by Akhilesh w.r.t Mobile UI
    isMobile;
    @track showInvoiceModal=false;
    /*get ProductList()                                                 //column options
    {  
           return this.ProductListOption;
    } */
    connectedCallback() {
        //this.value='10';
          // ForMobile compatibility Start
          console.log('The device form factor is: ' + FORM_FACTOR);
          if(FORM_FACTOR == 'Large'){
              this.isMobile = false;
          }else if(FORM_FACTOR == 'Medium' || FORM_FACTOR == 'Small'){
              this.isMobile = true;
          }
          console.log('this.isMobile ' + this.isMobile);
          // ForMobile compatibility Start end
        fetchUser().then(result => {
            //console.log('result---->',result);
            this.userAccountId = result[0].AccountId;
            this.currentAccount = this.userAccountId;
            this.country = result[0].Country;
            console.log('user Id ----->', this.userAccountId);
            if (this.userAccountId == undefined) {
                this.userAccountId = '';
            }
            if (result[0].Country == undefined) {
                this.country = '';
            }

            if (result[0].Country == 'Colombia') {
                this.showTotalAmountCurrency = true;
                this.currencyCode = 'COP';
                this.columns2 = this.columns5;
            } else {
                this.showTotalAmountCurrency = false;
                this.columns2 = this.columns2;
            }

            if (result[0].Country == 'Poland') {
                this.column = this.columns1;
                this.showIN = true;
                this.showBillToParty = false;
            }
            if (result[0].Country != 'Poland') {
                this.column = this.columns3;
                this.showSO = true;
                this.showBillToParty = true;
            }

            if (result[0].Country == 'Spain' || result[0].Country == 'Portugal') {
                this.column2 = this.columns4;
                this.column = this.columns1;
                this.showIN = true;
            } else {
                this.column2 = this.columns2;
                this.showIN = true;
            }
            if (result[0].Country == 'Japan') {
                this.column = this.JPcolumns;
                this.column2 = this.JPcolumns2;
                this.showTotalAmountCurrency = true;
                this.currencyCode = 'JPY';
                console.log('The accountSapcode is',result[0].Account.SAP_Code__c)
                if(result[0].Account.SAP_Code__c=='0001083269')
                {
                    this.showSAPON=true;
                   this.column.unshift({label: this.labels.Sales_Order_No_SAP, fieldName: 'invoiceReflectionCode', type: 'text' , cellAttributes: { alignment: 'left' },hideDefaultActions:true })
                   this.column.unshift({label: this.labels.Select_Branch, fieldName: 'accountName', type: 'text' , cellAttributes: { alignment: 'left' },hideDefaultActions:true })
                          
                }
            } else {
                this.showSON = true;
            }
            if (result[0].Country == 'Turkey') {
                this.showTotalAmountCurrency = true;
                this.column2 = this.JPcolumns2;
                this.currencyCode = 'TRY';
            }



            /*if(result[0].Country=='Poland'){
                this.showIN=true;
            }else{
                this.showSO=true;
            }*/
            //console.log('user Id ----->',this.userAccountId);
            //this.value='10';
            this.getProdList();
            //this.getTotalCountRecords();
        });

        fetchURL().then(result => {
            console.log('result---->', result);
            this.url=(window.location.href).split('/s/')[0];
            //this.url = result[0].URL__c;//Commented by Akhilesh to get current portal link
            console.log('url ----->', this.url);

            if (this.url == undefined) {
                this.url = '';
            }
            //console.log('url ----->', this.url);
        });

    }

    getProdList() {
        getProductList({
            uId: this.currentAccount
        }).then(result => {
            //console.log('option---->',result);
            if (result) {
                this.option.push({ label: this.labels.None, value: '' });
                for (const list of result) {
                    const selectOption = {
                        label: list.label,
                        value: list.value
                    };
                    // this.selectOptions.push(option);

                    this.option = [...this.option, selectOption];
                    //console.log('option1---->',this.option);
                }
            }
            this.showSpinneer=false;
            //this.ProductListOption=result;
        });
    }

  /*  get Option() { 
        return this.option;
    }
  */

    /*lists({ error, data }) {
        if (data) {
            for(const list of data){
                const option = {
                    label: list.Name,
                    value: list.Data_Store__c
                };
                // this.selectOptions.push(option);
                this.selectOptions = [ ...this.selectOptions, option ];
            }
        } else if (error) {
            console.error(error);
        }
    }

        @wire(getProductList)        
        wiredProductList({error,data}){
            if (data) {
            for(const list of data){
                const selectOption = {
                    label: list.label,
                    value: list.value
                };
                // this.selectOptions.push(option);
                this.option = [ ...this.option, selectOption ];
                //console.log('option---->',this.option);
            }
        }else if (error) {
            console.error(error);
        }
    }*/


    getUser() {
        fetchUser().then(result => {
            //console.log('result---->',result);
            this.userAccountId = result[0].AccountId;
            //console.log('user Id ----->',this.userAccountId);
            if (this.userAccountId == undefined) {
                this.userAccountId = '';
            }
            //console.log('user Id ----->',this.userAccountId);
            //this.value='10';

        });
    }
    getTotalCountRecords() {
        //console.log('this.userAccountId --> ' + this.userAccountId);
        //console.log('country-->',this.country);
        ////console.log('this.searchKeyYear --> ' + this.searchKeyYear);
      /*  getInvoiceSummaryCount({
            InvoiceNo: this.InvoiceNo,
            SalesOrderNo: this.SalesOrderNo,
            SAPOrderNo: this.SAPOrderNo,
            InvoiceDateFrom: this.InvoiceDateFrom,
            InvoiceDateTo: this.InvoiceDateTo,
            Product: this.product,
            PONumber: this.PONumber,
            uId: this.currentAccount,
            Country: this.country
        }).then(result => {
            //console.log('*---getTotalAL--->'+result);
            this.totalrecords = result;
            console.log('size----' + this.totalrecords);
            //console.log('--> getTotalALRec --> ',this.totalrecords);
            this.currentpage = 1;
            this.pagesize = 10;
            //this.pagesize = 5;
            this.totalpages = 1;
            this.totalpages = Math.ceil(parseInt(this.totalrecords, 10) / parseInt(this.pagesize, 10));
            ////console.log('total totalrecords--->',this.totalrecords);
            //console.log('total pages--->',this.totalpages);
            ////console.log('total pagesize--->',this.pagesize);
            if (this.totalrecords === 0) {
                this.pageNumber = 1;
                this.totalpages = 1;
            }
           


        }); */
        this.getData();
    } 

    getData() {
        //console.log('1-->');
        //console.log('country-->',this.country);
        console.log('in data');
        getInvoiceSummary({
                InvoiceNo: this.InvoiceNo,
                SalesOrderNo: this.SalesOrderNo,
                SAPOrderNo: this.SAPOrderNo,
                InvoiceDateFrom: this.InvoiceDateFrom,
                InvoiceDateTo: this.InvoiceDateTo,
                Product: this.product,
                PONumber: this.PONumber,
                uId: this.currentAccount,
                Country: this.country
            })
            .then(result => {
                this.invoiceData = result;
                //console.log('result-->'+result);
                console.log('invoice data---' + JSON.stringify(this.invoiceData));
                //console.log('DATA-->'+this.invoiceData);
                this.invoiceDataLength = this.invoiceData;
                this.totalRecountCount = this.invoiceData.length; //here it is 23
                console.log('DATA 1-->',this.invoiceDataLength);
                console.log('DATA Length-->',this.invoiceDataLength.length);
                if (this.invoiceDataLength.length !== 0) {
                    this.showResult = true;
                    console.log('true part');
                    this.page = 1;
                    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                //this.HandleButton();
                this.data = this.invoiceData.slice(0, this.pageSize);
                console.log('Data--->>'+JSON.stringify(this.data));
                this.rowNumberOffset = 0;
                this.endingRecord = this.pageSize;
                this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount) ?
                    this.totalRecountCount : (this.pageSize * this.page);
                
                    this.showSpinneer = false;
                } else {
                    this.showResult = false;
                    this.showErrorToast1(this.labels.Toast_Info, this.labels.No_Result_Found, 'info', 'dismissable'); //No_Result_Found
                    console.log('false part');
                    this.page = 0;
                    this.showSpinneer = false;
                }
                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                //this.HandleButton();
                this.data = this.invoiceData.slice(0, this.pageSize);
                //console.log('Data After--->>'+JSON.stringify(this.data));
                this.rowNumberOffset = 0;                
                this.endingRecord = this.pageSize;
                this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount) ?
                    this.totalRecountCount : (this.pageSize * this.page);
                //console.log('DATA-->',this.invoiceData);
                //console.log('Search result-->',this.invoiceData.length);
                this.error = undefined;
                 //For Mobile
            if(this.isMobile && this.template.querySelector('c-responsive-card') != undefined){
                this.template.querySelector('c-responsive-card').tableData = this.data;
                this.template.querySelector('c-responsive-card').updateValues();
            }
            })
            .catch(error => {
                this.error = error;
                this.invoiceData = undefined;
            });

           

    }

    displayRecordPerPage(page) {

        /*let's say for 2nd page, it will be => "Displaying 6 to 10 of 23 records. Page 2 of 5"
        page = 2; pageSize = 5; startingRecord = 5, endingRecord = 10
        so, slice(5,10) will give 5th to 9th records.
        */
        //this.HandleButton();        
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = ((this.pageSize * page) > this.totalRecountCount) ?
            this.totalRecountCount : (this.pageSize * page);
        if (this.isDataSorted === true) {
            if(this.showInvoiceModal !=true){
            this.data = this.parseData.slice(this.startingRecord, this.endingRecord);
            }else{
                this.invoiceLineDataLength=this.parseData.slice(this.startingRecord, this.endingRecord);
            }
            this.rowNumberOffset = this.startingRecord;
        } else {
            if(this.showInvoiceModal !=true){
            this.data = this.invoiceData.slice(this.startingRecord, this.endingRecord);
            }else{
                this.invoiceLineDataLength = this.invoiceLineItems.slice(this.startingRecord, this.endingRecord);
            }
            this.rowNumberOffset = this.startingRecord;
        }


        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;

        //added by Vaishnavi w.r.t Mobile UI
        if(this.showInvoiceModal !=true){
        if(this.isMobile){
            this.template.querySelector('c-responsive-card').tableData = this.data;
            this.template.querySelector('c-responsive-card').updateValues();
        }
        }
    }

    @wire(findChildAccounts)
    childs({ data, error }) {
        if (data) {
            if (data.length > 0) {
                data.forEach(element => {
                    if (!this.returnChildAccounts.includes(element)) {
                        this.returnChildAccounts.push(element);
                    }
                });
                this.returnChilds.push({ label: this.labels.Headquarter_Name, value: '' });
                this.returnChilds.push({ label: this.labels.All, value: 'All' });
                this.allAccountList.push(this.returnChildAccounts[0].Parent_Account__c);
                for (let i = 0; i < this.returnChildAccounts.length; i++) {
                    this.allAccountList = [...this.allAccountList, this.returnChildAccounts[i].Child_Account__r.Id];
                    this.returnChilds = [...this.returnChilds, { label: this.returnChildAccounts[i].Child_Account__r.Name, value: this.returnChildAccounts[i].Child_Account__r.Id }];
                }
                this.allAccountString = "'" + this.allAccountList.join("','") + "'";
                console.log('all account list--' + this.allAccountString);
                if (this.returnChilds.length > 0) {
                    this.isParent = true;
                }
                this.showSpinneer=false;
            }
        } else if (error) {
            this.error = error;
        }
    }

   /* get Option2() {
        
        return this.returnChilds;
    }
   */

    /*handleSONChange this method is use for getting Invoice Number and Sales order Number as per country*/
    handleINChange(event) {
        this.InvoiceNo = event.target.value;
        //console.log(this.InvoiceNo);
    }
    handleSONChange(event) {
        this.SalesOrderNo = event.target.value; // this.SalesOrderNo : - used for storing sales order no as well as invoice number as per country
        //console.log('inv/so--> ',this.SalesOrderNo);
    }
    handleSAPONChange(event) {
        this.SAPOrderNo = event.target.value;
    }
    handleIDFromChange(event) {
        this.InvoiceDateFrom = event.target.value;
        //console.log(this.InvoiceDateFrom);
    }
    handleODToChange(event) {
        this.InvoiceDateTo = event.target.value;
        //console.log(this.InvoiceDateTo);
    }
    handleProductChange(event) {
        this.product = event.target.value;
        //console.log(this.Product);
    }
    handlePONChange(event) {
        this.PONumber = event.target.value;
        //console.log(this.PONumber);
    }

    handleChildChange(event) {
        this.showSpinneer = true;
        this.child = event.target.value;
        console.log(this.child);
        if (this.child === '') {
            this.currentAccount = this.userAccountId;
        } else if (this.child === 'All') {
            this.currentAccount = this.allAccountString;
        } else {
            this.currentAccount = this.child;
        }
        this.InvoiceNo = '';
        this.InvoiceDateFrom = '';
        this.InvoiceDateTo = '';
        this.PONumber = '';
        this.product = '';
        this.option = [];
        this.selectOption = [];
        this.getProdList();
        

    }

    /*handleOVFChange(event){
        this.OrderValueFrom=event.target.value;
        //console.log(this.OrderValueFrom);
    }
    handleOVTChange(event){
        this.OrderValueTo=event.target.value;
        //console.log(this.OrderValueTo);
    }*/


    handleSearch() {
        this.showSpinneer = true;
        this.rowNumberOffset = 0;
        this.isDataSorted = false;
        this.pageSize ='10';
        //console.log('From Date ',this.InvoiceDateFrom);
        //console.log('To Date ',this.InvoiceDateTo);
        if (this.InvoiceNo === '' && this.SAPOrderNo === '' && this.SalesOrderNo === '' && (this.InvoiceDateFrom === '' || this.InvoiceDateFrom === null) && (this.InvoiceDateTo === '' || this.InvoiceDateTo === null) && this.product === '' && this.PONumber === '' && this.child === '') {
            this.showErrorToast1(this.labels.Toast_Warning, this.labels.IS_Toast6, 'warning', 'dismissable'); //IS_Toast6
            this.showSpinneer = false;
        } else {
            var c = 0;
            if (this.InvoiceNo != '') {
                this.InvoiceNo = this.InvoiceNo;
                c++;
                console.log(c);
            }

            if (this.SalesOrderNo != '') {
                this.SalesOrderNo = this.SalesOrderNo;
                c++;
                //console.log(c);
            }

            if (this.SAPOrderNo != '') {
                this.SAPOrderNo = this.SAPOrderNo;
                c++;
                //console.log(c);
            }


            if (this.InvoiceDateFrom != '' && this.InvoiceDateTo != '') {
                if (this.InvoiceDateFrom != null && this.InvoiceDateTo != null) {
                    if (this.InvoiceDateFrom < this.InvoiceDateTo) {
                        this.InvoiceDateFrom = this.InvoiceDateFrom;
                        this.InvoiceDateTo = this.InvoiceDateTo;
                        c++;
                        //console.log(c);
                    } else {
                        c = 0;
                        //console.log(c);
                        this.showErrorToast1(this.labels.Toast_Warning, this.labels.IS_Toast1, 'warning', 'dismissable'); //IS_Toast1
                    }
                }
            }
            if ((this.InvoiceDateFrom === '' && this.InvoiceDateTo != '') || (this.InvoiceDateFrom != '' && this.InvoiceDateTo === '')) {
                c = 0;
                //console.log(c);
                this.showErrorToast1(this.labels.Toast_Warning, this.labels.IS_Toast4, 'warning', 'dismissable'); //IS_Toast4
            }
            if (this.product != '') {
                this.product = this.product;
                c++;
                //console.log(c);
            }
            if (this.PONumber != '') {
                this.PONumber = this.PONumber;
                c++;
                //console.log(c);
            }
            if (this.child != '') {
                this.child = this.child;
                c++;
            }
            /*if(this.OrderValueFrom!='' && this.OrderValueTo!=''){
                this.from=Number(this.OrderValueFrom);
                this.to=Number(this.OrderValueTo);
                //console.log(this.from);
                //console.log(this.OrderValueFrom);
                //console.log(this.to);
                //console.log(this.OrderValueTo);
                if(this.to > this.from){
                    this.OrderValueFrom=this.OrderValueFrom;
                    this.OrderValueTo=this.OrderValueTo;
                    c++;
                    //console.log(c);
                }else{
                    c=0;
                    //console.log(c);
                    this.showErrorToast3();
                }
            }
            if((this.OrderValueFrom==='' && this.OrderValueTo!='')||(this.OrderValueFrom!='' && this.OrderValueTo==='')){
                this.OrderValueFrom=this.OrderValueFrom;
                this.OrderValueTo=this.OrderValueTo;
                c=0;
                //console.log(c);
                this.showErrorToast5();
            }*/

            if (c != 0) {
                this.pageNumber = 1;
                this.getTotalCountRecords();
                //patch
                //this.showSpinneer = false;

                //ends
            }

        }


        //this.getData();
    }

    doSorting(event) {
        this.isDataSorted = true;
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        this.parseData = JSON.parse(JSON.stringify(this.invoiceData));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        this.parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = this.parseData.slice(0, this.pageSize);
    }


    showErrorToast1(tit, mes, vari, tostmode) {
        const evt = new ShowToastEvent({
            title: tit,
            message: mes,
            variant: vari,
            mode: tostmode
                /*title: this.labels.Toast_Warning,
                message: this.labels.AL_Toast1,
                variant: 'warning',
                mode: 'dismissable'*/
        });
        this.dispatchEvent(evt);
        this.showSpinneer = false;
    }

    /*showErrorToast1() {
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Invoice Date(To) should be greater than Invoice Date(From).',
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
                
    }
    showErrorToast2() {
        const evt = new ShowToastEvent({
            title: 'Info',
            message: 'No Results Found',
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    showErrorToast3() {
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Order Value(To) should be greater than Order Value(From).',
            variant: 'warning',
            mode: 'dismissable'
        });
                
        this.dispatchEvent(evt);
                
    }
    showErrorToast4() {
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Invoice Date(From) and Invoice Date(To) should not be empty.',
            variant: 'warning',
            mode: 'dismissable'
        });
                
        this.dispatchEvent(evt);
                
    }
    showErrorToast5() {
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Order Value(From) and Order Value(To) should not be empty.',
            variant: 'warning',
            mode: 'dismissable'
        });
                
        this.dispatchEvent(evt);
                
    }

    showErrorToast6() {
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Please select atleast one filter criteria.',
            variant: 'warning',
            mode: 'dismissable'
        });
                
        this.dispatchEvent(evt);
                
    }

    showErrorToast7() {
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'No Files Available.',
            variant: 'warning',
            mode: 'dismissable'
        });
                
        this.dispatchEvent(evt);
                
    }*/
    /*Pagination code 
    handleFirst(event) {
        // this.flag = true;
        // //console.log('Flag Value first-->',this.flag);
        this.pageNumber = 1;
        this.rowNumberOffset = 0;
        ////console.log('first page offset-->',this.offset);
        this.getTotalCountRecords();
        this.getData();
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
    }
    handleLast(event) {
        // this.flag = true;
        // //console.log('Flag Value last-->',this.flag);
        this.pageNumber = this.totalpages;
        this.rowNumberOffset = this.pageNumber*10-10;
        ////console.log('last page offset-->',this.offset);
        ////console.log('total pages--->',this.pageNumber);
        this.getTotalCountRecords();
        this.getData();
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
        
    }
    handleNext(event) {
        // this.flag = true;
        // //console.log('Flag Value next-->',this.flag);
        this.pageNumber = this.pageNumber + 1;
        this.rowNumberOffset = this.rowNumberOffset+10;
        ////console.log('next page offset-->',this.offset);
        this.getTotalCountRecords();
        this.getData();
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
    }
    handlePrevious(event) {
        // this.flag = true;
        // //console.log('Flag Value prev-->',this.flag);
        this.pageNumber = this.pageNumber - 1;
        this.rowNumberOffset = this.rowNumberOffset-10;
        ////console.log('previous page offset-->',this.offset);
        this.getTotalCountRecords();
        this.getData();
        // setTimeout(() => {
        //     this.flag = false;
        // }, 300);
    }
    */

    handleFirst(event) {
        if (this.page > 1) {
            this.page = 1;
            this.displayRecordPerPage(this.page);
        }
    }

    handleLast(event) {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.totalPage;
            this.displayRecordPerPage(this.page);
        }
    }

    handleNext(event) {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    handlePrevious(event) {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    get showFirstButton() {
        if (this.page == 1 || this.page == 0) {
            return true;
        } else if (this.totalRecountCount === 0) {
            return true;
        } else {
            return false;
        }
    }

    get showLastButton() {
        if (this.totalRecountCount === undefined || this.totalRecountCount === 0) {
            return true;
        }
        if (Math.ceil(this.totalRecountCount / this.pageSize) === this.page || Math.ceil(this.totalRecountCount / this.pageSize) === 0) {
            return true;
        }
        return false;
    }

    /*

    get showFirstButton() {
        if (this.pageNumber == 1 || this.pageNumber == 0 ) {
            
            return true;
            
        }else if(this.totalrecords===0){
            return true;
        }else{
            return false;
        }
    }
    // getter  
    get showLastButton() {
       if(this.totalrecords===undefined ||  this.totalrecords === 0){
        this.totalrecords = 0;
       }
        ////console.log('pageSize --> ' + this.pagesize);
        ////console.log('pageNumber --> ' + this.pageNumber);
        
        if (Math.ceil(this.totalrecords / this.pagesize) === this.pageNumber || Math.ceil(this.totalrecords / this.pagesize)===0) {
            ////console.log('totalrecords showLastButton--> ' + this.totalrecords);
            return true;
        }
        return false;
    }
    */

    handleRowAction(event) {
        const row = event.detail.row;
        //console.log('Row',JSON.stringify(row)) ;     
        this.record = row;
        this.recordId = row.Id;
        console.log(this.recordId);
        var rValue = event.detail.action.name;
        //console.log('rValue-->',event.detail.action.name);
        if (rValue === 'View') {
            this.bShowModal = true;
        }
        if (rValue === 'Download') {
            this.downloadfile(this.recordId);
        }


        getInvoice({ invoiceId: this.recordId })
            .then(result => {
                this.invoice = result;
                Console.log(JSON.stringify(this.invoice));
                //console.log('invoice-->',this.invoice);
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
            });

        getInvoiceLineItem({ invoiceId: this.recordId })
            .then(result => {
                this.invoiceLineItems = result;
                if(this.invoiceLineItems[0].Invoice__r.Sold_to_Party_SAP_Code__c=='0001083269')
                {
                    this.isKaneko=true;
                    this.InvoiceReflectioncode= this.invoiceLineItems[0].Sales_Order_Line_Item__r.Invoice_Reflection_Code__c;
                }
                console.log('invoiceLineItems-->', this.invoiceLineItems);
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
            });
        //console.log('end');
    }

    downloadExcelFile() {
        var downloadURI = this.url + '/apex/InvoiceSummaryExcel?pgNo=' + this.pageNumber + '&pgSize=' + this.pagesize + '&inNo=' + this.InvoiceNo + '&soNo=' + this.SalesOrderNo + '&sapON=' + this.SAPOrderNo + '&invDateFrom=' + this.InvoiceDateFrom + '&invDateTo=' + this.InvoiceDateTo + '&prod=' + this.product + '&poNo=' + this.PONumber + '&userAccId=' + this.currentAccount + '&cntry=' + this.country;
        var res = encodeURI(downloadURI);
        window.open(res);
        //window.open(this.url+'/apex/InvoiceSummaryExcel?pgNo='+this.pageNumber+'&pgSize='+this.pagesize+'&soNo='+this.SalesOrderNo+'&invDateFrom='+this.InvoiceDateFrom+'&invDateTo='+this.InvoiceDateTo+'&prod='+this.Product+'&poNo='+this.PONumber+'&userAccId='+this.userAccountId+'&cntry='+this.country);
    }

    downloadfile(ID) {
        var pId = ID;
        //console.log('Id :'+ pId);
        let baseUrl = 'https://upl--upltest.my.salesforce.com/';
        this.showSpinner = true;
        contentVersionIdsList({ pId: pId }).then(result => {
                //console.log('result:-'+result);
                //var rLength=result.length;
                this.showSpinner = false;
                if (result == '') {
                    this.showErrorToast1(this.labels.Toast_Warning, this.labels.IS_Toast7, 'warning', 'dismissable'); //IS_Toast7
                } else {
                    for (let i = 0; i < result.length; i++) {
                        //console.log('result[i] : '+JSON.stringify(result[i]));
                        const element = result[i];
                        //console.log('element : '+element);    
                        setTimeout(function timer() {
                            let downloadElement = document.createElement('a');
                            var mediaTypeArray = ['application/html', 'application/java-archive', 'application/javascript', 'application/msword', 'application/octet-stream', 'application/octet-stream;type=unknown', 'application/opx', 'application/pdf', 'application/postscript', 'application/rtf', 'application/vnd.google-apps.document', 'application/vnd.google-apps.drawing', 'application/vnd.google-apps.form', 'application/vnd.google-apps.presentation', 'application/vnd.google-apps.script', 'application/vnd.google-apps.spreadsheet', 'application/vnd.ms-excel', 'application/vnd.ms-excel.sheet.macroEnabled.12', 'application/vnd.ms-infopath', 'application/vnd.ms-powerpoint', 'application/vnd.ms-powerpoint.presentation.macroEnabled.12', 'application/vnd.ms-word.document.macroEnabled.12', 'application/vnd.oasis.opendocument.presentation', 'application/vnd.oasis.opendocument.spreadsheet', 'application/vnd.oasis.opendocument.text', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/vnd.openxmlformats-officedocument.presentationml.slideshow', 'application/vnd.openxmlformats-officedocument.presentationml.template', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.openxmlformats-officedocument.spreadsheetml.template', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.openxmlformats-officedocument.wordprocessingml.template', 'application/vnd.visio', 'application/x-gzip', 'application/x-java-source', 'application/x-javascript', 'application/x-shockwave-flash', 'application/x-sql', 'application/x-zip-compressed', 'application/xhtml+xml', 'application/xml', 'application/zip', 'audio/mp4', 'audio/mpeg', 'audio/x-aac', 'audio/x-ms-wma', 'audio/x-ms-wmv', 'audio/x-wav', 'image/bmp', 'image/gif', 'image/jpeg', 'image/png', 'image/svg+xml', 'image/tiff', 'image/vnd.adobe.photoshop', 'image/vnd.dwg', 'image/x-photoshop', 'message/rfc822', 'text/css', 'text/csv', 'text/html', 'text/plain', 'text/rtf', 'text/snote', 'text/stypi', 'text/webviewhtml', 'text/x-c', 'text/x-c++', 'text/xml', 'video/mp4', 'video/mpeg', 'video/quicktime', 'video/x-m4v', 'video/x-ms-asf', 'video/x-msvideo', 'application/vnd.ms-excel'];
                            for (let j = 0; j < mediaTypeArray.length; j++) {
                                const strSplit = mediaTypeArray[j].split('/');
                                if (result[i].fType == strSplit[1]) {
                                    //console.log('mediaTypeArray[j] :'+mediaTypeArray[j]);
                                    downloadElement.href = 'data:' + mediaTypeArray[j] + ';base64,' + result[i].imagebase64Str;
                                }
                                if (result[i].fType == 'xls') {
                                    downloadElement.href = 'data:application/vnd.ms-excel;base64,' + result[i].imagebase64Str;
                                }
                            }
                            /*if(result[i].fType=='png'){
                                downloadElement.href = 'data:image/png;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='jpeg' || result[i].fType=='jpg'){
                                downloadElement.href = 'data:image/jpeg;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='gif'){
                                downloadElement.href = 'data:image/gif;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='pdf'){
                                downloadElement.href = 'data:application/pdf;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='csv'){
                                downloadElement.href = 'data:text/csv;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='xls'){
                                downloadElement.href = 'data:application/vnd.ms-excel;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='html'){
                                downloadElement.href = 'data:text/html;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='txt'){
                                downloadElement.href = 'data:text/plain;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='ttf'){
                                downloadElement.href = 'data:application/x-font-ttf;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='zip'){
                                downloadElement.href = 'data:application/zip;base64,'+result[i].imagebase64Str;
                            }else if(result[i].fType=='json'){
                                downloadElement.href = 'data:application/json;base64,'+result[i].imagebase64Str;
                            }*/

                            downloadElement.download = result[i].title;
                            downloadElement.target = '_self';

                            document.body.appendChild(downloadElement);
                            downloadElement.click();
                        }, i * 3000);
                    }
                }

                /*for (let i = 0; i < result.length; i++) {
                    const element = result[i];
                    //console.log('element : '+element);    
                    setTimeout(function timer() {
                        let downloadElement = document.createElement('a');
                        downloadElement.href = baseUrl+'sfc/servlet.shepherd/version/download/'+element;
                        downloadElement.target = '_self';
                        document.body.appendChild(downloadElement);
                        downloadElement.click(); 
                    }, i * 3000);
                  }*/
            })
            .catch(error => {
                this.error = error;
            });
    }


    downloadCSVFile() {
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.invoiceData.forEach(function(record) {
            Object.keys(record).forEach(function(key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);

        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for (let i = 0; i < this.invoiceData.length; i++) {
            let colValue = 0;

            // validating keys in data
            for (let key in rowData) {
                if (rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if (colValue > 0) {
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.invoiceData[i][rowKey] === undefined ? '' : this.invoiceData[i][rowKey];
                    csvString += '"' + value + '"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'Invoice_Summary.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click();
    }

    closeModal() {
        this.bShowModal = false;
        this.bShowModal1 = false;
        this.showInvoiceModal=false;
        //changes by Akhilesh for Invoice line item card
        this.pageSize='10';
        this.template.querySelector('.main').style="display:block";
        this.getData();
    }
     // added by Akhilesh w.r.t Mobile UI.
    
     showDetails(event){
        //this.recordId= event.currentTarget.dataset.id;
        this.recordId = event.detail;
        if(this.country == 'Poland'){
            this.recordId= event.detail.Id;
        }
        console.log('Invoice rec Id=> ',this.recordId);
        this.showInvoiceModal=true;
        this.pageSize='5';
        var rValue = event.detail.actionName;
        console.log('rValue-->',event.detail.actionName);
       
        getInvoice({ invoiceId: this.recordId })
                .then(result => {
                    this.invoice = result;
                    Console.log(JSON.stringify(this.invoice));
                    //console.log('invoice-->',this.invoice);
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error;
                });
    
        getInvoiceLineItem({ invoiceId: this.recordId })
        .then(result => {
                this.invoiceLineItems = result;
                //Changes by Akhilesh w.r.t. Invoice Line items card
				this.invoiceLineDataLength = this.invoiceLineItems;
                this.totalRecountCount = this.invoiceLineItems.length;
                if(this.invoiceLineItems[0].Invoice__r.Sold_to_Party_SAP_Code__c=='0001083269')
                {
                    this.isKaneko=true;
                    this.InvoiceReflectioncode= this.invoiceLineItems[0].Sales_Order_Line_Item__r.Invoice_Reflection_Code__c;
                }
				if (this.invoiceLineDataLength.length !== 0) {
                    this.showResult = true;
                    console.log('true part');
                    this.page = 1;
                    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                //this.HandleButton();
                this.invoiceLineDataLength = this.invoiceLineItems.slice(0, this.pageSize);
                this.rowNumberOffset = 0;
                this.endingRecord = this.pageSize;
                this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount) ?
                    this.totalRecountCount : (this.pageSize * this.page);
                
                    this.showSpinneer = false;
                } else {
                    this.showResult = false;
                    this.showErrorToast1(this.labels.Toast_Info, this.labels.No_Result_Found, 'info', 'dismissable'); //No_Result_Found
                    console.log('false part');
                    this.page = 0;
                    this.showSpinneer = false;
                }
                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                //this.HandleButton();
                this.data = this.invoiceData.slice(0, this.pageSize);
                this.rowNumberOffset = 0;
                this.endingRecord = this.pageSize;
                this.endingRecord = ((this.pageSize * this.page) > this.totalRecountCount) ?
                    this.totalRecountCount : (this.pageSize * this.page);
                console.log('invoiceLineItems-->', this.invoiceLineItems);
                this.error = undefined;
        })
        .catch(error => {
            this.error = error;
        });
 
        if (rValue === 'Download') {
            this.showInvoiceModal=false;
            this.downloadfile(this.recordId);
        }else{
            this.template.querySelector('.main').style="display:none";
        }
        console.log('end');
        }

}