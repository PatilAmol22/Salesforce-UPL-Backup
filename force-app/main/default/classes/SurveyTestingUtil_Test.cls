/*
* Name : SurveyTestingUtil_Test
* Created on : 2nd July 2020
* Developer : Varun Shrivastava                               
* Description : To provide Coverage to SurveyTestingUtil class 
* Last Stable Backup : 
*/
@isTest(seeAllData=true)
private class SurveyTestingUtil_Test {
    
    public static TestMethod void testConstructor(){
        SurveyTestingUtil tu = new SurveyTestingUtil();
        System.assert(tu.surveyId != null);
    }
    
}