trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update) {
    if(Trigger.isInsert && Trigger.isAfter && OpportunityLineItemTriggerHandler.isTriggerFire){
        Set<Id> qliIds = Trigger.newMap.keyset();
        System.debug('qliIds at Trigger '+qliIds);
        OpportunityLineItemTriggerHandler.sync(qliIds);
    }
    
    
    if(Trigger.isUpdate && Trigger.isAfter && OpportunityLineItemTriggerHandler.isTriggerFire){
        
    }
}