@isTest
private class CopyDDOnKYC_Test{
	@isTest
    static void testmethod1(){
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId(); 
        Id kycPassportRecId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        Id kycPanCardRecId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();
        
        System.debug('devRecordTypeIdAcc  ==>'+devRecordTypeIdAcc);
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='PG001';
        insert PGObj;
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert sOrg;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers' LIMIT 1];
        
        User usr1 = new User(
            // UserRole = 'undefined',
            firstname = 'Vikas',                                // Role
            lastName = 'Chavan', 
            Alias = 'vchavn',                                                                   // Alias
            Email = 'shama.buchade@skinternational.com',                                       // Email
            ProfileId = profileId.Id,                                                             // Profile
            Username = 'vc@uniphos.com.upltest',                                         // Username
            IsActive = true,                                                                   // Active
            CommunityNickname = 'vikas.chavannn',  // Nickname
            TimeZoneSidKey = 'Asia/Kolkata',                 // Time Zone
            LocaleSidKey = 'en_US',                                                  // Locale
            LanguageLocaleKey = 'en_US',                                                     // Language
            ForecastEnabled = false,                                                           // Allow Forecasting
            Phone = '7722034447',                                                    // Phone
            EmailEncodingKey = 'ISO-8859-1',        // Email Encoding
            // TM_Code__c = '01205184',                                                           // TM Code
            //SAP_User_Password__c = 'init123',                                                  // SAP User Password
            Zone__c = 'Pune',                                                                  // Zone
            //EnableDepot__c = true,                                                             // Enable Depot
            Show_List_Value__c = false,                                                        // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                       // Show Credit Limit
            Show_Inventory__c = true,                                                          // Show Inventory
            Show_Pricing__c = false,                                                           // Show Pricing
            Show_Inventory_Column__c = true,                                                   // Show Inventory Column
            Show_InTransit__c = false,                                                         // Show InTransit
            Show_InTransit_Values__c = false                                                  // Show InTransit Values
        );
        insert usr1;
        
        Division__c divObj = new Division__c();
        divObj.Name = 'Fertilizer Division';
        divObj.Division_Code__c = '10';
        insert divObj;
        
        Pin_Code__c pCode = new Pin_Code__c();
        pCode.Name = '400014';
        pCode.District__c = 'Mumbai';
        insert pCode;
        
        State_Tax_Structure__c sTax = new State_Tax_Structure__c();
        sTax.State_Name__c = 'Maharashtra';
        sTax.State_Code__c = '13';
        sTax.SalesOrg__c = sOrg.Id;
        sTax.GST_State_Code__c = '27';
        insert sTax;       
        
        HANA_Authentication__c credentials = new HANA_Authentication__c();
        credentials.Name = 'HANA Credentials';
        credentials.Endpoint__c = 'https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/CustomerOnBoarding';
        credentials.Username__c = 'S0003263313';
        credentials.Password__c = 'Aj@12345';
        insert credentials;
        
        Account acc = new Account();
        acc.Name='Ketan';
        acc.Last_Name__c='Khatri';
        //acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeIdAcc;
        acc.PriceGroupCode__c=PGObj.Id;
        acc.Mobile__c='9967341759';
        acc.Phone='0202356589';
        acc.Sales_Org__c = sOrg.Id;
        acc.Callout_Set__c = False;
        acc.ApprovalStatus__c = 'Open';
        acc.RegionalManager__c = usr1.Id;
        acc.ZonalHead__c = usr1.Id;
        acc.SBUHead__c = usr1.Id;
        acc.Country__c='India';
        acc.Division__c = divObj.Id;
        acc.BillingCity = 'Mumbai';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'DSP';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode= '400014';
        acc.PAN_Number__c = 'DLEPK3323L';
        acc.State_Tax_Structure__c = sTax.Id;
        acc.Tax_Number_3__c = '27DLEPK3323LAAA';
        acc.DealerDistributorShortName__c = null;
        acc.DealerDistributorShortNamec1__c = 'Sname';
        
        acc.Payment_Term_Code1__c ='0014';
        acc.State_Code1__c ='27';
        acc.Partner_Function_Code__c ='Z1';
        acc.Division_Code__c ='10';
        acc.Prospect_to_Distributor__c =false;
        acc.Central_Admin_Comment__c ='';
        acc.Depot_Code__c ='SEC1';
        acc.Country__c = 'Other';
        insert acc;
        
         kyc__c kyc = new KYC__c();
        kyc.Account__c = acc.Id;
        kyc.Name = 'Test';
        kyc.recordtypeId = kycPassportRecId ;//Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        
        INSERT kyc;
        
        kyc__c kyc1 = new KYC__c();
        kyc1.Account__c = acc.Id;
        kyc1.Name = 'Test';
        kyc1.recordtypeId = kycPanCardRecId ; // Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();
        
        INSERT kyc1;
        
        DistributorDocument__c dcObj1 = new DistributorDocument__c();
        dcObj1.Document_Name__c='Test';
        dcObj1.Distributor__c=acc.Id;
        dcObj1.Description__c='test';
        dcObj1.Document_List__c='Passport';
        dcObj1.Documents_Type__c ='Passport';
        insert dcObj1;
        
        
       
        
        
        
    }
    
    
    
}