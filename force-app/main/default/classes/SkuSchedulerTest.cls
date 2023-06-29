@istest
public class SkuSchedulerTest {
	@istest
    static void  testschedule() {
        Test.StartTest();
        Monitor_Integration_Flow__c mif = new Monitor_Integration_Flow__c();
        mif.Flow_Name__c='Payment Terms';
        mif.Service_Url__c='https://www.example.com';
        mif.Cronjob_format__c='0 0 0 * * ?';
        insert mif;
        mif.Flow_Enable__c=true;
        update mif;
        mif.Flow_Enable__c=false;
        update mif;
        mif.Flow_Enable__c=true;
        mif.SKU_Update__c=true;
        update mif;
        system.schedule('jobName', '0 0 0 * * ?', new SkuScheduler(mif));
        Test.stopTest();
    }
}