public with sharing class SORedirectController {
    @AuraEnabled
    public static String getLoginUserDetails(){
        String country='';
        try {
        
            User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, 
                        ManagerId FROM User where Id =:UserInfo.getUserId()];

            if(user != null){
                Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

                if(logCntry != null){
                    country = logCntry.For_Contry__c;
                }
            }
        
        } 
        catch (Exception ex) {
                System.debug('Exception in getLoginUserDetails method...:- '+ ex);
                System.debug('Exception Line  ...:- '+ ex.getLineNumber());
        }
                
        return country;
    }
}