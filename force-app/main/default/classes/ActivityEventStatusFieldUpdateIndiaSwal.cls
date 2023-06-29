public class ActivityEventStatusFieldUpdateIndiaSwal {

    @InvocableMethod(label='Update Status Field On Event For India SWAL')
    public static void RecordToUpdate(List<String> ActivityId)
    {
        
       
       
         List<Event> updateEveList= new List<Event>();
        List<Event> FinalupdateEveList= new List<Event>();
        List<String> ActivityStatusUpdateToApproved=new List<String>();
           List<String> ActivityStatusUpdateToRejected=new List<String>();
        List<Activity_Event__c> RelatedActivityIDList=[Select Related_Event_Id__c,Status__c from Activity_Event__c where id in:ActivityId];
        System.debug('RelatedIDList'+RelatedActivityIDList);
        List<String> ListofRelatedID=new List<String>();
        
        For(Activity_Event__c ae:RelatedActivityIDList){
            if(ae.Status__c=='Approved'){
            ActivityStatusUpdateToApproved.add(ae.Related_Event_Id__c);
            }
            else if(ae.Status__c=='Rejected')
              ActivityStatusUpdateToRejected.add(ae.Related_Event_Id__c);
        }
      
      List<Event> eveListToApprove=[Select id,SalesOrg__c from event where id in: ActivityStatusUpdateToApproved];
         List<Event> eveListToReject=[Select id,SalesOrg__c from event where id in: ActivityStatusUpdateToRejected];
        if(eveListToApprove.size()>0 && !eveListToApprove.isEmpty()){
            For(Event e:eveListToApprove){
                if(e.SalesOrg__c=='India' || e.SalesOrg__c=='Swal'){
                    e.Others__c='Approved';
                }
                FinalupdateEveList.add(e);
            }
            
        }
         if(eveListToReject.size()>0 && !eveListToReject.isEmpty()){
            For(Event e:eveListToReject){
                if(e.SalesOrg__c=='India' || e.SalesOrg__c=='Swal'){
                    e.Others__c='Rejected';
                }
                 FinalupdateEveList.add(e);
            }
            
        }
        update FinalupdateEveList;
         }
       
        
       
        

    }