/*  
* Name: SchedulePendingOrderMail    
* Created On: 07th Mar 2022
* Author: Paresh Sondigara
* Description: Sending reminder mails to higher authority for those orders which are pending and not yet taken action on last 24 hours.
*/
global class SchedulePendingOrderMail implements Schedulable {
    global void execute(SchedulableContext sc){
        //String jobId = System.schedule('Send pending order mail', '0 0 0/1 1/1 * ? *', new PendingOrderMailBatch());
        //System.debug(jobId);
    //CR#169 -Chile Margin Block -SKI- kalpesh chande - 31/01/2023 -Start Here....Existing Code has been moved to PendingOrderMailBatch class
        try{
        PendingOrderMailBatch scBatch=new PendingOrderMailBatch();
        Database.executeBatch(scBatch, 10);
        }Catch(Exception e){
            system.debug('error@@@'+e.getMessage());
            system.debug('error@@@'+e.getLineNumber());
        }
   //CR#169 -Chile Margin Block -SKI- kalpesh chande - 31/01/2023 -End Here 
    }
   
}