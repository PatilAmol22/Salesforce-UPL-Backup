@isTest
public class LiquidationApprovalTriggerTest {
    
    static testmethod void test1(){
        
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'LiquidationApprovalTrigger';
        newtri.isActive__c = true;
        INSERT newtri;
        
        Territory_Distributor__c td = new Territory_Distributor__c();
        td.Name = 'test territory';
        td.Liquidation_Submitted__c = false;
        INSERT td;
        
        Liquidation_Approval_History__c lah1 = new Liquidation_Approval_History__c();
        lah1.Territory__c = td.Id;
        lah1.Approval_Status__c = 'Pending for Approval';
        INSERT lah1;
        
        lah1.Approval_Status__c = 'Rejected';
        UPDATE lah1;
        
        lah1.Approval_Status__c = 'Approved';
        UPDATE lah1;
        
    }
}