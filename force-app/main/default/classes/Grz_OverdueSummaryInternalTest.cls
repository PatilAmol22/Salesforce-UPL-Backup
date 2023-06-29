@isTest
public class Grz_OverdueSummaryInternalTest {
    public static testmethod void unitTest(){
        
        
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='5000';
        s.Sales_Org_Code__c='29';
        insert s;
        
        Distribution_Channel__c dc= new Distribution_Channel__c();
        dc.name='test distributor';
        dc.Distribution_Channel_Code__c='1234';
        insert dc;
        
        
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c	='0001006761';
        acc.SAP_Code__c	='0001006761';
        
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c=s.id;
        acc.Distribution_Channel__c=dc .id;
        acc.Division_Code__c='543';
        insert acc;
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Grz_OverdueSummaryInternal.getData(acc.Id);
        Grz_OverdueSummaryInternal.getOverdueData('123456', '1234567', '5000', 'undefined','2020-10-20 00:00:00','5661');      
        PageReference pageRef = Page.Grz_OverdueSummaryInternalPDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        
        pageRef.getParameters().put('customerNumber','customerNumber');
        pageRef.getParameters().put('sapUserId','sapUserId');
        pageRef.getParameters().put('companyCode','companyCode');
        pageRef.getParameters().put('startDate','startDate');
        pageRef.getParameters().put('endDate','endDate');
        pageRef.getParameters().put('cstName','cstName');
        
        Grz_OverdueSummaryInternal ob2= new Grz_OverdueSummaryInternal();
        ob2.getDataForVF();
        
        test.stopTest();
        
    }
    public static testmethod void unitTest1(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
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
        acc.Ship_To_Party_SAP_Code__c	='0001006761';
        acc.SAP_Code__c	='0001006761';
        acc.Distribution_Channel__c=dc .id;
        acc.Division_Code__c='543';
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c = s.Id;
        insert acc;
        account acc1= new account();
        acc1.recordtypeId=RecordTypeIdContact;
        acc1.Name='test';
        acc1.Ship_To_Party_SAP_Code__c	='0001006761';
        acc1.Distribution_Channel__c=dc .id;
        acc1.Division_Code__c='543';
        acc1.Sales_Org__c = s.Id;
        insert acc1;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Grz_OverdueSummaryInternal.getData(acc.Id);
        Grz_OverdueSummaryInternal.getData(acc1.Id);
        Grz_OverdueSummaryInternal.getOverdueData('123456', '1234567', '5000', '2015-14-20 00:00:00','2025-10-20 00:00:00','5661');
        
    }
    
    
}