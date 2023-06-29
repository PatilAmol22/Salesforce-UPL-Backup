@IsTest
public class Grz_MexicoAccountReceivableTest {
     public static testmethod void AccountReceivablesMexico()
        {
            Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
            Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Mexico', '5100');
            Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
            Account acc = Grz_TestDataFactory.createAccount(false, 'Test Account',recordTypeId);
            acc.SAP_Code__c = '0001006761';
          
            acc.sap_UserId__c = 'UPLINTCRM';
            acc.Sales_Org__c = sorg.Id;
            insert acc;
             
           
            Contact con = Grz_TestDataFactory.createContact(true, 'Test12345',acc.Id);
            Profile pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
        	
            Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
       		User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        		User usr=new User();
        	System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }

            test.startTest();
            Grz_MexicoAccountReceivable.getMexicoArData('HomePageArGraph');
             Grz_MexicoAccountReceivable.getMexicoArData('ArGraph');
           
            test.stopTest();
            
          
        }
      public static testmethod void AccountReceivablesMexico1()
        {
            Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
            Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Mexico', '5100');
            Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
            Account acc = Grz_TestDataFactory.createAccount(false, 'Test Account',recordTypeId);
            acc.SAP_Code__c = '0001006761';
          
            acc.sap_UserId__c = 'UPLINTCRM';
            acc.Sales_Org__c = sorg.Id;
            insert acc;
             
           
            Contact con = Grz_TestDataFactory.createContact(true, 'Test12345',acc.Id);
            Profile pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
        	
            Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
       		User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        		User usr=new User();
        	System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }

            test.startTest();
           
            Grz_MexicoAccountReceivable.getMexicoArData( acc.SAP_Code__c);
            test.stopTest();
            
          
        }
}