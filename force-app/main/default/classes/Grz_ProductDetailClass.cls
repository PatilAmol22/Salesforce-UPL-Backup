public with sharing class Grz_ProductDetailClass {
    @AuraEnabled(cacheable=true)
    public static ProductDetailWrapper getProductDetailList(String urlapex)
    {
        List<Sales_Order__c> sales = new list<Sales_Order__c>();
        List<Sales_Order_Line_Item__c> lineitem = new list<Sales_Order_Line_Item__c>();
        Id id = UserInfo.getUserId(); // getting current user info
       
        List<User> user = [SELECT Id, Username, AccountId , Account.Sap_UserId__c, ContactId, profile.name FROM User where Id =: id];
         String checkaccountId = user[0].AccountId;
        String profilename = user[0].profile.name;
       
        ProductDetailWrapper productobj = new ProductDetailWrapper();
        if(checkaccountId != Null){
            productobj.isExternalUser = true;
        }
        else{
             productobj.isExternalUser = false;
        }
        String query = 'Select Id, Name,  Sold_to_Party__r.Sap_userid__c, Type_of_Order__c, Brazil_City__c, Currency_Brazil__c, Payment_Term__c,(Select Id, SKU_Code__c, UOM__c, Value_Number__c, Unit_Price__c, sale_order__c, SKU_Description__c, ProductName__c, Quantity__c from Sales_Order_Line_Item__r), Sold_to_Party__r.name,Sold_to_Party__c, SAP_Order_Number__c, SFDC_Order_Number__c, CreatedDate,Order_Date__c, Order_Type_lk__c, Order_Type_lk__r.Name, Order_Status__c, LastModifiedDate, OrderQuantity__c,Amount__c, Total_Amount__c from Sales_Order__c';
        query += ' where Id =: urlapex ';
        if(profilename.contains('Brazil'))
            {
                productobj.IsBrazilUser = true;
            }
        else
            {
                productobj.IsBrazilUser = false;

            }
           
        List<Sales_Order__c> salesOrderList = Database.query(query); 
        //Code Updated by Grz(Sumit Kumar) 22-05-2023 for Customer 360 New CR Changes (Ticket No. APPS-5366)
        Date orderDate;
        String datecheck = System.Label.Grz_HanaFiscalDate; //2023-03-31
        for(Sales_Order__c salesobj : salesOrderList){
            if(salesobj.Order_Date__c != null){
            	orderDate = salesobj.Order_Date__c;
            }else{
                DateTime dt = salesobj.CreatedDate;
                orderDate = dt.date();
            }
            sales.add(salesobj);
            lineitem.addAll(salesobj.Sales_Order_Line_Item__r);
         }
         String res;
        Id accountId;
        try{
                if(salesOrderList.size()>0){
                     if(salesOrderList[0].SAP_Order_Number__c==null ){
                         productobj.isSuccess=false;
                         productobj.msg='SAP Order Number is empty. Please contact administrator';
                         accountId='';
                         res='';
                        }
                    else{
                        accountId = salesOrderList[0].Sold_to_Party__c;
                        // Customer 360 CR changes (Ticket No. APPS-5366)
                        Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = Grz_SapCommonIntegration.getIntegrationMappings();
                        List<Account> accList = [SELECT Id, Sap_UserId__c, Company_Code__c,Sales_Org_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: accountId];
                        String salesOrgCode = accList[0].Sales_Org_Code__c;
                        if(integrationSettingsMap != null && integrationSettingsMap.containsKey(salesOrgCode) && integrationSettingsMap.get(salesOrgCode).Country__c == 'India'){
                            if(integrationSettingsMap.get(salesOrgCode).EndPointURL__c != null && orderDate >= date.valueOf(datecheck)){  //Code Updated by Grz(Sumit Kumar) 22-05-2023 for Customer 360 New CR Changes (Ticket No. APPS-5366)
                                system.debug('orderDate in if : '+orderDate);
                                String endPointName = integrationSettingsMap.get(salesOrgCode).EndPointURL__c;
                                res = Grz_SapCommonIntegration.invoiceMarketingIND(salesOrderList[0].SAP_Order_Number__c,salesOrderList[0].Sold_to_Party__r.Sap_userid__c,endPointName);
                            }else{
                                system.debug('orderDate in else : '+orderDate);
                                res = grz_SapIntegration.GerInvoiceInfo(salesOrderList[0].SAP_Order_Number__c,salesOrderList[0].Sold_to_Party__r.Sap_userid__c);
                            }
                        }else{
                            res = grz_SapIntegration.GerInvoiceInfo(salesOrderList[0].SAP_Order_Number__c,salesOrderList[0].Sold_to_Party__r.Sap_userid__c);
                        }
                       if(res.equals('Error_In_Sap')){
              			productobj.isSuccess=false;
            			productobj.msg='Error in SAP';
            			}
                        else{
                             productobj.isSuccess=true;
                       		 productobj.msg='';
                        }
                       
                    }                   
                 
                }
             }
        catch(exception e){
          system.debug('error in sap order number'+e);
        }
         ProductDetailWrapper1 Data = new ProductDetailWrapper1();
        if(res!=null){
            try{
                 Data = ProductDetailWrapper1.parse(res);
            }
            catch(exception e){
                 system.debug('---e---'+e);
            }
        }
        else{
            Data=null;
        }
      
        productobj.salesList = sales;
        Map<String, List<InvoiceDetailWrapper>> InvoiceMap =  new Map<String ,List<InvoiceDetailWrapper>>();
       
        if( Data != null){
             for(InvoiceDetailWrapper invoiceobj : Data.InvoiceDetails)
            {
           if(invoiceobj.BillingDocNumber!='' && invoiceobj.BillingDocNumber != NULL && !invoiceobj.BillingType.equalsIgnoreCase('S1')) {
             if(InvoiceMap.containsKey(invoiceobj.BillingDocNumber)) {
                    InvoiceMap.get(invoiceobj.BillingDocNumber).add(invoiceobj);
                }
                else{
                    List<InvoiceDetailWrapper> invoiceList = new List<InvoiceDetailWrapper>();
                    invoiceList.add(invoiceobj);
                    InvoiceMap.put(invoiceobj.BillingDocNumber,invoiceList);
                }
               
            }            

        }
    }
       
        
        
        List<InvoiceDetailWrapper> finalinvoiceList = new List<InvoiceDetailWrapper>();
        Map<String,Boolean> BillingackMap = new Map<String,Boolean>();
        set<string> billingtypeset = new set<string>();
       Map<String,Invoice__c> SfinvoiceMap = new Map<String,Invoice__c>();
        for(Invoice__c invoice1 : [SELECT Id, Acknowledge__c,  Billing_Doc_Number__c , Sold_To_Party__r.Name, Sold_To_Party__c FROM Invoice__c where Billing_Doc_Number__c in :InvoiceMap.keySet()]){
            BillingackMap.put(invoice1.Billing_Doc_Number__c,invoice1.Acknowledge__c);
         SfinvoiceMap.put(invoice1.Billing_Doc_Number__c,invoice1);
        }
       
         Map<String,String> contentDocMap = new Map<String,String>();
        if(accountId!=null){
          
            for(ContentDocumentLink con : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink where LinkedEntityId =:accountId]){
               
                Set<String> uniqueBillingDoc = InvoiceMap.keySet();
                String Title = con.ContentDocument.Title;
               
                if(Title.length()> 10){
                    String title1=Title;
                    if(Title.contains('.')){
                      
                        title1=Title.split('\\.')[0];
                    }
                     String lastchar = title1.RIGHT(10);
                   
                     if(uniqueBillingDoc.contains(lastchar)){
                          contentDocMap.put(lastchar,con.ContentDocumentId);
                     }               
                }
              
             }
           
        }
           
        for(String invoiceobj1 : InvoiceMap.keySet()){
             InvoiceDetailWrapper finalinvoiceobj = new InvoiceDetailWrapper();
           
             Decimal tempamount;
             Decimal total = 0;
             if(SfinvoiceMap.containskey(invoiceobj1)){
                   finalinvoiceobj.sfrecord = true;
              }
          
            if(InvoiceMap.get(invoiceobj1)[0].cancelled.equalsIgnoreCase('X')){
                  finalinvoiceobj.cancelledboolean = true;
              }
              else{
                   finalinvoiceobj.cancelledboolean = false;
              }
            finalinvoiceobj.BillingDocNumber = InvoiceMap.get(invoiceobj1)[0].BillingDocNumber;
              Datetime invoicedate = date.valueOf(InvoiceMap.get(invoiceobj1)[0].BillingDate);
             
               finalinvoiceobj.BillingDate = grz_SapIntegration.FormattedDate(invoicedate);
              
            finalinvoiceobj.ackcheckbox = BillingackMap.get(InvoiceMap.get(invoiceobj1)[0].BillingDocNumber);
              if(contentDocMap.containskey(invoiceobj1)){
                    finalinvoiceobj.invoicecontentdocid = contentDocMap.get(invoiceobj1);
                      finalinvoiceobj.invoicecontentdocname = invoiceobj1;
                    }
                   
             for(InvoiceDetailWrapper tempinvoice : InvoiceMap.get(invoiceobj1)){
                  if(!tempinvoice.BillingType.equalsIgnoreCase('S1')){
                      tempamount = tempinvoice.InvoiceTotalValue;
                  
                    total = total + tempamount;
                   
                  }
             }
                finalinvoiceobj.InvoiceTotalValue = total;
                finalinvoiceList.add(finalinvoiceobj);
               
        }
        productobj.InvoiceDetails = finalinvoiceList;
        productobj.lineItemList = lineitem;
            
        return productobj;
    }
    
      public static ProductDetailWrapper1 parse(String json) {
          ProductDetailWrapper1 resultinstance =  new ProductDetailWrapper1();
          try{
               resultinstance = (ProductDetailWrapper1) System.JSON.deserialize(json, ProductDetailWrapper1.class);
                return resultinstance;
          }
          catch(exception e){
            
              return Null;
          }
   }
     @AuraEnabled
    public static void setAcknowledgement(String Billinginvoiceid)
    {
         
        if (Billinginvoiceid != NULL)
        {
            List<Invoice__c> invoiceList = [SELECT Id, Acknowledge__c, Billing_Doc_Number__c FROM Invoice__c where Billing_Doc_Number__c =: Billinginvoiceid LIMIT 1];
            if (!invoiceList.isEmpty())
             {
                 Invoice__c invoiceobj = invoiceList[0];
                 invoiceobj.Acknowledge__c = true;
               
                 update invoiceobj;
            }
        }

    }
     
  public class ProductDetailWrapper
    {
       @AuraEnabled 
        public List<Sales_Order__c> salesList {get;set;}
          @AuraEnabled
        public List<Sales_Order_Line_Item__c> lineItemList {get;set;}
         
         @AuraEnabled
            public Boolean IsBrazilUser{get;set;}
         @AuraEnabled
        public  List<InvoiceDetailWrapper> InvoiceDetails{get;set;}
         @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String msg{get;set;}
         @AuraEnabled public  Boolean isExternalUser{get;set;}
      
}
    
     public class ProductDetailWrapper1
     {
           @AuraEnabled
        public List<InvoiceDetailWrapper> InvoiceDetails{get;set;}
     }
      
    
    public class InvoiceDetailWrapper {
        @AuraEnabled public  Boolean sfrecord{get;set;}
        @AuraEnabled public  String invoicecontentdocid{get;set;}
        @AuraEnabled public  Boolean ackcheckbox{get;set;}
        @AuraEnabled public  String invoicecontentdocname{get;set;}
        @AuraEnabled public  Boolean cancelledboolean{get;set;}
        @AuraEnabled public String SAPOrderNumber{get;set;}
        @AuraEnabled public String SalesDocumentItem{get;set;}
        @AuraEnabled public String BillingDocNumber{get;set;}
        @AuraEnabled public String BillingItem{get;set;}
        @AuraEnabled public String BillingDate{get;set;}
        @AuraEnabled public String Tax{get;set;}
        @AuraEnabled public Decimal InvoiceTotalValue{get;set;}
        @AuraEnabled public String transferStatus{get;set;}
        @AuraEnabled public String cancelled{get;set;}
        @AuraEnabled public String BillingType{get;set;}
        @AuraEnabled public String InvoiceName{get;set;}
        @AuraEnabled public String Cancelledbillingnumber{get;set;}
    }
    
}