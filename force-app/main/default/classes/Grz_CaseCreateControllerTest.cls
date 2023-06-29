@isTest
public class Grz_CaseCreateControllerTest {
    Public  static testmethod void testCaseController(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id caseRecId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'india','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        List<String> cdList = new List<String>();
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);  
        cdList.add(cd.ID);        
        Test.startTest();
        Case c = new Case();
        c.Subject = 'Test Case';
        c.Description = 'Test Case';
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;     	
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(false, 'CaseTypePicklist', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeShowId);
        partnerObj.CaseType__c = 'Test1,Test2';
        insert partnerObj;
        Grz_TestDataFactory.createCaseMatrix(true, 'Invoice', 'C & F;RCM',sOrg.Id);
        System.assert(partnerObj.id != null, 'Fail to create Partner Portal Configuration Record!');
        Grz_CaseCreateController.fetchUser();
        Grz_CaseCreateController.createCase(c,'Invoice',acc.Id,cdList);
        Grz_CaseCreateController.createCase(c,'Outstanding',acc.Id,cdList);
        Test.stopTest();
    }
    
    Public  static testmethod void testCaseController2(){
        List<String> cdDelList = new List<String>();
        ContentDocument cdDel = Grz_TestDataFactory.createContentDocument(true);  
        cdDelList.add(cdDel.ID);
        Grz_CaseCreateController.deleteAttachments(cdDelList);
    }
}