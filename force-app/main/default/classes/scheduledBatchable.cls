/*
@Author: Pranav Dinakaran
@Class_Description : Calling Batch of fully Registered Farmer Record Update, calling CLass to remove inActive USers from Kede 
                       and call Share Swal India CLass
*/
global class scheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new BatchAccountUpdate(),100);
      KEDEUserManagement kd = new KEDEUserManagement();
      ShareSwalIndiaClass sic = new ShareSwalIndiaClass();
      
   }
}