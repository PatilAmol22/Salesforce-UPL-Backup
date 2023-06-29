public with sharing class Grz_CaseMexicoFileVFController {
    
    public List<ResultWrapper> vfWrap{get;set;}
    public String imgUrl          {get;set;} //added by Vaishnavi w.r.t Uconnect Mobile App

    public void Grz_CaseListVF() {
        String searchKey = ApexPages.currentPage().getParameters().get('searchKey');
        String OrderByDate = ApexPages.currentPage().getParameters().get('OrderByDate');
        String status = ApexPages.currentPage().getParameters().get('status');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
        if(Test.isRunningTest()){       
            startDate = '2019-04-02';
            endDate = '2030-07-02';
            OrderByDate = 'CreatedDate%20desc';
            status = 'All';
        }
         System.debug('OrderByDate----'+OrderByDate);
         OrderByDate=OrderByDate.replaceAll('%20', ' ');
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mexico_Distributor').getRecordTypeId();        
       
        List<Case> CaseList = new List<Case>();  
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity FROM User where Id =: id];
        List<String> cstrCode = new List<String>();
        /*if(!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }*/
        String accountId = user[0].AccountId;
        //String groupCstr = user[0].Account.Customer_Group__c;
        String profilename = user[0].profile.name;
        Set<Id> accId = new Set<Id>();
        /*if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND ParentId =:accountId]){
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
            }
        }*/
        accId.add(accountId);
       //below URL code added by vaishnavi w.r.t Uconnect Mobile app.
       String sfdcBaseURL = ApexPages.currentPage().getHeaders().get('Referer');
       System.debug('sfdcBaseURL URL: ' + sfdcBaseURL); 
       String baseUrl = sfdcBaseURL?.split('/s/')[0];
       
       if(String.isNotBlank(baseUrl) && baseUrl.containsIgnoreCase('uplpartnerportalstd')){
           imgUrl = '/uplpartnerportalstd/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
       }else{
           imgUrl = '/uplpartnerportal/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';

       }
       System.debug('imgUrl=> '+imgUrl);
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
        String query = 'SELECT CaseNumber, Id, toLabel(Priority), Subject, toLabel(Status), AccountId, CreatedDate, LastModifiedDate, OwnerId,Createdby.Name,Owner.Name, Owner.FirstName, Owner.LastName, toLabel(Type) FROM Case ';
       
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
       
        if(OrderByDate != NULL && OrderByDate != ''){
            
            query += ' order by ' +OrderByDate; 
        }
        else{
            query += ' order by CreatedDate desc '; 
        }
        query += ' LIMIT 2000';
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
        vfWrap = wrapperList;
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
        public List<ResultWrapper> wrapCaseList {get;set;}
    } 

}