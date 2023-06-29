/*
@Author: Pragati Sharma For APPS-3648
@Class_Description : Interdiction Process Creation 
*/ 

public class InderdictionProcessController {
   @AuraEnabled(cacheable=true) //Method to call picklist fields and respective values.
    public static Map<String,List<String>> getPicklistTypeFields() {
        
        Map<String, Schema.SObjectType> detail = Schema.getGlobalDescribe();
        System.debug('schema'+detail);
        Map<String, List<String>> mapOfPicklistTypeFields = new  Map<String,List<String>>();
        for(Schema.SObjectField fields :detail.get('Interdiction_Process__c').getDescribe().fields.getMap().Values()) {
            If(fields.getDescribe().getType() == Schema.DisplayType.PICKLIST) { 
                
                for(Schema.PicklistEntry a : fields.getDescribe().getPickListValues())
                {
                    if(mapOfPicklistTypeFields.containsKey(fields.getDescribe().getName()))
                    {
                        List<String> pickList= mapOfPicklistTypeFields.get(fields.getDescribe().getName());
                        pickList.add(a.getLabel());
                        mapOfPicklistTypeFields.put(fields.getDescribe().getName(),pickList);
                    }
                    else
                    {
                        mapOfPicklistTypeFields.put(fields.getDescribe().getName(),new List<string>{a.getLabel()});
                    }
                }
                
                
            }
        }
        
        return mapOfPicklistTypeFields;
    }
    @AuraEnabled //Method to save Interdiction Process from component to database.
    public static String saveDetails(String fields){
        String objectName = 'Interdiction_Process__c';
        
        List<Interdiction_Process__c> interList = new List<Interdiction_Process__c>();
        Interdiction_Process__c ipc=new Interdiction_Process__c();
        System.debug('fields'+fields);
        Map<String,Object> mapofInterFieldsAndValue=new Map<String,Object>();
        Map<String,Object> mapOfInterData = new Map<String,Object>();
        For(Object o: (List<Object>)JSON.deserializeUntyped(fields)){
            System.debug('deserialize'+o);
            
            Map<String, Object> data = (Map<String, Object>)o;
            mapOfInterData.putAll(data);
            System.debug('mapOfCaseData'+mapOfInterData);
            
            if(mapOfInterData.containsKey('key') && mapOfInterData.containsKey('value')){
                
                mapofInterFieldsAndValue.put(string.valueOf(mapOfInterData.get('key')),mapOfInterData.get('value'));
                
                System.debug('mapp'+mapofInterFieldsAndValue);
            }
            
        }
        
        if ((mapofInterFieldsAndValue != null && !mapofInterFieldsAndValue.isEmpty())) {
            
            for(String fieldData : mapofInterFieldsAndValue.keySet()){
                
                String fieldName = fieldData;
                SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                system.debug('enetered'+fieldData);
                if(d.fields.getMap().get(fieldName).getDescribe().getType()==Schema.DisplayType.Date){
                    System.debug('date fields');
                    String a=string.valueOf(mapofInterFieldsAndValue.get(fieldData));
                    Date dp=Date.parse(a);
                    ipc.put(fieldData,dp);
                    System.debug(' ipc.put(fieldData,dp)'+ ipc);
                }
                
                else
                {
                    ipc.put(fieldData, mapofInterFieldsAndValue.get(fieldData));
                }
                
                
                
            }
            interList.add(ipc);
            System.debug('interdiction@@@'+interList);
        } 
        try{
            if(interList.size()>0 && !interList.isEmpty() && interList!=null){
                insert interList;
            }
            
            return interList[0].Id;  
        }Catch(Exception e){
            System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
            return e.getStackTraceString();
        }
        
    }
    @AuraEnabled //Method to save Interdiction Product related to Interdiction Process
    public static String saveProductDetails(String recordId,String productFields){
        List<Interdiction_Product__c> listOfAccounts = (List<Interdiction_Product__c>) JSON.deserialize(productFields, List<Interdiction_Product__c>.class);
        system.debug('Interdiction_Product__c'+listOfAccounts);
        List<Interdiction_Product__c> ipList=new List<Interdiction_Product__c>();
        for(Interdiction_Product__c ip:listOfAccounts){
            ip.Interdiction_Process__c=recordId;
            ipList.add(ip);
        }
        System.debug('ipList');
        try{
            if(ipList.size()>0 && !ipList.isEmpty()){
                insert ipList;
            }
            return ipList[0].id;
        }
        Catch(Exception e){
            System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
            return e.getStackTraceString();
        }
        
    }
    @AuraEnabled //Method to update checkbox field on contentversion to know that file was uploaded from the LWC.
    public static String updatecheckBoxFileRecord(List<Id> filedata) {
        System.debug('file'+filedata);
        List<ContentVersion> cvList=new List<ContentVersion>();
        List<ContentDocumentLink> cdList=new List<ContentDocumentLink>();
        for(ContentVersion cv :[SELECT AutoFileUpload__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId in : filedata]){
            cv.AutoFileUpload__c=true;
            cvList.add(cv);
        }
        if(cvList.size()>0 && !cvList.isEmpty()){
            update cvList;   
            System.debug('cvList'+cvList[0].AutoFileUpload__c);
        }
        
        return'Success';
    }
    
    @AuraEnabled //Method to update contentdocument with the recordID to show up on record's related list
    public static String updateFileRecord(String recordId, List<Id> filedata) {
        System.debug('this file'+filedata);
        System.debug('this.record'+recordId);
        Set<Id> CvId=new Set<Id>();
        List<ContentVersion> cvList=new List<ContentVersion>();
        for(ContentVersion cv :[SELECT AutoFileUpload__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId in : filedata]){
            cv.InterRecordID__c=recordId;
            CvId.add(cv.ContentDocumentId);
            cvList.add(cv);
        }
        if(cvList.size()>0 && !cvList.isEmpty()){
            update cvList; 
        }
        
        List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
        for( ContentVersion cv : cvList) {
            
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = recordId;
            conDocLink.ContentDocumentId = cv.ContentDocumentId;
            conDocLink.Visibility = 'AllUsers';
            conDocLink.shareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
            System.debug('cdl3'+conDocLink);
            cdList.add(conDocLink);
            
        }
        try{
            if(cdList.size()>0 && !cdList.isEmpty()){
                insert cdList; 
                
            }
            return cdList[0].id;
        }
        Catch(Exception e){
            System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
            return e.getStackTraceString();
        }
        
        
    }
    
    @AuraEnabled //Method to delete files that are saved on file upload but do not assosciated with any records.
    public static String DeleteFilesOnChange(List<String> filedata) {
        System.debug('fileData For Delete'+filedata);
        List<Id> ContentVersionIdList=new List<Id>();
        for(ContentVersion cv :[SELECT id,AutoFileUpload__c,ContentDocumentId FROM ContentVersion WHERE AutoFileUpload__c=true and ContentDocumentId in :filedata and InterRecordID__c ='']){
            
            ContentVersionIdList.add(cv.id);
        }
        List<contentDocument> cdList=[SELECT Description,title from ContentDocument where LatestPublishedVersionId in :ContentVersionIdList];
        System.debug('cdList' +cdList);
        try{
            if(cdList.size()>0 && !cdList.isEmpty()){
                delete cdList; 
            } 
            return 'Success'; 
        }
        Catch(Exception e){
            System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
            return e.getStackTraceString();
        }
        
    }
    @AuraEnabled //Method to call SKU for Brazil
    public static List<SKU__c> getProduct() {
        
        List<SKU__c> skuList=[Select id,name,SKU_Code__c,Active__c from SKU__c where Sales_Org_Code__c='5191' and Active__c=true];
        System.debug('sku'+skuList);
        return skuList;
        
    }
     
   
   
}