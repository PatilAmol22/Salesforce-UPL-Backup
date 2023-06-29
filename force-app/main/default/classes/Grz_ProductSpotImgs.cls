public with sharing class Grz_ProductSpotImgs {
    @AuraEnabled(cacheable=true)
    public static List<prodSpotWrapper> getProdSpotData(String language){
        
        List<prodSpotWrapper> outerList=new List<prodSpotWrapper>();
        List<prodSpotInnerWrapper> innerList=new List<prodSpotInnerWrapper>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setMethod('GET');
        if(language == 'en-US'){
            //request.setEndpoint('https://in.uplonline.com/api/products-spotlight'); -Vasrhit (This URL is not working)
            request.setEndpoint('https://in.uplonline.com/api/products-spotlight?keyword=webp');
        }else if(language == 'pt-BR'){
            request.setEndpoint('https://br.uplonline.com/api/products-spotlight');
        }
        else if(language == 'es'){
            request.setEndpoint('https://cl.uplonline.com/api/products-spotlight');
        }
        else{
            request.setEndpoint('https://mx.uplonline.com/api/products-spotlight');
        }
        HttpResponse response = http.send(request);
        if(response.getStatusCode()==200){
            
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            
                            prodSpotWrapper inv = (prodSpotWrapper)parser.readValueAs(prodSpotWrapper.class);
                            outerList.add(inv);
                        }
                        
                    }
                }
            } 
            system.debug('outerList==>'+outerList);
        }
         else{
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            //Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            //storeError.ClassName__c = 'Grz_ProductSpotImgs';
            //storeError.MethodName__c = 'getProdSpotData';
            //storeError.Exception_Message__c = response.getBody();
            //storeError.Error_Message_Code__c=String.valueOf(response.getStatusCode());
            //storeError.Account__c = cUserInfo.accountId;
            //storeError.ErrorType__c = 'Home page'; 
            //insert storeError;
        }
        System.debug('outerList--->>'+outerList);
        return outerList;
    }
    public class prodSpotWrapper {
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String image {get;set;}
        @AuraEnabled
        public prodSpotInnerWrapper product {get;set;}
    }
    public class prodSpotInnerWrapper {
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String fact {get;set;}
        @AuraEnabled
        public String view_link {get;set;}
        @AuraEnabled
        public String product_type_logo {get;set;}
    }
}