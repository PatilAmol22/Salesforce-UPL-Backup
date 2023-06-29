@istest
public with sharing class MexicoApprovalReminderSchedulerTest {
    static testmethod void Method1() {
        Test.startTest();
        MexicoApprovalReminderScheduler obj = new MexicoApprovalReminderScheduler();
        obj.execute(null);
        Test.stopTest();
    }
}