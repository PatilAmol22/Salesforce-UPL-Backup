trigger atmTrigger on AccountTeamMember (after insert,before delete) {
 if( Trigger_Settings__c.getValues('atmTrigger').isActive__c ){
 if(Trigger.isInsert){
    atmTriggerHandler.shareSalesOrder(Trigger.new);
   }
 if(Trigger.isDelete){
   atmTriggerHandler.deleteShareSalesOrder(Trigger.Old);
   }   
   }                            
}