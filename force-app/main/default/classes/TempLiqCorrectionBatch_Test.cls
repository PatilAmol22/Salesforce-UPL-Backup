@isTest
public class TempLiqCorrectionBatch_Test {
     @isTest
    static void TestTemp(){
        
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'Turkey';
        salorg.Sales_Org_Code__c = '7100';
        insert salorg;
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        insert a1;
        
        SKU__c sku1 = new SKU__c();
        sku1.Active_for_Liquidation__c = true;
        sku1.SKU_Code__c = '123';
        sku1.Sales_Org__c = salorg.Id;
        insert sku1;
        
        Liquidation_Annual_Plan__c lap1 = new Liquidation_Annual_Plan__c();
        lap1.Fiscal_Start_Date__c = Date.parse('01/04/20');
        lap1.FIscal_Year__c = '2020-2021';
        lap1.Sales_Org__c = salorg.Id;
        insert lap1;
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
        system.debug('rt--->'+rt);
        Opening_Inventory2__c o1 = new Opening_Inventory2__c();
        o1.Liquidation_Annual_Plan__c = lap1.Id;
        o1.Multi_Country_Key__c = '12345';
        o1.RecordTypeId = rt.Id;
        o1.Distributor__c = a1.Id;
        o1.SKU__c = sku1.Id;
        o1.Sent_to_Batch__c = true;
        
        insert o1;
        
        RecordType rtliq = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation2__c' and Name='Multi Country'];
        Liquidation2__c l1 = new Liquidation2__c ();
        l1.Month__c = 'Nov';
        l1.Opening_Inventory2__c = o1.Id;
        l1.Liquidation_Annual_Plan__c = lap1.Id;
        l1.Distributors_Inventory__c=0;
        l1.Retailers_Inventory__c=0;
        l1.Plan_for_the_month__c=0;
        l1.RecordTypeId = rtliq.Id;
        insert l1;
        
        Database.executeBatch(new TempliqCorrectionBatch());
    }
}