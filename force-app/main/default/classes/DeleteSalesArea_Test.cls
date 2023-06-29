/*
* Name: DeleteSalesArea_Test
* Created On: 07 March 2019
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: Test Class for DeleteSalesArea
    
*/


@isTest
public class DeleteSalesArea_Test {
    public static testmethod void testSalesArea() 
    {
        
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        User userObj = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'RC (Commercial Representative) NUCO Colombia'].Id,
            
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            Country='India',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
            //  UserRoleId =  ur.Id
        );  
        insert userObj;
        
         User userObj1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'RC (Commercial Representative) NUCO Colombia'].Id,
            
            LastName = 'lasts',
            Email = 'pusers000@amamama.com',
            Username = 'pusers000@amamama.com' + System.currentTimeMillis(),
            Country='India',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
            //  UserRoleId =  ur.Id
        );  
        insert userObj1;
        
        
        
        
        
        Sales_Org__c Sales_OrgObj = new Sales_Org__c(
            Name = 'Colombia',           // Sales Org Name
            Company_Code__c = '5700',      // Company Code
            Sales_Org_Code__c = '5710',    // Sales Org Code
            Country_Code__c = 'CO'        // Country Code
        );
        insert Sales_OrgObj;
        
        
        Division__c   DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Distribution_Channel__c Distribution_ChannelObj = new Distribution_Channel__c(
            Name = '67',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '67'  // Distribution Channel Code
        );
        insert Distribution_ChannelObj;
        
        Account accObj = new Account(
            Name = 'ABOCAR RISARALDA SAS',  // Account Name
            RecordTypeId = devRecordTypeId,                        // Account Record Type
            Last_Name__c = 'ABOCAR RISARALDA SAS',             // Last Name
            SAP_Code__c = '0001054681',                        // SAP Customer Code
            Email__c = 'comercial@abocar-risaralda.com',       // Email
            Order_Block__c = false,                            // Order Block
            Account_Type__c = 'Sold To Party',                 // Account Type
            Billing_Street_1__c = 'CARRERA 10  N° 38 B - 20',  // Billing Street 1
         
            Sales_Org__c = Sales_OrgObj.Id,                  // Sales Org
        
            Division__c = DivisionObj.Id,                   // Division Name
            Distribution_Channel__c = Distribution_ChannelObj.Id,       // Distribution Channel
         
            Depot_Code__c = 'CO51',                            // Depot Code
            Payment_Terms__c = '0016'                         // Payment Terms
         
        );
        insert accObj;
        
        Account accObj1 = new Account(
            Name = 'ABOCAR RISARALDA2 SAS',  // Account Name
            RecordTypeId = devRecordTypeId,                        // Account Record Type
            Last_Name__c = 'ABOCAR2 RISARALDA SAS',             // Last Name
            SAP_Code__c = '00010546281',                        // SAP Customer Code
            Email__c = 'comercial@abocar-risaralda.com',       // Email
            Order_Block__c = false,                            // Order Block
            Account_Type__c = 'Sold To Party',                 // Account Type
       
            Billing_Street_1__c = 'CARRERA 10  N° 38 B - 20',  // Billing Street 1
            Sales_Org__c = Sales_OrgObj.Id,                  // Sales Org
            Division__c = DivisionObj.Id,                   // Division Name
            Distribution_Channel__c = Distribution_ChannelObj.Id,       // Distribution Channel
         
            Depot_Code__c = 'CO51',                            // Depot Code
            Payment_Terms__c = '0016'                         // Payment Terms
       
        );
        insert accObj1;
        
        DistributorSalesAreaMapping__c distributorSalesAreaMappingObj = new DistributorSalesAreaMapping__c(
            
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = accObj.Id,          // Distributor
            SalesOrg__c = Sales_OrgObj.Id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            DistributionChannel__c = Distribution_ChannelObj.Id,  // Distribution Channel
            Division__c = DivisionObj.Id,             // Division
            AccountOwner__c = userObj.Id,         // Account Owner
            Manually_Created__c = True                 // Manually Created
        );
        insert distributorSalesAreaMappingObj;
        
        
         DistributorSalesAreaMapping__c distributorSalesAreaMappingObj1 = new DistributorSalesAreaMapping__c(
            
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = accObj1.Id,          // Distributor
            SalesOrg__c = Sales_OrgObj.Id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
           // DistributionChannel__c = Distribution_ChannelObj.Id,  // Distribution Channel
           // Division__c = DivisionObj.Id,             // Division
            AccountOwner__c = userObj1.Id,         // Account Owner
            Manually_Created__c = True                 // Manually Created
        );
        insert distributorSalesAreaMappingObj1;
        
        Credit_Info__c CreditInfoObj = new Credit_Info__c(
            Distributor_Code__c = '00010546815710',// Distributor Code
            Distributor__c = accObj.Id,      // Distributor
            Country__c = 'Colombia',                 // Country
            Credit_Limit__c = 1.00,                  // Credit Limit
            Balance_Limit__c = 1851918.10,           // Balance Limit
            Internal_Limit__c = 0.00,                // Internal Limit
            Percentage_Used__c = 999.00,           // Percentage Used
            Used_Limit__c = 1851919.10,              // Used Limit
            Sum_Open_Item__c = 1851919,          // Outstanding
            Sales_Org__c = Sales_OrgObj.Id        // Sales Org
        );
        insert CreditInfoObj;
        
              
        Account_Statement__c Account_StatementObj = new Account_Statement__c(
            Account__c = accObj.Id,  // Account
            Opening_Balance__c = 0.00,       // Opening Balance
            SAP_Code__c = '00010295685710',    // SAP Code
            Country__c = 'Colombia',           // Country
            Sales_Org__c = Sales_OrgObj.Id  // Sales Org
        );
        insert Account_StatementObj;
        
        
        Shipping_Location__c Shipping_LocationObj = new Shipping_Location__c(
            Location_Name__c = 'ALMACEN INSUAGRO LTDA', // Location Name
            SAP_Code__c = '0001029568',                   // SAP Code
            Distributor__c = accObj.Id,           // Distributor
            City__c = 'FLORENCIA',                        // City
            State__c = '18',                              // State
            Country__c = 'CO',                            // Country
            Billing_Street_3__c = 'CALLE 16 8 - 46',      // Billing Street 3
            Pincode__c = '00000000',                      // Pincode
            Sold_To_Party_SAP_Code__c = '0001029568',     // Sold To Party (SAP Code)
            Combination_Key__c = '00010295680001029568',  // Combination Key
            Country_Name__c = 'Colombia',                 // Country Name
            Sales_Org__c = Sales_OrgObj.Id,             // Sales Org
            Distribution_Channel__c = Distribution_ChannelObj.Id,  // Distribution Channel
            Division__c = DivisionObj.Id              // Division
        );
        insert Shipping_LocationObj;
        
      
      //  Credit_Info__Share Credit_Info__Share 
        
        
        Credit_Info__Share credit_InfoShareObj = new Credit_Info__Share(
            ParentId=CreditInfoObj.Id,
            UserOrGroupId=userObj.Id,
            AccessLevel='Read', 
            RowCause='Manual'
            
        );
        insert credit_InfoShareObj;
        
        //Account_StatementObj
         Account_Statement__Share accountStatementShareObj = new Account_Statement__Share(
            ParentId=Account_StatementObj.Id,
            UserOrGroupId=userObj.Id,
            AccessLevel='Read', 
            RowCause='Manual'
            
        );
        insert accountStatementShareObj;
        
        //Shipping_LocationObj
          Shipping_Location__Share shipping_LocationShareObj = new Shipping_Location__Share(
            ParentId=Shipping_LocationObj.Id,
            UserOrGroupId=userObj.Id,
            AccessLevel='Read', 
            RowCause='Manual'
            
        );
        insert shipping_LocationShareObj;
        
        
        //for Invoice
        Invoice__c InvoiceObj = new Invoice__c(
            Billing_Doc_Number__c = '2110787983',       // Billing Doc Number
            Billing_Date__c = System.today(),  // Billing Date
            PO_Number__c = '2438',                        // PO Number
            Sold_To_Party__c = accObj.Id,         // Sold To Party
            Sales_Org__c = Sales_OrgObj.Id ,             // Sales Org
            Distribution_Channel__c = Distribution_ChannelObj.Id,  // Distribution Channel
            Division__c = DivisionObj.Id              // Division
        );
        insert InvoiceObj;
        
        
          Invoice__Share InvoiceShareObj = new Invoice__Share(
            ParentId=InvoiceObj.Id,
            UserOrGroupId=userObj.Id,
            AccessLevel='Read', 
            RowCause='Manual'
            
        );
        insert InvoiceShareObj;
        
        
        
        
        
        
        
        
        Test.startTest();
        List<Account> accList = [select id from Account];
        System.debug('### In Test Class accList '+accList.size());
        
        List<DistributorSalesAreaMapping__c> DistributorSalesAreaMappingList = [Select Id,Name,Manually_Created__c, Distributor__c  From DistributorSalesAreaMapping__c ];
        delete DistributorSalesAreaMappingList;
       
        Test.stopTest();
        
    }
    
}