@isTest
public class MexicoCaseNotification_Controller_Test {
  static testMethod void TestMexicoCaseNotification_Controller() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
     
        email.subject = 'subject ';
        email.plainTextBody = 'body';
        env.fromAddress = 'virag.mhatre@skinternational.com';

        MexicoCaseNotification_Controller creatC = new MexicoCaseNotification_Controller ();
        creatC.handleInboundEmail(email, env );


    }

}