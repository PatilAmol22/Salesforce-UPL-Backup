public class Grz_CaseDetailBrazilClass {
	@AuraEnabled(cacheable=true)
    public static CaseDetailWrapper getCaseDetailList(String urlapex)
    {
        system.debug('---urlapex---'+urlapex);
        Id id = UserInfo.getUserId(); // getting current user info
        System.debug('id'+id);
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        system.debug('accountId'+accountId);
        List<Case> cases = new list<Case>();
        CaseDetailWrapper caseDetObj = new CaseDetailWrapper();
        
        if(accountId == NULL){
            caseDetObj.checkexternaluser = false;
        }
        else{
            caseDetObj.checkexternaluser = true;
        }
        String query = 'Select id,CaseNumber,Type,Subject,Description,Priority,CreatedBy.Name, Escalation_Level__c,Owner.name,Owner.FirstName, Owner.LastName,Status,Origin,createddate,lastmodifieddate,(SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComments where IsPublished = true order by createddate desc),(SELECT ContentDocumentId,ContentDocument.CreatedDate,ContentDocument.Title,ContentDocument.FileExtension,ContentDocument.CreatedBy.Name,LinkedEntityId FROM ContentDocumentLinks) from Case';
        query += ' WHERE Id = \'' + urlapex + '\'';
        
        system.debug('---query123---'+query);
        List<Case> caseList = Database.query(query); 
        
        List<CaseComment> fiList=new List<CaseComment>();
        for(Case caseObj : caseList){           
            if(caseObj.Escalation_Level__c == 'Escalated L1'){
                caseDetObj.checkescalationstatus = true;
            }
            else{
                caseDetObj.checkescalationstatus = false;
            }
            cases.add(caseObj);            
        }
        system.debug('---caseList---'+caseList);
        system.debug('---caseList[0].ContentDocumentLinks---'+caseList[0].ContentDocumentLinks);

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
        caseDetObj.caseList = cases;
        caseDetObj.urlMap=urlMap;
        return caseDetObj;
    }
    
    public class CaseDetailWrapper
    {
        @AuraEnabled 
        public List<Case> caseList {get;set;} 
        @AuraEnabled 
        public List<User> urlMap {get;set;} 
        @AuraEnabled 
        public Boolean checkexternaluser {get;set;} 
        @AuraEnabled 
        public Boolean checkescalationstatus {get;set;} 
		@AuraEnabled 
        public String CreatedbyName {get;set;} 
        @AuraEnabled 
        public String Id {get;set;} 
        @AuraEnabled 
        public String Filename {get;set;} 
        @AuraEnabled 
        public String publicLink {get;set;} 
        @AuraEnabled 
        public List<CaseDetailWrapper> attachPublicList {get;set;} 
    }

    
    @AuraEnabled
    public static String saveCaseComment(String caseId,String commentData)
    {
        Boolean isAddedCase = false;
        String commentPostedby;
        try{
            CaseComment ccm = new CaseComment(ParentId = caseId, CommentBody = commentData, IsPublished = true);
            insert ccm;
            List<CaseComment> cc = [SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComment where id =: ccm.id ];
            if(!cc.isEmpty()){
                commentPostedby = cc[0].CreatedBy.Name;
            	isAddedCase = true;
            }  
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
    }
    
    @AuraEnabled
    public static Boolean CloseCase(String caseId,String closeReason)
    {
        Boolean isupdatedCase = false;
        try{
            List<Case> caseList = [Select id,CaseNumber,Status,AgentAnswer__c,Reason from Case where id =: caseId];
            if(!caseList.isEmpty()){
                caseList[0].Status = 'Fechado';
                caseList[0].Reason = 'Fechado pelo Distribuidor';
                caseList[0].AgentAnswer__c = closeReason;
                update caseList;
                isupdatedCase = true;
            }
        }
        catch (Exception e) {
            isupdatedCase = false;
            system.debug('Aashima inside exception'+e);
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
        return isupdatedCase;
    }
    @AuraEnabled
    public static Map<Id,String> getContentDistribution(List<Id> cvIdList)
    {   
        Map<Id,String> urlMap=new Map<Id,String>();
        try{
           
           for(ContentDistribution cd : [SELECT Id, ContentVersionId,distributionpublicurl FROM ContentDistribution where ContentVersionId IN: cvIdList]){
            urlMap.put(cd.ContentVersionId,cd.distributionpublicurl);
           }

        }
        catch (Exception e) {
            system.debug('Aashima inside exception'+e);
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
      return urlMap;
    }

    /*@AuraEnabled
    public static String escalatePortalCase(List<Id> caseIdList,String originOfEscalation){
    System.debug('caseIdList==>'+caseIdList);
    String caseNewOwner;
    List<Case> caseList=[Select Id,Type,CaseNumber from Case where Id In :caseIdList];
        System.debug('caseList==>'+caseList);
    	List<Case> casesToBeUpdated=new List<Case>();
        Map<String,String> emailUserMap = new Map<String,String>();
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
            emailUserMap.put(ppc.Name,ppc.Description__c);
        }
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        String baseURL=String.valueOf(Network.getLoginUrl(myCommunity.id));
        baseURL=baseURL.split('/login')[0];
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Escalated_Email_Template' limit 1];
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
        String fromAdressId = owa.id;
        for(Case c : caseList){
            String commenityurl = baseURL+'/s/casedetailpage?id=';
            c.Escalation_Level__c='Escalated L2';
            commenityurl += c.Id;
            List<String> emailList=new List<String>();
            if(c.Type=='Invoice'|| c.Type=='Dispatch'|| c.Type=='Payments & Receipts'|| c.Type=='Order Cancellation'|| c.Type=='Order Update'|| c.Type=='Product Leakage'){
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmail(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('LOGISTICS HO'),commenityurl,fromAdressId);
                    emailListFull.add(email);
                }
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                    Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmail(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('HO Finance'),commenityurl,fromAdressId);
                    emailListFull.add(email4);
                }
                c.CaseOwner__c='LOGISTICS HO;HO Finance';
                caseNewOwner = 'LOGISTICS HO, HO Finance';
                casesToBeUpdated.add(c);
            }
            else if(c.Type=='Credit Limit'|| c.Type=='Outstanding'|| c.Type=='Account Related'|| c.Type=='Other'){
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                    Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmail(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('HO Finance'),commenityurl,fromAdressId);
                    emailListFull.add(email4);
                }
                c.CaseOwner__c='HO Finance';
                caseNewOwner = 'HO Finance';
                casesToBeUpdated.add(c);
            }
            else if(c.Type=='Scheme'){
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                    Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmail(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('Sales excellence'),commenityurl,fromAdressId);
                        emailListFull.add(email5);
                }
                c.CaseOwner__c='Sales excellence';
                caseNewOwner = 'Sales excellence';
                casesToBeUpdated.add(c);
            }
            System.debug('casesToBeUpdated==>'+casesToBeUpdated);
           
           
        }
        try{
            if(emailListFull.size() > 0 && !Test.isRunningTest()){
                Messaging.sendEmail(emailListFull);
            }
            if(!casesToBeUpdated.isEmpty()){
            update casesToBeUpdated;
            }
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.ErrorType__c = 'Cases';
            insert storeError;
            caseNewOwner = null;
        }

        return caseNewOwner;
    }*/
    @AuraEnabled
    public static String checkCaseStatus(String caseId)
    {   
        String statusVal='';
        try{
            List<Case> c=[Select Id, Status from case where id = :caseId];     
            if(!c.isEmpty()){
                statusVal=c[0].Status;
            }
        }
        catch (Exception e) {
            
            //throw new AuraHandledException(e.getMessage());
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
        return statusVal;
    }
    @AuraEnabled
    public static String contentSizePublic(String cid,String caseId) {
        if(checkCaseStatus(caseId)!='Fechado'){
            system.debug('cid---'+cid);
            List<ContentDocument> Doc = [select id,contentsize from ContentDocument where id =: cid limit 1];
            if(!Doc.isEmpty()){
                integer size = Doc[0].contentsize;
                if(size > 20971520){
                    system.debug('size value==='+size);
                    Delete Doc[0];
                    return 'ERROR';
                }else{
                    system.debug('size value==='+size);
                    return 'SUCCESS';
                }
            }else{
                return 'ERRORClosed';
            }
        }
        else{
            return 'ERRORClosed';
        }
        
    }
}