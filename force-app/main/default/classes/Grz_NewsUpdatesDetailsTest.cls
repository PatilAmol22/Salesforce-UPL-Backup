@isTest(SeeAllData=false)
public class Grz_NewsUpdatesDetailsTest {
    Public  static testmethod void testNews(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Test.stopTest();  
        Grz_NewsUpdatesDetails.getEventsDetails('en-US');
        Grz_NewsUpdatesDetails.newsUpdatesWrapper nwz = new Grz_NewsUpdatesDetails.newsUpdatesWrapper();
        nwz.id = 'test';
        nwz.title = 'test';
        nwz.news_date = 'test';
        nwz.description = 'test';
        nwz.link = 'test';
    }
    Public  static testmethod void testNews1(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Test.stopTest();  
        Grz_NewsUpdatesDetails.getEventsDetails('en-US');
        Grz_NewsUpdatesDetails.newsUpdatesWrapper nwz = new Grz_NewsUpdatesDetails.newsUpdatesWrapper();
        nwz.id = 'test';
        nwz.title = 'test';
        nwz.news_date = 'test';
        nwz.description = 'test';
        nwz.link = 'test';
    }
}