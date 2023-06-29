public with sharing class Grz_NewsUpdatesDetails {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getEventsDetails(String language){
        ResultWrapper rw = new ResultWrapper();
        List<newsUpdatesWrapper> ytWrapList=new List<newsUpdatesWrapper>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        if(language == 'en-US'){
            request.setEndpoint('https://in.uplonline.com/api/news-events-articles/news?page=1&limit=5');
        }
        else if(language == 'es-MX'){
            request.setEndpoint('https://mx.uplonline.com/api/news?page=1&limit=10&title=&tags=&month=&year=');
        }
        // the snippet below is introduced to get the relevant news in JSON for Argentina community from the official
        //  UPL Argentina website news column,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 16-08-2022        
        else if(language == 'es-AR'){
            request.setEndpoint('https://ar.uplonline.com/api/news?page=1&limit=10&title=&tags=&month=&year=');
        }
        else{
            request.setEndpoint('https://br.uplonline.com/api/news-events-articles/news?page=1&limit=5');
        }
        User cUserInfo= grz_SapIntegration.GetUserInfo();
        if(cUserInfo.accountId == null){
            rw.IsInternalUser = true;                
        }
        else{
            rw.IsInternalUser = false; 
        }
        HttpResponse response = http.send(request);

        if(response.getStatusCode()==200){
            JSONParser parser = JSON.createParser(response.getBody());
            system.debug('parser : '+parser);
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            newsUpdatesWrapper inv = (newsUpdatesWrapper)parser.readValueAs(newsUpdatesWrapper.class);
                            ytWrapList.add(inv);
                        }}
                }
            }
        }
        else{
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = 'Grz_NewsUpdatesDetails';
            storeError.MethodName__c = 'getEventsDetails';
            storeError.Exception_Message__c = response.getBody();
            storeError.Error_Message_Code__c=String.valueOf(response.getStatusCode());
            storeError.Account__c = cUserInfo.accountId;
            storeError.ErrorType__c = 'Home page';
            insert storeError;
        }
        rw.newupdateList = ytWrapList;
        system.debug('rw.newupdateList : '+rw.newupdateList);
        return rw;
    }
    
    public class newsUpdatesWrapper {
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String title {get;set;}
        @AuraEnabled
        public String news_date {get;set;}
        @AuraEnabled
        public String description {get;set;}
        @AuraEnabled
        public String article{get;set;}
        @AuraEnabled
        public String link {get;set;}
        @AuraEnabled
        public image image {get;set;}
    }
    public class image {
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String url {get;set;}
        @AuraEnabled
        public String filename {get;set;}
        @AuraEnabled
        public String extension {get;set;}
    }
    public class ResultWrapper {
        @AuraEnabled
        public Boolean IsInternalUser {get;set;}
        @AuraEnabled
        public List<newsUpdatesWrapper> newupdateList {get;set;}
        
    }
}