public class AccountLedgerMob {
    
    Public List<Account_Ledger__c> AccountLedgerList{get;set;}
    public List<AccountLedgerWrapper> WrapperList {get; set;}
    public List<Account_Ledger__c> selectedContacts{get;set;} 
    public List<Case> caseList{get;set;}
    public List<Contact> conList {get;set;}
    public string errorMessage{get;set;}
    public String Discription{get;set;}
    public boolean showError{get;set;}
    public boolean displayPopUp{get;set;}
    public String distributorId;
    public String accountId {get;set;}
    public String DocNumber{get;set;}
    public date StartDate{get;set;}
    public date EndDate{get;set;}
    public String DocType{get;set;}
    public String DueDate{get;set;}
    public String DocAmmount{get;set;}
    public String Comment{get;set;}
    public Id devRecordTypeId{get;set;}
    public String Postingdate{get;set;}
    
    public Integer SdYear;
    public Integer SdMonth;
    public Integer SdDate;
    public Integer EdYear;
    public Integer EdMonth;
    public Integer EdDate;
    public DateTime startDt;
    public DateTime endDt;
    
    public User loginUserObj {get;set;}
    
    public AccountLedgerMob(){
        
        SdYear=0;
        SdMonth=0;
        SdDate=0;
        EdYear=0;
        EdMonth=0;
        EdDate=0;
        
        DocNumber='';
        DocType='';
        DueDate='';
        Postingdate='';
        DocType='';
        DueDate='';
        DocAmmount='';
        Comment='';
        distributorId='';
        Discription='';
        showError=false;
        displayPopUp=false;
        errorMessage='';
        accountId = '';
        caseList = new List<Case>();
        AccountLedgerList =new List<Account_Ledger__c> ();
        selectedContacts= new List<Account_Ledger__c>();
        devRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        loginUserObj = [SELECT Id, Name, IsActive, ContactId, PortalRole,
                        Show_Inventory__c, Show_Credit_Limit__c
                        FROM User 
                        WHERE Id =: UserInfo.getUserId()
                        AND IsActive = True];
        conList = [SELECT Id, FirstName, LastName, 
                   Accountid, Account.OwnerId, 
                   Account.RegionalManager__c
                   FROM Contact 
                   WHERE Id =: loginUserObj.ContactID];
        System.debug('conList====>'+conList);
        
        if(!conList.isEmpty()){        
            accountId = conList[0].Accountid;
            
        }
    /*else{
            accountId = '001N000000ocp0T';
        }*/
        
    }
    
    public void clearInput(){
        for(AccountLedgerWrapper cCon: getLoadAccountLedger()) {
            System.debug('Clear'+cCon.selected);
            if(cCon.selected == true) {
                cCon.selected = false;
            }
        }
    }
    public List<AccountLedgerWrapper> getLoadAccountLedger() {
        
        if(WrapperList == null) {
            distributorId=UserInfo.getUserId();
            System.debug('distributorId:'+distributorId);
            System.debug('accountId:'+accountId);
            WrapperList = new List<AccountLedgerWrapper>();
            AccountLedgerList = [SELECT Id, Name, Doc_Type__c, Posting_Date__c, Doc_Number__c, Doc_Amount__c, Customer__c,Due_Date__c, 
                                 SAP_sales_org_code__c, Customer_Code__c FROM Account_Ledger__c where Customer__c=: accountId];
            
            for(Account_Ledger__c c : AccountLedgerList){
                WrapperList.add(new AccountLedgerWrapper(c));
            }
        }
        if(WrapperList.isEmpty()) {
            displayPopUp= true;
            // errorMessage = 'Account Ledger Is not Present';
            
        }
        return WrapperList;
    }
    
    
    public PageReference processSelected() {
        
        for(AccountLedgerWrapper cCon: getLoadAccountLedger()) {
            System.debug('cCon'+cCon.selected);
            if(cCon.selected == true) {
                selectedContacts.add(cCon.con);
            }
        }
        
        if(selectedContacts.size()==0){
            showError = true;
            errorMessage = 'Please Select Atleast one Account Ledger';
        }
        
        else if(selectedContacts.size()>1){
            showError = true;
            errorMessage = 'Do Not Select More than One AccountLedger';
        }
        else{
            
        }
        AccountLedgerList=new List<Account_Ledger__c> (); 
        return null;
    }
    public void CreateCaseRequestStatement(){
        try{
            System.debug('StartDate:'+StartDate);
            System.debug('EndDate:'+EndDate);
            if(StartDate!= null && EndDate!= null ){
                SdDate = startDate.day();
                SdMonth = startDate.month();
                SdYear = startDate.year();
                
                startDt = DateTime.newInstance(SdYear, SdMonth, SdDate);
                
                EdDate = EndDate.day();
                EdMonth = EndDate.month();
                EdYear = EndDate.year();
                
                endDt = DateTime.newInstance(EdYear, EdMonth, EdDate);
                
                List <user> userList =[SELECT Id,name,UserRoleId,UserRole.name,isactive FROM User where UserRole.name='Executive' and isactive=true]; 
                
               Map<Id, Account_Ledger__c> AccountLedgerMap = new Map<Id, Account_Ledger__c>([SELECT Id, Doc_Type__c, 
                                                                                              Posting_Date__c, Doc_Number__c, 
                                                                                              Doc_Amount__c, Customer__c, 
                                                                                              Customer__r.Email__c,Customer__r.Name,
                                                                                              Customer_Code__c
                                                                                              FROM Account_Ledger__c where Id IN:selectedContacts]);
              for(Account_Ledger__c acc: selectedContacts) {
                    case caseObj = new Case();
                  caseObj.AccountId = AccountLedgerMap.get(acc.Id).Customer__c;
                  // caseObj.AccountId = UserInfo.getUserId();
                    caseObj.Status='New';
                    caseObj.RecordTypeId=devRecordTypeId;
                    caseObj.Start_Date__c=startDt;
                    caseObj.End_Date__c=endDt;
                    CaseObj.Origin='Uni View';
                    //CaseObj.Status='New';
                    CaseObj.Type='Account Related';
                    CaseObj.OwnerId=userList[0].id;
                    CaseObj.Subject='Account Ledger Request for Statement from'+startDt+'  To  '+endDt;
                    caseList.add(CaseObj);
                   
              }
                System.debug('caseList====>'+caseList);
                
                System.debug('caseList====>'+caseList);
                if(caseList.size()>0){
                    insert caseList;
                }
                if(caseList[0].Id!=null){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Request Send Successfully'));
                }
                EmailTemplate template=[SELECT Id, Name, body,DeveloperName, OwnerId FROM EmailTemplate where name='AccountLedger1'];
                // userID=UserInfo.getUserId();
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {'trupti.tamboli@skinternational.com'});
                
                
                mail.setTemplateId(template.id);
                mail.setTargetObjectId(UserInfo.getUserId());//id of user when template is used 
                mail.setTreatTargetObjectAsRecipient(false);
                
                mail.setWhatId(caseList[0].Id);
                mail.setSaveAsActivity(false);
                System.debug('mail'+mail);
                
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                for ( Messaging.SendEmailResult result : r ) {
                    
                    if ( !r[0].isSuccess () ) {
                        System.debug ( result  );
                    }
                    
                    /*  else{
system.debug('Email Sent Successfully');
ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Request Send Successfully'));
}*/
                }
            }
        }
        catch(Exception ex ){
            system.debug('Exception :'+ex.getCause()+'Line Number:'+ex.getLineNumber()+'Message:'+ex.getMessage());
            
        }
    }
    public void createCaseAccountLedger(){
        
        List <user> userList =[SELECT Id,name,UserRoleId,UserRole.name,isactive FROM User where UserRole.name='Executive' and isactive=true];
        System.debug('Discription'+Discription);
        System.debug('createCaseAccountLedger.size()'+selectedContacts.size());
        for(Account_Ledger__c acc: selectedContacts) {
			 if(string.isnotblank(acc.Doc_Number__c)){
                DocNumber='Doc No : '+acc.Doc_Number__c+'\r\n';
            }
            else{
                DocNumber='Doc No : '+'N/A'+'\r\n';
            }
            if(string.isnotblank(acc.Doc_Type__c)){
                DocType='DocType : '+acc.Doc_Type__c+'\r\n';    
                
            }
            else{
                DocType='DocType : '+'N/A'+'\r\n';  
            }
            if(string.isnotblank(String.valueOF(acc.Doc_Amount__c))){
                DocAmmount='DocAmmount: '+acc.Doc_Amount__c+'\r\n';
            }
            else{
                DocAmmount='DocAmmount: '+'N/A'+'\r\n';
            }
            if(acc.Posting_Date__c==null){
                Postingdate='Posting Date: '+'N/A'+'\r\n';
            }
            else{
                Postingdate='Posting Date: '+string.valueof(acc.Posting_Date__c)+'\r\n';
            }
            if(acc.Due_Date__c==null){
                Duedate='Due Date: '+'N/A'+'\r\n';
            }
            else{
                Duedate='Due Date: '+string.valueof(acc.Due_Date__c)+'\r\n';
            }
            if(string.isnotblank(Discription)){
                Comment='Comment : '+Discription;
            }
            else{
                Comment='Comment : '+'N/A';
            }
            
            case CaseObj = new Case();
            CaseObj.RecordTypeId = devRecordTypeId;
            CaseObj.AccountId=acc.Customer__c;
            CaseObj.type = 'Account Related';
            CaseObj.Case_Assign_Date_Time__c=system.today();
            CaseObj.Subject='Account Statement transaction issue';
            CaseObj.Description='There is a issue With Account Statement as below \r\n'+DocNumber+Postingdate+DocType+Duedate+DocAmmount+Comment;
            CaseObj.Origin='Uni View';
            CaseObj.Status='New';
            CaseObj.OwnerId=userList[0].id;
            caseList.add(CaseObj);
            //insert CaseObj;
            
        }
        system.debug('caseList:'+caseList);
        if(caseList.size()>0){
            insert caseList;
        }
    }
    /*
*  toHome() 
*  navigates to the Home page 
*/
    public PageReference toHome() {
        PageReference next = new PageReference('/apex/cataloghome');
        next.setRedirect(true);
        // Directing to Home
        return next;
    }   
    
    public class AccountLedgerWrapper {
        public Account_Ledger__c con {get; set;}
        public Boolean selected {get; set;}
        
        
        public AccountLedgerWrapper(Account_Ledger__c c) {
            con = c;
            selected = false;
        }
    }
}