/*
* Name: EditSalesOrderArgentinaTest
* Created On:8 June 2018 
* Author: Vishal pawar (vishal.pawar@skinternational.com)
* Description: This test Class for Edit Order Sales Order for Argentina
*/


@isTest
public class EditSalesOrderArgentinaTest {      
    
    
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
     
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Charata';
        dp.Country__c='Argentina';
        dp.Location__c='Charata';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        //Data for Sales Org
         Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Argentina',        // Sales Org Name
            Sales_Org_Code__c = '5631'  // Sales Org Code
        );
        insert salesOrgObj;
        
       Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZXKB',                  // Order Type Name
            Description__c = 'Consignatario',     // Description
            Order_Type_Code__c = 'ZXKB',      // Order Type Code
            SalesOrg__c = salesOrgObj.Id  // Sales Org
        );
        insert orderTypeObj;
        
        
        
         //Data for Distribution Channel 
        Distribution_Channel__c distributionChannelObj = new Distribution_Channel__c(
            Name = 'Direct',                    // Distribution Channel Name
            Distribution_Channel_Code__c = '10'  // Distribution Channel Code
        );
        insert distributionChannelObj;
         
        
         //Data for Division
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
         //Bill to party /sold to party is Account Object 
        Account accObj = new Account(
            Name='Bhavik Devdhar',
            SAP_Code__c = '0001013292', 
            PriceGroupCode__c=pg.id,
            RecordTypeId=devRecordTypeId,                           // SAP Customer Code
            Last_Name__c = 'ADECO AGROPECUARIA S.A.',     // Last Name
            Order_Block__c = false,                       // Order Block
            Mobile__c = '9405883688',  
            Phone='020256589', // Mobile
            Email__c = 'marcelo.gorla@uniphos.com',       // Email
            Account_Type__c = 'Sold To Party',            // Account Type
            Raise_Order_Type__c = 'Factura',                 // Raise Order Type
            Billing_Street_2__c = 'CATAMARCA 3454',       // Billing Street 2
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            Division__c = divisionObj.Id,              // Division Name
            Distribution_Channel__c = distributionChannelObj.Id,  // Distribution Channel
            Depot_Code__c = 'AR13',                       // Depot Code
            BillingCity ='AR'
        );
        insert accObj;
        
       
        
         Product2 productObj = new Product2(
            Name = 'BISECT',                     // Product Name
            ProductCode = '71501',                 // Product Code
            Product_Code__c = '71501',             // Product Code
            IsActive = false,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.id,      // Sales Org
            Combination_Key__c = '7150156311010',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false     // Active For Liquidation
        );
        insert productObj;
        
         SKU__c sku = new SKU__c(
            Name = 'DOST',                                   // SKU Name
            SKU_Code__c = '000000000006019997',                 // SKU Code
            Product_Name__c = productObj.id,                // Product Name
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = distributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                                // Pack Size
            Division__c = divisionObj.Id,                    // Division
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Multiple_of__c = 20.00,                             // Multiple Of
            Combination_Key__c = '56311010000000000006019997',  // Combination Key
            Active__c = true,                                   // Active
            Brand_Name__c = 'DOST'                      // Brand Name
        );
        insert sku;
                                               
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;    
        PbMaster.MinPrice__c = 3000;
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'KG';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CompositeKey__c='c1';
        PbMaster.CurrencyIsoCode = 'USD';
        insert PbMaster; 
        
        
        
       
        
        contact con = new Contact();
        con.AccountId=accObj.Id;
        con.LastName=accObj.Last_Name__c;
        insert con;
        
        userrole  usrole = new userrole();
        usrole.Name ='Bhavik Devdhar Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Sales Head Argentina'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        //sobj1.ContactId=con.Id;
        insert sobj1;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
        
        Order_Type__c  orderTypeObsj = new Order_Type__c(
            Name = 'ZXOR',                  // Order Type Name
            Description__c = 'Factura',     // Description
            Order_Type_Code__c = 'ZXOR',      // Order Type Code
            SalesOrg__c = salesOrgObj.Id  // Sales Org
        );
        insert orderTypeObsj;
        
        Order_Type__c  orderTypeObj1 = new Order_Type__c(
            Name = 'Consignatario',                  // Order Type Name
            Description__c = 'Consignatario',     // Description
            Order_Type_Code__c = 'Consignatario',      // Order Type Code
            SalesOrg__c = salesOrgObj.Id  // Sales Org
        );
        insert orderTypeObj1;
        
        Order_Type__c  orderTypeObj2 = new Order_Type__c(
            Name = 'Commission Sales',                  // Order Type Name
            Description__c = 'Commission Sales',     // Description
            Order_Type_Code__c = 'Commission Sales',      // Order Type Code
            SalesOrg__c = salesOrgObj.Id  // Sales Org
        );
        insert orderTypeObj2;
        
        
        
        
        Inventory__c invObj = new Inventory__c( );
        invObj.Stock_Quantity__c = 10;   
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Depot__c = dp.Id;    
        invObj.UOM__c = 'L';                    
        invObj.Storage_Location__c = 'MAIN';  
        invObj.SKU__c = sku.Id;  
        invObj.SKU_Depot__c ='sd1';           
        insert invObj;
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = accObj.id;
        dsMap.Depot__c=dp.Id;
        insert dsMap;
        
       
        
        SKU_Pack_Size__c spObj = new SKU_Pack_Size__c();
        spObj.Depot__c = dp.Id;
        spObj.UOM__c = 'L';
        spObj.SKU__c = sku.Id;
        spObj.Pack_Size__c = '5';
        insert spObj;
        
        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=accObj.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c = salesOrgObj.id;
        insert crdIf;
        
        //Data for Shipping Location
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'ADECO AGROPECUARIA S.A.',// Location Name
            Distributor__c = accObj.Id,            // Distributor
            SAP_Code__c = '00010132925631',                // SAP Code
            City__c = 'MARTINEZ -PCIA. BUENOS AI',         // City
            State__c = '01',                               // State
            Country__c = 'AR',                             // Country
            Pincode__c = '1640',                           // Pincode
            Sold_To_Party_SAP_Code__c = '0001013292',      // Sold To Party (SAP Code)
            Sales_Org__c = salesOrgObj.Id,              // Sales Org
            
            Distribution_Channel__c = distributionChannelObj.Id,   // Distribution Channel
            Division__c = divisionObj.id               // Division
        );
        insert shippingLocationObj;
        
       
        
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippingLocationObj.id;  
        ord.Bill_To_Party__c = accObj.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Raise_By__c = 'Distributor';                                     
        ord.Order_Status__c = 'Pending';                                        
        ord.Sales_Org__c =salesOrgObj.Id;          
        ord.Distribution_Channel__c =distributionChannelObj.Id; 
        ord.Division__c = divisionObj.Id;
        insert ord;
        
       
    
       
        
        //Data for Order Object 
        Order__c orderObj = new Order__c(
            Order_Date__c = system.today(),     // Order Date
            Order_Raise_By__c = 'Territory Manager',      // Order Raise By
            Order_Status__c = 'Approved',                 // Order Status
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            Division__c = divisionObj.id,              // Division
            Distribution_Channel__c = distributionChannelObj.id,  // Distribution Channel
            Bill_To_Party__c = accObj.Id,         // Bill To Party
            Shipping_Location__c = shippingLocationObj.id     // Shipping Location
        );
        insert orderObj;
        
       
        
        
        
        //Data for Payment Method for Contado
        Payment_Method__c paymentMethodObj = new Payment_Method__c(
            Name = 'Contado',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'C1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodObj;
        
        //for credit card
         Payment_Method__c paymentMethodCreditObj = new Payment_Method__c(
            Name = 'Credit Card',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'CD1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodCreditObj;
        
        //for Long Barter
        
        Payment_Method__c paymentMethodLongBarterObj = new Payment_Method__c(
            Name = 'Long Barter',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'LB1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodLongBarterObj;
        
        
        // for Available Barter
       Payment_Method__c paymentMethodAvailableBarterObj = new Payment_Method__c(
            Name = 'Available Barter',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'AB1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodAvailableBarterObj;
        
        //for Wire transfer
        Payment_Method__c paymentMethodWireTransferObj = new Payment_Method__c(
            Name = 'Wire transfer',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'WT1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodWireTransferObj;
        
        
        //for Check
         Payment_Method__c paymentMethodCheckObj = new Payment_Method__c(
            Name = 'Check',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'CH1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodCheckObj;
        
        //data for Payment Term for 30 days
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = '30 dias',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Maturity_Date_Mandatory__c = 'Yes',                  // Maturity Date Mandatory
            Sales_Org__c = salesOrgObj.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        //data for Payment Term for 120 days
        Payment_Term__c paymentTermFor120DaysObj = new Payment_Term__c(
            Payment_Term_Code__c = '0017',    // Payment Term Code
            Payment_Term__c = '120 dias',       // Payment Term
            Maturity_Date_Mandatory__c = 'No',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 120,     // Days (to calc interest)
            Sales_Org__c = salesOrgObj.Id,    // Sales Org
            Active__c = false                  // Active
        );
        insert paymentTermFor120DaysObj;
        
        //data for payment term for 150 days
        Payment_Term__c paymentTerm150DayObj = new Payment_Term__c(
            Payment_Term_Code__c = '0018',    // Payment Term Code
            Payment_Term__c = '150 dias',       // Payment Term
            Maturity_Date_Mandatory__c = 'No',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 150,     // Days (to calc interest)
            Sales_Org__c = salesOrgObj.Id,   // Sales Org
            Active__c = false                  // Active
        );
        insert paymentTerm150DayObj;
       
        //data for payment term for 60 days
        Payment_Term__c paymentTerm60DayObj = new Payment_Term__c(
            Payment_Term_Code__c = '0016',    // Payment Term Code
            Payment_Term__c = '60 dias',        // Payment Term
            Maturity_Date_Mandatory__c = 'No',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 60,      // Days (to calc interest)
            Sales_Org__c =salesOrgObj.Id ,   // Sales Org
            Active__c = false                  // Active
        );
        insert paymentTerm60DayObj;
        
        
        //data for payment term for 90 days
        Payment_Term__c paymentTerm90DayObj = new Payment_Term__c(
            Payment_Term_Code__c = '0014',     // Payment Term Code
            Payment_Term__c = '90 dias',         // Payment Term
            Maturity_Date_Mandatory__c = 'Yes',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 0,        // Days (to calc interest)
            Sales_Org__c =salesOrgObj.Id ,    // Sales Org
            Active__c = false                   // Active
        );
        insert paymentTerm90DayObj;
       
       //Sales Org Insert
       Sales_Org__c sorg1 =new Sales_Org__c();
        sorg1.Name='Argentina';
        sorg1.Description__c='Argentina';
        sorg1.Sales_Org_Code__c='2710';
        insert sorg1; 
        
    //Data for Sales Order Object
        
        Sales_Order__c salesOrderobj = new Sales_Order__c(
            SFDC_Order_Number__c = '13875',               // SFDC Order Number
            Order_Raise_By__c = 'Territory Manager',        // Order Raised By
            Order_Status__c = 'Open',                       // Order Status
            Order_Cancel__c = false,                        // Order Cancel
            Order_Date__c = system.today(),       // Order Date
            Order__c = orderObj.id,                   // Order
            ProcessBuilderFlag__c = false,                  // Process Builder Flag
            Manager__c = sobj1.id,                 // Manager
            PaymentMethod__c = paymentMethodObj.Id,           // Payment Method
            Payment_Term__c = paymentTermObj.id,            // Payment Term
            Customer_Approval__c = false,                   // Customer Approval
            Order_Type_lk__c = orderTypeObj.Id,           // Order Type
            Customer_Approval_Status__c = 'Approved',       // Customer Approval Status
            ArgentinaOrderSubmittedforApproval__c = false,  // Argentina Order Submitted for Approval
            InternalApprovalCheck__c = false,               // Internal Approval Check
            BudgetApprovalCheck__c = true,                  // Budget Approval Check
            Total_Amount__c = 2400.00,                      // Total Amount
            Sold_to_Party__c = accObj.Id,           // Sold to Party
            Bill_To_Party__c = accObj.Id,           // Bill To Party
            Ship_To_Party__c = shippingLocationObj.Id,           // Ship To Party
            CreatedFrom__c = 'SFDC',                        // Created From
            Sales_Org_lk__C=sorg1.ID,
            Ship_To_Party_Account__c=accObj.ID
        );
        insert salesOrderobj;
        
        
        
        
        Product2 productObj2 = new Product2(
            Name = 'AZULOX',                     // Product Name
            ProductCode = '36860',                 // Product Code
            Product_Code__c = '36860',             // Product Code
            IsActive = false,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.id,      // Sales Org
            Combination_Key__c = '3686056311010',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false     // Active For Liquidation
            //multipleOf__c = 4.0                  // Multiple Of
        );
        insert productObj2;
        
        SKU__c sku1 = new SKU__c(
            Name = '200 LTS',                                 // SKU Name
            SKU_Code__c = '000000000006301278',                 // SKU Code
            Product_Name__c = productObj2.id,                // Product Name
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = distributionChannelObj.id,        // Distribution Channel
            Pack_Size__c = 0.00,                                // Pack Size
            Division__c = divisionObj.id,                    // Division
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Multiple_of__c = 200.00,                            // Multiple Of
            Combination_Key__c = '56311010000000000006301278',  // Combination Key
            Active__c = true,                                   // Active
            Brand_Name__c = 'AZULOX  200 LTS'                  // Brand Name
        );
        insert sku1;         

        Sales_Order_Line_Item__c salesOrderLineItemObj2 = new Sales_Order_Line_Item__c(
            UOM__c = 'L',                            // UOM
            Sale_Order__c = salesOrderobj.Id,         // Sale Order
            SKU_Name__c = sku1.Id,                      // SKU Name
            DepotDepot__c = dp.Id,                   // Depot
            Item_Number__c = 10,                       // Item Number
            Item_Status__c = 'Active',                 // Item Status
            Item_Cancel__c = false,                    // Item Cancel
            Order_Item_Key__c = '1413310',             // OrderNumber_Item_Key
            BudgetPrice__c = 6.00,                     // Budget Price
            MinPrice__c = 5.85,                        // Min Price
            MaxPrice__c = 7.20,                        // Max Price
            Net_Price__c = 6.00,                       // Net Price
            OrderQuantityEdited__c = false,            // Order Quantity Edited
            multipleOf__c = 200,                       // multipleOf
            Quantity__c = 1200.00,                     // Quantity
            Price__c = 4800.00,                        // Value
            DistributorDiscountPercentage__c = 44.44  // Distributor Discount (%)
        );
        insert salesOrderLineItemObj2;  
        
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Argentina'; 
        logCountryObj.For_Contry__c ='Argentina';
        logCountryObj.Sales_Org_Code__c ='5631';
        insert logCountryObj;
        
        Admin_MPT_Colombia__c adminMPT = new Admin_MPT_Colombia__c();
        adminMPT.Active__c = true;
        adminMPT.Approval_Level__c = 'Level 2';
        adminMPT.Sales_Org__c = salesOrgObj.Id;
        adminMPT.Level_3_below__c = 15;
        adminMPT.Level_2_min__c = 15.01;    
        adminMPT.Level_2_max__c = 20.00;
        adminMPT.Level_1_min__c = 20.01;
        adminMPT.Level_1_max__c = 30.00;
        insert adminMPT;
        
        Blanket_SKU__c bSKU = new Blanket_SKU__c();
        bSKU.SKU__c= sku.id;
        bSKU.Sales_Org__c = salesOrgObj.Id;
        bSKU.Start_Date__c = System.today();   
        bSKU.End_Date__c = System.today();
        bSKU.Status__c = false;
        insert bSKU;  
        
        Profit_Center__c pc = new Profit_Center__c();
        pc.Sales_Org__c = salesOrgObj.Id;
        pc.Profit_Center__c = 'P0000';
        pc.Sales_Value__c = 3;
        insert pc;
        
        
        Price_Block_Margin_Matrix__c e2eCost = new Price_Block_Margin_Matrix__c();
        e2eCost.E2E_Cost_USD__c = 2;
        e2eCost.Type__c = 'E2ECost';
        e2eCost.Profit_Center__c = pc.Id;
        e2eCost.UOM__c = 'KG';
        e2eCost.Start_Date__c = System.today();
        e2eCost.End_Date__c = System.today().addDays(5);
        e2eCost.Depot_Code__c = dp.Id;
        e2eCost.Sales_Org__c = salesOrgObj.Id;
        e2eCost.SKU_Code__c = sku.id;
        e2eCost.CurrencyIsoCode = 'USD';
        insert e2eCost;
        
        Price_Block_Margin_Matrix__c e2eUPC9 = new Price_Block_Margin_Matrix__c();
        e2eUPC9.E2E_Cost_UPC9_USD__c = 2;
        e2eUPC9.Type__c = 'E2ECostUPC9';
        e2eUPC9.Profit_Center__c = pc.Id;
        e2eUPC9.UOM__c = 'KG';
        e2eUPC9.Start_Date__c = System.today();
        e2eUPC9.End_Date__c = System.today().addDays(5);
        e2eUPC9.Depot_Code__c = dp.Id;
        e2eUPC9.Sales_Org__c = salesOrgObj.Id;
        e2eUPC9.SKU_Code__c = sku.id;
        e2eUPC9.CurrencyIsoCode = 'USD';
        insert e2eUPC9;
        
        Price_Block_Margin_Matrix__c e2eMBEW = new Price_Block_Margin_Matrix__c();
        e2eMBEW.E2E_Cost_MBEW_USD__c = 2;
        e2eMBEW.Type__c = 'E2ECostMBEW';
        e2eMBEW.Profit_Center__c = pc.Id;
        e2eMBEW.UOM__c = 'KG';
        e2eMBEW.Start_Date__c = System.today();
        e2eMBEW.End_Date__c = System.today().addDays(5);
        e2eMBEW.Depot_Code__c = dp.Id;
        e2eMBEW.Sales_Org__c = salesOrgObj.Id;
        e2eMBEW.SKU_Code__c = sku.id;
        e2eMBEW.CurrencyIsoCode = 'USD';
        insert e2eMBEW;
        
        UOM_Conversion__c uom = new UOM_Conversion__c();
        uom.Base_UOM__c = 'KG';
        uom.Sales_UOM__c = 'KG';
        uom.Numerator__c = 1;
        uom.Denominator__c = 1;
        uom.Sales_Org__c = salesOrgObj.Id;
        uom.SKU__c = sku.id;
        insert uom;
        
        Price_Block_Margin_Matrix__c rebate1 = new Price_Block_Margin_Matrix__c();
        rebate1.Rebate_USD__c = 2;
        rebate1.Type__c = 'Rebate';
        rebate1.Profit_Center__c = pc.Id;
        rebate1.UOM__c = 'KG';
        rebate1.Start_Date__c = System.today();
        rebate1.End_Date__c = System.today().addDays(5);
        rebate1.Depot_Code__c = dp.Id;
        rebate1.Sales_Org__c = salesOrgObj.Id;
        rebate1.SKU_Code__c = sku.id;
        rebate1.CurrencyIsoCode = 'USD';
        rebate1.Distributor_Code__c = accObj.Id;
        rebate1.Rebate_Code__c = '12345';
        insert rebate1;
        
        Price_Block_Margin_Matrix__c rebate2 = new Price_Block_Margin_Matrix__c();
        rebate2.Rebate_USD__c = 2;
        rebate2.Type__c = 'Rebate';
        rebate2.Profit_Center__c = pc.Id;
        rebate2.UOM__c = 'KG';
        rebate2.Start_Date__c = System.today();
        rebate2.End_Date__c = System.today().addDays(5);
        rebate2.Depot_Code__c = dp.Id;
        rebate2.Sales_Org__c = salesOrgObj.Id;
        rebate2.SKU_Code__c = sku.id;
        rebate2.CurrencyIsoCode = 'USD';
        rebate2.Distributor_Code__c = accObj.Id;
        rebate2.Rebate_Code__c = '12346';
        insert rebate2;
        
        Price_Block_Margin_Matrix__c discount = new Price_Block_Margin_Matrix__c();
        discount.Discount_USD__c = 2;
        discount.Type__c = 'Discount';
        discount.Profit_Center__c = pc.Id;
        discount.UOM__c = 'KG';
        discount.Start_Date__c = System.today();
        discount.End_Date__c = System.today().addDays(5);
        discount.Depot_Code__c = dp.Id;
        discount.Sales_Org__c = salesOrgObj.Id;
        discount.SKU_Code__c = sku.id;
        discount.CurrencyIsoCode = 'USD';
        discount.Distributor_Code__c = accObj.Id;
        insert discount;
        
        Price_Block_Margin_Matrix__c addDiscount = new Price_Block_Margin_Matrix__c();
        addDiscount.Additional_Discount_USD__c = 2;
        addDiscount.Type__c = 'AdditionalDiscount';
        addDiscount.Profit_Center__c = pc.Id;
        addDiscount.UOM__c = 'KG';
        addDiscount.Start_Date__c = System.today();
        addDiscount.End_Date__c = System.today().addDays(5);
        addDiscount.Depot_Code__c = dp.Id;
        addDiscount.Sales_Org__c = salesOrgObj.Id;
        addDiscount.SKU_Code__c = sku.id;
        addDiscount.CurrencyIsoCode = 'USD';
        addDiscount.Distributor_Code__c = accObj.Id;
        insert addDiscount;
        
        Price_Block_Margin_Matrix__c salesDeduction = new Price_Block_Margin_Matrix__c();
        salesDeduction.Sales_Deduction_USD__c = 2;
        salesDeduction.Type__c = 'SalesDeduction';
        salesDeduction.Profit_Center__c = pc.Id;
        salesDeduction.UOM__c = 'KG';
        salesDeduction.Start_Date__c = System.today();
        salesDeduction.End_Date__c = System.today().addDays(5);
        salesDeduction.Depot_Code__c = dp.Id;
        salesDeduction.Sales_Org__c = salesOrgObj.Id;
        salesDeduction.SKU_Code__c = sku.id;
        salesDeduction.CurrencyIsoCode = 'USD';
        insert salesDeduction;
        
        Price_Block_Margin_Matrix__c pln = new Price_Block_Margin_Matrix__c();
        pln.PLN_USD__c = 2;
        pln.Type__c = 'PLN';
        pln.Profit_Center__c = pc.Id;
        pln.UOM__c = 'KG';
        pln.Start_Date__c = System.today();
        pln.End_Date__c = System.today().addDays(5);
        pln.Depot_Code__c = dp.Id;
        pln.Sales_Org__c = salesOrgObj.Id;
        pln.SKU_Code__c = sku.id;
        pln.CurrencyIsoCode = 'USD';
        insert pln;
        
        Price_Block_Margin_Matrix__c e2eCost2 = new Price_Block_Margin_Matrix__c();
        e2eCost2.E2E_Cost_USD__c = 2;
        e2eCost2.Type__c = 'E2ECost';
        e2eCost2.Profit_Center__c = pc.Id;
        e2eCost2.UOM__c = 'KG';
        e2eCost2.Start_Date__c = System.today();
        e2eCost2.End_Date__c = System.today().addDays(5);
        e2eCost2.Depot_Code__c = dp.Id;
        e2eCost2.Sales_Org__c = salesOrgObj.Id;
        e2eCost2.SKU_Code__c = sku1.id;
        e2eCost2.CurrencyIsoCode = 'USD';
        insert e2eCost2;
        
        Price_Block_Margin_Matrix__c e2eUPC92 = new Price_Block_Margin_Matrix__c();
        e2eUPC92.E2E_Cost_UPC9_USD__c = 2;
        e2eUPC92.Type__c = 'E2ECostUPC9';
        e2eUPC92.Profit_Center__c = pc.Id;
        e2eUPC92.UOM__c = 'KG';
        e2eUPC92.Start_Date__c = System.today();
        e2eUPC92.End_Date__c = System.today().addDays(5);
        e2eUPC92.Depot_Code__c = dp.Id;
        e2eUPC92.Sales_Org__c = salesOrgObj.Id;
        e2eUPC92.SKU_Code__c = sku1.id;
        e2eUPC92.CurrencyIsoCode = 'USD';
        insert e2eUPC92;
        
        Price_Block_Margin_Matrix__c e2eMBEW2 = new Price_Block_Margin_Matrix__c();
        e2eMBEW2.E2E_Cost_MBEW_USD__c = 2;
        e2eMBEW2.Type__c = 'E2ECostMBEW';
        e2eMBEW2.Profit_Center__c = pc.Id;
        e2eMBEW2.UOM__c = 'KG';
        e2eMBEW2.Start_Date__c = System.today();
        e2eMBEW2.End_Date__c = System.today().addDays(5);
        e2eMBEW2.Depot_Code__c = dp.Id;
        e2eMBEW2.Sales_Org__c = salesOrgObj.Id;
        e2eMBEW2.SKU_Code__c = sku1.id;
        e2eMBEW2.CurrencyIsoCode = 'USD';
        insert e2eMBEW2;
        
        UOM_Conversion__c uom2 = new UOM_Conversion__c();
        uom2.Base_UOM__c = 'KG';
        uom2.Sales_UOM__c = 'KG';
        uom2.Numerator__c = 1;
        uom2.Denominator__c = 1;
        uom2.Sales_Org__c = salesOrgObj.Id;
        uom2.SKU__c = sku1.id;
        insert uom2;
        
        Price_Block_Margin_Matrix__c rebate11 = new Price_Block_Margin_Matrix__c();
        rebate11.Rebate_USD__c = 2;
        rebate11.Type__c = 'Rebate';
        rebate11.Profit_Center__c = pc.Id;
        rebate11.UOM__c = 'KG';
        rebate11.Start_Date__c = System.today();
        rebate11.End_Date__c = System.today().addDays(5);
        rebate11.Depot_Code__c = dp.Id;
        rebate11.Sales_Org__c = salesOrgObj.Id;
        rebate11.SKU_Code__c = sku1.id;
        rebate11.CurrencyIsoCode = 'USD';
        rebate11.Distributor_Code__c = accObj.Id;
        rebate11.Rebate_Code__c = '12345';
        insert rebate11;
        
        Price_Block_Margin_Matrix__c rebate12 = new Price_Block_Margin_Matrix__c();
        rebate12.Rebate_USD__c = 2;
        rebate12.Type__c = 'Rebate';
        rebate12.Profit_Center__c = pc.Id;
        rebate12.UOM__c = 'KG';
        rebate12.Start_Date__c = System.today();
        rebate12.End_Date__c = System.today().addDays(5);
        rebate12.Depot_Code__c = dp.Id;
        rebate12.Sales_Org__c = salesOrgObj.Id;
        rebate12.SKU_Code__c = sku1.id;
        rebate12.CurrencyIsoCode = 'USD';
        rebate12.Distributor_Code__c = accObj.Id;
        rebate12.Rebate_Code__c = '12346';
        insert rebate12;
        
        Price_Block_Margin_Matrix__c discount1 = new Price_Block_Margin_Matrix__c();
        discount1.Discount_USD__c = 2;
        discount1.Type__c = 'Discount';
        discount1.Profit_Center__c = pc.Id;
        discount1.UOM__c = 'KG';
        discount1.Start_Date__c = System.today();
        discount1.End_Date__c = System.today().addDays(5);
        discount1.Depot_Code__c = dp.Id;
        discount1.Sales_Org__c = salesOrgObj.Id;
        discount1.SKU_Code__c = sku1.id;
        discount1.CurrencyIsoCode = 'USD';
        discount1.Distributor_Code__c = accObj.Id;
        insert discount1;
        
        Price_Block_Margin_Matrix__c addDiscount1 = new Price_Block_Margin_Matrix__c();
        addDiscount1.Additional_Discount_USD__c = 2;
        addDiscount1.Type__c = 'AdditionalDiscount';
        addDiscount1.Profit_Center__c = pc.Id;
        addDiscount1.UOM__c = 'KG';
        addDiscount1.Start_Date__c = System.today();
        addDiscount1.End_Date__c = System.today().addDays(5);
        addDiscount1.Depot_Code__c = dp.Id;
        addDiscount1.Sales_Org__c = salesOrgObj.Id;
        addDiscount1.SKU_Code__c = sku1.id;
        addDiscount1.CurrencyIsoCode = 'USD';
        addDiscount1.Distributor_Code__c = accObj.Id;
        insert addDiscount1;
        
        Price_Block_Margin_Matrix__c salesDeduction1 = new Price_Block_Margin_Matrix__c();
        salesDeduction1.Sales_Deduction_USD__c = 2;
        salesDeduction1.Type__c = 'SalesDeduction';
        salesDeduction1.Profit_Center__c = pc.Id;
        salesDeduction1.UOM__c = 'KG';
        salesDeduction1.Start_Date__c = System.today();
        salesDeduction1.End_Date__c = System.today().addDays(5);
        salesDeduction1.Depot_Code__c = dp.Id;
        salesDeduction1.Sales_Org__c = salesOrgObj.Id;
        salesDeduction1.SKU_Code__c = sku1.id;
        salesDeduction1.CurrencyIsoCode = 'USD';
        insert salesDeduction1;
        
        Price_Block_Margin_Matrix__c pln1 = new Price_Block_Margin_Matrix__c();
        pln1.PLN_USD__c = 2;
        pln1.Type__c = 'PLN';
        pln1.Profit_Center__c = pc.Id;
        pln1.UOM__c = 'KG';
        pln1.Start_Date__c = System.today();
        pln1.End_Date__c = System.today().addDays(5);
        pln1.Depot_Code__c = dp.Id;
        pln1.Sales_Org__c = salesOrgObj.Id;
        pln1.SKU_Code__c = sku1.id;
        pln1.CurrencyIsoCode = 'USD';
        insert pln1;
    }
    
           
    
   static testMethod void method1() {
        Account accObj = [Select id From Account LIMIT 1];
        Sales_Order__c soObj = new Sales_Order__c();
        Sales_Order__c salesOrderObj =[select id from Sales_Order__c LIMIT 1];
        Shipping_Location__c shippingLocationObj =[select Id,City__c from Shipping_Location__c LIMIT 1];
        Sku__c sku = [Select id From Sku__c LIMIT 1 ];
        Sku__c sku1 = [Select id From Sku__c LIMIT 1 ];
        Depot__c dp=[select id From Depot__c LIMIT 1];
        Contact sobj1 =[select id from Contact LIMIT 1];
        Price_Group_Master__c priceGroupObj = [select id from Price_Group_Master__c LIMIT 1] ;
        Order_Type__c orderTypeObj = [select id from Order_Type__c LIMIT 1];
        Payment_Method__c paymentMethodObj = [select id from Payment_Method__c LIMIT 1];
        Payment_Term__c paymentTermObj = [select id from Payment_Term__c LIMIT 1];
        
      
        PageReference pageRef = Page.NewOrderArgentina;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',accObj.id);
        pageRef.getParameters().put('soid',salesOrderObj.id);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(salesOrderObj);
        NewOrderArgentinaController ordmanage = new NewOrderArgentinaController(sc);
                
        ordmanage.country = 'Argentina';
        ordmanage.PO = '23423';
        Test.startTest();
        ordmanage.editSalesOrderId=salesOrderObj.Id;
        ordmanage.accountId= accObj.Id;
        ordmanage.depoId=dp.id;
        ordmanage.skuIdChosen = sku.Id;
        ordmanage.fetchDistributorDetails();
        ordmanage.showOrderHistory();
        ordmanage.refreshSaleOrderValue();
       	//ordmanage.skuIdChosen = sku.Id;
        ordmanage.refreshSaleOrderValue();
        //ordmanage.skuIdChosen = sku1.Id;
        ordmanage.addToSaleOrderLineItem();
        
        
        
        //class for shipping location
        NewOrderArgentinaController.ShippingLocation shipLocObj = new NewOrderArgentinaController.ShippingLocation();
        shipLocObj.locationId = shippingLocationObj.Id;
        shipLocObj.city = shippingLocationObj.City__c;
        ordmanage.shippingMap.put(shipLocObj.locationId,shipLocObj);
        
        
        ordmanage.updateSKU();
        ordmanage.refreshSaleOrderValue();
        ordmanage.changeDepot();
        ordmanage.changeOrderType();
        ordmanage.selectedOrderType = 'Consignatario';
       // ordmanage.changePayment();
        ordmanage.changePaymentMethod();
        ordmanage.selectedPayment = paymentMethodObj.Id;
        ordmanage.changePaymentTerm();
       	ordmanage.changePayment();
        ordmanage.paymentTermCode =paymentTermObj.Id ;
        ordmanage.changeOrderType();
        ordmanage.selectedOrderType = orderTypeObj.Id;
        ordmanage.changeCustomerApprovalStatus();
        ordmanage.selectedCustmorApprovalStatus ='Rejected';
        ordmanage.selectedRejectReason = 'Price';
       // ordmanage.confirmSalesOrder();
       // ordmanage.flag = true; 
        //ordmanage.selectedPayment =null;
       // ordmanage.confirmSalesOrder();
        //paymentTermCode
       // ordmanage.paymentTermCode =null;
       // ordmanage.confirmSalesOrder();
       // ordmanage.selectedOrderType = null;
       // ordmanage.confirmSalesOrder();
       // ordmanage.selectedShipping = null;
       // ordmanage.confirmSalesOrder();
       // ordmanage.selectedCustmorApprovalStatus= null;
       // ordmanage.confirmSalesOrder();
       // ordmanage.paymentTermCode = null;
        //ordmanage.confirmSalesOrder();
       // ordmanage.selectedOrderType = null;
       // ordmanage.confirmSalesOrder();
      //  ordmanage.pdfFlag = true; 
        ordmanage.confirmSalesOrder();       
        ordmanage.redirectFunctionAfterEdit();
        test.stoptest();
       }
    
}