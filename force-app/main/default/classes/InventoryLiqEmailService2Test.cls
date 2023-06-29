@isTest
public class InventoryLiqEmailService2Test {
static testMethod void method(){
        // setup controller object
        InventoryLiqEmailService2 objconfirm = new InventoryLiqEmailService2();
        System.debug('Debug Email Service');
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'Business Dashboard Channel Partner_2017-03-06-16-12-22_';
        email.plainTextBody = 'This is a test mail.';
        envelope.fromAddress = 'upl@uniphos.com';
        
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
		binaryAttachment.Filename = 'Business Dashboard Channel Partner_2017-03-06-16-12-22_.txt';
        String csvAttachment = 'Territory,Customer,ActualSalesFEB2016,ActualPYYTDFEB2016,ActualSalesFEB2017,ActualYTDFEB2017,%GrowthFEB2017,%GrowthYTDFEB2017,Row No\r\n112,0001001299,,3283925.00,,3486344.00,0.00,6.16,2\r\n';
        
        binaryAttachment.body = Blob.valueOf(csvAttachment);
        //binaryattachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
        objconfirm.handleInboundEmail(email, envelope);
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        //System.assertEquals( result.success  ,true);
    }
}