@isTest(SeeAllData=false)
public class Grz_FeatureLinksControllerTest {
	
    Public  static testmethod void testFeatureLinksList(){		
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('Featured Link').RecordTypeId;     	
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(true, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url', 'en-US', recordTypeShowId);
        System.assert(partnerObj.id != null, 'Fail to create Partner Portal Configuration Record!');
        Grz_FeatureLinksController.getFeatureLinksList(partnerObj.Language__c);
    }
    
}