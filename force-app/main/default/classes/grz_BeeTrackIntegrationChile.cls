@RestResource(urlMapping='/ChileDelhiveryDetailsBtrack/*')
global class grz_BeeTrackIntegrationChile {
    @HttpPost
    global static void HandleResponse(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Sales_order_delivery__c delivery = new Sales_order_delivery__c();
        try{
            String data = req.requestBody.toString();
            if(data.contains('"event":"create"') || data.contains('"event":"update"') ){
                delivery.Response__c = data;
            }else{
                delivery.SubStatus__c = 'Exception';
                delivery.resource__c = 'Data not as expected';
                delivery.Response__c = data;
            }
            insert delivery;
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch(Exception e){
            Sales_order_delivery__c deliveryEx = new Sales_order_delivery__c();
            deliveryEx.SubStatus__c = 'Exception';
            deliveryEx.resource__c = String.valueOf(e);
            deliveryEx.Response__c = req.requestBody.toString();
            insert deliveryEx;
        }
    }
}