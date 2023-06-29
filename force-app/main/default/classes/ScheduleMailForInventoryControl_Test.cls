@isTest
public class ScheduleMailForInventoryControl_Test {
  
       @istest
        public static void  testschedule() {
            
            Test.StartTest();
            ScheduleMailforInventoryControl batch = new ScheduleMailforInventoryControl();
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, batch);
            ScheduleMailforInventoryControl.reviewmethod();
            Test.stopTest();
            
        }
}