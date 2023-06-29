@isTest
public class CropLiquidationApproval_Test {
    public static User u; //TM
    public static User u2; // ZH
    public static User u3; // SBU
    public static User u4; 
    
    public static void insertUser() {    
        
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'LiquidationTrigger';
        newtri.isActive__c = false;
        insert newtri;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
            
            LastName = 'lastu1',
            Email = 'puser000@test.com',
            Username = 'puser000@test.com' + System.currentTimeMillis(),
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
            
            LastName = 'lastu2',
            Email = 'puser0002@ibm.com',
            Username = 'puser0002@ibm.com' + System.currentTimeMillis(),
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
            LastName = 'lastu3',
            Email = 'puser003@a.com',
            Username = 'puser0003@a.com' + System.currentTimeMillis(),
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
        
        // UserRole ur4 = new UserRole(Name = 'Zonal Commercial Executive Pune'); Zonal Marketing Manager
        // insert ur4;
        u4 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Zonal Marketing Manager' OR Name = 'SBU Profile'].Id,
            LastName = 'lastu4',
            Email = 'puser004@testt.com',
            Username = 'puser0004@test.com' + System.currentTimeMillis(),
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
        
    }
    
    @isTest
    static void getTerritories(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        
        Integer intMonth = Date.Today().month();
        if(intMonth == 1){ intMonth = 12;
                         }else{
                             intMonth =intMonth-1;
                         }
        Map<Integer,String> monthMap = new Map<Integer,String>();
        monthMap.put(4,'Apr');
        monthMap.put(5,'May');
        monthMap.put(6,'Jun');
        monthMap.put(7,'Jul');
        monthMap.put(8,'Aug');
        monthMap.put(9,'Sept');
        monthMap.put(10,'Oct');
        monthMap.put(11,'Nov');
        monthMap.put(12,'Dec');
        monthMap.put(1,'Jan');
        monthMap.put(2,'Feb');
        monthMap.put(3,'Mar');
        
        String monthFY;
        monthFY = monthMap.get(intMonth);
        system.debug('*monthFY :'  +monthFY);
        
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
        
        
        Territory_Distributor__c displayT = [select id, name,Sales_Org_Code__c,TerritoryManager__c,Zonal_Manager_Id__c,Zonal_Marketing_Manager_1_Id__c from Territory_Distributor__c];
        system.debug('**display Territory' +displayT);
        list<Territory_Distributor__c> listTerritory = new list<Territory_Distributor__c>();
        string month;
        id userId;
        userId =UserInfo.getUserId();
        //user usr = [ select Id from User where Id = :u2.Id];
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
            
            
            sobj = new Liquidation2__c(
                Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
                Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
                Product__c = ProductObj.Id,                  // Product
                Type__c = 'Trade',                                // Type
                Month__c = monthFY,                               // Month
                Liquidation__c = 0,                              // Liquidation
                Plan_for_the_month__c = 123320,                       // Plan for the month
                Retailers_Inventory__c = 0,                      // Retailers Inventory
                Distributors_Inventory__c = 0,                   // Distributors Inventory
                Plan_for_the_next_month__c = 0,                  // Plan for the next month
                Territory__c = territoryObj.Id,                           // State
                RecordTypeId = rtforLiquidation,
                submitted_trade__c = true
            );
            insert sobj; 
            
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
                Liquidation_YTD_Trade__c = 123320       // Liquidation YTD Trade
            );
            insert crpLiqObj1;
            
        }
        
        id cropLiquiId;
        id prodLId;
        Crop_Liquidation__c crplist=[select id,name,Liquidation__r.Product__c from Crop_Liquidation__c limit 1];
        system.debug('$$croplist : ' +crplist); 
        cropLiquiId=crplist.id;
        system.debug('$$cropLiquiId : ' +cropLiquiId); 
        Product2 prodlist = [select id,name from Product2];
        prodLId= prodlist.id;
        system.debug('$$prodlist : ' +prodlist); 
        system.debug('$$prodLId : ' +prodLId); 
        list<Crop__c> croplists = new list<Crop__c> ();
        croplists = [Select Id,Name FROM Crop__c ];
        system.debug('**croplists : ' +croplists);
        
        
        Territory_Distributor__c cropT = [select id, name,Sales_Org_Code__c,TerritoryManager__c,Zonal_Manager_Id__c,Zonal_Marketing_Manager_1_Id__c from Territory_Distributor__c limit 1];
        string tid;
        tid=territoryObj.id;
        Liquidation_Annual_Plan__c lap = [select id,name,FIscal_Year__c,Territory_Name__c from Liquidation_Annual_Plan__c where Territory_Name__c=:tid and FIscal_Year__c='2021-2022'];
        Liquidation2__c liquilist = [select id,name, Liquidation_YTD_Trade__c,Opening_Inventory2__r.Opening_Inventory__c ,Total_Available_Stock__c , Total_Market_Inventory__c , Distributors_Inventory__c,Retailers_Inventory__c from Liquidation2__c];
        system.debug('##Territory Id for crop : '+tid);
        system.debug('##lap for crop : '+lap);
        system.debug('##liquilist for crop : '+liquilist);
        CropLiquidationApprovalController croptest = new CropLiquidationApprovalController();
        croptest.TerritoryIds=tid;
        croptest.cropFY='2021-2022';
        croptest.cropMonth=monthFY;
        croptest.defaultMethod();
        croptest.updateSingleRecordForCropLiquidations();
        croptest.recordIdTotupdate=cropLiquiId;
        croptest.prodIdTotupdate=prodLId;
        croptest.valueToupdate='20';
        
    }
}