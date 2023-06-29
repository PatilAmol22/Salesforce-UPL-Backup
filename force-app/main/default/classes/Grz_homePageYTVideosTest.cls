@isTest(SeeAllData=false)
public class Grz_homePageYTVideosTest {
    Public  static testmethod void testYTVideos(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Test.stopTest();
        Grz_homePageYTVideos.getYTVideoData('en-US');
        Grz_homePageYTVideos.youtTubeVideoWrapper ev = new Grz_homePageYTVideos.youtTubeVideoWrapper();
        ev.id = 'test';
        ev.title = 'test';
        ev.embedded_url = 'test';
    }
    Public  static testmethod void testYTVideos1(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Test.stopTest();
        Grz_homePageYTVideos.getYTVideoData('en-US');
        Grz_homePageYTVideos.youtTubeVideoWrapper ev = new Grz_homePageYTVideos.youtTubeVideoWrapper();
        ev.id = 'test';
        ev.title = 'test';
        ev.embedded_url = 'test';
    }
     Public  static testmethod void testYTVideos2(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Test.stopTest();
        Grz_homePageYTVideos.getYTVideoData('es');
        Grz_homePageYTVideos.youtTubeVideoWrapper ev = new Grz_homePageYTVideos.youtTubeVideoWrapper();
        ev.id = 'test';
        ev.title = 'test';
        ev.embedded_url = 'test';
    }
}