@isTest
public class EmailtoTaskServiceTest {
    static testMethod void test1(){
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Account accObj = new Account();
        accObj.Name = 'Test'; 
        accObj.First_Name__c = 'Test'; 
        accObj.Last_Name__c = 'Test';
        accObj.RecordTypeId = distributorRecordTypeId;
        accObj.Mobile__c = '9967341750';
        accObj.Email__c = 'test@test.com';
        insert accObj;
        
        
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        EmailtoTaskService emtotaObj = new EmailtoTaskService();
        
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        String contactEmail = 'test@domain.com';
        email.ccAddresses = new String[] {'Test Domain <' + contactEmail + '>'};
            email.subject = 'Dummy Subject';
        
        
        emtotaObj.handleInboundEmail(email, envelope);
        
    }
    static testMethod void test2(){
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.First_Name__c = 'Test';
        accObj.Last_Name__c = 'Test';
        accObj.RecordTypeId = distributorRecordTypeId;
        accObj.Mobile__c ='9967341751';
        accObj.Email__c = 'test@test.com';
        insert accObj;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        EmailtoTaskService emtotaObj = new EmailtoTaskService();
        
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        String contactEmail = 'test@domain.com';
        email.ccAddresses = new String[] {'Test Domain <' + contactEmail + '>'};
            email.subject = 'Dummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy SubjectDummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy SubjectDummy SubjectDummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy SubjectDummy Subject Dummy Subject Dummy Subject Dummy Subject Dummy Subject';
        
        
        emtotaObj.handleInboundEmail(email, envelope);
        
    }
    
}