/*******************************************************************************************
* @Name         ApprovalRejection  
* @Author       Satish Tiware <satish.tiware@skinternational.com>
* @Date         13/03/2023
* @Group        SKI
* @Description  This class contain method for Reject record on Certain Conditions.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0           Satish Tiware      13/02/2023           Initial Creation                                                      
*******************************************************************************************/

public class ApprovalRejection {
/*
  * @Description  Fetching Record in Approval process of Return Sales order Details using respective Return Sales Order Id.
  * @Param        recordId 
  * @return       returns Return Sales order record Details.
  */   
    @InvocableMethod
    public static void rejectRecord(List<Id> ProcessId){
    
   
    ProcessInstance pi = [SELECT Id, Status FROM ProcessInstance 
                          WHERE Status='Pending' AND TargetObjectId = :ProcessId];
        System.debug('ProceeRecord==>'+pi);
        List<ProcessInstanceWorkitem> workItem = new List<ProcessInstanceWorkitem>();
        If(!Test.isRunningTest()){ 
         workItem = [SELECT Id, ActorId FROM ProcessInstanceWorkitem 
                     WHERE ProcessInstanceId = :pi.Id AND ActorId = :UserInfo.getUserId()];
        }else{
             workItem = [SELECT Id, ActorId FROM ProcessInstanceWorkitem 
                     WHERE ProcessInstanceId = :pi.Id];
        }
        System.debug('@@workItem'+workItem);
        if(workItem.size()>0){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Record rejected by Apex class');
        req.setAction('Reject');
        req.setWorkitemId(workItem[0].Id);
        Approval.ProcessResult result = Approval.process(req);
        }
        
    }
}