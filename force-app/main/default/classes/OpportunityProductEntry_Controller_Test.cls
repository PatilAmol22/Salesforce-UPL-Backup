@isTest
public class OpportunityProductEntry_Controller_Test {
    
    
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
        oportunidadNueva.Country_of_Origin__c ='India';
        
        insert oportunidadNueva;
        
        Product2 pro = new Product2(
            Name = 'iPhone X', Family = 'Mobile',
            Sales_Org__c = salesOrgObj.id,
        Combination_Key__c ='1234567890fgh');
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

        
        
       
        
        Opportunity oppObj = [select Id, Name From Opportunity LIMIT 1];
        Sales_Org__c SalesOrgObj1 = [SELECT ID,Name FROM Sales_Org__c LIMIT1]; 
        List<OpportunityLineItem> opplItemList = [SELECT Id, OpportunityId, PricebookEntryId, Product2Id, ProductCode, Name, 
                                     Quantity, TotalPrice, UnitPrice, ListPrice, 
                                     ServiceDate, Description,  Sales_Org__c, Pack_Size__c 
                                     FROM OpportunityLineItem];
        
        System.debug('opplItemList in test class '+opplItemList);
        System.debug('opplItemList in test class size '+opplItemList.size());
        
        OpportunityProductEntry_Controller.fetchSKUValues('searchKeyWord', oppObj.Id);
        OpportunityProductEntry_Controller.fetchAllOppoLineItem(oppObj.Id);
        OpportunityProductEntry_Controller.fetchsingleOppoLineItem(opplItemList[0].Id);
        OpportunityProductEntry_Controller.searchHelperOnKeyPresPopup('iPhone X', SalesOrgObj1.Id, oppObj.Id);
        OpportunityProductEntry_Controller.searchHelperOnKeyPres('iPhone X', SalesOrgObj1.Id, oppObj.Id);
        OpportunityProductEntry_Controller.saveOpportunityLineItem(opplItemList);
        OpportunityProductEntry_Controller.updateOpportunityLineItem(opplItemList);
        OpportunityProductEntry_Controller.deleteOpportunityLineItem(opplItemList[0].Id);
            
    }
    
}