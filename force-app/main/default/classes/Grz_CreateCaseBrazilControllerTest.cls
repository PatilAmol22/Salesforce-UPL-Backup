@isTest(SeeAllData=false)
public class Grz_CreateCaseBrazilControllerTest {
    Public  static testmethod void testCaseControllerBrazilCat(){
        Grz_CreateCaseBrazilController.CaseCategory('test');
    }
	Public  static testmethod void testCaseControllerBrazil(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id caseRecId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'brazil','5190');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        List<String> cdList = new List<String>();
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);  
        cdList.add(cd.ID);        
        Test.startTest();
        Case c = new Case();
        c.Subject = 'Test Case Brazil 07-06-2021';
        c.Description = 'Test Case Brazil 07-06-2021';
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(false, 'CaseTypePicklistBrazil', 'CaseTypePicklistBrazil', 1, 'TestTab1Url', 'pt-BR', recordTypeShowId);
        partnerObj.CaseType__c = 'Test1,Test2';
        insert partnerObj;
        Grz_TestDataFactory.createCaseMatrix(true, 'Falta de Receituário na Entrega', 'BRUNA.DE FARIA HERMANN',sOrg.Id);
        System.assert(partnerObj.id != null, 'Fail to create Partner Portal Configuration Record!');
        Grz_CreateCaseBrazilController.fetchUser();
        Grz_CreateCaseBrazilController.createCase(c,'Falta de Receituário na Entrega',acc.Id,cdList);
        Grz_CreateCaseBrazilController.createCase(c,'Problemas em Preço e Prazo',acc.Id,cdList);
        Test.stopTest();
    }
    Public  static testmethod void testCaseControllerBrazil2(){
        List<String> cdDelList = new List<String>();
        ContentDocument cdDel = Grz_TestDataFactory.createContentDocument(true);  
        cdDelList.add(cdDel.ID);
        Grz_CreateCaseBrazilController.deleteAttachments(cdDelList);
        Grz_CreateCaseBrazilController.contentsize(cdDelList[0]);
    }
}