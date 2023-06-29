@isTest
public with sharing class ApprovalComponentControllerTestClass {
    static testmethod void myTestMethod1() {
     User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Poland(Key Account Manager)'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
    );
    insert u;
       
         Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Poland',           
            Company_Code__c = '001',     
            Sales_Org_Code__c = '2941',    
            Country_Code__c = 'TEST'        
        );
        insert SalesOrgObj;
        System.runAs(u){
        Sales_Order__c sobj = new Sales_Order__c(
            Sales_Org_lk__c = SalesOrgObj.Id,
            Order_Raise_By__c='Regular Distributor',
            Sent_for_Manager_Approval_Mexico__c = True,
            IsCustomerPortal__c  = false,
            Need_Community_Approval__c  = false,
            Order_Status__c = 'Pending'
        );
        insert sobj;
		System.debug('sobj -->'+[Select Id,SalesOrgCode__c,Order_Status__c  from Sales_Order__c where Id=:sobj.id].SalesOrgCode__c);
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
        req.setComments('Submitting approval request Test');        
        req.setObjectId(sobj.id);
        Approval.ProcessResult result = Approval.process(req); 
        
        Id recid = [Select Id from Sales_Order__c where Id=:sobj.id].Id;
        ApprovalComponentController aprc = new ApprovalComponentController();
        aprc.recId = recid;
        aprc.myApprovalData();
        Boolean approvetest = aprc.myApprovalData;
        }
    }
}