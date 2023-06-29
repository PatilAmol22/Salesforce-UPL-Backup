/*
* Name: TransactionLogHandler
* Created On: 18 May 2018
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Utility Class is used for adding Transaction Log entries for Brazil Order Module
* Supporting Classes: TransactionLogHandlerTest for Test Coverage
*/
public class TransactionLogHandler {
    public static void addTransactionEntry(Exception exObj, Sales_Order__c soObj){
        Transaction_Log__c tlObj = new Transaction_Log__c();
        tlObj.Sales_Order__c = soObj.Id;
        tlObj.DateTime__c = System.today();
        tlObj.Message__c = 'Exception Occurred: '+exObj.getMessage();
        tlObj.Module_Type__c = 'Brazil Log';
        tlObj.Status__c = 'Exception';
        insert tlObj;
    }    
}