public without sharing class LiquidationLookupController {
    @AuraEnabled
    public static List<Search> searchedList(String obj,String name,String value,string filter,String displayfield){
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
        if(String.isBlank(filter)&& obj=='Sales_District__c'){
            String country_name = [Select id,Country from User where Id=:UserInfo.getUserId()].Country;
            String profile_name = [Select id,Name from Profile where id=:UserInfo.getProfileId()].Name;
            System.debug('Profile Name '+profile_name);
            if(profile_name.containsIgnoreCase('National sales Manager indonesia') || profile_name.containsIgnoreCase('Sales Head Indonesia') || profile_name.containsIgnoreCase('Supply Chain & QM Turkey') || profile_name.containsIgnoreCase('Country Head For Turkey') || profile_name.containsIgnoreCase('Marketing Manager Turkey') || profile_name.containsIgnoreCase('Regional tech & technical sales Turkey') || profile_name.containsIgnoreCase('Marketing Manager Indonesia') || profile_name.containsIgnoreCase('Vietnam Country Head') || profile_name.containsIgnoreCase('Vietnam National Sales Manager(NSM)') || profile_name.containsIgnoreCase('Vietnam Sales Admin User') || profile_name.containsIgnoreCase('Vietnam Sales Manager(B2B)')){
                filter = 'User__r.Country=\''+country_name+'\'';
            }else{
                filter = 'User__c=\''+userinfo.getUserId()+'\'';
            }

        }
        List<Search> serachlist = new List<Search>();
        Set<String> serachset = new Set<String>();
        List<String> dist_id = new List<String>();
        List<SObject> alst; 
        System.debug('select '+name+' from '+obj+' where '+filter_val+filter);
        if(obj!='DistributorSalesAreaMapping__c'){
            String country_name = [Select id,Country from User where Id=:UserInfo.getUserId()].Country;
            String profile_name = [Select id,Name from Profile where id=:UserInfo.getProfileId()].Name;
            if(country_name.containsIgnoreCase('Mexico') && String.isEmpty(filter) && profile_name.containsIgnoreCase('Territory Manager for Mexico')){
                filter = 'User__c=\''+UserInfo.getUserId()+'\' and Distributor__r.Sales_District__c!=null and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true';
            }else if(country_name.containsIgnoreCase('Mexico') && String.isEmpty(filter) && profile_name.containsIgnoreCase('Regional/Zonal Managers for Mexico')){
                filter = 'Regional_manager__c=\''+UserInfo.getUserId()+'\' and Distributor__r.Sales_District__c!=null and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true';
            }else if(country_name.containsIgnoreCase('Mexico') && String.isEmpty(filter)){
                filter = ' Distributor__r.Sales_District__c!=null and Active_for_Liquidation__c = true and Distributor__r.Active_For_Liquidation__c = true';
            }
            System.debug('--> select '+name+' from '+obj+' where '+filter);
            alst = Database.query('select '+name+' from '+obj+' where '+filter);
            System.debug('alst size '+alst.size());
            if(displayfield=='sales_district'){
                for(SObject s :alst){
                    dist_id.add((String)s.get('Distributor__c'));
                }
                alst = [select Id,Sales_District__c from Account where Id IN:dist_id];
                for(SObject s :alst){
                    dist_id.add((String)s.get('Sales_District__c'));
                }
                String q = 'select id,Name from Sales_District__c where Id IN:dist_id  and Name like \''+value+'%\' limit 10';
                displayfield = 'Name';
                alst = Database.query(q);
            }
            if(displayfield=='distributor'){
                for(SObject s :alst){
                    dist_id.add((String)s.get('Distributor__c'));
                }
                String q = 'select id,Name from Account where Id IN:dist_id  and Name like \''+value+'%\' limit 10';
                displayfield = 'Name';
                alst = Database.query(q);
            }
            if(displayfield=='Location_Name__c'){
                alst = Database.query('select '+name+' from '+obj+' where '+filter_val+' '+filter+' limit 10');
            }
            for(SObject a : alst){ 
                String fieldname = (String)a.get(displayfield);
                // String sap_code = (String)a.get('Distributor_SAP_Code__c');
                if(displayfield=='Location_Name__c'){
                    String field2 =  (String)a.get('City__c');
                    serachlist.add(new Search(fieldname+'-- '+field2,a.Id));
                }else{
                    serachlist.add(new Search(fieldname,a.Id));
                }
            }
            System.debug('search list '+serachlist);
        }
        if(obj=='DistributorSalesAreaMapping__c'){
            String country_name = [Select id,Country from User where Id=:UserInfo.getUserId()].Country;
            if(country_name.containsIgnoreCase('mexico')==false){
            AggregateResult[] lst = Database.query('select '+name+' from '+obj+' where '+filter_val+filter);
            for(AggregateResult obj1 : lst){
                dist_id.add((String)obj1.get('Distributor__c'));
            }
            if(country_name=='Indonesia'){
            alst = [select Id,Name,SAP_Code__c from Account where Id IN:dist_id and Active_for_Liquidation__c=true];
            }else{
            alst = [select Id,Name,SAP_Code__c from Account where Id IN:dist_id];
            }
            for(SObject a : alst){ 
                String fieldname = (String)a.get('Name');
                String sap_code = (String)a.get('SAP_Code__c');
                Id acc_id = (Id)a.get('Id');
                if(serachset.add(fieldname)){
                    serachlist.add(new Search(fieldname+' - '+sap_code,acc_id));
                }
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