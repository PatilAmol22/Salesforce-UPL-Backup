@isTest
public class BrazilCaseTriggerHelper_Test {
    
    
    @isTest
    static void test1(){
        
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
       User usr= Grz_TestDataFactory.createInternalUser(true,p.id);
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account', recordTypeId);
        Entitlement et=new Entitlement();
        et.Name='Brazil SLAs';
        et.AccountId=acc.id;
        insert et; 
        
        Id caserecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Brazil Case Process').getRecordTypeId();
        Case c=Grz_TestDataFactory.createBrazilCaseRecord(false, 'Test Case 123', 'Order rescheduling', acc.id, caserecordTypeId,et.id,usr.Id);    
        c.description='test';
        insert c;
        User usr2= Grz_TestDataFactory.createInternalUser(true,p.id);
        c.status='Rejeitado';
        c.OwnerId=usr2.id;        
        update c;
        
    
        test.stopTest();
    }
    
}