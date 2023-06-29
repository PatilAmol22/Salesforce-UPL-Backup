@isTest
global class MandiHttpCalloutMockNew1 implements HttpCalloutMock{ 
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String jStr = '[{"id": 2792221,"name": "Andaman and Nicobar"},{"id": 2473,"name": "Andhra Pradesh"}]';
        response.setBody(jStr);
        response.setStatusCode(200);
        return response; 
    }
}