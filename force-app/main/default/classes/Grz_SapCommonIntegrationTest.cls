@isTest
public class Grz_SapCommonIntegrationTest {
    public static testmethod void unitTest(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Grz_SapCommonIntegration.creditSummary('123','002','test');
        Grz_SapCommonIntegration.overdueSummary('123','test','876','1','5','66');
        Grz_SapCommonIntegration.customerLedger('123','test','876','1','5','6');
        Grz_SapCommonIntegration.customerOutstanding('123','test','876','1','5','66');
        Grz_SapCommonIntegration.creditSummaryIND('123','656','7665');
        Grz_SapCommonIntegration.customerLedgerIND('123','3454','675','8867','8767','7');
        Grz_SapCommonIntegration.overdueSummaryIND('123','3454','675','8867','8767','7');
        Grz_SapCommonIntegration.customerOutstandingIND('123','3454','675','8867','8767','7');
        Grz_SapCommonIntegration.collection('123','3454','675','8867','8767');
        Grz_SapCommonIntegration.collectionIND('123','3454','675','8867','8767');
        
        //Code Updated by Grz(Sumit Kumar) 21-02-2023 for cover the method added in  Grz_SapCommonIntegration apex class
        Grz_SapCommonIntegration.creditSummaryMarketingIND('123','656','7665','Marketing');
        Grz_SapCommonIntegration.overdueSummaryMarketingIND('123','3454','675','8867','8767','7','Marketing');
        Grz_SapCommonIntegration.customerLedgerMarketingIND('123','3454','675','8867','8767','7','Marketing');
        Grz_SapCommonIntegration.customerOutstandingMarketingIND('123','3454','675','8867','8767','7','Marketing');
        Grz_SapCommonIntegration.collectionMarketingIND('123','3454','675','8867','8767','Marketing');
		Grz_SapCommonIntegration.GSTMarketingIND('123','3454','675','8867','8767','Marketing');
        Grz_SapCommonIntegration.invoiceMarketingIND('123','8767','Marketing');
        Grz_SapCommonIntegration.getIntegrationMappings();
        test.stopTest();
        
    }
}