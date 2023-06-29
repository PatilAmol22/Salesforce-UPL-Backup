public with sharing class Grz_SalesOrderListMexico {
    
    
    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getSalesOrderRecord(
        String searchKey, 
        String datefilter, 
        String sortby, 
        Decimal pageNumber, 
        Decimal pageSize,
        String startDate,
        String endDate,
        String distributor
        
    ) {
        Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        } 
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        List<String> pickOptions = new List<String>();
        Schema.DescribeFieldResult fieldResult = Sales_Order__c.Order_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            if(f.getLabel() != 'Partially Cancelled' && f.getLabel() != 'Pending for SD Approval Italy'){
                pickOptions.add(f.getLabel());
            }
        } 
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();
        String countQuery= 'Select Count() from Sales_Order__c';
        List<String> salesorgcode = System.Label.Grz_MexicoSalesOrgCode.trim().Split(',');
        
        
        String query = 'Select Id,Name,SAP_Order_Number__c, SFDC_Order_Number__c , Amount__c, CreatedBy.Name, CurrencyIsoCode, CreatedDate , Type_of_Order__c, Brazil_City__c , Order_Type_lk__c, Order_Type_lk__r.Name, toLabel(Order_Status__c),OrderQuantity__c,Total_Amount__c,Sold_to_Party__r.name,Sold_to_Party__c from Sales_Order__c';
        String filter = ' where SalesOrgCode__c in:salesorgcode and Order_Status__c!= Null ';
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where Sold_to_Party__c =: accountId';
            }
            else{
                filter += ' and Sold_to_Party__c =: accountId';
            }     
        }
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where Sold_to_Party__r.SAP_Code__c =: distributor';
                }
                else
                {
                    filter += ' and Sold_to_Party__r.SAP_Code__c =: distributor';
                }
            }    
        }
        
        
        if (!string.IsBlank(searchKey)) {
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (Name like \'%' +searchKey+ '%\' or SAP_Order_Number__c like \'%' +searchKey+ '%\' or SFDC_Order_Number__c  like \'%' +searchKey+ '%\')' ;
        }
        if (!string.IsBlank(sortby)) {
            if(sortby != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Order_Status__c like \'%' +sortby+ '%\'';
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
        if(datefilter != NULL && datefilter != ''){
            query += ' order by ' +datefilter; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        } 
        if(offset > 2000){
            offset = 2000; 
        }
        query += ' LIMIT :pSize OFFSET :offset';
        countQuery += ' LIMIT 2000';
        System.debug('query------'+query);
        List<Sales_Order__c> salesOrderList = Database.query(query);
        System.debug('salesOrderList------'+salesOrderList);
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
            orderResult.CurrencyMexico = sOrder.CurrencyIsoCode;
            
            if(sOrder.Total_Amount__c != null){
                orderResult.Amount = String.valueOf(sOrder.Total_Amount__c.setScale(2));
            }
            
            orderResult.OrderType = sOrder.Order_Type_lk__r.Name;
            
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
        public String OrderType{get;set;}
        @AuraEnabled
        public String OrderStatus{get;set;}    
        @AuraEnabled
        public String CurrencyMexico{get;set;} 
        
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
        public List<String> picklistValues{get;set;} 
    }  
}