//Class for customer onboarding crown integration
//Developer-Aashima(Grazitti)
//Test-Class:-Grz_OnboardingCrownIntegration_Test
public with sharing class Grz_OnboardingCrownIntegration {
    
    @AuraEnabled
    public static String getDocumentsFromCrown(String recordId){
        System.debug('Inside getDocumentsFromCrown');
        String returnString='';
        List<Crown_Document__c> crownDocumentRecord=[Select id,sales_area__r.Crown_Prospect_Number__c from Crown_Document__c where sales_area__c=:recordId limit 1];
        
        if(!crownDocumentRecord.isEmpty()){
            
            //deleteAllDocuments(crownDocumentRecord[0].Id);
            
            requestClass sapRequest=new requestClass();
            sapRequest.ProspectNo=crownDocumentRecord[0].sales_area__r.Crown_Prospect_Number__c;
            String token=GenerateToken();
            sapRequest.TokeNo=token;
            System.debug('sapRequest==>'+sapRequest);
            //generateDocumentsFuture(JSON.serialize(sapRequest),crownDocumentRecord[0].Id);
            
            calloutBatchClass c=new calloutBatchClass(JSON.serialize(sapRequest),recordId,crownDocumentRecord[0].Id);
            Integer batchSize=1;
            if(Test.isRunningTest()){
            batchSize=4;
            }
           database.executeBatch(c,batchSize ); return null; 
        }
        else{
            returnString='No record present under Crown Documents for this sales area';
        }
        
        return returnString;
    }
    /*public class responseClass3{
        @AuraEnabled public String DPN      {get;set;}
    }
    public static responseClass3 parse3(String json){
        return (responseClass3) System.JSON.deserialize(json, responseClass3.class);
    }
    @future(callout=true)
    public static void generateDocumentsFuture(String sapRequest,String crownDocRecordId)
    {
        String sapResponse;
        sapResponse = getDocumentByProspect(sapRequest);
        responseClass3 responseData=new responseClass3();
        List<String> nullList=new List<String>();
        nullList.add('');
        nullList.add(null);
        responseData=responseClass3.parse3(sapresponse);
        if(!nullList.contains(responseData.DPN)){
            generatePdf(responseData.DPN,crownDocRecordId,'DPN');     
        }
    }*/
    @AuraEnabled(cacheable=true)
    public static String getDocumentByProspect(String requestBody){
        system.debug('requestBody===>'+requestBody);
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Onboarding_Crown_URL/FileUpload/getDocumentByProspectno');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = requestBody;
        req.setBody(body);
        system.debug(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            system.debug(res.getStatusCode());
            response = res.getBody();
            system.debug(response);
            
        }catch(Exception e){
            System.debug('error message==>'+e.getMessage());
            System.debug('error stack trace==>'+e.getStackTraceString());
        }
        return response;
    }
    
    public class requestClass{
        @AuraEnabled public String ProspectNo      {get;set;}
        @AuraEnabled public String TokeNo      {get;set;}
    }
    @AuraEnabled
    public static String GenerateToken(){
        Map<String, PAN_GST_API_Creds__c> mcs = PAN_GST_API_Creds__c.getAll();
        PAN_GST_API_Creds__c settingDetails=PAN_GST_API_Creds__c.getValues('Crown_API_Creds');
        String username=settingDetails.username__c;
        String password=settingDetails.password__c;
        String body = '{ \"username\": \"'+username+'\",  \"password\": \"'+password+'\" }';
        
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Onboarding_Crown_URL/UserLogin/UserLogin');
        req.setTimeout(120000);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);
        HTTPresponse res= http.send(req);
        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Object token = (Object)response.get('User_Token');
        return token.toString();
    }
    public class requestClassUpdate{
        @AuraEnabled public String FileNo      {get;set;}
        @AuraEnabled public String TokeNo      {get;set;}
        @AuraEnabled public String SAPCODE      {get;set;}
        @AuraEnabled public String RemarkSAP      {get;set;}
        @AuraEnabled public String status      {get;set;}
    }
    public class responseClassUpdate{
        @AuraEnabled public String Message      {get;set;}
    }
    public static responseClassUpdate parseUpdate(String json){
        return (responseClassUpdate) System.JSON.deserialize(json, responseClassUpdate.class);
    }
    @future(callout=true)
    public static void updateSAPNumber(String saId,String SAPCustomerCode,String SAPResponseMessage){
        System.debug('updateSAPNumber==>');
        List<DistributorSalesAreaMapping__c> saList=[Select id,Substage__c,Crown_File_Number__c,Crown_SAP_Update_Response__c from DistributorSalesAreaMapping__c where id = :saId];
        if(!saList.isEmpty()){
            requestClassUpdate sapRequest=new requestClassUpdate();
            sapRequest.FileNo=saList[0].Crown_File_Number__c;
            String token=GenerateToken();
            sapRequest.TokeNo=token;
            sapRequest.SAPCODE=SAPCustomerCode;
            sapRequest.RemarkSAP=SAPResponseMessage;
            if(SAPCustomerCode==''){
                sapRequest.status='Reject';
            }
            else{
                sapRequest.status='Accept';
            }
            
            Http http = new Http(); 
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Onboarding_Crown_URL/FileUpload/UpdateSAPNo');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            String body = JSON.serialize(sapRequest);
            req.setBody(body);
            system.debug(body);
            string response;
            try{
                HTTPresponse res= http.send(req);
                system.debug(res.getStatusCode());
                response = res.getBody();
                system.debug(response);
                responseClassUpdate crownResponse=responseClassUpdate.parseUpdate(response);
                saList[0].Crown_SAP_Update_Response__c=crownResponse.Message;
                update saList[0];
            }catch(Exception e){
                System.debug('error message==>'+e.getMessage());
                System.debug('error stack trace==>'+e.getStackTraceString());
            }
        }
        
    }
    
    
    public static void generatePdf(String docData,String parentId,String fileName){
        System.debug('inside generatePdf');
        System.debug('inside fileName=>'+fileName);
        System.debug('inside parentId=>'+parentId);
        Blob blobContent = EncodingUtil.base64Decode( docData );
        ContentVersion objCV = new ContentVersion(
            Title = fileName,
            PathOnClient = fileName+'.pdf',
            VersionData = blobContent,
            IsMajorVersion = true,
            ContentLocation = 'S'
        );
        insert objCV;
        objCV = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id =: objCV.Id
        ];
        ContentDocumentLink objCDL = new ContentDocumentLink(
            ContentDocumentId = objCV.ContentDocumentId,
            LinkedEntityId = parentId,
            Visibility = 'AllUsers'
        );
        insert objCDL;
    }
    
    @AuraEnabled
    public static void deleteAllDocuments(String recordIdVal){
        List<Crown_Document__c> crownDocumentRecord=[Select id from Crown_Document__c where sales_area__c=:recordIdVal limit 1];
        if(!crownDocumentRecord.isEmpty()){
            List<Id> idList=new List<Id>();
            List<Id> contentDocumentIdList=new List<Id>();
            for(ContentDocumentLink cdLink:[Select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId = :crownDocumentRecord[0].Id]){
                idList.add(cdLink.Id);
                contentDocumentIdList.add(cdLink.ContentDocumentId);
            }
            
            if(!idList.isEmpty()){
                Database.delete(idList) ;
            }
            if(!contentDocumentIdList.isEmpty()){
                Database.delete(contentDocumentIdList);
            } 
        }
        
    }
}