/**************************************************************************************************
* Name             : OnBoardingOtherBusinessTrigger                                                      
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

trigger OnBoardingOtherBusinessTrigger on On_Boarding_Other_Business__c (before delete) {
	if(trigger.isBefore && trigger.isDelete){
        OnBoardingOtherBusinessTriggerHandler.beforeDeleteErrorOfOnBoardingOtherBusiness(trigger.old);
    }
}