/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-09-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger MassUploadCSVTrigger on Mass_Upload_CSV__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.run(new MassUploadCSVTriggerHandler('MassUploadCSVTrigger'));
}