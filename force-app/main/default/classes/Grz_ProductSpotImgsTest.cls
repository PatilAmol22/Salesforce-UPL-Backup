@isTest(SeeAllData=false)
public class Grz_ProductSpotImgsTest {
    Public  static testmethod void testProductSpotImgs(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Test.stopTest();
        Grz_ProductSpotImgs.getProdSpotData('en-US');
        Grz_ProductSpotImgs.prodSpotWrapper ev = new Grz_ProductSpotImgs.prodSpotWrapper();
        ev.id = 'test';
        ev.image = 'test';
        Grz_ProductSpotImgs.prodSpotInnerWrapper pro = new Grz_ProductSpotImgs.prodSpotInnerWrapper();
        pro.name = 'test';
        pro.fact = 'test';
        pro.view_link = 'test';
        pro.product_type_logo = 'test';
    }
    Public  static testmethod void testProductSpotImgs1(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Test.stopTest();
        Grz_ProductSpotImgs.getProdSpotData('en-US');
        Grz_ProductSpotImgs.prodSpotWrapper ev = new Grz_ProductSpotImgs.prodSpotWrapper();
        ev.id = 'test';
        ev.image = 'test';
        Grz_ProductSpotImgs.prodSpotInnerWrapper pro = new Grz_ProductSpotImgs.prodSpotInnerWrapper();
        pro.name = 'test';
        pro.fact = 'test';
        pro.view_link = 'test';
        pro.product_type_logo = 'test';
    }
    
      Public  static testmethod void testProductSpotImgs2(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Test.stopTest();
        Grz_ProductSpotImgs.getProdSpotData('es');
        Grz_ProductSpotImgs.prodSpotWrapper ev = new Grz_ProductSpotImgs.prodSpotWrapper();
        ev.id = 'test';
        ev.image = 'test';
        Grz_ProductSpotImgs.prodSpotInnerWrapper pro = new Grz_ProductSpotImgs.prodSpotInnerWrapper();
        pro.name = 'test';
        pro.fact = 'test';
        pro.view_link = 'test';
        pro.product_type_logo = 'test';
    }
}