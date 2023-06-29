@isTest
public without sharing class UpdateCaseRecordFromCtiTest {

    @testSetup
    public static void setupData()
    {
        Id farmerRecordType  =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        State__c st = new State__c(Name = 'Assam');
        insert st;
        
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        Account acc = new Account(LastName = 'TestAcc', VillageName__c = 'DidarKush',
                                  District__c = 'Cacher', StateName__c ='Assam',Preferred_Language__pc='English',Using_Smart_Phone__c='Yes',
                                  Using_Watsapp__c='Yes',Village__pc=vill.id,PersonMobilePhone = '9998887776' ,recordTypeId = farmerRecordType);
        insert acc;
        Id nurtureRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        case caseNew=new Case();
        caseNew.Call_Id__c='1234567890';
        caseNew.AccountId=acc.id;
        caseNew.Origin__c='Phone';
        caseNew.RecordTypeId=nurtureRecordType;
        insert caseNew;
        
        Genesys_Details__c genesysRecord = new Genesys_Details__c();
        genesysRecord.Call_Id__c = '1234567890';
        insert genesysRecord;
        
    }
    
    @isTest
    public static void testMethod1()
    {
        String phone='9998887776';
        String JsonMsg='{"Call Id": "1234567890","Phone": 1234567890,"Duration": 200,"Agent Id": "111111","Transfer status": "test status","Call direction": "IB","Recording": "https://www.google.com"}';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/services/apexrest/updatecasedetails/';
        request.requestBody = Blob.valueof(JsonMsg);
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        UpdateCaseRecordFromCti.postRequestValue();
        Test.stopTest();
    }
    
}