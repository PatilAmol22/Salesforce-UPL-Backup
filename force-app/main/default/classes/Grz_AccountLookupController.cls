public class Grz_AccountLookupController {
    
    /**
     * Returns JSON of list of ResultWrapper to Lex Components
     * @objectName - Name of SObject
     * @fld_API_Text - API name of field to display to user while searching
     * @fld_API_Val - API name of field to be returned by Lookup COmponent
     * @lim   - Total number of record to be returned
     * @fld_API_Search - API name of field to be searched
     * @searchText - text to be searched
     * */
    @AuraEnabled(cacheable=true) 
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,Integer lim,String fld_API_Search,String searchText ){
        Id recordTypeShowId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        system.debug('recordTypeShowId--'+recordTypeShowId);
        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
        
        String query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+' FROM '+objectName+' WHERE '+fld_API_Search+' LIKE '+searchText+ ' AND (recordtypeId  =: recordTypeShowId OR Customer_Category__c = \'03\') LIMIT '+lim;
        
        List<sObject> sobjList = Database.query(query);
        List<ResultWrapper> lstRet = new List<ResultWrapper>();
        
        for(SObject s : sobjList){
            ResultWrapper obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fld_API_Text)) ;
            obj.val = String.valueOf(s.get(fld_API_Val))  ;
            lstRet.add(obj);
        } 
         return JSON.serialize(lstRet) ;
    }
    
    @AuraEnabled
    public static ResultWrapper AccountUserInfo(String accId){
        ResultWrapper rwobj = new ResultWrapper();
        List<ResultWrapper> rwList = new List<ResultWrapper>();
        System.debug('accId : '+accId);
        accId = String.escapeSingleQuotes(accId);
        String indiaprofile = System.Label.Grz_IndiaCommunityProfile;
        List<String> profileNameList = new List<String>{'Brazil Partner Community Distributor Profile','India Partner Community Distributor Profile New','Mexico Partner Community Distributor Profile','Brazil Partner Community Distributor Profile New','Brazil Partner Community Distributor Finance Profile','Brazil Partner Community Distributor Marketing Profile','Brazil Partner Community Distributor Supply Profile'};
        profileNameList.add(indiaprofile);
        List<User> uList = [select id, name,contactId,Contact.name,MobilePhone,Email,accountId from user where accountId =: accId and profile.name in : profileNameList];
        List<ResultWrapper> SaleOrgName = new List<ResultWrapper>();
        List<String> SaleOrgNameList = new List<String>();
        List<DistributorSalesAreaMapping__c> SalesAreaNameList = [SELECT Id, Name, Distributor__c, SalesOrg__c,SalesOrg__r.name, Sales_Org_Code__c, Territory__c FROM DistributorSalesAreaMapping__c where Distributor__c =: accId order by lastmodifieddate desc];                
        for(DistributorSalesAreaMapping__c sa : SalesAreaNameList){
            ResultWrapper salesobj = new ResultWrapper();
            salesobj.Id = sa.SalesOrg__c;
            salesobj.Name = sa.SalesOrg__r.name;
            system.debug('SaleOrgName : '+salesobj.Name);
            if(!SaleOrgNameList.contains(salesobj.Name)){
                SaleOrgNameList.add(salesobj.Name);
                SaleOrgName.add(salesobj); 
            }
        }
        for(User u : uList){
            ResultWrapper obj = new ResultWrapper();
            obj.Name = u.Contact.name;
            obj.Email = u.Email;
            Obj.MobilePhone = u.MobilePhone;
            rwList.add(Obj);
        }
        rwobj.SalesOrgWrapper = SaleOrgName;
        rwobj.rwuserList = rwList;
        System.debug('Account Related User : '+rwobj);
        return rwobj;
    }
    
    public class ResultWrapper{
        public String objName {get;set;}
        public String text{get;set;}
        public String val{get;set;}
        
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Email{get;set;}
        @AuraEnabled
        public String MobilePhone{get;set;}
        @AuraEnabled
        public List<ResultWrapper> SalesOrgWrapper{get;set;}
        @AuraEnabled
        public List<ResultWrapper> rwuserList{get;set;}
    }
}