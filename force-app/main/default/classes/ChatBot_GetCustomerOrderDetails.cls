public class ChatBot_GetCustomerOrderDetails {
    public class PrechatOutput{
    	@InvocableVariable
        public List<JSON2Apex.Records> listOfCustomerOrder = new list<JSON2Apex.Records>();
        @InvocableVariable
    	public boolean isError = false;
    }
    public class PrechatInput{
        @InvocableVariable
        public JSON2Apex.Records Acc=new JSON2Apex.Records();
        @InvocableVariable
        public String orderStatus;
		@InvocableVariable
        public String userName;
                
    } 
    
    @InvocableMethod(label='Get Customer Order List')
    public static List<PrechatOutput> getCustomerOrderListData(List<PrechatInput> inputParameters){
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        //String filter = '%28Order_Status__c=\'Not+yet+processed\'+or+Order_Status__c=\'Partially+processed\'%29';
        String userName='';
        String orderStatus='';
        JSON2Apex.Records customerData=new JSON2Apex.Records();
    
            userName=inputParameters[0].userName;
            orderStatus=inputParameters[0].orderStatus;
            customerData=inputParameters[0].Acc;
            
            if(inputParameters[0].orderStatus == 'Open Orders'){
            orderStatus='%28Order_Status__c=\'Not+yet+processed\'+or+Order_Status__c=\'Partially+processed\'%29';
            
        	}
        	if(inputParameters[0].orderStatus == 'Dispatched Orders'){
            orderStatus='Order_Status__c=\'Completely+processed\'';
            }
            system.debug('order Status--'+orderStatus);
        
        
        system.debug('Customer code--'+customerData.SAP_Code);
        
        string resp=getOrderStatus(userName,orderStatus,customerData.SAP_Code);
        if(resp!=Null){
        	prechatobject.listOfCustomerOrder=JSON2Apex.parse(resp).records;
        	system.debug('prechatobject.listOfBrand---->'+prechatobject.listOfCustomerOrder);
        	system.debug('response size'+prechatobject.listOfCustomerOrder.size());
        	if(prechatobject.listOfCustomerOrder.size()==0){
            	prechatobject.isError =true;
        	}
        	po.add(prechatobject);
        
        }else{
            system.debug('Null value');
             prechatobject.isError =true;
             po.add(prechatobject);
        }
        return po ;
    }
    
    public static string getOrderStatus(string userDetails,string orderStatus,string custCode ){
          HttpRequest req;
          HttpResponse res;
          try{ 
              Http h = new Http();
              EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
                chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
             
                  	req = new HttpRequest();
              		string query='SELECT+Id,+Name,+Sold_to_Party__r.SAP_Code__c,+Order_Date__c,+Order_Status__c+FROM+Sales_Order__c+where+'+orderStatus+'+and+Sold_to_Party__r.SAP_Code__c=\''+custCode+'\'+and+Order_Date__c=LAST_N_DAYS:30';
              		System.debug('query--'+query);
    				req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Id,+Name,+Sold_to_Party__r.SAP_Code__c,+Order_Date__c,+SAP_Order_Number__c,+Order_Status__c+FROM+Sales_Order__c+where+'+orderStatus+'+and+Sold_to_Party__r.SAP_Code__c=\''+custCode+'\'+and+createdDate=LAST_N_DAYS:180');
    				req.setMethod('GET');
				    req.setHeader('Content-Type', 'application/json');
				    req.setHeader('Accept', 'application/json');
    				req.setHeader('Authorization', 'Bearer ' + getAccessToken(userDetails,chatbotSetting.siteBase__c,chatbotSetting.ConsumerKey__c) ); 
					 if(!test.isRunningTest()){
                  res = h.send(req);
              }else{
                  	
                  res = MockHttpResponseGeneratorChatbot.respond(req);
              }

             System.Debug('Response body >> ' + JSON2Apex.parse(res.getBody())); 
              
              //insert new Monitor_Log__c(Response__c	= res.getBody(),Method__c = userDetails);
              
          }catch(Exception e){
              System.Debug('EXCEPTION >> ' + e);
              return null;
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
        String accessToken ='';
        if(!test.isRunningTest()){
            accessToken = bearer.getAccessToken();
        }
        System.Debug('accessToken >>>>>>> ' + accessToken);
        return accessToken;
    }


}