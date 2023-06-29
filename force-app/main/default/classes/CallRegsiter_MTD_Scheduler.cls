/*
    Developer Name : Pravin J.
    Batch Class - 
    Description -  Batch Class Retriving the data from Case on the basis of 
    DayInWeek and setting up the last 7 days Cases of Fo and NonFo 
    against the Tehsil.

*/
global class CallRegsiter_MTD_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new CallRegister_MTDBatch(),200);
   }
}