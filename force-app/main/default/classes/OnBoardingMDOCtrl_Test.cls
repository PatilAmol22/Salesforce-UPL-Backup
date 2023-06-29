@isTest
private class OnBoardingMDOCtrl_Test {

     @isTest
    static void testmethod1(){
         Id devRecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
        Id devRecordTypeIdDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId(); 
        System.debug('devRecordTypeIdAcc  ==>'+devRecordTypeIdAcc);
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='PG001';
        insert PGObj;
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'SWAL',            // Sales Org Name
            Description__c = 'SWAL',    // Description
            Sales_Org_Code__c = '1210'  // Sales Org Code
        );
        insert sOrg;
        System.debug('Intest class '+sOrg.ID);
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager SWAL' LIMIT 1];
        
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
            //Zone__c = 'Pune',                                                                  // Zone
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
        
        Zone__c zoneObj = new Zone__c(
            Name = 'Kolkata',                // Zone Name
            SalesOrg__c = sOrg.Id,   // Sales Org
            ZoneCode__c = 'SWZ02',             // Zone Code
            ZonalHead__c = usr1.Id  // Zonal Head
           // CDM_User__c = usr1.Id   // CDM User
        );
        insert zoneObj;
        
        
        Division__c divObj = new Division__c();
        divObj.Name = 'Fertilizer Division';
        divObj.Division_Code__c = '10';
        insert divObj;
        
        Pin_Code__c pCode = new Pin_Code__c();
        pCode.Name = '421306';
        pCode.District__c = 'Thane';
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
        credentials.Oauth_URL__c='https://oauthasservices-ae7888026.hana.ondemand.com/oauth2/api/v1/token';
        insert credentials;
        
        Depot__c DepotObj = new Depot__c(
            Name = 'SWAL',                             // Depot Name
            Location__c = 'SWAL',                        // Location
            Country__c = 'SWAL',                        // Country
            RecordTypeId = devRecordTypeIdDepot,                  // Record Type
            Depot_Code__c = 'DS30',                      // Depot Code
            SalesOrg__c = sOrg.Id,             // Sales Org
            Active__c = false                           // Active
        );
        insert DepotObj;
        
        
        TM_Depot_Mapping__c TM_Depot_MappingObj = new TM_Depot_Mapping__c(
            Depot__c = DepotObj.Id,            // Depot
            Depot_Name__c = 'SWAL',                    // Depot Name
            Territory_Manager__c = usr1.Id  // Territory Manager
        );
        insert TM_Depot_MappingObj;
        
        Account acc = new Account(
            Country__c = 'SWAL',                                                                                   // Org Name
            Sales_Operation__c = 'Domestic',                                                                         // Sales Operation
            Partner_Function__c = '	Z1',                                                                   // Partner Function
            RecordTypeId = devRecordTypeIdAcc,                                                                              // Account Record Type
            Customer_Category__c = '04',                                                                         // Customer Category
            Salutation__c = 'M/S.',                                                                                  // Salutation
            Name = 'Test by pallavi (onboarding CR)126',                                            // Account Name
            Email__c = 'pal@gmail.com',                                                                              // Email
            First_Name__c = 'Pal',                                                                                   // First Name
            Mobile__c = '7289877889',                                                                      // Mobile
            Last_Name__c = 'Pal',                                                                                    // Last Name
            Phone = '7289877889',                                                                          // Phone
            Addressnotes__c = 'SKI',                                                                                 // Short Name
            ApprovalStatus__c = 'Pending',                                                                          // Approval Status
            Buying_Group__c = '2023087',                                                                             // Buying Group
            Prospect_to_Distributor__c = false,                                                                      // Prospect to Distributor
            Callout_Set__c = false,
            //Sales_Org__c= sOrg.ID,
            Depot_Code__c = 'DS30',                                                                                  // Depot Code
            Partner_Function_Code__c = 'Z0',                                                                         // Partner Function Code
           // Sales_Org_CD__c = '1210',                                                                                // Sales Org Code
            Division_Code__c = '10',                                                                                 // Division Code
            State_Code1__c = '13',                                                                                   // State Code1
            RegionalManager__c = usr1.Id,                                                                  // Regional Manager
            Photograph_Owner__c = true,                                                                              // Photograph (Owner)
            ZonalHead__c = usr1.Id,                                                                        // Zonal Head
            Photograph_Selfie_with_Customer__c = true,                                                               // Photograph (Selfie with Customer)
            Photograph_Shop__c = true,                                                                               // Photograph (Shop)
            Scanned_Security_Cheque__c = true,                                                                       // Security cheques along declaration annex
            Copy_of_Pesticide_Seed_License__c = true,                                                                // Copy of Pesticide / Seed License
            GST_Certificate__c = true,                                                                               // GST Cert/Cust declaration-NON-REG GSTN
            Copy_of_Partnership_Firm_Company_HUF_Pr__c = true,                                                       // Copy of Partnership Firm/ Company/HUF/Pr
            Signed_Business_Policy__c = true,                                                                        // Signed Business Policy
            Blank_Letter_Pad_for_Address_Proof__c = true,                                                            // Blank Letter Pad for Address Proof
            PAN_Card__c = true,                                                                                      // PAN Card
            Demand_Draft_DD__c = true,                                                                               // Demand Draft(DD)
           // Dealer_booklet__c = true,                                                                                // Dealer booklet
           // Annexure_of_declaration_of_relation__c = true,                                                           // Annexure of declaration of relation
           // Annexure_of_declaration_of_signing_docs__c = true,                                                       // Annexure of declaration of signing docs
           // Latest_bank_statement_of_last_3_months__c = true,                                                        // Latest bank statement of last 3 months
           // Owner_PARTNERs_Director_ADHAAR_Copy__c = true,                                                           // Owner/PARTNERs/Director ADHAAR Copy
           // Residential_Address_Proof_Proprietor_Par__c = true,                                                      // Residential Address Proof Proprietor/Par
            Billing_Street_2__c = 'Pal Pal Pal',                                                                     // Billing Street 2
            Billing_Street_3__c = 'Swarn rekha apartment,H2/512,lokgram,near Lok kalyan public school,Kalyan east',  // Billing Street 3
            Billing_Street_4__c = 'Test',                                                                            // Landmark
            CountryKey__c = 'IN',                                                                                    // Country Key
            Billing_Street_5__c = 'Swarn rekha apartment,H2/512,lokgram,near Lok kalyan public school,Kalyan east',  // Billing Street 5
            Customer_Country__c = 'India',                                                                           // Country
            LanguageKey__c = 'EN',                                                                                   // Language Key
            Pin_Code__c = pCode.Id,                                                                         // Pin Code
           // Sales_Org_name__c = 'USA',                                                                              // Sales Org
            DeliveryPriority__c = '01',                                                                              // Delivery Priority
            ShippingConditions__c = '01', 
            State_Tax_Structure__c=	sTax.Id,						// Shipping Conditions
           // Distribution_Channel__c = 'a0x28000001p9hc',                                                             // Distribution Channel
            RelevantforpricedeterminationID__c = 'X',                                                                // Relevant for price determination ID
            Division__c = divObj.Id,                                                                         // Division Name
            KeyforSorting__c = '001',                                                                                // Key for Sorting
           TM_Depot_Mapping__c = TM_Depot_MappingObj.Id,                                                                 // Depot
            Incoterms_Part_1__c = 'ZFU',                                                                             // Incoterms (Part 1)
            PriceGroupCode__c = PGObj.Id,                                                                   // Price Group Code
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                                                             // Incoterms (Part 2)
            PreviousMasterRecordNumber__c = '123123',                                                                // Previous Master Record Number
            Creditcontrolarea__c = 'SWAL',                                                                           // Credit control area
            ReconciliationAccountinGeneralLedger__c = '230010',                                                      // Reconciliation Account in General Ledger
           // Customer_Grp__c = 'undefined',                                                                           // Customer Group
            SalesGroupAFGFCGVSG__c = 'AFG',                                                                          // Sales Group
            Customergroup__c = '06',                                                                   // Customer Class
            Accountassignmentgroup__c = '04',                                                                        // Account assignment group
            CustomerStatisticsGroup__c = '1',                                                                        // Customer Statistics Group
            IndicatorCustomerIsRebateRelevant__c = 'X',                                                              // Indicator: Customer Is Rebate-Relevant
            IndicatorRecordPaymentHistory__c = 'X',                                                                  // Indicator: Record Payment History ?
            ActiveCode__c = '2025159',                                                                               // Active Code
            Groupkey__c = '1200',                                                                                    // Group key
            Pricingprocedureassignedtothiscusto__c = '1',                                                            // Pricing procedure assigned
           // TM_Depot_Mapping__c = 'a0w0K000007zWea',                                                                 // Depot
            PAN_Number__c = 'AHGPA3235Q',                                                                            // PAN Number
            Tax_Number_3__c = '27AHGPA3235QAAA',                                                                     // GST Number
            Tax_classification_for_customer__c = '0', 
            BillingPostalCode ='421306',// Tax classification for customer,
            Customer_Classification__c ='2',
            BillingStreet='Mumbai', 
            BillingCity='Mumbai', 
            BillingState='Mumbai',
           // BillingPostalCode='421306', 
            BillingCountry='Mumbai',
            Zone_Distributor__c = zoneObj.Id,
            MDO_Code__c='12343425'
        );
        insert acc;
        OnBoardingMDOController.gettingMDODetail(acc.Id);
        OnBoardingMDOController.callingOnboardingServices(acc.Id);
        
    }
}