/*
* Ticket : INCTASK0075617 ZMM point 4 reports scheduling
* Name: Exporter
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Last Modified Date:- 20.05.2020
* Description: Scheduled reports are fired every 1st to 5th of Month
* Supporting Class: ExporterTest (Test Class)
*/


global class Exporter implements System.Schedulable {
    global void execute(SchedulableContext sc) {
        DoExport();
    }
    
    @future(callout=true)
    public static void DoExport(){
        
        List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
        List<Report_Exporter__c> exportUpdateList = new List<Report_Exporter__c>{};
        List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
        //Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        //Date d = Date.today();
        //Date firstDate = d.toStartOfMonth();
        //Date lastDay = firstDate.addDays(Date.daysInMonth(d.year(), d.month())-1);
        //Date lastDay = firstDate + 5;
        
        //system.debug('First Day: ' + firstDate);
        //system.debug('Last Day: ' + lastDay);
            
        exportList = [Select Id, Name, Report_Id__c, Attachment_Name__c, Email_Subject__c, Email_Content__c, Email_Recipients__c,
                      Frequency__c from Report_Exporter__c WHERE Type__c = 'ZMM 4'];
        
        for(Report_Exporter__c e : exportList){
            //Determine if Exporter record is scheduled to run today.
            //Boolean process = Test.isRunningTest() ? false : true;
            Boolean process = true;           
            //Run process if scheduled.
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
                mails.add(message);
                System.debug('Completed message processing for: ' + e.Name);
                exportUpdateList.add(e);
            }
        }
        //Send the email messages all at once to avoid limits.
        Messaging.sendEmail(mails);
        System.debug('Send emails.');
        
        //Update Export record with Last Ran date.
        update exportUpdateList;
    }
}