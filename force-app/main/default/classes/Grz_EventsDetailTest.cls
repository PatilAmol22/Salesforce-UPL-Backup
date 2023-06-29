@isTest(SeeAllData=false)
public class Grz_EventsDetailTest {
    Public  static testmethod void testEventDetails(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Test.stopTest();
        Grz_EventsDetail.getEventsDetails('en-US');
        Grz_EventsDetail.eventsDetWrapper ev = new Grz_EventsDetail.eventsDetWrapper();
        ev.id = 'test';
        ev.title = 'test';
        ev.description = 'test';
        ev.from_date = 'test';
        ev.event_address = 'test';
        ev.event_image = 'test';
    }
    Public  static testmethod void testEventDetails1(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Test.stopTest();
        Grz_EventsDetail.getEventsDetails('en-US');
        Grz_EventsDetail.eventsDetWrapper ev = new Grz_EventsDetail.eventsDetWrapper();
        ev.id = 'test';
        ev.title = 'test';
        ev.description = 'test';
        ev.from_date = 'test';
        ev.event_address = 'test';
        ev.event_image = 'test';
    }
}