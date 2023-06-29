trigger Grz_CaseCommentTrigger on CaseComment (before insert,after insert) {
    if(trigger.IsBefore && trigger.IsInsert){
           Grz_CaseCommentController caseComment=new Grz_CaseCommentController();
           caseComment.checkCommentAddedOnCase(trigger.new); 
    }
    
    if(trigger.IsAfter && trigger.IsInsert){
           Grz_CaseCommentController caseComment=new Grz_CaseCommentController();
           caseComment.sendEmailOnCaseComment(trigger.new);
           Grz_CaseCommentRCMController.sendEmailOnCaseComment(trigger.new); // Method added by Mohit Garg (Grazitti)- 13-02-2023 - APPS-4742
    }
}