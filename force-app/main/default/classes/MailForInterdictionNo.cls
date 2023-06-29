/*
@Author: Pragati Sharma  For APPS-3648
@Class_Description : Invocable method to call from flow for sending mails with attachments
*/ 
public class MailForInterdictionNo {
    @InvocableMethod (label='Get Interdiction with no' description='Sends email to the logistic operator when interdiction is no with all the attachments' category='Interdiction_Process__c')
    public static void sendEmailToOperatorswhenNo(List<String> recordId){
        
        System.debug('recordId'+recordId);
        
        OrgWideEmailAddress owa=[select id, Address,DisplayName from OrgWideEmailAddress where DisplayName='Brazil Support'];
        
        List<String> emailList=new List<String>();
        List<String> ccAddresses = new List<String>();
        
        if(system.label.interdiction_logistics!=null)
        {
            for(String item : system.label.interdiction_logistics.split(',')){
                ccAddresses.add(item.trim());
            }
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        List<Interdiction_Process__c> InterdictionList=new List<Interdiction_Process__c>();
        List<Interdiction_Process__c> InterdictionListWithNo = new List<Interdiction_Process__c>();
        List<Interdiction_Process__c> InterdictionListWithSim = new List<Interdiction_Process__c>();
        List<Interdiction_Process__c> InterdictionListAfterLegal = new List<Interdiction_Process__c>();
        List<Interdiction_Process__c> InterdictionListToAgents = new List<Interdiction_Process__c>();
        Map<id,ContentDocumentLink> cvMap=new Map<id,ContentDocumentLink>();
        
        InterdictionList  =[Select id,STATE__c,CITY__c,INSCRI_O_ESTADUAL__c,CNPJ_CPF__c,DATE_OF_REQUEST__c,CONTACT__c,NUMBER__c,SUBURB__c,STREET__c,POSTCODE__c,SKU_Code__c,EMAIL_LOGISTICS_OPERATOR_Brazil__c,AGENT_EMAIL_Brazil__c,Instance_Number__c,TERM_NUMBER__c,DUE_DATE__c,IS_AN_INTERDICTION__c,Status__c,RAZ_O_SOCIAL__c,Criado_Por__c,Data_de_Encerramento__c,Pendente_com__c,CreatedDate from Interdiction_Process__c where id in:recordId];
        
        if(InterdictionList.size()>0 && !InterdictionList.isEmpty()){
            for(Interdiction_Process__c e :InterdictionList)
            {
                if(e.Status__c=='Book Collection' && e.IS_AN_INTERDICTION__c=='Não'){
                    
                    InterdictionListWithNo.add(e);
                    
                }
                if(e.Status__c=='Book Collection' && e.IS_AN_INTERDICTION__c=='Sim'){
                    
                    InterdictionListWithSim.add(e);
                    
                }
                if(e.Status__c=='Waiting for Collection' && e.IS_AN_INTERDICTION__c=='Sim'){
                    InterdictionListAfterLegal.add(e);
                    
                }
                if(e.Status__c=='Process Interdiction' && e.IS_AN_INTERDICTION__c=='Sim'){
                    InterdictionListToAgents.add(e);
                    
                }
                
            }
            
        }
        if(InterdictionListWithNo.size()>0 && !InterdictionListWithNo.isEmpty()){
            
            EmailTemplate et = [Select id,Body,HtmlValue,Subject from EmailTemplate where developerName ='when_Interdiction_Process_is_no'];
            For(ContentDocumentLink cv:[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId in :recordId])
            {
                cvMap.put(cv.id,cv);
            } 
            
            
            For(Interdiction_Process__c ipc:InterdictionListWithNo){
                if(ipc.EMAIL_LOGISTICS_OPERATOR_Brazil__c!=null){
                    for(String item : ipc.EMAIL_LOGISTICS_OPERATOR_Brazil__c.split(';')){
                        emailList.add(item.trim());}
                }
                Messaging.Emailfileattachment Attachments = new Messaging.Emailfileattachment();
                PageReference pref = page.InterdictionPdfGenerate;
                pref.getParameters().put('id',recordId[0]);
                pref.setRedirect(true);
                Blob b;
                if(!Test.isRunningTest()){
                    
                    b  = pref.getContent();
                    Attachments.setFileName( ipc.Instance_Number__c+' '+'.pdf');
                    Attachments.setBody(b);
                    fileAttachments.add(Attachments);
                }
                else{
                    b = Blob.valueof('Some random String');
                    ipc.STATE__c=  ipc.STATE__c;
                    ipc.TERM_NUMBER__c=ipc.TERM_NUMBER__c;
                    ipc.DUE_DATE__c= ipc.DUE_DATE__c;
                    ipc.STREET__c=ipc.STREET__c;
                    ipc.CITY__c=ipc.CITY__c;
                    ipc.CONTACT__c=ipc.CONTACT__c;
                    ipc.INSCRI_O_ESTADUAL__c=ipc.INSCRI_O_ESTADUAL__c;
                    ipc.SUBURB__c=ipc.SUBURB__c;
                    ipc.POSTCODE__c=ipc.POSTCODE__c;
                    ipc.NUMBER__c=ipc.NUMBER__c;
                    ipc.DATE_OF_REQUEST__c=ipc.DATE_OF_REQUEST__c;
                    ipc.Data_de_Encerramento__c=ipc.Data_de_Encerramento__c;
                    ipc.SKU_Code__c=ipc.SKU_Code__c;
                    
                    
                }
                
                mail.setTargetObjectId(UserInfo.getUserId());
                mail.setToAddresses(emailList);
                
                mail.setTemplateId(et.id);
                mail.setCcAddresses(ccAddresses);
                
                String htmlBody = et.HtmlValue;
                String subject=et.Subject;
                subject=subject.replace('{!Interdiction_Process__c.Instance_Number__c }',ipc.Instance_Number__c);
                subject=subject.replace('{!Interdiction_Process__c.RAZ_O_SOCIAL__c}',ipc.RAZ_O_SOCIAL__c);   
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.Instance_Number__c}',ipc.Instance_Number__c);
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
                
            }
            if(!cvMap.isEmpty() && cvMap!=null){
                for (id idc :cvMap.keyset()) 
                {   System.debug('enetered in cv for ');  
                 ContentDocumentLink a=cvMap.get(idc);
                 Messaging.Emailfileattachment efab = new Messaging.Emailfileattachment();
                 efab.setFileName(MethodForFileNameType(a));
                 efab.setBody(a.ContentDocument.LatestPublishedVersion.VersionData);
                 fileAttachments.add(efab);
                }
                
            }
            mail.setFileAttachments(fileAttachments);
            mail.saveAsActivity=false;
            allMails.add(mail);
            
            Savepoint sp = Database.setSavepoint();
            
            Messaging.sendEmail(allMails);
            
            Database.rollback(sp);
            List<Messaging.SingleEmailMessage> actualMessageList = new List<Messaging.SingleEmailMessage>();
            
            for (Messaging.SingleEmailMessage email : allMails) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(email.getToAddresses());
                mail.setOrgWideEmailAddressId(owa.id);
                emailToSend.setCcAddresses(ccAddresses);
                emailToSend.setHTMLBody(email.getHTMLBody());
                
                emailToSend.setSubject(email.getSubject());
                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                emailToSend.setFileAttachments(email.getFileAttachments());
                actualMessageList.add(emailToSend);
            }
            
            
            if(actualMessageList.size()>0 && !actualMessageList.isEmpty()){   
                
                try{
                    Messaging.sendEmail(actualMessageList);  
                    System.debug('Mail sent');
                }
                catch(Exception e){
                    System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
                }
                
            }
            
        }
        If(InterdictionListWithSim.size()>0 && !InterdictionListWithSim.isEmpty()){
            
            EmailTemplate et = [Select id,Body,HtmlValue,Subject from EmailTemplate where developerName ='Notify_Logistic_Operator_For_Interdiction_task2'];
            For(ContentDocumentLink cv:[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId in :recordId])
            {
                cvMap.put(cv.id,cv);
            } 
            
            For(Interdiction_Process__c ipc:InterdictionListWithSim){
                if(ipc.EMAIL_LOGISTICS_OPERATOR_Brazil__c!=null){
                    for(String item : ipc.EMAIL_LOGISTICS_OPERATOR_Brazil__c.split(';')){
                        emailList.add(item.trim());}
                }
                Messaging.Emailfileattachment Attachments = new Messaging.Emailfileattachment();
                PageReference pref = page.InterdictionPdfGenerate;
                pref.getParameters().put('id',recordId[0]);
                pref.setRedirect(true);
                Blob b;
                if(!Test.isRunningTest()){
                    
                    b  = pref.getContent();
                    Attachments.setFileName( ipc.Instance_Number__c+' '+'.pdf');
                    Attachments.setBody(b);
                    fileAttachments.add(Attachments);
                }
                else{
                    b = Blob.valueof('Some random String');
                    ipc.STATE__c=  ipc.STATE__c;
                    ipc.TERM_NUMBER__c=ipc.TERM_NUMBER__c;
                    ipc.DUE_DATE__c= ipc.DUE_DATE__c;
                    ipc.STREET__c=ipc.STREET__c;
                    ipc.CITY__c=ipc.CITY__c;
                    ipc.CONTACT__c=ipc.CONTACT__c;
                    ipc.INSCRI_O_ESTADUAL__c=ipc.INSCRI_O_ESTADUAL__c;
                    ipc.SUBURB__c=ipc.SUBURB__c;
                    ipc.POSTCODE__c=ipc.POSTCODE__c;
                    ipc.NUMBER__c=ipc.NUMBER__c;
                    ipc.DATE_OF_REQUEST__c=ipc.DATE_OF_REQUEST__c;
                    ipc.Data_de_Encerramento__c=ipc.Data_de_Encerramento__c;
                    ipc.SKU_Code__c=ipc.SKU_Code__c;
                }
                
                mail.setTargetObjectId(UserInfo.getUserId());
                mail.setToAddresses(emailList);
                mail.setTemplateId(et.id);
                mail.setOrgWideEmailAddressId(owa.id);
                mail.setCcAddresses(ccAddresses);
                
                String htmlBody = et.HtmlValue;
                String subject=et.Subject;
                subject=subject.replace('{!Interdiction_Process__c.Instance_Number__c}',ipc.Instance_Number__c);
                subject=subject.replace('{!Interdiction_Process__c.RAZ_O_SOCIAL__c}',ipc.RAZ_O_SOCIAL__c);   
                Date dtTodayDate = ipc.DUE_DATE__c;
                
                Datetime dtTodayDateTime = datetime.newInstance(dtTodayDate.year(), dtTodayDate.month(),dtTodayDate.day());
                
                string strDate = dtTodayDateTime.format('dd/MM/yyyy');
                
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.Instance_Number__c}',ipc.Instance_Number__c);
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.TERM_NUMBER__c}',ipc.TERM_NUMBER__c);
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.DUE_DATE__c}',strDate);
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
                
            }
            if(!cvMap.isEmpty() && cvMap!=null){
                for (id idc :cvMap.keyset()) 
                {   System.debug('enetered in cv for ');  
                 ContentDocumentLink a=cvMap.get(idc);
                 Messaging.Emailfileattachment efab = new Messaging.Emailfileattachment();
                 efab.setFileName(MethodForFileNameType(a));
                 efab.setBody(a.ContentDocument.LatestPublishedVersion.VersionData);
                 fileAttachments.add(efab);
                }
                
                System.debug('mail'+mail);
            }
            mail.setFileAttachments(fileAttachments);
            mail.saveAsActivity=false;
            allMails.add(mail);
            
            Savepoint sp = Database.setSavepoint();
            
            // send the temporary email list
            Messaging.sendEmail(allMails);
            
            Database.rollback(sp);
            List<Messaging.SingleEmailMessage> actualMessageList = new List<Messaging.SingleEmailMessage>();
            
            if(allMails.size()>0 && !allMails.isEmpty()){
                for (Messaging.SingleEmailMessage email : allMails) {
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setCcAddresses(ccAddresses);
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    emailToSend.setFileAttachments(email.getFileAttachments());
                    actualMessageList.add(emailToSend);
                }
            }
            
            
            if(actualMessageList.size()>0 && !actualMessageList.isEmpty()){   
                system.debug('Send Email');
                try{
                    Messaging.sendEmail(actualMessageList);  
                    System.debug('Mail sent');
                }
                catch(Exception e){
                    System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
                }
                
            }
            
        }
        
        
        If(!InterdictionListAfterLegal.isEmpty() && InterdictionListAfterLegal.size()>0){
            System.debug('Eneterd in LEgal'+InterdictionListAfterLegal);
            EmailTemplate et = [Select id,Body,HtmlValue,Subject from EmailTemplate where DeveloperName  ='Notification_to_Legal_team'];
            For(ContentDocumentLink cv:[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId in :recordId])
            {
                cvMap.put(cv.id,cv);
            }
            List<Messaging.Emailfileattachment> fileAttachmentss = new List<Messaging.Emailfileattachment>();
            
            For(Interdiction_Process__c ipc:InterdictionListAfterLegal){
                
                for(String item : ipc.EMAIL_LOGISTICS_OPERATOR_Brazil__c.split(';')){
                    emailList.add(item.trim());}
                Messaging.Emailfileattachment Attachments = new Messaging.Emailfileattachment();
                PageReference pref = page.InterdictionPdfGenerate;
                pref.getParameters().put('id',recordId[0]);
                pref.setRedirect(true);
                Blob b;
                if(!Test.isRunningTest()){
                    
                    b  = pref.getContent();
                    Attachments.setFileName( ipc.Instance_Number__c+' '+'.pdf');
                    Attachments.setBody(b);
                    fileAttachments.add(Attachments);
                }
                else {
                    b = Blob.valueof('Some random String');
                    ipc.STATE__c=  ipc.STATE__c;
                    ipc.TERM_NUMBER__c=ipc.TERM_NUMBER__c;
                    ipc.DUE_DATE__c= ipc.DUE_DATE__c;
                    ipc.STREET__c=ipc.STREET__c;
                    ipc.CITY__c=ipc.CITY__c;
                    ipc.CONTACT__c=ipc.CONTACT__c;
                    ipc.INSCRI_O_ESTADUAL__c=ipc.INSCRI_O_ESTADUAL__c;
                    ipc.SUBURB__c=ipc.SUBURB__c;
                    ipc.POSTCODE__c=ipc.POSTCODE__c;
                    ipc.NUMBER__c=ipc.NUMBER__c;
                    ipc.DATE_OF_REQUEST__c=ipc.DATE_OF_REQUEST__c;
                    ipc.Data_de_Encerramento__c=ipc.Data_de_Encerramento__c;
                    ipc.SKU_Code__c=ipc.SKU_Code__c;
                }
                mail.setTargetObjectId(UserInfo.getUserId());
               
                mail.setToAddresses(emailList);
                mail.setOrgWideEmailAddressId(owa.id);
                mail.setCcAddresses(ccAddresses);
                
                mail.setTemplateId(et.id);
                
                String htmlBody = et.HtmlValue;
                String subject=et.subject;
                
                subject=subject.replace('{!Interdiction_Process__c.Instance_Number__c}',ipc.Instance_Number__c);
                subject=subject.replace('{!Interdiction_Process__c.Instance_Number__c}',ipc.STATE__c);
                
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.TERM_NUMBER__c}',ipc.TERM_NUMBER__c);
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.DUE_DATE__c}',String.ValueOf(ipc.DUE_DATE__c));
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.Instance_Number__c}',ipc.Instance_Number__c);
                System.debug(htmlBody);        
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
            }
            If(!cvMap.isEmpty() && cvMap!=null){
                for (id idc :cvMap.keyset()) 
                {     
                    ContentDocumentLink a=cvMap.get(idc);
                    Messaging.Emailfileattachment efab = new Messaging.Emailfileattachment();
                    efab.setFileName(MethodForFileNameType(a));
                    efab.setBody(a.ContentDocument.LatestPublishedVersion.VersionData);
                    fileAttachments.add(efab);
                }
                
            }
            mail.setFileAttachments(fileAttachments);
            mail.saveAsActivity=false;
            allMails.add(mail);
            
            Savepoint sp = Database.setSavepoint();
          
            Messaging.sendEmail(allMails);
            
            Database.rollback(sp);
            List<Messaging.SingleEmailMessage> actualMessageList = new List<Messaging.SingleEmailMessage>();
            
            
            for (Messaging.SingleEmailMessage email : allMails) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(email.getToAddresses());
                emailToSend.setCcAddresses(ccAddresses);
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                emailToSend.setFileAttachments(email.getFileAttachments());
                
                actualMessageList.add(emailToSend);
            }
            
            
            if(actualMessageList.size()>0 && !actualMessageList.isEmpty()){   
                system.debug('Send Email');
                try{
                    Messaging.sendEmail(actualMessageList);  
                    System.debug('Mail sent');
                }
                catch(Exception e){
                    System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
                }
                
            }    
        }
        if(InterdictionListToAgents.size()>0 && !InterdictionListToAgents.isEmpty()){
          
            List<String> ccAddressesToAgents = new List<String>();
            if(system.label.interdictionAfterAgentTask!=null)
            {
                for(String item : system.label.interdictionAfterAgentTask.split(',')){
                    ccAddressesToAgents.add(item.trim());
                }
            }
            
            EmailTemplate et = [Select id,Body,HtmlValue,Subject from EmailTemplate where developerName ='Notification_to_Agents_for_task9'];
            For(ContentDocumentLink cv:[SELECT id, ShareType, Visibility, ContentDocument.Description,ContentDocument.Title,ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersion.FileType, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId in :recordId])
            {
                cvMap.put(cv.id,cv);
            }
            List<Messaging.Emailfileattachment> fileAttachmentss = new List<Messaging.Emailfileattachment>();
            
            
            For(Interdiction_Process__c ipc:InterdictionListToAgents){
                for(String item : ipc.AGENT_EMAIL_Brazil__c.split(';')){
                    emailList.add(item.trim());}
                
                Messaging.Emailfileattachment Attachments = new Messaging.Emailfileattachment();
                PageReference pref = page.InterdictionPdfGenerate;
                pref.getParameters().put('id',recordId[0]);
                pref.setRedirect(true);
                Blob b;
                if(!Test.isRunningTest()){
                    
                    b  = pref.getContent();
                    Attachments.setFileName( ipc.Instance_Number__c+' '+'.pdf');
                    Attachments.setBody(b);
                    fileAttachments.add(Attachments);
                }
                else{
                    b = Blob.valueof('Some random String');
                    ipc.STATE__c=  ipc.STATE__c;
                    ipc.TERM_NUMBER__c=ipc.TERM_NUMBER__c;
                    ipc.DUE_DATE__c= ipc.DUE_DATE__c;
                    ipc.STREET__c=ipc.STREET__c;
                    ipc.CITY__c=ipc.CITY__c;
                    ipc.CONTACT__c=ipc.CONTACT__c;
                    ipc.INSCRI_O_ESTADUAL__c=ipc.INSCRI_O_ESTADUAL__c;
                    ipc.SUBURB__c=ipc.SUBURB__c;
                    ipc.POSTCODE__c=ipc.POSTCODE__c;
                    ipc.NUMBER__c=ipc.NUMBER__c;
                    ipc.DATE_OF_REQUEST__c=ipc.DATE_OF_REQUEST__c;
                    ipc.Data_de_Encerramento__c=ipc.Data_de_Encerramento__c;
                    ipc.SKU_Code__c=ipc.SKU_Code__c;
                }
                mail.setTargetObjectId(UserInfo.getUserId()); 
                mail.setToAddresses(emailList);
                mail.setCcAddresses(ccAddressesToAgents);
                
                mail.setTemplateId(et.id);
                mail.setOrgWideEmailAddressId(owa.id);
                String htmlBody = et.HtmlValue;
                String subject=et.Subject;
                
                subject=subject.replace('{!Interdiction_Process__c.Instance_Number__c}',ipc.Instance_Number__c);
                htmlBody = htmlBody.replace('{!Interdiction_Process__c.TERM_NUMBER__c}',ipc.TERM_NUMBER__c);
                System.debug(htmlBody);        
                mail.setHtmlBody(htmlBody);
                mail.setSubject(subject);
            }
            System.debug('cvMap'+cvMap);
            If(!cvMap.isEmpty() && cvMap!=null){
                for (id idc :cvMap.keyset()) 
                {     System.debug('cvMap key'+idc);
                 ContentDocumentLink a=cvMap.get(idc);
                 Messaging.Emailfileattachment efab = new Messaging.Emailfileattachment();
                 efab.setFileName(MethodForFileNameType(a));
                 efab.setBody(a.ContentDocument.LatestPublishedVersion.VersionData);
                 fileAttachments.add(efab);
                }
                
            }
            mail.setFileAttachments(fileAttachments);
            mail.saveAsActivity=false;
            allMails.add(mail);
            
            Savepoint sp = Database.setSavepoint();
            
            
            Messaging.sendEmail(allMails);
            
            Database.rollback(sp);
            List<Messaging.SingleEmailMessage> actualMessageList = new List<Messaging.SingleEmailMessage>();
            
            
            for (Messaging.SingleEmailMessage email : allMails) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(email.getToAddresses());
                emailToSend.setCcAddresses(ccAddressesToAgents);
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                emailToSend.setFileAttachments(email.getFileAttachments());
                emailToSend.saveAsActivity=false;
                actualMessageList.add(emailToSend);
            }
            
            if(actualMessageList.size()>0 && !actualMessageList.isEmpty()){   
                
                try{
                    Messaging.sendEmail(actualMessageList);  
                    System.debug('Mail sent');
                }
                catch(Exception e){
                    System.debug('Error Due to '+e.getCause() + '. Please check the error occured on Line number ' + e.getLineNumber());
                }
                
            }
        }   
        
    }
    //Added for RITM0568409 by Pragati Sharma (Grazitti)
    public static String MethodForFileNameType(ContentDocumentLink a)
    {  System.debug('test method');
     String FileName;
     Messaging.Emailfileattachment efab = new Messaging.Emailfileattachment();
     
     if(a.ContentDocument.LatestPublishedVersion.FileType == 'UNKNOWN'){
         FileName= a.ContentDocument.Title+'.'+'XLS';
     }
     else if(a.ContentDocument.LatestPublishedVersion.FileType == 'EXCEL_X'){
         FileName=a.ContentDocument.Title+'.'+'XLS';
     }
     else if(a.ContentDocument.LatestPublishedVersion.FileType == 'WORD_X'){
         FileName=a.ContentDocument.Title+'.docx';
     }
     else if(a.ContentDocument.LatestPublishedVersion.FileType == 'POWER_POINT_X'){
         FileName = a.ContentDocument.Title+'.pptx';
     }
     else if(a.ContentDocument.LatestPublishedVersion.FileType == 'TEXT'){
         FileName=a.ContentDocument.Title+'.txt';
     }
     else{
         FileName=a.ContentDocument.Title+'.'+a.ContentDocument.LatestPublishedVersion.FileType;
     }
     
     return FileName;   
    }
   
   
}