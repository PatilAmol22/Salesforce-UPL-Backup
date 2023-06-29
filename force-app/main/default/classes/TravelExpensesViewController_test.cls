@isTest
public class TravelExpensesViewController_test{
    
    public Static TestMethod void travelExpenseView(){
        
        
        
        Monthly_Travel_Expense__c MTEObj = new Monthly_Travel_Expense__c(
            Month__c = 'APR 2018',                          // Month
            Status__c = 'Pending by RM',                      // Status
           SubmittedforApproval__c = true                    // Submitted for Approval
        );
        insert MTEObj; 
        
        Expense_Item__c ExpenseObj = new Expense_Item__c(
            Item__c = 'AIRPORT TAX - BASE ON BILL',        // Item
            Amount__c = 120.00,                              // Amount
            Location__c = 'test by sk',                      // Location
            Monthly_Travel_Expenses__c = MTEObj.id,  // Monthly Travel Expense
            Purpose__c = 'test',                             // Purpose
            Remarks__c = 'test again 2nd time',              // Remarks
            Month__c = 'APR 2018'                           // Month

            
        );
        insert ExpenseObj;
        ApexPages.currentPage().getParameters().put('id',MTEObj.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(MTEObj);
        TravelExpensesViewController TvlExctrlObj = new TravelExpensesViewController(sc);
        TvlExctrlObj.createCummulativeActivity();
        
    }
    
    
}