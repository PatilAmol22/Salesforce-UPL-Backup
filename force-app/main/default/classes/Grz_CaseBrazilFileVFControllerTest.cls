@isTest
public class Grz_CaseBrazilFileVFControllerTest {
    Public  static testmethod void Grz_CaseBrazilVFTest(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User usr= Grz_TestDataFactory.createInternalUser(true,p.id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Entitlement et=new Entitlement();
        et.Name='Brazil SLAs';
        et.AccountId=acc.id;
        insert et; 
        Case ccase = Grz_TestDataFactory.createBrazilCaseRecord(false,'Test','Order rescheduling',acc.Id,caseRecordTypeId,et.Id,usr.Id);
        ccase.Subject = 'Test';
        ccase.Priority ='High';
        ccase.RecordTypeId =caseRecordTypeId;
        insert ccase;
        
        Test.startTest();
        //Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, caseRecordTypeId);
        PageReference pageRef = Page.Grz_CaseBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey',ccase.Casenumber);
        pageRef.getParameters().put('distributor','All');
        pageRef.getParameters().put('status','All');
          //pageRef.getParameters().put('subGroupId','1234');
        
        Test.setCurrentPage(pageRef);
        Grz_CaseBrazilFileVFController abc = new Grz_CaseBrazilFileVFController();
        abc.Grz_CaseListVF();
        Grz_CaseBrazilFileVFController.ResultWrapper ob= new  Grz_CaseBrazilFileVFController.ResultWrapper();
        ob.closeDate='closeDate';
        Test.stopTest(); 
    }
    Public  static testmethod void Grz_CaseBrazilVFTest1(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User usr= Grz_TestDataFactory.createInternalUser(true,p.id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Entitlement et=new Entitlement();
        et.Name='Brazil SLAs';
        et.AccountId=acc.id;
        insert et; 
        Case ccase = Grz_TestDataFactory.createBrazilCaseRecord(false,'Test','Order rescheduling',acc.Id,caseRecordTypeId,et.Id,usr.Id);
        ccase.Subject = 'Test';
        ccase.Priority ='High';
        ccase.RecordTypeId =caseRecordTypeId;
        insert ccase;
        
        Test.startTest();
        //Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'New', acc.Id, caseRecordTypeId);
        PageReference pageRef = Page.Grz_CaseBrazilpdfDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('searchKey',ccase.Casenumber);
        pageRef.getParameters().put('distributor','All');
        pageRef.getParameters().put('status','All');
          pageRef.getParameters().put('subGroupId','1234');
        
        Test.setCurrentPage(pageRef);
        Grz_CaseBrazilFileVFController abc = new Grz_CaseBrazilFileVFController();
        abc.Grz_CaseListVF();
        Grz_CaseBrazilFileVFController.ResultWrapper ob= new  Grz_CaseBrazilFileVFController.ResultWrapper();
        ob.closeDate='closeDate';
        Test.stopTest(); 
    }
    
}