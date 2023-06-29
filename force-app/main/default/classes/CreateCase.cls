public class CreateCase {
    public date startDate{get;set;}
    public date EndDate{get;set;}
    public String AcntId{get;set;}
    public List<Account_Ledger__c> accountLedgerList{get;set;}
    public Integer SdYear;
    public Integer SdMonth;
    public Integer SdDate;
    public Integer EdYear;
    public Integer EdMonth;
    public Integer EdDate;
    public DateTime startDt;
    public DateTime endDt;
    public Account_Ledger__c caseObj{get;set;}
    
    
    public CreateCase(ApexPages.StandardController controller){
        SdYear=0;
        SdMonth=0;
        SdDate=0;
        EdYear=0;
        EdMonth=0;
        EdDate=0;
        this.caseObj = (Account_Ledger__c)controller.getRecord(); 
        accountLedgerList = new List<Account_Ledger__c>();
        AcntId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public void test(){
        if(startDate!= null && EndDate!= null ){
            Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            system.debug('devRecordTypeId'+devRecordTypeId);
            
            accountLedgerList = [SELECT Id, Doc_Type__c, Posting_Date__c, Doc_Number__c, 
                                 Doc_Amount__c, Customer__c, Customer__r.Email__c,Customer__r.Name,
                                 Customer_Code__c FROM Account_Ledger__c where Id =:AcntId];
            Map<Id, Account_Ledger__c> AccountLedgerMap = new Map<Id, Account_Ledger__c>([SELECT Id, Doc_Type__c, 
                                                                                          Posting_Date__c, Doc_Number__c, 
                                                                                          Doc_Amount__c, Customer__c, 
                                                                                          Customer__r.Email__c,Customer__r.Name,
                                                                                          Customer_Code__c
                                                                                          FROM Account_Ledger__c where Id =:AcntId]);
            
            
            System.debug('AccountLedgerMap--->'+AccountLedgerMap);
            System.debug('accountLedgerList--->'+accountLedgerList);
            system.debug('AccountLedgerMap.get(AcntId).Customer__c'+AccountLedgerMap.get(AcntId).Customer__c);
            
            System.debug('AcntId------->'+AcntId);
            
            
            SdDate = startDate.day();
            SdMonth = startDate.month();
            SdYear = startDate.year();
            
            startDt = DateTime.newInstance(SdYear, SdMonth, SdDate);
            
            EdDate = EndDate.day();
            EdMonth = EndDate.month();
            EdYear = EndDate.year();
            
            endDt = DateTime.newInstance(EdYear, EdMonth, EdDate);
            
            
            case caseObj = new Case();
            caseObj.AccountId = AccountLedgerMap.get(AcntId).Customer__c;
            caseObj.Status='New';
            caseObj.RecordTypeId=devRecordTypeId;
            caseObj.Start_Date__c=startDt;
            caseObj.End_Date__c=endDt;
            insert CaseObj;
            System.debug('CaseObj====>'+CaseObj.Id);  
            if(CaseObj.Id!=null){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Request Send Successfully'));
            }
                EmailTemplate template=[SELECT Id, Name, body,DeveloperName, OwnerId FROM EmailTemplate where name='AccountLedger1'];
                // userID=UserInfo.getUserId();
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {'trupti.tamboli@skinternational.com'});
                
                System.debug('CaseObj.Id'+CaseObj.Id);
                mail.setTemplateId(template.id);
                mail.setTargetObjectId(UserInfo.getUserId());//id of user when template is used 
                mail.setTreatTargetObjectAsRecipient(false);
                
                mail.setWhatId(CaseObj.Id);
                mail.setSaveAsActivity(false);
                System.debug('mail'+mail);
                
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                for ( Messaging.SendEmailResult result : r ) {
                    
                    if ( !r[0].isSuccess () ) {
                        System.debug ( result  );
                    }
                    
                    else{
                        system.debug('Email Sent Successfully');
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Request Send Successfully'));
                    }
                }
            
            
        }
        
    }
}