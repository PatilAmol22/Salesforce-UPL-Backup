public with sharing class SendFailedSMSBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
   public Database.QueryLocator start(Database.BatchableContext BC) {
       String status = 'Failed';
       String exceptionMessage = 'CALLOUT EXCEPTION%';
       String objectName = 'Account';
       String query = 'Select id, {0}, smagicinteract__external_field__c, smagicinteract__sentStatus__c, smagicinteract__SMSText__c, smagicinteract__PhoneNumber__c, smagicinteract__SenderId__c, smagicinteract__Source__c, smagicinteract__Message_Type__c, smagicinteract__ObjectType__c, smagicinteract__statusMessage__c, smagicinteract__disableSMSOnTrigger__c from smagicinteract__smsMagic__c where smagicinteract__sentStatus__c = :status and smagicinteract__statusMessage__c LIKE :exceptionMessage and smagicinteract__ObjectType__c =:objectName and CreatedDate >= 2017-11-16T00:00:00.000Z order by CreatedDate desc';
       query = String.format(query, new List<String> {String.join(getLookupFields(), ', ')});
       return Database.getQueryLocator(query);
   }
   public void execute(Database.BatchableContext BC, List<sObject> scope) {
       if(scope == null || scope.isEmpty()){
           return;
       }
       List<smagicinteract__smsMagic__c> smsList = (List<smagicinteract__smsMagic__c>) scope;
       String response = smagicinteract.ApexAPI.pushSMSCallout(smsList);
       if(String.isNotBlank(response) && !response.startsWith('Callout Error')) {
           for(smagicinteract__smsMagic__c rec : smsList) {
               rec.smagicinteract__sentStatus__c = 'Submited';
           }
           update smsList;
       }
   }
   public void finish(Database.BatchableContext BC) {}
   private static List<String> getLookupFields() {
       List<String> fields = new List<String>();
       Map<String, Schema.sObjectField> fieldMap = Schema.SObjectType.smagicinteract__smsMagic__c.fields.getMap();
       for(String str:  fieldMap.keySet()) {
           Schema.DescribeFieldResult F = fieldMap.get(str).getDescribe();
           if(F.getType() == Schema.Displaytype.REFERENCE && F.getRelationshipName() != null && F.getReferenceTo().size() == 1 && F.isCustom()) {
               fields.add(F.getName());
           }
       }
       return fields;
   }
}