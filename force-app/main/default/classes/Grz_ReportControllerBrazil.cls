/**************************************************************************************************
* Name               : Grz_ReportControllerBrazil                                                      
* Description        : Controller class for grz_InvoiceReportBrazil aura Component
* Test Class         : Grz_ReportControllerBrazilTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_ReportControllerBrazil {
    public static List<InvoiceWrap> items         {get;set;}
/**************************************************************************************************
* Name               : getAccountInformation                                                      
* Description        : method will return filter values and account information
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
    @AuraEnabled
    public static ParentResultWrapper getAccountInformation() {
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Set<Id> accId = new Set<Id>();
        //Added below two lines for Main Parent filter. GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        Boolean isMainParent = false;
        Set<String> subGroupData = new Set<String>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId) ORDER BY Name, BillingCity ASC]){// Added Order by in Query, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
            //Query added to get Sub Group distributor data, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
            for (Account ac : [SELECT Id, Sub_Parent_Account__c, Sub_Parent_Account__r.Name, Sub_Parent_Account__r.BillingCity, Sub_Parent_Account__r.SAP_Customer_Code__c
                               FROM Account
                               WHERE Customer_Group__c = :groupCstr AND ParentId = :accountId AND Sub_Parent_Account__c != null
                               ORDER BY Sub_Parent_Account__r.Name ASC]){
                                   isMainParent = true;
                                   subGroupData.add(ac.Sub_Parent_Account__r.SAP_Customer_Code__c + ' - ' + ac.Sub_Parent_Account__r.Name + ' - ' + ac.Sub_Parent_Account__r.BillingCity);
                               }
        }
        accId.add(accountId);
        ParentResultWrapper PRW = new ParentResultWrapper();     
        List<ResultWrapper> FinalRes = new List<ResultWrapper>();         
        ResultWrapper rw = new ResultWrapper();
        if(accId.size() > 1){
            rw.isParentBr = true;
            rw.cstrCode = cstrCode;
        }else{
            rw.isParentBr = false;
        }
        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        if (isMainParent){
            rw.subGroupData = subGroupData;
            rw.isMainParent = true;
        }
        rw.profileName = profilename;
        FinalRes.add(rw);
        PRW.Results = FinalRes; 
        return PRW;
    }
    @AuraEnabled
    public static ParentResultWrapper getCaseTypeData(String startDate, String endDate,String distributor) {
        Decimal caseTotal = 0;
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();        
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
        eachRecord= [Select Id,CaseType__c,Name from  Partner_Portal_Configuration__c where  recordtypeId  =: recordTypeShowId and Name = 'CaseTypePicklistBrazil'];
        List<String> caseTypes = new List<String>();
        if(!eachRecord.isEmpty()){
            caseTypes = eachRecord[0].CaseType__c.split(',');
        }
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }
        accId.add(accountId);
        String query = 'SELECT Type, COUNT(Id) FROM CASE ';
        String filter = '';  
        if(!String.isEmpty(caseRecordTypeId)){
            if(!filter.contains('where'))
                filter +=  ' where RecordTypeId =:caseRecordTypeId';
            else
                filter += ' and RecordTypeId =:caseRecordTypeId';
        }
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where SAP_Code__c =: distributor';
                }
                else
                {
                    filter += ' and SAP_Code__c =: distributor';
                }
            }    
        }
        if(!filter.contains('where')){
            filter += ' where DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }            
        else{
            filter += ' and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where AccountId In: accId GROUP BY Type HAVING Type IN: caseTypes';
            }
            else
            {
                filter += ' and AccountId In: accId GROUP BY Type HAVING Type IN: caseTypes';
            }     
        }
        query += filter;
        List<AggregateResult> CaseList = new List<AggregateResult>();
        CaseList = Database.query(query);
        
        ParentResultWrapper PRW = new ParentResultWrapper();
        List<CaseData> CredData = new List<CaseData>();
        for(AggregateResult s : CaseList){
            caseTotal += (Decimal)s.get('expr0');
            CredData.add(new CaseData((string)s.get('Type'),(Decimal)s.get('expr0')));
        }        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>();         
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = caseTotal;
        if(accId.size() > 1){
            rw.isParentBr = true;
            rw.cstrCode = cstrCode;
        }else{
            rw.isParentBr = false;
        }
        FinalRes.add(rw);
        PRW.Results = FinalRes; 
        return PRW;
    }   
    @AuraEnabled
    public static ParentResultWrapper getCaseStatusData(String startDate, String endDate,String distributor) {
        Decimal caseTotal = 0;
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();        
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;
        List<Partner_Portal_Configuration__c> eachRecord = new  List<Partner_Portal_Configuration__c>();
        eachRecord= [Select Id,CaseType__c,Name from  Partner_Portal_Configuration__c where  recordtypeId  =: recordTypeShowId and Name = 'CaseStatusPicklistBrazil'];
        List<String> caseStatus = new List<String>();
        if(!eachRecord.isEmpty()){
            caseStatus = eachRecord[0].CaseType__c.split(',');
        }
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }
        accId.add(accountId);
        String query = 'SELECT Status, COUNT(Id) FROM CASE ';
        String filter = '';  
        if(!String.isEmpty(caseRecordTypeId)){
            if(!filter.contains('where'))
                filter +=  ' where RecordTypeId =:caseRecordTypeId';
            else
                filter += ' and RecordTypeId =:caseRecordTypeId';
        }
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where SAP_Code__c =: distributor';
                }
                else
                {
                    filter += ' and SAP_Code__c =: distributor';
                }
            }    
        }
        if(!filter.contains('where')){
            filter += ' where DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }            
        else{
            filter += ' and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where AccountId In: accId GROUP BY Status HAVING Status IN: caseStatus';
            }
            else
            {
                filter += ' and AccountId In: accId GROUP BY Status HAVING Status IN: caseStatus';
            }     
        }
        query += filter;
        List<AggregateResult> CaseList = new List<AggregateResult>();
        CaseList = Database.query(query);
        
        ParentResultWrapper PRW = new ParentResultWrapper();
        List<CaseData> CredData = new List<CaseData>();
        for(AggregateResult s : CaseList){
            caseTotal += (Decimal)s.get('expr0');
            CredData.add(new CaseData((string)s.get('Status'),(Decimal)s.get('expr0')));
        }        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>();         
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = caseTotal;
        if(accId.size() > 1){
            rw.isParentBr = true;
            rw.cstrCode = cstrCode;
        }else{
            rw.isParentBr = false;
        }
        FinalRes.add(rw);
        PRW.Results = FinalRes;        
        return PRW;
    }   
    @AuraEnabled
    public static ParentResultWrapper getProductCategoryData(String startDate, String endDate,String distributor) {
        Decimal productTotal = 0;
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }
        accId.add(accountId);
        String query = 'SELECT Product_Category__c , SUM(TotalValueWithoutInterest__c)totalAmt FROM Sales_Order_Line_Item__c';
        String filter = '';  
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where Sale_Order__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }
                else
                {
                    filter += ' and Sale_Order__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }
            }    
        }
        if(!filter.contains('where')){
            filter += ' where DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }            
        else{
            filter += ' and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where Sale_Order__r.Sold_to_Party__c In: accId GROUP BY Product_Category__c ';
            }
            else
            {
                filter += ' and Sale_Order__r.Sold_to_Party__c In: accId GROUP BY Product_Category__c';
            }     
        }
        query += filter;
        List<AggregateResult> productList = new List<AggregateResult>();
        productList = Database.query(query);
        
        ParentResultWrapper PRW = new ParentResultWrapper();
        List<CaseData> CredData = new List<CaseData>();
        for(AggregateResult s : productList){
            if((Decimal)s.get('totalAmt') != 0 && (string)s.get('Product_Category__c') != null){
                productTotal += (Decimal)s.get('totalAmt');
                CredData.add(new CaseData((string)s.get('Product_Category__c'),(Decimal)s.get('totalAmt')));
            }
        }        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>();         
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = productTotal;
        if(accId.size() > 1){
            rw.isParentBr = true;
            rw.cstrCode = cstrCode;
        }else{
            rw.isParentBr = false;
        }
        FinalRes.add(rw);
        PRW.Results = FinalRes;        
        return PRW;
    }
    @AuraEnabled
    public static ParentResultWrapper getInvoiceBrandData(String startDate, String endDate,String distributor) {
        Decimal invoiceTotal = 0;
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }
        accId.add(accountId);
        String query = 'SELECT SKU__r.Brand_Name__c , SUM(Net_Value__c)totalAmt FROM Invoice_Line_Item__c ';
        String filter = ''; 
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where Invoice__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }
                else
                {
                    filter += ' and Invoice__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }
            }    
        }
        if(!filter.contains('where')){
            filter += ' where DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }            
        else{
            filter += ' and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where Invoice__r.Sold_to_Party__c In: accId GROUP BY SKU__r.Brand_Name__c ';
            }
            else
            {
                filter += ' and Invoice__r.Sold_to_Party__c In: accId GROUP BY SKU__r.Brand_Name__c';
            }     
        }
        query += filter;
        List<AggregateResult> invoiceList = new List<AggregateResult>();
        invoiceList = Database.query(query);
        ParentResultWrapper PRW = new ParentResultWrapper();
        List<CaseData> CredData = new List<CaseData>();
        for(AggregateResult s : invoiceList){
            if((Decimal)s.get('totalAmt') != 0 && (string)s.get('Brand_Name__c') != null){
                invoiceTotal += (Decimal)s.get('totalAmt');
                CredData.add(new CaseData((string)s.get('Brand_Name__c'),(Decimal)s.get('totalAmt')));
            }
        }        
        List<ResultWrapper> FinalRes = new List<ResultWrapper>();         
        ResultWrapper rw = new ResultWrapper();
        rw.cateListWrap = CredData;
        rw.Total = invoiceTotal;
        if(accId.size() > 1){
            rw.isParentBr = true;
            rw.cstrCode = cstrCode;
        }else{
            rw.isParentBr = false;
        }
        FinalRes.add(rw);
        PRW.Results = FinalRes;        
        return PRW;
    }
    @AuraEnabled
    public static ParentResultWrapper getInvoiceDetails(String startDate, String endDate,String distributor, Decimal pageNumber,Decimal pageSize, String subGroupId) {
        Integer pSize;
        if(pageSize != null && pageSize != 0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        } 
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Id id = UserInfo.getUserId();
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }
        // Added to get ordet type from Custom Setting GRZ(Nikhil Verma) : APPS-1394
        list<string> statusList= new list<string>();
        List<String> allStatus = Brazil_Portal_Configuration__c.getOrgDefaults().Portal_Sales_Order_Type__c.split('\n'); 
        for(String st : allStatus){
            statusList.add(st.trim());
        }

        accId.add(accountId);
        String countQuery= 'Select Count() from Invoice_Line_Item__c';
        //Query added updated, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        String query = 'Select Id,Brand_Name__c,Invoice__c,Invoice__r.Billing_Doc_Number__c, Invoice__r.Billing_Date__c, Invoice__r.Sold_To_Party__r.Name, Invoice__r.Sold_To_Party__r.SAP_Customer_Code__c, Invoice__r.Sold_To_Party__r.BillingCity, Invoice__r.Sold_To_Party__r.Tax_Number_Br_Portal_Filter__c, Invoice__r.Sold_To_Party__r.Tax_Number_3__c, Invoice__r.Sales_Order__r.Currency_Brazil__c, Net_Value__c, Quantity__c,SKU_Description__c  from Invoice_Line_Item__c ';
        String filter = ' where Invoice__r.Sales_Order__r.Type_of_Order__c IN: statusList'; // Added type of order filter GRZ(Nikhil Verma) : APPS-1394
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where Invoice__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }else{
                    filter += ' and Invoice__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }
            }else{//Else block added, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
                if (subGroupId != null && subGroupId != ''){
                    Set<String> subGroupSapId = new Set<String>();
                    for(Account acc : [SELECT SAP_Code__c FROM Account WHERE Sub_Parent_Account__r.SAP_Code__c = :subGroupId ]){
                        subGroupSapId.add(acc.SAP_Code__c);
                    }
                    subGroupSapId.add(subGroupId);
                    if (!filter.contains('where')){
                        filter += ' where Invoice__r.Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    } else{
                        filter += ' and Invoice__r.Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    }
                } 
            }    
        }
        if(!filter.contains('where')){
            filter += ' where Invoice__r.Billing_Date__c >= '+startDate+' and Invoice__r.Billing_Date__c <= '+endDate;
        }            
        else{
            filter += ' and Invoice__r.Billing_Date__c >= '+startDate+' and Invoice__r.Billing_Date__c <= '+endDate;
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where Invoice__r.Sold_to_Party__c In: accId ';
            }else{
                filter += ' and Invoice__r.Sold_to_Party__c In: accId ';
            }     
        }
        query += filter;
        countQuery += filter;
        if(offset > 2000){
            offset = 2000; 
        }        
        countQuery += ' Limit 2000';
        query += '  ORDER BY Invoice__r.Billing_Date__c desc LIMIT :pSize OFFSET :offset';
        List<Invoice_Line_Item__c> invoiceList = new List<Invoice_Line_Item__c>();
        invoiceList = Database.query(query);
        Integer totalRecords =Database.countQuery(countQuery);
        ParentResultWrapper PRW = new ParentResultWrapper();
        Integer recordEnd = pSize * pNumber;
            PRW.pageSize = pSize;
            PRW.pageNumber = pNumber;
            PRW.recordStart = offset + 1;
            PRW.totalRecords = totalRecords;
            PRW.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords; 
        List<InvoiceWrap> ListInvoiceWrap = new List<InvoiceWrap>();
        for(Invoice_Line_Item__c iv : invoiceList){
            InvoiceWrap ivWrap = new InvoiceWrap();
            ivWrap.ivId = iv.Invoice__c;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
            ivWrap.brandName = iv.Brand_Name__c != null ? iv.Brand_Name__c : '-'; // For New Column GRZ(Nikhil Verma) : APPS-1394
            if(iv.Invoice__r.Billing_Doc_Number__c != null){
                ivWrap.billingDocNumber = iv.Invoice__r.Billing_Doc_Number__c;
            }
            if(iv.Invoice__r.Billing_Date__c != null){
                ivWrap.billingDate = grz_SapIntegration.FormattedDateBrazil(iv.Invoice__r.Billing_Date__c);
            }
            ivWrap.distributor = iv.Invoice__r.Sold_To_Party__r.SAP_Customer_Code__c + ' - ' + iv.Invoice__r.Sold_To_Party__r.Name + ' - ' + iv.Invoice__r.Sold_To_Party__r.BillingCity;
            ivWrap.customerTaxNumber = iv.Invoice__r.Sold_To_Party__r.Tax_Number_Br_Portal_Filter__c;
            ivWrap.gstNumber = iv.Invoice__r.Sold_To_Party__r.Tax_Number_3__c;
            if(iv.Invoice__r.Sales_Order__r.Currency_Brazil__c != null){
                if(iv.Invoice__r.Sales_Order__r.Currency_Brazil__c == 'Billing BRL / Payment BRL'){
                    ivWrap.crncy = 'Real – BRL';
                }else if(iv.Invoice__r.Sales_Order__r.Currency_Brazil__c == 'Billing USD / Payment BRL'){
                    ivWrap.crncy = 'Dólar – USD';
                }else if(iv.Invoice__r.Sales_Order__r.Currency_Brazil__c == 'Billing USD / Payment USD'){
                    ivWrap.crncy = 'Dólar – USD';
                }
            }
            if(iv.Quantity__c != null){
                ivWrap.quantity = String.valueOf(iv.Quantity__c.setScale(0));
            }
            if(iv.Net_Value__c != null){
                ivWrap.totalValue = String.valueOf(iv.Net_Value__c.setScale(0));
            }
            ivWrap.product = iv.SKU_Description__c;
            ListInvoiceWrap.add(ivWrap);
        }        
        PRW.invoiceData = ListInvoiceWrap;        
        return PRW;
    }
    
    /**************************************************************************************************
    * Name               : getSalesOrderLineItemDetails                                                      
    * Description        : method will return sales order line item data
    * Created By         : Nikhil Verma (Grazitti)                                                                       
    * JIRA               : APPS-1394                                                                    
    **************************************************************************************************/
    @AuraEnabled
    public static ParentResultWrapper getSalesOrderLineItemDetails(String startDate, String endDate,String distributor, Decimal pageNumber,Decimal pageSize, String subGroupId) {
        Integer pSize;
        if(pageSize != null && pageSize != 0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        } 
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Id id = UserInfo.getUserId();
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }
        list<string> statusList= new list<string>();
        List<String> allStatus = Brazil_Portal_Configuration__c.getOrgDefaults().Portal_Sales_Order_Type__c.split('\n'); 
        for(String st : allStatus){
            statusList.add(st.trim());
        }
        accId.add(accountId);
        String countQuery= 'Select Count() from Sales_Order_Line_Item__c';
        string query=' Select Id,Quantity__c,TotalValueWithoutInterest__c,SKU_Description__c,Sale_Order__r.SalesOrderNumber_Brazil__c, Sale_Order__r.Invoice_Status__c,Sale_Order__r.Sold_To_Party__r.SAP_Code__c,Sale_Order__r.Sold_To_Party__r.Search_Terms_1__c, Sale_Order__r.CreatedDate,Sale_Order__r.Currency_Brazil__c,Sale_Order__r.Brazil_City__c,Sale_Order__r.Sold_To_Party__r.Name,Sale_Order__r.Total_Value_Brazil__c,Name,Item_Status__c,Sale_Order__r.Type_of_Order__c,Sale_Order__r.BrazilSalesOrderStatus__c,Sale_Order__r.Name,Sale_Order__r.CreatedBy.Name from Sales_Order_Line_Item__c  ';
        String filter = ' where Sale_Order__r.Type_of_Order__c IN: statusList';
        if(!String.isEmpty(distributor)){
            if(distributor != 'All'){
                if(!filter.contains('where')){
                    filter +=  ' where Sale_Order__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }else{
                    filter += ' and  Sale_Order__r.Sold_to_Party__r.SAP_Code__c =: distributor';
                }
            }else{
                if (subGroupId != null && subGroupId != ''){
                    Set<String> subGroupSapId = new Set<String>();
                    for(Account acc : [SELECT SAP_Code__c FROM Account WHERE Sub_Parent_Account__r.SAP_Code__c = :subGroupId ]){
                        subGroupSapId.add(acc.SAP_Code__c);
                    }
                    subGroupSapId.add(subGroupId);
                    if (!filter.contains('where')){
                        filter += ' where  Sale_Order__r.Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    } else{
                        filter += ' and Sale_Order__r.Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    }
                } 
            }    
        }
        if(!filter.contains('where')){
            filter += ' where DAY_ONLY(Sale_Order__r.CreatedDate) >= '+ startDate +' and DAY_ONLY(Sale_Order__r.CreatedDate) <= '+ endDate;
        }            
        else{
            filter += ' and  DAY_ONLY(Sale_Order__r.CreatedDate) >= '+ startDate +' and DAY_ONLY(Sale_Order__r.CreatedDate) <= '+ endDate;
        }
         if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where Sale_Order__r.Sold_to_Party__c In: accId ';
            }else{
                filter += ' and Sale_Order__r.Sold_to_Party__c In: accId ';
            }     
        }
        query += filter;
        countQuery += filter;
        if(offset > 2000){
            offset = 2000; 
        }        
        countQuery += ' Limit 2000';
        query += '  ORDER BY  Sale_Order__r.CreatedDate desc LIMIT :pSize OFFSET :offset';
        List<Sales_Order_Line_Item__c> lineItemList = new List<Sales_Order_Line_Item__c>();
        lineItemList = Database.query(query);
        Integer totalRecords =Database.countQuery(countQuery);
        ParentResultWrapper PRW = new ParentResultWrapper();
        Integer recordEnd = pSize * pNumber;
        PRW.pageSize = pSize;
        PRW.pageNumber = pNumber;
        PRW.recordStart = offset + 1;
        PRW.totalRecords = totalRecords;
        PRW.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords; 
        List<SalesOrderLineItemWrap> SalesLineItemWrapList = new List<SalesOrderLineItemWrap>();
        for(Sales_Order_Line_Item__c iv : lineItemList){
            SalesOrderLineItemWrap ivWrap = new SalesOrderLineItemWrap();
            String name = iv.Sale_Order__r.CreatedBy.Name.toLowerCase();
            String result = '';
            if (name != null && name != ''){
                  for (String iter : name.split('[ ]+')){
                    if (iter != null && iter != ''){
                        if (iter.length() > 1){
                            result += iter.substring(0, 1).toUpperCase() + iter.substring(1, iter.length()) + ' ';
                        } else{
                            result += iter.substring(0, 1).toUpperCase() + ' ';
                        }
                    }
                }
            }
            ivWrap.salesOrderName = iv.Sale_Order__r.SalesOrderNumber_Brazil__c;
            ivWrap.soId = iv.Sale_Order__c;
             if (iv.Sale_Order__r.Invoice_Status__c == 'Pedido em Análise' || iv.Sale_Order__r.Invoice_Status__c == 'Crédito Bloqueado' || iv.Sale_Order__r.Invoice_Status__c == 'Crédito Liberado'){
                 ivWrap.salesOrderStatus = 'Pedido em Processamento';
            } else if (iv.Sale_Order__r.Invoice_Status__c == 'Faturado' || iv.Sale_Order__r.Invoice_Status__c == 'Faturado Parcial'){
                ivWrap.salesOrderStatus = 'Pedido Faturado';
            } else if (iv.Sale_Order__r.Invoice_Status__c == null){
                ivWrap.salesOrderStatus = 'Pedido em Processamento';
            } else{
                ivWrap.salesOrderStatus = iv.Sale_Order__r.Invoice_Status__c;
            }
            ivWrap.salesOrderLineItemStatus = iv.Item_Status__c;
            if(iv.Sale_Order__r.CreatedDate != null){
                ivWrap.salesOrderCreatedDate = grz_SapIntegration.FormattedDateBrazil(iv.Sale_Order__r.CreatedDate);
            }
            ivWrap.typeOfOrder = iv.Sale_Order__r.Type_of_Order__c;
            ivWrap.salesOrderCTC = result;
            ivWrap.customer =iv.Sale_Order__r.Sold_To_Party__r.Name; 
            ivWrap.totalVolume =iv.Quantity__c;
            ivWrap.product = iv.SKU_Description__c;
            ivWrap.city = iv.Sale_Order__r.Brazil_City__c;
            ivWrap.lineItemGroup = iv.Sale_Order__r.Sold_To_Party__r.Search_Terms_1__c;
            if(iv.Sale_Order__r.Currency_Brazil__c != null){
                if(iv.Sale_Order__r.Currency_Brazil__c == 'Billing BRL / Payment BRL'){
                    ivWrap.currncy = 'Real – BRL';
                }else if(iv.Sale_Order__r.Currency_Brazil__c == 'Billing USD / Payment BRL'){
                    ivWrap.currncy = 'Dólar – USD';
                }else if(iv.Sale_Order__r.Currency_Brazil__c == 'Billing USD / Payment USD'){
                    ivWrap.currncy = 'Dólar – USD';
                }
            }
            SalesLineItemWrapList.add(ivWrap);
        }       
        PRW.salesOrderLineItemList = SalesLineItemWrapList; 
        return PRW;
    }

    //Method added for get data for VF page, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
    public void getDataForVF(){
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
        String subGroupId = ApexPages.currentPage().getParameters().get('subGroupId');
        ParentResultWrapper wrapData = getInvoiceDetails(startDate, endDate, distributor, 1,2000, subGroupId);  
        items = wrapData.invoiceData;
    }
    
    public class InvoiceWrap {
        @AuraEnabled public Id ivId {get;set;}
        @AuraEnabled public String brandName {get;set;}
        @AuraEnabled public String billingDocNumber {get;set;}
        @AuraEnabled public String billingDate {get;set;}
        @AuraEnabled public String distributor {get;set;}
        @AuraEnabled public String customerTaxNumber {get;set;}
        @AuraEnabled public String gstNumber {get;set;}
        @AuraEnabled public String crncy {get;set;}
        @AuraEnabled public String quantity {get;set;}
        @AuraEnabled public String totalValue {get;set;}
        @AuraEnabled public String product {get;set;}
    }
    public class SalesOrderLineItemWrap {
        @AuraEnabled public Id soId {get;set;}
        @AuraEnabled public String salesOrderName {get;set;}
        @AuraEnabled public String salesOrderStatus {get;set;}
        @AuraEnabled public String salesOrderLineItemStatus {get;set;}
        @AuraEnabled public String typeOfOrder {get;set;}
        @AuraEnabled public String salesOrderCreatedDate {get;set;}
        @AuraEnabled public String salesOrderCTC {get;set;}
        @AuraEnabled public String customer {get;set;}
        @AuraEnabled public String lineItemGroup {get;set;}
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String currncy {get;set;}
        @AuraEnabled public String product {get;set;}
        @AuraEnabled public decimal totalVolume {get;set;}
    }
    
    public class Grz_CaseSummaryWrapper {
        @AuraEnabled public List<CaseData> CredDonut{get;set;}
        @AuraEnabled public List<ResultWrapper> Result{get;set;}
    }
    public class CaseData {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Decimal value {get; set;}
        public CaseData(String name, Decimal value) {
            this.name = name;
            this.value = value;
        }
    }
    public class ResultWrapper{
        @AuraEnabled public Decimal Total{get;set;}
        @AuraEnabled public Boolean isParentBr{get;set;} 
        @AuraEnabled public String profileName{get;set;} 
        @AuraEnabled public List<String> cstrCode{get;set;} 
        @AuraEnabled public list<CaseData> cateListWrap{get;set;}
        @AuraEnabled public Boolean isMainParent{ get; set; }
        @AuraEnabled public Set<String> subGroupData{ get; set; }  
    }
    public class ParentResultWrapper{
        @AuraEnabled public List<SalesOrderLineItemWrap> salesOrderLineItemList{get;set;}
        @AuraEnabled public List<ResultWrapper> Results{get;set;}
        @AuraEnabled public List<InvoiceWrap> invoiceData{get;set;}
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer pageNumber {get;set;}
        @AuraEnabled public Integer totalRecords {get;set;}
        @AuraEnabled public Integer recordStart {get;set;}
        @AuraEnabled public Integer recordEnd {get;set;}
    }
}