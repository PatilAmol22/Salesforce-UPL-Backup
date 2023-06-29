public class ChatBot_getOrderSummaryByTerritory {
	public class PrechatOutput{
    	@InvocableVariable
        public String countOrders;
        //@InvocableVariable
        //public Decimal totalNetValue;
       // @InvocableVariable
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
    @InvocableMethod(label='Get Order Summary By Territory')
    public static List<PrechatOutput> getOrderSummaryTerritoryData(List<PrechatInput> inputParameters){
        Decimal totalAmount=0.00;
        String orderChoice='';
        String userName='';
        Integer currencyCount=0;
        Territory_Distributor__c territoryData=new Territory_Distributor__c();
        
        system.debug('territoryData---->>>'+inputParameters[0].sTD);
            userName=inputParameters[0].sUserName;
            territoryData=inputParameters[0].sTD;
            system.debug('territoryData--->'+territoryData);
            orderChoice='%28Order_Status__c=\'Not+yet+processed\'+or+Order_Status__c=\'Partially+processed\'%29';
        
        string resp=getOrderSummary(userName,orderChoice, territoryData.TerritoryCode__c);

        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        List<JSON2Apex.Records> listOfTerritoryCount = new list<JSON2Apex.Records>();
        if(resp!=Null){
            totalAmount=0.00;
			
        	listOfTerritoryCount=JSON2Apex.parse(resp).records;
        	system.debug('listOfTerritoryCount---->'+listOfTerritoryCount);
        	//system.debug('response size'+listOfTerritoryCount.size());
            
            Map<String,List<JSON2Apex.Records>> cuCount = new Map<String,List<JSON2Apex.Records>>();
            
            for(JSON2Apex.Records key : listOfTerritoryCount){
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
            
        	if(listOfTerritoryCount.size()>0){
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
                //system.debug('totalAmount'+totalAmount);
                //prechatobject.totalNetValue=totalAmount;
                //system.debug('totalNetValue'+prechatobject.totalNetValue);
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
    public static string getOrderSummary(string userDetails,string orderChoice,string territoryCode ){
          HttpRequest req;
          HttpResponse res;
          try{ 
    		Http h = new Http();
              EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
                chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
              System.debug('chatbotSetting>>--->'+chatbotSetting);
                System.debug('userDetails>>--->'+userDetails);
                	req = new HttpRequest();
              		string query='SELECT+Id,+Sold_to_Party__r.Name,+Order_Status__c,+Order_Date__c,+SAP_Order_Number__c,+Final_Total_Amont__c,+CurrencyIsoCode+FROM Sales_Order__c+WHERE+Sold_to_Party__r.Territory_Distributor__r.TerritoryCode__c=\''+territoryCode+'\'+AND+'+orderChoice+'+AND+CreatedDate=LAST_N_DAYS:30';
              		System.debug('query--'+query);
    				req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Id,+Sold_to_Party__r.Name,+Order_Status__c,+Order_Date__c,+SAP_Order_Number__c,+Final_Total_Amont__c,+CurrencyIsoCode+FROM+Sales_Order__c+WHERE+Sold_to_Party__r.Territory_Distributor__r.TerritoryCode__c=\''+territoryCode+'\'+AND+'+orderChoice+'+AND+CreatedDate=LAST_N_DAYS:400');
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