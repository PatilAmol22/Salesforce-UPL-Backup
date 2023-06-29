global class BrazilActualOrderInsertBatch implements Database.Batchable<sObject>{
    public List <Actual_Order__c> ActualOrderList = new List<Actual_Order__c>();
    
    global BrazilActualOrderInsertBatch(List<Actual_Order__c> ActualOrders){
        ActualOrderList = ActualOrders;
    }
    
    global List<Actual_Order__c> start(Database.BatchableContext bc) {
        return ActualOrderList;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('scope'+scope);
        insert scope;     
    }
    
    global void finish(Database.BatchableContext BC){
    }
}