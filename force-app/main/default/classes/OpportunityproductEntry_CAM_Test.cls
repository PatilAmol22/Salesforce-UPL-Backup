/*
Test class for OpportunityproductEntry_CAM_Controller
*/

@isTest
public class OpportunityproductEntry_CAM_Test {
    static testMethod void myUnitTest() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordTypeDepotId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
         Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Costa Rica',        // Sales Org Name
            Sales_Org_Code__c = '5711'  // Sales Org Code
        );
        insert salesOrgObj;
        
         Distribution_Channel__c distributionChannelObj = new Distribution_Channel__c(
            Name = 'Direct',                    // Distribution Channel Name
            Distribution_Channel_Code__c = '20'  // Distribution Channel Code
        );
        insert distributionChannelObj;
        
         //Data for Division
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        Account accObj = new Account(
            Name='Vishal Pawar',
            SAP_Code__c = '0001013292', 
            //PriceGroupCode__c=pg.id,
            RecordTypeId = devRecordTypeId,              // SAP Customer Code
            Last_Name__c = 'ADECO AGROPECUARIA S.A.',     // Last Name
            Order_Block__c = false,                       // Order Block
            Mobile__c = '9405883688',  
            Phone='020256589', // Mobile
            Email__c = 'marcelo.gorla@uniphos.com',       // Email
            Account_Type__c = 'Sold To Party',            // Account Type
            // Raise_Order_Type__c = 'Both',                 // Raise Order Type
            Billing_Street_2__c = 'CATAMARCA 3454',       // Billing Street 2
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            //Division__c = divisionObj.Id,              // Division Name
            // Distribution_Channel__c = distributionChannelObj.Id,  // Distribution Channel
            Depot_Code__c = 'AR13',                       // Depot Code
            Country__c = 'Other'
            //AuthorizationGroupSalesoffice__c ='S091'
        ); 
        insert accObj;
        
        Opportunity oportunidadNueva = new Opportunity();
        oportunidadNueva.Name = 'TEst';
        oportunidadNueva.StageName='Contratada';
        oportunidadNueva.CloseDate=Date.today();
        oportunidadNueva.CurrencyIsoCode='USD';
        oportunidadNueva.AccountId = accObj.Id;
        //oportunidadNueva.Country_of_Origin__c ='India';
        
        insert oportunidadNueva;
        
        Product2 pro = new Product2(
            Name = 'iPhone X', Family = 'Mobile',
            Sales_Org__c = salesOrgObj.id,
            Product_Code__c	='000000000006120028',
            Combination_Key__c ='1234567890fgh',
            Active_for_CAM__c =true,
            Distribution_Channel__c	=distributionChannelObj.Id,
            Division__c =divisionObj.Id
        );
        Insert pro;
        
         //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
         //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
         
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            CurrencyIsoCode = oportunidadNueva.CurrencyIsoCode,
            IsActive = true
        );
        Insert pbe;
        
         //Query the PricebookEntry record
        pbe = [SELECT Id, Pricebook2.IsStandard FROM PricebookEntry];
        //It should return true
        System.assertEquals(true, pbe.Pricebook2.IsStandard);
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=oportunidadNueva.Id, UnitPrice=0.01, PriceBookEntryId=pbe.Id);
        insert OPplineitem2;
        
        Depot__c depotObj = new Depot__c(
            Name = 'CR10',                               // Depot Name
            SalesOrg__c = salesOrgObj.Id,               // Sales Org
            Depot_Code__c = 'CR10',                        // Depot Code
            RecordTypeId = devRecordTypeDepotId,                    // Record Type
            Country__c = 'Costa Rica',                     // Country
            Combination_key_Storage_Location__c = 'CR10',  // Combination key Storage Location
            Active__c = true                              // Active
        );
        insert depotObj;
        
        Distributor_Depot_Mapping__c Distributor_Depot_MappingObj = new Distributor_Depot_Mapping__c(
            Distributor__c = accObj.id,// Distributor
            Depot__c = depotObj.Id        // Depot
        );
        insert Distributor_Depot_MappingObj;
        
        
        
        
        DistributorSalesAreaMapping__c DistributorSalesAreaMappingOBj = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = accObj.Id,          // Distributor
            SalesOrg__c = salesOrgObj.Id,             // Sales Org
            OrderBlock__c = true,                        // Order Block
            DistributionChannel__c = distributionChannelObj.id,  // Distribution Channel
            Division__c = divisionObj.Id,             // Division
            Manually_Created__c = false                 // Manually Created
            //PriceGroupMaster__c = 'a190k000000Ccp7'     // Price Group Master
        );
        insert DistributorSalesAreaMappingOBj;
        
        
        
        SKU__c skuObj = new SKU__c(
            Name = '10 LTR',                                  // SKU Name
            SKU_Code__c = '000000000006120028',                 // SKU Code
            Product_Name__c = pro.Id,                // Product Name
            SKU_Description__c = 'VONDONIL 72 SC - 1lt_TEST',   // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = distributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = divisionObj.Id,                    // Division
            Sales_Org__c = salesOrgObj.id,                   // Sales Org
            Combination_Key__c = '57112010000000000006120028',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'ABACO',                            // Brand Name
            Unit_Cost__c = 2667.23,                             // Unit Cost
            Inventory_Dynamic_Check_Italy__c = false,           // Inventory Dynamic Check
            Active_for_Liquidation__c = false,                  // Active for Liquidation
            For_Japan_Activity__c = false                      // For Japan Activity
        );
        insert skuObj;
        
        PriceBookMaster__c PriceBookMasterObj = new PriceBookMaster__c(
            DistributorCustomerCode__c = accObj.Id,              // Distributor Customer Code
            SKUCode__c = skuObj.Id,                                // SKU Code
            Manager_Price__c = 8.80,                                       // Manager Price / Sales Director Price
            Price__c = 9.68,                                               // Price / Max Price
            DepotCode__c = depotObj.Id,                              // Depot Code
            MinPrice__c = 8.80,                                            // Min Price
            Final_Price__c = 8.80,                                         // Final Price
            StartDate__c = System.today(),                       // Start Date
            EndDate__c = System.today()+1,                        // End Date
            UOM__c = 'L',                                                  // UOM
            Division__c = divisionObj.Id,                               // Division
            DistributionChannel__c = distributionChannelObj.id,                    // Distribution Channel
            Active__c = false,                                             // Active
            PerUnit__c = 1,                                              // Per Unit
            CompositeKey__c = 'CR0057112010000000000006120028',  // CompositeKey
            Sales_Org__c = salesOrgObj.Id,                              // Sales Org
            Price_Book_Change__c = false                                  // Price_Book_Change
            //Customized_Product__c = false                                 // Customized Product
        );
        insert PriceBookMasterObj;
        
        
        
        Stock_Requirement__c stockreqObj = new Stock_Requirement__c(
            SKU__c = skuObj.Id,                       // SKU
            Depot__c = DepotObj.Id,                       // Depot
            Unrestricted_Stock__c = 0,                     // Unrestricted Stock
            Sales_Order_Stock__c = 0,                      // Sales Order Stock
            Delivery_Stock__c = 0,                         // Delivery Stock
            Purchase_Order_Stock__c = 0,                   // Purchase Order Stock
            Stock_In_Transit__c = 0,                       // Stock In Transit
            UOM__c = 'L',                                       // UOM
            Combination_Key__c = '6731000000000005290400JP01',  // Combination Key
            Net_Stock_Italy__c = 0,                        // Net Stock Italy
            Outgoing_Reservations_Italy__c = 0            // Outgoing Reservations Italy
        );
        insert stockreqObj;
        
        
        
        Opportunity oppObj = [select Id, Name From Opportunity LIMIT 1];
        Sales_Org__c SalesOrgObj1 = [SELECT ID,Name FROM Sales_Org__c LIMIT 1]; 
        List<OpportunityLineItem> opplItemList = [SELECT Id, OpportunityId, PricebookEntryId, Product2Id, ProductCode, Name, 
                                                  Quantity, TotalPrice, UnitPrice, ListPrice, 
                                                  ServiceDate, Description,  Sales_Org__c, Pack_Size__c 
                                                  FROM OpportunityLineItem];
        
        PriceBookMaster__c temoObj = [Select id,SKUCombinationKey__c from PriceBookMaster__c LIMIT 1];
        System.debug('temoObj un test class '+temoObj.SKUCombinationKey__c);
        
        
        OpportunityproductEntry_CAM_Controller.fetchSKUValues('searchKeyWord', oppObj.Id);
        OpportunityproductEntry_CAM_Controller.fetchAllOppoLineItem(oppObj.Id);
        OpportunityproductEntry_CAM_Controller.fetchsingleOppoLineItem(opplItemList[0].Id);
        //OpportunityproductEntry_CAM_Controller.searchHelperOnKeyPresPopup('iPhone X', SalesOrgObj1.Id, oppObj.Id);
        System.debug('SalesOrgObj1.Id in test class '+SalesOrgObj1.Id);
        System.debug('SalesOrgObj1.Id in test class '+oppObj.Id);
        //OpportunityproductEntry_CAM_Controller.searchHelperOnKeyPres('iPhone X', SalesOrgObj1.Id, oppObj.Id);
        OpportunityproductEntry_CAM_Controller.saveOpportunityLineItem(opplItemList);
        OpportunityproductEntry_CAM_Controller.updateOpportunityLineItem(opplItemList);
        OpportunityproductEntry_CAM_Controller.deleteOpportunityLineItem(opplItemList[0].Id);
        OpportunityproductEntry_CAM_Controller.fetchPriceBookMasterDetails(pro.Id, oppObj.Id);
        OpportunityproductEntry_CAM_Controller.InventoryShow();
        
        
        
        
    }
}