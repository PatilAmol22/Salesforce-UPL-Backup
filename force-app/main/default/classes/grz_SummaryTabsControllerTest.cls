@isTest(SeeAllData=false)
public class grz_SummaryTabsControllerTest {
    
	Public  static testmethod void testSummaryTabsList(){
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('Summary Tabs').RecordTypeId;     	
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(true, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url', 'en-US', recordTypeShowId);
        System.assert(partnerObj.id != null, 'Fail to create Partner Portal Configuration Record!');
        grz_SummaryTabsController.getSummaryTabsList(partnerObj.Language__c);
        grz_SummaryTabsController.getNotice(partnerObj.Language__c);
    }
    Public  static testmethod void testGetNotice(){
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('Notification').RecordTypeId;     	
        Partner_Portal_Configuration__c pr = new Partner_Portal_Configuration__c();
        pr.RecordTypeId = recordTypeShowId;
        pr.URL__c = 'www.test.com';
        pr.Description__c = 'test data';
        pr.Language__c = 'pt-BR';
        insert pr;
        grz_SummaryTabsController.getNotice('pt-BR');
    }
}