/*
* Name: BrazilHANAServiceHelper
* Created On: 04 November 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Helper Class to pass Brazil Order Data to HANA Service using REST API.
* Supporting Class: ApexLog(For Exception Handling), TransactionLogHandler(For adding Transaction Log Entries), BrazilHANAServiceHelper_Test (Test Class)
*/
global class BrazilHANAServiceHelper{
    
    public static HttpResponse response;
    
    //Invocable Method called when Order Status is Approved
    //Based on 'Type of Order' different service methods are called
    @InvocableMethod
    public static void callHanaService(List<ID> IDString){
        System.debug('IDString: '+IDString);
        callService(IDString[0]);
    }
    
    @AuraEnabled
    webservice static String callHANAFromAction(String recordId){
        System.debug('recordId: '+recordId);
        return callService(recordId);
    }
    
    public static String callService(String recordId){
        System.debug('recordId: '+recordId);
        
        String result = 'Failed';
        
        List<Sales_Order__c> salesOrderList = new List<Sales_Order__c>([SELECT Id, Type_of_Order__c, PaymentMethod__r.Name 
                                                                        FROM Sales_Order__c 
                                                                        WHERE Id =: recordId 
                                                                        AND SAP_Order_Number__c = ''
                                                                        AND Order_Status__c != 'Draft' 
                                                                        AND Order_Status__c != 'Pending' 
                                                                        AND Order_Status__c != 'Cancelled' 
                                                                        AND Order_Status__c != 'Rejected']);
        System.debug('salesOrderList' +salesOrderList);
        
        try{
            if(!salesOrderList.isEmpty()){
                if(salesOrderList[0].Type_of_Order__c == 'CONTRATO MÃE'){
                    pushContract(String.valueof(salesOrderList[0].id));
                }
                else if(SalesOrderList[0].Type_of_Order__c == 'ORDEM FILHA'){
                    pushMaefil(String.valueof(salesOrderList[0].id));
                }
                else{
                    pushSalesOrder(String.valueof(salesOrderList[0].id));
                }
                result = 'Success';
            }
        }
        catch(Exception ex){
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerBrazil(ex, salesOrderList[0].Sold_to_Party__c, salesOrderList[0], '');
            
            //Add an entry to Transaction Log
            TransactionLogHandler.addTransactionEntry(ex, salesOrderList[0]);            
        }        
        return result;
    }
    
    //Method to load BrazilPushSalesOrderService and call the REST servive
    //Note: Some values are hardcoded or left blank since clarification is required from UPL
    @future(callout=true)
    webservice static void pushSalesOrder(String recordId){
        
        //Get Order & LineItems Data in Wrapper
        OrderWrapper owObj = getOrderWrapper(recordId);
        
        try{
            String url = '';
            
            if(isSandbox()){            
                //Sandbox
                url = 'https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/pushSalesOrder'; 
			}
            else{
                //Production
                url = 'https://l4039-iflmap.hcisbp.eu1.hana.ondemand.com/http/pushSalesOrder'; 
            }
            
            //Timeout set to 120 seconds (Max Limit)
            Integer timeOut = 120000;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();        
            
            // Set time out in milliseconds
            request.setTimeout(timeOut);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            
            //Set Authentication Header - Basic (Username/Password)
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
            
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            
            request.setHeader('Authorization', authorizationHeader);
            
            //Set endpoint url of service
            request.setEndpoint(url);          
            
            /*
            * Starting Wrapper Creation
            */
            BrazilPushSalesOrderService bpsObj = new BrazilPushSalesOrderService();
            
            //Get Sales Order
            bpsObj.ImportHeaders = new BrazilPushSalesOrderService.cls_ImportHeaders();
            //Get Related Items to Sales Order
            bpsObj.Tables = new BrazilPushSalesOrderService.cls_Tables();
            
            //Start Header (Sales Order)
            bpsObj.ImportHeaders.ORDER_HEADER_IN = new BrazilPushSalesOrderService.cls_ORDER_HEADER_IN();
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SAP_USER = owObj.UGDN;
            
            if(owObj.soObj.Type_of_Order__c == 'BONIFICAÇÃO'){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_TYPE = 'ZBON';
            }
            if(owObj.soObj.Type_of_Order__c == 'REMESSA PARA TESTE'){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_TYPE = 'ZREM';
            }
            if(owObj.soObj.Type_of_Order__c == 'VENDA CONTA ORDEM'){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_TYPE = 'ZRCS';
            }
            if(owObj.soObj.Type_of_Order__c == 'VENDA ZONA FRANCA'){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_TYPE = 'ZFRN';
            } 
            if(owObj.soObj.Type_of_Order__c == 'VENDA NORMAL'){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_TYPE = 'ZORB';
            }
                        
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SALES_ORG = 5191;
            String depotCode = owObj.soObj.Sold_to_Party__r.Brazil_Depot_Code__r.Depot_Code__c;
            
            Integer distributionChannel = 20;
            if(depotCode=='BR00'){
                distributionChannel = 10;
            }
            
            String DivID = owObj.soObj.Price_Book__r.Division__r.Division_Code__c;
            if(String.isNotBlank(DivID)){
                  bpsObj.ImportHeaders.ORDER_HEADER_IN.DIVISION = DivID;
                }else{
                    bpsObj.ImportHeaders.ORDER_HEADER_IN.DIVISION = '10';
                }
            
            bpsObj.ImportHeaders.ORDER_HEADER_IN.DISTR_CHAN = distributionChannel;
          //  bpsObj.ImportHeaders.ORDER_HEADER_IN.DIVISION = Integer.valueOf(owObj.soObj.Price_Book__r.Division__r.Division_Code__c);
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SALES_OFF = owObj.soObj.Region_Territory__r.Zone__r.ZoneCode__c;//'BR20';
            bpsObj.ImportHeaders.ORDER_HEADER_IN.PURCH_DATE = String.valueOf(owObj.soObj.Purchase_Order_Date__c);
            bpsObj.ImportHeaders.ORDER_HEADER_IN.REF_1 = owObj.soObj.SFDC_Order_Number__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SALES_DIST = owObj.soObj.Region_Territory__r.Region__r.RegionCode__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.INCOTERMS1 = owObj.soObj.Inco_Term__r.IncoTerm_Code__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.INCOTERMS2 = '.';
          //  bpsObj.ImportHeaders.ORDER_HEADER_IN.FIX_VAL_DY = String.valueOf(owObj.soObj.Maturity_Date__c);
           // bpsObj.ImportHeaders.ORDER_HEADER_IN.PMNTTRMS = owObj.soObj.Payment_Term__r.Payment_Term_Code__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CT_VALID_F = String.valueOf(owObj.soObj.Valid_From__c);
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CT_VALID_T = String.valueOf(owObj.soObj.Valid_To__c);
      /**  Sandip Atkari 03/11/2019 - Start Here  */
            
            //Maturity update added by ganesh 26/3/2019
            String maturityDate = String.valueOf(owObj.soObj.Maturity_Date__c);
            String CampaignDate = String.valueOf(owObj.soObj.Campaign_Payment_Term_Date__c);
            
            if(String.isNotBlank(maturityDate) || String.isNotBlank(CampaignDate)){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PMNTTRMS = 'BR71';
            }else{
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PMNTTRMS = owObj.soObj.Payment_Term__r.Payment_Term_Code__c;  
            }
            if(String.isNotBlank(maturityDate)){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.FIX_VAL_DY = maturityDate;
            }else if(String.isNotBlank(CampaignDate)){    
                bpsObj.ImportHeaders.ORDER_HEADER_IN.FIX_VAL_DY = CampaignDate;
            }
            //Change end
            if(owObj.soObj.Kit_Order__c){//Modified by Deeksha for kit selling Project
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPK';     //Modified by Deeksha for kit selling Project       
            }else if(owObj.soObj.Pronutiva__c){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPP';
            }
            else if(owObj.soObj.Directed_Sales__c){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPD';
            }else{
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPT';
            }
/**  Sandip Atkari 03/11/2019 - End Here  */        
    
            String territoryCode = owObj.soObj.Region_Territory__r.TerritoryCode__c;
            if(String.isNotBlank(territoryCode)){
                territoryCode = territoryCode.remove('BR');
            }
            
            String sbuCode = owObj.soObj.Region_Territory__r.SBU__r.SBUCode__c;        
            if(String.isNotBlank(sbuCode)){
                //sbuCode = sbuCode.remove('BR');
            }
            
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CUST_GRP1 = territoryCode; //owObj.soObj.Sold_to_Party__r.Group_Name__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CUST_GRP2 = sbuCode; //owObj.soObj.Sold_to_Party__r.Customer_Group__c; //'BR2';
            bpsObj.ImportHeaders.ORDER_HEADER_IN.PURCH_NO_C = owObj.soObj.Purchase_Order_no__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SD_DOC_CAT = 'C';
            bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_DATE = String.valueOf(Date.valueOf(owObj.soObj.CreatedDate));
            bpsObj.ImportHeaders.ORDER_HEADER_IN.PYMT_METH = owObj.soObj.PaymentMethod__r.Payment_Method_Code__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CURRENCY_VALUE = owObj.headerCurrency; //String.valueOf(owObj.soObj.CurrencyISOCode);
            //End Header
            
            //Start Order Conditions
            bpsObj.Tables.ORDER_CONDITIONS_IN = new BrazilPushSalesOrderService.cls_ORDER_CONDITIONS_IN();
            bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions = new List<BrazilPushSalesOrderService.cls_row_conditions>();
            
            BrazilPushSalesOrderService.cls_row_conditions rowObj = new BrazilPushSalesOrderService.cls_row_conditions();
            rowObj.ITM_NUMBER = '000000';
            rowObj.COND_TYPE = 'ZBRD';
            rowObj.COND_VALUE = String.valueOf(owObj.soObj.Punctuality_Discount__c);// String.valueOf(owObj.discountValue);
            rowObj.CURRENCY_VALUE = '';     //owObj.itemCurrency; //String.valueOf(owObj.soObj.CurrencyISOCode);
            bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj);   

            //Added business discount mapping in condition GRZ(Nikhil Verma) RITM0419745 date 13-09-2022
            if(owObj.soObj.Type_of_Order__c == 'VENDA CONTA ORDEM' || owObj.soObj.Type_of_Order__c == 'VENDA ZONA FRANCA' || owObj.soObj.Type_of_Order__c == 'VENDA NORMAL'){
                BrazilPushSalesOrderService.cls_row_conditions rowObjData = new BrazilPushSalesOrderService.cls_row_conditions();
                rowObjData.ITM_NUMBER = '000000';
                rowObjData.COND_TYPE = 'ZBTE';
                rowObjData.COND_VALUE = String.valueOf(owObj.soObj.Business_Discount__c);
                rowObjData.CURRENCY_VALUE = '';
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObjData); 
            }
            // ----------End here GRZ(Nikhil Verma) RITM0419745 date 13-09-2022

            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushSalesOrderService.cls_row_conditions rowObj2 = new BrazilPushSalesOrderService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZBR0';
                rowObj2.COND_VALUE = String.valueOf(soi.UnitValue__c);
                rowObj2.CURRENCY_VALUE = String.valueOf(soi.CurrencyIsoCode);
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
/**  Sandip Atkari 03/11/2019 - Start Here  */
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushSalesOrderService.cls_row_conditions rowObj2 = new BrazilPushSalesOrderService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZBR1';
                rowObj2.COND_VALUE = String.valueOf(soi.Net_Price__c); // chanage mapping field - not yet finalised
                rowObj2.CURRENCY_VALUE = String.valueOf(soi.CurrencyIsoCode);
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushSalesOrderService.cls_row_conditions rowObj2 = new BrazilPushSalesOrderService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZPER';
                rowObj2.COND_VALUE = String.valueOf(soi.Discount__c);
                rowObj2.CURRENCY_VALUE = '';
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushSalesOrderService.cls_row_conditions rowObj2 = new BrazilPushSalesOrderService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZACA';
                rowObj2.COND_VALUE = String.valueOf(soi.Total_Interest_Rate__c); // change mapping field - discount to interest rate percentage - formula
                rowObj2.CURRENCY_VALUE = '';
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
            
/**  Sandip Atkari 03/11/2019 - End Here  */
            //End Order Conditions
            
            //Start Order Items
            bpsObj.Tables.ORDER_ITEMS_IN = new BrazilPushSalesOrderService.cls_ORDER_ITEMS_IN();
            bpsObj.Tables.ORDER_ITEMS_IN.row_items = new List<BrazilPushSalesOrderService.cls_row_items>();
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushSalesOrderService.cls_row_items rowObj3 = new BrazilPushSalesOrderService.cls_row_items();
                rowObj3.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj3.MATERIAL = soi.SKU_Code__c;
                rowObj3.BILL_DATE = String.valueOf(soi.DateofFAT__c);
                rowObj3.PLANT = owObj.soObj.Sold_to_Party__r.Brazil_Depot_Code__r.Depot_Code__c;//soi.Depot_Code__c;
                rowObj3.TARGET_QTY = soi.Quantity__c;
                rowObj3.TARGET_QU = soi.SKU_Name__r.UOM__c;
                rowObj3.PO_DAT_S = ''; //'2017-11-02'
                rowObj3.USAGE_IND = soi.Culture__r.Culture_Code__c; //'B01';
                bpsObj.Tables.ORDER_ITEMS_IN.row_items.add(rowObj3);  
                rowObj3.PO_ITM_NO = soi.Product_PO_item_number__c; //Deeksha :SCTASK0216504
                rowObj3.HG_LV_ITEM = soi.Kit_Item_Number__c;//Modified by Deeksha for kit selling Project
                rowObj3.ITEM_CATEG = soi.Item_Category__c;//Modified by Deeksha for kit selling Project
            }
            //End Order Items
            
            //Start Order Partners
            bpsObj.Tables.ORDER_PARTNERS = new BrazilPushSalesOrderService.cls_ORDER_PARTNERS();
            bpsObj.Tables.ORDER_PARTNERS.row_partners = new List<BrazilPushSalesOrderService.cls_row_partners>();
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushSalesOrderService.cls_row_partners rowObj4 = new BrazilPushSalesOrderService.cls_row_partners();
                rowObj4.PARTN_ROLE = 'AG';
                rowObj4.PARTN_NUMB = owObj.soObj.Sold_to_Party__r.SAP_Code__c;
                bpsObj.Tables.ORDER_PARTNERS.row_partners.add(rowObj4); 
                
                BrazilPushSalesOrderService.cls_row_partners rowObj5 = new BrazilPushSalesOrderService.cls_row_partners();
                rowObj5.PARTN_ROLE = 'Z1';
                rowObj5.PARTN_NUMB = owObj.tmCode; //'57000637';
                bpsObj.Tables.ORDER_PARTNERS.row_partners.add(rowObj5);
                
/**  Sandip Atkari 03/11/2019 - Start Here  */
                BrazilPushSalesOrderService.cls_row_partners rowObj6 = new BrazilPushSalesOrderService.cls_row_partners();
                rowObj6.PARTN_ROLE = 'WE';
                rowObj6.PARTN_NUMB = owObj.soObj.Ship_To_Party__r.SAP_Code__c; 
                bpsObj.Tables.ORDER_PARTNERS.row_partners.add(rowObj6);
/**  Sandip Atkari 03/11/2019 - End Here  */
            }
            
            //End Order Partners
            
            //Start Order Text
            bpsObj.Tables.ORDER_TEXT = new BrazilPushSalesOrderService.cls_ORDER_TEXT();
            bpsObj.Tables.ORDER_TEXT.row_text = new List<BrazilPushSalesOrderService.cls_row_text>();
            
            //for(Sales_Order_Line_Item__c soi:owObj.itemList){
            BrazilPushSalesOrderService.cls_row_text rowObj5 = new BrazilPushSalesOrderService.cls_row_text();
            rowObj5.ITM_NUMBER = '000000'; //String.valueOf(soi.Item_Number__c);
            rowObj5.LANGU = 'P';
            rowObj5.TEXT_ID = '0001';
            rowObj5.TEXT_LINE = owObj.soObj.Invoice_Message__c;
            bpsObj.Tables.ORDER_TEXT.row_text.add(rowObj5);

/**  Sandip Atkari 03/11/2019 - Start Here  */          
            BrazilPushSalesOrderService.cls_row_text rowObj6 = new BrazilPushSalesOrderService.cls_row_text();
            rowObj6.ITM_NUMBER = '000000'; //String.valueOf(soi.Item_Number__c);
            rowObj6.LANGU = 'P';
            rowObj6.TEXT_ID = 'Z058';
            rowObj6.TEXT_LINE = owObj.soObj.Price_Book__r.Campaign_Number__c;
            bpsObj.Tables.ORDER_TEXT.row_text.add(rowObj6);
/*
            BrazilPushSalesOrderService.cls_row_text rowObj7 = new BrazilPushSalesOrderService.cls_row_text();
            rowObj7.ITM_NUMBER = '000000'; //String.valueOf(soi.Item_Number__c);
            rowObj7.LANGU = 'P';
            rowObj7.TEXT_ID = 'Z059';
            rowObj7.TEXT_LINE = ''+owObj.soObj.Expected_Number_of_days__c;
            bpsObj.Tables.ORDER_TEXT.row_text.add(rowObj7);
*/
/**  Sandip Atkari 03/11/2019 - End Here  */
            //}
            
            //End Order Text        
            
            /*
            * End of Wrapper Creation
            */
            
            String json = System.JSON.serializePretty(bpsObj);
            
            System.debug('json: '+json);
            
            request.setBody(json);
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"example":"test"}');
                response.setStatusCode(200);
            }
            
            System.debug('The status code returned was : ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('=====response.getBody()====='+response.getBody());
            
            //Save a entry of Request/Response against Sales Order in Monitor Log for debugging purpose
            //Params are Request, Response, Status Code, Class Name, Method Name, SalesOrder Id, SalesOrder Owner Id
            ApexLog.webServiceLog(json, response.getBody(), response.getStatusCode(), 'BrazilHANAServiceHelper', 'pushSalesOrder', recordId, owObj.soObj.OwnerId);
        }
        catch(Exception ex){
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerBrazil(ex, owObj.soObj.Sold_to_Party__c, owObj.soObj, JSON.serializePretty(owObj.itemList));
            
            //Add an entry to Transaction Log
            TransactionLogHandler.addTransactionEntry(ex, owObj.soObj);
        }   
    }
    
    //Method to load BrazilPushContractService and call the REST servive
    //Note: JSON is hardcoded at the moment, dynamic request from Salesforce yet to be done. Waiting for clarfication from UPL
    @future(callout=true)
    webservice static void pushContract(String recordId){
        
        //Get Order & LineItems Data in Wrapper
        OrderWrapper owObj = getOrderWrapper(recordId);
        
        try{
            String url = '';
            
            if(isSandbox()){
                //Sandbox
                url = 'https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/pushContract'; 
            }
            else{
                //Production
                url = 'https://l4039-iflmap.hcisbp.eu1.hana.ondemand.com/http/pushContract'; 
            }
            
            Integer timeOut = 120000;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();        
            
            // Set time out in milliseconds
            request.setTimeout(timeOut);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c;
            
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            
            request.setHeader('Authorization', authorizationHeader);
            
            request.setEndpoint(url);
            
            /*
            * Starting Wrapper Creation
            */
            
            BrazilPushContractService bpsObj = new BrazilPushContractService();
            
            //Get Sales Order
            bpsObj.ImportHeaders = new BrazilPushContractService.cls_ImportHeaders();
            //Get Related Items to Sales Order
            bpsObj.Tables = new BrazilPushContractService.cls_Tables();
            
            //Start Header (Sales Order)
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN = new BrazilPushContractService.cls_CONTRACT_HEADER_IN();
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.SAP_USER = owObj.UGDN;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.DOC_TYPE = 'ZMAE';
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.SALES_ORG = 5191;
            String depotCode = owObj.soObj.Sold_to_Party__r.Brazil_Depot_Code__r.Depot_Code__c;
            
            Integer distributionChannel = 20;
            if(depotCode=='BR00'){
                distributionChannel = 10;
            }
            
            String DivID = owObj.soObj.Price_Book__r.Division__r.Division_Code__c;
            if(String.isNotBlank(DivID)){
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.DIVISION = DivID;
            }else{
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.DIVISION = '10';
            }
           
            
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.DISTR_CHAN = distributionChannel;
          //  bpsObj.ImportHeaders.CONTRACT_HEADER_IN.DIVISION = Integer.valueOf(owObj.soObj.Price_Book__r.Division__r.Division_Code__c);
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.SALES_OFF = owObj.soObj.Region_Territory__r.Zone__r.ZoneCode__c; //'BR20';
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PURCH_DATE = String.valueOf(owObj.soObj.Purchase_Order_Date__c);
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.REF_1 = owObj.soObj.SFDC_Order_Number__c;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.SALES_DIST = owObj.soObj.Region_Territory__r.Region__r.RegionCode__c;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.INCOTERMS1 = owObj.soObj.Inco_Term__r.IncoTerm_Code__c;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.INCOTERMS2 = '.';
           // bpsObj.ImportHeaders.CONTRACT_HEADER_IN.FIX_VAL_DY = String.valueOf(owObj.soObj.Maturity_Date__c);
            //bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PMNTTRMS = owObj.soObj.Payment_Term__r.Payment_Term_Code__c;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.CT_VALID_F = String.valueOf(owObj.soObj.Valid_From__c);
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.CT_VALID_T = String.valueOf(owObj.soObj.Valid_To__c);
/**  Sandip Atkari 03/11/2019 - Start Here  */
            
             //Maturity update added by ganesh 26/3/2019
            String maturityDate = String.valueOf(owObj.soObj.Maturity_Date__c);
            String CampaignDate = String.valueOf(owObj.soObj.Campaign_Payment_Term_Date__c);
            
            if(String.isNotBlank(maturityDate) || String.isNotBlank(CampaignDate)){
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PMNTTRMS = 'BR71';
            }else{
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PMNTTRMS = owObj.soObj.Payment_Term__r.Payment_Term_Code__c;  
            }
          
            if(String.isNotBlank(maturityDate)){
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.FIX_VAL_DY = maturityDate;
            }else if(String.isNotBlank(CampaignDate)){    
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.FIX_VAL_DY = CampaignDate;
            }
            //Change end
			if(owObj.soObj.Kit_Order__c){//Modified by Deeksha for kit selling Project
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PO_METHOD = 'OVPK';     //Modified by Deeksha for kit selling Project       
            }else if(owObj.soObj.Pronutiva__c){
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PO_METHOD = 'OVPP';
            }else if(owObj.soObj.Directed_Sales__c){
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PO_METHOD = 'OVPD';
            }else{
                bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PO_METHOD = 'OVPT';
            }
/**  Sandip Atkari 03/11/2019 - End Here  */ 

            String territoryCode = owObj.soObj.Region_Territory__r.TerritoryCode__c;
            if(String.isNotBlank(territoryCode)){
                territoryCode = territoryCode.remove('BR');
            }
            
            String sbuCode = owObj.soObj.Region_Territory__r.SBU__r.SBUCode__c;        
            if(String.isNotBlank(sbuCode)){
                //sbuCode = sbuCode.remove('BR');
            }      
            
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.CUST_GRP1 = territoryCode;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.CUST_GRP2 =  sbuCode; //'BR2';
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PURCH_NO_C = owObj.soObj.Purchase_Order_no__c;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.SD_DOC_CAT = 'G';
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.DOC_DATE = String.valueOf(Date.valueOf(owObj.soObj.CreatedDate));
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.PYMT_METH = owObj.soObj.PaymentMethod__r.Payment_Method_Code__c;
            bpsObj.ImportHeaders.CONTRACT_HEADER_IN.CURRENCY_VALUE = owObj.headerCurrency; //String.valueOf(owObj.soObj.CurrencyISOCode);
            //End Header
            
            //Start Order Conditions
            bpsObj.Tables.CONTRACT_CONDITIONS_IN = new BrazilPushContractService.cls_CONTRACT_CONDITIONS_IN();
            bpsObj.Tables.CONTRACT_CONDITIONS_IN.row_conditions = new List<BrazilPushContractService.cls_row_conditions>();
            
            BrazilPushContractService.cls_row_conditions rowObj = new BrazilPushContractService.cls_row_conditions();
            rowObj.ITM_NUMBER = '000000';
            rowObj.COND_TYPE = 'ZBRD';
            rowObj.COND_VALUE = String.valueOf(owObj.soObj.Punctuality_Discount__c);//String.valueOf(owObj.discountValue);
            rowObj.CURRENCY_VALUE = '';     //owObj.itemCurrency; //String.valueOf(owObj.soObj.CurrencyISOCode);
            bpsObj.Tables.CONTRACT_CONDITIONS_IN.row_conditions.add(rowObj); 

            //Added business discount mapping in condition GRZ(Nikhil Verma) RITM0419745 date 13-09-2022
            BrazilPushContractService.cls_row_conditions rowObjData = new BrazilPushContractService.cls_row_conditions();
            rowObjData.ITM_NUMBER = '000000';
            rowObjData.COND_TYPE = 'ZBTE';
            rowObjData.COND_VALUE = String.valueOf(owObj.soObj.Business_Discount__c);
            rowObjData.CURRENCY_VALUE = '';
            bpsObj.Tables.CONTRACT_CONDITIONS_IN.row_conditions.add(rowObjData); 
            // ----------End here GRZ(Nikhil Verma) RITM0419745 date 13-09-2022  
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushContractService.cls_row_conditions rowObj2 = new BrazilPushContractService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZBR0';
                rowObj2.COND_VALUE = String.valueOf(soi.UnitValue__c);
                rowObj2.CURRENCY_VALUE = String.valueOf(soi.CurrencyIsoCode);
                bpsObj.Tables.CONTRACT_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
/**  Sandip Atkari 03/11/2019 - Start Here  */
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushContractService.cls_row_conditions rowObj2 = new BrazilPushContractService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZBR1';
                rowObj2.COND_VALUE = String.valueOf(soi.Net_Price__c); // chanage mapping field - not yet finalised
                rowObj2.CURRENCY_VALUE = String.valueOf(soi.CurrencyIsoCode);
                bpsObj.Tables.CONTRACT_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushContractService.cls_row_conditions rowObj2 = new BrazilPushContractService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZPER';
                rowObj2.COND_VALUE = String.valueOf(soi.Discount__c);
                rowObj2.CURRENCY_VALUE = '';
                bpsObj.Tables.CONTRACT_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushContractService.cls_row_conditions rowObj2 = new BrazilPushContractService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZACA';
                rowObj2.COND_VALUE = String.valueOf(soi.Total_Interest_Rate__c); // change mapping field - discount to interest rate percentage - formula
                rowObj2.CURRENCY_VALUE = '';
                bpsObj.Tables.CONTRACT_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
/**  Sandip Atkari 03/11/2019 - End Here  */
            //End Order Conditions
            
            //Start Order Items
            bpsObj.Tables.CONTRACT_ITEMS_IN = new BrazilPushContractService.cls_CONTRACT_ITEMS_IN();
            bpsObj.Tables.CONTRACT_ITEMS_IN.row_items = new List<BrazilPushContractService.cls_row_items>();
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushContractService.cls_row_items rowObj3 = new BrazilPushContractService.cls_row_items();
                rowObj3.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj3.MATERIAL = soi.SKU_Code__c;
                rowObj3.BILL_DATE = String.valueOf(soi.DateofFAT__c);
                rowObj3.PLANT = owObj.soObj.Sold_to_Party__r.Brazil_Depot_Code__r.Depot_Code__c; //soi.Depot_Code__c;
                rowObj3.TARGET_QTY = soi.Quantity__c;
                rowObj3.TARGET_QU = soi.SKU_Name__r.UOM__c;
                rowObj3.PO_DAT_S = ''; //'2017-11-02'
                rowObj3.USAGE_IND = soi.Culture__r.Culture_Code__c; //'B01';
                rowObj3.PO_ITM_NO = soi.Product_PO_item_number__c; //Deeksha :SCTASK0216504
                rowObj3.HG_LV_ITEM = soi.Kit_Item_Number__c;//Modified by Deeksha for kit selling Project
                rowObj3.ITEM_CATEG = soi.Item_Category__c;//Modified by Deeksha for kit selling Project
                bpsObj.Tables.CONTRACT_ITEMS_IN.row_items.add(rowObj3);              
            }
            //End Order Items
            
            //Start Order Partners
            bpsObj.Tables.CONTRACT_PARTNERS = new BrazilPushContractService.cls_CONTRACT_PARTNERS();
            bpsObj.Tables.CONTRACT_PARTNERS.row_partners = new List<BrazilPushContractService.cls_row_partners>();
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushContractService.cls_row_partners rowObj4 = new BrazilPushContractService.cls_row_partners();
                rowObj4.PARTN_ROLE = 'AG';
                rowObj4.PARTN_NUMB = owObj.soObj.Sold_to_Party__r.SAP_Code__c;
                bpsObj.Tables.CONTRACT_PARTNERS.row_partners.add(rowObj4); 
                
                BrazilPushContractService.cls_row_partners rowObj5 = new BrazilPushContractService.cls_row_partners();
                rowObj5.PARTN_ROLE = 'Z1';
                rowObj5.PARTN_NUMB = owObj.tmCode; //'57000637';
                bpsObj.Tables.CONTRACT_PARTNERS.row_partners.add(rowObj5);    
                
/** Sandip Atkari 11/03/2019 Start Here   */                
                BrazilPushContractService.cls_row_partners rowObj6 = new BrazilPushContractService.cls_row_partners();
                rowObj6.PARTN_ROLE = 'WE';
                rowObj6.PARTN_NUMB = owObj.soObj.Ship_to_Party__r.SAP_Code__c; //'57000637';
                bpsObj.Tables.CONTRACT_PARTNERS.row_partners.add(rowObj6);
/** Sandip Atkari 11/03/2019 End Here   */                
            }
            
            //End Order Partners
            
            //Start Order Text
            bpsObj.Tables.CONTRACT_TEXT = new BrazilPushContractService.cls_CONTRACT_TEXT();
            bpsObj.Tables.CONTRACT_TEXT.row_text = new List<BrazilPushContractService.cls_row_text>();
            
            //for(Sales_Order_Line_Item__c soi:owObj.itemList){
            BrazilPushContractService.cls_row_text rowObj5 = new BrazilPushContractService.cls_row_text();
            rowObj5.ITM_NUMBER = '000000';//String.valueOf(soi.Item_Number__c);
            rowObj5.LANGU = 'P';
            rowObj5.TEXT_ID = '0001';
            rowObj5.TEXT_LINE = owObj.soObj.Invoice_Message__c;
            bpsObj.Tables.CONTRACT_TEXT.row_text.add(rowObj5);
/** Sandip Atkari 11/03/2019 Start Here   */
            BrazilPushContractService.cls_row_text rowObj6 = new BrazilPushContractService.cls_row_text();
            rowObj6.ITM_NUMBER = '000000';//String.valueOf(soi.Item_Number__c);
            rowObj6.LANGU = 'P';
            rowObj6.TEXT_ID = 'Z058';
            rowObj6.TEXT_LINE = owObj.soObj.Price_Book__r.Campaign_Number__c;
            bpsObj.Tables.CONTRACT_TEXT.row_text.add(rowObj6);
/*
            BrazilPushContractService.cls_row_text rowObj7 = new BrazilPushContractService.cls_row_text();
            rowObj7.ITM_NUMBER = '000000';//String.valueOf(soi.Item_Number__c);
            rowObj7.LANGU = 'P';
            rowObj7.TEXT_ID = 'Z059';
            rowObj7.TEXT_LINE = ''+owObj.soObj.Expected_Number_of_days__c;
            bpsObj.Tables.CONTRACT_TEXT.row_text.add(rowObj7);
*/            
/** Sandip Atkari 11/03/2019 End Here   */
            //}
            
            //End Order Text        
            
            /*
            * End of Wrapper Creation
            */
            
            String json = System.JSON.serializePretty(bpsObj);
            
            System.debug('json: '+json);
            
            request.setBody(json);
            
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"example":"test"}');
                response.setStatusCode(200);
            }
            
            System.debug('The status code returned was : ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('=====response.getBody()====='+response.getBody());
            
            ApexLog.webServiceLog(json, response.getBody(), response.getStatusCode(), 'BrazilHANAServiceHelper', 'pushContract', recordId, owObj.soObj.OwnerId);
        }
        catch(Exception ex){
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerBrazil(ex, owObj.soObj.Sold_to_Party__c, owObj.soObj, JSON.serializePretty(owObj.itemList));
            
            //Add an entry to Transaction Log
            TransactionLogHandler.addTransactionEntry(ex, owObj.soObj);            
        }  
    }
    
    //Method to load BrazilPushMaefilService and call the REST servive 
    //Note: JSON is hardcoded at the moment, dynamic request from Salesforce yet to be done. Waiting for clarfication from UPL
    @future(callout=true)
    webservice static void pushMaefil(String recordId){
        //Get Order & LineItems Data in Wrapper
        OrderWrapper owObj = getOrderWrapper(recordId);   
        
        try{
            String url = '';
            
            if(isSandbox( )){
                //Sandbox
                url = 'https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/PushMaefil';
                	   
            }
            else{
                //Production
                url = 'https://l4039-iflmap.hcisbp.eu1.hana.ondemand.com/http/PushMaefil'; 
            }
            
            Integer timeOut = 120000;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();        
            
            // Set time out in milliseconds
            request.setTimeout(timeOut);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c;
            
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            
            request.setHeader('Authorization', authorizationHeader);
            
            //Set endpoint url of service
            request.setEndpoint(url); 
            
            /*
            * Starting Wrapper Creation
            */
            BrazilPushMaefilService bpsObj = new BrazilPushMaefilService();
            
            //Get Sales Order
            bpsObj.ImportHeaders = new BrazilPushMaefilService.cls_ImportHeaders();
            //Get Related Items to Sales Order
            bpsObj.Tables = new BrazilPushMaefilService.cls_Tables();
            
            //Start Header (Sales Order)
            bpsObj.ImportHeaders.ORDER_HEADER_IN = new BrazilPushMaefilService.cls_ORDER_HEADER_IN();
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SAP_USER = owObj.UGDN;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_TYPE = 'ZFIL';
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SALES_ORG = 5191;
            String depotCode = owObj.soObj.Sold_to_Party__r.Brazil_Depot_Code__r.Depot_Code__c;
            Integer distributionChannel = 20;
            if(depotCode=='BR00'){
                distributionChannel = 10;
            }
            
            String DivID = owObj.soObj.Price_Book__r.Division__r.Division_Code__c;
            if(String.isNotBlank(DivID)){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.DIVISION = DivID;
            }else{
                bpsObj.ImportHeaders.ORDER_HEADER_IN.DIVISION = '10';
            }
          
            
            bpsObj.ImportHeaders.ORDER_HEADER_IN.DISTR_CHAN = distributionChannel;
          //  bpsObj.ImportHeaders.ORDER_HEADER_IN.DIVISION = Integer.valueOf(owObj.soObj.Price_Book__r.Division__r.Division_Code__c);
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SALES_OFF = owObj.soObj.Region_Territory__r.Zone__r.ZoneCode__c; //'BR20';
            bpsObj.ImportHeaders.ORDER_HEADER_IN.PURCH_DATE = String.valueOf(owObj.soObj.Purchase_Order_Date__c);
            bpsObj.ImportHeaders.ORDER_HEADER_IN.REF_DOC = owObj.soObj.Sales_Order__r.SAP_Order_Number__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.REFDOC_CAT = 'G';
            bpsObj.ImportHeaders.ORDER_HEADER_IN.REF_1 = owObj.soObj.SFDC_Order_Number__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SALES_DIST = owObj.soObj.Region_Territory__r.Region__r.RegionCode__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.INCOTERMS1 = owObj.soObj.Inco_Term__r.IncoTerm_Code__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.INCOTERMS2 = '.';
           // bpsObj.ImportHeaders.ORDER_HEADER_IN.FIX_VAL_DY = String.valueOf(owObj.soObj.Maturity_Date__c);
           // bpsObj.ImportHeaders.ORDER_HEADER_IN.PMNTTRMS = owObj.soObj.Payment_Term__r.Payment_Term_Code__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CT_VALID_F = String.valueOf(owObj.soObj.Valid_From__c);
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CT_VALID_T = String.valueOf(owObj.soObj.Valid_To__c);
/**  Sandip Atkari 03/11/2019 - Start Here  */
            
             //Maturity update added by ganesh 26/3/2019
            String maturityDate = String.valueOf(owObj.soObj.Maturity_Date__c);
            String CampaignDate = String.valueOf(owObj.soObj.Campaign_Payment_Term_Date__c);
          
            if(String.isNotBlank(maturityDate) || String.isNotBlank(CampaignDate)){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PMNTTRMS = 'BR71';
            }else{
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PMNTTRMS = owObj.soObj.Payment_Term__r.Payment_Term_Code__c;  
            }
            if(String.isNotBlank(maturityDate)){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.FIX_VAL_DY = maturityDate;
            }else if(String.isNotBlank(CampaignDate)){    
                bpsObj.ImportHeaders.ORDER_HEADER_IN.FIX_VAL_DY = CampaignDate;
            }
            //Change end
            //Modified by Deeksha for kit selling Project
            if(owObj.soObj.Kit_Order__c){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPK';
            }else if(owObj.soObj.Pronutiva__c){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPP';
            }else if(owObj.soObj.Directed_Sales__c){
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPD';
            }else{
                bpsObj.ImportHeaders.ORDER_HEADER_IN.PO_METHOD = 'OVPT';
            }
/**  Sandip Atkari 03/11/2019 - End Here  */
            
            String territoryCode = owObj.soObj.Region_Territory__r.TerritoryCode__c;
            if(String.isNotBlank(territoryCode)){
                territoryCode = territoryCode.remove('BR');
            }
            
            String sbuCode = owObj.soObj.Region_Territory__r.SBU__r.SBUCode__c;        
            if(String.isNotBlank(sbuCode)){
                //sbuCode = sbuCode.remove('BR');
            }      
            
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CUST_GRP1 = territoryCode;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CUST_GRP2 =  sbuCode; //'BR2';
            bpsObj.ImportHeaders.ORDER_HEADER_IN.PURCH_NO_C = owObj.soObj.Purchase_Order_no__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.SD_DOC_CAT = ''; //'C'
            bpsObj.ImportHeaders.ORDER_HEADER_IN.DOC_DATE = String.valueOf(Date.valueOf(owObj.soObj.CreatedDate));
            bpsObj.ImportHeaders.ORDER_HEADER_IN.PYMT_METH = owObj.soObj.PaymentMethod__r.Payment_Method_Code__c;
            bpsObj.ImportHeaders.ORDER_HEADER_IN.CURRENCY_VALUE = owObj.headerCurrency; //String.valueOf(owObj.soObj.CurrencyISOCode);
            //End Header
            
            //Start Order Conditions
            bpsObj.Tables.ORDER_CONDITIONS_IN = new BrazilPushMaefilService.cls_ORDER_CONDITIONS_IN();
            bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions = new List<BrazilPushMaefilService.cls_row_conditions>();
            
            BrazilPushMaefilService.cls_row_conditions rowObj = new BrazilPushMaefilService.cls_row_conditions();
            rowObj.ITM_NUMBER = '000000';
            rowObj.COND_TYPE = 'ZBRD';
            rowObj.COND_VALUE = String.valueOf(owObj.soObj.Punctuality_Discount__c);//String.valueOf(owObj.discountValue);
            rowObj.CURRENCY_VALUE ='';      // owObj.itemCurrency; //String.valueOf(owObj.soObj.CurrencyISOCode);
            bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj);         

            //Added business discount mapping in condition GRZ(Nikhil Verma) RITM0419745 date 13-09-2022
            BrazilPushMaefilService.cls_row_conditions rowObjData = new BrazilPushMaefilService.cls_row_conditions();
            rowObjData.ITM_NUMBER = '000000';
            rowObjData.COND_TYPE = 'ZBTE';
            rowObjData.COND_VALUE = String.valueOf(owObj.soObj.Business_Discount__c);
            rowObjData.CURRENCY_VALUE = '';
            bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObjData); 
            // ----------End here GRZ(Nikhil Verma) RITM0419745 date 13-09-2022
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushMaefilService.cls_row_conditions rowObj2 = new BrazilPushMaefilService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZBR0';
                rowObj2.COND_VALUE = String.valueOf(soi.UnitValue__c);
                rowObj2.CURRENCY_VALUE = String.valueOf(soi.CurrencyIsoCode);
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
/**  Sandip Atkari 03/11/2019 - Start Here  */
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushMaefilService.cls_row_conditions rowObj2 = new BrazilPushMaefilService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZBR1';
                rowObj2.COND_VALUE = String.valueOf(soi.Net_Price__c); // chanage mapping field - not yet finalised
                rowObj2.CURRENCY_VALUE = String.valueOf(soi.CurrencyIsoCode);
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushMaefilService.cls_row_conditions rowObj2 = new BrazilPushMaefilService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZPER';
                rowObj2.COND_VALUE = String.valueOf(soi.Discount__c);
                rowObj2.CURRENCY_VALUE = '';
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushMaefilService.cls_row_conditions rowObj2 = new BrazilPushMaefilService.cls_row_conditions();
                rowObj2.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj2.COND_TYPE = 'ZACA';
                rowObj2.COND_VALUE = String.valueOf(soi.Total_Interest_Rate__c); // change mapping field - discount to interest rate percentage - formula
                rowObj2.CURRENCY_VALUE = '';
                bpsObj.Tables.ORDER_CONDITIONS_IN.row_conditions.add(rowObj2);               
            }
/**  Sandip Atkari 03/11/2019 - End Here  */
            //End Order Conditions
            
            //Start Order Items
            bpsObj.Tables.ORDER_ITEMS_IN = new BrazilPushMaefilService.cls_ORDER_ITEMS_IN();
            bpsObj.Tables.ORDER_ITEMS_IN.row_items = new List<BrazilPushMaefilService.cls_row_items>();
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushMaefilService.cls_row_items rowObj3 = new BrazilPushMaefilService.cls_row_items();
                rowObj3.ITM_NUMBER = String.valueOf(soi.Item_Number__c);
                rowObj3.MATERIAL = soi.SKU_Code__c;
                rowObj3.BILL_DATE = String.valueOf(soi.DateofFAT__c);
                rowObj3.PLANT = owObj.soObj.Sold_to_Party__r.Brazil_Depot_Code__r.Depot_Code__c;//soi.Depot_Code__c;
                rowObj3.TARGET_QTY = soi.Quantity__c;
                rowObj3.TARGET_QU = soi.SKU_Name__r.UOM__c;
                rowObj3.PO_DAT_S = ''; //'2017-11-02'
                rowObj3.USAGE_IND = soi.Culture__r.Culture_Code__c; //'B01';
                rowObj3.REF_DOC = owObj.soObj.Sales_Order__r.SAP_Order_Number__c; //SAP Order Number of Mother
                rowObj3.REF_DOC_IT = String.valueOf(soi.Sales_Order_Line_Item__r.Item_Number__c); //Item Number of parent
                rowObj3.REF_DOC_CA = 'G'; //If Child - Send 'C'
                rowObj3.PO_ITM_NO = soi.Product_PO_item_number__c; //Deeksha :SCTASK0216504
                rowObj3.HG_LV_ITEM = soi.Kit_Item_Number__c;//Modified by Deeksha for kit selling Project
                rowObj3.ITEM_CATEG = soi.Item_Category__c;//Modified by Deeksha for kit selling Project
                bpsObj.Tables.ORDER_ITEMS_IN.row_items.add(rowObj3);              
            }
            //End Order Items
            
            //Start Order Partners
            bpsObj.Tables.ORDER_PARTNERS = new BrazilPushMaefilService.cls_ORDER_PARTNERS();
            bpsObj.Tables.ORDER_PARTNERS.row_partners = new List<BrazilPushMaefilService.cls_row_partners>();
            
            for(Sales_Order_Line_Item__c soi:owObj.itemList){
                BrazilPushMaefilService.cls_row_partners rowObj4 = new BrazilPushMaefilService.cls_row_partners();
                rowObj4.PARTN_ROLE = 'AG';
                rowObj4.PARTN_NUMB = owObj.soObj.Sold_to_Party__r.SAP_Code__c;
                bpsObj.Tables.ORDER_PARTNERS.row_partners.add(rowObj4); 
                
                BrazilPushMaefilService.cls_row_partners rowObj5 = new BrazilPushMaefilService.cls_row_partners();
                rowObj5.PARTN_ROLE = 'Z1';
                rowObj5.PARTN_NUMB = owObj.tmCode; //'57000637';
                bpsObj.Tables.ORDER_PARTNERS.row_partners.add(rowObj5);     
                
/**  Sandip Atkari 03/11/2019 - Start Here  */
                BrazilPushMaefilService.cls_row_partners rowObj6 = new BrazilPushMaefilService.cls_row_partners();
                rowObj6.PARTN_ROLE = 'WE';
                rowObj6.PARTN_NUMB = owObj.soObj.Ship_To_Party__r.SAP_Code__c; 
                bpsObj.Tables.ORDER_PARTNERS.row_partners.add(rowObj6);
/**  Sandip Atkari 03/11/2019 - End Here  */
            }
            
            //End Order Partners
            
            //Start Order Text
            bpsObj.Tables.ORDER_TEXT = new BrazilPushMaefilService.cls_ORDER_TEXT();
            bpsObj.Tables.ORDER_TEXT.row_text = new List<BrazilPushMaefilService.cls_row_text>();
            
            //for(Sales_Order_Line_Item__c soi:owObj.itemList){
            BrazilPushMaefilService.cls_row_text rowObj5 = new BrazilPushMaefilService.cls_row_text();
            rowObj5.ITM_NUMBER = '000000';//String.valueOf(soi.Item_Number__c);
            rowObj5.LANGU = 'P';
            rowObj5.TEXT_ID = '0001';
            rowObj5.TEXT_LINE = owObj.soObj.Invoice_Message__c;
            bpsObj.Tables.ORDER_TEXT.row_text.add(rowObj5);

/**  Sandip Atkari 03/11/2019 - Start Here  */          
            BrazilPushMaefilService.cls_row_text rowObj6 = new BrazilPushMaefilService.cls_row_text();
            rowObj6.ITM_NUMBER = '000000'; //String.valueOf(soi.Item_Number__c);
            rowObj6.LANGU = 'P';
            rowObj6.TEXT_ID = 'Z058';
            rowObj6.TEXT_LINE = owObj.soObj.Price_Book__r.Campaign_Number__c;
            bpsObj.Tables.ORDER_TEXT.row_text.add(rowObj6);
/*
            BrazilPushMaefilService.cls_row_text rowObj7 = new BrazilPushMaefilService.cls_row_text();
            rowObj7.ITM_NUMBER = '000000'; //String.valueOf(soi.Item_Number__c);
            rowObj7.LANGU = 'P';
            rowObj7.TEXT_ID = 'Z059';
            rowObj7.TEXT_LINE = ''+owObj.soObj.Expected_Number_of_days__c;
            bpsObj.Tables.ORDER_TEXT.row_text.add(rowObj7);
*/
/**  Sandip Atkari 03/11/2019 - End Here  */
            //}
            
            //End Order Text        
            
            /*
            * End of Wrapper Creation
            */
            
            String json = System.JSON.serializePretty(bpsObj);
            
            System.debug('json: '+json);
            
            request.setBody(json);
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"example":"test"}');
                response.setStatusCode(200);
            }        
            System.debug('The status code returned was : ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('=====response.getBody()====='+response.getBody());
            
            ApexLog.webServiceLog(json, response.getBody(), response.getStatusCode(), 'BrazilHANAServiceHelper', 'pushMaefil', recordId, owObj.soObj.OwnerId);
        }
        catch(Exception ex){
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerBrazil(ex, owObj.soObj.Sold_to_Party__c, owObj.soObj, JSON.serializePretty(owObj.itemList));
            
            //Add an entry to Transaction Log
            TransactionLogHandler.addTransactionEntry(ex, owObj.soObj);
        }  
    }
    
    public static Boolean isSandbox() {
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
    //Method will return SBU UGDN when Sales Order Owner is a Open User
    public static String getKEDE(String ownerId){
        String UGDN = '';
        List<Territory_Distributor__c> tdList = [SELECT ID, Open_TM_Code__c, TM_Code__c, SBU__r.SBUUser__r.UGDN_Number__c
                                                 FROM Territory_Distributor__c 
                                                 WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                 AND TerritoryManagerActive__c = True
                                                 AND TerritoryManager__c=: ownerId];
        
        
        //System.debug('Territory_Distributor List: '+tdList);
        
        if(!tdList.isEmpty()){
            UGDN = tdList[0].SBU__r.SBUUser__r.UGDN_Number__c;
        }
        
        return UGDN;
    }
    
    public static OrderWrapper getOrderWrapper(String recordId){
        String TMCode = '';
        OrderWrapper owObj = new OrderWrapper();
        
        owObj.soObj = [SELECT Id,Business_Discount__c,Kit_Order__c,Purchase_Order_Type__c, SFDC_Order_Number__c, Purchase_Order_Date__c, OwnerId, CreatedDate, Currency_Brazil__c,
                       Sales_District__c,Region_Territory__r.TM_Code__c, Inco_Term__c, Payment_Term__r.Payment_Term_Code__c, Invoice_Message__c,
                       Region_Territory__r.TerritoryCode__c, Region_Territory__r.SBU__r.SBUCode__c, Type_of_Order__c,
                       Region_Territory__r.TerritoryManagerActive__c, Region_Territory__r.Zone__r.ZoneCode__c, Sales_Order__r.SAP_Order_Number__c,Punctuality_Discount__c,
                       Sold_to_Party__r.Group_Name__c, Price_Book__r.Division__r.Division_Code__c,Region_Territory__r.Open_TM_Code__c,
                       Sold_to_Party__r.SAP_Code__c, Region_Territory__r.Region__r.RegionCode__c, Maturity_Date__c,
                       Valid_From__c, Valid_To__c, Sold_to_Party__r.Customer_Group__c, CurrencyISOCode,Campaign_Payment_Term_Date__c,
                       Sold_to_Party__r.Brazil_Depot_Code__r.Depot_Code__c, Inco_Term__r.IncoTerm_Code__c, 
                       Purchase_Order_no__c, PaymentMethod__r.Payment_Method_Code__c , SAP_Order_Number__c,
                       Pronutiva__c,Directed_Sales__c,Expected_Number_of_days__c,Ship_To_Party__c,Ship_To_Party__r.SAP_Code__c,Price_Book__r.Campaign_Number__c
                       FROM Sales_Order__c
                       WHERE Id =: recordId];    //Modified by Deeksha for kit selling Project:Added Purchase_Order_Type__c
        
        owObj.itemList = [SELECT ID, Kit_Item_Number__c, Item_Category__c, Item_Number__c, UnitValue__c,
                          Depot_Code__c, SKU_Code__c, DateofFAT__c, Sales_Order_Line_Item__r.Item_Number__c,
                          CurrencyISOCode, Quantity__c, Discount__c,
                          SKU_Name__r.UOM__c, Culture__r.Culture_Code__c, Total_Interest_Rate__c, Net_Price__c,Product_PO_item_number__c
                          FROM Sales_Order_Line_Item__c
                          WHERE Sale_Order__c=:recordId]; //Modified by Deeksha for kit selling Project:Added Kit_Item_Number__c, Item_Category__c
        
        for(Sales_Order_Line_Item__c soiObj:owObj.itemList){
            owObj.discountValue += soiObj.Discount__c;
        }
        
        User userObj = [Select UGDN_Number__c, TM_Code__c
                        FROM User 
                        WHERE Id=:owObj.soObj.OwnerId];
        
       if(String.isNotBlank(userObj.UGDN_Number__c)){
            owObj.UGDN = userObj.UGDN_Number__c;    
        }
        
        if(String.isBlank(owObj.soObj.Region_Territory__r.Open_TM_Code__c) && String.isNotBlank(owObj.soObj.Region_Territory__r.TM_Code__c) && owObj.soObj.Region_Territory__r.TerritoryManagerActive__c==true){
            owObj.tmCode = userObj.TM_Code__c;
        }
        else if(String.isNotBlank(owObj.soObj.Region_Territory__r.Open_TM_Code__c) && owObj.soObj.Region_Territory__r.TerritoryManagerActive__c==false){//owObj.soObj.Region_Territory__r.TerritoryManagerActive__c
            owObj.tmCode = owObj.soObj.Region_Territory__r.Open_TM_Code__c;
        }
        
        if(owObj.soObj.Currency_Brazil__c=='Billing USD / Payment BRL'){
            owObj.headerCurrency = 'BRL';
            owObj.itemCurrency = 'USD';
        }
        else{
            owObj.headerCurrency = String.valueOf(owObj.soObj.CurrencyISOCode);
            owObj.itemCurrency = String.valueOf(owObj.soObj.CurrencyISOCode);            
        }
        
        return owObj;
    }
    
    class OrderWrapper{
        public Sales_Order__c soObj;
        public List<Sales_Order_Line_Item__c> itemList;
        public String UGDN;
        public String tmCode;
        public String headerCurrency;
        public String itemCurrency;
        public Decimal discountValue; 
        
        OrderWrapper(){
            soObj = new Sales_Order__c();
            itemList = new List<Sales_Order_Line_Item__c>();
            UGDN = '';
            tmCode = '';
            discountValue = 0.00;
        }
    }
}