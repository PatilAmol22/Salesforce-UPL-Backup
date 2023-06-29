public with sharing class grz_OrderSummary {
   

    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getSalesOrderRecord(
       
        String searchKey, 
        String datefilter, 
        String sortby, 
        Date getstartdate, 
        Date getenddate, 
        Decimal pageNumber, 
        Decimal pageSize) {
             
         
         Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        } 
        Integer pNumber = (Integer)pageNumber;
        System.debug('------pNumber-----+++++' +pNumber); 
        Integer offset = (pNumber - 1) * pSize;
        System.debug('-------offset-----+++++' +offset); 
         Id id = UserInfo.getUserId(); // getting current user info
        System.debug('id'+id);
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        system.debug('accountId'+accountId);
        String profilename = user[0].profile.name;
        system.debug('profilename '+profilename);
        

        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();

        FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();

        String countQuery= 'Select Count() from Sales_Order__c';
        List<String> salesorgcode = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');
        system.debug('salesorgcode : '+salesorgcode);
         List<String> pickListValuesActive   = new List<String>();
        List<String> pickListValuesInactive = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Sales_Order__c.Order_Status__c.getDescribe(); 
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pickListVal : ple) {
            if(pickListVal.isActive()) {
                pickListValuesActive.add(pickListVal.getLabel());
            } else {
                pickListValuesInactive.add(pickListVal.getLabel());
            }
        }
        objDT.activePickListVal = pickListValuesActive;
        system.debug(' objDT.activePickListVal'+ objDT.activePickListVal);
        system.debug('pickListValuesInactive'+pickListValuesInactive);
        
       // String query = 'Select count() from Sales_Order__c where Order_Status__c != null and SalesOrgCode__c in:salesorgcode and Order_Status__c in: pickListValuesActive and '; 
        String query = 'Select Id,Name,SAP_Order_Number__c, SFDC_Order_Number__c , CreatedDate , LastModifiedDate, Type_of_Order__c, Brazil_City__c , Order_Type_lk__c, Order_Type_lk__r.Name, Order_Status__c,OrderQuantity__c,Total_Amount__c,Sold_to_Party__r.name,Sold_to_Party__c from Sales_Order__c';
        System.debug('query-----+++++' +query);  
		
        String filter = ' where SalesOrgCode__c in:salesorgcode and Order_Status__c!= Null and Order_Status__c in: pickListValuesActive ';
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where'))
                filter +=  ' where Sold_to_Party__c =: accountId';
             else
                 filter += ' and Sold_to_Party__c =: accountId';
        }

       

        if (!string.IsBlank(searchKey)) {
            system.debug('search====='+searchKey);
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (Name like \'%' +searchKey+ '%\' or SAP_Order_Number__c like \'%' +searchKey+ '%\' or SFDC_Order_Number__c  like \'%' +searchKey+ '%\')' ;
        }
        if (!string.IsBlank(sortby)) {
            if(sortby != 'All'){
            system.debug('====sortby====='+sortby);
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' Order_Status__c like \'%' +sortby+ '%\'';
            }
           
        }


        String fiscalyear = System.Label.Grz_FiscalYear;
            
        if(!filter.contains('where')){
            if(fiscalyear == '0'){
                filter += ' where createddate = THIS_FISCAL_YEAR ';
            }
            else {
                query += ' where createddate >= LAST_N_FISCAL_YEARS:1 ';
            }  
        }
        else{
            if(fiscalyear == '0'){
                filter += ' and createddate = THIS_FISCAL_YEAR ';
            }
            else {
                filter += ' and createddate >= LAST_N_FISCAL_YEARS:1 ';
            }            
        }
            
        /*if(!filter.contains('where'))
        filter +=  ' where (createddate = THIS_FISCAL_YEAR) ';
        else
         filter +=  ' and (createddate = THIS_FISCAL_YEAR) ';*/

        
        query += filter;
        countQuery += filter;
       
        if(datefilter != NULL && datefilter != ''){
            system.debug('---datefilter---'+datefilter);
              query += ' order by ' +datefilter; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        }
            
         system.debug('query----'+query);
        system.debug('countQuery----'+countQuery);
        if(offset > 2000){
           offset = 2000; 
        }
        query += ' LIMIT :pSize OFFSET :offset';
        countQuery += ' LIMIT 2000';
        System.debug('query-----' +query);
        List<Sales_Order__c> salesOrderList = Database.query(query);  
        System.debug('Sales Order list -----++++++' +salesOrderList);
        Integer totalRecords =Database.countQuery(countQuery);
        Integer recordEnd = pSize * pNumber;
        System.debug('offset----'+offset);
       

        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.totalRecords = totalRecords;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords; 
          if(profilename.contains('Brazil')){
                objDT.brazilFlag = true;
            }
            else{
                objDT.brazilFlag = false;
            }
       
        for(Sales_Order__c sOrder : salesOrderList){
            
            ResultWrapper orderResult = new ResultWrapper();
            orderResult.Id = sOrder.Id;
            orderResult.SAPOrderNumber = sOrder.SAP_Order_Number__c;
            String lastchar;
               if(sOrder.Name.length()> 10){
                      lastchar = sOrder.Name.RIGHT(8);
               }
             orderResult.SalesOrderNumber = lastchar;
             orderResult.OrderDate =grz_SapIntegration.FormattedDate(sOrder.CreatedDate);
         
             orderResult.OrderLastModified =grz_SapIntegration.FormattedDate(sOrder.LastModifiedDate);
            orderResult.CustomerName = sOrder.Sold_to_Party__r.name;
            orderResult.OrderType = sOrder.Order_Type_lk__r.Name;

            if(sOrder.OrderQuantity__c != null){
            orderResult.Quantity  = currencyINDformat(sOrder.OrderQuantity__c);
            }
            if(sOrder.Total_Amount__c != null){
              orderResult.OrderAmount = currencyINDformat(sOrder.Total_Amount__c);
               System.debug('orderResult.OrderAmount : '+orderResult.OrderAmount);
            }
            orderResult.Status = sOrder.Order_Status__c;
             orderResult.BrazilCity = sOrder.Brazil_City__c;
              orderResult.BrazilOrderType = sOrder.Type_of_Order__c;
             if(profilename.contains('Brazil')){
                orderResult.IsBrazilUser = true;
            }
            else{
                orderResult.IsBrazilUser = false;
            }
            saleWrapperList.add(orderResult);
        }
        
        objDT.salesWrapList = saleWrapperList;
        system.debug('----objDT----'+objDT);
        return objDT;
    }

     public static String currencyINDformat(Decimal value){
        Decimal d = value.setScale(2);
        List<String> args = new String[]{'0','number','#,###.0'};
        String indamount = String.format(d.format(), args);
        System.debug('indamount : '+indamount);
        return indamount;
    }

    public class ResultWrapper {
            @AuraEnabled
            public String Id{get;set;}
            @AuraEnabled
            public String SAPOrderNumber{get;set;}
            @AuraEnabled
            public String SalesOrderNumber{get;set;}
            @AuraEnabled
            public String OrderDate{get;set;}
            @AuraEnabled
            public String OrderLastModified{get;set;}
            @AuraEnabled
            public String CustomerName{get;set;}
            @AuraEnabled
            public String OrderType{get;set;}
            @AuraEnabled
            public String Quantity{get;set;}
            
            @AuraEnabled
            public String OrderAmount{get;set;}
            @AuraEnabled
            public String Status{get;set;}
             @AuraEnabled
            public Boolean IsBrazilUser{get;set;}
             @AuraEnabled
            public String BrazilCity{get;set;}
             @AuraEnabled
            public String BrazilOrderType{get;set;}

           
           
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
            public Boolean brazilFlag {get;set;}
            @AuraEnabled
            public List<ResultWrapper> salesWrapList {get;set;}
             @AuraEnabled
            public List<String> activePickListVal {get;set;}

    }
     

}