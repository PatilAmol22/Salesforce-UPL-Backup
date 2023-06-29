@isTest(SeeAllData=false)
public class Grz_AccountStatDonutChartControllerTest {
	
    Public  static testmethod void testAccountStatementData(){
        
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
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
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        } 
        Test.stopTest();
        Grz_AccountStatDonutChartController.getAccountStatementData('0');
         
    }
    
    Public  static testmethod void testAccountStatementData1(){
        
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(false, 'Mexico','5100');
        sOrg.Company_Code__c = '5000';
        insert sOrg;
		Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '0001006761';
        acc.sap_UserId__c = 'UPLINTCRM';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        } 
        Test.stopTest();
        Grz_AccountStatDonutChartController.getAccountStatementData('1');
         
    }
}