@isTest(SeeAllData=false)
public class grz_FooterControllerTest {
    
     Public  static testmethod void testUPLFooterList(){        
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('UPL Footer').RecordTypeId;  
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(true, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url','en-US', recordTypeShowId);
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url','en-US', recordTypeShowId);         
        System.assert(partnerObj.id != null, 'Fail to create Partner Portal Configuration Record!');
        partnerObj1.ParentMenu__c = partnerObj.Id;
        insert partnerObj1;
         Id recordTypeShowSurvey = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CommunicationSurvey').RecordTypeId;  
        Partner_Portal_Configuration__c partnerSur = Grz_TestDataFactory.createSummaryTabs(false, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url','pt-BR', recordTypeShowSurvey);
         partnerSur.Enable_Survey__c = true;
         insert partnerSur;
         Partner_Portal_Configuration__c partnerSurIn = Grz_TestDataFactory.createSummaryTabs(false, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url','en-US', recordTypeShowSurvey);
         partnerSurIn.Enable_Survey__c = true;
         insert partnerSurIn;
         Partner_Portal_Configuration__c partnerSurEs = Grz_TestDataFactory.createSummaryTabs(false, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url','es', recordTypeShowSurvey);
         partnerSurEs.Enable_Survey__c = true;
         insert partnerSurEs;
          Partner_Portal_Configuration__c partnerSurMx = Grz_TestDataFactory.createSummaryTabs(false, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url','es-Mx', recordTypeShowSurvey);
         partnerSurMx.Enable_Survey__c = true;
         insert partnerSurMx;
         grz_FooterController.getUPLFooterList(partnerObj.Language__c);   
         grz_FooterController.getSurveyData(partnerSur.Language__c);
         grz_FooterController.getSurveyData(partnerSurIn.Language__c);
         grz_FooterController.getSurveyData(partnerSurEs.Language__c);
          grz_FooterController.getSurveyData(partnerSurMx.Language__c);
    }
}