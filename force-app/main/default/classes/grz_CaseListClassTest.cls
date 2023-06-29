@isTest
public class grz_CaseListClassTest {
      Public  static testmethod void testCaseRecord(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        Test.startTest();
		Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Case ca = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        ca.CaseOwner__c = 'RCM';
        insert ca;
        Grz_TestDataFactory.createCaseRecord(true, 'Test', 'New ', acc.Id, recordTypeShowId);
        grz_CaseListClass.getCaseListAll('en-US','', 'Createddate','2020-01-01','2030-01-01','New', 1, 10,'All','');
        grz_CaseListClass.getCaseListAll('en-US','Test Case', 'Createddate','2020-01-01','2030-01-01', 'New', 1, null,'All','');
        grz_CaseListClass.getCaseListAll('en-US','Test Case', null, '2020-01-01','2030-01-01','New', 200, 200,'All','');
        //Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        new grz_CaseListClass().getCaseListVF();
        Test.stopTest();
    }  
    Public  static testmethod void testCaseRecordBrazil(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();
        Test.startTest();
		Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
        //Grz_TestDataFactory.createCaseRecord(true, 'Test', 'New ', acc.Id, recordTypeShowId);
        grz_CaseListClass.getCaseListAll('pt-BR','', 'Createddate','2020-01-01','2030-01-01', 'New', 1, 10,'All','');
        grz_CaseListClass.getCaseListAll('pt-BR','Test Case', 'Createddate','2020-01-01','2030-01-01', 'New', 1, null,'All','');
       // grz_CaseListClass firstcase = new grz_CaseListClass();
       // firstcase.getCaseListVF();
        //grz_CaseListClass.getCaseListAll('pt-BR','Test Case', null,'2020-01-01','2030-01-01', 'New', 200, 200,'All','');
        Test.stopTest();
    } 
    
    Public  static testmethod void testCaseRecordBrazil2(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();
        Test.startTest();
		Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        //Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
        Grz_TestDataFactory.createCaseRecord(true, 'Test', 'New ', acc.Id, recordTypeShowId);
        //grz_CaseListClass.getCaseListAll('pt-BR','', 'Createddate','2020-01-01','2030-01-01', 'New', 1, 10,'All');
        //grz_CaseListClass.getCaseListAll('pt-BR','Test Case', 'Createddate','2020-01-01','2030-01-01', 'New', 1, null,'All');
        grz_CaseListClass.getCaseListAll('pt-BR','Test Case', null,'2020-01-01','2030-01-01', 'New', 200, 200,'All','');
        Test.stopTest();
    }
    
    Public  static testmethod void testCaseRecordMexico(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();  
        Test.startTest();
		Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, recordTypeShowId);
        grz_CaseListClass.getCaseListAll('es-MX','', 'Createddate','2020-01-01','2030-01-01', 'All', 1, 10,'All','');
        grz_CaseListClass.getCaseListAll('es-MX','Test Case', 'Createddate','2020-01-01','2030-01-01', 'New', 1, null,'All','');
        //grz_CaseListClass.getCaseListAll('pt-BR','Test Case', null,'2020-01-01','2030-01-01', 'New', 200, 200,'All');
        Test.stopTest();
    } 
}