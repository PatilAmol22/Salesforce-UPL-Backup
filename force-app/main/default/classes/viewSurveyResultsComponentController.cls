public with sharing class viewSurveyResultsComponentController {
    
    public String surveyId {get;set;}
    
    
    public String reportId {get;set;}
    public PageReference results;
    
    public viewSurveyResultsComponentController()
    {
        ReportFinderUtil rfu = new ReportFinderUtil();
        reportId = rfu.findReportId('Survey with Questions and Responses'); 
        
    }
    public pageReference getResults()
    {
        surveyId = surveyId.substring(0,15);
        return new PageReference('/' + reportId + '?pv0=' + surveyId);
    }
}