public class CaseEmailForSite {
    
    
    public list<wrapperCase> wrapaccountList{ get; set;}
    public string caseID {get;set;}
    public String StatusValue { get; set; }
    public String UserName{get;set;}
    public Boolean reMangr{get;set;}
    public Boolean ZonalHead{get;set;}
    
    
    public List<Case> caseObjList{get;set;}
    public List<SelectOption> yearOptions{get;set;}
    
    
    public CaseEmailForSite() {
        reMangr=false;
        ZonalHead=false;
        caseID = ApexPages.currentPage().getParameters().get('id');
        System.debug(caseID);
        yearOptions=new List<SelectOption>();
        wrapaccountList =new list<wrapperCase>();
        caseObjList = [Select Id , Non_SFDC_User__r.name, Non_SFDC_User__r.Email__c,status,
                       Type,Account.Name,CaseNumber,Owner.name,Origin,Priority,Subject,Description,SendEmailNonsfdcuser__c,
                       Zonal_Head_1__r.name,Regional_Manager_1__r.name,
                       Zonal_Head__c,Zonal_Head__r.name,SAP_Code__c,Case_Assign_By__c,
                       Salesforce_Non_User_Comment__c From Case where Id =: caseID ];
        wrapperCase wrap = new wrapperCase();
        yearOptions.add(new SelectOption('Open','Open'));
        yearOptions.add(new SelectOption('Closed','Closed'));
       // UserName=UserInfo.getName();
        system.debug('UserName-->'+UserName);
        
        System.debug( UserInfo.getName());
        for(Case CaseObj :caseObjList){
           wrap.Comment= CaseObj.Salesforce_Non_User_Comment__c ;
            wrap.AccountId= CaseObj.Account.name;
            wrap.CaseNumber= CaseObj.CaseNumber;
            wrap.NonSFDCUser= CaseObj.Non_SFDC_User__r.name;
            wrap.zonalHead= CaseObj.Zonal_Head__r.name;
            wrap.Origin=CaseObj.Origin;
            wrap.Type = CaseObj.Type;
            wrap.SapCode= CaseObj.SAP_Code__c;
            wrap.OwnerId=CaseObj.Owner.name;
            wrap.caseId = caseID;
            wrap.Priority=CaseObj.Priority;
            wrap.subject= CaseObj.Subject;
            wrap.Description=CaseObj.Description;
            wrap.checkEmail = CaseObj.SendEmailNonsfdcuser__c;
            wrap.CaseAssign = CaseObj.Case_Assign_By__c;
            if(String.isNotBlank(CaseObj.Regional_Manager_1__r.name)){
                reMangr=true;
                wrap.RgMgr=CaseObj.Regional_Manager_1__r.name;
                
            }
            if(String.isNotBlank(CaseObj.Zonal_Head_1__r.name)){
                ZonalHead=true;
                wrap.zonalHead1=CaseObj.Zonal_Head_1__r.name;
                
            }
            wrapaccountlist.add(wrap);
            
        }
        System.debug(wrapaccountlist);
    }
    public PageReference Save(){
        PageReference savePage;
        
        SiteURL__c SiteUrl= [SELECT URL__c, Id, Name FROM SiteURL__c where Name=:'CaseSave'];
        Case cs = new Case();
        cs.id=wrapaccountlist[0].caseId ;
        cs.status= StatusValue;
        cs.Salesforce_Non_User_Comment__c = wrapaccountlist[0].Comment;
        cs.SendEmailNonsfdcuser__c=false;
        update cs;
        System.debug('SiteUrl=====>'+SiteUrl);
        
        
        // savePage = new PageReference('http://devbox-uplltd.cs6.force.com/CaseSave/CaseSave');
        savePage = new PageReference(SiteUrl.URL__c);
        //savePage = new PageReference('http://uplltd.force.com/CaseSave/CaseSave');
        savePage.setRedirect(true);
        return savePage;
    }
    
    
    public PageReference CheckLink(){
        
        SiteURL__c SiteUrl= [SELECT URL__c, Id, Name FROM SiteURL__c where Name=:'RedirectPage'];
        System.debug('SiteUrl'+SiteUrl);
        System.debug('caseID------>'+caseID);
        System.debug('wrapaccountlist[0].checkEmail'+wrapaccountlist[0].checkEmail);
        PageReference errorPage;
        if(caseObjList[0].SendEmailNonsfdcuser__c==False){
            System.debug('inside if wrapaccountlist[0].checkEmail'+wrapaccountlist[0].checkEmail);
            errorPage = new PageReference(SiteUrl.URL__c);
            // errorPage = new PageReference('http://uplltd.force.com/LinkExpired/RedirectPage');
            errorPage.setRedirect(true);
            System.debug('errorPage'+errorPage);
            return errorPage;
             
        }
        else{
         System.debug('errorPage'+errorPage);
            
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
        public String zonalHead{get;set;}
        public String Origin{get;set;}
        public String SapCode{get;set;}
        public String RgMgr{get;set;}
        public String zonalHead1{get;set;}
        public String CaseAssign{get;set;}
        
    }
    
    
}