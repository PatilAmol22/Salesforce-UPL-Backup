/* Name: ScheduleYOYcalcInvTest (test class)
/Created On: 17 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: Apex Class used for test coverage of ScheduleYOYcalcInv Scheduler apex class
/Project: UPL USA Ignite
*/
@istest
public class ScheduleYOYcalcInvTest {
    @istest
    static void  testschedule() {
        Test.StartTest();
        system.schedule('jobName', '0 0 0 * * ?', new ScheduleYOYcalcInv());
        ScheduleYOYcalcInv.invYOY();
        Test.stopTest();
    }
}