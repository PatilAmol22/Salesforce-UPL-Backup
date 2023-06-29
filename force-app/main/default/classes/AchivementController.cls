public without sharing class AchivementController {
    
    public List<Community_Configuration__c> ccList {get;set;}
    public List<wrapClass> wrapClassList {get;set;}
    
    
    public AchivementController(){
        ccList= new List<Community_Configuration__c>();
        wrapClassList = new List<wrapClass>();
    }
    
    
    
    public void gettingAchivementInfo(){
        System.debug('in Achivment Info');
        
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, AccountId,Account.Sales_Org_Code__c,
                        Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        salesOrg = userObj.Account.Sales_Org_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        CommunityRole= userObj.Community_Role__c;
        System.debug('@@@ CommunityRole in Achivement  '+CommunityRole);
        System.debug('@@@ RecordId in Achivement '+RecordId);
        
        
        List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        
        
        
        //if(forCheckList.size()>0){
            System.debug('In first Part');
            
            ccList = [Select Id,Name,Image__c,Description__c FROM Community_Configuration__c
                      WHERE (Distributor_Name__c =:recordId OR Visible_To_All__c= true)
                      AND RecordType.Name='Achievement'
                      AND Community_User_Role__c =:CommunityRole
                      AND Sales_Org__c =:salesOrg
                      AND Country__c=:countryName
                      AND Valid_From__c <= Today
                      AND Valid_To__c >= Today
                      AND Active__c=true];
            
            
            
    //    }
   /* else{
            System.debug('In Else Part');
            ccList = [Select Id,Name,Image__c,Description__c FROM Community_Configuration__c
                      Where Sales_Org__c =:salesOrg
                      AND Country__c=:countryName
                      AND RecordType.Name='Achievement'
                      AND Valid_From__c <= TODAY 
                      AND Valid_To__c >= TODAY
                      AND Community_User_Role__c =:CommunityRole
                      AND Active__c=true];
        }
*/
        
        System.debug('ccList in achivement '+ccList);
        System.debug('ccList in achivement size  '+ccList.size());
        
        if(ccList.size()>0){
            Integer i=0;
            wrapClass wrapClassObj ; 
            for(Community_Configuration__c ccObj :ccList){
                wrapClassObj = new wrapClass();
                wrapClassObj.description = ccObj.Description__c;
                wrapClassObj.index = i;
                wrapClassList.add(wrapClassObj);
                i++;
            }
        }
        
        System.debug('wrapClassList '+wrapClassList);
        System.debug('wrapClassList size  '+wrapClassList.size());
        
        
    }
    
    
    
      
    
    
    public class  wrapClass{
        public String description{get;set;}
        public Integer index{get;set;}
        public wrapClass(){
            description='';
            index =0;
        }
        
        
    }
   
    
    
}