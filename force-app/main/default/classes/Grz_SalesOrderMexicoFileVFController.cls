public with sharing class Grz_SalesOrderMexicoFileVFController {
    public List<ResultWrapper> vfWrap{get;set;}
    public void Grz_SalesOrderListVF() {
        String searchKey = ApexPages.currentPage().getParameters().get('searchKey');
        String datefilter = ApexPages.currentPage().getParameters().get('datefilter');
        String sortby = ApexPages.currentPage().getParameters().get('sortby');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
       
        if(Test.isRunningTest()){       
            startDate = '2019-04-02';
            endDate = '2030-07-02';
        }
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        List<String> salesorgcode = System.Label.Grz_MexicoSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        Id id = UserInfo.getUserId(); // getting current user info
            List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        
            String accountId = user[0].AccountId;
        
          
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
        if(datefilter != NULL && datefilter != ''){
            query += ' order by ' +datefilter; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        } 
        query += ' LIMIT 2000';
        List<Sales_Order__c> salesOrderList = Database.query(query);  
        for(Sales_Order__c sOrder : salesOrderList){
            ResultWrapper orderResult = new ResultWrapper();
            orderResult.Id = sOrder.Id;
            orderResult.SAPOrderNumber = sOrder.SAP_Order_Number__c;
            if(orderResult.SAPOrderNumber == null){
                orderResult.SAPOrderNumber = sOrder.SFDC_Order_Number__c;
            }
            
            if(sOrder.CreatedDate != null){
                orderResult.CreatedDate = grz_SapIntegration.FormattedDateMexico(sOrder.CreatedDate);
            }
          
            orderResult.SoldToPartyName = sOrder.Sold_To_Party__r.Name;
            orderResult.City = sOrder.Brazil_City__c;
            orderResult.CurrencyMexico = sOrder.CurrencyIsoCode;
            if(sOrder.Amount__c != null){
                orderResult.Amount = String.valueOf(sOrder.Amount__c.setScale(2));
            }
            orderResult.OrderType = sOrder.Order_Type_lk__r.Name;
            orderResult.OrderStatus = sOrder.Order_Status__c;
            saleWrapperList.add(orderResult);
        }
        vfWrap = saleWrapperList;
    }
    public class ResultWrapper {
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String SAPOrderNumber{get;set;}
       
       
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
}