/*Class Name:-AccountRedirectExtension
calling from:- SetPickList
Author: Vishal Pawar
Email:- vishal.pawar@skinternational.com
Test class:-AccountRedirectExtension_test
Description: the class is set the country picklist value to Login User's country 
*/




public with sharing class AccountRedirectExtension {
    
    private ApexPages.StandardController controller = null;
    
    public AccountRedirectExtension (ApexPages.StandardController controller){
        this.controller = controller;
    }
    
    
    public PageReference redirect(){
        
        String prefix = Account.SObjectType.getDescribe().getKeyPrefix();
        Map<String, String> strMap = ApexPages.currentPage().getParameters();
        String recordTypeId = strMap.get('RecordType');
        
        
        Id RecordTypeIdforProspect = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        String tempRecordTypeIdforProspect = String.valueOf(RecordTypeIdforProspect);
        tempRecordTypeIdforProspect = tempRecordTypeIdforProspect.substring(0,tempRecordTypeIdforProspect.length()-3);
        
        
        FieldDefinition FieldDefinitionObj = [SELECT DurableId,QualifiedApiName,Label,DeveloperName,EntityDefinitionId, DataType FROM FieldDefinition WHERE EntityDefinitionId='Account' AND QualifiedApiName='Country__c' LIMIT 1];
        String customFieldId = FieldDefinitionObj.DurableId;
        customFieldId = customFieldId.right(15);
        
        //checking record type id is same or not
        if(recordTypeId==tempRecordTypeIdforProspect){
            String UserCountry = [SELECT Country, Id FROM User Where Id=:UserInfo.getUserId() LIMIT 1].Country;
            
            String param='';
            if(UserCountry!=''){
                param = getParameters() + '&'+customFieldId+'='+UserCountry;    
            }else{
                param = getParameters() + '&'+customFieldId+'=None';
            }
            
            return new PageReference('/'+prefix+'/e?nooverride=1&'+param);
        }else{
            String param1 = getParameters() + '&'+customFieldId+'=None';
            return new PageReference('/'+prefix+'/e?nooverride=1&'+param1);
            
        }
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