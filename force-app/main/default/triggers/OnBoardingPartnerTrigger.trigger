/**************************************************************************************************
* Name             : OnBoardingPartnerTrigger                                                      
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

trigger OnBoardingPartnerTrigger on On_Boarding_Partner__c (before delete) {
	if(trigger.isBefore && trigger.isDelete){
        Grz_OnBoardingPartnerTriggerHandler.beforeDeleteErrorOfOnBoardingPartner(trigger.old);
    }
}