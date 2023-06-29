@isTest
public class grz_TileViewCountControllerTest {
    
    Public  static testmethod void testCaseCount(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        Brazil_Portal_Configuration__c bp = new Brazil_Portal_Configuration__c();
        bp.Name = 'Configuration';
        bp.Portal_Sales_Order_Type__c = 'CONTRATO MÃE';
        insert bp;
        Test.startTest();
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        case c1 =Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'Dispatch', acc.Id, recordTypeShowId);
        c1.Description='Test Case';
        insert c1;
        grz_TileViewCountController.getOrderAndTicketCount();
        grz_TileViewCountController.getOrderAndTicketCountAll('pt-BR');
        grz_TileViewCountController.getOrderAndTicketCountAll('es');
        grz_TileViewCountController.getOrderAndTicketCountBrazil();
        Test.stopTest();
    }
    
    Public  static testmethod void testSalesCount(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Test.startTest();
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(true, '7062140268','Open',Date.today(), acc.Id);
        grz_TileViewCountController.getOrderAndTicketCount();
        Test.stopTest();
    }
    
    Public  static testmethod void testRecordCountMx(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();  
        Test.startTest();
        Sales_Org__c sorgMx = Grz_TestDataFactory.createSalesOrg(true, 'Mexico','5100');
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
		Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(false, '5434265676','Approved',Date.today(), acc.Id);
        salesObj.Sales_Org_lk__c = sorgMx.Id;
        salesObj.Total_Amount__c = 5000; 
        insert salesObj;
        grz_TileViewCountController.getOrderAndTicketCountAll('es-MX');
        Test.stopTest();
    }
}