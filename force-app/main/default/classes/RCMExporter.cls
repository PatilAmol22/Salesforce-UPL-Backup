/*
* Ticket : SCTASK0229141 Sharing Report to all RCMs
* Name: Exporter
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Last Modified Date:- 16.07.2020
* Description: Scheduled reports are fired everyday 7 AM
* Supporting Class: RCMExporterTest (Test Class)
*/


global class RCMExporter implements System.Schedulable {
    global void execute(SchedulableContext sc) {
        DoRCMExport();
    }
    
    @future(callout=true)
    public static void DoRCMExport(){
        
        List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
        List<Report_Exporter__c> exportUpdateList = new List<Report_Exporter__c>{};
        List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
        exportList = [Select Id, Name, Report_Id__c, Attachment_Name__c, Email_Subject__c, Email_Content__c, Email_Recipients__c,CC_Recipients__c,
                      Frequency__c from Report_Exporter__c WHERE Type__c = 'RCM'];
        
        for(Report_Exporter__c e : exportList){
            Boolean process = true;           
            if(process){
                System.debug('Starting message processing for: ' + e.Name);
                ApexPages.PageReference report = new ApexPages.PageReference('/' + e.Report_Id__c + '?csv=1');
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName(e.Attachment_Name__c);
                Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : report.getContent();
                attachment.setBody(content);
                attachment.setContentType('text/csv');
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
                message.setSubject(e.Email_Subject__c);
                message.setPlainTextBody(e.Email_Content__c);
                String[] emailRecipients = e.Email_Recipients__c.split(',');
                message.setToAddresses(emailRecipients);
                String[] CcRecipients = e.CC_Recipients__c.split(',');
                message.setCcAddresses(CcRecipients);
                mails.add(message);
                System.debug('Completed message processing for: ' + e.Name);
                exportUpdateList.add(e);
            }
        }
        Messaging.sendEmail(mails);
        System.debug('Send emails.');
        update exportUpdateList;
    }
}