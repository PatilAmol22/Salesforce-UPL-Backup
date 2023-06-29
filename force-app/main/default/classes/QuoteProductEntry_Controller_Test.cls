@isTest
public class QuoteProductEntry_Controller_Test {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'India',        // Sales Org Name
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert salesOrgObj;
        
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
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            //Division__c = divisionObj.Id,              // Division Name
            // Distribution_Channel__c = distributionChannelObj.Id,  // Distribution Channel
            Depot_Code__c = 'AR13',                       // Depot Code
            Country__c = 'Other'
            //AuthorizationGroupSalesoffice__c ='S091'
        ); 
        insert accObj;
        
        
        
        
        
        Opportunity oportunidadNueva = new Opportunity();
        oportunidadNueva.Name = 'TEst';
        oportunidadNueva.StageName='Contratada';
        oportunidadNueva.CloseDate=Date.today();
        oportunidadNueva.CurrencyIsoCode='MXN';
        oportunidadNueva.AccountId = accObj.Id;
        oportunidadNueva.Country_of_Origin__c = 'India';
        
        insert oportunidadNueva;
        
        Product2 pro = new Product2(
            Name = 'iPhone X', Family = 'Mobile', Sales_Org__c = salesOrgObj.id,Combination_Key__c='123456789');
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            CurrencyIsoCode = oportunidadNueva.CurrencyIsoCode,
            IsActive = true
        );
        Insert pbe;
        
        //Query the PricebookEntry record
        pbe = [SELECT Id, Pricebook2.IsStandard FROM PricebookEntry];
        //It should return true
        System.assertEquals(true, pbe.Pricebook2.IsStandard);
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=oportunidadNueva.Id, UnitPrice=0.01, PriceBookEntryId=pbe.Id);
        insert OPplineitem2;
        
        Quote objquote=new Quote();
        objquote.Name='TestQuote';
        //objquote.AccountID=accObj.id;
        objquote.OpportunityID=oportunidadNueva.id;
        objquote.Carriage_By__c ='Sea';
        objquote.SGS_Inspection__c ='Yes';
        insert objquote;
        
        QuoteLineItem objquotelineitem=new QuoteLineItem();
        objquotelineitem.QuoteID=objquote.id;
        objquotelineitem.Product2ID=pro.id;
        objquotelineitem.Quantity=2;
        objquotelineitem.UnitPrice=45.78;
        objquotelineitem.PricebookEntryId=pbe.Id;
        insert objquotelineitem;
        
        List<QuoteLineItem> qliList =[SELECT Id, QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, 
                                      Description, Product2Id,  ListPrice, Subtotal, TotalPrice, Sales_Org__c, 
                                      Description_of_Goods__c, Pack_Size__c, opportunity_line_item_id__c FROM QuoteLineItem];
        
        QuoteProductEntry_Controller.fetchSKUValues('searchKeyWord', objquote.Id);
        QuoteProductEntry_Controller.searchHelperOnKeyPres('iPhone X',  objquote.Id);
        QuoteProductEntry_Controller.saveQuoteLineItem(qliList);
        QuoteProductEntry_Controller.fetchAllQuoteItem(objquote.Id);
        QuoteProductEntry_Controller.fetchsingleQuoteLineItem(qliList[0].Id);
        QuoteProductEntry_Controller.updateQuoteLineItem(qliList);
        QuoteProductEntry_Controller.searchHelperOnKeyPresPopup('iPhone X',  objquote.Id);
        //QuoteProductEntry_Controller.submitToApproval(objquote.Id);
        QuoteProductEntry_Controller.checkApprovalProcess(objquote.Id);
        QuoteProductEntry_Controller.deleteQuoteLineItms(qliList[0].Id);         
        
    }
}