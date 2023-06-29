/*
    Developer Name : Pravin J.
    Batch Class - ThisMonthProductRecomdBatch
    Description -  Batch Class Retriving the data from Case on the basis of 
    Products_Recommended and created in this month 
    against the Tehsil.

*/
global class ThisMonthProductRecomd_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new ThisMonthProductRecomdBatch(),200);
   }
}