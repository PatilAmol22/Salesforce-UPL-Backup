@isTest
public class USApprovalRecallTest {
    static testMethod void testParse(){
         CSR__c c = new CSR__c();
        c.CSR_Status__c ='Approved_at_Level_1';
         c.Level_3__c= False;
         insert c;
         c.Level_3__c= True;
         update c;
         
         
        CSRApprovalRecallSubmit.recallApproval(c.id);

}
}