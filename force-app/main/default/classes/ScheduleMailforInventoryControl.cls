/* Name: ScheduleMailforInventoryControl
/Author: Wipro
/Description: Scheduling Reminder mail every month to salesforcebrazil@upl-ltd.com for inventory control records update 
/Brazil Price2Win Phase 2 
*/
global class ScheduleMailforInventoryControl implements Schedulable {
    global void execute(SchedulableContext sc) {
        SendMailForInventoryControl b = new SendMailForInventoryControl(); 
        database.executebatch(b);
    }
      public static void reviewmethod()
    {
  ScheduleMailforInventoryControl batch = new ScheduleMailforInventoryControl();
String sch = '0 2 * * * ?' ;
        if(!Test.isRunningTest()){   
String jobIDNew = system.schedule('Batch Scheduled', sch, batch);
        }
}
 }