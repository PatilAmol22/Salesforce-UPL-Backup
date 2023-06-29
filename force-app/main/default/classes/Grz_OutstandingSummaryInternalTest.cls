@isTest
public class Grz_OutstandingSummaryInternalTest {
    //Changes by Grazitti for SWOT requirements 11Oct22
    public static testmethod void unitTest(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='5660';
        s.Sales_Org_Code__c='5661';
        insert s;
        
        Distribution_Channel__c dc= new Distribution_Channel__c();
        dc.name='test distributor';
        dc.Distribution_Channel_Code__c='1234';
        insert dc;
        
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c   ='0001006761';
        acc.SAP_Code__c ='0001006761';
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c=s.id;
        acc.Distribution_Channel__c=dc .id;
        acc.Division_Code__c='1235567';
        insert acc;
        
        account acc1= new account();
        acc1.recordtypeId=RecordTypeIdContact;
        acc1.Name='test';
        acc1.Ship_To_Party_SAP_Code__c  ='0001006761';
        acc1.Sales_Org__c=s.id;
        acc1.Distribution_Channel__c=dc .id;
        acc1.Division_Code__c='1235567';
        insert acc1;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Grz_OutstandingSummaryInternal.getSalesAreaValues('recId');
        Grz_OutstandingSummaryInternal.getData(acc.Id,'');
        Grz_OutstandingSummaryInternal.getData(acc1.Id,'');
        Grz_OutstandingSummaryInternal.getData(acc1.Id,'1001201');
        Grz_OutstandingSummaryInternal.getData('invalid','');
        Grz_OutstandingSummaryInternal.getOutstanding360Data(acc1.Id, null, null);
        Grz_OutstandingSummaryInternal.getOutstanding360Data('invalid', null, null);
        PageReference pageRef = Page.Grz_OutstandingSummaryInternalPDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        
        pageRef.getParameters().put('OutstandingData','{"customerNumber":"0001085776","custName":"CIA AGROPECUARIA COPEVAL S A","bucket1":"0.0","bucket2":"0.0","bucket3":"0.0","bucket4":"0.0","bucket5":"0.0","bucket6":"0.0","bucket7":"0.0","bucket8":"0.0","bucket9":"15265940.52","totalOutstanding":"15265940.52","unadjustedReceipts":"0.0","unadjustedCredits":"-4655.87","netOutstanding":"15261284.65","currencyKey":"USD"}');
        
        Test.setCurrentPage(pageRef);
        Grz_OutstandingSummaryInternal obj1 = new Grz_OutstandingSummaryInternal();
        obj1.getDataForVF();
        test.stopTest();       
    }
    //Changes by Grazitti for SWOT requirements 11Oct22
    public static testmethod void unitTest1(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Distribution_Channel__c dc= new Distribution_Channel__c();
        dc.name='test distributor';
        dc.Distribution_Channel_Code__c='1234';
        insert dc;
        
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='5660';
        s.Sales_Org_Code__c='1000';
        insert s;
        
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c   ='0001006761';
        acc.SAP_Code__c ='0001006761';
        acc.Ship_To_Party_SAP_Code__c='123';
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c=s.id;
        insert acc;
        test.startTest();
        Grz_OutstandingSummaryInternal.getData(acc.Id,'');
        test.stopTest();
    }
    //Changes by Grazitti for SWOT requirements 11Oct22
    public static testmethod void unitTest2(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Distribution_Channel__c dc= new Distribution_Channel__c();
        dc.name='test distributor';
        dc.Distribution_Channel_Code__c='1234';
        insert dc;
        
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c   ='0001006761';
        acc.Ship_To_Party_SAP_Code__c='123';
        insert acc;
        test.startTest();
        Grz_OutstandingSummaryInternal.getData(acc.Id,'');
        test.stopTest();
    }
}