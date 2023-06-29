@isTest
public class BrazilHANAServiceHelper_Test {
    static testMethod void method5(){
        
        Account acc2 = new Account();
        acc2.Name='SK INTERNATIONAL';
        acc2.Email__c = 'ganesh0339@gmail.com';
        acc2.Last_Name__c='INTERNATIONAL';
        acc2.SAP_Code__c='2028845';
        acc2.Mobile__c='9967341759';
        acc2.Phone='01234567891';
        acc2.BillingCity='MINEIROS';
        acc2.Tax_Number_3__c='114415457';
        acc2.Tax_Number_1__c='114411425';
        acc2.Customer_Region__c='AC';
        acc2.Customer_Group__c='005';
        acc2.Program_Margin_Discount__c=0.00;
        acc2.Active__c=true;
        acc2.Search_Terms_1__c='SK INTERNATIONAL';
        acc2.Search_Terms_2__c='FAZ SEUBAK2';
        insert acc2;
        
        Sales_Order__c sobj = new Sales_Order__c(
            Order_Cancel__c = false,    
            Order_Status__c = 'Not yet processed',             // Order Status
            OrderSubStatus__c = 'Approved',                    // Order Sub-Status
            RequestforCancellationCheck__c = false,            // Request for Cancellation
            Flag_Status__c = 'dislike\n',                      // Flag Status
            BrazilOrderSubmittedforApproval__c = true,         // Brazil Order Submitted for Approval
            
            Currency_Brazil__c = 'Billing USD / Payment USD',  // Currency (Brazil)
            Key_Account__c = false,                            // Key Account
            Sold_to_Party__c = acc2.Id,                        // Sold to Party
            Valid_From__c = system.today(),
            Valid_To__c = system.today()+350,                  // Valid To
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,         // Sale Order
            Item_Number__c = 10,                       // Item Number
            CurrencyIsoCode = 'BRL',
            Item_Status__c = 'Not yet processed',      // Item Status
            Item_Cancel__c = false,                    // Item Cancel
            Order_Item_Key__c = '836010',              // OrderNumber_Item_Key
            Approval_Flag__c = 0,                      // Approval Flag
            OrderQuantityEdited__c = false,            // Order Quantity Edited
            Time_in_months__c = 0,                     // Time in months
            Days__c = 0,
            Customer_Conversion_Factor__c =1,// Days
            DateofFAT__c =  system.today()+1,
            Quantity__c = 450.00,                      // Quantity
            UnitValue__c = 100.00,                     // Unit Value
            UnitValuewithInterest__c = 100.00,         // Unit Value with Interest
            InterestRate__c = 0.00,                    // Interest Rate
            TotalTax__c = 0.00,                        // Total Tax
            TotalFreight__c = 0.00,                    // Total Freight
            TotalPunctuality__c = 0.00,                // Total Punctuality
            TotalLedgerCost__c = 0.00,                 // Total Ledger Cost
            TotalReplacementCost__c = 0.00            // Total Replacement Cost
        );
        insert soLineItm; 
        List<Id> IDString = new List<ID>();
        IDString.add(sobj.Id); 
        test.startTest();
        BrazilHANAServiceHelper.callHanaService(IDString);
        BrazilHANAServiceHelper.callHANAFromAction(sobj.Id);
        BrazilHANAServiceHelper.pushSalesOrder(sobj.Id);
        BrazilHANAServiceHelper.pushMaefil(sobj.Id);
        test.stopTest();
    }
}