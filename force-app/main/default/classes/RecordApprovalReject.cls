public with sharing class RecordApprovalReject {
    public String recId {get;set;}
    Public ProcessInstanceStep pStep{get;set;}
 public RecordApprovalReject (){
     
 }
 public String getApprovalSteps() {
      if (recId != null) {
        pStep = [Select SystemModstamp, StepStatus, ProcessInstanceId, OriginalActorId,OriginalActor.Name,
        Comments, ActorId From ProcessInstanceStep where ProcessInstance.TargetObjectId=:recId order by SystemModstamp desc Limit 1];  
        
      }
      return pStep.Comments ;
    }
 
 
}