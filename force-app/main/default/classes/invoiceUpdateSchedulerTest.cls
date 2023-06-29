@isTest
public class invoiceUpdateSchedulerTest {
   @isTest
    static void TestIUST(){
        system.schedule('jobName', '00 00 12 12 10 ? *', new invoiceUpdateScheduler());
    }
}