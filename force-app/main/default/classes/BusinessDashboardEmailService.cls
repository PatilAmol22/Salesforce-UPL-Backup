/*
* Name: Business Dashboard Email Service
* Created On: 17 Feb 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Email Service for storing & splitting Binary/Text Attachments (BW Dashboard Reports)
*/
global class BusinessDashboardEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        try{
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            
            String emailSubject = email.Subject; 
            emailSubject = emailSubject.substring(emailSubject.indexOf(':') + 1);
            System.debug('emailSubject:'+emailSubject);
            
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0 ) {
                for (Integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                    if(email.binaryAttachments[i].filename.endsWith('.txt')||email.binaryAttachments[i].filename.endsWith('.csv')){
                        FileUtility.processAttachment(email.binaryAttachments[i].filename, email.fromAddress, emailSubject, email.binaryAttachments[i].body);
                    }
                }
            }
            if (email.TextAttachments != null && email.TextAttachments.size() > 0) {
                for (Integer i = 0 ; i < email.TextAttachments.size() ; i++) {
                    if(email.TextAttachments[i].filename.endsWith('.txt')||email.TextAttachments[i].filename.endsWith('.csv')){
                        FileUtility.processAttachment(email.TextAttachments[i].filename, email.fromAddress, emailSubject, Blob.valueOf(email.TextAttachments[i].body));
                    }
                }
            }
            
            List<SchedulerSettings__c> settingsList = [SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
            if(!settingsList.isEmpty()){
                if(settingsList[0].Enabled__c == True){
                    Database.executeBatch(new BusinessDashboardReadAndPopulateBatch(), Integer.valueOf(settingsList[0].Batch_Size__c));
                }
            }
            return result;
        }
        
        catch(Exception e){
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
            return null;
        }          
    }
}