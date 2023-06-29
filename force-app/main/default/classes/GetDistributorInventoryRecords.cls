public with sharing class GetDistributorInventoryRecords {
    //added changes for new filters RITM0212196
    //fixed the loading screen error for only dist name or code search RITM0212196
    //fixed the order of execution of the if else ladder RITM0212196
    //added empty string check in all if conditions RITM0212196
    //http get request was not necessary for checking count of records for pagination, so removed to normal SOQL RITM0212196
    
    @AuraEnabled
    public static string getTotalRecordcount(String d_name,String d_code,String di_material_name,String di_material_code,String d_month,String d_year){
        String query = 'SELECT Count() from Distributor_Inventory__c WHERE Distributor__r.Name != \''+null+'\'';
        
        // HttpRequest req = new HttpRequest(); 
        // req.setEndpoint('https://'+URL.getSalesforceBaseUrl().getHost()+'/services/data/v20.0/query/?q=SELECT+Id+from+Distributor_Inventory__c'); 
        // req.setMethod('GET'); 
        // string autho = 'Bearer '+ userInfo.getsessionId(); 
        // System.debug('session ID'+autho);
        // req.setHeader('Authorization', autho); 
        // Http http = new Http(); 
        // HTTPResponse res = http.send(req); 
        // string response = res.getBody(); 
        // string total = response.substring(response.indexOf('totalSize":') + 11, response.indexOf(',')); 
        // system.debug('Total: '+ total);
        //Integer total = 0;
        /*HttpRequest req;
        HttpResponse res;
        String userDetails=userInfo.getUserName();*/
        Integer total;
        if( !String.isEmpty(d_name) && d_name!=null ){
            //system.debug('d_name non empty');
            d_name = '%' + d_name + '%';
            query += ' and Distributor__r.Name like \''+d_name+'\'';
        }else{
            //system.debug('d_name empty');
        }
        if( !String.isEmpty(d_code) && d_code!=null ){
            //system.debug('d_code non empty');
            d_code = '%' + d_code + '%';
            query += ' and Distributor__r.SAP_Code__c like \''+d_code+'\'';
        }else{
            //system.debug('d_code empty');
        }
        if( !String.isEmpty(di_material_name) && di_material_name!=null ){
            //system.debug('di_material_name non empty');
            di_material_name = '%' + di_material_name + '%';
            query += ' and Material__r.SKU_Description__c like \''+di_material_name+'\'';
        }else{
            //system.debug('di_material_name empty');
        }
        if( !String.isEmpty(di_material_code) && di_material_code!=null ){
            //system.debug('di_material_code non empty');
            di_material_code = '%' + di_material_code + '%';
            query += ' and Material__r.SKU_Code__c like \''+di_material_code+'\'';
        }else{
            //system.debug('di_material_code empty');
        }
        if( !String.isEmpty(d_month) && d_month!=null ){
            //system.debug('d_month non empty');
            query += ' and Month_value__c = \''+d_month+'\'';
        }else{
            //system.debug('d_month empty');
        }
        if( !String.isEmpty(d_year) && d_year!=null ){
            //system.debug('d_year non empty');
            query += ' and Fiscal_Year__c = \''+d_year+'\'';
        }else{
            //system.debug('d_year empty');
        }
        
        try{ 
            //Http h = new Http();
            //EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
            //chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
            //req = new HttpRequest();

            
            /*if( !String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(di_material_name)&&String.isEmpty(di_material_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year) ){
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.Name LIKE :d_name and Material__r.SKU_Description__c LIKE :di_material_name and Month_value__c=:d_month and Fiscal_Year__c=:d_year];
            }else if( String.isEmpty(d_name)&&!String.isEmpty(d_code)&&String.isEmpty(di_material_name)&&!String.isEmpty(di_material_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year) ){
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.SAP_Code__c LIKE :d_code and Material__r.SKU_Code__c LIKE :di_material_code and Month_value__c=:d_month and Fiscal_Year__c=:d_year];
            }else if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE+\'%'+d_name+'%\''+'and+Month_value__c=\''+d_month+'\'+and+Fiscal_Year__c=\''+d_year+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE+\'%'+d_name+'%\''+'and+Month_value__c=\''+d_month+'\'+and+Fiscal_Year__c=\''+d_year+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.Name LIKE :d_name and Month_value__c=:d_month and Fiscal_Year__c=:d_year];
            }else if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\''+'and+Month_value__c=\''+d_month+'\'+and+Fiscal_Year__c=\''+d_year+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\''+'and+Month_value__c=\''+d_month+'\'+and+Fiscal_Year__c=\''+d_year+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.SAP_Code__c LIKE :d_code and Month_value__c=:d_month and Fiscal_Year__c=:d_year];
            }else  if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE+\'%'+d_name+'%\''+'and+Month_value__c=\''+d_month+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE+\'%'+d_name+'%\''+'and+Month_value__c=\''+d_month+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.Name LIKE :d_name and Month_value__c=:d_month];
            }else if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&String.isEmpty(d_month)&&!String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE+\'%'+d_name+'%\''+'and+Fiscal_Year__c=\''+d_year+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE+\'%'+d_name+'%\''+'and+Fiscal_Year__c=\''+d_year+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.Name LIKE :d_name and Fiscal_Year__c=:d_year];
            }else if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&!String.isEmpty(d_month)&&String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\''+'and+Month_value__c=\''+d_month+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\''+'and+Month_value__c=\''+d_month+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.SAP_Code__c LIKE:d_code and Month_value__c=:d_month];
            }else if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&String.isEmpty(d_month)&&!String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\''+'and+Fiscal_Year__c=\''+d_year+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\''+'and+Fiscal_Year__c=\''+d_year+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.SAP_Code__c LIKE:d_code and Fiscal_Year__c=:d_year];
            }else if(String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Month_value__c=\''+d_month+'\'+and+Fiscal_Year__c=\''+d_year+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Month_value__c=\''+d_month+'\'+and+Fiscal_Year__c=\''+d_year+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Month_value__c=:d_month and Fiscal_Year__c=:d_year];
            }else if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&String.isEmpty(d_month)&&String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE+\'%'+d_name+'%\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.Name+LIKE:\''+d_name+'\'');
                total = [SELECT Count() FROM Distributor_Inventory__c where Distributor__r.Name LIKE :d_name];
            }else if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&String.isEmpty(d_month)&&String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Distributor__r.SAP_Code__c+LIKE+\'%'+d_code+'%\'');
                total = [SELECT Count() from Distributor_Inventory__c where Distributor__r.SAP_Code__c LIKE:d_code];
            }else if(String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Month_value__c=\''+d_month+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Month_value__c=\''+d_month+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Month_value__c=:d_month];
            }else if(String.isEmpty(d_name)&&String.isEmpty(d_code)&&String.isEmpty(d_month)&&!String.isEmpty(d_year)){
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c+where+Fiscal_Year__c=\''+d_year+'\'';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c+where+Fiscal_Year__c=\''+d_year+'\'');
                total = [SELECT Count() from Distributor_Inventory__c where Fiscal_Year__c=:d_year];
            }else{
                //String query='';
                //query='SELECT+Count()+from+Distributor_Inventory__c';
                //req.setEndpoint(chatbotSetting.End_Point__c+'SELECT+Count()+from+Distributor_Inventory__c');
                total = [SELECT Count() from Distributor_Inventory__c];
            }*/
            
            /*req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + getAccessToken(userDetails,chatbotSetting.siteBase__c,chatbotSetting.ConsumerKey__c) ); 
            
            if(!test.isRunningTest()){
                res = h.send(req);
            }else{
                res = MockHttpResponseGeneratorChatbot.respond(req);
            }*/
            
            //System.Debug('Response body >> ' + JSON2Apex.parse(res.getBody())); 
            
            //insert new Monitor_Log__c(Response__c	= res.getBody(),Method__c = userDetails);
            
            total = database.countQuery(query);
            return String.valueOf(total);
            
        }catch(Exception e){
            System.Debug('EXCEPTION >> ' + e);
            total = [SELECT Count() from Distributor_Inventory__c];
            return String.valueOf(total);
        }
        /*System.Debug('Response body >> ' + res.getBody());
        system.debug('status code->'+res.getStatusCode());
        if( res.getStatusCode() == 200 ){
            string response = res.getBody();
            system.debug('response->'+response);
            string total = response.substring(response.indexOf('totalSize":') + 11, response.indexOf(',')); 
            system.debug('Total: '+ total);
            return total;
        }else{
            return '5';
        }*/
    }
    
    /*public static String getAccessToken(String username,string siteBase,String consumerKey){
        //String siteBase = 'https://test.salesforce.com';
        //String consumerKey = '3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw';
        Auth.JWT jwt = new Auth.JWT();
        jwt.setSub(username);
        jwt.setIss(consumerKey);
        jwt.setAud(siteBase);
        Auth.JWS jws = new Auth.JWS(jwt, 'EinsteinBot');
        String tokenEndpoint = siteBase+'/services/oauth2/token';
        Auth.JWTBearerTokenExchange bearer = new
            Auth.JWTBearerTokenExchange(tokenEndpoint, jws);
        String accessToken ='';
        if(!test.isRunningTest()){
            accessToken = bearer.getAccessToken();
        }
        System.Debug('accessToken >>>>>>> ' + accessToken);
        return accessToken;
    }*/
    
    
    
    @AuraEnabled
    public static List<Distributor_Inventory__c> onfilter(String d_name,String d_code,String di_material_name,String di_material_code,String d_month,String d_year, String str_limit,String last_record,String op){
        Integer limit_num = Integer.valueOf(str_limit);
        //system.debug('Sayan onfilter d_name->'+d_name);
        //system.debug('Sayan onfilter d_code->'+d_code);
        //system.debug('Sayan getTotalRecordcount di_material_name->'+di_material_name);
        //system.debug('Sayan getTotalRecordcount di_material_code->'+di_material_code);
        //system.debug('Sayan onfilter d_month->'+d_month);
        //system.debug('Sayan onfilter d_year->'+d_year);
        String order = 'ASC';
        if(op=='<'){
            order = 'DESC';
        }
        String query = 'SELECT Id, Office__r.Name,Pagination_Formula__c, Fiscal_Year__c, Month__c,Month_value__c, Distributor__r.Name, Distributor__r.SAP_Code__c, Pesticidal_Year__c, Single_pack_number__c, Region__c, Area__r.Name, Material__r.SKU_Description__c, Material__r.SKU_Code__c, Single_Pack_Size__c, Distributors_Office__c,Price_Per_Single_Bottle__c,Amount_JPY__c,Single_Bottle_In_Case__c,Calendar_Year__c,Japan_Region__c,Number_in_case__c FROM Distributor_Inventory__c where Pagination_Formula__c '+op+' '+last_record+' ';
        
        
        if( !String.isEmpty(d_name) && d_name!=null ){
            //system.debug('d_name non empty');
            d_name = '%' + d_name + '%';
            query += ' and Distributor__r.Name like \''+d_name+'\'';
        }else{
            //system.debug('d_name empty');
        }
        if( !String.isEmpty(d_code) && d_code!=null ){
            //system.debug('d_code non empty');
            d_code = '%' + d_code + '%';
            query += ' and Distributor__r.SAP_Code__c like \''+d_code+'\'';
        }else{
            //system.debug('d_code empty');
        }
        if( !String.isEmpty(di_material_name) && di_material_name!=null ){
            //system.debug('di_material_name non empty');
            di_material_name = '%' + di_material_name + '%';
            query += ' and Material__r.SKU_Description__c like \''+di_material_name+'\'';
        }else{
            //system.debug('di_material_name empty');
        }
        if( !String.isEmpty(di_material_code) && di_material_code!=null ){
            //system.debug('di_material_code non empty');
            di_material_code = '%' + di_material_code + '%';
            query += ' and Material__r.SKU_Code__c like \''+di_material_code+'\'';
        }else{
            //system.debug('di_material_code empty');
        }
        if( !String.isEmpty(d_month) && d_month!=null ){
            //system.debug('d_month non empty');
            query += ' and Month_value__c = \''+d_month+'\'';
        }else{
            //system.debug('d_month empty');
        }
        if( !String.isEmpty(d_year) && d_year!=null ){
            //system.debug('d_year non empty');
            query += ' and Fiscal_Year__c = \''+d_year+'\'';
        }/*else{
            system.debug('d_year empty');
        }*/
        List<Distributor_Inventory__c> di;
        /*String di_query = 'SELECT Id, Office__r.Name,Pagination_Formula__c, Fiscal_Year__c, Month__c,Month_value__c, Distributor__r.Name, Distributor__r.SAP_Code__c, Pesticidal_Year__c, Single_pack_number__c, Region__c, Area__r.Name, Material__r.SKU_Description__c, Material__r.SKU_Code__c, Single_Pack_Size__c, Distributors_Office__c,Price_Per_Single_Bottle__c,Amount_JPY__c,Single_Bottle_In_Case__c,Calendar_Year__c,Japan_Region__c,Number_in_case__c FROM Distributor_Inventory__c';
        
        if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(di_material_name)&&String.isEmpty(di_material_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.Name like \''+d_name+'\' and Material__r.SKU_Description__c like \''+di_material_name+'\' and Month_value__c = \''+d_month+'\' and Fiscal_Year__c = \''+d_year+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_name di_material_name d_month d_year-->'+qry);
            return di;
        }
        
        if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&String.isEmpty(di_material_name)&&!String.isEmpty(di_material_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            system.debug('Sayan onfilter d_code->'+d_code);
            system.debug('Sayan onfilter di_material_code->'+di_material_code);
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.SAP_Code__c like \''+d_code+'\' and Material__r.SKU_Code__c like \''+di_material_code+'\' and Month_value__c = \''+d_month+'\' and Fiscal_Year__c = \''+d_year+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_code di_material_code d_month d_year-->'+qry);
            return di;
        }
        
        if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.Name like \''+d_name+'\' and Month_value__c = \''+d_month+'\' and Fiscal_Year__c = \''+d_year+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_name d_month d_year-->'+qry);
            return di;
        }
        if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.SAP_Code__c like \''+d_code+'\' and Month_value__c = \''+d_month+'\' and Fiscal_Year__c = \''+d_year+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_code d_month d_year-->'+qry);
            return di;
        }
        if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.Name like \''+d_name+'\' and Month_value__c = \''+d_month+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_name d_month-->'+qry);
            return di;
        }
        if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.Name like \''+d_name+'\' and Fiscal_Year__c = \''+d_year+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_name d_year-->'+qry);
            return di;
        }
        
        if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&!String.isEmpty(d_month)&&String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.SAP_Code__c like \''+d_code+'\' and Month_value__c = \''+d_month+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_code d_month-->'+qry);
            return di;
        }
        if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.SAP_Code__c like \''+d_code+'\' and Fiscal_Year__c = \''+d_year+'\' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_code d_year-->'+qry);
            return di;
        }
        if(String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and  Month_value__c = \''+d_month+'\' and  Fiscal_Year__c = \''+d_year+'\'  Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_month d_year-->'+qry);
            return di;
        }
        
        if(!String.isEmpty(d_name)&&String.isEmpty(d_code)&&String.isEmpty(d_month)&&String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.Name like \''+d_name+'\'  Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_name-->'+qry);
            return di;
        }
        if(String.isEmpty(d_name)&&!String.isEmpty(d_code)&&String.isEmpty(d_month)&&String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and Distributor__r.SAP_Code__c like \''+d_code+'\'  Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_code-->'+qry);
            return di;
        }
        if(String.isEmpty(d_name)&&String.isEmpty(d_code)&&!String.isEmpty(d_month)&&String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and  Month_value__c = \''+d_month+'\'  Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_month-->'+qry);
            return di;
        }
        if(String.isEmpty(d_name)&&String.isEmpty(d_code)&&String.isEmpty(d_month)&&!String.isEmpty(d_year)){
            String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' and  Fiscal_Year__c = \''+d_year+'\'  Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
            di = Database.query(qry);
            System.debug('qry d_year-->'+qry);
            return di;
        }
        String idd='a651m0000006xueAAA';
        
        String qry = di_query+' where Pagination_Formula__c '+op+' '+last_record+' Order By Pagination_Formula__c '+order+' limit '+limit_num+'';
        System.debug('qry-->'+qry);
        di = Database.query(qry);
        return di;*/


        query += 'Order By Pagination_Formula__c '+order+' limit '+limit_num;
        di = Database.query(query);
        return di;
    }    
    @AuraEnabled
    public static string getLastRecord(){
        return String.valueOf([select id,CreatedDate,Pagination_Formula__c from Distributor_Inventory__c order by CreatedDate desc limit 1].Pagination_Formula__c); 
    }
    
    @AuraEnabled
    public static void deleteRecords(list<Id> lstIds){
        try {
            list<Distributor_Inventory__c> lstRecsToDelete = new list<Distributor_Inventory__c>();
            //System.debug('lstConIds ====> '+lstIds);
            for(Id idRec : lstIds) {
                lstRecsToDelete.add(new Distributor_Inventory__c(Id = idRec));
            }
            if(!lstRecsToDelete.isEmpty()) {
                delete lstRecsToDelete;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}