/**********************************************
 * Name: SCH_Agreement_Notification
 * Created By: Varun Shrivastava
 * Create Date: 4 May 2021
 * Purpose: Schedule Batch Class(BCH_Agreement_Notification) Daily at 10 AM CST(France Time Zone)
 * Ticket: SCTASK0381589
**********************************************/
global class SCH_Agreement_Notification implements Schedulable {
   global void execute(SchedulableContext SC) {
      BCH_Agreement_Notification batchInstance = new BCH_Agreement_Notification(); 
      Database.executeBatch(batchInstance, 100); 
   }
}