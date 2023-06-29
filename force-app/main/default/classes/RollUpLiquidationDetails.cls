public class RollUpLiquidationDetails {
    
    public static Map<String,Liquidation2__c> rollUpLiquidation(String query){//String lst_salesDistricts,String sales_districts,String start_year,String month,string SalesOrgCode
        HttpRequest req;
        HttpResponse res;
        String userDetails=[SELECT id,name, username from user Where Id='005280000017DV0'].username;
        //String userDetails=userInfo.getUserName();
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Http h = new Http();
        
        Map<String,Liquidation2__c> mapLiq = new map<String,Liquidation2__c>();
              EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
                chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
                req = new HttpRequest();
        req.setEndpoint(chatbotSetting.End_Point__c+query);//'SELECT+SKU__r.SKU_Code__c,SKU__r.Brand_Name__c,SKU__r.SKU_Description__c,+SUM(YTD_Sales__c),+SUM(Liquidation_YTD__c),+SUM(Total_Available_Stock__c),+SUM(Distributors_Inventory__c),+SUM(Retailers_Inventory__c),+SUM(Total_Market_Inventory__c),+SUM(Plan_for_the_month__c),+SUM(Plan_for_the_next_month__c),+SUM(Opening_Inventory2__r.Opening_Inventory__c),+SUM(Liquidation_Percent_YTD__c)+FROM+Liquidation2__c++WHERE+SKU__r.Active_for_Liquidation__c+=+true++AND+RecordTypeId+=+\''+rec_type+'\'+Group+By+SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,SKU__r.Brand_Name__c');
        
        
         req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + getAccessToken(userDetails,chatbotSetting.siteBase__c,chatbotSetting.ConsumerKey__c) ); 
				
            if(!test.isRunningTest()){
                  res = h.send(req);
                 }else{      
				res = MockHttpResponseGeneratorChatbot.respond(req);
            }
                
                system.debug('body>>--->'+res.getBody());
                for(RollupLiqMulticountryJSON2Apex.records rec : RollupLiqMulticountryJSON2Apex.parse(res.getBody()).records){
                Liquidation2__c liq = new Liquidation2__c();
                liq.SKU_Code__c = rec.SKU_Code;
                liq.Brand_Name__c = rec.Brand_Name;
                liq.SKU_Description__c =rec.SKU_Description;
                //liq.SKU__c = new SKU__c(SKU_Code__r == rec.SKU_Code);    
                liq.YTD_Sales_Wrap__c = rec.expr0;
                liq.Liquidation_YTD_Wrap__c = rec.expr1;
                liq.Total_Available_Stock_Wrap__c = rec.expr2;    
                liq.Distributors_Inventory__c =rec.expr3;
                liq.Retailers_Inventory__c = rec.expr4;
                liq.Total_Market_Inventory_Wrap__c = rec.expr5;    
                liq.Plan_for_the_month__c = rec.expr6;
                liq.Plan_for_the_next_month__c = rec.expr7;
                liq.Opening_Inventory_Wrap__c = rec.expr8;
                liq.UOM_Wrap__c = rec.UOM;
                if(!String.isEmpty(String.valueOf(rec.expr9))){   
               		liq.Liquidation_YTD_Percent_Wrap__c = double.valueof(decimal.valueOf(rec.expr9).setscale(2)) ; 
                }else{
                    liq.Liquidation_YTD_Percent_Wrap__c = double.valueof('0') ;
                }
                    
                //system.de
                    mapLiq.put(liq.SKU_Code__c,liq);
                        
                }     
                
           
        return mapLiq;
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