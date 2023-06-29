@isTest
public class CampaignExporterTest {
    static testMethod void CampaignExporterCheck(){
        Test.startTest();
        CampaignExporter  sch2 = new CampaignExporter();
        String sch = '0 31 17 * 4 ?';
        system.schedule('One Time Pro', sch, sch2);
        Test.stopTest();
    }
}