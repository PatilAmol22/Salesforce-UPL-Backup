public class ProcessApprovelRequest {

    public static void submitForApproval(Case c){        
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for Ticket Closed.');
        req1.setObjectId(c.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(c.ownerId );  //  c.CreatedById  //  c.ownerId  // UserInfo.getUserId()  
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('India_Case_Module_Case_Close');
        req1.setSkipEntryCriteria(true);  
        
        // 
// Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        // Select Id, ContentDocumentId from ContentVersion where ContentDocumentId != null Limit 100  
        
      System.debug('offer submitted for approval successfully: '+result.isSuccess());
        
      System.debug('result' + result);  
        
      
    }     

    //This method added by Mohit Garg - Grazitti (13-02-2023) - APPS-4742
    public static void submitForApproval1(Case c){        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for Case Closed.');
        req1.setObjectId(c.id);
        req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req1.setSubmitterId(c.ownerId );  
        req1.setProcessDefinitionNameOrId('India_RCM_Case_Module_Case_Close');
        req1.setSkipEntryCriteria(true);  
        Approval.ProcessResult result = Approval.process(req1);
        
    }     
 }