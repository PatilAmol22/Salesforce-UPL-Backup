/* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-07-2022 */  

trigger SKU_Trigger on SKU__c (After update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        // string query = '';
        //map<string,Opening_Inventory2__c> mapOpeningInventory = new map<string,Opening_Inventory2__c>();
        //
		SKU_Trigger_Handler.automation(trigger.new,trigger.oldmap);
    }
    
    
  // Add Below Condition for RITM0449691  GRZ(Dheeraj Sharma) 27-12-2022 
    if(Trigger.isAfter && Trigger.isUpdate){
        
        SKU_Trigger_Handler.caseSkuUnitCostUpdate(trigger.new,trigger.oldmap);
    }
}