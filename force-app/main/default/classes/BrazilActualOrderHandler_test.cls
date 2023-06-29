@isTest(SeeAllData=true)
public class BrazilActualOrderHandler_test {
    public static testMethod void EmailAttachmentTester(){
        BrazilActualOrderHandler grz = new BrazilActualOrderHandler();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'test';
        email.plainTextBody = 'test';
        email.fromAddress = 'pragati.sharma@grazitti.com';
        envelope.fromAddress = 'pragati.sharma@grazitti.com';
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
        List<Actual_Order__c> stlist = new List<Actual_Order__c>();
        Actual_Order__c st = new Actual_Order__c();
        stlist.add(st);
        Test.stopTest(); 
        BrazilActualOrderInsertBatch bin = new BrazilActualOrderInsertBatch(stlist) ;
        Database.executeBatch(bin,2000);
    }
    /*public static testMethod void EmailAttachmentBatchTest2(){ 
        Test.startTest(); 
        Open_Order__c st = new Open_Order__c();
        insert st;
        String mailTime = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        ID jobID = Database.executeBatch(new Grz_BrazilOpenOrderDeleteBatch(mailTime),200);
        Test.stopTest();  
    }*/
}