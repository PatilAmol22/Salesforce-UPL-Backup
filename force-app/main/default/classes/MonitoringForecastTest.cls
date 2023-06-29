@isTest
public with sharing class MonitoringForecastTest {
@isTest(seeAllData=true)
static void makeData(){
    Sales_Org__c sales_org = new Sales_Org__c();
    sales_org.Name = 'Brazil';
    sales_org.Sales_Org_Code__c = '5191';
    sales_org.CurrencyIsoCode = 'INR';
    insert sales_org;

    Region__c region = new Region__c();
    region.Name = 'region1';
    region.RegionCode__c = '58';
    region.SalesOrg__c = sales_org.Id;
    insert region;
    List<Account> accounts = new List<Account>();    
    Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    Account a = new Account();
    a.Name = 'Name';
    a.Email__c= 'email@example.com';
    a.RecordTypeId = recordTypeId;
    a.CurrencyIsoCode = 'INR';
    a.Is_Forecast_Required__c = true;
    a.Sales_Org__c = sales_org.Id;
    //insert a;
    accounts.add(a);

    Account a1 = new Account();
    a1.Name = 'Name1';
    a1.Email__c= 'email1@example.com';
    a1.RecordTypeId = recordTypeId;
    a1.CurrencyIsoCode = 'INR';
    a1.Is_Forecast_Required__c = true;
    a1.Sales_Org__c = sales_org.Id;
    //insert a1;
    accounts.add(a1);
    insert accounts;
    
	List<User> users = new List<User>();    
    User RegionalManager = new User(
    ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales District Manager'].Id,
    LastName = 'RM',
    Email = 'rm@test.com',
    Username = 'rm@test.com' + System.currentTimeMillis(),
    CompanyName = 'TEST',
    Title = 'title',
    Alias = 'alias',
    TimeZoneSidKey = 'America/Los_Angeles',
    EmailEncodingKey = 'UTF-8',
    LanguageLocaleKey = 'en_US',
    LocaleSidKey = 'en_US'
    );
    insert RegionalManager;
    //users.add(RegionalManager);

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
    LocaleSidKey = 'en_US',
    Manager=RegionalManager
    );
    //insert territoryManager;
    users.add(territoryManager);
	insert users;
    Territory_Distributor__c territory = new Territory_Distributor__c();
    territory.Name='territory1';
    territory.TerritoryManager__c = territoryManager.Id;
    territory.Region__c = region.Id;
    territory.SalesOrg__c = sales_org.Id;
    insert territory;
    
   Product2 prod = new Product2();
    prod.Active__c = true;
    prod.Name = 'Product_test';
    prod.Combination_Key__c ='abvcf';
    insert prod;

    
    
    Pricebook2 standardPricebook = [select Id,IsStandard from Pricebook2 where isStandard=true limit 1];
    
    //standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
	//System.assertEquals(true, standardPricebook.IsStandard);
	//System.debug('standardPricebook.IsStandard -->'+standardPricebook.IsStandard);
    
    
    PricebookEntry pbe = new PricebookEntry(
    Pricebook2Id = standardPricebook.Id,
    Product2Id = prod.Id,
    UnitPrice = 1020,
    IsActive = true
    );
    Insert pbe;

    
   SalesAgreement salesAgmt = new SalesAgreement();
	salesAgmt.Region__c = territory.Id;
	salesAgmt.Year__c = '2021';
	salesAgmt.Name='sales_agreement';
	salesAgmt.Status = 'Draft';
	salesAgmt.Active_Forecast_Month__c='April';
    salesAgmt.StartDate= Date.valueOf(System.Now());
    salesAgmt.ScheduleFrequency = 'Monthly';
    salesAgmt.ScheduleCount = 12;  
    salesAgmt.PricebookId = standardPricebook.Id;
    salesAgmt.AccountId = a.Id;
	insert salesAgmt;

    
    Forecast_Account__c crm = new Forecast_Account__c();
	crm.Territory__c = territory.Id;
	crm.Account__c = a.Id;
    crm.Combination_Key__c = 'BR001';
	insert crm;
    Forecast_Account__c crm1 = new Forecast_Account__c();
	crm1.Territory__c = territory.Id;
    crm1.Combination_Key__c = 'BR002';
	crm1.Account__c = a1.Id;
	insert crm1;
    
    String indicator = 'All';
    String salesDistrict = '';
    String salesRep  = '';
    String salesorg  = '5191';
    String month = 'April';
    String year = '2021';
    String territory_id = '';
    String filter = '{"indicator":"'+indicator+'","salesDistrict":"'+salesDistrict+'","salesRep":"'+salesRep+'","salesorg":"'+salesorg+'","month":"'+month+'","year":"'+year+'","territory_id":"'+territory_id+'"}';
    
    salesRep = territoryManager.Id;

    filter = '{"indicator":"'+indicator+'","salesDistrict":"'+salesDistrict+'","salesRep":"'+salesRep+'","salesorg":"'+salesorg+'","month":"'+month+'","year":"'+year+'","territory_id":"'+territory_id+'"}';
    MonitoringForecast.getAllSaleAgreements(filter);

    salesDistrict = region.Id;
    salesRep = '';

    filter = '{"indicator":"'+indicator+'","salesDistrict":"'+salesDistrict+'","salesRep":"'+salesRep+'","salesorg":"'+salesorg+'","month":"'+month+'","year":"'+year+'","territory_id":"'+territory_id+'"}';
    MonitoringForecast.getAllSaleAgreements(filter);
    
    salesDistrict = region.Id;
    salesRep = territoryManager.Id;

    filter = '{"indicator":"'+indicator+'","salesDistrict":"'+salesDistrict+'","salesRep":"'+salesRep+'","salesorg":"'+salesorg+'","month":"'+month+'","year":"'+year+'","territory_id":"'+territory_id+'"}';
    MonitoringForecast.getAllSaleAgreements(filter);
	String salesAgmtstr = salesAgmt.Id;
    
    
    indicator = 'Blue';
    filter = '{"indicator":"'+indicator+'","salesDistrict":"'+salesDistrict+'","salesRep":"'+salesRep+'","salesorg":"'+salesorg+'","month":"'+month+'","year":"'+year+'","territory_id":"'+territory_id+'"}';
    MonitoringForecast.closeForecast(filter);
    MonitoringForecast.getSalesAgreementsBySalesRep(filter);
    MonitoringForecast.sendRemainder(filter);
    indicator = 'Yellow';
    filter = '{"indicator":"'+indicator+'","salesDistrict":"'+salesDistrict+'","salesRep":"'+salesRep+'","salesorg":"'+salesorg+'","month":"'+month+'","year":"'+year+'","territory_id":"'+territory_id+'"}';
    MonitoringForecast.sendRemainder(filter);
    String jsonStr = JSON.serialize(new List<String>{salesAgmtstr});
    MonitoringForecast.recallSalesAgreements(jsonStr);
    
    indicator = 'Red';
    filter = '{"indicator":"'+indicator+'","salesDistrict":"'+salesDistrict+'","salesRep":"'+salesRep+'","salesorg":"'+salesorg+'","month":"'+month+'","year":"'+year+'","territory_id":"'+territory_id+'"}';
    MonitoringForecast.sendRemainder(filter);
    MonitoringForecast.asyncCloseForecast(filter);
}
}