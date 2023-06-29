/**
 * Class: 		Grz_BrazilOpenOrderInsertBatch
 * Test Class: 	Grz_BrazilOpenOrderHandler_Test
 * Called from: Grz_BrazilOpenOrderHandler
 * Author: 		Tanuj Malik (Grazitti)
 * Created: 	13 Feb 2023
 * Purpose: 	This class is responsible for inserting new records 
 * 				based on the information contained within the CSV file.
 * Ticket:		APPS-4744 Open order CR
 */
global class Grz_BrazilOpenOrderInsertBatch implements Database.Batchable<sObject>{
    public List <Open_Order__c> OpenOrderList = new List<Open_Order__c>();
    
    global Grz_BrazilOpenOrderInsertBatch(List<Open_Order__c> OpenOrders){
        OpenOrderList = OpenOrders;
    }
    
    global List<Open_Order__c> start(Database.BatchableContext bc) {
        return OpenOrderList;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        insert scope;     
    }
    
    global void finish(Database.BatchableContext BC){
    }
}