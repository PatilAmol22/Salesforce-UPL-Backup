@isTest
public class Grz_PricesDiscountsTest {
    Public  static testmethod void testPriceDiscount(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        User usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        SKU__c sk = Grz_TestDataFactory.createSKU(true);
        Grz_TestDataFactory.createPriceBook(true, acc.Id, sk.Id);
        Test.startTest();
        Account a=Grz_PricesDiscounts.getAccInfo();
        System.assertNotEquals(a,null);
        Test.stopTest();
    }
}