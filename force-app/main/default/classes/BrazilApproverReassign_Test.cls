@isTest(seeAllData=true)
public class BrazilApproverReassign_Test {
    public static testmethod void test_getSalesOrderRecordBrazil()
    {
        
      
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062100998','Pending',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'test';
        salesObj1.SalesOfficeManager__c='0050K00000BlAcs';
        salesObj1.CreatedById='0050K00000BlAcs';
        salesObj1.Directed_Sales__c=true;
        salesObj1.Reassigned_Approver__c='0050K00000BlAcs';
        insert salesObj1;
         system.debug('@@@@@@@salesObj1'+salesObj1);
        //////////
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(salesObj1.id);
        Approval.ProcessResult result = Approval.process(app);
         system.debug('@@@@@@@result'+result);
        List<ProcessInstanceWorkitem> pid =[SELECT ProcessInstance.TargetObjectid,ProcessInstance.Status, OriginalActor.id, Actor.id,OriginalActor.name, Actor.name 
                                            FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' 
        									AND ProcessInstance.TargetObject.Type ='Sales_Order__c' 
                                            and ProcessInstance.TargetObjectid =:salesObj1.id];
        system.debug('@@@@@@@pid'+pid);
        
        system.debug('@@@@@@@pid[0].OriginalActor.id'+pid[0].OriginalActor.id);
      
        
        ////////////////
      
        
        
        BrazilApproverReassign brazilapp = new BrazilApproverReassign();
        brazilapp.reassignApprover();       
      
        Test.stopTest();
    }
    
}