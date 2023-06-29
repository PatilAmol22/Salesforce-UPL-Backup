@isTest
public without sharing class GetWeatherOrMandiInfoTest {
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
    }
    
    @isTest
    public static void testMethod1()
    {
        String phone='9998887776';
        String JsonMsg='{"Phone":"'+phone+'","Type":"Mandi","Commodity":"Cotton"}';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/services/apexrest/weatherormandidetails/';
        request.requestBody = Blob.valueof(JsonMsg);
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        Test.setMock(HttpCalloutMock.class, new MandiHttpCalloutMock()); 
        Test.startTest();
        GetWeatherOrMandiInfo.postRequestValue();
        Test.stopTest();
        
    }
    
    @isTest
    public static void testMethod2()
    {
        String phone='9998887776';
        String JsonMsg='{"Phone":"'+phone+'","Type":"Weather","Commodity":""}';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/services/apexrest/weatherormandidetails/';
        request.requestBody = Blob.valueof(JsonMsg);
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock());
        Test.startTest();
        GetWeatherOrMandiInfo.postRequestValue();
        Test.stopTest();
    }
    
}