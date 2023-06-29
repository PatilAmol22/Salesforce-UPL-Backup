public without sharing class Grz_CaseDetailMexico {
	@AuraEnabled(cacheable=true)
    public static CaseDetailWrapper getCaseDetailList(String urlapex) {
        system.debug('Case ID : '+urlapex);
        Id id = UserInfo.getUserId(); // getting current user info
        System.debug('User Id : '+id);
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        system.debug('AccountId : '+accountId);
        List<Case> cases = new list<Case>();
        CaseDetailWrapper caseDetObj = new CaseDetailWrapper();
        
        if(accountId == NULL){
            caseDetObj.checkexternaluser = false;
        }
        else{
            caseDetObj.checkexternaluser = true;
        }
        String query = 'Select id,CaseNumber,tolabel(Type),Subject,Description,toLabel(Priority),CreatedBy.Name, Escalation_Level__c,Owner.name,Owner.FirstName, Owner.LastName,tolabel(Status),tolabel(Origin),createddate,lastmodifieddate,(SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComments where IsPublished = true order by createddate desc),(SELECT ContentDocumentId,ContentDocument.CreatedDate,ContentDocument.Title,ContentDocument.FileExtension,ContentDocument.CreatedBy.Name,LinkedEntityId FROM ContentDocumentLinks) from Case';
        query += ' WHERE Id = \'' + urlapex + '\'';
        
        system.debug('Query : '+query);
        List<Case> caseList = Database.query(query); 
        
        List<ProcessInstance> approvalOwnersList = [SELECT Id, Status, TargetObjectId, TargetObject.name, (SELECT Id, StepStatus, Actorid,Actor.name, Comments FROM StepsAndWorkitems where StepStatus = 'Pending') FROM ProcessInstance where TargetObjectId =: urlapex];
        //System.debug('approvalOwnersList'+approvalOwnersList[0].StepsAndWorkitems);
        
        List<Id> ownerIdList = new List<Id>();
        List<String> actorName = new List<String>();
        for(ProcessInstance pi : approvalOwnersList){
            for(ProcessInstanceHistory sw : pi.StepsAndWorkitems){
                ownerIdList.add(sw.Actorid);
            	actorName.add(sw.Actor.name);
            }            
        }
        
        List<Id> queueMembersId = new List<Id>();
        
        List<GroupMember> queueMembers = [SELECT id,UserOrGroupId FROM GroupMember WHERE GroupId IN (SELECT Id FROM Group WHERE type='Queue' and Name='Mexico Case Queue')];      
        
        for(GroupMember gm : queueMembers){
            queueMembersId.add(gm.UserOrGroupId);
        }
        List<String> caseOwnersList = new List<String>();
        List<User> OwnerUsersList = new List<User>();
        string caseOwners = '';
        if(ownerIdList.size() > 0){
            //OwnerUsersList = [SELECT Id, Name,Username, profile.name FROM User where Id in : ownerIdList];
            caseOwners = string.join(actorName,',');
        }else{
            OwnerUsersList = [SELECT Id, Name,Username, profile.name FROM User where Id in : queueMembersId];
            for(User us : OwnerUsersList){
            	caseOwnersList.add(us.Name);
        	}
			caseOwners = string.join(caseOwnersList,',');
            //caseOwners = Grz_CaseDetailClass.getCaseQueueOwners(queueMembersId);
        }
                
        
        system.debug('caseOwners---'+caseOwners);
        
        List<CaseComment> fiList = new List<CaseComment>();        
        system.debug('CaseList---'+caseList);
        system.debug('caseList[0].ContentDocumentLinks---'+caseList[0].ContentDocumentLinks);

        List<Id> CondocId = new List<Id>();
        for(ContentDocumentLink cdl: caseList[0].ContentDocumentLinks){
            CondocId.add(cdl.ContentDocumentId);
        }
        
        Map<id,String> contentDisMap = new  Map<id,String>();
        for(ContentDistribution cd : [SELECT Id, ContentVersionId, ContentDocumentId, RelatedRecordId,pdfdownloadurl,distributionpublicurl FROM ContentDistribution where contentdocumentid IN: CondocId]){
            contentDisMap.put(cd.ContentDocumentId, cd.distributionpublicurl);
        }

        List<CaseDetailWrapper> atachList = new List<CaseDetailWrapper>();

        for(ContentDocumentLink cdl1: caseList[0].ContentDocumentLinks){
            CaseDetailWrapper Obj = new CaseDetailWrapper();
            Obj.Id = cdl1.Id;
            String ext = cdl1.ContentDocument.FileExtension;
            if(ext==null){
                Obj.Filename = cdl1.ContentDocument.Title;
            }
            else{
                Obj.Filename = cdl1.ContentDocument.Title+'.'+ext;
            }            
            obj.CreatedbyName = cdl1.ContentDocument.CreatedBy.Name;
            Obj.publicLink = contentDisMap.get(cdl1.ContentDocumentId);
            atachList.add(Obj);
        }
        caseDetObj.attachPublicList = atachList;

        for(CaseComment cf:caseList[0].CaseComments){
            fiList.add(cf);
        }
        
        system.debug('---fiList---'+fiList);
        List<Id> idList=new List<Id>();
        List<User> urlMap=new List<User>();
        for(CaseComment fi:fiList){
            idList.add(fi.CreatedById);
        }
        for(User u:[Select Id,SmallPhotoUrl from User where Id IN :idList]){
            urlMap.add(u);
        }
        system.debug('---idList---'+idList);
        system.debug('---urlMap---'+urlMap);
        system.debug('---cases---'+cases);
        caseDetObj.caseList = caseList;
        caseDetObj.caseOwners = caseOwners;
        caseDetObj.urlMap=urlMap;
        return caseDetObj;
    }
    
    /*@AuraEnabled
    public static String saveCaseComment(String caseId,String commentData){
        Boolean isAddedCase = false;
        String commentPostedby;
        try{
            CaseComment ccm = new CaseComment(ParentId = caseId, CommentBody = commentData, IsPublished = true);
            insert ccm;
            List<CaseComment> cc = [SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComment where id =: ccm.id ];
            commentPostedby = cc[0].CreatedBy.Name;
            isAddedCase = true;
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');	
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            storeError.ErrorType__c = 'Cases';
            insert storeError;
        }
        return commentPostedby;
    }*/
    
    public class CaseDetailWrapper
    {
        @AuraEnabled 
        public List<Case> caseList {get;set;}       
        @AuraEnabled 
        public List<User> urlMap {get;set;} 
        @AuraEnabled 
        public Boolean checkexternaluser {get;set;} 
		@AuraEnabled 
        public String CreatedbyName {get;set;} 
        @AuraEnabled 
        public String caseOwners {get;set;}
        @AuraEnabled 
        public String Id {get;set;} 
        @AuraEnabled 
        public String Filename {get;set;} 
        @AuraEnabled 
        public String publicLink {get;set;} 
        @AuraEnabled 
        public List<CaseDetailWrapper> attachPublicList {get;set;} 
    }
}