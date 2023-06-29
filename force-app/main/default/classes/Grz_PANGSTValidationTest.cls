/**************************************************************************************************
* Name             : Grz_PANGSTValidationTest                                                     
* Description      : To cover the Apex class Grz_PANGSTValidation
* Created Date     : 28-12-2022                                                                        
* Project/JIRA     : APPS-2662                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti) 28-12-2022                                                                        
**************************************************************************************************/

@isTest
public class Grz_PANGSTValidationTest {
    @isTest static void testPANGSTValidation(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        
        PAN_GST_API_Creds__c objPan = new PAN_GST_API_Creds__c();
        objPan.Name = 'PAN GST Auth Creds';
        objPan.Username__c = 'upl-ltd_prepaid_prod';
        objPan.Password__c = 'y467vTIWwsd5k1s19T';
        insert objPan;
                
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer On-Boarding').getRecordTypeId();
        
        List<Account> lstAcc = new List<Account>();
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Testabc';
        objAcc.Mobile__c = '9192929299';
        objAcc.PAN_Number__c = '3223343';
        objAcc.State_Union_Territory__c = 'Meghalaya';
        objAcc.First_Name__c = 'Test';
        objAcc.Middle_Name__c = 'Abc';
        objAcc.Last_Name__c = 'Account';
        objAcc.PAN_API_Response__c = 'This is for testing';
        objAcc.PAN_Validated__c = false;
        objAcc.Type_of_PAN_Holder__c = 'testing';
        objAcc.PAN_Status__c = 'XYZ';
        lstAcc.add(objAcc);
        
        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = stExam;
        objAcc1.Name = 'Testabcs';
        objAcc1.Mobile__c = '9192929299';
        objAcc1.PAN_Validated__c = true;
        objAcc1.PAN_Number__c = '3220343';
        objAcc1.State_Union_Territory__c = 'Meghalaya';
        objAcc1.Tax_Number_3__c = '343443';
        objAcc1.GST_API_Response__c = 'this is for testing';
        objAcc1.GST_Status__c = 'testt';
        objAcc1.Constitution_of_Business__c = 'ttt';
        objAcc1.GST_Validated__c = true;
        objAcc1.Billing_Street_2__c = 'NewYork';
        objAcc1.BillingState = 'Abc Street';
        objAcc1.BillingCity = 'Jaipur';
        objAcc1.BillingPostalCode = '302030';
        objAcc1.BillingCountry = 'India';
        lstAcc.add(objAcc1);
          
        insert lstAcc;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro.Id);
       
        Test.startTest();
        Grz_PANGSTValidation.getPANData(objAcc.Id);
        Grz_PANGSTValidation.updateNonGST(objAcc.Id);
        Test.stopTest();
    }
    @isTest static void testPANGSTValidation1(){
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        
        PAN_GST_API_Creds__c objPan = new PAN_GST_API_Creds__c();
        objPan.Name = 'PAN GST Auth Creds';
        objPan.Username__c = 'upl-ltd_prepaid_prod';
        objPan.Password__c = 'y467vTIWwsd5k1s19T';
        insert objPan;
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer On-Boarding').getRecordTypeId();

        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = stExam;
        objAcc1.Name = 'Testabcs';
        objAcc1.Mobile__c = '9192929299';
        objAcc1.PAN_Validated__c = true;
        objAcc1.PAN_Number__c = '3220343';
        objAcc1.State_Union_Territory__c = 'Meghalaya';
        objAcc1.Tax_Number_3__c = '343443';
        objAcc1.GST_API_Response__c = 'this is for testing';
        objAcc1.GST_Status__c = 'testt';
        objAcc1.Constitution_of_Business__c = 'ttt';
        objAcc1.GST_Validated__c = false;
        objAcc1.Billing_Street_2__c = 'NewYork';
        objAcc1.BillingState = 'Abc Street';
        objAcc1.BillingCity = 'Jaipur';
        objAcc1.BillingPostalCode = '302030';
        objAcc1.BillingCountry = 'India';
        
        insert objAcc1;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro.Id);
        
        Test.startTest();
        Grz_PANGSTValidation.getGSTData(objAcc1.Id);
        Grz_PANGSTValidation.getPANData(objAcc1.Id);
        Grz_PANGSTValidation.getGSTDataAgain(objAcc1.Id,'17AABCA7375C1D3');
        Test.stopTest();
    }
    
    @isTest static void testPANGSTValidation2(){
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer On-Boarding').getRecordTypeId();

        List<Account> lstAcc = new List<Account>();
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Testabc';
        objAcc.PAN_Number__c = null;
        objAcc.Mobile__c = '9192929299';
        objAcc.State_Union_Territory__c = 'Meghalaya';
        objAcc.First_Name__c = 'Test';
        objAcc.Middle_Name__c = 'Abc';
        objAcc.Last_Name__c = 'Account';
        objAcc.PAN_API_Response__c = 'This is for testing';
        objAcc.PAN_Validated__c = false;
        objAcc.Type_of_PAN_Holder__c = 'testing';
        objAcc.PAN_Status__c = 'XYZ';
        lstAcc.add(objAcc);
        
        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = stExam;
        objAcc1.Name = 'Testabcs';
        objAcc1.PAN_Validated__c = true;
        objAcc1.Mobile__c = '9192929299';
        objAcc1.PAN_Number__c = '3220343';
        objAcc1.State_Union_Territory__c = 'Meghalaya';
        objAcc1.Tax_Number_3__c = '343443';
        objAcc1.GST_API_Response__c = 'this is for testing';
        objAcc1.GST_Status__c = 'testt';
        objAcc1.Constitution_of_Business__c = 'ttt';
        objAcc1.GST_Validated__c = true;
        objAcc1.Billing_Street_2__c = 'NewYork';
        objAcc1.BillingState = 'Abc Street';
        objAcc1.BillingCity = 'Jaipur';
        objAcc1.BillingPostalCode = '302030';
        objAcc1.BillingCountry = 'India';
        lstAcc.add(objAcc1);
        
        insert lstAcc;
        
        Test.startTest();
        Grz_PANGSTValidation.getGSTData(objAcc1.Id);
        Grz_PANGSTValidation.getPANData(objAcc.Id);
        Test.stopTest();
    }
    
    @isTest static void testPANGSTValidation3(){
        
        Test.setMock(HttpCalloutMock.class, new Grz_PANGSTValidationCallout(true));
        
        PAN_GST_API_Creds__c objPan = new PAN_GST_API_Creds__c();
        objPan.Name = 'PAN GST Auth Creds';
        objPan.Username__c = 'upl-ltd_prepaid_prod';
        objPan.Password__c = 'y467vTIWwsd5k1s19T';
        insert objPan;
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer On-Boarding').getRecordTypeId();
        
        List<Account> lstAcc = new List<Account>();
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Testabc';
        objAcc.PAN_Number__c = '3456789';
        objAcc.Mobile__c = '9192929299';
        objAcc.State_Union_Territory__c = 'Meghalaya';
        objAcc.First_Name__c = 'Test';
        objAcc.Middle_Name__c = 'Abc';
        objAcc.Last_Name__c = 'Account';
        objAcc.PAN_API_Response__c = 'This is for testing';
        objAcc.PAN_Validated__c = false;
        objAcc.Type_of_PAN_Holder__c = 'testing';
        objAcc.PAN_Status__c = 'XYZ';
        lstAcc.add(objAcc);
        
        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = stExam;
        objAcc1.Name = 'Testabcs';
        objAcc1.PAN_Validated__c = true;
        objAcc1.PAN_Number__c = '765434567';
        objAcc1.Mobile__c = '9192929299';
        objAcc1.State_Union_Territory__c = 'Meghalaya';
        objAcc1.Tax_Number_3__c = '343443';
        objAcc1.GST_API_Response__c = 'this is for testing';
        objAcc1.GST_Status__c = 'testt';
        objAcc1.Constitution_of_Business__c = 'ttt';
        objAcc1.GST_Validated__c = false;
        objAcc1.Billing_Street_2__c = 'NewYork';
        objAcc1.BillingState = 'Abc Street';
        objAcc1.BillingCity = 'Jaipur';
        objAcc1.BillingPostalCode = '302030';
        objAcc1.BillingCountry = 'India';
        lstAcc.add(objAcc1);
        
        insert lstAcc;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro.Id);
        
        Test.startTest();
        Grz_PANGSTValidation.getPANData(objAcc.Id);
        Grz_PANGSTValidation.getGSTData(objAcc1.Id);
        Grz_PANGSTValidation.getGSTDataAgain(objAcc1.Id,'17AABCA7375C1D3');
        Test.stopTest();
    }
    
    @isTest static void testPANGSTValidation4(){
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer On-Boarding').getRecordTypeId();
        
        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = stExam;
        objAcc1.Name = 'Testabcs';
        objAcc1.PAN_Validated__c = true;
        objAcc1.PAN_Number__c = null;
        objAcc1.Mobile__c = '9192929299';
        objAcc1.State_Union_Territory__c = 'Meghalaya';
        objAcc1.Tax_Number_3__c = '343443';
        objAcc1.GST_API_Response__c = 'this is for testing';
        objAcc1.GST_Status__c = 'testt';
        objAcc1.Constitution_of_Business__c = 'ttt';
        objAcc1.GST_Validated__c = false;
        objAcc1.Billing_Street_2__c = 'NewYork';
        objAcc1.BillingState = 'Abc Street';
        objAcc1.BillingCity = 'Jaipur';
        objAcc1.BillingPostalCode = '302030';
        objAcc1.BillingCountry = 'India';
        
        insert objAcc1;
        
        Test.startTest();
        Grz_PANGSTValidation.getGSTData(objAcc1.Id);
        Test.stopTest();
    }
    
    @isTest static void testPANGSTValidation5(){
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer On-Boarding').getRecordTypeId();
        
        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = stExam;
        objAcc1.Name = 'Testabcs';
        objAcc1.PAN_Validated__c = false;
        objAcc1.PAN_Number__c = '3456789';
        objAcc1.State_Union_Territory__c = 'Meghalaya';
        objAcc1.Tax_Number_3__c = '343443';
        objAcc1.Mobile__c = '9192929299';
        objAcc1.GST_API_Response__c = 'this is for testing';
        objAcc1.GST_Status__c = 'testt';
        objAcc1.Constitution_of_Business__c = 'ttt';
        objAcc1.GST_Validated__c = false;
        objAcc1.Billing_Street_2__c = 'NewYork';
        objAcc1.BillingState = 'Abc Street';
        objAcc1.BillingCity = 'Jaipur';
        objAcc1.BillingPostalCode = '302030';
        objAcc1.BillingCountry = 'India';
        
        insert objAcc1;
        
        Test.startTest();
        Grz_PANGSTValidation.getGSTData(objAcc1.Id);
        Test.stopTest();
    }
    
    @isTest static void testPANGSTValidation6(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        
        PAN_GST_API_Creds__c objPan = new PAN_GST_API_Creds__c();
        objPan.Name = 'PAN GST Auth Creds';
        objPan.Username__c = 'upl-ltd_prepaid_prod';
        objPan.Password__c = 'y467vTIWwsd5k1s19T';
        insert objPan;
                
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer On-Boarding').getRecordTypeId();
        
        List<Account> lstAcc = new List<Account>();
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Testabc';
        objAcc.PAN_Number__c = '3223343';
        objAcc.Mobile__c = '9192929299';
        objAcc.State_Union_Territory__c = 'Meghalaya';
        objAcc.First_Name__c = 'Test';
        objAcc.Middle_Name__c = 'Abc';
        objAcc.Last_Name__c = 'Account';
        objAcc.PAN_API_Response__c = 'This is for testing';
        objAcc.PAN_Validated__c = false;
        objAcc.Type_of_PAN_Holder__c = 'testing';
        objAcc.PAN_Status__c = 'XYZ';
        lstAcc.add(objAcc);
        
        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = stExam;
        objAcc1.Name = 'Testabcs';
        objAcc1.PAN_Validated__c = true;
        objAcc1.PAN_Number__c = '3220343';
        objAcc1.Mobile__c = '9192929299';
        objAcc1.State_Union_Territory__c = 'Meghalaya';
        objAcc1.Tax_Number_3__c = '343443';
        objAcc1.GST_API_Response__c = 'this is for testing';
        objAcc1.GST_Status__c = 'testt';
        objAcc1.Constitution_of_Business__c = 'ttt';
        objAcc1.GST_Validated__c = true;
        objAcc1.Billing_Street_2__c = 'NewYork';
        objAcc1.BillingState = 'Abc Street';
        objAcc1.BillingCity = 'Jaipur';
        objAcc1.BillingPostalCode = '302030';
        objAcc1.BillingCountry = 'India';
        lstAcc.add(objAcc1);
          
        insert lstAcc;
        
        
        Test.startTest();
        Grz_PANGSTValidation.getPANData(objAcc.Id);
        Test.stopTest();
    }

    
}