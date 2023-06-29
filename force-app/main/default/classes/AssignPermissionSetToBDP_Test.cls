@isTest
private class AssignPermissionSetToBDP_Test {
    
    private static testMethod void testFutureMethod(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User u = new User(Alias = 'stan123', Email='stan123user@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='stan123', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='user1997@testorg.com');
        insert u;
        
        List<PermissionSet> ps= [SELECT Id, Name FROM PermissionSet where Name IN ('DPE_Permission_Set','AnalyticsStoreUser')];
        
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = u.Id;
        psa1.PermissionSetId = ps[0].Id;
        insert psa1;
        
        PermissionSetAssignment psa2 = new PermissionSetAssignment();
        psa2.AssigneeId = u.Id;
        psa2.PermissionSetId = ps[1].Id;
        insert psa2;
        
        Test.startTest();
        System.runAs(u)
        {            
            AssignPermissionSetToBDP.assignPermissionSet();
            AssignPermissionSetToBDP.removePermissionSet();
            AssignPermissionSetToBDP.sendMailToBDP();
        }
        Test.stopTest();
        
    }
}