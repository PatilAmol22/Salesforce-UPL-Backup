public with sharing class grz_SalesOrderSummary {
    public static String currencyINDformat(Decimal value){
        Decimal d = value.setScale(2);
        List<String> args = new String[]{'0','number','#,###.0'};
        String indamount = String.format(d.format(), args);
        return indamount;
    }
    public static String FormattedDateBr(Datetime dt){
        String dateFormatString = 'd/M/yyyy';
        String dateString = dt.format(dateFormatString);
        return dateString;
    }
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getSalesOrderRecordAll(String language){
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        if(language == 'pt-BR'){
            saleWrapperList = grz_SalesOrderSummary.getSalesOrderRecordBrazil();
        }
        else if(language == 'es-MX'){
            saleWrapperList = grz_SalesOrderSummary.getSalesOrderRecordMexico();
        }
        else if(language == 'es'){
            saleWrapperList = grz_SalesOrderSummary.getSalesOrderRecordChile();
        }
        else{
            saleWrapperList = grz_SalesOrderSummary.getSalesOrderRecord();
        }
        return saleWrapperList;
    }
    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getCaseRecordAll(String language){
        FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();
        if(language == 'pt-BR'){
            objDT = grz_SalesOrderSummary.getCaseRecordBrazil();
        }
        else if(language == 'es-MX'){
            objDT = grz_SalesOrderSummary.getCaseRecordMexico();
        } 
        else{
            objDT = grz_SalesOrderSummary.getCaseRecord();
        }
        return objDT;
    }
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getSalesOrderRecord(){
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        Id id = UserInfo.getUserId();  // getting current user info
        //Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String query = 'Select Id,(SELECT Id,Sale_Order__c, SKU_Description__c, Quantity__c, Price__c FROM Sales_Order_Line_Item__r Limit 5), Name, SAP_Order_Number__c, Order_Type_lk__c,Type_of_Order__c, Order_Status__c, Total_Amount__c, Sold_to_Party__r.name, Sold_to_Party__c, Order_Date__c,Payment_Term__c,Total_Value_Brazil__c,createdby.name from Sales_Order__c where ';
        if(!String.isEmpty(accountId)){
            query += 'Sold_to_Party__c =:accountId and ';
        }
        String fiscalyear = System.Label.Grz_FiscalYear;
        if(fiscalyear == '0'){
            query += 'createddate = THIS_FISCAL_YEAR and ';
        }
        else{
            query += 'createddate >= LAST_N_FISCAL_YEARS:1 and ';
        }
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
        query += 'Order_Status__c != null and SalesOrgCode__c in:salesorgcode and Order_Status__c in: pickListValuesActive order by createddate desc limit 5';
        System.debug('query-----' +query); 
        String dateFormatString = 'MMM dd, yyyy';
        Integer count = 0;
        for(Sales_Order__c sOrder : Database.query(query)){
            ResultWrapper orderResult = new ResultWrapper();
            List<ResultWrapper> salesLineItemsWrapperList = new List<ResultWrapper>();
            String sapOrderNum = sOrder.SAP_Order_Number__c;
            if(String.isEmpty(sapOrderNum)){
                orderResult.SAPOrderNumber = sOrder.Name.RIGHT(8);
            }
            else{
                orderResult.SAPOrderNumber = sOrder.SAP_Order_Number__c;
            }
            orderResult.Id = sOrder.Id;
            orderResult.SoldtoParty = sOrder.Sold_to_Party__r.name;
            orderResult.OrderType = sOrder.Order_Type_lk__c;
            // orderResult.Quantity = sOrder.OrderQuantity__c;
            //orderResult.OrderAmount = sOrder.Total_Amount__c;
            Decimal OrderAmt = sOrder.Total_Amount__c;
            if(OrderAmt != null){
                //orderResult.OrderAmount = orderResult.OrderAmount.setScale(2);
                Decimal d = sOrder.Total_Amount__c.setScale(2);
                orderResult.OrderAmount = currencyINDformat(d);
            }
            orderResult.Status = sOrder.Order_Status__c;
            orderResult.PaymentTerm = sOrder.Payment_Term__c;
            orderResult.TypeofOrder = sOrder.Type_of_Order__c;            
            if(orderResult.TotalValue != null){
                orderResult.TotalValue = orderResult.TotalValue.setScale(2);
            }
            if(orderResult.Status=='Partially processed' || orderResult.Status=='Pending' || orderResult.Status=='Open' || orderResult.Status=='Not yet processed' || orderResult.Status=='Submitted' || orderResult.Status=='Draft'){
                orderResult.StatusColor = 'color: white; background-color : orange;';
            }
            else if(orderResult.Status=='Not Relevant' || orderResult.Status=='Order Cancelled' || orderResult.Status=='Rejected' || orderResult.Status=='Cancelled' || orderResult.Status=='Error from SAP' || orderResult.Status=='Blocked'){
                orderResult.StatusColor = 'color: white; background-color : red;';
            }
            else if(orderResult.Status == 'Completely processed' || orderResult.Status == 'Completly processed' || orderResult.Status == 'Approved'){
                orderResult.StatusColor = 'color: white; background-color : green;';
            }
            else{
                orderResult.StatusColor = 'color: white; background-color: #888888; fontFamily: NotoSansRegular';
            }
            System.debug('before date -----' +sOrder.Order_Date__c); 
            if(sOrder.Order_Date__c != null){
                Datetime dt = sOrder.Order_Date__c;  
                orderResult.OrderDate = grz_SapIntegration.FormattedDate(dt);     
            }
            orderResult.OrderDateBr = sOrder.Order_Date__c;
            count = count + 1;    
            orderResult.CountId = count;
            for (Sales_Order_Line_Item__c salesLineItems : sOrder.Sales_Order_Line_Item__r) {
                ResultWrapper childItems = new ResultWrapper();
                childItems.Id  =  salesLineItems.Id;
                childItems.Description = salesLineItems.SKU_Description__c;
                childItems.CountId = count;
                Decimal quantituval = salesLineItems.Quantity__c;
                if(quantituval != null){
                    childItems.Quantity = currencyINDformat(quantituval);
                }
                //childItems.Price = salesLineItems.Price__c;
                Decimal amtvalue = salesLineItems.Price__c;
                if(amtvalue != null){
                    //childItems.Price = childItems.Price.setScale(2);
                    childItems.Price = currencyINDformat(amtvalue);
                }
                childItems.SalesOrderId = salesLineItems.Sale_Order__c;
                if(sOrder.Sales_Order_Line_Item__r.size() == 1){
                    childItems.ShowIcon = false;
                }else{
                    childItems.ShowIcon = true;
                }                    
                salesLineItemsWrapperList.add(childItems);    
            } 
            if(salesLineItemsWrapperList.size() == 1){
                orderResult.ShowIcon = false;
            }else{
                orderResult.ShowIcon = true;
            }
            orderResult.children = salesLineItemsWrapperList;            
            saleWrapperList.add(orderResult);
        }
        List<ResultWrapper> saleWrapperList1 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList2 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList3 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList4 = new  List<ResultWrapper>();
        
        for(ResultWrapper so: saleWrapperList){
            if(so.Status=='Partially processed' || so.Status=='Pending' || so.Status=='Open' || so.Status=='Not yet processed' || so.Status=='Submitted' || so.Status=='Draft'){
                saleWrapperList1.add(so);
            }
            else if(so.Status=='Not Relevant' || so.Status=='Order Cancelled' || so.Status=='Rejected' || so.Status=='Cancelled' || so.Status=='Error from SAP' || so.Status=='Blocked'){
                saleWrapperList2.add(so);
            }
            else if(so.Status=='Completly processed' || so.Status=='Completely processed' || so.Status=='Approved'){
                saleWrapperList3.add(so);
            }
            else {
                saleWrapperList4.add(so);
            }
            /*else if(so.Status=='Request for Cancellation'){
        saleWrapperList4.add(so);
        }*/
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList2);
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList3);
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList4);
        }
        return saleWrapperList1;
    }
    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getCaseRecord(){
        FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();
        List<ResultWrapper> caseWrapperList = new List<ResultWrapper>();
        Id id = UserInfo.getUserId();                                   // getting current user info
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        system.debug('accountId : '+accountId);
        Id caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel From CaseStatus Where IsClosed = false and MasterLabel not in ('Draft')];
        List<String> caseStatuslst = new List<String>();
        for(CaseStatus cs : caseStatusList){
            caseStatuslst.add(cs.MasterLabel);
        }
        String query = 'SELECT Id, CaseNumber, Subject, Status, Type, Origin, Priority, CreatedDate, ClosedDate, IsEscalated, Account.name,Owner.name,Owner.FirstName,Owner.LastName,RecordTypeId FROM Case where ';
        if(!String.isEmpty(accountId)){
            query += 'AccountId = :accountId and ';
        }
        String fiscalyear = System.Label.Grz_FiscalYear;
        if(fiscalyear == '0'){
            query += 'createddate = THIS_FISCAL_YEAR and ';
        }
        else{
            query += 'createddate >= LAST_N_FISCAL_YEARS:1 and ';
        }
        //query += 'Status in : caseStatuslst and DAY_ONLY(createdDate) >= :startDate and DAY_ONLY(createdDate) <= :endDate order by createddate desc Limit 5';
        
        //Sub_Category__c condition added for showing only case created from community (Sumit Kumar) Jira Ticket No. RITM0427885 modified on 30-09-2022
        query += 'Status in : caseStatuslst and RecordTypeId =: caseRecordTypeId and CaseOwner__c != Null and Sub_Category__c = Null order by createddate desc Limit 5';
        system.debug('Case query : '+query);
        List<Case> caseList = Database.query(query);
        String dateFormatString = 'MMM dd, yyyy';
        for(Case clist :caseList){
            ResultWrapper caseResult = new ResultWrapper();
            caseResult.Id = clist.Id;
            caseResult.CaseNumber = clist.CaseNumber;
            caseResult.Subject = clist.Subject;
            caseResult.Status = clist.Status;
            caseResult.Type = clist.Type;
            caseResult.Origin = clist.Origin;
            caseResult.Priority = clist.Priority; 
            Datetime dt = clist.CreatedDate;
            // String dateString= dt.format(dateFormatString);
            caseResult.CreatedDate = grz_SapIntegration.FormattedDate(dt);
            //caseResult.AssignTo = clist.Owner.FirstName+' '+clist.Owner.LastName;
            String nn = clist.Owner.LastName;
            if(null != clist.Owner.FirstName){  
                caseResult.AssignTo = clist.Owner.FirstName+' '+nn; 
            }
            else{
                caseResult.AssignTo = nn;
            }
            caseWrapperList.add(caseResult);
        }
        objDT.caseWrapList = caseWrapperList;       
        return objDT;
    }
    
    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getCaseRecordBrazil(){
        Integer currentYear = System.Today().year();
        String startDate = currentYear + '-01-01';
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        String endDate = String.valueOf(myDate);
        FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();
        List<ResultWrapper> caseWrapperList = new List<ResultWrapper>();
        Id id = UserInfo.getUserId();                                   // getting current user info
        System.debug('User Id : '+id);
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String profilename = user[0].profile.name;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
            }
        }
        accId.add(accountId);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();
        system.debug('caseRecordTypeId ==='+caseRecordTypeId);
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel From CaseStatus Where IsClosed = false and MasterLabel not in ('Draft')];
        List<String> caseStatuslst = new List<String>();
        for(CaseStatus cs : caseStatusList){
            caseStatuslst.add(cs.MasterLabel);
        }
        String query = 'SELECT Id, CaseNumber, Subject, Status, Type, Origin, Priority, CreatedDate, ClosedDate, IsEscalated, Account.name,Owner.name,Owner.FirstName,Owner.LastName,RecordTypeId FROM Case where ';
        if(!String.isEmpty(accountId)){
            query += 'AccountId In:accId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+ endDate +' and ';
        }else{
            query += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+ endDate +' and ';
        }
        //query += 'Status in : caseStatuslst and DAY_ONLY(createdDate) >= :startDate and DAY_ONLY(createdDate) <= :endDate order by createddate desc Limit 5';
        query += 'Status in : caseStatuslst and RecordTypeId =: caseRecordTypeId order by createddate desc Limit 5';
        system.debug('Case query : '+query);
        List<Case> caseList = Database.query(query);
        for(Case clist :caseList){
            ResultWrapper caseResult = new ResultWrapper();
            caseResult.Id = clist.Id;
            caseResult.CaseNumber = clist.CaseNumber;
            caseResult.Subject = clist.Subject;
            caseResult.Status = clist.Status;
            caseResult.Type = clist.Type;
            caseResult.Origin = clist.Origin;
            caseResult.Priority = clist.Priority; 
            Datetime dt = clist.CreatedDate;
            caseResult.CreatedDate = grz_SapIntegration.FormattedDateBrazil(dt);
            //caseResult.AssignTo = clist.Owner.FirstName+' '+clist.Owner.LastName;
            String nn = clist.Owner.LastName;
            if(null != clist.Owner.FirstName){  
                caseResult.AssignTo = clist.Owner.FirstName+' '+nn; 
            }
            else{
                caseResult.AssignTo = nn;
            }
            caseWrapperList.add(caseResult);
        }
        objDT.caseWrapList = caseWrapperList;       
        return objDT;
    }
        
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getSalesOrderRecordBrazil(){
        Integer currentYear = System.Today().year();
        String startDate = currentYear + '-01-01';
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        String endDate = String.valueOf(myDate);
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        Id id = UserInfo.getUserId();  // getting current user info
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
        String query = 'Select Id,SFDC_Order_Number__c,Invoice_Status__c,Brazil_City__c,BrazilSalesOrderStatus__c,(SELECT Id,UnitValue__c,ProductName__c,Sale_Order__c, SKU_Description__c, Quantity__c,TotalValueWithInterest__c, Price__c FROM Sales_Order_Line_Item__r Limit 5), Name, SAP_Order_Number__c, Order_Type_lk__c,Type_of_Order__c, Order_Status__c, Total_Amount__c, Sold_to_Party__r.name, Sold_to_Party__c, Order_Date__c,Payment_Term__c,Total_Value_Brazil__c,createdby.name,CreatedDate from Sales_Order__c where ';
        if(!String.isEmpty(accountId)){
            query += 'Sold_to_Party__c In:accId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+ endDate +' and ';
        }else{
            query += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+ endDate +' and ';
        }
        List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        // Added to get ordet type from Custom Setting GRZ(Nikhil Verma) : APPS-1394
        list<string> statusList= new list<string>();
        List<String> allStatus = Brazil_Portal_Configuration__c.getOrgDefaults().Portal_Sales_Order_Type__c.split('\n'); 
        for(String st : allStatus){
            statusList.add(st.trim());
        }

        List<String> orderSt = System.Label.Approved.trim().Split(',');
        query += 'BrazilSalesOrderStatus__c In: orderSt and SalesOrgCode__c IN:salesorgcode and Type_of_Order__c in:statusList order by createddate desc limit 5';// Added order type filter GRZ(Nikhil Verma) : APPS-1394
        System.debug('query-----' +query); 
        Integer count = 0;
        for(Sales_Order__c sOrder : Database.query(query)){
            ResultWrapper orderResult = new ResultWrapper();
            List<ResultWrapper> salesLineItemsWrapperList = new List<ResultWrapper>();
            String sapOrderNum = sOrder.SFDC_Order_Number__c;
            if(String.isEmpty(sapOrderNum)){
                orderResult.SAPOrderNumber = sOrder.SFDC_Order_Number__c;
            }
            else{
                orderResult.SAPOrderNumber = sOrder.SFDC_Order_Number__c;
            }
            orderResult.Id = sOrder.Id;
            orderResult.SoldtoParty = sOrder.Sold_to_Party__r.name;
            orderResult.OrderType = sOrder.Order_Type_lk__c;
            orderResult.PaymentTerm = sOrder.Payment_Term__c;
            orderResult.TypeofOrder = sOrder.Type_of_Order__c;  
            orderResult.TotalValue = sOrder.Total_Value_Brazil__c;
            if (
                sOrder.Invoice_Status__c == 'Pedido em Análise' ||
                sOrder.Invoice_Status__c == 'Crédito Bloqueado' ||
                sOrder.Invoice_Status__c == 'Crédito Liberado'      
            ) {
                orderResult.Status = 'Pedido em Processamento';
            }
            else if (sOrder.Invoice_Status__c == 'Faturado' || sOrder.Invoice_Status__c == 'Faturado Parcial') {
                orderResult.Status = 'Pedido Faturado';
            }
            else if (sOrder.Invoice_Status__c != null && sOrder.Invoice_Status__c.contains('Entrega prevista')) {
                orderResult.Status = sOrder.Invoice_Status__c;
            }
            else if (sOrder.Invoice_Status__c != null && sOrder.Invoice_Status__c.contains('Entregue em')) {
                orderResult.Status = sOrder.Invoice_Status__c;
            }
            else if(sOrder.Invoice_Status__c == null){
                orderResult.Status = 'Pedido em Processamento'; 
            }
            else{
                orderResult.Status = sOrder.Invoice_Status__c;
            }  
            orderResult.StatusColor = 'color: white; background-color : green;';      
            if(orderResult.TotalValue != null){
                if(orderResult.TypeofOrder == 'BONIFICAÇÃO' || orderResult.TypeofOrder == 'REMESSA PARA TESTE'){
                    orderResult.TotalValue = 0;
                }else{
                    orderResult.TotalValue = orderResult.TotalValue.setScale(0);
                }
            }
            orderResult.CityBr = sOrder.Brazil_City__c;  
            if(sOrder.CreatedDate != null){
                orderResult.CreatedDate = grz_SalesOrderSummary.FormattedDateBr(sOrder.CreatedDate);
            }
            count = count + 1;    
            orderResult.CountId = count;
            for (Sales_Order_Line_Item__c salesLineItems : sOrder.Sales_Order_Line_Item__r) {
                ResultWrapper childItems = new ResultWrapper();
                childItems.Id  =  salesLineItems.Id;
                childItems.Description = salesLineItems.SKU_Description__c;
                childItems.ProductName = salesLineItems.ProductName__c;
                childItems.CountId = count;
                Decimal quantituval = salesLineItems.Quantity__c;
                if(quantituval != null){
                    childItems.Quantity = String.valueOf(quantituval);
                }
                if(salesLineItems.UnitValue__c != null){
                    childItems.Price = String.valueOf(salesLineItems.UnitValue__c.setScale(2));
                }
                if(salesLineItems.TotalValueWithInterest__c != null){
                    childItems.TotalPrice = String.valueOf(salesLineItems.TotalValueWithInterest__c.setScale(2));
                }
                childItems.SalesOrderId = salesLineItems.Sale_Order__c;
                if(sOrder.Sales_Order_Line_Item__r.size() == 1){
                    childItems.ShowIcon = false;
                }else{
                    childItems.ShowIcon = true;
                }                    
                salesLineItemsWrapperList.add(childItems);    
            } 
            if(salesLineItemsWrapperList.size() == 1){
                orderResult.ShowIcon = false;
            }else{
                orderResult.ShowIcon = true;
            }
            orderResult.children = salesLineItemsWrapperList;            
            saleWrapperList.add(orderResult);
        }
        List<ResultWrapper> saleWrapperList1 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList2 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList3 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList4 = new  List<ResultWrapper>();
        
        for(ResultWrapper so: saleWrapperList){
            if(so.Status != null && so.Status.contains('Entrega prevista')){
                saleWrapperList1.add(so);
            }
            else if(so.Status=='Pedido Faturado'){
                saleWrapperList2.add(so);
            }
            else if(so.Status=='Pedido em Processamento'){
                saleWrapperList3.add(so);
            }
            else {
                saleWrapperList4.add(so);
            }
            /*else if(so.Status=='Request for Cancellation'){
        saleWrapperList4.add(so);
        }*/
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList2);
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList3);
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList4);
        }
        return saleWrapperList1;
    }

    
    // Chile Sales Order Records @ Added by Nikhil Verma
    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getSalesOrderRecordChile(){
        Integer currentYear = System.Today().year();
        String startDate = currentYear + '-01-01';
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        String endDate = String.valueOf(myDate);
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        Id id = UserInfo.getUserId();  // getting current user info
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String query = 'Select Id,Destination_City__c,Ship_To_Party__r.City__c,Purchase_Order_no__c,SFDC_Order_Number__c,Net_Amount__c,OrderTypeCode__c,Invoice_Status__c,Brazil_City__c,Sold_to_Party__r.BillingCity,BrazilSalesOrderStatus__c,(SELECT Id,UnitValue__c,ProductName__c,Sale_Order__c, SKU_Description__c, Quantity__c,TotalValueWithInterest__c, Price__c FROM Sales_Order_Line_Item__r Limit 5), Name, SAP_Order_Number__c, Order_Type_lk__c,Type_of_Order__c, Order_Status__c, Total_Amount__c, Sold_to_Party__r.name, Sold_to_Party__c, Order_Date__c,Payment_Term__c,Total_Value_Brazil__c,createdby.name,CreatedDate from Sales_Order__c where ';
        if(!String.isEmpty(accountId)){
            query += 'Sold_to_Party__c =: accountId and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+ endDate +' and ';
        }else{
            query += 'DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+ endDate +' and ';
        }
        List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        query += 'BrazilSalesOrderStatus__c In: orderSt and SalesOrgCode__c IN:salesorgcode order by createddate desc limit 5';
        System.debug('query-----' +query); 
        Integer count = 0;
        for(Sales_Order__c sOrder : Database.query(query)){
            ResultWrapper orderResult = new ResultWrapper();
            List<ResultWrapper> salesLineItemsWrapperList = new List<ResultWrapper>();
            String sapOrderNum = sOrder.Name;
            if(String.isEmpty(sapOrderNum)){
                orderResult.SAPOrderNumber = sOrder.Name;
            }
            else{
                orderResult.SAPOrderNumber = sOrder.Name;
            }
            orderResult.Id = sOrder.Id;
            orderResult.SoldtoParty = sOrder.Sold_to_Party__r.name;
            orderResult.OrderType = sOrder.Order_Type_lk__c;
            orderResult.PaymentTerm = sOrder.Payment_Term__c;
            orderResult.TypeofOrder = sOrder.Purchase_Order_no__c;  
            orderResult.TotalValue = sOrder.Total_Amount__c;
            orderResult.Status = sOrder.BrazilSalesOrderStatus__c; 
            orderResult.StatusColor = 'color: white; background-color : green;';     
            if(orderResult.TotalValue != null){
                orderResult.TotalValue = orderResult.TotalValue.setScale(0);
            }
            if(sOrder.Ship_To_Party__c != null){
                orderResult.CityBr = sOrder.Destination_City__c;  
            }else{
                orderResult.CityBr = '-';
            }
            if(sOrder.CreatedDate != null){
                orderResult.CreatedDate = grz_SapIntegration.FormattedDateChile(sOrder.CreatedDate);
            }
            count = count + 1;    
            orderResult.CountId = count;          
            saleWrapperList.add(orderResult);
        }
        List<ResultWrapper> saleWrapperList1 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList2 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList3 = new  List<ResultWrapper>();
        List<ResultWrapper> saleWrapperList4 = new  List<ResultWrapper>();
        
        for(ResultWrapper so: saleWrapperList){
            saleWrapperList1.add(so);
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList2);
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList3);
        }
        if(saleWrapperList1.size()<5){
            saleWrapperList1.addAll(saleWrapperList4);
        }
        return saleWrapperList1;
    }

    @AuraEnabled(cacheable=true)
    public static List<ResultWrapper> getSalesOrderRecordMexico(){
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        Id id = UserInfo.getUserId();  // getting current user info
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String query = 'Select Id, Name, SAP_Order_Number__c, Order_Type_lk__c,Type_of_Order__c, toLabel(Order_Status__c), Total_Amount__c, Sold_to_Party__r.name, Sold_to_Party__c, Order_Date__c,Payment_Term__c,Total_Value_Brazil__c,createdby.name from Sales_Order__c where ';
        if(!String.isEmpty(accountId)){
            query += 'Sold_to_Party__c =:accountId and createddate = THIS_FISCAL_YEAR and ';
        }else{
            query += 'createddate = THIS_FISCAL_YEAR and ';
        }
        String salesorgcode = System.Label.Grz_MexicoSalesOrgCode.trim();
        system.debug('salesorgcode : '+salesorgcode);
        
        query += 'Order_Status__c != null and SalesOrgCode__c = :salesorgcode order by createddate desc limit 5';
        System.debug('query-----' +query); 
        Integer count = 0;
        for(Sales_Order__c sOrder : Database.query(query)){
            ResultWrapper orderResult = new ResultWrapper();
            List<ResultWrapper> salesLineItemsWrapperList = new List<ResultWrapper>();
            String sapOrderNum = sOrder.SAP_Order_Number__c;
            if(String.isEmpty(sapOrderNum)){
                orderResult.SAPOrderNumber = sOrder.Name.RIGHT(8);
            }
            else{
                orderResult.SAPOrderNumber = sOrder.SAP_Order_Number__c;
            }
            orderResult.Id = sOrder.Id;
            //orderResult.SoldtoParty = sOrder.Sold_to_Party__r.name;
            //orderResult.OrderType = sOrder.Order_Type_lk__c;
            Decimal OrderAmt = sOrder.Total_Amount__c;
            if(OrderAmt != null){
                Decimal d = sOrder.Total_Amount__c.setScale(2);
                orderResult.OrderAmount = currencyINDformat(d);
            }
            orderResult.Status = sOrder.Order_Status__c;
            orderResult.StatusColor = 'color: white; background-color: green; fontFamily: NotoSansRegular';
            if(sOrder.Order_Date__c != null){
                Datetime dt = sOrder.Order_Date__c;  
                orderResult.OrderDate = grz_SapIntegration.FormattedDateMexico(dt);     
            }
            //orderResult.OrderDateBr = sOrder.Order_Date__c;
            count = count + 1;    
            orderResult.CountId = count;
                      
            saleWrapperList.add(orderResult);
        }
        
        return saleWrapperList;
    }
    // Mexico Code start for  retriving case Records
    
    @AuraEnabled(cacheable=true)
    public static FinamlSalesDataWrapper getCaseRecordMexico(){
        FinamlSalesDataWrapper objDT =  new FinamlSalesDataWrapper();
        List<ResultWrapper> caseWrapperList = new List<ResultWrapper>();
        Id id = UserInfo.getUserId();
        System.debug('User Id : '+id);
        List<User> user =  [SELECT Id, Username, AccountId, ContactId,profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        Set<Id> accId = new Set<Id>();
        accId.add(accountId);
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();
        system.debug('Mexico caseRecordTypeId === '+caseRecordTypeId);
        
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel From CaseStatus Where IsClosed = false and MasterLabel not in ('Draft')];
        List<String> caseStatuslst = new List<String>();
        for(CaseStatus cs : caseStatusList){
            caseStatuslst.add(cs.MasterLabel);
        }
        
        String query = 'SELECT Id, CaseNumber, Subject, toLabel(Status), toLabel(Type), Origin, Priority, CreatedDate,Createdby.name, ClosedDate, Account.name,Owner.name,Owner.FirstName,Owner.LastName,RecordTypeId FROM Case where ';
        if(!String.isEmpty(accountId)){
            query += 'AccountId In: accId and ';
        }
        
        query += 'createddate = THIS_FISCAL_YEAR and ';
        query += 'Status in : caseStatuslst and RecordTypeId =: caseRecordTypeId order by createddate desc Limit 5';
        system.debug('Case query : '+query);
        List<Case> caseList = Database.query(query);
        
        for(Case clist :caseList){
            ResultWrapper caseResult = new ResultWrapper();
            caseResult.Id = clist.Id;
            caseResult.CaseNumber = clist.CaseNumber;
            caseResult.Subject = clist.Subject;
            caseResult.Status = clist.Status;
            caseResult.Type = clist.Type;
            caseResult.Origin = clist.Origin;
            caseResult.Priority = clist.Priority; 
            Datetime dt = clist.CreatedDate;
            caseResult.CreatedDate = grz_SapIntegration.FormattedDateMexico(dt);
            caseResult.AssignTo = clist.Createdby.name;
            caseWrapperList.add(caseResult);
        }
        objDT.caseWrapList = caseWrapperList;
        
        return objDT;
    }

    public class ResultWrapper {
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public Integer CountId{get;set;}
        @AuraEnabled
        public String SAPOrderNumber{get;set;}
        @AuraEnabled
        public String Description{get;set;}
        @AuraEnabled
        public String ProductName{get;set;}
        @AuraEnabled
        public String OrderType{get;set;}
        @AuraEnabled
        public String TotalPrice{get;set;}
        @AuraEnabled
        public String Quantity{get;set;}
        @AuraEnabled
        public String OrderDate{get;set;}
        @AuraEnabled
        public Date OrderDateBr{get;set;}
        @AuraEnabled
        public String OrderAmount{get;set;}   // for india
        @AuraEnabled         
        public String Price{get;set;}
        @AuraEnabled
        public String Status{get;set;}
        @AuraEnabled
        public String SalesOrderId{get;set;}
        @AuraEnabled
        public String StatusColor{get;set;}
        @AuraEnabled
        public String TypeofOrder{get;set;}
        @AuraEnabled
        public String SoldtoParty{get;set;}
        @AuraEnabled
        public String CityBr{get;set;}
        @AuraEnabled
        public String PaymentTerm{get;set;}
        @AuraEnabled
        public Decimal TotalValue{get;set;}
        @AuraEnabled
        public Boolean ShowIcon{get;set;}
        @AuraEnabled
        public String CaseNumber{get;set;}
        @AuraEnabled
        public String Subject{get;set;}
        @AuraEnabled
        public String Type{get;set;}
        @AuraEnabled
        public String Origin{get;set;}
        @AuraEnabled
        public String Priority{get;set;}
        @AuraEnabled
        public String AssignTo{get;set;}
        @AuraEnabled
        public String CreatedDate{get;set;}
        @AuraEnabled
        public List<ResultWrapper> children {get;set;}
    }
    public class FinamlSalesDataWrapper {
        @AuraEnabled
        public List<ResultWrapper> caseWrapList {get;set;}
    }
}