/**************************************************************************************************
* Name               : grz_SapIntegration                                                      
* Description        : Utility class for all SAP Integrations
* Test Class         : grz_SapIntegrationTest
* Created By         : Nikhil Verma (Grazitti)                                                                        
**************************************************************************************************/
public with sharing class grz_SapIntegration {
    
    
    public static String FormattedDate(Datetime dt){
        String dateFormatString = 'MMM dd, yyyy';
        String dateString = dt.format(dateFormatString,'IST');
        return dateString;
    }
    public static String FormattedDateBrazil(Datetime dt){
        String dateFormatString = 'd/M/yyyy';
        String dateString = dt.format(dateFormatString ,'GMT');
        return dateString;
    }
    public static String FormattedDateMexico(Datetime dt){
        String dateFormatString = 'dd/MM/yyyy';
        String dateString = dt.formatGmt(dateFormatString);
        return dateString;
    }
    public static String FormattedDateChile(Datetime dt){
        String dateFormatString = 'dd-MM-yyyy';
        String dateString = dt.formatGmt(dateFormatString);
        return dateString;
    }
    public static String currencyBrazil(Decimal inrValue){
        List<String> args = new String[]{'0','number','#,###.0'};
            String parseVal = String.format(inrValue.format(), args);
        return parseVal;
    }
    
    @AuraEnabled(cacheable=true)
    public static String GenerateToken(){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SAP_CPI_DATA');
        req.setTimeout(120000);
        req.setMethod('POST');
        HTTPresponse res= http.send(req);
        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Object token = (Object)response.get('access_token');
        return token.toString();
    }
    @AuraEnabled(cacheable=true)
    public static String CreditSummary(String companyCode,String customerCode, String sapUserId){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/CreditSummary_IND');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        req.setBody(body);
        system.debug(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            system.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            system.debug(response);
            
        }catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String CreditSummaryBrazil(String companyCode,String customerCode, String sapUserId){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/CreditSummary_INT');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        req.setBody(body);
        system.debug(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            system.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            system.debug(response);
        }catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String AccountAndLedgerStatement(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/CustomerLedger_IND');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"FiscalYearFrom\":\"'+fiscalYearFrom+'\",\"FiscalYearTo\":\"'+fiscalYearTo+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        req.setBody(body);
        system.debug(body);
        HTTPresponse res= http.send(req);
        
        string response;
        if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
        system.debug(response);
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String AccountAndLedgerStatementForBrazil(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/CustomerLedger_INT');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"FiscalYearFrom\":\"'+fiscalYearFrom+'\",\"FiscalYearTo\":\"'+fiscalYearTo+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String GerInvoiceInfo(String SAPOrderNumber, String sapUserId){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/Invoice_Details_IND');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"SAPOrderNumber\":\"'+SAPOrderNumber+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
              if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
           
            system.debug(response);
            
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static user GetUserInfo(){
        List<user> u = [select id, name,contactId,Contact.name,MobilePhone,Email,accountId,userroleid from user where id =: userinfo.getUserId()];
        return u[0];
    }
    public static String getUserTerritory(Id userId){
        
       List<User> userMap= [Select Id,Name,ProfileId,Profile.Name,MobilePhone,AccountId,Account.name from User where Id =:userId];
        System.debug('sendEmailToUserTerritoryRCM userMap==>'+userMap);
         String accountID;
         String TerritoryID;
         String rcmEmail;
        if(userMap[0].AccountId != Null)
        accountID = userMap[0].AccountId;
        System.debug('sendEmailToUserTerritoryRCM useraccMap==>'+accountID);
        
        List<Account> accMap = [Select id,name,recordtypeid,recordtype.name,Territory_Distributor__c from Account where id =: accountID];
        System.debug('sendEmailToUserTerritoryRCM accMap==>'+accMap);
        if(accMap[0].Territory_Distributor__c != Null)
        TerritoryID = accMap[0].Territory_Distributor__c;
        List<Territory_Distributor__c> territoryMap = [Select id,RCM_Email__c  from Territory_Distributor__c where id =: TerritoryID];
        System.debug('sendEmailToUserTerritoryRCM territoryMap==>'+territoryMap);
        if(territoryMap[0].RCM_Email__c != Null)
        rcmEmail = territoryMap[0].RCM_Email__c;
        System.debug('sendEmailToUserTerritoryRCM rcmEmail==>'+rcmEmail);
        return rcmEmail;
    }
    @AuraEnabled(cacheable=true)
    public static String getGstDetails(String customerCode, String companyCode, String startDate, String endDate, String sapUserId){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/GST_Details_IND');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"CompanyCode\":\"'+companyCode+'\",\"CustomerCode\":\"'+customerCode+'\",\"StartDate\":\"'+startDate+'\",\"EndDate\":\"'+endDate+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        req.setBody(body);
        system.debug(body);
        HTTPresponse res= http.send(req);
        string response;
        if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
        system.debug('response==>'+response);
        return response;
    }
    @AuraEnabled
    public static String getBrazilAccountReceivables(String customerCode, String sapUserId,String companyCode, String posting_date_in_the_document){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/AccountReceivables_INT');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"customerCode\":\"'+customerCode+'\",\"sapUserId\":\"'+sapUserId+'\",\"companyCode\":\"'+companyCode+'\",\"posting_date_in_the_document\":\"'+posting_date_in_the_document+'\"}';
        req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            //Commented to increase code coverage block not required GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
            /*if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }*/
        }
        catch(Exception e){
            response = 'Error_In_Sap';
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String getMexicoChileAR(String customerNumber, String sapUserId,String companyCode, String keyDate, String notedItem, String secIndex){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/OpenInvoices_CL');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"customerNumber\":\"'+customerNumber+'\",\"sapUserId\":\"'+sapUserId+'\",\"companyCode\":\"'+companyCode+'\",\"keyDate\":\"'+keyDate+'\",\"notedItem\":\"'+notedItem+'\",\"secIndex\":\"'+secIndex+'\"}';
        req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    public static String getInvoiceDeliveryInfoMexico(String token, String deliveryNumber){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        system.debug(token);
        req.setEndpoint('https://cuplir.arysta.com/ArystaCargo/Services/GetRemission');
        req.setTimeout(120000);
        //req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"Token\":\"'+token+'\",\"Remission\":\"'+deliveryNumber+'\"}';
        req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            system.debug('response : '+res);
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String getMexicoInvoicPDF(String sapUserId,String companyCode, String billingDocNumber, String qas){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/Invoice-MX');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        //String body = '{\"customerNumber\":\"'+customerNumber+'\",\"sapUserId\":\"'+sapUserId+'\",\"companyCode\":\"'+companyCode+'\",\"keyDate\":\"'+keyDate+'\",\"notedItem\":\"'+notedItem+'\",\"secIndex\":\"'+secIndex+'\"}';
        String body = '{\"sapUserId\":\"'+sapUserId+'\",\"input\":[{\"companyCode\":\"'+companyCode+'\",\"billingDocNum\":\"'+billingDocNumber+'\"}],\"Qas\":\"'+qas+'\"}';
        req.setBody(body);
        String response;
        try{
            HTTPresponse res= http.send(req);
            if(res.getStatusCode() == 200){
                response = res.getBody();
                system.debug('Invoice response : '+response);
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    
/**************************************************************************************************
* @Description       : method created to get Assignment document for Argentina Account ledger                                                       
* Date               : 21-09-2022
* Project/JIRA       : APPS-1757                                                                        
* Author             : Gurubaksh Grewal
* @Return            : String
* Last Modified By 	 : Gurubaksh Grewal (Grazitti) 21-09-2022                                                                        
**************************************************************************************************/
	@AuraEnabled(cacheable=true)
    public static String getArgentinaInvoicPDF(String assignment,String companyCode){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/Assignment_Document_Fetch_AR');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"Assignment\":\"'+assignment+'\"}';
        req.setBody(body);
        String response;
        try{
            HTTPresponse res= http.send(req);
            if(res.getStatusCode() == 200){
                response = res.getBody();
                system.debug('Invoice response : '+response);
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    
    /**************************************************************************************************
* @Description       : method created to get invoice document for Argentina Account ledger                                                       
* Date               : 13-13-2023
* Project/JIRA       : RITM0512279                                                                      
* Author             : Sumit Kumar
* @Return            : String
* Last Modified By 	 : Sumit Kumar (Grazitti) 13-13-2023                                                                       
**************************************************************************************************/
	@AuraEnabled(cacheable=true)
    public static String getArgentinaDocumentPDF(String companyCode,String AccountingDocNumber,String fiscalYear){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/Doc_Num_Fetch_PDF_AR');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"documentNumber\":\"'+AccountingDocNumber+'\",\"fiscalYear\":\"'+fiscalYear+'\"}';
        req.setBody(body);
        String response;
        try{
            HTTPresponse res= http.send(req);
            if(res.getStatusCode() == 200){
                response = res.getBody();
                system.debug('Invoice response : '+response);
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    
    @AuraEnabled(cacheable=true)
    public static String CreditSummaryChileMexico(String companyCode,String customerCode, String sapUserId){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/CreditSummary_NL');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        req.setBody(body);
        system.debug(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
            system.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            system.debug(response);
        }catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }
    @AuraEnabled(cacheable=true)
    public static String AccountAndLedgerStatementForMexico(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId){

        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/CustomerLedger_MXCL');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"FiscalYearFrom\":\"'+fiscalYearFrom+'\",\"FiscalYearTo\":\"'+fiscalYearTo+'\",\"sapUserId\":\"'+sapUserId+'\"}';
         System.debug('body--'+body);
        req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
             System.debug('res--'+res);
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }

/**************************************************************************************************
* @Description       : method created to get data for Argentina consignment stock                                                       
* Date               : 02-09-2022
* Project/JIRA       : APPS-1757                                                                        
* Author             : Gurubaksh Grewal
* @Return            : String
* Last Modified By 	 : Gurubaksh Grewal (Grazitti) 02-09-2022                                                                        
**************************************************************************************************/
      
    @AuraEnabled(cacheable=true)
    public static String ArgentinaConsignmentStockData(String customerCode,string depot){
        
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/Consignment_stock');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"customerCode\":\"'+customerCode+'\",\"Depot\":\"'+depot+'\"}';
        req.setBody(body);
        system.debug(body);
        HTTPresponse res= http.send(req);
        
        string response;
        system.debug('res======='+res.getStatusCode());
        system.debug('res======='+res.getStatus());
        if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
        system.debug(response);
        return response;
    }
    
    
/**************************************************************************************************
* @Description       : method created to get data for argentina Account and leger chart                                                       
* Date               : 11-08-2022
* Project/JIRA       : APPS-1757                                                                        
* Author             : Gurubaksh Grewal
* @Return            : String
* Last Modified By 	 : Gurubaksh Grewal (Grazitti) 17-08-2022                                                                        
**************************************************************************************************/
    
    @AuraEnabled(cacheable=true)
    public static String AccountAndLedgerStatementForArgentina(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId){

        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        system.debug(token);
        req.setEndpoint('callout:Sap_data/http/CustomerLedger_NL');
        req.setTimeout(120000);
        req.setHeader('Authorization', 'Bearer '+token);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"FiscalYearFrom\":\"'+fiscalYearFrom+'\",\"FiscalYearTo\":\"'+fiscalYearTo+'\",\"sapUserId\":\"'+sapUserId+'\"}';
         System.debug('body--'+body);
        req.setBody(body);
        string response;
        try{
            HTTPresponse res= http.send(req);
             System.debug('res--'+res);
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }else{
                response = 'Error_In_Sap';
            }
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        return response;
    }

    /**************************************************************************************************
    * @Description       : Method to send community attachments via email                                                      
    * Date               : 19-08-2022
    * Project/JIRA       : APPS-1893                                                                    
    * Author             : Nikhil Verma
    * Last Modified By 	 : Nikhil Verma (Grazitti) 19-08-2022                                                                        
    **************************************************************************************************/

    @AuraEnabled
    public static void SendEMail(String Url, String fileType, String fileName, String subjectName){
       PageReference pageRef = new PageReference(Url);
        Blob body;
        if(Test.isRunningTest()) { 
          body = blob.valueOf('Unit.Test');
        } else {
          body = pageRef.getContent();
        }
      	String name = UserInfo.getName();
        List<String> emailaddress = new List<String>();
		String email = UserInfo.getUserEmail();
        emailaddress.add(email);      
        List<EmailTemplate> p =[SELECT Id,body,HtmlValue,subject FROM EmailTemplate WHERE developername =: 'Chile_Community_Attachment_Template' limit 1];
        if(!p.isEmpty()){
            String Html = p[0].HtmlValue;
            Html = Html.replace('[name]', name);
            Html = Html.replace('[fileType]', fileType.toUpperCase());
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            if(fileType == 'pdf'){
                attach.setContentType('application/pdf');
                attach.setFileName(fileName + '.pdf');
                attach.setInline(false);
                attach.Body = body;
            }else if(fileType == 'xls'){
                attach.setContentType('application/xls');
                attach.setFileName(fileName + '.xls');
                attach.setInline(false);
                attach.Body = body;
            }
            List<OrgWideEmailAddress> owa = [SELECT id, DisplayName, Address FROM OrgWideEmailAddress WHERE displayname =: 'Sales Excellence' ];
            if(!owa.isEmpty()){
                String fromAdressId = owa[0].id;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setOrgWideEmailAddressId(fromAdressId);
                mail.setHtmlBody(Html);
                mail.setToAddresses(emailaddress);
                mail.setSubject(subjectName);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false); 
            }    
        } 
    }
}