@isTest(seeAlldata=false)
public class CropLiquidationDeleteInvocableTest {
    @isTest
    static void CropLiquidationDeleteInvocableTestMain(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        Liquidation2__c sobj2;
        List<Liquidation2__c> dempLiqMap = new List<Liquidation2__c>();
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1210',    // Company Code
            Sales_Org_Code__c = '1210'  // Sales Org Code
        );
        insert salesOrgObj;
        
        Country__c countryObj = new Country__c(
            Name = 'India',      // Country Name
            Country_Id__c = '91'  // Country Id
        );
        insert countryObj;
        
        State__c stateObj = new State__c(
            Name = 'Uttar Pradesh',                // State Name
            State_Code__c = '9',                     // State Code
            Country__c = 'India',                    // Country
            Active__c = true,                        // Active
            State_Code_Census__c = '9',              // State Code Census
            State_Name_Census__c = 'UTTAR PRADESH',  // State Name Census
            Country_Akc__c = countryObj.id      // Country
        );
        insert stateObj;
        
        SBU__c SBUObj = new SBU__c(
            SBUUser__c = UserInfo.getUserId(), // SBU User
            SBUCode__c = 'SBU2',              // SBU Code
            SalesOrg__c = salesOrgObj.id  // Sales Org
        );
        insert SBUObj;
        
        Zone__c zoneObj = new Zone__c(
            Name = 'Indore',                 // Zone Name
            SalesOrg__c = salesOrgObj.Id,   // Sales Org
            ZoneCode__c = 'Z16',               // Zone Code
            ZonalHead__c = UserInfo.getUserId(),  // Zonal Head
            SBUCode__c = SBUObj.Id    // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            RegionHead__c = UserInfo.getUserId(),     // Region Head
            Zone__c = zoneObj.id
            
        );
        insert regionObj;
        
        
        territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Narayangaon';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Region__c = regionObj.id;
        territoryObj.TerritoryManager__c = UserInfo.getUserId();
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.SBU__c = SBUObj.Id;
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Present_in_KEDE__c = true ;
        territoryObj.Neglected__c = false;
        
        insert territoryObj;
        
        
        ProductObj = new Product2(
            Name = '2,4 D SODIUM SALT',          // Product Name
            ProductCode = '71450',                 // Product Code
            Product_Code__c = '71450',             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '7145010002010',  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 50.00                 // Budget NRV
        );
        insert ProductObj;    
        
        Test.startTest();
        liqannlPlnObj = new Liquidation_Annual_Plan__c(
            Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
            FIscal_Year__c = '2020-2021',                     // FIscal Year
            Fiscal_End_Date__c = Date.newInstance(2021,03, 31),   // Fiscal End Date
            SentToBatch__c = false,                           // Sent To Batch
            Territory_Name__c = territoryObj.Id,                            // State
            RecordTypeId = rtforAnnualPlan,
            Sales_Org__c = salesOrgObj.id
        );
        insert liqannlPlnObj;
        System.debug('liqannlPlnObj test '+liqannlPlnObj.Sales_Org__r.Sales_Org_Code__c);
        
        openInveObj = new Opening_Inventory2__c(
            Product__c = ProductObj.Id,                // Product
            Opening_Inventory__c = 0,                        // Opening Inventory
            Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
            X15_days_lock__c = false, 
            Territory__c = territoryObj.Id,                    // State
            YTD_Sales__c = 0 ,                               // YTD Sales
            RecordTypeId = rtforOpeningInventory
        );
        insert openInveObj;
        
        openInveObj = new Opening_Inventory2__c(
            Product__c = ProductObj.Id,                // Product
            Opening_Inventory__c = 0,                        // Opening Inventory
            Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
            X15_days_lock__c = true, 
            Territory__c = territoryObj.Id,                    // State
            YTD_Sales__c = 0 ,                               // YTD Sales
            RecordTypeId = rtforOpeningInventory
        );
        insert openInveObj;
        
        sobj = new Liquidation2__c(
            Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
            Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
            Product__c = ProductObj.Id,                  // Product
            Type__c = 'Trade',                                // Type
            Month__c = 'May',                               // Month
            Liquidation__c = 0,                              // Liquidation
            Plan_for_the_month__c = 0,                       // Plan for the month
            Retailers_Inventory__c = 0,                      // Retailers Inventory
            Distributors_Inventory__c = 0,                   // Distributors Inventory
            Plan_for_the_next_month__c = 0,                  // Plan for the next month
            Territory__c = territoryObj.Id,                           // State
            RecordTypeId = rtforLiquidation,
            submitted_Trade_SWAL__c =true
        );
        insert sobj;
        dempLiqMap.add(sobj);
        
        sobj2 = new Liquidation2__c(
            Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
            Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
            Product__c = ProductObj.Id,                  // Product
            Type__c = 'Trade',                                // Type
            Month__c = 'May',                               // Month
            Liquidation__c = 0,                              // Liquidation
            Plan_for_the_month__c = 0,                       // Plan for the month
            Retailers_Inventory__c = 0,                      // Retailers Inventory
            Distributors_Inventory__c = 0,                   // Distributors Inventory
            Plan_for_the_next_month__c = 0,                  // Plan for the next month
            Territory__c = territoryObj.Id,                           // State
            RecordTypeId = rtforLiquidation,
            submitted_Trade_SWAL__c =true
        );
        insert sobj2;
        dempLiqMap.add(sobj);
        
        Crop__c crpObj = new Crop__c(
            Name = 'Cereals',                     // Crop Name
            Crop_Code__c = 'CL001',                 // Crop Code
            Active__c = true,                       // Active
            SalesOrg__c = salesOrgObj.Id,        // Sales Org
            Type__c = 'Category',                   // Type
            Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
        );
        insert crpObj;
        
        Crop__c crpObj2 = new Crop__c(
            Name = 'Oilseeds',                    // Crop Name
            Crop_Code__c = 'OL003',                 // Crop Code
            Active__c = true,                       // Active
            SalesOrg__c = salesOrgObj.Id,        // Sales Org
            Type__c = 'Category',                   // Type
            Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
        );
        insert crpObj2;            
        
        Crop_Liquidation__c crpLiqObj1 = new Crop_Liquidation__c(
            Crop__c = crpObj.Id,            // Crop
            Liquidation__c = sobj.Id ,       // Liquidation
            Sales_Org__c = salesOrgObj.Id,         // Sales Org
            Liquidation_Value__c = 9.00,            // Liquidation Value
            is_Crop_Liquidation_Submitted__c = true,  // is Crop Liquidation Submitted
            Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
        );
        insert crpLiqObj1;
        
        Crop_Liquidation__c crpLiqObj2 = new Crop_Liquidation__c(
            Crop__c = crpObj2.Id,            // Crop
            Liquidation__c = sobj.Id,       // Liquidation
            Sales_Org__c = salesOrgObj.Id,         // Sales Org
            Liquidation_Value__c = 1000.00,        // Liquidation Value
            is_Crop_Liquidation_Submitted__c = true,  // is Crop Liquidation Submitted
            Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
        );
        insert crpLiqObj2;
        
        //Added by Varun Shrivastava Start
        Sub_Crops__c subCrop1  = new Sub_Crops__c();
        subCrop1.Name = 'Maize';
        subCrop1.Crop__c = crpObj.ID;
        subCrop1.Sales_Org__c = salesOrgObj.Id;
        insert subCrop1;
        
        Sub_Crops__c subCrop2  = new Sub_Crops__c();
        subCrop2.Name = 'Groundnut';
        subCrop2.Crop__c = crpObj2.ID;
        subCrop2.Sales_Org__c = salesOrgObj.Id;
        insert subCrop2;
        
        Sub_Crop_Liquidation__c	subCropLiquidation = new Sub_Crop_Liquidation__c();
        subCropLiquidation.Crop_Liquidation__c = crpLiqObj1.Id;
        subCropLiquidation.Is_Sub_Crop_Liquidation_Submitted__c=false;
        subCropLiquidation.Sales_Org__c= salesOrgObj.Id;
        subCropLiquidation.Sub_Crop_Liquidation_Value__c=10;	
        subCropLiquidation.Sub_Crops__c=subCrop1.ID;
        subCropLiquidation.Liquidation__c=sobj.Id;
        insert subCropLiquidation;
        
        Sub_Crop_Liquidation__c	subCropLiquidation2 = new Sub_Crop_Liquidation__c();
        subCropLiquidation2.Crop_Liquidation__c = crpLiqObj2.Id;
        subCropLiquidation2.Is_Sub_Crop_Liquidation_Submitted__c=false;
        subCropLiquidation2.Sales_Org__c= salesOrgObj.Id;
        subCropLiquidation2.Sub_Crop_Liquidation_Value__c=20;	
        subCropLiquidation2.Sub_Crops__c=subCrop2.ID;
        subCropLiquidation2.Liquidation__c=sobj.Id;
        insert subCropLiquidation2;
        
        
        CropLiquidationDeleteInvocable ob = new CropLiquidationDeleteInvocable();
        CropLiquidationDeleteInvocable.CropLiquidationDelete(dempLiqMap);
        
    }
}