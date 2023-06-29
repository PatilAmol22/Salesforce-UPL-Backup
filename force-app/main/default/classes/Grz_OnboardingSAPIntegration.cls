public with sharing class Grz_OnboardingSAPIntegration {
    
    @AuraEnabled(cacheable=true)
    public static String GenerateToken(){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Onboarding_SAP_Token');
        req.setTimeout(120000);
        req.setMethod('POST');
        HTTPresponse res= http.send(req);
        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Object token = (Object)response.get('access_token');
        return token.toString();
    }
    
    @AuraEnabled(cacheable=true)
    public static String customerCreation(String requestBody,Grz_Customer360IntegrationMappings__mdt metadataRecord){
        string response;
        if(metadataRecord!=null){
            system.debug('requestBody===>'+requestBody);
            String urlEndpoint=metadataRecord.Customer_Creation_API_URL__c;
            system.debug('urlEndpoint===>'+urlEndpoint);
            Http http = new Http(); 
            HttpRequest req = new HttpRequest();
            String token = GenerateToken();
            system.debug(token);
            req.setEndpoint('callout:Sap_data'+urlEndpoint);
            req.setTimeout(120000);
            req.setHeader('Authorization', 'Bearer '+token);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('GET');
            String body = requestBody;
            req.setBody(body);
            system.debug(body);
            
            try{
                HTTPresponse res= http.send(req);
                system.debug(res.getStatusCode());
                if(res.getStatusCode() == 200){
                    response = res.getBody();
                }else{
                    system.debug('response@@@@+++>'+response);
                    response = 'Error_In_Sap';
                }
                system.debug(response);
                
            }catch(Exception e){
                errorHandler(e);
            }
        }
        else{
            response='Endpoint_Unavailable';
        }
        
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String salesAreaExtention(String requestBody,Grz_Customer360IntegrationMappings__mdt metadataRecord){
        string response;
        if(metadataRecord!=null){
            String urlEndpoint=metadataRecord.Customer_Extension_API_URL__c;
            system.debug('urlEndpoint===>'+urlEndpoint);
            Http http = new Http(); 
            HttpRequest req = new HttpRequest();
            String token = GenerateToken();
            system.debug(token);
            req.setEndpoint('callout:Sap_data'+urlEndpoint);
            req.setTimeout(120000);
            req.setHeader('Authorization', 'Bearer '+token);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('GET');
            String body = requestBody;
            req.setBody(body);
            system.debug(body);
            try{
                HTTPresponse res= http.send(req);
                system.debug(res.getStatusCode());
                if(res.getStatusCode() == 200){
                    response = res.getBody();
                }else{
                    response = 'Error_In_Sap';
                }
                system.debug(response);
                
            }catch(Exception e){
                errorHandler(e);
            }
        }
        else{
            response='Endpoint_Unavailable';
        }
        return response;
    }
    
    @AuraEnabled(cacheable=true)
    public static String DistributorModification(String requestBody,Grz_Customer360IntegrationMappings__mdt metadataRecord){
        string response;
        if(metadataRecord!=null){
            String urlEndpoint=metadataRecord.Customer_Modification_API_URL__c;
            system.debug('urlEndpoint===>'+urlEndpoint);
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data'+urlEndpoint);
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        String body = requestBody;
        req.setBody(body);
        system.debug(body);
        try{
            HTTPresponse res= http.send(req);
            system.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            system.debug(response);
            
        }catch(Exception e){
            errorHandler(e);
        }
            }
        else{
            response='Endpoint_Unavailable';
        }
        return response;
    }
    
    @AuraEnabled(cacheable=true)
    public static String syncMethod(String requestBody,Grz_Customer360IntegrationMappings__mdt metadataRecord){
        string response;
        if(metadataRecord!=null){
            String urlEndpoint=metadataRecord.Ship_to_API_URL__c;
            system.debug('urlEndpoint===>'+urlEndpoint);
            Http http = new Http(); 
            HttpRequest req = new HttpRequest();
            String token = GenerateToken();
            system.debug(token);
            req.setEndpoint('callout:Sap_data'+urlEndpoint);
            req.setTimeout(120000);
            req.setHeader('Authorization', 'Bearer '+token);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('GET');
            String body = requestBody;
            req.setBody(body);
            system.debug('body================================'+body);
            system.debug('endPoint================================'+req.getBody());
            try{
                HTTPresponse res= http.send(req);
                //system.debug(JSON.serializePretty(res));
                system.debug(res.getBody());
                system.debug(res.getStatusCode());
                if(res.getStatusCode() == 200){
                    response = res.getBody();
                }else{
                    response = 'Error_In_Sap';
                }
                system.debug(response);
                
            }catch(Exception e){
                errorHandler(e);
            }
        }
        else{
            response='Endpoint_Unavailable';
        }
        return response;
    }
    
    public static void errorHandler(exception e){
        
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        String className = stackTrace.substringAfter('.').substringBefore('.'); 
        String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
        User cUserInfo= grz_SapIntegration.GetUserInfo();
        Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
        storeError.ClassName__c = className;
        storeError.MethodName__c = methodName;
        storeError.Exception_Message__c = e.getMessage();
        storeError.Account__c = cUserInfo.accountId;
        insert storeError;
    }
}