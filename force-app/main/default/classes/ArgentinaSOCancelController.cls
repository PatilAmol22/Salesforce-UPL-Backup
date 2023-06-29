public class ArgentinaSOCancelController {
    public string soId ;
    public List<Id> eligibleIds;
    public String userid;
    public Integer check{get;set;}
    public ArgentinaSOCancelController(ApexPages.StandardController controller) {
        Sales_Order__c so = (Sales_Order__c)controller.getRecord();
        soId = so.id;
        
        //Sayan(IBM):Cancel Order authority given to one Public Group only ( RITM0133468 )
        userid = Userinfo.getUserId();
        eligibleIds = new List<Id>();
        check = 0;
        for(GroupMember tempId :[SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN:[SELECT Id FROM Group WHERE DeveloperName = 'Argentina_Cancel_Order_accessing_group'] ]){
            eligibleIds.add(tempId.UserOrGroupId);
        }
        for(Id var:eligibleIds){
            if(var == userid){
                check = 1;
                break;
            }else{
                check = 0;
            }
        }
        system.debug('check>>>>'+check);
        //Sayan(IBM):Cancel Order authority given to one Public Group only ( RITM0133468 )
    }
    
    public void controllerMethod(){
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest> ();
        system.debug('@@'+soId);
        List<ProcessInstance> pi = [Select Id from ProcessInstance where TargetObjectId =:soId];
        List<ProcessInstanceWorkItem> pp = new List<ProcessInstanceWorkItem>();
        if(pi.size() > 0){
        pp = [Select Id from ProcessInstanceWorkItem where ProcessInstanceId = :pi[0].id];
            system.debug('@@'+pp);
        }
        if(pp.size() > 0){
            // if there's a work item, set the action to 'removed' and execute
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setAction('Removed');
            req2.setWorkitemId(pp[0].Id);
            requests.add(req2);
            //Approval.ProcessResult[] processResults = null;
            //processResults = Approval.process(requests, true); 
        }
        Approval.ProcessResult[] processResults = null;
        processResults = Approval.process(requests, true); 
    }
}