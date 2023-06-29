/**************************************************************************************************
* Name             : grz_returnSalesOrderTrigger                                                      
* Description      : Trigger to populate ZSM,SBU and Tm onto the return sales order,map equivalent
                     statuses on return sales order line items and provide
                     certain custom validations(error messages) via apex.
* Test Class       : grz_ReturnSalesOrderControllerTest
* Created Date     : 14-11-2022                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 07-12-2022                                                                        
**************************************************************************************************/

trigger grz_returnSalesOrderTrigger on Return_Sales_Order__c (before insert,after update,before update,after insert) {
    if(trigger.isAfter && trigger.isInsert){
        grz_returnSalesOrderHandler.afterReturnInsert(Trigger.newMap);
    }
    if(trigger.isBefore && (trigger.isInsert||trigger.isUpdate)){
        grz_returnSalesOrderHandler.beforeReturnUpdateInsert(Trigger.newMap, trigger.old, trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
        grz_returnSalesOrderHandler.afterReturnUpdate(Trigger.newMap, trigger.old);
    }
    
}