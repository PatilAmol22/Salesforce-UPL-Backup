public without sharing class InvoiceSummary {

    public Map<Id,WrapperInvoiceSummary> wrapperlist{get;set;}
    public List<Community_Configuration__c> ccList{get;set;}
    public string countryName {get;set;}
    public Boolean isChild {get;set;}
    public string parentAccountName {get;set;}
    public string parentSAPCode {get;set;}
    public string childAccountName {get;set;}
    public string childSAPCode {get;set;}

    public InvoiceSummary(){

        Map<String,Invoice_Line_Item__c> invoiceMap=new Map<String,Invoice_Line_Item__c>();
        List<Invoice_Line_Item__c> invoiceList=new List<Invoice_Line_Item__c>();
        wrapperlist=new Map<Id,WrapperInvoiceSummary>();
        ccList = new List<Community_Configuration__c>();

        String pageNumber=ApexPages.CurrentPage().getParameters().get('pgNo');
        String pageSize=ApexPages.CurrentPage().getParameters().get('pgSize');
        String InvoiceNo=ApexPages.CurrentPage().getParameters().get('inNo');
        String SalesOrderNo=ApexPages.CurrentPage().getParameters().get('soNo');
        String SAPOrderNo=ApexPages.CurrentPage().getParameters().get('sapON');
        String InvoiceDateFrom=ApexPages.CurrentPage().getParameters().get('invDateFrom');
        String InvoiceDateTo=ApexPages.CurrentPage().getParameters().get('invDateTo');
        String Product=ApexPages.CurrentPage().getParameters().get('prod');
        String PONumber=ApexPages.CurrentPage().getParameters().get('poNo');
        String uId=ApexPages.CurrentPage().getParameters().get('userAccId');
        String Country=ApexPages.CurrentPage().getParameters().get('cntry');
        system.debug('Country'+Country);
        String query = '';
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        countryName = Country;

        id userId = UserInfo.getUserId();
        User u = [select id, contactId, accountId, Account.Name, Account.SAP_Code__c, Country from User where id = : userId];
        String userAccountId = u.accountId;
        if(userAccountId==uId){
            isChild = false;            
        }else{
            isChild = true;
            parentAccountName = u.Account.Name;
            parentSAPCode = u.Account.SAP_Code__c;
        }
        if(uId.length()>18){
            uId = uId;
        }else{
            uId = '\''+uId+'\'';
        }
        
            if(!String.isBlank(uId) && u.Country=='Japan'){
                query='SELECT Id,Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Invoice_Date__c=LAST_N_DAYS:365 order by CreatedDate desc';
                
            }
            if(!String.isBlank(InvoiceNo)){
                query='SELECT Id,Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c, SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(SalesOrderNo)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' order by CreatedDate desc ';
                
            } 
            if(!String.isBlank(SAPOrderNo)){
                query='SELECT Id,Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.SAP_Order_Number__c= \''+SAPOrderNo+'\' order by CreatedDate desc ';
                
            } 
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' order by CreatedDate desc ';
                
            } 
            if(!String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND SKU_Description__c = \''+Product+'\'  order by CreatedDate desc ';
                
            }
            if(!String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.PO_Number__c = \''+PONumber+'\'  order by CreatedDate desc ';
                
            }            
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND SKU_Description__c = \''+Product+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(Product) ){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(PONumber) ){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\'  order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\'  order by CreatedDate desc ';
                
            }
            if(!String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }            
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }            
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Sold_To_Party__r.Name,Invoice__r.Sold_To_Party__r.SAP_Code__c,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.SAP_Order_Number__c!=\'\' and Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' order by CreatedDate desc ';
                
            }
            invoiceList= Database.query(query);

        Map<Integer, String> turkeyDates = new Map<Integer, String>();
                turkeyDates.put(1, 'Oca');
                turkeyDates.put(2, 'şub');
                turkeyDates.put(3, 'Mar');
                turkeyDates.put(4, 'Nis');
                turkeyDates.put(5, 'May');
                turkeyDates.put(6, 'Haz');
                turkeyDates.put(7, 'Tem');
                turkeyDates.put(8, 'Ağu');
                turkeyDates.put(9, 'Eyl');
                turkeyDates.put(10, 'Eki');
                turkeyDates.put(11, 'Kas');
                turkeyDates.put(12, 'Ara');
        for(Invoice_Line_Item__c i : invoiceList){
            invoiceMap.put(i.Invoice__r.Billing_Doc_Number__c,i);
        }

        for( Invoice_Line_Item__c f : invoiceMap.values())
            {
                WrapperInvoiceSummary wrapperObj=new WrapperInvoiceSummary();
                    wrapperObj.Id=f.Invoice__c;
                    wrapperObj.Billing_Doc_Number=f.Invoice__r.Billing_Doc_Number__c;
                    wrapperObj.Sales_Order_No='\''+f.Invoice__r.Sales_Order_No__c+'\'';
                    wrapperObj.SAP_Order_No=f.Invoice__r.SAP_Order_Number__c;
                    wrapperObj.PO_Number=f.Invoice__r.PO_Number__c;
                    Date invdate=f.Invoice__r.Invoice_Date__c;
                    Datetime myDatetime = invdate;
                    wrapperObj.Invoice_Date=String.valueOf(f.Invoice__r.Invoice_Date__c.Day())+'-'+String.valueOf(f.Invoice__r.Invoice_Date__c.Month())+'-'+String.valueOf(f.Invoice__r.Invoice_Date__c.Year());
                    if(Country=='Turkey'){
                        wrapperObj.Invoice_Date = String.valueOf(f.Invoice__r.Invoice_Date__c.day()) +' '+ turkeyDates.get(f.Invoice__r.Invoice_Date__c.month()) +' '+ String.valueOf(f.Invoice__r.Invoice_Date__c.year());
                    }else if(Country=='Japan'){
                        wrapperObj.Invoice_Date = myDatetime.format('yyyy-MM-dd');
                    }
                    //wrapperObj.wCurrency=f.Invoice__r.CurrencyIsoCode;
                    if(Country!='Japan'){
                        wrapperObj.Doc_Amount=f.Invoice__r.TotalAmountCurrency__c.setScale(2); 
                    }else{
                        wrapperObj.Doc_Amount=(f.Invoice__r.TotalAmountCurrency__c).setScale(2);
                    }                        
                    wrapperObj.DocAmount=String.valueOf(f.Invoice__r.TotalAmountCurrency__c.setScale(2)).replace('.',',');
                    wrapperObj.SKUDesc=f.SKU_Description__c;
                    wrapperObj.Quantity=String.valueOf(f.Quantity__c);
                    wrapperObj.childAccountName=f.Invoice__r.Sold_To_Party__r.Name;
                    wrapperObj.childSAPCode=f.Invoice__r.Sold_To_Party__r.SAP_Code__c;                                        
                    wrapperlist.put(f.Invoice__r.Id,wrapperObj);
                
            }
    }


    @AuraEnabled(cacheable = true)
    public static List<user> fetchUser(){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        List<user> u = new List<User>();
        u = [select id, Name, contactId, accountId,Country,account.SAP_Code__c from User where id = : userId];
        return u;
    }

    @AuraEnabled(cacheable = true)
    public static List<Community_Url_Configuration__c> fetchURL(){
        
        List<Community_Url_Configuration__c> url = new List<Community_Url_Configuration__c>();
        url = [SELECT Id, Name, URL__c FROM Community_Url_Configuration__c WHERE  Name ='Distributors Community URL' Limit 1];
        return url;
    }

    @AuraEnabled(cacheable = true)
    public static List<Parent_Child_Mapping__c> findChildAccounts(){
        id userId = UserInfo.getUserId();
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        List<Parent_Child_Mapping__c> childList = new List<Parent_Child_Mapping__c>();    
        childList = [select Parent_Account__c, Child_Account__c, Child_Account__r.Name, Active__c from Parent_Child_Mapping__c where Parent_Account__c=:u.accountId and Active__c=True];        
        return childList;
    }

    @AuraEnabled(cacheable = true)
    public static Integer getInvoiceSummaryCount(String InvoiceNo,String SalesOrderNo, String SAPOrderNo,String InvoiceDateFrom,String InvoiceDateTo,String Product,String PONumber,String uId,String Country){
        String query = '';
        Map<String,Invoice_Line_Item__c> invoiceMap1=new Map<String,Invoice_Line_Item__c>();
        List<Invoice_Line_Item__c> invoiceList=new List<Invoice_Line_Item__c>();
        Integer count=0;
        List<user> u = new List<User>();
        u = [select id, Name, contactId, accountId,Country from User where id = : UserInfo.getUserId()];
        if(uId.length()>18){
            uId = uId;
        }else{
            uId = '\''+uId+'\'';
        }
        //In Poland SalesOrderNo used as Invoice Number(invoice billing doc number) and In other countries SalesOrderNo used for Sales Order Number.

        /*if(Country=='Poland'){

            if(!String.isBlank(SalesOrderNo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Billing_Doc_Number__c= \''+SalesOrderNo+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\' AND SKU_Description__c = \''+Product+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Billing_Doc_Number__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Billing_Doc_Number__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Billing_Doc_Number__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\'  AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }

        }else{*/
            //1
            if(!String.isBlank(uId) && u[0].Country=='Japan'){
                query='SELECT Id,Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+')';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SAPOrderNo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.SAP_Order_Number__c= \''+SAPOrderNo+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND SKU_Description__c = \''+Product+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            //2
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND SKU_Description__c = \''+Product+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(PONumber) ){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            //3
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+' AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            //4
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+' AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+' AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            /*
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\'  ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\'  AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
            if(!String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Billing_Doc_Number__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c = \''+uId+'\'  AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                invoiceList= Database.query(query);
            }
        //}*/
                
                
                /*else{
            query='SELECT count() FROM Invoice_Line_Item__c Where Invoice__r.Sold_To_Party__c = \''+uId+'\'';
            count = Database.countQuery(query);
        }*/
        for(Invoice_Line_Item__c i : invoiceList){
            invoiceMap1.put(i.Invoice__r.Billing_Doc_Number__c,i);
        }
        count=invoiceMap1.values().size();
        system.debug('count-->'+count);
        system.debug('Map count-->'+invoiceMap1.values().size());
        //return [SELECT Id, Name, Sales_Order_No__c, PO_Number__c, Invoice_Date__c, CurrencyIsoCode, TotalAmount__c FROM Invoice__c order by CreatedDate desc LIMIT 5 ];
        return count;
    }
    //Change by Grazitti team for Community adoption RITM0429236 12Oct22
    @AuraEnabled(cacheable = true)
    public static List<WrapperInvoiceSummary> getInvoiceSummary(String InvoiceNo,String SalesOrderNo,String SAPOrderNo,String InvoiceDateFrom,String InvoiceDateTo,String Product,String PONumber,String uId,String Country){
        String query = '';
        //Integer psize = Integer.valueOf(pageSize);
        //Integer pnumber = Integer.valueOf(pageNumber)-1;
        
        List<user> u = new List<User>();
        u = [select id, Name, contactId, accountId,Country from User where id = : UserInfo.getUserId()];
        Map<String,Invoice_Line_Item__c> invoiceMap2=new Map<String,Invoice_Line_Item__c>();
        List<Invoice_Line_Item__c> invoiceList=new List<Invoice_Line_Item__c>();
        List<WrapperInvoiceSummary> wrapperlist=new List<WrapperInvoiceSummary>();
        String OrderType='ZJWH';
        if(uId.length()>18){
            uId = uId;
        }else{
            uId = '\''+uId+'\'';
        }
        
            if(!String.isBlank(uId) && u[0].Country=='Japan'){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c,Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+')';
                
                
            }
            if(!String.isBlank(InvoiceNo)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c,Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' ';
                
                
            }
            if(!String.isBlank(SalesOrderNo)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c,Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN  ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' ';
                
                
            } 
                if(!String.isBlank(SAPOrderNo)){
                query='SELECT Id, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+')';
                if(u[0].Country=='Japan'){
                    query+= ' AND Sales_Order_Line_Item__r.Invoice_Reflection_Code__c= \''+SAPOrderNo+'\' '; 
                }
                else{
                 query+= ' AND Invoice__r.SAP_Order_Number__c= \''+SAPOrderNo+'\' ';
                }
                
            } 
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                                
                            } 
            if(!String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND SKU_Description__c = \''+Product+'\'  ';
                
                
            }
            if(!String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.PO_Number__c = \''+PONumber+'\'  ';
                
                
            }
            //2
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND SKU_Description__c = \''+Product+'\' ';
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
                
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                
                
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(Product) ){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' ';
                
                
            }
            if(!String.isBlank(SalesOrderNo) && !String.isBlank(PONumber) ){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
                
            }
            if(!String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
                
            }
            //3
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c,Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c, Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
            }
            //4
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(Product)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c,Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND SKU_Description__c = \''+Product+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(InvoiceDateFrom) && !String.isBlank(InvoiceDateTo) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND Invoice__r.Invoice_Date__c >= '+InvoiceDateFrom+'  AND Invoice__r.Invoice_Date__c <= '+InvoiceDateTo+' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
                
            }
            if(!String.isBlank(InvoiceNo) && !String.isBlank(SalesOrderNo) && !String.isBlank(Product) && !String.isBlank(PONumber)){
                query='SELECT Id, Invoice__r.Ship_to_Party__r.Location_Name__c, Invoice__r.Sales_Order__r.Order_Type_lk__r.Name,SKU_Description__c,Quantity__c,Invoice__r.SAP_Order_Number__c, Invoice__r.Name,Invoice__r.Billing_Doc_Number__c, Invoice__r.Sales_Order_No__c, Invoice__r.PO_Number__c, Invoice__r.Invoice_Date__c, Invoice__r.CurrencyIsoCode, Invoice__r.TotalAmount__c,Product__r.Name,Sales_Order__r.Total_Amount__c,Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c,Invoice__r.TotalAmountCurrency__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c,Invoice__r.Sold_To_Party__r.Name FROM Invoice_Line_Item__c where Invoice__r.TotalAmountCurrency__c!=0 AND Invoice__r.Sold_To_Party__c  IN ('+uId+') AND Invoice__r.Billing_Doc_Number__c= \''+InvoiceNo+'\' AND Invoice__r.Sales_Order_No__c= \''+SalesOrderNo+'\' AND SKU_Description__c = \''+Product+'\' AND Invoice__r.PO_Number__c = \''+PONumber+'\' ';
                
            }
            if(u[0].Country=='Japan'){
                query+='AND Invoice__r.Invoice_Date__c=LAST_N_DAYS:365 AND Invoice__r.Sales_Order__r.Order_Type_lk__r.Name='+'\''+'ZJWH'+'\' order by CreatedDate desc ';
            }else{
                query+='order by CreatedDate desc';
            }
            
        invoiceList= Database.query(query);
      //  System.debug('invoice list'+invoiceList.size());
        for(Invoice_Line_Item__c i : invoiceList){    
            invoiceMap2.put(i.Invoice__r.Billing_Doc_Number__c,i);  
        }
    //system.debug('Map size-->'+invoiceMap2.values().size());        
        
    //List<Invoice_Line_Item__c>l1=new List<Invoice_Line_Item__c>();
      //  l1.addAll(invoiceMap2.values());

        for( Invoice_Line_Item__c f : invoiceMap2.values())
            {      
                WrapperInvoiceSummary wrapperObj=new WrapperInvoiceSummary();
                    wrapperObj.Id=f.Invoice__c;
                    wrapperObj.Billing_Doc_Number=f.Invoice__r.Billing_Doc_Number__c;
                    wrapperObj.Sales_Order_No=f.Invoice__r.Sales_Order_No__c;
                    wrapperObj.PO_Number=f.Invoice__r.PO_Number__c;
                    wrapperObj.Invoice_Date=String.valueOf(f.Invoice__r.Invoice_Date__c);
                    wrapperObj.SAP_Order_No=f.Invoice__r.SAP_Order_Number__c;
                    wrapperObj.ShiptoParty=f.Invoice__r.Ship_to_Party__r.Location_Name__c;
                    if(f.Sales_Order_Line_Item__r.Invoice_Reflection_Code__c!=null)
                    {
                    wrapperObj.invoiceReflectionCode=f.Sales_Order_Line_Item__r.Invoice_Reflection_Code__c;
                    }

                    //wrapperObj.wCurrency=f.Invoice__r.CurrencyIsoCode;
                    if(u[0].Country=='Japan'){
                        wrapperObj.Doc_Amount=f.Invoice__r.TotalAmountCurrency__c;
                    }else{
                        wrapperObj.Doc_Amount=f.Invoice__r.TotalAmountCurrency__c;
                    }                   
                    wrapperObj.SKUDesc=f.SKU_Description__c;
                    wrapperObj.Quantity=String.valueOf(f.Quantity__c);
                    wrapperObj.accountName=f.Invoice__r.Sold_To_Party__r.Name;
                
                    wrapperlist.add(wrapperObj);             
                
            }

        //return [SELECT Id, Name, Sales_Order_No__c, PO_Number__c, Invoice_Date__c, CurrencyIsoCode, TotalAmount__c FROM Invoice__c order by CreatedDate desc LIMIT 5 ];
        /*
        Integer starting=pnumber*10;
        System.debug('starting--'+starting);
        Integer pageRecord=0;
        Integer pgSize=l1.size()/10;
        System.debug('pgSize--'+pgSize);
        System.debug('ttlpages--'+tPages);
        System.debug('ttlpages-->'+Integer.valueOf(tPages));
        System.debug('pageNumber--'+pageNumber);
        Integer ttlPages=Integer.valueOf(tPages);
        if(pgSize==0){
            pgSize=1;
        }
        
        if(l1.size() < 10){
            pageRecord=math.mod(l1.size(),10);
        }
        if(ttlPages==Integer.valueOf(pageNumber)){
            pageRecord=10*(Integer.valueOf(pageNumber)-1);
            pageRecord=pageRecord+math.mod(l1.size(),10);
            if(10*Integer.valueOf(pageNumber)==l1.size()){
                pageRecord=10*(Integer.valueOf(pageNumber));
            }
        }
        if(pageRecord==0){
            pageRecord=10*(Integer.valueOf(pageNumber));
        }
        
        System.debug('pageRecord--'+pageRecord);
        System.debug('l1.size--'+l1.size());
        if(l1.size()!=0){
            System.debug('l1.size--'+l1.size());
        for(Integer i=10*(Integer.valueOf(pageNumber)-1);i<pageRecord;i++){
            System.debug('l1.size--'+l1.size());
            WrapperInvoiceSummary wrapperObj=new WrapperInvoiceSummary();
            System.debug('i---'+i);
                    wrapperObj.Id=l1[i].Invoice__c;
                    System.debug('l1[i]---'+l1[i]);
                    wrapperObj.Billing_Doc_Number=l1[i].Invoice__r.Billing_Doc_Number__c;
                    wrapperObj.Sales_Order_No=l1[i].Invoice__r.Sales_Order_No__c;
                    wrapperObj.SAP_Order_No=l1[i].Sales_Order_Line_Item__r.Sale_Order__r.SAP_Order_Number__c;
                    wrapperObj.PO_Number=l1[i].Invoice__r.PO_Number__c;
                    wrapperObj.Invoice_Date=String.valueOf(l1[i].Invoice__r.Invoice_Date__c);
                    //wrapperObj.wCurrency=f.Invoice__r.CurrencyIsoCode;
                    //wrapperObj.Doc_Amount=l1[i].Invoice__r.TotalAmountCurrency__c;
                    
                        wrapperObj.Doc_Amount=l1[i].Invoice__r.TotalAmountCurrency__c;
                    
                    
                    wrapperlist.add(wrapperObj);
        }
    }
    */
   // System.debug('wrapperlist-----'+wrapperlist.size());
        return wrapperlist;
    }

    public class WrapperInvoiceSummary
        {
            @AuraEnabled
            public String Id{get;set;}
            @AuraEnabled
            public String Billing_Doc_Number{get;set;}
            @AuraEnabled
            public String Sales_Order_No{get;set;}
            @AuraEnabled
            public String SAP_Order_No{get;set;}
            @AuraEnabled
            public String PO_Number{get;set;}
            @AuraEnabled
            public String Invoice_Date{get;set;}
            // @AuraEnabled
            // public String wCurrency{get;set;}
            @AuraEnabled
            public Decimal Doc_Amount{get;set;}
            @AuraEnabled
            public String DocAmount{get;set;}
            @AuraEnabled
            public String SKUDesc{get;set;}
            @AuraEnabled
            public String Quantity{get;set;}
            @AuraEnabled
            public String childAccountName{get;set;}
            @AuraEnabled
            public String childSAPCode{get;set;}
            @AuraEnabled
            public String invoiceReflectionCode{get;set;}
            @AuraEnabled
            public String accountName{get;set;}
            @AuraEnabled
            public String ShiptoParty{get;set;}
    
            public WrapperInvoiceSummary()
            {
                Id='';
                Billing_Doc_Number='';
                Sales_Order_No='';
                SAP_Order_No='';
                PO_Number='';
                Invoice_Date='';
                //wCurrency='';
                Doc_Amount=0.00;
                DocAmount='';
                SKUDesc='';
                Quantity='';
                childAccountName='';
                childSAPCode='';
                invoiceReflectionCode='';
                accountName='';
                ShiptoParty='';
            }
        }

    @AuraEnabled(cacheable = true)
    public static List<WrappergetInvoice> getInvoice(String invoiceId){
        Date iDate;
        List<Invoice__c> invoiceList=new List<Invoice__c>();
        List<WrappergetInvoice> wrapperlist=new List<WrappergetInvoice>();
        List<user> u = new List<User>();
        u = [select id, Name, contactId, accountId,Country from User where id = : UserInfo.getUserId()];
        invoiceList=[SELECT Id, Name, Billing_Doc_Number__c,Sales_Order_No__c, Sales_Order__r.SAP_Order_Number__c,Delivery_Number__c, PO_Number__c,Bill_To_Party__r.Name , Bill_To_Party__r.Customer_Country__c,Invoice_Date__c,Ship_to_Party__c, CurrencyIsoCode, TotalAmount__c, Ship_to_Party__r.Location_Name__c, Sold_To_Party__r.Name,TotalAmountCurrency__c FROM Invoice__c where id=:invoiceId];
        for( Invoice__c i : invoiceList){
            WrappergetInvoice wrapperObj=new WrappergetInvoice();
            wrapperObj.Id=i.id;
            wrapperObj.BillingDocNumber=i.Billing_Doc_Number__c;
            if(u[0].Country=='Japan'){
                wrapperObj.SalesOrderNo=i.Sales_Order__r.SAP_Order_Number__c; 
                wrapperObj.BillToParty=i.Sold_To_Party__r.Name;               
            }else{
                wrapperObj.SalesOrderNo=i.Sales_Order_No__c;
                wrapperObj.BillToParty=i.Bill_To_Party__r.Name;
            }
            wrapperObj.DeliveryNumber=i.Delivery_Number__c;
            wrapperObj.PONumber=i.PO_Number__c;           
            wrapperObj.CurrencyIsoCode=i.CurrencyIsoCode;
            iDate=i.Invoice_Date__c;
            Datetime myDatetime=iDate;
            
            String myDatetimeStr='';
            if(u[0].Country=='Poland'){
                myDatetimeStr = myDatetime.format('dd-MM-yyyy');
            }else if(u[0].Country=='Turkey'){
                Map<Integer, String> turkeyDates = new Map<Integer, String>();
                turkeyDates.put(1, 'Oca');
                turkeyDates.put(2, 'şub');
                turkeyDates.put(3, 'Mar');
                turkeyDates.put(4, 'Nis');
                turkeyDates.put(5, 'May');
                turkeyDates.put(6, 'Haz');
                turkeyDates.put(7, 'Tem');
                turkeyDates.put(8, 'Ağu');
                turkeyDates.put(9, 'Eyl');
                turkeyDates.put(10, 'Eki');
                turkeyDates.put(11, 'Kas');
                turkeyDates.put(12, 'Ara');
                myDatetimeStr = String.valueOf(i.Invoice_Date__c.day()) +' '+ turkeyDates.get(i.Invoice_Date__c.month()) +' '+ String.valueOf(i.Invoice_Date__c.year());
            }else if(u[0].Country=='Japan'){
                myDatetimeStr = myDatetime.format('yyyy-MM-dd');
            }else{
                myDatetimeStr = myDatetime.format('dd-MM-yyyy');
            }
            
            wrapperObj.InvoiceDate=myDatetimeStr;
            //wrapperObj.TotalAmount=i.TotalAmountCurrency__c.round().format();
            if(u[0].Country=='Turkey'){
                wrapperObj.TotalAmount=String.valueOf(i.TotalAmountCurrency__c.setScale(2));
            }else if(u[0].Country=='Japan'){
                wrapperObj.TotalAmount=String.valueOf((i.TotalAmountCurrency__c).setScale(2));
            }else{
                wrapperObj.TotalAmount=String.valueOf(i.TotalAmountCurrency__c.setScale(2));
            }
            
            wrapperObj.SoldToParty=i.Sold_To_Party__r.Name;
            wrapperObj.ShiptoParty=i.Ship_to_Party__r.Location_Name__c;

            wrapperlist.add(wrapperObj);
        }
        return wrapperlist;
//         Datetime myDatetime = Datetime.now();
// String myDatetimeStr = myDatetime.format('MMMM d,  yyyy');
//         Date d = date.today();
//         String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');
//         system.debug(logginglevel.error,dt);
       //return [SELECT Id, Name, Billing_Doc_Number__c,Sales_Order_No__c,Delivery_Number__c, PO_Number__c,Bill_To_Party__r.Name , Bill_To_Party__r.Customer_Country__c,Invoice_Date__c,Ship_to_Party__c, CurrencyIsoCode, TotalAmount__c, Ship_to_Party__r.Location_Name__c, Sold_To_Party__r.Name FROM Invoice__c where Sold_To_Party__c =:uId ];
    }
//Change by Grazitti team for Community adoption RITM0429236 12Oct22
    public class WrappergetInvoice
    {
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String BillingDocNumber{get;set;}
        @AuraEnabled
        public String SalesOrderNo{get;set;}
        @AuraEnabled
        public String DeliveryNumber{get;set;}
        @AuraEnabled
        public String PONumber{get;set;}
        @AuraEnabled
        public String BillToParty{get;set;}
        @AuraEnabled
        public String CurrencyIsoCode{get;set;}
        @AuraEnabled
        public String InvoiceDate{get;set;}
        @AuraEnabled
        public String TotalAmount{get;set;}
        @AuraEnabled
        public String SoldToParty{get;set;}
        @AuraEnabled
        public String ShiptoParty{get;set;}        

        public WrappergetInvoice()
        {
            Id='';
            BillingDocNumber='';
            SalesOrderNo='';
            DeliveryNumber='';
            PONumber='';
            BillToParty='';
            CurrencyIsoCode='';
            InvoiceDate='';
            TotalAmount='';
            SoldToParty='';
            ShiptoParty='';            
        }
    }    
    @AuraEnabled(cacheable = true)
    public static List<Invoice_Line_Item__c> getInvoiceLineItem(String invoiceId){
        List<user> u = new List<User>();
        u = [select id, Name, contactId, accountId,Country from User where id = : UserInfo.getUserId()];
        List<Invoice_Line_Item__c> invoiceLineItems = [SELECT Id,SKU__r.SKU_Code__c ,SKU_Code__c,SKU__r.Name,SKU__r.SKU_Description__c,SKU_Description__c, UOM__c,Quantity__c, CurrencyIsoCode,Tax_Value__c,Tax_value_formula__c,Net_Value__c,Net_Value_Cal__c,Sales_Order__r.Payment_Term__r.Payment_Term__c,Payment_Term__c,Sales_Order_Line_Item__r.Invoice_Reflection_Code__c,Invoice__r.Sold_to_Party_SAP_Code__c FROM Invoice_Line_Item__c where Invoice__r.id=:invoiceId];      
        return invoiceLineItems;
    }

    @AuraEnabled(cacheable = true)
    public static List<WrapperProductList> getProductList(String uId){
            system.debug('User ID-->'+uId);
            if(uId.length()>18){
                uId = uId;
            }else{
                uId = '\''+uId+'\'';
            }
            List<user> u = new List<User>();
            u = [select id, Name, contactId, accountId,Country from User where id = : UserInfo.getUserId()];
            List<Invoice_Line_Item__c> ILIList=new List<Invoice_Line_Item__c>();
            String query = 'SELECT Id,Product__r.Name,SKU__r.Product_Name__r.Name,Invoice__r.Bill_To_Party__r.OwnerId,SKU_Description__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c IN ('+uId+')';
            if(u[0].Country=='Japan'){
                query+=' AND Invoice__r.Invoice_Date__c=LAST_N_DAYS:365 Order by SKU_Description__c ASC';
            }else{
                query+='Order by SKU_Description__c ASC';
            }
    //        ILIList=[SELECT Id,Product__r.Name,SKU__r.Product_Name__r.Name,Invoice__r.Bill_To_Party__r.OwnerId,SKU_Description__c FROM Invoice_Line_Item__c where Invoice__r.Sold_To_Party__c =: uId Order by SKU_Description__c ASC];
            ILIList = Database.query(query);
            List<WrapperProductList> wrapperlist=new List<WrapperProductList>();
            Map<String,Invoice_Line_Item__c> ILIMap=new Map<String,Invoice_Line_Item__c>();

            for( Invoice_Line_Item__c f : ILIList){
                ILIMap.put(f.SKU_Description__c,f);
                system.debug('Product Map-->'+ILIMap.values());
            }
            
                for( Invoice_Line_Item__c f : ILIMap.values()){
                    WrapperProductList wrapperObj=new WrapperProductList();
                        
                        wrapperObj.label=f.SKU_Description__c;
                        wrapperObj.value=f.SKU_Description__c;
                        wrapperlist.add(wrapperObj);
                    
                }
            
                system.debug('Product List-->'+wrapperlist);
                return wrapperlist;
        }
        
        /*@AuraEnabled(cacheable=true)
        public static List<String> getContentVersionIds(String pId){


            List<String> cvIdsList=new List<String>();
            //cvIdsList.add('list of file');    
            List<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp, IsDeleted FROM ContentDocumentLink where LinkedEntityId=:pId And Visibility='AllUsers' And IsDeleted=false];
            Set<String> ContentDocumentIdSet=new Set<String>();
            for(ContentDocumentLink cdlObj:cdlList){
                ContentDocumentIdSet.add(cdlObj.ContentDocumentId);
            }
            List<ContentVersion> cvList=[SELECT Id, Title, Description, ContentBodyId, VersionData, ContentDocumentId,FileType,FileExtension  FROM ContentVersion where ContentDocumentId IN : ContentDocumentIdSet];
            for(ContentVersion cvObj:cvList){
                    cvIdsList.add(cvObj.Id);
            }
            System.debug('cvIdsList :'+cvIdsList);
            return cvIdsList;
        }*/

        @AuraEnabled(cacheable=true)
        public static List<ImageWrapper> getContentVersionIds(String pId){
            List<ImageWrapper> imageWrapList=new List<ImageWrapper>();
            //cvIdsList.add('list of file');    
            List<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp, IsDeleted FROM ContentDocumentLink where LinkedEntityId=:pId And Visibility='AllUsers' And IsDeleted=false];
            Set<String> ContentDocumentIdSet=new Set<String>();
            for(ContentDocumentLink cdlObj:cdlList){
                ContentDocumentIdSet.add(cdlObj.ContentDocumentId);
            }
            List<ContentVersion> cvList=[SELECT Id, Title, Description, ContentBodyId, VersionData, ContentDocumentId,FileType,FileExtension  FROM ContentVersion where ContentDocumentId IN : ContentDocumentIdSet];
            for(ContentVersion cvObj:cvList){
                ImageWrapper wrap=new ImageWrapper();
                wrap.title=cvObj.Title;
                wrap.imagebase64Str=EncodingUtil.base64Encode((blob) cvObj.get('VersionData'));
                wrap.fType=cvObj.FileExtension;
                //cvIdsList.add(EncodingUtil.base64Encode((blob) cvObj.get('VersionData')));
                    //cvIdsList.add(cvObj.Id);
                    imageWrapList.add(wrap);
            }
            System.debug('imageWrapList :'+imageWrapList);
            return imageWrapList;
        }

        public class WrapperProductList{
            @AuraEnabled
            public String label{get;set;}
            @AuraEnabled
            public String value{get;set;}
            
    
            public WrapperProductList()
            {
                label='';
                value='';
            }
        }
        
        public class ImageWrapper{
            @AuraEnabled 
            public String title {get;set;}
            @AuraEnabled 
            public String imagebase64Str {get;set;}
            @AuraEnabled 
            public String fType {get;set;}
    
            public ImageWrapper(){
                title='';
                imagebase64Str='';
                fType='';
            }
    
        }
}