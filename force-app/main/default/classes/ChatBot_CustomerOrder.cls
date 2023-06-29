public class ChatBot_CustomerOrder {
public class PrechatOutput{
    	@InvocableVariable
        public List<JSON2Apex.Records> listOfCustomer = new list<JSON2Apex.Records>();
    	@InvocableVariable
    	public boolean isError = false;
    }
    public class PrechatInput{
        @InvocableVariable
        public String customerName;
        @InvocableVariable
        public String userName;
                
    }   
    @InvocableMethod(label='Get Customers for order')
    public static List<PrechatOutput> getCustomersforOrder(List<PrechatInput> inputParameters){
      
        String custName =inputParameters[0].customerName;
        String	userName =inputParameters[0].userName;
        custName = custName.trim().replaceAll(' ', '+');
        string resp = getOrderStatus(userName,custName);
       
        system.debug('custName>>--->'+custName);
        //String custNameIp= '%'+custName+'%';
        //system.debug('Cust Name aas Input-->'+custNameIp);
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
       	prechatobject.listOfCustomer=JSON2Apex.parse(resp).records;
        system.debug('prechatobject.listOfBrand---->'+prechatobject.listOfCustomer);
        system.debug('response size'+prechatobject.listOfCustomer.size());
        if(prechatobject.listOfCustomer.size()==0){
            prechatobject.isError =true;
        }
        system.debug('Error>>--->'+prechatobject.isError);
        po.add(prechatobject);
        return po ; 
    }
    public static string getOrderStatus(string userDetails, string custName){
          HttpRequest req;
          HttpResponse res;
          try{ 
              Http h = new Http();
              EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
                chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
    		
            req = new HttpRequest();
    			req.setEndpoint(chatbotSetting.End_Point__c+'select+id,+name,+sap_code__c+from+account+where+Recordtype.Name=\'distributor\'+And+account_type__c+=+\'Sold+To+Party\'+and+name+Like+\'%25'+custName+'%25\'');
    			req.setMethod('GET');
				    req.setHeader('Content-Type', 'application/json');
				    req.setHeader('Accept', 'application/json');
    			req.setHeader('Authorization', 'Bearer ' + getAccessToken(userDetails,chatbotSetting.siteBase__c,chatbotSetting.ConsumerKey__c) ); 
				  if(!test.isRunningTest()){
              res = h.send(req);
              }else{
                  res = MockHttpResponseGeneratorChatbot.respond(req);
                  system.debug('body-->>'+res.getBody());
              }
         		
             System.Debug('Response body >> ' + JSON2Apex.parse(res.getBody())); 
              
              //insert new Monitor_Log__c(Response__c	= res.getBody(),Method__c = userDetails);
              
          }catch(Exception e){
              System.Debug('EXCEPTION >> ' + e);
              System.Debug('EXCEPTION >> ' + e.getLineNumber());
          }
    	return res.getBody();
    }
    public static String getAccessToken(String username,string siteBase,String consumerKey){
       // String siteBase = 'https://test.salesforce.com';
       // String consumerKey = '3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw';
        Auth.JWT jwt = new Auth.JWT();
        jwt.setSub(username);
        jwt.setIss(consumerKey);
        jwt.setAud(siteBase);
        Auth.JWS jws = new Auth.JWS(jwt, 'EinsteinBot');
        String tokenEndpoint = siteBase+'/services/oauth2/token';
        Auth.JWTBearerTokenExchange bearer = new
        Auth.JWTBearerTokenExchange(tokenEndpoint, jws);
        String accessToken = '';
        if(!test.isRunningTest()){
            accessToken = bearer.getAccessToken();
        }
        System.Debug('accessToken >>>>>>> ' + accessToken);
        return accessToken;
    }

   
}