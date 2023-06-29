global class Grz_StockMngementDeleteBatch implements Database.Batchable<sObject> {
    public String dm;
    
    global Grz_StockMngementDeleteBatch(String mailtime){
        dm = mailtime;          
    }
    
    global Database.querylocator start(Database.BatchableContext BC)
    {
        string query = 'Select Id from Stock_Management__c WHERE createdDate < '+dm;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Stock_Management__c> scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){        
    }
}