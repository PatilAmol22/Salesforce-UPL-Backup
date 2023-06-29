/*
* Ticket : SCTASK0292279 Crop Liquidation reports for SWAL
* Name: CropExporter
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Last Modified Date:- 04.12.2020
* Description: Scheduled reports are fired every 1st to 6th of Month to the respective ZMM/ZH at 10 AM
* Supporting Class: CropExporterTest (Test Class)
*/


global class CropExporter implements System.Schedulable ,Database.AllowsCallouts{
    global void execute(SchedulableContext sc) {
        exportCrop();
        
    }
    
    
    @future(callout =true)
    public static void exportCrop(){
        List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
        List<Report_Exporter__c> exportUpdateList = new List<Report_Exporter__c>{};
        List<Messaging.SingleEmailMessage> mails  = new List<Messaging.SingleEmailMessage>();
        String[] emailRecipients;
        exportList = [Select Id, Name, Report_Id__c, Attachment_Name__c, Email_Subject__c, Email_Content__c,ZMM2_SBU_or_Zone__c,SBU_Marketing_Head__c,
                      Email_Recipients__c,Zonal_Marketing_Manager__c, Frequency__c 
                      FROM Report_Exporter__c WHERE Type__c = 'Crop' AND ZMM2_SBU_or_Zone__c != null];
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
                if(e.ZMM2_SBU_or_Zone__c == 'SBU'){
                    emailRecipients = e.SBU_Marketing_Head__c.split(',');
                    message.setToAddresses(emailRecipients);
                }else if(e.ZMM2_SBU_or_Zone__c == 'Zone'){
                    emailRecipients = e.Zonal_Marketing_Manager__c.split(',');
                    message.setToAddresses(emailRecipients);
                }
                message.setCcAddresses(e.Email_Recipients__c.split(','));
                message.setPlainTextBody(e.Email_Content__c);
                message.setSenderDisplayName('Crop Liquidation report');
                message.setSubject('Crop Liquidation report');
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