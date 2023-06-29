@isTest(seeAllData =true)
public class SICScheduleEmailToTMRMTest {
    static testMethod void CallInventoryUpload()
    {
        test.startTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        // Schedule the test job
        String jobId = System.schedule('BorrarAseguradosTest', CRON_EXP, new SICScheduleEmailToTMRM());
        test.stopTest();
        
    }
    
}