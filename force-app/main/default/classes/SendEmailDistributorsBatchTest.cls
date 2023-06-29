@isTest
public class SendEmailDistributorsBatchTest {
    @testSetup
    static void allDataForThisClass(){
         
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Poland';
        salesorg.Description__c='Poland';
        salesorg.Sales_Org_Code__c='2941';
        insert salesorg;
         
         Account acntObj = new Account(
             Name = 'AGROSIMEX SP Z O.O. [View Hierarchy]',  // Account Name
             Last_Name__c = 'AGROSIMEX SP Z O.O.',             // Last Name
             SAP_Code__c = '0001021932',                       // SAP Customer Code
             Order_Block__c = false,                           // Order Block
             Account_Type__c = 'Sold To Party',                // Account Type
             Incoterms_Part_2__c = 'CIP',                      // Incoterms (Part 2)
             //Unproductive_Call_Backend_Support__c = false,     // Unproductive Call (Backend) Support
             Prospect_to_Distributor__c = false,               // Prospect to Distributor
             AuthorizationGroupSalesoffice__c = '',        // Authorization Group (Sales office)
             TaxNumber1__c = '7971581032',                     // Tax Number 1
             Visit_Response__c = 'Red',                        // Visit Response
             LanguageKey__c = 'EN',                            // Language Key
             CountryKey__c = 'IN',                             // Country Key
             Sales_Org__c = salesOrg.Id,                // Sales Org
             ShippingConditions__c = '01',                     // Shipping Conditions
             Division__c = 'a10280000050MKD',                  // Division Name
             Distribution_Channel__c = 'a0x28000001p9hc',      // Distribution Channel
             CustomerAccountGroup__c = 'Z031',                 // Customer Account Group
             Depot_Code__c = 'PD01',                           // Depot Code
             //Inco_Term__c = 'a280k000000S7FV',                 // Inco Term
             Payment_Term_Code1__c = 'PT-4061',                // Payment Term Code
             Payment_Terms__c = 'UK04',                        // Payment Terms
             Distributor_Type_Poland__c = 'Regular Customer',  // Distributor Type Poland
             Is_Fixed_Rate_Available_Italy__c = false,         // Is Fixed Rate Available
             Tax_classification_for_customer__c = '',         // Tax classification for customer
         	 Email__c='abc@gmail.com'
         );
         insert acntObj;
         
     }
    static testMethod void method(){
        Account acntObj=[Select Id from Account limit 1];
        Test.startTest();
        SendEmailDistributorsBatch batchObj=new SendEmailDistributorsBatch();
        Database.executeBatch(batchObj, 1);
        
        SendEmailDistributorScheduler schedulerObj=new SendEmailDistributorScheduler();
        String sch = '0 0 0 25 12 ?'; system.schedule('Poland Christmas Scheduler', sch, schedulerObj);
        Test.stopTest();
    }

}