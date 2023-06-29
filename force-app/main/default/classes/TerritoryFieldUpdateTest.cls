@isTest
public class TerritoryFieldUpdateTest {
    static testMethod void validate() {
        Sales_Org__c sOrg = new Sales_Org__c();
        sOrg.Sales_Org_Code__c = '1410'; //'1000';
        insert sOrg;
        
        Territory_Distributor__c t = new Territory_Distributor__c();
        t.SalesOrg__c = sOrg.Id;
        insert t;
        
        TerritoryFieldUpdate a = new TerritoryFieldUpdate();
        //system.schedule('Test Territory Check', sch, sh1);  
        a.execute(null);
        
            
    }
}