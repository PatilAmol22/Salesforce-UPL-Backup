@isTest 
public class DownLoadPDFQuoteController_Test {
        
    static testMethod void method1() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordTypeEntityId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entity').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Charata';
        dp.Country__c='Argentina';
        dp.Location__c='Charata';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        //Data for Sales Org
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Argentina',        // Sales Org Name
            Sales_Org_Code__c = '5631'  // Sales Org Code
        );
        insert salesOrgObj;
        
        Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZXKB',                  // Order Type Name
            Description__c = 'Consignatario',     // Description
            Order_Type_Code__c = 'ZXKB',      // Order Type Code
            SalesOrg__c = salesOrgObj.Id  // Sales Org
        );
        insert orderTypeObj;
        
        
        
        //Data for Distribution Channel 
        Distribution_Channel__c distributionChannelObj = new Distribution_Channel__c(
            Name = 'Direct',                    // Distribution Channel Name
            Distribution_Channel_Code__c = '10'  // Distribution Channel Code
        );
        insert distributionChannelObj;
        
        
        //Data for Division
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        
        //Bill to party /sold to party is Account Object 
        Account accObj = new Account(
            Name='Vishal Pawar',
            SAP_Code__c = '0001013292', 
            //PriceGroupCode__c=pg.id,
            RecordTypeId = devRecordTypeId,              // SAP Customer Code
            Last_Name__c = 'ADECO AGROPECUARIA S.A.',     // Last Name
            Order_Block__c = false,                       // Order Block
            Mobile__c = '9405883688',  
            Phone='020256589', // Mobile
            Email__c = 'marcelo.gorla@uniphos.com',       // Email
            Account_Type__c = 'Sold To Party',            // Account Type
            // Raise_Order_Type__c = 'Both',                 // Raise Order Type
            Billing_Street_2__c = 'CATAMARCA 3454',       // Billing Street 2
            //Sales_Org__c = salesOrgObj.id,             // Sales Org
            //Division__c = divisionObj.Id,              // Division Name
            // Distribution_Channel__c = distributionChannelObj.Id,  // Distribution Channel
            Depot_Code__c = 'AR13',                       // Depot Code
            Country__c = 'Other'
            //AuthorizationGroupSalesoffice__c ='S091'
        ); 
        insert accObj;
        
        
        Id RecordTypeIdEnity = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entity').getRecordTypeId();
        Id RecordTypeIdDistributor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        System.debug('RecordTypeIdEnity  in test class '+RecordTypeIdEnity);
        
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='PG001';
        insert PGObj;

       /* UPL_Settings__c uplsetting = new UPL_Settings__c();
        uplsetting.Name = 'UPLSetting';
        uplsetting.India_SAS_Sales_Org__c = '1410';
        INSERT uplsetting;*/
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'Costa Rica',            // Sales Org Name
            Description__c = 'Costa Rica',    // Description
            Sales_Org_Code__c = '5711'//uplsetting.India_SAS_Sales_Org__c  // Sales Org Code
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
        
        /*Division__c divObj = new Division__c();
        divObj.Name = 'Fertilizer Division';
        divObj.Division_Code__c = '10';
        insert divObj;*/
        
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
        
      
        
        Account accobj1 = new Account();
        accobj1.Name='Ketan';
        accobj1.Last_Name__c='Khatri';
        //acc.SAP_Code__c='SAP996734';
        accobj1.RecordTypeId=RecordTypeIdDistributor;
        accobj1.PriceGroupCode__c=PGObj.Id;
        accobj1.Mobile__c='9967341759';
        accobj1.Phone='1234567890';
        accobj1.Sales_Org__c = sOrg.Id;
        accobj1.Callout_Set__c = False;
        accobj1.ApprovalStatus__c = 'Open';
        accobj1.RegionalManager__c = usr1.Id;
        accobj1.ZonalHead__c = usr1.Id;
        accobj1.SBUHead__c = usr1.Id;
        accobj1.Country__c='India';
       // accobj1.Division__c = divObj.Id;
        accobj1.BillingCity = 'Mumbai';
        accobj1.BillingCountry = 'India';
        accobj1.BillingStreet = 'DSP';
        accobj1.BillingState = 'MAHARASHTRA';
        accobj1.BillingPostalCode= '400014';
        accobj1.PAN_Number__c = 'DLEPK3323L';
        accobj1.State_Tax_Structure__c = sTax.Id;
        accobj1.Tax_Number_3__c = '27DLEPK3323LAAA';
        accobj1.DealerDistributorShortName__c = null;
        accobj1.DealerDistributorShortNamec1__c = 'Sname';
        
        accobj1.Payment_Term_Code1__c ='0014';
        accobj1.State_Code1__c ='27';
        accobj1.Partner_Function_Code__c ='Z1';
        accobj1.Division_Code__c ='10';
        accobj1.Prospect_to_Distributor__c =false;
        accobj1.Central_Admin_Comment__c ='';
        accobj1.Depot_Code__c ='SEC1';
        accobj1.Country__c = 'Other';
        accObj1.Tax_classification_for_customer__c = '1';                  
        insert accobj1;
        
         Bank_Details__c bankObj = new Bank_Details__c(
            Name = 'Arysta LifeScience SAS',                                                      // Beneficiary Name
            Customer__c = accObj.Id,                                                        // Customer
            Beneficiary_IBAN_Number__c = 'FR76 1778 9000 0110 5120 0800 048',                       // Beneficiary IBAN Number
            Address__c = 'Deutsche Bank AG\n23-25 Avenue Franklin Roosevelt\n75008 Paris\nFrance',  // Address
            Bank_Identifier_Code__c = 'DEUTFRPP',                                                   // Bank Identifier Code
            Supplier_Code__c = '2730',                                                              // Supplier Code
            Supplier_Code_Name__c = 'ALSSAS',                                                       // Supplier Code Name
            BillingStreet__c = 'Route d',                                     // BillingStreet
            BillingCountry__c = 'France'                                                           // BillingCountry
        );
        insert bankObj;
        
        Opportunity OppOObj = new Opportunity(
            Name = 'Hindustan Pencils PVT LTD.',  // Opportunity Name
            AccountId = accObj.Id,          // Account Name
            CloseDate = system.today(),  // Close Date
            StageName = 'Proposal',                 // Stage
            Probability = 75,                       // Probability (%)
            Country_of_Origin__c = 'Netherland',    // Country Of Origin
            Opportunity_Currency__c = 'USD'        // Opportunity Currency
           // Supplier1__c = bankObj.Id
        );
        insert OppOObj;
        
        
        Inco_Term__c incoTermObj = new Inco_Term__c(
            Name = 'Inco',                   // Inco Term Name
            IncoTerm_Code__c = '09',           // IncoTerm Code
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Active__c = false                 // Active
        );
        insert incoTermObj;
        
        Payment_Term__c ptObj = new Payment_Term__c(
            Payment_Term_Code__c = 'UK10',           // Payment Term Code
            Maturity_Date_Mandatory__c = 'No',       // Maturity Date Mandatory
            Payterms_Desc__c = '120 dias corridos',  // Payterms Desc
            Sales_Org__c = salesOrgObj.Id,        // Sales Org
            Days_to_calc_interest__c = 0,          // Days (to calc interest)
            Active__c = true,                        // Active
            CombinationKey__c = '5191UK10'          // CombinationKey
        );
        insert ptObj;
        
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'AVADH AGRO CHEMICALS - Tanzania',        // Location Name
            Distributor__c = accObj.Id,                            // Distributor
            SAP_Code__c = '00010195241000',                                // SAP Code
            State__c = '06',                                               // State
            Billing_Street_1__c = 'Falcon Estate Limited',                 // Billing Street 1
            Country__c = 'Tanzania',                                       // Country
            Billing_Street_2__c = 'Themi Industrial Area, P.O. box 1183',  // Billing Street 2
            Billing_Street_3__c = 'Arusha',                                // Billing Street 3
            Sold_To_Party_SAP_Code__c = '0001019524',                      // Sold To Party (SAP Code)
            Billing_Street_6__c = 'TANZANIA',                              // Billing Street 6
            Sales_Org__c = salesOrgObj.Id,                              // Sales Org
            Distribution_Channel__c = distributionChannelObj.Id ,                   // Distribution Channel
            Division__c = divisionObj.Id,                               // Division
            Combination_Key__c = '000101952400010195241000'               // Combination Key
        );
        insert shippingLocationObj;
        
        Product2 p1 = new Product2();
        p1.Name='Test8';
        p1.Productcode='PO16';
        p1.IsActive = true;
        p1.Combination_Key__c = '1234567890';        
        insert p1;      
        
        Pricebook2 standardPricebook = new Pricebook2(            
            Id = Test.getStandardPricebookId(),            
            IsActive = true,
            CurrencyIsoCode = 'USD' 
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        
        Update standardPricebook;
        
        
        
        Pricebook2 standardPB = [Select Id from Pricebook2 where isStandard=true limit 1];
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.Product2ID = p1.Id;
        pbe.Pricebook2Id = standardPB.Id;
        pbe.UnitPrice = 200; 
        pbe.CurrencyIsoCode = 'USD';
        //pbe.UseStandardPrice = false;
        insert pbe;
        
        
        
        
        Quote quoteObj = new Quote(
            Name = 'Quote_002',                               // Quote Name
            Quote_Raised_By__c = 'Commercial/Country Manager',  // Quote raised by
            OpportunityId = OppOObj.Id,                  // Opportunity Name
            IsApprovalRequired__c = false,                      // IsApprovalRequired
            Approved_By_Country_Manager__c = false,             // Approved By Country Manager
            Carriage_By__c = 'Sea',                             // Carriage by
            Approved_By_Region_Head__c = false,                 // Approved By Region Head
            Port_of_Final_destination__c = 'Mumbai',            // Port Of Final Destination
            Status = 'Auto Approved',                           // Status
            Place_of_Receipt_By_pre_carrier__c = 'Mumbai',      // Place Of Receipt By Pre-Carrier
            //Region_Head__c = '0050k000001i9DH',                 // Region Head
           // Inco_Term_1__c = incoTermObj.Id,                 // Inco Term
            Inco_Term_2__c = 'Inco Term Description',           // Inco Term Description
           // Payment_Term__c = ptObj.Id,                // Payment Term
            Place_of_Receipt_By__c = 'Mumbai',                  // Place Of Receipt By
            SGS_Inspection__c = 'Yes',                          // SGS Inspection
            Port_of_loading__c = 'Mumbai',                      // Port Of Loading
            Payment_Term_2__c = 'Payment Term Description',     // Payment Term Description
            Freight__c = 4500.00,                               // Freight
            Container_load__c = 'FCL',                          // Container Load
            BillingName = 'AVADH AGRO CHEMICALS - BAGASARA',    // Bill To Name
            ShippingName = 'AVADH AGRO CHEMICALS - BAGASARA',   // Ship To Name
            Ship_to_Party__c = shippingLocationObj.Id,
            Pricebook2Id = standardPB.Id,
            CurrencyIsoCode ='USD'
            
            
            
        );
        insert quoteObj;
        
       
        
        


        
        /*

        
        //Quote Line Item
        QuoteLineItem qliObj = new QuoteLineItem(
            Product2Id = '01t0k000005PR01',                         // Product
            QuoteId  = quoteObj.Id,
            Description = 'UTHANE M45(MZB) 80WP-10KG PRNT PAPER_UG',  // Line Item Description
            opportunity_line_item_id__c = '00k0k000005ekoW',          // opportunity line item id
            UnitPrice = 6054353.465650,                                       // Sales Price
            Quantity = 55.00,                                       // Quantity
            Pack_Size__c = '0 KG',                                    // Pack Size
            PricebookEntryId = pbe.Id
            
        );
        insert qliObj; 
        */
        System.debug('quoteObj.id '+quoteObj.id);
       DownLoadPDFQuoteController.downloadPdf(quoteObj.id);
        
        
        
        
    }
    
    
    
}