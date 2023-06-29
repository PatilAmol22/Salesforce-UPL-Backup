/*
Author Name :- Vishal Pawar
Description : This Test Class is use for AccountOnBoardingTrigger
Date :- 30.01.2020
*/


@isTest
public class AccountOnBoardingTrig_Test {
    @isTest static void testMethod1(){
        
        List<DistributorDocument__c> dDocList = new List<DistributorDocument__c>();
        
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
        System.debug('devRecordTypeIdAcc  ==>'+devRecordTypeIdAcc);
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='03';
        insert PGObj;
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert sOrg;
        
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
        sTax.GST_State_Code__c = '27';
        sTax.SalesOrg__c = sOrg.Id;
        insert sTax;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        TM_Depot_Mapping__c tdmObj = new TM_Depot_Mapping__c();
        tdmObj.Depot__c = dp.Id;
        tdmObj.Depot_Name__c = 'Pune';
        tdmObj.Territory_Manager__c = usr1.Id;
        insert tdmObj;
        
        
        Account acc = new account();
        acc.Name = 'Pagani Zonda';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        acc.PriceGroupCode__c=PGObj.Id;
        acc.Mobile__c='9967341759';
        acc.Phone='0203256589';
        acc.Sales_Org__c = sOrg.Id;
        acc.Callout_Set__c = False;
        acc.ApprovalStatus__c = 'Open';
        acc.TM_Depot_Mapping__c = tdmObj.Id;
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
        acc.CreatedById = usr1.Id;
        acc.Payment_Term_Code1__c ='0014';
        acc.State_Code1__c ='27';
        acc.Partner_Function_Code__c ='Z1';
        acc.Division_Code__c ='10';
        acc.Prospect_to_Distributor__c =false;
        acc.Central_Admin_Comment__c ='';
        acc.Depot_Code__c ='SEC1';        
        insert acc;
        
        Test.startTest();
        
        DistributorDocument__c dcObj1 = new DistributorDocument__c();
        dcObj1.Document_Name__c='Test';
        dcObj1.Distributor__c=acc.Id;
        dcObj1.Description__c='test';
        dcObj1.Document_List__c='Photograph (Owner)';
        dDocList.add(dcObj1);
        insert dcObj1;
        //delete dcObj1;
        
        DistributorDocument__c dcObj2 = new DistributorDocument__c();
        dcObj2.Document_Name__c='Test';
        dcObj2.Distributor__c=acc.Id;
        dcObj2.Description__c='test';
        dcObj2.Document_List__c='Photograph (Selfie with Customer)';
        dDocList.add(dcObj2);
        insert dcObj2;
        // delete dcObj2;
        
        
        
        DistributorDocument__c dcObj3 = new DistributorDocument__c();
        dcObj3.Document_Name__c='Test';
        dcObj3.Distributor__c=acc.Id;
        dcObj3.Description__c='test';
        dcObj3.Document_List__c='Photograph (Shop)';
        dDocList.add(dcObj3);
        insert dcObj3;
        // delete dcObj3;
        
        DistributorDocument__c dcObj4 = new DistributorDocument__c();
        dcObj4.Document_Name__c='Test';
        dcObj4.Distributor__c=acc.Id;
        dcObj4.Description__c='test';
        dcObj4.Document_List__c='Security cheques along with deceleration annexure';
        dDocList.add(dcObj4);
        insert dcObj4;
        //delete dcObj4;
        
        DistributorDocument__c dcObj5 = new DistributorDocument__c();
        dcObj5.Document_Name__c='Test';
        dcObj5.Distributor__c=acc.Id;
        dcObj5.Description__c='test';
        dcObj5.Document_List__c='Copy of Pesticide / Seed License';
        dDocList.add(dcObj5);
        insert dcObj5;
        //delete dcObj5;
        
        DistributorDocument__c dcObj6 = new DistributorDocument__c();
        dcObj6.Document_Name__c='Test';
        dcObj6.Distributor__c=acc.Id;
        dcObj6.Description__c='test';
        dcObj6.Document_List__c='GST certificate/ customer deceleration for NON-REGISTERED GSTN';
        dDocList.add(dcObj6);
        insert dcObj6;
        //delete dcObj6; 
        
        
        DistributorDocument__c dcObj7 = new DistributorDocument__c();
        dcObj7.Document_Name__c='Test';
        dcObj7.Distributor__c=acc.Id;
        dcObj7.Description__c='test';
        dcObj7.Document_List__c='Copy of Partnership Firm/ Company/HUF/Prop. Affidavit';
        dDocList.add(dcObj7);
       // insert dcObj7;
        Test.stopTest();  
    }
    
    @isTest static void testMethod2(){
        
        List<DistributorDocument__c> dDocList = new List<DistributorDocument__c>();
        
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
        System.debug('devRecordTypeIdAcc  ==>'+devRecordTypeIdAcc);
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='03';
        insert PGObj;
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert sOrg;
        
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
        sTax.GST_State_Code__c = '27';
        sTax.SalesOrg__c = sOrg.Id;
        insert sTax;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        TM_Depot_Mapping__c tdmObj = new TM_Depot_Mapping__c();
        tdmObj.Depot__c = dp.Id;
        tdmObj.Depot_Name__c = 'Pune';
        tdmObj.Territory_Manager__c = usr1.Id;
        insert tdmObj;
        
        
        Account acc = new account();
        acc.Name = 'Pagani Zonda';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        acc.PriceGroupCode__c=PGObj.Id;
        acc.Mobile__c='9967341759';
        acc.Phone='0203256589';
        acc.Sales_Org__c = sOrg.Id;
        acc.Callout_Set__c = False;
        acc.ApprovalStatus__c = 'Open';
        acc.TM_Depot_Mapping__c = tdmObj.Id;
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
        acc.CreatedById = usr1.Id;
        acc.Payment_Term_Code1__c ='0014';
        acc.State_Code1__c ='27';
        acc.Partner_Function_Code__c ='Z1';
        acc.Division_Code__c ='10';
        acc.Prospect_to_Distributor__c =false;
        acc.Central_Admin_Comment__c ='';
        acc.Depot_Code__c ='SEC1';        
        insert acc;
        
        
         Test.startTest();
        
        DistributorDocument__c dcObj1 = new DistributorDocument__c();
        dcObj1.Document_Name__c='Test';
        dcObj1.Distributor__c=acc.Id;
        dcObj1.Description__c='test';
        dcObj1.Document_List__c='Signed Business Policy';
        dDocList.add(dcObj1);
        insert dcObj1;
        delete dcObj1;
        
        
        
        DistributorDocument__c dcObj2 = new DistributorDocument__c();
        dcObj2.Document_Name__c='Test';
        dcObj2.Distributor__c=acc.Id;
        dcObj2.Description__c='test';
        dcObj2.Document_List__c='Blank Letter Pad for Address Proof';
        dDocList.add(dcObj2);
        insert dcObj2;
        delete dcObj2;
        
        
        DistributorDocument__c dcObj10 = new DistributorDocument__c();
        dcObj10.Document_Name__c='Test';
        dcObj10.Distributor__c=acc.Id;
        dcObj10.Description__c='test';
        dcObj10.Document_List__c='PAN Card';
        dDocList.add(dcObj10);
        insert dcObj10;
        delete dcObj10;
        
       Test.stopTest();
        
    }
    
    
    
     @isTest static void testMethod3(){
        
        List<DistributorDocument__c> dDocList = new List<DistributorDocument__c>();
        
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
        System.debug('devRecordTypeIdAcc  ==>'+devRecordTypeIdAcc);
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='03';
        insert PGObj;
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert sOrg;
        
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
        sTax.GST_State_Code__c = '27';
        sTax.SalesOrg__c = sOrg.Id;
        insert sTax;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        TM_Depot_Mapping__c tdmObj = new TM_Depot_Mapping__c();
        tdmObj.Depot__c = dp.Id;
        tdmObj.Depot_Name__c = 'Pune';
        tdmObj.Territory_Manager__c = usr1.Id;
        insert tdmObj;
        
        
        Account acc = new account();
        acc.Name = 'Pagani Zonda';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        acc.PriceGroupCode__c=PGObj.Id;
        acc.Mobile__c='9967341759';
        acc.Phone='0203256589';
        acc.Sales_Org__c = sOrg.Id;
        acc.Callout_Set__c = False;
        acc.ApprovalStatus__c = 'Open';
        acc.TM_Depot_Mapping__c = tdmObj.Id;
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
        acc.CreatedById = usr1.Id;
        acc.Payment_Term_Code1__c ='0014';
        acc.State_Code1__c ='27';
        acc.Partner_Function_Code__c ='Z1';
        acc.Division_Code__c ='10';
        acc.Prospect_to_Distributor__c =false;
        acc.Central_Admin_Comment__c ='';
        acc.Depot_Code__c ='SEC1';        
        insert acc;
        
        
         Test.startTest();
        
        DistributorDocument__c dcObj1 = new DistributorDocument__c();
        dcObj1.Document_Name__c='Test';
        dcObj1.Distributor__c=acc.Id;
        dcObj1.Description__c='test';
        dcObj1.Document_List__c='Dealer booklet';
        dDocList.add(dcObj1);
        insert dcObj1;
        delete dcObj1;
         
         //Annexure of declaration of relation
        
         DistributorDocument__c dcObj11 = new DistributorDocument__c();
        dcObj11.Document_Name__c='Test';
        dcObj11.Distributor__c=acc.Id;
        dcObj11.Description__c='test';
        dcObj11.Document_List__c='Annexure of declaration of relation';
        dDocList.add(dcObj11);
        
        insert dcObj11;
         delete dcObj11;
         
         DistributorDocument__c dcObj34 = new DistributorDocument__c();
         dcObj34.Document_Name__c='Test';
         dcObj34.Distributor__c=acc.Id;
         dcObj34.Description__c='test';
         dcObj34.Document_List__c='Annexure of declaration of signing documents';
         dDocList.add(dcObj34);
         
         insert dcObj34;
         delete dcObj34;
         
        
         
       Test.stopTest();
        
    }
    
    
    
     @isTest static void testMethod4(){
        
        List<DistributorDocument__c> dDocList = new List<DistributorDocument__c>();
        
        Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
        System.debug('devRecordTypeIdAcc  ==>'+devRecordTypeIdAcc);
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='03';
        insert PGObj;
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert sOrg;
        
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
        sTax.GST_State_Code__c = '27';
        sTax.SalesOrg__c = sOrg.Id;
        insert sTax;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        TM_Depot_Mapping__c tdmObj = new TM_Depot_Mapping__c();
        tdmObj.Depot__c = dp.Id;
        tdmObj.Depot_Name__c = 'Pune';
        tdmObj.Territory_Manager__c = usr1.Id;
        insert tdmObj;
        
        
        Account acc = new account();
        acc.Name = 'Pagani Zonda';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        acc.PriceGroupCode__c=PGObj.Id;
        acc.Mobile__c='9967341759';
        acc.Phone='0203256589';
        acc.Sales_Org__c = sOrg.Id;
        acc.Callout_Set__c = False;
        acc.ApprovalStatus__c = 'Open';
        acc.TM_Depot_Mapping__c = tdmObj.Id;
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
        acc.CreatedById = usr1.Id;
        acc.Payment_Term_Code1__c ='0014';
        acc.State_Code1__c ='27';
        acc.Partner_Function_Code__c ='Z1';
        acc.Division_Code__c ='10';
        acc.Prospect_to_Distributor__c =false;
        acc.Central_Admin_Comment__c ='';
        acc.Depot_Code__c ='SEC1';        
        insert acc;
        
        
         Test.startTest();
        
        //Latest bank statement of last 3 months
         DistributorDocument__c dcj34 = new DistributorDocument__c();
         dcj34.Document_Name__c='Test';
         dcj34.Distributor__c=acc.Id;
         dcj34.Description__c='test';
         dcj34.Document_List__c='Latest bank statement of last 3 months';
         dDocList.add(dcj34);
         
         insert dcj34;
         delete dcj34;
         
         
          //Latest bank statement of last 3 months
         DistributorDocument__c oj34 = new DistributorDocument__c();
         oj34.Document_Name__c='Test';
         oj34.Distributor__c=acc.Id;
         oj34.Description__c='test';
         oj34.Document_List__c='Residential Address Proof Proprietor/Partner/Director';
         dDocList.add(oj34);
         
         insert oj34;
         delete oj34;
         
         
        
         
       Test.stopTest();
        
    }
    
    
    
    
}