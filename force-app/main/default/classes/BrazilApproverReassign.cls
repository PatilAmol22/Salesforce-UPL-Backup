public class BrazilApproverReassign{

public void reassignApprover(){
    Map<Id, Id> salesApproverMap=new Map <Id, Id>();
    Map<Id, Id> originalApprovalId = new Map<Id, Id>(); //RITM0385465 Remove sales order from list after reassignment.
    List<Sales_Order__c> sotoupdate =new List<Sales_Order__c>();
    List<Sales_Order__c> salesOrderList=[select id,name,Reassigned_Approver__c from Sales_Order__c where Order_Status__c='Pending' and SalesOrgCode__c='5191'];
    List<ProcessInstanceWorkitem> pid=new List<ProcessInstanceWorkitem> ();
    
    if(salesOrderList.size()>0){
    pid= [SELECT ProcessInstance.TargetObjectid,ProcessInstance.Status, OriginalActor.id, Actor.id,OriginalActor.name, Actor.name FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' 
        AND ProcessInstance.TargetObject.Type ='Sales_Order__c' and ProcessInstance.TargetObjectid in :salesOrderList];
       }

    

for(ProcessInstanceWorkitem p:pid){
if(p.Actor.id!=p.OriginalActor.id){
system.debug(p.ProcessInstance.TargetObjectid+', '+p.Actor.Name+', '+p.OriginalActor.Name);
originalApprovalId.put(p.ProcessInstance.TargetObjectid,p.OriginalActor.Id); //RITM0385465 - Created map of Originalactor id and sales order object record id
salesApproverMap.put(p.ProcessInstance.TargetObjectid,p.Actor.id);
}
}

for(Sales_Order__c s:salesOrderList){
if(salesApproverMap.containskey(s.id)){
if(s.Reassigned_Approver__c!=salesApproverMap.get(s.id)){
s.Old_Approver_Name__c = originalApprovalId.get(s.id);  // RITM0385465 - Assigned Old approver to custom filed call old approval name
System.debug('Old Approver is - '+originalApprovalId.get(s.id));
system.debug('before approver reassign: '+s.Reassigned_Approver__c);
s.Reassigned_Approver__c=salesApproverMap.get(s.id);
sotoupdate.add(s);
system.debug('after approver reassign: '+s.Reassigned_Approver__c);
}
}
}
if(sotoupdate.size()>0)
update sotoupdate;
}

}