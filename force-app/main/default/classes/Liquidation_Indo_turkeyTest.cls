@IsTest
public with sharing class Liquidation_Indo_turkeyTest {
    @TestSetup
    static void makeData(){
        
        
        Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Indonesia';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Active__c = true;
        lbf2.Distributor_Filter__c='Test';
        lbf2.Sales_District_Filter__c='Test';
        insert lbf2;
        
        Trigger_Settings__c settingsTest = new Trigger_Settings__c();
        settingsTest.Name = 'LiquidationTrigger';
        settingsTest.IsActive__c = false;
        insert settingsTest;

        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='UPL-Indonesia';
        so_indo1.Sales_Org_Code__c='6451';
        insert so_indo1;
     
         
     User usr_regional_manager = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Indonesia'].Id,
     LastName = 'RM',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Country = 'Indonesia',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_regional_manager;

     User usr_nsm = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'National sales Manager indonesia'].Id,
     LastName = 'NSM',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_nsm;

     Multi_Country_Liquidation__c mcl_liquidation = new Multi_Country_Liquidation__c();
     mcl_liquidation.Name = 'Indonesia Liquidation';
     mcl_liquidation.Country__c = 'Indonesia';
     mcl_liquidation.Edit_Start_Day__c = 1;
     mcl_liquidation.Edit_End_Day__c = 30;
     mcl_liquidation.Type__c = 'Liquidation';
     insert mcl_liquidation;

     Multi_Country_Liquidation__c mcl_oi = new Multi_Country_Liquidation__c();
     mcl_oi.Name = 'Indonesia Opening Inventory';
     mcl_oi.Country__c = 'Indonesia';
     mcl_oi.Edit_Start_Day__c = 1;
     mcl_oi.Edit_End_Day__c = 30;
     mcl_oi.Type__c = 'Opening Inventory';
     mcl_oi.Month__c = 'September';
     insert mcl_oi;

     SKU__c sku1 = new SKU__c();
     sku1.Name = '6 LTR';
     sku1.SKU_Code__c = '000000000005160032';
     sku1.Brand_Name__c = 'ABACO';
     sku1.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
     sku1.Active_for_Liquidation__c =true;
     sku1.Sales_Org__c = so_indo1.Id;
     insert sku1;

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
     acc1.Sales_Org__c = so_indo1.Id;
     acc1.Is_Community_Active__c = true;
     insert acc1;
        
     Contact c = new Contact();
        c.AccountId = acc1.ID;
        c.FirstName = 'testContact';
        c.LastName = 'test';
        c.email = 'test@test.com';
	insert c;
        
        User usr_turkey = new User(
    
      //ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community User-Turkey'].Id,
    ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            
      LastName = 'Turkey',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     //ContactId =c.Id,
     Country = 'Turkey',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_turkey;
        
        
     Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
     Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
     lap.FIscal_Year__c = '2020-2021';
     lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf('2020'), 4, 1); 
     lap.Fiscal_End_Date__c =  Date.newInstance(Integer.valueOf('2021'), 3, 31); 
     lap.Distributor__c = acc1.Id;
     lap.Sales_Org__c = so_indo1.Id;
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

      Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
    //  Liquidation2__c liquidation = new Liquidation2__c();
    //  liquidation.Month__c = 'Sept';
     // liquidation.Distributor__c = acc1.Id;
    //  liquidation.Liquidation_Annual_Plan__c = lap.Id;
    //  liquidation.SKU__c = sku1.Id;
    //  liquidation.SKU_Code__c = sku1.SKU_Code__c;
    //  liquidation.Brand_Name__c = sku1.Brand_Name__c;
    //  liquidation.SKU_Description__c = sku1.SKU_Description__c;
    //  liquidation.Sales_District__c = sales_dis.Id;
   //   liquidation.RecordTypeId = rec_type_liquidation;
   //   liquidation.Opening_Inventory2__c = oi.Id;
    //  insert liquidation;

    //  Liquidation2__c liquidation1 = new Liquidation2__c();
    //  liquidation1.Month__c = 'Oct';
    // liquidation1.Distributor__c = acc1.Id;
    //  liquidation1.Liquidation_Annual_Plan__c = lap.Id;
    //  liquidation1.SKU__c = sku1.Id;
    //  liquidation1.SKU_Code__c = sku1.SKU_Code__c;
    //  liquidation1.Brand_Name__c = sku1.Brand_Name__c;
    //  liquidation1.SKU_Description__c = sku1.SKU_Description__c;
    //  liquidation1.Sales_District__c = sales_dis.Id;
    //  liquidation1.RecordTypeId = rec_type_liquidation;
    //  liquidation1.Opening_Inventory2__c = oi.Id;
    //  insert liquidation1;
    }

    @IsTest
    static void testLiquidation_rm(){
        User usr_rm = [select id,Name from User where LastName='RM' limit 1];
        User usr_turkey = [select id,Name from User where LastName='Turkey' limit 1];
        User usr_nsm = [select id,Name from User where LastName='NSM' limit 1];
        Sales_District__c sale_dist = [select id,Name from Sales_District__c where Name='sale_dist' limit 1];
        Account acc = [select id,Name from Account where Name='acc1' limit 1];
        Opening_Inventory2__c opi = [select id,Name from Opening_Inventory2__c where Distributor__c=:acc.Id limit 1]; 
        SKU__c sku1 = [select id,Name,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c limit 1];
        Liquidation_Annual_Plan__c lap = [select id,Name from Liquidation_Annual_Plan__c limit 1];
        Test.startTest();
        System.runAs(usr_rm){
            String countryname = Liquidation_Indo_turkey.getUserCountry();
            String profile = Liquidation_Indo_turkey.getUserProfile();
            String loggedInUser = Liquidation_Indo_turkey.getLogedInUserId();
            String liq_edit_date = Liquidation_Indo_turkey.getLiquidationEditDates();
            String oi_edit_date = Liquidation_Indo_turkey.getOpeningInventoryEditDates();
            List<Sales_District__c> lst_salesDistrict = Liquidation_Indo_turkey.getSalesDistrict(); 
            List<Account> lst_acc = Liquidation_Indo_turkey.getDistributor(String.valueOf(sale_dist.Id));
            List<Sales_Org__c> lst_sales_org = Liquidation_Indo_turkey.getSalesOrg();
            List<Liquidation2__c> lst_liq1 = Liquidation_Indo_turkey.getAllLiquidation(String.valueOf(sale_dist.Id),String.valueOf(acc.Id),'6451','2020','Oct','');
            List<Liquidation2__c> lst_liq2 = Liquidation_Indo_turkey.getAllLiquidation(String.valueOf(sale_dist.Id),String.valueOf(acc.Id),'6451','2020','Oct','SCANNER');
            List<Liquidation2__c> lst_liq3 = Liquidation_Indo_turkey.getAllLiquidation(String.valueOf(sale_dist.Id),String.valueOf(acc.Id),'','2020','Oct','');
            List<Liquidation2__c> lst_liq4 = Liquidation_Indo_turkey.getAllLiquidationPDFXLS(String.valueOf(sale_dist.Id),String.valueOf(acc.Id),'6451','2020','Oct','');
            List<Liquidation2__c> lst_liq5 = Liquidation_Indo_turkey.getAllLiquidationPDFXLS(String.valueOf(sale_dist.Id),String.valueOf(acc.Id),'6451','2020','Oct','SCANNER');
            List<Liquidation2__c> lst_liq6 = Liquidation_Indo_turkey.getAllLiquidationPDFXLS(String.valueOf(sale_dist.Id),String.valueOf(acc.Id),'','2020','Oct','');
            
            Multi_Country_Liquidation__c mcl = [select id,name,Month__c,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c from Multi_Country_Liquidation__c where Type__c = 'Opening Inventory' limit 1];
        map<String,String> monthStringMap =new map<String,String>();
        monthStringMap.put('1','JANUARY');
        monthStringMap.put('2','February');
        monthStringMap.put('3','March');
        monthStringMap.put('4','April');
        monthStringMap.put('5','May');
        monthStringMap.put('6','June');
        monthStringMap.put('7','July');
        monthStringMap.put('8','August');
        monthStringMap.put('9','September');
        monthStringMap.put('10','October');
        monthStringMap.put('11','November');
        monthStringMap.put('12','December');

           // mcl.Month__c = monthStringMap.get(String.ValueOf(System.today().Month()));
            //update mcl;
            Liquidation_Indo_turkey.getOpeningInventoryEditDates();
           // mcl.Month__c = 'September';
            //update mcl;
            
            Liquidation_Indo_turkey.getSalesDistrictOnAccount(acc.Id);
        }
       
        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation2__c liquidation = new Liquidation2__c();
        liquidation.Month__c = 'Sept';
        liquidation.Distributor__c = acc.Id;
        liquidation.Liquidation_Annual_Plan__c = lap.Id;
        liquidation.SKU__c = sku1.Id;
        liquidation.SKU_Code__c = sku1.SKU_Code__c;
        liquidation.Brand_Name__c = sku1.Brand_Name__c;
        liquidation.SKU_Description__c = sku1.SKU_Description__c;
        liquidation.Sales_District__c = sale_dist.Id;
        liquidation.RecordTypeId = rec_type_liquidation;
        liquidation.Opening_Inventory2__c = opi.Id;
        insert liquidation;
   
        Liquidation2__c liquidation1 = new Liquidation2__c();
        liquidation1.Month__c = 'Dec';
        liquidation1.Distributor__c = acc.Id;
        liquidation1.Liquidation_Annual_Plan__c = lap.Id;
        liquidation1.SKU__c = sku1.Id;
        liquidation1.SKU_Code__c = sku1.SKU_Code__c;
        liquidation1.Brand_Name__c = sku1.Brand_Name__c;
        liquidation1.SKU_Description__c = sku1.SKU_Description__c;
        liquidation1.Sales_District__c = sale_dist.Id;
        liquidation1.RecordTypeId = rec_type_liquidation;
        liquidation1.Opening_Inventory2__c = opi.Id;
        insert liquidation1;
         Liquidation2__c liquidation2 = new Liquidation2__c();
        liquidation2.Month__c = 'Nov';
        liquidation2.Distributor__c = acc.Id;
        liquidation2.Liquidation_Annual_Plan__c = lap.Id;
        liquidation2.SKU__c = sku1.Id;
        liquidation2.SKU_Code__c = sku1.SKU_Code__c;
        liquidation2.Brand_Name__c = sku1.Brand_Name__c;
        liquidation2.SKU_Description__c = sku1.SKU_Description__c;
        liquidation2.Sales_District__c = sale_dist.Id;
        liquidation2.RecordTypeId = rec_type_liquidation;
        liquidation2.Opening_Inventory2__c = opi.Id;
        insert liquidation2;
        Liquidation2__c liq = [select id,Month__c from Liquidation2__c where Month__c='sept' limit 1];
        Liquidation2__c liq_oct = [select id,Month__c from Liquidation2__c where Month__c='Dec' limit 1];
        List<Liquidation2__c> lstliq = [select id,Month__c from Liquidation2__c];
        System.runAs(usr_rm){
            Liquidation2__c liq_update2 = Liquidation_Indo_turkey.updatePlanForMonth(liq);
            //Liquidation2__c liq_update3 = Liquidation_Indo_turkey.updatePlanForMonth(liq_oct);
            Liquidation2__c liq_update1 = Liquidation_Indo_turkey.saveLiquidation(liq);
            String val_update = Liquidation_Indo_turkey.updateOpeningInventory(String.valueOf(opi.Id),'6630');
            Boolean liq_submit = Liquidation_Indo_turkey.submitLiquidation('["'+lstliq[0].Id+'","'+lstliq[1].Id+'"]');

            Map<String,Liquidation2__c> map_liq1 = Liquidation_Indo_turkey.rollUpLiquidation('[]','','2020','Oct','','');
            Map<String,Liquidation2__c> map_liq2 = Liquidation_Indo_turkey.rollUpLiquidation('[]',String.valueOf(sale_dist.Id),'2020','Oct',String.valueOf(acc.Id),'');
            Map<String,Liquidation2__c> map_liq3 = Liquidation_Indo_turkey.rollUpLiquidation('[]',String.valueOf(sale_dist.Id),'2020','Oct','','');
            Map<String,Liquidation2__c> map_liq4 = Liquidation_Indo_turkey.rollUpLiquidation('[]',String.valueOf(sale_dist.Id),'2020','Oct','','6451');
            Map<String,Liquidation2__c> map_liq5 = Liquidation_Indo_turkey.rollUpLiquidation('[]',String.valueOf(sale_dist.Id),'2020','Oct',String.valueOf(acc.Id),'6451');
            Map<String,Liquidation2__c> map_liq6 = Liquidation_Indo_turkey.rollUpLiquidation('[]','','2020','Oct','','6451');
            Map<String,Liquidation2__c> map_liq7 = Liquidation_Indo_turkey.rollUpLiquidation('[]','','2020','Oct',String.valueOf(acc.Id),'6451');
          
         
          Map<String,Liquidation2__c> map_liq10 = Liquidation_Indo_turkey.rollUpLiquidationPDFXLS(String.valueOf(sale_dist.Id),'2020','Oct','','');
           Map<String,Liquidation2__c> map_liq11 = Liquidation_Indo_turkey.rollUpLiquidationPDFXLS(String.valueOf(sale_dist.Id),'2020','Oct','','6451');
            Map<String,Liquidation2__c> map_liq12 = Liquidation_Indo_turkey.rollUpLiquidationPDFXLS(String.valueOf(sale_dist.Id),'2020','Oct',String.valueOf(acc.Id),'6451');
        
                
            
        }

        System.runAs(usr_nsm){
            List<Sales_District__c> lst_salesDistrict = Liquidation_Indo_turkey.getSalesDistrict(); 
        }

        System.runAs(usr_turkey){
            Liquidation_Indo_turkey.isCommunityUser();
            Liquidation_Indo_turkey.getCommunityDistributor();
            
        }
        Liquidation_Indo_turkey.isActiveCommunity(acc.Id);
       
        Test.stopTest();
    }
}