@isTest
public class LiquidationTriggerTest {
    static testMethod void validate() {
        //Trigger_Settings__c newtri = Trigger_Settings__c.getValues('LiquidationTrigger');
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'LiquidationTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        Territory_Distributor__c t = new Territory_Distributor__c();
        t.Liquidation_Submitted__c = false;
        insert t;
        
        Liquidation2__c l = new Liquidation2__c();
		l.submitted_Trade_SWAL__c = false;
        l.Territory__c = t.id;
        insert l;
        
        l.submitted_Trade_SWAL__c = true;
        update l;
        l.submitted_Trade_SWAL__c = false;
        update l;
        l.submitted_Trade_SWAL__c = true;
        update l;
    }

}