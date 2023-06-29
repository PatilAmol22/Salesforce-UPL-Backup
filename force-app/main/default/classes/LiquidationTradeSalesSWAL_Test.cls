@isTest(seeAlldata=false)
public class LiquidationTradeSalesSWAL_Test { 
    public static User u; //TM
    public static User u1; // RM
    public static User u2; // ZH
    public static User u3; // SBU
    private static Date today;
    
    @TestSetup
    static void makeData(){
        Multi_Country_Liquidation__c liquiRecord = new Multi_Country_Liquidation__c();
        liquiRecord.Name = 'Liquidation SWAL';
        liquiRecord.Country__c = 'SWAL';
        liquiRecord.Enable_Liq_Validation__c = false;
        liquiRecord.Hide_Current_Month_Option__c = false;
        insert liquiRecord;
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= false;
        insert record;
        
        Trigger_Settings__c record1 = new Trigger_Settings__c();
        record1.Name = 'LiquidationApprovalTrigger';
        record1.IsActive__c	= true;
        insert record1;
        
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
            MobilePhone = '9748694980'
            //  UserRoleId =  ur.Id
        );  
        insert u;
        
        
        // UserRole ur2 = new UserRole(Name = 'Zonal Head Indore');
        //  insert ur2;
        u1 = new User(
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
        
        
        
        // UserRole ur3 = new UserRole(Name = 'SBU Head India 1');
        // insert ur3;
        u2 = new User(
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
        
        // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune');
        // insert ur4;
        u3 = new User(
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
    }// End of insertUser function
    
    
    @isTest
    static void testupdatePermissionTM(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj1;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ){insertUser();}
        
        
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
        
        
        
        
        System.runAs(u){
            liqannlPlnObj1 = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2020-2021',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2021,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj1;
            Liquidation_Annual_Plan__c liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
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
                submitted_Trade_SWAL__c =true
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj; 
            
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
            //Added by Varun Shrivastava End
            try{
            Test.startTest(); //bh
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.selectMonth=4;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            
            liquidationTradeSalesControllerObj.selectMonth=6;
           liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Jun');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Jun');
                
           
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            
            liquidationTradeSalesControllerObj.selectedYear='2022-2023';
            liquidationTradeSalesControllerObj.onYearChange();
                
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
            liquidationTradeSalesControllerObj.selectMonth=8;
            
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.totalLiquidation = 10;
            liquidationTradeSalesControllerObj.fieldTotupdate = 'Plan_for_the_next_month__c';
           liquidationTradeSalesControllerObj.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj.valueToupdate = '14';
            liquidationTradeSalesControllerObj.selectMonth = 7;
            liquidationTradeSalesControllerObj.Select_Year = '2021-2022';
            liquidationTradeSalesControllerObj.prodIdTotupdate = ProductObj.Id;
            liquidationTradeSalesControllerObj.updateSingleRecord();
                
            liquidationTradeSalesControllerObj.defaultMethod();
                 liquidationTradeSalesControllerObj.totalLiquidation = 10;
            liquidationTradeSalesControllerObj.fieldTotupdate = 'Plan_for_the_next_month__c';
           liquidationTradeSalesControllerObj.recordIdTotupdate = sobj.id;
            liquidationTradeSalesControllerObj.valueToupdate = '14';
            liquidationTradeSalesControllerObj.selectedMonth = 12;
            liquidationTradeSalesControllerObj.Select_Year = '2021-2022';
            liquidationTradeSalesControllerObj.prodIdTotupdate = ProductObj.Id;
            liquidationTradeSalesControllerObj.updateSingleRecord();
                
            // liquidationTradeSalesControllerObj.sendEmailToRM(); removed after RITM0180898
            liquidationTradeSalesControllerObj.onMonthChange();
            liquidationTradeSalesControllerObj.getDataForPrevSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            liquidationTradeSalesControllerObj.createDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            liquidationTradeSalesControllerObj.createCropLiquidation();
            
            liquidationTradeSalesControllerObj.recordIdTotupdate =crpLiqObj2.Id;
            liquidationTradeSalesControllerObj.valueToupdate = '12';
            liquidationTradeSalesControllerObj.prodIdTotupdate = ProductObj.Id;
            liquidationTradeSalesControllerObj.updateSingleRecordForCropLiquidation();
            liquidationTradeSalesControllerObj.updateCropLiquidation();
            Test.stopTest();
            
            liquidationTradeSalesControllerObj.updateCropLiquidation();
            //TradeSalesSWALCropLiquidation to = new TradeSalesSWALCropLiquidation();
            //to.updateCropLiquidationSWAL(territoryObj.ID, 'Apr', liqannlPlnObj.Id, rtforLiquidation);
            
            
            liquidationTradeSalesControllerObj.selectedMonth = 3;
                //rtforLiquidation
            liquidationTradeSalesControllerObj.updateData();
            
            
            
            //RollupTradeSalesLiquidation_SWAL rollupTradeSalesLiquidation_SWAL = new RollupTradeSalesLiquidation_SWAL();
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Apr',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','May',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Jun',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Jul',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Aug',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Sept',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Oct',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Nov',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Dec',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Jan',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Mar',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Feb',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            
            //rollupTradeSalesLiquidation_SWAL.rollUpOpenInventoryDetails('All','Mar',new List<Liquidation_Annual_Plan__c> {liqannlPlnObj});
            
            }
            catch(Exception e){
                
            }
        } //End of First User.
        
        
    }//end of function for TM
    
    
    @isTest
    static void testupdatePermissionTM8(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj1;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c sobj;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ){insertUser();}
        
        
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
        
        
        
        Test.startTest();
            
        System.runAs(u){
            liqannlPlnObj1 = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2020-2021',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2021,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj1;
            Liquidation_Annual_Plan__c liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
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
                submitted_Trade_SWAL__c =false
            );
            insert sobj; 
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj1.Id,  // Liquidation Annual Plan
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
                submitted_Trade_SWAL__c =false
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
                submitted_Trade_SWAL__c =false
            );
            insert sobj; 
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj1.Id,  // Liquidation Annual Plan
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
                submitted_Trade_SWAL__c =false
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
                submitted_Trade_SWAL__c =false
            );
            insert sobj; 
            
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
            //Added by Varun Shrivastava End
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.selectMonth=7;
            //liquidationTradeSalesControllerObj.defaultMethod();
            //
           /* System.assert(false,'Jun:'+[SELECT id  FROM Liquidation2__c 
                                WHERE Territory__c=:territoryObj.ID
                                AND Liquidation_Annual_Plan__c=:liqannlPlnObj.Id
                                AND Month__c ='Jun'
                                AND RecordTypeId =:rtforLiquidation]);*/
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Jul');
                        liquidationTradeSalesControllerObj.updateData();

            
            
        } 
        Test.stopTest();
        //End of First User.
        
        
    }//end of function for TM
    
    
    @isTest
    static void testupdatePermissionTM2(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
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
        
        Product2 ProductObj1 = new Product2(
            Name = 'PHOSKILL',          // Product Name
            ProductCode = '71450',                 // Product Code
            Product_Code__c = '71451',             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '7145010002011',  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 50.00                 // Budget NRV
        );
        insert ProductObj1;    
        
        
        
        System.runAs(u){
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
            
            Liquidation_Annual_Plan__c liqannlPlnObj1 = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2020-2021',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2021,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj1;
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
            
            Opening_Inventory2__c openInveObj1 = new Opening_Inventory2__c(
                Product__c = ProductObj1.Id,                // Product
                Opening_Inventory__c = 12,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 100 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj1;
            
            
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj;
            
            Liquidation2__c sobj3 = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj1.Id,  // Liquidation Annual Plan
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj3; 
            
            
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
            //Added by Varun Shrivastava End
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            liquidationTradeSalesControllerObj.selectMonth=5;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'May');
            
            liquidationTradeSalesControllerObj.selectedMonth=9;
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            Test.stopTest();
        } 
    }
    
     @isTest
  static void testupdatePermissionTM1(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
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
        
        
        
        
        System.runAs(u){
            Test.startTest();
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
                Month__c = 'Apr',                               // Month
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
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
            
            
            
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.selectMonth=4;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            Test.stopTest();
            
        } //End of First User.
        
        
    }//end of function for testupdatePermissionTM1
    
@isTest
    static void testupdatePermissionRM(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        

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
            
            
           
            
        
        System.runAs(u1){
            Test.startTest();
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
                Month__c = 'Apr',                               // Month
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj; 
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Month__c = 'Apr',                               // Month
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
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
            }
            update updateList;
        
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.isTM = false;
            liquidationTradeSalesControllerObj.isRM = True;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.selectedMonth = 12;
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.onMonthChange();
            liquidationTradeSalesControllerObj.onYearChange();
            
           // liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.selectedMonth = 10;
            liquidationTradeSalesControllerObj.onMonthChange();
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.OnchangeTeritirry();
            
            //bh
            liquidationTradeSalesControllerObj.isRM = True;
             liquidationTradeSalesControllerObj.selectedTeritorry = 'All';
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.selectedMonth = 4;
            liquidationTradeSalesControllerObj.onMonthChange();
            
            liquidationTradeSalesControllerObj.selectedMonth=7;
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            
            
            liquidationTradeSalesControllerObj.selectedMonth = 1; 
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Naraya';
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.onMonthChange();
            //bh
            Test.stopTest(); 
        
        }
        
        
    }// end of the function testupdatePermissionRM
    
    
    @isTest
    static void testupdatePermissionRM1(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        

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
            
            
           
            
        
        System.runAs(u1){
            Test.startTest();
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
                Month__c = 'Jun',                               // Month
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj; 
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Month__c = 'Jun',                               // Month
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
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
            
            
            
            
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.isRM = True;
           // liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.createCropLiquidation();
                
            liquidationTradeSalesControllerObj.selectedMonth = 4;
            liquidationTradeSalesControllerObj.OnchangeTeritirry();
            RollupTradeSalesLiquidation_SWAL obj = new RollupTradeSalesLiquidation_SWAL();
            List<Liquidation_Annual_Plan__c> liquAPlanList = new List<Liquidation_Annual_Plan__c>();
            liquAPlanList.add(liqannlPlnObj);
            obj.rollupCropLiquidationDetails(liquAPlanList, 'Jun');
            
            liquidationTradeSalesControllerObj.selectedMonth=6;
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            
            liquidationTradeSalesControllerObj.selectedMonth = 1; 
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Naraya';
            liquidationTradeSalesControllerObj.onMonthChange();
            Test.stopTest();
        }
        
        
    }// end of the function testupdatePermissionRM1
    
    //this is for ZH
    @isTest
    static void testupdatePermissionZH1(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        

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
                ZonalHead__c = u3.Id,  // Zonal Head
                SBUCode__c = SBUObj.Id,
                ZMMUser__c = u3.Id       
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
           // territoryObj.Region__c = regionObj.id;
            //territoryObj.TerritoryManager__c = u.Id;
            territoryObj.Zone__c = zoneObj.id;
           // territoryObj.SBU__c = SBUObj.Id;
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
            
        System.runAs(u3){
            Test.startTest();
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
                Opening_Inventory__c = 1230,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 123,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = true, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 0 ,
                												// YTD Sales
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
                submitted_Trade_SWAL__c =true
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
                Retailers_Inventory__c = 1230,                      // Retailers Inventory
                Distributors_Inventory__c = 1230,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_Trade_SWAL__c =true
            );
            insert sobj; 
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Month__c = 'Apr',                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 0,                       // Plan for the month
                Retailers_Inventory__c = 210,                      // Retailers Inventory
                Distributors_Inventory__c = 2130,
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_Trade_SWAL__c =true
            );
            insert sobj; 
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
            }
            update updateList;
        
            //data for Crop Liquidation
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
            //Added by Varun Shrivastava End
            
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.selectedMonth = 4;
            liquidationTradeSalesControllerObj.onMonthChange();
            
            liquidationTradeSalesControllerObj.OnchangeTeritirry();
            liquidationTradeSalesControllerObj.createCropLiquidation();
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj1 = new LiquidationTradeSalesController_SWAL ();
            liquidationTradeSalesControllerObj.selectedTeritorry = 'All';
            
            liquidationTradeSalesControllerObj.selectedMonth=5;
            //liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            Test.stopTest();
            liquidationTradeSalesControllerObj1.OnchangeTeritirry();
            
            
            
            
        }
        
        
    }
    //Added by Varun Shrivastava start
    @isTest
    static void testtTradeSwalCropLiqudationFunctions(){
		Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c liq1;
        Liquidation2__c liq2;
        
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ){insertUser();}
        
        
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
        
        
        
        
        System.runAs(u){
            Test.startTest();
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
            System.debug('liqannlPlnObj test '+liqannlPlnObj.Sales_Org__r.Sales_Org_Code__c);
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 200,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 100 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 100,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = true, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 100 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            liq1 = new Liquidation2__c(
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
                submitted_Trade_SWAL__c =true
            );
            insert liq1; 
            
            liq2 = new Liquidation2__c(
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
                submitted_Trade_SWAL__c =true
            );
            insert liq2; 
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
                Liquidation__c = liq1.Id ,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 9.00,            // Liquidation Value
                is_Crop_Liquidation_Submitted__c = true,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj1;
            
            Crop_Liquidation__c crpLiqObj2 = new Crop_Liquidation__c(
                Crop__c = crpObj2.Id,            // Crop
                Liquidation__c = liq2.Id,       // Liquidation
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
            subCropLiquidation.Liquidation__c=liq1.Id;
            insert subCropLiquidation;
            
            Sub_Crop_Liquidation__c	subCropLiquidation2 = new Sub_Crop_Liquidation__c();
            subCropLiquidation2.Crop_Liquidation__c = crpLiqObj2.Id;
            subCropLiquidation2.Is_Sub_Crop_Liquidation_Submitted__c=false;
            subCropLiquidation2.Sales_Org__c= salesOrgObj.Id;
            subCropLiquidation2.Sub_Crop_Liquidation_Value__c=20;	
            subCropLiquidation2.Sub_Crops__c=subCrop2.ID;
            subCropLiquidation2.Liquidation__c=liq2.Id;
            insert subCropLiquidation2;
            //Added by Varun Shrivastava End
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.recordIdTotupdate = liq1.id;
            liquidationTradeSalesControllerObj.selectMonth=8;
            liquidationTradeSalesControllerObj.createCropLiquidation();
            
             liquidationTradeSalesControllerObj.selectedMonth=3;
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.onMonthChange();
            
            Test.stopTest();
            
            
         
        }
    }
    
    @isTest
    static void testtTradeSwalCropLiqudationFunctionsRM(){
		Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
        Territory_Distributor__c territoryObj;
        Sales_Org__c salesOrgObj;
        Product2 ProductObj;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        Opening_Inventory2__c openInveObj;
        Liquidation2__c liq1;
        Liquidation2__c liq2;
        
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ){insertUser();}
        
        
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
        //territoryObj.TerritoryManager__c = u.Id;
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
        
        
        
        
        System.runAs(u1){
            Test.startTest();
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
            System.debug('liqannlPlnObj test '+liqannlPlnObj.Sales_Org__r.Sales_Org_Code__c);
            
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 200,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 100 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            openInveObj = new Opening_Inventory2__c(
                Product__c = ProductObj.Id,                // Product
                Opening_Inventory__c = 100,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = true, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 100 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj;
            
            liq1 = new Liquidation2__c(
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
                submitted_Trade_SWAL__c =true
            );
            insert liq1; 
            
            liq2 = new Liquidation2__c(
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
                submitted_Trade_SWAL__c =true
            );
            insert liq2; 
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
                Liquidation__c = liq1.Id ,       // Liquidation
                Sales_Org__c = salesOrgObj.Id,         // Sales Org
                Liquidation_Value__c = 9.00,            // Liquidation Value
                is_Crop_Liquidation_Submitted__c = true,  // is Crop Liquidation Submitted
                Liquidation_YTD_Trade__c = 12330       // Liquidation YTD Trade
            );
            insert crpLiqObj1;
            
            Crop_Liquidation__c crpLiqObj2 = new Crop_Liquidation__c(
                Crop__c = crpObj2.Id,            // Crop
                Liquidation__c = liq2.Id,       // Liquidation
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
            subCropLiquidation.Liquidation__c=liq1.Id;
            insert subCropLiquidation;
            
            Sub_Crop_Liquidation__c	subCropLiquidation2 = new Sub_Crop_Liquidation__c();
            subCropLiquidation2.Crop_Liquidation__c = crpLiqObj2.Id;
            subCropLiquidation2.Is_Sub_Crop_Liquidation_Submitted__c=false;
            subCropLiquidation2.Sales_Org__c= salesOrgObj.Id;
            subCropLiquidation2.Sub_Crop_Liquidation_Value__c=20;	
            subCropLiquidation2.Sub_Crops__c=subCrop2.ID;
            subCropLiquidation2.Liquidation__c=liq2.Id;
            insert subCropLiquidation2;
            //Added by Varun Shrivastava End
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.recordIdTotupdate = liq1.id;
            liquidationTradeSalesControllerObj.selectMonth=8;
            liquidationTradeSalesControllerObj.selectedTeritorry = 'All';
            liquidationTradeSalesControllerObj.isRM=true;
           	RollupTradeSalesLiquidation_SWAL obj = new RollupTradeSalesLiquidation_SWAL();
            List<Liquidation_Annual_Plan__c> liquAPlanList = new List<Liquidation_Annual_Plan__c>();
            liquAPlanList.add(liqannlPlnObj);
         	obj.rollupCropLiquidationDetails(liquAPlanList, 'Aug');
            liquidationTradeSalesControllerObj.createCropLiquidation();
            liquidationTradeSalesControllerObj.isTM = false;
            liquidationTradeSalesControllerObj.isRM = True;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.selectedTeritorry = 'All';
            liquidationTradeSalesControllerObj.selectedMonth = 8;
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.createCropLiquidation();
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.createCropLiquidation();
            liquidationTradeSalesControllerObj.onMonthChange();//INC0187719
            
                
              liquidationTradeSalesControllerObj.isLiqSubmitted = False;
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayanon';
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.onMonthChange();
              liquidationTradeSalesControllerObj.selectedMonth=4;
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            
          
            Test.stopTest();
            
            
         
        }
    }
    
    //Added by Varun Shrivastava End
    
    // end of the function For ZH
    
    
    
    /*
    @isTest
    static void testupdatePermissionRM2(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        

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
            
            
           
            
        
        System.runAs(u1){
            Test.startTest();
             liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2021-2022',                     // FIscal Year
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
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            liquidationTradeSalesControllerObj.isRM = True;
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.selectedMonth = 4;
            liquidationTradeSalesControllerObj.OnchangeTeritirry();
            liquidationTradeSalesControllerObj.onMonthChange();
            Test.stopTest();
        }
        
        
    }// end of the function testupdatePermissionRM2 
    */
    
    @isTest//bh
    static void testupdatePermissionTM3(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
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
        territoryObj.Name = 'Narayangao';
        territoryObj.TerritoryCode__c = '394';
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
        
        Product2 ProductObj1 = new Product2(
            Name = 'PHOSKILL',          // Product Name
            ProductCode = '71450',                 // Product Code
            Product_Code__c = '71451',             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '7145010002011',  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 50.00                 // Budget NRV
        );
        insert ProductObj1;    
        
        
        
        System.runAs(u1){
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
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2022-2023',                     // FIscal Year//bh
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj;
            
            Liquidation_Annual_Plan__c liqannlPlnObj1 = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2020-2021',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2021,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj1;
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
            
            Opening_Inventory2__c openInveObj1 = new Opening_Inventory2__c(
                Product__c = ProductObj1.Id,                // Product
                Opening_Inventory__c = 12,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 100 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj1;
            
            
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj;
            
            Liquidation2__c sobj3 = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj1.Id,  // Liquidation Annual Plan
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj3; 
            
            
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
            //Added by Varun Shrivastava End
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            liquidationTradeSalesControllerObj.selectMonth=5;
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'May');
            
            liquidationTradeSalesControllerObj.isZH = True;
            liquidationTradeSalesControllerObj.selectedYear='2022-2023';
            liquidationTradeSalesControllerObj.onYearChange();
            
            liquidationTradeSalesControllerObj.selectedMonth=11;
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
            
            liquidationTradeSalesControllerObj.selectedMonth=2;
            liquidationTradeSalesControllerObj.onYearChange();
            liquidationTradeSalesControllerObj.loadDataForSelectedMonth(territoryObj.ID, liqannlPlnObj.Id);
                        
             liquidationTradeSalesControllerObj.selectedMonth=3;
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.updateData();
            
             liquidationTradeSalesControllerObj.selectedMonth=8;
            liquidationTradeSalesControllerObj.selectedYear='2021-2022';
            liquidationTradeSalesControllerObj.defaultMethod();
            liquidationTradeSalesControllerObj.createData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.loadAllData(territoryObj.ID, liqannlPlnObj.Id, 'Dec');
            liquidationTradeSalesControllerObj.updateData();
            
            liquidationTradeSalesControllerObj.isZH = False;
            liquidationTradeSalesControllerObj.defaultMethod();
            
            liquidationTradeSalesControllerObj.selectedTeritorry = 'Narayangaon';
            liquidationTradeSalesControllerObj.selectedMonth = 10;
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.onMonthChange();
        
            
            liquidationTradeSalesControllerObj.updateSingleRecordForCropLiquidation();
            
            liquidationTradeSalesControllerObj.selectedMonth=1;
             //liquidationTradeSalesControllerObj.loadDataForSelectedMonth('Naraya',liqannlPlnObj.Id);
            
            Test.stopTest();
        } 
    }
    
     @isTest//bh
    static void testupdatePermissionTM4(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        
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
        territoryObj.TerritoryCode__c = '394';
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
        
        Product2 ProductObj1 = new Product2(
            Name = 'PHOSKILL',          // Product Name
            ProductCode = '71450',                 // Product Code
            Product_Code__c = '71451',             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '7145010002011',  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 50.00                 // Budget NRV
        );
        insert ProductObj1;    
        
        
        
        System.runAs(u1){
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
            liqannlPlnObj = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2022-2023',                     // FIscal Year//bh
                Fiscal_End_Date__c = Date.newInstance(2022,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj;
            
            Liquidation_Annual_Plan__c liqannlPlnObj1 = new Liquidation_Annual_Plan__c(
                Fiscal_Start_Date__c = Date.newInstance(2020, 04, 01),// Fiscal Start Date
                FIscal_Year__c = '2020-2021',                     // FIscal Year
                Fiscal_End_Date__c = Date.newInstance(2021,03, 31),   // Fiscal End Date
                SentToBatch__c = false,                           // Sent To Batch
                Territory_Name__c = territoryObj.Id,                            // State
                RecordTypeId = rtforAnnualPlan,
                Sales_Org__c = salesOrgObj.id
            );
            insert liqannlPlnObj1;
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
            
            Opening_Inventory2__c openInveObj1 = new Opening_Inventory2__c(
                Product__c = ProductObj1.Id,                // Product
                Opening_Inventory__c = 12,                        // Opening Inventory
                Liquidation_Annual_Plan__c = liqannlPlnObj.id,  // Liquidation Annual Plan
                X15_days_lock__c = false, 
                Territory__c = territoryObj.Id,                    // State
                YTD_Sales__c = 100 ,                               // YTD Sales
                RecordTypeId = rtforOpeningInventory
            );
            insert openInveObj1;
            
            
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj;
            
            Liquidation2__c sobj3 = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj1.Id,  // Liquidation Annual Plan
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
                submitted_Trade_SWAL__c =true
            );
            insert sobj3; 
            
            
             List<Liquidation2__c> updateList = [Select id,Fixed_YTD_Sales__c,Liquidation_YTD_SWAL__c from Liquidation2__c];
            for(integer i =0;i<updateList.size();i++){
                updateList[i].Fixed_YTD_Sales__c = updateList[i].Liquidation_YTD_SWAL__c;
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
            //Added by Varun Shrivastava End
            
            LiquidationTradeSalesController_SWAL  liquidationTradeSalesControllerObj = new LiquidationTradeSalesController_SWAL ();
            
            liquidationTradeSalesControllerObj.isZH = True;
            liquidationTradeSalesControllerObj.selectedMonth = 12;
            liquidationTradeSalesControllerObj.selectedYear = '2021-2022';
            liquidationTradeSalesControllerObj.onMonthChange();
            Test.stopTest();
        } 
    }
    
    
    
    
}