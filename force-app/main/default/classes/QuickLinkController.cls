public without sharing class  QuickLinkController {
    
    @AuraEnabled
    public static List<Community_Configuration__c> gettingDetailsCommConfig(){
        System.debug('QuickLinkController Controller Class');
        
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        salesOrg = userObj.Account.Sales_Org_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        CommunityRole= userObj.Community_Role__c;
        System.debug('@@@ CommunityRole '+CommunityRole);
        System.debug('@@@ RecordId '+RecordId);
        
        List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        List<Community_Configuration__c> ccList= new List<Community_Configuration__c>();
        
        
       // if(forCheckList.size()>0){
        try{
            ccList =[Select Id,Name,Custom_Link_Name__c,Custom_Link_Url__c,Standard_Link_Url__c 
                     FROM Community_Configuration__c
                     Where (Distributor_Name__c =:recordId OR Visible_to_All__c = true)
                     AND RecordType.Name='Quick Link'
                     AND Valid_From__c <= TODAY 
                     AND Valid_To__c >= TODAY
                     AND Community_User_Role__c =:CommunityRole
                     AND Country__c=:countryName
                     AND Sales_Org__c =:salesOrg
                     AND Active__c=true
                     ORDER BY Sort_Order_On__c ASC];  
        }
        catch(Exception ex){
            System.debug('Error Occure on QuickLink controller '+ex.getLineNumber());
            System.debug('Error Occure on QuickLink controller '+ex.getMessage());
            return null;
        }
        
        System.debug('ccList '+ccList);
        System.debug('ccList  szie '+ccList.size());
        return ccList;
        
        
       // }
        /*else{
            ccList =[Select Id,Name,Custom_Link_Name__c,Custom_Link_Url__c 
                     FROM Community_Configuration__c
                     Where Sales_Org__c =:salesOrg
                     AND Country__c=:countryName
                     AND RecordType.Name='Quick Link'
                     AND Valid_From__c <= TODAY 
                     AND Valid_To__c >= TODAY
                     AND Community_User_Role__c =:CommunityRole
                     AND Visible_to_All__c = true
                     AND Active__c=true
                     ORDER BY Sort_Order_On__c ASC];  
        }*/
        
       
        
        
    }
    
    
}