public class Grz_CaseEscalationBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    public List<Case> caseList=new List<Case>();
    public Database.QueryLocator start(Database.BatchableContext BC){
        DateTime currTime = System.now();
        system.debug('currTime ==>'+currTime );
         Integer hour1 = Integer.ValueOf(Label.Grz_24only);  // Added by Swaran(Grazitti) APPS-4632
         System.debug('hour1---' +hour1);
        DateTime hrBefore = currTime.addHours(hour1);
        system.debug('hrBefore ==>'+hrBefore);
        //CRQ:changes to prevent certain case types from escalation
        List<String> lstUplItCaseType = System.Label.Grz_UPLITSupport.split(',');
        if(Test.isRunningTest()){
        return Database.getQueryLocator('Select Id,CreatedById,CaseOwner__c,CaseNumber,Type From Case Limit 1');
        }
        else{
            return Database.getQueryLocator('Select Id,CreatedById,CaseOwner__c,CaseNumber,Type From Case WHERE Recordtype.Name = \'Distributor\' AND Type NOT IN:lstUplItCaseType  AND Comment_updated_in_24_hrs__c!=true AND Status_updated_in_24_hrs__c!=true AND Escalation_Level__c=\'Escalated L1\' AND CaseOwner__c!=\'\' and CreatedDate< :hrBefore');
        }    
    }
    
    public void execute(Database.BatchableContext BC, List<Case> scope){
        List<Id> caseIdList=new List<Id>();
        
        for(Case c:scope)
        {
            caseIdList.add(c.Id);
            caseList.add(c);
        }      
        System.debug('caseIdList==>'+caseIdList.size());
        Grz_CaseDetailClass.escalatePortalCase(caseIdList,'Batch');
    }
    
    public void finish(Database.BatchableContext BC){
        if(!caseList.isEmpty()){
            ID jobID = System.enqueueJob(new Grz_SendSmsQueueableClass(caseList));
        }
    }
    
}