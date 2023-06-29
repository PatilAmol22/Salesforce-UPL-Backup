//Created by Naresh Kumar EY Team #RITM0378285
global class SchedableBatchForGtmRecordsUpdate implements Schedulable{
 global void execute(SchedulableContext sc) {
      
  	BatchGTMDetailsRecordsUpdate gtmUp = new BatchGTMDetailsRecordsUpdate();
    Database.executeBatch(gtmUp);
      
   }
}