@isTest
public class RecallApprovalProcessByEmailService_Test {
@isTest
    public static void validateProcessData(){
        
         Account accObj = new Account();
        accObj.Name='Agrolic Pharma Pvt Ltd';
        accObj.SAP_Code__c='319362';
        accObj.Account_Type__c='Sold To Party';
        insert accObj;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c();
            salesOrgObj.Name = 'Brazil';            
            salesOrgObj.Company_Code__c = '5190';        
            salesOrgObj.Sales_Org_Code__c = '5191';      
            salesOrgObj.Country_Code__c = 'BR';     
            insert salesOrgObj;
        
        Return_Sales_Order__c rsoList = new Return_Sales_Order__c();
        rsoList.SalesOrg__c=salesOrgObj.Id;
        rsoList.Return_Type__c='Commercial';
        rsoList.RSO_SFDC_Number__c='122345';
        rsoList.RSO_Raised_By__c='Sales Rep';
        rsoList.Call_RSO_Approval_Process__c=true;
        rsoList.Sub_Status__c='Pending At Quality Team';
        rsoList.Comment__c='Go for Approval';
        rsoList.Customer__c=accObj.Id;
        rsoList.Order_Status__c='Pending';
        insert rsoList;
        
        
        update rsoList;
    
       // submitApproval(rsoList);
      
       Messaging.InboundEmail email = new Messaging.InboundEmail();
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
       List<string> emails = new List<string>{'testbandi@gmail.com','testbandi123@gmail.com'};
      
      email.subject = rsoList.Id;
      email.fromAddress = 'someaddress@email.com';
      email.toAddresses = emails;
      email.plainTextBody = 'email body';
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfileone.txt';
      attachment.mimeTypeSubType = 'text/plain';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     
      RecallApprovalProcessByEmailService testInbound=new RecallApprovalProcessByEmailService ();
      testInbound.handleInboundEmail(email, env);
        
       
}
     
     //private static void submitApproval(Return_Sales_Order__c rso){
      //  Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
      //  req.setComments('Submitting approval request');        
      //  req.setObjectId(rso.id);     
      //  Approval.ProcessResult result = Approval.process(req);   
   // }
    
}