/**
 * @description       : 
 * @author            : Amol Patil
 * @group             : SKI
 * @last modified onC  : 08-10-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AttachmentTriggerHandler implements ITriggerHandler {
    
public Trigger_Settings__c triggerMetaData = new Trigger_Settings__c();

public AttachmentTriggerHandler() {}
    public AttachmentTriggerHandler(String setttingName){
        triggerMetaData = [select id,Name,ObjectName__c,IsActive__c from Trigger_Settings__c where Name=:setttingName];
        }

        public Boolean isDisabled(){
            system.debug('Attachment Active ='+ triggerMetaData.IsActive__c);
        return !triggerMetaData.IsActive__c;
    }
    

    public void beforeInsert(List<Sobject> newItems){}

    public void beforeUpdate(Map<Id,SObject> oldItems,Map<Id,Sobject> newItems){}

    public void beforeDelete(Map<Id, SObject> oldItems) {}
    
    public void afterInsert(Map<Id, SObject> newItems) {

    
        AttachmentTriggerHelper.updateMassUploadCSV(newItems);

    }
    
    public void afterUpdate(Map<Id, SObject> oldItems, Map<Id, SObject> newItems) {
        
      
        
    }
    
    public void afterDelete(Map<Id,SObject> oldItems,Map<Id,Sobject> newItems) {}
    
    public void afterUndelete(Map<Id, SObject> oldItems) {}

    }


