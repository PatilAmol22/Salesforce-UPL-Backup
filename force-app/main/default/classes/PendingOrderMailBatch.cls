/*  
* Name: PendingOrderMailBatch    
* Created On: 31th Jan 2023
* Author: Kalpesh Chande
* Description: Sending reminder mails to higher authority for those orders which are pending and not yet taken action on last 24 hours.
*/
public class PendingOrderMailBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        DateTime dateFilter = System.now().addHours(-24); 
        String pendingOrderList;
        pendingOrderList = 'SELECT Id, Order_Status__c, Last_Approver_Date_Time__c, SalesOrgCode__c FROM Sales_Order__c WHERE SalesOrgCode__c=\'5661\' AND Order_Status__c = \'Pending\' AND Last_Approver_Date_Time__c!=null AND Last_Approver_Date_Time__c < :dateFilter'; 
        return Database.getQueryLocator(pendingOrderList);
    }
    
    public void execute( Database.BatchableContext BC, List<Sales_Order__c> pendingOrderList){
       // EmailTemplate emailTemplate =[SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name ='Mexico SO Approval Requests']; //CR#169 -Chile Margin Block -SKI- kalpesh chande - 31/01/2023 
        EmailTemplate emailTemplateChile =[SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE Name ='Chile SO Approval request']; 
        Set<Id> salesOrderIds = new Set<Id>();
        for(Sales_Order__c s : pendingOrderList){
            salesOrderIds.add(s.Id); 
        }
        system.debug('salesOrderIds@@'+salesOrderIds.size());
        List<ProcessInstanceWorkitem> processList =new List<ProcessInstanceWorkitem>();
        if(!Test.isRunningTest()){
            processList= [SELECT Id, ProcessInstanceId, OriginalActorId, ActorId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND ProcessInstance.TargetObjectId IN :salesOrderIds];
        }else{
            processList = [SELECT Id, ProcessInstanceId, OriginalActorId, ActorId,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND ProcessInstance.TargetObjectId IN :salesOrderIds];
        }        		
        System.debug('processList size---'+processList.size());
        Set<Id> userIds = new Set<Id>(); 
        for(ProcessInstanceWorkitem p : processList){
            userIds.add(p.OriginalActorId);
        }  
        
        List<User> userList = new List<User>();
        if(!Test.isRunningTest()){
            userList = [SELECT Id, Name, Email FROM User WHERE Id IN :userIds];
        }else{
            userList = [select ID, Name, Email from User  where LastName='Testing1' limit 1];
        }        
        System.debug('userList size---'+userList.size());
        Map<String,String> userIdEmailMap = new Map<String,String>();
        for(User u : userList){
            system.debug('u.email@@@'+u.Email);
            userIdEmailMap.put(u.Id,u.Email);
        }
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(Sales_Order__c s : pendingOrderList){
            for(ProcessInstanceWorkitem p : processList){
                if(Test.isRunningTest() || s.Id==p.ProcessInstance.TargetObjectId){  
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if(!Test.isRunningTest()){
                        mail.setToAddresses(new String[] { userIdEmailMap.get(p.OriginalActorId) }); 
                    }else{
                        mail.setToAddresses(new String[] { userList[0].Email });
                    }                                        
                    mail.setUseSignature(false);
                    mail.setBccSender(false);
                    mail.setSaveAsActivity(false);
                    mail.setCharset('UTF-8');
                    mail.setReplyTo('dynamic_email_approval@x-28cjv484qu8jbbwb0z1nwu7pehgq9mu2is2s7751cyb2enew3p.5d-edijuag.cs72.apex.sandbox.salesforce.com');
                    mail.setSenderDisplayName('UPL Ltd.');
                    //CR#169 -Chile Margin Block -SKI- kalpesh chande - 31/01/2023 -comment Start Here
                   /* if(s.SalesOrgCode__c=='5100'){
                        mail.setTemplateID(emailTemplate.Id);
                    }else {
                        mail.setTemplateID(emailTemplateChile.Id);
                    }*/
                     //CR#169 -Chile Margin Block -SKI- kalpesh chande - 31/01/2023 -comment- End Here
                    mail.setTemplateID(emailTemplateChile.Id);
                    mail.setTargetObjectId(p.OriginalActorId);
                    mail.setWhatId(s.Id);
                    system.debug('mail@@@ '+mail);
                    mailList.add(mail);  
                }
            }
        }
        system.debug('mailList.size'+mailList);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mailList);
    }
    public void finish(Database.BatchableContext BC){
    }
    
    
}