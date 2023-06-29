/**************************************************************************************************
* Name               : SecondarySalesDataTrigger 
* Handler			 : SecondarySalesDataTriggerHandler
* Description        : Trigger for Secondary Sales Data
* Created Date       : 14/02/2023                                                                
* Created By         : Nikhil Verma (Grazitti) RITM0507183                                                                    
**************************************************************************************************/ 
trigger SecondarySalesDataTrigger on Secondary_Sales_Data__c (before insert, before update) {
    SecondarySalesDataTriggerHandler handler = new SecondarySalesDataTriggerHandler();
	if(Trigger.isBefore){
        if(Trigger.isInsert){
            handler.NAMSalesDataOperation(Trigger.new);
            handler.ownershipUpdateNAM(Trigger.new);
        }
        if(Trigger.isUpdate){
            handler.NAMSalesDataOperation(Trigger.new);
            handler.ownershipUpdateNAM(Trigger.new);
        }
    }
}