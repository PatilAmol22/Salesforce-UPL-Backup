@isTest
public class CreateSurveyInviteTest {
    
    @isTest(SeeAllData=true)
    private static void unit1(){
        Id RecordId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Hannaford_General_Query').getRecordTypeId();
		case cse = new case();
        cse.Subject = 'test'; 
        cse.recordTypeId = RecordId;
        cse.SuppliedEmail ='test@test.com';
        insert cse;
        
        List<CreateSurveyInvite.params> paramsList = new List<CreateSurveyInvite.params>();
        CreateSurveyInvite.params obj = new CreateSurveyInvite.params();
        obj.CaseId = cse.Id;
        obj.SurveyId = Label.Hannaford_Case_Survey_ID;
        paramsList.add(obj);
        CreateSurveyInvite.CreateSurveyInv(paramsList);
        CaseReopenController.reopenCase(new List<Id>{cse.Id});
    }
}