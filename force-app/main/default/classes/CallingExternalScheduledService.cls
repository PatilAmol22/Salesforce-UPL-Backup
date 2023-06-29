global class CallingExternalScheduledService{
    
    public static HttpResponse response; 
    
    //Added By Krishanu @ Wipro
    Webservice static void SKUService(string flowId){
        datetime d1 = datetime.now();
        datetime d2 = d1.addHours(-4);
        try{
            SKUBrazilOutboundAPI.SKUUpdate(null,d2,d1);
        }
        catch(Exception e){
            Monitor_Integration_Flow__c  mif = new Monitor_Integration_Flow__c();
            mif.id=flowId;
            mif.Transaction_Status__c = 'Failed';
            mif.Executed_Date__c = System.now();
            mif.Response_Message__c = e.getMessage();
            update mif;
        }
        
    }
       @future(Callout =True)
       Webservice static void CallService(String stringJson, String url, String flowName, String flowId, String mode){
        
        System.debug('CallService-----');
        Integer timeOut = 120000;
        String resp ='';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        
        // Set time out in milliseconds
        request.setTimeout(timeOut);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        
        //Set Authentication Header - Basic (Username/Password)
        String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
           System.Debug('username :- ' +username);
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c;System.Debug('password :- ' +password);
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
        
        request.setHeader('Authorization', authorizationHeader);
        
        System.Debug('Service URL ======= ' + url);
        //Set endpoint url of service
        request.setEndpoint(url);          
  
        String json = ''+stringJson;
        
        System.debug('json: '+json);
        
        System.Debug('stringJson 2 :- ' +stringJson);
        System.Debug('url 2 :-' +url );
        System.Debug('flowName 2 :- ' +flowName );
        System.Debug('flowId 2 :- ' +flowId );
        
        request.setBody(json);
        System.Debug('request :- ' +request);        
        try{
        
            if(!Test.isRunningTest()){
                response = http.send(request);
                system.debug('response  :- '+response);
            }else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"example":"test"}');
                response.setStatusCode(200);
            }
        
            resp =''+response; 
            
        }catch(Exception ex){
            system.debug('Exception  :- '+ex);
            resp = ''+ex;
        }
        
        system.debug('resp :- '+resp);
        Monitor_Integration_Flow__c  mif = new Monitor_Integration_Flow__c();      
        if(resp == 'System.HttpResponse[Status=OK, StatusCode=200]'){
           System.debug('Flow - '+ flowName +' executed - Success'); 
            
            mif.id=flowId;
            mif.Transaction_Status__c = 'Success';
            mif.Executed_Date__c = System.now();
            mif.Response_Message__c = resp;
            mif.Transaction_Type__c = mode;
        }else{
             System.debug('Flow - '+ flowName +' executed - Error'); 
             
             mif.id=flowId;
             mif.Transaction_Status__c = 'Failed';
             mif.Executed_Date__c = System.now();
             mif.Response_Message__c = resp;
             mif.Transaction_Type__c = mode;
        }
        update mif;
        //return 'Success';
    }
}