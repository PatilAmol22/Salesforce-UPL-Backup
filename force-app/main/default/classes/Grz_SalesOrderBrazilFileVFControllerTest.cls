@isTest
public class Grz_SalesOrderBrazilFileVFControllerTest {
    Public  static testmethod void Grz_SalesOrderBrazilVFTest(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'Pedido em Análise';
        salesObj1.Type_of_Order__c = 'BONIFICAÇÃO';
         salesObj1.Currency_Brazil__c='Billing USD / Payment USD';
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133268');
        pageRef.getParameters().put('invoicedata','B');
        pageRef.getParameters().put('sortby','BONIFICAÇÃO');
        pageRef.getParameters().put('viewUndeliveredOrders','false');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderBrazilFileVFController abc = new Grz_SalesOrderBrazilFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest(); 
    }
    Public  static testmethod void Grz_SalesOrderBrazilVFTest1(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133238','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'Faturado';
         salesObj1.Currency_Brazil__c='Billing USD / Payment USD';
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133238');
        pageRef.getParameters().put('viewUndeliveredOrders','false');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderBrazilFileVFController abc = new Grz_SalesOrderBrazilFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest(); 
    }
    Public  static testmethod void unitTest1(){
       Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133238','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'Faturado Parcial';
          salesObj1.Currency_Brazil__c='Billing USD / Payment USD';
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133238');
        pageRef.getParameters().put('viewUndeliveredOrders','false');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderBrazilFileVFController abc = new Grz_SalesOrderBrazilFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest(); 
    }
     Public  static testmethod void unitTest2(){
       Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133238','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'Entrega prevista';
         salesObj1.Currency_Brazil__c='Billing USD / Payment BRL';
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133238');
        pageRef.getParameters().put('viewUndeliveredOrders','true');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderBrazilFileVFController abc = new Grz_SalesOrderBrazilFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest();  
    }
    Public  static testmethod void unitTest3(){
         Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133238','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'Entregue em';
        salesObj1.Currency_Brazil__c='Billing BRL / Payment BRL';
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133238');
        pageRef.getParameters().put('viewUndeliveredOrders','true');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderBrazilFileVFController abc = new Grz_SalesOrderBrazilFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest();
    }
     Public  static testmethod void unitTest4(){
         Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133238','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
         salesObj1.Currency_Brazil__c='Billing BRL / Payment BRL';
        //salesObj1.Invoice_Status__c = 'Entregue em';
        insert salesObj1;
        Test.startTest();
        PageReference pageRef = Page.Grz_SalesOrderBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey','7062133238');
         pageRef.getParameters().put('viewUndeliveredOrders','false');
        Test.setCurrentPage(pageRef);
        Grz_SalesOrderBrazilFileVFController abc = new Grz_SalesOrderBrazilFileVFController();
        abc.Grz_SalesOrderListVF();
        Test.stopTest();
    }
}