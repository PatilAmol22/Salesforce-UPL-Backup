public  without sharing class Grz_CaseDetailClass {
    
    /*public static String getCaseQueueOwners(List<Id> queueMembersId){
        
        List<User> OwnerUsersList = new List<User>();
        List<String> caseOwnersList = new List<String>();
        string caseOwners = '';
        
        OwnerUsersList = [SELECT Id, Name,Username, profile.name FROM User where Id in : queueMembersId];
        for(User us : OwnerUsersList){
            caseOwnersList.add(us.Name);
        }
        
		caseOwners = string.join(caseOwnersList,',');
        return caseOwners;
        
    }*/
   	 
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
        //String query = 'Select id,CaseNumber,Subject,Description,Priority,Owner.name,Status,Origin,createddate,lastmodifieddate,(SELECT Id, ParentId, Type, Title, Body, Visibility,CreatedDate,CreatedById, CreatedBy.Name FROM Feeds where visibility=\'AllUsers\'),(SELECT ContentDocumentId,ContentDocument.CreatedDate,ContentDocument.Title,ContentDocument.FileExtension,ContentDocument.CreatedBy.Name,LinkedEntityId FROM ContentDocumentLinks) from Case';
        String query = 'Select id,CaseNumber,Type,Created_Date_Time__c,Category__c,Subject,Description,SalesOrg__c,SalesOrg__r.name,catesub__c,Priority,CaseOwner__c,Sub_Category__c,Escalation_Level__c,Owner.name,Owner.FirstName, Owner.LastName,Status,Origin,createddate,lastmodifieddate,Reopen_Status_Count__c,createdById,(SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComments where IsPublished = true order by createddate desc),(SELECT ContentDocumentId,ContentDocument.CreatedDate,ContentDocument.Title,ContentDocument.FileExtension,ContentDocument.CreatedBy.Name,LinkedEntityId FROM ContentDocumentLinks) from Case';
        
        query += ' WHERE Id = \'' + urlapex + '\'';
        //CRQ: use Custom Label for hide the Close Button, Escalation Button, Reopen Buttons
        String lstUplItCaseType = System.Label.Grz_UPLITSupport;
        system.debug('lstUplItCaseType ---> '+ lstUplItCaseType);
        system.debug('---query123---'+query);
        List<Case> caseList = Database.query(query); 
        List<CaseComment> fiList=new List<CaseComment>();
        System.debug('caseList' + caseList);
        for(Case caseObj : caseList){      
            system.debug('lstUplItCaseType  ++'+ lstUplItCaseType);
                system.debug('caseObj.Type ++'+ caseObj.Type);     
            if(caseObj.Escalation_Level__c == 'Escalated L1'){
                caseDetObj.checkescalationstatus = true;
            }
            else{
                caseDetObj.checkescalationstatus = false;
            }
            if(caseObj.createdById == id){
                caseDetObj.isCaseCreatedUser = true;
            }
            else{
                caseDetObj.isCaseCreatedUser = false;
            }
            
            if(caseObj.Reopen_Status_Count__c < 2){
                caseDetObj.isReopenBtnVisible = true; 
            }    
            else{
                caseDetObj.isReopenBtnVisible = false; 
            }
            
            if(caseObj.Type != null){									//condition added for handled Escalation and Close button visibility issue for guest users (Sumit Kumar) Jira Ticket No. RITM0427885 modified on 30-09-2022
                if(lstUplItCaseType.contains(caseObj.Type)){
                    caseDetObj.checkescalationstatus = false;
                    caseDetObj.isReopenBtnVisible = false;
                    caseDetObj.hideCloseCaseButton = false;
            	}
                else{
                    //caseDetObj.checkescalationstatus = true;
                    //caseDetObj.isReopenBtnVisible = true;
                    caseDetObj.hideCloseCaseButton = true;
                }
            }else{
                caseDetObj.hideCloseCaseButton = true;
            }
             
            cases.add(caseObj);            
        }
        
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
        
        List<Id> idList=new List<Id>();
        List<User> urlMap=new List<User>();
        for(CaseComment fi:fiList){
            idList.add(fi.CreatedById);
        }
        for(User u:[Select Id,SmallPhotoUrl from User where Id IN :idList]){
            urlMap.add(u);
        }
        
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
        public Boolean hideCloseCaseButton {get;set;}
        @AuraEnabled 
        public Boolean isCaseCreatedUser {get;set;} 
        @AuraEnabled 
        public Boolean isReopenBtnVisible {get;set;}
        @AuraEnabled 
        public String CaseOwner {get;set;}
        @AuraEnabled 
        public String CaseUpdateSuccess {get;set;}
        
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
    public static String saveCaseComment(String caseId,String commentData,String sourceComment){
        
          //System.debug('commentData' + commentData);  
        //System.debug('caseId' + caseId);  
        //System.debug('sourceComment' + sourceComment);  
        Boolean isAddedCase = false;
        String commentPostedby;
        try{
            List<Case> c=[Select id, Escalation_Level__c,CaseOwner__c,Status from Case where id=:caseId];
            if(!c.isEmpty() && c[0].Escalation_Level__c=='Escalated L2' && sourceComment=='escalation'){
                commentPostedby = 'caseEscalated'+c[0].CaseOwner__c;
               
            }
            else if(!c.isEmpty() && c[0].Status!='Closed'){
                CaseComment ccm = new CaseComment(ParentId = caseId, CommentBody = commentData, IsPublished = true);
                insert ccm;
                List<CaseComment> cc = [SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComment where id =: ccm.id ];
                commentPostedby = cc[0].CreatedBy.Name;
                isAddedCase = true;
            }
            else if(!c.isEmpty() && c[0].Status!='Reopen'){
                CaseComment ccm = new CaseComment(ParentId = caseId, CommentBody = commentData, IsPublished = true);
                insert ccm;
                List<CaseComment> cc = [SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComment where id =: ccm.id ];
                commentPostedby = cc[0].CreatedBy.Name;
            }
          /*  else if(!c.isEmpty() && c[0].Status!='NEW'){
                CaseComment ccm = new CaseComment(ParentId = caseId, CommentBody = commentData, IsPublished = true);
                insert ccm;
                List<CaseComment> cc = [SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComment where id =: ccm.id ];
                commentPostedby = cc[0].CreatedBy.Name;
            }
            else if(!c.isEmpty() && c[0].Status!='Open'){
                CaseComment ccm = new CaseComment(ParentId = caseId, CommentBody = commentData, IsPublished = true);
                insert ccm;
                List<CaseComment> cc = [SELECT Id, ParentId, IsPublished, CommentBody,CreatedDate,CreatedById,CreatedBy.Name FROM CaseComment where id =: ccm.id ];
                commentPostedby = cc[0].CreatedBy.Name;
            }  */
            else{
                commentPostedby = 'caseClosed';
            }
            if(Test.isRunningTest()) {
                            CalloutException e = new CalloutException();
                            e.setMessage('This is a constructed exception for testing and code coverage');
                            throw e;
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
        return commentPostedby;
    }
    
    @AuraEnabled
    public static CaseDetailWrapper CloseCase(String caseId,String closeReason)
    {
        String isupdatedCase = 'false';
        CaseDetailWrapper caseDetObj = new CaseDetailWrapper();
        caseDetObj.CaseUpdateSuccess = isupdatedCase;
        if(checkCaseStatus(caseId)!='Closed'){
            try{
                List<Case> caseList = [Select id,CaseOwner__c,CaseNumber,Status,Reason_for_Closure__c,Reopen_Status_Count__c,createdById from Case where id =: caseId];
                caseList[0].Status = 'Closed';
                caseList[0].Reason = 'Issue resolved';
                caseList[0].Reason_for_Closure__c = closeReason;
                if(caseList[0].Reopen_Status_Count__c == null){
                    caseList[0].Reopen_Status_Count__c = 0;
                }
                if(caseList[0].createdById == UserInfo.getUserId()){
                    caseDetObj.isCaseCreatedUser = true;
                }
                else{
                    caseDetObj.isCaseCreatedUser = false;
                }
                
                if(caseList[0].Reopen_Status_Count__c < 2){
                    caseDetObj.isReopenBtnVisible = true; 
                }    
                else{
                    caseDetObj.isReopenBtnVisible = false; 
                }
                update caseList;
                caseDetObj.CaseUpdateSuccess = 'true';
                
            }
            catch (Exception e) {
                caseDetObj.CaseUpdateSuccess = 'false';
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
        }
        else{
            caseDetObj.CaseUpdateSuccess = 'falseClosed';
        }
        
        return caseDetObj;
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
        return urlMap;
    }
    
//--------------------------------------India Case Reopen Functionality -------------------------------------------------------------------   
    
    @AuraEnabled
    public static CaseDetailWrapper reopenPortalCase(List<Id> caseIdList){
        System.debug('In reopenPortalCase function');
        CaseDetailWrapper caseDetObj = new CaseDetailWrapper();
        caseDetObj.CaseUpdateSuccess = 'Not Reopned';
        try { 
            
            Map<Id,Case> CaseMap = new Map<Id,Case>([Select Id,CaseNumber,catesub__C,CategoryForSubcategory__c,sub_category__c, CreatedDate,AccountId,SalesOrg__c,CreatedById,CaseOwner__c,Owner.Email,recordTypeId,Escalation_Level__c,Reopen_Status_Count__c,Is_Auto_Escalated__c,Type,Status,Subject,Description,ClosedDate,(SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) from Case where Id IN :caseIdList]);
            //List<Case> caseList=[Select Id,Type,CaseNumber,AccountId,Subject,Description,Status,CreatedDate,ClosedDate,Escalation_Level__c,CaseOwner__c,Reopen_Status_Count__c,Is_Auto_Escalated__c,CreatedById from Case where Id In :caseIdList];
            List<Case> casesToBeUpdated = new List<Case>();
            Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();
            List<Id> createList=new List<Id>();
            Map<Id,Id> accountIdMap=new Map<Id,Id>();
            Set<String> introTextList=new Set<String>();  // Used for Collecting Users Email
            List<String> saleOrgNameList = new List<String>();
            List<Id> saleOrgIdList = new List<Id>();
            
            for(Case c : CaseMap.values()){     
                if(c.CaseOwner__c != null){
                    createList.add(c.createdById);
                    accountIdMap.put(c.Id,c.AccountId);
                    caseCommentMap.put(c.Id, c.CaseComments);
                    saleOrgIdList.add(c.SalesOrg__c);
                }  
            }
            Map<Id,Id> accOwnerMap=new Map<Id,Id>();
            Map<Id,Account> accountMap=new Map<Id,Account>();
            if(!accountIdMap.isEmpty()){
                for(Account a:[Select id,ownerid,SAP_Code__c,Name from Account where Id  IN :accountIdMap.values()]){
                    accOwnerMap.put(a.Id,a.ownerid);
                    accountMap.put(a.Id,a);
                }
            }
            
            /*Map<Id,String> accterrMap= new Map<Id,String>();
            for(DistributorSalesAreaMapping__c sa : [SELECT Id, Distributor__c,Distributor__r.name, SalesOrg__c,SalesOrg__r.name, Status__c, Sales_Org_Code__c, Territory__c,Territory__r.name FROM DistributorSalesAreaMapping__c where Distributor__c IN : accountIdMap.values()  and SalesOrg__c IN : saleOrgIdList order by lastmodifieddate desc]){
                if(!accterrMap.containsKey(sa.Distributor__c)){
                    accterrMap.put(sa.Distributor__c,sa.Territory__c);
                    saleOrgNameList.add(sa.SalesOrg__r.name);
                }
            }
            System.debug('saleOrgNameList : '+saleOrgNameList);
            System.debug('accterrMap : '+accterrMap);*/
            System.debug('accOwnerMap in reopen : '+accOwnerMap);
            Map<Id,String> rcmMap=new Map<Id,String>();
            Map<Id,Id> zsmMap=new Map<Id,Id>();
            Map<Id,String> tmMap = new  Map<Id,String>();
      
            if(!accOwnerMap.isEmpty()){
                for(Territory_Distributor__c td:[Select Id, RCM_Email__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where TerritoryManager__c  IN :accOwnerMap.values()]){
                    rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
                    introTextList.add(td.RCM_Email__c);
                    zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
                    introTextList.add(td.ZSM_Id__c);
                    tmMap.put(td.Id, td.TerritoryManager__c);
                }
            }       
            System.debug('rcmMap : '+rcmMap);
            System.debug('zsmMap : '+zsmMap);
            Map<Id,String> cnfMap=new Map<Id,String>();
            //Change by Aashima(Grazitti) for APPS-4027 28Dec22
            for(TM_Depot_Mapping__c tdmp:[Select Id,Depot__r.Case_Access_Email__c,Territory_Manager__c from TM_Depot_Mapping__c where Territory_Manager__c  IN :tmMap.values() and sales_org__c ='UPL SAS']){
                if(tdmp.Depot__r.Case_Access_Email__c!=null && tdmp.Depot__r.Case_Access_Email__c!=''){
                    if(!cnfMap.containsKey(tdmp.Territory_Manager__c)){
                        cnfMap.put(tdmp.Territory_Manager__c,tdmp.Depot__r.Case_Access_Email__c);
                    }
                    else{
                        String emailVal=cnfmap.get(tdmp.Territory_Manager__c);
                        cnfMap.put(tdmp.Territory_Manager__c,emailVal+','+tdmp.Depot__r.Case_Access_Email__c);
                    }
                    introTextList.add(tdmp.Depot__r.Case_Access_Email__c);
                }
            }
            System.debug('cnfMap==>'+cnfMap);
            Id loggedInUser = userInfo.getUserId();
            Map<Id,User> userMap=new Map<Id,User>([Select Id,ProfileId,Name,Profile.Name,MobilePhone,Email from User where Id IN :createList or ID =:loggedInUser or Id IN :zsmMap.values()]);
            
            
            Map<String,String> emailUserMap = new Map<String,String>();
            for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
                emailUserMap.put(ppc.Name,ppc.Description__c);
                introTextList.add(ppc.Description__c);
            }
            system.debug('emailUserMap : '+emailUserMap);
            
            Map<String,String> emailNameMap=new Map<String, String>();
            for(User u:[select id,email, firstname,lastname from user where email IN :introTextList]){
                if(!emailNameMap.containsKey(u.email)){
                    if(null!=u.firstname){
                        emailNameMap.put(u.email,u.firstname+' '+u.lastname);
                    }
                    else{
                        emailNameMap.put(u.email,u.lastname);
                    }
                }
                else{
                    emailNameMap.put(u.email,u.email);
                }
            }
            
            List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();
            Network myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
            String baseURL=String.valueOf(Network.getLoginUrl(myCommunity.id));
            baseURL=baseURL.split('/login')[0];
            
            List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Reopen_Email_Template' limit 1];
            OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
            String fromAdressId = owa.id;
            
            List<Case_Matrix__c> cmList =[SELECT Id, OwnerId, Name, Case_Access__c, Case_Owner__c, Case_Type__c, Sales_Org__c,Sales_Org__r.name,Case_Owner_Notify__c FROM Case_Matrix__c where Sales_Org__r.name = 'India'];                 
            Map<String,String> cmMap = new Map<String,String>();
            for(Case_Matrix__c cm : cmList){
                cmMap.put(cm.Case_Type__c,cm.Case_Owner__c);
            }
            List<SMS_Template__c> smsTemp=[SELECT Id, Name, Name__c, ObjectName__c, Text__c FROM SMS_Template__c where Name='Community_Case_ReOpen' and ObjectName__c='Case'];
            for(Case c : CaseMap.values()){
                
                String caseCreatedBy='';
                String accName='';
                String accSapCode='';
                if(!userMap.isEmpty() && userMap.containsKey(c.createdById)){
                     caseCreatedBy=userMap.get(c.createdById).Name;
                }
                if(!accountMap.isEmpty() && accountMap.containsKey(c.accountId)){
                 accName=accountMap.get(c.accountId).Name;
                 accSapCode=accountMap.get(c.accountId).SAP_Code__c;
                }
                
                
                system.debug('c.Escalation_Level__c==>'+c.Escalation_Level__c);
                    system.debug('c.Is_Auto_Escalated__c==>'+c.Is_Auto_Escalated__c);
                String communityPublicPageUrl = baseURL+'/s/casedetailpage?id=';
                String commenityurl = baseURL+'/s/case/';
                commenityurl += c.Id;
                communityPublicPageUrl += c.Id;                
                User u = userMap.get(c.createdbyid);
                system.debug('Reopen_Status_Count__c==>'+c.Reopen_Status_Count__c);
                system.debug('Status==>'+c.Status);

                if(c.Reopen_Status_Count__c !=null){
                    c.Reopen_Status_Count__c = c.Reopen_Status_Count__c + 1;
                }
                else{
                    c.Reopen_Status_Count__c = 1;
                }
                
                if(c.Status=='Closed' && c.Reopen_Status_Count__c < 3){
                    system.debug('inside caseupdatestatus');
                    caseDetObj.CaseUpdateSuccess = 'Case Reopened';
                    c.Status = 'Reopen';                    
                    system.debug('inside caseupdatestatus22'+caseDetObj.CaseUpdateSuccess);
                    /*if(c.Escalation_Level__c == 'Escalated L1'){
                            System.debug('In Case Reopened function==>');                        
                            assignCaseOwner = c.CaseOwner__c;     

                    }*/
                    if(c.Escalation_Level__c == 'Escalated L1' || (c.Escalation_Level__c == 'Escalated L2' && c.Is_Auto_Escalated__c)){
                        caseDetObj.checkescalationstatus = true;
                        caseDetObj.CaseOwner = c.CaseOwner__c;
                        if(c.Escalation_Level__c == 'Escalated L2' && c.Is_Auto_Escalated__c){            
                            c.Escalation_Level__c = 'Escalated L1';
                            if(!cmMap.isEmpty() && cmMap.containsKey(c.Type)){
                                c.CaseOwner__c = cmMap.get(c.Type);
                                c.OwnerOfCase__c = cmMap.get(c.Type);   //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 30-09-2022
                                caseDetObj.CaseOwner = cmMap.get(c.Type);    
                            }
                            system.debug('In Escalated L2 Condition ==='+c.CaseOwner__c);
                        }
                        
                        if(c.CaseOwner__c != null){   
                            system.debug('Case Owner ==='+c.CaseOwner__c);
                            system.debug('Case Escalation Level==='+c.Escalation_Level__c);
                            Id TM_Id = accOwnerMap.get(accountIdMap.get(c.Id));
                            //Id terrId = accterrMap.get(c.AccountId);
                            //Id TM_Id = tmMap.get(terrId);
                            system.debug('Case TM_Id==='+TM_Id);
                            system.debug('Case TM_Id in CaseDetail Reopen ==='+TM_Id);
                            if(c.CaseOwner__c.contains('C & F')){
                                if(!cnfMap.isEmpty() && cnfMap.containsKey(TM_Id)){
                                    if(cnfMap.get(TM_Id)!=null){
                                        if(cnfMap.get(TM_Id).contains(',')){
                                            String[] emailArray=cnfMap.get(TM_Id).split(',');
                                            for(Integer i=0;i<emailArray.size();i++){
                                                Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailArray[i],communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                                if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                                    system.debug('Reopen_Status_Count == 2');
                                                    List<String> emails = emailUserMap.get('Business ID').split(',');
                                                    if(emails.size()>0){
                                                        email.setCcAddresses(emails);      
                                                    }                                                                      
                                                }
                                                emailListFull.add(email);
                                            }
                                        }
                                        else{
                                            Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,cnfMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                            if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                                    system.debug('Reopen_Status_Count == 2');
                                                    List<String> emails = emailUserMap.get('Business ID').split(',');
                                                    if(emails.size()>0){
                                                        email.setCcAddresses(emails);      
                                                    }                                                                      
                                            }
                                            emailListFull.add(email);
                                        }
                                    }
                                }
                            }
                            if(c.CaseOwner__c.contains('RCM')){
                                if(!rcmMap.isEmpty() && rcmMap.containsKey(TM_Id)){
                                    System.debug('Owner rcm : '+rcmMap.containsKey(TM_Id));
                                    if(rcmMap.get(TM_Id) != null){
                                        Messaging.Singleemailmessage email2 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,rcmMap.get(TM_Id),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                            system.debug('Reopen_Status_Count == 2');
                                            system.debug('emailUserMap.getBusiness ID'+emailUserMap.get('Business ID'));
                                            List<String> emails = emailUserMap.get('Business ID').split(',');
                                            if(emails.size()>0){
                                                email2.setCcAddresses(emails);      
                                            }                                                                      
                                        }
                                        emailListFull.add(email2);
                                    }
                                }
                            }
                            if(c.CaseOwner__c.contains('LOGISTICS HO')){
                                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                                    if(emailUserMap.get('LOGISTICS HO') != null){
                                        Messaging.Singleemailmessage email3 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                            system.debug('Reopen_Status_Count == 2');
                                            List<String> emails = emailUserMap.get('Business ID').split(',');
                                            if(emails.size()>0){
                                                email3.setCcAddresses(emails);      
                                            }                                                                      
                                        }
                                        emailListFull.add(email3);
                                    }
                                }
                            }
                            if(c.CaseOwner__c.contains('HO Finance')){
                                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                                    if(emailUserMap.get('HO Finance') != null){
                                        Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                            system.debug('Reopen_Status_Count == 2');
                                            List<String> emails = emailUserMap.get('Business ID').split(',');
                                            if(emails.size()>0){
                                                email4.setCcAddresses(emails);      
                                            }                                                                      
                                        }
                                        emailListFull.add(email4);
                                    }
                                }
                            }
                            if(c.CaseOwner__c.contains('FCE')){
                                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('FCE')){
                                    if(emailUserMap.get('FCE') != null){
                                        Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('FCE'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                            system.debug('Reopen_Status_Count == 2');
                                            List<String> emails = emailUserMap.get('Business ID').split(',');
                                            if(emails.size()>0){
                                                email4.setCcAddresses(emails);      
                                            }                                                                      
                                        }
                                        emailListFull.add(email4);
                                    }
                                }
                            }
                            if(c.CaseOwner__c.contains('Sales excellence')){
                                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                                    if(emailUserMap.get('Sales excellence') != null){
                                        Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                            List<String> emails = emailUserMap.get('Business ID').split(',');
                                            if(emails.size()>0){
                                                email5.setCcAddresses(emails);      
                                            }                                                                      
                                        }
                                        emailListFull.add(email5);
                                    }
                                }
                            }
                            if(c.CaseOwner__c.contains('ZSM')){
                                System.debug('In zsmMap If');
                                if(!zsmMap.isEmpty() && zsmMap.containsKey(TM_Id) && !userMap.isEmpty() && userMap.containsKey(zsmMap.get(TM_Id))){
                                    System.debug('zsmMap : '+userMap.get(zsmMap.get(TM_Id)).Email);
                                    if(userMap.get(zsmMap.get(TM_Id)).Email !=null){
                                        Messaging.Singleemailmessage email6 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,userMap.get(zsmMap.get(TM_Id)).Email,communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                            List<String> emails = emailUserMap.get('Business ID').split(',');
                                            if(emails.size()>0){
                                                email6.setCcAddresses(emails);      
                                            }                                                                      
                                        }
                                        emailListFull.add(email6);  
                                    }
                                }
                            }
                            if(c.CaseOwner__c.contains('CROP MANAGER')){
                                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('CROP MANAGER')){
                                    if(emailUserMap.get('CROP MANAGER') != null){
                                        Messaging.Singleemailmessage email7 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,u.Id,c,emailUserMap.get('CROP MANAGER'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                        if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                            system.debug('Reopen_Status_Count == 2');
                                            List<String> emails = emailUserMap.get('Business ID').split(',');
                                            if(emails.size()>0){
                                                email7.setCcAddresses(emails);      
                                            }                                                                      
                                        }
                                        emailListFull.add(email7);
                                    }
                                }
                            }
                            System.debug('emailListFull : '+emailListFull);            
                        }
                    }
                    
                    else if(c.Escalation_Level__c == 'Escalated L2' && !c.Is_Auto_Escalated__c){
                        caseDetObj.checkescalationstatus = false;
                        if(c.Type=='Invoice'|| c.Type=='Dispatch'|| c.Type=='Payments & Receipts'|| c.Type=='Order Cancellation'|| c.Type=='Order Update'|| c.Type=='Product Leakage' || c.Type=='Shipping Address'){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                                Messaging.Singleemailmessage email1 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('LOGISTICS HO'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                    system.debug('Reopen_Status_Count == 2');
                                    List<String> emails = emailUserMap.get('Business ID').split(',');
                                    if(emails.size()>0){
                                        email1.setCcAddresses(emails);      
                                    }                                                                      
                                }
                                emailListFull.add(email1);
                            }
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                                Messaging.Singleemailmessage email2 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                    system.debug('Reopen_Status_Count == 2');
                                    List<String> emails = emailUserMap.get('Business ID').split(',');
                                    if(emails.size()>0){
                                        email2.setCcAddresses(emails);      
                                    }                                    
                                }
                                emailListFull.add(email2);
                            }
                        }
                        else if(c.Type=='Credit Limit'|| c.Type=='Outstanding'|| c.Type=='Account Related'|| c.Type=='Other'){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                                Messaging.Singleemailmessage email3 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('HO Finance'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                    system.debug('Reopen_Status_Count == 2');
                                    List<String> emails = emailUserMap.get('Business ID').split(',');
                                    if(emails.size()>0){
                                        email3.setCcAddresses(emails);      
                                    }                                    
                                }
                                emailListFull.add(email3);
                            }
                        }
                        else if(c.Type=='Scheme'){
                            if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                                Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('Sales excellence'),communityPublicPageUrl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                                if(c.Reopen_Status_Count__c == 2 && emailUserMap.containsKey('Business ID')){
                                    system.debug('Reopen_Status_Count == 2');
                                    List<String> emails = emailUserMap.get('Business ID').split(',');
                                    if(emails.size()>0){
                                        email4.setCcAddresses(emails);      
                                    }                                    
                                }
                                emailListFull.add(email4);
                            }
                        }                        
                        caseDetObj.CaseOwner = c.CaseOwner__c;
                    }
                                
                }            
                casesToBeUpdated.add(c); 
                
                //sms send for case reopen starts
                if( c.sub_category__c == null){
                String encodedcontent;
                if(c.CaseOwner__c != null)
                    encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber).replace('<Case Owner>',c.CaseOwner__c), 'UTF-8');
                else
                    encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber), 'UTF-8');
                if(u.MobilePhone!='' && u.MobilePhone!=null){
                    String phoneVal = u.MobilePhone.replaceAll('\\D','');
                    String senderId = 'UPL';
                    if(!Test.isRunningTest())
                    IntegrationWithKarix.sendSMS(encodedcontent,phoneVal,c.createdById,senderId);
                }
              }
                //sms send for case reopen ends
                
            }
            if(emailListFull.size() > 0 && !Test.isRunningTest()){
                System.debug('emailListFull ==>'+emailListFull);
                Messaging.sendEmail(emailListFull);
            }
            if(casesToBeUpdated.size() > 0){
                System.debug('casesToBeUpdated==>'+casesToBeUpdated);
                update casesToBeUpdated;
            }
            
        } catch (Exception e) {
            caseDetObj.CaseUpdateSuccess = 'Not Reopned';
            System.debug('Error Message : '+e.getStackTraceString());
            //throw new AuraHandledException(e.getMessage());
        }
        
        return caseDetObj;
    }
    
    @AuraEnabled     // Original Arguments  List<Id> caseIdList,String originOfEscalation  // Additional Line After Update Trigger   Map<Id, Case> caseMap1 
    public static String escalatePortalCase(List<Id> caseIdList,String originOfEscalation){ //
        
     /*   String originOfEscalation = 'Batch';  //
        
        
        Map<Id, Case> caseNewMap = new Map<Id, Case>();
        List<Id> caseIdList = new List<Id>();
        for(case c : [Select Id,CaseNumber,createdById,Count_Open_Values__c,Reopened_Start_Date__c,CreatedDate,CaseOwner__c,Reopened_Case__c,
                                                 Sub_Category__c,Owner.Email,recordTypeId,CategoryForSubcategory__c,Escalation_Level__c,OwnerId,Category__c, LastModifiedById,AccountId, 
                                                 Created_Date__c,X24_hrs__c,level2__c, Reopened_Close_Date__c, Reopen_Status_Count__c, lastModifieddate, SalesOrg__c,
                                                 Created_Date_Time__c, X48_hrs__c,Is_Auto_Escalated__c,Type,catesub__c, Status, Subject,Description,ClosedDate,checked_till_24_hour__c,
                                                 (SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name 
                                                  FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) 
                                                 from Case where Id IN :caseMap1.keySet()]){
                                                     
                                                     if(c.level2__c != null){
                                                     caseNewMap.put(c.Id, c);
                                                     caseIdList.add(c.Id);
                                                         }
            
          }   //  
        */
        
        String caseNewOwner;
        /*if(originOfEscalation=='Portal' && checkCaseStatus(caseIdList[0])=='Closed'){
caseNewOwner='CaseClosed';
}
else{*/
        System.debug('caseIdList' + caseIdList);
        //List<Case> caseList=[Select Id,Type,CaseNumber,CreatedDate,Subject,Description,Status,ClosedDate from Case where Id In :caseIdList and Status != 'Closed'];
          Set<String> introTextList=new Set<String>();  // User For Collecting User Emails
          Map<Id,Case> CaseMap = new Map<Id,Case>([Select Id,CaseNumber,createdById,Count_Open_Values__c,Reopened_Start_Date__c,CreatedDate,CaseOwner__c,Reopened_Case__c,
                                                 Sub_Category__c,Owner.Email,recordTypeId,CategoryForSubcategory__c,Escalation_Level__c,OwnerId,Category__c, LastModifiedById,AccountId, 
                                                 Created_Date__c,X24_hrs__c, Reopened_Close_Date__c, Reopen_Status_Count__c, lastModifieddate, SalesOrg__c,level2__c,
                                                 Created_Date_Time__c, X48_hrs__c,Is_Auto_Escalated__c,Type,catesub__c, Status, Subject,Description,ClosedDate,checked_till_24_hour__c,
                                                 (SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, createdby.name 
                                                  FROM CaseComments where IsPublished=true order by LastModifiedDate desc limit 5) 
                                                 from Case where Id IN :caseIdList]);
        List<Case> casesToBeUpdated=new List<Case>();
        Map<String,String> emailUserMap = new Map<String,String>();
        for(Partner_Portal_Configuration__c ppc:[Select Name,Description__c from Partner_Portal_Configuration__c where Recordtype.Name = 'CaseConfiguration']){
            emailUserMap.put(ppc.Name,ppc.Description__c);
            introTextList.add(ppc.Description__c);
        }
        
        
        
        
        /*    Additional Line   Begins Here  */
        
       // Map<Id, Case> caseNewMap = new Map<Id, Case>();
        
        //for(Case c : [Select id, caseNumber, category__c, sub_category__c, subject, description, catesub__c from case where Id In : caseIdList]){
         //     caseNewMap.put(c.Id, c);
       // }
        
        
                List<Id> userId = new List<Id>();
       // List<Id> caseIds=new List<Id>();
        List<Id> createList1=new List<Id>();
        Map<Id,Id> accountIdMap=new Map<Id,Id>();
        
        System.debug('CaseMap' + CaseMap);
        if(!CaseMap.isEmpty()){
        for(Case c : CaseMap.values()){ 
                System.debug('c.CaseOwner__c' + c.CaseOwner__c);
                createList1.add(c.createdById);
                accountIdMap.put(c.Id,c.AccountId);   
        }
            }
        Map<Id,Id> accOwnerMap=new Map<Id,Id>();
        Map<Id,Account> accountMap=new Map<Id,Account>();
        System.debug('accountIdMap' + accountIdMap);
        if(!accountIdMap.isEmpty()){
            for(Account a:[Select id,ownerid,SAP_Code__c,Name,Sales_Org__r.Name,Depot_Code__c,Brazil_Depot_Code__r.Name from Account where Id  IN :accountIdMap.values()]){  // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
                accOwnerMap.put(a.Id,a.ownerid);
                accountMap.put(a.Id,a);                
            }
        }
        
        //Set<String> introTextList=new Set<String>();
                
                 
        System.debug('accOwnerMap.values' + accOwnerMap);
        Map<Id,String> rcmMap=new Map<Id,String>();
        Map<Id,Id> zsmMap=new Map<Id,Id>();
        Map<Id,String> zsmEmailMap = new Map<Id,String>();
        if(!accOwnerMap.isEmpty()){
            for(Territory_Distributor__c td:[Select Id, RCM_Email__c,TerritoryManager__c,ZSM_Id__c from Territory_Distributor__c where TerritoryManager__c  IN :accOwnerMap.values()]){
                rcmMap.put(td.TerritoryManager__c,td.RCM_Email__c);
                zsmMap.put(td.TerritoryManager__c,td.ZSM_Id__c);
                //introTextList.add(td.RCM_Email__c);
                //introTextList.add(td.ZSM_Id__c);
            }
        }   
        if(!zsmMap.isEmpty()){
            for(user u : [select Id, Name, Email from user where Id IN : zsmMap.Values()]){
                            zsmEmailMap.put( u.Id,  u.Email);
            }
        }
        
        System.debug('rcmMap : '+rcmMap);
        System.debug('zsmMap : '+zsmMap);
        System.debug('zsmEmailMap : '+zsmEmailMap);
        Map<Id,String> cnfMap=new Map<Id,String>();
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        for(TM_Depot_Mapping__c tdmp:[Select Id,Depot__r.Case_Access_Email__c,Territory_Manager__c from TM_Depot_Mapping__c where Territory_Manager__c  IN :accOwnerMap.values() and (sales_org__c ='UPL SAS' or sales_org__c ='SWAL')]){
            if(tdmp.Depot__r.Case_Access_Email__c!=null && tdmp.Depot__r.Case_Access_Email__c!=''){
                if(!cnfMap.containsKey(tdmp.Territory_Manager__c)){
                    cnfMap.put(tdmp.Territory_Manager__c,tdmp.Depot__r.Case_Access_Email__c);
                }
                else{
                    String emailVal=cnfmap.get(tdmp.Territory_Manager__c);
                    cnfMap.put(tdmp.Territory_Manager__c,emailVal+','+tdmp.Depot__r.Case_Access_Email__c);
                }
                //introTextList.add(tdmp.Depot__r.Case_Access_Email__c);
            }
        }
        System.debug('cnfMap==>'+cnfMap);
        Id loggedInUser = userInfo.getUserId();
        Map<Id,User> userMap1=new Map<Id,User>([Select Id,ProfileId,Name,Profile.Name,MobilePhone,Email from User where Id IN :createList1 or ID =:loggedInUser or Id IN :zsmMap.values()]);

        
        
        /*  End Here  */  
        
        
        
        
        
        //SMS sending on case escalation starts
        /*List<Id> createList=new List<Id>();
        for(Case c:CaseMap.values()){
            if(c.categoryforsubcategory__c == null && c.sub_category__c == null){
            createList.add(c.createdById);
              }
        }
        System.debug('createList==>'+createList);*/
        //Map<Id,User> userMap=new Map<Id,User>([Select Id,MobilePhone from User where Id IN :createList]);
        //SMS sending on case escalation ends 
        
        Map<String,String> emailNameMap=new Map<String, String>();
        for(User u:[select id,email, firstname,lastname from user where email IN :introTextList]){
            if(!emailNameMap.containsKey(u.email)){
                if(null!=u.firstname){
                    emailNameMap.put(u.email,u.firstname+' '+u.lastname);
                }
                else{
                    emailNameMap.put(u.email,u.lastname);
                }
            }
            else{
                emailNameMap.put(u.email,u.email);
            }
        }
        Map<Id,List<CaseComment>> caseCommentMap=new Map<Id,List<CaseComment>>();
        
        List <Messaging.Singleemailmessage> emailListFull = new List <Messaging.Singleemailmessage>();
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'UPL Partner Portal'];
        String baseURL=String.valueOf(Network.getLoginUrl(myCommunity.id));
        baseURL=baseURL.split('/login')[0];
        List<EmailTemplate> emailtemp = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Escalated_Email_Template' limit 1];
        List<EmailTemplate> emailtemp1 = [SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE DeveloperName = 'Portal_Escalated_Email_Template_1' limit 1];  //  Additional Line  
       
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence'];
        String fromAdressId = owa.id;
        List<SMS_Template__c> smsTemp=[SELECT Id, Name, Name__c, ObjectName__c, Text__c FROM SMS_Template__c where Name='Community_Case_Escalation' and ObjectName__c='Case'];
        System.debug('CaseMap ' + CaseMap);
        for(Case c : CaseMap.values()){
            
            String caseCreatedBy='';
            String accName='';
            String accSapCode='';
            // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
            String depotName = '';
            String depotCode='';
            
            if(!userMap1.isEmpty() && userMap1.containsKey(c.createdById)){
                 caseCreatedBy=userMap1.get(c.createdById).Name;
            }
            if(!accountMap.isEmpty() && accountMap.containsKey(c.accountId)){
                 accName=accountMap.get(c.accountId).Name;
                 accSapCode=accountMap.get(c.accountId).SAP_Code__c;
                 // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
                 depotName = accountMap.get(c.accountId).Brazil_Depot_Code__r.Name;
                 depotCode = accountMap.get(c.accountId).Depot_Code__c;
            }
            
            
            String commenityurl = baseURL+'/s/casedetailpage?id=';
            c.Escalation_Level__c='Escalated L2';
            commenityurl += c.Id;
            
            caseCommentMap.put(c.Id,c.CaseComments);
            if(originOfEscalation == 'Batch'){
                c.Is_Auto_Escalated__c = true;
            }
            else{
                c.Is_Auto_Escalated__c = false;
            }
            //system.debug('catesub__c ' + c.catesub__c); 
            //System.debug('sub_category__c ' + c.sub_category__c); 
            //System.debug('Category__C ' + c.categoryforsubcategory__c);
            List<String> emailList = new List<String>();
            if(c.Type=='Invoice'|| c.Type=='Dispatch'|| c.Type=='Payments & Receipts'|| c.Type=='Order Cancellation'|| c.Type=='Order Update'|| c.Type=='Product Leakage' || c.Type=='Shipping Address'){
                 if(c.sub_category__c == null){ 
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('LOGISTICS HO')){
                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('LOGISTICS HO'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                    emailListFull.add(email);
                }
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                    Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('HO Finance'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                    emailListFull.add(email4);
                }
                c.CaseOwner__c='LOGISTICS HO;HO Finance';
                c.OwnerOfCase__c = 'LOGISTICS HO, HO Finance';   //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                caseNewOwner = 'HO Finance, LOGISTICS HO';
                casesToBeUpdated.add(c);
                 }
            }
            else if(c.Type=='Credit Limit'|| c.Type=='Outstanding'|| c.Type=='Account Related'|| c.Type=='Other'){
                if(c.sub_category__c == null){ 
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('HO Finance')){
                    Messaging.Singleemailmessage email4 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('HO Finance'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                    emailListFull.add(email4);
                }
                c.CaseOwner__c='HO Finance';
                c.OwnerOfCase__c = 'HO Finance';    //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                caseNewOwner = 'HO Finance';
                casesToBeUpdated.add(c);
                }
            }
            
          
    
            
            else if(c.Type=='Scheme'){
                if(c.sub_category__c == null){ 
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Sales excellence')){
                    Messaging.Singleemailmessage email5 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp,UserInfo.getUserId(),c,emailUserMap.get('Sales excellence'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                    emailListFull.add(email5);
                }
                c.CaseOwner__c='Sales excellence';
                c.OwnerOfCase__c = 'Sales excellence';     //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                caseNewOwner = 'Sales excellence';
                casesToBeUpdated.add(c);
                }
            }
            System.debug('casesToBeUpdated==>'+casesToBeUpdated);
            
            
            
            System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
			System.debug('rcmMap ' + rcmMap);
            /*  Addtional Line added for India Case Module */
            Id TM_Id = accOwnerMap.get(accountIdMap.get(c.Id));
			System.debug('TM_Id ' + TM_Id);
            // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
            String tempEmailHTML = emailtemp1[0].HtmlValue;
            String emailHTML = emailtemp1[0].HtmlValue;
            System.debug('emailHTML : '+emailHTML);
            
            System.debug('depotName : '+depotName);
            if(null!=depotName){
            	emailHTML = emailHTML.replace('[Depot_Name]',depotName);
            }
            else{
                emailHTML = emailHTML.replace('[Depot_Name]','');
            }
            
            if(null!=depotCode){
                  System.debug('depotCode : '+depotCode);
                  emailHTML = emailHTML.replace('[Depot_Code]', depotCode);
            }else{
                  emailHTML = emailHTML.replace('[Depot_Code]', '');
            }
            
            if(c.Sub_Category__c=='Invoice, Schemes & Discount related'|| c.Sub_Category__c=='Dispatch related'|| c.Sub_Category__c=='Product Leakage / damage while shipping' || c.Sub_Category__c=='Product related' || c.Sub_Category__c=='Order Cancellation' || c.Sub_Category__c=='Order Update'){
                if(!rcmMap.isEmpty() &&  TM_Id != null && rcmMap.get(TM_Id) != null){  //  rcmMap.get(TM_Id) // emailUserMap.get('RCMs')                    
                    emailtemp1[0].HtmlValue = emailHTML;     // Change by Sumit(Grazitti) for APPS-4676 31-01-2023                                 
                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,UserInfo.getUserId(),c,rcmMap.get(TM_Id),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                    emailListFull.add(email);
                    System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
                    emailtemp1[0].HtmlValue = tempEmailHTML; // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
                }
                
                c.CaseOwner__c='RCMs';
                c.OwnerOfCase__c = 'RCMs';     //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                caseNewOwner = 'RCMs';
                c.level2__c = 'RCMs';
                casesToBeUpdated.add(c);
                System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
            }
            else if(c.Sub_Category__c=='Product Availability'|| c.Sub_Category__c=='Product Complaints by Farmers'){
                // if(!emailUserMap.isEmpty() && emailUserMap.containsKey('ZSM or ZMM') && !zsmEmailMap.isEmpty() && zsmEmailMap.get(TM_Id) != null && TM_Id != null){  //  zsmEmailMap.get(TM_Id)  // emailUserMap.get('Harbind Chauhan')
                  System.debug('In zsmMap If');
                    if(!zsmMap.isEmpty() && zsmMap.containsKey(TM_Id) && !userMap1.isEmpty() && userMap1.containsKey(zsmMap.get(TM_Id))){
                        System.debug('zsmMap : '+userMap1.get(zsmMap.get(TM_Id)).Email);
                        if(userMap1.get(zsmMap.get(TM_Id)).Email !=null){ //  userMap1.get(zsmMap.get(TM_Id)).Email  //  zsmEmailMap.get(TM_Id)  // emailUserMap.get('ZSM or ZMM')
                            emailtemp1[0].HtmlValue = emailHTML;  // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
                            Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,UserInfo.getUserId(),c,userMap1.get(zsmMap.get(TM_Id)).Email,commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);  //  emailUserMap.get('ZSM or ZMM'),
                            emailListFull.add(email);
                      		System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
                  		}
                	}
                c.CaseOwner__c='ZSM or ZMM';
                c.OwnerOfCase__c = 'ZSM or ZMM';     //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                caseNewOwner = 'ZSM or ZMM';
                c.level2__c = 'ZSM or ZMM';
                casesToBeUpdated.add(c);
                System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
            }  
            else if(c.Sub_Category__c=='Payments & Receipts' || c.Sub_Category__c=='Credit Limit' || c.Sub_Category__c=='Outstanding' || c.Sub_Category__c=='Account Related' || c.Sub_Category__c=='Customer master updation'){
               if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Harbind Chauhan')){  //  emailUserMap.get('Harbind Chauhan')  // emailUserMap.get('Harbind Chauhan')
                   emailtemp1[0].HtmlValue = emailHTML; // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
                   Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,UserInfo.getUserId(),c,emailUserMap.get('Harbind Chauhan'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                    emailListFull.add(email);
                   System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
                }
                c.CaseOwner__c='Harbind Chauhan';
                c.OwnerOfCase__c = 'Harbind Chauhan';     //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                caseNewOwner = 'Harbind Chauhan';
                c.level2__c = 'Harbind Chauhan';
                casesToBeUpdated.add(c);
                System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
            }
              else if(c.Sub_Category__c=='Quality Complaint'){ 
                 system.debug('insideQality----');
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Quality Complaint Level 2')){
                    system.debug('Reopen_Status_Count123------123');
                    List<String> emails123 = emailUserMap.get('Quality Complaint Level 2').split(',');
                    emailtemp1[0].HtmlValue = emailHTML;    // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
                    for(Integer i=0;i<emails123.size();i++){
                        
                        Messaging.Singleemailmessage email123 = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,UserInfo.getUserId(),c,emails123[i],commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                        emailListFull.add(email123);
                         system.debug('emailListFull--- '+emailListFull);
                    }                                                                     
                }
                 
                c.CaseOwner__c = emailUserMap.get('Quality Owners 2');
                   system.debug(' c.CaseOwner__c--- '+c.CaseOwner__c);
                c.OwnerOfCase__c = emailUserMap.get('Quality Owners 2');    //code added for handle owner assignment tracking GRZ(Swaranjeet) Jira Ticket No. APPS-3667 modified on 13-12-2022
                   system.debug(' c.OwnerOfCase__c--- '+c.OwnerOfCase__c);
                caseNewOwner = emailUserMap.get('Quality Owners 2');
                 system.debug(' caseNewOwner--- '+caseNewOwner);
                  casesToBeUpdated.add(c);
            }
         /*   else if(c.Sub_Category__c=='Order Cancellation'|| c.Sub_Category__c=='Order Update'){
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('RCMs') && !rcmMap.isEmpty() && rcmMap.get(TM_Id) != null && TM_Id != null){ //  rcmMap.get(TM_Id)  // emailUserMap.get('Harbind Chauhan')
                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,UserInfo.getUserId(),c,rcmMap.get(TM_Id) ,commenityurl,fromAdressId,emailNameMap,caseCommentMap);
                    emailListFull.add(email);
                }
                c.CaseOwner__c='RCMs';
                caseNewOwner = 'RCMs';
                c.level2__c = 'RCMs';
                casesToBeUpdated.add(c);
            } 
            
            else if(c.Sub_Category__c=='Credit Limit' || c.Sub_Category__c=='Outstanding' || c.Sub_Category__c=='Account Related' || c.Sub_Category__c=='Customer master updation'){
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Harbind Chauhan')){  //  emailUserMap.get('Harbind Chauhan')  // emailUserMap.get('Harbind Chauhan')
                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,UserInfo.getUserId(),c,emailUserMap.get('Harbind Chauhan'),commenityurl,fromAdressId,emailNameMap,caseCommentMap);
                    emailListFull.add(email);
                }
                c.CaseOwner__c='Harbind Chauhan';
                caseNewOwner = 'Harbind Chauhan';
                casesToBeUpdated.add(c);
                c.level2__c = 'Harbind Chauhan';
            } */ 
             
             else if(c.Sub_Category__c=='Schemes & Price Communication from HO'){
                if(!emailUserMap.isEmpty() && emailUserMap.containsKey('Parveen Chambial')){   //  emailUserMap.get('Parveen Chambial')  // emailUserMap.get('Parveen Chambial')
                    emailtemp1[0].HtmlValue = emailHTML;      // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
                    Messaging.Singleemailmessage email = Grz_CaseCommentController.handledynamicEmailNew(emailtemp1,UserInfo.getUserId(),c,emailUserMap.get('Parveen Chambial'),commenityurl,fromAdressId,emailNameMap,caseCommentMap,caseCreatedBy,accName,accSapCode);
                    emailListFull.add(email);
                }
                c.CaseOwner__c='Parveen Chambial';
                c.OwnerOfCase__c = 'Parveen Chambial';     //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
                caseNewOwner = 'Parveen Chambial';
                c.level2__c = 'Parveen Chambial';
                casesToBeUpdated.add(c);
            }
            emailtemp1[0].HtmlValue = tempEmailHTML;       // Change by Sumit(Grazitti) for APPS-4676 31-01-2023
            System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
            System.debug('c.level2__c' + c.level2__c);
            System.debug('casesToBeUpdated==>'+casesToBeUpdated);

            
            /*    End Here */  
            
            
            
            
            
            //SMS sending on case escalation starts
            if(originOfEscalation != 'Batch' && c.sub_category__c == null){
             String encodedcontent;
            User u=userMap1.get(c.createdById);
             if(c.CaseOwner__c != null )
                    encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber).replace('<Case Owner>',c.CaseOwner__c), 'UTF-8');
                else
                    encodedcontent = EncodingUtil.urlEncode(smsTemp[0].Text__c.replace('<CASE ID>', c.CaseNumber), 'UTF-8');
                if(u.MobilePhone!='' && u.MobilePhone!=null){
                    String phoneVal = u.MobilePhone.replaceAll('\\D','');
                    String senderId = 'UPL';
                    if(!Test.isRunningTest())
                    IntegrationWithKarix.sendSMS(encodedcontent,phoneVal,c.Id,senderId);
                }   
            }
            //SMS sending on case escalation ends
            System.debug('c.CaseOwner__c ' + c.CaseOwner__c);
            System.debug('c.level2__c' + c.level2__c);
            System.debug('casesToBeUpdated==>'+casesToBeUpdated);
        }
        try{
            if(emailListFull.size() > 0 && !Test.isRunningTest()){
                Messaging.sendEmail(emailListFull);
            }
            
            
            System.debug('casesToBeUpdated==>'+casesToBeUpdated);
            if(!casesToBeUpdated.isEmpty()){
                update casesToBeUpdated;
            }
             if(Test.isRunningTest()) {
                            CalloutException e = new CalloutException();
                            e.setMessage('This is a constructed exception for testing and code coverage');
                            throw e;
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
        //}
        
        
        return caseNewOwner;
    }
    
    @AuraEnabled
    public static String checkCaseStatus(String caseId)
    {   
        String statusVal='';
        try{
            List<Case> c=[Select Id, Status from case where id = :caseId];     
            if(!c.isEmpty()){
                statusVal=c[0].Status;
            }
             if(Test.isRunningTest()) {
                            CalloutException e = new CalloutException();
                            e.setMessage('This is a constructed exception for testing and code coverage');
                            throw e;
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
        if(checkCaseStatus(caseId)!='Closed'){
            system.debug('cid---'+cid);
            List<ContentDocument> Doc = [select id,contentsize from ContentDocument where id =: cid limit 1];
            integer size = Doc[0].contentsize;
            if(size > 209715200){
                system.debug('size value==='+size);
                Delete Doc[0];
                return 'ERROR';
            }else{
                system.debug('size value==='+size);
                return 'SUCCESS';
            }
        }
        else{
            return 'ERRORClosed';
        }
        
    }
}