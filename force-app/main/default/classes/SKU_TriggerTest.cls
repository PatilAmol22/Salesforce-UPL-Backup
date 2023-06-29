@isTest
public class SKU_TriggerTest {
    
    @TestSetup
    static void makeData(){
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        
        Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Poland';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'2941\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Distributor_Filter__c = 'test';
        lbf2.Sales_District_Filter__c = 'id != \'\'';
        lbf2.Active__c = true;
        
        insert lbf2;
        
        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='Poland';
        so_indo1.Sales_Org_Code__c='2941';
        insert so_indo1;
        
        Sales_Org__c so_Usa = new Sales_Org__c();
        so_Usa.Name='USA';
        so_Usa.Sales_Org_Code__c='3100';
        insert so_Usa;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          Country = 'Turkey',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,                 
                          TimeZoneSidKey='America/Los_Angeles',
                          email = uniqueName + '@test' + orgId + '.org',
                          Username = uniqueName + '@test' + orgId + '.org');
        insert u;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = '6 LTR';
        sku1.SKU_Code__c = '000000000005160032';
        sku1.Brand_Name__c = 'ABACO';
        sku1.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
        //sku1.Active_for_Liquidation__c =true;
        sku1.Sales_Org__c = so_indo1.Id;
        insert sku1;
        
        SKU__c sku2 = new SKU__c();
        sku2.Name = '6 LTR';
        sku2.SKU_Code__c = '000000000005160034';
        sku2.Brand_Name__c = 'ABACO';
        sku2.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
        //sku1.Active_for_Liquidation__c =true;
        sku2.Sales_Org__c = so_Usa.Id;
        insert sku2;
        
        
        Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'acc1';
        acc1.Account_Type__c = 'Sold To Party';
        acc1.RecordTypeId=rec_type_acc;
        acc1.Sales_Org__c = so_indo1.Id;
        insert acc1;
        
        Shipping_Location__c shp = new 	Shipping_Location__c();
        shp.Active__c=true;
        shp.SAP_Code__c='123456';
        shp.User__c=u.Id;
        insert shp;
        
        
        Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
        lap.FIscal_Year__c = '2021-2022';
        lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf('2021'), 4, 1); 
        lap.Fiscal_End_Date__c =  Date.newInstance(Integer.valueOf('2023'), 3, 31); 
        lap.Distributor__c = acc1.Id;
        lap.Sales_Org__c = so_indo1.Id;
        lap.recordTypeId = rec_type_LAP;
        lap.Ship_To_Party__c=shp.Id;
        insert lap;
        
        Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Opening_Inventory2__c oi = new Opening_Inventory2__c();
        oi.SKU__c = sku1.Id;
        oi.Distributor__c = acc1.Id;
        oi.Opening_Inventory__c = 3360;
        oi.Liquidation_Annual_Plan__c = lap.Id;
        oi.recordTypeId = rec_type_OI;
        
        insert oi;
        
        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation2__c liquidation = new Liquidation2__c();
        liquidation.Quarter__c = 'Quarter 3';
        liquidation.Distributor__c = acc1.Id;
        liquidation.Liquidation_Annual_Plan__c = lap.Id;
        liquidation.SKU__c = sku1.Id;
        liquidation.SKU_Code__c = sku1.SKU_Code__c;
        liquidation.Brand_Name__c = sku1.Brand_Name__c;
        liquidation.SKU_Description__c = sku1.SKU_Description__c;
        liquidation.RecordTypeId = rec_type_liquidation;
        liquidation.Opening_Inventory2__c = oi.Id;
        
        insert liquidation;
        
        MultiCountry_Liquidation__c montlyliq = new MultiCountry_Liquidation__c();
        montlyliq.Name = 'All Countries';
        montlyliq.Active_Month__c = true;
        montlyliq.Month__c = 'Apr';
        montlyliq.Previous_Month__c = 'Mar';
        insert montlyliq;
        
        
    }
    
    
    
    
    @IsTest
    static void testSkuTrigger(){
        
        SKU__c sku1 = [select id,Name,unit_Cost__c,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c limit 1];
        
        Test.startTest();
        sku1.Active_for_Liquidation__c=true;
        update sku1;
        Test.stopTest();
    }
    
    @IsTest
    static void testSkuUnitCost(){
  
         SKU__c sku1 = [select id,Name,unit_Cost__c,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c where sku_code__c='000000000005160034' limit 1];
        
        Case css = new Case();
        css.subject='test1';
        css.RecordTypeId='01228000001HozeAAC';
        css.SalesOrg__c='a1F0K0000034aWUUAY';
        css.Total_Volume_Effected__c=3;
        css.Pack_Size_SKU__c=sku1.id;
        css.Units_1__c='Quarts';
        insert css;
        
        
        Test.startTest();
        sku1.Active_for_Liquidation__c=true;
        sku1.Unit_Cost__c=4;
        update sku1;
        
        Test.stopTest();
    }
    
    
}