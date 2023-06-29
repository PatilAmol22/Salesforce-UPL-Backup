/**************************************************************************************************
* Name               : Grz_CreateCaseBrazilController                                                      
* Description        : Controller for Grz_CreateCaseBrazilPage.cmp aura component
* Test Class         : Grz_CreateCaseBrazilControllerTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_CreateCaseBrazilController {
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
        eachRecord= [Select Id,CaseType__c,Name from  Partner_Portal_Configuration__c where  recordtypeId  =: recordTypeShowId and Name = 'CaseTypePicklistBrazil'];
        List<String> Types = eachRecord[0].CaseType__c.split(',');
        List<String> caseTypesList = new  List<String>();  
        Types.sort();//Added by Aashima(Grazitti) for RITM0437297
        obj.CaseTypeList = Types;
        obj.Error= false;
        obj.ErrorMessage = 'Case created successfully';        
        return obj;
    } 
    
    
    @AuraEnabled 
    public static string CaseCategory( String CaseType){
         Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseCategoryMapping').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
         eachRecord= [Select Id,CaseType__c,Name,Description__c,Language__c from  Partner_Portal_Configuration__c where  recordtypeId  =: recordTypeShowId and Language__c ='pt-BR' and Name =: CaseType LIMIT 1];
        if(!eachRecord.isEmpty()){
            return eachRecord[0].Description__c;
        }
        return null;
    } 
    
    
    
    @AuraEnabled
    public static case createCase(Case cs, String casetypes, String AccountID, List<String> ContentDocId) {
        Id recordTypeShowId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();
        List<Case_Matrix__c> cmList =[SELECT Id, OwnerId, Name, Case_Access__c, Case_Owner__c, Case_Type__c, Sales_Org__c,Sales_Org__r.name,Case_Owner_Notify__c FROM Case_Matrix__c where Sales_Org__r.name = 'Brazil'];                 
        Map<String,String> cmMap = new Map<String,String>();
        for(Case_Matrix__c cm : cmList){
            cmMap.put(cm.Case_Type__c,cm.Case_Owner__c);
        }
        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        if(!cmMap.isEmpty()){
            cs.CaseOwner__c = cmMap.get(casetypes);
        }
        cs.Created_From_Portal__c = true;
        cs.Type = casetypes;
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