public class NavigateToViewEmp {

	@AuraEnabled
    public static Task getTasks(String taskRecordId) {
        
        Task taskVal = [ SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, 
                        Subject, ActivityDate, Status, Priority, IsHighPriority, OwnerId,
                        Description, Type, AccountId, IsClosed, 
                        Empanelment__c FROM Task WHERE Id =: taskRecordId ];
        
        return taskVal;
    }

	@AuraEnabled
    public static Empanelment__c empanelValues(string empanelmentId){
        system.debug('emp 0 emp 0 '+empanelmentId);
        
        
        Empanelment__c empc = [SELECT Id,CultivatedArea__c, SowingDate__c, CultivatedCrop__c,Farmer__r.Village__pr.State__c,Farmer__r.Id,Farmer__r.Name  FROM Empanelment__c WHERE Id =: empanelmentId ];
        
        return empc;
        
        
    }


}