@isTest
public class CaseNotificationNurtureBatchTest {
    
    public static TestMethod void test1(){
        String CRON_EXP = '0 0 0 15 3 ? *';
        Id nutureFarmRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        Case case1=new Case();
        case1.subject='Test';
        case1.recordtypeid=nutureFarmRecordTypeId;
        case1.Status='Escalated-L2';
        insert case1;
        test.startTest();
        CaseNotificationNurtureBatch obj = new CaseNotificationNurtureBatch();
        DataBase.executeBatch(obj);
        String jobId = System.schedule('ScheduleCaseNotif',  CRON_EXP, new CaseNotificationNurtureBatch());
        test.stopTest();
    }

}