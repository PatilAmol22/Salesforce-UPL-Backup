/*
    Developer Name : Pravin J.
    Batch Class - CurrMonthLastYearProductRecomdBatch
    Description -  Batch Class Retriving the data from Case on the basis of 
    Products_Recommended and created in Current month Last Year 
    against the Tehsil.

*/
global class CurrMonthLastYearProductRecomd_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new CurrMonthLastYearProductRecomdBatch(),200);
   }
}