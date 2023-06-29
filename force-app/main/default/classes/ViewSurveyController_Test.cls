/*
* Name : ViewSurveyController_Test
* Created on : 2nd July 2020
* Developer : Varun Shrivastava                               
* Description : To provide Coverage to ViewSurveyController class 
* Last Stable Backup : 
*/
@isTest(seeAllData=true)
private class ViewSurveyController_Test {
    public static Testmethod void testViewSurveyController() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc;   
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.init();
        System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        
        
        vsc.submitResults();
        for (ViewSurveyController.question q : vsc.allQuestions)
        {
            q.selectedOption = String.valueof(2);
            q.choices = String.valueof(2);
            q.selectedOptions = new List<String>();
            q.selectedOptions.add(String.valueof(2));
            vsc.submitResults();            
        }
        System.assertEquals(true, vsc.thankYouRendered);
        
        
        //test something
    }
    
    public static Testmethod void testUpdateSurveyName() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc; 
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.surveyName = 'new name';
        system.assert(vsc.updateSurveyName() == null);
        
    }
    
    public static Testmethod void testupdateSurveyThankYouAndLink() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc; 
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.surveyThankYouText = 'new stuff';
        vsc.surveyThankYouURL = 'more new stff';
        system.assert(vsc.updateSurveyThankYouAndLink()==null);
    }
    
}