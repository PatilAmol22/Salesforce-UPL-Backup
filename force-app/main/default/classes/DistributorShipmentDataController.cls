public with sharing class DistributorShipmentDataController {
    
    @AuraEnabled(cacheable=true)
    public static String getTotalRecCount(String searchKeyName,String searchKeyCode,String searchKeyMaterialCode,String searchKeyMaterialName, String searchKeyYear , String searchKeyMonth){
        
        HttpRequest req;
        HttpResponse res;
        Integer count=0;
        String keyCode = '%' + searchKeyCode + '%'; 
        String KeyName = '%' + searchKeyName + '%'; 
        String KeyMCode = '%' + searchKeyMaterialCode + '%';
        String KeyMName = '%' + searchKeyMaterialName + '%';
        String keyMonth = searchKeyMonth;
        String keyYear = searchKeyYear;
        String userDetails=userInfo.getUserName();
        try{ 
    		Http h = new Http();
              EnglishSalesTeamChatbotSetting__c chatbotSetting = new EnglishSalesTeamChatbotSetting__c();
                chatbotSetting = [SELECT Id,ConsumerKey__c,End_Point__c,siteBase__c FROM EnglishSalesTeamChatbotSetting__c WHERE Name = 'Eisenstein Connected App Setting' LIMIT 1]; 
                req = new HttpRequest();

        if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyMonth)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+Month_value__c =\''+keyMonth+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+Month_value__c =\''+keyMonth+'\'');
            
        }
        else if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'');
        	
        }
        else if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyMaterialName)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'');
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyMonth)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'';
            system.debug('Query1'+query);
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'');
        	
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'';
            system.debug('Query2'+query);
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'');
        	
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'';
            system.debug('Query3'+query);
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'');
        	
        }
        else if(!String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyMonth)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+KeyMCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'';
            system.debug('Query4'+query);
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+KeyMCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'');
        }
        else if(!String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+KeyMCode+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'';
            system.debug('Query5'+query);
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+KeyMCode+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'');
        	
        }
        else if(!String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+keyMCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'';
            system.debug('Query6'+query);
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+KeyMCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'');
        	
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+keyMCode+'%\''+'AND+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'';
            system.debug('Query7'+query);
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+KeyMCode+'%\''+'AND+Distributor_Code__c+LIKE+\'%'+keyCode+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'');
        	
        }
         else if(!String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyMonth)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'');
        }
        else if(!String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+UPL_FY__c=\''+keyYear+'\'');
        }
        else if(!String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'');
        }
        else if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
                String query='';
                query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'';
                req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+KeyMName+'%\''+'AND+Distributor_Name__c+LIKE+\'%'+KeyName+'%\''+'AND+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'');
        }
        else if(!String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Month_value__c=\''+keyMonth+'\'+AND+UPL_FY__c=\''+keyYear+'\'');
        }
        else if(!String.isBlank(searchKeyName)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Name__c+LIKE+\'%'+KeyName+'%\'');
        }
        else if(!String.isBlank(searchKeyCode)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Distributor_Code__c+LIKE+\'%'+keyCode+'%\'');
        }
        else if(!String.isBlank(searchKeyMaterialCode)){
                String query='';
                query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+keyMCode+'%\'';
                req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Code__c+LIKE+\'%'+keyMCode+'%\'');
        }
        else if(!String.isBlank(searchKeyMaterialName)){
                String query='';
                query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+keyMName+'%\'';
                req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Material_Name__c+LIKE+\'%'+keyMName+'%\'');
        }
        else if(!String.isBlank(searchKeyMonth)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+Month_value__c=\''+keyMonth+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+Month_value__c=\''+keyMonth+'\'');
        }
        else if(!String.isBlank(searchKeyYear)){
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c+where+UPL_FY__c=\''+keyYear+'\'';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c+where+UPL_FY__c=\''+keyYear+'\'');
        }
        else 
        {
            String query='';
            query='select+count()+from+Ex_Distributor_Shipment_Data__c';
            req.setEndpoint(chatbotSetting.End_Point__c+'select+count()+from+Ex_Distributor_Shipment_Data__c');
        }
        
        req.setMethod('GET');
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept', 'application/json');
    	req.setHeader('Authorization', 'Bearer ' + getAccessToken(userDetails,chatbotSetting.siteBase__c,chatbotSetting.ConsumerKey__c) ); 
				
            if(!test.isRunningTest()){
                  res = h.send(req);
            }else{      
				res = MockHttpResponseGeneratorChatbot.respond(req);
            }
              
          }catch(Exception e){
              System.Debug('EXCEPTION >> ' + e);
              return null;
          }
          System.Debug('Response body >> ' + res.getBody());
          string response = res.getBody(); 
          string total = response.substring(response.indexOf('totalSize":') + 11, response.indexOf(',')); 
        system.debug('Total: '+ total);
        return total;
    }
    
    public static String getAccessToken(String username,string siteBase,String consumerKey){
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
    }


    public static String tablename='';
    @AuraEnabled 
    public static List<SObject> getDistributorShipmentData(String pageNumber,String pageSize,String searchKeyName,String searchKeyCode,String searchKeyMaterialCode,String searchKeyMaterialName, String searchKeyYear , String searchKeyMonth,String pageoffSet){
        system.debug('pageoffSet-->'+pageoffSet);
        String op='>';
       
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        Integer offset = Integer.valueOf(pageoffSet);

        List<SObject> v1 = New List<SObject>();
        List<SObject> DistributorShipmentDataList = v1;
       
        String keyCode = '%' + searchKeyCode + '%'; 
        String keyMaterialCode = '%' + searchKeyMaterialCode + '%';
        String keyMaterialName = '%' + searchKeyMaterialName + '%';
        String KeyName = '%' + searchKeyName + '%'; 
        String keyMonth = searchKeyMonth;
        String keyYear = searchKeyYear;

        if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyMonth) && String.isBlank(searchKeyMaterialName) && String.isBlank(searchKeyYear)){
            String query='';
            //Updated by Varun Shrivastava start : 1 April 2021 SCTASK0429583
            //query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Name__c LIKE \'%'+KeyName+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' AND Pagination_Formula__c '+op+' '+offset+'Order By Pagination_Formula__c ASC LIMIT  ' + psize ;
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Name__c LIKE \'%'+KeyName+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            //Updated by Varun Shrivastava End : 1 April 2021 SCTASK0429583
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyMonth) && String.isBlank(searchKeyMaterialName)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Name__c LIKE \'%'+KeyName+'%\'' + 'AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyMaterialName)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Name__c LIKE \'%'+KeyName+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyMonth) && String.isBlank(searchKeyYear) && String.isBlank(searchKeyMaterialCode)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Code__c LIKE \'%'+keyCode+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyMonth) && String.isBlank(searchKeyMaterialCode)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Code__c LIKE \'%'+keyCode+'%\'' + 'AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyMaterialCode)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Code__c LIKE \'%'+keyCode+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyCode) && String.isBlank(searchKeyMonth) && String.isBlank(searchKeyYear)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Code__c LIKE :keyMaterialCode AND Distributor_Code__c LIKE :keyCode Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyMonth) && String.isBlank(searchKeyYear) && String.isBlank(searchKeyCode)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Code__c LIKE \'%'+keyMaterialCode+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyMonth) && String.isBlank(searchKeyCode)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Code__c LIKE \'%'+keyMaterialCode+'%\'' + 'AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyCode)){
            String query='';
			query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Code__c LIKE \'%'+keyMaterialCode+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyCode) && !String.isBlank(searchKeyMaterialCode) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            system.debug('here');
			query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Code__c LIKE :keyMaterialCode AND Distributor_Code__c LIKE :keyCode AND Month_value__c= \'' +KeyMonth+ '\'  AND UPL_FY__c = \'' +keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyMonth) && String.isBlank(searchKeyYear) && String.isBlank(searchKeyName)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Name__c LIKE \'%'+keyMaterialName+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyMonth) && String.isBlank(searchKeyName)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Name__c LIKE \'%'+keyMaterialName+'%\'' + 'AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear) && String.isBlank(searchKeyName)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Name__c LIKE \'%'+keyMaterialName+'%\'' + 'AND Month_value__c  = \''+keyMonth+'\' AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyMaterialName) && String.isBlank(searchKeyMonth) && String.isBlank(searchKeyYear)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Name__c LIKE :keyMaterialName AND Distributor_Name__c LIKE :keyName Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyName) && !String.isBlank(searchKeyMaterialName) && !String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Name__c LIKE :keyMaterialName AND Distributor_Name__c LIKE :keyName AND Month_value__c= \'' +KeyMonth+ '\'  AND UPL_FY__c = \'' +keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMonth) && !String.isBlank(searchKeyYear)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Month_value__c  = \''+keyMonth+'\' AND UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyName)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Name__c LIKE \'%'+KeyName+'%\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyCode)){
            String query='';
            //Updated by Varun Shrivastava start : 1 April 2021 SCTASK0429583
            //query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Code__c LIKE \'%'+keyCode+'%\'' + 'AND Pagination_Formula__c '+op+' '+offset+'Order By Pagination_Formula__c ASC LIMIT  ' + psize ;
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Distributor_Code__c LIKE \'%'+keyCode+'%\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            //Updated by Varun Shrivastava End : 1 April 2021 SCTASK0429583
            //system.debug('Query searchKeyCode--->'+query);
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialCode)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Code__c LIKE \'%'+keyMaterialCode+'%\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMaterialName)){
            String query='';
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Material_Name__c LIKE \'%'+keyMaterialName+'%\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyMonth)){
            String query='';
            //Updated by Varun Shrivastava start : 1 April 2021 SCTASK0429583
            //query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Month_value__c  = \''+keyMonth+'\' AND Pagination_Formula__c '+op+' '+offset+'Order By Pagination_Formula__c ASC LIMIT  ' + psize ;
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Month_value__c  = \''+keyMonth+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            //Updated by Varun Shrivastava End : 1 April 2021 SCTASK0429583
            //system.debug('Query searchKeyName--->'+query);
            DistributorShipmentDataList=Database.query(query);
        }
        else if(!String.isBlank(searchKeyYear)){
            String query='';
            //Updated by Varun Shrivastava start : 1 April 2021 SCTASK0429583
            //query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where UPL_FY__c = \''+keyYear+'\' AND Pagination_Formula__c '+op+' '+offset+'Order By Pagination_Formula__c ASC LIMIT  ' + psize ;
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where UPL_FY__c = \''+keyYear+'\' Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            //Updated by Varun Shrivastava End : 1 April 2021 SCTASK0429583
            //system.debug('Query searchKeyName--->'+query);
            DistributorShipmentDataList=Database.query(query);
        }
        else 
        {
            String query='';
            //Updated by Varun Shrivastava start : 1 April 2021 SCTASK0429583
            //query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c where Pagination_Formula__c '+op+' '+offset+'Order By Pagination_Formula__c ASC LIMIT  ' + psize ;
            query='SELECT Amount_JPY__c, Id, Distributor_Area_Name__c, toLabel(Chemical_IPM__c), Sales_Office_of_Ex_Distributor__c, Area_Name__c, Sales_Office_Name__c, UPL_FY__c, Calendar_Year__c, Distributor_Name__c, Distributor_Code__c, Customer_Name__c, toLabel(Month__c), Distributor_Office_Name__c, Region_in_Ex_Distributor_s_Customer__c, District_in_Ex_Distributor_s_Customer__c, toLabel(Customer_Category__c), Material_Name__c, Material_Code__c, JA_Area_Name__c, Single_Pack_Size__c, Volume__c, Pesticidal_Year__c, Price_per_single_bottle_bag__c, Order_Type__c, Customer_Address__c, IPM_NEW__c, Single_bottle_bag_number_in_Case__c, Month_value__c,Sales_Office_Area_in_Distributor_Text__c,Distributor_s_Office_Text__c,Unit_Of_Measurement__c FROM Ex_Distributor_Shipment_Data__c Order By Pagination_Formula__c ASC LIMIT  ' + psize +'OffSet '+offset;
            //Updated by Varun Shrivastava End : 1 April 2021 SCTASK0429583
            // system.debug('Query All--->'+query);
            DistributorShipmentDataList=Database.query(query);
        }
         
       // System.debug(DistributorShipmentDataList);
        return DistributorShipmentDataList;
    }

    @AuraEnabled(cacheable=true)
    public static  List<WrapperFieldLabelYear>  getFiscalYearList()
    {
            /*------Dynamic Apex------*/
        Schema.DescribeFieldResult fieldResult = Ex_Distributor_Shipment_Data__c.UPL_FY__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        List<WrapperFieldLabelYear> wrapperlist=new List<WrapperFieldLabelYear>();
        for( Schema.PicklistEntry f : ple)
        {
            WrapperFieldLabelYear wrapperObj=new WrapperFieldLabelYear();
                
                wrapperObj.label=f.getLabel();
                wrapperObj.value=f.getValue();
                wrapperlist.add(wrapperObj);
            
        } 
            //system.debug('Fiscal Year-->'+wrapperlist);
            return wrapperlist;
    }

    public class WrapperFieldLabelYear
    {
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
        

        public WrapperFieldLabelYear()
        {
            label='';
            value='';
        }
    }

    @AuraEnabled(cacheable=true)
    public static  List<WrapperFieldLabelMonth>  getMonthList()
    {
            /*------Dynamic Apex------*/
        Schema.DescribeFieldResult fieldResult = Ex_Distributor_Shipment_Data__c.Month__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        List<WrapperFieldLabelMonth> wrapperlist=new List<WrapperFieldLabelMonth>();
        for( Schema.PicklistEntry f : ple)
        {
            WrapperFieldLabelMonth wrapperObj=new WrapperFieldLabelMonth();
                
                wrapperObj.label=f.getLabel();
                wrapperObj.value=f.getValue();
                wrapperlist.add(wrapperObj);
            
        } 
            //system.debug('months-->'+wrapperlist);
            return wrapperlist;
    }

    public class WrapperFieldLabelMonth
    {
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
        

        public WrapperFieldLabelMonth()
        {
            label='';
            value='';
        }
    }

    @AuraEnabled
    public static void deleteRecords(list<Id> lstIds){
        try {
            list<Ex_Distributor_Shipment_Data__c> lstRecsToDelete = new list<Ex_Distributor_Shipment_Data__c>();
            System.debug('lstConIds ====> '+lstIds);
            for(Id idRec : lstIds) {
                lstRecsToDelete.add(new Ex_Distributor_Shipment_Data__c(Id = idRec));
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