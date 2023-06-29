/**************************************************************************************************
* Name             : Grz_RsoApprovalController                                                      
* Description      : Controller for the Grz_RsoApprovalLWC  
that gets the pending approvals for return sales order and lets user approve/reject it   
* Test Class       : grz_SalesOrderReturnFnlControllerTest
* Created Date     : 06-03-2023                                                                        
* Project/JIRA     : APPS-4957                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 06-03-2023                                                                        
**************************************************************************************************/
public class Grz_RsoApprovalController {  
	@AuraEnabled
    public static object fetchApprovals(){
        map<string,list<string>>obj2comments=new map<string,list<string>>();
        list<object>obList2return=new list<object>();
        list<map<string,object>>pi2obj= new list<map<string,object>>();
        list<map<string,object>>obj2return= new list<map<string,object>>();
        
        //00528000006mvSgAAI
        for(ProcessInstanceWorkitem wi : [SELECT Id, ProcessInstanceId,ProcessInstance.SubmittedById,ProcessInstance.SubmittedBy.name,ProcessInstance.TargetObjectId,ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.status='Pending' AND ActorId = :userInfo.getUserId() ORDER BY CreatedDate ASC]){
        //for(ProcessInstanceWorkitem wi : [SELECT Id, ProcessInstanceId,ProcessInstance.TargetObjectId,ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.status='Pending' AND ActorId = '00528000006mvSgAAI']){
            if(wi.ProcessInstanceId!=null){
                if(string.valueOf(wi.ProcessInstance.TargetObjectId.getSobjectType())=='Return_Sales_Order__c'){
                    obj2comments.put(wi.ProcessInstance.TargetObjectId,new list<string>());
                    pi2obj.add(new map<string,object>{'subId'=>wi.ProcessInstance.SubmittedById,'subName'=>wi.ProcessInstance.SubmittedBy.name,'wi'=>wi.id,'rsoId'=>wi.ProcessInstance.TargetObjectId});
                }
            } 
        }
        
        for(ProcessInstanceStep wi:[Select id,comments,ProcessInstanceId,ProcessInstance.TargetObjectId from ProcessInstanceStep Where ProcessInstance.TargetObjectId in:obj2comments.KeySet() ORDER BY CreatedDate DESC]){
            if(wi.ProcessInstanceId!=null){
                if(obj2comments.containsKey(wi.ProcessInstance.TargetObjectId)){
                    list<string> cL=obj2comments.get(wi.ProcessInstance.TargetObjectId);
                    if(wi.comments!=null)cL.add(wi.comments);
                    obj2comments.put(wi.ProcessInstance.TargetObjectId,cl);
                }
            }
        }
        map<string,string>id2name=new map<string,string>();
        for(Return_Sales_Order__c rso:[select id,name from Return_Sales_Order__c where id in:obj2comments.keySet()]){
            id2name.put(rso.id,rso.name);
        }

        for(map<string,object> mp:pi2obj){
            string rsoid=string.valueOf(mp.get('rsoId'));
            mp.put('rsoName',id2name.get(rsoid));
            mp.put('newComment','');
            mp.put('status','Pending');
            mp.put('action',null);
            mp.put('disable',false);
            mp.put('theme','slds-theme_shade slds-theme_alert-texture slds-border_top slds-border_right slds-border_bottom slds-border_left');
            if(obj2comments.get(rsoid).size()>0)mp.put('comment',obj2comments.get(rsoid)[0]);else mp.put('comment','');
            mp.put('nav',('/'+rsoid));
            obj2return.add(mp);
        }
        return obj2return;
    }
    
    @AuraEnabled
    public static void processApprovals( string insId,string action1,string comment){
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setWorkitemId(insId);
          req.setAction(action1);
          req.setComments(comment);
          requests.add(req);
        system.debug('__________________'+req);
        Approval.ProcessResult[] processResults = Approval.process(requests);
    }

}