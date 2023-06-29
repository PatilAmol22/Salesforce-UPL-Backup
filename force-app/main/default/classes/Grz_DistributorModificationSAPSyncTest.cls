/**************************************************************************************************
* Name             : Grz_DistributorModificationSAPSyncTest                                                     
* Description      : To cover the Apex class Grz_DistributorModificationSAPSync					 
* Created Date     : 01-02-2023                                                                       
* Project/JIRA     : UPL                                                                 
* Created By       : Gurubaksh Grewal  (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 01-02-2023                                                                     
**************************************************************************************************/
@isTest
public class Grz_DistributorModificationSAPSyncTest {
    @testSetup static void setup() {     
        Sales_Org__c objSalesOrg = new Sales_Org__c();
        objSalesOrg.Name = 'test1';
        objSalesOrg.Sales_Org_Code__c = '3710';
        objSalesOrg.Company_Code__c='1200';
        
        insert objSalesOrg;
        
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Test';
        objAcc.Sales_Org__c = objSalesOrg.Id;
        objAcc.Email__c='taruni.uce@test.com';
        objAcc.GST_Validated__c=True;
        insert objAcc;
        
        
    }
    @istest static void SyncMethod1(){     
        list<Account> acc= [SELECT ID from Account];
        Grz_DistributorModificationSAPSync.listOfInput l=new Grz_DistributorModificationSAPSync.listOfInput();
        l.recordId=acc[0].id;
		test.startTest();  
            Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
			Grz_DistributorModificationSAPSync.syncWithSAP(new list<Grz_DistributorModificationSAPSync.listOfInput>{l});
        test.stopTest();
    }
    
    
    @istest static void SyncMethod2(){     
       list<Account> acc= [SELECT ID from Account];
        Grz_DistributorModificationSAPSync.listOfInput l=new Grz_DistributorModificationSAPSync.listOfInput();
        l.recordId=acc[0].id;
		test.startTest();  
            Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
			Grz_DistributorModificationSAPSync.syncWithSAP(new list<Grz_DistributorModificationSAPSync.listOfInput>{l});
        test.stopTest();
    }
}