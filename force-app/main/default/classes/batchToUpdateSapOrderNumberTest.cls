@isTest
public class batchToUpdateSapOrderNumberTest {
    static testMethod void testSapOrderNumber(){
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        sorg=[SELECT Id,sales_org_code__c from sales_org__c];
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account accObj = new Account(
            Name = 'Test',                                                // Account Name
            Last_Name__c = 'Test Last',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'test@test.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = sorg .Id,
            recordTypeId = RecordTypeId,
            //Division__c = divisionObj.Id,                                               // Division Name
            //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
            
        );
        insert accObj;   
        
        
        
        Sales_Order__c sobj = new Sales_Order__c(            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id            
        );
        insert sobj;
        
        test.startTest();
        batchToUpdateSapOrderNumber obj = new batchToUpdateSapOrderNumber();
        Database.executeBatch(obj);
        test.stopTest();
    }
}