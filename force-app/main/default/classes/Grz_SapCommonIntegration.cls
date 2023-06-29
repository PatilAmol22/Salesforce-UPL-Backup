/**************************************************************************************************
* Name               : Grz_SapCommonIntegration                                                      
* Description        : Common class for SAP integration callouts
* Created Date       : 23/05/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_SapCommonIntegration {
    
    /******************************************************************************************************
    * @Description        : Method is used to get HANA Integration Mappings for SAP
    * Date                : 16/02/2023
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : Map
    *******************************************************************************************************/
    public static Map<String, Grz_Customer360IntegrationMappings__mdt> getIntegrationMappings(){
        Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = new Map<String, Grz_Customer360IntegrationMappings__mdt>();
        for(Grz_Customer360IntegrationMappings__mdt data: Grz_Customer360IntegrationMappings__mdt.getAll().values()){
            integrationSettingsMap.put(data.Sales_Org_Code__c, data);
        }
        return integrationSettingsMap;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Credit Summary parameters for SAP
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String creditSummary(String companyCode,String customerCode, String sapUserId){
        String endpointURL = 'CreditSummary_NL';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Credit Summary India parameters for SAP
    * Date                : 01/06/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String creditSummaryIND(String companyCode,String customerCode, String sapUserId){
        String endpointURL = 'CreditSummary_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }
    
    /******************************************************************************************************
    * @Description        : Method is used to set  Marketing and Manufacturing Credit Summary India parameters for SAP
    * Date                : 16/02/2023 
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String creditSummaryMarketingIND(String companyCode,String customerCode, String sapUserId, String endPointNameURL){
        String endpointURL = endPointNameURL+'/CreditSummary_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Customer Overdue parameters for SAP
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String overdueSummary(String customerNumber, String sapUserId,String companyCode, String keyDate, String notedItem, String secIndex){
        String endpointURL = 'OpenInvoices_CL';
        String body = '{\"customerNumber\":\"'+customerNumber+'\",\"sapUserId\":\"'+sapUserId+'\",\"companyCode\":\"'+companyCode+'\",\"keyDate\":\"'+keyDate+'\",\"notedItem\":\"'+notedItem+'\",\"secIndex\":\"'+secIndex+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Customer Overdue India parameters for SAP
    * Date                : 01/06/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String overdueSummaryIND(String customerNumber, String sapUserId,String companyCode, String keyDate, String notedItem, String secIndex){
        String endpointURL = 'OpenInvoices_IND';
        String body = '{\"customerNumber\":\"'+customerNumber+'\",\"sapUserId\":\"'+sapUserId+'\",\"companyCode\":\"'+companyCode+'\",\"keyDate\":\"'+keyDate+'\",\"notedItem\":\"'+notedItem+'\",\"secIndex\":\"'+secIndex+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }
    
        /******************************************************************************************************
    * @Description        : Method is used to set Marketing and Manufacturing Customer Overdue India parameters for SAP
    * Date                : 16/02/2023 
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String overdueSummaryMarketingIND(String customerNumber, String sapUserId,String companyCode, String keyDate, String notedItem, String secIndex,String endPointNameURL){
        String endpointURL = endPointNameURL + '/OpenInvoices_IND';
        String body = '{\"customerNumber\":\"'+customerNumber+'\",\"sapUserId\":\"'+sapUserId+'\",\"companyCode\":\"'+companyCode+'\",\"keyDate\":\"'+keyDate+'\",\"notedItem\":\"'+notedItem+'\",\"secIndex\":\"'+secIndex+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Customer Ledger parameters for SAP
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String customerLedger(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId){
        String endpointURL = 'CustomerLedger_NL';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"FiscalYearFrom\":\"'+fiscalYearFrom+'\",\"FiscalYearTo\":\"'+fiscalYearTo+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Customer Ledger India parameters for SAP
    * Date                : 01/06/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String customerLedgerIND(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId){
        String endpointURL = 'CustomerLedger_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"FiscalYearFrom\":\"'+fiscalYearFrom+'\",\"FiscalYearTo\":\"'+fiscalYearTo+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }
    
    /******************************************************************************************************
    * @Description        : Method is used to set Marketing and Manufacturing Customer Ledger India parameters for SAP
    * Date                : 17/02/2023 
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String customerLedgerMarketingIND(String customerCode, String companyCode, String fiscalYear, String fiscalYearFrom, String fiscalYearTo, String sapUserId,String endPointNameURL){
        String endpointURL = endPointNameURL + '/CustomerLedger_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"FiscalYearFrom\":\"'+fiscalYearFrom+'\",\"FiscalYearTo\":\"'+fiscalYearTo+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }
    
    /******************************************************************************************************
    * @Description        : Method is used to set Customer Outstanding parameters for SAP
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String customerOutstanding(String customerCode, String companyCode, String salesOrgCode, String distributionCode, String divisionCode, String sapUserId){
        String endpointURL = 'CustomerOutstanding_NL';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerNumber\":\"'+customerCode+'\",\"salesOrg\":\"'+salesOrgCode+'\",\"distrChan\":\"'+distributionCode+'\",\"division\":\"'+divisionCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Customer Outstanding India parameters for SAP
    * Date                : 01/06/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String customerOutstandingIND(String customerCode, String companyCode, String salesOrgCode, String distributionCode, String divisionCode, String sapUserId){
        String endpointURL = 'CustomerOutstanding_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerNumber\":\"'+customerCode+'\",\"salesOrg\":\"'+salesOrgCode+'\",\"distrChan\":\"'+distributionCode+'\",\"division\":\"'+divisionCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }
    
    /******************************************************************************************************
    * @Description        : Method is used to set Marketing and Manufacturing Customer Outstanding India Marketing parameters for SAP
    * Date                : 18/02/2023 
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    
    public static String customerOutstandingMarketingIND(String customerCode, String companyCode, String salesOrgCode, String distributionCode, String divisionCode, String sapUserId,String endPointNameURL){
        String endpointURL = endPointNameURL + '/CustomerOutstanding_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerNumber\":\"'+customerCode+'\",\"salesOrg\":\"'+salesOrgCode+'\",\"distrChan\":\"'+distributionCode+'\",\"division\":\"'+divisionCode+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Collection parameters for SAP
    * Date                : 14/06/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String collection(String customerCode, String companyCode, String fiscalYear, String fiscalPeriod, String sapUserId){
        String endpointURL = 'Collection_Inter';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"fiscalPeriod\":\"'+fiscalPeriod+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set Collection parameters for SAP
    * Date                : 14/06/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String collectionIND(String customerCode, String companyCode, String fiscalYear, String fiscalPeriod, String sapUserId){
        String endpointURL = 'Collection_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"fiscalPeriod\":\"'+fiscalPeriod+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }
    
        /******************************************************************************************************
    * @Description        : Method is used to set Marketing and Manufacturing url in Collection parameters for SAP
    * Date                : 20/02/2023 
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String collectionMarketingIND(String customerCode, String companyCode, String fiscalYear, String fiscalPeriod, String sapUserId,String endPointNameURL){
        String endpointURL = endPointNameURL + '/Collection_IND';
        String body = '{\"companyCode\":\"'+companyCode+'\",\"customerCode\":\"'+customerCode+'\",\"fiscalYear\":\"'+fiscalYear+'\",\"fiscalPeriod\":\"'+fiscalPeriod+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set  Marketing and Manufacturing GST India parameters for SAP
    * Date                : 16/02/2023 
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String GSTMarketingIND(String customerCode, String companyCode, String startDate, String endDate, String sapUserId, String endPointNameURL){
        String endpointURL = endPointNameURL+'/GST_Details_IND';
        String body = '{\"CompanyCode\":\"'+companyCode+'\",\"CustomerCode\":\"'+customerCode+'\",\"StartDate\":\"'+startDate+'\",\"EndDate\":\"'+endDate+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method is used to set  Marketing and Manufacturing Invoice India parameters for SAP
    * Date                : 16/02/2023 
    * Author              : Sumit Kumar (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String invoiceMarketingIND(String SAPOrderNumber, String sapUserId, String endPointNameURL){
        String endpointURL = endPointNameURL+'/Invoice_Details_IND';
        String body = '{\"SAPOrderNumber\":\"'+SAPOrderNumber+'\",\"sapUserId\":\"'+sapUserId+'\"}';
        String response = makeSapCallout( endpointURL, body );
        return response;
    }

    /******************************************************************************************************
    * @Description        : This method will generate token
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String generateToken(){
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SAP_CPI_DATA');
        request.setTimeout(120000);
        request.setMethod('POST');
        HTTPresponse res = http.send( request );
        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Object token = (Object)response.get('access_token');
        return token.toString();
    }

    /******************************************************************************************************
    * @Description        : Genric method to call SAP
    * Date                : 23/05/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    *******************************************************************************************************/
    public static String makeSapCallout(String endPointURL, String body){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        String token = GenerateToken();
        String response = 'Error_In_Sap';
        if(token != null){
            req.setEndpoint('callout:Sap_data/http/' + endPointURL);
            req.setTimeout(120000);
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            req.setBody(body);
            HTTPresponse res = http.send(req);
            if(res.getStatusCode() == 200){
                response = res.getBody();
            }
        }
        return response;
    }

    /******************************************************************************************************
    * @Description        : Method to get Sales Area data for Customer
    * Date                : 26/06/2023 
    * Author              : Nikhil Verma (Grazitti) RITM0579566                                                                 
    * @Return             : String
    *******************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static List<DistributorSalesAreaMapping__c> getSalesAreaValues(String recordId) {
        Map<String,DistributorSalesAreaMapping__c> dsaMap = new Map<String,DistributorSalesAreaMapping__c>();
        for(DistributorSalesAreaMapping__c dsa: [SELECT Id,SalesOrg__r.Name,Sales_Org_Code__c,Company_Code__c FROM DistributorSalesAreaMapping__c WHERE Distributor__c=:recordId]){
            dsaMap.put(dsa.SalesOrg__r.name,dsa);
        }
        return dsaMap.values();
    }
}