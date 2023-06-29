public class FrContractLegalApprovalMail {
@InvocableMethod
      public static void sendContractEmail(List<id> contractIds){		
        Id userId;
        string emailTo;
        Blob b;
        string temp=system.label.France_Contract_Legal_EmailTemplate;
        Messaging.SingleEmailMessage semail= new Messaging.SingleEmailMessage();
        
        EmailTemplate emailTemp = [SELECT Id,name FROM EmailTemplate WHERE DeveloperName =:temp limit 1];

		Contract_management__c Contr = [select id,name,Contract_Attached__c,Contact__c,Legal_Person_Email__c,Customer_Account__c,Status__c,OwnerId,owner.email from Contract_management__c where id In :contractIds];
		
		 if(Contr.Legal_Person_Email__c!=null && Contr.OwnerId!=null){
               userId=Contr.OwnerId;
               emailTo=Contr.Legal_Person_Email__c;
               }
          
		 List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();   
          
          for(Id cId :contractIds)
           {   
               for(ContentDocumentLink contentLink : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :cId limit 1]){
                   for (ContentDocument contentDocument : [SELECT Id, LatestPublishedVersionId FROM ContentDocument WHERE Id = :contentLink.ContentDocumentId limit 1]){
                       for(ContentVersion document : [SELECT Id, Title, VersionData,FileType,FileExtension FROM ContentVersion WHERE Id = :contentDocument.LatestPublishedVersionId limit 1]){
      
      Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
      b=document.VersionData;
      attachment.setBody(b);
      attachment.setFileName(document.Title+'.'+document.FileExtension);
      fileAttachments.add(attachment);
               }
               }
               }
               list<String> emailIds= new list<String>();
               emailIds.add(emailTo);
		       semail.saveAsActivity = false;
               semail.setTemplateId(emailTemp.Id);
               semail.setTargetObjectId(userId);
               semail.setWhatId(cId);
               semail.setToAddresses(emailIds);
               semail.setFileAttachments(fileAttachments);
           }
           Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
			   
		}
}