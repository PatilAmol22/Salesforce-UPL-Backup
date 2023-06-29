global class MexicoApprovalReminder implements Database.Batchable<sobject> {
    global List<String> ActorIdTargetIDlst = new List<String>();
    global List<ID> TargetObjectIDlst = new List<ID>();
    global Map<ID,ID> mapTargetObjectID = new Map<ID,ID>();
    global List<Sales_Order__c> lstSalesOrder = new List<Sales_Order__c>();
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        if(Test.isRunningTest()){
          return Database.getQueryLocator('SELECT ActorId,ProcessInstance.TargetObjectId from ProcessInstanceWorkitem where (ProcessInstance.Status=\'Pending\' AND ProcessInstance.TargetObject.Type = \'Sales_Order__c\')');
      }
        return Database.getQueryLocator('SELECT ActorId,ProcessInstance.TargetObjectId from ProcessInstanceWorkitem where (ElapsedTimeInHours > 12.000000000000 AND ProcessInstance.Status=\'Pending\' AND ProcessInstance.TargetObject.Type = \'Sales_Order__c\' AND ProcessInstance.ProcessDefinition.Name=\'New Mexico SO Approval Process V1.7\' AND CreatedDate=THIS_MONTH)');
      
    }
    global void execute(Database.BatchableContext bc, List<ProcessInstanceWorkitem> scope)
    {
        System.debug(scope.size());
        String combinationKey;
        for(ProcessInstanceWorkitem p : scope)
        {
            Schema.SObjectType objectType = p.ProcessInstance.TargetObjectId.getSobjectType();
            if(objectType.getDescribe().getName().equals('Sales_Order__c')){
                combinationKey= p.ProcessInstance.TargetObjectId +'-'+p.ActorId;
                //mapTargetObjectID.put(combinationKey,p.ProcessInstance.TargetObjectId);
                ActorIdTargetIDlst.add(combinationKey);
            }
        }
        /*lstSalesOrder = [SELECT ID,Name,SalesOrgCode__c FROM Sales_Order__c WHERE ID IN :mapActorID.keySet() AND SalesOrgCode__c ='7100' LIMIT 49999];
        for(Sales_Order__c order : lstSalesOrder)
        {
            ActorIdlst.add(mapActorID.get(order.Id)); 
        }*/
    LIST<Messaging.SingleEmailMessage> maillst = new List<Messaging.SingleEmailMessage>();
    EmailTemplate templateId = [SELECT ID FROM EmailTemplate WHERE Name = 'Mexico Sales Orders Approval Reminder']; 
        for(String IDlst : ActorIdTargetIDlst)
        {
            String TargetID;
            String ActorID;
            String[] strID=IDlst.split('-');
            TargetID = strID[0];
            ActorID = strID[1]; 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSaveAsActivity(false);
            mail.setWhatId(TargetID);
        	mail.setTemplateID(templateId.Id);
        	mail.setTargetObjectId(ActorID);
            //mail.setTreatTargetObjectAsRecipient(true);
            maillst.add(mail);
        }
        Messaging.sendEmail(maillst, false); 
    }
    global void finish(Database.BatchableContext bc)
    {
        AsyncApexJob a = [SELECT Id,Status,NumberOfErrors,JobItemsProcessed,TotalJobItems,ExtendedStatus FROM AsyncApexJob WHERE Id = :bc.getJobId()];  
        if(a.Status=='Completed')
         System.debug('Succesfully processed');
        else
         System.debug('Batch processing : '+a.NumberOfErrors); 
    }
    
}