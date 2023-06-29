public class CreateSurveyInvite {
    @InvocableMethod
    public static void CreateSurveyInv(List<params> caseDetails) {
        
        string CaId;
        string CaseNumber;
        string communityId;
        string SurveyId = caseDetails[0].SurveyId ;
        
        Case c = [select Id, CaseNumber, SuppliedEmail, Survey_URL__c, owner.Name from Case where Id =: caseDetails[0].CaseId];
        
        CaId = c.Id;
        CaseNumber = c.CaseNumber;
       
        
        communityId = [select Id from Network where Name = 'Partner Community'].Id;
        //SurveyId = [Select Id from Survey where Name = 'Hannaford Case Feedback'].Id;
        
        SurveyInvitation SInv = New SurveyInvitation();
        
        SInv.Email__c = c.SuppliedEmail;
        SInv.case_owner__c = c.owner.Name;
        Sinv.CommunityId = communityId;
        SInv.Name = CaseNumber;
        SInv.OptionsCollectAnonymousResponse = true;
        SInv.OptionsAllowGuestUserResponse = true;
        SInv.SurveyId = SurveyId;
        SInv.caseId__c = CaId;
        insert SInv;
        
        SurveySubject SS = new SurveySubject();
        
        SS.SubjectId = CaId;
        SS.ParentId = SInv.Id;
        SS.Name = CaseNumber;
        
        insert SS;
        SurveyInvitation inviteObj = [SELECT InvitationLink FROM SurveyInvitation WHERE Id =:SInv.Id];
        c.Survey_URL__c = inviteObj.InvitationLink;
        update c;
    }
    
    public class params{
         @InvocableVariable(required=true)
         public Id CaseId;
         @InvocableVariable(required=true)
         public String SurveyId;
    }
}