public class StockInChannel {
    
@AuraEnabled public Boolean isDirector{get;set;}
@AuraEnabled public Boolean isManager{get;set;}
@AuraEnabled public Boolean isCoordinator{get;set;}
@AuraEnabled public List<Territory_Distributor__c> zone{get;set;}
   
    @AuraEnabled
    public static list<user> getSalesRep(String BU) //Region
    { 
        //fetch Sales org code from Custom settings
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        
        list<user> liUser = new list<user>(); 
        set<id> userId = new set<id>();
        for (Territory_Distributor__c TD: [Select ID , TerritoryManager__c 
                                           from Territory_Distributor__c 
                                           where Sales_Org_Code__c=:SalesOrg 
                                           and Zone__c=: BU
                                          and (TerritoryManager__c=: UserInfo.getUserId() OR Regional_Manager_Id__c =: UserInfo.getUserId() OR Zonal_Manager_Id__c=: UserInfo.getUserId() or SBU_Head_Id__c=: UserInfo.getUserId())]){
            userId.add(TD.TerritoryManager__c);
        }    
        liUser = [select Id,Name from user where id in :userId];
        return liUser; 
	}
    
    //Wrapper for Init Info
    public class getInitInfo {
        
        @AuraEnabled
        public boolean EnabledAccess {get;set;} 
        @AuraEnabled
        public list<Zone__c> listZone {get;set;}
       
               
    }
    
     @AuraEnabled
    public static getInitInfo getBUOps()
    { 
        //fetch Sales org code from Custom settings
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        
        List<Territory_Distributor__c> Bulst;
        List<String> BUs = new list<String>();
        Set<Id> SetBUs=new Set<Id>();
         Bulst= [Select ID , Zone__c, Zone__r.name from Territory_Distributor__c where (TerritoryManager__c=: UserInfo.getUserId() OR Regional_Manager_Id__c	=: UserInfo.getUserId() OR Zonal_Manager_Id__c=: UserInfo.getUserId() OR SBU_Head_Id__c=: UserInfo.getUserId() ) AND (Sales_Org_Code__c = :SalesOrg)];
        For (Territory_Distributor__c B : Bulst)
        {
            SetBUs.add(B.Zone__c);            
        }
        list<Zone__c> liZone = [select id,name from Zone__c where id in :SetBUs];
        //BUs.addAll(SetBUs);
        getInitInfo wrapper = new getInitInfo();
        wrapper.listZone = liZone;
        String profileName;
        if(Test.isRunningTest()){
            profileName =  'Brazil Sales Person';  
        }
        else{
            profileName = [Select Name from Profile where Id = :UserInfo.getProfileId()][0].Name;
        }
        if(profileName == 'Brazil Sales Person' || profileName == 'Brazil Sales District Manager' || profileName == 'Brazil Sales Office Manager'){
           wrapper.EnabledAccess = false; 
        }
        else{
        wrapper.EnabledAccess = true;
            }
            
        return wrapper;
        
	}
    
    @AuraEnabled
    public static List<Territory_Distributor__c> getZone(String SalesRep)
    { 
        //fetch Sales org code from Custom settings
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        
        //system.debug('BU'+BU);
        List<Territory_Distributor__c> lst;
        
     	lst= [Select ID,name from Territory_Distributor__c where //zone__c=: BU and
              TerritoryManager__c=: SalesRep AND Sales_Org_Code__c=:SalesOrg]; //OR Regional_Manager_Id__c =: UserInfo.getUserId() OR Zonal_Manager_Id__c=: UserInfo.getUserId() or SBU_Head_Id__c=: UserInfo.getUserId()) AND Sales_Org_Code__c=:SalesOrg];
        
        return lst;
	}
    
    
    @AuraEnabled
    public static List<Account> getCustomer(String Region,String Salesrep)
    { 
        //fetch Sales org code from Custom settings
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        //List<Customer_and_Region_Mapping__c> Custlst;
        List<User> userlist = [SELECT UGDN_Number__c FROM User WHERE Id =: Salesrep];
        List<String> userugdns = new List<String>();
        for( User temp:userlist ){
            userugdns.add( temp.UGDN_Number__c );
        }
        List<SIC_Customer__c> SICCustList = new List<SIC_Customer__c>();
        
        
        List<Account> Cust = new list<Account>();
        //Set<Id> SRs=new Set<Id>();
        /*Custlst= [Select Customer_Name__c from Customer_and_Region_Mapping__c where CustomerRegion__c =: Region and
CustomerRegion__r.Sales_Org_Code__c=:SalesOrg];

For (Customer_and_Region_Mapping__c B : Custlst)
{
SRs.add(B.Customer_Name__c);            
}*/
        //system.debug('SRs '+SRs);
        //added by swapnil
        set<string> setCustomerCode = new set<string>();
        for(SIC_Customer__c A: [Select Customer_SAP_Code__c 
                                from SIC_Customer__c
                                where year__c = :string.valueOf(Date.Today().Year())
                                and active__c = true AND Sales_Rep_UGDN__c IN:userugdns] ){
                                    setCustomerCode.add(A.Customer_SAP_Code__c);   
                                }
        //system.debug('setCustomerCode '+setCustomerCode);
        Cust = [SELECT Id, Name, BillingCity,  SAP_Code__c 
                FROM Account 
                where SAP_Code__c in :setCustomerCode
                order by Name asc];
        //system.debug('Cust '+Cust);
        return Cust;
    }
    @AuraEnabled
    public static String getNotesID(String Year,String Customer,String Region)
    {
        String notesid; 
        
        List<Stock_In_Channel__c> lst= [select  id from Stock_In_Channel__c where Year__c=: Year and Channel__c=:Customer limit 1];
        For (Stock_In_Channel__c ab: lst){
        notesid= ab.id;
                
        } 
        return notesid;
    }
    
    
    
    
}