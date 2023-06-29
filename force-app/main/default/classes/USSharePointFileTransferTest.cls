@isTest(SeeAllData = true)
private class USSharePointFileTransferTest{


     static testMethod void test1(){
        RecordType rd = [select id, name from RecordType where  SobjectType='Account' AND DeveloperName='US_Distributor'];
        
        Account acc = [select id, name from Account where Name='Test US Account'];
        
        CSR__c c =[select id, name from CSR__c where Account_Name__c =: acc.id limit 1]; 
        Case ca = [Select id, AccountId from Case where AccountID =: acc.id limit 1]; 
      
                USSharePointFileTransfer.CallCSRServiceforFileTransfer(c.id);
                USSharePointFileTransfer.CallCSRServiceforFileTransfer('');
                USSharePointFileTransfer.CallCaseServiceforFileTransfer(ca.id);
                USSharePointFileTransfer.CallCaseServiceforFileTransfer('');
    
    }
}