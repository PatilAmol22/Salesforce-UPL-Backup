/**************************************************************************************************
* Name             : Grz_ArgentinaAccountReceivableTest                                                     
* Description      : To cover the controller class Grz_ArgentinaAccountReceivable
* Created Date     : 23-08-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 10-10-2022                                                                        
**************************************************************************************************/

@isTest
public class Grz_ArgentinaAccountReceivableTest {
    
	Public  static testmethod void testgetInvoiceDelivery(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Test.startTest();
        Grz_ArgentinaAccountReceivable.getArgentinaPDFData('6050285064','2145135','2022','R1');
        Test.stopTest();
        Grz_ArgentinaAccountReceivable.getArgentinaPDFData('6050285064','0021300009','2022','DA');
        
    }
    Public  static testmethod void testAccountLedgerVFARG(){
        
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
        ApexPages.currentPage().getParameters().put('fiscalMonthStart', String.valueOf(8));
        ApexPages.currentPage().getParameters().put('fiscalMonthEnd', String.valueOf(8));
        ApexPages.currentPage().getParameters().put('sDate', '2022-01-01');
        ApexPages.currentPage().getParameters().put('eDate', '2022-01-10');
        Grz_ArgentinaAccountReceivable.getAccountLedgerDataArg();
        Grz_ArgentinaAccountReceivable.getArgentinaArData('0001006761');
    }
   
    Public  static testmethod void testgetArAndLedgerData(){
        
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
           
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        User usr=new User();
        System.runAs(usr1){
            Group gg = Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        }   
        Test.startTest(); 
        Grz_ArgentinaAccountReceivable.getArAndLedgerData('Customer', '2021', '8','9','2022-01-01','2022-11-11');
        Grz_ArgentinaAccountReceivable.getArgentinaArData('ArLedgerCmp');
         Test.stopTest();        
    }
}