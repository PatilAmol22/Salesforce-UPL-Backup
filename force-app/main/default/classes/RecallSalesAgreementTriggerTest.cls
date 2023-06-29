@isTest
public class RecallSalesAgreementTriggerTest {

    @isTest
    public static void test1(){
        RecallSalesAgreements__e event = new RecallSalesAgreements__e();
        event.SalesAgreementId__c = 'test';
        Test.startTest();
        Eventbus.publish(event);
        Test.stopTest();
    }
}