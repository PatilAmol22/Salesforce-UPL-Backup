/**************************************************************************************************
* Name               : Grz_ProductDetailClassBrazil                                                      
* Description        : Controller for grz_SalesOrderDetailBrazil LWC Component
* Test Class         : Grz_ProductDetailClassBrazilTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_ProductDetailClassBrazil {
    //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    public String dateStr                           {get;set;}
    public String punctuality                       {get;set;}
    public ProductDetailWrapper soPDF               {get;set;}

    @AuraEnabled(cacheable=true)
    public static ProductDetailWrapper getProductDetailList(String urlapex) {
        Id id = UserInfo.getUserId();
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accId = new Set<Id>();
            if(!String.isEmpty(groupCstr)){
                for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                    accId.add(ac.Id);
                }
            }
        accId.add(accountId);
        String query = 'Select Id, Name, Type_of_Order__c,SalesOrderNumber_Brazil__c,Invoice_status__c,BrazilSalesOrderStatus__c, Brazil_City__c, CurrencyIsoCode, Currency_Brazil__c,Payment_Term__r.Payterms_Desc__c, Payment_Term__c,(Select Id, SKU_Code__c, UOM__c, Value_Number__c, Unit_Price__c, sale_order__c,Brazil_Product__c, ProductName__c, Quantity__c,TotalValueWithoutInterest__c,UnitValue__c from Sales_Order_Line_Item__r), (Select Id, Name, Billing_Doc_Number__c, Billing_Date__c, TotalSalesAmount__c, Billing_Status__c, Acknowledge__c, Sold_To_Party__c,Invoice_key__c from Invoice__r), Sold_to_Party__r.Name, SAP_Order_Number__c, SFDC_Order_Number__c, CreatedDate,createdby.name, Order_Type_lk__r.Name, Total_Value_Brazil__c,Order_Status__c, OrderQuantity__c, Total_Amount__c from Sales_Order__c';
        query += ' where Id =: urlapex ';
        if(!String.isEmpty(accountId)) {
            if(!query.contains('where')){
                query +=  ' where Sold_to_Party__c In: accId';
            }else{
                query += ' and Sold_to_Party__c In: accId';
            }     
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
        productobj.orderType = sales.Type_of_Order__c;
        if(sales.CreatedDate != null){
            productobj.orderDate = grz_SapIntegration.FormattedDateBrazil(sales.CreatedDate);
        }
        productobj.orderStatus = sales.BrazilSalesOrderStatus__c;
        if(sales.Total_Value_Brazil__c != null){
            if(sales.Type_of_Order__c == 'BONIFICAÇÃO' || sales.Type_of_Order__c == 'REMESSA PARA TESTE'){
                productobj.orderTotal = '-';
            }else{
                productobj.orderTotal = String.valueOf(sales.Total_Value_Brazil__c.setScale(0));
            }
        }
        productobj.SAPOrderNo = sales.SAP_Order_Number__c;
        productobj.SFDCOrderNo = sales.SalesOrderNumber_Brazil__c;
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
        productobj.city = sales.Brazil_City__c;
        if(sales.Currency_Brazil__c != null){
            if(sales.Currency_Brazil__c == 'Billing BRL / Payment BRL'){
                productobj.crncy = 'Real – BRL';
            }else if(sales.Currency_Brazil__c == 'Billing USD / Payment BRL'){
                productobj.crncy = 'Dólar – USD';
            }else if(sales.Currency_Brazil__c == 'Billing USD / Payment USD'){
                productobj.crncy = 'Dólar – USD';
            }
        }    
        if(sales.Payment_Term__c != null){
            productobj.paymentTerm = sales.Payment_Term__r.Payterms_Desc__c;
        }  
        productobj.invoiceStatus = sales.Invoice_Status__c;

        List<LineItemWrap> lineWrapList = new List<LineItemWrap>();
        for(Sales_Order_Line_Item__c so : lineitem){
            LineItemWrap lineWrap = new LineItemWrap();
            lineWrap.Id = so.Id;
            lineWrap.skuCode = so.SKU_Code__c;
            lineWrap.productName = so.Brazil_Product__c;
            lineWrap.uom = so.UOM__c;
            if(so.Quantity__c != null){
                lineWrap.quantity = String.valueOf(so.Quantity__c);
            }
            if(so.UnitValue__c != null){
                lineWrap.unitPrice = String.valueOf(so.UnitValue__c.setScale(0));
            }
            if(so.TotalValueWithoutInterest__c != null){
                lineWrap.totalValue = String.valueOf(so.TotalValueWithoutInterest__c.setScale(0));
            }
            lineWrapList.add(lineWrap);
        }

        List<InvoiceWrap> ivWrapList = new List<InvoiceWrap>();
        for(Invoice__c iv : finalinvoiceList){
            InvoiceWrap ivWrap = new InvoiceWrap();
            ivWrap.ivId = iv.Id;
            ivWrap.invoiceKey = iv.Invoice_key__c;
            if(iv.Billing_Doc_Number__c != null){
                ivWrap.billingDocNumber = iv.Billing_Doc_Number__c;
            }
            if(iv.Billing_Date__c != null){
                ivWrap.billingDate = grz_SapIntegration.FormattedDateBrazil(iv.Billing_Date__c);
            }
            if(iv.TotalSalesAmount__c != null){
                ivWrap.totalAmount = String.valueOf(iv.TotalSalesAmount__c.setScale(0));
            }
            ivWrap.billingStatus = iv.Billing_Status__c;
            ivWrapList.add(ivWrap);
        }
        
        productobj.lineItemList = lineWrapList;
        productobj.InvoiceDetails = ivWrapList;
        return productobj;
    }

    //Method added for VF page, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
    public void getDataForVF(){
        try {
            datetime now = system.today();
        dateStr = now.format();
        Id orderID = ApexPages.CurrentPage().getParameters().get('Id');
        punctuality = ApexPages.CurrentPage().getParameters().get('punct');
        if(null != punctuality){
            if(punctuality.equalsIgnoreCase('true')){
                punctuality = Label.Yes;
            }else{
                punctuality = Label.No;
            }
        }

        List<Sales_Order__c> salesOrderList = [SELECT Id, Name,BrazilSalesOrderStatus__c,Invoice_Status__c,Total_Value_Brazil__c,Brazil_City__c,CreatedBy.Name,SalesOrderNumber_Brazil__c,SAP_Order_Number__c,Punctuality_Discount__c, Order_Status__c,Sold_to_Party__r.BillingAddress,Purchase_Order_no__c,createdDate,Expected_Number_of_days__c,
        Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c,Campaign_Payment_Term_Date__c,Use_Campaign__c,Sold_to_Party__r.BillingPostalCode,Sold_to_Party__r.BillingStreet,
        Sold_to_Party__r.Tax_Number_3__c, TotalValueWithInterest__c,Sold_to_Party__r.Customer_Region__c,Inco_Term__r.Name,Sold_to_Party__r.BillingCountry,
        Sold_to_Party__r.SAP_Code__c, TotalValueWithoutInterest__c,Inco_Term__c,Sold_to_Party__r.Email__c,Inco_Term_Code__c,Campaign_Type__c,
        Sold_to_Party__r.Customer_Group__c,TotalReplacementCost__c, SalesOrderReplacementMargin__c,Payment_Term__r.Payterms_Desc__c,
        Sold_to_Party__r.BillingCity, Price_Book__c, CreatedById, OwnerId, Owner.Name, Flag__c,Sold_to_Party__r.TaxNumber2__c,
        Sold_to_Party__r.BillingState, Type_of_Order__c, Valid_From__c,Currency_Brazil__c,Sold_to_Party__r.Tax_Number_1__c,
        Valid_To__c, PONumber__c, Purchase_Order_Date__c, PaymentMethod__c,Maturity_Date__c,
        Payment_Term__c,Invoice_Message__c,Internal_OBS__c,Sales_order_OBS__c,PaymentMethod__r.Name,Text_Cal_Brazil__c,
        (SELECT ID, Sale_Order__c, DateofFAT__c, SKU_Code__c,SKU_Name__c, UnitValue__c, InterestRate__c,
        Quantity__c, UnitValuewithInterest__c, Time_in_months__c, Days__c, Flag__c,
        PriceBookDetail__c, CurrencyIsoCode, Sales_Org__c, MaterialPlantRelation__c, Culture__c, Culture__r.Culture_Desc__c,
        ExchangeRate__c,Brazil_Product__c,UOM__c, SKU_Name__r.Name, TotalValueWithInterest__c, TotalValueWithoutInterest__c, SKU_Name__r.SKU_Description__c
        FROM Sales_Order_Line_Item__r)                                      
        FROM Sales_Order__c 
        WHERE Id =: orderID]; 
        List<Sales_Order_Line_Item__c> lineitem = new list<Sales_Order_Line_Item__c>();
        ProductDetailWrapper productobj = new ProductDetailWrapper();
        Sales_Order__c sales = new Sales_Order__c(); 
        for(Sales_Order__c salesobj : salesOrderList) {
            sales = salesobj;
            lineitem.addAll(salesobj.Sales_Order_Line_Item__r);
        }
        productobj.orderType = sales.Type_of_Order__c;
        productobj.purchaseOrderNumber = sales.Purchase_Order_no__c;
        productobj.ownerName = sales.Owner.Name;
        if(sales.CreatedDate != null){
            productobj.orderDate = grz_SapIntegration.FormattedDateBrazil(sales.CreatedDate);
        }
        productobj.orderStatus = sales.BrazilSalesOrderStatus__c;
        if(sales.Total_Value_Brazil__c != null){
            if(sales.Type_of_Order__c == 'BONIFICAÇÃO' || sales.Type_of_Order__c == 'REMESSA PARA TESTE'){
                productobj.orderTotal = '-';
            }else{
                productobj.orderTotal = String.valueOf(sales.Total_Value_Brazil__c.setScale(0));
            }
        }
        if(sales.Sold_to_Party__r.Tax_Number_1__c != null && sales.Sold_to_Party__r.TaxNumber2__c != null){
            productobj.CNPG_CPF =  sales.Sold_to_Party__r.Tax_Number_1__c+' /'+sales.Sold_to_Party__r.TaxNumber2__c;
        }else if(sales.Sold_to_Party__r.Tax_Number_1__c!= null){
            productobj.CNPG_CPF =  sales.Sold_to_Party__r.Tax_Number_1__c;
        }else{
            productobj.CNPG_CPF =  sales.Sold_to_Party__r.TaxNumber2__c;
        }
        productobj.SAPOrderNo = sales.SAP_Order_Number__c;
        productobj.SFDCOrderNo = sales.SalesOrderNumber_Brazil__c;
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
        productobj.soldToPartyEmail = sales.Sold_To_Party__r.Email__c;
        productobj.soldToPartyBillingStreet = sales.Sold_To_Party__r.BillingStreet;
        productobj.soldToPartyBillingCity = sales.Sold_To_Party__r.BillingCity;
        productobj.soldToPartyBillingState = sales.Sold_To_Party__r.BillingState;
        productobj.soldToPartyBillingCountry = sales.Sold_To_Party__r.BillingCountry;
        productobj.soldToPartyBillingPostalCode = sales.Sold_To_Party__r.BillingPostalCode;
        productobj.soldToPartyCustomerRegion = sales.Sold_To_Party__r.Customer_Region__c;
        productobj.soldToPartyTax3 = sales.Sold_To_Party__r.Tax_Number_3__c;
        productobj.city = sales.Brazil_City__c;
        productobj.paymentTerm = sales.Payment_Term__r.Payterms_Desc__c;
        productobj.campaignPaymentTerm = sales.Campaign_Payment_Term_Date__c;
        productobj.maturityDate = sales.Maturity_Date__c;
        productobj.reloadPaymentTerm = sales.ReloadPaymentTerms__c;
        productobj.paymentMethod = sales.PaymentMethod__r.Name;
        productobj.shippingType = sales.Inco_Term__r.Name;
        productobj.invoiceMessage = sales.Invoice_Message__c;
        productobj.obs = sales.Sales_order_OBS__c;
        productobj.punchDiscount = sales.Punctuality_Discount__c;
        productobj.campaignType = sales.Campaign_Type__c;
        productobj.finalTotal = sales.Text_Cal_Brazil__c;
        if(sales.Currency_Brazil__c != null){
            if(sales.Currency_Brazil__c == 'Billing BRL / Payment BRL'){
                productobj.crncy = 'Real – BRL';
            }else if(sales.Currency_Brazil__c == 'Billing USD / Payment BRL'){
                productobj.crncy = 'Dólar – USD';
            }else if(sales.Currency_Brazil__c == 'Billing USD / Payment USD'){
                productobj.crncy = 'Dólar – USD';
            }
        }     
        productobj.invoiceStatus = sales.Invoice_Status__c;

        List<LineItemWrap> lineWrapList = new List<LineItemWrap>();
        for(Sales_Order_Line_Item__c so : lineitem){
            LineItemWrap lineWrap = new LineItemWrap();
            lineWrap.Id = so.Id;
            lineWrap.skuCode = so.SKU_Code__c;
            lineWrap.productName = so.Brazil_Product__c;
            lineWrap.uom = so.UOM__c;
            lineWrap.qty = so.Quantity__c;
            lineWrap.unitVal = so.UnitValue__c;
            lineWrap.fatDate = so.DateofFAT__c;
            lineWrap.amt = so.TotalValueWithoutInterest__c;
            lineWrapList.add(lineWrap);
        }
        productobj.lineItemList = lineWrapList;
        soPDF = productobj;
        SYSTEM.DEBUG('soPDF==>'+soPDF);
        } catch (Exception ex) {
            system.debug('exc ==> ' +ex);
        }
        
    }

    @AuraEnabled
    public static ResultWrapper getFiles(String invoiceId, String fileType) {
        ResultWrapper wrapper = new ResultWrapper();
        Invoice__c invoice = [SELECT id,
                                Invoice_key__c,
                                Billing_Doc_Number__c,
                                Last_Invoice_Line_Items_Updated__c,
                                Last_Invoice_Line_Items_Updated_Status__c,
                                SuccessFull_Invoice_Line_Items_Updated__c,
                                Nota_Fiscal__c
                                FROM Invoice__c 
                                WHERE Id = :invoiceId];

        list<ContentDocumentlink> cdl = [SELECT Id, LinkedEntityId, ContentDocumentId,
                                ContentDocument.title,ContentDocument.filetype, 
                                IsDeleted, SystemModstamp, ShareType, Visibility
                                FROM ContentDocumentLink where 
                                LinkedEntityId =:invoiceId AND
                                ContentDocument.title = :invoice.Nota_fiscal__c AND
                                ContentDocument.filetype =:fileType];

        if(!cdl.isEmpty()){
            wrapper.success = true;
            wrapper.contentId = cdl[0].ContentDocumentId;
        }else{
            string endpoint = UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint__c + invoice.Invoice_key__c;
            String userName = UPL_Settings__c.getOrgDefaults().DOC_API_UserName__c;
            String password = UPL_Settings__c.getOrgDefaults().DOC_API_PassWord__c;
            String extentionType;
            if(!String.isEmpty(fileType) && fileType == 'PDF'){
                extentionType = '.pdf';
                endpoint += UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint_Ext_PDF__c;
            }else if(!String.isEmpty(fileType) && fileType == 'XML'){
                extentionType = '.xml';
                endpoint += UPL_Settings__c.getOrgDefaults().DOC_API_Endpoint_Ext_XML__c;        
            }
            try {
                // Below changes to change authorization to get invoice doc from MasterSaf RITM0427255 GRZ(Nikhil Verma) 27-09-2022
                Http http = new Http();
                HttpRequest request = new HttpRequest(); 
                String token = GenerateToken();   
                request.setTimeout(120000);
                request.setMethod('GET');
                request.setEndpoint(endpoint);        
                request.setHeader('Authorization', 'Bearer ' + token);
                HttpResponse response = http.send(request); 
                if (response.getStatusCode() == 200) {
                    ContentVersion cv = new ContentVersion();
                    cv.Title = invoice.Nota_Fiscal__c;
                    cv.PathOnClient = invoice.Nota_Fiscal__c + extentionType;
                    cv.VersionData = response.getBodyAsBlob();
                    cv.IsMajorVersion = true;
                    Insert cv;
                    system.debug(cv);
                    //Get Content Documents
                    List<ContentDocument> docList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where LatestPublishedVersionId = :cv.Id];
                    //Create ContentDocumentLink 
                    ContentDocumentLink contentDocLink = New ContentDocumentLink();
                    contentDocLink.LinkedEntityId = invoiceId;
                    contentDocLink.ContentDocumentId = docList[0].Id;
                    contentDocLink.shareType = 'I';
                    contentDocLink.Visibility = 'AllUsers';
                    Insert contentDocLink;
                    if(cdl != null){
                        wrapper.success = true;
                        wrapper.contentId = contentDocLink.ContentDocumentId;
                    }else{
                        wrapper.success = false;
                    }
                }else{
                    wrapper.success = false;
                    system.debug(response.getBody());
                }
            } catch (exception e) {
                system.debug(e.getMessage()+'\n'+e.getLineNumber()+'\n'+e.getCause());
                wrapper.success = false;
            }
        }
        return wrapper;
    }

    /******************************************************************************************************
    * @Description        : This method will generate token for Master Saf
    * Date                : 27/09/2022 
    * Author              : Nikhil Verma (Grazitti)                                                                  
    * @Return             : String
    * Ticket              : RITM0427255
    *******************************************************************************************************/
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

    public class ResultWrapper {
        @AuraEnabled public String contentId {get;set;}
        @AuraEnabled public Boolean success {get;set;}
    }
    public class ProductDetailWrapper {
        @AuraEnabled public List<LineItemWrap> lineItemList {get;set;}  
        @AuraEnabled public  List<InvoiceWrap> InvoiceDetails{get;set;}
        @AuraEnabled public String orderType {get;set;}
        @AuraEnabled public String orderDate {get;set;}
        @AuraEnabled public String orderStatus {get;set;}
        @AuraEnabled public String orderTotal {get;set;}
        @AuraEnabled public String SAPOrderNo {get;set;}
        @AuraEnabled public String SFDCOrderNo {get;set;}
        @AuraEnabled public String repName {get;set;}
        @AuraEnabled public String soldToParty {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String crncy {get;set;}
        @AuraEnabled public String paymentTerm {get;set;}
        @AuraEnabled public String invoiceStatus {get;set;}
        
        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        @AuraEnabled public String CNPG_CPF {get;set;}
        @AuraEnabled public String purchaseOrderNumber {get;set;}
        @AuraEnabled public String ownerName {get;set;}
        @AuraEnabled public String soldToPartyEmail {get;set;}
        @AuraEnabled public String soldToPartyBillingStreet {get;set;}
        @AuraEnabled public String soldToPartyBillingCity {get;set;}
        @AuraEnabled public String soldToPartyBillingState {get;set;}
        @AuraEnabled public String soldToPartyBillingCountry {get;set;}
        @AuraEnabled public String soldToPartyBillingPostalCode {get;set;}
        @AuraEnabled public String soldToPartyCustomerRegion {get;set;}
        @AuraEnabled public String soldToPartyTax3 {get;set;}
        @AuraEnabled public Date campaignPaymentTerm {get;set;}
        @AuraEnabled public Date maturityDate {get;set;}
        @AuraEnabled public String reloadPaymentTerm {get;set;}
        @AuraEnabled public String paymentMethod {get;set;}
        @AuraEnabled public String shippingType {get;set;}
        @AuraEnabled public String invoiceMessage {get;set;}
        @AuraEnabled public String obs {get;set;}
        @AuraEnabled public String campaignType {get;set;}
        @AuraEnabled public Decimal punchDiscount {get;set;}
        @AuraEnabled public Decimal finalTotal {get;set;}
    }
    public class InvoiceWrap {
        @AuraEnabled public Id ivId {get;set;}
        @AuraEnabled public String billingDocNumber {get;set;}
        @AuraEnabled public String billingDate {get;set;}
        @AuraEnabled public String totalAmount {get;set;}
        @AuraEnabled public String billingStatus {get;set;}
        @AuraEnabled public String invoiceKey {get;set;}
    }
    public class LineItemWrap {
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String skuCode {get;set;}
        @AuraEnabled public String productName {get;set;}
        @AuraEnabled public String quantity {get;set;}
        @AuraEnabled public String uom {get;set;}
        @AuraEnabled public String unitPrice {get;set;}
        @AuraEnabled public String totalValue {get;set;}

        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        @AuraEnabled public Decimal qty {get;set;}
        @AuraEnabled public Decimal unitVal {get;set;}
        @AuraEnabled public Date fatDate {get;set;}
        @AuraEnabled public Decimal amt {get;set;}
    }
}