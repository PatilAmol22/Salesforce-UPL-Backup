/*
    Developer Name : Pravin J.
    Batch Class - ThisYearProductRecomdBatch
    Description -  Batch Class Retriving the data from Case on the basis of 
    Products_Recommended and created in this Year 
    against the Tehsil.

*/
global class ThisYearProductRecomd_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new ThisYearProductRecomdBatch(),200);
   }
}