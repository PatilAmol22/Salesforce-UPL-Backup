@isTest
global class ProductCatalogMock1 implements HttpCalloutMock {
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        HTTPResponse response = new HTTPResponse();
        // Setting the response body
        response.setBody('{"data":[{"id":1,"name":"herbicide","display_name":"Herbicidas","product_type_image":"https://co.uplonline.com/product_type/logos/herbicide_icon.png","leaf_image":null,"light_color":"#d2f2d9","dark_color":"#28a44a","number_of_products":1,"status":1,"products":[{"id":11,"name":"FASCINATE/u00ae 280 SL","meta_title":null,"meta_description":"Banano,Bledo"}]}],"code":200,"message":"Categories fetched successfully."}');
        //response.setBody('{"data":{"productDetailsResponse":{"id":111,"name":"SAFARI","meta_title":null,"meta_description":"Banano,Cafu00e9,Mau00edz,Naranja,Palma Africana,Potreros,,Glufosinato de Amonio","product_meta_description":null,"product_name_image":null,"banner_name":null,"thumbnail_name":null,"large_name":null,"thumbnail_image":null,"banner_image":"landing.jpg","large_image":null,"product_logo_image":"kwmrQrsSkgN2YA3mJoGiB7VuUx8Mib0ANaUq866T.png","header_image":null,"video_link":null,"is_arysta":1,"is_special":0,"amount":null,"mapp_number":null,"status":1,"formulation":"Concentrado Soluble - SL","registration_info":null,"product_url":"safari","type":"Herbicidas","fact":null,"view_link":"safari","code":200,"message":"data fetched successfully."}');
        // Setting the response header
        response.setHeader('Content-Type', 'application/json');
        // Setting the response code
        response.setStatusCode(200);
        // Returning the response
        return response;
    }
}