@isTest
private class TransactionLogHandlerTest {
    //inserting all data into database for testing 
    @testSetup
    static void allTheDataForThisTestClass() {
        Sales_Order__c sobj = new Sales_Order__c(
            SFDC_Order_Number__c = '5645',                    // SFDC Order Number
            SAP_Order_Number__c = '723423423',                // SAP Order Number
            Order_Cancel__c = false,    
            Order_Status__c = 'Not yet processed',             // Order Status
            OrderSubStatus__c = 'Approved',                    // Order Sub-Status
            Flag_Status__c = 'dislike\n',                      // Flag Status
            BrazilOrderSubmittedforApproval__c = false,         // Brazil Order Submitted for Approval
            Currency_Brazil__c = 'Billing USD / Payment USD',  // Currency (Brazil)
            Key_Account__c = false,                            // Key Account
            Valid_From__c = system.today(),
            Valid_To__c = system.today()+350,                  // Valid To
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
    }
    
    static testMethod void methodExceptionHandler(){
        Sales_Order__c sobj = [SELECT Id FROM Sales_Order__c LIMIT 1];
        try{
            CalloutException e = new CalloutException();
            e.setMessage('?Transaction log Exception Coverage for Brazil Order Module');
            throw e;
        }
        catch(Exception ex){
            //Add an entry to Transaction Log
            TransactionLogHandler.addTransactionEntry(ex, sobj);
        }
    }
}