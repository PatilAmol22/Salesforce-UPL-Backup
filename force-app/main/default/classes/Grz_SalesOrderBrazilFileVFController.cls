/**************************************************************************************************
* Name               : Grz_SalesOrderBrazilFileVFController                                                      
* Description        : Controller for SalesOrderList download functionality for Brazil Community
* Test Class         : Grz_SalesOrderBrazilFileVFControllerTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_SalesOrderBrazilFileVFController {
    public List<ResultWrapper> vfWrap{get;set;}
    public String customerName          {get;set;}
    public String dateCol               {get;set;}
    public String cstNameCol            {get;set;}
    public String userNameCol           {get;set;}
    public void Grz_SalesOrderListVF() {
        String searchKey = ApexPages.currentPage().getParameters().get('searchKey');
        String datefilter = ApexPages.currentPage().getParameters().get('datefilter');
        String sortby = ApexPages.currentPage().getParameters().get('sortby');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
        String invoicedata = ApexPages.currentPage().getParameters().get('invoicedata');
        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        String subGroupId = ApexPages.currentPage().getParameters().get('subGroupId');
        Boolean viewUndeliveredOrders = Boolean.valueOf(ApexPages.currentPage().getParameters().get('viewUndeliveredOrders'));
        if(Test.isRunningTest()){       
            startDate = '2019-04-02';
            endDate = '2030-07-02';
        }
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        Id id = UserInfo.getUserId(); // getting current user info
            List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        
            String accountId = user[0].AccountId;
            if(user[0].Account.Name != null){
                customerName = user[0].Account.Name;
                dateCol = '1';
                cstNameCol = '5';
                userNameCol = '3';
            }else{
                customerName = '';
                dateCol = '4';
                cstNameCol = '0';
                userNameCol = '5';
            }
            String groupCstr = user[0].Account.Customer_Group__c;
            Set<Id> accId = new Set<Id>();
            if(!String.isEmpty(groupCstr)){
                for(Account ac : [SELECT Id,Name,BillingCity, SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                    accId.add(ac.Id);
                }
            }
            accId.add(accountId);
        String query = 'Select Id,SalesOrderNumber_Brazil__c,Name,SAP_Order_Number__c, SFDC_Order_Number__c, Currency_Brazil__c,Invoice_Status__c,CreatedBy.Name, CreatedDate ,Total_Value_Brazil__c,BrazilSalesOrderStatus__c, LastModifiedDate, Type_of_Order__c, Brazil_City__c , Order_Type_lk__c, Order_Type_lk__r.Name, Order_Status__c,OrderQuantity__c,Total_Amount__c,Sold_to_Party__r.name,Sold_to_Party__c from Sales_Order__c';
        String filter = ' where SalesOrgCode__c in:salesorgcode and BrazilSalesOrderStatus__c In: orderSt';
        
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where Sold_to_Party__c In: accId';
            }
            else{
                filter += ' and Sold_to_Party__c In: accId';
            }     
        }
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where Sold_to_Party__r.SAP_Code__c =: distributor';
                }else{
                    filter += ' and Sold_to_Party__r.SAP_Code__c =: distributor';
                }
            }else{//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if (subGroupId != null && subGroupId != ''){
                    Set<String> subGroupSapId = new Set<String>();
                    for(Account acc : [SELECT SAP_Code__c FROM Account WHERE Sub_Parent_Account__r.SAP_Code__c = :subGroupId ]){
                        subGroupSapId.add(acc.SAP_Code__c);
                    }
                    subGroupSapId.add(subGroupId);
                    if (!filter.contains('where')){
                        filter += ' where Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    } else{
                        filter += ' and Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    }
                } 
            }    
        }
        if (!string.IsBlank(invoicedata)){
            if (invoicedata != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                if (invoicedata == 'A'){
                    filter += ' (Invoice_Status__c like \'%' + 'Faturado' + '%\' or Invoice_Status__c like \'%' + 'Faturado Parcial' + '%\')';
                } else if (invoicedata == 'B'){
                    filter += ' (Invoice_Status__c like \'%' + 'Pedido em Análise' + '%\' or Invoice_Status__c like \'%' + 'Crédito Bloqueado' + '%\' or Invoice_Status__c like \'%' + 'Crédito Liberado' + '%\' or Invoice_Status__c like \'%' + null + '%\')';
                } else if(invoicedata == 'Entregue em'){//Logic update, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                    filter += ' (Invoice_Status__c like \'%' + invoicedata + '%\' OR Invoice_Status__c = \'Entregue\')';
                }else{
                    filter += ' (Invoice_Status__c like \'%' + invoicedata + '%\')';
                }
            }else{//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if(viewUndeliveredOrders){
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' ( (NOT Invoice_Status__c like \'%Entregue em%\' ) AND Invoice_Status__c != \'Entregue\')';
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
                filter += ' Type_of_Order__c like \'%' +sortby+ '%\'';
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
            orderResult.SFDCOrderNumber = sOrder.SalesOrderNumber_Brazil__c;
            if (sOrder.Invoice_Status__c == 'Pedido em Análise' ||  sOrder.Invoice_Status__c == 'Crédito Bloqueado' || sOrder.Invoice_Status__c == 'Crédito Liberado') {
                orderResult.InvoiceStatus = 'Pedido em Processamento';
            }
            else if (sOrder.Invoice_Status__c == 'Faturado') {
                orderResult.InvoiceStatus = 'Pedido Faturado';
            }
            else if (sOrder.Invoice_Status__c == 'Faturado Parcial') {
                orderResult.InvoiceStatus = 'Pedido Faturado';
            }
            else if (sOrder.Invoice_Status__c != null && sOrder.Invoice_Status__c.contains('Entrega prevista')) {
                orderResult.InvoiceStatus = sOrder.Invoice_Status__c;
            }
            else if (sOrder.Invoice_Status__c != null && sOrder.Invoice_Status__c.contains('Entregue em')) {
                orderResult.InvoiceStatus = sOrder.Invoice_Status__c;
            }
            else if(sOrder.Invoice_Status__c == null){
                orderResult.InvoiceStatus = 'Pedido em Processamento'; 
            }
            else{
                orderResult.InvoiceStatus = sOrder.Invoice_Status__c;
            }
            if(sOrder.CreatedDate != null){
                orderResult.CreatedDate = grz_SapIntegration.FormattedDateBrazil(sOrder.CreatedDate);
            }
            orderResult.SalesRepName = sOrder.CreatedBy.Name;
            orderResult.SoldToPartyName = sOrder.Sold_To_Party__r.Name;
            orderResult.City = sOrder.Brazil_City__c;
            if (sOrder.Currency_Brazil__c != null){//Logic update, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if (sOrder.Currency_Brazil__c == 'Billing BRL / Payment BRL'){
                    orderResult.CurrencyBrazil = 'Real – BRL';
                } else if (sOrder.Currency_Brazil__c == 'Billing USD / Payment BRL'){
                    orderResult.CurrencyBrazil = 'Dólar – USD';
                } else if (sOrder.Currency_Brazil__c == 'Billing USD / Payment USD'){
                    orderResult.CurrencyBrazil = 'Dólar – USD';
                }
            }
            if(sOrder.Total_Value_Brazil__c != null){
                if(sOrder.Type_of_Order__c == 'BONIFICAÇÃO' || sOrder.Type_of_Order__c == 'REMESSA PARA TESTE'){
                    orderResult.Amount = '-';
                }else{
                    orderResult.Amount = String.valueOf(sOrder.Total_Value_Brazil__c.setScale(0));
                }
            }
            orderResult.OrderType = sOrder.Type_of_Order__c;
            orderResult.OrderStatus = sOrder.BrazilSalesOrderStatus__c;
            saleWrapperList.add(orderResult);
        }
        vfWrap = saleWrapperList;
    }
    public class ResultWrapper {
        @AuraEnabled public String Id{get;set;}
        @AuraEnabled public String SAPOrderNumber{get;set;}
        @AuraEnabled public String SFDCOrderNumber{get;set;}
        @AuraEnabled public String InvoiceStatus{get;set;}
        @AuraEnabled public String CreatedDate{get;set;}
        @AuraEnabled public String SalesRepName{get;set;}
        @AuraEnabled public String SoldToPartyName{get;set;}
        @AuraEnabled public String City{get;set;}
        @AuraEnabled public String Amount{get;set;}
        @AuraEnabled public String OrderType{get;set;}
        @AuraEnabled public String OrderStatus{get;set;}    
        @AuraEnabled public String CurrencyBrazil{get;set;} 
    }
}