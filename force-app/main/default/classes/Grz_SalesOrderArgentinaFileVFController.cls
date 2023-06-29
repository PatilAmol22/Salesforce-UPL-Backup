/****************************************************************************
    * Name - Grz_SalesOrderArgentinaFileVFController
    * @Description  - Controller Class for grz_SalesOrderArgentinapdfDownload VF Page
    * Test Class - Grz_SalesOrderListArgentinaTest
    * Date - 25/08/2022
    * Author - Mohit garg(Grazitti)
    * Last modified by - Mohit Garg(Grazitti) 31/08/2022 
    *************************************************************************** */


public with sharing class Grz_SalesOrderArgentinaFileVFController {
    public List<ResultWrapper> vfWrap{get;set;}
    public void Grz_SalesOrderListVF() {
        String searchKey = ApexPages.currentPage().getParameters().get('searchKey');
        String orderByDate = ApexPages.currentPage().getParameters().get('orderByDate');
        String sortby = ApexPages.currentPage().getParameters().get('sortby');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String allOrderStatus = ApexPages.currentPage().getParameters().get('allOrderStatus');
        
        if(Test.isRunningTest()){       
            startDate = '2019-04-02';
            endDate = '2030-07-02';
        }
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        List<String> salesorgcode = System.Label.Grz_ArgentinaSalesOrgCode.trim().Split(',');
        List<String> salesOrderStatus = System.Label.Grz_ArgentinaSalesOrderStatusField.trim().Split(',');
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        
        String accountId = user[0].AccountId;
        
        String query = 'Select Id,Name,SAP_Order_Number__c, SFDC_Order_Number__c , Amount__c, CreatedBy.Name, CurrencyIsoCode, CreatedDate , Brazil_City__c , toLabel(Order_Status__c),OrderQuantity__c,Total_Amount__c,Sold_to_Party__r.name,Sold_to_Party__c from Sales_Order__c';
        String filter = ' where SalesOrgCode__c =:salesorgcode and Order_Status__c IN :salesOrderStatus ';
        
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where Sold_to_Party__c =: accountId';
            }
            else{
                filter += ' and Sold_to_Party__c =: accountId';
            }     
        }
        
       
        if (!string.IsBlank(searchKey)) {
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (Name like \'%' +searchKey+ '%\' or SAP_Order_Number__c like \'%' +searchKey+ '%\' or SFDC_Order_Number__c  like \'%' +searchKey+ '%\')' ;
        }
        if (!string.IsBlank(allOrderStatus)) {
            if(allOrderStatus != 'All'){
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
        if(orderByDate != NULL && orderByDate != ''){
            query += ' order by ' +orderByDate; 
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
            orderResult.CurrencyArgentina = sOrder.CurrencyIsoCode;
            if(sOrder.Total_Amount__c != null){
                orderResult.Amount = String.valueOf(sOrder.Total_Amount__c.setScale(2).format());
            }
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
        public String CurrencyArgentina{get;set;} 
        
    }
}