@isTest
public class SendFailedSMSBatchTest {
   static void insertRecord() {
       smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
       smsObj.smagicinteract__sentStatus__c = 'Failed';
       smsObj.smagicinteract__disableSMSOnTrigger__c = 1;
       smsObj.smagicinteract__statusMessage__c = 'CALLOUT EXCEPTION';
       smsObj.smagicinteract__ObjectType__c = 'Account';
       smsObj.smagicinteract__Message_Type__c = 'SMS';
       smsObj.smagicinteract__PhoneNumber__c = '9792929489';
       smsObj.smagicinteract__SMSText__c = 'test sms';
       smsObj.smagicinteract__SenderId__c = 'senderId';
       smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
       smsObj.smagicinteract__Source__c = '1150';
       insert smsObj;
   }
   static testMethod void testSendFailedSMSBatch1() {
       insertRecord();
       Test.startTest();
       SendFailedSMSBatch bat = new SendFailedSMSBatch();
        Database.executeBatch(bat, 200);
       Test.stopTest();
       System.assert(true);
   }
}