//Email service to save the attachments of email against an account which contains Customer Code (SAP Code) recieved in subject line of email
//Written by Virag Mhatre

global class IncomingInvoice implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
         List<Account> Account = new List<Account>();
         String Subject;
         String CustomerCode;
          
          try{
          //Splitting Customer Code From Subject
          Subject = email.subject;
          system.debug('Subject --->'+Subject);
          CustomerCode = (Subject.split('\\-')[0]).split('#')[1];
          system.debug('Customer Code --->'+CustomerCode);
          Account = [Select Id FROM Account WHERE SAP_Code__c  = :CustomerCode AND Account_Type__c = 'Sold To Party' LIMIT 1];
              system.debug(Account[0].Id);
              
            // Save Text Attachments
          if(email.textAttachments!=null){
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
        //    Attachment attachment = new Attachment();
        //    attachment.Name = tAttachment.fileName;
        //    attachment.Body = Blob.valueOf(tAttachment.body);
        //    attachment.ParentId = invoice[0].Id;
        //    insert attachment;
                
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = tAttachment.fileName; 
                conVer.Title = tAttachment.fileName; 
                conVer.VersionData = EncodingUtil.base64Decode(tAttachment.body); 
                insert conVer; 

                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = Account[0].Id; 
                conDocLink.ContentDocumentId = conDoc;
                conDocLink.shareType = 'V';
                insert conDocLink;
            }
          }

            //Save Binary Attachment
          if(email.binaryAttachments!=null){
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
         //    Attachment attachment = new Attachment();
         //    attachment.Name = bAttachment.fileName;
         //    attachment.Body = bAttachment.body;
         //    attachment.ParentId = invoice[0].Id;
         //    insert attachment;
            
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; 
                conVer.PathOnClient = bAttachment.fileName; 
                conVer.Title = bAttachment.fileName; 
                conVer.VersionData = bAttachment.body; 
                insert conVer; 

                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = Account[0].Id; 
                conDocLink.ContentDocumentId = conDoc;
                conDocLink.shareType = 'V';
                insert conDocLink;
                
            }
          }
                result.success = true;
              
              if(result.success==true){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {email.fromAddress} );              
                mail.setSubject('Incoming Invoice Service');
                  if(email.textAttachments!=null || email.binaryAttachments!=null){
                mail.setPlainTextBody('Dear User,\n\nEmail attachments uploaded successfully.\n\nThank you.');              
                  }
                  else if(email.textAttachments==null && email.binaryAttachments==null){
                mail.setPlainTextBody('Dear User,\n\nNo Email attachments found.\n\nThank you.');          
                  }
                   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 
              }
          
          }
          
          catch(exception e){
           system.debug(e);
              if(Account.isEmpty()){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //Email address changed by Grazitti(Aashima) for APPS-2467
                //mail.setToAddresses(new String[] {email.fromAddress} );  
                mail.setToAddresses(new String[] {'uconnect.support@upl-ltd.com'} );              
                mail.setSubject('Incoming Invoice Service');
                  if(CustomerCode==null){
                      mail.setPlainTextBody('Dear User,\n\nNo Customer code found in the subject line.\nPlease enter a correct Customer code in the subject line of email in the following format.\n#Customer code - Billing document number\n\nThank you.');
                  }
                  else{
                      mail.setPlainTextBody('Dear User,\n\nCustomer code '+CustomerCode+' not found while uploading attachments.\nPlease enter a correct customer code.\n\nThank you.');
                    }
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
              }
          }    
  
          return result;
      }
  }