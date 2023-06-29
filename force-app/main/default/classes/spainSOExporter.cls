global class spainSOExporter implements System.Schedulable {
    global void execute(SchedulableContext sc) {
        soExport();
    }
    
    @future(callout=true)
    public static void soExport(){
        
        List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
        List<Report_Exporter__c> exportUpdateList = new List<Report_Exporter__c>{};
        List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
        string spainType= system.label.Spain_Approved_SO;
            
        exportList = [Select Id, Name, Report_Id__c, Attachment_Name__c, Email_Subject__c, Email_Content__c, Email_Recipients__c,
                      Frequency__c,CC_Recipients__c from Report_Exporter__c WHERE Type__c = :spainType];
        
        for(Report_Exporter__c e : exportList){
            Boolean process = true;   
            if(process){
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
                /* String[] ccRecipients = e.CC_Recipients__c.split(',');
                message.setCcAddresses(ccRecipients); */
                mails.add(message);
                exportUpdateList.add(e);
            }
        }
        Messaging.sendEmail(mails);
        update exportUpdateList;
    }
}