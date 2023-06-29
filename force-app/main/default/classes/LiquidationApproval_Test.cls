@isTest
public class LiquidationApproval_Test {
   
    public static User u; //TM
    public static User u2; // ZH
    public static User u3; // SBU
    public static User u4; 
    
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
        
        Trigger_Settings__c record1 = new Trigger_Settings__c();
        record1.Name = 'LiquidationApprovalTrigger';
        record1.IsActive__c	= true;
        insert record1;
        
        
    }
    

public static void insertUser() {       
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
        List<Liquidation2__c> newLiq = new List<Liquidation2__c>();
        List<Liquidation2__c> LiqList = new List<Liquidation2__c>();
        List<Liquidation2__c> insertedLiq = new List<Liquidation2__c>();
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
        Product2 ProductObj1;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        //Opening_Inventory2__c openInveObj;
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
		
		 List<Product2> prodList = new List<Product2>();
        for( integer i=0;i<=3;i++ ){
        ProductObj = new Product2(
            Name = 'Product'+i,          // Product Name
            ProductCode = '71450' +i,                 // Product Code
            Product_Code__c = '71450' +i,             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '7145010002010'+i,  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 50.00                 // Budget NRV
        );
		prodList.add(ProductObj);
		}
        insert prodList; 
        
     
        
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
			
			List<Opening_Inventory2__c> openinvList = new List<Opening_Inventory2__c>();
        Integer i = 0;
        for( Product2 v:prodList ){
            Opening_Inventory2__c openInveObj = new Opening_Inventory2__c();
            openInveObj.Product__c = v.Id;
            openInveObj.Opening_Inventory__c = i+56;
            openInveObj.Liquidation_Annual_Plan__c = liqannlPlnObj.id;
            openInveObj.X15_days_lock__c = false;
            openInveObj.Territory__c = territoryObj.Id;
            openInveObj.YTD_Sales__c = i;
            openInveObj.YTD_Sales_Jan__c = i+10;
            openInveObj.YTD_Sales_Feb__c = i+10;
            openInveObj.YTD_Sales_Mar__c = i;
            openInveObj.YTD_Sales_Apr__c = i+10;
            openInveObj.YTD_Sales_May__c = i+10;
            openInveObj.YTD_Sales_Jun__c = i+10;
            openInveObj.YTD_Sales_Jul__c = i+10;
            openInveObj.YTD_Sales_Aug__c = i+10;
            openInveObj.YTD_Sales_Sept__c = i+10;
            openInveObj.YTD_Sales_Oct__c = i+10;
            openInveObj.YTD_Sales_Nov__c = i+10;
            openInveObj.YTD_Sales_Dec__c = i+10;
            openInveObj.RecordTypeId = rtforOpeningInventory;
            i+=10;
            openinvList.add(openInveObj);
        }
        insert openinvList;
			
             
        Integer j=0;
        for( Opening_Inventory2__c v:openinvList ){
            Liquidation2__c liq = new Liquidation2__c();
            liq.Opening_Inventory2__c = v.id;
            liq.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
            liq.Product__c = v.Product__c;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Mar';
            liq.Liquidation__c = j;
            liq.Plan_for_the_month__c = j;
            liq.Retailers_Inventory__c = j+3;
            liq.Distributors_Inventory__c = j+2;
            liq.Plan_for_the_next_month__c = j;
            liq.Territory__c = territoryObj.Id;
            liq.RecordTypeId = rtforLiquidation;
            liq.submitted_trade__c =true;
            j+=10;
            LiqList.add(liq);
        }
        insert LiqList;
		
            List<Crop__c> CropList = new List<Crop__c>();
        Crop__c crpObj = new Crop__c();
        crpObj.Name = 'Cereals';
        crpObj.Crop_Code__c = 'CL001';            
        crpObj.Active__c = true;
        crpObj.SalesOrg__c = salesOrgObj.Id;
        crpObj.Type__c = 'Crop';
        crpObj.Active_for_Crop_Liquidation__c = true;
        CropList.add(crpObj);
        
        Crop__c crpObj2 = new Crop__c();
        crpObj2.Name = 'Oilseeds';
        crpObj2.Crop_Code__c = 'OL003';            
        crpObj2.Active__c = true;
        crpObj2.SalesOrg__c = salesOrgObj.Id;
        crpObj2.Type__c = 'Crop';
        crpObj2.Active_for_Crop_Liquidation__c = true;
        CropList.add(crpObj2);
        
        insert CropList;
                               
        insertedLiq = [ SELECT Id,Liquidation_YTD_Trade__c FROM Liquidation2__c WHERE Id IN:LiqList LIMIT 2];
        for( Liquidation2__c vg:insertedLiq ){
            system.debug('Sayan-->'+vg.Id+'---'+vg.Liquidation_YTD_Trade__c);
        }
        List<Crop_Liquidation__c> CropLiqList = new List<Crop_Liquidation__c>();
        for( Liquidation2__c k:insertedLiq ){
            for( Crop__c c:CropList ){
                Crop_Liquidation__c crpLiqObj = new Crop_Liquidation__c();
                crpLiqObj.Crop__c = c.Id;
                crpLiqObj.Liquidation__c = k.Id;
                crpLiqObj.Sales_Org__c = salesOrgObj.Id;
                crpLiqObj.Liquidation_Value__c = 0.0;
                crpLiqObj.is_Crop_Liquidation_Submitted__c = true;
                crpLiqObj.Liquidation_YTD_Trade__c = k.Liquidation_YTD_Trade__c;
                CropLiqList.add(crpLiqObj);
            }
        }
        insert CropLiqList;
             
             Opening_Inventory2__c openInveObj2 = new Opening_Inventory2__c();
        openInveObj2.Product__c = prodList[0].Id;
        openInveObj2.Opening_Inventory__c = 600;
        openInveObj2.Liquidation_Annual_Plan__c = liqannlPlnObj.id;
        openInveObj2.X15_days_lock__c = false;
        openInveObj2.Territory__c = territoryObj.Id;
        openInveObj2.YTD_Sales__c = 50;
        openInveObj2.YTD_Sales_Jan__c = 100;
        openInveObj2.YTD_Sales_Feb__c = 100;
        openInveObj2.YTD_Sales_Mar__c = 100;
        openInveObj2.YTD_Sales_Apr__c = 100;
        openInveObj2.YTD_Sales_May__c = 100;
        openInveObj2.YTD_Sales_Jun__c = 100;
        openInveObj2.YTD_Sales_Jul__c = 100;
        openInveObj2.YTD_Sales_Aug__c = 100;
        openInveObj2.YTD_Sales_Sept__c = 100;
        openInveObj2.YTD_Sales_Oct__c = 100;
        openInveObj2.YTD_Sales_Nov__c = 100;
        openInveObj2.YTD_Sales_Dec__c = 100;
        openInveObj2.RecordTypeId = rtforOpeningInventory;
        insert openInveObj2;
        
        
        Liquidation2__c liq = new Liquidation2__c();
        liq.Opening_Inventory2__c = openInveObj2.id;
        liq.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq.Product__c = prodList[0].Id;
        liq.Type__c = 'Trade';
        liq.Month__c = 'Mar';
        liq.Liquidation__c = 10;
        liq.Plan_for_the_month__c = 10;
        liq.Retailers_Inventory__c = 3;
        liq.Distributors_Inventory__c = 2;
        liq.Plan_for_the_next_month__c = 10;
        liq.Territory__c = territoryObj.Id;
        liq.RecordTypeId = rtforLiquidation;
        liq.submitted_trade__c =true;
        insert liq;
             
             
        Liquidation2__c liq2 = new Liquidation2__c();
        liq2.Opening_Inventory2__c = openInveObj2.id;
        liq2.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq2.Product__c = prodList[0].Id;
        liq2.Type__c = 'Trade';
        liq2.Month__c = 'May';
        liq2.Liquidation__c = 10;
        liq2.Plan_for_the_month__c = 10;
        liq2.Retailers_Inventory__c = 3;
        liq2.Distributors_Inventory__c = 2;
        liq2.Plan_for_the_next_month__c = 10;
        liq2.Territory__c = territoryObj.Id;
        liq2.RecordTypeId = rtforLiquidation;
        liq2.submitted_trade__c =true;
        insert liq2;
             
        Liquidation2__c liq3 = new Liquidation2__c();
        liq3.Opening_Inventory2__c = openInveObj2.id;
        liq3.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq3.Product__c = prodList[0].Id;
        liq3.Type__c = 'Trade';
        liq3.Month__c = 'Jun';
        liq3.Liquidation__c = 10;
        liq3.Plan_for_the_month__c = 10;
        liq3.Retailers_Inventory__c = 3;
        liq3.Distributors_Inventory__c = 2;
        liq3.Plan_for_the_next_month__c = 10;
        liq3.Territory__c = territoryObj.Id;
        liq3.RecordTypeId = rtforLiquidation;
        liq3.submitted_trade__c =true;
        insert liq3;
        newLiq.add(liq);
            
             
             Liquidation_Approval_History__c newApprovalInstance = new Liquidation_Approval_History__c();
                    newApprovalInstance.Territory__c = territoryObj.Id;
                    newApprovalInstance.Month__c = monthFY;
                    //newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance.SalesOrg__c = salesOrgObj.Id;
                    newApprovalInstance.LAP__c = liqannlPlnObj.Id;
                    newApprovalInstance.Territory_Manager_Email__c = 'test@t.com';
                    insert newApprovalInstance;
             
             Liquidation_Approval_History__c newApprovalInstance1 = new Liquidation_Approval_History__c();
                    newApprovalInstance1.Territory__c = territoryObj.Id;
                    newApprovalInstance1.Month__c = 'May';
                    //newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance1.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance1.SalesOrg__c = salesOrgObj.Id;
                    newApprovalInstance1.LAP__c = liqannlPlnObj.Id;
                    newApprovalInstance1.Territory_Manager_Email__c = 'test@t.com';
                    insert newApprovalInstance1;
             
             Liquidation_Approval_History__c newApprovalInstance2 = new Liquidation_Approval_History__c();
                    newApprovalInstance2.Territory__c = territoryObj.Id;
                    newApprovalInstance2.Month__c = 'Jun';
                    //newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance2.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance2.SalesOrg__c = salesOrgObj.Id;
                    newApprovalInstance2.LAP__c = liqannlPlnObj.Id;
                    newApprovalInstance2.Territory_Manager_Email__c = 'test@t.com';
                    insert newApprovalInstance2;
             
                    system.debug('**newApprovalInstance : ' +newApprovalInstance); 
         }
        
        string fy;
        String perf; 
        String com='test';
        Boolean UpdationStat =true;
        Decimal planNextM = 10;
        String FieldD='Distributors_Inventory__c';
        String FieldR='Retailers_Inventory__c';
        string fieldPlan = 'Plan_for_the_next_month__c';
        string fieldOpenInv = 'Opening_Inventory__c';
      
        Test.startTest();
        System.runAs(u4){
   
        Territory_Distributor__c tc = [select id, name,Sales_Org_Code__c,TerritoryManager__c,Zonal_Manager_Id__c,Zonal_Marketing_Manager_1_Id__c from Territory_Distributor__c limit 1];
             //string tcid =  tc.id;

            String URL = system.URL.getSalesforceBaseUrl().toExternalForm();
            LiquidationApprovalController tstobj = new LiquidationApprovalController();
            listTerritory =LiquidationApprovalController.getTerritories();
            month = LiquidationApprovalController.getMonth();
            fy = LiquidationApprovalController.getFYData();
            LiquidationApprovalController.getPageURL();
            LiquidationApprovalController.getliquidation(tc.id,fy,month);
            LiquidationApprovalController.liquiApprove(tc.id,fy,month,com);
            //LiquidationApprovalController.liquiReject(tc.id,fy,month,com);
            LiquidationApprovalController.getAlreadyApprovedRecord(tc.id,fy,month);
            LiquidationApprovalController.liquiUpdate(LiqList,tc.id,fy,month,UpdationStat);
			LiquidationApprovalController.liquiUpdate(LiqList,tc.id,fy,month,false);
			LiquidationApprovalController.Validation( tc.id,fy,month,insertedLiq[0].Id,FieldD,500 );
            LiquidationApprovalController.Validation( tc.id,fy,month,insertedLiq[0].Id,FieldD,2 );
            LiquidationApprovalController.Validation( tc.id,fy,month,insertedLiq[0].Id,FieldR,500 );
            LiquidationApprovalController.Validation( tc.id,fy,month,insertedLiq[0].Id,FieldR,2 );
            LiquidationApprovalController.normalUpdate(LiqList[0].Id,planNextM,tc.id,fy,month);
			LiquidationApprovalController.UpdateNullValueAsZero(tc.id,fy,month,FieldR,LiqList[0].Id);
            LiquidationApprovalController.UpdateNullValueAsZero(tc.id,fy,month,FieldD,LiqList[0].Id);
            LiquidationApprovalController.UpdateNullValueAsZero(tc.id,fy,month,fieldOpenInv,LiqList[0].Id);
            LiquidationApprovalController.UpdateNullValueAsZero(tc.id,fy,month,fieldPlan,LiqList[0].Id); 
            //LiquidationApprovalController.UpdateCropRecords(newLiq,tc.id,fy,month);
            //LiquidationApprovalController.OpenInventoryUpdate(LiqList[0].Id,OpenInventory,tc.id,fy,month);
            //LiquidationApprovalController.CreateCropandSubCropforMissingProducts(ProductIdsToCreateRecords,tc.id,month,fy); 
            
        }
        Test.stopTest();
    
    }
    
    @isTest
    static void checkOtherCoverage(){
        List<Liquidation2__c> newLiq = new List<Liquidation2__c>();
        List<Liquidation2__c> LiqList = new List<Liquidation2__c>();
        List<Liquidation2__c> insertedLiq = new List<Liquidation2__c>();
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
        Product2 ProductObj1;
        Liquidation_Annual_Plan__c liqannlPlnObj;
        //Opening_Inventory2__c openInveObj;
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
		
		 List<Product2> prodList = new List<Product2>();
        	List<Opening_Inventory2__c> openinvList = new List<Opening_Inventory2__c>();
        
        for( integer i=0;i<=3;i++ ){
        ProductObj = new Product2(
            Name = 'Product'+i,          // Product Name
            ProductCode = '71450' +i,                 // Product Code
            Product_Code__c = '71450' +i,             // Product Code
            IsActive = true,                       // Active
            Active__c = true,                      // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '7145010002010'+i,  // Combination Key
            Popular__c = false,                    // Popular
            Brand_Type__c = 'Power Brand',         // Brand Type
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = true,      // Active For Liquidation
            Indication_Type__c = 'Insecticide',    // Indication Type
            Budget_NRV__c = 50.00                 // Budget NRV
        );
		prodList.add(ProductObj);
		}
        insert prodList; 
        
     
        
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
			
		Integer i = 0;
        for( Product2 v:prodList ){
            Opening_Inventory2__c openInveObj = new Opening_Inventory2__c();
            openInveObj.Product__c = v.Id;
            openInveObj.Opening_Inventory__c = i+56;
            openInveObj.Liquidation_Annual_Plan__c = liqannlPlnObj.id;
            openInveObj.X15_days_lock__c = false;
            openInveObj.Territory__c = territoryObj.Id;
            openInveObj.YTD_Sales__c = i;
            openInveObj.YTD_Sales_Jan__c = i+10;
            openInveObj.YTD_Sales_Feb__c = i+10;
            openInveObj.YTD_Sales_Mar__c = i;
            openInveObj.YTD_Sales_Apr__c = i+10;
            openInveObj.YTD_Sales_May__c = i+10;
            openInveObj.YTD_Sales_Jun__c = i+10;
            openInveObj.YTD_Sales_Jul__c = i+10;
            openInveObj.YTD_Sales_Aug__c = i+10;
            openInveObj.YTD_Sales_Sept__c = i+10;
            openInveObj.YTD_Sales_Oct__c = i+10;
            openInveObj.YTD_Sales_Nov__c = i+10;
            openInveObj.YTD_Sales_Dec__c = i+10;
            openInveObj.RecordTypeId = rtforOpeningInventory;
            i+=10;
            openinvList.add(openInveObj);
        }
        insert openinvList;
			
             
        Integer j=0;
        for( Opening_Inventory2__c v:openinvList ){
            Liquidation2__c liq = new Liquidation2__c();
            liq.Opening_Inventory2__c = v.id;
            liq.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
            liq.Product__c = v.Product__c;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Mar';
            liq.Liquidation__c = j;
            liq.Plan_for_the_month__c = j;
            liq.Retailers_Inventory__c = j+3;
            liq.Distributors_Inventory__c = j+2;
            liq.Plan_for_the_next_month__c = j;
            liq.Territory__c = territoryObj.Id;
            liq.RecordTypeId = rtforLiquidation;
            liq.submitted_trade__c =true;
            j+=10;
            LiqList.add(liq);
        }
        insert LiqList;
		
            List<Crop__c> CropList = new List<Crop__c>();
        Crop__c crpObj = new Crop__c();
        crpObj.Name = 'Cereals';
        crpObj.Crop_Code__c = 'CL001';            
        crpObj.Active__c = true;
        crpObj.SalesOrg__c = salesOrgObj.Id;
        crpObj.Type__c = 'Crop';
        crpObj.Active_for_Crop_Liquidation__c = true;
        CropList.add(crpObj);
        
        Crop__c crpObj2 = new Crop__c();
        crpObj2.Name = 'Oilseeds';
        crpObj2.Crop_Code__c = 'OL003';            
        crpObj2.Active__c = true;
        crpObj2.SalesOrg__c = salesOrgObj.Id;
        crpObj2.Type__c = 'Crop';
        crpObj2.Active_for_Crop_Liquidation__c = true;
        CropList.add(crpObj2);
        
        insert CropList;
                               
        insertedLiq = [ SELECT Id,Liquidation_YTD_Trade__c FROM Liquidation2__c WHERE Id IN:LiqList LIMIT 2];
        for( Liquidation2__c vg:insertedLiq ){
            system.debug('Sayan-->'+vg.Id+'---'+vg.Liquidation_YTD_Trade__c);
        }
        List<Crop_Liquidation__c> CropLiqList = new List<Crop_Liquidation__c>();
        for( Liquidation2__c k:insertedLiq ){
            for( Crop__c c:CropList ){
                Crop_Liquidation__c crpLiqObj = new Crop_Liquidation__c();
                crpLiqObj.Crop__c = c.Id;
                crpLiqObj.Liquidation__c = k.Id;
                crpLiqObj.Sales_Org__c = salesOrgObj.Id;
                crpLiqObj.Liquidation_Value__c = 0.0;
                crpLiqObj.is_Crop_Liquidation_Submitted__c = true;
                crpLiqObj.Liquidation_YTD_Trade__c = k.Liquidation_YTD_Trade__c;
                CropLiqList.add(crpLiqObj);
            }
        }
        insert CropLiqList;
             
             Opening_Inventory2__c openInveObj2 = new Opening_Inventory2__c();
        openInveObj2.Product__c = prodList[0].Id;
        openInveObj2.Opening_Inventory__c = 600;
        openInveObj2.Liquidation_Annual_Plan__c = liqannlPlnObj.id;
        openInveObj2.X15_days_lock__c = false;
        openInveObj2.Territory__c = territoryObj.Id;
        openInveObj2.YTD_Sales__c = 50;
        openInveObj2.YTD_Sales_Jan__c = 100;
        openInveObj2.YTD_Sales_Feb__c = 100;
        openInveObj2.YTD_Sales_Mar__c = 100;
        openInveObj2.YTD_Sales_Apr__c = 100;
        openInveObj2.YTD_Sales_May__c = 100;
        openInveObj2.YTD_Sales_Jun__c = 100;
        openInveObj2.YTD_Sales_Jul__c = 100;
        openInveObj2.YTD_Sales_Aug__c = 100;
        openInveObj2.YTD_Sales_Sept__c = 100;
        openInveObj2.YTD_Sales_Oct__c = 100;
        openInveObj2.YTD_Sales_Nov__c = 100;
        openInveObj2.YTD_Sales_Dec__c = 100;
        openInveObj2.RecordTypeId = rtforOpeningInventory;
        insert openInveObj2;
        
        
        Liquidation2__c liq = new Liquidation2__c();
        liq.Opening_Inventory2__c = openInveObj2.id;
        liq.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq.Product__c = prodList[0].Id;
        liq.Type__c = 'Trade';
        liq.Month__c = 'Mar';
        liq.Liquidation__c = 10;
        liq.Plan_for_the_month__c = 10;
        liq.Retailers_Inventory__c = 3;
        liq.Distributors_Inventory__c = 2;
        liq.Plan_for_the_next_month__c = 10;
        liq.Territory__c = territoryObj.Id;
        liq.RecordTypeId = rtforLiquidation;
        liq.submitted_trade__c =true;
        insert liq;
             
             
        Liquidation2__c liq2 = new Liquidation2__c();
        liq2.Opening_Inventory2__c = openInveObj2.id;
        liq2.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq2.Product__c = prodList[0].Id;
        liq2.Type__c = 'Trade';
        liq2.Month__c = 'May';
        liq2.Liquidation__c = 10;
        liq2.Plan_for_the_month__c = 10;
        liq2.Retailers_Inventory__c = 3;
        liq2.Distributors_Inventory__c = 2;
        liq2.Plan_for_the_next_month__c = 10;
        liq2.Territory__c = territoryObj.Id;
        liq2.RecordTypeId = rtforLiquidation;
        liq2.submitted_trade__c =true;
        insert liq2;
             
        Liquidation2__c liq3 = new Liquidation2__c();
        liq3.Opening_Inventory2__c = openInveObj2.id;
        liq3.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq3.Product__c = prodList[0].Id;
        liq3.Type__c = 'Trade';
        liq3.Month__c = 'Jun';
        liq3.Liquidation__c = 10;
        liq3.Plan_for_the_month__c = 10;
        liq3.Retailers_Inventory__c = 3;
        liq3.Distributors_Inventory__c = 2;
        liq3.Plan_for_the_next_month__c = 10;
        liq3.Territory__c = territoryObj.Id;
        liq3.RecordTypeId = rtforLiquidation;
        liq3.submitted_trade__c =true;
        insert liq3;
             
             Liquidation2__c liq4 = new Liquidation2__c();
        liq4.Opening_Inventory2__c = openInveObj2.id;
        liq4.Liquidation_Annual_Plan__c = liqannlPlnObj.Id;
        liq4.Product__c = prodList[0].Id;
        liq4.Type__c = 'Trade';
        liq4.Month__c = 'Aug';
        liq4.Liquidation__c = 10;
        liq4.Plan_for_the_month__c = 10;
        liq4.Retailers_Inventory__c = 3;
        liq4.Distributors_Inventory__c = 2;
        liq4.Plan_for_the_next_month__c = 10;
        liq4.Territory__c = territoryObj.Id;
        liq3.RecordTypeId = rtforLiquidation;
        liq4.submitted_trade__c =true;
        insert liq4;
        newLiq.add(liq);
            
             
             Liquidation_Approval_History__c newApprovalInstance = new Liquidation_Approval_History__c();
                    newApprovalInstance.Territory__c = territoryObj.Id;
                    newApprovalInstance.Month__c = monthFY;
                    //newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance.SalesOrg__c = salesOrgObj.Id;
                    newApprovalInstance.LAP__c = liqannlPlnObj.Id;
                    newApprovalInstance.Territory_Manager_Email__c = 'test@t.com';
                    insert newApprovalInstance;
             
             Liquidation_Approval_History__c newApprovalInstance1 = new Liquidation_Approval_History__c();
                    newApprovalInstance1.Territory__c = territoryObj.Id;
                    newApprovalInstance1.Month__c = 'May';
                    //newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance1.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance1.SalesOrg__c = salesOrgObj.Id;
                    newApprovalInstance1.LAP__c = liqannlPlnObj.Id;
                    newApprovalInstance1.Territory_Manager_Email__c = 'test@t.com';
                    insert newApprovalInstance1;
             
             Liquidation_Approval_History__c newApprovalInstance2 = new Liquidation_Approval_History__c();
                    newApprovalInstance2.Territory__c = territoryObj.Id;
                    newApprovalInstance2.Month__c = 'Jun';
                    //newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance2.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance2.SalesOrg__c = salesOrgObj.Id;
                    newApprovalInstance2.LAP__c = liqannlPlnObj.Id;
                    newApprovalInstance2.Territory_Manager_Email__c = 'test@t.com';
                    insert newApprovalInstance2;
             
                    system.debug('**newApprovalInstance : ' +newApprovalInstance); 
         }
        
        string fy;
        String perf; 
        String com='test';
        Boolean UpdationStat =true;
        Decimal planNextM = 10;
        String FieldD='Distributors_Inventory__c';
        String FieldR='Retailers_Inventory__c';
        string fieldPlan = 'Plan_for_the_next_month__c';
        string fieldOpenInv = 'Opening_Inventory__c';
      
        Test.startTest();
        System.runAs(u4){
   
        Territory_Distributor__c tc = [select id, name,Sales_Org_Code__c,TerritoryManager__c,Zonal_Manager_Id__c,Zonal_Marketing_Manager_1_Id__c from Territory_Distributor__c limit 1];
             //string tcid =  tc.id;

            String URL = system.URL.getSalesforceBaseUrl().toExternalForm();
            LiquidationApprovalController tstobj = new LiquidationApprovalController();
            listTerritory =LiquidationApprovalController.getTerritories();
            month = LiquidationApprovalController.getMonth();
            fy = LiquidationApprovalController.getFYData();
            LiquidationApprovalController.getPageURL();
            LiquidationApprovalController.productList = prodList;
            LiquidationApprovalController.getliquidation(tc.id,fy,month);
            //LiquidationApprovalController.liquiApprove(tc.id,fy,month,com);
            LiquidationApprovalController.liquiReject(tc.id,fy,month,com);
            LiquidationApprovalController.fetchCustomSetting();
            LiquidationApprovalController.allSort(openinvList,prodList);
            //LiquidationApprovalController.UpdateCropRecords(newLiq,tc.id,fy,month);
            //LiquidationApprovalController.OpenInventoryUpdate(LiqList[0].Id,OpenInventory,tc.id,fy,month);
            //LiquidationApprovalController.CreateCropandSubCropforMissingProducts(ProductIdsToCreateRecords,tc.id,month,fy); 
            
        }
        Test.stopTest();
    
    }
    }