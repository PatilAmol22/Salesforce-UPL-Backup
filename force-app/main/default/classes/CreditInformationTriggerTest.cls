@isTest
public class CreditInformationTriggerTest {
    public static TestMethod void testmethod1(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.BillingCity='Pune';
        insert acc;
        
        
        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=acc.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Used_Limit__c=10000;
        insert crdIf;
        
        crdIf.Credit_Limit__c=2000;
        update crdIf;
    }
}