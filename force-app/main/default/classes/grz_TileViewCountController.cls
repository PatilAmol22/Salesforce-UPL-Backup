public with sharing class grz_TileViewCountController {
    
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getOrderAndTicketCountAll(String language){
        ResultWrapper saleWrapper = new ResultWrapper();
        if(language == 'pt-BR'){
            saleWrapper = grz_TileViewCountController.getOrderAndTicketCountBrazil();
        }
        else if(language == 'es-MX')
        {
            saleWrapper = grz_TileViewCountController.getOrderAndTicketCountMexico();
        }
        else if(language == 'es')
        {
            saleWrapper = grz_TileViewCountController.getOrderAndTicketCountChile();
        }
        else{
            saleWrapper = grz_TileViewCountController.getOrderAndTicketCount();
        }
        return saleWrapper;
    }
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getOrderAndTicketCount(){
        ResultWrapper saleWrapper = new ResultWrapper();
        Id id = UserInfo.getUserId();                                   // getting current user info
        List<User> user =  [SELECT Id, Username,FirstName,LastName, AccountId,Account.SAP_Code__c, ContactId,profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        Id caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        String  draftLabel = System.Label.Grz_CaseStatusDraft;
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel,IsClosed From CaseStatus Where MasterLabel != : draftLabel];
        List<String> caseStatusIsclosedTruelst = new List<String>();
        List<String> caseStatusIsclosedfalselst = new List<String>();
        for(CaseStatus cs : caseStatusList){
            if(cs.IsClosed){
                caseStatusIsclosedTruelst.add(cs.MasterLabel);
            }
            else{
                caseStatusIsclosedfalselst.add(cs.MasterLabel);
            }                
        }
        String ticketQuery = 'SELECT Id,Status FROM Case where ';         // getting Case Count
        if(!String.isEmpty(accountId)){
            ticketQuery += 'AccountId = :accountId and ';
            saleWrapper.sapCode = user[0].Account.SAP_Code__c;
            saleWrapper.userText = 'SAP Customer Number';
            saleWrapper.isInternal = false;
        }else{
            saleWrapper.userText = user[0].FirstName + ' ' +user[0].LastName;
            saleWrapper.isInternal = true;
        }
        String fiscalyear = System.Label.Grz_FiscalYear;
        if(fiscalyear == '0'){
            ticketQuery += 'createddate = THIS_FISCAL_YEAR and ';
        }
        else{
            ticketQuery += 'createddate >= LAST_N_FISCAL_YEARS:1 and ';
        }
        //Sub_Category__c condition added for showing only case created from community (Sumit Kumar) Jira Ticket No. RITM0427885 modified on 30-09-2022
        ticketQuery += 'RecordTypeId =: caseRecordTypeId and CaseOwner__c != Null and Sub_Category__c = Null';
        List<Case> caseCounttotal = Database.Query(ticketQuery);
        List<String> casecount = new List<String>();
        for(Case cs: caseCounttotal){
            if(caseStatusIsclosedfalselst.contains(cs.status)){
                casecount.add(cs.Id); 
            }
        }
        saleWrapper.ticketCount = casecount.size();
        saleWrapper.ticketTotalCount  = caseCounttotal.size();
        List<String> salesorgcode = System.Label.Grz_IndiaSalesOrgCode.trim().Split(',');        
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
         String Value = 'Completely processed';
        String queryComProccessed = 'Select count() from Sales_Order__c where Order_Status__c != null and SalesOrgCode__c in:salesorgcode and Order_Status__c =: Value and ';
        String query = 'Select count() from Sales_Order__c where Order_Status__c != null and SalesOrgCode__c in:salesorgcode and Order_Status__c in: pickListValuesActive and ';         // getting Sales Order Count
        if(!String.isEmpty(accountId)){
              queryComProccessed += 'Sold_to_Party__c =:accountId and ';
            query += 'Sold_to_Party__c =:accountId and ';
        }  
        if(fiscalyear == '0'){
             queryComProccessed +=  'createddate = THIS_FISCAL_YEAR';
            query += 'createddate = THIS_FISCAL_YEAR';
        }
        else{
            queryComProccessed +=  'createddate >= LAST_N_FISCAL_YEARS:1';
            query += 'createddate >= LAST_N_FISCAL_YEARS:1';
        }
        Integer completelyProcessed =  Database.countQuery(queryComProccessed);
        Integer salesCount = Database.countQuery(query); 
        saleWrapper.salesOrderCompletelyProcessedCount = completelyProcessed;
        saleWrapper.salesOrderCount = salesCount;
        return saleWrapper;
    }
    
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getOrderAndTicketCountBrazil(){
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        String endDate = String.valueOf(myDate);
        Integer currentYear = System.Today().year();
        String startDate = currentYear + '-01-01';
        ResultWrapper saleWrapper = new ResultWrapper();
        Id id = UserInfo.getUserId();                                   // getting current user info
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name,Account.Customer_Group__c FROM User where Id =: id];
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
        String  draftLabel = System.Label.Grz_CaseStatusDraft;
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel,IsClosed From CaseStatus Where MasterLabel != : draftLabel];
        List<String> caseStatusIsclosedTruelst = new List<String>();
        List<String> caseStatusIsclosedfalselst = new List<String>();
        for(CaseStatus cs : caseStatusList){
            if(cs.IsClosed){
                caseStatusIsclosedTruelst.add(cs.MasterLabel);
            }
            else{
                caseStatusIsclosedfalselst.add(cs.MasterLabel);
            }                
        }
        String ticketQuery = 'SELECT Id,Status FROM Case where ';         // getting Case Count
        if(!String.isEmpty(accountId)){
            ticketQuery += 'AccountId In: accId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate+' and';
        }else{
            ticketQuery += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate+' and';
        }
        ticketQuery += ' RecordTypeId =: caseRecordTypeId';
        List<Case> caseCounttotal = Database.Query(ticketQuery);
        List<String> casecount = new List<String>();
        for(Case cs: caseCounttotal){
            if(caseStatusIsclosedfalselst.contains(cs.status)){
                casecount.add(cs.Id); 
            }
        }
        saleWrapper.ticketCount = casecount.size();
        saleWrapper.ticketTotalCount  = caseCounttotal.size();
        List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        // Added to get ordet type from Custom Setting GRZ(Nikhil Verma) : APPS-1394
        list<string> statusList= new list<string>();
        List<String> allStatus = Brazil_Portal_Configuration__c.getOrgDefaults().Portal_Sales_Order_Type__c.split('\n'); 
        for(String st : allStatus){
            statusList.add(st.trim());
        }
        
        String query = 'Select count() from Sales_Order__c where BrazilSalesOrderStatus__c In: orderSt  and Type_of_Order__c in: statusList and (NOT Invoice_status__c like \'%Entregue em%\') AND Invoice_status__c != \'Entregue\' AND SalesOrgCode__c in:salesorgcode and ';   // Added Entregue condition to exclude sales prder from Oper order count GRZ(Nikhil Verma) : APPS-1394
        if(!String.isEmpty(accountId)){
            query += 'Sold_to_Party__c In: accId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }  
        else{
            query += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        Integer salesCount = Database.countQuery(query); 
        saleWrapper.salesOrderCount = salesCount;
        return saleWrapper;
    }
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getOrderAndTicketCountMexico()
    {
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        String endDate = String.valueOf(myDate);
        Integer currentYear = System.Today().year();
        String startDate = currentYear + '-01-01';
        ResultWrapper saleWrapper = new ResultWrapper();
        Id id = UserInfo.getUserId();
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();
        String  draftLabel = System.Label.Grz_CaseStatusDraft;
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel,IsClosed From CaseStatus Where MasterLabel != : draftLabel];
        List<String> caseStatusIsclosedTruelst = new List<String>();
        List<String> caseStatusIsclosedfalselst = new List<String>();
        for(CaseStatus cs : caseStatusList){
            if(cs.IsClosed){
                caseStatusIsclosedTruelst.add(cs.MasterLabel);
            }
            else{
                caseStatusIsclosedfalselst.add(cs.MasterLabel);
            }                
        }
        String ticketQuery = 'SELECT Id,Status FROM Case where ';         // getting Case Count
        if(!String.isEmpty(accountId)){
            //ticketQuery += 'AccountId =: accountId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate+' and';
        	ticketQuery += 'AccountId = :accountId and createddate = THIS_FISCAL_YEAR and';
        }else{
            //ticketQuery += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate+' and';
            ticketQuery += 'createddate = THIS_FISCAL_YEAR and';
        }
        ticketQuery += ' RecordTypeId =: caseRecordTypeId';
        List<Case> caseCounttotal = Database.Query(ticketQuery);
        List<String> casecount = new List<String>();
        for(Case cs: caseCounttotal){
            if(caseStatusIsclosedfalselst.contains(cs.status)){
                casecount.add(cs.Id); 
            }
        }
        saleWrapper.ticketCount = casecount.size();
        saleWrapper.ticketTotalCount  = caseCounttotal.size();


        List<String> salesorgcode = System.Label.Grz_MexicoSalesOrgCode.trim().Split(',');
      
        String query = 'Select count() from Sales_Order__c where SalesOrgCode__c in:salesorgcode and ';         // getting Sales Order Count
        if(!String.isEmpty(accountId)){
            //query += 'Sold_to_Party__c = :accountId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        	query += 'Sold_to_Party__c = :accountId and createddate = THIS_FISCAL_YEAR';
        }  
        else{
            //query += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        	query += 'createddate = THIS_FISCAL_YEAR';
        }
        Integer salesCount = Database.countQuery(query); 
        saleWrapper.salesOrderCount = salesCount;
        
        return saleWrapper;
    }


 @AuraEnabled(cacheable=true)
    public static ResultWrapper getOrderAndTicketCountChile()
    {
        ResultWrapper saleWrapper = new ResultWrapper();

         Integer currentYear = System.Today().year();
        String startDate = currentYear + '-01-01';
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        String endDate = String.valueOf(myDate);
        Id id = UserInfo.getUserId();                                   // getting current user info
        List<User> user =  [SELECT Id, Username,FirstName,LastName, Account.Customer_Group__c,AccountId,Account.SAP_Code__c, ContactId,profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;        
        if(!String.isEmpty(accountId)){
            saleWrapper.sapCode = user[0].Account.SAP_Code__c;
            saleWrapper.userText = 'Número de cliente de SAP';
            saleWrapper.isInternal = false;
        }else{
            saleWrapper.userText = user[0].FirstName + ' ' +user[0].LastName;
            saleWrapper.isInternal = true;
        }

        List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        String query = 'Select count() from Sales_Order__c where BrazilSalesOrderStatus__c In: orderSt AND SalesOrgCode__c in:salesorgcode AND ';         // getting Sales Order Count
        if(!String.isEmpty(accountId)){
            query += 'Sold_to_Party__c =: accountId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }  
        else{
            query += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        
        String orderStatus = 'Completly processed';
        String orderStatus1 = 'Completely processed';
        String queryOperOrders = 'Select count() from Sales_Order__c where BrazilSalesOrderStatus__c In: orderSt AND Order_Status__c !=: orderStatus AND Order_Status__c !=: orderStatus1 AND SalesOrgCode__c in:salesorgcode AND ';         // getting Sales Order Count
        if(!String.isEmpty(accountId)){
            queryOperOrders += 'Sold_to_Party__c =: accountId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }  
        else{
            queryOperOrders += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        Integer openSalesCount = Database.countQuery(queryOperOrders); 
        Integer salesCount = Database.countQuery(query); 
        saleWrapper.openOrdersCountCl = openSalesCount;
        saleWrapper.salesOrderCount = salesCount;
        return saleWrapper;
    }
    public class ResultWrapper {
        @AuraEnabled public Integer salesOrderCompletelyProcessedCount { get; set; }
        @AuraEnabled public Integer salesOrderCount { get; set; }
        @AuraEnabled public Integer openOrdersCountCl { get; set; }
        @AuraEnabled public Integer ticketCount { get; set; }
        @AuraEnabled public Integer ticketTotalCount { get; set; }
        @AuraEnabled public String sapCode { get; set; }
        @AuraEnabled public String userText { get; set; }
        @AuraEnabled public Boolean isInternal { get; set; }
    }
}