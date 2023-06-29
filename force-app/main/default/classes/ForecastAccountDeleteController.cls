public class ForecastAccountDeleteController {
    @AuraEnabled(cacheable=true)
    public static List<ForecastAccountWrapper> getForecastAccount(){
        List<ForecastAccountWrapper> wrapperList = new  List<ForecastAccountWrapper>();
        
        Integer currentYear = System.Today().year();
        Set<Id> SalesAgreementIdSet=new  Set<Id> ();
        List<SalesAgreement> salesAgreementList=new List<SalesAgreement>();
        List<Forecast_Account__c> foreAccountList=new List<Forecast_Account__c>();
        Set<String> combinationKeyForForecastAccount=new Set<String>();
       
        String agreemMonth=[Select id,Customer_SAP_Code__c,Combination_Key__c,Active_Forecast_Month__c,Year__c, Region__r.TerritoryCode__c FROM SalesAgreement where TotalAgreementAmount=0  and (NOT(Combination_Key__c LIKE '%spot%'))
                           order by Active_Forecast_Month__c desc limit 1].Active_Forecast_Month__c;
                           
     String agreemYear=[Select id,Customer_SAP_Code__c,Combination_Key__c,Active_Forecast_Month__c,Year__c, Region__r.TerritoryCode__c FROM SalesAgreement where TotalAgreementAmount=0  and (NOT(Combination_Key__c LIKE '%spot%'))
                           order by Year__c desc limit 1].Year__c;
        System.debug('agreemYear'+agreemYear+'agreemMonth'+agreemMonth);
        salesAgreementList= [Select id,Customer_SAP_Code__c,Combination_Key__c,Active_Forecast_Month__c, Region__r.TerritoryCode__c FROM SalesAgreement 
                             WHERE TotalAgreementAmount=0 and Year__c =:agreemYear and (NOT(Combination_Key__c LIKE '%spot%'))  and Active_Forecast_Month__c=:agreemMonth limit 75 ];
        System.debug('salesAgreementList'+salesAgreementList.size());
        for(SalesAgreement sAgreement:salesAgreementList){
            combinationKeyForForecastAccount.add(sAgreement.Region__r.TerritoryCode__c+sAgreement.Customer_SAP_Code__c);
        }
        System.debug('combinationKey'+combinationKeyForForecastAccount);
        
        if(combinationKeyForForecastAccount!=null){
            foreAccountList=[SELECT Id, Name, Account__c, Combination_Key__c, OwnerId, 
                             Territory__r.TerritoryCode__c,Account__r.Name,Account__r.SAP_Code__c, Dummy_Customer__c FROM Forecast_Account__c where Combination_Key__c in:combinationKeyForForecastAccount];
            
            System.debug('foreAccountList'+foreAccountList.size());
        }
        if(foreAccountList.size()>0 && !foreAccountList.isEmpty()){
            for(Forecast_Account__c facc:foreAccountList){
                wrapperList.add(new ForecastAccountWrapper(facc.Name,facc.Account__r.Name,facc.Territory__r.TerritoryCode__c,facc.Account__r.SAP_Code__c,facc.Combination_Key__c));
            }
        }
        return wrapperList; 
    }
    
    public class ForecastAccountWrapper {
        @AuraEnabled public String Name;   
        @AuraEnabled public String AccName;
        @AuraEnabled public String Territory;
        @AuraEnabled public String SAPCode;
        @AuraEnabled public String combKey;
        
        
        public ForecastAccountWrapper(String Name,String AccName,String Territory,String SAPCode,String combKey) {
            this.Name=Name;
            this.AccName = AccName;
            this.Territory = Territory;
            this.SAPCode = SAPCode;
            this.combKey = combKey;
            
        }
    }
    @AuraEnabled
    public static Boolean deleteForecastAccount(List<Forecast_Account__c> fAList){
        System.debug('faa'+fAList);
        List<Forecast_Account__c> delForecastAccount=new List<Forecast_Account__c>();
        List<String> forecastNameList=new List<String>();
        if(fAList.size()>0 && !fAList.isEmpty() && fAList!=null ){
            for(Forecast_Account__c fa:fAList){
                forecastNameList.add(fa.Name);
            }
        }
        if(forecastNameList.size()>0 && !forecastNameList.isEmpty() && forecastNameList!=null){
            delForecastAccount=[Select id from Forecast_Account__c where Name in:forecastNameList];
            
            
            
        }
        try{
            System.debug('enteer in del');
            if(delForecastAccount.size()>0 && !delForecastAccount.isEmpty() && delForecastAccount!=null){
                System.debug('delForecastAccount'+delForecastAccount);
                delete delForecastAccount;
                return true;
            }
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
        return false;
    }
    
}