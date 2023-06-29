global class salesOrderEmail {
@InvocableMethod(label='Sales order email' description='Sends email to Account --> Contact users of Sales order according to status of SO' category='Sales Order')
  global static void sendSOEmails(List<ID> ids) {
      String SalesOrderId = ids[0];
      
      Set<String> setofAccounts = new Set<String>();
      Set<String> setOfEmailIds= new Set <String>();
      List<Contact> listOfContact = new List<Contact>();
      
      List<Sales_Order__c> listOfSO = [SELECT Id, Sold_to_Party__c, Order_Status__c FROM Sales_Order__c WHERE ID in :ids LIMIT 1];
      String Status = '';
      for(Sales_Order__c so : listOfSO){
       system.debug('Status>>--->'+so.Order_Status__c);
          if(so.Order_Status__c == 'Open' || so.Order_Status__c == 'Rejected'){
              setOfAccounts.add(so.Sold_to_Party__c);
              Status = so.Order_Status__c;
             
        
      }      
      system.debug('accounts >>--->'+setOfAccounts);
      listOfContact = [SELECT Id, Email FROM Contact WHERE AccountId IN :setOfAccounts AND Is_Community__c = true LIMIT 10];
      for(Contact c : listOfContact){
         setOfEmailIds.add(c.Email);
      }
          List<String> listOfEmails = new List<String>(setOfEmailIds);
          system.debug('listofemails---->'+listOfEmails);
          
          if(listOfEmails.size()>0){
         
              EmailTemplate et;
        if(Status == 'Open'){
             et = [SELECT Id, DeveloperName FROM EmailTemplate where DeveloperName= 'Poland_SO_Approved'];
          }
        else if (Status == 'Rejected'){
             et = [SELECT Id, DeveloperName FROM EmailTemplate where DeveloperName= 'Poland_SO_Rejected'];
             
        }
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where DisplayName ='UPL Team'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        list<string> maillist= new list<string>();
        if(owea.size()>0){
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setToAddresses(listOfEmails);
        mail.setWhatId(SalesOrderId);
        mail.setTemplateId(et.Id);
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setSaveAsActivity(false);
        list<Messaging.SendEmailResult> mailresult = Messaging.sendEmail(new Messaging.Email[] { mail });
        
        system.debug('mailresult>>--->'+mailresult);
          }         
  }
  }
    
    
}