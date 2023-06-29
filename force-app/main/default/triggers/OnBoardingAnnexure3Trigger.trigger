/**************************************************************************************************
* Name             : OnBoardingAnnexure3Trigger                                                      
* Created Date     : 16-01-2023                                                                        
* Project/JIRA     : APPS-2665                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 16-01-2023                                                                        
**************************************************************************************************/

trigger OnBoardingAnnexure3Trigger on On_Boarding_Annexure_3__c (before delete) {
	if(trigger.isBefore && trigger.isDelete){
        Grz_OnBoardingAnnexure3TriggerHandler.beforeDeleteErrorOfOnBoarding(trigger.old);
    }
}