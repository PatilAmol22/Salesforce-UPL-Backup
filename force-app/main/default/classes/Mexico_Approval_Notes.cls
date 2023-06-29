/*

this class we will use in lightning component "Mexico_approval_Notes" to display msg if approver is approving the 
sales order below limit. 
As per requirement # SCTask0621778
*/

public class Mexico_Approval_Notes {
    
    @AuraEnabled
    public static String getSalesOrderRecord(String varRecordId)
   {
       String notes='';
       List<Sales_Order__c> listSalesOrder=   [Select id,Notes__c,Approval_Status__c,Manager__c from Sales_Order__c where id=:varRecordId LIMIT  100];
       return notes=listSalesOrder[0].Notes__c;
    } 
    
    @auraEnabled
    public static Boolean getSalesOrder180(String recordIdVar){
       boolean notes180=false;  
       List<Sales_Order__c> listSalesOrder=   [Select id,Payment_Term_Days__c
                                               from Sales_Order__c 
                                               where id=:recordIdVar 
                                               AND Payment_Term_Days__c>180
                                               LIMIT  1];
         system.debug('########listSalesOrder'+listSalesOrder);                                      
        if(listSalesOrder.size()>0){ 
            /* Map<Id,ProcessInstance> processinstence = New Map<Id,ProcessInstance>([SELECT Id, Status, (SELECT ID, ProcessNodeId,  
                         StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending  
                         ,OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate, Actor.Name,  
                         OriginalActor.Name , ProcessNode.Name FROM StepsAndWorkitems)   
                   FROM ProcessInstance where TargetObjectId =:recordIdVar order by CreatedDate DESC]); 

        	for(ProcessInstance pr :  processinstence.values()){
            	for(ProcessInstanceHistory  str : pr.StepsAndWorkitems) {

           			system.debug(' after update methods #####pr.Status'+str.ProcessNode.Name);
               			if(str.ProcessNode.Name=='To Sub Region Head' || str.ProcessNode.Name=='To CFO') {
                    		notes180=true;
                           
           					
                		}  
          	 	}
        	}
           */
            notes180=true;
        }
        system.debug('######notes180'+notes180);
        return notes180;
        
        
        
    } 
    
    

}