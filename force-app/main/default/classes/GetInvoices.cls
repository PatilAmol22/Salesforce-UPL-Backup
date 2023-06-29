/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* called from Lightning Component and Schedule apex
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Swapnil More   <swapnil.more@in.ibm.com>
* @modifiedBy     Swapnil More   <swapnil.more@in.ibm.com>
* @maintainedBy   Swapnil More   <swapnil.more@in.ibm.com>
* @version        1.0
* @created        2020-02-04
* @modified       2020-02-04
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public without sharing class GetInvoices {
    
    @AuraEnabled
    public static void GetInvoicesAPICall(string SAPOrderNumber){
        string SalesOrgCode = UPL_Settings__c.getOrgDefaults().SalesOrg__c;
        system.debug('SalesOrgCode'+SalesOrgCode);
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = '';
        req.sapOrderNumber = SAPOrderNumber;
        Sales_Org__c SOrg = [select id, Sales_Org_Code__c 
                             from Sales_Org__c 
                             where Sales_Org_Code__c = :SalesOrgCode];
        Sales_Order__c SO = [select id,
                             Sold_to_Party__c,
                             SalesOrg__r.Sales_Org_Code__c,
                             Last_Invoice_Updated__c,
                             Last_Invoice_Update_Status__c,
                             Last_SuccessFull_Invoice_Update__c
                             from Sales_Order__c 
                             where SAP_Order_Number__c = :SAPOrderNumber];
        SO.Last_Invoice_Updated__c = system.now();
        
        SalesOrderTrackingResponseWrapper res = APICallout(req);
        if(res.status == 'S'){
            SO.Last_Invoice_Update_Status__c = 'Success';
            SO.Last_SuccessFull_Invoice_Update__c = system.now();
            if(string.isNotBlank(res.invoiceStatus)){
                SO.Invoice_Status__c = res.invoiceStatus;
                system.debug('invoice status'+res.invoiceStatus);
            }
            update SO;
            map<string,Invoice__c> MapInvoices = new map<string,Invoice__c>();
            /* start Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
            Map<String,Id> depotMap=new Map<String,Id>();
            set<string> depotCode= new set<string>();
              for(SalesOrderTrackingInvoices SOTI: res.invoices){
                  depotCode.add(SOTI.Depot);
              }
            List<Depot__c> d=[select id,name,depot_code__C from Depot__c where depot_code__C IN:depotCode];
            for(Depot__c dd: d){
                depotMap.put(dd.depot_code__C,dd.Id);
            }
            /* end Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
            List<String> billingDocSet = new List<String>();//Added for RITM0554451 GRZ(Nikhil Verma) 23-05-2023
            for(SalesOrderTrackingInvoices SOTI: res.invoices){
             
                billingDocSet.add(SOTI.invoiceIdNumber);  //Added for RITM0554451 GRZ(Nikhil Verma) 23-05-2023

                Invoice__c INV = new Invoice__c();
                INV.Nota_Fiscal__c = SOTI.invoiceNumber;
                INV.Billing_Doc_Number__c = SOTI.invoiceIdNumber;
                INV.Sender_Document__c = SOTI.senderDocument;
                INV.Destination_Document__c = SOTI.destinationDocument;
                INV.Carrier_Name__c = SOTI.carrierName;
                if(string.isNotBlank(SOTI.invoiceDate)){
                    if(SOTI.invoiceDate != '0000-00-00' && SOTI.invoiceDate != '    -  -  '){
                        if(date.valueOf(SOTI.invoiceDate).month() != 0 &&
                           date.valueOf(SOTI.invoiceDate).day() != 0 &&
                           date.valueOf(SOTI.invoiceDate).Year() != 0){
                               INV.Billing_Date__c = date.valueOf(SOTI.invoiceDate);
                           }
                    }
                }
                if(string.isNotBlank(SOTI.cancellationDate)){
                    if(SOTI.cancellationDate != '0000-00-00' && SOTI.cancellationDate != '    -  -  '){
                        if(date.valueOf(SOTI.cancellationDate).month() != 0 &&
                        date.valueOf(SOTI.cancellationDate).day() != 0 &&
                        date.valueOf(SOTI.cancellationDate).Year() != 0){
                        INV.Data_de_Cancelamento__c = date.valueOf(SOTI.cancellationDate);
                        }
                    }
                }
                if(string.isNotBlank(SOTI.deliveryDate)){
                    if(SOTI.deliveryDate != '0000-00-00' && SOTI.deliveryDate != '    -  -  '){ 
                        if(date.valueOf(SOTI.deliveryDate).month() != 0 &&
                           date.valueOf(SOTI.deliveryDate).day() != 0 &&
                           date.valueOf(SOTI.deliveryDate).Year() != 0){
                               INV.Delivery_Date__c = date.valueOf(SOTI.deliveryDate);
                               
                           }
                    }
                }
                if(string.isNotBlank(SOTI.estimatedDeliveryDate)){
                    if(SOTI.estimatedDeliveryDate != '0000-00-00' && SOTI.estimatedDeliveryDate != '    -  -  '){
                        if(date.valueOf(SOTI.estimatedDeliveryDate).month() != 0 &&
                           date.valueOf(SOTI.estimatedDeliveryDate).day() != 0 &&
                           date.valueOf(SOTI.estimatedDeliveryDate).Year() != 0){
                               INV.Estimated_Delivery_Date__c = date.valueOf(SOTI.estimatedDeliveryDate);
                           }
                    }
                }
                INV.Invoice_Total_Value__c = decimal.valueOf(SOTI.invoiceTotalValue);
                INV.Billing_Status__c = SOTI.generalStatusOfTheInvoice;
                INV.Sold_To_Party__c = SO.Sold_to_Party__c;
                INV.Sales_Order__c = SO.Id;
                INV.Sales_Org__c = SOrg.Id;
                INV.Invoice_key__c = SOTI.invoicekey;

                //  Start Add this field  for RITM0514419 GRZ(Javed) 09-03-2023 
                INV.SAP_Billing_DOC__c=SOTI.SAPBillingDOC;
                if(depotMap != null && depotMap.containskey(SOTI.Depot)){
                    INV.Depot__c= depotMap.get(SOTI.Depot);
                }             
                //  end  for RITM0514419 GRZ(Javed) 09-03-2023    

                MapInvoices.put(SOTI.invoiceNumber, INV);
            }
            system.debug('list@@@@@@'+MapInvoices.values());
            upsert MapInvoices.values() Billing_Doc_Number__c;

           //Added for RITM0554451 GRZ(Nikhil Verma) 23-05-2023
            if(billingDocSet != null && billingDocSet.size() <= 100){
                BatchUpdateInvoiceLineItemBrazil bo = new BatchUpdateInvoiceLineItemBrazil(billingDocSet);
                if(!Test.isRunningTest()){
                    Database.executeBatch(bo,1);
                }      
            }else{
                system.debug('SFDC cannot perform more than 100 callouts in Batch');
            }
            //Added End for RITM0554451 GRZ(Nikhil Verma) 23-05-2023
        }
        
        if(res.status == 'E'){
            
            SO.Last_Invoice_Update_Status__c = 'Failure';
            //SO.Last_SuccessFull_Invoice_Update__c = system.now();
            update SO;
            
        }
        
        
    }
    
    @AuraEnabled
    public static void GetProductsMaterialsAPICall(string InvoiceId){
        string SalesOrgCode = UPL_Settings__c.getOrgDefaults().SalesOrg__c;
        Sales_Org__c SOrg = [select id, Sales_Org_Code__c 
                             from Sales_Org__c 
                             where Sales_Org_Code__c = :SalesOrgCode];
        
        Invoice__c INV = [select id,
                          Sales_Order__r.SAP_Order_Number__c,
                          Invoice_key__c,
                          Billing_Doc_Number__c,
                          Last_Invoice_Line_Items_Updated__c,
                          Last_Invoice_Line_Items_Updated_Status__c,
                          SuccessFull_Invoice_Line_Items_Updated__c,
                          Nota_Fiscal__c
                          from Invoice__c 
                          where Billing_Doc_Number__c = :InvoiceId];
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = InvoiceId; 
        req.sapOrderNumber = INV.Sales_Order__r.SAP_Order_Number__c;
        SalesOrderTrackingResponseWrapper res = APICallout(req);
        /* start Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
        Map<String,Id> depotMap=new Map<String,Id>();
        Map<String,Id> salesOrderMap=new Map<String,Id>();
        set<string> salesOrderNumber= new set<string>();
        set<string> depotCode= new set<string>();
        for(SalesOrderTrackingMaterial SOTI: res.materials){
            depotCode.add(SOTI.Depot);
            salesOrderNumber.add(SOTI.SalesOrder);
        }
        if(salesOrderNumber != null && !salesOrderNumber.isEmpty()){
            for(Sales_Order__c s: [select id,name,SAP_Order_Number__c from Sales_Order__c where SAP_Order_Number__c IN:salesOrderNumber AND SAP_Order_Number__c != null AND  SalesOrgCode__c = '5191']){
                salesOrderMap.put(s.SAP_Order_Number__c,s.Id);
            }
        }
        List<Depot__c> d=[select id,name,depot_code__C from Depot__c where depot_code__C IN:depotCode];
        for(Depot__c dd: d){
            depotMap.put(dd.depot_code__C,dd.Id);
        }
        /* end Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
        INV.Last_Invoice_Line_Items_Updated__c = system.now();
        if(res.status == 'S'){
            INV.Last_Invoice_Line_Items_Updated_Status__c = 'Success';
            INV.SuccessFull_Invoice_Line_Items_Updated__c = system.now();
            update INV;
            list<Invoice__c> liInvoice = new list<Invoice__c>();
            for (SalesOrderTrackingInvoices SOTI : res.invoices){
                Invoice__c Invc = new Invoice__c();
                Invc.Billing_Doc_Number__c = SOTI.invoiceIdNumber;
                Invc.Invoice_key__c = SOTI.invoicekey;
                liInvoice.add(Invc);
            }
            upsert liInvoice Billing_Doc_Number__c; 
            
            INV = [select id,Sales_Order__r.SAP_Order_Number__c,
                   Invoice_key__c,Billing_Doc_Number__c,
                   Nota_Fiscal__c
                   from Invoice__c where Billing_Doc_Number__c = :InvoiceId];
            system.debug('invoice key'+INV.Invoice_key__c);
            map<string, Invoice_Line_Item__c> MapInvoiceLI = new map<string, Invoice_Line_Item__c>();
            set<string> SKUCodes = new set<string>();
            for(SalesOrderTrackingMaterial SOTI: res.materials){
                SKUCodes.add(SOTI.productCode);            
            }
            map<string,SKU__c> mapSKU = new map<string,SKU__c>();
            for (SKU__c S: [select Id,SKU_Code__c from SKU__C
                            where SKU_Code__c = :SKUCodes And Sales_Org_Code__c ='5191']){  // Added Sales_Org_Code__c for RITM0538824 GRZ(Dheeraj Sharma) 18-04-2023
                                mapSKU.put(S.SKU_Code__c,S);  
                            }

            
            for(SalesOrderTrackingMaterial SOTI: res.materials){   
                Invoice_Line_Item__c ILI = new Invoice_Line_Item__c();
                ILI.SKU__C = mapSKU.get(SOTI.productCode) != null ? mapSKU.get(SOTI.productCode).Id : null;
                ILI.Invoice_Item_Key__c = INV.Billing_Doc_Number__c+SOTI.itemNumber;
                ILI.Invoice_Item__c = SOTI.itemNumber;
                ILI.Quantity__c = decimal.valueof(SOTI.volume);
                ILI.Net_Value__c = decimal.valueof(SOTI.value);
                ILI.SalesOrg__c = SOrg.Id;
                ILI.Invoice__c = INV.Id;
                /* start add below line's  for RITM0514419 GRZ(Javed) 09-03-2023 */
                ILI.Unit_Price__c = SOTI.UnitPrice != '' ? decimal.valueof(SOTI.UnitPrice) : 0.0;
                if(SOTI.ManufacturingDate != '0000-00-00' && SOTI.ManufacturingDate !=null ){
                    ILI.Manufacturing_Date__c = date.valueof(SOTI.ManufacturingDate);
                }
                ILI.Billing_DOC_reference_number__c = SOTI.BillingDOCreferencenumber;
                if(SOTI.ExpireDate != '0000-00-00' && SOTI.ExpireDate != null){
                    ILI.Expire_Date__c = date.valueOf(SOTI.ExpireDate);
                }
                if(depotMap != null && depotMap.containskey(SOTI.depot)){
                    ILI.Depot__c = depotMap.get(SOTI.depot);
                }
                if(salesOrderMap != null && salesOrderMap.containskey(SOTI.SalesOrder)){
                    ILI.Sales_Order__c = salesOrderMap.get(SOTI.SalesOrder);
                }
                ILI.Batch__c = SOTI.Batch;
                ILI.SAP_Billing_DOC__c = SOTI.SAPBillingDOC;
                /* end add below line's  for RITM0514419 GRZ(Javed) 09-03-2023 */ 
                MapInvoiceLI.put(SOTI.itemNumber, ILI);
            }
            
            upsert MapInvoiceLI.values() Invoice_Item_Key__c;
            //SaveFileAPICall.getPDF(INV.Invoice_key__c, INV.Billing_Doc_Number__c, INV.id); //INV.Invoice_key__c
            //SaveFileAPICall.getXML(INV.Invoice_key__c, INV.Billing_Doc_Number__c, INV.id);
            //list<ContentVersion> liCVPDF = [select id from ContentVersion where PathOnClient =: INV.Billing_Doc_Number__c+'.pdf'];
            list<ContentDocumentlink> liCVPDF = [SELECT Id, LinkedEntityId, 
                                                 ContentDocument.title,ContentDocument.filetype, 
                                                 IsDeleted, SystemModstamp, ShareType, Visibility
                                                 FROM ContentDocumentLink where 
                                                 LinkedEntityId = :INV.Id AND
                                                 ContentDocument.title = :INV.Nota_fiscal__c AND //Billing_Doc_Number__c
                                                 ContentDocument.filetype = 'PDF'];
            system.debug('liCVPDF'+liCVPDF);
            if(liCVPDF.size()==0){
                string endpoint_pdf = UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint__c + INV.Invoice_key__c+UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint_Ext_PDF__c;
                getDoc(INV.Invoice_key__c,
                       INV.Billing_Doc_Number__c,
                       INV.Nota_Fiscal__c, 
                       INV.id, 
                       UPL_Settings__c.getOrgDefaults().DOC_API_UserName__c,
                       UPL_Settings__c.getOrgDefaults().DOC_API_PassWord__c,
                       endpoint_pdf,
                       '.pdf');
            }
            //list<ContentVersion> liCVXML = [select id from ContentVersion where PathOnClient =: INV.Billing_Doc_Number__c+'.xml'];
            list<ContentDocumentlink> liCVXML = [SELECT Id, LinkedEntityId, 
                                                 ContentDocument.title,ContentDocument.filetype, 
                                                 IsDeleted, SystemModstamp, ShareType, Visibility 
                                                 
                                                 FROM ContentDocumentLink where 
                                                 LinkedEntityId = :INV.Id AND
                                                 ContentDocument.title = :INV.Nota_fiscal__c AND //Billing_Doc_Number__c
                                                 ContentDocument.filetype = 'XML'];
            system.debug('liCVXML'+liCVXML);
            if(liCVXML.size()==0){
                string endpoint_XML = UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint__c + INV.Invoice_key__c+UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint_Ext_XML__c;
                getDoc(INV.Invoice_key__c,
                       INV.Billing_Doc_Number__c,
                       INV.Nota_Fiscal__c, 
                       INV.id, 
                       UPL_Settings__c.getOrgDefaults().DOC_API_UserName__c,
                       UPL_Settings__c.getOrgDefaults().DOC_API_PassWord__c,
                       endpoint_XML,
                       '.xml');
            }
        }
        if(res.status == 'E'){
            INV.Last_Invoice_Line_Items_Updated_Status__c = 'Failure';
            Update INV;
        }
    }
    
    @future(callout=true)
    public static void fetchSalesOrderStatus(){
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        datetime yesterday = Datetime.now()-1;
        datetime dbyesterday = Datetime.now()-30;
        req.dateFrom = dbyesterday.format('yyyyMMdd');//'20191101';
        req.dateTo = yesterday.format('yyyyMMdd');//'20191130';
        req.invoiceId = '';
        req.sapOrderNumber = '';
        
        SalesOrderTrackingResponseWrapper res = APICallout(req);
        
        string SalesOrgCode = UPL_Settings__c.getOrgDefaults().SalesOrg__c; 
        map<string,Sales_Order__c> mapSO = new  map<string,Sales_Order__c>();
        for( SalesOrderTrackingSalesOrders SOTSO : res.salesOrders ){
            Sales_Order__c SO = new Sales_Order__c();
            SO.SAP_Order_Number__c = SOTSO.sapSalesOrderNumber;
            SO.Invoice_Status__c = SOTSO.invoicesStatus;
            mapSO.put(SOTSO.sapSalesOrderNumber, SO);
        }
        system.debug('mapSO'+mapSO);
        map<string,Sales_Order__c> mapSOAll = new  map<string,Sales_Order__c>();
        for (Sales_Order__c SO: [select Id, SAP_Order_Number__c,Invoice_Status__c
                                 from Sales_Order__c 
                                 where SAP_Order_Number__c = :mapSO.keySet()
                                 and SalesOrg__r.Sales_Org_Code__c = :SalesOrgCode]){
                                     mapSOAll.put(SO.SAP_Order_Number__c, SO);
                                 }
        List<Sales_Order__c> LiSO = new List<Sales_Order__c>();
        for (Sales_Order__c SO: mapSOAll.values()){
            if(SO.Invoice_Status__c != mapSO.get(SO.SAP_Order_Number__c).Invoice_Status__c){
                SO.Invoice_Status__c = mapSO.get(SO.SAP_Order_Number__c).Invoice_Status__c;
                LiSO.add(SO);
            }
        }
        
        system.debug('LiSO'+LiSO);
        upsert LiSO SAP_Order_Number__c;
    }
    
    public static SalesOrderTrackingResponseWrapper APICallout(SalesOrderTrackingRequestWrapper req){
        
        String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
        String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
        String url = UPL_Settings__c.getOrgDefaults().Sales_Order_Tracking_URL__c;//'https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/salesOrder/tracking';
        
        Integer timeOut = 120000;
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setTimeout(timeOut);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String json = System.JSON.serializePretty(req);
        
        system.debug('json is '+json);
        request.setBody(json);
        request.setEndpoint(url);        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
        //String authorizationHeader='Basic UzAwMDMyNjMzMTM6QWpAMTIzNDU=';
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response;       
        response = http.send(request);      
        system.debug('reached here before converting to response wrapper');
        system.debug('status from webservice '+response.getStatus());
        system.debug('response from webservice is '+response.getBody());
        SalesOrderTrackingResponseWrapper res;
        res= (SalesOrderTrackingResponseWrapper) System.JSON.deserialize(response.getBody(), SalesOrderTrackingResponseWrapper.class);
        System.debug('111Anji'+res.status);
        system.debug('resFAfter:'+res);
        return res;
        
    }
    
    @future(callout=true)
    public static void getDoc(string InvoiceKey,
                              string billingDocNumber,
                              string Invoice, 
                              string invoiceId,
                              string username,
                              string password,
                              string endpoint,
                              string Type){
                                  system.debug(Invoice);
                                  list<ContentVersion> liCV = [select id from ContentVersion where PathOnClient =: Invoice+Type];
                                  
                                  if(liCV.size()==0){
                                      invoice__c INV = [select id,
                                                        Last_PDF_Doc_Fetched__c,
                                                        Last_PDF_Doc_Fetched_Status__c,
                                                        Last_Successfull_PDF_Doc_Fetched__c,
                                                        Last_Successfull_XML_Doc_Fetched__c,
                                                        Last_XML_Doc_Fetched__c,
                                                        Last_XML_Doc_Fetched_Status__c          
                                                        from Invoice__c 
                                                        where Billing_Doc_Number__c = :billingDocNumber FOR UPDATE]; //Invoice
                                      
                                      
                                    // Below changes to change authorization to get invoice doc from MasterSaf RITM0427255 GRZ(Nikhil Verma) 27-09-2022
                                      Integer timeOut = 120000;
                                      Http http = new Http();
                                      HttpRequest request = new HttpRequest();
                                      String token;
                                      if(Test.isRunningTest()){
                                          token = 'testToken'; 
                                      }else{
                                          token  = GenerateToken(); 
                                      }
                                      request.setTimeout(timeOut);
                                      request.setMethod('GET');
                                      request.setEndpoint(endpoint);        
                                      request.setHeader('Authorization', 'Bearer ' + token);
                                      system.debug('request'+request);
                                      HttpResponse response;       
                                      response = http.send(request); 
                                      system.debug('status'+response.getStatusCode());
                                      if(Type == '.xml') {
                                          system.debug('inside xml'+system.now());
                                          INV.Last_XML_Doc_Fetched__c = system.now();
                                          
                                      }  
                                      if(Type == '.pdf') {
                                          system.debug('inside pdf'+system.now());
                                          INV.Last_PDF_Doc_Fetched__c = system.now();
                                          
                                      } 
                                      
                                      
                                      if(response.getStatusCode() == 200){
                                          if(Type == '.xml') {
                                              
                                              INV.Last_Successfull_XML_Doc_Fetched__c = system.now();
                                              INV.Last_XML_Doc_Fetched_Status__c = 'Success';
                                              
                                          }  
                                          if(Type == '.pdf') {
                                              
                                              INV.Last_Successfull_PDF_Doc_Fetched__c = system.now();
                                              INV.Last_PDF_Doc_Fetched_Status__c = 'Success';
                                              
                                          }  
                                          update INV;    
                                          ContentVersion cv = new ContentVersion();
                                          cv.Title = Invoice;
                                          cv.PathOnClient = Invoice+Type;
                                          cv.VersionData = response.getBodyAsBlob();
                                          cv.IsMajorVersion = true;
                                          Insert cv;
                                          
                                          
                                          //Get Content Documents
                                          List<ContentDocument> docList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId = :cv.Id];
                                          
                                          //Create ContentDocumentLink 
                                          ContentDocumentLink cdl = New ContentDocumentLink();
                                          cdl.LinkedEntityId = invoiceId;
                                          cdl.ContentDocumentId = docList[0].Id;
                                          cdl.shareType = 'I';
                                          cdl.Visibility = 'AllUsers';
                                          Insert cdl;
                                      }
                                      else{
                                          if(Type == '.pdf') {
                                              INV.Last_PDF_Doc_Fetched_Status__c = 'Status Code: '+ response.getStatusCode() +
                                                  'Status Message :'+ response.getBody();
                                          }
                                          if(Type == '.xml') {
                                              INV.Last_XML_Doc_Fetched_Status__c = 'Status Code: '+ response.getStatusCode() +
                                                  'Status Message :'+ response.getBody();     
                                          }
                                          update INV;
                                      }
                                  }
                                  
                              }
    
    // Below changes to change authorization to get invoice doc from MasterSaf RITM0427255 GRZ(Nikhil Verma) 27-09-2022
    public static String generateToken(){
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        string endpoint = UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint__c;
        string userName = UPL_Settings__c.getOrgDefaults().DOC_API_UserName__c;
        string APIKey = UPL_Settings__c.getOrgDefaults().DOC_API_Key__c;
        endpoint = endpoint.replace('nfe/', 'login');
        request.setEndpoint(endpoint);
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String body = '{\"nomeUsuario\":\"'+userName+'\",\"chave\":\"'+APIKey+'\"}';
        request.setBody(body);
        HTTPresponse res = http.send( request );
        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Object token = (Object)response.get('accessToken');
        return token.toString();
    }
    
}