@isTest
global class MandiHttpCalloutMockNew2 implements HttpCalloutMock{ 
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String jStr = '[{"id": 18902,"state": "Andhra Pradesh","stateId": 2473,"district": "Andhra Pradesh","districtId": 2473,"product": "Bengal Gram(Gram)(Whole)","cropId": 37,"variety": "Other","market": "Udgir","minPrice": 4800,"maxPrice": 4960,"modalPrice": 4880}]';
        response.setBody(jStr);
        response.setStatusCode(200);
        return response; 
    }
}