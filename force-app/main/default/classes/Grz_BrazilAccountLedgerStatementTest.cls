@isTest(SeeAllData=false)
public class Grz_BrazilAccountLedgerStatementTest {
    Public  static testmethod void testOne(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Grz_BrazilAccountLedgerStatement.getAccInfo();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '1001801';
        insert acc;
        String doc = 'RV,DG';
        List<String> docType = doc.split(',');
        List<String> emptyDocType = new List<String>();
        Test.stopTest(); 
        Grz_BrazilAccountLedgerStatement.getAccountStatement('1001801', '2020', '1', '3', docType, '2020-04-01', '2021-03-31', true);
        Grz_BrazilAccountLedgerStatement.ItemInfo ifo =  new Grz_BrazilAccountLedgerStatement.ItemInfo();
        ifo.Date1 = '2020-03-02';
        ifo.DocNumber = '2020-03-02';
        ifo.PostingDate = '2020-03-02';
        ifo.ReferenceDocumentNumber = '2020-03-02';
        ifo.ReferebceChqNumber = '2020-03-02';
        ifo.RunningBalance = '2020-03-02';
        ifo.DocumentHeaderText = '2020-03-02';
        ifo.AccountingDocNumber = '2020-03-02';
        Grz_BrazilAccountLedgerStatement.CustomerInfo cfo =  new Grz_BrazilAccountLedgerStatement.CustomerInfo();
        cfo.CustomerName = '2020-03-02';
        cfo.CustomerCode = '2020-03-02';
        cfo.City = '2020-03-02';
        cfo.SalesOffice = '2020-03-02';
        cfo.GlAccountName = '2020-03-02';
        cfo.GlAccountNumber = '2020-03-02';
        cfo.GlAccountLongText = '2020-03-02';
        cfo.Plant = '2020-03-02';
        
    }
    Public  static testmethod void testOne1(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Grz_BrazilAccountLedgerStatement.getAccInfo();
        String doc = 'RV,DG';
        List<String> docType = doc.split(',');
        List<String> emptyDocType = new List<String>();
        Grz_BrazilAccountLedgerStatement.getAccountStatement('1001801', '2020', '1', '3', emptyDocType, '2020-04-01', '2021-03-31', true);
        Test.stopTest(); 
    }
    Public  static testmethod void testOne2(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Grz_BrazilAccountLedgerStatement.getAccInfo();
        String doc = 'RV,DG';
        List<String> docType = doc.split(',');
        List<String> emptyDocType = new List<String>();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '1001801';
        insert acc;
        Test.stopTest(); 
        Grz_BrazilAccountLedgerStatement.getLedgerStatement('1001801', '2020', '1', '3', true); 
    }
}