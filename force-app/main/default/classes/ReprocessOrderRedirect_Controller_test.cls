@isTest(SeeAllData=false)

public class ReprocessOrderRedirect_Controller_test {
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id recordTypeId1 = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId(); 
        Id recordTypeIDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId(); 
        
           
        //Data for Distribution Channel
        Distribution_Channel__c DistributionChanneLObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert DistributionChanneLObj;
      
        
        //Data For Division  
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        //Data for Sales Org 
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert salesOrgObj;
        
        //Data for Payment Term
        Payment_Term__c PaymentTermObj = new Payment_Term__c(
            Payment_Term__c = 'Net 7 days',   // Payment Term
            Payment_Term_Code__c = 'UK01',      // Payment Term Code
            Payterms_Desc__c = 'Net 7 days',    // Payterms Desc
            Sales_Org__c = salesOrgObj.id,   // Sales Org
            Active__c = true,                   // Active
            CombinationKey__c = '5710UK01'     // CombinationKey
        );
        insert PaymentTermObj;
        
        
        //Data For Bill to Party / Account
        Account accObj = new Account(
            Name = 'BAM S.A. [View Hierarchy]',                              // Account Name
            RecordTypeId = devRecordTypeId,                                        // Account Record Type
            Last_Name__c = 'BAM S.A.',                                         // Last Name
            SAP_Code__c = '0001023194',                                        // SAP Customer Code
            Mobile__c = '787878787878',                                        // Mobile
            Order_Block__c = false,                                            // Order Block
            
            Account_Type__c = 'Sold To Party',                                 // Account Type
            
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            
            Division__c = divisionObj.id,                                   // Division Name
            Distribution_Channel__c = DistributionChanneLObj.Id,                       // Distribution Channel
            
          
            Depot_Code__c = 'CO51',                                            // Depot Code
            Payment_Term_Code__c = PaymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK08'                                         // Payment Terms
            
        );
        insert accObj;
        
        //Data for Shipping Location
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'BAM S.A.',                           // Location Name
            SAP_Code__c = '0001023194',                                // SAP Code
            Distributor__c = accObj.Id,                        // Distributor
            City__c = 'BOGOTA DC',                                     // City
            State__c = '11',                                           // State
            Country__c = 'CO',                                         // Country
            Billing_Street_3__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 3
            Pincode__c = '11001',                                      // Pincode
            Sold_To_Party_SAP_Code__c = '0001023194',                  // Sold To Party (SAP Code)
            Combination_Key__c = '00010231940001023194',               // Combination Key
            Country_Name__c = 'Colombia',                              // Country Name
            Sales_Org__c = salesOrgObj.id,                          // Sales Org
            Distribution_Channel__c = distributionChannelObj.id,               // Distribution Channel
            Division__c = divisionObj.Id                           // Division
        );
        insert shippingLocationObj;
        
        
        //Data For Order
        Order__c OrderOBj = new Order__c(
            Order_Date__c =system.today(),			     // Order Date
            Order_Raise_By__c = 'Territory Manager',      // Order Raise By
            Order_Status__c = 'Approved',                 // Order Status
            Price_Entry__c = 'Pre-uploaded',              // Price Entry
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            Distribution_Channel__c = DistributionChanneLObj.id,  // Distribution Channel
            Bill_To_Party__c = accObj.id,         // Bill To Party
            Shipping_Location__c = shippingLocationObj.Id     // Shipping Location
        );
        insert OrderOBj;
        
        //Data for Sale Order
        Sales_Order__c salesOrderObj = new Sales_Order__c(
            RecordTypeId = recordTypeId1,                    // Record Type
            SFDC_Order_Number__c = '87348',                  // SFDC Order Number
            Order_Raise_By__c = 'Territory Manager',         // Order Raised By
            Order__c = OrderOBj.id,                    // Order
            Desc_Punctuality__c = false,                     // Desc Punctuality
            Order_Status__c = 'In Transit',                    // Order Status
            OrderSubStatus__c = 'Draft',                     // Order Sub-Status
            Punctuality_Discount__c = 0.00,                  // Punctuality Discount
            Flag_Status__c = '\n',                           // Flag Status
            Customer_Approval__c = false,                    // Customer Approval
            isOffline_Mobile_Order__c = false,               // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = false,      // Brazil Order Submitted for Approval
            Call_Process_Builder_Flow__c = false,            // Call Process Builder Flow
            Signed__c = false,                               // Signed
            ProcessBuilderFlag__c = false,                   // Process Builder Flag
            RequestforCancellationCheck__c = false,          // Request for Cancellation
            BrazilSalesOrderApproved__c = false,             // Brazil Sales Order Approved
            Key_Account__c = false,                          // Key Account
            ApprovedBySDM__c = false,                        // Approved By SDM
            ApprovedBySOM__c = false,                        // Approved By SOM
            SentEmailIndonesia__c = true,                    // Sent Email Indonesia
            ApprovedByBM__c = false,                         // Approved By BM
            Sales_Org_lk__c = salesOrgObj.id,             // Sales Org
            ApprovedBySOMifSDMisNull__c = false,             // Approved By SOM if SDM is Null
            Division_lk__c = divisionObj.id,              // Division
            Distribution_Channel_lk__c = distributionChannelObj.id,  // Distribution Channel
            Sold_to_Party__c = accObj.Id,            // Sold to Party
            Bill_To_Party__c = accObj.Id,            // Bill To Party
            Ship_To_Party__c = shippingLocationObj.id,            // Ship To Party
            Depot_Code__c = 'CO51'                          // Depot Code
        );
        insert salesOrderObj;
        
        //Data for Depot 
        Depot__c depotObj = new Depot__c(
            Name = 'CO51',                             // Depot Name
            Location__c = 'CO51',                        // Location
            SalesOrg__c = salesOrgObj.id,             // Sales Org
            Depot_Code__c = 'CO51',                      // Depot Code
            RecordTypeId = recordTypeIDepot,                  // Record Type
            Active__c = false                           // Active
        );
        insert depotObj;
        //data for Product
        Product2 productObj = new Product2(
            Name = 'ALPHA CYPER 10% EC',         // Product Name
            Product_Code__c = '65100',             // Product Code
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.id,      // Sales Org
            Combination_Key__c = '6510057106710',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
            
            Budget_NRV__c = 0.00                // Budget NRV
        );
        insert productObj;
        
        //data for SKU 
        SKU__c SKUObj = new SKU__c(
            Name = 'a1C0k000000NAz5',                         // SKU Name
            SKU_Code__c = '000000000006180633',                 // SKU Code
            Product_Name__c = productObj.id,                // Product Name
            SKU_Description__c = 'FURYY 40 EC X 250 cc',        // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = distributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = divisionObj.id,                    // Division
            Sales_Org__c = salesOrgObj.id,                   // Sales Org
            Combination_Key__c = '57106710000000000006180633',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true                                   // Active
        );
        insert SKUObj;
        
        //data for Sales order Line Item
        Sales_Order_Line_Item__c salesOrderLineItemObj = new Sales_Order_Line_Item__c(
            Sale_Order__c = salesOrderObj.id,      // Sales Order
            SKU_Name__c = SKUObj.id,        // SKU Name
            Item_Status__c = 'Active',              // Item Status
            Item_Number__c = 10,                  // Item Number
            DepotDepot__c = depotObj.Id,      // Depot
            UOM__c = 'N/A',                         // UOM
            Net_Price__c = 10.00,                   // Net Price
            MinPrice__c = 10.00,                    // Min Price
            Quantity__c = 25.00,                  // Quantity
            FinalPrice__c = 10.00,                  // Final Price
            Price__c = 250.00                      // Value
        );
        insert salesOrderLineItemObj;
        
 
    }
    
    static testMethod void method() {
        Sales_Order__c Sales_OrderObj = [Select id From Sales_Order__c];
        Sales_Order_Line_Item__c Sales_Order_Line_ItemObj = [Select id From Sales_Order_Line_Item__c WHERE Sale_Order__c =:Sales_OrderObj.id];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Sales_OrderObj);
        
        ReprocessOrderRedirect_Controller ReprocessOrderRedirectObj = new ReprocessOrderRedirect_Controller(sc);
        ReprocessOrderRedirectObj.updateSoLineItem();
        ReprocessOrderRedirectObj.refreshPage();
        
        
    }
    
    
    
}