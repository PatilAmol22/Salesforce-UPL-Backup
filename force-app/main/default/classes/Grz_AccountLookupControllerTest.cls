@isTest
public class Grz_AccountLookupControllerTest {
    Public  static testmethod void testController(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'India','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Grazitti Test Account',recordTypeId,sOrg.Id);
        Territory_Distributor__c terr = Grz_TestDataFactory.createTeritory(true);
        DistributorSalesAreaMapping__c sa = Grz_TestDataFactory.CreateSalesArea(true,acc,sOrg.Id,terr.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
        Group gg=Grz_TestDataFactory.creategroup(true);
        usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Test.startTest();
        String result=Grz_AccountLookupController.searchDB('Account','Id','Name',1,'Name','Grazitti');
        System.assertNotEquals(result, null);
        Grz_AccountLookupController.ResultWrapper result1 = Grz_AccountLookupController.AccountUserInfo(acc.Id);
        System.assertNotEquals(result1, null);
        Test.stopTest();
    }
}