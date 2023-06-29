public class CaseReopenController {
    @InvocableMethod
    public static void reopenCase(List<String> caseIdList) {
        List<case> caseUpdateList = new List<case>();
        for(String Id : caseIdList){
            caseUpdateList.add(new case(Id = Id, status = 'Reopen'));
        }
        
        if(caseUpdateList.size()> 0 ){
            update caseUpdateList;
        }
    }
}