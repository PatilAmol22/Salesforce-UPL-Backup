@isTest
public class Grz_LiquidationClassNewTest {
    Public  static testmethod void testLiquidationRecord(){
        Id rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Id rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Test.startTest();
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000' // Sales Org Code
        );
        insert salesOrgObj;
        
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
            MobilePhone = '8888888888' //Sayan CHG0030762
            //  UserRoleId =  ur.Id
        );  
        insert u;
        
        
        // UserRole ur2 = new UserRole(Name = 'Zonal Head Indore');
        //  insert ur2;
        User u2 = new User(
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
        User u3 = new User(
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
        User u4 = new User(
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
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
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
        //System.runAs(u){
        Liquidation_Annual_Plan__c liqannlPlnObj = new Liquidation_Annual_Plan__c(
            Fiscal_Start_Date__c = Date.newInstance(2019, 04, 01),// Fiscal Start Date
            FIscal_Year__c = '2019-2020',                     // FIscal Year
            Fiscal_End_Date__c = Date.newInstance(2020,03, 31),   // Fiscal End Date
            SentToBatch__c = false,                           // Sent To Batch
            Territory_Name__c = territoryObj.Id,                            // State
            RecordTypeId = rtforAnnualPlan,
            Sales_Org__c = salesOrgObj.id
            
            
        );
        insert liqannlPlnObj;
        Multi_Country_Liquidation__c mcl = new Multi_Country_Liquidation__c();
        mcl.Name='Test';
        mcl.Country__c='India';
        mcl.Edit_Start_Day__c=01/04/2020;
        mcl.Edit_End_Day__c=01/04/2021;
        mcl.Month__c = 'December';
        mcl.Type__c='Liquidation';
        
        insert mcl;
        
        Multi_Country_Liquidation__c mcl1 = new Multi_Country_Liquidation__c();
        mcl1.Name='Test';
        mcl1.Country__c='India';
        mcl1.Edit_Start_Day__c=01/04/2020;
        mcl1.Edit_End_Day__c=01/04/2021;
           mcl1.Month__c = 'December';
        mcl1.Type__c='Opening Inventory';        
        insert mcl1;
        
        Opening_Inventory2__c openInveObj = new Opening_Inventory2__c(
            
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
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'LiquidationTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        SKU__c sku = new SKU__c();
        sku.Name = 'Test SKU';
        sku.Sales_Org__c = salesOrgObj.Id;
        sku.Active_For_Liquidation__c = true;
        sku.SKU_Code__c = '000000000006305735';
        insert sku;
        
        Liquidation2__c sobj = new Liquidation2__c(
            Opening_Inventory2__c = openInveObj.id,     // Opening Inventory2
            Liquidation_Annual_Plan__c = liqannlPlnObj.Id,  // Liquidation Annual Plan
            SKU__c = sku.Id,
            //Type__c = 'Multi Country',                                // Type
            Month__c = 'Nov',                               // Month
            Liquidation__c = 0,                              // Liquidation
            Plan_for_the_month__c = 0,                       // Plan for the month
            Retailers_Inventory__c = 0,                      // Retailers Inventory
            Distributors_Inventory__c = 0,                   // Distributors Inventory
            Plan_for_the_next_month__c = 0,                  // Plan for the next month
            Territory__c = territoryObj.Id,                           // State
            RecordTypeId = rtforLiquidation,
            submitted_trade__c = true,
            submitted__c = true
        );
        insert sobj;
       
        system.debug('Liquidation2__c : '+sobj);
        
        
        
        List<Grz_LiquidationClassNew.ResultWrapper> resultlist = new List<Grz_LiquidationClassNew.ResultWrapper>();
        Grz_LiquidationClassNew.ResultWrapper resultobj = new Grz_LiquidationClassNew.ResultWrapper();
        //resultobj.Id = '01t1a000101NrtY';
        resultobj.Id = sobj.Id;
        resultobj.SKU_Code = 'abc';
        resultobj.BrandName = 'abc';
        resultobj.OpeningInventory = 10; 
        resultobj.YTDSales = 10;
        resultobj.TotalAvailablestock = 10;
        resultobj.DistributorsInventory = 10;
        resultobj.RetailersInventory = 10;
        resultobj.TotalMarketInventory = 10; 
        resultobj.PlanYTDmonth = 10;
        resultobj.ProductBudget = 10;
        resultobj.LiquidationYTDmonth = 10;
        resultobj.LiquidationYTDmonthpercentage = 10;
        resultobj.yeardata = new List<String>{'2021'};
            resultlist.add(resultobj);
        Test.stopTest();     
        Grz_LiquidationClassNew objliqui = new Grz_LiquidationClassNew();
        Grz_LiquidationClassNew.getLiquidationRecord(123,'','2019-2020','Nov');
        Grz_LiquidationClassNew.getLiquidationRecord(89,'test','2019-2020','Nov');
        Grz_LiquidationClassNew.updateDistributorInventory(sobj.Id,'10');
        Grz_LiquidationClassNew.updateRetailerInventory(sobj.Id,'10');
        Grz_LiquidationClassNew.updateOpeningInventory(openInveObj.Id,'100');
        Grz_LiquidationClassNew.updateSubmit(resultlist);
        Grz_LiquidationClassNew.getMonths(true);
        
        
    } 
}