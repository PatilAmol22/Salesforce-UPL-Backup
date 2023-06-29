@isTest(SeeAllData=true)
public class Mexico_Case_Escalation_Batch_Test {
    
static testMethod void TestMexico_Case_Escalation_Batch() {
Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mexico Distributor').getRecordTypeId();
Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    
 Account testAccount = new Account();
 testAccount.Name='Test Account' ;
 testAccount.RecordTypeId = RecordTypeIdAccount;
 insert testAccount;
    
    
    Promotional_Product__c p = new Promotional_Product__c();
    p.name = 'test';
    insert p;
    
    Crop__c crop1 = new Crop__c();
    crop1.Name = 'Crop1';
    insert crop1;
    
      
    Case c1 = new Case();
    c1.Status = 'Approved';
    c1.Approval_Submitted_Date__c = Date.newInstance(2019, 12, 9);
    c1.AccountId = testAccount.id;
    c1.Crop_pick__c = 'Banana';
    //c1.Promotional_Product__c = p.id;
    c1.Type = 'Account Ledger';
    c1.RecordTypeId = RecordTypeId;
    c1.Crop__c = crop1.Id;
    insert c1;
    
    Case c2 = new Case();
    c2.Status = 'Approved';
    c2.Approval_Submitted_Date__c = Date.newInstance(2019, 12, 9);
    c2.OpenNewEscalationDateTime__c = Date.newInstance(2020, 12, 9);
    c2.AccountId = testAccount.id;
    c2.Crop_pick__c = 'Banana';
   // c2.Promotional_Product__c = p.id;
    c2.Type = 'Account Ledger';
    c2.RecordTypeId = RecordTypeId;
    c2.Crop__c = crop1.Id;
    insert c2;
    
    Test.startTest();
          
            Mexico_Case_Escalation_Batch obj = new Mexico_Case_Escalation_Batch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
}

}