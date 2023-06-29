/*
* Class Name - CustomlookupControllerUpl
* Created Date - 14th MAY, 2022
* Author - Taruni/Abhinay/Rasika
* Description - Created a class CustomlookupControllerUpl. 
* */
public class CustomlookupControllerUpl {
    @AuraEnabled(cacheable=false)
    public static List<sObject> companySearchHandlerApex(String searchKey, String objName){
        Set<Id> userIds = new Set<Id>();
        for(User user : [Select Id,Country From User WHERE Country = 'France']){
            userIds.add(user.Id);
        }
        String companyName = 'France';
        if(String.isNotBlank(searchKey)){
            String query = 'Select Id,Name FROM  ' +objName+ ' Where Name Like  \'%'+searchKey+'%\' And OwnerId In : userIds Limit 10';
            return Database.query(query);
        }else{
            String query = 'Select Id,Name FROM  ' +objName+' Where OwnerId In : userIds limit 10';
            return Database.query(query);        
        }
       
    } 

    @AuraEnabled(cacheable=false)
    public static List<sObject> brandSearchHandlerApex(String searchKey, String objName,String parentId){
        if(String.isNotBlank(parentId)){
            String query = 'Select Id,Name FROM  ' +objName+ ' Where Name Like  \'%'+searchKey+'%\' AND Company__c =:parentId Limit 10';
            return Database.query(query);
        }else{
            return null;
        } 
    } 
    
    
    @AuraEnabled(cacheable=false) 
    public static List<sObject> formulationSearchHandlerApex(String searchKey, String objName,String parentId){
        List<BrandFormulation__c> lstquery = new List<BrandFormulation__c>();
        List<sObject> tempLst = new List<sObject>();
        Set<String> setContactID = new Set<String>();

        if(String.isNotBlank(parentId)){
            String query = 'Select Id, Formulation__c, Formulation__r.Name FROM  ' +objName+ ' Where Formulation__r.Name Like  \'%'+searchKey+'%\' AND Formulation__c != \'\' AND Brand__c =:parentId Limit 10'; 
            lstquery = Database.query(query);
            if(lstquery.size()>0){
                return Database.query(query);
            }else {
                String query1 = 'Select Id,Formulation__c,Formulation__r.Name FROM  ' +objName+ ' Where Formulation__c != \'\' AND Formulation__r.Name Like  \'%'+searchKey+'%\'';
                List<BrandFormulation__c> allBrandFormulationList = new List<BrandFormulation__c>();
                allBrandFormulationList = Database.query(query1);
                
                
                Map<String,BrandFormulation__c> uniqueBrandFormulationMap = new Map<String,BrandFormulation__c>();
                for(BrandFormulation__c formulation: allBrandFormulationList){
                    uniqueBrandFormulationMap.put(formulation.Formulation__r.Name,formulation);
                }
                allBrandFormulationList.clear();
                for(String formulationName: uniqueBrandFormulationMap.keySet()){
                    if(uniqueBrandFormulationMap.containsKey(formulationName)){
                        if(allBrandFormulationList.size()>=10){
                            break;
                        }else{
                            allBrandFormulationList.add(uniqueBrandFormulationMap.get(formulationName));
                        }
                    }
                }
                return allBrandFormulationList;              
            }
        } else{
            return null;
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<sObject> familySearchHandlerApex(String searchKey, String objName,String parentId){
        List<Sobject> lstquery = new List<SObject>();
        if(String.isNotBlank(parentId)){
            String query = 'Select Id, Name, Family__c,Family__r.Name FROM  ' +objName+ ' Where Family__c != \'\' AND Family__r.Name Like  \'%'+searchKey+'%\' AND Brand__c =:parentId Limit 10'; 
            lstquery = Database.query(query);
            if(lstquery.size()>0){
                return Database.query(query);
            }else {
                String query1 = 'Select Id,Name, Family__c,Family__r.Name FROM  ' +objName+ ' Where Family__c != \'\' AND Family__r.Name Like  \'%'+searchKey+'%\''; 
                //return Database.query(query1);
                List<BrandFamily__c> allBrandFamilyList = new List<BrandFamily__c>();
                allBrandFamilyList = Database.query(query1);
                
                Map<String,BrandFamily__c> uniqueBrandFamilyMap = new Map<String,BrandFamily__c>();
                for(BrandFamily__c formulation: allBrandFamilyList){
                    uniqueBrandFamilyMap.put(formulation.Family__r.Name,formulation);
                }
                allBrandFamilyList.clear();
                for(String formulationName: uniqueBrandFamilyMap.keySet()){
                    if(uniqueBrandFamilyMap.containsKey(formulationName)){
                        if(allBrandFamilyList.size()>=10){
                            break;
                        }else{
                            allBrandFamilyList.add(uniqueBrandFamilyMap.get(formulationName));
                        }
                    }
                }
                return allBrandFamilyList;              
            }
        }else{
            return null;
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static List<sObject> marketSearchHandlerApex(String searchKey, String objName,String parentId){
        List<Sobject> lstquery = new List<SObject>();
        if(String.isNotBlank(parentId)){
            String query = 'Select Id,Name, Market__c,Market__r.Name FROM  ' +objName+ ' Where Market__c != \'\' AND Market__r.Name Like  \'%'+searchKey+'%\' AND Brand__c =:parentId Limit 10'; //
            lstquery = Database.query(query);
            if(lstquery.size()>0){
                return Database.query(query);
            } else{
                String query1 = 'Select Id,Name, Market__c,Market__r.Name FROM  ' +objName+ ' Where Market__c != \'\' AND Market__r.Name Like  \'%'+searchKey+'%\''; 
               // return Database.query(query1);
                List<BrandMarket__c> allBrandMarketList = new List<BrandMarket__c>();
                allBrandMarketList = Database.query(query1);
                
                Map<String,BrandMarket__c> uniqueBrandMarketMap = new Map<String,BrandMarket__c>();
                for(BrandMarket__c formulation: allBrandMarketList){
                    uniqueBrandMarketMap.put(formulation.Market__r.Name,formulation);
                }
                allBrandMarketList.clear();
                for(String formulationName: uniqueBrandMarketMap.keySet()){
                    if(uniqueBrandMarketMap.containsKey(formulationName)){
                        if(allBrandMarketList.size()>=10){
                            break;
                        }else{
                            allBrandMarketList.add(uniqueBrandMarketMap.get(formulationName));
                        }
                    }
                }
                return allBrandMarketList;
            }
        }else{
            return null;
        }
    }


    @AuraEnabled(cacheable=false)    
    public static List<sObject> searchPackSizeRecordsApex(String searchKey, String objName){
        Set<Id> userIds = new Set<Id>();
        for(User user : [Select Id,Country From User WHERE Country = 'France']){
            userIds.add(user.Id);
        }
        String companyName = 'France';
        if(String.isNotBlank(searchKey)){
            String query = 'Select Id,Name FROM  ' +objName+ ' Where Name Like  \'%'+searchKey+'%\' And OwnerId In : userIds Limit 10';
            return Database.query(query);
        }else{
            String query = 'Select Id,Name FROM  ' +objName+' Where OwnerId In : userIds limit 10';
            return Database.query(query);        
        }   
        
    } 

    @AuraEnabled(cacheable=false)
    public static List<sObject> cropSearchHandlerApex(String searchKey, String objName){
        Set<Id> userIds = new Set<Id>();
        for(User user : [Select Id,Country From User WHERE Country = 'France']){
            userIds.add(user.Id);
        }
        String companyName = 'France';
        if(String.isNotBlank(searchKey)){
            String query = 'Select Id,Name FROM  ' +objName+ ' Where Name Like  \'%'+searchKey+'%\' And OwnerId In : userIds Limit 10';
            return Database.query(query);
        }else{
            String query = 'Select Id,Name FROM  ' +objName+' Where OwnerId In : userIds limit 10';
            return Database.query(query);        
        }  
    } 

    @AuraEnabled(cacheable=false)
    public static List<sObject> pestSearchHandlerApex(String searchKey, String objName){
        Set<Id> userIds = new Set<Id>();
        for(User user : [Select Id,Country From User WHERE Country = 'France']){
            userIds.add(user.Id);
        }
        String companyName = 'France';
        system.debug('searchKey-->'+searchKey);
        system.debug('objName-->'+objName);
        if(String.isNotBlank(searchKey)){
            system.debug('objName-->'+objName);
            String query = 'Select Id,Name FROM  ' +objName+ ' Where Name Like  \'%'+searchKey+'%\' And OwnerId In : userIds Limit 10';
            return Database.query(query);
        }else{
            String query = 'Select Id,Name FROM  ' +objName+' Where OwnerId In : userIds limit 10';
            return Database.query(query);        
        }  
    } 

    @AuraEnabled(cacheable=false)
    public static List<sObject> aISearchHandlerApex(String searchKey, String objName){
        Set<Id> userIds = new Set<Id>();
        for(User user : [Select Id,Country From User WHERE Country = 'France']){
            userIds.add(user.Id);
        }
        String companyName = 'France';
        system.debug('searchKey-->'+searchKey);
        system.debug('objName-->'+objName);
        if(String.isNotBlank(searchKey)){
            system.debug('objName-->'+objName);
            String query = 'Select Id,Name FROM  ' +objName+ ' Where Name Like  \'%'+searchKey+'%\' And OwnerId In : userIds Limit 10';
            return Database.query(query);
        }else{
            String query = 'Select Id,Name FROM  ' +objName+' Where OwnerId In : userIds limit 10';
            return Database.query(query);        
        }   
    } 
}