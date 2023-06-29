/*
    Developer Name : Pravin J.
    Batch Class - LastYearProductRecomdBatch
    Description -  Batch Class Retriving the data from Case on the basis of 
    Products_Recommended and created in Last Year 
    against the Tehsil.

*/
global class LastYearProductRecomd_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new LastYearProductRecomdBatch(),200);
   }
}