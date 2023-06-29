trigger OfflineOrderTrigger on Offline_Mobile_Order__c (before insert) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            System.debug('OfflineOrderHandler==>');
            OfflineOrderHandler.beforeInsert(Trigger.new);
        }
    }
}