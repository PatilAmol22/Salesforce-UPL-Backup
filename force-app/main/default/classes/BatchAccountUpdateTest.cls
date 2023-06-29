@isTest(SeeAllData=true)

public class BatchAccountUpdateTest {
    static testmethod void myTestMethod1() {
        Database.executeBatch(new BatchAccountUpdate(),200);
    }
}