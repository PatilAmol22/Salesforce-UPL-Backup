public with sharing class OnBoardingMDOController {
    
    
    @AuraEnabled
    public static Boolean gettingMDODetail(String recoId){
        Boolean isMDO;
        try{
            System.debug('In Apex class '+recoId);
            
            Account AccObj = new Account();
            if(recoId!=null){
                AccObj = [Select Id,Name,MDO_Code__c,ApprovalStatus__c,Error_Message__c From Account 
                          WHERE Id=:recoId];
                if(AccObj!=null){
                    System.debug('AccObj.MDO_Code__c '+AccObj.MDO_Code__c);
                    if(AccObj.MDO_Code__c!=null){
                        isMDO = false;
                        System.debug('Null Not');
                    }else{
                        isMDO= true;
                        System.debug('Null yes');
                    }
                    
                }
                
            }
            
        }
        catch(Exception ex){
            System.debug('Error Occure '+ex.getLineNumber());
            System.debug('Error Occure '+ex.getMessage());
        }
        
        return isMDO;
        
        
    }
    
    @AuraEnabled
    public static void callingOnboardingServices(String recoId){
        System.debug('callingOnboardingServices '+recoId);
        AccountOnBoardingService.pushAccount(recoId);
        
    }
    
    
    
    
}