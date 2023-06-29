@isTest 
public class CalledClassToQuotePDF_Test {
    static testMethod void method1() {
        Id RecordTypeIdEnity = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entity').getRecordTypeId();
        Id RecordTypeIdDistributor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        System.debug('RecordTypeIdEnity  in test class '+RecordTypeIdEnity);
        
        
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
            Phone = '1234567890',                                                    // Phone
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
        
      
        
        Account accobj = new Account();
        accobj.Name='Ketan';
        accobj.Last_Name__c='Khatri';
        //acc.SAP_Code__c='SAP996734';
        accobj.RecordTypeId=RecordTypeIdDistributor;
        accobj.PriceGroupCode__c=PGObj.Id;
        accobj.Mobile__c='9967341759';
        accobj.Phone='1234567890';
        accobj.Sales_Org__c = sOrg.Id;
        accobj.Callout_Set__c = False;
        accobj.ApprovalStatus__c = 'Open';
        accobj.RegionalManager__c = usr1.Id;
        accobj.ZonalHead__c = usr1.Id;
        accobj.SBUHead__c = usr1.Id;
        accobj.Country__c='India';
        accobj.Division__c = divObj.Id;
        accobj.BillingCity = 'Mumbai';
        accobj.BillingCountry = 'India';
        accobj.BillingStreet = 'DSP';
        accobj.BillingState = 'MAHARASHTRA';
        accobj.BillingPostalCode= '400014';
        accobj.PAN_Number__c = 'DLEPK3323L';
        accobj.State_Tax_Structure__c = sTax.Id;
        accobj.Tax_Number_3__c = '27DLEPK3323LAAA';
        accobj.DealerDistributorShortName__c = null;
        accobj.DealerDistributorShortNamec1__c = 'Sname';
        
        accobj.Payment_Term_Code1__c ='0014';
        accobj.State_Code1__c ='27';
        accobj.Partner_Function_Code__c ='Z1';
        accobj.Division_Code__c ='10';
        accobj.Prospect_to_Distributor__c =false;
        accobj.Central_Admin_Comment__c ='';
        accobj.Depot_Code__c ='SEC1';
        accobj.Country__c = 'Other';
        accObj.Tax_classification_for_customer__c = '1';                  
        insert accobj;
        
        
        /*Account accObj = new Account(
            Name = 'ANGLO GULF LIMITED',            // Account Name
            RecordTypeId = RecordTypeIdDistributor,                                // Account Record Type
            Last_Name__c = 'ANGLO GULF LIMITED',                       // Last Name
            SAP_Code__c = '0005001516',                                // SAP Customer Code
            Email__c = 'agadxbme@emirates.net.ae',                     // Email
            Order_Block__c = false,                                    // Order Block
            Account_Type__c = 'Sold To Party',                         // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',               // Incoterms (Part 2)
            Phone ='9876543212',
            Country__c = 'Other',                                      // Org Name
            AuthorizationGroupSalesoffice__c = 'S091',                 // Authorization Group (Sales office)
            Prospect_to_Distributor__c = false,                        // Prospect to Distributor
            LanguageKey__c = 'EN',                                     // Language Key
            CountryKey__c = 'IN',                                      // Country Key
            Billing_Street_3__c = 'P.O. BOX 16887, JABEL ALI DUBAI,',  // Billing Street 3
            Sales_Org__c = 'a1F0k000001yVxM',                          // Sales Org
            ShippingConditions__c = '01',                              // Shipping Conditions
            Division__c = 'a100k000000C9Hx',                           // Division Name
            Distribution_Channel__c = 'a0x0k000000pL23',               // Distribution Channel
            CustomerAccountGroup__c = 'Z031',                          // Customer Account Group
            Is_Fixed_Rate_Available_Italy__c = false,                  // Is Fixed Rate Available
            Tax_classification_for_customer__c = '1'                  // Tax classification for customer
        );
        insert accObj;*/
        
        Account customerObj = new Account();
        customerObj.Name='Ketan';
        customerObj.Last_Name__c='Khatri';
        //acc.SAP_Code__c='SAP996734';
        customerObj.RecordTypeId=RecordTypeIdDistributor;
        customerObj.PriceGroupCode__c=PGObj.Id;
        customerObj.Mobile__c='9967341759';
        customerObj.Phone='1234567890';
        customerObj.Sales_Org__c = sOrg.Id;
        customerObj.Callout_Set__c = False;
        customerObj.ApprovalStatus__c = 'Open';
        customerObj.RegionalManager__c = usr1.Id;
        customerObj.ZonalHead__c = usr1.Id;
        customerObj.SBUHead__c = usr1.Id;
        customerObj.Country__c='India';
        customerObj.Division__c = divObj.Id;
        customerObj.BillingCity = 'Mumbai';
        customerObj.BillingCountry = 'India';
        customerObj.BillingStreet = 'DSP';
        customerObj.BillingState = 'MAHARASHTRA';
        customerObj.BillingPostalCode= '400014';
        customerObj.PAN_Number__c = 'DLEPK3323L';
        customerObj.State_Tax_Structure__c = sTax.Id;
        customerObj.Tax_Number_3__c = '27DLEPK3323LAAA';
        customerObj.DealerDistributorShortName__c = null;
        customerObj.DealerDistributorShortNamec1__c = 'Sname';
        
        customerObj.Payment_Term_Code1__c ='0014';
        customerObj.State_Code1__c ='27';
        customerObj.Partner_Function_Code__c ='Z1';
        customerObj.Division_Code__c ='10';
        customerObj.Prospect_to_Distributor__c =false;
        customerObj.Central_Admin_Comment__c ='';
        customerObj.Depot_Code__c ='SEC1';
        customerObj.Country__c = 'Other';
        customerObj.Tax_classification_for_customer__c = '1'; 
        customerObj.Bill_to_Party_SAP_Code__c = '2732';                 // Bill to Party SAP Code
        customerObj.Supplier_Code__c = '2730';                            // Supplier Code
        customerObj.Supplier_Code_Name__c = 'ALSSAS'; 
        insert customerObj;
        
        
        
        
        
       /* Account customerObj = new Account(
            Name = 'Arysta LifeScience S.A.S.',// Account Name
            Bill_to_Party_SAP_Code__c = '2732',                   // Bill to Party SAP Code
            Supplier_Code__c = '2730',                            // Supplier Code
            Supplier_Code_Name__c = 'ALSSAS',                     // Supplier Code Name
            RecordTypeId = RecordTypeIdEnity                           // Account Record Type
        );
        insert customerObj;*/
        
        Bank_Details__c supplierObj = new Bank_Details__c(
            Supplier_Code__c = '2730',                                                            // Supplier Code
            Supplier_Code_Name__c = 'ALSSAS',                                                       // Supplier Code Name
            Customer__c = customerObj.Id,                                                        // Customer
            Name = 'Arysta LifeScience SAS',                                                        // Beneficiary Name
            Beneficiary_IBAN_Number__c = 'FR76 1778 9000 0110 5120 0800 048',                       // Beneficiary IBAN Number
            Bank_Identifier_Code__c = 'DEUTFRPP',                                                   // Bank Identifier Code
            Address__c = 'Deutsche Bank AG\n23-25 Avenue Franklin Roosevelt\n75008 Paris\nFrance',  // Address
            BillingStreet__c = 'Route dArtix, 64150 Noguères',                                     // BillingStreet
            BillingCountry__c = 'France'                                                           // BillingCountry
        );
        insert supplierObj;
        
        Opportunity oppoObj = new Opportunity(
            Name = 'Bombay Coffee',               // Opportunity Name
            AccountId = accObj.Id,          // Account Name
            CloseDate = System.today(),  // Close Date
            StageName = 'Proposal',                 // Stage
            Probability = 75,                       // Probability (%)
            Country_of_Origin__c = 'Belgium',       // Country Of Origin
            Opportunity_Currency__c = 'EUR'        // Opportunity Currency
           // Supplier1__c = supplierObj.Id       // Supplier / Shipper / Exporter
        );
        insert oppoObj;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Utd.Arab Emir.',       // Sales Org Name
            Sales_Org_Code__c = '2000',      // Sales Org Code
            Country_Code__c = 'AE'          // Country Code
        );
        insert salesOrgObj;
        
        Distribution_Channel__c distributorChannelObj = new Distribution_Channel__c(
            Name = 'Exports - Non Subs',        // Distribution Channel Name
            Distribution_Channel_Code__c = '40'  // Distribution Channel Code
        );
        insert distributorChannelObj;
        
        /*Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;*/
        
        Shipping_Location__c shippinLocationObj = new Shipping_Location__c(
            Location_Name__c = 'ANGLO GULF LIMITED',                 // Location Name
            Distributor__c = accObj.Id,                        // Distributor
            SAP_Code__c = '0005001516',                                // SAP Code
            City__c = 'DUBAI',                                         // City
            Country__c = 'AE',                                         // Country
            Pincode__c = '00000',                                      // Pincode
            Billing_Street_3__c = 'P.O. BOX 16887, JABEL ALI DUBAI,',  // Billing Street 3
            Sold_To_Party_SAP_Code__c = '0005001516',                  // Sold To Party (SAP Code)
            Sales_Org__c = salesOrgObj.Id,                          // Sales Org
            Distribution_Channel__c = distributorChannelObj.Id,               // Distribution Channel
           // Division__c = divisionObj.Id,                           // Division
            Combination_Key__c = '00050015160005001516'               // Combination Key
        );
        insert shippinLocationObj;
        
        Quote quoteObj = new Quote(
            Name = 'Quote_100',                               // Quote Name
            Quote_Raised_By__c = 'Commercial/Country Manager',  // Quote raised by
            OpportunityId = oppoObj.Id,                  // Opportunity Name
            IsApprovalRequired__c = false,                      // IsApprovalRequired
            Approved_By_Country_Manager__c = false,             // Approved By Country Manager
            Carriage_By__c = 'Sea',                             // Carriage by
            Approved_By_Region_Head__c = false,                 // Approved By Region Head
            Port_of_Final_destination__c = 'Mumbai',            // Port Of Final Destination
            Place_of_Receipt_By_pre_carrier__c = 'Mumbai',      // Place Of Receipt By Pre-Carrier
           // Region_Head__c = '0050k000001i9DH',                 // Region Head
            Status = 'Pending',                                 // Status
            SGS_Inspection__c = 'Yes',                          // SGS Inspection
            Port_of_loading__c = 'Mumbai',                      // Port Of Loading
            Container_load__c = 'FCL',                          // Container Load
            //Payment_Term__c = 'undefined',                      // Payment Term
            //Inco_Term_Code__c = 'undefined',                    // Inco Term
            sent_for_Region_Manager_Approval__c = false,        // sent  for Region Manager Approval
            sent_for_Commercial_Manager_Approval__c = false,    // sent for Commercial Manager Approval
            sent_for_Commercial_Head_Approval__c = false,       // sent for Commercial Head  Approval
            BillingName = 'ANGLO GULF LIMITED',                 // Bill To Name
            ShippingName = 'ANGLO GULF LIMITED',                // Ship To Name
            Ship_to_Party__c = shippinLocationObj.Id               // Ship To Party
        );
        insert quoteObj;
        
        CalledClassToQuotePDF.CalledClassToQuotePDFID(quoteObj.Id);
        
        
        
    }
}