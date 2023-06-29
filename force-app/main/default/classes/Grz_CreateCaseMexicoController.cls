public with sharing class Grz_CreateCaseMexicoController {
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
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseCategoryMapping').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
        eachRecord= [Select Id,Name,Label__c,CaseType__c from  Partner_Portal_Configuration__c where  recordtypeId  =: recordTypeShowId and Language__c = 'es-MX'];
        //List<String> Types = eachRecord[0].CaseType__c.split(',');
        List<String> caseTypesList = new  List<String>(); 
        for(Partner_Portal_Configuration__c pp : eachRecord){
            caseTypesList.add(pp.name);
        }
            
        obj.CaseTypeList = caseTypesList;
        obj.Error= false;
        obj.ErrorMessage = 'Case created successfully';        
        return obj;
    } 
    
    
    /*@AuraEnabled 
    public static string CaseCategory( String CaseType){
         Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseCategoryMapping').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
         eachRecord= [Select Id,CaseType__c,Name,Description__c,Language__c from  Partner_Portal_Configuration__c where  recordtypeId  =: recordTypeShowId and Language__c ='pt-BR' and Name =: CaseType LIMIT 1];
        if(!eachRecord.isEmpty()){
            return eachRecord[0].Description__c;
        }
        return null;
    }*/ 
    
    
    
    @AuraEnabled
    public static case createCase(Case cs, String casetypes, String AccountID, List<String> ContentDocId) {
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();
        Id portalrecordTypeId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseCategoryMapping').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
        eachRecord= [Select Id,Name,Label__c,CaseType__c from  Partner_Portal_Configuration__c where  recordtypeId  =: portalrecordTypeId and Language__c = 'es-MX'];
        Map<String,String> mxCaseTypeMap = new Map<String,String>();
        for(Partner_Portal_Configuration__c ppc : eachRecord){
            mxCaseTypeMap.put(ppc.Name,ppc.Label__c);
        }
        system.debug('CaseTypes : '+casetypes);
        cs.Type = mxCaseTypeMap.get(casetypes);
        cs.IsCaseCreatedFromMxPortal__c = true;
        system.debug('Case : '+cs);
        cs.RecordTypeId = recordTypeShowId;
        User cUserInfo = grz_SapIntegration.GetUserInfo();
        if(cUserInfo.accountId == null && AccountID != NULL){
            cs.AccountId= AccountID;
        }
        else{
            cs.AccountId = cUserInfo.accountId;
        }
        try{   
            insert cs;
            List<Case> caseList = new List<Case>();
            caseList.add(cs);
            Grz_MexicoCaseApprovalHelper.submitProcessApprovalRequestMexico(caseList);
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
                    cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers 
                    cdlinklist.add(cDocLink);
                }            
                insert cdlinklist;
            }            
        }
        catch (Exception e) {
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
        List<ContentDocument> Doc = [select id,contentsize from ContentDocument where id =: cid limit 1];
        Integer size;
        if(!doc.isEmpty()){
            size = Doc[0].contentsize;
        }
        if(size > 20971520){
            Delete Doc[0];
            return 'ERROR';
        }else{
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
        public String ErrorMessage {get;set;}
        @AuraEnabled
        public Boolean Error{get;set;}
        @AuraEnabled
        public List<String> CaseTypeList{get;set;}
    }    
}