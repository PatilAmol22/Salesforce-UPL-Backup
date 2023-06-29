@isTest
public with sharing class AccountLookupControllerTest {
    @TestSetup
    public static void makeData(){
        
        Sales_Org__c sales_org = new Sales_Org__c();
        sales_org.Name = 'Colombia';
        sales_org.Sales_Org_Code__c = '5710';
        sales_org.CurrencyIsoCode = 'INR';
        insert sales_org;
        
          Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a = new Account();
        a.Name = 'Name';
        a.Email__c= 'email@example.com';
        a.RecordTypeId = recordTypeId;
        a.CurrencyIsoCode = 'COP';
        a.Sales_Org__c = sales_org.Id;
        insert a;
        
        User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'last',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);
        insert u;
       
        
        //SELECT Id, Name, AccountOwner__c, Distributor__c FROM DistributorSalesAreaMapping__c where Distributor__c='0010k00000n5MrYAAU'
        DistributorSalesAreaMapping__c sales_area = new DistributorSalesAreaMapping__c();
        //sales_area.Name = 'sales_area';
        sales_area.AccountOwner__c = u.Id;
        sales_area.Distributor__c = a.Id;
        
        insert sales_area;
        
         SKU__c sku1 = new SKU__c();
        sku1.Name='Stest';
        sku1.SKU_Description__c = 'product_name_sku';
        sku1.SKU_code__c = '001';
        sku1.Active__c = true;
        sku1.Brand_Name__c = 'brand';
        sku1.SKU_Description__c='description';
        insert sku1; 
        
        //select id,Name,Brand_Name__c,SKU__c.Product_Name__c from SKU__c where Brand_Name__c like '%%'
        Product2 p2=new Product2();
        p2.Name = 'test';
        p2.Product_Code__c = '002';
        p2.Combination_Key__c='57101010002';
        insert p2;  
        
       // Customer_and_Region_Mapping__c cr=new Customer_and_Region_Mapping__c();
        //cr.Customer_Region__c='';
        //cr.TerritoryManager__c='';
        //cr.CustomerName_Formula_Field__c='';
        //cr.Customer_Name__c=u.Name;
       // insert cr;
    }
    
   

    @istest
    public static void searchedListTest(){
        //makeData();
        List<Account> lstacc = [select Name,Email__c from Account];
        System.debug('lst acc'+lstacc);
        DistributorSalesAreaMapping__c dsm  = [select id,Name,AccountOwner__c,Account_Owner_Name__c from DistributorSalesAreaMapping__c limit 1];
        System.debug('DSM '+dsm);
        SKU__c sk=[select id,Name from SKU__c limit 1];
        Product2 p=[select id,Name,Product_Code__c,Combination_Key__c from Product2 limit 1];
        Test.startTest();
         AccountLookupController.searchedList('Account','Name,Email__c','na','Email__c=\''+'email@example.com'+'\'',false,'Name');
        
        AccountLookupController.searchedList('DistributorSalesAreaMapping__c','Name, AccountOwner__c,Account_Owner_Name__c, Distributor__c ','','Name=\''+dsm.Name+'\'',false,'Account_Owner_Name__c');
        
        AccountLookupController.searchedList('SKU__c','Name,Brand_Name__c,Product_Name__c','','Brand_Name__c=\''+'brand'+'\'',false,'Brand_Name__c');
        
        AccountLookupController.searchedList('SKU__c','SKU_Description__c,SKU_code__c','','Id=\''+sk.Id+'\'',false,'SKU_Description__c');

        AccountLookupController.searchedList('Product2','Name,Product_Code__c','','Name=\''+p.Name+'\'',false,'Name');
        
        AccountLookupController.searchedList('Customer_and_Region_Mapping__c','Name','','Name=\''+'%'+'\'',false,'CustomerName_Formula_Field__c');
        Test.stopTest();
    }
}