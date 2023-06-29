/*
* Name : GSurveysController_Test
* Created on : 2nd July 2020
* Developer : Varun Shrivastava                               
* Description : To provide Coverage to GSurveysController class 
* Last Stable Backup : 
*/
@isTest(seeAllData=true)
private class GSurveysController_Test {
    
    public static TestMethod void testDeleteSurvey(){
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('uId', Userinfo.getUserId());
        Apexpages.Standardcontroller stc;
        GSurveysController sc = new GSurveysController(stc);
        System.assertEquals(GSurveysController.deleteSurvey(tu.surveyId),'true');
    }
    
    public static TestMethod void testMakeNewSurvey(){
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('uId', Userinfo.getUserId());
        Apexpages.Standardcontroller stc;
        GSurveysController sc = new GSurveysController(stc);
        System.assert(sc.makeNewSurvey()==null);
        sc.surveySite = '--SELECT SITE--';
        sc.newSurveyName = 'TestMakeNewSurvey';
        system.assert(sc.makeNewSurvey()==null);
        sc.surveySite = 'blah';
        System.assert(sc.makeNewSurvey()!=null);
        sc.doSurveyReset();     
    }
    
    public static TestMethod void testGSurveysController(){
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('uId', Userinfo.getUserId());
        Apexpages.Standardcontroller stc;
        GSurveysController sc = new GSurveysController(stc);
        System.assert(sc.allSurveys.size()>0);
    }
}