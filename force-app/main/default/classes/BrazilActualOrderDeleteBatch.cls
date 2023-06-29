global class BrazilActualOrderDeleteBatch implements Database.Batchable<sObject> {
    public String dm;
    
    global BrazilActualOrderDeleteBatch(String mailtime){
        dm = mailtime;          
    }
    
    global Database.querylocator start(Database.BatchableContext BC)
    {
        string query = 'Select Id from Actual_Order__c WHERE createdDate < '+dm+(Test.isRunningTest()?' LIMIT 200':'');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Actual_Order__c> scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){        
    }
}