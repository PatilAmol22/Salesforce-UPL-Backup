@isTest
public with sharing class LiquidationMexicoTest {
    @TestSetup
    static void makeData(){
        
         Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Poland';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'2941\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Active__c = true;
        lbf2.Distributor_Filter__c='Test';
        lbf2.Sales_District_Filter__c='Test';
        insert lbf2;
        
        
        test.startTest();
        Group grp = new Group();
        grp.name = System.Label.Grz_GroupNameMexico;
        grp.Type = 'Regular'; 
        Insert grp; 
        test.stopTest();
        
        
        
        Sales_Org__c so_mexico1 = new Sales_Org__c();
        so_mexico1.Name='UPL-Mexico';
        so_mexico1.Sales_Org_Code__c='5100';
        insert so_mexico1;
        
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr_regional_manager;
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            
            usr_regional_manager = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers for Mexico'].Id,
                LastName = 'RM',
                Email = 'test@test.com',
                Username = 'test@test.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Country = 'Mexico',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
                //UserRoleId = r.Id
            );
            insert usr_regional_manager;
            
            GroupMember gm = Grz_TestDataFactory.createGM(true,gg.Id,usr_regional_manager.id);
            
        }
        
        Sales_District__c sales_dis = new Sales_District__c();
        sales_dis.Name = 'sale_dist';
        sales_dis.User__c = usr_regional_manager.Id;
        sales_dis.Sales_District_Code__c = 'ID0004';
        insert sales_dis;
        
        Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'acc1';
        acc1.Sales_District__c = sales_dis.Id;
        acc1.Account_Type__c = 'Sold To Party';
        acc1.RecordTypeId=rec_type_acc;
        acc1.Sales_Org__c = so_mexico1.Id;
        insert acc1;
        
        DistributorSalesAreaMapping__c sales_area = new DistributorSalesAreaMapping__c();
        // sales_area.Name = 'Test sales Area';
        sales_area.Distributor__c = acc1.Id;
        sales_area.Sales_District__c = sales_dis.Id;
        sales_area.SalesOrg__c = so_mexico1.Id;
        sales_area.AccountOwner__c = usr_regional_manager.Id;
        insert sales_area;
        
        Multi_Country_Liquidation__c mcl_liquidation = new Multi_Country_Liquidation__c();
        mcl_liquidation.Name = 'Mexico Liquidation';
        mcl_liquidation.Country__c = 'Mexico';
        mcl_liquidation.Edit_Start_Day__c = 1;
        mcl_liquidation.Edit_End_Day__c = 30;
        mcl_liquidation.Type__c = 'Liquidation';
        insert mcl_liquidation;
        
        Multi_Country_Liquidation__c mcl_oi = new Multi_Country_Liquidation__c();
        mcl_oi.Name = 'Mexico Opening Inventory';
        mcl_oi.Country__c = 'Mexico';
        mcl_oi.Edit_Start_Day__c = 1;
        mcl_oi.Edit_End_Day__c = 30;
        mcl_oi.Type__c = 'Opening Inventory';
        mcl_oi.Month__c = 'September';
        insert mcl_oi;
        
        Shipping_Location__c ship_to_party = new Shipping_Location__c();
        // ship_to_party.Name = 'AGRICOLA';
        ship_to_party.Distributor__c = acc1.Id;
        ship_to_party.User__c = usr_regional_manager.Id;
        ship_to_party.Sales_District__c = sales_dis.Id;
        ship_to_party.SAP_Code__c = '0002035995';
        ship_to_party.Sales_Org__c = so_mexico1.Id;
        insert ship_to_party;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = '6 LTR';
        sku1.SKU_Code__c = '000000000005160032';
        sku1.Brand_Name__c = 'ABACO';
        sku1.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
        sku1.Active_for_Liquidation__c =true;
        sku1.Sales_Org__c = so_mexico1.Id;
        insert sku1;
        
        Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
        lap.FIscal_Year__c = '2020-2021';
        //lap.Fiscal_Start_Date__c = Date.parse('01/04/21');
        lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf(System.Today().year()), 4, 1);
        //lap.FIscal_Year__c = '2021-2022';
        lap.Distributor__c = acc1.Id;
        lap.Sales_Org__c = so_mexico1.Id;
        lap.recordTypeId = rec_type_LAP;
        insert lap;
        
        Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Opening_Inventory2__c oi = new Opening_Inventory2__c();
        oi.SKU__c = sku1.Id;
        oi.Sales_District__c = sales_dis.Id;
        oi.Distributor__c = acc1.Id;
        oi.Opening_Inventory__c = 3360;
        oi.Liquidation_Annual_Plan__c = lap.Id;
        oi.recordTypeId = rec_type_OI;
        insert oi;
        
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'LiquidationTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation2__c liquidation = new Liquidation2__c();
        liquidation.Month__c = 'Sept';
        liquidation.Distributor__c = acc1.Id;
        liquidation.Liquidation_Annual_Plan__c = lap.Id;
        liquidation.SKU__c = sku1.Id;
        liquidation.SKU_Code__c = sku1.SKU_Code__c;
        liquidation.Brand_Name__c = sku1.Brand_Name__c;
        liquidation.SKU_Description__c = sku1.SKU_Description__c;
        liquidation.Sales_District__c = sales_dis.Id;
        liquidation.RecordTypeId = rec_type_liquidation;
        liquidation.Opening_Inventory2__c = oi.Id;
        liquidation.Ship_To_Party__c = ship_to_party.Id;
        insert liquidation;
        Liquidation2__c liquidation1 = new Liquidation2__c();
        liquidation1.Month__c = 'Nov';
        liquidation1.Distributor__c = acc1.Id;
        liquidation1.Liquidation_Annual_Plan__c = lap.Id;
        liquidation1.SKU__c = sku1.Id;
        liquidation1.SKU_Code__c = sku1.SKU_Code__c;
        liquidation1.Brand_Name__c = sku1.Brand_Name__c;
        liquidation1.SKU_Description__c = sku1.SKU_Description__c;
        liquidation1.Sales_District__c = sales_dis.Id;
        liquidation1.RecordTypeId = rec_type_liquidation;
        liquidation1.Opening_Inventory2__c = oi.Id;
        liquidation1.Ship_To_Party__c = ship_to_party.Id;
        liquidation1.YTD_Sales_Wrap__c = 20.22;
        liquidation1.Liquidation_YTD_Wrap__c = 30.22;
        liquidation1.Total_Available_Stock_Wrap__c = 54.11;
        liquidation1.Distributors_Inventory__c = 11.2;
        liquidation1.Retailers_Inventory__c = 54.3;
        liquidation1.Total_Market_Inventory_Wrap__c = 76.1;
        liquidation1.Plan_for_the_month__c = 12;
        liquidation1.Plan_for_the_next_month__c = 12;
        liquidation1.Opening_Inventory_Wrap__c = 100;
        liquidation1.UOM_Wrap__c = '44';
        liquidation1.Liquidation_YTD_Percent_Wrap__c = 44;
        insert liquidation1;
        
        Liquidation2__c liquidation2 = new Liquidation2__c();
        liquidation2.Month__c = 'Dec';
        liquidation2.Distributor__c = acc1.Id;
        liquidation2.Liquidation_Annual_Plan__c = lap.Id;
        liquidation2.SKU__c = sku1.Id;
        liquidation2.SKU_Code__c = sku1.SKU_Code__c;
        liquidation2.Brand_Name__c = sku1.Brand_Name__c;
        liquidation2.SKU_Description__c = sku1.SKU_Description__c;
        liquidation2.Sales_District__c = sales_dis.Id;
        liquidation2.RecordTypeId = rec_type_liquidation;
        liquidation2.Opening_Inventory2__c = oi.Id;
        liquidation2.Ship_To_Party__c = ship_to_party.Id;
        insert liquidation2;
        
        
       
        
        
        
        
    }
    
    @isTest
    public static void testMethods(){
        
        UserRole r = new UserRole(DeveloperName = 'sandeep', Name = 'New Mexico Region Financial Head');
        insert r;
        User usr_rm = [select id,Name,UserRoleId from User where LastName='RM' limit 1];
        usr_rm.UserRoleId = r.Id;
        update usr_rm;
        Sales_District__c sale_dist = [select id,Name from Sales_District__c where Name='sale_dist' limit 1];
        Account acc = [select id,Name from Account where Name='acc1' limit 1];
        Shipping_Location__c ship_to_party  = [select Id from Shipping_Location__c where SAP_Code__c = '0002035995' limit 1];
        Liquidation2__c liq = [select id,Month__c from Liquidation2__c where Month__c='Nov' limit 1];
        List<Liquidation_Annual_Plan__c> listann = [SELECT Id, Name, FIscal_Year__c, Fiscal_Start_Date__c, Sales_Org__c FROM Liquidation_Annual_Plan__c];
        System.debug('listann : '+listann);
        List<Liquidation2__c> lstliq = [select id,Month__c,SKU__r.Active_for_Liquidation__c,SKU__r.SKU_Code__c,Distributor__c,Liquidation_Annual_Plan__r.Fiscal_Start_Date__c,Sales_District__c,Ship_To_Party__c,Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c,RecordTypeId from Liquidation2__c];
        System.debug('lstliq : '+lstliq);
        Opening_Inventory2__c opi = [select id,Name from Opening_Inventory2__c where Distributor__c=:acc.Id limit 1];
        Test.startTest();
        System.runAs(usr_rm){
            System.debug('user '+UserInfo.getUserId());
            LiquidationMexico.getSalesDistrict();
            LiquidationMexico.getDistributor();
            LiquidationMexico.getSalesOrg();
            LiquidationMexico.getUserCountry();
            LiquidationMexico.getUserProfile();
            LiquidationMexico.getLogedInUserId();
            LiquidationMexico.getLiquidationEditDates();
            LiquidationMexico.getOpeningInventoryEditDates();        
            LiquidationMexico.getAllLiquidation('5100',String.valueOf(sale_dist.Id),String.valueOf(acc.Id),String.valueOf(ship_to_party.Id),'2020','Sept','');
            LiquidationMexico.updatePlanForMonth(liq);
            LiquidationMexico.updateOpeningInventory(String.valueOf(opi.Id),'6630');
            LiquidationMexico.saveLiquidation(liq);
            LiquidationMexico.submitLiquidation('["'+lstliq[0].Id+'","'+lstliq[1].Id+'"]');
            LiquidationMexico.rollUpLiquidation('[]','[]','','2020','Nov','','','5100');
            LiquidationMexico.rollUpLiquidation('[]','[]','','2020','Nov','',ship_to_party.Id,'5100');
            LiquidationMexico.rollUpLiquidation('[]','[]','','2020','Nov',acc.Id,'','5100');
            LiquidationMexico.rollUpLiquidation('[]','[]','','2020','Nov',acc.Id,ship_to_party.Id,'5100');
            LiquidationMexico.rollUpLiquidation('[]','[]',sale_dist.Id,'2020','Nov','','','5100');
            LiquidationMexico.rollUpLiquidation('[]','[]',sale_dist.Id,'2020','Nov','',ship_to_party.Id,'5100');
            LiquidationMexico.rollUpLiquidation('[]','[]',sale_dist.Id,'2020','Nov',acc.Id,'','5100');
            LiquidationMexico.getSalesDisctrictForShipToParty(ship_to_party.Id);
            LiquidationMexico.getDistributorForShipToParty(ship_to_party.Id);
        }
        ApexPages.currentPage().getParameters().put('saleOrgCode', String.valueOf('5100'));
        ApexPages.currentPage().getParameters().put('salesDistrict',  String.valueOf(sale_dist.id));
        ApexPages.currentPage().getParameters().put('distributor', String.valueOf(acc.Id));
        ApexPages.currentPage().getParameters().put('shipToParty', String.valueOf(ship_to_party.Id));
        ApexPages.currentPage().getParameters().put('year', String.valueOf(2022));
        ApexPages.currentPage().getParameters().put('month', 'Nov');
        ApexPages.currentPage().getParameters().put('searchStr', '');
        
        GRZ_LiquidationMexicoController.getPOGLiquidationMexico();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethods1(){
        UserRole r = new UserRole(DeveloperName = 'sandeep', Name = 'New Mexico Region Financial Head');
        insert r;
        User usr_rm = [select id,Name,UserRoleId from User where LastName='RM' limit 1];
        usr_rm.UserRoleId = r.Id;
        update usr_rm;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot()); 
        Test.startTest();
        System.runAs(usr_rm){
            ApexPages.currentPage().getParameters().put('saleOrgCode', String.valueOf('5100'));
            ApexPages.currentPage().getParameters().put('month', 'Nov');
            ApexPages.currentPage().getParameters().put('salesDistrict',  String.valueOf(''));
            ApexPages.currentPage().getParameters().put('shipToParty', String.valueOf(''));
            ApexPages.currentPage().getParameters().put('distributor', String.valueOf(''));
            ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
            ApexPages.currentPage().getParameters().put('searchStr', '');
            GRZ_LiquidationMexicoController.getPOGLiquidationMexico();
        }
        Test.stopTest();        
    }
    
    @isTest
    public static void testMethods2(){
        UserRole r = new UserRole(DeveloperName = 'sandeep', Name = 'New Mexico Region Financial Head');
        insert r;
        User usr_rm = [select id,Name,UserRoleId from User where LastName='RM' limit 1];
        usr_rm.UserRoleId = r.Id;
        update usr_rm;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot()); 
        Test.startTest();
        System.runAs(usr_rm){
            ApexPages.currentPage().getParameters().put('saleOrgCode', String.valueOf('5100'));
            ApexPages.currentPage().getParameters().put('month', 'Nov');
            ApexPages.currentPage().getParameters().put('salesDistrict',  String.valueOf(''));
            ApexPages.currentPage().getParameters().put('shipToParty', String.valueOf(''));
            ApexPages.currentPage().getParameters().put('distributor', String.valueOf(''));
            ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
            ApexPages.currentPage().getParameters().put('searchStr', 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....');
            GRZ_LiquidationMexicoController.getPOGLiquidationMexico();
        }
        Test.stopTest();        
    }
}