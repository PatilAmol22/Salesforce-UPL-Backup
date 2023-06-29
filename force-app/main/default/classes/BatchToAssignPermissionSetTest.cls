@isTest
public class BatchToAssignPermissionSetTest {

    @isTest
    public static void testBatch(){
        Test.startTest();
        Database.executeBatch(new BatchToAssignPermissionSet());
        Test.stopTest();
    }
}