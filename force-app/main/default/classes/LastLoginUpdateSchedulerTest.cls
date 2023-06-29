@isTest
public class LastLoginUpdateSchedulerTest {
    static testmethod void schedulerTest() {
        String CRON_EXP = '0 0 0 15 3 ? *';
        Last_Login__c llObj=new Last_Login__c();
        llObj.Country__c='India';
        llObj.Region__c='Swal';
        llObj.Local_Country__c='India';
        insert llObj;
        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new LastLoginUpdateScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}