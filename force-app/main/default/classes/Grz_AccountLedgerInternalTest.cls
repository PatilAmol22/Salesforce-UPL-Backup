@isTest
public class Grz_AccountLedgerInternalTest {
    public static testmethod void unitTest(){
        
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='5000';
        s.Sales_Org_Code__c='5661';
        insert s;
        
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c	='0001006761';
        acc.SAP_Code__c	='0001006761';
        //acc.SAP_Customer_Code__c='123456';   
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c=s.id;
        insert acc;
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        
        Grz_AccountLedgerInternal.getLedgerData('123','5000','2022','2023','2024','UPLINTCRM','1000');
        Grz_SapCommonIntegration.customerLedger('123','5000','2022','2023','2024','UPLINTCRM');
        
        Grz_AccountLedgerInternal.getData(acc.Id);
        
        PageReference pageRef = Page.Grz_AccountledgerInternalPDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('customerCode','7062133268');
        pageRef.getParameters().put('companyCode','5000');
        
        pageRef.getParameters().put('fiscalYear','2021');
        pageRef.getParameters().put('fiscalYearFrom','2019');
        pageRef.getParameters().put('fiscalYearTo','2022');
        pageRef.getParameters().put('sapUserId','7062');
        Test.setCurrentPage(pageRef);
        Grz_AccountLedgerInternal obj1 = new Grz_AccountLedgerInternal();
        obj1.getDataForVF();
        test.stopTest();
    }
    public static testmethod void unitTest1(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='1000';
        s.Sales_Org_Code__c='1000';
        insert s;
        
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c	='0001006761';
        acc.Sales_Org__c = s.Id;
        insert acc;
        
        account acc1= new account();
        acc1.recordtypeId=RecordTypeIdContact;
        acc1.Name='test';
        acc1.Ship_To_Party_SAP_Code__c	='0001006761';
        insert acc1;
        
        test.startTest();
        Grz_AccountLedgerInternal.getData(acc.Id);
        Grz_AccountLedgerInternal.getData(acc1.Id);
        Grz_AccountLedgerInternal.getLedgerData('','','','','','','5661');
        test.stopTest();
    }
    
    public static testmethod void unitTest2(){  
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Ship_To').getRecordTypeId();
        account acc= new account();
        acc.Name='test';
        acc.recordtypeId=RecordTypeIdContact;
        acc.Ship_To_Party_SAP_Code__c	='0001006761';
        acc.BillingPostalCode = '000000';
        insert acc; 
        test.startTest();
        Grz_AccountLedgerInternal.getData(acc.Id);
        test.stopTest();
    }
}