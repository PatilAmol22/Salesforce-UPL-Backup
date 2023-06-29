@isTest
public class Grz_AccountLedgerMexicoVFControllerTest {
    
    Public  static testmethod void testAccountLedgerVFMx(){
        
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(false, 'Mexico','5100');
        sOrg.Company_Code__c = '5000';
        insert sOrg;
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '0001006761';
        acc.sap_UserId__c = 'UPLINTCRM';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
           
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        User usr=new User();
        System.runAs(usr1){
            Group gg = Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        }
        
        Test.stopTest(); 
        ApexPages.currentPage().getParameters().put('customerCode', String.valueOf(acc.SAP_Code__c));
        ApexPages.currentPage().getParameters().put('fiscalYear', String.valueOf(2021));
        ApexPages.currentPage().getParameters().put('fiscalMonth', String.valueOf(8));
        Grz_AccountLedgerMexicoVFController.getAccountLedgerDataMx();
    }
    
    Public  static testmethod void testAccountLedgerStatementMx2(){
        
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(false, 'Mexico','5100');
        sOrg.Company_Code__c = '5000';
        insert sOrg;
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '0001006761';
        acc.sap_UserId__c = 'UPLINTCRM';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
           
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        User usr=new User();
        System.runAs(usr1){
            Group gg = Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        }        
        Test.stopTest(); 
        Grz_MexicoArAndLedgerController.getArAndLedgerData('Customer', '2021', '8');
        Grz_MexicoArAndLedgerController.ItemInfo info = new Grz_MexicoArAndLedgerController.ItemInfo();
        info.Assignment = '123456';
        info.PostDate = '2020-03-02';
        info.DocCurrency = 'INR';
        info.CollectionExecutive = 'Test User';
        info.AmtInDocCurrency = '34577.22';
        info.AmtInLocalCurrency= '456789.2';
		Grz_MexicoArAndLedgerController.CustomerInfo cinfo = new Grz_MexicoArAndLedgerController.CustomerInfo();
        cinfo.City = 'Test';
        cinfo.CustomerCode = '12345876';
        cinfo.CustomerName = 'Test Name';            
    }
}