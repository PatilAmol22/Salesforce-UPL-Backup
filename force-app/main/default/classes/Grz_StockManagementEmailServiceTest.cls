@isTest(SeeAllData=false)
public class Grz_StockManagementEmailServiceTest {
    public static testMethod void EmailAttachmentTester(){
        Grz_StockManagementEmailService grz = new Grz_StockManagementEmailService();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        grz.handleInboundEmail(email, envelope);
        email.subject = 'test';
        email.plainTextBody = 'test';
        envelope.fromAddress = 'stock_management@c-1w6dcqtcz0frvegn7z2uc5nwdu3nepgjxpluo3cgh1cxxgd81q.6d-1swbuam.cs73.apex.sandbox.salesforce.com';
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'compose1.csv';
        binaryAttachment.body = blob.valueOf('my attachment text;a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;aa;ab;ac;ad;ae;af;ag;ah;ai;aj;ak;al;am;an;ao;ap;aq;ar;as;at;au;av;aw;ax;ay;az\nmy attachment text;a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;aa;ab;ac;ad;ae;af;ag;ah;ai;aj;ak;al;am;an;ao;ap;aq;ar;as;at;au;av;aw;ax;ay;az\nmy attachment text;a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;aa;ab;ac;ad;ae;af;ag;ah;ai;aj;ak;al;am;an;ao;ap;aq;ar;as;at;au;av;aw;ax;ay;az\nmy attachment text;a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;aa;ab;ac;ad;ae;af;ag;ah;ai;aj;ak;al;am;an;ao;ap;aq;ar;as;at;au;av;aw;ax;ay;az\nmy attachment text;a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;aa;ab;ac;ad;ae;af;ag;ah;ai;aj;ak;al;am;an;ao;ap;aq;ar;as;at;au;av;aw;ax;ay;az');
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment };
        grz.handleInboundEmail(email, envelope);
        Messaging.InboundEmailResult result = grz.handleInboundEmail(email, envelope);
    }
    public static testMethod void EmailAttachmentBatchTest(){
        Test.startTest();  
        List<Stock_Management__c> stlist = new List<Stock_Management__c>();
        Stock_Management__c st = new Stock_Management__c();
        st.C_d_prod_ind_stria__c = 'test';
        st.Vencimento__c = Date.valueOf('2021-05-05');
        st.Descri_o_produto__c = 'test';
        st.Lote__c = 'test';
        stlist.add(st);
        Test.stopTest(); 
        Grz_StockMngementInsertBatchThree bin = new Grz_StockMngementInsertBatchThree(stlist) ;
        Database.executeBatch(bin,2000);
        Grz_StockMngementInsertBatchTwo bin1 = new Grz_StockMngementInsertBatchTwo(stlist) ;
        Database.executeBatch(bin1,2000);
    }
    public static testMethod void EmailAttachmentBatchTest2(){ 
        Test.startTest(); 
        Stock_Management__c st = new Stock_Management__c();
        st.C_d_prod_ind_stria__c = 'test';
        st.Vencimento__c = Date.valueOf('2021-05-05');
        st.Descri_o_produto__c = 'test';
        st.Lote__c = 'test';
        insert st;
        String mailTime = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        ID jobID = Database.executeBatch(new Grz_StockMngementDeleteBatch(mailTime),200);
        Test.stopTest();  
    }
}