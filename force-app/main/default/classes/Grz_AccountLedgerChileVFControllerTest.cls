@isTest(SeeAllData=false)
public class Grz_AccountLedgerChileVFControllerTest {
     Public  static testmethod void Account_Ledger_Chile(){
        Test.startTest();   
         Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
          Grz_AccountLedgerChileVFController.Grz_AccountPDFControllerData();
        Test.stopTest(); 
       
        
    }
    
   
     Public  static testmethod void Account_Ledger_Chile1(){
        Test.startTest();   
         Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
         Grz_AccountLedgerChileVFController.Grz_LedgerPDFControllerData();
        Test.stopTest(); 
       
        
    
}
}