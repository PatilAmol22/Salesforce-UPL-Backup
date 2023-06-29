@isTest
public class SOColumbiaComp_Test {
    
    @testSetup
    static void allTheDataForThisTestClass() {
        
        Id devRecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        System.debug('devRecordTypeId===> '+devRecordTypeId);
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        System.debug('devRecordAcc ===> '+devRecordAcc);
        Id devRecordDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        
        
        //Data for Sales Org
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Codes
        );
        insert salesOrgObj;
        
        //Data for Division
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORU';              
        ordType.Order_Type_Code__c = 'ZORU';
        ordType.SalesOrg__c = salesOrgObj.Id;
        insert ordType;
        
        //Data for Distribution Channel
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67',  // Distribution Channel Code
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
            PG_Code__c = '76',                  // PG Code
            Description_Colombia__c = 'Casagro'  // Description
        );
        insert priceGroupMasterObj;
        
        
        //Data for account 1
        Account accObj1 = new Account(
            Name = 'BAM',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',				                           // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            // LanguageKey__c = 'EN',                                             // Language Key
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            // CountryKey__c = 'IN',                                              // Country Key
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            //   ShippingConditions__c = '01',                                      // Shipping Conditions
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            //   CustomerAccountGroup__c = 'Z031',                                  // Customer Account Group
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //  Tax_classification_for_customer__c = '1',
            PriceGroupCode__c =priceGroupMasterObj.Id							// Tax classification for customer
        );
        insert accObj1;
        
        
        //Data for Account 2
        Account accObj = new Account(
            Name = 'BAM S.A.',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'BAM S.A.',                                         // Last Name
            SAP_Code__c = '0001023194',                                        // SAP Customer Code
            Mobile__c = '1234567980',				                           // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589795',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            //  LanguageKey__c = 'EN',                                             // Language Key
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            //   CountryKey__c = 'IN',                                              // Country Key
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            // ShippingConditions__c = '01',                                      // Shipping Conditions
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            //   CustomerAccountGroup__c = 'Z031',                                  // Customer Account Group
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //   Tax_classification_for_customer__c = '1',
            PriceGroupCode__c =priceGroupMasterObj.Id							// Tax classification for customer
        );
        insert accObj;
        
        
        
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
            Country_Name__c = 'Colombia',                              // Country Name
            Sales_Org__c = salesOrgObj.Id,                          // Sales Org
            Distribution_Channel__c = DistributionChannelObj.Id,               // Distribution Channel
            Division__c = divisionObj.Id                           // Division
            
        );
        insert shippingLocationObj;
        
        //Data for Sales Orders
        Sales_Order__c SalesOrderObj = new Sales_Order__c(
            RecordTypeId = devRecordTypeId,                        // Record Type
            SFDC_Order_Number__c = '87614',                      // SFDC Order Number
            Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Desc_Punctuality__c = false,                         // Desc Punctuality
            Order_Date__c = System.today(),            // Order Date
            OrderSubStatus__c = 'Draft',                         // Order Sub-Status
            Punctuality_Discount__c = 0.00,                      // Punctuality Discount
            Flag_Status__c = '\n',                               // Flag Status
            isOffline_Mobile_Order__c = false,                   // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = false,          // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,                // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                       // Process Builder Flag
            BrazilSalesOrderApproved__c = false,                 // Brazil Sales Order Approved
            Turkey_Order_Send_for_Approval__c = false,           // Turkey Order Send for Approval
            Key_Account__c = false,                              // Key Account
            Customer_Approval__c = false,                        // Customer Approval
            Signed__c = false,                                   // Signed
            SentEmailIndonesia__c = false,                       // Sent Email Indonesia
            Sales_Org_lk__c = salesOrgObj.Id,                 // Sales Org
            RequestforCancellationCheck__c = false,              // Request for Cancellation
            TM_Code__c = '00051120',                             // TM Code
            ApprovedBySDM__c = false,                            // Approved By SDM
            ApprovedBySOM__c = false,                            // Approved By SOM
            ApprovedByBM__c = false,                             // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                 // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                           // Approved By SD
            Division_lk__c = DivisionObj.Id,                  // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,      // Distribution Channel
            Sent_for_Manager_Approval_Mexico__c = true,          // Sent for Manager Approval
            Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
            Bill_To_Party__c = accObj.Id,                // Bill To Party
            Depot_Code__c = 'CO51',                              // Depot Code
            Sold_to_Party__c = accObj.Id,                // Sold to Party
            Ship_To_Party__c = shippingLocationObj.Id,                // Ship To Party
            UGDN__c = '20011688' ,                               // UGDN
            Order_Type_Colombia__c = 'Normal Order'
        );
        insert SalesOrderObj;
        
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
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Combination_Key__c = '57106710000000000006180633',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'FURRY1'                          // Brand Name
        );
        insert skuObj;
        
        //Data for Depot  
        Depot__c depotObj = new Depot__c(
            Name = 'CO00',                             // Depot Name
            Location__c = 'CO00',                        // Location
            SalesOrg__c = salesOrgObj.Id,             // Sales Org
            Depot_Code__c = 'CO00',                      // Depot Code
            RecordTypeId = devRecordDepot,                  // Record Type
            Active__c = false                           // Active
        );
        insert depotObj;
        
        //Data for Admin MPT
        Admin_MPT_Colombia__c AdminMPTColombiaObj = new Admin_MPT_Colombia__c(
            of_adjustment_to_display_vendor_utility__c = 70.00,// Percentage Of Adjustment
            Min_for_Profitable_in_result_by_margin__c = 45.00,   // Minimum Percentage For Profitable
            Level_1_max__c = 35.00,                              // Level 1 Maximum Percentage
            Level_1_min__c = 30.10,                              // Level 1 Minimum Percentage
            Level_2_max__c = 30.00,                              // Level 2 Maximum Percentage
            Level_2_min__c = 25.10,                              // Level 2 Minimum Percentage
            Level_3_below__c = 25.00,                            // Level 3 Below Percentage
            Max_no_of_prod_asso_with_initial_product__c = 4,   // Maximum Number Of Product
            Sales_Org__c =salesOrgObj.Id,
            USD_Conversion_Rate__c=1,
            Active__c = true                                    // Active
        );
        insert AdminMPTColombiaObj;
        
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
        
        //Data for Sales Order Line Item
        Sales_Order_Line_Item__c saleOrderLineObj = new Sales_Order_Line_Item__c(
            Sale_Order__c = SalesOrderObj.Id,      // Sales Order
            SKU_Name__c = skuObj.Id,                // SKU Name
            Item_Number__c = 10,                  // Item Number
            UOM__c = 'L',                           // UOM
            Net_Price__c = 10.00,                   // Net Price
            MinPrice__c = 10.00,                    // Min Price
            MaxPrice__c = 15.00,                    // Max Price
            Quantity__c = 9.00,                   // Quantity
            FinalPrice__c = 10.00,                  // Final Price
            Price__c = 90.00                       // Value
            //Business_Type_Colombia__c ='Producto Inicial'
        );
        insert saleOrderLineObj;
        
    }
    static testMethod void method1(){
        list<account> accs=new list<account>();
        Account acc2 = [SELECT id,Sales_Org_Code__c FROM Account WHERE Last_Name__c = 'SAR123' LIMIT 1]; 
        accs.add(acc2);
        
        Test.startTest();
        Test.setCurrentPage(Page.SOColumbiaComp_VF);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(accs);
        stdSetController.setSelected(accs);
        ApexPages.CurrentPage().getParameters().put('recordId',acc2.id);
        SOColumbiaComp_Controller ext = new SOColumbiaComp_Controller(stdSetController);
        SOColumbiaComp_Controller.getAccountData(acc2.id);
        Test.stopTest();
    }
}