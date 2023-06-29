public class CaseDistributorFeedback {
    Public String CaseID{get;set;}
    public List<Case> CaseList{get;set;}
    public String feedbackselect{get;set;}
    //public String UserName{get;set;}
    
    public list<wrapperCase> wrapaccountList{ get; set;}
    public List<SelectOption> FeedbackDistributor{get;set;}
    public CaseDistributorFeedback(){
        wrapaccountList=new List<wrapperCase>();
        FeedbackDistributor=new List<SelectOption>();
        CaseList=new List<Case>();
        
        
        CaseID = ApexPages.currentPage().getParameters().get('id');
        System.debug('CaseID:'+CaseID);
        CaseList=[Select Id , Non_SFDC_User__r.name, Non_SFDC_User__r.Email__c,status,
                  Type,Account.Name,CaseNumber,Owner.name,Origin,Priority,Subject,Description,SendEmailNonsfdcuser__c,
                  Zonal_Head__c,Zonal_Head__r.name,Regional_Manager_1__r.name,Zonal_Head_1__r.name,SAP_Code__c,Case_Assign_By__c,
                  Salesforce_Non_User_Comment__c,Feedback__c,Distributor_Comment__c,Email_sent_to_Distributor__c,CheckBox__c From Case where Id =: caseID];
        //  UserName=UserInfo.getName();
        
        FeedbackDistributor.add(new SelectOption('--None--','--None--')); 
        Schema.DescribeFieldResult statusFieldDescription = case.Feedback__c.getDescribe();
        System.debug(statusFieldDescription.getPicklistValues());
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues()){
            FeedbackDistributor.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel())); 
        }
        
        System.debug(''+FeedbackDistributor);
        
        wrapperCase Wrap =new wrapperCase();
        
        for(Case CaseObj :CaseList){
            wrap.Comment= CaseObj.Salesforce_Non_User_Comment__c ;
            wrap.AccountId= CaseObj.Account.name;
            wrap.CaseNumber= CaseObj.CaseNumber;
            wrap.NonSFDCUser= CaseObj.Non_SFDC_User__r.name;
            wrap.zonalHead= CaseObj.Zonal_Head__r.name;
            wrap.Origin=CaseObj.Origin;
            wrap.Type=CaseObj.Type;
            wrap.OwnerId=CaseObj.Owner.name;
            wrap.caseId = caseID;
            wrap.SapCode= CaseObj.SAP_Code__c;
            wrap.Priority=CaseObj.Priority;
            wrap.subject= CaseObj.Subject;
            wrap.Description=CaseObj.Description;
            wrap.checkEmail = CaseObj.SendEmailNonsfdcuser__c;
            wrap.status=CaseObj.status;
            wrap.CheckDist=CaseObj.Email_sent_to_Distributor__c;
            wrap.CheckBox=true;
            wrap.DistComment=CaseObj.Distributor_Comment__c;
            wrap.CaseAssign = CaseObj.Case_Assign_By__c;
            
            wrapaccountlist.add(wrap);
            
        }
        System.debug(wrapaccountlist);
        
    }
    public PageReference Save(){
        PageReference savePage;
        
        SiteURL__c SiteUrl= [SELECT URL__c, Id, Name FROM SiteURL__c where Name=:'CaseSave'];
        if(feedbackselect=='--None--'){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select Distributor Feedback'));
            
        }else{
            Case cs = new Case();
            cs.id=wrapaccountlist[0].caseId ;
            cs.Feedback__c=feedbackselect;
            cs.Distributor_Comment__c = wrapaccountlist[0].DistComment;
            cs.Email_sent_to_Distributor__c =false;
            cs.CaseClosed__c=true;
            cs.CheckBox__c=true;
            update cs;
            
            System.debug('----------cs---------->'+cs);
            System.debug('SiteUrl=====>'+SiteUrl);
            savePage = new PageReference(SiteUrl.URL__c);
            //savePage = new PageReference('http://uplltd.force.com/CaseSave/CaseSave');
            savePage.setRedirect(true);
            return savePage;
        }
        return savePage;
        // savePage = new PageReference('http://devbox-uplltd.cs6.force.com/CaseSave/CaseSave');
        
    }
    
    public PageReference CheckLink(){
        System.debug('CheckLink Called');
        System.debug('--------wrapaccountlist[0].CheckDist------>'+wrapaccountlist[0].CheckDist);
        System.debug('--------wrapaccountlist[0].CheckBox------>'+wrapaccountlist[0].CheckBox);
        SiteURL__c SiteUrl= [SELECT URL__c, Id, Name FROM SiteURL__c where Name=:'RedirectPage'];
        System.debug('SiteUrl'+SiteUrl);
        System.debug('caseID------>'+caseID);
        PageReference errorPage;
        if(wrapaccountlist[0].CheckBox==true && wrapaccountlist[0].CheckDist==false){
            
            errorPage = new PageReference(SiteUrl.URL__c);
            // errorPage = new PageReference('http://uplltd.force.com/LinkExpired/RedirectPage');
            errorPage.setRedirect(true);
            return errorPage;
        }
        else{
            return null;
            
        }
        
    }
    
    public class wrapperCase{
        
        public string caseId{get;set;}
        public string Comment{get;set;}
        public string AccountId{get;set;}
        public string CaseNumber{get;set;}
        public string NonSFDCUser{get;set;}
        public string OwnerId{get;set;}
        public string Type{get;set;}
        public string subject{get;set;}
        public string Description{get;set;}
        public string Priority{get;set;}
        public Boolean checkEmail{get;set;}
        Public String DistComment{get;set;}
        Public String Status{get;set;}
        public Boolean CheckDist{get;set;}
        public Boolean CheckBox{get;set;}
        public String zonalHead{get;set;}
        public string Origin{get;set;}
        public String SapCode{get;set;}
        public String CaseAssign{get;set;} 
    }
    
    
}