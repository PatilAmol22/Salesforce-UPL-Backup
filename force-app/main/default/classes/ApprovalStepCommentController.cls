public class ApprovalStepCommentController {
    
    public ID ObjectId {get; set;}
    
    public String comments {
        get{
            If(comments == null){
                ProcessInstanceStep lastStep = getLastApprovalStep();
            	comments = ( lastStep != null ) ? lastStep.comments : '';
              
            }
             return comments;
        }
        Private set;
    }
    
       
     private ProcessInstanceStep getLastApprovalStep() {
        List<ProcessInstanceStep> steps = new List<ProcessInstanceStep>([SELECT Comments FROM ProcessInstanceStep
                                                                        WHERE ProcessInstance.TargetObjectId = :ObjectId
                                                                        ORDER BY SystemModStamp DESC LIMIT 1]);
        return ( steps.size() > 0 ) ? steps[0] : null;
    }
       
}