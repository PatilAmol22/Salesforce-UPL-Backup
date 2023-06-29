@isTest(seeAllData = false)
public class Liquidation_TradeSale_Test {
    //Data for  Business Head
    public static User u; //TM
    //User u1; // RM
    public static User u2; // ZH
    public static User u3; // SBU
    public static User u4; 
    
    private static Date today;

    @TestSetup
    static void makeData(){
        Multi_Country_Liquidation__c liquiRecord = new Multi_Country_Liquidation__c();
        liquiRecord.Name = 'Liquidation AF';
        liquiRecord.Country__c = 'India';
        liquiRecord.Enable_Liq_Validation__c = false;
        liquiRecord.Hide_Current_Month_Option__c = false;
        insert liquiRecord;
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        
        Trigger_Settings__c record1 = new Trigger_Settings__c();
        record1.Name = 'LiquidationApprovalTrigger';
        record1.IsActive__c	= true;
        insert record1;
        
    }
    
    public static void insertUser() {
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;


        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        //UserRole ur = new UserRole(Name = 'Business Development Manager');
        //insert ur;
        u = new User(
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
            MobilePhone = '8888888888' //Sayan CHG0030762
            //  UserRoleId =  ur.Id
        );  
        insert u;
        
        
        // UserRole ur2 = new UserRole(Name = 'Zonal Head Indore');
        //  insert ur2;
        u2 = new User(
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
            MobilePhone = '8888888888' //Sayan CHG0030762
            //  UserRoleId =  ur2.Id
        );  
        insert u2;
        
        
        
        // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
        // insert ur3;
        u3 = new User(
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
            MobilePhone = '8888888888' //Sayan CHG0030762
            // UserRoleId =  ur3.Id
        );  
        insert u3;
        
        // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
        // insert ur4;
        u4 = new User(
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
            MobilePhone = '8888888888' //Sayan CHG0030762
            //UserRoleId =  ur4.Id
        );  
        insert u4;
    }// end of insertUser function 
    
    @isTest
    static void testCreateData(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Liquidation_Annual_Plan__c liqannlPlnObj1;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ){insertUser();}
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            ZMMUser__c = u4.Id,
            SBUCode__c = SBUObj.Id    // SBU Code
        );
        insert zoneObj;
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
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
        System.runAs(u){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
                
                
            );
            insert liqannlPlnObj;
            
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 , 
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                       // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Aug',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Nov',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            //insert sobj; 
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            Test.startTest();
            liquidationTradeSalesControllerObj.selectMonth=5;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            
            liquidationTradeSalesControllerObj.selectedMonth=3;
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.updateData();
        }
    }
    
    @isTest
    static void testupdatePermissionTM(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;

        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Liquidation_Annual_Plan__c liqannlPlnObj1;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        //UserRole ur = new UserRole(Name = 'Business Development Manager');
        System.runAs ( thisUser ){insertUser();}
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            ZMMUser__c = u4.Id,
            SBUCode__c = SBUObj.Id    // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
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
        
        
        Product2 ProductObj2 = new Product2(
            Name = 'Stargem Plus',          // Product Name
            ProductCode = '71451',                 // Product Code
            Product_Code__c = '71451',             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '71450112302011',  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 100.00                 // Budget NRV
        );
        insert ProductObj2;    
        
        
        
        
        
        // System.runAs ( thisUser ) {
        
        System.runAs(u){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
                
                
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 , 
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            Opening_Inventory2__c openInveObj3 = new Opening_Inventory2__c(
                Product__c = ProductObj2.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj3;
            
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Oct',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Nov',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj;
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'May',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 200,                      // Retailers Inventory
                Distributors_Inventory__c = 100,
                Distributor_Inventory_Previous_Month__c = 50,
                Retailer_Inventory_Previous_Month__c = 30,// Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Jun',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 100,                      // Retailers Inventory
                Distributors_Inventory__c = 200, 
                Distributor_Inventory_Previous_Month__c = 50,
                Retailer_Inventory_Previous_Month__c = 30,// Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj;
            
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            
            Crop__c crpObj = new Crop__c(
                Name = 'Cereals',                     // Crop Name
                Crop_Code__c = 'CL001',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj;
            
            Crop__c crpObj2 = new Crop__c(
                Name = 'Oilseeds',                    // Crop Name
                Crop_Code__c = 'OL003',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
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
            
            
            
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.selectMonth=5;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.selectedMonth = 11;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Nov');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Nov');
            
            
            liquidationTradeSalesControllerObj.selectedMonth = 10;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Oct');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Oct');
            
            
            liquidationTradeSalesControllerObj.selectedMonth = 9;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Sept');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Sept'); 
            
            
            liquidationTradeSalesControllerObj.selectedMonth = 8;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Aug');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Aug'); 
            
            
            liquidationTradeSalesControllerObj.selectedMonth = 7;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Jul');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Jul');
            liquidationTradeSalesControllerObj.selectedMonth = 3;
            Test.startTest();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Mar');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Mar');
            
            
            liquidationTradeSalesControllerObj.selectedMonth = 4;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Apr');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Apr');
            
            liquidationTradeSalesControllerObj.selectedMonth = 5;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'May');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'May');
            
            liquidationTradeSalesControllerObj.selectedMonth = 6;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Jun');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Jun');
            
            
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.selectedMonth = 12;
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            liquidationTradeSalesControllerObj.selectedMonth = 11;
            liquidationTradeSalesControllerObj.getPreviousMonthLiquidation(territoryObj.ID, liqannlPlnObj.Id);
            liquidationTradeSalesControllerObj.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj.recordIdTotupdate = openInveObj.id;
            liquidationTradeSalesControllerObj.valueToupdate = '14';
            liquidationTradeSalesControllerObj.fieldTotupdate='Opening_Inventory__c';
            //liquidationTradeSalesControllerObj.updateSingleRecord();
            
            liquidationTradeSalesControllerObj.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj.fieldTotupdate = 'distributer_inventory';
            //liquidationTradeSalesControllerObj.updateSingleRecord();
            
            liquidationTradeSalesControllerObj.fieldTotupdate = 'retailer_inventory';
            //liquidationTradeSalesControllerObj.updateSingleRecord();
            liquidationTradeSalesControllerObj.selectMonth=8;
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj1 = new LiquidationTradeSalesController();
            
            //liquidationTradeSalesControllerObj1.defaultMethod();
            liquidationTradeSalesControllerObj1.totalLiquidation = 10;
            liquidationTradeSalesControllerObj1.fieldTotupdate = 'Plan_for_the_next_month__c';
            liquidationTradeSalesControllerObj1.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj1.valueToupdate = '14';
            liquidationTradeSalesControllerObj1.selectMonth = 9; 
            liquidationTradeSalesControllerObj1.Select_Year = '2021-2022';
            liquidationTradeSalesControllerObj1.prodIdTotupdate = ProductObj.Id;
            //liquidationTradeSalesControllerObj1.updateSingleRecord();
            
            
            liquidationTradeSalesControllerObj.updateData();
            liquidationTradeSalesControllerObj1.selectMonth = 9;
            liquidationTradeSalesControllerObj.onMonthChange();
            liquidationTradeSalesControllerObj.tmpSelectedMonth = 9;
            liquidationTradeSalesControllerObj.getDataForPrevSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            delete  [Select Id from Liquidation2__c where Product__c = :ProductObj2.ID];
            liquidationTradeSalesControllerObj.createDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            liquidationTradeSalesControllerObj.tmpSelectedMonth = 5;
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Apr');
            Test.stopTest();
        } 
        //End of First User.
    }//end of function testupdatePermissionTM
    
    @isTest
    static void testupdatePermissionTM3(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;

        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Liquidation_Annual_Plan__c liqannlPlnObj1;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        //UserRole ur = new UserRole(Name = 'Business Development Manager');
        System.runAs ( thisUser ){insertUser();}
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            ZMMUser__c = u4.Id,
            SBUCode__c = SBUObj.Id    // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
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
        
        
        Product2 ProductObj2 = new Product2(
            Name = 'Stargem Plus',          // Product Name
            ProductCode = '71451',                 // Product Code
            Product_Code__c = '71451',             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '71450112302011',  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 100.00                 // Budget NRV
        );
        insert ProductObj2;    
        
        
        
        
        
        // System.runAs ( thisUser ) {
        
        System.runAs(u){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
                
                
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 , 
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            Opening_Inventory2__c openInveObj3 = new Opening_Inventory2__c(
                Product__c = ProductObj2.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj3;
            
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Oct',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Nov',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj;
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'May',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 200,                      // Retailers Inventory
                Distributors_Inventory__c = 100,
                Distributor_Inventory_Previous_Month__c = 50,
                Retailer_Inventory_Previous_Month__c = 30,// Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Jun',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 100,                      // Retailers Inventory
                Distributors_Inventory__c = 200, 
                Distributor_Inventory_Previous_Month__c = 50,
                Retailer_Inventory_Previous_Month__c = 30,// Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj;
            
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            
            Crop__c crpObj = new Crop__c(
                Name = 'Cereals',                     // Crop Name
                Crop_Code__c = 'CL001',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj;
            
            Crop__c crpObj2 = new Crop__c(
                Name = 'Oilseeds',                    // Crop Name
                Crop_Code__c = 'OL003',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
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
            
            
            
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            Test.startTest();
            liquidationTradeSalesControllerObj.selectMonth=5;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.createCropLiquidation();
            liquidationTradeSalesControllerObj.createCropLiquidation();
            liquidationTradeSalesControllerObj.isDataAvail = true;
            liquidationTradeSalesControllerObj.flag = true;
           Test.stopTest();
        } 
        //End of First User.
    }//end of function testupdatePermissionTM
    
    
    
    
    @isTest
    static void testupdatePermissionTM1(){
        // this is for update single value
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Liquidation_Annual_Plan__c liqannlPlnObj1;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        //UserRole ur = new UserRole(Name = 'Business Development Manager');
        System.runAs ( thisUser ){insertUser();}
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            ZMMUser__c = u4.Id,
            SBUCode__c = SBUObj.Id    // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
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
        
        
        
        
        
        
        // System.runAs ( thisUser ) {
        
        System.runAs(u){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
                
                
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 , 
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123320,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,
                YTD_Sales_Jan__c = 0,
                YTD_Sales_Feb__c = 0,
                YTD_Sales_Mar__c = 0,
                YTD_Sales_Apr__c = 0,
                YTD_Sales_May__c = 0,
                YTD_Sales_Jun__c = 0,
                YTD_Sales_Jul__c = 0,
                YTD_Sales_Aug__c = 0,
                YTD_Sales_Sept__c = 0,
                YTD_Sales_Oct__c = 0,
                YTD_Sales_Nov__c = 0,
                YTD_Sales_Dec__c = 0,
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Apr',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Apr',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            
            Crop__c crpObj = new Crop__c(
                Name = 'Cereals',                     // Crop Name
                Crop_Code__c = 'CL001',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj;
            
            Crop__c crpObj2 = new Crop__c(
                Name = 'Oilseeds',                    // Crop Name
                Crop_Code__c = 'OL003',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
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
            
            
            
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.selectMonth=5;
            liquidationTradeSalesControllerObj.defaultMethod();
            Test.startTest();
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.selectedMonth = 12;
            liquidationTradeSalesControllerObj.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj.recordIdTotupdate = openInveObj.id;
            liquidationTradeSalesControllerObj.valueToupdate = '14';
            liquidationTradeSalesControllerObj.fieldTotupdate='Opening_Inventory__c';
            liquidationTradeSalesControllerObj.updateSingleRecord();
            
            liquidationTradeSalesControllerObj.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj.fieldTotupdate = 'distributer_inventory';
            liquidationTradeSalesControllerObj.updateSingleRecord();
            
            liquidationTradeSalesControllerObj.fieldTotupdate = 'retailer_inventory';
            liquidationTradeSalesControllerObj.updateSingleRecord();
            
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj1 = new LiquidationTradeSalesController();
            liquidationTradeSalesControllerObj1.totalLiquidation = 10;
            liquidationTradeSalesControllerObj1.fieldTotupdate = 'Plan_for_the_next_month__c';
            liquidationTradeSalesControllerObj1.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj1.valueToupdate = '14';
            liquidationTradeSalesControllerObj1.selectMonth = 9; 
            liquidationTradeSalesControllerObj1.Select_Year = '2021-2022';
            liquidationTradeSalesControllerObj1.prodIdTotupdate = ProductObj.Id;
            liquidationTradeSalesControllerObj1.updateSingleRecord();
            liquidationTradeSalesControllerObj1.createCropLiquidation();
            
            
            liquidationTradeSalesControllerObj1.recordIdTotupdate =crpLiqObj2.Id;
            liquidationTradeSalesControllerObj1.valueToupdate = '12';
            liquidationTradeSalesControllerObj1.prodIdTotupdate = ProductObj.Id; 
            liquidationTradeSalesControllerObj1.updateSingleRecordForCropLiquidation();
            liquidationTradeSalesControllerObj1.updateCropLiquidation();
            
            TradeSalesIndiaCropLiquidation TradeSalesObj = new TradeSalesIndiaCropLiquidation();
            TradeSalesObj.checkingCropLiquidationSubmitedIndia('Narayangaon', 'Apr', liqannlPlnObj.Id, rtforLiquidation);
            TradeSalesObj.checkingCropLiquidationSubmitedIndiaHigh('Narayangaon', 'Apr', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //objs.loadAllDataForCropLiquidationIndiaSelectTeri('Narayangaon', 'Apr', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj}, rtforLiquidation);
            //objs.displayCropDataForSingleTeritory(new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},'Narayangaon','Apr');
            
            
            Test.stopTest();
            
            
        } 
        //End of First User.
    }//end of testupdatePermissionTM1
    
    //this is for Zonal Head Login
    
    @isTest
    static void testupdatePermissionZonalHead(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        
        System.runAs ( thisUser ){insertUser();}
        
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            SBUCode__c = SBUObj.Id,
            ZMMUser__c = u2.Id // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
            Zone__c = zoneObj.id
            
            
        );
        insert regionObj;
        
        
        territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Narayangaon';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Region__c = regionObj.id;
       // territoryObj.TerritoryManager__c = u.Id;
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
        
        
        
        
        
        
        //End of First User.
        
        
        System.runAs(u2){
            Test.startTest();
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,
                Sales_Org__c = salesOrgObj.Id, 
                RecordTypeId = rtforAnnualPlan
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
                Month__c = 'Apr',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            
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
                RecordTypeId = rtforLiquidation
            );
            insert sobj; 
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj1 = new LiquidationTradeSalesController();
            liquidationTradeSalesControllerObj1.isAdmin = true;
            liquidationTradeSalesControllerObj1.OnchangeTeritirry();
            liquidationTradeSalesControllerObj1.onMonthChange();
            liquidationTradeSalesControllerObj1.onYearChange();
            liquidationTradeSalesControllerObj1.selectedTeritorry ='Narayangaon';
            liquidationTradeSalesControllerObj1.OnchangeTeritirry();
            liquidationTradeSalesControllerObj1.selectedTeritorry ='All';
            Test.stopTest();
            liquidationTradeSalesControllerObj1.onMonthChange();
        }
        
        
        
    }// End of function testupdatePermissionZonalHead
    
    
    //this is for Zonal Head for Crop Liquidation
    
    
    @isTest
    static void testupdatePermissionZonalHead1(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        
        System.runAs ( thisUser ){insertUser();}
        
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            SBUCode__c = SBUObj.Id,
            ZMMUser__c = u2.Id // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
            Zone__c = zoneObj.id
            
            
        );
        insert regionObj;
        
        
        territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Narayangaon';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Region__c = regionObj.id;
       // territoryObj.TerritoryManager__c = u.Id;
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
        
        
        
        
        
        
        //End of First User.
        
        Test.startTest();
        System.runAs(u2){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,
                Sales_Org__c = salesOrgObj.Id, 
                RecordTypeId = rtforAnnualPlan
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 23130,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 213230,                        // Opening Inventory
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
                Month__c = 'Apr',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,  
                Fixed_YTD_Sales__c=100,                // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Apr',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,
                Fixed_YTD_Sales__c=200,// Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            Crop__c crpObj = new Crop__c(
                Name = 'Cereals',                     // Crop Name
                Crop_Code__c = 'CL001',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj;
            
            Crop__c crpObj2 = new Crop__c(
                Name = 'Oilseeds',                    // Crop Name
                Crop_Code__c = 'OL003',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
               
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj2;            
            
            Crop_Liquidation__c crpLiqObj1 = new Crop_Liquidation__c(
                Crop__c = crpObj.Id,            // Crop
                Liquidation__c = sobj.Id ,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 9.00,            // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj1;
            
            Crop_Liquidation__c crpLiqObj2 = new Crop_Liquidation__c(
                Crop__c = crpObj2.Id,            // Crop
                Liquidation__c = sobj.Id,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 1000.00,        // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj2;
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            //liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            liquidationTradeSalesControllerObj.createCropLiquidation();
             liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            liquidationTradeSalesControllerObj.selectedMonth = 6;
             liquidationTradeSalesControllerObj.onMonthChange();
            liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            liquidationTradeSalesControllerObj.createCropLiquidation();
            liquidationTradeSalesControllerObj.selectedTeritorry ='All';
            liquidationTradeSalesControllerObj.createCropLiquidation();
            
        }
        Test.stopTest();
        
        
    }// End of function testupdatePermissionZonalHead1
    
    
    //Territory Present
     @isTest
    static void testupdatePermissionZonalHead2(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        
        System.runAs ( thisUser ){insertUser();}
        
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            SBUCode__c = SBUObj.Id,
            ZMMUser__c = u2.Id // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
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
        
        
        
        
        
        
        //End of First User.
        
        Test.startTest();
        System.runAs(u2){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,
                Sales_Org__c = salesOrgObj.Id, 
                RecordTypeId = rtforAnnualPlan
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 23130,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 213230,                        // Opening Inventory
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
                Month__c = 'Jun',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Jun',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            Crop__c crpObj = new Crop__c(
                Name = 'Cereals',                     // Crop Name
                Crop_Code__c = 'CL001',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj;
            
            Crop__c crpObj2 = new Crop__c(
                Name = 'Oilseeds',                    // Crop Name
                Crop_Code__c = 'OL003',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj2;            
            
            Crop_Liquidation__c crpLiqObj1 = new Crop_Liquidation__c(
                Crop__c = crpObj.Id,            // Crop
                Liquidation__c = sobj.Id ,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 9.00,            // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj1;
            
            Crop_Liquidation__c crpLiqObj2 = new Crop_Liquidation__c(
                Crop__c = crpObj2.Id,            // Crop
                Liquidation__c = sobj.Id,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 1000.00,        // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj2;
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            //liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            liquidationTradeSalesControllerObj.createCropLiquidation();
             liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
           // liquidationTradeSalesControllerObj.selectedMonth = 6;
            // liquidationTradeSalesControllerObj.onMonthChange();
            //liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            //liquidationTradeSalesControllerObj.createCropLiquidation();
            
            RollupTradeSalesLiquidation rollupTradeObj = new RollupTradeSalesLiquidation();
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jan',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Feb',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Mar',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Apr',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','May',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jun',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jul',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Aug',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Sept',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Oct',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Nov',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Dec',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            TradeSalesIndiaCropLiquidation obj = new TradeSalesIndiaCropLiquidation();
            obj.actionCreateCropLiquidationIndiaForHigher('Narayangaon','Jun', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation);
            obj.loadAllDataForCropLiquidationIndiaSelectTeri('Narayangaon','Jun', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation);
            
            obj.showProductListForCropIndiaSelectTeri('Narayangaon','Jun',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation); // added after changes done for RITM0180898
            obj.updateCropLiquidationIndia( liqannlPlnObj.Territory_Name__c, 'Jun', liqannlPlnObj.Id, rtforLiquidation); // added after changes done for RITM0180898
            
        }
        Test.stopTest();
        
        
    }// End of function testupdatePermissionZonalHead2
    
      @isTest
    static void testupdatePermissionZonalHead5(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        
        System.runAs ( thisUser ){insertUser();}
        
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            SBUCode__c = SBUObj.Id,
            ZMMUser__c = u2.Id // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
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
        
        
        
        
        
        
        //End of First User.
        
        Test.startTest();
        System.runAs(u2){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,
                Sales_Org__c = salesOrgObj.Id, 
                RecordTypeId = rtforAnnualPlan
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 23130,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 213230,                        // Opening Inventory
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
                Month__c = 'Mar',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Mar',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            Crop__c crpObj = new Crop__c(
                Name = 'Cereals',                     // Crop Name
                Crop_Code__c = 'CL001',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj;
            
            Crop__c crpObj2 = new Crop__c(
                Name = 'Oilseeds',                    // Crop Name
                Crop_Code__c = 'OL003',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj2;            
            
            Crop_Liquidation__c crpLiqObj1 = new Crop_Liquidation__c(
                Crop__c = crpObj.Id,            // Crop
                Liquidation__c = sobj.Id ,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 9.00,            // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj1;
            
            Crop_Liquidation__c crpLiqObj2 = new Crop_Liquidation__c(
                Crop__c = crpObj2.Id,            // Crop
                Liquidation__c = sobj.Id,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 1000.00,        // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj2;
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            //liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            liquidationTradeSalesControllerObj.createCropLiquidation();
             liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
           // liquidationTradeSalesControllerObj.selectedMonth = 6;
            // liquidationTradeSalesControllerObj.onMonthChange();
            //liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            //liquidationTradeSalesControllerObj.createCropLiquidation();
            
            RollupTradeSalesLiquidation rollupTradeObj = new RollupTradeSalesLiquidation();
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jan',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Feb',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Mar',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Apr',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','May',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jun',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jul',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Aug',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Sept',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Oct',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Nov',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Dec',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            TradeSalesIndiaCropLiquidation obj = new TradeSalesIndiaCropLiquidation();
            obj.actionCreateCropLiquidationIndiaForHigher('Narayangaon','Mar', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation);
            obj.loadAllDataForCropLiquidationIndiaSelectTeri('Narayangaon','Mar', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation);
            
            obj.showProductListForCropIndiaSelectTeri('Narayangaon','Mar',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation); // added after changes done for RITM0180898
            obj.updateCropLiquidationIndia( liqannlPlnObj.Territory_Name__c, 'Mar', liqannlPlnObj.Id, rtforLiquidation); // added after changes done for RITM0180898
            
        }
        Test.stopTest();
        
        
    }
    
      @isTest
    static void testupdatePermissionZonalHead6(){
        
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        
        System.runAs ( thisUser ){insertUser();}
        
        
        salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
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
            SBUCode__c = SBUObj.Id,
            ZMMUser__c = u2.Id // SBU Code
        );
        insert zoneObj;
        
        
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
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
        
        
        
        
        
        
        //End of First User.
        
        Test.startTest();
        System.runAs(u2){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,
                Sales_Org__c = salesOrgObj.Id, 
                RecordTypeId = rtforAnnualPlan
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 23130,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 213230,                        // Opening Inventory
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
                Month__c = 'Mar',                               // Month
                Liquidation__c = 0,   
                Fixed_YTD_Sales__c=300,// Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = 'Mar',                               // Month
                Liquidation__c = 0,
                Fixed_YTD_Sales__c = 200,// Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            Crop__c crpObj = new Crop__c(
                Name = 'Cereals',                     // Crop Name
                Crop_Code__c = 'CL001',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj;
            
            Crop__c crpObj2 = new Crop__c(
                Name = 'Oilseeds',                    // Crop Name
                Crop_Code__c = 'OL003',                 // Crop Code
                Active__c = true,                       // Active
                SalesOrg__c = salesOrgObj.Id,        // Sales Org
                Type__c = 'Crop',                   // Type
                
                Active_for_Crop_Liquidation__c = true  // Active for Crop Liquidation
            );
            insert crpObj2;            
            
            Crop_Liquidation__c crpLiqObj1 = new Crop_Liquidation__c(
                Crop__c = crpObj.Id,            // Crop
                Liquidation__c = sobj.Id ,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 9.00,            // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj1;
            
            Crop_Liquidation__c crpLiqObj2 = new Crop_Liquidation__c(
                Crop__c = crpObj2.Id,            // Crop
                Liquidation__c = sobj.Id,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 1000.00,        // Liquidation Value
                is_Crop_Liquidation_Submitted__c = false,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj2;
            
            
            LiquidationTradeSalesController liquidationTradeSalesControllerObj = new LiquidationTradeSalesController();
            //liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            liquidationTradeSalesControllerObj.createCropLiquidation();
             liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
           // liquidationTradeSalesControllerObj.selectedMonth = 6;
            // liquidationTradeSalesControllerObj.onMonthChange();
            //liquidationTradeSalesControllerObj.selectedTeritorry ='Narayangaon';
            //liquidationTradeSalesControllerObj.createCropLiquidation();
            
            RollupTradeSalesLiquidation rollupTradeObj = new RollupTradeSalesLiquidation();
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jan',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Feb',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Mar',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Apr',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','May',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jun',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Jul',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Aug',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Sept',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Oct',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Nov',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeObj.rollUpOpenInventoryDetails('All','Dec',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            TradeSalesIndiaCropLiquidation obj = new TradeSalesIndiaCropLiquidation();
            obj.actionCreateCropLiquidationIndiaForHigher('Narayangaon','Mar', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation);
            obj.loadAllDataForCropLiquidationIndiaSelectTeri('Narayangaon','Mar', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},rtforLiquidation);
            obj.rollupCropLiquidationIndia(new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},'Mar');
        }
        Test.stopTest();
        
        
    }
    
}