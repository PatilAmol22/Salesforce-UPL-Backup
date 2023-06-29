/* 
@Author: Pranav Dinakaran
@Trigger_Description: This Trigger is to Recall Approval Process where no action has been taken for long time, 
                        this Trigger will invoke Apex class CSRApprovalRecallSubmit.
*/

trigger ApprovalProcessEscalationTrigger on CSR__c (after update) {
 for(CSR__c cr : trigger.new){
     // Check if Escalation in  level3 and pending for approval.
     if(cr.Level_3__c == True && cr.CSR_Status__c == 'Approved_at_Level_1'){
            system.debug('Inside if condition');
            if(!test.isRunningTest())
            // Call CLass Method to Recall Approval Process.
            CSRApprovalRecallSubmit.recallApproval(cr.id);
        }
     
 }

}