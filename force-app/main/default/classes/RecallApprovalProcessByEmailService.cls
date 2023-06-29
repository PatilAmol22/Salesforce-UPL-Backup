/*******************************************************************************************
* @Name         RecallApprovalProcessByEmailService 
* @Author       Satish Tiware <satish.tiware@skinternational.com>
* @Date         13/02/2023
* @Group        SKI
* @Description  This class contain method related to Recall Approval By Email Services.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0           Satish Tiware      13/02/2023           Initial Creation                                                      
*******************************************************************************************/

global class RecallApprovalProcessByEmailService implements Messaging.InboundEmailHandler {
global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    
    
    String subject = email.subject;   
    Id recordId=Id.valueOf(subject);
    System.debug('Record Id'+recordId);
    
   System.debug('RSo Record'+[Select Id from Return_Sales_Order__c where Id=:recordId]);
        ProcessInstanceWorkitem[] Pval = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :recordId]; 
         System.debug('Size'+Pval.size());
       if(Pval.size() > 0){
      System.debug('Recall Record Id'+Pval);
    Approval.ProcessWorkItemRequest Preq= new Approval.ProcessWorkItemRequest();
    Preq.setAction('Removed');
    Preq.setWorkItemId(Pval[0].Id);
    Approval.ProcessResult res = Approval.process(Preq);
}
        
    result.success = true;
   return result;
  }
}