@isTest(SeeAllData=false)
public class Grz_DisplayPDFController1Test {
    Public  static testmethod void testAccountLedgerPDFStatement(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        new Grz_DisplayPDFController1().Grz_AccountPDFControllerData();
        new Grz_DisplayPDFController1().Grz_LedgerPDFControllerData();
        Test.stopTest(); 
    }
}