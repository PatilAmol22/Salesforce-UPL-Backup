//CREATED Trigger FOR INVENTORY CONTROL BY HARSHIT&ANMOL@WIPRO FOR (US IU-001) ---START

trigger inventoryTrigger on Inventory_Control__c (before insert,after insert) {
 
    
    if(Trigger.isInsert && trigger.isbefore){
          //inventoryTriggerHandler.inventorycontrolImport(Trigger.New);
          inventoryTriggerHandler.inventorycontrolDuplicate(Trigger.New);
    }
    if(Trigger.isInsert && trigger.isafter){
          //inventoryTriggerHandler.inventorycontrolImport(Trigger.New);
          inventoryTriggerHandler.delRecords(Trigger.New);
    }
   
}