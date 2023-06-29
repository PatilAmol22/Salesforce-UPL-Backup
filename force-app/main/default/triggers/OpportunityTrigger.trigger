/**************************************************************************************************
* Name               : OpportunityTrigger 
* Handler			 : OpportunityTriggerHandler
* Description        : Trigger for Opportunity
* Created Date       : 30/03/2023                                                                
* Created By         : Nikhil Verma (Grazitti) for RITM0537885                                                                    
**************************************************************************************************/ 
trigger OpportunityTrigger on Opportunity (before insert,before update, after update) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            handler.ChurnAndCrossSellAutomation(Trigger.new);
            handler.DefaultFieldsChurnAndCrossSell(Trigger.new);
        }
        if(Trigger.isUpdate){
            //handler.ActivityValidation(Trigger.new, Trigger.oldMap);
            handler.ChurnAndCrossSellAutomation(Trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
        }
    }
}