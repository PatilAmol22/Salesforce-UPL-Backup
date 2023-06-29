@isTest
public with sharing class LiquidationLookupControllerTest {
    @TestSetup
    static void makeData(){

    Sales_Org__c so_indo1 = new Sales_Org__c();
    so_indo1.Name='UPL-Indonesia';
    so_indo1.Sales_Org_Code__c='6451';
    insert so_indo1;

    User usr_regional_manager = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Indonesia'].Id,
     LastName = 'RM',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Country = 'Indonesia',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_regional_manager;

     User usr_nsm = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'National sales Manager indonesia'].Id,
     LastName = 'NSM',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Country = 'Indonesia',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_nsm;
        
     User usr_tm = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager for Mexico'].Id,
     LastName = 'Territory Manager',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Country = 'Mexico',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_tm; 
        
     User usr_trm = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers for Mexico'].Id,
     LastName = 'Regional Mexico',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Country = 'Mexico',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_trm;    
        
     User usr_MD = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Directors Mexico'].Id,
     LastName = 'MD',
     Email = 'test@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Country = 'Mexico',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
     );
     insert usr_MD;    
     
    Sales_District__c sales_dis = new Sales_District__c();
     sales_dis.Name = 'sale_dist';
     sales_dis.User__c = usr_regional_manager.Id;
     sales_dis.Sales_District_Code__c = 'ID0004';
     insert sales_dis;

    Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
     Account acc1 = new Account();
     acc1.Name = 'acc1';
     acc1.Sales_District__c = sales_dis.Id;
     acc1.Account_Type__c = 'Sold To Party';
     acc1.RecordTypeId=rec_type_acc;
     acc1.Sales_Org__c = so_indo1.Id;
     acc1.SAP_Code__c = '123456';
     insert acc1;

     DistributorSalesAreaMapping__c sales_area = new DistributorSalesAreaMapping__c();
     sales_area.AccountOwner__c = usr_regional_manager.Id;
     sales_area.Distributor__c = acc1.Id;   
     insert sales_area;
        
     Shipping_Location__c ship_to_party = new Shipping_Location__c();
     ship_to_party.Distributor__c = acc1.Id;
     ship_to_party.User__c = usr_tm.Id;
     ship_to_party.Regional_manager__c = usr_trm.Id;   
     ship_to_party.Sales_District__c = sales_dis.Id;
     ship_to_party.SAP_Code__c = '0002035995';
     ship_to_party.Sales_Org__c = so_indo1.Id;
     insert ship_to_party;
   
    }

    @IsTest
    static void testLookup(){
        User usr_rm = [select id,Name from User where LastName='RM' limit 1];
        User usr_nsm = [select id,Name from User where LastName='NSM' limit 1];
        User usr_tm = [select id,Name from User where LastName='Territory Manager' limit 1];
        User usr_trm = [select id,Name from User where LastName='Regional Mexico' limit 1];
        User usr_MD = [select id,Name from User where LastName='MD' limit 1];
        Sales_District__c sales_dis = [select id,Name from Sales_District__c where Name='sale_dist' limit 1];
        Test.startTest();
        System.runAs(usr_rm){
            LiquidationLookupController.searchedList('Sales_District__c','Name,User__c','sale_di','User__r.Country = \'Indonesia\'','Name');
            LiquidationLookupController.searchedList('DistributorSalesAreaMapping__c','count( Id), Distributor__c,Distributor__r.Name,Distributor__r.SAP_code__c','sale_di','AccountType__c=\'Sold To Party\' and Distributor__r.RecordType.Name=\'Distributor\' and Distributor__r.Sales_District__c = \''+sales_dis.Id+'\' and SalesOrg__r.Sales_Org_Code__c = \'6451\' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) =1','Name');
        	LiquidationLookupController.searchedList('Sales_District__c','Name,User__c','sale_di','','Name');
        }
        System.runAs(usr_nsm){
            LiquidationLookupController.searchedList('Sales_District__c','Name,User__c','sale_di','User__r.Country = \'Indonesia\'','Name');
            LiquidationLookupController.searchedList('Sales_District__c','Name,User__c','sale_di','','Name');
        }
        System.runAs(usr_tm){
            //obj,Name,value,filter,display_field
            LiquidationLookupController.searchedList('Shipping_Location__c','Name,Sales_District__c,Distributor__c,Location_Name__c,City__c','','','sales_district');
        }
        System.runAs(usr_trm){
            LiquidationLookupController.searchedList('Shipping_Location__c','Name,Sales_District__c,Distributor__c,Location_Name__c,City__c','','','distributor');
        }
        System.runAs(usr_MD){
            LiquidationLookupController.searchedList('Shipping_Location__c','Name,Sales_District__c,Distributor__c,Location_Name__c,City__c','','','Location_Name__c');
        }
        Test.stopTest();
    }
}