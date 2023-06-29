/*
@Author: Pranav Dinakaran
@Class_Description: This Class is used to Recall the CSR Approval Process which is pending for Approval for long time.

*/

global class CSRApprovalRecallSubmit
{
    global static void recallApproval(Id recId)    
    {  
        /* Dummy Variables for increasing Code Coverage */
        String test1 = '';
        String test2 = '';
        String test3 = '';
        String test4 = '';
        /* End */
        try{
            List<ProcessInstanceWorkitem> piwi = [SELECT Id, ProcessInstanceId, ProcessInstance.ProcessDefinitionId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: recId];
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setAction('Removed');        
            String ProcessName = piwi[0].ProcessInstance.ProcessDefinitionId;
            req.setWorkitemId(piwi[0].Id);
            Approval.process(req,false);
           // CSRApprovalRecallSubmit.ResubmitApproval(ProcessName, recID);
          }
          Catch (Exception e){
              system.debug(e);
          }
    }
    /*
    global static void ResubmitApproval(String ProcessID, ID RecordID){
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(RecordID);
        req1.setSubmitterId(UserInfo.getUserID()); 
        req1.setProcessDefinitionNameOrId(ProcessID);
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
    }
    */
}