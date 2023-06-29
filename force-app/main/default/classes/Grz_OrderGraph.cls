public with sharing class Grz_OrderGraph {
    @AuraEnabled
    public static Boolean getUserData() {
        Boolean validUser;
        Id id = UserInfo.getUserId();
        List<User> usr = [SELECT Id, profile.name FROM User WHERE Id=:id LIMIT 1];
        String stPro = usr[0].profile.name;
        if(stPro == 'Brazil Partner Community Distributor Supply Profile' || stPro == 'Brazil Partner Community Distributor Marketing Profile' ){
            validUser = false;
        }else{
            validUser = true;
        }
        return validUser;
    }
    @AuraEnabled
    public static List<ResultWrapper> getDonDataAll(String fiscalYearValue , String language) {
        List<ResultWrapper> wrapList = new List<ResultWrapper>();
        if(language == 'en_US'){
            wrapList = Grz_OrderGraph.getDonData(fiscalYearValue);
        }
         else if(language == 'es_MX'){
            wrapList = Grz_OrderGraph.getDonDataMexico(fiscalYearValue);
        }
        else if(language == 'es'){
            wrapList = Grz_OrderGraph.getDonDataChile(fiscalYearValue);
        }else{
            wrapList = Grz_OrderGraph.getDonDataBrazil(fiscalYearValue);
        }
        return wrapList;
    }
    public static List<ResultWrapper> getDonData(String fiscalYearValue) {
        Id id = UserInfo.getUserId(); // getting current user info
        List<String> AccId = new List<String>(); 
        List<User> user = [SELECT Id, Username, AccountId, userRole.name, ContactId FROM User where Id =: id];
        String query = 'SELECT SUM(Total_amount__c)totalAmt, CALENDAR_YEAR(createddate)calYear, FISCAL_MONTH(createddate)fm FROM Sales_Order__c where ';
        if(user[0].AccountId != null){
            String accountId = user[0].AccountId;
            query += 'Sold_to_Party__c =:accountId and ';
        }
        String fiscalyear = fiscalYearValue;
        if(fiscalyear == '0'){
            query += 'createddate = THIS_FISCAL_YEAR and ';
        }
        else {
            query += 'createddate = LAST_FISCAL_YEAR and ';
        }
        
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
        query += 'Order_Status__c != null and SalesOrgCode__c in:salesorgcode and Order_Status__c in: pickListValuesActive group by CALENDAR_MONTH(createddate), CALENDAR_YEAR(createddate) , FISCAL_MONTH(createddate)';
        List<AggregateResult> orderList= new List<AggregateResult>();
        for (AggregateResult result : Database.query(query)){
            orderList.add(result);
            System.debug('result==>'+result);
        }
        System.debug('orderList==>'+orderList);
        List<ResultWrapper> wrapList = new List<ResultWrapper>();
        ResultWrapper rw = new ResultWrapper();
        List<CredDonutData> data = new List<CredDonutData>();
        Decimal amtVal;
        Decimal tval=0;
        Integer cYear;
        Integer cYear1;
        if(fiscalyear == '0'){
            cYear =getCurrentFY();
            cYear1 =getCurrentFY()-1;
        }
        else {
            cYear =getCurrentFY()-1;
            cYear1 =getCurrentFY()-2;
        }
        String cYearStr=String.valueOf(cYear).right(2);
        String cYearStr1=String.valueOf(cYear1).right(2);
        List<string> MonthList=new list<String>{'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan', 'Feb','Mar'};
        for(String s:MonthList){
            if(MonthList.indexOf(s)<=8){
                data.add(new CredDonutData(s+'\n'+cYearStr1,0));
            }
            else{
                data.add(new CredDonutData(s+'\n'+cYearStr,0));
            }
        }
        for(AggregateResult so:orderList){
            if(so.get('totalAmt')==null){
                amtVal=0;
            }
            else{
                amtVal=(Decimal)so.get('totalAmt');
            }
            
            tval=tval+amtVal;
            
            if(so.get('fm')==1){
                data.set(0,new CredDonutData('Apr'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Apr'));
            }
            else if(so.get('fm')==2){
                data.set(1,new CredDonutData('May'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('May'));
            }
            else if(so.get('fm')==3){
                data.set(2,new CredDonutData('Jun'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Jun'));
            }
            else if(so.get('fm')==4){
                data.set(3,new CredDonutData('Jul'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Jul'));
            }
            else if(so.get('fm')==5){
                data.set(4,new CredDonutData('Aug'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Aug'));
            }
            else if(so.get('fm')==6){
                data.set(5,new CredDonutData('Sep'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Sep'));
            }
            else if(so.get('fm')==7){
                data.set(6,new CredDonutData('Oct'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Oct'));
            }
            else if(so.get('fm')==8){
                data.set(7,new CredDonutData('Nov'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Nov'));
            }
            else if(so.get('fm')==9){
                data.set(8,new CredDonutData('Dec'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Dec'));
            }
            else if(so.get('fm')==10){
                data.set(9,new CredDonutData('Jan'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('Jan'));
            }
            else if(so.get('fm')==11){
                System.debug('data.get(10)'+data.get(10));
                data.set(10,new CredDonutData('Feb'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('Feb'));
            }
            else if(so.get('fm')==12){
                data.set(11,new CredDonutData('Mar'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('Mar'));
            }
        }
        rw.cateListWrap = data;
        rw.Total=currencyINDformat(tval);
        //rw.Year=cYear;
        wraplist.add(rw);
        system.debug('Data'+wraplist);
        return wraplist;
    }
    public static List<ResultWrapper> getDonDataBrazil(String fiscalYearValue) {
        Id id = UserInfo.getUserId(); // getting current user info
        List<String> AccId = new List<String>(); 
        List<User> user = [SELECT Id, Username, AccountId, userRole.name, ContactId,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accIds = new Set<Id>();
            if(!String.isEmpty(groupCstr)){
                for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                    accIds.add(ac.Id);
                }
            }
        accIds.add(accountId);
        List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        // Added to get ordet type from Custom Setting GRZ(Nikhil Verma) : APPS-1394
        List<String> orderTypeList = new list<string>();
        List<String> invoiceOrderTypeList = new list<string>();
         List<String> salesOrderType = Brazil_Portal_Configuration__c.getOrgDefaults().Graph_Sales_Order_Type__c.split('\n'); 
         List<String> invoiceType = Brazil_Portal_Configuration__c.getOrgDefaults().Graph_Invoice_Order_Type__c.split('\n'); 
         for(String st : salesOrderType){
            orderTypeList.add(st.trim());
        }
        for(String st : invoiceType){
            invoiceOrderTypeList.add(st.trim());
        }
        //------End GRZ(Nikhil Verma) : APPS-1394
        
         String fiscalyear = fiscalYearValue;
        String query = 'SELECT SUM(Total_Value_Brazil__c)totalAmt, CALENDAR_YEAR(createddate)calYear, FISCAL_MONTH(createddate)fm FROM Sales_Order__c where ';
        if(!String.isEmpty(accountId)){
            query += 'Sold_to_Party__c In: accIds and ';
        }
        if(fiscalyear == '0'){
            query += 'createddate = THIS_FISCAL_YEAR and ';
        }
        else {
            query += 'createddate = LAST_FISCAL_YEAR and ';
        }
        query += 'BrazilSalesOrderStatus__c In: orderSt and SalesOrgCode__c in:salesorgcode AND Type_of_Order__c IN:orderTypeList  group by CALENDAR_MONTH(createddate), CALENDAR_YEAR(createddate) , FISCAL_MONTH(createddate)';
        system.debug('Query==>'+query);
        
        // InVoice Query
        String queryInv = 'SELECT SUM(Invoice_Total_Value__c)invTotalAmt, CALENDAR_YEAR(Billing_Date__c)calYear, FISCAL_MONTH(Billing_Date__c)fm FROM Invoice__c where ';
        if(!String.isEmpty(accountId)){
            queryInv += 'Sold_to_Party__c In: accIds and ';
        }
        if(fiscalyear == '0'){
            queryInv += 'Billing_Date__c = THIS_FISCAL_YEAR ';
        }
        else {
            queryInv += 'Billing_Date__c = LAST_FISCAL_YEAR ';
        }
        queryInv += ' and Sales_Org_Code__c in:salesorgcode AND Data_de_Cancelamento__c = null AND Sales_Order__r.Type_of_Order__c IN:invoiceOrderTypeList group by CALENDAR_MONTH(Billing_Date__c), CALENDAR_YEAR(Billing_Date__c) , FISCAL_MONTH(Billing_Date__c)';
        system.debug('queryInv==>'+queryInv);
        List<AggregateResult> orderList= new List<AggregateResult>();
        List<AggregateResult> invoiceList= new List<AggregateResult>();
        for (AggregateResult result : Database.query(query)){
            orderList.add(result);
        }
        for (AggregateResult result : Database.query(queryInv)){
            invoiceList.add(result);
        }
        List<ResultWrapper> wrapList = new List<ResultWrapper>();
        ResultWrapper rw = new ResultWrapper();
        List<CredDonutData> data = new List<CredDonutData>();
        List<invoiceDonutData> invData = new List<invoiceDonutData>();
        
        Integer cYear;
        Integer cYear1;
        if(fiscalyear == '0'){
            cYear =getCurrentFY();
            cYear1 =getCurrentFY()-1;
        }
        else {
            cYear =getCurrentFY()-1;
            cYear1 =getCurrentFY()-2;
        }
        //GRZ(Swaranjeet) : APPS-947 PO & Delivery Date :30-08-2022
        String cYearStr=String.valueOf(cYear).right(2);
        String cYearStr1=String.valueOf(cYear1).right(2);
        List<string> MonthList=new list<String>{'abr','mai','jun','jul','ago','set','out','nov','dez','jan', 'fev','mar'};
        for(String s:MonthList){
            if(MonthList.indexOf(s)<=8){
                data.add(new CredDonutData(s+'\n'+cYearStr1,0));
            }
            else{
                data.add(new CredDonutData(s+'\n'+cYearStr,0));
            }
        }
        List<string> MonthListinv=new list<String>{'abr','mai','jun','jul','ago','set','out','nov','dez','jan', 'fev','mar'};
        for(String s:MonthListinv){
            if(MonthListinv.indexOf(s)<=8){
                invData.add(new invoiceDonutData(s+'\n'+cYearStr1,0));
            }
            else{
                invData.add(new invoiceDonutData(s+'\n'+cYearStr,0));
            }
        }
        Decimal amtVal;
        Decimal tval=0;
        Decimal amtValinv;
        Decimal tvalinv=0;
        for(AggregateResult so:orderList){
            if(so.get('totalAmt')==null){
                amtVal=0;
            }
            else{
                amtVal=(Decimal)so.get('totalAmt');
            }
            
            tval=tval+amtVal;
            
            if(so.get('fm')==1){
                data.set(0,new CredDonutData('abr'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('abr'));
            }
            else if(so.get('fm')==2){
                data.set(1,new CredDonutData('mai'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('mai'));
            }
            else if(so.get('fm')==3){
                data.set(2,new CredDonutData('jun'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('jun'));
            }
            else if(so.get('fm')==4){
                data.set(3,new CredDonutData('jul'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('jul'));
            }
            else if(so.get('fm')==5){
                data.set(4,new CredDonutData('ago'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('ago'));
            }
            else if(so.get('fm')==6){
                data.set(5,new CredDonutData('set'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('set'));
            }
            else if(so.get('fm')==7){
                data.set(6,new CredDonutData('out'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('out'));
            }
            else if(so.get('fm')==8){
                data.set(7,new CredDonutData('nov'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('nov'));
            }
            else if(so.get('fm')==9){
                data.set(8,new CredDonutData('dez'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('dez'));
            }
            else if(so.get('fm')==10){
                data.set(9,new CredDonutData('jan'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('jan'));
            }
            else if(so.get('fm')==11){
                System.debug('data.get(10)'+data.get(10));
                data.set(10,new CredDonutData('fev'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('fev'));
            }
            else if(so.get('fm')==12){
                data.set(11,new CredDonutData('mar'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('mar'));
            }
        }
        for(AggregateResult so:invoiceList){
            if(so.get('invTotalAmt')==null){
                amtValinv=0;
            }
            else{
                amtValinv=(Decimal)so.get('invTotalAmt');
            }
            
            tvalinv=tvalinv+amtValinv;
            
            if(so.get('fm')==1){
                invData.set(0,new invoiceDonutData('abr'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('abr'));
            }
            else if(so.get('fm')==2){
                invData.set(1,new invoiceDonutData('mai'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('mai'));
            }
            else if(so.get('fm')==3){
                invData.set(2,new invoiceDonutData('jun'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('jun'));
            }
            else if(so.get('fm')==4){
                invData.set(3,new invoiceDonutData('jul'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('jul'));
            }
            else if(so.get('fm')==5){
                invData.set(4,new invoiceDonutData('ago'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('ago'));
            }
            else if(so.get('fm')==6){
                invData.set(5,new invoiceDonutData('set'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('set'));
            }
            else if(so.get('fm')==7){
                invData.set(6,new invoiceDonutData('out'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('out'));
            }
            else if(so.get('fm')==8){
                invData.set(7,new invoiceDonutData('nov'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('nov'));
            }
            else if(so.get('fm')==9){
                invData.set(8,new invoiceDonutData('dez'+'\n'+cYearStr1, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('dez'));
            }
            else if(so.get('fm')==10){
                invData.set(9,new invoiceDonutData('jan'+'\n'+cYearStr, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('jan'));
            }
            else if(so.get('fm')==11){
                invData.set(10,new invoiceDonutData('fev'+'\n'+cYearStr, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('fev'));
            }
            else if(so.get('fm')==12){
                invData.set(11,new invoiceDonutData('mar'+'\n'+cYearStr, amtValinv));
                MonthListinv.remove(MonthListinv.indexOf('mar'));
            }
        }
        
        rw.cateListWrap = data;
        rw.Total=grz_SapIntegration.currencyBrazil(tval.setScale(0));
        rw.invoiceListWrap = invData;
        rw.invTotal=grz_SapIntegration.currencyBrazil(tvalinv.setScale(0));
        wraplist.add(rw);
        return wraplist;
    } 
    public static List<ResultWrapper> getDonDataMexico(String fiscalYearValue){
        Id id = UserInfo.getUserId(); // getting current user info
        List<String> AccId = new List<String>(); 
        List<User> user = [SELECT Id, Username, AccountId, userRole.name, ContactId FROM User where Id =: id];
        String query = 'SELECT SUM(TotalAmount_Argentina__c)totalAmt, CALENDAR_YEAR(createddate)calYear, FISCAL_MONTH(createddate)fm FROM Sales_Order__c where ';
        if(user[0].AccountId != null){
            String accountId = user[0].AccountId;
            query += 'Sold_to_Party__c =:accountId and ';
        }
        String fiscalyear = fiscalYearValue;
        if(fiscalyear == '0'){
            query += 'createddate = THIS_FISCAL_YEAR and ';
        }
        else {
            query += 'createddate = LAST_FISCAL_YEAR and ';
        }
        
        String salesorgcode = System.Label.Grz_MexicoSalesOrgCode;
        query += 'Order_Status__c != null and SalesOrgCode__c = :salesorgcode group by CALENDAR_MONTH(createddate), CALENDAR_YEAR(createddate) , FISCAL_MONTH(createddate)';
        List<AggregateResult> orderList= new List<AggregateResult>();
        for (AggregateResult result : Database.query(query)){
            orderList.add(result);
            System.debug('result==>'+result);
        }
        System.debug('orderList==>'+orderList);
        List<ResultWrapper> wrapList = new List<ResultWrapper>();
        ResultWrapper rw = new ResultWrapper();
        List<CredDonutData> data = new List<CredDonutData>();
        Decimal amtVal;
        Decimal tval=0;
        Integer cYear;
        Integer cYear1;
        if(fiscalyear == '0'){
            cYear =getCurrentFY();
            cYear1 =getCurrentFY()-1;
        }
        else {
            cYear =getCurrentFY()-1;
            cYear1 =getCurrentFY()-2;
        }
        String cYearStr=String.valueOf(cYear);
        String cYearStr1=String.valueOf(cYear1);
        List<string> MonthList=new list<String>{'Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic','Ene', 'Feb','Mar'};
        for(String s:MonthList){
            if(MonthList.indexOf(s)<=8){
                data.add(new CredDonutData(s+'\n'+cYearStr1,0));
            }
            else{
                data.add(new CredDonutData(s+'\n'+cYearStr,0));
            }
        }
        for(AggregateResult so:orderList){
            if(so.get('totalAmt')==null){
                amtVal=0;
            }
            else{
                amtVal=(Decimal)so.get('totalAmt');
            }
            
            tval=tval+amtVal;
            
            if(so.get('fm')==1){
                data.set(0,new CredDonutData('Abr'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Abr'));
            }
            else if(so.get('fm')==2){
                data.set(1,new CredDonutData('May'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('May'));
            }
            else if(so.get('fm')==3){
                data.set(2,new CredDonutData('Jun'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Jun'));
            }
            else if(so.get('fm')==4){
                data.set(3,new CredDonutData('Jul'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Jul'));
            }
            else if(so.get('fm')==5){
                data.set(4,new CredDonutData('Ago'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Ago'));
            }
            else if(so.get('fm')==6){
                data.set(5,new CredDonutData('Sep'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Sep'));
            }
            else if(so.get('fm')==7){
                data.set(6,new CredDonutData('Oct'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Oct'));
            }
            else if(so.get('fm')==8){
                data.set(7,new CredDonutData('Nov'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Nov'));
            }
            else if(so.get('fm')==9){
                data.set(8,new CredDonutData('Dic'+'\n'+cYearStr1, amtVal));
                MonthList.remove(MonthList.indexOf('Dic'));
            }
            else if(so.get('fm')==10){
                data.set(9,new CredDonutData('Ene'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('Ene'));
            }
            else if(so.get('fm')==11){
                System.debug('data.get(10)'+data.get(10));
                data.set(10,new CredDonutData('Feb'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('Feb'));
            }
            else if(so.get('fm')==12){
                data.set(11,new CredDonutData('Mar'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('Mar'));
            }
        }
        rw.cateListWrap = data;
        rw.Total=currencyINDformat(tval);
        wraplist.add(rw);
        system.debug('Data'+wraplist);
        return wraplist;
    }
    public static List<ResultWrapper> getDonDataChile(String fiscalYearValue) {
        Integer currentYear = System.Today().year();
        String startDate = currentYear + '-01-01';
        String LastStartDate = currentYear - 1 + '-01-01';
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        String endDate = currentYear + '-12-31';
        String LastEndDate = currentYear - 1 + '-12-31';
        Id id = UserInfo.getUserId(); // getting current user info
        List<String> AccId = new List<String>(); 
        List<User> user = [SELECT Id, Username, AccountId, userRole.name, ContactId FROM User where Id =: id];
        String query = 'SELECT SUM(TotalAmount_Argentina__c)totalAmt, CALENDAR_YEAR(createddate)calYear,CALENDAR_MONTH(createddate)fm FROM Sales_Order__c where ';
        if(user[0].AccountId != null){
            String accountId = user[0].AccountId;
            query += 'Sold_to_Party__c =:accountId and ';
        }
        String fiscalyear = fiscalYearValue;
        if(fiscalyear == '0'){
            query += ' DAY_ONLY(createddate) >=' + startDate +' and DAY_ONLY(createddate)<=' + endDate;
        }
        else {
            query += ' DAY_ONLY(createddate) >=' + LastStartDate +' and DAY_ONLY(createddate)<=' + LastEndDate;
        }
        List<String> salesorgcode = System.Label.Grz_ChileSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');       
        query += ' and SalesOrgCode__c in:salesorgcode and BrazilSalesOrderStatus__c in: orderSt group by CALENDAR_MONTH(createddate), CALENDAR_YEAR(createddate)';
        List<AggregateResult> orderList= new List<AggregateResult>();
        for (AggregateResult result : Database.query(query)){
            orderList.add(result);
            System.debug('result==>'+result);
        }
        System.debug('orderList==>'+orderList);
        List<ResultWrapper> wrapList = new List<ResultWrapper>();
        ResultWrapper rw = new ResultWrapper();
        List<CredDonutData> data = new List<CredDonutData>();
        Decimal amtVal;
        Decimal tval=0;
        Integer cYear;
        Integer cYear1;
        if(fiscalyear == '0'){
            cYear = currentYear;
        }
        else {
            cYear = currentYear - 1;
        }
        String cYearStr=String.valueOf(cYear);
        List<string> MonthList=new list<String>{'ene','feb','mar','abr','Mayo','jun','jul','ago','sep','oct', 'nov','dic'};
        for(String s:MonthList){
                data.add(new CredDonutData(s+'\n'+cYearStr,0));
        }
        for(AggregateResult so:orderList){
            if(so.get('totalAmt')==null){
                amtVal=0;
            }
            else{
                amtVal=(Decimal)so.get('totalAmt');
            }
            
            tval=tval+amtVal;
            
            if(so.get('fm')==1){
                data.set(0,new CredDonutData('ene'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('ene'));
            }
            else if(so.get('fm')==2){
                data.set(1,new CredDonutData('feb'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('feb'));
            }
            else if(so.get('fm')==3){
                data.set(2,new CredDonutData('mar'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('mar'));
            }
            else if(so.get('fm')==4){
                data.set(3,new CredDonutData('abr'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('abr'));
            }
            else if(so.get('fm')==5){
                data.set(4,new CredDonutData('Mayo'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('Mayo'));
            }
            else if(so.get('fm')==6){
                data.set(5,new CredDonutData('jun'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('jun'));
            }
            else if(so.get('fm')==7){
                data.set(6,new CredDonutData('jul'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('jul'));
            }
            else if(so.get('fm')==8){
                data.set(7,new CredDonutData('ago'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('ago'));
            }
            else if(so.get('fm')==9){
                data.set(8,new CredDonutData('sep'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('sep'));
            }
            else if(so.get('fm')==10){
                data.set(9,new CredDonutData('oct'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('oct'));
            }
            else if(so.get('fm')==11){
                System.debug('data.get(10)'+data.get(10));
                data.set(10,new CredDonutData('nov'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('nov'));
            }
            else if(so.get('fm')==12){
                data.set(11,new CredDonutData('dic'+'\n'+cYearStr, amtVal));
                MonthList.remove(MonthList.indexOf('dic'));
            }
        }
        rw.cateListWrap = data;
        rw.Total=currencyINDformat(tval);
        wraplist.add(rw);
        system.debug('Data'+wraplist);
        return wraplist;
    }
    
    public static integer getCurrentFY() {
        Organization orgInfo = [SELECT FiscalYearStartMonth, UsesStartDateAsFiscalYearName FROM Organization WHERE id=:Userinfo.getOrganizationId()];
        Date today = system.today();
        Integer currentFY;
        if (today.month() >= orgInfo.FiscalYearStartMonth) {
            if (orgInfo.UsesStartDateAsFiscalYearName) {
                currentFY = today.year();
            } else {
                currentFY = today.year() + 1;
            }
        } else {
            if (orgInfo.UsesStartDateAsFiscalYearName) {
                currentFY = today.year() - 1;
            } else {
                currentFY = today.year();
            }
        }
        return currentFY;
    }
        
    // Wrapper class
    public class CredDonutData {
        @AuraEnabled
        public String monthName { get; set; }
        @AuraEnabled
        public Decimal orderAmount { get; set; }
        
        public CredDonutData(String monthName, Decimal orderAmount) {
            this.monthName = monthName;
            this.orderAmount = orderAmount;
        }
    }
    public class invoiceDonutData {
        @AuraEnabled
        public String monthName { get; set; }
        @AuraEnabled
        public Decimal invAmount { get; set; }
        
        public invoiceDonutData(String monthName, Decimal invAmount) {
            this.monthName = monthName;
            this.invAmount = invAmount;
        }
    }
    public class ResultWrapper{
        @AuraEnabled
        public String Total{get;set;}
        @AuraEnabled
        public String invTotal{get;set;}
        @AuraEnabled
        public List<CredDonutData> cateListWrap{get;set;}
        @AuraEnabled
        public List<invoiceDonutData> invoiceListWrap{get;set;}
    }
    
    public static String currencyINDformat(Decimal value){
        Decimal d = value.setScale(2);
        List<String> args = new String[]{'0','number','#,###.0'};
            String indamount = String.format(d.format(), args);
        System.debug('indamount : '+indamount);
        return indamount;
    }
}