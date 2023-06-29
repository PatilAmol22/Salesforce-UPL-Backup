@istest
public class CampYrCalTest {
    @istest
    static void  testschedule() {
        Test.StartTest();
        NAM_Capaign_Year__mdt CampgnYrNAMCurr = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMCurrentCampaignYear'];
        NAM_Capaign_Year__mdt CampgnYrNAMPrev = [SELECT StartDate__c,EndDate__c,Label FROM NAM_Capaign_Year__mdt where Label='NAMPreviousCampaignYear'];
        Sales_Org__c sg = new Sales_Org__c();
        sg.Name = 'USA';
        sg.Sales_Org_Code__c = '3100';
        insert sg;
        SKU__c sk = new SKU__c();
        sk.Name = 'test';
        sk.Sales_Org__c = sg.Id;
        sk.SKU_Code__c = '012345673';
        insert sk;
        Secondary_Sales_Data__c sd = new Secondary_Sales_Data__c();
        sd.Year__c = String.valueOf((CampgnYrNAMPrev.EndDate__c).Year());
        sd.Month__c = String.valueOf((CampgnYrNAMPrev.EndDate__c).Month());
        sd.Sales_Org__c = sg.Id;
        sd.Product_Name__c = sk.Id;
        insert sd;
        Account acc = new Account();
        acc.Name = 'test';
        acc.Sales_Org__c = sg.Id;
        insert acc;
        Invoice__c inv = new Invoice__c();
        inv.Billing_Date__c = CampgnYrNAMPrev.EndDate__c;
        inv.Sales_Org__c = sg.Id;
        inv.Sold_To_Party__c = acc.Id;
        insert inv;
        system.schedule('jobName', '0 0 0 * * ?', new CampYrCal());
        CampYrCal.calCamp();
        Test.stopTest();
    }
}