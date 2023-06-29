public with sharing class Grz_CaseCreateController {
    
    @AuraEnabled 
    public static ResultWrapper fetchUser(){
        ResultWrapper obj = new ResultWrapper();
        // query current user information  
        User cUserInfo= grz_SapIntegration.GetUserInfo();        
        obj.Name = cUserInfo.Contact.name;
        obj.Email = cUserInfo.Email;
        Obj.MobilePhone = cUserInfo.MobilePhone;
        if(cUserInfo.accountId == null){
            Obj.IsInternalUser = true;                
        }
        else{
            Obj.IsInternalUser = false; 
        }
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
        eachRecord= [Select Id,CaseType__c,Name from  Partner_Portal_Configuration__c where  recordtypeId  =: recordTypeShowId and Name = 'CaseTypePicklist'];
        List<String> Types = new List<String>();
        
        if(eachRecord.size()>0){
            Types = eachRecord[0].CaseType__c.split(',');
        }    
        obj.CaseTypeList = Types;
        return obj;
    } 
    
    @AuraEnabled
    public static case createCase(Case cs, String casetypes, String AccountID, List<String> ContentDocId) {
        system.debug('Case Record==='+cs);
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        system.debug('ContentDocId==='+ContentDocId);
		
     	List<Case_Matrix__c> cmList =[SELECT Id, OwnerId, Name, Case_Access__c, Case_Owner__c, Case_Type__c, Sales_Org__c,Sales_Org__r.name,Case_Owner_Notify__c FROM Case_Matrix__c where Sales_Org__r.name = 'India'];                 
        Map<String,String> cmMap = new Map<String,String>();
        for(Case_Matrix__c cm : cmList){
            cmMap.put(cm.Case_Type__c,cm.Case_Owner__c);
        }
        system.debug('cmMap==='+cmMap);
        if(!cmMap.isEmpty() && cmMap.containsKey(casetypes)){
            cs.CaseOwner__c = cmMap.get(casetypes);   
            cs.OwnerOfCase__c = cmMap.get(casetypes);  //code added for handle owner assignment tracking GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
        }		        
        cs.Type = casetypes;
        cs.Escalation_Level__c= 'Escalated L1';
        cs.RecordTypeId = recordTypeShowId;
        
        User cUserInfo = grz_SapIntegration.GetUserInfo();
        
        if(cUserInfo.accountId == null && AccountID != NULL){
            cs.AccountId= AccountID;
        }
        else{
            cs.AccountId = cUserInfo.accountId;
        }
        
        try{
            
            system.debug('Case Record===1'+cs);
            insert cs;
            List<ContentVersion> contentVerList=[Select Id,Guest_Record_fileupload__c from contentversion where contentdocumentid IN :ContentDocId];
            List<ContentVersion> cvUpdateList=new List<ContentVersion>();
            for(ContentVersion cv:contentVerList){
                cv.Guest_Record_fileupload__c=cs.Id;
                cvUpdateList.add(cv);
            }            
            if(!cvUpdateList.isEmpty()){
                update cvUpdateList;
            }
            List<ContentDocumentLink> cdlinklist = new List<ContentDocumentLink>();
            if(ContentDocId != null){
                for(String ctid :ContentDocId){
                    ContentDocumentLink cDocLink = new ContentDocumentLink();
                    cDocLink.ContentDocumentId = ctid;//Add ContentDocumentId
                    cDocLink.LinkedEntityId = cs.Id;//Add attachment parentId
                    //cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                    cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers 
                    cdlinklist.add(cDocLink);
                }
                                
                insert cdlinklist;
                system.debug('Case Record return==='+cdlinklist);
            }            
        }
        catch (Exception e) {
            
            //throw new AuraHandledException(e.getMessage());
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo1= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo1.accountId;
            storeError.ErrorType__c = 'Cases';
            insert storeError;
        }
        return cs;
    }
    @AuraEnabled
    public static void deleteAttachments(List<String> ContentDocId) {
        List<ContentDocument> cdlist = new List<ContentDocument>();
        for(String cdocid: ContentDocId){
            ContentDocument cd = new ContentDocument(id=cdocid);
            cdlist.add(cd);
        }
        delete cdlist;
    }
    @AuraEnabled
    public static String contentSize(String cid) {
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
    
    public class ResultWrapper{
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Email{get;set;}
        @AuraEnabled
        public String MobilePhone {get;set;}
        @AuraEnabled
        public Boolean IsInternalUser{get;set;}
        @AuraEnabled
        public List<String> CaseTypeList{get;set;}
        
    }    
}