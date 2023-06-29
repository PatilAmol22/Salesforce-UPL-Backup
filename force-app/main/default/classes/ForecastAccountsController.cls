/*******************************************************************************************
* @Name         Forecast Account (for Sales Forecast Generation)
* @Author       Nikhil Dhoke
* @Date         24/02/2022
* @Group        SKI
* @Description  This class contains all methods used in Forecast Account mapping for Sales Forecast Generation.
*******************************************************************************************/
public without sharing class ForecastAccountsController {

    /*
    * @Description - This method get called from forecastAccounts LWC to get map of forecast account.
                     Map is created from customer and region mapping and forecast account records.
    * @Param String - account id and territory id.
    * @return  -    map of account for forecast
    */
    @AuraEnabled(cacheable=true)
    public static Map<String,AccountsForForecast> getForecastAccounts(String accId,String terrId) //SKI (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
    {
        Map<String,AccountsForForecast> accountMap = new Map<String,AccountsForForecast>();
        try { 
            String query;   //---SKI (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
            String query2;  //---SKI (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
            
            List<Customer_and_Region_Mapping__c> accList = new List<Customer_and_Region_Mapping__c>();
            Set<String> combinationKeySet = new Set<String>();
             //System.debug('terrirory length - '+terrId.length());
            
                query = 'SELECT Id, Name, Customer_Name__c, Customer_Name__r.SAP_Code__c, CustomerRegion__c, '+
                        +' CustomerRegion__r.TerritoryCode__c, Customer_Name__r.Name, Customer_Name__r.BillingCity, '+
                        +' Customer_Name__r.Is_Forecast_required__c FROM Customer_and_Region_Mapping__c '+
                        +' WHERE Customer_Name__r.RecordType.Name = \'Distributor\' '+
                        +' AND Customer_Name__r.Account_Type__c = \'Sold To Party\' AND '+
                        +' Customer_Name__r.Sales_Org__r.Sales_Org_Code__c = \'5191\' ';
               //--- Start--SKI    (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
               query2 = 'SELECT Id, Name, Account__c, Combination_Key__c, OwnerId, Account__r.BillingCity, '+
                        +' Territory__c, CurrencyIsoCode, Dummy_Customer__c, Territory__r.TerritoryCode__c, '+
                        +' Account__r.Is_Forecast_required__c, Account__r.Name, Account__r.SAP_Code__c FROM Forecast_Account__c '+
                        +' WHERE Account__r.RecordType.Name = \'Distributor\' '+
                        +' AND Account__r.Account_Type__c = \'Sold To Party\' AND '+
                        +' Account__r.Sales_Org__r.Sales_Org_Code__c = \'5191\' AND '+
                        +' Dummy_Customer__c = true ';

            //--- End--SKI    (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
            //System.debug('Account Id' +accId.length());
            //--- Start---SKI (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
            if(terrId.length()>0)
            {
                query +='AND  CustomerRegion__c =\''+terrId+'\'';
                query2 +='AND  Territory__c =\''+terrId+'\'';
            }
            else {
                query +='AND  CustomerRegion__r.TerritoryManager__c =\''+UserInfo.getUserId()+'\'';
                query2 +='AND  Territory__r.TerritoryManager__c =\''+UserInfo.getUserId()+'\'';

            }
            //---End---SKI (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022


            if(accId.length()>0){
                
                query += 'AND Customer_Name__c = \''+accId+'\' ORDER BY Customer_Name__r.Name';
                query2 += 'AND Account__c = \''+accId+'\'';
            }
            else{
                query += ' ORDER BY Customer_Name__r.Name';
            }
            //system.debug('query is -'+query);
            accList = Database.query(query);      
           // System.debug('Account List :- '+ accList.size());
           // System.debug('Account accId :- '+ accId);
            if(accList.size()>0){
                for(Customer_and_Region_Mapping__c acc : accList){
                    if(acc.CustomerRegion__r.TerritoryCode__c != null && acc.Customer_Name__r.SAP_Code__c != null){
                        combinationKeySet.add(acc.CustomerRegion__r.TerritoryCode__c+acc.Customer_Name__r.SAP_Code__c);
                    }

                    if(!accountMap.containsKey(acc.CustomerRegion__r.TerritoryCode__c+acc.Customer_Name__r.SAP_Code__c)){
                        AccountsForForecast aff = new AccountsForForecast();
                        aff.accountId = acc.Customer_Name__c;
                        aff.accountName = acc.Customer_Name__r.Name;
                        aff.sapCode = acc.Customer_Name__r.SAP_Code__c;
                        aff.enableForForecast = acc.Customer_Name__r.Is_Forecast_required__c;
                        aff.territoryId = acc.CustomerRegion__c;
                        aff.isSelected = false;
                        aff.isDummy = false;
                        aff.combiKey = acc.CustomerRegion__r.TerritoryCode__c+acc.Customer_Name__r.SAP_Code__c;
                        aff.accountCity = acc.Customer_Name__r.BillingCity;
                        accountMap.put(aff.combiKey,aff);
                    }
                }
                //System.debug('combinationKeySet :- '+ combinationKeySet);
                

                List<Forecast_Account__c> forecastAccounts = new List<Forecast_Account__c>();
                if(combinationKeySet.size()>0){
                    forecastAccounts = [SELECT Id, Name, Account__c, Combination_Key__c, OwnerId, 
                        Territory__c, CurrencyIsoCode, Dummy_Customer__c FROM Forecast_Account__c 
                        WHERE Combination_Key__c IN : combinationKeySet];
                }
                // System.debug('forecastAccounts :- '+ forecastAccounts);
                if(forecastAccounts.size()>0){
                    for(Forecast_Account__c fa : forecastAccounts){
                        if(accountMap.containsKey(fa.Combination_Key__c)){
                            AccountsForForecast aff = accountMap.get(fa.Combination_Key__c); 
                            aff.isSelected = true;
                            if(fa.Dummy_Customer__c == true){
                                aff.isDummy = true;
                            }
                            accountMap.put(fa.Combination_Key__c,aff);
                        }
                    }
                }
               // System.debug('accountMap :- '+ accountMap.size());
                forecastAccounts = new List<Forecast_Account__c>();
                forecastAccounts = Database.query(query2); 

                if(forecastAccounts.size()>0){
                    for(Forecast_Account__c fa : forecastAccounts){
                        String combKey = fa.Territory__r.TerritoryCode__c;
                        if(!accountMap.containsKey(combKey)){
                            AccountsForForecast aff = new AccountsForForecast();
                            aff.accountId = fa.Account__c;
                            aff.accountName = fa.Account__r.Name;
                            if(fa.Account__r.SAP_Code__c == null){
                                aff.sapCode = '';
                            }
                            else{
                                aff.sapCode = fa.Account__r.SAP_Code__c;
                            }
                            aff.accountCity = fa.Account__r.BillingCity;
                            aff.enableForForecast = fa.Account__r.Is_Forecast_required__c;
                            aff.territoryId = fa.Territory__c;
                            aff.isSelected = true;
                            aff.isDummy = true;
                            aff.combiKey = combKey;
                            accountMap.put(combKey,aff);
                        }
                    }
                }
               // System.debug('accountMap2 :- '+ accountMap.size());
                
            }    
            
        } 
        catch (Exception ex) {
            System.debug('Exception in getForecastAccounts :- '+ ex);
            System.debug('Exception at Line no :- '+ ex.getLineNumber());
            System.debug('Exception is :- '+ ex.getMessage());
            //throw new AuraHandledException(e.getMessage());
        }
        return accountMap;
    }

    /*
    * @Description - This method get called from forecastAccounts LWC to save forecast account records
    * @Param - all 3 input parameters are serialize string. checked account ids, unchecked account ids, forecast account map
    * @return  -  status of operation
    */
    @AuraEnabled
    public static string saveMapping(String checkedIds, String unCheckedIds, String forecastAccountMap){
        String result ='';
        List<String> checkedIdList = new List<String>();
        List<String> unCheckedIdList = new List<String>();
        List<String> allCmbKey = new List<String>();
        Map<String,AccountsForForecast> accountMap = new Map<String,AccountsForForecast>();
        try {
            accountMap = (Map<String,AccountsForForecast>)JSON.deserialize(forecastAccountMap, Map<String,AccountsForForecast>.class);
            checkedIdList = (List<String>)JSON.deserialize(checkedIds, List<String>.class);
            unCheckedIdList = (List<String>)JSON.deserialize(unCheckedIds, List<String>.class);

            if(checkedIdList.size()>0){
                allCmbKey.addAll(checkedIdList);
            }
            if(unCheckedIdList.size()>0){
                allCmbKey.addAll(unCheckedIdList);
            }

            List<Forecast_Account__c> fAccList = new List<Forecast_Account__c>();
            Map<String,Forecast_Account__c> fAccMap = new Map<String,Forecast_Account__c>();
            fAccList = [SELECT Id, Name, Account__c, Combination_Key__c, OwnerId, Territory__c 
                        FROM Forecast_Account__c WHERE Combination_Key__c IN: allCmbKey];
            if(fAccList.size()>0){
                for(Forecast_Account__c fa : fAccList){
                    if(!fAccMap.containsKey(fa.Combination_Key__c)){
                        fAccMap.put(fa.Combination_Key__c, fa);
                    }
                }
            }
            
            List<Forecast_Account__c> fAccDeleteList = new List<Forecast_Account__c>();
            if(unCheckedIdList.size()>0){
                for(String cmKey : unCheckedIdList){
                    if(fAccMap.containsKey(cmKey)){
                        fAccDeleteList.add(fAccMap.get(cmKey));
                    }
                }
            }

            if(fAccDeleteList.size()>0){
                delete fAccDeleteList;
            }

            List<Forecast_Account__c> fAccInsertList = new List<Forecast_Account__c>();
            if(checkedIdList.size()>0){
                for(String cmKey : checkedIdList){
                    if(!fAccMap.containsKey(cmKey)){
                        Forecast_Account__c facc = new Forecast_Account__c();
                        facc.Account__c = accountMap.get(cmKey).accountId;
                        facc.Territory__c = accountMap.get(cmKey).territoryId;
                        facc.Combination_Key__c = cmKey;
                        facc.OwnerId = UserInfo.getUserId();

                        fAccInsertList.add(facc);
                    }
                }
            }
            
            if(fAccInsertList.size()>0){
                insert fAccInsertList;
            }

            result = 'success';

           /*  System.debug('accountMap deserialize:- '+ JSON.serializePretty(accountMap));
            System.debug('checkedIdList :- '+ JSON.serializePretty(checkedIdList));
            System.debug('unCheckedIdList :- '+ JSON.serializePretty(unCheckedIdList)); */
        } 
        catch (Exception ex) {
            System.debug('Exception in saveMapping :- '+ ex);
            System.debug('Exception at Line no :- '+ ex.getLineNumber());
            System.debug('Exception is :- '+ ex.getMessage());
            result = 'error';
            //throw new AuraHandledException(ex.getMessage());
        }
        return result;
    }

    /*
    * @Description - This method get called from forecastAccounts LWC to get list of territories for which manager is null
    * @Param - N/A
    * @return  -  list of territorys
    */
   //--- Start--SKI  (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
    @AuraEnabled
    public static List<Territory_Distributor__c> getterritory()
    {   

        List<Territory_Distributor__c> terr = new  List<Territory_Distributor__c>();
        terr = [Select Id, Name, TerritoryCode__c,TerritoryManager__c,Sales_Org_Code__c FROM Territory_Distributor__c WHERE  Sales_Org_Code__c = '5191' AND TerritoryManager__c =NULL Order By TerritoryCode__c ASC];
        return terr;

    }
    //--- End--SKI  (PrashantK) : #CR155 : Forecast Account For Demand Planner : 03-08-2022
 
    /*
    * @Description - This is a wrapper class
    * @Param - N/A
    * @return  - N/A
    */
    public class AccountsForForecast{
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public String sapCode;
        @AuraEnabled public Boolean enableForForecast;
        @AuraEnabled public String territoryId;
        @AuraEnabled public Boolean isSelected;
        @AuraEnabled public String combiKey;
        @AuraEnabled public Boolean isDummy;
        @AuraEnabled public String accountCity;
        
        
        AccountsForForecast(){
         accountId = '';
         accountName = '';
         sapCode = '';
         enableForForecast = false;
         territoryId = '';
         isSelected = false;
         combiKey = '';
         isDummy = false;
         accountCity = '';
         
        }
     }
}