public without sharing class NewsCommunityController {
    

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
        
        List<NewsWrapper> newsWrapList=new List<NewsWrapper>();
        
        Integer srNoCount=0;
            for(Community_Configuration__c ccObj:[SELECT Id, Country__c, Name, Title__c, Description__c,Image__c, Active__c,Visible_to_All__c,Sales_Org__c,Distributor_Name__c FROM Community_Configuration__c where recordType.Name='News'  And Active__c=true And Valid_From__c<=Today and Valid_To__c>=Today AND Community_User_Role__c =:CommunityRole AND Country__c=:country AND Sales_Org__c=:salesOrgCode AND (Distributor_Name__c=:strAccId OR Visible_to_All__c=true) Order By CreatedDate DESC]){
                NewsWrapper wrapObj=new NewsWrapper();
                srNoCount=srNoCount+1;
                wrapObj.srNoCount=srNoCount;
                wrapObj.Id=ccObj.Id;
                wrapObj.title=ccObj.Title__c;
                String urlStr=getImageUrl(ccObj.Image__c);
                wrapObj.description=ccObj.Description__c;
                newsWrapList.add(wrapObj);
            }
            System.debug('newsWrapList : '+newsWrapList);
            System.debug('newsWrapList size: '+newsWrapList.size());
            totalRecords=newsWrapList.size();
        return totalRecords;
    }

    @AuraEnabled(cacheable=true)
    public static List<NewsWrapper> getNewsList(){

        
        String strAccId='';
        String salesOrgCode='';
        String accountCountry='';
        String CommunityRole ='';
        String userid = UserInfo.getUserId();
        System.debug('userid : '+userid);
        User userObj = [SELECT Id,Country,UserName,Community_Role__c,TimeZoneSidKey, AccountId,Account.Sales_Org_Code__c,
                        Account.Sales_Org_Country__c FROM User WHERE Id=: userid];

        strAccId=userObj.AccountId;    
        salesOrgCode=userObj.Account.Sales_Org_Code__c;
        accountCountry=userObj.Account.Sales_Org_Country__c;
        CommunityRole= userObj.Community_Role__c;
        
        System.debug('strAccId : '+strAccId);
        System.debug('salesOrgCode : '+salesOrgCode);
        System.debug('accountCountry : '+accountCountry);
        
        Map<Integer,String> dateMap=new Map<Integer,String>();
        dateMap.put(1,'Jan');
        dateMap.put(2,'Feb');
        dateMap.put(3,'March');
        dateMap.put(4,'April');
        dateMap.put(5,'May');
        dateMap.put(6,'June');
        dateMap.put(7,'July');
        dateMap.put(8,'Aug');
        dateMap.put(9,'Sep');
        dateMap.put(10,'Oct');
        dateMap.put(11,'Nov');
        dateMap.put(12,'Dec');
        
        list<String> ccIdList = new list<String>();
        for(Community_Configuration__c ccObj:[SELECT Id FROM Community_Configuration__c where recordType.Name='News' And Active__c=true And Country__c=:accountCountry And Valid_From__c<=Today and Valid_To__c>=Today AND Community_User_Role__c =:CommunityRole]){
            ccIdList.add(ccObj.id);
        }
        System.debug('ccIdList Id :'+ccIdList);
        list<String> CntDocIds = new list<String>();
        Map<String,String> cLEIMap=new Map<String,String>();
        Map<String,String> cDIMap=new Map<String,String>();
        for(ContentDocumentLink cdl :[SELECT Id, ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :ccIdList]){
            CntDocIds.add(cdl.ContentDocumentId);
            cLEIMap.put(cdl.LinkedEntityId,cdl.ContentDocumentId);
            cDIMap.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
        }
        System.debug('cLEIMap :'+cLEIMap);
        System.debug('cDIMap :'+cDIMap);
        Map<String,String> cVDMap=new Map<String,String>();
        for(ContentVersion cv:[SELECT Id, VersionData, OwnerId, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: CntDocIds]){
            System.debug('str :');
            cVDMap.put(cDIMap.get(cv.ContentDocumentId),EncodingUtil.base64Encode((blob) cv.get('VersionData')));
        }
        
        List<NewsWrapper> newsWrapList=new List<NewsWrapper>();
        
        Integer srNoCount=0;
            for(Community_Configuration__c ccObj:[SELECT Id, Name, Country__c, Title__c, Description__c, Description_For_News__c,Image__c, Active__c,Visible_to_All__c,Sales_Org__c,Distributor_Name__c,CreatedDate FROM Community_Configuration__c where recordType.Name='News'  AND Active__c=true AND Valid_From__c<=Today AND Valid_To__c>=Today AND Community_User_Role__c =:CommunityRole AND Country__c=:accountCountry AND Sales_Org__c=:salesOrgCode AND (Distributor_Name__c=:strAccId OR Visible_to_All__c=true) Order By CreatedDate DESC]){
                NewsWrapper wrapObj=new NewsWrapper();
                srNoCount=srNoCount+1;
                wrapObj.srNoCount=srNoCount;
                wrapObj.Id=ccObj.Id;
                wrapObj.title=ccObj.Title__c;
                wrapObj.country=ccObj.Country__c;
                String mapStr=cVDMap.get(ccObj.Id);
                if(!String.isEmpty(mapStr)){
                    if(mapStr.length()<6000000){
                        String base64Str='data:image/png;base64,'+cVDMap.get(ccObj.Id);
                        wrapObj.imageurl=base64Str;
                    }
                }
                
                wrapObj.description=ccObj.Description__c;
                wrapObj.RichDescription=ccObj.Description_For_News__c;
                Datetime dateStr=ccObj.CreatedDate;
                System.debug('Date Str => '+dateStr.year() + '-' + dateStr.month() + '-' + dateStr.day());
                wrapObj.createDate=dateStr.day()+' '+dateMap.get(dateStr.month())+', '+dateStr.year();
                newsWrapList.add(wrapObj);
                /*if(ccObj.Visible_to_All__c==true){
                    if(ccObj.Sales_Org__c.contains(salesOrgCode)){
                        newsWrapList.add(wrapObj);
                    }
                }
                if(ccObj.Distributor_Name__c==strAccId){
                    if(ccObj.Visible_to_All__c==false)
                        newsWrapList.add(wrapObj);
                }*/
            }
        System.debug('newsWrapList size: '+newsWrapList.size());
        return newsWrapList;
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
    public static string getImageUrl(String image_url){
        String imageURL='';
        Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher(image_url);           
        while (imgMatcher.find()) {                
            String imageTag = imgMatcher.group();
            System.debug('imageTag :' +imageTag );              
            
            imageURL= imageTag.substringBetween(' src="', '"' );
            System.debug('imageURL :' + imageURL );
        }
        return imageURL.unescapeHtml4();
    } 

    @AuraEnabled(cacheable=true)
    public static List<ImageWrapper> getContentVersionIds(String nId){
        List<ImageWrapper> imageWrapList=new List<ImageWrapper>();
        List<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp, IsDeleted FROM ContentDocumentLink where LinkedEntityId=:nId And Visibility='AllUsers' And IsDeleted=false];
        Set<String> ContentDocumentIdSet=new Set<String>();
        for(ContentDocumentLink cdlObj:cdlList){
            ContentDocumentIdSet.add(cdlObj.ContentDocumentId);
        }
        List<ContentVersion> cvList=[SELECT Id, Title, Description, ContentBodyId, VersionData, ContentDocumentId,FileType,FileExtension  FROM ContentVersion where ContentDocumentId IN : ContentDocumentIdSet];
        for(ContentVersion cvObj:cvList){
            ImageWrapper wrap=new ImageWrapper();
            wrap.title=cvObj.Title;
            wrap.imagebase64Str=EncodingUtil.base64Encode((blob) cvObj.get('VersionData'));
            wrap.fType=cvObj.FileExtension;
            imageWrapList.add(wrap);
        }
        System.debug('imageWrapList :'+imageWrapList);
        return imageWrapList;
    }

    public class NewsWrapper{
        @AuraEnabled public Integer srNoCount;
        @AuraEnabled public String Id;
        @AuraEnabled public String title;
        @AuraEnabled public String imageurl;
        @AuraEnabled public String description;
        @AuraEnabled public String createDate;
        @AuraEnabled public String country;
        @AuraEnabled public String RichDescription;
        

        NewsWrapper(){
            srNoCount=0;
            Id='';
            imageurl='';
            title='';
            description='';
            createDate='';
            country='';
            RichDescription='';
        }
       
    }

    public class ImageWrapper{
        @AuraEnabled public String title;
        @AuraEnabled public String imagebase64Str;
        @AuraEnabled public String fType;

        ImageWrapper(){
            title='';
            imagebase64Str='';
            fType='';
        }

    }
}