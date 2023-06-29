/*******************************************************************************************
* @Name         Sales Order Return 
* @Author       Nikhil Dhoke (SKI)
* @Date         03/03/2023
* @Group        SKI
* @Description  This class is used for Sales Order Return Module (Brazil Only).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         	   Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------   
*  1.0             Nikhil Dhoke            03/04/2023            Initial Creation                                        
*******************************************************************************************/
public without sharing class SORAttachmentChildController {
    
    /*
    * @Description - This method will return List of attachments for SOR.
    * @Param String - SOR id.
    * @return  - List of Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static List<AttachmentWrapper> getSORAttachments(String sorId) {
        List<AttachmentWrapper> attachWrapList = new List<AttachmentWrapper>();
        try{
            List<ContentDocumentLink> docList = [SELECT Id, LinkedEntityId, ContentDocument.Title, 
                                                ContentDocument.FileExtension, ContentDocument.FileType, 
                                                ContentDocumentId, ShareType, Visibility FROM 
                                                ContentDocumentLink WHERE LinkedEntityId =: sorId];
            if(docList.size()>0){
                for(ContentDocumentLink doc : docList){
                    AttachmentWrapper atchWrap = new AttachmentWrapper();
                    atchWrap.docId = doc.ContentDocumentId;
                    atchWrap.sorId = doc.LinkedEntityId;
                    atchWrap.name = doc.ContentDocument.Title+'.'+doc.ContentDocument.FileExtension;
                    atchWrap.download = '';

                    attachWrapList.add(atchWrap);
                }
            }                                    

        } catch(Exception e){
            System.debug('getSORAttachments Exception is - '+ e.getMessage());
            System.debug('getSORAttachments Exception at - '+ e.getLineNumber());
        }

        return attachWrapList;
    }

    /*
    * @Description - This method will delete attachment.
    * @Param String - record id.
    * @return  - .
    */
    @AuraEnabled
    public static void deleteContentDocument(Id recordId) {
        try{
            DELETE [SELECT Id FROM ContentDocument WHERE ID=:recordId];
        } catch(Exception e){
            System.debug('deleteContentDocument Exception is - '+ e.getMessage());
            System.debug('deleteContentDocument Exception at - '+ e.getLineNumber());
        }    
    }

    /* @AuraEnabled(cacheable=true)
    public static Map<ID, ContentVersion> fetchFiles(String recordId) {
        // Get record file IDs        
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }
 
        List<ContentVersion> docs = [SELECT ContentDocumentId,Title 
            FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
        Map<ID, ContentVersion> mapIdTitle = new Map<ID, ContentVersion>();
        for (ContentVersion docLink : docs) {
            mapIdTitle.put(docLink.ContentDocumentId, docLink);
        }
        return mapIdTitle;
    } */   

    public class AttachmentWrapper{
        @AuraEnabled public String docId;
        @AuraEnabled public String sorId;
        @AuraEnabled public String name;
        @AuraEnabled public String download;
        @AuraEnabled public Boolean isEdit;

        public AttachmentWrapper(){
            docId = '';
            sorId = '';
            name = '';
            download = '';
            isEdit = false;
        }

    }
}