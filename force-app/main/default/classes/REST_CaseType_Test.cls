@isTest
public class REST_CaseType_Test{
    
      /* 
        -----------------------------
        Developer Name - Pravin J.
        Created Date -  18/09/2017
        Last Modified Date - -------
        Description - class created for
        Mobile Development Purpose
        ------------------------------
    */
    
    
    public REST_CaseType_Test(){
        System.debug('--Constructor Calling--');    
    } 
     
    private static testMethod void test1(){
    
        test.startTest();
        
           /* RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestURI = '/v1/CaseType/*';
            req.httpMethod = 'GET';
            
            RestContext.request = req;
            RestContext.response= res;
            
            */
            REST_CaseType rest = new REST_CaseType();
            REST_CaseType.doGet();
        
        test.stopTest();
    
    }
    
    
}