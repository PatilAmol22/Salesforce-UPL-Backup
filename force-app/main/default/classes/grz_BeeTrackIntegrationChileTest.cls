@isTest
public class grz_BeeTrackIntegrationChileTest {
    
    public static testMethod void testHttpPostUpdate() {
        Sales_order_delivery__c so = new Sales_Order_Delivery__c();
        so.identifier__c = '106934';
        insert so;
        String myJSON = '{"resource":"dispatch","event":"update","account_name":"Arysta","account_id":2588,"guide":"106934","identifier":"106934","route_id":18238917,"dispatch_id":331053955,"truck_identifier":"SAYMO04","status":2,"substatus":"Entrega Exitosa","substatus_code":"test","estimated_at":"2021-11-25T14:13:23.000-03:00","max_delivery_time":null,"min_delivery_time":null,"contact_identifier":"2.004.276-2","contact_phone":null, "contact_name":"TATTERSALL AGROINSUMOS S A","contact_email":"cdhenriquez@tattersall.cl","contact_address":"DIEGO DE ALMAGRO 1687,SAN FELIPE","tags":[{"name":"Chofer","value":"ALEXANDER LAZCANO"},{"name":"Patente","value":"JDZL-66"}],"is_pickup":false,"is_trunk":false,"locked":false,"items":[{"item_id":505520667,"name":"SPRINGER (SPIRO 24 SL) 10x1LT_CL","description":"SPRINGER (SPIRO 24 SL) 10x1LT_CL","quantity":504,"original_quantity":504,"delivered_quantity":504,"code":"5685113","extras":[]} ],"groups":[],"arrived_at":"2021-11-25 14:26:58-0300","waypoint":{"latitude":"-32.989872","longitude":"-71.266585"},"evaluation_answers":[{"_id":{"$oid":"619fc7666966300001629396"},"cast":"photo","code":"6d9b3d30-ea0f-0138-6dbf-02611c27def4","name":"Foto de la guía firmada","image_url":"https://cdn.beetrack.com/mobile_evaluations/images/IMG_20211125_142638_8712103365923475979.jpg","web":false}]}';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        grz_BeeTrackIntegrationChile.HandleResponse();
    }
    public static testMethod void testHttpPostCreate() {
        String myJSON = '{"resource":"dispatch_guide","event":"create","account_name":"Arysta","dispatch_guide":{"guide":"107948","beecode":"149142c46e7ccfb8171dea10","identifier":"107948","account_id":2588,"promised_date":null,"contact_name":"ARYSTA LIFESCIENCE CHILE SA","contact_phone":null,"contact_identifier":null,"contact_email":null,"contact_address":"REQUINOA"},"tags":[{"name":"Chofer","value":"RAFAEL SANTELICES"},{"name":"Patente","value":"PRCY-18"}],"items":[{"id":534658622,"name":"AZOTE","description":"AZOTE","quantity":20,"original_quantity":20,"delivered_quantity":0,"code":null,"extras":[]}],"groups":[]}';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        grz_BeeTrackIntegrationChile.HandleResponse();
    }
    public static testMethod void testException() {
		String myJSON = 'exception';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        grz_BeeTrackIntegrationChile.HandleResponse();
    }
    
}