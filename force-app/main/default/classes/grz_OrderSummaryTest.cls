@isTest
public class grz_OrderSummaryTest {
   public static testmethod void test_getSalesOrderRecord()
    {
		
		Date startdate = Date.newInstance(2021, 04, 1);
        Date enddate = Date.newInstance(2022, 03, 31);
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
		Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'india', '1000');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062140268','Open',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        insert salesObj1;
      	grz_OrderSummary.getSalesOrderRecord('7062140268','CreatedDate' ,'Open',startdate, enddate, 1, 10);       
        grz_OrderSummary.getSalesOrderRecord('7062140268','CreatedDate' ,'Open',startdate, enddate, 1, Null);
  	 	Test.stopTest();
    }

}