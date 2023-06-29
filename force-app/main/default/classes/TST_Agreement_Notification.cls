/* Name : TST_Agreement_Notification
* Covergae Class : BCH_Agreement_Notification, SCH_Agreement_Notification
* Created By: Varun Shrivastava
* Created Date: 7 May 2021
* Ticket: SCTASK0381589
*/
@isTest(seeAllData=False)
private class TST_Agreement_Notification {
    @Testsetup
    static void setupTestData(){
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'France';
        sorg.Sales_Org_Code__c = '2710';
        insert sorg;
        
        Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC';
        insert div;      
       
        Distribution_Channel__c dChannel =  new Distribution_Channel__c();
        dChannel.Name = '10';
        dChannel.Distribution_Channel_Code__c = '10';
        
        Depot__c dep = new Depot__c(
            Name = 'UPL Do Brasil - Aparecida de Goiania',   // Depot Name
            Country__c = 'Brazil',                           // Country
            Depot_Code__c = 'BR04',                          // Depot Code
            Active__c = true,                                // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep;
        
        Profile p =  [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1];                     //Brazil Sales Person Profile
        
        User userTerMan1 = new User(
            Alias = 'WES',                                                             // Alias
            Email = 'varshriv@upl-ltd.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = '20205489@uniphos3.com.upltest',                                     // Username
            IsActive = true,                                                               // Active
            LastName = 'BARBOSA DErCAMARGO', 
            CommunityNickname = 'Xyu ',                                                // Nickname
            Title = 'RuiR',                                                              // Title
            TimeZoneSidKey = 'America/Sao_Paulo',      
            LocaleSidKey = 'en_IN',                                            
            LanguageLocaleKey = 'pt_BR',                                                 // Language
            ForecastEnabled = false,                                                       // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',   
            Territory__c = 'Araxá',                                              // Territory
            EnableDepot__c = false,                                                        // Enable Depot
            Show_List_Value__c = false,                                                    // Show List Value (Brazil)
            Show_Credit_LIMIT__c = false,                                                  // Show Credit LIMIT
            Show_Inventory__c = false,                                                     // Show Inventory
            Show_Pricing__c = false,                                                       // Show Pricing
            Show_Inventory_Column__c = false,                                              // Show Inventory Column
            Show_InTransit__c = false,                                                     // Show InTransit
            Show_InTransit_Values__c = false , 
            country = 'Brazil'
        );
        insert userTerMan1;
        
        
        Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATO';
        acc.Email__c = 'ganesh039@gmail.com';
        acc.Last_Name__c = 'PASSINATO';
        acc.SAP_Code__c = '2028843';
        acc.RecordTypeId = devRecordTypeId;
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.Division__c = Div.Id;
        acc.Distribution_Channel__c = dChannel.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Depot_Code__c = dep.Id;
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        acc.key_account_manager__c = userTerMan1.Id;
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
        
        Agrement_clients__c agreementRecord = new Agrement_clients__c();
        agreementRecord.Expiration_Date_France__c = Date.today();
        agreementRecord.Customer_Name__c = acc.ID;
        insert agreementRecord;
    }
    
    static testMethod void checkCoverage(){
        Test.startTest();
        SCH_Agreement_Notification sch = new SCH_Agreement_Notification();
		String croneExpression = '0 30 13 1/1 * ? *';
		String jobID = system.schedule('Test Agreement Notification', croneExpression, sch);
        Test.stopTest();
    }
}