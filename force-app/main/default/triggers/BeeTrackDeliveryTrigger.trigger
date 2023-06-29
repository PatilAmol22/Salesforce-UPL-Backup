trigger BeeTrackDeliveryTrigger on Sales_order_delivery__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    BeeTrackDeliveryTriggerHandler handler = new BeeTrackDeliveryTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert,
                                                                                trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isBefore, trigger.isAfter);
    
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            handler.BeforeInsertEvent();
        }else if(trigger.isUpdate){
            handler.BeforeUpdateEvent();
        }
    }else if(trigger.isAfter){
        if(trigger.isInsert){
            handler.AfterInsertEvent();
        }else if(trigger.isUpdate){
            handler.AfterUpdateEvent();
        }
    }
}