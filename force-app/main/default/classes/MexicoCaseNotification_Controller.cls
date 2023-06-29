/* Email service class to fetch subject and body from email and store it in subject and description field of a newly created case record
 * respectively, The account owner of the account containing the recieved email address would be auto assigned as owner of the newly created
 * case.  ----------------- Email service name : Mexico Case Notification
 * Written by Virag Mhatre */

global class MexicoCaseNotification_Controller implements Messaging.InboundEmailHandler{
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)

{

      //Fetching details of Email
        String Subject = email.subject;
        system.debug('Subject >> '+Subject);
        String Description = (email.plainTextBody).substringBeforeLast('--');
        system.debug('Body/Description >> '+Description);
        String FromAddress = email.fromAddress;
        system.debug('From Address >> '+FromAddress);
       
        //Fetching List of Accounts and their Owner Ids associated with FromAddress
        List<Account> AccountsRelatedToFromAddress = [Select id , Email__c, OwnerId, Owner.Email from Account WHERE Email__c =:FromAddress AND Sales_Org_Code__c = '5100' AND Account_Type__c = 'Sold To Party' AND RecordType.Name = 'Distributor'];  
        system.debug('List of Accounts > '+AccountsRelatedToFromAddress);
   //   system.debug('Case Owner >> '+AccountsRelatedToFromAddress[0].OwnerId);
     
       //Fetching Mexico distributor record type id and Case Queue Id
       Id RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mexico Distributor').getRecordTypeId();
       Id CaseQueue = [select Id, Name, DeveloperName from Group where Type = 'Queue' and DeveloperName = 'Mexico_Email_to_case_Queue' Limit 1].Id;
       List<Id> SendEmailToList = new List<Id>();
   
         //Creation of Case record
           Case c = new Case();
           c.Subject = Subject;
           c.Description = Description;          
           c.RecordTypeId = RecordTypeId; //RecordTypeId of Mexico Distributor
           //Added by Varun Shrivastava: SCTASK0517841 : Add Default Type Start
           c.Type = 'Customer Email';
           //Added by Varun Shrivastava: SCTASK0517841 : Add Default Type End
           c.Origin = 'Email';
           c.EmailForCaseCreate__c = FromAddress;
       if(AccountsRelatedToFromAddress.size()==1){  //if only one account is found then assign account and account owner to the case
           c.OwnerId = AccountsRelatedToFromAddress[0].OwnerId;
           c.AccountId = AccountsRelatedToFromAddress[0].Id;  
           SendEmailToList.add(AccountsRelatedToFromAddress[0].OwnerId);
        }
      if(AccountsRelatedToFromAddress.size()!=1){ // if no account or more than one account is found then assign owner to queue
        c.OwnerId = CaseQueue;
          for(User u : [SELECT User.Id, User.Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE Group.Id =:CaseQueue)]){
              SendEmailToList.add(u.Id);
          }
        }
           insert c;
    System.debug('SendEmailToList '+SendEmailToList);
   System.debug('c id '+c.Id);
    
    EmailTemplate emailTemplate=[select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Mexico Case : When Case is assigned'];
     	
    For(Id usrid : SendEmailToList){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
   		mail.setTargetObjectId(usrid);
        mail.setWhatId(c.Id); 
        mail.setTemplateId(emailTemplate.Id);
        mail.setBccSender(false); 
        mail.setUseSignature(false); 
        mail.setSenderDisplayName('UPL Team'); 
        mail.setSaveAsActivity(false); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
   
    SendEmailToList.Clear();
    return null;
  }
}