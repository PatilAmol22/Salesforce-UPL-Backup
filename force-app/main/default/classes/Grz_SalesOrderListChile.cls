public with sharing class Grz_SalesOrderListChile {
    public List<ResultWrapper> vfWrap{get;set;}
    public static String imgUrl {get;set;} //added by Akhilesh w.r.t Uconnect Mobile App
    //Changes logic in below method to get multiple delivery information GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
    @AuraEnabled(cacheable=true)
    public static DeliveryWrapper getLineItems(Id lineItemId){
        DeliveryWrapper finalWrapper = new DeliveryWrapper();
        List<LineItemWrapper> wrapList = new List<LineItemWrapper>();
        for(Sales_order_Line_Item__c line : [Select Id,Name,SKU_Description__c, sale_order__c, Quantity__c,(SELECT Id,SubStatus__c,Arrived_At__c,Estimated_at__c,Receipt__c,Delivered_Quantity__c FROM Sales_order_delivery__r WHERE Parent_Record__c != null) FROM Sales_Order_Line_Item__c WHERE Id =: lineItemId]){
            System.debug('line--->'+line);
            if(!line.Sales_order_delivery__r.isEmpty()){
                finalWrapper.deliveryInfoPresent = true;
                for(Sales_order_delivery__c sod: line.Sales_order_delivery__r){
                    LineItemWrapper wrap = new LineItemWrapper();
                    wrap.productName = line.SKU_Description__c;
                    wrap.deliveredQuantity = sod.Delivered_Quantity__c != null ? String.ValueOf(sod.Delivered_Quantity__c) : '-';
                    if(sod.SubStatus__c != null && sod.SubStatus__c != ''){
                        wrap.status = sod.SubStatus__c;
                    }else{
                        wrap.status = 'En camino';
                    }	
                    if(sod.Arrived_At__c != null && sod.Arrived_At__c != ''){
                        wrap.arrivedAt = String.ValueOf(DateTime.Valueof(sod.Arrived_At__c.replace('T', ' ')));
                    }else{
                        wrap.arrivedAt = '-';
                    }
                    if(sod.Estimated_at__c != null && sod.Estimated_at__c != ''){
                        wrap.estimatedAt = String.ValueOf(DateTime.Valueof(sod.Estimated_at__c.replace('T', ' ')));
                    }else{
                        wrap.estimatedAt = '-';
                    }
                    wrap.imageURL = sod.Receipt__c; 
                    wrapList.add(wrap);
                }
            }else{
                finalWrapper.deliveryInfoPresent = false;
            }
        }
        finalWrapper.lineItemWrapper = wrapList;
        return finalWrapper;
    }
    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getSalesOrderRecord(String searchKey, String datefilter, Decimal pageNumber, Decimal pageSize,String startDate,String endDate,String orderStatus,String distributorId){
        Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        } 
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();
        String countQuery= 'Select Count() from Sales_Order_Line_Item__c';
        List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        String query = 'SELECT Id,Item_Status__c,First_Date__c,Delivery_Date__c,Consignee_City__c,Sale_Order__r.Destination_City__c,(SELECT Id,SubStatus__c FROM Sales_order_delivery__r WHERE Parent_Record__c != null LIMIT 1),(SELECT Id FROM Invoice_Line_Item__r LIMIT 1),(SELECT Id,Deliverynumber__c FROM Dispatches__r WHERE Batch__c != null LIMIT 1), Sale_Order__c, Sale_Order__r.Name, Sale_Order__r.CreatedDate, Sale_Order__r.Purchase_Order_no__c, Sale_Order__r.Purchase_order_Date__c, Sale_Order__r.Brazil_City__c, CurrencyIsoCode,CreatedDate,Price__c, SKU_Description__c, Cust_Name__c, CreatedBy.Name FROM Sales_Order_Line_Item__c';
        String filter = ' where Sale_Order__r.SalesOrgCode__c IN:salesorgcode and Sale_Order__r.BrazilSalesOrderStatus__c In: orderSt';        
        if(!String.isEmpty(accountId)){
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' Sale_Order__r.Sold_to_Party__c =: accountId';   
            objDT.isInternalUser = false; 
        }else{
            objDT.isInternalUser = true; 
        }
        if(!String.isEmpty(distributorId) && distributorId != 'All'){
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' Sale_Order__r.Sold_to_Party__c =: distributorId';
        }
        if (!string.IsBlank(searchKey)) {
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (Sale_Order__r.Purchase_Order_no__c like \'%' +searchKey+ '%\' or Consignee_City__c like \'%' +searchKey+ '%\' or Sale_Order__r.Name like \'%' +searchKey+ '%\' or Sale_Order__r.SFDC_Order_Number__c  like \'%' +searchKey+ '%\' OR SKU_Name__r.SKU_Description__c  like \'%' +searchKey+ '%\' OR Cust_Name__c  like \'%' +searchKey+ '%\')' ;
        }           
        filter += ' and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        query += filter;
        countQuery += filter;
        if(datefilter != null && datefilter != ''){
            query += ' order by ' +datefilter; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        } 
        if(offset > 2000){
            offset = 2000; 
        }
        if(!String.isEmpty(orderStatus) && orderStatus == 'All'){
            query += ' LIMIT :pSize OFFSET :offset';
        }else{
            query += ' OFFSET :offset';
        }
        countQuery += ' LIMIT 2000';

        List<Sales_Order_Line_Item__c> salesOrderList = Database.query(query);  
        Integer totalRecords =Database.countQuery(countQuery);
        Integer recordEnd = pSize * pNumber;
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.totalRecords = totalRecords;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords; 
        for(Sales_Order_Line_Item__c sOrder : salesOrderList){
            System.debug('sOrder---->'+sOrder);
            ResultWrapper orderResult = new ResultWrapper();
            orderResult.Id = sOrder.Sale_Order__c;
            orderResult.lineItemId = sOrder.Id;
            orderResult.SFDCOrderNumber = sOrder.Sale_Order__r.Name;
            orderResult.productName = sOrder.SKU_Description__c;
            orderResult.purchaseOrderNumber = sOrder.Sale_Order__r.Purchase_Order_no__c;
            orderResult.SoldToPartyName = sOrder.Cust_Name__c;
            orderResult.destination = sOrder.Sale_Order__r.Destination_City__c;
            if(sOrder.CreatedDate != null){
                orderResult.CreatedDate = grz_SapIntegration.FormattedDateChile(sOrder.CreatedDate);
            }
            if(sOrder.Sale_Order__r.Purchase_Order_Date__c != null){
                orderResult.purchaseOrderDate = grz_SapIntegration.FormattedDateChile(sOrder.Sale_Order__r.Purchase_Order_Date__c);
            }
            if(sOrder.CurrencyIsoCode != null){
                orderResult.orderCurrency = sOrder.CurrencyIsoCode;
            }  
            if(sOrder.Price__c != null){
                orderResult.Amount = String.valueOf(sOrder.Price__c);
            }
            if(!sOrder.Dispatches__r.isEmpty()){
                orderResult.deliveryNumber = sOrder.Dispatches__r[0].Deliverynumber__c;
            }else{
                orderResult.deliveryNumber = '-';
            }
            orderResult.firstDate = sOrder.Delivery_Date__c != null ? grz_SapIntegration.FormattedDateChile(sOrder.Delivery_Date__c) : '-'; //New column added GRZ(Nikhil Verma) APPS-1893 modified on 05-09-2022
            String name = sOrder.CreatedBy.Name.toLowerCase(); 
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
                orderResult.SalesRepName = result;
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
            saleWrapperList.add(orderResult);
        }
        if(!String.isEmpty(orderStatus)){
            if(orderStatus != 'All' && orderStatus != 'Other'){
                List<ResultWrapper> orderResultList = new List<ResultWrapper>();
                for(ResultWrapper rw : saleWrapperList){
                    if(rw.orderStatus == orderStatus){
                        if(orderResultList.size() <= pSize){
                            orderResultList.add(rw);
                        }else{
                            break;
                        }
                    }
                }
                objDT.salesWrapList = orderResultList;
            } else if(orderStatus == 'Other'){
                List<ResultWrapper> orderResultList = new List<ResultWrapper>();
                for(ResultWrapper rw : saleWrapperList){
                    if(rw.orderStatus != 'Pedido en proceso' && rw.orderStatus != 'Entrega en Ruta' && rw.orderStatus != 'Entrega Exitosa' && rw.orderStatus != 'Pedido facturado'){
                        if(orderResultList.size() <= pSize){
                            orderResultList.add(rw);
                        }else{
                            break;
                        }
                    }
                }
                objDT.salesWrapList = orderResultList;
            }else{
                objDT.salesWrapList = saleWrapperList;
            }
        }   
        return objDT;
    }
    public void salesOrderListVF() {
        String searchKey = ApexPages.currentPage().getParameters().get('searchKey');
        String datefilter = ApexPages.currentPage().getParameters().get('datefilter');
        String pageNumber = ApexPages.currentPage().getParameters().get('pageNumber');
        String pageSize = ApexPages.currentPage().getParameters().get('pageSize');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String orderStatus = ApexPages.currentPage().getParameters().get('orderStatus');
        String distributorId = ApexPages.currentPage().getParameters().get('distributorId');
        FinamlSalesDataWrapper datawrap = getSalesOrderRecord(searchKey, datefilter, Decimal.valueOf(pageNumber), Decimal.valueOf(pageSize), startDate, endDate, orderStatus, distributorId);
        vfWrap = datawrap.salesWrapList;
        //below URL code added by Akhilesh w.r.t Uconnect Mobile app.
       String sfdcBaseURL = ApexPages.currentPage().getHeaders().get('Referer');
       System.debug('sfdcBaseURL URL: ' + sfdcBaseURL);
       String baseUrl = sfdcBaseURL?.split('/s/')[0];
       
       if(string.isNotBlank(baseUrl) && baseUrl.containsIgnoreCase('uplpartnerportalstd')){
            imgUrl = '/uplpartnerportalstd/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
       }else {
            imgUrl = '/uplpartnerportal/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
       }
    }

    public class ResultWrapper {
        @AuraEnabled public String Id{get;set;}
        @AuraEnabled public String lineItemId{get;set;}
        @AuraEnabled public String SFDCOrderNumber{get;set;}
        @AuraEnabled public String purchaseOrderDate{get;set;}
        @AuraEnabled public String purchaseOrderNumber{get;set;}
        @AuraEnabled public String CreatedDate{get;set;}
        @AuraEnabled public String SalesRepName{get;set;}
        @AuraEnabled public String SoldToPartyName{get;set;}
        @AuraEnabled public String City{get;set;}
        @AuraEnabled public String destination{get;set;}
        @AuraEnabled public String Amount{get;set;}  
        @AuraEnabled public String deliveryNumber{get;set;}  
        @AuraEnabled public String orderCurrency{get;set;} 
        @AuraEnabled public String productName{get;set;} 
        @AuraEnabled public String orderStatus{get;set;} 
        @AuraEnabled public String firstDate{get;set;}
    }
    public class FinamlSalesDataWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer pageNumber {get;set;}
        @AuraEnabled public Integer totalRecords {get;set;}
        @AuraEnabled public Integer recordStart {get;set;}
        @AuraEnabled public Integer recordEnd {get;set;}
        @AuraEnabled public Boolean isInternalUser {get;set;}
        @AuraEnabled public List<ResultWrapper> salesWrapList {get;set;}
    }
    public class DeliveryWrapper{
        @AuraEnabled public List<LineItemWrapper> lineItemWrapper {get;set;}
        @AuraEnabled public Boolean deliveryInfoPresent {get;set;}
    }
    public class LineItemWrapper{
        @AuraEnabled public String productName {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String quantity {get;set;}
        @AuraEnabled public String deliveredQuantity {get;set;}
        @AuraEnabled public String arrivedAt {get;set;}
        @AuraEnabled public String estimatedAt {get;set;}
        @AuraEnabled public String imageURL {get;set;}
        @AuraEnabled public Boolean deliveryInfoPresent {get;set;}
    }
}