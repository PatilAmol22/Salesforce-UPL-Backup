@IsTest
public class Grz_AccountReceivablesChileTest {
     public static testmethod void AccountReceivablesChile()
        {
            Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
            Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Chile', '5661');
            Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
            Account acc = Grz_TestDataFactory.createAccount(false, 'Test Account',recordTypeId);
            acc.SAP_Code__c = '1234567';
            acc.Sales_Org__c = sorg.Id;
            insert acc;
            Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
            Profile pro = [SELECT Id FROM Profile WHERE Name = 'Chile Partner Community Distributor Profile'];
        	User usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            Grz_AccountReceivablesChile.getCustomerRecord(acc.Id);
            Grz_AccountReceivablesChile.getuserInfo();
            test.startTest();
            Grz_AccountReceivablesChile.getAccountReceivables('0001085776','UPLINTCRM','5660','','01-01-2021','31-12-2022','01-01-2021','31-12-2021',false);
            test.stopTest();
            
            Grz_AR_FileVFControllerChile.Grz_ARactionVF();
        }
}