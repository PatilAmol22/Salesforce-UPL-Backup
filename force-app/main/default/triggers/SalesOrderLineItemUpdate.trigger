trigger SalesOrderLineItemUpdate on Sales_Order_Line_Item__c (after update,after insert, before update,before insert) {
	Set<ID> setID = new Set<ID>();

    //added by Ashraf- to dump the product qty to salesorder qty
  if(Trigger.isInsert && Trigger.isAfter){
         System.debug('enter SalesOrderLineItem');
          SalesOrderLineItemTriggerHandler.onAfterInsert(Trigger.New);
    }
      //end 
   //CREATED Trigger FOR INVENTORY CONTROL BY HARSHIT&ANMOL@WIPRO FOR (US IU-001) ---START 
   if(Trigger.isInsert && Trigger.isAfter){  
        List<Sales_Order_Line_Item__c> salesOrderItemList = new  List<Sales_Order_Line_Item__c>();
       for(Sales_Order_Line_Item__c s: Trigger.New){
            string salesorg = s.Sales_Org_Code__c;
            if(salesorg == '5191'){
            salesOrderItemList.add(s);
            				setID.add(s.Sale_Order__c);
            }
       }
         System.debug('enter SalesOrderLineItem inventory');
       if(salesOrderItemList.size() > 0){
                    System.debug('enter SalesOrderLineItem inventory 1');

          SalesOrderLineItemTriggerHandler.inventorycontrol(salesOrderItemList);
                    System.debug('enter SalesOrderLineItem inventory 2');

           
       }
       if(setID.size() > 0) {
			SalesOrderLineItemTriggerHandler.gpLista(setID);
		   }
    }
    //--END
    /*
    if(Trigger.isUpdate && Trigger.isAfter){
         System.debug('enter SalesOrderLineItem changedateofFAT');
          SalesOrderLineItemTriggerHandler.changedateofFAT(Trigger.New);
    }*/

  if(trigger.isUpdate && trigger.isBefore){
      SalesOrderLineItemTriggerHandler.updatenewQuantityToOld(Trigger.new,Trigger.oldMap);
      SalesOrderLineItemTriggerHandler.updateRejectionReason(Trigger.new,Trigger.oldMap);//below code added for RITM0283331 GRZ(Javed Ahmed) ModifiedDate-20-09-2022

   for (Sales_Order_Line_Item__c soit: Trigger.new) {
          Sales_Order_Line_Item__c oldsoit = Trigger.oldMap.get(soit.ID);
          if(soit.New_Date_of_FAT__c == oldsoit.DateofFAT__c) {
              soit.New_Date_of_FAT__c = null;
              soit.Date_Of_FAT_Changed__c = false;
          }
      }

  }
        // below code added for RITM0283331 GRZ(Javed Ahmed) ModifiedDate-20-09-2022
    if( trigger.IsInsert && trigger.isBefore ){
        SalesOrderLineItemTriggerHandler.updateRejectionReason(trigger.new,trigger.oldMap);
    }
     /* if(trigger.isUpdate && trigger.isAfter){
        System.debug('enter SalesOrderLineItem3');
     // SalesOrderLineItemTriggerHandler.ProductCancellation(Trigger.new);
        
  }*/
    
    
    if(trigger.isUndelete && trigger.isAfter ){
        
        
        for(Sales_Order_Line_Item__c c : trigger.new){
            setID.add(c.Sale_Order__c);
        }
       SalesOrderLineItemTriggerHandler.gpLista(setID);

    }
    else if(trigger.isDelete && trigger.isAfter){
        for(Sales_Order_Line_Item__c c : trigger.old){
            setID.add(c.Sale_Order__c);
        }
               SalesOrderLineItemTriggerHandler.gpLista(setID);

    }
    
    else if(trigger.isUpdate && trigger.isAfter){
         for(Sales_Order_Line_Item__c c : trigger.new){
            if(c.Sale_Order__c != null){
                if(trigger.oldmap.get(c.id).Sale_Order__c != c.Sale_Order__c){
            setID.add(c.Sale_Order__c);
                }
            } 
            setID.add(trigger.oldmap.get(c.id).Sale_Order__c);
         }
                       SalesOrderLineItemTriggerHandler.gpLista(setID);

    }

}