global class Grz_StockMngementInsertBatch implements Database.Batchable<sObject>{
    public List <Stock_Management__c> stockList = new List<Stock_Management__c>();
    
    global Grz_StockMngementInsertBatch(List<Stock_Management__c> stock){
        stockList = stock;          
    }
    
    global List<Stock_Management__c> start(Database.BatchableContext bc) {
        return stockList;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        insert scope;     
    }
    
    global void finish(Database.BatchableContext BC){
    }
}