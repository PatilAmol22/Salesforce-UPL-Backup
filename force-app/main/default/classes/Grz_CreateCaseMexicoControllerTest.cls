@isTest
public class Grz_CreateCaseMexicoControllerTest {
    
		Public  static testmethod void testCaseControllerMexico(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id caserecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();  
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Mexico','5100');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        List<String> cdList = new List<String>();
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);  
        cdList.add(cd.ID);        
        Test.startTest();
        Case c = new Case();
        c.Subject = 'Test Case Brazil 07-06-2021';
        c.Description = 'Test Case Brazil 07-06-2021';
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseCategoryMapping').RecordTypeId;
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(false, 'Account Ledger', 'Account Ledger', 1, 'TestTab1Url', 'es-MX', recordTypeShowId);
		partnerObj.Description__c = 'Mexico_First_Case_Approval_Process_V1';
        insert partnerObj;
        //Grz_TestDataFactory.createCaseMatrix(true, 'Falta de Receituário na Entrega', 'BRUNA.DE FARIA HERMANN',sOrg.Id);
        System.assert(partnerObj.id != null, 'Fail to create Partner Portal Configuration Record!');
        Grz_CreateCaseMexicoController.fetchUser();
        Grz_CreateCaseMexicoController.createCase(c, 'Account Ledger', acc.Id, cdList);
        Grz_CreateCaseMexicoController.createCase(c, 'Test', acc.Id, cdList);
        Test.stopTest();
    }
    Public  static testmethod void testCaseControllerMexico2(){
        List<String> cdDelList = new List<String>();
        ContentDocument cdDel = Grz_TestDataFactory.createContentDocument(true);  
        cdDelList.add(cdDel.ID);
        Grz_CreateCaseMexicoController.deleteAttachments(cdDelList);
        Grz_CreateCaseMexicoController.contentsize(cdDelList[0]);
    }
}