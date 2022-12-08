/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-10-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AttachmentTriggerHelper {

    public AttachmentTriggerHelper() {

    }

    public static void updateMassUploadCSV(Map<Id, SObject> newItems){

        List<Attachment> attachments = (List<Attachment>) newItems.values();
        List<String> parentIds = new List<String>();
        for(Attachment attachObj:attachments){
            parentIds.add(attachObj.ParentId);
        }
        
        List<Mass_Upload_CSV__c> massUploadCSVs = [SELECT Id,isAttachment__c FROM Mass_Upload_CSV__c WHERE Id IN : parentIds];
        for(Mass_Upload_CSV__c massUpload: massUploadCSVs){
            massUpload.isAttachment__c = true;
        }
    }
}
