@isTest
public class AccountRedirectExtension_test{
  
    
    @testSetup
    static void allTheDataForThisTestClass() {
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
            Name='Bhavik Devdhar',
            SAP_Code__c = '0001013292', 
            PriceGroupCode__c=pg.id,
            RecordTypeId=devRecordTypeId,							// SAP Customer Code
            Last_Name__c = 'ADECO AGROPECUARIA S.A.',     // Last Name
            Order_Block__c = false,                       // Order Block
            Mobile__c = '9405883688',  
            Phone='020256589', // Mobile
            Email__c = 'marcelo.gorla@uniphos.com',       // Email
            Account_Type__c = 'Sold To Party',            // Account Type
            Raise_Order_Type__c = 'Both',                 // Raise Order Type
            Billing_Street_2__c = 'CATAMARCA 3454',       // Billing Street 2
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            Division__c = divisionObj.Id,              // Division Name
            Distribution_Channel__c = distributionChannelObj.Id,  // Distribution Channel
            Depot_Code__c = 'AR13',                       // Depot Code
            Partner_Function__c ='Z1',
            CustomerAccountGroup__c= 'Z031'
            
        );
        insert accObj;
    }
    
    static testMethod void method1() {
        
        
       
        Account accObjs =[select id,Name from Account LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(accObjs);
        AccountRedirectExtension accReObj = new AccountRedirectExtension(sc);
        
        /*PageReference pageRef = Page.SetPickList;
        Test.setCurrentPage(pageRef);
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        pageRef.getParameters().put('RecordTypeId',devRecordTypeId);*/
        
        
       accReObj.redirect();
   }
    
  
}