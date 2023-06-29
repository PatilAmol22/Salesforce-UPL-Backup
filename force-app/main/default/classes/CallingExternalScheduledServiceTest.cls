@isTest
public class CallingExternalScheduledServiceTest {
    private static testmethod void callingExternalScheduledServiceTest(){
     Test.startTest();
        Monitor_Integration_Flow__c  mif = new Monitor_Integration_Flow__c();
           mif.Transaction_Status__c = 'Failed';
        mif.Executed_Date__c = System.now();
         mif.Transaction_Type__c = 'Auto';
        mif.Response_Message__c = 'you can do it';
        mif.Service_Url__c = 'url1.com';
       string Json = '{"Test": "Test@test.com","Transaction_Type__c": "Manual","Transaction_Status__c": "Pass"}';
        
        insert mif;
        CallingExternalScheduledService.SKUService(mif.id);
        CallingExternalScheduledService.CallService(Json,mif.Service_Url__c,mif.Name,mif.id,mif.Transaction_Type__c );
      //System.schedule('Test CallingExternalScheduledService', mif);
        Test.stopTest();
    }
}