/**
 * Class: 		Grz_BrazilOpenOrderDeleteBatch
 * Test Class: 	Grz_BrazilOpenOrderHandler_Test
 * Called from: Grz_BrazilOpenOrderHandler
 * Author: 		Tanuj Malik (Grazitti)
 * Created: 	13 Feb 2023
 * Purpose: 	This class is responsible for deleting old records.
 * Ticket:		APPS-4744 Open order CR
 */
global class Grz_BrazilOpenOrderDeleteBatch implements Database.Batchable<sObject> {
    public String dm;
    
    global Grz_BrazilOpenOrderDeleteBatch(String mailtime){
        dm = mailtime;          
    }
    
    global Database.querylocator start(Database.BatchableContext BC)
    {
        string query = 'Select Id from Open_order__c WHERE createdDate < '+dm+(Test.isRunningTest()?' LIMIT 200':'');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Open_order__c> scope){
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC){        
    }
}