@isTest(SeeAllData=false)
public class grz_SapIntegrationTest {
    Public  static testmethod void testSapIntegration(){
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        //Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        //Case c = Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'Invoice', acc.Id, recordTypeShowId);
        //Case c1 = Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'Credit Limit', acc.Id, recordTypeShowId);
        //Case c2 = Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'Scheme', acc.Id, recordTypeShowId);
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
        Test.startTest();
        DateTime todaysDate = System.today();
        Date todaysDateStr = todaysDate.dateGMT();
        grz_SapIntegration.AccountAndLedgerStatementForBrazil('1000', '1001801','2021','4','5','UPLINTCRM');
        //grz_SapIntegration.getBrazilAccountReceivables('1001801', '1000','','test');
        Test.stopTest();
        grz_SapIntegration.CreditSummary('1000', '1001801','UPLINTCRM'); 
        grz_SapIntegration.CreditSummaryChileMexico('5661','0001085776', 'UPLINTCRM'); 
        grz_SapIntegration.CreditSummaryBrazil('1000', '1001801','UPLINTCRM');
        grz_SapIntegration.GerInvoiceInfo(null,null);
        grz_SapIntegration.FormattedDate(Date.valueOf('2021-01-01'));
        grz_SapIntegration.AccountAndLedgerStatement('1001801', '1000', '2020', '1', '2','UPLINTCRM');
        grz_SapIntegration.getGstDetails('1001801', '1000', '2021-01-01', '2021-03-31' ,'UPLINTCRM');
        grz_SapIntegration.getMexicoChileAR('0001085776', 'UPLINTCRM', '5661', String.valueof(todaysDateStr), 'x' ,'x');
        grz_SapIntegration.GetUserInfo();
        grz_SapIntegration.FormattedDateBrazil(System.now());
        grz_SapIntegration.currencyBrazil(1000);
        grz_SapIntegration.getUserTerritory(usr.Id);
    }
    Public  static testmethod void testSapIntegration1(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Test.startTest();
        grz_SapIntegration.getBrazilAccountReceivables('1001801', '1000','','test');
        Test.stopTest();
        //code added by Sumit Kumar for cover Argentina Invoice PDF method
        grz_SapIntegration.getArgentinaInvoicPDF('5630', '1416106468');

    }
    Public  static testmethod void testSapIntegration2(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Test.startTest();
        grz_SapIntegration.AccountAndLedgerStatementForMexico('0001006761', '5000', '2021', '8', '8', '0001006761');
        DateTime todaysDate = System.today();
        Date todaysDateStr = todaysDate.dateGMT();
        grz_SapIntegration.FormattedDateMexico(todaysDate);
        Test.stopTest();
        grz_SapIntegration.getInvoiceDeliveryInfoMexico('njteEQnhA7NIs3M+QOqZfSqUyHhmIdPmf3Il5lG2C7Y=','6050285064');
    }
    Public  static testmethod void testSapIntegration3(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Test.startTest();
        grz_SapIntegration.getMexicoInvoicPDF('UPLINTCRM', '5000', '2110842611','X');
        Test.stopTest();
        grz_SapIntegration.SendEMail('test', 'pdf', 'test', 'test');
        grz_SapIntegration.SendEMail('test', 'xls', 'test', 'test');
    }
    /**************************************************************************************************
    * @Description       : test method created for covering the method introduced to get Argentina consignment stock and chart data                                                      
    * Date               : 11-08-2022
    * Project/JIRA       : APPS-1757                                                                        
    * Author             : Gurubaksh Grewal
    * @Return            : Void
    * Last Modified By 	 : Gurubaksh Grewal (Grazitti) 05-09-2022                                                                        
    **************************************************************************************************/
    Public  static testmethod void testSapIntegration4(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Test.startTest();
        grz_SapIntegration.AccountAndLedgerStatementForArgentina('0001006761', '5000', '2021', '8', '8', '0001006761');
        DateTime todaysDate = System.today();
        Date todaysDateStr = todaysDate.dateGMT();
        grz_SapIntegration.FormattedDateChile(todaysDate);
        Test.stopTest();
        //code added by Sumit Kumar for ticket no. RITM0512279 
        grz_SapIntegration.ArgentinaConsignmentStockData('0001006761', '5000');
        grz_SapIntegration.getArgentinaDocumentPDF('5630', '0021300009', '2022');
    }
    
    
 
}