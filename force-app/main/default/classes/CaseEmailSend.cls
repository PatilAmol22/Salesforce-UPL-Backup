public class CaseEmailSend {
    public string caseID {get;set;}
    public id userID{get;set;}
    public Case caseObj {get;set;}
    public List<String> ccAddressList{get;set;}
     public List<SelectOption> typePickList{get;set;}
     public  String selectOption{get;set;}
    public List<string> options{get;set;}
     public String UserName{get;set;}
    
    public CaseEmailSend(ApexPages.StandardController controller) {
      options=new List<String>();
       typePickList=new List<SelectOption>();
        ccAddressList=new List<String>();
        
        actioncall();
        this.caseObj = (Case)controller.getRecord();
        
        System.debug('---this.caseObj---'+this.caseObj);
        caseID = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('-Case-qId --'+caseID);
      
        
        
        caseObj = [Select Id ,Zonal_Head__c,Type, Non_SFDC_User__c, Non_SFDC_User__r.Email__c,Non_SFDC_User__r.Name,
                   status,Zonal_Head_1__c,Regional_Manager_1__c,
                   Salesforce_Non_User_Comment__c,SendEmailNonsfdcuser__c From Case where Id =: caseID ];
       selectOption=caseObj.type;
        // caseObj.=UserInfo.getName();
        
       /* if(String.isblank(caseObj.type)){
         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Select the Case Type'));
        }*/
    }
    
    public PageReference Back(){
        PageReference pr = new pageReference('/'+caseID);
        pr.setRedirect(true);
        return pr;
    }
    public void actioncall(){
 
        System.debug('Action called');
           Id recType2Id = [Select Id from RecordType Where SobjectType = 'Case' 
                                            AND DeveloperName like 'Distributor'].Id;
        System.debug('recType2Id'+recType2Id);
      
        options = PicklistDescriber.describe('Case', recType2Id, 'Type');
        //options.add('--None--');
        System.debug('options'+options);
         typePickList.add(new SelectOption('--None--','--None--'));
        for(String SelectOption: options){
        typePickList.add(new SelectOption(SelectOption,SelectOption));
        }
        
    }
    

    public void SendEmail(){
        
        if(selectOption=='--None--'){
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select Case Type'));
        
        }
        else{
        System.debug('caseObj:'+caseObj.SendEmailNonsfdcuser__c);
        if(caseObj.SendEmailNonsfdcuser__c==false){
            Non_SFDC_User__c objNon = [SELECT Id, Name, Email__c, Designation__c FROM Non_SFDC_User__c where Id =:caseObj.Non_SFDC_User__c];
            Non_SFDC_User__c objNon1 = [SELECT Id, Name, Email__c, Designation__c FROM Non_SFDC_User__c where Id =:caseObj.Zonal_Head__c];
            List<Non_SFDC_User__c> objNon2 = [SELECT Id, Name, Email__c, Designation__c FROM Non_SFDC_User__c where Id =:caseObj.Zonal_Head_1__c];
            List<Non_SFDC_User__c> RgmgrList = [SELECT Id, Name, Email__c, Designation__c FROM Non_SFDC_User__c where Id =:caseObj.Regional_Manager_1__c];
            
            if(objNon2.size()>0){
               ccAddressList.add(objNon2[0].Email__c); 
            }
            if(RgmgrList.size()>0){
                 ccAddressList.add(RgmgrList[0].Email__c); 
            }
              ccAddressList.add(objNon1.Email__c);
            
            system.debug('Email'+objNon.Email__c);
            //System.debug(objNon1.Email__c);
            EmailTemplate template=[SELECT Id, Name, body,DeveloperName, OwnerId FROM EmailTemplate where name='Case Email Sent'];
            userID=UserInfo.getUserId();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { objNon.Email__c});
         
         //   mail.setCcAddresses(new String[] { ccAddressList});
                mail.setCcAddresses(ccAddressList);
         
            mail.setTemplateId(template.id);
            mail.setTargetObjectId(userID);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setWhatId(caseObj.Id);
            mail.setSaveAsActivity(false);
            System.debug('mail'+mail);
            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            for ( Messaging.SendEmailResult result : r ) {
                
                if ( !r[0].isSuccess () ) {
                    System.debug ( result  );
                }
                
                else{
                    system.debug('Email Sent Successfully');
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email Sent Successfully'));

                    caseObj.SendEmailNonsfdcuser__c=true;
                    caseObj.Status='open';
                    caseObj.CaseClosed__c=false;
                    caseObj.CheckBox__c=false;
                    caseObj.type=selectOption;
                    caseObj.Case_Assign_By__c=UserInfo.getName();
                    update caseObj;
                 
                }
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Email Already Sent To sales User'));
            
        }
        }
        //return null;
    }
    public void Save(){
        System.debug('caseObj:'+caseObj);
        update caseObj;
        
    }
}