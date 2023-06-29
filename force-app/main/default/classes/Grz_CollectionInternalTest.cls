@isTest
public class Grz_CollectionInternalTest {
    public static testmethod void unitTest(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='5000';
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
        
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c=s.id;
        acc.Distribution_Channel__c=dc .id;
        acc.Division_Code__c='543';
        insert acc;
        
         
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Grz_CollectionInternal.getData(acc.Id);
        Grz_CollectionInternal.getCollectionData('123','456','789','098','765','1000');
        
        PageReference pageRef = Page.Grz_CollectionInternalPDF; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('customerCode','7062133268');
        pageRef.getParameters().put('companyCode','5000');
        
        pageRef.getParameters().put('fiscalYear','2021');
        pageRef.getParameters().put('fiscalYearFrom','2019');
        pageRef.getParameters().put('fiscalYearTo','2022');
        pageRef.getParameters().put('sapUserId','7062');
        Test.setCurrentPage(pageRef);
        Grz_CollectionInternal obj1 = new Grz_CollectionInternal();
        obj1.getDataForVF();
        test.stopTest();       
    }
    public static testmethod void unitTest1(){
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<Sales_Org__c> sorgList = new List<Sales_Org__c>();
        Sales_Org__c s= new Sales_Org__c();
        s.Name='Test Sales org';
        s.Company_Code__c='5000';
        s.Sales_Org_Code__c='1800';
        sorgList.add(s);
        
        Sales_Org__c s1= new Sales_Org__c();
        s1.Name='Test Sales org';
        s1.Sales_Org_Code__c='5661';
        sorgList.add(s1);
        insert sorgList;
        
        Distribution_Channel__c dc= new Distribution_Channel__c();
        dc.name='test distributor';
        dc.Distribution_Channel_Code__c='1234';
        insert dc;
        
        List<account> accList = new List<account>();
        account acc= new account();
        acc.recordtypeId=RecordTypeIdContact;
        acc.Name='test';
        acc.Ship_To_Party_SAP_Code__c	='0001006761';
        acc.SAP_Code__c	='0001006761';        
        acc.Sap_UserId__c='UPLINTCRM';
        acc.Sales_Org__c=sorgList[0].id;
        acc.Distribution_Channel__c=dc .id;
        acc.Division_Code__c='543';
        accList.add(acc);
        
        account acc1= new account();
        acc1.recordtypeId=RecordTypeIdContact;
        acc1.Name='Test Account 1';
        acc1.Sales_Org__c=sorgList[1].id;
        acc1.Ship_To_Party_SAP_Code__c	='0001006761';
        accList.add(acc1);
        insert accList;
        
        test.startTest();
        Grz_CollectionInternal.getCollectionData('123','456','789','098','765','5661');
        Grz_CollectionInternal.getData(accList[0].id);
        Grz_CollectionInternal.getData(accList[1].id);
        Grz_CollectionInternal.getData('12345675432');
        test.stopTest();
    }
}