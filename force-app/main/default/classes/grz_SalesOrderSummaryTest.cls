@isTest(SeeAllData=false)
public class grz_SalesOrderSummaryTest {
    
    Public  static testmethod void testSalesOrderRecord(){  
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'india', '1000');
        
        List<Sales_Order__c> saleList = new List<Sales_Order__c>();
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '7062140268','Open',Date.today(), acc.Id);
        salesObj.Sales_Org_lk__c = sorg.Id;
        salesObj.Total_Amount__c = 500;
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '','Not Relevant',null, acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        Sales_Order__c salesObj2 = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265176','Approved',Date.today(), acc.Id);
        salesObj2.Sales_Org_lk__c = sorg.Id;
        Sales_Order__c salesObj3 = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265676','Request for Cancellation',Date.today(), acc.Id);
        salesObj3.Sales_Org_lk__c = sorg.Id;
        saleList.add(salesObj);
        saleList.add(salesObj1);
        saleList.add(salesObj2);
        saleList.add(salesObj3);
        Test.startTest();
        insert saleList;
        Sales_Order_Line_Item__c saleline = Grz_TestDataFactory.createsalesLineItemsRecord(false, salesObj.Id, 20);
        saleline.Price__c = 200;
        saleline.Quantity__c = 10;
        insert saleline;
        grz_SalesOrderSummary.getSalesOrderRecordAll('en-US');
        Test.stopTest();
    }
    
    
    
    Public  static testmethod void testSalesOrderRecordChile(){  
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorgCl = Grz_TestDataFactory.createSalesOrg(true, 'Chile', '5661');
        List<Sales_Order__c> saleList = new List<Sales_Order__c>();
        
        Sales_Order__c salesObj4 = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265676','Approved',Date.today(), acc.Id);
        salesObj4.Sales_Org_lk__c = sorgCl.Id;
        
        saleList.add(salesObj4);
        Test.startTest();
        insert saleList;
        grz_SalesOrderSummary.FormattedDateBr(System.now());
        grz_SalesOrderSummary.getSalesOrderRecordAll('es');
        Test.stopTest();
    }
    
    Public  static testmethod void testSalesOrderRecordMexico(){  
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true,'Test Account',recordTypeId);
        Sales_Org__c sorgMx = Grz_TestDataFactory.createSalesOrg(true, 'Mexico','5100');
        List<Sales_Order__c> saleList = new List<Sales_Order__c>();
        
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265676','Approved',Date.today(), acc.Id);
        salesObj.Sales_Org_lk__c = sorgMx.Id;
        salesObj.Total_Amount__c = 5000;
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '','Open',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorgMx.Id;
        salesObj1.Total_Amount__c = 15000;
        saleList.add(salesObj);
        saleList.add(salesObj1);
        Test.startTest();
        insert saleList;
        grz_SalesOrderSummary.getSalesOrderRecordAll('es-MX');
        Test.stopTest();
    }
    
    
    Public  static testmethod void testSalesOrderRecordBrazil(){  
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg1 = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        List<Sales_Order__c> saleList = new List<Sales_Order__c>();
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '7062140268','Approved',Date.today(), acc.Id);
        salesObj.Sales_Org_lk__c = sorg1.Id;
        salesObj.Total_Amount__c = 500;
        salesObj.Valid_To__c = Date.newInstance(2021, 12, 9);
        salesObj.Valid_From__c = Date.newInstance(2022, 10, 9);
        salesObj.Type_of_Order__c = 'CONTRATO MÃE';
        salesObj.Invoice_Status__c = 'Crédito Liberado';
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '','Approved',null, acc.Id);
        salesObj1.Sales_Org_lk__c = sorg1.Id;
        salesObj1.Invoice_Status__c = 'Faturado';
        salesObj1.Valid_To__c = Date.newInstance(2021, 12, 9);
        salesObj1.Valid_From__c = Date.newInstance(2022, 10, 9);
        salesObj1.Type_of_Order__c = 'CONTRATO MÃE';
        Sales_Order__c salesObj2 = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265176','Approved',Date.today(), acc.Id);
        salesObj2.Sales_Org_lk__c = sorg1.Id;
        salesObj2.Invoice_Status__c = 'Entregue em';
        salesObj2.Type_of_Order__c = 'CONTRATO MÃE';
        salesObj2.Valid_From__c = Date.newInstance(2022, 10, 9);
        salesObj2.Valid_To__c = Date.newInstance(2021, 12, 9);
        Sales_Order__c salesObj3 = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265676','Approved',Date.today(), acc.Id);
        salesObj3.Sales_Org_lk__c = sorg1.Id;
        salesObj3.Invoice_Status__c = 'Entrega prevista para';
        salesObj3.Type_of_Order__c = 'CONTRATO MÃE';
        salesObj3.Valid_From__c = Date.newInstance(2022, 10, 9);
        salesObj3.Valid_To__c = Date.newInstance(2021, 12, 9);
        saleList.add(salesObj);
        saleList.add(salesObj1);
        saleList.add(salesObj2);
        saleList.add(salesObj3);
        Brazil_Portal_Configuration__c bp = new Brazil_Portal_Configuration__c();
        bp.Name = 'Configuration';
        bp.Portal_Sales_Order_Type__c = 'CONTRATO MÃE';
        insert bp;
        Test.startTest();
        insert saleList;
        grz_SalesOrderSummary.FormattedDateBr(System.now());
        grz_SalesOrderSummary.getSalesOrderRecordAll('pt-BR');
        grz_SalesOrderSummary.getSalesOrderRecordAll('es');
        Test.stopTest();
    }
    Public  static testmethod void testCaseRecord(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
        grz_SalesOrderSummary.getCaseRecordAll('en-US');
    }
    
    Public  static testmethod void testCaseRecordMx(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();  
        Test.startTest();
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
        grz_SalesOrderSummary.getCaseRecordAll('es-MX');
        Test.stopTest();
    }
    
    Public  static testmethod void testCaseRecordBr(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId(); 
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
        grz_SalesOrderSummary.getCaseRecordAll('pt-BR');
    }
    
}