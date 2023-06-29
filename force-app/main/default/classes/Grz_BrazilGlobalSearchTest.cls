@isTest
public class Grz_BrazilGlobalSearchTest {
	public static testmethod void test_getSalesOrderSearch()
    {
        Date startdate = Date.newInstance(2021, 04, 1);
        Date enddate = Date.newInstance(2022, 03, 31);
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'test';
        salesObj1.Type_of_Order__c = 'CONTRATO MÃE';
        salesObj1.Valid_From__c = system.today();
        insert salesObj1;
        Brazil_Portal_Configuration__c bp = new Brazil_Portal_Configuration__c();
        bp.Name = 'Configuration';
        bp.Portal_Sales_Order_Type__c = 'CONTRATO MÃE';
        insert bp;
        Grz_BrazilGlobalSearchResultController.getSalesOrder('7062133268');       
        Test.stopTest();
    }
    Public  static testmethod void testCaseRecordSearch(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();
        Test.startTest();
		Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
        Grz_BrazilGlobalSearchResultController.getCase('041');      
        Test.stopTest();
    } 
}