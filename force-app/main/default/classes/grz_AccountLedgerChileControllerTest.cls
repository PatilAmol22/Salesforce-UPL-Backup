@isTest(SeeAllData=false)
public class grz_AccountLedgerChileControllerTest {
     Public  static testmethod void testAccountLedgerStatement(){
          
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5661');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Chile Partner Community Distributor Profile'];
        User usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        Test.startTest(); 
        grz_AccountLedgerChileController.getAccInfo();
        String doc = 'RV,DG';
        List<String> docType = doc.split(',');
        List<String> emptyDocType = new List<String>();
        grz_AccountLedgerChileController.getAccountStatement('0001085868', '5660', '2021', '4', '8', docType, '2020-03-01', '2021-05-31', true,'test');
      //  grz_AccountLedgerChileController.getAccountStatement('0001085868', '5660', '2021,', '4', '8', emptyDocType, '2020-04-01', '2021-03-31', true,'test');
       // grz_AccountLedgerChileController.getLedgerStatement('0001085868', '5660', '2021', '4', '8', true,'test'); 
     //    grz_AccountLedgerChileController.getCustomerRecord('0001085868'); 
        grz_AccountLedgerChileController.ItemInfo ifo =  new grz_AccountLedgerChileController.ItemInfo();
        
        ifo.Date1 = '2020-03-02';
        ifo.DocNumber = '2020-03-02';
        ifo.PostingDate = '2020-03-02';
        ifo.ReferenceDocumentNumber = '2020-03-02';
        ifo.ReferebceChqNumber = '2020-03-02';
        ifo.RunningBalance = '2020-03-02';
        ifo.DocumentHeaderText = '2020-03-02';
        ifo.AccountingDocNumber = '2020-03-02';
        grz_AccountLedgerChileController.CustomerInfo cfo =  new grz_AccountLedgerChileController.CustomerInfo();
        cfo.CustomerName = '2020-03-02';
        cfo.CustomerCode = '2020-03-02';
        cfo.City = '2020-03-02';
        cfo.SalesOffice = '2020-03-02';
        cfo.GlAccountName = '2020-03-02';
        cfo.GlAccountNumber = '2020-03-02';
        cfo.GlAccountLongText = '2020-03-02';
        cfo.Plant = '2020-03-02';
        Test.stopTest(); 
        
    }
    
    
    
    
    
     Public  static testmethod void testAccountLedgerStatement1(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5661');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Chile Partner Community Distributor Profile'];
        User usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        Test.stopTest(); 
        grz_AccountLedgerChileController.getAccInfo();
        String doc = 'RV,DG';
        List<String> docType = doc.split(',');
        List<String> emptyDocType = new List<String>();
        //grz_AccountLedgerChileController.getAccountStatement('0001085868', '5660', '2021', '4', '8', docType, '2020-04-01', '2021-03-31', true,'test');
       // grz_AccountLedgerChileController.getAccountStatement('0001085868', '5660', '2021,', '4', '8', emptyDocType, '2020-04-01', '2021-03-31', true,'test');
        grz_AccountLedgerChileController.getLedgerStatement('0001085868', '5660', '2021', '4', '8', true,'test'); 
         grz_AccountLedgerChileController.getCustomerRecord(acc.Id); 
        grz_AccountLedgerChileController.ItemInfo ifo =  new grz_AccountLedgerChileController.ItemInfo();
        
        ifo.Date1 = '2020-03-02';
        ifo.DocNumber = '2020-03-02';
        ifo.PostingDate = '2020-03-02';
        ifo.ReferenceDocumentNumber = '2020-03-02';
        ifo.ReferebceChqNumber = '2020-03-02';
        ifo.RunningBalance = '2020-03-02';
        ifo.DocumentHeaderText = '2020-03-02';
        ifo.AccountingDocNumber = '2020-03-02';
        grz_AccountLedgerChileController.CustomerInfo cfo =  new grz_AccountLedgerChileController.CustomerInfo();
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