global class CaselNotificationBatchSchedular implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new CaseEmailNotifactionBatch(),100);
   }
}