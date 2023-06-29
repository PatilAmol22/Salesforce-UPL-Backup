@isTest(SeeAllData=false)
public class Grz_AccountLedgerStatementTest {
    Public  static testmethod void testAccountLedgerStatement(){
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
        Grz_AccountLedgerStatement.getAccInfo();
        String doc = 'RV,DG';
        List<String> docType = doc.split(',');
        List<String> emptyDocType = new List<String>();
       	Grz_AccountLedgerStatement.getAccountStatement('1001801', '1200', '2020', '1', '3', docType, '2020-04-01', '2021-03-31', true,'test', String.valueOf(acc.Id));
        Grz_AccountLedgerStatement.getAccountStatement('1001801', '1200', '2020', '1', '3', emptyDocType, '2020-04-01', '2021-03-31', true,'test', String.valueOf(acc.Id));
        Grz_AccountLedgerStatement.getLedgerStatement('1001801', '1200', '2020', '1', '3', true,'test',String.valueOf(acc.Id)); 
        Grz_AccountLedgerStatement.SendMail('https://uat-upl.cs72.force.com/uplpartnerportal/apex/Grz_LedgerStatementDownload?fiscalYear=2022&customerCode=0001011649&companyCode=1000&fiscalYearFrom=4&fiscalYearTo=6&sapUserId=UPLINTCRM', '2020-04-01', '2021-03-31');
        Grz_AccountLedgerStatement.ItemInfo ifo =  new Grz_AccountLedgerStatement.ItemInfo();
        
        ifo.Date1 = '2020-03-02';
        ifo.DocNumber = '2020-03-02';
        ifo.PostingDate = '2020-03-02';
        ifo.ReferenceDocumentNumber = '2020-03-02';
        ifo.ReferebceChqNumber = '2020-03-02';
        ifo.RunningBalance = '2020-03-02';
        ifo.DocumentHeaderText = '2020-03-02';
        ifo.AccountingDocNumber = '2020-03-02';
        Grz_AccountLedgerStatement.CustomerInfo cfo =  new Grz_AccountLedgerStatement.CustomerInfo();
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