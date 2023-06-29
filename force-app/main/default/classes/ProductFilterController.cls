public with sharing class ProductFilterController {
    /* public static String spainBaseUrl = 'https://es-test.upl-ltd.com/api/products-categories-targets';
    public static String portugalBaseUrl = 'https://pt-test.upl-ltd.com/api/products-categories-targets';
    public static String polandBaseUrl = 'https://us-test.upl-ltd.com/api/products-categories-targets';
    public static String columbiaBaseUrl = 'https://co.uplonline.com/api/products-categories-targets'; */
    /* public ProductCatalogController() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(baseUrl+'/selection');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        List<ProductWrapper> conList = new List<ProductWrapper>();

        JSONParser parser = JSON.createParser(res.getBody());

        while(parser.nextToken() != JSONToken.END_ARRAY) {   // we started with an array of objects
            ProductWrapper con = new ProductWrapper();   
                while(parser.nextToken() != JSONToken.END_OBJECT){   // loop through each object
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME) { //token should be field name
                        String attr = parser.getText(); //get the text of the field name
                        parser.nextToken(); // move the pointer
                        //start mapping the fields

                        if(attr == 'id') { 
                            con.id = parser.getText();
                        } else if(attr == 'name') {
                            con.name = parser.getText();
                        } else if(attr == 'status') {
                            con.status = parser.getText();
                        }
                    }
                }
                conList.add(con);
        }        

        System.debug('Respone- ' + conList);
    } */

    @AuraEnabled   
    public static List<ProductWrapper> getFirstDropDown(){
        List<ProductWrapper> productList = new List<ProductWrapper>();
        try{
            String baseUrl = '';
            User currentUser = new User();
            currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];

            if(currentUser != null){
                Product_URL__c prdURL = [SELECT Id, Name, URL__c FROM Product_URL__c where Name =:currentUser.Country limit 1];

                if(prdURL != null){
                    baseUrl = prdURL.URL__c;
                }
            }

            HttpRequest req = new HttpRequest();
            req.setEndpoint(baseUrl+'/selection');
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('res.getBody()- ' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while(parser.nextToken() != JSONToken.END_ARRAY) {   // we started with an array of objects
                ProductWrapper prod = new ProductWrapper();   
                    while(parser.nextToken() != JSONToken.END_OBJECT){   // loop through each object
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME) { //token should be field name
                            String attr = parser.getText(); //get the text of the field name
                            parser.nextToken(); // move the pointer
                            //start mapping the fields
    
                            if(attr == 'id') { 
                                prod.id = parser.getText();
                            } 
                            else if(attr == 'name') {
                                prod.name = parser.getText();
                            } 
                            else if(attr == 'status') {
                                prod.status = parser.getText();
                            }
                            prod.displayName ='';
                            prod.lightColor ='';
                            prod.darkColor ='';

                        }
                    }
                    productList.add(prod);
            }     
        }
        catch(Exception ex){
            System.debug('Exception in getFirstDropDown method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
            return productList;
        }
        System.debug('Respone- ' + productList);
        return productList;
    }

    @AuraEnabled   
    public static List<ProductWrapper> getSecondDropDown(String cat_val){
        List<ProductWrapper> productList = new List<ProductWrapper>();
        try{
            String baseUrl = '';
            User currentUser = new User();
            currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];

            if(currentUser != null){
                Product_URL__c prdURL = [SELECT Id, Name, URL__c FROM Product_URL__c where Name =:currentUser.Country limit 1];

                if(prdURL != null){
                    baseUrl = prdURL.URL__c;
                }
            }

            HttpRequest req = new HttpRequest();
            req.setEndpoint(baseUrl+'/get-level-two?category='+cat_val);
            req.setTimeout(120000);
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('res.getBody()- ' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while(parser.nextToken() != JSONToken.END_ARRAY) {   // we started with an array of objects
                ProductWrapper prod = new ProductWrapper();   
                    while(parser.nextToken() != JSONToken.END_OBJECT){   // loop through each object
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME) { //token should be field name
                            String attr = parser.getText(); //get the text of the field name
                            parser.nextToken(); // move the pointer
                            //start mapping the fields
    
                            if(attr == 'id') { 
                                prod.id = parser.getText();
                            } 
                            else if(attr == 'name') {
                                prod.name = parser.getText();
                            } 
                            else if(attr == 'status') {
                                prod.status = parser.getText();
                            }
                            else if(attr == 'display_name') {
                                prod.displayName = parser.getText();
                            }
                            else if(attr == 'light_color') {
                                prod.lightColor = parser.getText();
                            }
                            else if(attr == 'dark_color') {
                                prod.darkColor = parser.getText();
                            }
                            
                        }
                    }
                    productList.add(prod);
            }     
        }
        catch(Exception ex){
            System.debug('Exception in getSecondDropDown method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
            return productList;
        }
        System.debug('Respone- ' + productList);
        return productList;
    }
    
    @AuraEnabled   
    public static List<ProductWrapper> getThirdDropDown(String cat_val, String sub_cat_val){
        List<ProductWrapper> productList = new List<ProductWrapper>();
        try{
            String baseUrl = '';
            User currentUser = new User();
            currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];

            if(currentUser != null){
                Product_URL__c prdURL = [SELECT Id, Name, URL__c FROM Product_URL__c where Name =:currentUser.Country limit 1];

                if(prdURL != null){
                    baseUrl = prdURL.URL__c;
                }
            }

            HttpRequest req = new HttpRequest();
            req.setEndpoint(baseUrl+'/get-level-three?category='+cat_val+'&subCategory='+sub_cat_val);
            req.setTimeout(120000);
            req.setMethod('GET');
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('res.getBody()- ' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            while(parser.nextToken() != JSONToken.END_ARRAY) {   // we started with an array of objects
                ProductWrapper prod = new ProductWrapper();   
                    while(parser.nextToken() != JSONToken.END_OBJECT){   // loop through each object
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME) { //token should be field name
                            String attr = parser.getText(); //get the text of the field name
                            parser.nextToken(); // move the pointer
                            //start mapping the fields
    
                            if(attr == 'id') { 
                                prod.id = parser.getText();
                            } 
                            else if(attr == 'name') {
                                prod.name = parser.getText();
                            } 
                            else if(attr == 'status') {
                                prod.status = parser.getText();
                            }
                            else if(attr == 'display_name') {
                                prod.displayName = parser.getText();
                            }
                            else if(attr == 'light_color') {
                                prod.lightColor = parser.getText();
                            }
                            else if(attr == 'dark_color') {
                                prod.darkColor = parser.getText();
                            }
                            
                        }
                    }
                    productList.add(prod);
            }     
        }
        catch(Exception ex){
            System.debug('Exception in getThirdDropDown method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
            return productList;
        }
        System.debug('Respone- ' + productList);
        return productList;
    }

    public class ProductWrapper
    {
        @AuraEnabled public string id ;
        @AuraEnabled public string name ;
        @AuraEnabled public string status ;
        @AuraEnabled public string displayName ;
        @AuraEnabled public string lightColor ;
        @AuraEnabled public string darkColor ;

        public ProductWrapper(){
            id = '';
            name ='';
            status = '';
            displayName = '';
            lightColor = '';
            darkColor = '';
        }
    }
}