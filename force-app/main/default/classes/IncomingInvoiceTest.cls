@isTest(seeAllData=true)
public class IncomingInvoiceTest {
  static testMethod void TestIncomingInvoice() {
      Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      List<Sales_Org__c> SalesOrgPoland = [SELECT Id From Sales_Org__c WHERE Name = 'Poland'];
      
      Account testAccount = new Account();
      testAccount.Name='Test Account' ;
      testAccount.RecordTypeId = RecordTypeIdAccount;
      testAccount.Sales_Org__c = SalesOrgPoland[0].Id;
      testAccount.SAP_Code__c = '12345';
      testAccount.Account_Type__c = 'Sold To Party';
      insert testAccount; 
            
     /* Invoice__c i = new Invoice__c();
      i.Billing_Doc_Number__c = '2110786065';
      i.Sold_To_Party__c = testAccount.Id;
      i.Sales_Org__c = SalesOrgPoland[0].Id; 
      insert i; */
      
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = '#12345-2110786';
        email.plainTextBody = 'body';
        
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
        email.fromAddress='virag.mhatre@skinternational.com';
            
        env.fromAddress = 'virag.mhatre@skinternational.com';

        IncomingInvoice creatC = new IncomingInvoice ();
        creatC.handleInboundEmail(email, env );

      
      //Wrong Data
        Messaging.InboundEmail email2 = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env2 = new Messaging.InboundEnvelope();
        email2.subject = '-484684';
        email2.plainTextBody = 'body';
        email2.fromAddress='virag.mhatre@skinternational.com';
        env2.fromAddress = 'virag.mhatre@skinternational.com';

        IncomingInvoice creatC2 = new IncomingInvoice ();
        creatC2.handleInboundEmail(email2, env2 );
      
       Messaging.InboundEmail email3 = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env3 = new Messaging.InboundEnvelope();
        email3.subject = '12344-154876';
        email3.plainTextBody = 'body';
        email3.fromAddress='virag.mhatre@skinternational.com';
        env3.fromAddress = 'virag.mhatre@skinternational.com';

        IncomingInvoice creatC3 = new IncomingInvoice ();
        creatC2.handleInboundEmail(email3, env3 );
      
      //No Attachments
       Messaging.InboundEmail email4 = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env4 = new Messaging.InboundEnvelope();
        email4.subject = '#12345-2110786065';
        email4.plainTextBody = 'body';
        email4.fromAddress='virag.mhatre@skinternational.com';
        env4.fromAddress = 'virag.mhatre@skinternational.com';
   
      IncomingInvoice creatC4 = new IncomingInvoice ();
        creatC4.handleInboundEmail(email4, env4 );


    }
}