@isTest
public class ProductTriggertest {
    @isTest
    static void testupdatePermission(){
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Sales_Org__c salesOrgObj;
        Opening_Inventory2__c openInveObj;
        Territory_Distributor__c territoryObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Product2 ProductObj;
        salesOrgObj = new Sales_Org__c(
            Name = 'Swal',            // Sales Org Name
            Description__c = 'SWAL',    // Description
            Company_Code__c = '1210',    // Company Code
            Sales_Org_Code__c = '1210'  // Sales Org Code
        );
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
                //SBUUser__c = u3.Id, // SBU User
                SBUCode__c = 'SBU2',              // SBU Code
                SalesOrg__c = salesOrgObj.id  // Sales Org
            );
            insert SBUObj;
            
            Zone__c zoneObj = new Zone__c(
                Name = 'Indore',                 // Zone Name
                SalesOrg__c = salesOrgObj.Id,   // Sales Org
                ZoneCode__c = 'Z16',               // Zone Code
                //ZonalHead__c = u2.Id,  // Zonal Head
                SBUCode__c = SBUObj.Id    // SBU Code
            );
            insert zoneObj;
            
            
            
            Region__c regionObj = new Region__c(
                Name = 'TRIANGULO',                  // Region Name
                RegionCode__c = 'BR4003',              // Region Code
                SalesOrg__c =salesOrgObj.id,       // Sales Org
                //RegionHead__c = u1.id,     // Region Head
                Zone__c = zoneObj.id
                
            );
            insert regionObj;
        territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Narayangaon';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Region__c = regionObj.id;
        //territoryObj.TerritoryManager__c = u.Id;
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.SBU__c = SBUObj.Id;
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Present_in_KEDE__c = true ;
        territoryObj.Neglected__c = false;
        
        insert territoryObj;
        liqannlPlnObj = new Liquidation_Annual_Plan__c(
            Fiscal_Start_Date__c = Date.newInstance(2022, 04, 01),// Fiscal Start Date
            FIscal_Year__c = '2022-2023',                     // FIscal Year
            Fiscal_End_Date__c = Date.newInstance(2023,03, 31),   // Fiscal End Date
            SentToBatch__c = false,                           // Sent To Batch
            Territory_Name__c = territoryObj.Id,                            // State
            RecordTypeId = rtforAnnualPlan,
            Sales_Org__c = salesOrgObj.id
        );
        insert liqannlPlnObj;
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
            Active_For_Liquidation__c = false,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 50.00                 // Budget NRV
        );
         insert ProductObj; 
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
        ProductObj.Active_For_Liquidation__c = true;
        update ProductObj;
        
    }
    
    @isTest
    static void testupdatePermission1(){
        
         Sales_Org__c salesOrgObj;
        
          salesOrgObj = new Sales_Org__c(
            Name = 'Swal',            // Sales Org Name
            Description__c = 'SWAL',    // Description
            Company_Code__c = '1210',    // Company Code
            Sales_Org_Code__c = '1210'  // Sales Org Code
        );
        insert salesOrgObj;
        
        product2 pro = new product2();
        pro.name = 'test';
        pro.Combination_Key__c = '12345678';
        pro.Sales_Org__c = salesOrgObj.id;
        insert pro;
    }
}