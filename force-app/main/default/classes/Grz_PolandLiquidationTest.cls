@IsTest
public with sharing class Grz_PolandLiquidationTest {
    
    @TestSetup
    static void makeData(){
        
        
 
        
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        userrole r = [select id,name from userrole where developername = 'Business_Analysis_Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', userRoleId = r.id,
                          UserName=uniqueUserName);
        Test.startTest();
        
        System.runAs(u) {
            
            List<Multi_Country_Liquidation__c> mclList = new List<Multi_Country_Liquidation__c>();
            Multi_Country_Liquidation__c mcl_oi = new Multi_Country_Liquidation__c();
            mcl_oi.Name = 'Poland Opening Inventory';
            mcl_oi.Country__c = 'Poland';
            mcl_oi.Edit_Start_Day__c = 1;
            mcl_oi.Edit_End_Day__c = 30;
            mcl_oi.Type__c = 'Liquidation';
            mcl_oi.Quarter__c='Quarter 1';
            mcl_oi.Month__c = 'July';
             //insert mcl_oi;
           mclList.add(mcl_oi);  
             Multi_Country_Liquidation__c mcl_oi1 = new Multi_Country_Liquidation__c();
            mcl_oi1.Name = 'Poland Opening Inventory';
            mcl_oi1.Country__c = 'Poland';
            mcl_oi1.Edit_Start_Day__c = 1;
            mcl_oi1.Edit_End_Day__c = 30;
            mcl_oi1.Type__c = 'Opening Inventory';
            mcl_oi1.Quarter__c='Quarter 1';
            mcl_oi1.Month__c = 'September';
             mclList.add(mcl_oi1);
            insert mclList;
            
            Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
            lbf2.Name = 'Poland';
            lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'2941\'';
            lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
            lbf2.Distributor_Filter__c = 'test';
            lbf2.Active__c = true;
            
            insert lbf2;
            
            Sales_Org__c so_indo1 = new Sales_Org__c();
            so_indo1.Name='Poland';
            so_indo1.Sales_Org_Code__c='2941';
            insert so_indo1;
            
            SKU__c sku1 = new SKU__c();
            sku1.Name = '6 LTR';
            sku1.SKU_Code__c = '000000000005160032';
            sku1.Brand_Name__c = 'test';
            sku1.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
            sku1.Active_for_Liquidation__c =true;
            sku1.Sales_Org__c = so_indo1.Id;
            insert sku1;
            
            Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            Account acc1 = new Account();
            acc1.Name = 'acc1';
            acc1.Account_Type__c = 'Sold To Party';
            acc1.RecordTypeId=rec_type_acc;
            acc1.Sales_Org__c = so_indo1.Id;
            insert acc1;
            
            Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
            Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
            lap.FIscal_Year__c = '2021-2022';
            lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf('2021'), 4, 1); 
            lap.Fiscal_End_Date__c =  Date.newInstance(Integer.valueOf('2022'), 3, 31); 
            lap.Distributor__c = acc1.Id;
            lap.Sales_Org__c = so_indo1.Id;
            
            lap.recordTypeId = rec_type_LAP;
            insert lap;
            
            Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
            Opening_Inventory2__c oi = new Opening_Inventory2__c();
            oi.SKU__c = sku1.Id;
            oi.Distributor__c = acc1.Id;
            oi.Opening_Inventory__c = 3360;
            oi.Liquidation_Annual_Plan__c = lap.Id;
            oi.recordTypeId = rec_type_OI;
            insert oi;
        }
        
        
        
        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        test.stopTest();
    }
    
    @IsTest
    static void testLiquidation_rm(){
        Account acc = [select id,Name from Account where Name='acc1' limit 1];
        Opening_Inventory2__c opi = [select id,Name from Opening_Inventory2__c where Distributor__c=:acc.Id limit 1]; 
        SKU__c sku1 = [select id,Name,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c where Brand_Name__c ='test'  limit 1];
        Liquidation_Annual_Plan__c lap = [select id,Name from Liquidation_Annual_Plan__c limit 1];
        
        Trigger_Settings__c ts = new Trigger_Settings__c();
        ts.Name = 'LiquidationTrigger';
        ts.IsActive__c = false;
        insert ts;
        Test.startTest();
        String countryname = Grz_PolandLiquidation.getUserCountry();
        Boolean liq_edit_date = Grz_PolandLiquidation.getLiquidationEditDates();
        Boolean oi_edit_date = Grz_PolandLiquidation.getOpeningInventoryEditDates();
        String allLabel=System.Label.All;
        List<Liquidation2__c> lst_liq1 = Grz_PolandLiquidation.getLiquidationData(String.valueOf(acc.Id),acc.name,'2020','Quarter 3');
        List<Liquidation2__c> lst_liq2 = Grz_PolandLiquidation.getLiquidationData('',allLabel,'2020','Quarter 3');
        Multi_Country_Liquidation__c mcl = [select id,name,Month__c,Country__c,Edit_Start_Day__c,Edit_End_Day__c,Type__c  from Multi_Country_Liquidation__c where Type__c = 'Opening Inventory' limit 1];
        map<String,String> quarStringMap =new map<String,String>();
        map<String,String> monthStringMap =new map<String,String>();
        monthStringMap.put('1','January'); 
        monthStringMap.put('2','February');
        monthStringMap.put('3','March');
        monthStringMap.put('4','April');
        monthStringMap.put('5','May');
        monthStringMap.put('6','Jun');
        monthStringMap.put('7','July');
        monthStringMap.put('8','August');
        monthStringMap.put('9','September');
        monthStringMap.put('10','October');
        monthStringMap.put('11','November');
        monthStringMap.put('12','December');
        
       // mcl.Month__c = monthStringMap.get(String.ValueOf(System.today().Month()));
      //  update mcl;
        Grz_PolandLiquidation.getOpeningInventoryEditDates();
        Grz_PolandLiquidation.getUserRole();
        
        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation2__c liquidation = new Liquidation2__c();
        liquidation.Quarter__c = 'Quarter 3';
        liquidation.Distributor__c = acc.Id;
        liquidation.Liquidation_Annual_Plan__c = lap.Id; 
        liquidation.SKU__c = sku1.Id;
        liquidation.SKU_Code__c = sku1.SKU_Code__c;
        liquidation.Brand_Name__c = sku1.Brand_Name__c;
        liquidation.SKU_Description__c = sku1.SKU_Description__c;
        liquidation.RecordTypeId = rec_type_liquidation;
        liquidation.Opening_Inventory2__c = opi.Id;
      liquidation.Plan_for_the_Quarter__c=0.0;
        liquidation.Plan_for_the_Next_Quarter__c=0.0;
        insert liquidation;
        
        Liquidation2__c liquidation1 = new Liquidation2__c();
        liquidation1.Quarter__c = 'Quarter 2';
        liquidation1.Distributor__c = acc.Id;
        liquidation1.Liquidation_Annual_Plan__c = lap.Id;
        liquidation1.SKU__c = sku1.Id;
        liquidation1.SKU_Code__c = sku1.SKU_Code__c;
        liquidation1.Brand_Name__c = sku1.Brand_Name__c;
        liquidation1.SKU_Description__c = sku1.SKU_Description__c;
        liquidation1.RecordTypeId = rec_type_liquidation;
        liquidation1.Opening_Inventory2__c = opi.Id;
        liquidation1.Plan_for_the_Quarter__c=0.0;
        
        insert liquidation1;
        Liquidation2__c liquidation2 = new Liquidation2__c();
        liquidation2.Quarter__c = 'Quarter 1';
        liquidation2.Distributor__c = acc.Id;
        liquidation2.Liquidation_Annual_Plan__c = lap.Id;
        liquidation2.SKU__c = sku1.Id;
        liquidation2.SKU_Code__c = sku1.SKU_Code__c;
        liquidation2.Brand_Name__c = sku1.Brand_Name__c;
        liquidation2.SKU_Description__c = sku1.SKU_Description__c;
        liquidation2.RecordTypeId = rec_type_liquidation;
        liquidation2.Opening_Inventory2__c = opi.Id;
        liquidation2.Plan_for_the_Quarter__c=0.0;
        insert liquidation2;
        Liquidation2__c liq = [select id,Quarter__c from Liquidation2__c where Quarter__c='Quarter 1' limit 1];
        Liquidation2__c liq_oct = [select id,Quarter__c from Liquidation2__c where Quarter__c='Quarter 2' limit 1];
        List<Liquidation2__c> lstliq = [select id,Month__c from Liquidation2__c];
        
        Liquidation2__c liq_update2 = Grz_PolandLiquidation.updatePlanForQuarter(liq);
        Liquidation2__c liq_update1 = Grz_PolandLiquidation.saveLiquidation(liq);
        String val_update = Grz_PolandLiquidation.updateOpeningInventory(String.valueOf(opi.Id),'6630');
        Boolean liq_submit = Grz_PolandLiquidation.submitLiquidation('["'+lstliq[0].Id+'","'+lstliq[1].Id+'"]');
        Grz_PolandLiquidation.checkIsSubmitTrueLiquidation('2021', 'Quarter 3');
      //  Grz_PolandLiquidation.getLiquidationPolandDataPDF(String.valueOf(acc.Id),'','2020','Quarter 3','t');
         Grz_PolandLiquidation.getLiquidationPolandDataPDF(String.valueOf(acc.Id),acc.name,'2021','Quarter 3','');
       //  Grz_PolandLiquidation.getLiquidationPolandDataPDF('',allLabel,'2021','Quarter 4','');
        Test.stopTest(); 
    }
}