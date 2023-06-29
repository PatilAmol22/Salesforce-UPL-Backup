/****************************************************************************
    * Name - Grz_SalesOrderListArgentina
    * @Description  - Controller Class for grz_SalesOrderListArgentina LWC Component
    * Test Class - Grz_SalesOrderListArgentinaTest
    * Date - 25/08/2022
    * Author - Mohit garg(Grazitti)
    * Last modified by - Mohit Garg(Grazitti) 31/08/2022 
    *************************************************************************** */


public with sharing class Grz_SalesOrderListArgentina {
    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getSalesOrderRecord(
        String searchKey, 
        String orderByDate, 
        String allOrderStatus, 
        Decimal pageNumber, 
        Decimal pageSize,
        String startDate,
        String endDate
                ) {
            Integer pSize;
            if(pageSize!=null && pageSize!=0.0){
                pSize = (Integer)pageSize;    
            }else{
                pSize=10;  
            } 
            Integer pNumber = (Integer)pageNumber;
            Integer offset = (pNumber - 1) * pSize;
            List<String> salesOrderStatus = System.Label.Grz_ArgentinaSalesOrderStatusField.trim().Split(',');
            Set<String> pickOptions = new Set<String>();
            Schema.DescribeFieldResult fieldResult = Sales_Order__c.Order_Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
                for(String str : salesOrderStatus){
                    if(f.getValue()==str){
                        String label = f.getLabel();
                        pickOptions.add(label);
                    }
                }
        	} 
            Id id = UserInfo.getUserId();
            List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
            String accountId = user[0].AccountId;
            List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
            FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();
            String countQuery= 'SELECT Count() FROM Sales_Order__c';
            String salesorgcode = System.Label.Grz_ArgentinaSalesOrgCode;
           
            String query = 'Select Id,Name,SAP_Order_Number__c, SFDC_Order_Number__c , CreatedBy.Name, CurrencyIsoCode, CreatedDate , Brazil_City__c , toLabel(Order_Status__c),OrderQuantity__c,Total_Amount__c,Sold_to_Party__r.name,Sold_to_Party__c from Sales_Order__c';
            String filter = ' where SalesOrgCode__c =:salesorgcode and Order_Status__c IN :salesOrderStatus';
            if(!String.isEmpty(accountId)){
                if(!filter.contains('where')){
                    filter +=  ' where Sold_to_Party__c =:accountId';
                }
                else{
                    filter += ' and Sold_to_Party__c =:accountId';
                }     
            }

            if (!string.IsBlank(searchKey)) {
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' (Name like \'%' +searchKey+ '%\' or SAP_Order_Number__c like \'%' +searchKey+ '%\' or SFDC_Order_Number__c  like \'%' +searchKey+ '%\')' ;
            }
            if (!string.IsBlank(allOrderStatus)) {
                if(allOrderStatus != 'All' ){
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' Order_Status__c like \'%' +allOrderStatus+ '%\'';
                }
            }            
            if(!filter.contains('where')){
                filter += ' where DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
            }
            else{
                filter += ' and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
            }
            query += filter;
            countQuery += filter;
            if(orderByDate != NULL && orderByDate != ''){
                query += ' order by ' +orderByDate; 
            }
            else{
                query += ' order by CreatedDate desc '; 
            } 
            if(offset > 2000){
                offset = 2000; 
             }
             query += ' LIMIT :pSize OFFSET :offset';
             countQuery += ' LIMIT 2000';
            List<Sales_Order__c> salesOrderList = Database.query(query);
            Integer totalRecords =Database.countQuery(countQuery);
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
           
            objDT.recordStart = offset + 1;
            objDT.totalRecords = totalRecords;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords; 
            for(Sales_Order__c sOrder : salesOrderList){
                ResultWrapper orderResult = new ResultWrapper();
                orderResult.Id = sOrder.Id;
                orderResult.SAPOrderNumber = sOrder.SAP_Order_Number__c;
                 orderResult.SFDCOrderNumber = sOrder.SFDC_Order_Number__c;
                if(sOrder.CreatedDate != null){
                    orderResult.CreatedDate = grz_SapIntegration.FormattedDateMexico(sOrder.CreatedDate);
                }
               
                orderResult.SoldToPartyName = sOrder.Sold_To_Party__r.Name;
                orderResult.City = sOrder.Brazil_City__c;
                orderResult.CurrencyArgentina = sOrder.CurrencyIsoCode;
                 
                if(sOrder.Total_Amount__c != null){
                    orderResult.Amount = String.valueOf(sOrder.Total_Amount__c.setScale(2).format());
                }
                orderResult.OrderStatus = sOrder.Order_Status__c;
                saleWrapperList.add(orderResult);
            }
            objDT.salesWrapList = saleWrapperList;
            objDT.picklistValues = pickOptions;
            return objDT;
        }
        
    public class ResultWrapper {
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String SAPOrderNumber{get;set;}
        @AuraEnabled
        public String SFDCOrderNumber{get;set;}
        @AuraEnabled
        public String CreatedDate{get;set;}
        @AuraEnabled
        public String SoldToPartyName{get;set;}
        @AuraEnabled
        public String City{get;set;}
        @AuraEnabled
        public String Amount{get;set;}
        @AuraEnabled
        public String OrderStatus{get;set;}    
        @AuraEnabled
        public String CurrencyArgentina{get;set;} 
        
    }
    
    public class FinamlSalesDataWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<ResultWrapper> salesWrapList {get;set;}
        @AuraEnabled
        public Set<String> picklistValues{get;set;} 
    }  
}