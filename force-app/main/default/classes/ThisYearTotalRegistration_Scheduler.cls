/*
    Developer Name : Pravin J.
    Batch Class - ThisYearTotalRegistrationBatch
    Description - Batch Class Retriving the data from Account on the basis of 
    Register Date time and setting up the count of Fo and Non - Fo Count
    against the Tehsil of Current Year.

*/
global class ThisYearTotalRegistration_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new ThisYearTotalRegistrationBatch(),200);
   }
}