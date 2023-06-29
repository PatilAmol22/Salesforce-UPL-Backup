public without sharing class PolandPriceCommunicationAuraController {
    
    @AuraEnabled
    public static List<Account> getDistributors(){
        system.debug('distributors');
        List<Account> acntList = [SELECT Name, Id, (Select id,Name,Email from contacts where Email!=null) FROM Account WHERE Sales_Org_Code__c='2941' And SAP_Code__c!=null And Id in (Select AccountId from contact where (Email!=null And Is_Community__c=true))];

        return acntList;
    }
    
    @AuraEnabled
    public static List<DistributorDetailsWrapper> getCommunityContacts(List<String> selectedIds){
        List<DistributorDetailsWrapper> listWrap=new List<DistributorDetailsWrapper>();
        System.debug('selectedIds :'+selectedIds);
        List<Contact> contactList=[Select id,Name,Email,AccountId,Account.Name from Contact where AccountId IN (Select id from Account where Id IN :selectedIds) And Is_Community__c=true];
        System.debug('contactList :'+contactList);
        for(Contact contObj:contactList){
            DistributorDetailsWrapper wrapper=new DistributorDetailsWrapper();
            wrapper.accId=contObj.AccountId;
            wrapper.accName=contObj.Account.Name;
            wrapper.cId=contObj.id;
            wrapper.cName=contObj.Name;
            wrapper.cEmail=contObj.Email;
            listWrap.add(wrapper);
        }
        return listWrap;
    }
    
    @AuraEnabled
    public static List<Poland_Price_Communication__c> createPPCommunication(boolean isSendEmail,String description,String distributorDetailList){
        System.debug('description :'+description);
        Id userId=UserInfo.getUserId();
        Map<String,String> userIdMap=new Map<String,String>();
        List<Poland_Price_Communication__c> ppComList=new List<Poland_Price_Communication__c>();
        List<DistributorDetailsWrapper> datalist = (List<DistributorDetailsWrapper>)JSON.deserialize(distributorDetailList, List<DistributorDetailsWrapper>.class);
        Map<String,String> accntIdMap=new Map<String,String>();
        for(Account acntObj:[Select id,name from Account where Sales_Org_Code__c='2941' And SAP_Code__c!=null And Id in (Select AccountId from contact where (Email!=null And Is_Community__c=true))]){
            accntIdMap.put(acntObj.name,acntObj.id);
        }
        
        for(User userObj:[Select id,name,ContactId from User]){
            userIdMap.put(userObj.ContactId,userObj.id);
        }
        
        for(DistributorDetailsWrapper ddwrapObj:datalist){
            Poland_Price_Communication__c ppComObj=new Poland_Price_Communication__c();
            if(accntIdMap.containsKey(ddwrapObj.accName)){
                System.debug('checkMail :'+ddwrapObj.checkMail);
                ppComObj.Account__c=accntIdMap.get(ddwrapObj.accName);
                ppComObj.Description__c=description;
                ppComObj.Contact__c=ddwrapObj.cId;
                System.debug('isSendEmail :'+isSendEmail);
                if(isSendEmail){
                	ppComObj.isEmailChecked__c=true;
                }
                //ppComObj.CreatedById=userIdMap.get(ddwrapObj.cId);
                //ppComObj.LastModifiedById=userIdMap.get(ddwrapObj.cId);
                if(!Test.isRunningTest()){
                ppComObj.OwnerId=userIdMap.get(ddwrapObj.cId);
                }
                ppComList.add(ppComObj);
            }
        }
        
        System.debug('ppComList :'+ppComList);
        if(ppComList.size()>0){
            insert ppComList;
        }
        return ppComList;
    }
    
    @AuraEnabled
    public static Integer uploadFileAttachments(List<Poland_Price_Communication__c> ppComList,String fileName, String base64Data, String contentType, List<String> emailIds, Integer totalFileCount){
            
            System.debug('emailIds : '+emailIds);
            Integer totalFileCountInt=0;
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
            cv.IsMajorVersion = true;
            Insert cv; 
            System.debug('cv.ID  :'+cv.ID);
            if(totalFileCount!=0){
               totalFileCountInt=totalFileCount;
            }else{
               totalFileCount =0;
            }
            
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            
        List<ContentDocumentLink> cdlList = New List<ContentDocumentLink>();
            for(Integer i=0;i<ppComList.size();i++){
                System.debug('ParentId : '+ppComList[i].id);
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = ppComList[i].id;
                cdl.ContentDocumentId = conDocId;
                cdl.shareType = 'V';
                cdl.Visibility = 'AllUsers';
                cdlList.add(cdl);
                //Insert cdl;
            }
        if(cdlList.size() > 0){             //Updated by GRZ(Butesh Singla) for INC0479104 modified 30-05-2023
            insert cdlList;
        }
            System.debug('totalFileCount : '+totalFileCount);
            return totalFileCount;
        
    } 
    
    @AuraEnabled
    public static boolean sendEmailMethod(){
        PolandPriceCommunicationEmailBatch pcbatch=new PolandPriceCommunicationEmailBatch();
        Database.executeBatch(pcbatch, 1);
        return true;
    }
        
    public class DistributorDetailsWrapper{
        @AuraEnabled public String accId;
        @AuraEnabled public String accName;
        @AuraEnabled public String cId;
        @AuraEnabled public String cName;
        @AuraEnabled public String cEmail;
        @AuraEnabled public boolean checkMail;
        
        DistributorDetailsWrapper(){
            accId='';
            accName='';
            cId='';
            cName='';
            cEmail='';
            checkMail=true;
        }
    }
    
    public class ImageUploadWrapper{
        
    }

}