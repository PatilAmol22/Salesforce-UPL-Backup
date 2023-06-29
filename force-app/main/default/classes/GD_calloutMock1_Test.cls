@isTest
global class GD_calloutMock1_Test  implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "Cheque":"Record"},{ "Annexure":"Test"}');
        response.setStatusCode(201);
        return response; 
        
    }
    
}