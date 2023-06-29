/* Name : Batch_Order_Status_Italy_TestClass
* Covergae Class : BCH_Liquidation_FieldUpdate
* Created By: Varun Shrivastava
* Created Date: 29 April 2021
* Ticket: SCTASK0419590
*/
@isTest(seeAllData=False)
private class TST_BCH_Liquidation_FieldUpdate {
    @Testsetup
    static void setupTestData(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        User superUser = [ select Id from User where Id = :UserInfo.getUserId()];
        System.runAs ( superUser ){
            User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                MobilePhone = '9748694980'
                //  UserRoleId =  ur.Id
            );  
            insert u;
            User u1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
                LastName = 'last',
                Email = 'puser0002@amamama.com',
                Username = 'puser0002@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                MobilePhone = '9748694980'
                //  UserRoleId =  ur2.Id
            );  
            insert u1;
            User u2 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name = 'SBU Profile'].Id,
                LastName = 'last',
                Email = 'puser003@amamama.com',
                Username = 'puser0003@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                MobilePhone = '9748694980'
                // UserRoleId =  ur3.Id
            );  
            insert u2;
            User u3 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
                LastName = 'last',
                Email = 'puser004@amamama.com',
                Username = 'puser0004@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                MobilePhone = '9748694980'
                //UserRoleId =  ur4.Id
            );  
            insert u3;
            
            Territory_Distributor__c territoryObj;
            Sales_Org__c salesOrgObj;
            Product2 ProductObj;
            Liquidation_Annual_Plan__c liqannlPlnObj;
            Opening_Inventory2__c openInveObj;
            Liquidation2__c sobj;
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
            SBUUser__c = u3.Id, // SBU User
            SBUCode__c = 'SBU2',              // SBU Code
            SalesOrg__c = salesOrgObj.id  // Sales Org
        );
        insert SBUObj;
        
        Zone__c zoneObj = new Zone__c(
            Name = 'Indore',                 // Zone Name
            SalesOrg__c = salesOrgObj.Id,   // Sales Org
            ZoneCode__c = 'Z16',               // Zone Code
            ZonalHead__c = u2.Id,  // Zonal Head
            SBUCode__c = SBUObj.Id    // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            RegionHead__c = u1.id,     // Region Head
            Zone__c = zoneObj.id
            
        );
        insert regionObj;
        
        
        territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Narayangaon';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Region__c = regionObj.id;
        territoryObj.TerritoryManager__c = u.Id;
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
        }
    }
    
    static testMethod void checkCoverage(){
        Test.startTest();
        Database.executeBatch(new BCH_Liquidation_FieldUpdate(),1);
        Test.stopTest();
    }
}