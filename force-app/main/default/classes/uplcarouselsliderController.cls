public without sharing class uplcarouselsliderController {
    // public List<wrapperClass> wrapperClassList {get;set;}
    public ContentVersion CV {get;set;}
    public list<object> objectList {get;set;}
    
    public List<wrapperClass> wrpList{get;set;}
    public String temp1;
    public String temp2;
    public String temp3;
    public String temp4;
    
    public uplcarouselsliderController(){
        // wrapperClassList = new List<wrapperClass>();
    }
    
    public void fetchDistributorDetails(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        temp1='';
        temp1='';
        temp1='';
        temp1='';
       
        
        
        
        //List<wrapperClass> wrapperClassList = new List<wrapperClass>();
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey, 
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        salesOrg = userObj.Account.Sales_Org_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        CommunityRole= userObj.Community_Role__c;
        
        System.debug('recordId in recordId '+recordId);
        System.debug('recordId in salesOrg '+salesOrg);

        System.debug('recordId in countryName '+countryName);
        System.debug('recordId in CommunityRole '+CommunityRole);
        
        
        List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        List<Community_Configuration__c> ccList= new List<Community_Configuration__c>();
       // forCheckList = [Select Id from Community_Configuration__c WHERE Distributor_Name__c=:RecordId];
        
        //if(forCheckList.size()>0){
            System.debug('inside first');
            
           
                ccList =[Select Id,Name,Image__c,Custom_Link_Url__c  
                         FROM Community_Configuration__c
                         Where (Distributor_Name__c =:recordId OR Visible_to_All__c =true)
                         AND RecordType.Name='Banner'
                         AND Country__c=:countryName
                         AND Sales_Org__c =: salesOrg
                         AND Valid_From__c <= TODAY 
                         AND Valid_To__c >= TODAY
                         AND Community_User_Role__c =:CommunityRole
                         AND Active__c=true ];
            
            
    //    }
    /*else{
            System.debug('inside Second');
            ccList =[Select Id,Name,Image__c,Custom_Link_Url__c 
                     FROM Community_Configuration__c
                     Where Sales_Org__c =:salesOrg
                     AND Country__c=:countryName
                     AND RecordType.Name='Banner'
                     AND Valid_From__c <= TODAY 
                     AND Valid_To__c >= TODAY
                     AND Visible_to_All__c =true
                     AND Community_User_Role__c =:CommunityRole
                     AND Active__c=true ];  
        }*/
        
        System.debug('ccList in banner '+ccList);
        System.debug('ccList  szie in Banner  '+ccList.size());
        
        
        
        
        
        
        
        
        
        
         temp1='';
        temp1='';
        temp1='';
        temp1='';
        // wrapperClass wrapperClassObj;
        list<String> ccIdList = new list<String>();
        Integer i=0;
        for(Community_Configuration__c tempObj : ccList){
            ccIdList.add(tempObj.id);
            
        }
        system.debug('ccIdList inside '+ccIdList);
        temp1='';
        temp1='';
        temp1='';
        temp1='';
        
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
       
        lstcontVer = [SELECT Id, VersionData, OwnerId,Hyperlink_URL__c, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN:CntDocIds];  
        objectList = new list<object>();
        
        wrpList = new List<wrapperClass>();
        wrapperClass wrapperClassObj;
        
        System.debug('lstcontVer '+lstcontVer);
        System.debug('lstcontVer size '+lstcontVer.size());
        for(ContentVersion cv:lstcontVer){
            wrapperClassObj = new wrapperClass();
            wrapperClassObj.imgObj=EncodingUtil.base64Encode((blob) cv.get('VersionData'));
            System.debug('cv.Hyperlink_URL__c in uplc page '+cv.Hyperlink_URL__c);
            
            wrapperClassObj.hyperLink = cv.Hyperlink_URL__c;
            if(cv.Hyperlink_URL__c=='https://null'){
               wrapperClassObj.isurlAvail= true;
            }else{
                wrapperClassObj.isurlAvail= false;
            }      
            wrpList.add(wrapperClassObj);
            
          
        }
        
        //System.debug('wrpList '+wrpList[0].isurlAvail);
        //System.debug('wrpList '+wrpList[1].isurlAvail);
        //System.debug('wrpList '+wrpList[2].isurlAvail);
        //System.debug('wrpList '+wrpList[3].isurlAvail);
        
        
        
    }
    
    
    
    
    public class wrapperClass{
        public object imgObj {get;set;}
        public String hyperLink {get;set;}
        public Boolean isurlAvail {get;set;} 
        
        public wrapperClass(){
            //imgObj = new object();
            hyperLink ='';
            isurlAvail = false;
           
        }
        
    }
    
    
    
}