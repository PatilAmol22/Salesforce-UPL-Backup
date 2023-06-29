@isTest(seeAllData=False)
private class TST_BCH_Account_Delete {
	@Testsetup
    static void setupTestData(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
            
        Account acnt= new Account();
        acnt.Name = 'Test Account';
        acnt.Email__c='varshriv@ulp-ltd.com';
        acnt.RecordTypeId=devRecordTypeId;
        acnt.Mobile__c='9867341712';
        acnt.Phone='020256580';
        insert acnt;
    }
    
    static testmethod void checkBatchCoverage(){
        Test.startTest();
        	BCH_Account_Delete bch = new BCH_Account_Delete();
        	Database.executeBatch(bch);
        Test.stopTest();
    }
}