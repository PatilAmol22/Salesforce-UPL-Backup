public class Grz_InvoiceDetailClassMexico {
    
    @AuraEnabled(cacheable=true)
    public static InvoiceDetailWrapper getInvoiceDetailList(String urlapex) {       
        Id id = UserInfo.getUserId(); // getting current user info
        System.debug('id'+id);
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accId = new Set<Id>();
            /*if(!String.isEmpty(groupCstr)){
                for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND ParentId =:accountId]){
                    accId.add(ac.Id);
                }
            }*/
        accId.add(accountId);
        String query = 'Select Id, Name, Billing_Doc_Number__c, Billing_Date__c, Sales_Order__c,Sales_Order__r.Invoice_Status__c, TotalSalesAmount__c, Billing_Status__c, Acknowledge__c,Mexico_E_Invoice__c,Sold_To_Party__r.Name, (Select Id,Product__r.Name, SKU__r.SKU_Code__c, Quantity__c, UOM__c, Net_Value__c, Net_Price_Per_Unit__c,SKU_Description__c from Invoice_Line_Item__r) from Invoice__c';
        query += ' where Id =: urlapex ';
        
        /*if(!String.isEmpty(accountId)) {
            if(!query.contains('where'))
                query +=  ' where Sold_to_Party__c In: accId';
            else
                query += ' and Sold_to_Party__c In: accId';
        }*/
        system.debug('---query---'+query);
        List<Invoice__c> invList = Database.query(query); 
        List<Invoice_Line_Item__c> invoiceLineItemList = new List<Invoice_Line_Item__c>();
        Invoice__c invoice = new Invoice__c();
        for(Invoice__c invoiceObj : invList) {
            invoice = invoiceObj;
            invoiceLineItemList.addAll(invoiceObj.Invoice_Line_Item__r);
        }
        
        InvoiceDetailWrapper invoiceDetailobj = new InvoiceDetailWrapper();
        Set<Id> contentLinkId = new Set<Id>();
        for (ContentDocumentLink contentId : [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =:urlapex]) {
            contentLinkId.add(contentId.ContentDocumentId);
        }
        MAP<String,Id> mapVersion = new MAP<String,Id>();
        if(!contentLinkId.isEmpty()){
            for (ContentVersion contentVer : [SELECT Id, ContentDocumentId,FileType FROM ContentVersion where ContentDocumentId IN: contentLinkId]) {
                mapVersion.put(contentVer.FileType, contentVer.ContentDocumentId);
            }
        }
        invoiceDetailobj.InvoiceName = invoice.Name;
        invoiceDetailobj.billNumber = invoice.Billing_Doc_Number__c;
        invoiceDetailobj.soldToParty = invoice.Sold_To_Party__r.Name;
        if(invoice.TotalSalesAmount__c != null){
            invoiceDetailobj.totalValue = String.valueOf(invoice.TotalSalesAmount__c.setScale(0));
        }
        if(invoice.Billing_Date__c != null){
            invoiceDetailobj.billDate = grz_SapIntegration.FormattedDateMexico(invoice.Billing_Date__c);
        }
        if(invoice.Sales_order__r.Invoice_Status__c != null){
            invoiceDetailobj.orderStatus = invoice.Sales_order__r.Invoice_Status__c;
        }
        invoiceDetailobj.invoicePDF = invoice.Mexico_E_Invoice__c;
        invoiceDetailobj.invoiceStatus = invoice.Billing_Status__c;
        invoiceDetailobj.salesOrderId = invoice.Sales_Order__c;
        invoiceDetailobj.contentDocumentId = contentLinkId;
        invoiceDetailobj.contentMap = mapVersion;
        List<InvoiceLineItemWrap> ListItemWrap = new List<InvoiceLineItemWrap>();
        for(Invoice_Line_Item__c so : invoiceLineItemList){
            InvoiceLineItemWrap lineWrap = new InvoiceLineItemWrap();
            lineWrap.Id = so.Id;
            lineWrap.skuName = so.SKU__r.SKU_Code__c;
            lineWrap.productName = so.SKU_Description__c;
            lineWrap.uom = so.UOM__c;
            if(so.Net_Price_Per_Unit__c != null){
                lineWrap.unitPrice = String.valueOf(so.Net_Price_Per_Unit__c.setScale(2));
            }
            if(so.Quantity__c != null){
                lineWrap.quantity = String.valueOf(so.Quantity__c.setScale(0));
            }
            if(so.Net_Value__c != null){
                lineWrap.netValue = String.valueOf(so.Net_Value__c.setScale(0));
            }
            ListItemWrap.add(lineWrap);
        }
        invoiceDetailobj.invoiceLineItem = ListItemWrap;
        return invoiceDetailobj;
    }
    
    public class InvoiceDetailWrapper { 
        @AuraEnabled
        public List<InvoiceLineItemWrap> invoiceLineItem{get;set;}
        @AuraEnabled public String InvoiceName {get;set;}
        @AuraEnabled public String billNumber {get;set;}
        @AuraEnabled public String soldToParty {get;set;}
        @AuraEnabled public String orderStatus {get;set;}
        @AuraEnabled public String totalValue {get;set;}
        @AuraEnabled public String billDate {get;set;}
        @AuraEnabled public String invoiceStatus {get;set;}
        @AuraEnabled public String salesOrderId {get;set;}
        @AuraEnabled public String invoicePDF {get;set;}
        @AuraEnabled public Set<Id> contentDocumentId {get;set;}
        @AuraEnabled public MAP<String,Id> contentMap {get;set;}
    }
    public class InvoiceLineItemWrap { 
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String skuName {get;set;}
        @AuraEnabled public String productName {get;set;}
        @AuraEnabled public String quantity {get;set;}
        @AuraEnabled public String uom {get;set;}
        @AuraEnabled public String unitPrice {get;set;}
        @AuraEnabled public String netValue {get;set;}

    }
}