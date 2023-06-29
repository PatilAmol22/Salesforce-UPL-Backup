@isTest(SeeAllData=false)
public class Grz_GstInformationTest {
    Public  static testmethod void testGstInfo(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false)); 
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
        System.runAs(usr){
        	Grz_GstInformation.getSalesAreaOptions();
        }
        Test.stopTest(); 
        Grz_GstInformation.getGstInformation('2021-01-01', '2021-03-31','01290132');
        Grz_GstInformation.GstInfo gs = new Grz_GstInformation.GstInfo();
        gs.CGSTValue = 'test';
        gs.CommercialInvoiceNo = 'test';
        gs.DeliveryDate = 'test';
        gs.DeliveryNo = 'test';
        gs.GSTInvoiceNo = 'test';
        gs.InvoiceDate = 'test';
        gs.ISTValue  = 'test';
        gs.Profit_center = 'test';
        gs.Sales_order_no = 'test';
        gs.SGST_UGSTValue = 'test';
        gs.TaxableValue = 'test';
        gs.TotalGSTValue = 'test';
        gs.TotalInvoiceValue = 'test';
    }
}