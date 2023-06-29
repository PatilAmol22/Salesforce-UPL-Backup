@isTest
public class MultiCountryLiqAnnualPlanScheduler_Test {
    static testmethod void  testschedule(){
        
        Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'Indo1';
         salorg.Sales_Org_Code__c = '6451';
         insert salorg;
        
         Sales_Org__c salorg2 = new Sales_Org__c();
         salorg2.name = 'Indo2';
         salorg2.Sales_Org_Code__c = '6410';
         insert salorg2;
        
        Sales_Org__c salorg3 = new Sales_Org__c();
         salorg3.name = 'Mexico';
         salorg3.Sales_Org_Code__c = '5100';
         insert salorg3;
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        a1.Active_For_Liquidation__c = true;
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'Test2';
        a2.RecordTypeId = RecordTypeId;
        a2.SAP_Code__c = '12345';
        a2.Active_For_Liquidation__c = true;
        insert a2;
        
        DistributorSalesAreaMapping__c DSA = new DistributorSalesAreaMapping__c();
        DSA.SalesOrg__c = salorg.Id;
        DSA.AccountType__c = 'Sold To Party';
        DSA.Distributor__c = a1.Id;
        insert DSA;
        
        DistributorSalesAreaMapping__c DSA2 = new DistributorSalesAreaMapping__c();
        DSA2.SalesOrg__c = salorg2.Id;
        DSA2.AccountType__c = 'Sold To Party';
        DSA2.Distributor__c = a2.Id;
        insert DSA2;
        
        Shipping_Location__c sl1 = new Shipping_Location__c();
        sl1.Distributor__c = a1.Id;
        sl1.Active_for_Liquidation__c = true;
        sl1.Sales_Org__c = Salorg3.Id;
        sl1.SAP_Code__c = '21212';
        insert sl1;
        
        Liquidation_Batch_Filters__c lbf1 = new Liquidation_Batch_Filters__c();
        lbf1.Name = 'Indonesia';
        lbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf1.Active__c = true;
        insert lbf1;
        
        Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Mexico';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'5100\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Active__c = true;
        insert lbf2;
        
        MultiCountryLiqAnnualPlanScheduler sh1 = new MultiCountryLiqAnnualPlanScheduler();      
         String sch = '0  00 1 3 * ?';
         system.schedule('Test', sch, sh1);
        
      
    }
}