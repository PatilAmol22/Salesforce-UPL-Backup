public without sharing class NoticeController {
    
    
    @AuraEnabled(cacheable=true)
    public static List<wrapperClass> getNewsList(){
        //https://upl--uat--c.documentforce.com/
        
        //String baseImageURL='https://upl--upltest--c.cs57.content.force.com'; //Please check while image loading
        String baseImageURL='https://upl--uat--c.documentforce.com/'; //Please check while image loading
        List<wrapperClass> newsWrapList=new List<wrapperClass>();
        list<object> objectList;
        List<wrapperClass> wrpList;
        
        
        
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
        
        
        
        List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        List<Community_Configuration__c> ccList= new List<Community_Configuration__c>();
        List<Community_Configuration__c> ccList1= new List<Community_Configuration__c>();
        List<Community_Configuration__c> genralsettingList = new List<Community_Configuration__c>();
        genralsettingList = [SELECT Id, Name,no_of_news_display_on_home_page__c, Title__c, Description__c,Image__c, Active__c 
                             FROM Community_Configuration__c
                             Where (Distributor_Name__c =:recordId OR Visible_to_All__c = true)
                             AND RecordType.Name='General Setting'
                             AND Country__c=:countryName
                             AND Sales_Org__c =:salesOrg
                             AND Community_User_Role__c =:CommunityRole
                             AND Active__c=true ];
        
        System.debug('genralsettingList in new com '+genralsettingList);
        String noofNews = '1' ; 
        if(genralsettingList.size()>0 && genralsettingList[0].no_of_news_display_on_home_page__c!='' ){
            noofNews = genralsettingList[0].no_of_news_display_on_home_page__c;
        }
        
        
        String recordTypeName = 'News';
        String soqlStr = 'Select Id, Name, Title__c,Description_For_News__c, Description__c,Image__c, Active__c From Community_Configuration__c  Where (Distributor_Name__c =:recordId OR Visible_to_All__c = true)  AND RecordType.Name=:recordTypeName AND Country__c=:countryName  AND Sales_Org__c =:salesOrg AND Community_User_Role__c =:CommunityRole AND Active__c=true AND Display_On_Home_Page__c= true LIMIT '+noofNews;
        
        ccList = Database.query(soqlStr);
        
        //System.debug('ccList1 '+ccList1);
        //System.debug('ccList1 in newss '+ccList1.size());
        
        /*ccList =[SELECT Id, Name, Title__c, Description__c,Image__c, Active__c FROM Community_Configuration__c
                 Where (Distributor_Name__c =:recordId OR Visible_to_All__c = true)
                 AND RecordType.Name='News'
                 AND Country__c=:countryName
                 AND Sales_Org__c =:salesOrg
                 AND Valid_From__c <= TODAY 
                 AND Valid_To__c >= TODAY
                 AND Community_User_Role__c =:CommunityRole
                 AND Active__c=true AND Display_On_Home_Page__c= true];
                 */
        
        System.debug('ccList1 in newss in next '+ccList.size());
        
        
        list<String> ccIdList = new list<String>();
        for(Community_Configuration__c tempObj : ccList){
            ccIdList.add(tempObj.id);
            
        }
        
        list<ContentDocumentLink> listofContentDocumentLink = new list<ContentDocumentLink>();
        listofContentDocumentLink =[SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :ccIdList];
        list<String> CntDocIds = new list<String>(); 
        
        System.debug('listofContentDocumentLink '+listofContentDocumentLink);
        System.debug('listofContentDocumentLink size '+listofContentDocumentLink.size());
        
         for(ContentDocumentLink cdl : listofContentDocumentLink){
            CntDocIds.add(cdl.ContentDocumentId);
        }
        system.debug('CntDocIdsgsdf'+CntDocIds);
        
        list<ContentVersion> lstcontVer = new list<ContentVersion>();
        lstcontVer = [SELECT Id, VersionData, OwnerId,Description__c,Description_For_News__c, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN:CntDocIds];  
        objectList = new list<object>();
        
        wrpList = new List<wrapperClass>();
        wrapperClass wrapperClassObj;
        
        System.debug('lstcontVer '+lstcontVer);
        System.debug('lstcontVer size in news component '+lstcontVer.size());
        
        for(ContentVersion cv:lstcontVer){
            wrapperClassObj = new wrapperClass();
            wrapperClassObj.imgObj=EncodingUtil.base64Encode((blob) cv.get('VersionData'));
            wrapperClassObj.description= cv.Description__c;
            System.debug('@@@@@@ cv.Description_For_News__c '+cv.Description_For_News__c);
            wrapperClassObj.descriptionforNews= cv.Description_For_News__c;
            
            wrpList.add(wrapperClassObj);
        }
        
        System.debug('@@@@@@ wrpList in news  '+wrpList);
         
        return wrpList;
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    @AuraEnabled    
    public static String gettingUrlAddress(){
        list<Community_Url_Configuration__c> csList= new List<Community_Url_Configuration__c>();
        String returnUrl='';
        csList=[SELECT Id, Name, URL__c FROM Community_Url_Configuration__c WHERE  Name ='Distributors Community URL' ];
        if(csList.size()>0){
            returnUrl=csList[0].URL__c;
        }
        return returnUrl;
    }
    
    public class wrapperClass{
       @AuraEnabled public object imgObj {get;set;}
       @AuraEnabled public String description {get;set;}
        @AuraEnabled public String descriptionforNews {get;set;}
        public wrapperClass(){
            description ='';
            descriptionforNews='';
            
            
        }
        
    }
}