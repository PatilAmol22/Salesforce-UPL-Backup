/**************************************************************************************************
* Name             : OnBoardingLegalCaseTrigger                                                      
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

trigger OnBoardingLegalCaseTrigger on On_Boarding_Legal_Cases__c (before delete) {
	if(trigger.isBefore && trigger.isDelete){
        Grz_OnBoardingLegalCasesTriggerHandler.beforeDeleteErrorOfOnBoardingCase(trigger.old);
    }
}