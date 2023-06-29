@isTest
public class Grz_AccountReceivableControllerTest {
    Public  static testmethod void teststockManagement(){
         
         Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
         
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.Tax_Number_1__c = '1234';
        acc.Customer_Group__c = '97';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
         Test.startTest(); 
        Grz_AccountReceivableReportController.getuserInfo();
        Grz_AccountReceivableReportController.getAccountReceivables('0001033914','UPLINTCRM','5190','All','0001033252');
       
        Test.stopTest(); 
        Grz_AccountReceivableReportController.getAccountReceivables('0001033914','UPLINTCRM','5190','0001033914','');
        Grz_AccountReceivableReportController.ResultWrapper wrap = new Grz_AccountReceivableReportController.ResultWrapper();
        wrap.Message = 'test';
        wrap.isMainParent = false;
    }
    Public  static testmethod void teststockManagement1(){
         
         Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
         
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.Tax_Number_1__c = '1234';
        acc.Customer_Group__c = '97';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
         Test.startTest(); 
        Grz_AccountReceivableReportController.getuserInfo();
        Grz_AccountReceivableReportController.getAccountReceivables('0001033914','UPLINTCRM','5190','0001033252','');
       
        Test.stopTest(); 
    }
}