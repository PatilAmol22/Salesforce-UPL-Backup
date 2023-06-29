@isTest
public class Grz_UserInfoControllerTest {
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"ip": "217.61.20.213","hostname": "host213-20-61-217.static.arubacloud.com","city": "London","region": "England","country": "GB","loc": "51.5085,-0.1257","org": "AS199883 ArubaCloud Limited","postal": "EC1A","timezone": "Europe/London","readme": "https://ipinfo.io/missingauth"}';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }

    }
    static void init(String str){
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Grz_UserInfoController obj = new Grz_UserInfoController();
        Grz_UserInfoController.accountName = str;
        Test.startTest();
        obj.onValueUpdate();
		obj.getIPGeolocation();
        Test.StopTest();
    }
    
    Public  static testmethod void testUserInfoController1(){
        init('India');
    }
    Public  static testmethod void testUserInfoController2(){
        init('Brazil');
    }
    Public  static testmethod void testUserInfoController3(){
        init('Columbia');
    }
    Public  static testmethod void testUserInfoController4(){
        init('Spain');
    }
    Public  static testmethod void testUserInfoController5(){
        init('Poland');
    }
    Public  static testmethod void testUserInfoController6(){
        init('Portugal');
    }
    Public  static testmethod void testUserInfoController7(){
        init('Mexico');
    }
    Public  static testmethod void testUserInfoController8(){
        init('Chile');
    }
    Public  static testmethod void testUserInfoController9(){
        init('Turkey');
    }
    Public  static testmethod void testUserInfoController10(){
        init('Japan');
    }
/**************************************************************************************************
* @Description       : test method created for covering the snippet introduced to redirect to Argentina login page                                                      
* Date               : 11-08-2022
* Project/JIRA       : APPS-1757                                                                        
* Author             : Gurubaksh Grewal
* @Return            : Void
* Last Modified By 	 : Gurubaksh Grewal (Grazitti) 18-08-2022                                                                        
**************************************************************************************************/
    
    Public  static testmethod void testUserInfoController11(){
        init('Argentina');
    }
}