/**************************************************************************************************
* Name             : grz_returnSalesOrderLineItem                                                      
* Description      : Trigger to provide certain custom validations(error messages) like available 
                     quantitites to return and UOM check via apex along with the profiles that have
                     access to edit the record.
* Test Class       : grz_ReturnSalesOrderControllerTest
* Created Date     : 14-11-2022                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 14-11-2022                                                                        
**************************************************************************************************/
 
trigger grz_returnSalesOrderLineItem on Return_Sales_Order_Line_Item__c (before Update,before insert,after Update,after insert){
    if(trigger.isBefore&&trigger.isInsert){
        grz_returnSalesOrderLineItemHandler.beforeReturnInsert(trigger.new);
    }
    if(trigger.isAfter&&(trigger.isInsert || trigger.isUpdate)){
        grz_returnSalesOrderLineItemHandler.afterReturnInsUp(trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate){
        grz_returnSalesOrderLineItemHandler.beforeReturnUpdate(trigger.new, trigger.old, trigger.newMap, trigger.OldMap);
    }
    
    
    }