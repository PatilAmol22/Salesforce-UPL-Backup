public class SurveyFileUploadController {
    @auraenabled
    public static void createDistributorDoc(List<DistributorDocument__c> DistributorDocList){    
        try{
            System.debug('DistributorDocList---->'+DistributorDocList);
            upsert DistributorDocList;
            
            List<ContentDocumentLink> ContentDocumentLinkList = new List<ContentDocumentLink>();
            for(DistributorDocument__c DistributorDocObj:DistributorDocList)
            {
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = DistributorDocObj.AttachmentId__c;
                cDe.LinkedEntityId = DistributorDocObj.Id; // you can use objectId,GroupId etc
                cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                cDe.Visibility = 'InternalUsers';
                ContentDocumentLinkList.add(cDe);
            }
            insert ContentDocumentLinkList;
            
        }
        catch(Exception e)
        {
            System.debug('E-->'+e.getMessage());
            System.debug('line'+e.getLineNumber());
        } 
    }
    @auraenabled
    public static List<DistributorDocument__c> loadDistributorDoc(String SurveyId,String AccountId){    
        try{
            system.debug('@@@@@@@@@SurveyId==='+SurveyId);
            system.debug('@@@@@@@@@AccountId==='+AccountId);
            List<DistributorDocument__c> DistributorDocList=[select id,Document_Name__c,Survey__c,AttachmentId__c,Documents_Type__c,Distributor__c from DistributorDocument__c where Survey__c=:SurveyId AND Distributor__c=:AccountId]; 
            
            system.debug('@@@@@@@@@DistributorDocList==='+DistributorDocList);
            return DistributorDocList;
        }
        catch(Exception e)
        {
            System.debug('E-->'+e.getMessage());
            System.debug('line'+e.getLineNumber());
        } 
        
        return null;
    }
    @auraenabled
    public static Boolean DeleteDistributorDocuments(List<DistributorDocument__c> DeletedDocumentList){    
        try{
            System.debug('deleted Document List'+DeletedDocumentList);
            delete DeletedDocumentList;
            
            return true;
        }
        catch(Exception e)
        {
            System.debug('E-->'+e.getMessage());
            System.debug('line'+e.getLineNumber());
            
        } 
        
        return false;
    }
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @auraenabled
    public static Axedasurvey__c InsertAttachmentInSurvey(List<DistributorDocument__c> DistributorDocList,String SurveyId){
        Map<String,String> attatmentIdMap = new Map<String,String>();
        for(DistributorDocument__c DistributorDocObj:DistributorDocList)
        {
            attatmentIdMap.put(DistributorDocObj.Documents_Type__c,DistributorDocObj.AttachmentId__c);
        }
        System.debug('attatmentIdMap-->'+attatmentIdMap);
        try{
            SurveyId = SurveyId.substring(0,15);
            Axedasurvey__c survey = new Axedasurvey__c();
            survey.Id = SurveyId;
            survey.uploaded_Image__c = attatmentIdMap.get('Distributor Agreement Dealership Firm');
            survey.uploaded_Image1__c = attatmentIdMap.get('Pan Card');
            survey.uploaded_Image2__c = attatmentIdMap.get('Adhar Number');
            survey.uploaded_Image_3__c =attatmentIdMap.get('GST Certification');
            survey.uploaded_Image_4__c = attatmentIdMap.get('Authorization in Name of Manager');
            survey.uploaded_Image_5__c = attatmentIdMap.get('Upload PP photo with Digital Signature [Owner/Partner manager whichever applicable- sign on A4 blank page and upload]');
            survey.uploaded_Image_6__c =  attatmentIdMap.get('Photograph/Selfie - Company person and Distributor');
            survey.uploaded_Image8__c = attatmentIdMap.get('Shop / Office photo (frontage)'); 
            survey.uploaded_Image_9__c =  attatmentIdMap.get('Bank statement last 6M');
            survey.uploaded_Image_10__c = attatmentIdMap.get('Upload competition companies invoice copies');
            update survey;
            system.debug('@@@@'+survey);
            return survey;
        }
        catch(Exception e)
        {
            System.debug('e line number--->'+e.getLineNumber());
            System.debug('e message--->'+e.getMessage());
        }
        return null;
    }
    //Get attachment
    @AuraEnabled
    public static Id convertAttachmentToFile(Id AttachmentId){
        Attachment attach = [SELECT Id, Name, Body, ContentType, ParentId,OwnerId From Attachment where id=:AttachmentId LIMIT 1];
        system.debug('attach===>'+attach);
        //Insert ContentVersion
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = attach.Name;//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        cVersion.OwnerId = attach.OwnerId;//Owner of the file
        cVersion.Title = attach.Name;//Name of the file
        cVersion.VersionData = attach.Body;//File content
        Insert cVersion;
        system.debug('attach===>'+attach);
        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        system.debug('conDocument===>'+conDocument);
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = attach.ParentId;//Add attachment parentId
        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'InternalUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        system.debug('cDocLink===>'+cDocLink);
        DELETE attach;
        return conDocument;
    }
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {

     base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update a;
    }
    @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
}