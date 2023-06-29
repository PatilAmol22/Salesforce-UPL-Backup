@isTest
public class LiquidationSAIB_Test {
    
    @isTest
    static void testupdatePermissionBH(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        
        //Data for  Business Head
        User u;
        User u1;
        User u2;
      
        
        //Country__c countryObj;
        //State__c stateObj;
        SAIB_State_Mapping__c saiBStateMapObj;
        SAIB_State_Mapping__c saiBStateMapObj1;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        
        System.runAs ( thisUser ) {
            UserRole ur = new UserRole(Name = 'Business Development Manager');
            insert ur;
            
            u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Business Head'].Id,
                
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
                UserRoleId =  ur.Id
            );  
            insert u; 
            
            
            UserRole ur1 = new UserRole(Name = 'AF - Business Head India');
            insert ur1;
            u1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Business Head'].Id,
                
                LastName = 'last',
                Email = 'puser1000@amamama.com',
                Username = 'pus1er000@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                UserRoleId =  ur1.Id
            );  
            insert u1; 
            
            
             UserRole ur2 = new UserRole(Name = 'AF - Business Head India');
            insert ur2;
            u2 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'CM Users'].Id,
                
                LastName = 'last',
                Email = 'puser10002@amamama.com',
                Username = 'pus1er0002@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                UserRoleId =  ur2.Id
            );  
            insert u2; 
            
            
            
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
            
            
            
            saiBStateMapObj = new SAIB_State_Mapping__c(
                State__c = stateObj.id,// State
                User__c = u.id,
                SBU_User__c = u1.id
            );
            insert saiBStateMapObj;
            
            salesOrgObj = new Sales_Org__c(
                Name = 'India',            // Sales Org Name
                Description__c = 'India',    // Description
                Company_Code__c = '1000',    // Company Code
                Sales_Org_Code__c = '1000'  // Sales Org Code
            );
            insert salesOrgObj;
            
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
                Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2018-2019',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2019,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                State__c = stateObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj;
            
           
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory_Cooperatives__c = 170000,      // Opening Inventory Cooperatives
                Opening_Inventory__c = 0,                        // Opening Inventory
                Opening_Inventory_Govt__c = 140000,              // Opening Inventory Govt
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                YTD_Sales_Corporate__c = 3000,                   // YTD Sales Corporate
                X15_days_lock__c = false,                        // 15 days lock
                YTD_Sales_Govt__c = 3000,                        // YTD Sales Govt
                State__c = stateObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory_Cooperatives__c = 170000,      // Opening Inventory Cooperatives
                Opening_Inventory__c = 0,                        // Opening Inventory
                Opening_Inventory_Govt__c = 140000,              // Opening Inventory Govt
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                YTD_Sales_Corporate__c = 3000,                   // YTD Sales Corporate
                X15_days_lock__c = false,                        // 15 days lock
                YTD_Sales_Govt__c = 3000,                        // YTD Sales Govt
                State__c = stateObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Sept',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
             sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Sept',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
            
            
             sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Sept',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
            
            
        }
        System.runAs(u){
            Test.startTest();
            LiquidationSAIBController liquidationSAIBControllerObj = new  LiquidationSAIBController();
            
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            
            liquidationSAIBControllerObj.defaultMethod();
            
            liquidationSAIBControllerObj.selectedMonth = 11; 
            liquidationSAIBControllerObj.onMonthChange();
            liquidationSAIBControllerObj.onYearChange();
            liquidationSAIBControllerObj.displayProduct();
            
            
            liquidationSAIBControllerObj.totalLiquidation = 10;
            liquidationSAIBControllerObj.fieldTotupdate = 'Opening_Inventory_Govt__c';
            liquidationSAIBControllerObj.recordIdTotupdate = openInveObj.id;
            liquidationSAIBControllerObj.valueToupdate = '14';
            liquidationSAIBControllerObj.updateSingleRecord();
            
            liquidationSAIBControllerObj.totalLiquidation = 10;
            liquidationSAIBControllerObj.fieldTotupdate = 'Opening_Inventory_Cooperatives__c';
            liquidationSAIBControllerObj.recordIdTotupdate = openInveObj.id;
            liquidationSAIBControllerObj.valueToupdate = '14';
            liquidationSAIBControllerObj.updateSingleRecord();
            
            liquidationSAIBControllerObj.totalLiquidation = 10;
            liquidationSAIBControllerObj.fieldTotupdate = 'Inventory_in_Kg_Govt__c';
            liquidationSAIBControllerObj.recordIdTotupdate = sobj.id;
            liquidationSAIBControllerObj.valueToupdate = '14';
            liquidationSAIBControllerObj.updateSingleRecord();
            
            liquidationSAIBControllerObj.totalLiquidation = 10;
            liquidationSAIBControllerObj.fieldTotupdate = 'Inventory_in_Kg_Cooperatives__c';
            liquidationSAIBControllerObj.recordIdTotupdate = sobj.id;
            liquidationSAIBControllerObj.valueToupdate = '14';
            liquidationSAIBControllerObj.updateSingleRecord();
            liquidationSAIBControllerObj.selectedMonth =10 ;
            liquidationSAIBControllerObj.createDataForSelectedMonth(saiBStateMapObj.Id,sobj.Id);
            liquidationSAIBControllerObj.createData(saiBStateMapObj.Id , sobj.Id,'Oct');
            
            liquidationSAIBControllerObj.loadDataForSelectedMonth(saiBStateMapObj.Id,sobj.Id);
            
            
            
            
            
            
            
            LiquidationSAIBController liquidationSAIBControllerObj1 = new  LiquidationSAIBController();
            
            
            
            liquidationSAIBControllerObj1.defaultMethod();
            liquidationSAIBControllerObj1.totalLiquidation = 10;
            liquidationSAIBControllerObj1.fieldTotupdate = 'Plan_for_the_next_month__c';
            liquidationSAIBControllerObj1.recordIdTotupdate = sobj.id;
            liquidationSAIBControllerObj1.valueToupdate = '14';
            liquidationSAIBControllerObj1.selectMonth = 9;
            liquidationSAIBControllerObj1.Select_Year = '2018-2019';
            liquidationSAIBControllerObj1.prodIdTotupdate = ProductObj.Id;
            liquidationSAIBControllerObj1.updateSingleRecord();
            
            liquidationSAIBControllerObj.updateData();
        }// End of BH
        //Start of BHI
        
        
        
        
        Test.stopTest();   
        
        
    }//end of testupdatePermissionBH
    
     @isTest
    static void testupdatePermissionBH1(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        
        //Data for  Business Head
        User u;
        User u1;
        User u2;
      
        
        //Country__c countryObj;
        //State__c stateObj;
        SAIB_State_Mapping__c saiBStateMapObj;
        SAIB_State_Mapping__c saiBStateMapObj1;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        
        System.runAs ( thisUser ) {
            UserRole ur = new UserRole(Name = 'Business Development Manager');
            insert ur;
            
            u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Business Head'].Id,
                
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
                UserRoleId =  ur.Id
            );  
            insert u; 
            
            
            UserRole ur1 = new UserRole(Name = 'AF - Business Head India');
            insert ur1;
            u1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Business Head'].Id,
                
                LastName = 'last',
                Email = 'puser1000@amamama.com',
                Username = 'pus1er000@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                UserRoleId =  ur1.Id
            );  
            insert u1; 
            
            
             UserRole ur2 = new UserRole(Name = 'AF - Business Head India');
            insert ur2;
            u2 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'CM Users'].Id,
                
                LastName = 'last',
                Email = 'puser10002@amamama.com',
                Username = 'pus1er0002@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                UserRoleId =  ur2.Id
            );  
            insert u2; 
            
            
            
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
            
            
            
            saiBStateMapObj = new SAIB_State_Mapping__c(
                State__c = stateObj.id,// State
                //User__c = u2.id,
                SBU_User__c = u2.id
            );
            insert saiBStateMapObj;
            
            salesOrgObj = new Sales_Org__c(
                Name = 'India',            // Sales Org Name
                Description__c = 'India',    // Description
                Company_Code__c = '1000',    // Company Code
                Sales_Org_Code__c = '1000'  // Sales Org Code
            );
            insert salesOrgObj;
            
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
                Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2018-2019',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2019,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                State__c = stateObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj;
            
           
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory_Cooperatives__c = 170000,      // Opening Inventory Cooperatives
                Opening_Inventory__c = 0,                        // Opening Inventory
                Opening_Inventory_Govt__c = 140000,              // Opening Inventory Govt
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                YTD_Sales_Corporate__c = 3000,                   // YTD Sales Corporate
                X15_days_lock__c = false,                        // 15 days lock
                YTD_Sales_Govt__c = 3000,                        // YTD Sales Govt
                State__c = stateObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory_Cooperatives__c = 170000,      // Opening Inventory Cooperatives
                Opening_Inventory__c = 0,                        // Opening Inventory
                Opening_Inventory_Govt__c = 140000,              // Opening Inventory Govt
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                YTD_Sales_Corporate__c = 3000,                   // YTD Sales Corporate
                X15_days_lock__c = false,                        // 15 days lock
                YTD_Sales_Govt__c = 3000,                        // YTD Sales Govt
                State__c = stateObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Dec',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
             sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Dec',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
            
            
             sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Dec',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
            
            
        }
        
         System.runAs(u2){
            LiquidationSAIBController liquidationSAIBControllerObj = new  LiquidationSAIBController();
            liquidationSAIBControllerObj.displayProduct();
            liquidationSAIBControllerObj.defaultMethod();
            liquidationSAIBControllerObj.selectedMonth = 7;
            liquidationSAIBControllerObj.displayProduct();
            liquidationSAIBControllerObj.onMonthChange();
            liquidationSAIBControllerObj.displayProduct();
            liquidationSAIBControllerObj.OnchangeTeritirry();
            liquidationSAIBControllerObj.displayProduct();
            liquidationSAIBControllerObj.Select_Year = '2018-2019';
            liquidationSAIBControllerObj.displayProduct();
            liquidationSAIBControllerObj.onYearChange();
            liquidationSAIBControllerObj.displayProduct();
            
        }
        
       // Test.stopTest();   
        
        
    }//end of testupdatePermissionBH
    
    @isTest
    static void testupdatePermissionBH2(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
        
        //Data for  Business Head
        User u;
        User u1;
        User u2;
      
        
        //Country__c countryObj;
        //State__c stateObj;
        SAIB_State_Mapping__c saiBStateMapObj;
        SAIB_State_Mapping__c saiBStateMapObj1;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        
        System.runAs ( thisUser ) {
            UserRole ur = new UserRole(Name = 'Business Development Manager');
            insert ur;
            
            u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Business Head'].Id,
                
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
                UserRoleId =  ur.Id
            );  
            insert u; 
            
            
            UserRole ur1 = new UserRole(Name = 'AF - Business Head India');
            insert ur1;
            u1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Business Head'].Id,
                
                LastName = 'last',
                Email = 'puser1000@amamama.com',
                Username = 'pus1er000@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                UserRoleId =  ur1.Id
            );  
            insert u1; 
            
            
             UserRole ur2 = new UserRole(Name = 'SBU Marketing Head India 1');
            insert ur2;
            u2 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Head Pune' OR Name ='SBU Profile'].Id,
                
                LastName = 'last',
                Email = 'puser10002@amamama.com',
                Username = 'pus1er0002@amamama.com' + System.currentTimeMillis(),
                Country='India',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                UserRoleId =  ur2.Id
            );  
            insert u2; 

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
            
            
            State__c stateObj1 = new State__c(
                Name = 'Gujarat',                // State Name
                State_Code__c = '10',                     // State Code
                Country__c = 'India',                    // Country
                Active__c = true,                        // Active
                State_Code_Census__c = '10',              // State Code Census
                State_Name_Census__c = 'Gujarat',  // State Name Census
                Country_Akc__c = countryObj.id      // Country
            );
            insert stateObj1;
             
            
            
            saiBStateMapObj = new SAIB_State_Mapping__c(
                State__c = stateObj.id,// State
                User__c = u1.id,
                SBU_User__c = u2.id
            );
            insert saiBStateMapObj;
            
            
            
            saiBStateMapObj = new SAIB_State_Mapping__c(
                State__c = stateObj1.id,// State
                User__c = u1.id,
                SBU_User__c = u2.id
            );
            insert saiBStateMapObj;
            
            salesOrgObj = new Sales_Org__c(
                Name = 'India',            // Sales Org Name
                Description__c = 'India',    // Description
                Company_Code__c = '1000',    // Company Code
                Sales_Org_Code__c = '1000'  // Sales Org Code
            );
            insert salesOrgObj;
            
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
                Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2018-2019',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2019,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                State__c = stateObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj;
            
            
             liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2018-2019',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2019,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                State__c = stateObj1.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj;
            
           
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory_Cooperatives__c = 170000,      // Opening Inventory Cooperatives
                Opening_Inventory__c = 0,                        // Opening Inventory
                Opening_Inventory_Govt__c = 140000,              // Opening Inventory Govt
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                YTD_Sales_Corporate__c = 3000,                   // YTD Sales Corporate
                X15_days_lock__c = false,                        // 15 days lock
                YTD_Sales_Govt__c = 3000,                        // YTD Sales Govt
                State__c = stateObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            
            
               openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory_Cooperatives__c = 170000,      // Opening Inventory Cooperatives
                Opening_Inventory__c = 1470,                        // Opening Inventory
                Opening_Inventory_Govt__c = 140000,              // Opening Inventory Govt
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                YTD_Sales_Corporate__c = 3000,                   // YTD Sales Corporate
                X15_days_lock__c = false,                        // 15 days lock
                YTD_Sales_Govt__c = 3000,                        // YTD Sales Govt
                State__c = stateObj1.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory_Cooperatives__c = 170000,      // Opening Inventory Cooperatives
                Opening_Inventory__c = 0,                        // Opening Inventory
                Opening_Inventory_Govt__c = 140000,              // Opening Inventory Govt
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                YTD_Sales_Corporate__c = 3000,                   // YTD Sales Corporate
                X15_days_lock__c = false,                        // 15 days lock
                YTD_Sales_Govt__c = 3000,                        // YTD Sales Govt
                State__c = stateObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Dec',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
             sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Dec',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
            
            
             sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'SAIB',                                // Type
                submitted__c = false,                            // submitted
                Month__c = 'Dec',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Inventory_in_Kg_Cooperatives__c = 0,             // Inventory in Kg Cooperatives
                Inventory_in_Kg_Govt__c = 0,                     // Inventory in Kg Govt
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                State__c = stateObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
            
            
        }
        
         System.runAs(u2){
             LiquidationSAIBController liquidationSAIBControllerObj = new  LiquidationSAIBController();
             State__c stateObj = [select id,Name from State__c WHERE Name = 'Gujarat' LIMIT 1];
             System.debug('stateObj in test class '+stateObj.Name);
             
             
             liquidationSAIBControllerObj.displayProduct();
             liquidationSAIBControllerObj.defaultMethod();
             liquidationSAIBControllerObj.selectedTeritorry = stateObj.Id;
             liquidationSAIBControllerObj.isSBU = true;
             liquidationSAIBControllerObj.OnchangeTeritirry();
             LiquidationSAIBController liquidationSAIBControllerObj1 = new  LiquidationSAIBController();
             liquidationSAIBControllerObj1.isSBU = true;
             liquidationSAIBControllerObj1.selectedTeritorry ='Gujrat';
             liquidationSAIBControllerObj1.OnchangeTeritirry(); 
           
            
        }
         
         System.runAs(u1){
             LiquidationSAIBController liquidationSAIBControllerObj = new  LiquidationSAIBController();
              State__c stateObj = [select id,Name from State__c WHERE Name = 'Gujarat' LIMIT 1];
             liquidationSAIBControllerObj.displayProduct();
             liquidationSAIBControllerObj.defaultMethod();
             liquidationSAIBControllerObj.isBH = false;
             liquidationSAIBControllerObj.isSBU = true;
             liquidationSAIBControllerObj.selectedTeritorry =stateObj.Id;
             //liquidationSAIBControllerObj.OnchangeTeritirry();
             liquidationSAIBControllerObj.Select_Year ='2018-2019';
             liquidationSAIBControllerObj.selectedMonth = 11;
             liquidationSAIBControllerObj.onMonthChange();
             
             
         }
        
       // Test.stopTest();   
        
        
    }//end of testupdatePermissionSBU
    
    
   
}