@isTest
public class Grz_CaseDetailMexicoTest {
	Public  static testmethod void testCaseRecordMexico(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id caserecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();  
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseCategoryMapping').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Mexico','5100');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id); 
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(false, 'Account Ledger', 'Account Ledger', 1, 'TestTab1Url', 'es-MX', recordTypeShowId);
		partnerObj.Description__c = 'Mexico_First_Case_Approval_Process_V1';
        insert partnerObj;
        Case c = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'Account Ledger', acc.Id, caserecordTypeId);
        c.IsCaseCreatedFromMxPortal__c = true;
        insert c;
        List<Case> caselist = new List<Case>();
        caselist.add(c);
        Grz_MexicoCaseApprovalHelper.submitProcessApprovalRequestMexico(caselist);
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);  
        List<Id> cvIdList = Grz_TestDataFactory.mapAttachmentToCase(true,cd.Id,c.Id);  
        CaseComment cm = Grz_TestDataFactory.createCaseComment(true,c.Id,'Test Case Feed Item');       
        String urlapex = c.Id;
        Test.startTest();
        Grz_CaseDetailMexico.getCaseDetailList(urlapex);
        Grz_CaseDetailBrazilClass.saveCaseComment(c.Id, 'Test Case Comment');
        Test.stopTest();
    }
}