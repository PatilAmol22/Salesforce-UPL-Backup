/**************************************************************************************************
* Name             : POBTrigger                                                      
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

trigger POBTrigger on Particulars_of_the_Business__c (before delete) {
    if(trigger.isBefore && trigger.isDelete){
        Grz_PartiOfBusinssTriggerHandler.beforeDeleteError(trigger.old);
    }
}