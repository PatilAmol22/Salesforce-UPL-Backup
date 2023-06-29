@isTest
public class PriceBookCheckTest {
@testSetup
    static void allTheDataForThisTestClass() {
        
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
        
        
        //Data for Account 2
        Account accObj = new Account(
            Name = 'BAM S.A.',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'BAM S.A.',                                         // Last Name
            SAP_Code__c = '0001023194',                                        // SAP Customer Code
            Mobile__c = '1234567980',                                          // Mobile
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
            PriceGroupCode__c =priceGroupMasterObj.Id,                          // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj;
        
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
    }
    static testMethod void method(){
        Account acnt=[Select id from Account Limit 1];
        ApexPages.StandardController apSC=new ApexPages.StandardController(acnt);
        new PriceBookCheck(apSC);
    }
}