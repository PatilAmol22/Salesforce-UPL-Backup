public class CampaignExporter implements System.Schedulable{
    public void execute(SchedulableContext sc) {
        doCampaignExporter();
    }
    @future(callout=true)
    public static void doCampaignExporter(){
        ApexPages.PageReference report = new ApexPages.PageReference('/00O0K00000AhBpE?csv=1');
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Campaign & Promotion related Cases.csv');
        if(!Test.isRunningTest())
        attachment.setBody(report.getContent());
        attachment.setContentType('text/csv');
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(!Test.isRunningTest())
        message.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment } );
        message.setSubject('"Campaign & Promotion related" calls yesterday');
        message.setPlainTextBody('Dear Manager,\r\n\r\nPlease find attached report for UPL campaign and promotion related calls in AKC for yesterday.\r\n\r\nThanks and Regard ,\r\nUPL AKC Team');
        message.setToAddresses( new String[] { 'swapani.kulkarni1@concentrix.com','kulkarni.mukul@concentrix.com','nilesh.bagwe@concentrix.com','purviish.shah@upl-ltd.com','akbarikk@upl-ltd.com' } );
        //message.setToAddresses( new String[] { 'swapani.kulkarni1@concentrix.com' } );
        message.setSenderDisplayName('Campaign & Promotion related calls yesterday');
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );
    }
}