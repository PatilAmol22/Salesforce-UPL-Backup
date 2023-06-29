/*
* Name: ReportScheduler
* Created By :- Varun Shrivastava
* Last Modified Date:- 11.06.2020
* Description: Scheduled reports 
* Supporting Class: ReportScheduler Test (Test Class)
*/


global class ReportScheduler implements System.Schedulable ,Database.AllowsCallouts, Database.stateful{
    
    global void execute(SchedulableContext sc) {
        exportRep();
        
    }
    
    @future(callout=true)
    public static void exportRep(){
        List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
        List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
        List<Messaging.Emailfileattachment> attachmentList = new List<Messaging.Emailfileattachment>();
        String[] emailRecipients;
        exportList = [Select Id, Name, Report_Id__c, Attachment_Name__c, Email_Subject__c, Email_Content__c,ZMM2_SBU_or_Zone__c,SBU_Marketing_Head__c,
                      Email_Recipients__c,Zonal_Marketing_Manager__c, Frequency__c 
                      FROM Report_Exporter__c WHERE Type__c = 'Unproductive Call'];
        String mailBody = '';
        for(Report_Exporter__c e : exportList){
            	ApexPages.PageReference report = new ApexPages.PageReference('/' + e.Report_Id__c + '?csv=1');
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName(e.Attachment_Name__c);
                Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : report.getContent();
                attachment.setBody(content);
                attachment.setContentType('text/csv');
                attachmentList.add(attachment);
            	emailRecipients = e.Email_Recipients__c.split(',');
            	mailBody = e.Email_Content__c;
            }
        
        		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setFileAttachments(attachmentList);
                message.setToAddresses(emailRecipients);
                message.setPlainTextBody(mailBody);
                message.setSenderDisplayName('Un Productive Call Report');
                message.setSubject('Unproductive Call Report');
                mails.add(message);
        		Messaging.sendEmail(mails);
        		System.debug('Send emails.');
    }    
}