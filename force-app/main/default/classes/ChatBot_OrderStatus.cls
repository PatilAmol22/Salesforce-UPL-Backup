public class ChatBot_OrderStatus {
public class PrechatOutput{
        @InvocableVariable
        public List<JSON2Apex.Records> listOfBrand = new list<JSON2Apex.Records>();
        @InvocableVariable
        public boolean isError = false;
    }
    public class PrechatInput{
        @InvocableVariable
        public String orderNumber;
        @InvocableVariable
        public String userName;
                
    }   
    @InvocableMethod(label='Get order status')
    public static List<PrechatOutput> getCustomersforOrder(list<PrechatInput> inputParameter){
       
       
        String orderNo =inputParameter[0].orderNumber;
        String userName =inputParameter[0].userName;
      
       
        
        //String squery='Select Sold_to_Party__r.Name, Order_Date__c, Order_Status__c FROM Sales_Order__c WHERE SAP_Order_Number__c ='+orderNo;
        //Select Sold_to_Party__r.Name, Order_Date__c, Order_Status__c FROM Sales_Order__c WHERE SAP_Order_Number__c = '7063729480''
        //Select+Sold_to_Party__r.Name,+Order_Date__c,+Order_Status__c+FROM+Sales_Order__c+WHERE+SAP_Order_Number__c+=+'7063729480''
        //system.debug('String query  '+squery);
        
         
      
         string resp  = getOrderStatus(userName,orderNo);  
        
          
        
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        List<Sales_Order__c> soList=new List<Sales_Order__c>();
        if(resp!=Null){
        	prechatobject.listOfBrand=JSON2Apex.parse(resp).records;
        system.debug('prechatobject.listOfBrand---->'+prechatobject.listOfBrand);
        system.debug('response size'+prechatobject.listOfBrand.size());
        if(prechatobject.listOfBrand.size()==0){
            prechatobject.isError =true;
        }
        //system.debug('response >>--->'+JSON2Apex.parse(resp).records[0]);
        /*if(JSON2Apex.parse(resp).records[0]){
         prechatobject.isError = true;
        }*/
        /*soList = Database.query(squery);
        for(Sales_Order__c so:soList){
            prechatobject.listOfBrand.add(so.Order_Status__c);
        }*/
        system.debug('Error>>--->'+prechatobject.isError);
        po.add(prechatobject);
    
        }else{
            system.debug('Null value');
             prechatobject.isError =true;
             po.add(prechatobject);
        }
                return po ; 
    }
    public static string getOrderStatus(string userDetails, string orderno){
          HttpRequest req;
          HttpResponse res;
          try{ 
            Http h = new Http();
              	EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
                chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
              
            
                    req = new HttpRequest();
                   req.setEndpoint(chatbotSetting.End_Point__c+'Select+Sold_to_Party__r.Name,+Order_Date__c,+SAP_Order_Number__c,+Order_Status__c+FROM+Sales_Order__c+WHERE+SAP_Order_Number__c+=+\''+orderno+'\'+');
                req.setMethod('GET');
                    req.setHeader('Content-Type', 'application/json');
                    req.setHeader('Accept', 'application/json');
                req.setHeader('Authorization', 'Bearer ' + getAccessToken(userDetails,chatbotSetting.siteBase__c,chatbotSetting.ConsumerKey__c) ); 
                  if(!test.isRunningTest()){
              res = h.send(req);
              }else{ 
              res = MockHttpResponseGeneratorChatbot.respond(req);
              }
             
              system.debug('After send request');
             // System.Debug('Response body >> ' +JSON.deserializeUntyped(res.getBody()));
            // System.Debug('Response body >> ' + JSON2Apex.parse(res.getBody()).records); 
              system.debug('after response body print');
              //insert new Monitor_Log__c(Response__c   = res.getBody(),Method__c = userDetails);
              
          }catch(Exception e){
              System.Debug('EXCEPTION >> ' + e);
              System.Debug('EXCEPTION >> ' + e.getLineNumber());
              return null;
          }
    return res.getBody();
    }
    public static String getAccessToken(String username,string siteBase,String consumerKey){
        //String siteBase = 'https://test.salesforce.com';
        //String consumerKey = '3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw';
        Auth.JWT jwt = new Auth.JWT();
        jwt.setSub(username);
        jwt.setIss(consumerKey);
        jwt.setAud(siteBase);
        Auth.JWS jws = new Auth.JWS(jwt, 'EinsteinBot');
        String tokenEndpoint = siteBase+'/services/oauth2/token';
        Auth.JWTBearerTokenExchange bearer = new
        Auth.JWTBearerTokenExchange(tokenEndpoint, jws);
        String accessToken ='';
        if(!test.isRunningTest()){
            accessToken = bearer.getAccessToken();
        }
        System.Debug('accessToken >>>>>>> ' + accessToken);
        return accessToken;
    }

}