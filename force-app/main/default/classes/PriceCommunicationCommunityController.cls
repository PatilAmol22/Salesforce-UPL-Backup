public without sharing class PriceCommunicationCommunityController {
    
    @AuraEnabled
    public static Integer TotalRecords(){
        return [Select count() from Poland_Price_Communication__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<PCCWrapper> getppcommunicationList(){
        Id userId=UserInfo.getUserId();
        System.debug('userId : '+userId);
        List<PCCWrapper> ppcWrapList=new List<PCCWrapper>();
        Integer srNoCount=0;
        /*if(v_pagesize>10){
            srNoCount=srNoCount+v_pagesize;
        }*/
        List<User> userList=[SELECT Id, Name,contactId,contact.Name FROM User where id =:userId limit 1];
        List<Poland_Price_Communication__c> pPCList=[Select Id,Account__c,Description__c,CreatedDate from Poland_Price_Communication__c Where Contact__c=:userList[0].contactId Order By CreatedDate DESC];
            for(Poland_Price_Communication__c pccObj:pPCList){
                PCCWrapper wrapObj=new PCCWrapper();
                srNoCount=srNoCount+1;
                wrapObj.srNoCount=srNoCount;
                wrapObj.Id=pccObj.Id;
                wrapObj.description=pccObj.Description__c;
                datetime dt= pccObj.CreatedDate;
                wrapObj.createdDate=String.valueof(dt.format('dd-MM-yyyy'));
                ppcWrapList.add(wrapObj);
            }
        return ppcWrapList;
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

    @AuraEnabled(cacheable=true)
    public static List<ImageWrapper> getContentVersionIds(String nId){
        system.debug('nId:'+nId);
        List<ImageWrapper> imageWrapList=new List<ImageWrapper>();
        //cvIdsList.add('list of file');    
        List<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp, IsDeleted FROM ContentDocumentLink where LinkedEntityId=:nId And Visibility='AllUsers' And IsDeleted=false];
        system.debug('cdlList@@:'+cdlList);
        Set<String> ContentDocumentIdSet=new Set<String>();
        for(ContentDocumentLink cdlObj:cdlList){
            ContentDocumentIdSet.add(cdlObj.ContentDocumentId);
        }
         system.debug('ContentDocumentIdSet@@:'+ContentDocumentIdSet);
        List<ContentVersion> cvList=[SELECT Id, Title, Description, ContentBodyId, VersionData, ContentDocumentId,FileType,FileExtension  FROM ContentVersion where ContentDocumentId IN : ContentDocumentIdSet];
      system.debug('cvList@@:'+cvList);
        for(ContentVersion cvObj:cvList){
            ImageWrapper wrap=new ImageWrapper();
            wrap.title=cvObj.Title;
            wrap.imagebase64Str=EncodingUtil.base64Encode((blob) cvObj.get('VersionData'));
            wrap.fType=cvObj.FileExtension;
            //cvIdsList.add(EncodingUtil.base64Encode((blob) cvObj.get('VersionData')));
                //cvIdsList.add(cvObj.Id);
                imageWrapList.add(wrap);
        }
        System.debug('imageWrapList :'+imageWrapList);
        return imageWrapList;
    }
    
    /*@AuraEnabled(cacheable=true)
    public static List<String> getContentVersionIds(String pId){
        List<String> cvIdsList=new List<String>();
        //cvIdsList.add('list of file');    
        List<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp, IsDeleted FROM ContentDocumentLink where LinkedEntityId=:pId And Visibility='AllUsers' And IsDeleted=false];
        Set<String> ContentDocumentIdSet=new Set<String>();
        for(ContentDocumentLink cdlObj:cdlList){
            ContentDocumentIdSet.add(cdlObj.ContentDocumentId);
        }
        List<ContentVersion> cvList=[SELECT Id, Title, Description, ContentBodyId, VersionData, ContentDocumentId,FileType,FileExtension  FROM ContentVersion where ContentDocumentId IN : ContentDocumentIdSet];
        for(ContentVersion cvObj:cvList){
                cvIdsList.add(cvObj.Id);
        }
        System.debug('cvIdsList :'+cvIdsList);
        return cvIdsList;
    }*/


    public class PCCWrapper{
        @AuraEnabled public Integer srnoCount;
        @AuraEnabled public String Id;
        @AuraEnabled public String description;
        @AuraEnabled public String createdDate;
        PCCWrapper(){
            srnoCount=0;
            Id='';
            description='';
            createdDate='';
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