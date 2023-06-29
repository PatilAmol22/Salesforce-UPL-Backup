/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for ShareSalesOrdersCreditInfoWithAccount
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Swapnil More   <swapnil.more@in.ibm.com>
* @modifiedBy     Swapnil More   <swapnil.more@in.ibm.com>
* @maintainedBy   Swapnil More   <swapnil.more@in.ibm.com>
* @version        1.0
* @created        2020-04-17
* @modified       2020-04-17
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class testShareSalesOrders {
    @testSetup
    static void allTheDataForThisTestClass() {
        insertUser();
        insertUser1();
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        sorg=[SELECT Id,sales_org_code__c from sales_org__c];
        
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
            Sales_Org__c = sorg .Id,                                              // Sales Org
            //Division__c = divisionObj.Id,                                               // Division Name
            //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'
            
            
        );
        insert accObj;
        
       
        
        
        // Create a fake response
        Sales_Order__c sobj = new Sales_Order__c(            
            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            SDM_Approval_On_Order_Cancellation__c=2,
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id,
            sales_org_lk__c = sorg.Id,
            createdDate = System.today()
            
        );
        
        insert sobj;
        
       invoice__c I = new Invoice__c(
        Sold_to_Party__c = accObj.Id,
        Sales_Order__c = sobj.Id,
        Sales_Org__c = sorg.Id
        );
        insert I;
        
        
        
    }
    
    @future
    public static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Brazil Sales Person'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='Brazil Sales Price Admin'];
        User futureUser = new User(firstname = 'Future', lastname = 'User',
                                   alias = 'future', defaultgroupnotificationfrequency = 'N',
                                   digestfrequency = 'N', email = 'test@test.org',
                                   emailencodingkey = 'UTF-8', languagelocalekey='en_US', 
                                   localesidkey='en_US', profileid = p.Id, 
                                   timezonesidkey = 'America/Los_Angeles',
                                   username = 'futureuser7757@test.org',
                                   userpermissionsmarketinguser = false,
                                   userpermissionsofflineuser = false, userroleid = r.Id);
        insert(futureUser);
    }
    
    @future
    public static void insertUser1() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Brazil Sales Person'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='Brazil Sales Price Admin'];
        User futureUser = new User(firstname = 'Future1', lastname = 'User1',
                                   alias = 'future', defaultgroupnotificationfrequency = 'N',
                                   digestfrequency = 'N', email = 'test1@test.org',
                                   emailencodingkey = 'UTF-8', languagelocalekey='en_US', 
                                   localesidkey='en_US', profileid = p.Id, 
                                   timezonesidkey = 'America/Los_Angeles',
                                   username = 'futureuser8652@test.org',
                                   userpermissionsmarketinguser = false,
                                   userpermissionsofflineuser = false, userroleid = r.Id);
        insert(futureUser);
    }
    
    @isTest static void TestMethod1() {
        Account a = [select id, Key_account_Manager__c from account limit 1];
        
        user u = [select id from user where firstname = 'Future' limit  1];
        user u1 = [select id from user where firstname = 'Future1' limit  1];
        a.Key_Account_Manager__c = a.id;
        //update a;
        List<ShareSalesOrdersCreditInfoWithAccount.WrapperInputParameters> liWIP = 
            new List<ShareSalesOrdersCreditInfoWithAccount.WrapperInputParameters>();
        ShareSalesOrdersCreditInfoWithAccount.WrapperInputParameters WIP = new ShareSalesOrdersCreditInfoWithAccount.WrapperInputParameters();
        WIP.AccId = a.id;
        WIP.OldKAM = u.Id;
        WIP.NewKAM = u.Id;
        liWIP.add(WIP);
        ShareSalesOrdersCreditInfoWithAccount.GrantRemoveAccess(liWIP);
        
        WIP.AccId = a.id;
        WIP.OldKAM = u.Id;
        WIP.NewKAM = u.Id;
        liWIP.add(WIP);
        ShareSalesOrdersCreditInfoWithAccount.GrantRemoveAccess(liWIP);
        
        WIP.AccId = a.id;
        WIP.OldKAM = u1.Id;
        WIP.NewKAM = u1.Id;
        liWIP.add(WIP);
        ShareSalesOrdersCreditInfoWithAccount.GrantRemoveAccess(liWIP);
    }
    
}