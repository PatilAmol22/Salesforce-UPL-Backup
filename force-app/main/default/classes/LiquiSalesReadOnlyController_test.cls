@isTest
public class LiquiSalesReadOnlyController_test {
    //Data for  Business Head
    public static User u; //TM
    public static User u2; // ZH
    public static User u3; // SBU
    public static User u4; 
    
    private static Date today;
    
    @TestSetup
    static void makeData(){
        Multi_Country_Liquidation__c liquiRecord = new Multi_Country_Liquidation__c();
        liquiRecord.Name = 'Liquidation AF';
        liquiRecord.Enable_Liq_Validation__c = false;
        liquiRecord.Hide_Current_Month_Option__c = false;
        insert liquiRecord;
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= true;
        insert record;
    }
    
    
    public static void insertUser() {
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
    }// end of insert user function
    
    
    @isTest
    static void testupdatePermissionAdmin(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
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
        /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1410';
            uplsetting.India_SAS_Company_Code__c = '1400';
            INSERT uplsetting;
        */
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
                Fiscal_Start_Date__c = Date.newInstance(2019, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2019-2020',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2020,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
                
                
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 12330,                           // Opening Inventory
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
                Opening_Inventory__c = 12330,                           // Opening Inventory
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
                    List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_Trade__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_Trade__c;
            }
            update updateList;
       
            
            
            
            LiquidationTradeSalesReadOnlyController LiquidationTradeSalesReadOnlyControllerObj = new LiquidationTradeSalesReadOnlyController();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            LiquidationTradeSalesReadOnlyControllerObj.selectMonth=5;
            LiquidationTradeSalesReadOnlyControllerObj.defaultMethod();
            
            LiquidationTradeSalesReadOnlyControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            LiquidationTradeSalesReadOnlyControllerObj.selectedMonth = 11;
            
            LiquidationTradeSalesReadOnlyControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Nov');
            
            
            LiquidationTradeSalesReadOnlyControllerObj.selectedMonth = 10;
            
            LiquidationTradeSalesReadOnlyControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Oct');
            
            
            LiquidationTradeSalesReadOnlyControllerObj.selectedMonth = 9;
            
            LiquidationTradeSalesReadOnlyControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Sept'); 
            
            
            LiquidationTradeSalesReadOnlyControllerObj.selectedMonth = 8;
            
            LiquidationTradeSalesReadOnlyControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Aug'); 
            
            
            LiquidationTradeSalesReadOnlyControllerObj.selectedMonth = 7;
            
            LiquidationTradeSalesReadOnlyControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Jul'); 
            Test.startTest();
            LiquidationTradeSalesReadOnlyControllerObj.selectedYear='2019-2020';
            LiquidationTradeSalesReadOnlyControllerObj.onYearChange();
            LiquidationTradeSalesReadOnlyControllerObj.selectedYear='2019-2020';
            LiquidationTradeSalesReadOnlyControllerObj.onYearChange();
            LiquidationTradeSalesReadOnlyControllerObj.selectedMonth = 12;
            
            LiquidationTradeSalesReadOnlyControllerObj.selectedMonth = 11;
            
            
            
            
            LiquidationTradeSalesReadOnlyControllerObj.updateSingleRecord();
            
            
            LiquidationTradeSalesReadOnlyControllerObj.updateSingleRecord();
            
            LiquidationTradeSalesReadOnlyControllerObj.updateSingleRecord();
            LiquidationTradeSalesReadOnlyControllerObj.selectMonth=8;
            
            
            LiquidationTradeSalesReadOnlyController LiquidationTradeSalesReadOnlyControllerObj1 = new LiquidationTradeSalesReadOnlyController();
            
            //LiquidationTradeSalesReadOnlyControllerObj1.defaultMethod();
            LiquidationTradeSalesReadOnlyControllerObj1.totalLiquidation = 10;
            
            
            
            LiquidationTradeSalesReadOnlyControllerObj1.selectMonth = 9;
            LiquidationTradeSalesReadOnlyControllerObj1.Select_Year = '2019-2020';
            
            LiquidationTradeSalesReadOnlyControllerObj1.updateSingleRecord();
            LiquidationTradeSalesReadOnlyControllerObj1.selectMonth = 9;
            LiquidationTradeSalesReadOnlyControllerObj.onMonthChange();
            LiquidationTradeSalesReadOnlyControllerObj.tmpSelectedMonth = 9;
            
            
            // LiquidationTradeSalesReadOnlyControllerObj.OnchangeTeritirry();
            LiquidationTradeSalesReadOnlyControllerObj.tmpSelectedMonth = 5;
            LiquidationTradeSalesReadOnlyControllerObj.OnchangeTeritirry();
            //LiquidationTradeSalesReadOnlyControllerObj1.createCropLiquidation();
        } 
        //End of First User.
        Test.stopTest();
        
    }//end of function testupdatePermissionAdmin
    
    // this is for SBU user
  
    
    @isTest
    static void testupdatePermissionBH1(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
                
        //Country__c countryObj;
        //State__c stateObj;
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        
        
            System.runAs ( thisUser ){insertUser();}
            //-------------------------------------------------------
            /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1410';
            uplsetting.India_SAS_Company_Code__c = '1400';
            INSERT uplsetting;
*/
            //--------------------------------------------------------

            salesOrgObj = new Sales_Org__c(
                Name = 'India',            // Sales Org Name
                Description__c = 'India',    // Description
                Company_Code__c = '1000',    // Company Code
                Sales_Org_Code__c = '1000' // Sales Org Code
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
            
            
            
        
        Test.startTest();
        

        //End of First User.
        
        
        System.runAs(u3){
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2020-2021',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2021,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,
                Sales_Org__c = salesOrgObj.Id, 
                RecordTypeId = rtforAnnualPlan
            );
            insert liqannlPlnObj;
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 12330,                           // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 12330,                           // Opening Inventory
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
            
            
            
            
            LiquidationTradeSalesReadOnlyController LiquidationTradeSalesReadOnlyControllerObj1 = new LiquidationTradeSalesReadOnlyController();
            //LiquidationTradeSalesReadOnlyControllerObj1.selectedYear = '2019-2020';
           
            //LiquidationTradeSalesReadOnlyControllerObj1.onMonthChange();
           // LiquidationTradeSalesReadOnlyControllerObj1.OnchangeTeritirry();
            LiquidationTradeSalesReadOnlyControllerObj1.createCropLiquidation();
            TradeIndiaCropLiquiSBUAdmin objs = new TradeIndiaCropLiquiSBUAdmin();
            objs.showProductListForCropIndiaSelectTeri('Narayangaon', 'Apr', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj}, rtforLiquidation);
            objs.loadAllDataForCropLiquidationIndiaSelectTeri('Narayangaon', 'Apr', new List<Liquidation_Annual_Plan__c> {liqannlPlnObj}, rtforLiquidation);
            objs.displayCropDataForSingleTeritory(new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},'Narayangaon','Apr');
            objs.showProductListForCropForHigher(new List<Liquidation_Annual_Plan__c> {liqannlPlnObj},'Apr', rtforLiquidation);
            
            RollUpSBUAdminIndiaCtrl rollupTradeSalesLiquidationObj = new RollUpSBUAdminIndiaCtrl();
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Jan',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Feb',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Mar',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Apr',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','May',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Jun',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Jul',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Aug',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Sept',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Oct',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Nov',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails('All','Dec',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
             rollupTradeSalesLiquidationObj.rollupCropLiquidationDetails(new List<Liquidation_Annual_Plan__c> {liqannlPlnObj}, 'Apr');
            LiquidationTradeSalesReadOnlyControllerObj1.OnchangeTeritirry();
            LiquidationTradeSalesReadOnlyControllerObj1.selectedTeritorry ='Narayangaon';
            LiquidationTradeSalesReadOnlyControllerObj1.createCropLiquidation();
            
        }
        
        
        Test.stopTest();
        
    }
  
   
    
    
    
}