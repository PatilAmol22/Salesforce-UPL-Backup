@isTest
global class MockHttpResponseGenesysCallid implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"CallID":"","Mobile":"1002","Disposition":""}');
        res.setStatusCode(200);
        return res;
    }
}