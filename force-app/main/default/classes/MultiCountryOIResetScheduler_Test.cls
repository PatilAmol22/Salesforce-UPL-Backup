@isTest
public class MultiCountryOIResetScheduler_Test {
     @isTest
    public static void testSch(){
        System.schedule('jobName', '0 30 14 1 1/1 ? *', new MultiCountryOIResetScheduler());
    }

}