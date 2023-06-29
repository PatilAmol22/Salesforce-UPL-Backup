/*
* Name: NewAccountOverride_Controller
* Created On: 27 Jan 2020   
* Author: Ketan Khatri (ketan.khatri@skinternational.com)
* Description: Created as controller for lighting component NewAccountOverride.
                to override standard New Button in lightining
* Supporting Class:  (Test Class)
* Last Stable Back up : 
*/

public class NewAccountOverride_Controller {

    @AuraEnabled
    public static ResponseWrapper isProspectCustomer(Id recTypeId){
        try{ 
            ResponseWrapper resWrap = new ResponseWrapper();
            Id prospectRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
            System.debug(prospectRecTypeId+' vs '+recTypeId); 
            
            User usrObj = [SELECT Id,Name,Username,Country 
                           FROM User 
                           WHERE Id =: userInfo.getUserId()];
            if(recTypeId == prospectRecTypeId & usrObj!=NULL){
                resWrap.isProspect = true;
                resWrap.userCountry = usrObj.Country;
            }
            else{
                resWrap.isProspect = false;
                resWrap.userCountry = usrObj.Country;
            }
            return resWrap;
        }
        catch (Exception ex) {            
            throw new AuraHandledException('Darn it! Something went wrong: ' + ex.getMessage());    
        }    
        
    }
    
    public class ResponseWrapper{
        @AuraEnabled public boolean isProspect;
        @AuraEnabled public string userCountry;
        
        public ResponseWrapper(){
            isProspect = false;
            userCountry = '';
        }
      
    }
    
}