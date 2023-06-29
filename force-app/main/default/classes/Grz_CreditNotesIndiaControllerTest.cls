@isTest(SeeAllData=false)
public class Grz_CreditNotesIndiaControllerTest {
    Public  static testmethod void testCrditNotes(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        
        System.runAs(usr1){
            
            User usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        }
        Test.stopTest(); 
        Grz_CreditNotesIndiaController.getAccInfo();
        Grz_CreditNotesIndiaController.getLedgerStatement('1001801', '1200', '2020', '1', '3', true,'test',String.valueOf(acc.Id)); 
        Grz_CreditNotesIndiaController.ItemInfo ifo =  new Grz_CreditNotesIndiaController.ItemInfo();
        ifo.Date1 = '2020-03-02';
        ifo.DocNumber = '2020-03-02';
        ifo.PostingDate = '2020-03-02';
        ifo.ReferenceDocumentNumber = '2020-03-02';
        ifo.ReferebceChqNumber = '2020-03-02';
        ifo.RunningBalance = '2020-03-02';
        ifo.DocumentHeaderText = '2020-03-02';
        ifo.AccountingDocNumber = '2020-03-02';
        Grz_CreditNotesIndiaController.CustomerInfo cfo =  new Grz_CreditNotesIndiaController.CustomerInfo();
        cfo.CustomerName = '2020-03-02';
        cfo.CustomerCode = '2020-03-02';
        cfo.City = '2020-03-02';
        cfo.SalesOffice = '2020-03-02';
        cfo.GlAccountName = '2020-03-02';
        cfo.GlAccountNumber = '2020-03-02';
        cfo.GlAccountLongText = '2020-03-02';
        cfo.Plant = '2020-03-02';
        
    }
}