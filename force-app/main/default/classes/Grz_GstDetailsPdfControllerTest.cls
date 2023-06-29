@isTest(SeeAllData=false)
public class Grz_GstDetailsPdfControllerTest {
    Public  static testmethod void testGstInfoPdf(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
        Group gg=Grz_TestDataFactory.creategroup(true);
        usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Grz_GstDetailsPdfController.formatNumber('44');
        Grz_GstDetailsPdfController obj = new Grz_GstDetailsPdfController();
        obj.gstDetailsFxn();
          Test.stopTest();
          
     
    }
}