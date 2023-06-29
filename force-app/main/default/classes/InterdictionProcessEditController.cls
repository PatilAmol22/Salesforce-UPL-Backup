/*
@Author: Pragati Sharma  For APPS-3648
@Class_Description : Interdiction Process Edit Controller

*/ 
public class InterdictionProcessEditController {
    @AuraEnabled(cacheable=true)
   
    public static List<Interdiction_Process__c> getInterRecords(String recordId){
        return([Select 	Instance_Number__c,OwnerId,Owner.Type,AGENT_EMAIL_Brazil__c,CITY__c,CNPJ_CPF__c,COMMENTS__c,CONTACT__c,DATE_OF_REAL_COLLECTION__c,DATE_OF_REQUEST__c,DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR__c,DUE_DATE__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,ENTRY_CLOSED__c,ESTIMATED_COLLECTION_DATE__c,INSCRI_O_ESTADUAL__c,IS_AN_INTERDICTION__c,NUMBER__c,POSTCODE__c,PRIORITY__c,RAZ_O_SOCIAL__c,REASON__c,STATE__c,STREET__c,SUBURB__c,TERM_NUMBER__c,Vendor__c,toLabel(Status__c) from Interdiction_Process__c where id=:recordId]);
    }
    @AuraEnabled(cacheable=true)
    public static Profile getUserInfo() {
       
        return  [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    }
     @AuraEnabled(cacheable=true)
    public static String getgroupInfo() {
       String userIDFromGroup;
        for(GroupMember member:[SELECT UserOrGroupId,Group.Id FROM GroupMember WHERE UserOrGroupId =:UserInfo.getUserId()]){
            userIDFromGroup=member.Group.Id;
        }
        return userIDFromGroup;
    }
    @AuraEnabled
    public static String updateRecords (Interdiction_Process__c Interpro,String recordId){
        System.debug('interr'+Interpro+' id'+recordId);
        Map<String,String> mapofPicklistValueandLabel=new Map<String,String>();
        Schema.DescribeFieldResult objFieldDescribe = Interdiction_Process__c.Status__c.getDescribe();
List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
for (Schema.PicklistEntry objPickList : lstPickListValues) {
    mapofPicklistValueandLabel.put(objPickList.getLabel(),objPickList.getValue());
    
}
       // Interdiction_Process__c ip=new Interdiction_Process__c();
        if(mapofPicklistValueandLabel!=null){
        For(String s:mapofPicklistValueandLabel.keySet()){
            if(s == Interpro.Status__c){
                Interpro.Status__c= mapofPicklistValueandLabel.get(s);
            }
        }
        }
        Interpro.id=recordId;
        if(Interpro!=null){
        update Interpro;  
        }
        return 'Success';
        
    }
  
    @AuraEnabled(cacheable=true)
   public static List<Interdiction_Product__c> getInterProductRecords(String recordId){
        System.debug('Inter record'+recordId);
        return([Select id,Name,Interdiction_Process__c,Batch__c,Quantity__c,Expire_Date__c from Interdiction_Product__c where Interdiction_Process__c=:recordId]);
    }
    @AuraEnabled
      public static String DeleteFilesOnChange(List<String> filedata) {
          System.debug('fileData For Delete'+filedata);
           List<Id> ContentVersionIdList=new List<Id>();
          If(filedata.size()>0 && !filedata.isEmpty()){
         for(ContentVersion cv :[SELECT id,AutoFileUpload__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId in :filedata]){
            
            ContentVersionIdList.add(cv.id);
        }
          }
        List<contentDocument> cdList=[SELECT Description,title from ContentDocument where LatestPublishedVersionId in :ContentVersionIdList];
   System.debug('cdList' +cdList);
          try{
           if(cdList.size()>0 && !cdList.isEmpty()){
    delete cdList;   
           }
       return('delete done');
          }
          Catch(Exception e){
            System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
            return e.getStackTraceString();
        }
                             
      }
      @AuraEnabled
    public static String updateFileRecordOnCV(List<Id> filedata,String recordId) {
        System.debug('filedata'+filedata+'@@@@@@@@@@@@'+recordId);
        Set<Id> CvId=new Set<Id>();
          List<ContentVersion> cvList=new List<ContentVersion>();
        if(filedata.size()>0 && recordId!=null){
         for(ContentVersion cv :[SELECT AutoFileUpload__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId in : filedata]){
            cv.InterRecordID__c=recordId;
           
            cvList.add(cv);
        }
        }
        try{
         if(cvList.size()>0 && !cvList.isEmpty()){
        update cvList; 
         }
         return cvList[0].id;
        }
        Catch(Exception e){
            System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
            return e.getStackTraceString();
        }
    }
     @AuraEnabled
    public static String updateProductRecords (String recordId,String Interproduct){
      
        System.debug('interr for update'+Interproduct);
        System.debug('record'+recordId);
        //System.debug('proID'+proId);
        List<Interdiction_Product__c> listOfProducts = (List<Interdiction_Product__c>) JSON.deserialize(Interproduct, List<Interdiction_Product__c>.class);
        system.debug('Interdiction_Product__c'+listOfProducts);
        List<Interdiction_Product__c> ipList=new List<Interdiction_Product__c>();
        for(Interdiction_Product__c ip:listOfProducts){
            ip.Interdiction_Process__c=recordId;
            ipList.add(ip);
        }
        System.debug('ipLisy'+ipList);
        if(ipList.size()>0 && !ipList.isEmpty()){
        upsert ipList; 
        }
        return 'success';
        
    }
    @AuraEnabled
    public static String DeleteProductRecords(List<Id> recordId){
        System.debug('Inter record'+recordId);
        List<Interdiction_Product__c> productList = new List<Interdiction_Product__c>();
        if(recordId!=null){
            productList=[Select Name,Interdiction_Process__c,Batch__c,Quantity__c,Expire_Date__c from Interdiction_Product__c where id in:recordId];
        }
            System.debug('proddd'+productList);
   try{
        if(productList.size()>0 && !productList.isEmpty()){
   delete productList;  
        }
   }
   catch(DmlException e){
       System.debug(e.getmessage());
   }
   return'success';
    }
     /*@AuraEnabled
    public static void deleteContentDocument(List<Id> recordId) {
        try{
            DELETE [SELECT Id FROM ContentDocument WHERE ID=:recordId];
        } catch(Exception e){
            System.debug('deleteContentDocument Exception is - '+ e.getMessage());
            System.debug('deleteContentDocument Exception at - '+ e.getLineNumber());
        }    
    }*/
         

}