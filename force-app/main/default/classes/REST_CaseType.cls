@RestResource(urlMapping='/v1/CaseType/*')
global with sharing class REST_CaseType {
    @HttpGet
    global static String doGet() {
        
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            List<CaseWrapper> lstOfCaseType ;
            List<String> options ;
            String locationJSON;
            
        try{
              
                Id DistributorRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
                RestRequest request = RestContext.request;
                lstOfCaseType = new List<CaseWrapper>();
                options = PicklistDescriber.describe('Case', DistributorRecType , 'Type');
                for(String str : options){
                    lstOfCaseType.add(new CaseWrapper(str));
                }
               locationJSON = JSON.serialize(lstOfCaseType);
                  
            }catch(Exception ex){
                
                System.debug('ErrorMsg==>'+ex);
                System.debug('Error==>'+ex.getLineNumber());
                
            }

        return locationJSON;
        
    }
    
    public class CaseWrapper{
        
        public String caseType ;
        
        public CaseWrapper(String caseType1){
                caseType = caseType1;
        }
    }
}