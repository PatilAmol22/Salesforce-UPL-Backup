/*******************************************************************************************
* @Name         pathfinderRecordSubmissionr 
* @Author       Ishu Mittal
* @Date         06/20/2022
* @Group        EY
* @Description  Trigger for GTM__c object
*******************************************************************************************/
//Changes for RITM0370177 By ET Team
trigger pathfinderRecordSubmission on GTM__c (after update) {

    if(trigger.isUpdate && trigger.isAfter){
        GTMPathFinder.updateGtmDetails(Trigger.New,Trigger.oldMap);
        }
}