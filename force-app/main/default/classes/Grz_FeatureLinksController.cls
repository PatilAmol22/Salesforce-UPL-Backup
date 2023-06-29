public with sharing class Grz_FeatureLinksController {

    @AuraEnabled(cacheable=true)
    public static List<MenuItemWrapper> getFeatureLinksList(String language) {

        List<MenuItemWrapper> flinkList = new List<MenuItemWrapper>(); 
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('Featured Link').RecordTypeId;
            
        for(Partner_Portal_Configuration__c eachRecord:[Select Id,Name,Label__c,Order__c,URL__c from  Partner_Portal_Configuration__c where Language__c =:language and recordtypeId =: recordTypeShowId order by Order__c]){
            MenuItemWrapper flink = new MenuItemWrapper();
            flink.Id = eachRecord.Id;
            flink.Name = eachRecord.Name;           
            flink.Label = eachRecord.Label__c;
            flink.Order = eachRecord.Order__c;
            flink.URL = eachRecord.URL__c;
            flinkList.add(flink); 
        }

        return flinkList; 
    }

    public class MenuItemWrapper {
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Label {get;set;}
        @AuraEnabled
        public String URL {get;set;}
        @AuraEnabled
        public Decimal Order {get;set;}

    }

}