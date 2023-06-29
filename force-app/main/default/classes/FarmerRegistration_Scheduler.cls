/*
    Developer Name : Pravin J.
    Batch Class - FarmerRegistrationBatch
    Description - Batch Class Retriving the data from Account object
    and Setting the up the count Against the Regiseter Farmer on Tehsil.

*/
global class FarmerRegistration_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new FarmerRegistrationBatch(),200);
   }
}