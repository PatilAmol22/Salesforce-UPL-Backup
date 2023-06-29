public class Brazil_SalesOrder_Email {
@InvocableMethod
    public static void sendPDFEmail(List<id> soId){
        system.debug('**Sales_Order Id list : ' +soId);
        system.debug('userinfo'+userinfo.getUserId());
        generateSendPDF(soId);
        }
   @future(callout=true)
   
       static void generateSendPDF(List<id> soId){
        id userId;
        string emailTo;
        Blob b;
        list<id> accIds = new list<id>();
        list<string> ContactEmail = new list<string>();
        list<string> salesRepEmail = new list<string>();
        list<Contact> contactList = new list<Contact>();
        list<Sales_Order__c> userQuery = new list<Sales_Order__c>();
        
        Messaging.SingleEmailMessage semail= new Messaging.SingleEmailMessage();
        
        EmailTemplate emailTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Brazil_SalesOrder_PDF' limit 1];
        
        EmailTemplate SalesRepTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Brazil_Sales_Rep_SalesOrder_PDF' limit 1];
        
        userQuery = [select id,name,Order_Status__c,SalesOrgCode__c,OwnerId,owner.email,Sold_to_Party__r.email__c,Sold_to_Party__r.id from Sales_Order__c where id=:soid];
         
        if(userQuery!=null && userQuery.size()>0){
            userId=userQuery[0].OwnerId;
            for(Sales_Order__c sales: userQuery)
              {
               accIds.add(sales.Sold_to_Party__r.id);
               salesRepEmail.add(sales.owner.email);
               }
               //emailTo=userQuery.Sold_to_Party__r.email__c;
               }
         system.debug('**User Id : ' +userId);
         system.debug('**Account Id list : ' +accIds);
        for(account acnt:[SELECT Id,name, (SELECT Id,name,Email,Brazil_Approval_Contact__c FROM Contacts where Brazil_Approval_Contact__c=true) FROM Account where Id in:accIds ]){
        If(acnt.Contacts.size()>0){
        system.debug('**Inside Contact list');
        contactList.addAll(acnt.Contacts);
        }
         }
        system.debug('**Contact list : ' +contactList);

        for(contact cons : contactList){
        if(cons.Brazil_Approval_Contact__c==true){
        ContactEmail.add(cons.Email);
         }
         }
        system.debug('**Contact Emails : ' +ContactEmail);
        system.debug('**Contact Emails : ' +ContactEmail.size());
        
        Messaging.SendEmailResult [] r;
        try{
        if(ContactEmail!=null && ContactEmail.size()>0){
            
        system.debug('**Inside contact send Email');
        for(Id sid :soId)
           {
               PageReference pref= page.SalesOrderPDF;
               pref.getParameters().put('id1',(Id)sid);
               pref.setRedirect(true);
               if(Test.isRunningTest()) { 
                   b = blob.valueOf('Unit.Test');
               }
                   else {
                       b=pref.getContent();
               }
               
               Messaging.EmailFileAttachment attach= new Messaging.EmailFileAttachment();
               attach.setFileName('Detalhes do pedido.pdf');
               attach.setBody(b); 
               list<String> emailIds= new list<String>();
               emailIds.add(emailTo);            
               semail.saveAsActivity = false;
               semail.setTemplateId(emailTemp.Id);
               semail.setTargetObjectId(userId);
               
               semail.setWhatId(sId);
               semail.setToAddresses(ContactEmail);
               //semail.setSenderDisplayName('Salesforce Support');
               semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
           }
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
        }
            else{
                system.debug('**Inside sales rep send Email');
                system.debug('**salesRepEmail -> ' +salesRepEmail);
        for(Id sid :soId)
           {
               PageReference pref= page.SalesOrderPDF;
               pref.getParameters().put('id1',(Id)sid);
               pref.setRedirect(true);
               if(Test.isRunningTest()) { 
                   b = blob.valueOf('Unit.Test');
               }
                   else {
                       b=pref.getContent();
               }
               
               Messaging.EmailFileAttachment attach= new Messaging.EmailFileAttachment();
               attach.setFileName('Detalhes do pedido.pdf');
               attach.setBody(b);               
               semail.saveAsActivity = false;
               semail.setTemplateId(SalesRepTemp.Id);
               semail.setTargetObjectId(userId);
               semail.setWhatId(sId);
                 
               semail.setToAddresses(salesRepEmail);
               semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
           }
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
            }
            System.debug('**Email result -> ' + r[0].IsSuccess());
        }
         catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
        }
    }
 
}