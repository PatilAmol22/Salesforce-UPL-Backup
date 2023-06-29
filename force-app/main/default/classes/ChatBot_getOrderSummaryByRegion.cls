public class ChatBot_getOrderSummaryByRegion {
    public class PrechatOutput{
    	@InvocableVariable
        public String countOrders;
        //@InvocableVariable
        //public Decimal totalNetValue;
        //@InvocableVariable
        //public String currencyIsoCode;
    	@InvocableVariable
    	public boolean isError = false;
    	 
    }
    public class PrechatInput{
        @InvocableVariable
        public String sUserName;
        @InvocableVariable
        public Territory_Distributor__c sTD=new Territory_Distributor__c();
        
    }
    
    @InvocableMethod(label='Get Order Summary By Region')
    public static List<PrechatOutput> getOrderSummaryRegionData(List<PrechatInput> inputParameters){
        Decimal totalAmount=0.0;
        String orderChoice='';
        String userName='';
        Territory_Distributor__c regionData=new Territory_Distributor__c();
        
            userName=inputParameters[0].sUserName;
            regionData=inputParameters[0].sTD;
            system.debug('Region data--->>'+regionData);
            system.debug('Region code--->'+regionData.Region_Code__c);
            orderChoice='%28Order_Status__c=\'Not+yet+processed\'+or+Order_Status__c=\'Partially+processed\'%29';
        
        
        List<JSON2Apex.Records> listOfRegionCount = new list<JSON2Apex.Records>();
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
                
        string resp=getOrderSummary(userName,orderChoice,regionData.Region_Code__c);
        if(resp!=Null){
        	listOfRegionCount=JSON2Apex.parse(resp).records;
        	system.debug('listOfRegionCount---->'+listOfRegionCount);
        	system.debug('response size'+listOfRegionCount.size());
        	Map<String,List<JSON2Apex.Records>> cuCount = new Map<String,List<JSON2Apex.Records>>();
            
            for(JSON2Apex.Records key : listOfRegionCount){
    			if(!cuCount.containsKey(key.CurrencyIsoCode)){
    				List<JSON2Apex.Records> listOfRec=new List<JSON2Apex.Records>();
                    listOfRec.add(key);
                    cuCount.put(key.CurrencyIsoCode,listOfRec);
    			}
                else{
                    List<JSON2Apex.Records> listOfRec=cuCount.get(key.CurrencyIsoCode);
                    listOfRec.add(key);
   			 		cuCount.put(key.CurrencyIsoCode,listOfRec); 
                }
    			
			}
            system.debug('count--->>'+cuCount.keyset().size());
            
        	if(listOfRegionCount.size()>0){
                prechatobject.countOrders='';
                system.debug('Count'+prechatobject.countOrders);
                
                for(String str:cuCount.keyset()){
                    prechatobject.countOrders=prechatobject.countOrders+'Order Count : '+cuCount.get(str).size()+'\n';
                    Decimal Total_Sum=0.00;
                    for(JSON2Apex.Records JA:cuCount.get(str)){
                           Total_Sum=Total_Sum+JA.Total_Amount;
                    }
                    
                    prechatobject.countOrders=prechatobject.countOrders+'Total Value : ('+str+')'+(Total_Sum.format().contains('.')?Total_Sum.format():(Total_Sum.format()+'.00'))+'\n';
                }
            }else{
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
    public static string getOrderSummary(string userDetails,string orderChoice,String regionCode){
          HttpRequest req;
          HttpResponse res;
          try{ 
    		Http h = new Http();
              EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
                chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
       
                  req = new HttpRequest();
              string query='SELECT+Id,+Sold_to_Party__r.Name,+Order_Status__c,+Order_Date__c,+SAP_Order_Number__c,+Final_Total_Amont__c,+CurrencyIsoCode+FROM+Sales_Order__c+WHERE+Sold_to_Party__r.Territory_Distributor__r.Region_Code__c=\''+regionCode+'\'+AND+'+orderChoice+'+AND+CreatedDate=LAST_N_DAYS:400';
              System.debug('query--'+query);
    			req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Id,+Sold_to_Party__r.Name,+Order_Status__c,+Order_Date__c,+SAP_Order_Number__c,+Final_Total_Amont__c,+CurrencyIsoCode+FROM+Sales_Order__c+WHERE+Sold_to_Party__r.Territory_Distributor__r.Region_Code__c=\''+regionCode+'\'+AND+'+orderChoice+'+AND+CreatedDate=LAST_N_DAYS:400');
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