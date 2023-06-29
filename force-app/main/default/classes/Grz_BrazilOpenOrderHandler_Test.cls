/**
 * Class: 		Grz_BrazilOpenOrderHandler_Test
 * Main Class: 	Grz_BrazilOpenOrderHandler
 * Author: 		Tanuj Malik (Grazitti)
 * Created: 	13 Feb 2023
 * Ticket:		APPS-4744 Open order CR
 */
@isTest(SeeAllData=true)
public class Grz_BrazilOpenOrderHandler_Test {
    public static testMethod void EmailAttachmentTester(){
        Grz_BrazilOpenOrderHandler grz = new Grz_BrazilOpenOrderHandler();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'test';
        email.plainTextBody = 'test';
        email.fromAddress = 'tanuj.malik@grazitti.com';
        envelope.fromAddress = 'tanuj.malik@grazitti.com';
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'compose1.csv';
        binaryAttachment.body = blob.valueOf('buc,rc,rc,cc,src,pc,ck,ddr,QTYORD,NETSALESORD\nBR15,BR1502,117,1048643,57001790,6307185,5.19100000005251E+017,02/03/2023,280,27753\nBR15,BR1502,117,1048643,57001790,6307185,5.19100000005251E+017,02/03/2023,100,9912\nBR15,BR1502,117,1048643,57001790,6307185,5.1910000000525E+017,02/03/2023,690,29968\nBR1115,BR134502,1533417,156048643,56767001790,6345407185,5.19100000005251E+017,02/03/2023,280,27753\nBR15,BR134502,1533417,156048643,56767001790,6345407185,5.19100000005251E+017,02/03/2023,280,27753\nBR15,BR1502,1533417,156048643,56767001790,6345407185,5.19100000005251E+017,02/03/2023,280,27753\nBR15,BR1502,117,156048643,56767001790,6345407185,5.19100000005251E+017,02/03/2023,280,27753\nBR15,BR1502,117,1048643,56767001790,6345407185,5.19100000005251E+017,02/03/2023,280,27753\nBR15,BR1502,117,1048643,57001790,6345407185,5.19100000005251E+017,02/03/2023,280,27753\nBR15,BR1502,117,1048643,57001790,6307185,5.19100000005251E+017,02/03/2023,280,277533\nBR15,BR1502,57001790,6307185,5.19100000005251E+017,02/03/2023,280,2775');
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
        Messaging.InboundEmailResult result = grz.handleInboundEmail(email, envelope);
		email.fromAddress=null;
        grz.handleInboundEmail(email, envelope);

    }
    public static testMethod void EmailAttachmentBatchTest(){
        Test.startTest();  
        List<Open_Order__c> stlist = new List<Open_Order__c>();
        Open_Order__c st = new Open_Order__c();
        stlist.add(st);
        Test.stopTest(); 
        Grz_BrazilOpenOrderInsertBatch bin = new Grz_BrazilOpenOrderInsertBatch(stlist) ;
        Database.executeBatch(bin,2000);
    }
    public static testMethod void EmailAttachmentBatchTest2(){ 
        Test.startTest(); 
        Open_Order__c st = new Open_Order__c();
        insert st;
        String mailTime = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        ID jobID = Database.executeBatch(new Grz_BrazilOpenOrderDeleteBatch(mailTime),200);
        Test.stopTest();  
    }
}