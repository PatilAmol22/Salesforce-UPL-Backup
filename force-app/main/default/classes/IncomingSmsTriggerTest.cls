@isTest
public class IncomingSmsTriggerTest {
    static testMethod void test1(){
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.First_Name__c = 'Test';
        accObj.Last_Name__c = 'Test';
        accObj.RecordTypeId = distributorRecordTypeId;
        accObj.Mobile__c = '9967341750';
        insert accObj;
        
        smagicinteract__Incoming_SMS__c smObj =  new smagicinteract__Incoming_SMS__c();
        smObj.smagicinteract__external_field__c = 'test';
        smObj.smagicinteract__Mobile_Number__c = '9967341750';
        insert smObj;
    }
    
    static testMethod void test2(){
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        smagicinteract__Incoming_SMS__c smObj =  new smagicinteract__Incoming_SMS__c(); 
        smObj.smagicinteract__external_field__c = 'test';
        smObj.smagicinteract__Mobile_Number__c = '9967341750';
        insert smObj;
    }
}