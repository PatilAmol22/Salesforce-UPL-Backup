public with sharing class Grz_SalesOrderDetailChile {
    @AuraEnabled(cacheable=true)
    public static ProductDetailWrapper getProductDetailList(String urlapex) {
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String query = 'Select Id, Name,Purchase_Order_no__c,Purchase_order_Date__c, CurrencyIsoCode,Sold_To_Party__r.BillingCity,Sold_To_Party__r.TaxNumber1__c,Sold_to_Party__r.Name, SAP_Order_Number__c, SFDC_Order_Number__c, CreatedDate,createdby.name, OrderQuantity__c, Total_Amount__c,(Select Id, SKU_Code__c,SKU_Description__c,Price__c, UOM__c, Value_Number__c, Unit_Price__c, sale_order__c,Brazil_Product__c, ProductName__c, Quantity__c,TotalValueWithoutInterest__c,UnitValue__c,Net_Price_Per_Unit__c from Sales_Order_Line_Item__r), (Select Id, Name, Billing_Doc_Number__c, Billing_Date__c, TotalSalesAmount__c,Delivery_Number__c from Invoice__r) from Sales_Order__c';
        query += ' where Id =: urlapex ';
        if(!String.isEmpty(accountId)) {
            query += query.contains('where') ? ' and' : ' where';
            query +=  ' Sold_to_Party__c =: accountId';    
        }
        List<Sales_Order__c> salesOrderList = Database.query(query); 
        List<Sales_Order_Line_Item__c> lineitem = new list<Sales_Order_Line_Item__c>();
        List<Invoice__c> finalinvoiceList = new list<Invoice__c>();
        ProductDetailWrapper productobj = new ProductDetailWrapper();
        Sales_Order__c sales = new Sales_Order__c(); 
        for(Sales_Order__c salesobj : salesOrderList) {
            sales = salesobj;
            lineitem.addAll(salesobj.Sales_Order_Line_Item__r);
            finalinvoiceList.addAll(salesobj.Invoice__r);
        }
        productobj.poNumber = sales.Purchase_Order_no__c;
        if(sales.Purchase_order_Date__c != null){
            productobj.poDate = grz_SapIntegration.FormattedDateChile(sales.Purchase_order_Date__c);
        }
        if(sales.Total_Amount__c != null){
            productobj.orderTotal = String.valueOf(sales.Total_Amount__c);
        }
        productobj.SAPOrderNo = sales.SAP_Order_Number__c;
        productobj.SFDCOrderNo = sales.Name;
        String name = sales.CreatedBy.Name.toLowerCase(); 
        String result = '';
        if (name != null && name != '') {
            for (String iter : name.split('[ ]+')) {
                if (iter != null && iter != '') {
                    if (iter.length() > 1) {  
                        result += iter.substring(0,1).toUpperCase() + iter.substring(1,iter.length()) + ' ';
                    }
                    else {
                        result += iter.substring(0,1).toUpperCase() + ' ';
                    }
                }
            }
            result = result.substring(0, result.length() - 1);
            productobj.repName = result;
        }
        productobj.soldToParty = sales.Sold_To_Party__r.Name;
        productobj.city = sales.Sold_To_Party__r.BillingCity;
        productobj.customerTaxNumber = sales.Sold_To_Party__r.TaxNumber1__c;
        productobj.crncy = sales.CurrencyIsoCode;  
        List<InvoiceWrap> ivWrapList = new List<InvoiceWrap>();
        List<LineItemWrap> lineWrapList = new List<LineItemWrap>();
        for(Invoice__c iv : finalinvoiceList){
            InvoiceWrap ivWrap = new InvoiceWrap();
            ivWrap.ivId = iv.Id;
            if(iv.Billing_Doc_Number__c != null){
                ivWrap.billingDocNumber = iv.Billing_Doc_Number__c;
            }
            if(iv.Billing_Date__c != null){
                ivWrap.billingDate = grz_SapIntegration.FormattedDateChile(iv.Billing_Date__c);
            }
            if(iv.TotalSalesAmount__c != null){
                ivWrap.totalAmount = String.valueOf(iv.TotalSalesAmount__c);
            }
            ivWrap.deliveryNumber = iv.Delivery_Number__c;
            ivWrapList.add(ivWrap);
        }
        Set<Id> lineItemIds = new Set<Id>();
        for(Sales_Order_Line_Item__c so : lineitem){
            lineItemIds.add(so.Id);
        }
        if(!lineItemIds.isEmpty()){
            for(Sales_Order_Line_Item__c so : [SELECT Id,UOM__c,Quantity__c,Net_Price_Per_Unit__c,Consignee_City__c,SKU_Code__c,Sale_Order__r.Destination_City__c,(SELECT Id,SubStatus__c FROM Sales_order_delivery__r WHERE Parent_Record__c != null LIMIT 1),(SELECT Id FROM Invoice_Line_Item__r LIMIT 1),(SELECT Id,Deliverynumber__c FROM Dispatches__r WHERE Batch__c != null LIMIT 1), Sale_Order__c, Sale_Order__r.Name, Sale_Order__r.CreatedDate, Sale_Order__r.Purchase_Order_no__c, Sale_Order__r.Purchase_order_Date__c, Sale_Order__r.Brazil_City__c, CurrencyIsoCode,CreatedDate,Price__c, SKU_Description__c, Cust_Name__c, CreatedBy.Name FROM Sales_Order_Line_Item__c WHERE Id IN:lineItemIds]){
                LineItemWrap lineWrap = new LineItemWrap();
                lineWrap.Id = so.Id;
                lineWrap.skuCode = so.SKU_Code__c;
                lineWrap.productName = so.SKU_Description__c;
                lineWrap.uom = so.UOM__c;
                if(so.Quantity__c != null){
                    lineWrap.quantity = String.valueOf(so.Quantity__c);
                }
                if(so.Net_Price_Per_Unit__c != null){
                    lineWrap.unitPrice = String.valueOf(so.Net_Price_Per_Unit__c);
                }
                if(so.Price__c != null){
                    lineWrap.totalValue = String.valueOf(so.Price__c);
                }
                if(!so.Invoice_Line_Item__r.isEmpty()){
                    lineWrap.deliveryStatus = 'Pedido facturado';
                }else{
                    if(!so.Sales_order_delivery__r.isEmpty()){
                        if(so.Sales_order_delivery__r[0].SubStatus__c != null && so.Sales_order_delivery__r[0].SubStatus__c != ''){
                            lineWrap.deliveryStatus = so.Sales_order_delivery__r[0].SubStatus__c;
                        }else{
                            lineWrap.deliveryStatus = 'Entrega en Ruta';
                        }
                    }else{
                        lineWrap.deliveryStatus = 'Pedido en proceso';
                    }
                }
                lineWrapList.add(lineWrap);
            }
        }
        productobj.lineItemList = lineWrapList;
        productobj.InvoiceDetails = ivWrapList;
        return productobj;
    }
    
    @AuraEnabled
    public static ResultWrapper getPoDocument(String orderId) {
        ResultWrapper wrapper = new ResultWrapper();
            List<Attachment> attList  = [SELECT Id FROM Attachment WHERE ParentId =:orderId LIMIT 1];
            if(!attList.isEmpty()){
                wrapper.fileContent = attList[0].Id;
                wrapper.success = true;
            }else{
                wrapper.success = false;
            }
        return wrapper;
    }

    //Changed below method logic to get multipe dispatch documents GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
    @AuraEnabled
    public static DBNetWrapper getPDF(String type, String reference, String customerTaxNumber) {
        DBNetWrapper wrapper = new DBNetWrapper();  
        List<ResultWrapper> rWrapList = new List<ResultWrapper>();      
        String refnumber;
        String docCode;
        String amount = '0';
        String billingDate;

        if(!String.isEmpty(type) && type == 'Delivery'){
            if(!String.isEmpty(reference)){
                List<Dispatch__c> dis = [SELECT Id,Reference_Number__c,Document_Date__c,Customer__r.TaxNumber1__c 
                                        FROM Dispatch__c WHERE SalesOrderLineItem__c =:reference
                                        AND SalesOrg__r.Name = 'Chile' 
                                        AND Reference_Number__c != null AND Batch__c != null LIMIT 4];
                if(!dis.isEmpty()){
                    wrapper.success = true;
                    for(Dispatch__c d :dis){
                        ResultWrapper rWrap = new ResultWrapper();
                        if(d.Reference_Number__c != null){
                            refnumber = d.Reference_Number__c;
                            refnumber = refnumber.right(6);
                        }
                        docCode = DB_Net_Chile__c.getOrgDefaults().Delivery_Doc__c;
                        if(String.isEmpty(customerTaxNumber)){
                            customerTaxNumber = d.Customer__r.TaxNumber1__c;
                        }
                        if(d.Document_Date__c != null){
                            billingDate = String.valueOf(d.Document_Date__c);
                        }
                        rWrap = Grz_SalesOrderDetailChile.getDataFromDBNet(refnumber,docCode,amount,billingDate,customerTaxNumber);
                        rWrapList.add(rWrap);
                    }
                }else{
                    wrapper.success = false;
                }
            }
        }else if(!String.isEmpty(type) && type == 'Invoice'){
            ResultWrapper rWrap = new ResultWrapper();
            List<Invoice__c> inv = [SELECT Id, Billing_Date__c,TotalSalesAmount__c,
                        CurrencyISOCode,Delivery_Number__c, Folio__c, Total_Included_Tax__c,Sold_To_Party__r.TaxNumber1__c
                        FROM Invoice__c WHERE Id=:reference];
        
            if(String.isEmpty(customerTaxNumber) && !inv.isEmpty()){
                customerTaxNumber = inv[0].Sold_To_Party__r.TaxNumber1__c;
            }
            if(inv[0].Folio__c != null){
                refnumber = inv[0].Folio__c;
                refnumber = refnumber.right(6);
            }
            docCode = DB_Net_Chile__c.getOrgDefaults().Invoice_Doc__c;
            if(inv[0].Billing_Date__c != null){
                billingDate = String.valueOf(inv[0].Billing_Date__c);
            }
            if(!String.isEmpty(refnumber) && !String.isEmpty(docCode) && !String.isEmpty(amount) && !String.isEmpty(billingDate) && !String.isEmpty(customerTaxNumber)){
                wrapper.success = true;
                rWrap = Grz_SalesOrderDetailChile.getDataFromDBNet(refnumber,docCode,amount,billingDate,customerTaxNumber);
                rWrapList.add(rWrap);
            }else{
                wrapper.success = false;
            }
        }        
        wrapper.dbWrap = rWrapList;
        
        return wrapper;
    }

    @AuraEnabled
    public static ResultWrapper getDataFromDBNet(String refnumber,String docCode,String amount,String billingDate,String customerTaxNumber) {
        ResultWrapper wrapper = new ResultWrapper();
        String username = DB_Net_Chile__c.getOrgDefaults().Username__c;
        String password = DB_Net_Chile__c.getOrgDefaults().Password__c;
        String endpoint = DB_Net_Chile__c.getOrgDefaults().URL__c;
        String rutt = DB_Net_Chile__c.getOrgDefaults().Rutt__c;
        Boolean merito = DB_Net_Chile__c.getOrgDefaults().Merito__c;
        String xmlBody = 
        '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
            '<soap:Header>' +
                '<wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' +
                    '<wsse:UsernameToken>' +
                        '<wsse:Username>' + username + '</wsse:Username>' +
                        '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + password + '</wsse:Password>' +
                    '</wsse:UsernameToken>' +
                '</wsse:Security>' +
            '</soap:Header>' +
            '<soap:Body>' +
                '<get_pdf xmlns="http://www.dbnet.cl/getPDF64">' +
                    '<rutt>' + rutt + '</rutt>' +
                    '<folio>' + refnumber + '</folio>' +
                    '<doc>' + docCode + '</doc>' +
                    '<monto>' + amount + '</monto>' +
                    '<fecha>' + billingDate + '</fecha>' +
                    '<ruttt>' + customerTaxNumber + '</ruttt>' +
                    '<Merito>' + merito + '</Merito>' +
                '</get_pdf>' +
            '</soap:Body>' +
        '</soap:Envelope>' ;
        HTTPResponse response;
        try {
            HTTP http = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setEndpoint(endpoint);
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('SOAPAction', 'http://www.dbnet.cl/getPDF64/get_pdf');
            req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
            req.setBody(xmlBody);
            req.setMethod('POST');
            req.setTimeout(120000);
            response = http.send(req);
            //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
            wrapper.refnumber = refnumber;
            wrapper.docCode = docCode;
            wrapper.amount = amount;
            wrapper.billingDate = billingDate;
            wrapper.customerTaxNumber = customerTaxNumber;

            if (response.getStatusCode() == 200) {
                if(response.getBody().contains('<string>ERR3</string>')){
                    wrapper.success = false;
                }else if(response.getBody().contains('<string>DOK</string>')){
                    wrapper.success = true;
                    String str2 = response.getBody().substringBetween('<get_pdfResult>', '</get_pdfResult>');
                    List<String> lstStr= str2.split('</string><string>');
                    wrapper.fileName = lstStr[0].replace('<string>','');
                    wrapper.fileContent = lstStr[1];
                }                
            }else{
                wrapper.success = false;
                system.debug(response.getBody());
            }
        } catch (exception e) {
            system.debug(e.getMessage()+'\n'+e.getLineNumber()+'\n'+e.getCause());
            wrapper.success = false;
        }
        return wrapper;
    }
    //GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
    public class DBNetWrapper {
        @AuraEnabled public List<ResultWrapper> dbWrap {get;set;}
        @AuraEnabled public Boolean success {get;set;}
    }

    public class ResultWrapper {
        @AuraEnabled public String fileName {get;set;}
        @AuraEnabled public String fileContent {get;set;}
        @AuraEnabled public Boolean success {get;set;}
        @AuraEnabled public String refnumber {get;set;}
        @AuraEnabled public String docCode {get;set;}
        @AuraEnabled public String amount {get;set;}
        @AuraEnabled public String billingDate {get;set;}
        @AuraEnabled public String customerTaxNumber {get;set;}
    }
    public class ProductDetailWrapper {
        @AuraEnabled public Sales_Order__c salesList {get;set;}
        @AuraEnabled public List<LineItemWrap> lineItemList {get;set;}  
        @AuraEnabled public  List<InvoiceWrap> InvoiceDetails{get;set;}
        @AuraEnabled public String poNumber {get;set;}
        @AuraEnabled public String poDocLink {get;set;}
        @AuraEnabled public String poDate {get;set;}
        @AuraEnabled public String orderTotal {get;set;}
        @AuraEnabled public String SAPOrderNo {get;set;}
        @AuraEnabled public String SFDCOrderNo {get;set;}
        @AuraEnabled public String repName {get;set;}
        @AuraEnabled public String soldToParty {get;set;}
        @AuraEnabled public String customerTaxNumber {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String crncy {get;set;}
    }
    public class InvoiceWrap {
        @AuraEnabled public Id ivId {get;set;}
        @AuraEnabled public String billingDocNumber {get;set;}
        @AuraEnabled public String billingDate {get;set;}
        @AuraEnabled public String totalAmount {get;set;}
        @AuraEnabled public String deliveryNumber {get;set;}

    }
    public class LineItemWrap {
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String skuCode {get;set;}
        @AuraEnabled public String deliveryStatus {get;set;}
        @AuraEnabled public String productName {get;set;}
        @AuraEnabled public String quantity {get;set;}
        @AuraEnabled public String uom {get;set;}
        @AuraEnabled public String unitPrice {get;set;}
        @AuraEnabled public String totalValue {get;set;}
    }
}