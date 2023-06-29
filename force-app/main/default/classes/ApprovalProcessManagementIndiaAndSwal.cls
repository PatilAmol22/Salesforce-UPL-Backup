public class ApprovalProcessManagementIndiaAndSwal {
    @InvocableMethod(label='Submit Aproval Process For India And Swal')
    public static void submitForApproval(List<String> ActivityEventIdList)
    {
        User userObj = [Select managerID from User where id =:UserInfo.getUserId()];
        system.debug('opp'+ ActivityEventIdList);
        List<Event> updateEveList= new List<Event>();
        List<Activity_Event__c> ActivityStatusUpdate=new List<Activity_Event__c>();
        List<Activity_Event__c> RelatedActivityIDList=[Select Related_Event_Id__c,Status__c from Activity_Event__c where id in:ActivityEventIdList];
        System.debug('RelatedIDList'+RelatedActivityIDList);
        List<String> ListofRelatedID=new List<String>();
        
        For(Activity_Event__c ae:RelatedActivityIDList){
            ae.Status__c='Pending';
            ActivityStatusUpdate.add(ae);
            ListofRelatedID.add(ae.Related_Event_Id__c);
        }
        System.debug('ListofRelatedID'+ListofRelatedID);
        List<Event> eveList=[Select id from event where id in: ListofRelatedID];
        System.debug('eveList'+eveList);
        if(eveList.size()>0 && !eveList.isEmpty()){
            For(Event e:eveList){
                e.Others__c='Pending';
                updateEveList.add(e);
                System.debug('e'+e);
            }
        }
        update updateEveList;
        
        for(String str: ActivityEventIdList)
        {
            // Create an approval request for the Opportunity
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval automatically using Trigger');
            req1.setObjectId(str);
            req1.setProcessDefinitionNameOrId('Approval_to_Manager_India_Swal_Activity');
            req1.setNextApproverIds(new Id[] {userObj.managerID});
            
            // Submit the approval request for the Opportunity
            Approval.ProcessResult result = Approval.process(req1); 
            system.debug('result' + result);
        }
        if(ActivityStatusUpdate.size()>0 && !ActivityStatusUpdate.isEmpty()){
            update ActivityStatusUpdate;
        }
        
        
    }
    
}