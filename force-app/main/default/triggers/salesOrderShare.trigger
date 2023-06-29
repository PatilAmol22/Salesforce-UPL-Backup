trigger salesOrderShare on Sales_Order__c ( before update, after insert,  before insert, after update) {
//Test.isrunningtest condition added by Grazitti on 17-8-2021 due to test classes failure due to unavailability of custom settings
if(Test.isRunningTest() ||  Trigger_Settings__c.getValues('salesOrderShareTriger').isActive__c ){
//Added by Vijaylaxmi
//Only below if condition because code is running in all the scenario and earlier code is written only for after insert

 if(Trigger.isInsert && Trigger.isAfter){
        salesOrderTriggerHandler.sharetoTeam(Trigger.new);
        AssignOwnerToMexioSO.assignOwnerPoland(Trigger.new);
       salesOrderTriggerHandler.updateCreatedFromField(Trigger.new);// Added for RITM0459801 GRZ(Mohit Garg) 13-12-2022
   
    }
 }  

// Added by Amit Sharma for Mexico Owner assignment 
if(Trigger.isInsert && Trigger.isBefore){
    SalesOrderTriggerHandler.SalesOrderOwnerUpdateNAM(Trigger.new); // Added for NAM GRZ(Nikhil Verma) 23-03-2023
    AssignOwnerToMexioSO.assignOwner(Trigger.new);
    
     //Added by Sagar@Wipro SO-013 for updating Mother Order's Valid to date
    SalesOrderTriggerHandler.motherOrderValidToUpdate(Trigger.New);
    
     BrazilSalesOrderTaxAndFreightUpdate.BeforeUpdateMyMethod(Trigger.New);  // Brazil Sales Order Update  //  Brazil Sales Order Update  
}

 
//Added by Vijaylaxmi
//Price Control Maxico CR  
    //if(Trigger.isUpdate && Trigger.isBefore && !SalesOrderTriggerHandler.runOnce){
    if(Trigger.isUpdate && Trigger.isBefore){
        SalesOrderTriggerHandler.SalesOrderOwnerUpdateNAM(Trigger.new); // Added for NAM GRZ(Nikhil Verma) 23-03-2023
         System.debug('enter before update ####');
       //  SalesOrderTriggerHandler.runOnce = true;
         SalesOrderTriggerHandler.onBeforeUpdate(Trigger.New);
        //Change for RITM0373560 by EY Team-->
         BrazilSalesOrderTaxAndFreightUpdate.BeforeUpdateMyMethod(Trigger.New);
        //Added by Nandhini for India error capturing
         SalesOrderTriggerHandler.updateErrorMessage(Trigger.New,trigger.oldmap);
    }
    
    
    
    //Added by Sagar@Wipro for Order Unblocking after SDM approves line item edit/cancel changes
    if(Trigger.isUpdate && Trigger.isAfter){
        
        //Added by Sirisha@Wipro OC-001
        System.debug('Test1');
        SalesOrderTriggerHandler.OrderCancellation(Trigger.New); 
        //cpu limit check by Nandhini
        //SalesOrderTriggerHandler.cpuLimitcheck(Trigger.new,Trigger.Oldmap);
        Set<Id> setOrderId = new Set<Id>();
        Set<Id> setOrderId1 = new Set<Id>();
        list<Sales_Order_Line_Item__c> soitList = new list<Sales_Order_Line_Item__c>();
        list<Sales_Order__c> solist = new list<Sales_Order__c>();
        for (Sales_Order__c SO : trigger.new)
        {
            if (SO.SDM_Approval_On_Order_Item_Edit_Cancel__c == true || SO.SDM_Auto_Approval_Item_Edit_Cancel__c == true){
                setOrderId.add(SO.Id);
            }
        }
        System.debug('Test44'); 
        // if (SO.SDM_Approval_On_Order_Item_Edit_Cancel__c && SO.SDM_Approval_On_Order_Item_Edit_Cancel__c != trigger.oldMap.get(SO.Id).SDM_Approval_On_Order_Item_Edit_Cancel__c)
        if(setOrderId.size() > 0){
            List<Sales_Order_Line_Item__c> soitems =  [Select Id,Name,Item_Number__c,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,Quantity_Billed__c ,DateofFAT__c,Cancel_Line_Item__c,New_Quantity__c,New_Date_of_FAT__c,Date_Of_FAT_Changed__c,Quantity_Changed__c,Cancellation_Reason__c,Item_Status__c from Sales_Order_Line_Item__c where Sale_Order__c IN:setOrderId AND (Date_Of_FAT_Changed__c = true OR Quantity_Changed__c = true OR Cancel_Line_Item__c =true)];
            if(soitems.size() > 0){
                // update soitList;
                System.debug('Sagar Test when SO gets approved');
                id soidapi = new list<id>(setOrderId)[0];
                Sales_Order__c soapi = [select id,SFDC_Order_Number__c,OwnerId, SAP_Order_Number__c,Order_Status__c,SalesDistrictManager__c from Sales_Order__c where Id=:soidapi];
                if(System.IsBatch() == false && System.isFuture() == false){ 
                    BrazilOrderItemEditController.OrderItemBlockingCallout(json.serialize(soapi),json.serialize(soitems),2);
                   // BrazilOrderItemEditController.OrderItemChangeCallout(json.serialize(soapi),json.serialize(soitems));
                }
            }
        }
        
        //Added by Sagar@Wipro for Order Unblocking after SDM Rejects line item edit/cancel changes
        System.debug('Test1');
        //  list<Sales_Order_Line_Item__c> soitList = new list<Sales_Order_Line_Item__c>();
        for (Sales_Order__c SO : trigger.new)
        {
            if (SO.SDM_Rejected_OrderItem_Edit_Approval__c == true ){
                setOrderId1.add(SO.Id);
            }
        }
        
        
        if(setOrderId1.size() > 0){
            // update soitList;
            System.debug('Sagar Test when SO gets approved');
            id soidapi1 = new list<id>(setOrderId1)[0];
            Sales_Order__c SO = [select id, SAP_Order_Number__c,SFDC_Order_Number__c,Order_Status__c,SDM_Rejected_OrderItem_Edit_Approval__c from Sales_Order__c where Id =: soidapi1];
            System.debug('Test2');
            List<Sales_Order_Line_Item__c> soitems =  [Select Id,Name,Item_Number__c,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,DateofFAT__c,Item_Cancel__c,New_Quantity__c,New_Date_of_FAT__c from Sales_Order_Line_Item__c where Sale_Order__c =:SO.id];
             if(System.IsBatch() == false && System.isFuture() == false){ 
                 BrazilOrderItemEditController.OrderItemBlockingCallout(json.serialize(SO),json.serialize(soitems),3);
            }        
        } 
    }
}