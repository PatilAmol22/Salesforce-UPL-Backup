/**************************************************************************************************
* Name               : grz_CaseListClass                                                      
* Description        : Controller class for grz_CaseListCmp LWC Component
* Test Class         : grz_CaseListClassTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/ 
public with sharing class grz_CaseListClass {
    public List<ResultWrapper> vfWrap{get;set;}
    @AuraEnabled(cacheable=true)
    public static FinalDataWrapper getCaseListAll(String language, String searchKey , String OrderByDate,String startDate, String endDate,String status, Decimal pageNumber, Decimal pageSize, String distributor, String subGroupId){
        FinalDataWrapper finalObj =  new FinalDataWrapper();
        if(language == 'pt-BR'){
            finalObj = grz_CaseListClass.getCaseListBrazil(searchKey,OrderByDate,startDate,endDate,status,pageNumber,pageSize,distributor,subGroupId);//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        }
        else if(language == 'es-MX'){
            finalObj = grz_CaseListClass.getCaseListMexico(searchKey, OrderByDate, startDate, endDate, status, pageNumber, pageSize, distributor);
        }
        else{
            finalObj = grz_CaseListClass.getCaseList(searchKey,OrderByDate,status,pageNumber,pageSize);
        }
        return finalObj;
    }
    
    public void getCaseListVF(){
       String searchKey1 = ApexPages.currentPage().getParameters().get('searchKey');
        String OrderByDate1;
         String status1;
        if(Test.isRunningTest()){
              OrderByDate1 = 'CreatedDate%20desc';
              status1 = 'All';
        }else{
             OrderByDate1 = ApexPages.currentPage().getParameters().get('OrderByDate');
             status1 = ApexPages.currentPage().getParameters().get('status');
        }
        System.debug('searchKey1'+searchKey1);
        System.debug('OrderByDate1'+OrderByDate1);
        System.debug('status1'+status1); 
        
        OrderByDate1=OrderByDate1.replaceAll('%20', ' ');
        
        Id caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        
        List<Case> CaseList = new List<Case>();  
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String profilename = user[0].profile.name;
        String query = 'SELECT CaseNumber, Id, Priority, Subject, Status, AccountId, CreatedDate,ClosedDate, LastModifiedDate, OwnerId, Owner.Name, Owner.FirstName, Owner.LastName, Type FROM Case ';
        String filter = '';  
        if(!String.isEmpty(caseRecordTypeId)){
                    //Sub_Category__c condition added for showing only case created from community (Sumit Kumar) Jira Ticket No. RITM0427885 modified on 03-10-2022
            if(!filter.contains('where'))
                filter +=  ' where RecordTypeId =:caseRecordTypeId and CaseOwner__c != Null and Sub_Category__c = Null';
            else
                filter += ' and RecordTypeId =:caseRecordTypeId and CaseOwner__c != Null and and Sub_Category__c = Null';
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where'))
                filter +=  ' where AccountId =: accountId';
            else
                filter += ' and AccountId =: accountId';
        }
        
        
        if (!string.IsBlank(searchKey1)) {
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (CaseNumber like \'%' +searchKey1+ '%\')' ;
        }  
        if (!status1.equals('undefined')) {
            if(status1 != 'All'){
                
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Status like \'%' +status1+ '%\'';
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
        
        query += filter;
        if(!OrderByDate1.equals('undefined')){
            
            query += ' order by ' +OrderByDate1; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        }
        
        System.debug('query'+query);
        CaseList = Database.query(query);  
        FinalDataWrapper finalObj =  new FinalDataWrapper();
        List<ResultWrapper> wrapperList = new List<ResultWrapper>();
        
        for(Case caseobj :CaseList){
            ResultWrapper resultwrap = new ResultWrapper();
            resultwrap.Id = caseobj.Id;
            resultwrap.casenumber = caseobj.CaseNumber;
            resultwrap.subject = caseobj.Subject;
            resultwrap.priority = caseobj.Priority;            
            resultwrap.status = caseobj.Status;
            Datetime dt = caseobj.CreatedDate;
            Datetime dt2 = caseobj.LastModifiedDate;
            Datetime dt3;
            if(caseobj.ClosedDate != null){
                dt3 = caseobj.ClosedDate;
            }
            resultwrap.createddate = grz_SapIntegration.FormattedDate(dt);
            resultwrap.lastmodifieddate = grz_SapIntegration.FormattedDate(dt2);
            String name = caseobj.Owner.LastName;
            if(null != caseobj.Owner.FirstName){
                name = caseobj.Owner.FirstName+' '+name;
            }
            resultwrap.ownername = name;
            if(dt3 != null){
                resultwrap.closeDate =  grz_SapIntegration.FormattedDate(dt3);
            }
            resultwrap.casetype = caseobj.Type;
            wrapperList.add(resultwrap);
        }
        vfWrap = wrapperList;
        
           
    }
    @AuraEnabled(cacheable=true)
    public static FinalDataWrapper getCaseList(String searchKey , String OrderByDate, String status, Decimal pageNumber, Decimal pageSize){
        
        Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        } 
        
        Id caseRecordTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        List<Case> CaseList = new List<Case>();  
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String profilename = user[0].profile.name;
        String countQuery= 'Select Count() from Case';
        String query = 'SELECT CaseNumber, Id, Priority, Subject, Status, AccountId, CreatedDate,ClosedDate, LastModifiedDate,CaseOwner__c, OwnerId, Owner.Name, Owner.FirstName, Owner.LastName, Type FROM Case ';
        String filter = '';  
        if(!String.isEmpty(caseRecordTypeId)){
                                //Sub_Category__c condition added for showing only case created from community (Sumit Kumar) Jira Ticket No. RITM0427885 modified on 03-10-2022
            if(!filter.contains('where'))
                filter +=  ' where RecordTypeId =:caseRecordTypeId and CaseOwner__c != Null and Sub_Category__c = Null';
            else
                filter += ' and RecordTypeId =:caseRecordTypeId and CaseOwner__c != Null and Sub_Category__c = Null';
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where'))
                filter +=  ' where AccountId =: accountId';
            else
                filter += ' and AccountId =: accountId';
        }
        
        
        if (!string.IsBlank(searchKey)) {
            
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (CaseNumber like \'%' +searchKey+ '%\')' ;
        }  
        if (!string.IsBlank(status)) {
            if(status != 'All'){
                
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Status like \'%' +status+ '%\'';
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
        
        query += filter;
        countQuery += filter;
        if(OrderByDate != NULL && OrderByDate != ''){
            
            query += ' order by ' +OrderByDate; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        }
        if(offset > 2000){
            offset = 2000; 
        }        
        countQuery += ' Limit 2000';
        query += ' LIMIT :pSize OFFSET :offset';
        CaseList = Database.query(query);  
        FinalDataWrapper finalObj =  new FinalDataWrapper();
        List<ResultWrapper> wrapperList = new List<ResultWrapper>();
        Integer totalRecords =Database.countQuery(countQuery);
        Integer recordEnd = pSize * pNumber;
        finalObj.pageSize = pSize;
        finalObj.pageNumber = pNumber;
        finalObj.recordStart = offset + 1;
        finalObj.totalRecords = totalRecords;
        finalObj.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        for(Case caseobj :CaseList){
            ResultWrapper resultwrap = new ResultWrapper();
            resultwrap.Id = caseobj.Id;
            resultwrap.casenumber = caseobj.CaseNumber;
            resultwrap.subject = caseobj.Subject;
            resultwrap.priority = caseobj.Priority;            
            resultwrap.status = caseobj.Status;
            Datetime dt = caseobj.CreatedDate;
            Datetime dt2 = caseobj.LastModifiedDate;
            Datetime dt3;
            if(caseobj.ClosedDate != null){
                dt3 = caseobj.ClosedDate;
            }
            resultwrap.createddate = grz_SapIntegration.FormattedDate(dt);
            resultwrap.lastmodifieddate = grz_SapIntegration.FormattedDate(dt2);
            String name = caseobj.Owner.LastName;
            if(null != caseobj.Owner.FirstName){
                name = caseobj.Owner.FirstName+' '+name;
            }
            resultwrap.ownername = name;
            if(dt3 != null){
                resultwrap.closeDate =  grz_SapIntegration.FormattedDate(dt3);
            }
            resultwrap.casetype = caseobj.Type;
            wrapperList.add(resultwrap);
        }
        finalObj.wrapCaseList = wrapperList;
        
        return finalObj;
    }
/**************************************************************************************************
* Name               : getCaseListBrazil                                                      
* Description        : Medthod will return Case List are be selected filter by end user
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static FinalDataWrapper getCaseListBrazil(String searchKey, String OrderByDate,String startDate, String endDate, String status, Decimal pageNumber, Decimal pageSize,String distributor, String subGroupId){
        Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        }         
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Brazil_Case_Process').getRecordTypeId();        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        List<Case> CaseList = new List<Case>();  
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        List<String> cstrCode = new List<String>();
        if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        Set<Id> accId = new Set<Id>();
        //Below 2 lines added GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        Boolean isMainParent = false;
        Set<String> subGroupData = new Set<String>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId) ORDER BY Name, BillingCity ASC]){//Added order by, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
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
        String countQuery= 'Select Count() from Case';
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel,IsClosed From CaseStatus Where MasterLabel not in ('Draft')];
        List<String> caseStatusIsclosed = new List<String>();
        List<String> caseStatusIsOpen = new List<String>();
        for(CaseStatus cs : caseStatusList){
            if(cs.IsClosed){
                caseStatusIsclosed.add(cs.MasterLabel);
            }
            else{
                caseStatusIsOpen.add(cs.MasterLabel);
            }                
        }
        String query = 'SELECT CaseNumber, Id, Priority, Subject, Status, AccountId, CreatedDate, LastModifiedDate, OwnerId, Owner.Name, Owner.FirstName, Owner.LastName, Type FROM Case ';
        
        String filter = '';  
        if(!String.isEmpty(caseRecordTypeId)){
            if(!filter.contains('where'))
                filter +=  ' where RecordTypeId =:caseRecordTypeId';
            else
                filter += ' and RecordTypeId =:caseRecordTypeId';
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where AccountId In: accId';
            }
            else
            {
                filter += ' and AccountId In: accId';
            }     
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
            }else{// Else block added GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if (subGroupId != null && subGroupId != ''){
                    Set<String> subGroupSapId = new Set<String>();
                    for(Account acc : [SELECT SAP_Code__c FROM Account WHERE Sub_Parent_Account__r.SAP_Code__c = :subGroupId ]){
                        subGroupSapId.add(acc.SAP_Code__c);
                    }
                    subGroupSapId.add(subGroupId);
                    if (!filter.contains('where')){
                        filter += ' where SAP_Code__c IN: subGroupSapId';
                    } else{
                        filter += ' and SAP_Code__c IN: subGroupSapId';
                    }
                } 
            }    
        }
        if (!string.IsBlank(searchKey)) {
            
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (CaseNumber like \'%' +searchKey+ '%\')' ;
        }  
        if (!string.IsBlank(status)) {
            if(status != 'All'){
                if(status == 'New'){
                    
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' Status IN : caseStatusIsOpen';
                }else if(status == 'Closed'){
                    
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' Status IN : caseStatusIsclosed';
                }
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
        if(OrderByDate != NULL && OrderByDate != ''){
            
            query += ' order by ' +OrderByDate; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        }
        if(offset > 2000){
            offset = 2000; 
        }        
        countQuery += ' Limit 2000';
        query += ' LIMIT :pSize OFFSET :offset';
        CaseList = Database.query(query);  
        FinalDataWrapper finalObj =  new FinalDataWrapper();
        List<ResultWrapper> wrapperList = new List<ResultWrapper>();
        Integer totalRecords =Database.countQuery(countQuery);
        Integer recordEnd = pSize * pNumber;
        if(accId.size() > 1){
            finalObj.isParentBr = true;
            finalObj.cstrCode = cstrCode;
        }else{
            finalObj.isParentBr = false;
        }
        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        if (isMainParent){
            finalObj.subGroupData = subGroupData;
            finalObj.isMainParent = true;
          }
        finalObj.pageSize = pSize;
        finalObj.pageNumber = pNumber;
        finalObj.recordStart = offset + 1;
        finalObj.totalRecords = totalRecords;
        finalObj.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        
        
        for(Case caseobj :CaseList){
            ResultWrapper resultwrap = new ResultWrapper();
            resultwrap.Id = caseobj.Id;
            resultwrap.casenumber = caseobj.CaseNumber;
            resultwrap.subject = caseobj.Subject;
            resultwrap.priority = caseobj.Priority;            
            resultwrap.status = caseobj.Status;
            Datetime dt = caseobj.CreatedDate;
            Datetime dt2 = caseobj.LastModifiedDate;
            resultwrap.createddate = grz_SapIntegration.FormattedDateBrazil(dt);
            resultwrap.lastmodifieddate = grz_SapIntegration.FormattedDateBrazil(dt2);
            String name = caseobj.Owner.LastName;	
            if(null != caseobj.Owner.FirstName){	
                name = caseobj.Owner.FirstName+' '+name;	
            }	
            resultwrap.ownername = name;
            resultwrap.casetype = caseobj.Type;
            wrapperList.add(resultwrap);
        }
        finalObj.wrapCaseList = wrapperList;
        System.debug('finalObj : '+finalObj);
        return finalObj;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static FinalDataWrapper getCaseListMexico(String searchKey, String OrderByDate,String startDate, String endDate, String status, Decimal pageNumber, Decimal pageSize,String distributor){
        System.debug('status : '+status);
        Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        }         
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();        
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        List<Case> CaseList = new List<Case>();  
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        List<String> cstrCode = new List<String>();
        /*if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }*/
        String accountId = user[0].AccountId;
        system.debug('accountId Mexico : '+accountId);
        //String groupCstr = user[0].Account.Customer_Group__c;
        //String profilename = user[0].profile.name;
        Set<Id> accId = new Set<Id>();
        /*if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND ParentId =:accountId]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }*/
        accId.add(accountId);
        String countQuery= 'Select Count() from Case';
        List<CaseStatus> caseStatusList = [Select Id, MasterLabel,IsClosed From CaseStatus Where MasterLabel not in ('Draft')];
        List<String> caseStatusIsclosed = new List<String>();
        List<String> caseStatusIsOpen = new List<String>();
        for(CaseStatus cs : caseStatusList){
            if(cs.IsClosed){
                caseStatusIsclosed.add(cs.MasterLabel);
            }
            else{
                caseStatusIsOpen.add(cs.MasterLabel);
            }                
        }
        String query = 'SELECT CaseNumber, Id, Priority, Subject, toLabel(Status), AccountId, CreatedDate,Createdby.Name, LastModifiedDate, OwnerId, Owner.Name, Owner.FirstName, Owner.LastName, toLabel(Type) FROM Case ';
        
        String filter = '';  
        if(!String.isEmpty(caseRecordTypeId)){
            if(!filter.contains('where'))
                filter +=  ' where RecordTypeId =:caseRecordTypeId';
            else
                filter += ' and RecordTypeId =:caseRecordTypeId';
        }
        if(!String.isEmpty(accountId)){
            if(!filter.contains('where')){
                filter +=  ' where AccountId In: accId';
            }
            else
            {
                filter += ' and AccountId In: accId';
            }     
        }

        if (!string.IsBlank(searchKey)) {
            
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (CaseNumber like \'%' +searchKey+ '%\')' ;
        }  
        if (!string.IsBlank(status)) {
            if(status != 'All'){
                
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Status like \'%' +status+ '%\'';
                /*if(status == 'New'){                   
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' Status IN : caseStatusIsOpen';
                }else if(status == 'Closed'){                    
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' Status IN : caseStatusIsclosed';
                }*/
            }
        } 
        
        /*if(!filter.contains('where')){
            filter += ' where createddate = THIS_FISCAL_YEAR';
          }            
		  else{
			filter += ' and createddate = THIS_FISCAL_YEAR';
		 }*/
        
        if(!filter.contains('where')){
            filter += ' where DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }            
        else{
            filter += ' and DAY_ONLY(createddate) >='+startDate+' and DAY_ONLY(createddate)<='+endDate;
        }
        
        query += filter;
        countQuery += filter;
        if(OrderByDate != NULL && OrderByDate != ''){            
            query += ' order by ' +OrderByDate; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        }
        if(offset > 2000){
            offset = 2000; 
        }        
        countQuery += ' Limit 2000';
        query += ' LIMIT :pSize OFFSET :offset';
        CaseList = Database.query(query);  
        FinalDataWrapper finalObj =  new FinalDataWrapper();
        List<ResultWrapper> wrapperList = new List<ResultWrapper>();
        Integer totalRecords =Database.countQuery(countQuery);
        Integer recordEnd = pSize * pNumber;
        finalObj.isParentBr = false;
        finalObj.pageSize = pSize;
        finalObj.pageNumber = pNumber;
        finalObj.recordStart = offset + 1;
        finalObj.totalRecords = totalRecords;
        finalObj.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        
        
        for(Case caseobj :CaseList){
            ResultWrapper resultwrap = new ResultWrapper();
            resultwrap.Id = caseobj.Id;
            resultwrap.casenumber = caseobj.CaseNumber;
            resultwrap.subject = caseobj.Subject;
            resultwrap.priority = caseobj.Priority;            
            resultwrap.status = caseobj.Status;
            Datetime dt = caseobj.CreatedDate;
            Datetime dt2 = caseobj.LastModifiedDate;
            resultwrap.createddate = grz_SapIntegration.FormattedDateMexico(dt);
            resultwrap.lastmodifieddate = grz_SapIntegration.FormattedDateMexico(dt2);
            /*String name = caseobj.Owner.LastName;	
            if(null != caseobj.Owner.FirstName){	
                name = caseobj.Owner.FirstName+' '+name;	
            }*/	
            resultwrap.ownername = caseobj.Createdby.Name;
            resultwrap.casetype = caseobj.Type;
            wrapperList.add(resultwrap);
        }
        finalObj.wrapCaseList = wrapperList;
        System.debug('finalObj : '+finalObj);
        return finalObj;
    }
    
    public class ResultWrapper{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String casenumber{get;set;}
        @AuraEnabled
        public String subject{get;set;}
        @AuraEnabled
        public String priority{get;set;}
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public String ownername{get;set;} 
        @AuraEnabled
        public String createddate{get;set;} 
        @AuraEnabled
        public String lastmodifieddate{get;set;} 
        @AuraEnabled
        public String casetype{get;set;} 
        @AuraEnabled
        public String closeDate{get;set;} 
        
    }
    
    public class FinalDataWrapper {
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
        public Boolean isParentBr{get;set;} 
        @AuraEnabled
        public List<String> cstrCode{get;set;} 
        @AuraEnabled
        public List<ResultWrapper> wrapCaseList {get;set;}
        @AuraEnabled
        public Boolean isMainParent{ get; set; }
        @AuraEnabled
        public Set<String> subGroupData{ get; set; }
    } 
}