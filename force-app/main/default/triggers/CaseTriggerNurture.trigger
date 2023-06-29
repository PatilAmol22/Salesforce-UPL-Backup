trigger CaseTriggerNurture on Case (before insert, after insert, after update, before update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        
        CaseTriggerHandlerNurture.updateTimeInCase(Trigger.new,Trigger.oldMap);
        
    }
    
     // Add Below Condition for RITM0449691  GRZ(Dheeraj Sharma) 27-12-2022 
    
     if(Trigger.isBefore && (Trigger.isInsert  || Trigger.isUpdate)){
        CaseTriggerHandlerNurture.insertSkuUnitCostOnCase(trigger.new, trigger.oldMap);
    }
    
}