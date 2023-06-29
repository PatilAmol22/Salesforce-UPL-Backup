@isTest
public class QuickOrderRedirectCotrollerTest {
    static testMethod void Method() {
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Auto_Number__c autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        
        Account ac = new Account();
        ac.Name='Bhavik Devdhar';
        ac.Last_Name__c='Devdhar';
        ac.PriceGroupCode__c=pg.id;
        ac.SAP_Code__c='SAP996734';
        ac.RecordTypeId=distributorRecordTypeId;
        ac.Mobile__c='9967341759';
        ac.Phone='020256589';
        ac.BillingCity='Pune';
        ac.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert ac;
        
        PageReference pageRef2 = Page.QuickOrderRedirect;
        Test.setCurrentPage(pageRef2);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(ac);
        QuickOrderRedirectController ordmanage2 = new QuickOrderRedirectController(sc2);
        ordmanage2.redirectPage();
    }
}