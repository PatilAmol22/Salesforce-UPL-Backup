/*
Name: Vishal Pawar
Email : vishal.pawar@skinternational.com*/



@isTest
public class GeneratePDFForItaly_Test {
    @testSetup
    static void allTheDataForThisTestClass() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Argentina',        // Sales Org Name
            Sales_Org_Code__c = '5631'  // Sales Org Code
        );
        insert salesOrgObj;
        
        
        
        Payment_Method__c paymentMethodObj = new Payment_Method__c(
            Name = 'Available Barter',       // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'AB1',    // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodObj;
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = '30 days',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Maturity_Date_Mandatory__c = 'Yes',                  // Maturity Date Mandatory
            Sales_Org__c = salesOrgObj.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        Order_Type__c orderTypeObj = new Order_Type__c(
            Name = 'ZXOR',                  // Order Type Name
            Description__c = 'Credit',        // Description
            Order_Type_Code__c = 'ZXOR',      // Order Type Code
            SalesOrg__c = salesOrgObj.Id  // Sales Org
        );
        insert orderTypeObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        Distribution_Channel__c distributionChannelObj = new Distribution_Channel__c(
            Name = 'Direct',                    // Distribution Channel Name
            Distribution_Channel_Code__c = '10'  // Distribution Channel Code
        );
        insert distributionChannelObj;
        
        
        Account accontObj = new Account();
        accontObj.Name='Bhavik Devdhar';
        accontObj.Last_Name__c='Devdhar';
        //accontObj.PriceGroupCode__c=pg.id;
        accontObj.SAP_Code__c='SAP996734';
        accontObj.RecordTypeId=devRecordTypeId;
        accontObj.Mobile__c='9967341759';
        accontObj.Phone='020256589';
        accontObj.Sales_Org__c=salesOrgObj.id;
        accontObj.Division__c=divisionObj.Id;
        accontObj.Distribution_Channel__c=distributionChannelObj.Id;
        accontObj.BillingCity='Charata';
        //accontObj.Order_Type__c=ordType.Id;
        accontObj.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert accontObj;
        
        
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'ADECO AGROPECUARIA S.A.',// Location Name
            Distributor__c = accontObj.Id,            // Distributor
            SAP_Code__c = '0001013292',                    // SAP Code
            City__c = 'MARTINEZ -PCIA. BUENOS AI',         // City
            State__c = '01',                               // State
            Country__c = 'AR',                             // Country
            Pincode__c = '1640',                           // Pincode
            Sold_To_Party_SAP_Code__c = '0001013292',      // Sold To Party (SAP Code)
            Sales_Org__c = salesOrgObj.Id,              // Sales Org
            Distribution_Channel__c = distributionChannelObj.Id,   // Distribution Channel
            Division__c = divisionObj.Id               // Division
        );
        insert shippingLocationObj;
        
        
        Sales_Order__c salesOrderObj = new Sales_Order__c(
            SFDC_Order_Number__c = '13706',              // SFDC Order Number
            Order_Raise_By__c = 'Territory Manager',       // Order Raised By
            Order_Status__c = 'Open',                   // Order Status
            Order_Cancel__c = false,                       // Order Cancel
            OrderSubStatus__c = 'Draft',                   // Order Sub-Status
            //Order__c = 'a170k000000btTD',                // Order
            Order_Date__c = system.today(),                // Order Date
            ProcessBuilderFlag__c = false,                 // Process Builder Flag
            //Manager__c = '0050k000000rQyO',                // Manager
            PaymentMethod__c = paymentMethodObj.Id,          // Payment Method
            Payment_Term__c = paymentTermObj.Id,           // Payment Term
            Customer_Approval__c = true,                   // Customer Approval
            Order_Type_lk__c = orderTypeObj.Id,          // Order Type
            ArgentinaOrderSubmittedforApproval__c = true,  // Argentina Order Submitted for Approval
            InternalApprovalCheck__c = true,               // Internal Approval Check
            BudgetApprovalCheck__c = true,                 // Budget Approval Check
            Total_Amount__c = 716383.68,                   // Total Amount
            Sold_to_Party__c = accontObj.Id,          // Sold to Party
            Bill_To_Party__c = accontObj.Id,          // Bill To Party
            Ship_To_Party__c = shippingLocationObj.Id,          // Ship To Party
            CreatedFrom__c = 'SFDC'                       // Created From
        );
        insert salesOrderObj;
        
        Product2 productobj = new Product2(
            Name = 'UNIZEB',                    // Product Name
            ProductCode = '2090',                 // Product Code
            Product_Code__c = '2090',             // Product Code
            IsActive = false,                     // Active
            Active__c = false,                    // Active
            Sales_Org__c = salesOrgObj.Id,     // Sales Org
            Combination_Key__c = '209056311010',  // Combination Key
            Popular__c = false,                   // Popular
            Power_Brand__c = false,               // Power Brand
            Active_For_Liquidation__c = false    // Active For Liquidation
        );
        insert productobj;
        
        
        
        SKU__c skuObj = new SKU__c(
            Name = '1 KG',                                    // SKU Name
            SKU_Code__c = '000000000006301687',                 // SKU Code
            Product_Name__c = productobj.Id,                // Product Name
            UOM__c = 'KG',                                      // UOM
            Distribution_Channel__c = distributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                                // Pack Size
            Division__c = divisionObj.Id,                    // Division
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Multiple_of__c = 20.00,                             // Multiple Of
            Combination_Key__c = '56311010000000000006301687',  // Combination Key
            Active__c = true                                   // Active
        );
        insert skuObj;
        
        
        Depot__c depotObj = new Depot__c(
            Name = 'Argentina',             // Depot Name
            Location__c = 'Argentina',        // Location
            Depot_Code__c = 'AR13',           // Depot Code
            SalesOrg__c = salesOrgObj.Id,  // Sales Org
            // RecordType = '0120k000000ChEP',   // Record Type
            Active__c = false                // Active
        );
        insert depotObj;
        
        Sales_Order_Line_Item__c sliObj = new Sales_Order_Line_Item__c(
            UOM__c = 'KG',                           // UOM
            Sale_Order__c = salesOrderObj.Id,         // Sale Order
            SKU_Name__c = skuObj.Id,           // SKU Name
            DepotDepot__c = depotObj.Id,         // Depot
            Item_Number__c = 10,                       // Item Number
            Item_Status__c = 'Active',                 // Item Status
            Item_Cancel__c = false,                    // Item Cancel
            Order_Item_Key__c = '1444610',             // OrderNumber_Item_Key
            BudgetPrice__c = 5.00,                     // Budget Price
            MinPrice__c = 5.20,                        // Min Price
            MaxPrice__c = 7.00,                        // Max Price
            Net_Price__c = 6.00,                       // Net Price
            OrderQuantityEdited__c = false,            // Order Quantity Edited
            multipleOf__c = 20,                        // multipleOf
            Quantity__c = 2400.00,                     // Quantity
            Price__c = 14400.00,                       // Value
            DistributorDiscountPercentage__c = 14.29  // Distributor Discount (%)
        );
        insert sliObj;
        
        
        
        
        
    }
    
    static testMethod void method() {
        Sales_Order__c salesOrderObj= [select id,Name,Sold_to_Party__c From Sales_Order__c LIMIT 1];
        GeneratePDFForItaly controllerObj = new GeneratePDFForItaly();
        GeneratePDFForItaly.ProcessSalesorderForItaly(salesOrderObj.Id);
    }
}