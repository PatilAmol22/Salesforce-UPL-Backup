/*Class to get the latest rebate percentages
 * test class: BRRebateModule_Test
 * Gurubaksh Grewal(Grazitti) (RITM0523779 )
 * Date Created:05-04-23
 * Last Modified:17-04-23
 * */
public class Grz_RebatePercentagesUploader {
    public static String GenerateToken(){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:HCI_SAP');
        req.setTimeout(120000);
        req.setMethod('POST');
        HTTPresponse res= http.send(req);
        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Object token = (Object)response.get('access_token');
        return token.toString();
    }
    public static map<string,object> getRebPercentages(){
        map<string,object> respMap=new map<string,object>();
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/Fetch_Rebate_Calculation');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        //req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            system.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
                string res1=res.getBody();
          respMap=(map<string,object>)JSON.deserializeUntyped(res1);
          system.debug('respMap=====>'+JSON.serializePretty(respMap));
            }
            
        }catch(Exception e){
            system.debug('error====>'+JSON.serializePretty(e));
        }
        return respMap;
    }
    	@future(callout=true)
        public static void upsRebPercentages(){
            map<string,Rebate_Percentage_Calculation__c> rpcMap =new map<string,Rebate_Percentage_Calculation__c>();
            map<string,object> rootMap=getRebPercentages();
            if(rootMap.containsKey('root')){
          		map<string,object> itemMapP=(map<string,object>)rootMap.get('root');
                if(itemMapP.containsKey('item')){
                    
          		list<object> itemList=(list<object>)itemMapP.get('item');
                for(object itOb:itemList){
                  map<string,object>itemMap=(map<string,object>)itOb;  
                    string clientClass='';
                    string operator='';
                    decimal perc=0.00;
                    string productClass='';
                    string type1='';
                    decimal value1=0.00;
                    string year1='';
                    
                    if(itemMap.containsKey('Year__c'))year1=string.valueOf(itemMap.get('Year__c'));
                    if(itemMap.containsKey('Type__c'))type1=string.valueOf(itemMap.get('Type__c'));
                    if(itemMap.containsKey('Client_Classification__c'))clientClass=string.valueOf(itemMap.get('Client_Classification__c'));
                    if(itemMap.containsKey('Product_Classification__c'))productClass=string.valueOf(itemMap.get('Product_Classification__c'));
                    if(itemMap.containsKey('Value__c'))value1=decimal.valueOf(string.valueOf(itemMap.get('Value__c')));
                    if(itemMap.containsKey('Percentage__c'))perc=decimal.valueOf(string.valueOf(itemMap.get('Percentage__c')));
                    
                    string extId=productClass+clientClass+type1+year1;
                    rpcMap.put(extId,(new Rebate_Percentage_Calculation__c(Year__c=year1,Type__c=type1,Client_Classification__c=clientClass,Product_Classification__c=productClass,Value__c=value1,Percentage__c=perc,ExternalId__c=extId)));
                    
                }
                }
                
            }
            if(rpcMap!=null && !rpcMap.values().isEmpty()) upsert rpcMap.values() ExternalId__c;
        }
}