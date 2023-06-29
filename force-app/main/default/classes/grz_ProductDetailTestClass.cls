@isTest
public class grz_ProductDetailTestClass {
   Public  static testmethod void testgetProductDetailList()
    {
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(true, '7062140268','Open',Date.today(), acc.Id);
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(true, '','Open',Date.today(), acc.Id);
        Sales_Order__c salesObj2 = Grz_TestDataFactory.createSalesOrderRecord(true, '','Open',null, acc.Id);
        Invoice__c invo = Grz_TestDataFactory.createInvoice(false, acc.Id);  //Code Updated by Grz(Sumit Kumar) 23-05-2023 (Ticket No. APPS-5366)
        invo.sales_org__c=sOrg.Id;
        invo.Sales_Order__c = salesObj.Id;
        invo.Billing_Doc_Number__c = '123456765';
        insert invo;
        test.stopTest();
        Grz_ProductDetailClass.getProductDetailList(String.valueOf(salesObj.Id));
        Grz_ProductDetailClass.getProductDetailList(String.valueOf(salesObj1.Id));
        Grz_ProductDetailClass.getProductDetailList(String.valueOf(salesObj2.Id));
        Grz_ProductDetailClass.InvoiceDetailWrapper inv = new Grz_ProductDetailClass.InvoiceDetailWrapper();
        Grz_ProductDetailClass.setAcknowledgement(invo.Billing_Doc_Number__c);
        inv.SAPOrderNumber = 'test';
        inv.SalesDocumentItem = 'test';
        inv.BillingItem = 'test';
        inv.Tax = 'test';
        inv.InvoiceTotalValue = 100;
        inv.transferStatus = 'test';
        inv.cancelled = 'test';
        inv.BillingType = 'test';
        inv.InvoiceName = 'test';
        inv.Cancelledbillingnumber = 'test';
    }

}