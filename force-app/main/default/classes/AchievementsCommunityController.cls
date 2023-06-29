public without sharing class AchievementsCommunityController {  
    
    @AuraEnabled
    public static Integer TotalRecords(){

        Integer totalRecords=0;
        String strAccId='';
        String salesOrgCode='';
        String CommunityRole ='';
        String country ='';
        String userid = UserInfo.getUserId();
        System.debug('userid : '+userid);
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, AccountId,Account.Sales_Org_Code__c,
                        Account.Sales_Org_Country__c FROM User WHERE Id=: userid];

        strAccId=userObj.AccountId;    
        salesOrgCode=userObj.Account.Sales_Org_Code__c;
		CommunityRole= userObj.Community_Role__c;
        country=userObj.Account.Sales_Org_Country__c;
        
        System.debug('strAccId : '+strAccId);
        System.debug('salesOrgCode : '+salesOrgCode);
        System.debug('country : '+country);
        
        //List<AchievementWrapper> achivementDistributorWrapList=new List<AchievementWrapper>();
        List<AchievementWrapper> achivementWrapList=new List<AchievementWrapper>();
        Integer srNoCountDist=0;

        for(Community_Configuration__c ccObj:[SELECT Id, Name, Title__c, Description__c, Active__c,Visible_to_All__c,Country__c,Sales_Org__c,Distributor_Name__c FROM Community_Configuration__c where recordType.Name='Achievement' And Active__c=true And Visible_to_All__c=true And Valid_From__c<=Today and Valid_To__c>=Today AND Community_User_Role__c =:CommunityRole AND Country__c=:country AND Sales_Org__c=:salesOrgCode AND (Distributor_Name__c=:strAccId OR Visible_to_All__c=true)]){
                AchievementWrapper wrapObj=new AchievementWrapper();
                srNoCountDist=srNoCountDist+1;
                wrapObj.srNoCount=srNoCountDist;
                wrapObj.Id=ccObj.Id;
                wrapObj.title=ccObj.Title__c;
                wrapObj.description=ccObj.Description__c;
                achivementWrapList.add(wrapObj);
            }
        System.debug('achivementWrapList size : '+achivementWrapList.size());
        System.debug('achivementWrapList : '+achivementWrapList);
        totalRecords=achivementWrapList.size();
        return totalRecords;
    }

    @AuraEnabled(cacheable=true)
    public static List<AchievementWrapper> getAchievementList(){
        
        String strAccId='';
        String salesOrgCode='';
        String CommunityRole ='';
        String country ='';
        String userid = UserInfo.getUserId();
        System.debug('userid : '+userid);
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, AccountId,Account.Sales_Org_Code__c,
                        Account.Sales_Org_Country__c FROM User WHERE Id=: userid];

        strAccId=userObj.AccountId;    
        salesOrgCode=userObj.Account.Sales_Org_Code__c;
		CommunityRole= userObj.Community_Role__c;
        country=userObj.Account.Sales_Org_Country__c;
        System.debug('strAccId : '+strAccId);
        System.debug('salesOrgCode : '+salesOrgCode);
        System.debug('country : '+country);
        
        //List<AchievementWrapper> achivementDistributorWrapList=new List<AchievementWrapper>();
        List<AchievementWrapper> achivementWrapList=new List<AchievementWrapper>();
        Integer srNoCountDist=0;

        for(Community_Configuration__c ccObj:[SELECT Id, Name, Title__c, Description__c, Active__c,Visible_to_All__c,Country__c,Sales_Org__c,Distributor_Name__c FROM Community_Configuration__c where recordType.Name='Achievement' And Active__c=true And Valid_From__c<=Today and Valid_To__c>=Today AND Community_User_Role__c =:CommunityRole AND Country__c=:country AND Sales_Org__c=:salesOrgCode AND (Distributor_Name__c=:strAccId OR Visible_to_All__c=true)  Order By CreatedDate DESC]){
            AchievementWrapper wrapObj=new AchievementWrapper();
            wrapObj.Id=ccObj.Id;
            wrapObj.title=ccObj.Title__c;
            wrapObj.description=ccObj.Description__c;
            srNoCountDist=srNoCountDist+1;
            wrapObj.srNoCount=srNoCountDist;
            achivementWrapList.add(wrapObj);
            
        }
        System.debug('achivementWrapList2 size : '+achivementWrapList.size());
        System.debug('achivementWrapList2 : '+achivementWrapList);
        return achivementWrapList;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getNext(Integer v_Offset, Integer v_pagesize){
        v_Offset += v_pagesize;
        return v_Offset;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPrevious(Integer v_Offset, Integer v_pagesize){
        v_Offset -= v_pagesize;
        return v_Offset;
    }

    public class AchievementWrapper{
        @AuraEnabled public Integer srNoCount;
        @AuraEnabled public String Id;
        @AuraEnabled public String title;
        @AuraEnabled public String description;

        AchievementWrapper(){
            srNoCount=0;
            Id='';
            title='';
            description='';
        }
       
    }
}