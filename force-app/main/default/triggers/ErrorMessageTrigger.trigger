/*
* Name: ErrorMessageTrigger
* Created On: 14 Sept 2017
* Author: KETAN KHATRI
* Description: Trigger is used for showing the message of transaction log record into 
               the Error Message field of the related Sales Order record.
*/

trigger ErrorMessageTrigger on Transaction_Log__c (after insert){
    Set<ID> salesOrderIdSet = new Set<ID>();
    Set<ID> salesOrderLineItemIdSet = new Set<ID>();
    
    if(Trigger.isAfter && Trigger.isInsert){
        //Add Sales Order IDs to Set for SOQL
        for(Transaction_Log__c tlObj:Trigger.New){
            if(String.isNotBlank(tlObj.Sales_Order__c) && (tlObj.Status__c == 'Failed' || tlObj.Status__c == 'E' || tlObj.Status__c == 'Error from SAP')){
                salesOrderIdSet.add(tlObj.Sales_Order__c);
            }
        }
        
         /**
                Modified By : Sandip Atkari 
                Added below logic as per request by Mohan regarding Order level cancellation & item level updation
                Dated : 12/10/2018
        */
        for(Transaction_Log__c tlObj:Trigger.New){
            if(String.isNotBlank(tlObj.Sales_Order_Line_Item__c) && (tlObj.Status__c == 'Failed' || tlObj.Status__c == 'E' || tlObj.Status__c == 'Error from SAP')){
                salesOrderLineItemIdSet.add(tlObj.Sales_Order_Line_Item__c);
            }
        }
        
        //Map Error Message with SalesOrderIDs
        Map<ID,Sales_Order__c> salesOrderMap = new Map<ID,Sales_Order__c>();
        for(Sales_Order__c soObj:[Select Id,ErrorMessage__c,Order_cancellation_error_message__c FROM Sales_Order__c WHERE Id IN: salesOrderIdSet]){
            salesOrderMap.put(soObj.Id, soObj);
        }
        
         /**
                Modified By : Sandip Atkari 
                Added below logic as per request by Mohan regarding Order level cancellation & item level updation
                Dated : 12/10/2018
        */
        Map<ID,Sales_Order_Line_Item__c> salesOrderLineItemMap = new Map<ID,Sales_Order_Line_Item__c>();
        for(Sales_Order_Line_Item__c solnObj:[Select Id,Item_Message__c FROM Sales_Order_Line_Item__c WHERE Id IN: salesOrderLineItemIdSet]){
            salesOrderLineItemMap.put(solnObj.Id, solnObj);
        }
        
        //Process each error record and append Transaction message to previous Error message against appropriate Sales Order
        for(Transaction_Log__c tlObj:Trigger.New){
            if(String.isNotBlank(tlObj.Sales_Order__c) && (tlObj.Status__c == 'Failed' || tlObj.Status__c == 'E' || tlObj.Status__c == 'Error from SAP')){

                if(salesOrderMap.containsKey(tlObj.Sales_Order__c)){
                    Sales_Order__c soObj = salesOrderMap.get(tlObj.Sales_Order__c);
                    if(String.isNotBlank(soObj.ErrorMessage__c)){
                        soObj.ErrorMessage__c += ','+tlObj.Message__c;   
                    }
                    else{
                        soObj.ErrorMessage__c = tlObj.Message__c;
                    }
                    
                    if(String.isNotBlank(soObj.Order_cancellation_error_message__c)){
                        soObj.Order_cancellation_error_message__c+= ','+tlObj.Cancellation_Message__c;   
                    }
                    else{
                        soObj.Order_cancellation_error_message__c= tlObj.Cancellation_Message__c;
                    }
                    salesOrderMap.put(soObj.Id, soObj);
                }
             }   
             
             
             /**
                Modified By : Sandip Atkari 
                Added below logic as per request by Mohan regarding Order level cancellation & item level updation
                Dated : 12/10/2018
             */
             if(String.isNotBlank(tlObj.Sales_Order_Line_Item__c) && (tlObj.Status__c == 'Failed' || tlObj.Status__c == 'E' || tlObj.Status__c == 'Error from SAP')){
                if(salesOrderLineItemMap.containsKey(tlObj.Sales_Order_Line_Item__c)){
                    Sales_Order_Line_Item__c solnObj = salesOrderLineItemMap.get(tlObj.Sales_Order_Line_Item__c);
                    if(String.isNotBlank(solnObj.Item_Message__c)){
                        solnObj.Item_Message__c += ','+tlObj.Item_Message__c ;   
                    }
                    else{
                        solnObj.Item_Message__c = tlObj.Item_Message__c ;
                    }
                                      
                    salesOrderLineItemMap.put(solnObj.Id, solnObj);
                }
            }
        }
        
        
         /**
                Modified By : Sandip Atkari 
                Added below logic as per request by Mohan regarding Order level cancellation & item level updation
                Update only salesOrder or salesOrderLineItem not null. 
                Dated : 12/10/2018
        */
        //Update all Sales Orders with the new Error messages
        if(salesOrderMap != null){
            update salesOrderMap.values();
        }
        
        if(salesOrderlineItemMap != null){
            update salesOrderlineItemMap.values();
        }
        
    }
}