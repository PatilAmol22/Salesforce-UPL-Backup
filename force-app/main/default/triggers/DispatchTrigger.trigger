trigger DispatchTrigger on Dispatch__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    DispatchTriggerHandler handler = new DispatchTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert,
                                                                                trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isBefore, trigger.isAfter);
    
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            handler.AfterInsertEvent();
        }else if(trigger.isUpdate){
            handler.AfterUpdateEvent();
        }
    }
}