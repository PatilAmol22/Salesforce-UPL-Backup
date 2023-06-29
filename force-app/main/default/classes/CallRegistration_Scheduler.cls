/*
    Developer Name : Pravin J.
    Batch Class - CallRegistrationBatch
    Description - Batch Class Retriving the data from Case on the basis of 
    DayInWeek and setting up the last 7 day call of Fo and NonFo 
    against the Tehsil.

*/
global class CallRegistration_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new CallRegistrationBatch(),200);
   }
}