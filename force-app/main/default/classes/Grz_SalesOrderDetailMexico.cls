public with sharing  class Grz_SalesOrderDetailMexico {
    
	@AuraEnabled(cacheable=true)
    public static ProductDetailWrapper getProductDetailList(String urlapex) {
        Id id = UserInfo.getUserId(); // getting current user info
        System.debug('id'+id);
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accId = new Set<Id>();
        
        accId.add(accountId);
        String query = 'Select Id, Name,PONumber__c,SalesOrderNumber_Brazil__c,BrazilSalesOrderStatus__c,Brazil_City__c,CurrencyIsoCode,Payment_Term__r.Name,Payment_Term__c,(Select Id, SKU_Code__c,toLabel(Line_Item_Status__c),UOM__c, Value_Number__c,Net_Price_Per_Unit__c,sale_order__c,Brazil_Product__c, ProductName__c, Quantity__c,TotalValueWithoutInterest__c,CreatedDate from Sales_Order_Line_Item__r), (Select Id, Name, Billing_Doc_Number__c, Billing_Date__c, TotalSalesAmount__c, Billing_Status__c,Delivery_Number__c,Mexico_E_Invoice__c,Sold_To_Party__c from Invoice__r), Sold_to_Party__r.Name, SAP_Order_Number__c, CreatedDate,createdby.name, Order_Type_lk__r.Name,Order_Status__c, Total_Amount__c from Sales_Order__c';
        query += ' where Id =: urlapex ';
        /*if(!String.isEmpty(accountId)) {
            if(!query.contains('where')){
                query +=  ' where Sold_to_Party__c In: accId';
            }else{
                query += ' and Sold_to_Party__c In: accId';
            }     
        }*/
        system.debug('---query---'+query);
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
        Set<Id> invoiceId = new Set<Id>();
        List<ContentDocumentLink> ContentDocumentList = new List<ContentDocumentLink>();
        Map<String, Map<String, Id>> contentId = new Map<String, Map<String, Id>>();
        Map<Id,List<String>> contentIdsOnly = new Map<Id,List<String>>();
        Set<Id> contentIds = new Set<Id>();
        
        productobj.orderType = sales.Order_Type_lk__r.name;
        productobj.PONumber = sales.PONumber__c;
        if(sales.CreatedDate != null){
            productobj.orderDate = grz_SapIntegration.FormattedDateMexico(sales.CreatedDate);
        }
        productobj.orderStatus = sales.BrazilSalesOrderStatus__c;
        if(sales.Total_Amount__c != null){
            productobj.orderTotal = String.valueOf(sales.Total_Amount__c.setScale(2));
        }
        productobj.SAPOrderNo = sales.SAP_Order_Number__c;
        productobj.SFDCOrderNo = sales.SalesOrderNumber_Brazil__c;
        
        String name = sales.CreatedBy.Name;
		productobj.repName = name;
        
        productobj.soldToParty = sales.Sold_To_Party__r.Name;
        productobj.city = sales.Brazil_City__c;
        productobj.crncy = sales.CurrencyIsoCode;
        if(sales.Payment_Term__c != null){
            productobj.paymentTerm = sales.Payment_Term__r.Name.split('-')[0];
        }  
        productobj.contentDocumentIds = contentId; // Content doc id
        List<InvoiceWrap> ivWrapList = new List<InvoiceWrap>();
        List<LineItemWrap> lineWrapList = new List<LineItemWrap>();
        for(Invoice__c iv : finalinvoiceList){
            InvoiceWrap ivWrap = new InvoiceWrap();
            ivWrap.ivId = iv.Id;
            if(iv.Billing_Doc_Number__c != null){
                ivWrap.billingDocNumber = iv.Billing_Doc_Number__c;
            }
            if(iv.Billing_Date__c != null){
                ivWrap.billingDate = grz_SapIntegration.FormattedDateMexico(iv.Billing_Date__c);
            }
            if(iv.TotalSalesAmount__c != null){
                ivWrap.totalAmount = String.valueOf(iv.TotalSalesAmount__c.setScale(2));
            }
            ivWrap.billingStatus = iv.Billing_Status__c;
            ivWrap.deliveryNumber = iv.Delivery_Number__c;
            
            if(iv.Mexico_E_Invoice__c != null){
            	ivWrap.invoicePDF = 'data:application/pdf;base64,'+iv.Mexico_E_Invoice__c;                
            }
            
            if(iv.Billing_Doc_Number__c != null){
                ivWrap.invoicePDFName = iv.Billing_Doc_Number__c+'.pdf';
            }
            else{
                ivWrap.invoicePDFName = iv.Name+'.pdf';
            }
            
            ivWrapList.add(ivWrap);
        }
        Map<Id,String> DeliverynumberMap = new Map<Id,String>();
        if(urlapex != null){
            for(Dispatch__c dobj : [Select id,Name,Deliverynumber__c,Sales_Order__c,SalesOrderLineItem__c,Customer__c from Dispatch__c where Sales_Order__c =: urlapex]){
            	DeliverynumberMap.put(dobj.SalesOrderLineItem__c,dobj.Deliverynumber__c);
        	}
        }
        
        String datestr = System.Label.Grz_OrderItemStatusDate;
        Date dt =  Date.valueOf(datestr);
        
        for(Sales_Order_Line_Item__c so : lineitem){
            LineItemWrap lineWrap = new LineItemWrap();
            lineWrap.Id = so.Id;
            lineWrap.skuCode = so.SKU_Code__c;
            lineWrap.productName = so.Brazil_Product__c;
            lineWrap.uom = so.UOM__c;
            lineWrap.status = so.Line_Item_Status__c;
            
            if((lineWrap.status == null || lineWrap.status == 'Pedido Entregado al Cliente') && so.CreatedDate >= dt){
                lineWrap.status = 'Entregado';
            }
            if(so.Quantity__c != null){
                lineWrap.quantity = String.valueOf(so.Quantity__c);
            }
            if(so.Net_Price_Per_Unit__c  != null){
                lineWrap.unitPrice = String.valueOf(so.Net_Price_Per_Unit__c .setScale(2));
            }
            if(so.Value_Number__c != null){
                lineWrap.totalValue = String.valueOf(so.Value_Number__c.setScale(2));
            }
            if(!DeliverynumberMap.isEmpty() && DeliverynumberMap.containsKey(so.Id)){
                if(DeliverynumberMap.get(so.Id)!=null){
                    lineWrap.deliveryNumber = DeliverynumberMap.get(so.Id);
                }
            }
            lineWrapList.add(lineWrap);
        }
        productobj.lineItemList = lineWrapList;
        productobj.InvoiceDetails = ivWrapList;
        system.debug('productobj.InvoiceDetails : '+productobj.InvoiceDetails);
        return productobj;
    }
    
    public class ProductDetailWrapper {
         
        //@AuraEnabled public Sales_Order__c salesList {get;set;}
        @AuraEnabled
        public List<LineItemWrap> lineItemList {get;set;}  
        @AuraEnabled
        public  List<InvoiceWrap> InvoiceDetails{get;set;}
        @AuraEnabled public String orderType {get;set;}
        @AuraEnabled public String orderDate {get;set;}
        @AuraEnabled public String orderStatus {get;set;}
        @AuraEnabled public String PONumber {get;set;}
        @AuraEnabled public String orderTotal {get;set;}
        @AuraEnabled public String SAPOrderNo {get;set;}
        @AuraEnabled public String SFDCOrderNo {get;set;}
        @AuraEnabled public String repName {get;set;}
        @AuraEnabled public String soldToParty {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String crncy {get;set;}
        @AuraEnabled public String paymentTerm {get;set;}
        @AuraEnabled public Map<String, Map<String, Id>> contentDocumentIds {get;set;}
    }
    public class InvoiceWrap {
        @AuraEnabled public Id ivId {get;set;}
        @AuraEnabled public String billingDocNumber {get;set;}
        @AuraEnabled public String billingDate {get;set;}
        @AuraEnabled public String totalAmount {get;set;}
        @AuraEnabled public String billingStatus {get;set;}
        @AuraEnabled public String deliveryNumber {get;set;}
        @AuraEnabled public String invoicePDF {get;set;}
        @AuraEnabled public String invoicePDFName {get;set;}
    }
    public class LineItemWrap {
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String skuCode {get;set;}
        @AuraEnabled public String productName {get;set;}
        @AuraEnabled public String quantity {get;set;}
        @AuraEnabled public String uom {get;set;}
        @AuraEnabled public String unitPrice {get;set;}
        @AuraEnabled public String totalValue {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String deliveryNumber {get;set;}
    }
}