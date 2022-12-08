/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-10-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AttachmentTrigger on Attachment  ( before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.run(new AttachmentTriggerHandler('AttachmentTrigger'));

}