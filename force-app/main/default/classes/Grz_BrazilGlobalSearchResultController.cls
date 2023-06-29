public with sharing class Grz_BrazilGlobalSearchResultController {
    @AuraEnabled(cacheable=true)
    public static List<Sales_Order__c> getSalesOrder(String searchKey){
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
            }
        }
        accId.add(accountId);
        List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        // Added to get ordet type from Custom Setting GRZ(Nikhil Verma) : APPS-1394
        list<string> statusList= new list<string>();
        List<String> allStatus = Brazil_Portal_Configuration__c.getOrgDefaults().Portal_Sales_Order_Type__c.split('\n'); 
        for(String st : allStatus){
            statusList.add(st.trim());
        }

        String query = 'Select Id, Name, Type_of_Order__c,SalesOrderNumber_Brazil__c,Invoice_status__c,BrazilSalesOrderStatus__c, Brazil_City__c, CurrencyIsoCode, Currency_Brazil__c,Payment_Term__r.Name, Payment_Term__c,(Select Id, SKU_Code__c, UOM__c, Value_Number__c, Unit_Price__c, sale_order__c,Brazil_Product__c, ProductName__c, Quantity__c,TotalValueWithoutInterest__c,UnitValue__c from Sales_Order_Line_Item__r), (Select Id, Name, Billing_Doc_Number__c, Billing_Date__c, TotalSalesAmount__c, Billing_Status__c, Acknowledge__c, Sold_To_Party__c from Invoice__r), Sold_to_Party__r.Name, SAP_Order_Number__c, SFDC_Order_Number__c, CreatedDate,createdby.name, Order_Type_lk__r.Name, Total_Value_Brazil__c,Order_Status__c, OrderQuantity__c, Total_Amount__c from Sales_Order__c';
        query += ' where SalesOrgCode__c in:salesorgcode and BrazilSalesOrderStatus__c In: orderSt and Type_of_Order__c in: statusList'; // Added type of order filter GRZ(Nikhil Verma) : APPS-1394
        if(!String.isEmpty(accountId)) {
            query += query.contains('where') ? ' and' : ' where';
            query +=  ' Sold_to_Party__c In: accId';     
        }
        if (!string.IsBlank(searchKey)) {
            query += query.contains('where') ? ' and' : ' where';
            query += ' (Name like \'%' +searchKey+ '%\' or SAP_Order_Number__c like \'%' +searchKey+ '%\' or SFDC_Order_Number__c  like \'%' +searchKey+ '%\')' ;
        }
        query += ' order by CreatedDate desc LIMIT 20';
        List<Sales_Order__c> Sales = new  List<Sales_Order__c>();
        Sales = Database.query(query);
        return Sales;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Case> getCase(String searchKey){
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
            }
        }
        accId.add(accountId);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();
        String query = 'Select id,CaseNumber,Type,Subject,Description,account.name,Priority,CreatedBy.Name, Escalation_Level__c,Owner.name,Owner.FirstName, Owner.LastName,Status,Origin,createddate,lastmodifieddate from Case';
        if(!String.isEmpty(accountId)) {
            query += query.contains('where') ? ' and' : ' where';
            query +=  ' AccountId In: accId';   
        }
        if(!String.isEmpty(caseRecordTypeId)){
            query += query.contains('where') ? ' and' : ' where';
            query +=  ' RecordTypeId =:caseRecordTypeId';
        }
        if (!string.IsBlank(searchKey)) {
            query += query.contains('where') ? ' and' : ' where';
            query += ' casenumber like \'%' +searchKey+ '%\'';
        }
        query += ' order by CreatedDate desc LIMIT 20';
        List<Case> caseList = Database.query(query);
        return caseList;
    }
}