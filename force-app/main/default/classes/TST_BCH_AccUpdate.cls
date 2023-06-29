@isTest(seeAllData=False)
private class TST_BCH_AccUpdate {
	@Testsetup
    static void setupTestData(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        
        State__c st = new State__c();
        st.Name='test';
        st.Language__c='Gujarati';
        st.Country__c='India';
        insert st;
        
        District__c dis = new District__c();
        dis.Name='test';
        dis.State__c=st.Id;
        //dis.Active__c=True;
        insert dis;
        
        Tehsil__c ts = new Tehsil__c();
        ts.Name='vasai';
        //ts.Active__c=true;
        ts.District__c=dis.Id;
        insert ts;
        
        
        Village__c vc= new Village__c();
        vc.Village_Code__c = '803390';
        vc.Name = 'Test Village';
        vc.Tehsil__c = ts.ID;
        insert vc;
            
        Account acnt= new Account();
        acnt.LastName = 'Test Account';
        acnt.Email__c='varshriv@ulp-ltd.com';
        acnt.RecordTypeId=devRecordTypeId;
        acnt.PersonMobilePhone='9867341712';
        acnt.Phone='020256580';
        acnt.Custom_Village_Code__c = 803390;
        insert acnt;
    }
    
    static testmethod void checkBatchCoverage(){
        Test.startTest();
        	BCH_Account_Update bch = new BCH_Account_Update();
        	Database.executeBatch(bch);
        Test.stopTest();
    }
}