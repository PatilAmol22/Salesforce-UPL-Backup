public with sharing class Grz_ChileReportController {
    @AuraEnabled(cacheable = true)
    public static Response getSalesOrder( String searchKey, String typeValue, Decimal pageNumber, Decimal pageSize,String startDate,String endDate,String orderStatus ){
        Response response = new Response();
        Id id = UserInfo.getUserId();
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
        String countQuery , query, filter;
        Integer pSize;
        List<User> user = [SELECT Id,AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        if(pageSize != null && pageSize != 0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize = 10;  
        } 
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
            
        if(!String.isEmpty(typeValue)){
            countQuery= 'Select Count() FROM ' + typeValue;
            if(typeValue == 'Sales_Order_Line_Item__c'){
                query = 'SELECT Id,(SELECT Id,SubStatus__c,Estimated_at__c,Arrived_At__c,Receipt__c FROM Sales_order_delivery__r WHERE Parent_Record__c != null LIMIT 1),(SELECT Id FROM Invoice_Line_Item__r LIMIT 1),(SELECT Id,Deliverynumber__c,Document_Date__c FROM Dispatches__r WHERE Batch__c != null LIMIT 1), Sale_Order__c, Sale_Order__r.Name, Sale_Order__r.CreatedDate, Sale_Order__r.Purchase_Order_no__c, Sale_Order__r.Purchase_Order_Date__c, Sale_Order__r.Brazil_City__c, CurrencyIsoCode,CreatedDate,Price__c, SKU_Description__c, Cust_Name__c, CreatedBy.Name,Item_Status__c FROM Sales_Order_Line_Item__c ';
                filter = ' WHERE Sale_Order__r.SalesOrgCode__c IN: salesorgcode AND Sale_Order__r.BrazilSalesOrderStatus__c IN: orderSt';
                if(!String.isEmpty(accountId)){
                    filter += filter.contains('WHERE') ? ' AND' : ' WHERE';
                    filter += ' Sale_Order__r.Sold_to_Party__c =: accountId';    
                }
                if (!string.IsBlank(searchKey)) {
                    filter += filter.contains('WHERE') ? ' AND' : ' WHERE';
                    filter += ' (Sale_Order__r.Purchase_Order_no__c LIKE \'%' +searchKey+ '%\' OR Sale_Order__r.Name LIKE \'%' +searchKey+ '%\')' ;
                }
                if(!filter.contains('WHERE')){
                    filter += ' WHERE DAY_ONLY(createddate) >='+startDate+' AND DAY_ONLY(createddate)<='+endDate;
                }
                else{
                    filter += ' AND DAY_ONLY(createddate) >='+startDate+' AND DAY_ONLY(createddate)<='+endDate;
                }
            }else if(typeValue == 'Invoice__c'){
                query = 'Select Id,Billing_Doc_Number__c,Folio__c,Sold_To_Party__r.Name,Delivery_Number__c,Billing_Date__c,Sales_Order__r.Name,Sales_Order__r.Purchase_Order_no__c,Sales_Order__r.Purchase_Order_Date__c,CurrencyIsoCode,Sales_Order__r.Order_Date__c,TotalSalesAmount__c FROM Invoice__c ';
                filter = ' WHERE Sales_Order__r.SalesOrgCode__c IN: salesorgcode AND Sales_Order__r.BrazilSalesOrderStatus__c IN: orderSt';
                if(!String.isEmpty(accountId)){
                    filter += filter.contains('WHERE') ? ' AND' : ' WHERE';
                    filter += ' Sold_To_Party__c =: accountId';    
                }
                if (!string.IsBlank(searchKey)) {
                    filter += filter.contains('WHERE') ? ' AND' : ' WHERE';
                    filter += ' (Billing_Doc_Number__c LIKE \'%' +searchKey+ '%\' OR Delivery_Number__c LIKE \'%' +searchKey+ '%\')' ;
                }
                if(!filter.contains('WHERE')){
                    filter += ' WHERE Billing_Date__c >='+startDate+' AND Billing_Date__c <='+endDate;
                }
                else{
                    filter += ' AND Billing_Date__c >='+startDate+' AND Billing_Date__c <='+endDate;
                }
            }else{
                query = 'Select Id,Name,Purchase_Order_no__c,Sold_to_Party__r.Name,Purchase_Order_Date__c,CurrencyIsoCode, Total_Amount__c,Order_Date__c,CreatedDate FROM Sales_Order__c ';
                filter = ' WHERE SalesOrgCode__c IN: salesorgcode AND BrazilSalesOrderStatus__c IN: orderSt';
                if(!String.isEmpty(accountId)){
                    filter += filter.contains('WHERE') ? ' AND' : ' WHERE';
                    filter += ' Sold_to_Party__c =: accountId';    
                }
                if (!string.IsBlank(searchKey)) {
                    filter += filter.contains('WHERE') ? ' AND' : ' WHERE';
                    filter += ' (Name LIKE \'%' +searchKey+ '%\' OR Purchase_Order_no__c LIKE \'%' +searchKey+ '%\')' ;
                }
                if(!filter.contains('WHERE')){
                    filter += ' WHERE DAY_ONLY(createddate) >='+startDate+' AND DAY_ONLY(createddate)<='+endDate;
                }
                else{
                    filter += ' AND DAY_ONLY(createddate) >='+startDate+' AND DAY_ONLY(createddate)<='+endDate;
                }
            }
        }    
        query += filter;
        countQuery += filter;
        query += ' ORDER BY CreatedDate DESC '; 
        if(offset > 2000){
            offset = 2000; 
        }
        if(typeValue == 'Sales_Order_Line_Item__c'){
            if(!String.isEmpty(orderStatus) && orderStatus == 'All'){
                query += ' LIMIT :pSize OFFSET :offset';
            }else{
                query += ' OFFSET :offset';
            }
        }else{
            query += ' LIMIT :pSize OFFSET :offset';
        }
        
        countQuery += ' LIMIT 2000';      
        try{ 
            Integer totalRecords = Database.countQuery(countQuery);
            Integer recordEnd = pSize * pNumber;
            response.pageSize = pSize;
            response.pageNumber = pNumber;
            response.recordStart = offset + 1;
            response.totalRecords = totalRecords;
            response.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords; 
            if(typeValue == 'Sales_Order_Line_Item__c'){
                List<Sales_Order_Line_Item__c> sObjectList = Database.query(query); 
                List<ResultWrapper> wrapList = new List<ResultWrapper>();
                for(Sales_Order_Line_Item__c sOrder : sObjectList){
                    ResultWrapper orderResult = new ResultWrapper();
                    orderResult.Id = sOrder.Sale_Order__c;
                    orderResult.lineItemId = sOrder.Id;
                    orderResult.sFDCOrderNumber = sOrder.Sale_Order__r.Name;
                    orderResult.purchaseOrderNumber = sOrder.Sale_Order__r.Purchase_Order_no__c;
                    orderResult.productName = sOrder.SKU_Description__c;
                    orderResult.clientName = sOrder.Cust_Name__c;
                    if(sOrder.CreatedDate != null){
                        orderResult.createdDate = grz_SapIntegration.FormattedDateChile(sOrder.CreatedDate);
                    }
                    if(sOrder.Sale_Order__r.Purchase_Order_Date__c != null){
                        orderResult.purchaseOrderDate = grz_SapIntegration.FormattedDateChile(sOrder.Sale_Order__r.Purchase_Order_Date__c);
                    }
                    if(sOrder.CurrencyIsoCode != null){
                        orderResult.orderCurrency = sOrder.CurrencyIsoCode;
                    }  
                    if(sOrder.Price__c != null){
                        orderResult.amount = String.valueOf(sOrder.Price__c);
                    }
                    if(!sOrder.Dispatches__r.isEmpty()){
                        orderResult.deliveryNumber = sOrder.Dispatches__r[0].Deliverynumber__c;
                        if(sOrder.Dispatches__r[0].Document_Date__c != null){
                            orderResult.documentDate = grz_SapIntegration.FormattedDateChile(sOrder.Dispatches__r[0].Document_Date__c);
                        }else{
                            orderResult.documentDate = '-';
                        }
                    }else{
                        orderResult.deliveryNumber = '-';
                        orderResult.documentDate = '-';
                    }
                    if(!sOrder.Sales_order_delivery__r.isEmpty()){
                        orderResult.receipt = sOrder.Sales_order_delivery__r[0].Receipt__c;
                        if(sOrder.Sales_order_delivery__r[0].Arrived_At__c != null && sOrder.Sales_order_delivery__r[0].Arrived_At__c != ''){
                            orderResult.arrivedAt = String.ValueOf(DateTime.Valueof(sOrder.Sales_order_delivery__r[0].Arrived_At__c.replace('T', ' ')));
                        }else{
                            orderResult.arrivedAt = '-';
                        }
                    }else{
                        orderResult.arrivedAt = '-';
                    }
                    if(!sOrder.Invoice_Line_Item__r.isEmpty()){
                        orderResult.orderStatus = 'Pedido facturado';
                    }else{
                        if(!sOrder.Sales_order_delivery__r.isEmpty()){
                            if(sOrder.Sales_order_delivery__r[0].SubStatus__c != null && sOrder.Sales_order_delivery__r[0].SubStatus__c != ''){
                                orderResult.orderStatus = sOrder.Sales_order_delivery__r[0].SubStatus__c;
                            }else{
                                orderResult.orderStatus = 'Entrega en Ruta';
                            }
                        }else{
                            orderResult.orderStatus = 'Pedido en proceso';
                        }
                    }
                    // Logic added for cancelled orders GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
                    if(sOrder.Item_Status__c!=Null && sOrder.Item_Status__c.contains('rejected') ){
                        orderResult.orderStatus = 'Cancelado';
                    }
                    wrapList.add(orderResult);
                }
                if(!String.isEmpty(orderStatus)){
                    if(orderStatus != 'All' && orderStatus != 'Other'){
                        List<ResultWrapper> orderResultList = new List<ResultWrapper>();
                        for(ResultWrapper rw : wrapList){
                            if(rw.orderStatus == orderStatus){
                                if(orderResultList.size() <= pSize){
                                    orderResultList.add(rw);
                                }else{
                                    break;
                                }
                            }
                        }
                        wrapList = orderResultList;
                    }else if(orderStatus == 'Other'){
                        List<ResultWrapper> orderResultList = new List<ResultWrapper>();
                        for(ResultWrapper rw : wrapList){
                            if(rw.orderStatus != 'Pedido en proceso' && rw.orderStatus != 'Entrega en Ruta' && rw.orderStatus != 'Entrega Exitosa' && rw.orderStatus != 'Pedido facturado'){
                                if(orderResultList.size() <= pSize){
                                    orderResultList.add(rw);
                                }else{
                                    break;
                                }
                            }
                        }
                        wrapList = orderResultList;
                    }else{
                        wrapList = wrapList;
                    }
                }
                response.data = wrapList;
            }else{
                List<sObject> sObjectList = Database.query(query); 
                response.data = sObjectList;
            }
        }catch(Exception ex) { 
            response.success = false;
            response.message = ex.getMessage();
        }
        return response;
    }

    public class Response {
        @AuraEnabled public Object data          {get;set;}
        @AuraEnabled public Integer pageSize     {get;set;}
        @AuraEnabled public Integer pageNumber   {get;set;}
        @AuraEnabled public Integer totalRecords {get;set;}
        @AuraEnabled public Integer recordStart  {get;set;}
        @AuraEnabled public Integer recordEnd    {get;set;}
        @AuraEnabled public String message       {get;set;}
        @AuraEnabled public Boolean success      {get;set;}
    
        public Response(){
            this.message = 'Success';
            this.success = true;
        }
    }

    public class ResultWrapper {
        @AuraEnabled public String Id                   {get;set;}
        @AuraEnabled public String lineItemId           {get;set;}
        @AuraEnabled public String sFDCOrderNumber      {get;set;}
        @AuraEnabled public String purchaseOrderDate    {get;set;}
        @AuraEnabled public String purchaseOrderNumber  {get;set;}
        @AuraEnabled public String createdDate          {get;set;}
        @AuraEnabled public String amount               {get;set;}  
        @AuraEnabled public String deliveryNumber       {get;set;}  
        @AuraEnabled public String orderCurrency        {get;set;} 
        @AuraEnabled public String productName          {get;set;} 
        @AuraEnabled public String orderStatus          {get;set;} 
        @AuraEnabled public String arrivedAt            {get;set;} 
        @AuraEnabled public String documentDate         {get;set;} 
        @AuraEnabled public String receipt              {get;set;} 
        @AuraEnabled public String clientName           {get;set;} 
    }
}