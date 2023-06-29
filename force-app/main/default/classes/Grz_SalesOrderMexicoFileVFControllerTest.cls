@isTest
public class Grz_SalesOrderMexicoFileVFControllerTest {
Public  static testmethod void Grz_SalesOrderMexicoVFTest(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Mexico', '5100');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        
    	//salesObj1.Type_of_Order__c = 'BONIFICAÇÃO';
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderMexicopdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133268');
    	
    	pageRef.getParameters().put('sortby','BONIFICAÇÃO');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderMexicoFileVFController abc = new Grz_SalesOrderMexicoFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest(); 
    }
    Public  static testmethod void Grz_SalesOrderBrazilVFTest1(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Mexico', '5100');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133238','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderMexicopdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133238');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderMexicoFileVFController abc = new Grz_SalesOrderMexicoFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest(); 
    }
}