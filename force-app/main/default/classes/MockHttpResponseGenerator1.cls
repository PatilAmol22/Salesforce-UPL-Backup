@isTest
global class MockHttpResponseGenerator1 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/JSON');
        res.setBody('Request accepted for Request ID=2035237413513039100 & Statuscode=200 & Info=Platform Accepted & Time=2020-04-16 14:13:51');
        res.setStatusCode(200);
        return res;
    }
}