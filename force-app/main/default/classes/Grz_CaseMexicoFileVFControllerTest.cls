@isTest
public class Grz_CaseMexicoFileVFControllerTest {
    Public  static testmethod void Grz_CaseBrazilVFTest(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User usr= Grz_TestDataFactory.createInternalUser(true,p.id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();  
        Account acc = Grz_TestDataFactory.createAccount(true,'Test Account',recordTypeId); 
        Case ca = Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, caseRecordTypeId);        
        
        Test.startTest();
        PageReference pageRef = Page.Grz_CaseBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey',ca.Casenumber);
        pageRef.getParameters().put('distributor','All');
        pageRef.getParameters().put('status','All');
        Test.setCurrentPage(pageRef);
        Grz_CaseMexicoFileVFController abc = new Grz_CaseMexicoFileVFController();
        abc.Grz_CaseListVF();
        Test.stopTest(); 
    }
}