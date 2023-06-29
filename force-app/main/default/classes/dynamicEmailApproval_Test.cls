@isTest(SeeAllData=true)
public class dynamicEmailApproval_Test {
    static testmethod void test(){
        
        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
       	Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
        Messaging.InboundEmail email2 = new Messaging.InboundEmail();
       	Messaging.InboundEnvelope env2 = new Messaging.InboundEnvelope();
        Messaging.InboundEmail email3 = new Messaging.InboundEmail();
       	Messaging.InboundEnvelope env3 = new Messaging.InboundEnvelope();
        
        DateTime dateFilter = System.now().addHours(-24); 
        List<Sales_Order__c> pendingOrderList = new List<Sales_Order__c>();                
        pendingOrderList = [SELECT Id, Name, Order_Status__c, SalesOrgCode__c FROM Sales_Order__c WHERE SalesOrgCode__c='5100' AND Order_Status__c = 'Pending'];
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u = new User(Alias = 'standt', Email='paresh.sondigara@skinternational.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser786@testorg.com');
        insert u;              
	        
        email1.subject = 'Re: Sandbox: Orden de Venta:'+pendingOrderList[0].Name;
        email1.plainTextBody = 'Approve' + '\n' + 'Test';
        env1.fromAddress = 'paresh.sondigara@skinternational.com';
        email1.fromAddress = 'paresh.sondigara@skinternational.com';
        
        email2.subject = 'Re: Sandbox: Orden de Venta:'+pendingOrderList[0].Name;
        email2.plainTextBody = 'Reject' + '\n' + 'Test';
        env2.fromAddress = 'paresh.sondigara@skinternational.com';
        email2.fromAddress = 'paresh.sondigara@skinternational.com';
        
        email3.subject = 'Re: Sandbox: Orden de Venta:'+pendingOrderList[0].Name;
        email3.plainTextBody = 'Reje' + '\n' + 'Test';
        env3.fromAddress = 'paresh.sondigara@skinternational.com';
        email3.fromAddress = 'paresh.sondigara@skinternational.com';
        
        String msg='message';
        
        dynamicEmailApproval obj1=new dynamicEmailApproval();
        obj1.handleInboundEmail(email1, env1);    
        
        dynamicEmailApproval obj2=new dynamicEmailApproval();
        obj2.handleInboundEmail(email2, env2);
        
        dynamicEmailApproval obj3=new dynamicEmailApproval();
        obj3.handleInboundEmail(email3, env3);
    }                 	      
}