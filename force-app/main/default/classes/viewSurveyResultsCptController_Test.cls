/*
* Name : viewSurveyResultsCptController_Test
* Created on : 2nd July 2020
* Developer : Varun Shrivastava                               
* Description : To provide Coverage to viewShareSurveyComponentController class 
* Last Stable Backup : 
*/
@isTest(seeAllData=true)
private class viewSurveyResultsCptController_Test {
    public static testmethod void testResultController()
    {
        Survey__c mySurvey = new Survey__c();
        mySurvey.Submit_Response__c = 'empty';  
        insert mySurvey;
        
        viewSurveyResultsComponentController vsr = new viewSurveyResultsComponentController();
        vsr.surveyId = mySurvey.Id;
        
        String mySurveyId = mySurvey.Id;
        PageReference pageRef = new PageReference ('/' + vsr.reportId + '?pv0=' + mySurveyId.substring(0,15));
        System.assertEquals(pageRef.getURL(),vsr.getResults().getURL());
        
    }
}