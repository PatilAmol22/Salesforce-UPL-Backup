@isTest
public class Grz_SalesOrderListMexicoTest {
    public static testmethod void test_getSalesOrderRecordMexico()
    {
        
        Date startdate = Date.newInstance(2021, 04, 1);
        Date enddate = Date.newInstance(2022, 03, 31);
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Mexico', '5100');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Approved',Date.today(), acc.Id);
       salesObj1.Sales_Org_lk__c = sorg.Id;
       insert salesObj1;
        Grz_SalesOrderListMexico.getSalesOrderRecord('','CreatedDate asc','All',1,1,'2020-01-01','2030-01-01','All');       
       Grz_SalesOrderListMexico.getSalesOrderRecord('70',null,'Abierto',1,null,'2020-01-01','2030-01-01','All');
        
        Test.stopTest();
    }
    
}