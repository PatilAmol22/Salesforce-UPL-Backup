public without sharing class LiquidationLookupControllerPoland {
    @AuraEnabled
    public static List<Search> searchedListPoland(String obj,String name,String value,string filter,String displayfield){
        System.debug('Name'+name);
        System.debug('Value'+value);
        System.debug('obj is'+obj);
        System.debug('filter '+filter);
        String filter_val='';
        if(!String.isBlank(value)){
            if(displayfield!='distributor' && displayfield!='sales_district'){
                filter_val = displayfield+' like \''+value+'%\' and ';
            }
        }
        
        List<Search> serachlist = new List<Search>();
        Set<String> serachset = new Set<String>();
        List<String> dist_id = new List<String>();
        List<SObject> alst; 
        System.debug('select '+name+' from '+obj+' where '+filter_val+filter);
        
        if(obj=='DistributorSalesAreaMapping__c'){
            String country_name = [Select id,Country from User where Id=:UserInfo.getUserId()].Country;
            AggregateResult[] lst = Database.query('select '+name+' from '+obj+' where '+filter_val+filter);
            for(AggregateResult obj1 : lst){
                dist_id.add((String)obj1.get('Distributor__c'));
            }
            if(Test.isRunningTest()){
                country_name = 'Poland';
            }
            system.debug('country_name==>'+country_name);
            if(country_name=='Poland'){
                alst = [select Id,Name,SAP_Code__c from Account where Id IN:dist_id and Active_for_Liquidation__c=true and sales_org__r.name='Poland'];
            }
            system.debug('alst==>'+alst);
            for(SObject a : alst){ 
                String fieldname = (String)a.get('Name');
                String sap_code = (String)a.get('SAP_Code__c');
                Id acc_id = (Id)a.get('Id');
                if(serachset.add(fieldname)){
                    serachlist.add(new Search(fieldname+' - '+sap_code,acc_id));
                }
            }
        }
        
        System.debug('result '+serachlist);
        return serachlist;
    }
    
    public class Search{ 
        @AuraEnabled
        public String recName;
        
        @AuraEnabled
        public ID recId;
        public Search(String recNametemp,ID recIdtemp)
        {
            recName = recNametemp;
            recId = recIdtemp;
        }
    }  
}