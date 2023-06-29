/* 
* Developer Name : Nandhini Perumalsamy
* Descriptoin: This trigger gets fires when record gets inserted into EmailMessage sObject
* CR: APPS-3946
* Author: EY
* Created Date: 29/12/2022
*/
trigger EmailMessageTrigger on EmailMessage (after insert, before insert) {

    Trigger_Settings__c emailMessageByPass = Trigger_Settings__c.getValues('EmailMessageTrigger');
    if(emailMessageByPass!=null && !emailMessageByPass.IsActive__c) {

      switch on Trigger.operationType {
        when BEFORE_INSERT {//added by Vaishnavi w.r.t CR- APPS-3974
          EmailMessageTriggerhandler.beforeInsert(Trigger.new);  
        }
      }

   /* if(Trigger.isAfter && Trigger.isInsert) {
        EmailMessageTriggerhandler.UpdateCaseStatusToResolved(Trigger.new);  
    }*/
  }
}