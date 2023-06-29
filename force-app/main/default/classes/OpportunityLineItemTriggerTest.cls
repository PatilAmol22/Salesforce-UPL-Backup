@IsTest
public class OpportunityLineItemTriggerTest {

    @testSetup
    static void setupData(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
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
        
       
        
        Opportunity OppOObj = new Opportunity(
            Name = 'Hindustan Pencils PVT LTD.',  // Opportunity Name
            AccountId = accObj.Id,          // Account Name
            CloseDate = system.today(),  // Close Date
            StageName = 'Proposal',                 // Stage
            Probability = 75,                       // Probability (%)
            Country_of_Origin__c = 'Netherland',    // Country Of Origin
            Opportunity_Currency__c = 'USD',        // Opportunity Currency
            CurrencyIsoCode ='USD'
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
        p1.Combination_Key__c ='1234567890';        
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
        
          OpportunityLineItem OliObj = new OpportunityLineItem(
            OpportunityId = OppOObj.Id,                      // Opportunity
            Product2Id = p1.Id,                           // Product
            TotalPrice = 30000.00,                                    // Total Price
           // UnitPrice = 600.00,                                       // Sales Price
            Quantity = 50.00,                                       // Quantity
            Pack_Size__c = '0 KG',                                    // Pack Size
            Description = 'UTHANE M45(MZB) 80WP-10KG PRNT PAPER_UG',  // Line Description 
            PricebookEntryId = pbe.Id
        );
        insert OliObj;
        
        QuoteLineItem qliObj = new QuoteLineItem(
            Product2Id = p1.Id, // Product
            Description = 'BALEAR-720SC-1L',  // Line Item Description
            QuoteId	= quoteObj.Id,
            UnitPrice = 12.00,                // Sales Price
            Quantity = 12.00,               // Quantity
            Pack_Size__c = '0 KG',
            //opportunity_line_item_id_1__c =OliObj.Id,  // Pack Size
            PricebookEntryId = pbe.Id
        );
        insert qliObj;
        
        //Quote Line Item
        /*QuoteLineItem qliObj = new QuoteLineItem(
            Product2Id = '01t0k000005PR01',                         // Product
            QuoteId  = quoteObj.Id,
            Description = 'UTHANE M45(MZB) 80WP-10KG PRNT PAPER_UG',  // Line Item Description
            opportunity_line_item_id__c = '00k0k000005ekoW',          // opportunity line item id
            OpportunityLineItemId = OliObj.Id,
            UnitPrice = 6054353.465650,                                       // Sales Price
            Quantity = 55.00,                                       // Quantity
            Pack_Size__c = '0 KG',                                    // Pack Size
            PricebookEntryId = pbe.Id
           
        );
        insert qliObj; */
        
        QuoteLineItem Obj = new QuoteLineItem();
        Obj = [Select Id, Product2Id from QuoteLineItem ];
        update obj;
        
        Quote_Line_Item_Field_Mapping__c qlImapObj=new Quote_Line_Item_Field_Mapping__c();
        qlImapObj.Name='Pack_Size__c';
        qlImapObj.Opportunity_Line_Item_Field__c='Pack_Size__c';
        insert qlImapObj;
        
    }
    
    @isTest static void beforeupdateTest() {
        Account acnt = [select id,Name from Account where Name='Vishal Pawar'];
        Opportunity op = [select id,Name from Opportunity where Name='Hindustan Pencils PVT LTD.'];
        OpportunityLineItem opITEM=[Select Id,  Pack_Size__c from OpportunityLineItem where OpportunityId =:op.id];
        //QuoteLineItem liObj=[Select id, Pack_Size__c, opportunity_line_item_id_1__c from QuoteLineItem where OpportunityLineItemId=:opITEM.id];
        
        set<id> opSet=new set<id>();
        opSet.add(opITEM.id);
        // Perform test
        Test.startTest();
        OpportunityLineItemTriggerHandler.sync(opSet);
        Test.stopTest();        
        
    }

}