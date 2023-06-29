/*

* Name: SearchController
* Created On: 29 Nov 2021
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: Generic class for search component Used in GTM Project
*/


public without sharing class SearchController {
    
    
    @AuraEnabled
    public static List<Account> search(String objectName, List<String> fields, String searchTerm,String customerTypeForFilter){
        
        
        Id recordTypeId;
        
        Sales_Org__c salesOrgObj = getSalesOrg();
        String salesOrg = salesOrgObj.Id;
        
        if(customerTypeForFilter=='Lead Customer'){
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lead Customer').getRecordTypeId();
        }else if(customerTypeForFilter=='Non Lead Customer'){
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        }
        
        
        
        
        String searchKey = searchTerm + '%';
        List < Account > returnList = new List < Account > ();
        String accType = 'Sold To Party';
        //String salesOrgCode ='5631';
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5  
        String sQuery=''; 
        
        
        if(customerTypeForFilter=='Both'){
            sQuery =  'select id, Name from ' +objectName + ' where Sales_Org__c=:salesOrg AND Name LIKE: searchKey And Account_Type__c=:accType  order by createdDate DESC limit 3';  
        }else{
            sQuery =  'select id, Name from ' +objectName + ' where Sales_Org__c=:salesOrg AND Name LIKE: searchKey And Account_Type__c=:accType AND RecordTypeId=:recordTypeId  order by createdDate DESC limit 3';
        }
        
        
        
        List < Account > lstOfRecords = Database.query(sQuery);
        
        for (Account obj: lstOfRecords) {
            returnList.add(obj);
        }        
       
       
        return returnList;
    }
    
    
    @AuraEnabled
    public static List<User> searchUsers(String objectName, List<String> fields, String searchTerm){
        
        
        Sales_Org__c sorgObj  = getSalesOrg();
        String countryName = sorgObj.Name;
        String salesOrgCode = sorgObj.Sales_Org_Code__c;
        String ProfileName ='';
        String regionProfileName ='';
        List<PathFinderProfiles__mdt> pathfinderProfile = new List<PathFinderProfiles__mdt>();
        pathfinderProfile = [select Id,ProfileName__c from PathFinderProfiles__mdt where Sales_org_code__c=:salesOrgCode];
        List<String> strProflile = new List<String>();
        
        for(PathFinderProfiles__mdt obj :pathfinderProfile){
            
            strProflile.add(obj.ProfileName__c);
        }
        
        System.debug('strProflile '+strProflile);
        
        /*
        
        if(countryName=='Argentina'){
            
            ProfileName ='Territory Manager Argentina';
            regionProfileName ='Regional/Zonal Managers Argentina';
        }
        if(countryName=='Mexico'){
            ProfileName ='Territory Manager for Mexico';
            regionProfileName ='Regional/Zonal Managers for Mexico';
        }
        
        System.debug('countryName '+countryName);
        if(countryName=='Italy - Domestic'){
            System.debug('countryName inside  ');
            ProfileName ='Sales Agents Italy';
            countryName ='Italy';
        }
        */
        
        String searchKey = '%'+searchTerm + '%';
        List < User > returnList = new List < User > ();       
        String sQuery ='';
        
        
        sQuery =  'select id, Name from User where Profile.Name IN:strProflile AND Name LIKE: searchKey AND IsActive=true order by createdDate DESC limit 2';    
        System.debug('sQuery '+sQuery);
        /*
        if(countryName!='Italy'){
            sQuery =  'select id, Name from ' +objectName + ' where Country=:countryName AND (Profile.Name=:ProfileName OR Profile.Name=:regionProfileName) AND Name LIKE: searchKey AND IsActive=true order by createdDate DESC limit 2';    
        }else{
            sQuery =  'select id, Name from ' +objectName + ' where Country=:countryName AND Profile.Name=:ProfileName  AND Name LIKE: searchKey AND IsActive=true order by createdDate DESC limit 2';
        }*/
        
        System.debug('sQuery for mexico '+sQuery);
        List < User > lstOfRecords = Database.query(sQuery);
        System.debug('lstOfRecords '+lstOfRecords);
        
        for (User obj: lstOfRecords) {
            returnList.add(obj);
        }
        
        
        return returnList;
        
        
    }
    public static Sales_Org__c getSalesOrg(){
        String country = '';
        //Sales_Org__c salesorg =GTMPathFinder.getSalesOrg() ;
        // System.debug('salesorg in Test Class '+salesorg);
        
        Sales_Org__c salesorg;
        
        
        Login_Country__c loginCountry = null;
        User usr;
        if(Schema.sObjectType.User.isAccessible()){
            usr = [Select Id,Name,Country from User where id=:userInfo.getUserId()];
        }
        if(usr!=null){
            country =  usr.Country;
        }
        if(country =='Italy'){
           country =  'Italy - Domestic';
        }
        System.debug('for checking country '+country);
        System.debug('country for Test Class '+Schema.sObjectType.Login_Country__c.isAccessible());
        if(Schema.sObjectType.Login_Country__c.isAccessible() || Test.isRunningTest()){
            loginCountry = [Select id,Name,Sales_Org_Code__c from Login_Country__c where Name=:country];
            System.debug('loginCountry for Test Class '+loginCountry);
            
            
        }
        if((loginCountry!=null && Schema.sObjectType.Sales_Org__c.isAccessible()) || Test.isRunningTest()){
            // System.debug('getSalesOrg '+loginCountry.Sales_Org_Code__c);
            salesorg = [Select id,Name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c=:loginCountry.Sales_Org_Code__c];
        }
        return salesorg;
    }
    
    
    
    
}