public with sharing class Grz_EventsDetail {
    @AuraEnabled(cacheable=true)
    public static List<eventsDetWrapper> getEventsDetails(String language){
        List<eventsDetWrapper> ytWrapList=new List<eventsDetWrapper>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setMethod('GET');
        if(language == 'en-US'){
            request.setEndpoint('https://in.uplonline.com/api/news-events-articles/events');
        }else{
            request.setEndpoint('https://br.uplonline.com/api/news-events-articles/events');
        }
        HttpResponse response = http.send(request);
        if(response.getStatusCode()==200){
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            eventsDetWrapper inv = (eventsDetWrapper)parser.readValueAs(eventsDetWrapper.class);
                            ytWrapList.add(inv);
                        }}
                }
            }
        }
        else{
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = 'Grz_EventsDetail';
            storeError.MethodName__c = 'getEventsDetails';
            storeError.Exception_Message__c = response.getBody();
            storeError.Error_Message_Code__c=String.valueOf(response.getStatusCode());
            storeError.Account__c = cUserInfo.accountId;
            storeError.ErrorType__c = 'Home page';
            insert storeError;
        }
        return ytWrapList;
    }
    
    public class eventsDetWrapper {
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String title {get;set;}
        @AuraEnabled
        public String description {get;set;}
        @AuraEnabled
        public String from_date {get;set;}
        @AuraEnabled
        public String event_address {get;set;}
        @AuraEnabled
        public String event_image {get;set;}
    }
}