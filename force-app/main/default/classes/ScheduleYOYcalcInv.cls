/* Name: ScheduleYOYcalcInv (schedule apex class)
/Created On: 14 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: Apex Class used to schedule GetNAMYOYGrowthEDISales and GetNAMYOYGrowth for YoY growth
/Project: NAM SFDC New Rollout IGNITE
Test Class: ScheduleYOYcalcInvTest
Updated On: 12-06-2023 by GRZ(Nikhil Verma) RITM0571473 to optimize code and fix system limits.
*/
global class ScheduleYOYcalcInv implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executebatch(new GetNAMYOYGrowth(),20);
        database.executebatch(new GetNAMYOYGrowthEDISales(),20);
    }
    public static void invYOY(){
        String jobIDNew = System.schedule('Batch Scheduled for NAM GetNAMYOYGrowth and GetNAMYOYGrowthEDISales', '0 0 0 * * ?' , new ScheduleYOYcalcInv());
    }
}