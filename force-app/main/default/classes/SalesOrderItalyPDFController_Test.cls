/*
Name: Vishal Pawar
Email : vishal.pawar@skinternational.com
Description : Helper Class for SalesOrderItalyPDFController

*/

@isTest
public class SalesOrderItalyPDFController_Test {
    
    @testSetup
    static void allTheDataForThisTestClass() {
        
          Id devRecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        
        
        //Data for Sales Org
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Italy',           // Sales Org Name
            Company_Code__c = '2400',      // Company Code
            Sales_Org_Code__c = '2410',    // Sales Org Code
            Country_Code__c = 'IT'        // Country Codes
        );
        insert salesOrgObj;
        
        //Data for Division
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZIOR';              
        ordType.Order_Type_Code__c = 'ZIOR';
        ordType.SalesOrg__c = salesOrgObj.Id;
        insert ordType;
        
        //Data for Distribution Channel
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
       
        
        //Data for Payment Term
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term__c = 'Net 7 days',   // Payment Term
            Payment_Term_Code__c = 'UK01',      // Payment Term Code
            Payterms_Desc__c = 'Net 7 days',    // Payterms Desc
            Sales_Org__c = salesOrgObj.Id,   // Sales Org
            Days_to_calc_interest__c = 0,     // Days (to calc interest)
            Active__c = true,                   // Active
            CombinationKey__c = '5710UK01'     // CombinationKey
        );
        insert paymentTermObj;
        
        //Data for Price Group
        Price_Group_Master__c priceGroupMasterObj = new Price_Group_Master__c(
            PG_Code__c = '95',                // PG Code
            Description_Colombia__c = 'Casagro'  // Description
        );
        insert priceGroupMasterObj;
        
        Payment_Term_PG_Group_Mapping__c paymentPgMapObj = new Payment_Term_PG_Group_Mapping__c(
            Name = '0001',   // Payment Term
            Payment_Term_Italy__c = paymentTermObj.Id,      // Payment Term Code
            Price_Group_Master_Italy__c =priceGroupMasterObj.Id    // Payterms Desc
        );
        insert paymentPgMapObj;
        
        
        //Data for account 1
        Account accObj1 = new Account(
            Name = 'BAM',                                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            PriceGroupCode__c =priceGroupMasterObj.Id,              // Tax classification for customer
          AuthorizationGroupSalesoffice__c='',
          Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        
        //Data for Account 2
        Account accObj = new Account(
            Name = 'BAM S.A.',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'BAM S.A.',                                         // Last Name
            SAP_Code__c = '0001023194',                                        // SAP Customer Code
            Mobile__c = '1234567980',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589795',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            PriceGroupCode__c =priceGroupMasterObj.Id,              // Tax classification for customer
          AuthorizationGroupSalesoffice__c='',
          Tax_classification_for_customer__c=''
        );
        insert accObj;
        
          Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=accObj.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c=salesOrgObj.Id;
        insert crdIf;
        
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'BAM S.A.',                           // Location Name
            SAP_Code__c = '0001023194',                                // SAP Code
            Distributor__c = accObj.Id,                        // Distributor
            City__c = 'BOGOTA DC',                                     // City
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 1
            State__c = '11',                                           // State
            Country__c = 'CO',                                         // Country
            Billing_Street_3__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 3
            Pincode__c = '11001',                                      // Pincode
            Sold_To_Party_SAP_Code__c = '0001023194',                  // Sold To Party (SAP Code)
            Combination_Key__c = '00010231940001023194',               // Combination Key
            Country_Name__c = 'Italy',                   // Country Name
            Sales_Org__c = salesOrgObj.Id,                          // Sales Org
            Distribution_Channel__c = DistributionChannelObj.Id,               // Distribution Channel
            Division__c = divisionObj.Id                           // Division
            
        );
        insert shippingLocationObj;
        
      
        
        //Data For Product
        Product2 productObj = new Product2(
            Name = 'ALPHA CYPER 10% EC',         // Product Name
            Product_Code__c = '65100',             // Product Code
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '6510057106710',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
          //  Multiple_Of__c = 0.0,                // Multiple Of
            Budget_NRV__c = 0.00                // Budget NRV
        );
        insert productObj;
        
        
        
        
        //Data for SKU
        SKU__c skuObj = new SKU__c(
            Name = 'a1C0k000000NAz5',                         // SKU Name
            SKU_Code__c = '000000000006180633',                 // SKU Code
            Product_Name__c = productObj.Id,                // Product Nam
            SKU_Description__c = 'FURYY 40 EC X 250 cc',        // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = DistributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = divisionObj.Id,   
            Unit_Cost__c = 200,
            Area_Manager_MSP__c =150,
            Sales_Agent_MSP__c =500,
            Sales_Director_MSP__c =50,
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Combination_Key__c = '57106710000000000006180633',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'FURRY1',                          // Brand Name
          Inventory_Description_Italy__c='Stock available'
        );
        insert skuObj;
        
        //Data for Depot  
        Depot__c depotObj = new Depot__c(
            Name = 'IT00',                             // Depot Name
            Location__c = 'IT00',                        // Location
            SalesOrg__c = salesOrgObj.Id,             // Sales Org
            Depot_Code__c = 'IT00',                      // Depot Code
            RecordTypeId = devRecordDepot,                  // Record Type
            Active__c = false                           // Active
        );
        insert depotObj;
        
         PricebookDiscount__c PbDis = new PricebookDiscount__c();
        PbDis.Batch__c = 'test';                                               
        PbDis.DepotCode__c = depotObj.Id;                                  
        PbDis.EndDate__c = System.today()+1;                         
        PbDis.PerUnit__c = 1.00;                                                 
        PbDis.PG_Code__c =null;// priceGroupMasterObj.Id;                                   
        PbDis.SKUCode__c = skuObj.Id;                             
        PbDis.StartDate__c = system.today();                         
        PbDis.Active__c = false;
        PbDis.DistributorCustomerCode__c = accObj.Id;
        PbDis.Price__c = 200.00;                                                 
        PbDis.UOM__c = 'KG';                                                   
        PbDis.CompositeKey__c = '01-04-2016BHA103000000000000692001';           
        insert PbDis;
        
        Trans_Contribution__c tcData = new Trans_Contribution__c();
        tcData.name ='default value';
        tcData.LessThanPallet__c =0.20;
        tcData.MoreThanPallet__c = 0.10;
        insert tcData;
        
    //Data for PRice Book Master       
        PriceBookMaster__c priceBookMasterObj = new PriceBookMaster__c(
            DistributorCustomerCode__c = accObj.Id,         // Distributor Customer Code
            SKUCode__c = skuObj.Id,                           // SKU Code
            Price__c = 61000.00,                                      // Price / Max Price
            DepotCode__c = DepotObj.Id,                         // Depot Code
            MinPrice__c = 41000.00,                                   // Min Price
            Final_Price__c = 0.00,                                    // Final Price
            StartDate__c = System.today(),                // Start Date
            EndDate__c = System.today()+10,                    // End Date
            UOM__c = 'L',                                             // UOM
            Division__c = divisionObj.Id,                          // Division
            DistributionChannel__c = distributionChannelObj.Id,               // Distribution Channel
            Sales_Org__c = salesOrgObj.Id,
            CompositeKey__c ='c1'// Sales Org
        );
        insert priceBookMasterObj;
        
        
        DistributorSalesAreaMapping__c DistributorSalesAreaMappingObj = new DistributorSalesAreaMapping__c(
              AccountType__c = 'Sold To Party',          // Account Type
              Distributor__c = accObj.id,          // Distributor
              SalesOrg__c = salesOrgObj.id,             // Sales Org
              OrderBlock__c = false,                       // Order Block
              DistributionChannel__c = distributionChannelObj.id,  // Distribution Channel
              Division__c = divisionObj.id,             // Division
                    // Account Owner
              PriceGroupMaster__c = priceGroupMasterObj.id     // Price Group Master
            );
            insert DistributorSalesAreaMappingobj;
        
        
        
         DistributorSalesAreaMapping__c DistributorSalesAreaMappingObj1 = new DistributorSalesAreaMapping__c(
              AccountType__c = 'Sold To Party',          // Account Type
              Distributor__c = accObj1.id,          // Distributor
              SalesOrg__c = salesOrgObj.id,             // Sales Org
              OrderBlock__c = false,                       // Order Block
              DistributionChannel__c = distributionChannelObj.id,  // Distribution Channel
              Division__c = divisionObj.id,             // Division
                    // Account Owner
              PriceGroupMaster__c = priceGroupMasterObj.id     // Price Group Master
            );
            insert DistributorSalesAreaMappingobj1;
        
        
        
        //Data for PRice Book Master       
        PriceBookMaster__c priceBookMasterObj1 = new PriceBookMaster__c(
            DistributorCustomerCode__c =null,         // Distributor Customer Code
            SKUCode__c = skuObj.Id,    
            PG_CODE__c =priceGroupMasterObj.Id,
            Price__c = 60000.00,                                      // Price / Max Price
            DepotCode__c = DepotObj.Id,                         // Depot Code
            MinPrice__c = 41000.00,                                   // Min Price
            Final_Price__c = 0.00,                                    // Final Price
            StartDate__c = System.today(),                // Start Date
            EndDate__c = System.today()+10,                    // End Date
            UOM__c = 'L',                                             // UOM
            Division__c = divisionObj.Id,                          // Division
            DistributionChannel__c = distributionChannelObj.Id,               // Distribution Channel
            Sales_Org__c = salesOrgObj.Id,
            CompositeKey__c ='c12'// Sales Org
        );
        insert priceBookMasterObj1;
        
        Order__c ord = new Order__c();
        ord.Bill_To_Party__c = accObj.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =salesOrgObj.Id;          
        insert ord;
        
        OrderLineItem__c ordItem = new OrderLineItem__c();
        ordItem.SKU_Name__c = skuObj.Id; 
        ordItem.FinalPrice__c =12;
        ordItem.pallet_Size_Italy__c =100.00;
       // ordItem.Weight_Italy__c =20;
        ordItem.Transport_contribution__c =45.00;
        ordItem.Discount2__c =490.00;
        ordItem.Average_Final_Price__c =4000.00;
      //  ordItem.Ordered_weight__c =280.00;
        ordItem.Quantity__c = 14;          
        ordItem.Special_Discount__c = 0.00;     
        ordItem.Price__c = 4500.00; 
        ordItem.Shipping_Date__c = System.today(); 
        ordItem.Net_Invoice_Price__c = 4500.00; 
        ordItem.Order__c = ord.Id;    
        ordItem.Net_Price__c = 63000.00;  
        ordItem.Product_Type_Italy__c = 'Vendita';
        ordItem.Inventory_order_Flag_Color_Italy__c='';
        ordItem.Inventory_Description_Italy__c='Stock available';
        insert ordItem; 
    
        
          //Data for Sales Orders
        Sales_Order__c SalesOrderObj = new Sales_Order__c(
            RecordTypeId = devRecordTypeId,                        // Record Type
            SFDC_Order_Number__c = '87614',                      // SFDC Order Number
         // Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Desc_Punctuality__c = false,                         // Desc Punctuality
            Order_Date__c = System.today(),            // Order Date
            OrderSubStatus__c = 'Draft',                         // Order Sub-Status
            Punctuality_Discount__c = 0.00,                      // Punctuality Discount
            Flag_Status__c = '\n',                               // Flag Status
            isOffline_Mobile_Order__c = false,                   // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = false,
            Call_Process_Builder_Flow__c = false,                // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                       // Process Builder Flag
            Customer_Approval__c = false,                        // Customer Approval
            Sales_Org_lk__c = salesOrgObj.Id,                 // Sales Org
            RequestforCancellationCheck__c = false,              // Request for Cancellation
            TM_Code__c = '00051120',                             // TM Code
            ApprovedBySDM__c = false,     
            Order_Status__c ='Pending',
            ApprovedBySOM__c = false,                            // Approved By SOM
            ApprovedByBM__c = false,                             // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                 // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                           // Approved By SD
            Division_lk__c = DivisionObj.Id,                  // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,      // Distribution Channel
            Sent_for_Manager_Approval_Mexico__c = true,          // Sent for Manager Approval
            Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
            Bill_To_Party__c = accObj.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = accObj.Id,                // Sold to Party
            Ship_To_Party__c = shippingLocationObj.Id,                // Ship To Party
            UGDN__c = '20011688'                            // UGDN
        );
        insert SalesOrderObj;
        
        //Data for Sales Order Line Item
        Sales_Order_Line_Item__c saleOrderLineObj = new Sales_Order_Line_Item__c(
            Sale_Order__c = SalesOrderObj.Id,      // Sales Order
            SKU_Name__c = skuObj.Id,                // SKU Name
            Item_Number__c = 10,                  // Item Number
            UOM__c = 'L',      
            Net_Price__c = 10.00,                   // Net Price
            MinPrice__c = 10.00,                    // Min Price
            MaxPrice__c = 15.00,                    // Max Price
            Quantity__c = 9.00,                   // Quantity
            FinalPrice__c = 10.00,                  // Final Price
            Price__c = 90.00,                       // Value
            Product_Type_Italy__c ='Vendita',
            Inventory_order_Flag_Color_Italy__c='',
            Inventory_Description_Italy__c='Stock available'
        );
        insert saleOrderLineObj;
        
    }
    
    static testMethod void method() {
        List<Sales_Order__c> salesOrderList= [select id,Sold_to_Party__c From Sales_Order__c];
        List<Id> sIdList = new List<Id>();
        
        for(Sales_Order__c SalesOrderObj :salesOrderList){
            sIdList.add(SalesOrderObj.Id);
        }
        
        SalesOrderItalyPDFInvokable controllerObj = new SalesOrderItalyPDFInvokable();
        SalesOrderItalyPDFInvokable.ProcessSalesorder(sIdList);
        
        
          Sales_Order__c salesOrderObj =[select id,Sold_to_Party__c From Sales_Order__c];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(salesOrderObj);
        
        SalesOrderItalyPDFController SalesOrderPDFObj = new SalesOrderItalyPDFController(sc);
        SalesOrderPDFObj.salesOrderId = salesOrderList[0].Id;
        SalesOrderPDFObj.gettingSoID();
        
        
        
    }
    
    
}