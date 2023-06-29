trigger PreventDuplicateRecord on Brazil_Region_SKU_Combination__c (before insert, before update) {

if(trigger.isInsert && trigger.isBefore){
PreventDuplicateRecordHandler.beforeInsertCombinationKey(Trigger.New);
}

if(trigger.isUpdate && trigger.isBefore){
PreventDuplicateRecordHandler.beforeUpdateCombinationKey(Trigger.New, Trigger.oldMap);
}


}

   /*trigger PreventDuplicateRecord on Brazil_Region_SKU_Combination__c (before insert, before update) {
    
    if(trigger.isBefore){
        if(trigger.isInsert){  
            PreventDuplicateRecordHandler.beforeInsertCombinationKey(Trigger.New);
        }
        if(trigger.isUpdate){
            
            PreventDuplicateRecordHandler.beforeInsertCombinationKey(Trigger.New);
        }
        
    }
   
    
}*/