@isTest
public class KEDEUserManagementTest{
    static testmethod void test1(){
        KEDEUserManagement fd = new KEDEUserManagement();
        System.schedule('Job1', '0 49 16 * * ?', new scheduledBatchable());
    
    }
}