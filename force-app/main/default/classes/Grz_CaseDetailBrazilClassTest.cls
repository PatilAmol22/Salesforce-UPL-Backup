@isTest
public class Grz_CaseDetailBrazilClassTest {
	Public  static testmethod void testCaseRecord(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Brazil Case Process').RecordTypeId;  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Case c = Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'Pendente Analista', acc.Id, recordTypeShowId);
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);  
        List<Id> cvIdList = Grz_TestDataFactory.mapAttachmentToCase(true,cd.Id,c.Id);  
        CaseComment cm = Grz_TestDataFactory.createCaseComment(true,c.Id,'Test Case Feed Item');       
        String urlapex = c.Id;
        Test.startTest();
        Grz_CaseDetailBrazilClass.getCaseDetailList(urlapex);
        Grz_CaseDetailBrazilClass.saveCaseComment(c.Id, 'Test Case Comment');
        c.AgentAnswer__c ='Test Reason';
        c.Reason='Unknown';
        update c;
        Test.stopTest();
    }
    Public  static testmethod void testCaseRecord1(){
        Test.startTest();
        Grz_CaseDetailBrazilClass.saveCaseComment(null, null);
        Grz_CaseDetailBrazilClass.getContentDistribution(null);
        Test.stopTest();
    }
    Public  static testmethod void testCaseRecord2(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Brazil Case Process').RecordTypeId;  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Case c = Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'Pendente Analista', acc.Id, recordTypeShowId);
        Test.startTest();
        Grz_CaseDetailBrazilClass.CloseCase(c.Id, 'Test Reason');
        Grz_CaseDetailBrazilClass.CloseCase(c.Id, null);
        Test.stopTest();
        
    }
}