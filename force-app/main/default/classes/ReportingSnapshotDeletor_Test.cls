@isTest
public class ReportingSnapshotDeletor_Test {
    
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob() {
    
    
    Last_Login__c lstLoginObj = new Last_Login__c(
            //Name = 'Login1',           
            Last_Login__c = System.today()-2,
            User_Full_Name__c='20011002@uniphos.com.upltest',
        	Active__c = true,
        	Country__c = 'Colombia',
        	CreatedDate = System.today()-2
        
        );
        insert lstLoginObj;
        
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ReportingSnapshotDeletor_Test',
            CRON_EXP, 
            new ReportingSnapshotDeletor_Scheduler());     
        Test.stopTest();
    }

}