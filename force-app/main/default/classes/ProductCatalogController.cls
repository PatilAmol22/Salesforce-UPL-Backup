public with sharing class ProductCatalogController {
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

            /* if(currentUser.Country.equalsignorecase('Colombia')){
                baseUrl = columbiaBaseUrl;
            }
            else if(currentUser.Country.equalsignorecase('Spain')){
                baseUrl = spainBaseUrl;
            }
            else if(currentUser.Country.equalsignorecase('Portugal')){
                baseUrl = portugalBaseUrl;
            }
            else if(currentUser.Country.equalsignorecase('Poland')){
                baseUrl = portugalBaseUrl;
            } */
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(baseUrl+'/selection');
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
          //  System.debug('res.getBody()- ' + res.getBody());
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
      //  System.debug('Respone- ' + productList);
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
           // System.debug('res.getBody()- ' + res.getBody());
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
      //  System.debug('Respone- ' + productList);
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
           // System.debug('res.getBody()- ' + res.getBody());
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
       // System.debug('Respone- ' + productList);
        return productList;
    }

    @AuraEnabled   
    public static List<ProductWrapper> getProducts(String cat_val, String sub_cat_val, String last_cat_val){
        List<ProductWrapper> productList = new List<ProductWrapper>();
        try{
           // System.debug(' cat_val- ' + cat_val);
           // System.debug(' sub_cat_val- ' + sub_cat_val);
           // System.debug(' last_cat_val- ' + last_cat_val);

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
            req.setEndpoint(baseUrl+'/get-products?category='+cat_val+'&subCategory='+sub_cat_val+'&lastCategory='+last_cat_val);
            req.setTimeout(120000);
            req.setMethod('GET');
            
            Http http = new Http();
            HTTPResponse res = http.send(req);

            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(res.getBody()); //re is response body string
           // System.debug('m-----: ' + response);
            List<Object> listObject = (List<Object>)response.get('data');
            
            for(Object result : listObject) {
                ProductWrapper prod = new ProductWrapper(); 
               // System.debug('result-----: ' + result);
                Map<String,Object> mpParsed = (Map<String,Object>)result;
                prod.id = String.valueOf((Integer) mpParsed.get('id')); 
                prod.name = (String) mpParsed.get('name'); 
                prod.displayName = (String) mpParsed.get('display_name');
                prod.productTypeImage = (String) mpParsed.get('product_type_image');
                prod.lightColor = (String) mpParsed.get('light_color');
                prod.darkColor = (String) mpParsed.get('dark_color');
                prod.numberOfProducts = String.valueOf((Integer) mpParsed.get('number_of_products'));

                List<Object> proObject = (List<Object>)mpParsed.get('products');
                if(proObject.size()>0){
                    List<ProductListWrapper> prodList = new List<ProductListWrapper>();
                    for(Object obj : proObject){
                        ProductListWrapper prodListObj = new ProductListWrapper();  
                        Map<String,Object> objParsed = (Map<String,Object>)obj;
                        prodListObj.id = String.valueOf((Integer) objParsed.get('id')); 
                        prodListObj.name = (String) objParsed.get('name');
                        prodListObj.leafImage = (String) objParsed.get('leaf_image');
                        prodListObj.viewLink = (String) objParsed.get('view_link');
                        prodListObj.ingredients = (String) objParsed.get('cdms_active_ingredient');
                        prodListObj.prod_url = (String) objParsed.get('product_url'); 

                        prodList.add(prodListObj);
                       // System.debug('prodListObj - ' + prodListObj);
                    }
                    prod.productList.addall(prodList);
                }
                //System.debug('display name-----: ' + mpParsed.get('display_name'));
                productList.add(prod);
               // System.debug('mpParsed-----: ' + proObject);
               // System.debug('list size-----: ' + proObject.size());
            }
            
            /* JSONParser parser = JSON.createParser(res.getBody());
            
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
                            else if(attr == 'display_name') {
                                prod.displayName = parser.getText();
                            }
                            else if(attr == 'product_type_image') {
                                prod.productTypeImage = parser.getText();
                            }
                            else if(attr == 'light_color') {
                                prod.lightColor = parser.getText();
                            }
                            else if(attr == 'dark_color') {
                                prod.darkColor = parser.getText();
                            }
                            else if(attr == 'number_of_products') {
                                prod.numberOfProducts = parser.getText();
                            }
                            else if(attr == 'products') {
                                
                                List<ProductListWrapper> prodList = new List<ProductListWrapper>();
                                while(parser.nextToken() != JSONToken.END_ARRAY) {   // we started with an array of objects
                                    
                                    ProductListWrapper prodListObj = new ProductListWrapper();   
                                        while(parser.nextToken() != JSONToken.END_OBJECT){   // loop through each object
                                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) { //token should be field name
                                                
                                                String pro = parser.getText(); //get the text of the field name
                                                parser.nextToken(); // move the pointer
                                                //start mapping the fields
                                                if(pro == 'id') { 
                                                    prodListObj.id = parser.getText();
                                                } 
                                                else if(pro == 'name') {
                                                    prodListObj.name = parser.getText();
                                                }
                                                else if(pro == 'leaf_image') {
                                                    prodListObj.leafImage = parser.getText();
                                                }
                                                else if(pro == 'view_link') {
                                                    prodListObj.viewLink = parser.getText();
                                                }
                                                else if(pro == 'cdms_active_ingredient') {
                                                    prodListObj.ingredients = parser.getText();
                                                    
                                                }
                                                else{
                                                    parser.nextToken(); // move the pointer
                                                }
                                                
                                            }
                                             
                                        }
                                        prodList.add(prodListObj);
                                        System.debug('prodListObj - ' + prodListObj);
                                }
                                prod.productList.addall(prodList);
                            }
                            
                        }
                    }
                    productList.add(prod);
            } */     
        }
        catch(Exception ex){
            System.debug('Exception in getProducts method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
            return productList;
        }
       // System.debug('Respone getProducts- ' + productList);
        return productList;
    }

    @AuraEnabled   
    public static ProductWrapper getProductDetails(String prodName){
        ProductWrapper productDetails = new ProductWrapper();
        try{
            System.debug('prodName- ' + prodName);

            String baseUrl = '';
            User currentUser = new User();
            currentUser = [SELECT id, Country FROM user WHERE id =: UserInfo.getUserId()];

            if(currentUser != null){
                Product_URL__c prdURL = [SELECT Id, Name, URL__c FROM Product_URL__c WHERE Name =:currentUser.Country limit 1];

                if(prdURL != null){
                    baseUrl = prdURL.URL__c;
                }
            }
           
            HttpRequest req = new HttpRequest();
            req.setEndpoint(baseUrl+'/get-product-details/'+prodName);
            req.setTimeout(120000);
            req.setMethod('GET');
            
            Http http = new Http();
            HTTPResponse res = http.send(req);

            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(res.getBody()); //re is response body string
            System.debug('m-----: ' + response);
            Map<String, Object> objects = (Map<String, Object>)response.get('data');
            //System.debug('dwnObject -----: ' + objects.get('productLabelFileResponse'));
            List<DownloadWrapper> downldList = new List<DownloadWrapper>();
            
            String objTst = '[]';

            Object dwnObject = (Object)objects.get('productLabelFileResponse');
            System.debug('dwnObject -----: ' + dwnObject);
            if(Json.serialize(dwnObject) != objTst){
                Map<String,Object> dwnParsed = (Map<String,Object>)dwnObject;
                System.debug('dwnParsed -----: ' + dwnParsed);
            
                String str = (String) dwnParsed.get('file_link');
                if(str != null){
                    DownloadWrapper dwnWrap = new DownloadWrapper();
                    dwnWrap.file_name = (String) dwnParsed.get('file_name');
                    dwnWrap.file_link = (String) dwnParsed.get('file_link');
                    dwnWrap.pdf_icon = (String) dwnParsed.get('pdf_icon_image');

                    downldList.add(dwnWrap);
                }
                //prod.downList.addall(downldList);
            }

            Object dwnObject2 = (Object)objects.get('productMsdsFileResponse');
            System.debug('dwnObject2 -----: ' + dwnObject2);
            if(Json.serialize(dwnObject2) != objTst){
                Map<String,Object> dwnParsed2 = (Map<String,Object>)dwnObject2;
                System.debug('dwnParsed2 -----: ' + dwnParsed2);
            
                String str2 = (String) dwnParsed2.get('file_link');
                if(str2 != null){
                    DownloadWrapper dwnWrap2 = new DownloadWrapper();
                    dwnWrap2.file_name = (String) dwnParsed2.get('file_name');
                    dwnWrap2.file_link = (String) dwnParsed2.get('file_link');
                    dwnWrap2.pdf_icon = (String) dwnParsed2.get('pdf_icon_image');

                    downldList.add(dwnWrap2);
                }
                //prod.downList.addall(downldList);
            }

            try{

                List<Object> dwnObject3 = (List<Object>)objects.get('productTankMixFileResponse');
                System.debug('dwnObject3 -----: ' + dwnObject3);
                System.debug('dwnObject3 size-----: ' + dwnObject3.size());
                System.debug('Json.serialize(dwnObject3) -----: ' + Json.serialize(dwnObject3));
                if(dwnObject3.size() > 0 && Json.serialize(dwnObject3) != objTst){
                    for(Object obj3 : dwnObject3){

                        Map<String,Object> dwnParsed3 = (Map<String,Object>)obj3;
                        System.debug('dwnParsed3 -----: ' + dwnParsed3);
                    
                        String str3 = (String) dwnParsed3.get('file_link');
                        if(str3 != null){
                            DownloadWrapper dwnWrap3 = new DownloadWrapper();
                            dwnWrap3.file_name = (String) dwnParsed3.get('file_name');
                            dwnWrap3.file_link = (String) dwnParsed3.get('file_link');
                            dwnWrap3.pdf_icon = (String) dwnParsed3.get('pdf_icon_image');

                            downldList.add(dwnWrap3);
                        }
                    }
                    //prod.downList.addall(downldList);
                }

            }
            catch(Exception exp){
                System.debug('Exception in productTankMixFileResponse -----: '+ exp + 'At line no -' +exp.getLineNumber());
                Object dwnObject6 = (Object)objects.get('productTankMixFileResponse');
                System.debug('dwnObject6 -----: ' + dwnObject6);
                
                if(Json.serialize(dwnObject6) != objTst){
                                        
                        Map<String,Object> dwnParsed6 = (Map<String,Object>)dwnObject6;
                        System.debug('dwnParsed6 -----: ' + dwnParsed6);
                    
                        String str6 = (String) dwnParsed6.get('file_link');
                        if(str6 != null){
                            DownloadWrapper dwnWrap6 = new DownloadWrapper();
                            dwnWrap6.file_name = (String) dwnParsed6.get('file_name');
                            dwnWrap6.file_link = (String) dwnParsed6.get('file_link');
                            dwnWrap6.pdf_icon = (String) dwnParsed6.get('pdf_icon_image');

                            downldList.add(dwnWrap6);
                        }
                    //prod.downList.addall(downldList);
                }
            }
            
            try{
            
                List<Object> dwnObject4 = (List<Object>)objects.get('productOtherFilesResponse');
                System.debug('dwnObject4 -----: ' + dwnObject4);
                System.debug('dwnObject4 size-----: ' + dwnObject4.size());
                System.debug('Json.serialize(dwnObject4) -----: ' + Json.serialize(dwnObject4));
                if(dwnObject4.size() > 0 && Json.serialize(dwnObject4) != objTst){
                    for(Object obj4 : dwnObject4){
                    
                        Map<String,Object> dwnParsed4 = (Map<String,Object>)obj4;
                        System.debug('dwnParsed4 -----: ' + dwnParsed4);
                    
                        String str4 = (String) dwnParsed4.get('file_link');
                        if(str4 != null){
                            DownloadWrapper dwnWrap4 = new DownloadWrapper();
                            dwnWrap4.file_name = (String) dwnParsed4.get('file_name');
                            dwnWrap4.file_link = (String) dwnParsed4.get('file_link');
                            dwnWrap4.pdf_icon = (String) dwnParsed4.get('pdf_icon_image');

                            downldList.add(dwnWrap4);
                        }
                    }
                    //prod.downList.addall(downldList);
                }
            }
            catch(Exception exp){
                System.debug('Exception in productOtherFilesResponse -----: '+ exp + 'At line no -' +exp.getLineNumber());
                Object dwnObject7 = (Object)objects.get('productOtherFilesResponse');
                System.debug('dwnObject7 -----: ' + dwnObject7);
                
                if(Json.serialize(dwnObject7) != objTst){
                                        
                        Map<String,Object> dwnParsed7 = (Map<String,Object>)dwnObject7;
                        System.debug('dwnParsed7 -----: ' + dwnParsed7);
                    
                        String str7 = (String) dwnParsed7.get('file_link');
                        if(str7 != null){
                            DownloadWrapper dwnWrap7 = new DownloadWrapper();
                            dwnWrap7.file_name = (String) dwnParsed7.get('file_name');
                            dwnWrap7.file_link = (String) dwnParsed7.get('file_link');
                            dwnWrap7.pdf_icon = (String) dwnParsed7.get('pdf_icon_image');

                            downldList.add(dwnWrap7);
                        }
                    //prod.downList.addall(downldList);
                }
            }

            /* Object dwnObject4 = (Object)objects.get('productOtherFilesResponse');
            System.debug('dwnObject4 -----: ' + dwnObject4);
            
            if(Json.serialize(dwnObject4) != objTst){
                Map<String,Object> dwnParsed4 = (Map<String,Object>)dwnObject4;
                System.debug('dwnParsed4 -----: ' + dwnParsed4);
            
                String str4 = (String) dwnParsed4.get('file_link');
                if(str4 != null){
                    DownloadWrapper dwnWrap4 = new DownloadWrapper();
                    dwnWrap4.file_name = (String) dwnParsed4.get('file_name');
                    dwnWrap4.file_link = (String) dwnParsed4.get('file_link');
                    dwnWrap4.pdf_icon = (String) dwnParsed4.get('pdf_icon_image');

                    downldList.add(dwnWrap4);
                }
                //prod.downList.addall(downldList);
            } */

            try{

                List<Object> dwnObject5 = (List<Object>)objects.get('productEisFileResponse');
                System.debug('dwnObject5 -----: ' + dwnObject5);
                System.debug('dwnObject5 size-----: ' + dwnObject5.size());
                System.debug('Json.serialize(dwnObject5) -----: ' + Json.serialize(dwnObject5));
                if(dwnObject5.size() > 0 && Json.serialize(dwnObject5) != objTst){
                    for(Object obj5 : dwnObject5){

                        Map<String,Object> dwnParsed5 = (Map<String,Object>)obj5;
                        System.debug('dwnParsed5 -----: ' + dwnParsed5);
                    
                        String str5 = (String) dwnParsed5.get('file_link');
                        if(str5 != null){
                            DownloadWrapper dwnWrap5 = new DownloadWrapper();
                            dwnWrap5.file_name = (String) dwnParsed5.get('file_name');
                            dwnWrap5.file_link = (String) dwnParsed5.get('file_link');
                            dwnWrap5.pdf_icon = (String) dwnParsed5.get('pdf_icon_image');

                            downldList.add(dwnWrap5);
                        }
                    }
                    //prod.downList.addall(downldList);
                }
            }
            catch(Exception exp){
                System.debug('Exception in productEisFileResponse -----: '+ exp + 'At line no -' +exp.getLineNumber());
                Object dwnObject8 = (Object)objects.get('productEisFileResponse');
                System.debug('dwnObject8 -----: ' + dwnObject8);
                
                if(Json.serialize(dwnObject8) != objTst){
                                        
                        Map<String,Object> dwnParsed8 = (Map<String,Object>)dwnObject8;
                        System.debug('dwnParsed8 -----: ' + dwnParsed8);
                    
                        String str8 = (String) dwnParsed8.get('file_link');
                        if(str8 != null){
                            DownloadWrapper dwnWrap8 = new DownloadWrapper();
                            dwnWrap8.file_name = (String) dwnParsed8.get('file_name');
                            dwnWrap8.file_link = (String) dwnParsed8.get('file_link');
                            dwnWrap8.pdf_icon = (String) dwnParsed8.get('pdf_icon_image');

                            downldList.add(dwnWrap8);
                        }
                    //prod.downList.addall(downldList);
                }
            }

            System.debug('downldList -----: ' + downldList);
                System.debug('downldList size-----: ' + downldList.size());
        
            List<Object> listObject = objects.values();
            for(Object result : listObject) {
                ProductWrapper prod = new ProductWrapper(); 
                System.debug('result-----: ' + result);
                Map<String,Object> mpParsed = (Map<String,Object>)result;
                System.debug('mpParsed-----: ' + mpParsed);
                prod.id = String.valueOf((Integer) mpParsed.get('id')); 
                prod.name = (String) mpParsed.get('name'); 

                String pests = (String) mpParsed.get('meta_description');
                if(pests.length()>0){
                    String[] arrTest = pests.split(',');
                    if(arrTest.size()>0){
                        List<PestDiseaseWrapper> pestsD = new List<PestDiseaseWrapper>();
                        for(String str:arrTest){
                            if(str.length()>0){
                                PestDiseaseWrapper pd = new PestDiseaseWrapper();
                                pd.id='';
                                pd.name = str;
    
                                pestsD.add(pd);
                            }
                            
                        }

                        if(pestsD.size()>0){
                            prod.pestList.addall(pestsD); 
                        }
                    }
                }

                prod.bannerImage = (String) mpParsed.get('banner_image');
                prod.productTypeImage = (String) mpParsed.get('product_logo_image');
                prod.formulation = (String) mpParsed.get('formulation');
                prod.regInfo = (String) mpParsed.get('registration_info'); 
                prod.productUrl = (String) mpParsed.get('product_url'); 
                prod.type = (String) mpParsed.get('type'); 
                prod.fact = (String) mpParsed.get('fact'); 
                prod.description = (String) mpParsed.get('description'); 
                prod.ingredient = (String) mpParsed.get('cdms_active_ingredient'); 


                List<Object> cropObject = (List<Object>)mpParsed.get('crops');
                if(cropObject.size()>0){
                    List<CropWrapper> cropList = new List<CropWrapper>();
                    for(Object obj : cropObject){
                        CropWrapper crop = new CropWrapper();
                        Map<String,Object> objParsed = (Map<String,Object>)obj;
                        crop.id = String.valueOf((Integer) objParsed.get('id')); 
                        crop.name = (String) objParsed.get('name');
                       
                        cropList.add(crop);
                       // System.debug('cropList - ' + cropList);
                    }
                    prod.cropList.addall(cropList);
                }
                
                productDetails = prod;

                if(downldList.size()>0){
                    productDetails.downList.addall(downldList);
                }
        
                System.debug('productDetails-----: ' + productDetails);
                System.debug('cropObject-----: ' + cropObject);
                System.debug('cropObject size-----: ' + cropObject.size());
                
            }

            /* ********************************************************************** */
            /* JSONParser parser = JSON.createParser(res.getBody());
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
                            else if(attr == 'meta_description') {
                                String pests = parser.getText();
                                if(pests.length()>0){
                                    String[] arrTest = pests.split(',');
                                    if(arrTest.size()>0){
                                        List<PestDiseaseWrapper> pestsD = new List<PestDiseaseWrapper>();
                                        for(String str:arrTest){
                                            PestDiseaseWrapper pd = new PestDiseaseWrapper();
                                            pd.id='';
                                            pd.name = str;

                                            pestsD.add(pd);
                                        }

                                        if(pestsD.size()>0){
                                            prod.pestList.addall(pestsD); 
                                        }
                                    }
                                }
                                
                            }
                            else if(attr == 'banner_image') {
                                prod.bannerImage = parser.getText();
                            }
                            else if(attr == 'product_logo_image') {
                                prod.productTypeImage = parser.getText();
                            }
                            else if(attr == 'formulation') {
                                prod.formulation = parser.getText();
                            }
                            else if(attr == 'registration_info') {
                                prod.regInfo = parser.getText();
                            }
                            else if(attr == 'product_url') {
                                prod.productUrl = parser.getText();
                            }
                            else if(attr == 'type') {
                                prod.type = parser.getText();
                            }
                            else if(attr == 'fact') {
                                prod.fact = parser.getText();
                            }
                            else if(attr == 'description') {
                                prod.description = parser.getText();
                            }
                            else if(attr == 'cdms_active_ingredient'){
                                prod.ingredient = parser.getText();
                            }
                            else if(attr == 'crops') {
                                
                                List<CropWrapper> cropList = new List<CropWrapper>();
                                while(parser.nextToken() != JSONToken.END_ARRAY) {   // we started with an array of objects
                                    
                                    CropWrapper crop = new CropWrapper();   
                                        while(parser.nextToken() != JSONToken.END_OBJECT){   // loop through each object
                                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) { //token should be field name
                                                String pro = parser.getText(); //get the text of the field name
                                                parser.nextToken(); // move the pointer
                                                //start mapping the fields
                                                if(pro == 'id') { 
                                                    crop.id = parser.getText();
                                                } 
                                                else if(pro == 'name') {
                                                    crop.name = parser.getText();
                                                }
                                                else{

                                                }
                                            }
                                        }
                                        cropList.add(crop);
                                        System.debug('prodListObj - ' + cropList);
                                }
                                prod.cropList.addall(cropList);
                            }
                            
                        }
                    }
                    productDetails = prod;
            } */     
        }
        catch(Exception ex){
            System.debug('Exception in getProductDetails method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
            return productDetails;
        }
        System.debug('Respone getProductDetails- ' + productDetails);
        return productDetails;
    }

    public class DownloadWrapper
    {
        @AuraEnabled public string id;
        @AuraEnabled public string file_name;
        @AuraEnabled public string file_link;
        @AuraEnabled public string pdf_icon;
                
        public DownloadWrapper(){
            id = '';
            file_name ='';
            file_link = '';
            pdf_icon = '';
        }
    }

    public class PestDiseaseWrapper
    {
        @AuraEnabled public string id;
        @AuraEnabled public string name;
                
        public PestDiseaseWrapper(){
            id = '';
            name ='';
        }
    }

    public class CropWrapper
    {
        @AuraEnabled public string id;
        @AuraEnabled public string name;
                
        public CropWrapper(){
            id = '';
            name ='';
        }
    }

    public class ProductListWrapper
    {
        @AuraEnabled public string id;
        @AuraEnabled public string name;
        @AuraEnabled public string status;
        @AuraEnabled public string viewLink;
        @AuraEnabled public string leafImage;
        @AuraEnabled public string ingredients;
        @AuraEnabled public string prod_url;

        public ProductListWrapper(){
            id = '';
            name ='';
            status = '';
            viewLink = '';
            leafImage = '';
            ingredients = '';
            prod_url = '';
        }
    }

    public class ProductWrapper
    {
        @AuraEnabled public string id;
        @AuraEnabled public string name;
        @AuraEnabled public string status;
        @AuraEnabled public string displayName;
        @AuraEnabled public string lightColor;
        @AuraEnabled public string darkColor;
        @AuraEnabled public string productTypeImage;
        @AuraEnabled public string leafImage;
        @AuraEnabled public string numberOfProducts;
        @AuraEnabled public List<ProductListWrapper> productList;
        @AuraEnabled public List<PestDiseaseWrapper> pestList;
        @AuraEnabled public List<CropWrapper> cropList;
        @AuraEnabled public List<DownloadWrapper> downList;
        @AuraEnabled public string bannerImage;
        @AuraEnabled public string formulation;
        @AuraEnabled public string regInfo;
        @AuraEnabled public string productUrl;
        @AuraEnabled public string type;
        @AuraEnabled public string fact;
        @AuraEnabled public string description; 
        @AuraEnabled public string ingredient;

        public ProductWrapper(){
            id = '';
            name ='';
            status = '';
            displayName = '';
            lightColor = '';
            darkColor = '';
            productTypeImage = '';
            leafImage = '';
            numberOfProducts = '';
            productList = new List<ProductListWrapper>();
            pestList = new List<PestDiseaseWrapper>();
            cropList = new List<CropWrapper>();
            downList = new List<DownloadWrapper>();
            bannerImage = '';
            formulation = '';
            regInfo = '';
            productUrl = '';
            type = '';
            fact = '';
            description = '';
            ingredient = '';

        }
    }
}