public with sharing class Grz_homePageYTVideos {
    @AuraEnabled(cacheable=true)
    public static List<youtTubeVideoWrapper> getYTVideoData(String language){
        List<youtTubeVideoWrapper> ytWrapList=new List<youtTubeVideoWrapper>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setMethod('GET');
        if(language == 'en-US'){
            request.setEndpoint('https://in.uplonline.com/api/homepage-video');
        }else if(language == 'pt-BR'){
            request.setEndpoint('https://br.uplonline.com/api/homepage-video');
        }else if(language == 'es'){
            request.setEndpoint('https://cl.uplonline.com/api/homepage-video');
        }else{
           request.setEndpoint('https://mx.uplonline.com/api/homepage-video'); 
        }
        HttpResponse response = http.send(request);
        if(response.getStatusCode()==200){
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            youtTubeVideoWrapper inv = (youtTubeVideoWrapper)parser.readValueAs(youtTubeVideoWrapper.class);
                            ytWrapList.add(inv);
                        }}
                }
            }
        }
        else{
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = 'Grz_homePageYTVideos';
            storeError.MethodName__c = 'getYTVideoData';
            storeError.Exception_Message__c = response.getBody();
            storeError.Error_Message_Code__c=String.valueOf(response.getStatusCode());
            storeError.Account__c = cUserInfo.accountId;
            storeError.ErrorType__c = 'Home page';
            insert storeError;
        }
        return ytWrapList;
    }
    
    public class youtTubeVideoWrapper {
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String title {get;set;}
        @AuraEnabled
        public String embedded_url {get;set;}
    }
}