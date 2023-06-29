@istest

public with sharing class BrazilApproverReassignScheduler_Test{
 static testmethod void Method1() {
            Test.startTest();
            BrazilApproverReassignScheduler   obj = new BrazilApproverReassignScheduler();
            obj.execute(null);
            Test.stopTest();
        }
}