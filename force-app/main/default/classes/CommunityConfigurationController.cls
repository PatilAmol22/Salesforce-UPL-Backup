public class CommunityConfigurationController {
  private ApexPages.StandardController controller = null;    
    public CommunityConfigurationController(ApexPages.StandardController controller){
        this.controller = controller;
    }
    
     @AuraEnabled
    public static String getuserCountry(Id userId){
        try{ 
           // ResponseWrapper resWrap = new ResponseWrapper();
           
            System.debug(' vs '+userId); 
            
            User usrObj = [SELECT Id,Name,Username,Country 
                           FROM User 
                           WHERE Id =: userInfo.getUserId()];
           
               
              
            return usrObj.Country;
        }
        catch (Exception ex) {            
            throw new AuraHandledException('Darn it! Something went wrong: ' + ex.getMessage());    
        }    
        
    }
    
    
    public PageReference newredirect(){
        
      String prefix = Community_Configuration__c.SObjectType.getDescribe().getKeyPrefix();
        Map<String, String> strMap = ApexPages.currentPage().getParameters();
        String recordTypeId = strMap.get('RecordType');
        
        FieldDefinition FieldDefinitionObj = [SELECT DurableId,QualifiedApiName,Label,DeveloperName,EntityDefinitionId, DataType FROM FieldDefinition WHERE EntityDefinitionId='Community_Configuration__c' AND QualifiedApiName='Country__c' LIMIT 1];
        String customFieldId = FieldDefinitionObj.DurableId;
        customFieldId = customFieldId.right(15);
        
        //checking record type id is same or not
            String UserCountry = [SELECT Country, Id FROM User Where Id=:UserInfo.getUserId() LIMIT 1].Country;
            system.debug('UserCountry>>--->'+UserCountry);
            String param='';
            if(UserCountry!=''){
                param = getParameters() + '&'+customFieldId+'='+UserCountry;    
            }else{
                param = getParameters() + '&'+customFieldId+'=None';
            }
            
            return new PageReference('/'+prefix+'/e?nooverride=1&'+param);
  
    }
    
    // Inherit previous parameters, more imporatntly, RecordType parameter!
    private String getParameters(){
        string param = '';
        Map<String, String> strMap = ApexPages.currentPage().getParameters();
        
        String[] keys = new String[]{'RecordType', 'retURL', 'cancelURL'};
            for(String s : keys){
                if(strMap.containsKey(S)) param += s + '=' + strMap.get(s) + '&';
            }
        if(param.length() > 0) param = param.substring(0, param.length()-1);
        return param;
    }

}