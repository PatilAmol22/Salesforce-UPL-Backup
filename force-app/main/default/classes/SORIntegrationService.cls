/*******************************************************************************************
* @Name         Sales Order Return 
* @Author       Nikhil Dhoke (SKI)
* @Date         03/03/2023
* @Group        SKI
* @Description  This class is used for Sales Order Return Integration (Brazil Only).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         	   Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------   
*  1.0             Nikhil Dhoke            03/04/2023            Initial Creation                                        
*******************************************************************************************/
public without sharing class SORIntegrationService {
    /* public SORIntegrationService() {

    } */
    public static List<HttpWrapper> mainHttpWrapList = new List<HttpWrapper>();

    /*
    * @Description - This method get called from SORParentController class and will send multiple requests depends of Customer Service records.
    * @Param List - Customer service id's,
             List - Full custoer service invoice id's,
             Map - Map of full invoice id's and Order types(Doc type),
             String - SOR id,
             String - Refusal value Yes or No.
    * @return  - .
    */
    @future(callout=true)
    public static void sendToIntegration(List<String> custServIds, List<String> fullCustServInvoiceIds, Map<String,String> invcDocTpMap, String sorId, String refusal){
        List<HttpWrapper> httpWrapList = new List<HttpWrapper>();
        Http http;
        HttpRequest request;
        HttpResponse response;
       
        try {
            Map<String,RSO> custServMap = new Map<String,RSO>();
            Map<String,String> invcAndCustInvcMap = new Map<String,String>();
            RSO rsoWrap = new RSO();
            RSOLineItem rsoItem = new RSOLineItem();
            List<RSOLineItem> rsoItemList = new List<RSOLineItem>();            
            
            List<RSO_with_Customer_Service__c> newCustServList = [SELECT Id, Name, Return_Sales_Order__c, Return_Sales_Order__r.SFDC_Order_Number__c, 
                                                                    SAP_Order_Number__c, Invoice__c, Invoice__r.Name, Invoice__r.Nota_Fiscal__c,  
                                                                    Invoice__r.Billing_Doc_Number__c, Billing_Doc__c, 
                                                                    Invoice_Date__c, Inco_Term__c, Inco_Term_2__c, Sub_Return_Type__c, 
                                                                    Sub_Return_Type__r.Sub_Return_Type_Code__c, Deposit__c, Deposit__r.Deposit_Code__c, 
                                                                    Deposit_Flag__c, Order_Type__c, Full_Return__c, Customer_Invoice__c, Customer_Invoice_Date__c,   
                                                                    Quantity__c, Quantity_Flag__c, Billing_Doc_Item_Number__c, 
                                                                    Billing_Doc_Item_Number__r.Invoice_Line_Item__r.Billing_DOC_reference_number__c,
                                                                    Order_Type__r.Order_Type_Code__c  
                                                                    FROM RSO_with_Customer_Service__c WHERE ID IN :custServIds];
            for(RSO_with_Customer_Service__c cs : newCustServList){
                rsoWrap = new RSO();
                rsoItem = new RSOLineItem();
                rsoItemList = new List<RSOLineItem>();
                String key = '';
                if(refusal == 'Yes'){
                    key = cs.Invoice__c;
                }
                else{
                    if(cs.Order_Type__r.Order_Type_Code__c == 'ZROB'){
                        key = cs.Invoice__c+''+cs.Order_Type__r.Order_Type_Code__c;
                    }
                    else{
                        key = cs.Invoice__c+''+cs.Customer_Invoice__c+''+cs.Order_Type__r.Order_Type_Code__c;
                    }
                }

                if(custServMap.containsKey(key) && cs.Full_Return__c == false && refusal == 'No'){
                    rsoWrap = custServMap.get(key);
                    rsoItemList = rsoWrap.RSOLineItem;
                    rsoItem.billingDocItemNumber = cs.Billing_Doc_Item_Number__r.Invoice_Line_Item__r.Billing_DOC_reference_number__c;
                    rsoItem.quantity = string.valueOf(cs.Quantity__c);
                    rsoItem.quantityFlag = cs.Quantity_Flag__c;

                    if(cs.Deposit__c != null){
                        rsoItem.deposit = cs.Deposit__r.Deposit_Code__c;
                        rsoItem.depositFlag = cs.Deposit_Flag__c;
                    }
                    
                    rsoItemList.add(rsoItem);
                    rsoWrap.RSOLineItem = rsoItemList;
                    custServMap.put(key,rsoWrap);
                }
                else{
                    rsoWrap.RSOSFDCNumber = (cs.Return_Sales_Order__r.SFDC_Order_Number__c).replace('RSO-','').trim();
                    if(cs.Billing_Doc__c != null){
                        rsoWrap.SAPBillingDoc = cs.Billing_Doc__c;
                    }
                    
                    rsoWrap.returnSubType = cs.Sub_Return_Type__r.Sub_Return_Type_Code__c;
                    rsoWrap.incoTerms = cs.Inco_Term__c;
                    rsoWrap.incoTerms2 = cs.Inco_Term_2__c;
                    rsoWrap.orderType = cs.Order_Type__r.Order_Type_Code__c;

                    if(refusal == 'Yes'){
                        rsoWrap.invoice = cs.Invoice__r.Nota_Fiscal__c;//cs.Invoice__r.Billing_Doc_Number__c; // as requested by client...
                        rsoWrap.invoiceDate = string.valueOf(cs.Invoice_Date__c);
                        if(cs.Deposit__c != null){
                            rsoWrap.deposit = cs.Deposit__r.Deposit_Code__c;
                        }
                    }
                    else{
                        if(cs.Order_Type__r.Order_Type_Code__c != 'ZROB'){
                            rsoWrap.invoice = cs.Customer_Invoice__c; // requsted by client...to interchange fields..
                        }
                        
                        rsoWrap.customerInvoice = cs.Invoice__r.Nota_Fiscal__c;//cs.Invoice__r.Billing_Doc_Number__c; // requsted by client...to interchange fields..
                        rsoWrap.customerInvoiceDate = string.valueOf(cs.Customer_Invoice_Date__c);
                        rsoWrap.orderDocType = cs.Order_Type__r.Order_Type_Code__c;
                        rsoWrap.FullReturn = string.valueOf(cs.Full_Return__c);

                        if(cs.Full_Return__c == false && refusal == 'No'){
                            rsoItem.billingDocItemNumber = cs.Billing_Doc_Item_Number__r.Invoice_Line_Item__r.Billing_DOC_reference_number__c;
                            rsoItem.quantity = string.valueOf(cs.Quantity__c);
                            rsoItem.quantityFlag = cs.Quantity_Flag__c;

                            if(cs.Deposit__c != null){
                                rsoItem.deposit = cs.Deposit__r.Deposit_Code__c;
                                rsoItem.depositFlag = cs.Deposit_Flag__c;
                            }

                            rsoItemList.add(rsoItem);
                        }
                        else{
                            if(!invcAndCustInvcMap.containsKey(cs.Invoice__c)){
                                invcAndCustInvcMap.put(cs.Invoice__c,cs.Customer_Invoice__c);
                            }
                        }
                        
                        rsoWrap.RSOLineItem = rsoItemList;                        
                    }

                    custServMap.put(key,rsoWrap);
                }
            } 
            
            List<Return_Sales_Order_Line_Item__c> sorItemList = [SELECT Id, Name, Return_Sales_Order__c, Invoice_Line_Item__c, Invoice__c, Volumn_KG_LT__c, 
                                                                    Return_Sales_Order__r.Customer__r.Brazil_Depot_Code__c, 
                                                                    Return_Sales_Order__r.Return_Sub_Type__c, Invoice_Line_Item__r.Billing_DOC_reference_number__c   
                                                                    FROM Return_Sales_Order_Line_Item__c WHERE Return_Sales_Order__c =: sorId AND 
                                                                    Invoice__c IN : fullCustServInvoiceIds];
            if(sorItemList.size()>0){
                List<RSO_Deposit__c> depositList = SORTabSectionChildController.getDeposit(sorItemList[0].Return_Sales_Order__r.Customer__r.Brazil_Depot_Code__c,sorItemList[0].Return_Sales_Order__r.Return_Sub_Type__c);
                String depstId = '';
                String depstName = '';
                String depstFlag = '';
                if(depositList.size()>0){
                    depstId = depositList[0].Id;
                    depstName = depositList[0].Deposit_Code__c;
                    depstFlag = 'X';
                }

                for(Return_Sales_Order_Line_Item__c sorItem : sorItemList){
                    String key = '';
                    String key2 = '';
                    rsoWrap = new RSO();
                    rsoItem = new RSOLineItem();
                    rsoItemList = new List<RSOLineItem>();

                    if(invcDocTpMap.containsKey(sorItem.Invoice__c)){
                        if(invcDocTpMap.get(sorItem.Invoice__c) == 'ZROB'){
                            key = sorItem.Invoice__c+''+invcDocTpMap.get(sorItem.Invoice__c); // invoice and doc  type...
                        }
                        else{
                            key = sorItem.Invoice__c+''+invcAndCustInvcMap.get(sorItem.Invoice__c)+''+invcDocTpMap.get(sorItem.Invoice__c);
                        }
                    }

                    /* if(invcAndCustInvcMap.containsKey(sorItem.Invoice__c)){
                        key = sorItem.Invoice__c+''+invcAndCustInvcMap.get(sorItem.Invoice__c)+''+invcDocTpMap.get(sorItem.Invoice__c);
                    } */
                    if(custServMap.containsKey(key)){
                        rsoWrap = custServMap.get(key);
                        //key = custServMap.get(key) != null ? key : key2;
                        if(rsoWrap != null){
                            rsoItemList = rsoWrap.RSOLineItem;
                            rsoItem.billingDocItemNumber = sorItem.Invoice_Line_Item__r.Billing_DOC_reference_number__c;
                            rsoItem.quantity = string.valueOf(sorItem.Volumn_KG_LT__c);
                            rsoItem.quantityFlag = 'X';
                            rsoItem.deposit = depstName;
                            rsoItem.depositFlag = depstFlag;
    
                            rsoItemList.add(rsoItem);
                            rsoWrap.RSOLineItem = rsoItemList;
                            custServMap.put(key,rsoWrap);
                        }
                        
                    }
                }
            }   
            System.debug('sorItemList - ' + JSON.serializePretty(sorItemList));
            System.debug('custServMap 2 - ' + JSON.serializePretty(custServMap));
            /* ----------------------------- HTTP Request-Response Part Start ---------------------------------- */
            String accessToken = ServiceHelper.getAuthentication('');
            
            String zcerURL = [SELECT EndPointUrl__c FROM RSOAndDGEndPoint__c WHERE Name=:'ZCER' ORDER BY LastModifiedDate DESC limit 1].EndPointUrl__c;
            String zreb_zrobURL = [SELECT EndPointUrl__c FROM RSOAndDGEndPoint__c WHERE Name=:'ZREB_ZROB' ORDER BY LastModifiedDate DESC limit 1].EndPointUrl__c;
            
            for(RSO sor : custServMap.values()){
                HttpWrapper httpWrap = new HttpWrapper();
                RSORefusalNo rsoNo = new RSORefusalNo();
                RSORefusalYes rsoYes = new RSORefusalYes();
                String json = '';
                http = new Http();
                request = new HttpRequest();
                response = new HttpResponse();
                request.setMethod('GET');
                request.setTimeout(120000);
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setHeader('Authorization','Bearer '+accessToken); 

                if(refusal == 'Yes'){
                    request.setEndpoint(zcerURL); // end point...

                    rsoYes.RSOSFDCNumber = sor.RSOSFDCNumber;
                    rsoYes.SAPBillingDoc = sor.SAPBillingDoc;
                    rsoYes.invoice = sor.invoice;
                    rsoYes.invoiceDate = sor.invoiceDate;
                    rsoYes.returnSubType = sor.returnSubType;
                    rsoYes.deposit = sor.deposit;
                    rsoYes.incoTerms = sor.incoTerms;
                    rsoYes.incoTerms2 = sor.incoTerms2;
                    rsoYes.orderType = sor.orderType;

                    json = System.JSON.serializePretty(rsoYes);
                }
                else{
                    request.setEndpoint(zreb_zrobURL);// end point...

                    rsoNo.RSOSFDCNumber = sor.RSOSFDCNumber;
                    rsoNo.SAPBillingDoc = sor.SAPBillingDoc;
                    rsoNo.invoice = sor.invoice;
                    rsoNo.customerInvoice = sor.customerInvoice;
                    rsoNo.customerInvoiceDate = sor.customerInvoiceDate;
                    rsoNo.returnSubType = sor.returnSubType;
                    rsoNo.orderDocType = sor.orderDocType;
                    rsoNo.incoTerms = sor.incoTerms;
                    rsoNo.incoTerms2 = sor.incoTerms2;
                    rsoNo.FullReturn = sor.FullReturn;
                    rsoNo.RSOLineItem = sor.RSOLineItem;
                    rsoNo.orderType = sor.orderType;

                    json = System.JSON.serializePretty(rsoNo);
                }
                System.debug('json 1- ' + json);
                
                request.setBody(json);
                response = http.send(request);
                System.debug('request - ' + request.getBody());
                System.debug('response - ' + response.getBody());

                httpWrap.request = request;
                httpWrap.response = response;
                httpWrapList.add(httpWrap);
                //custServListToUpdate.addAll(SORIntegrationService.updateCustmerService(response,request,rso.Refusal__c));
            }           
            System.debug('httpWrapList size - ' + httpWrapList.size());
            /* ----------------------------- HTTP Request-Response Part End ---------------------------------- */

            mainHttpWrapList.addAll(httpWrapList);
            System.debug('mainHttpWrapList size - ' + mainHttpWrapList.size());

            if(mainHttpWrapList.size()>0){
                SORIntegrationService.updateCSWithSAP(mainHttpWrapList,sorId,refusal);
            }
            
        } catch (Exception ex) {
            System.debug('sendToIntegration Exception is - '+ ex.getMessage());
            System.debug('sendToIntegration Exception at - '+ ex.getLineNumber());
            ApexLog.exceptionHandlerSORandDG(ex,sorId,request.getBody(),response.getBody(),'SORIntegrationService');
        }
    }

    /*
    * @Description - This method will update Customer service records with SAP number.
    * @Param List - Http wrapper object list,
             String - SOR id,
             String - Refusal value Yes or No.
    * @return  - .
    */
    public static void updateCSWithSAP(List<HttpWrapper> httpWrapList, String sorId, String refusal){
        List<RSO_with_Customer_Service__c> cslist = new List<RSO_with_Customer_Service__c>();
        String req = '';
        String res = '';
        try{
            for(SORIntegrationService.HttpWrapper httpWrap : httpWrapList){
                req = httpWrap.request.getBody();
                res = httpWrap.response.getBody();
                cslist.addAll(SORIntegrationService.responseToCustmerService(httpWrap.response,httpWrap.request,refusal,sorId));
            }
            System.debug('integration call cslist size - '+ cslist.size());
            if(cslist.size() > 0){
                UPDATE cslist;
            } 
        } catch (Exception ex) {
            System.debug('updateCSWithSAP Exception is - '+ ex.getMessage());
            System.debug('updateCSWithSAP Exception at - '+ ex.getLineNumber());
            ApexLog.exceptionHandlerSORandDG(ex,sorId,req,res,'SORIntegrationService');
        }
    }

    /*
    * @Description - This method will convert Http reponse into Customer service record.
    * @Param HttpResponse - response,
             HttpRequest - request
             String - SOR id,
             String - Refusal value Yes or No.
    * @return  - .
    */
    public static List<RSO_with_Customer_Service__c> responseToCustmerService(HttpResponse response, HttpRequest request, String refusal, String sorId){
        List<RSO_with_Customer_Service__c> custServList = new List<RSO_with_Customer_Service__c>();
        try{
            ApexLog.webServiceLogDGSOR(request.getBody(),response.getBody(),response.getStatusCode(),'SORIntegrationService','responseToCustmerService',sorId,UserInfo.getUserId());
            RSO obj = (RSO)JSON.deserialize(response.getBody(), RSO.class);
            System.debug('RSO obj - ' + JSON.serializePretty(obj));
            String sfdcOrdNum = 'RSO-'+obj.RSOSFDCNumber;
            if(String.IsNotBlank(obj.RSOSAPNumber)){
                if(refusal == 'Yes'){
                    custServList = [SELECT Id, SAP_Order_Number__c FROM RSO_with_Customer_Service__c WHERE 
                                    Invoice__r.SAP_Billing_DOC__c =: obj.SAPBillingDoc AND 
                                    Return_Sales_Order__r.SFDC_Order_Number__c =: sfdcOrdNum AND 
                                    Full_Return__c = false];
                }
                else{
                    if(obj.orderType == 'ZROB'){
                        custServList = [SELECT Id, SAP_Order_Number__c FROM RSO_with_Customer_Service__c WHERE 
                                        Invoice__r.SAP_Billing_DOC__c =: obj.SAPBillingDoc AND 
                                        Return_Sales_Order__r.SFDC_Order_Number__c =: sfdcOrdNum AND 
                                        Order_Type__r.Order_Type_Code__c =: obj.orderType];
                    }
                    else{
                        custServList = [SELECT Id, SAP_Order_Number__c FROM RSO_with_Customer_Service__c WHERE 
                                        Invoice__r.SAP_Billing_DOC__c =: obj.SAPBillingDoc AND 
                                        Return_Sales_Order__r.SFDC_Order_Number__c =: sfdcOrdNum AND 
                                        Customer_Invoice__c =: obj.invoice AND Order_Type__r.Order_Type_Code__c =: obj.orderType];
                    } 
                }
                System.debug('RSO custServList - ' + JSON.serializePretty(custServList));
                if(custServList.size() > 0){
                    for(RSO_with_Customer_Service__c rso : custServList){
                        rso.SAP_Order_Number__c = obj.RSOSAPNumber;
                    }
                    System.debug('RSO custServList 2- ' + JSON.serializePretty(custServList));
                }
            }
            
        } catch (Exception e) {
            System.debug('responseToCustmerService Exception is - '+ e.getMessage());
            System.debug('responseToCustmerService Exception at - '+ e.getLineNumber());
            ApexLog.exceptionHandlerSORandDG(e,sorId,request.getBody(),response.getBody(),'SORIntegrationService');
        }
        return custServList;
    }        

    public class HttpWrapper{
        public HttpRequest request;
        public HttpResponse response;

        public HttpWrapper(){
            request = new HttpRequest();
            response = new HttpResponse();
        }
    }

    public class RSO{

        @AuraEnabled public String RSOSFDCNumber;
        @AuraEnabled public String SAPBillingDoc;
        @AuraEnabled public String invoice;
        @AuraEnabled public String customerInvoice;
        @AuraEnabled public String customerInvoiceDate;
        @AuraEnabled public String returnSubType;
        @AuraEnabled public String orderDocType;
        @AuraEnabled public String incoTerms;
        @AuraEnabled public String incoTerms2;
        @AuraEnabled public String FullReturn;
        @AuraEnabled public String invoiceDate;
        @AuraEnabled public String deposit;
        @AuraEnabled public String RSOSAPNumber;
        @AuraEnabled public String errorCode;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public List<RSOLineItem> RSOLineItem;
        @AuraEnabled public String orderType;

        public RSO(){
            RSOSFDCNumber = '';
            SAPBillingDoc = '';
            invoice = '';
            customerInvoice = '';
            customerInvoiceDate = '';
            returnSubType = '';
            orderDocType = '';
            incoTerms = '';
            incoTerms2 = '';
            FullReturn = '';
            invoiceDate = '';
            deposit = '';
            RSOSAPNumber = '';
            errorCode = '';
            errorMessage = '';
            RSOLineItem = new List<RSOLineItem>();
            orderType = '';
        }
    }

    public class RSORefusalNo{
        @AuraEnabled public String RSOSFDCNumber;
        @AuraEnabled public String SAPBillingDoc;
        @AuraEnabled public String invoice;
        @AuraEnabled public String customerInvoice;
        @AuraEnabled public String customerInvoiceDate;
        @AuraEnabled public String returnSubType;
        @AuraEnabled public String orderDocType;
        @AuraEnabled public String incoTerms;
        @AuraEnabled public String incoTerms2;
        @AuraEnabled public String FullReturn;
        @AuraEnabled public List<RSOLineItem> RSOLineItem;
        @AuraEnabled public String orderType;

        public RSORefusalNo(){
            RSOSFDCNumber = '';
            SAPBillingDoc = '';
            invoice = '';
            customerInvoice = '';
            customerInvoiceDate = '';
            returnSubType = '';
            orderDocType = '';
            incoTerms = '';
            incoTerms2 = '';
            FullReturn = '';
            RSOLineItem = new List<RSOLineItem>();
            orderType = '';
        }

    }

    public class RSORefusalYes{
        @AuraEnabled public String RSOSFDCNumber;
        @AuraEnabled public String SAPBillingDoc;
        @AuraEnabled public String invoice;
        @AuraEnabled public String invoiceDate;
        @AuraEnabled public String returnSubType;
        @AuraEnabled public String deposit;
        @AuraEnabled public String incoTerms;
        @AuraEnabled public String incoTerms2;
        @AuraEnabled public String orderType;

        public RSORefusalYes(){
            RSOSFDCNumber = '';
            SAPBillingDoc = '';
            invoice = '';
            invoiceDate = '';
            returnSubType = '';
            deposit = '';
            incoTerms = '';
            incoTerms2 = '';
            orderType = '';
        }
    }

    public class RSOLineItem {
        @AuraEnabled public String billingDocItemNumber;
        @AuraEnabled public String quantity;
        @AuraEnabled public String quantityFlag;
        @AuraEnabled public String deposit;
        @AuraEnabled public String depositFlag;

        public RSOLineItem(){
            billingDocItemNumber = '';
            quantity = '';
            quantityFlag = '';
            deposit = '';
            depositFlag = '';
        }
    }
}