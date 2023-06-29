/* Name : TST_AccountUpdateViaSalesDisrtrict
 * Covergae Class : CNT_AccountUpdateViaSalesDisrtrict, BCH_AccountUpdateViaSalesDisrtrict
 * Created By: Varun Shrivastava
*/
@isTest(seeAllData=False)
private class TST_AccountUpdateViaSalesDisrtrict {
    @Testsetup
    static void setupTestData(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c salesorg = new Sales_Org__c();
        salesorg.Name = 'Indnesia';          
        salesorg.Description__c = 'Indnesia';   
        salesorg.Company_Code__c = '6410';    
        salesorg.Sales_Org_Code__c = '6419';
        insert salesorg;
        
        User user1 = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Indonesia'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                Country='Indonesia',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                MobilePhone = '9748694980'
                //  UserRoleId =  ur.Id
            );  
            insert user1;


        Sales_District__c salesDistrict = new Sales_District__c();
        salesDistrict.Name = 'Kalimantan';
        salesDistrict.User__c = user1.ID;
        salesDistrict.Sales_District_Code__c = 'ID0001';
        insert salesDistrict;
            
        Account acnt= new Account();
        acnt.Name = 'Test Account';
        acnt.Email__c='varshriv@ulp-ltd.com';
        acnt.BillingCity ='Indonesia';
        acnt.BillingCountry='Indonesia';
        acnt.Sales_District__c = salesDistrict.ID;
        acnt.RecordTypeId=devRecordTypeId;
        acnt.Mobile__c='9867341712';
        acnt.Phone='020256580';
        acnt.Sales_Org__c=salesOrg.Id;
        insert acnt;
        
    }

    static testmethod void checkCoverage(){
        Test.startTest();
        Sales_District__c salesDistrict =  [Select ID,User__c from Sales_District__c limit 1];
        salesDistrict.User__c = UserInfo.getUserId();
        update salesDistrict;
        List<Id> salesIdList = new List<Id>();
        salesIdList.add(salesDistrict.ID);
        CNT_AccountUpdateViaSalesDisrtrict.getAccountNames(salesIdList);
        Test.stopTest();
    }
}