@isTest
public class Grz_InvoiceDetailClassChileTest {
	  
    Public  static testmethod void invoiceDetailClassChile()
    {
        Test.startTest();   
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Chile','5661');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(true, '7062140268','Approved',Date.today(), acc.Id);
        Invoice__c invo = Grz_TestDataFactory.createInvoice(false, acc.Id);
        invo.Sales_Order__c = salesObj.Id;
        invo.Billing_Date__c = Date.newInstance(2020, 12, 9);
        insert invo;
        Invoice_Line_Item__c invItem = new Invoice_Line_Item__c();
        invItem.Invoice__c = invo.Id;
        insert invItem;
        Grz_InvoiceDetailClassChile.getInvoiceDetailList(String.valueOf(invo.Id));
        test.stopTest();
    }

}