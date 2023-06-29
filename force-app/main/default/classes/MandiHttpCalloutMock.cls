@isTest
global class MandiHttpCalloutMock implements HttpCalloutMock{ 
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String jStr = '{"records":[{"Id": "111", "commodity": "Ginger","district": "Kangra","market": "Palampur","modal_price": "6250", "state": "Himachal Pradesh","variety": "Other"}]}';
        response.setBody(jStr);
        response.setStatusCode(200);
        return response; 
    }
}