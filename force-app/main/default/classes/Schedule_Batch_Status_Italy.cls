/****************************************
 * Created By: Varun Shrivastava
 * Created Date: 25 Jan 2021
 * Ticket: SCTASK0335027
 * **************************************/
global class Schedule_Batch_Status_Italy implements Schedulable {
   global void execute(SchedulableContext sc) {
      Batch_Order_Status_Italy batchInstance = new Batch_Order_Status_Italy(); 
      Database.executebatch(batchInstance,1);
   }
}