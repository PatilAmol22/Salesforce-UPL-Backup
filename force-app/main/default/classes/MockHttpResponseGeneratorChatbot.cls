@isTest
global class MockHttpResponseGeneratorChatbot implements HttpCalloutMock {
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/JSON');
        res.setBody('{"totalSize":2,"done":true,"records":[{"attributes":{"type":"Sales_Order__c","url":"/services/data/v48.0/sobjects/Sales_Order__c/a1E0k000000zx6mEAA"},"Id":"a1E0k000000zx6mEAA","Name":"03022020167944","Sold_to_Party__r":{"attributes":{"type":"Account","url":"/services/data/v48.0/sobjects/Account/0010k000002TXLNAA4"},"SAP_Code__c":"0001043088"},"Order_Date__c":"2020-02-03","SAP_Order_Number__c":"7069149275","Order_Status__c":"Partially processed","Final_Total_Amont__c":"1234.00","User__c":"123456789","Sales_District_Code__c":"123456"},{"attributes":{"type":"Sales_Order__c","url":"/services/data/v48.0/sobjects/Sales_Order__c/a1E0k000000zx8UEAQ"},"Id":"a1E0k000000zx8UEAQ","Name":"03022020167945","Sold_to_Party__r":{"attributes":{"type":"Account","url":"/services/data/v48.0/sobjects/Account/0010k000002TXLNAA4"},"SAP_Code__c":"0001043088"},"Order_Date__c":"2020-02-03","SAP_Order_Number__c":"7069149276","Order_Status__c":"Partially processed","Final_Total_Amont__c":"1234.00","User__c":"123456789","Sales_District_Code__c":"123456"}]}');
        res.setStatusCode(200);
        return res;
    }

}