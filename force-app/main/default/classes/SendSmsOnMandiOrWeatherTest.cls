@isTest
public class SendSmsOnMandiOrWeatherTest {

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
        
        List<SMS_Template__c> smsTempLst=new List<SMS_Template__c>();
        SMS_Template__c smsTemp1=new SMS_Template__c();
        smsTemp1.Name__c='WeatherTemplate';
        smsTemp1.ObjectName__c='NurtureAccount';
        smsTemp1.Language__c='English';
        smsTemp1.Template_Text__c='Test';
        SMS_Template__c smsTemp2=new SMS_Template__c();
        smsTemp2.Name__c='WeatherTemplate';
        smsTemp2.ObjectName__c='NurtureAccount';
        smsTemp2.Language__c='Hindi';
        smsTemp2.Template_Text__c='Test';
        SMS_Template__c smsTemp3=new SMS_Template__c();
        smsTemp3.Name__c='MandiTemplate';
        smsTemp3.ObjectName__c='NurtureAccount';
        smsTemp3.Language__c='English';
        smsTemp3.Template_Text__c='Test';
        SMS_Template__c smsTemp4=new SMS_Template__c();
        smsTemp4.Name__c='MandiTemplate';
        smsTemp4.ObjectName__c='NurtureAccount';
        smsTemp4.Language__c='Hindi';
        smsTemp4.Template_Text__c='Test';
        smsTempLst.add(smsTemp1);
        smsTempLst.add(smsTemp2);
        smsTempLst.add(smsTemp3);
        smsTempLst.add(smsTemp4);
        insert smsTempLst;
        
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
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        Test.startTest();
        SendSmsOnMandiOrWeather.postRequestValue();
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
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        Test.startTest();
        SendSmsOnMandiOrWeather.postRequestValue();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod3()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        Test.startTest();
        String msg='Test';
        SendSmsOnMandiOrWeather.sendSMS(msg,'8281597708','Nurture');
        Test.stopTest();
    }
}