@isTest
public class PreventNewSalesAgreementTest {

    @testSetup
    static void  makeData(){
        User user1 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Demand Planning Administrator'].Id,
        LastName = 'Brazil Demand Planning Administrator',
        Email = 'tm@test.com',
        Username = 'tm@test.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US'
        );
        insert user1;
    }
    
    @isTest
    public static void testIsCreatable(){
        User user1 = [select Id,Name,ProfileId,Profile.Name from User limit 1];
        System.runAs(user1){
            System.debug('User Profile '+user1.Profile.Name);
            boolean isCreateable = PreventNewSalesAgreement.isNotCreatable();
            
        }
    }
    @isTest
    public static void deleteSalesAgreement(){
        
        
        User territoryManager = new User(
    ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person'].Id,
    LastName = 'TM',
    Email = 'tm@test.com',
    Username = 'tm@test.com' + System.currentTimeMillis(),
    CompanyName = 'TEST',
    Title = 'title',
    Alias = 'alias',
    TimeZoneSidKey = 'America/Los_Angeles',
    EmailEncodingKey = 'UTF-8',
    LanguageLocaleKey = 'en_US',
    LocaleSidKey = 'en_US'
    
    );
    insert territoryManager;

        Sales_Org__c sales_org = new Sales_Org__c();
    sales_org.Name = 'Brazil';
    sales_org.Sales_Org_Code__c = '5191';
    sales_org.CurrencyIsoCode = 'INR';
    insert sales_org;

        Product2 prod = new Product2(Name = 'Laptop X200',
                                     Family = 'Hardware',
                                    Active__c = True,
                                    Combination_key__c = 'abcd');
        insert prod;
       
        Id pricebookId = Test.getStandardPricebookId();
       
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
       
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
       
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
    Region__c region = new Region__c();
    region.Name = 'region1';
    region.RegionCode__c = '58';
    region.SalesOrg__c = sales_org.Id;
    insert region;
        
Territory_Distributor__c territory = new Territory_Distributor__c();
    territory.Name='territory1';
    territory.TerritoryManager__c = territoryManager.Id;
    territory.Region__c = region.Id;
    territory.SalesOrg__c = sales_org.Id;
    insert territory;

//Pricebook2 standardPricebook = [select Id,IsStandard from Pricebook2 where isStandard=true limit 1];
Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    Account a = new Account();
    a.Name = 'Name';
    a.Email__c= 'email@example.com';
    a.RecordTypeId = recordTypeId;
    a.CurrencyIsoCode = 'INR';
    a.Is_Forecast_Required__c = true;
    a.Sales_Org__c = sales_org.Id;
    insert a;
        
	SalesAgreement salesAgmt = new SalesAgreement();
	salesAgmt.Region__c = territory.Id;
	salesAgmt.Year__c = '2021';
	salesAgmt.Name='sales_agreement';
	salesAgmt.Status = 'Draft';
	salesAgmt.Active_Forecast_Month__c='April';
    salesAgmt.StartDate= Date.valueOf(System.Now());
    salesAgmt.ScheduleFrequency = 'Monthly';
    salesAgmt.ScheduleCount = 12;  
    salesAgmt.PricebookId = customPB.Id;
    salesAgmt.AccountId = a.Id;
insert salesAgmt;
       
   //  delete SalesAgmt;
                Test.startTest();
        Database.DeleteResult result = Database.delete(salesAgmt, false);
         Test.stopTest();
    }
    
    
}