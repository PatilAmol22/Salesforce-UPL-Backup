@isTest
public class DashboardDataDeletionBatchTest {
    
    static testMethod void method(){
        Test.StartTest();
        Database.executeBatch(new DashboardDataDeletionBatch('BusinessDashboardData__c', System.Today(),'Business Dashboard Channel Partner'),100);
        Test.stopTest();
    }
    
    static testMethod void method2(){
        SchemaObjectMapping__c smObj = new SchemaObjectMapping__c();
        smObj.Name = 'Business Dashboard Channel Partner';
        smObj.Filename__c = 'Business Dashboard Channel Partner';
        smObj.Object__c = 'BusinessDashboardData__c';
        smObj.Deleted_on__c = System.today() - 10;
        insert smObj;
        
        Test.StartTest();
        Database.executeBatch(new DashboardDataDeletionBatch('Daily'), 100);
        Test.stopTest();
    }
    
    static testMethod void method3(){
        Test.StartTest();
        String cronStr = '0  00 1 3 * ?';
        //System.schedule('Scheduler', cronStr, new DashboardDailyDeletionScheduler());
        Test.stopTest();
    }
}