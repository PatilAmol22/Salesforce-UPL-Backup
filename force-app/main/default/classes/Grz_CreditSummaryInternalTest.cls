@isTest
public class Grz_CreditSummaryInternalTest {
    public static testmethod void unitTest(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='5000';
        s.Sales_Org_Code__c='1000';
        insert s;
        
        Sales_Org__c s1= new Sales_Org__c();
        s1.Name='Test Sales org';                               // Added Sales Org for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
        s1.Sales_Org_Code__c='1000';
        insert s1;
        
        
        
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c	='0001006761';
        acc.SAP_Code__c	='0001006761';
        acc.Ship_To_Party_SAP_Code__c='123';
        
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c=s.id;
        insert acc;
        account acc1= new account();
        acc1.recordtypeId=RecordTypeIdContact;
        acc1.Name='test';
        acc1.Ship_To_Party_SAP_Code__c	='0001006761';
        acc1.Ship_To_Party_SAP_Code__c='123';
        acc1.Sales_Org__c=s.id;
        insert acc1;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        
        PageReference pageRef = Page.Grz_CreditSummaryInternalPDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('fileName','7062133268');
        pageRef.getParameters().put('CreditLimit','70');
        pageRef.getParameters().put('CreditExposure','7062');
        pageRef.getParameters().put('BalanceLimit','7062133268');
        pageRef.getParameters().put('Percentage','70');
        pageRef.getParameters().put('Name','Test');
        Test.setCurrentPage(pageRef);
         
        Grz_CreditSummaryInternal obj= new Grz_CreditSummaryInternal();
        obj.getDataForVF();
        Grz_CreditSummaryInternal.getData(acc.Id,s.Company_Code__c, s.Sales_Org_Code__c);       // Updated for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
        Grz_CreditSummaryInternal.getData(acc1.Id,s1.Company_Code__c, s.Sales_Org_Code__c);		 // Updated for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
        test.stopTest();
    }    
}