@isTest
public class QuoteLineItemTrigger_test {
    
    
    @testSetup
    static void setupData(){
        Id RecordTypeIdEnity = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entity').getRecordTypeId();
        Id RecordTypeIdDistributor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account accObj = new Account(
            Name = 'Vishal Pawar',            // Account Name
            RecordTypeId = RecordTypeIdDistributor,                                // Account Record Type
            Last_Name__c = 'ANGLO GULF LIMITED',                       // Last Name
            SAP_Code__c = '0005001516',                                // SAP Customer Code
            Email__c = 'agadxbme@emirates.net.ae',                     // Email
            Order_Block__c = false,                                    // Order Block
            Account_Type__c = 'Sold To Party',                         // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',               // Incoterms (Part 2)
          
            Country__c = 'Other',                                      // Org Name
            AuthorizationGroupSalesoffice__c = 'S091',                 // Authorization Group (Sales office)
            Prospect_to_Distributor__c = false,                        // Prospect to Distributor
            LanguageKey__c = 'EN',                                     // Language Key
            CountryKey__c = 'IN',                                      // Country Key
            Billing_Street_3__c = 'P.O. BOX 16887, JABEL ALI DUBAI,',  // Billing Street 3
           // Sales_Org__c = 'a1F0k000001yVxM',                          // Sales Org
            ShippingConditions__c = '01',                              // Shipping Conditions
           // Division__c = 'a100k000000C9Hx',                           // Division Name
           // Distribution_Channel__c = 'a0x0k000000pL23',               // Distribution Channel
            CustomerAccountGroup__c = 'Z031'                          // Customer Account Group
            
            
        );
        insert accObj;
        
        Account customerObj = new Account(
            Name = 'Arysta LifeScience S.A.S.',// Account Name
            Bill_to_Party_SAP_Code__c = '2732',                   // Bill to Party SAP Code
            Supplier_Code__c = '2730',                            // Supplier Code
            Supplier_Code_Name__c = 'ALSSAS',                     // Supplier Code Name
            RecordTypeId = RecordTypeIdEnity                           // Account Record Type
        );
        insert customerObj;
        
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
            Name = 'Hindustan Pencils PVT LTD.',               // Opportunity Name
            AccountId = accObj.Id,          // Account Name
            CloseDate = System.today(),  // Close Date
            StageName = 'Proposal',                 // Stage
            Probability = 75,                       // Probability (%)
            Country_of_Origin__c = 'Belgium',       // Country Of Origin
            Opportunity_Currency__c = 'USD',        // Opportunity Currency
            CurrencyIsoCode='USD'       // Supplier / Shipper / Exporter
        );
        insert oppoObj;
        
        Product2 p1 = new Product2();
        p1.Name='Test8';
        p1.Productcode='PO16';
        p1.IsActive = true;
        p1.Combination_Key__c ='dsaadsa32131';

        
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
        
       
        
        
        
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Utd.Arab Emir.',       // Sales Org Name
            Sales_Org_Code__c = '5711',      // Sales Org Code
            Country_Code__c = 'AE'          // Country Code
        );
        insert salesOrgObj;
        
        Distribution_Channel__c distributorChannelObj = new Distribution_Channel__c(
            Name = 'Exports - Non Subs',        // Distribution Channel Name
            Distribution_Channel_Code__c = '40'  // Distribution Channel Code
        );
        insert distributorChannelObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
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
            Division__c = divisionObj.Id,                           // Division
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
            Ship_to_Party__c = shippinLocationObj.Id,
            Pricebook2Id = standardPB.Id,
            CurrencyIsoCode ='USD'										// Ship To Party
        );
        insert quoteObj;
        
        OpportunityLineItem OpliObj = new OpportunityLineItem(
            OpportunityId = oppoObj.Id,                       // Opportunity
            Product2Id = '01t0k000005jIf7',                            // Product
            TotalPrice = 45000.00,                                     // Total Price
            //UnitPrice = 9.00,                                          // Sales Price
            Quantity = 5000.00,                                     // Quantity
            Pack_Size__c = 'KG',                                       // Pack Size
            Description = 'ALUMINIUM PHOSPHID57%FT(9TINSX1440GM)_AE',  // Line Description
            PricebookEntryId = pbe.Id
        );
        insert OpliObj;
        
        
        QuoteLineItem QuoteLineItemObj = new QuoteLineItem(
            Product2Id = p1.Id,    // Product
            QuoteId = quoteObj.Id,
            Description = 'CYTHRIN-10EC-0.25L',  // Line Item Description
            UnitPrice = 10.00,                   // Sales Price
            Quantity = 10.00,
            Min_Price__c =12.00,
            PricebookEntryId = pbe.Id,
            OpportunityLineItemId = OpliObj.Id,// Quantity
            Pack_Size__c = '0.25L'              // Pack Size
        );
        insert QuoteLineItemObj;
        
        QuoteLineItem Obj = new QuoteLineItem();
        Obj = [Select Id,Min_Price__c,UnitPrice, Product2Id from QuoteLineItem ];
        update obj;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj1=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj1.Name='Pack_Size__c';
        qlImapObj1.Opportunity_Line_Item_Field__c='Pack_Size__c';
        insert qlImapObj1;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj2=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj2.Name='Min_Price__c';
        qlImapObj2.Opportunity_Line_Item_Field__c='Min_Price__c';
        insert qlImapObj2;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj3=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj3.Name='Max_Price__c';
        qlImapObj3.Opportunity_Line_Item_Field__c='Max_Price__c';
        insert qlImapObj3;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj4=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj4.Name='UOM__c';
        qlImapObj4.Opportunity_Line_Item_Field__c='UOM__c';
        insert qlImapObj4;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj5=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj5.Name='Storage_Location__c';
        qlImapObj5.Opportunity_Line_Item_Field__c='Storage_Location__c';
        insert qlImapObj5;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj6=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj6.Name='Distribution_Channel__c';
        qlImapObj6.Opportunity_Line_Item_Field__c='Distribution_Channel__c';
        insert qlImapObj6;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj7=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj7.Name='Sales_Org__c';
        qlImapObj7.Opportunity_Line_Item_Field__c='Sales_Org__c';
        insert qlImapObj7;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj8=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj8.Name='Division__c';
        qlImapObj8.Opportunity_Line_Item_Field__c='Division__c';
        insert qlImapObj8;
        
        
    }
    
    
    
    
    @isTest static void beforeupdateTest() {
        Account acnt = [select id,Name from Account where Name='Vishal Pawar' LIMIT 1];
        System.debug('### acnt '+acnt);
        
        Opportunity op = [select id,Name,SyncedQuoteId from Opportunity where Name='Hindustan Pencils PVT LTD.' LIMIT 1];
        System.debug('###  op '+op);
        OpportunityLineItem opITEM = [Select Id, Pack_Size__c from OpportunityLineItem where OpportunityId =:op.id];
        System.debug('###  opITEM'+opITEM);
        
        QuoteLineItem liObj=[Select id,QuoteId,Pack_Size__c,Min_Price__c,UnitPrice, opportunity_line_item_id_1__c from QuoteLineItem where OpportunityLineItemId=:opITEM.id ];
        
        List<QuoteLineItem> liObj1=[Select id,Pack_Size__c,Min_Price__c,UnitPrice, opportunity_line_item_id_1__c ,QuoteId from QuoteLineItem where OpportunityLineItemId=:opITEM.id];
        System.debug('liObj1 in Test class '+liObj1);
        
        
        set<id> opSet=new set<id>();
        opSet.add(opITEM.id);
        
        List<QuoteLineItem> listOfliObj=new List<QuoteLineItem>();
        listOfliObj.add(liObj);
        
        Map<ID, QuoteLineItem> oldMap =new Map<ID, QuoteLineItem>();
        oldMap.put(liObj.id, liObj);
        
        Map<ID,OpportunityLineItem> mapOppLineItems=new Map<ID,OpportunityLineItem>();
        mapOppLineItems.put(opITEM.id, opITEM);
        
        // Perform test
        Test.startTest();
        QuoteLineItemTriggerHandler qlihandler=new QuoteLineItemTriggerHandler();
        qlihandler.handleBeforeInsert(listOfliObj);
        qlihandler.handleAfterInsert(listOfliObj, oldMap);
        qlihandler.copyOpportunityLineItemFieldsToQuoteLineItemFields(listOfliObj);
        qlihandler.handleBeforeDelete(listOfliObj,oldMap);
        qlihandler.handleAfterDelete(listOfliObj,oldMap);
        qlihandler.handleBeforeUpdate(listOfliObj,oldMap,listOfliObj,oldMap);
       
        
        QuoteLineItemTriggerHandler1.syncQuotes(liObj1);
        Test.stopTest();     
        
    }
    
    
}