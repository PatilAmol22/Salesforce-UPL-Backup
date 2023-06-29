/*
Created By : abhishek 
Date : 31-10-2017
batch for sending mails for last loggin users
*/
global class SendLoginNotificationBatch implements Database.Batchable<sObject>, Schedulable {

    //Variable Section
    global FINAL String strQuery;
    global List<String> errorMessages = new List<String>();
    global String body='';
    global SendLoginNotificationBatch() { 
        this.strQuery = getBatchQuery();
    }
    
    //Returns the Query String to Batch constructor to fetch right records.
    private String getBatchQuery() {
        String strQuery = 'SELECT Id, Email_Id__c, Last_Login__c,User_Full_Name__c,OwnerId,Owner.Email,CreatedDate FROM Last_Login__c WHERE CreatedDate = TODAY'; 
        return strQuery;
    }
    
    //Batch Start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }

    //Batch Execute method calls findCostForWoD method
    global void execute(Database.BatchableContext BC, List<sObject> scopeList) {
        System.debug(LoggingLevel.INFO, '== scopeList size ==' + scopeList.size());
        
        List<Last_Login__c> oppList = (List<Last_Login__c>) scopeList;
        if(!oppList.isEmpty()) { 
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
           List<OrgWideEmailAddress> owa = [select id, DisplayName, Address from OrgWideEmailAddress ];
           EmailTemplate templateId = [Select id from EmailTemplate where name = 'Email on Last Login - Uniphos'];
            String[] ccAddresses = new String[] {'afindanalytics@uniphos.com'};
            for (Last_Login__c prod : oppList)
            {               
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                String[] toAddresses = new String[] {prod.Email_Id__c};
                message.setToAddresses(toAddresses); 
                message.SaveAsActivity = false;
                message.setSaveAsActivity(false);
                 message.setccAddresses(ccAddresses);
                message.subject ='Salesforce Uniview CRM Login';
                 message.setHtmlBody('<html><body> Dear '+prod.User_Full_Name__c+',<br></br>You have not used Uniview (Salesforce CRM platform) from last three days.<br></br> Please login to stay updated. <br></br> Regards,<br></br>CRM Team</body><html> ');
                  
                if(prod.Email_Id__c.contains('@uniphos.com')){
                  
                 message.setOrgWideEmailAddressId(owa[0].id);
                }
                if(prod.Email_Id__c.contains('@swal.in')){
                    message.setOrgWideEmailAddressId(owa[1].id);
                }
                if(prod.Email_Id__c.contains('@skinternational.com')){
                        message.setOrgWideEmailAddressId(owa[0].id);
                }
                
                     
                mailList.add(message);
                
            }
            if(!mailList.isEmpty()) {
                try{
                    Messaging.sendEmail(mailList);
                }
                catch (Exception ex) {
                    errorMessages.add('Unable to send email to Tech: '+ ex);
                    system.debug('Unable to send email to Tech: '+ ex);
                }
            }
        }
    }  

    //Batch Finish method for after execution of batch work
    global void finish(Database.BatchableContext BC) { 
        AsyncApexJob aaj = [Select Id, Status, NumberOfErrors, JobItemsProcessed, MethodName, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {aaj.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('JOB Salesforce Send Notification Batch: ' + aaj.Status);
        String bodyText='Total Job Items ' + aaj.TotalJobItems + ' Number of records processed ' + aaj.JobItemsProcessed + ' with '+ aaj.NumberOfErrors + ' failures.\n';
        bodyText += 'Number of Error Messages ' + errorMessages.size() + '\n';
        bodyText += 'Error Message' + String.join(errorMessages, '\n');
        mail.setPlainTextBody(bodyText);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //Method which schedules the ProductDownloadBatch
    global void execute(SchedulableContext sc) {        
        SendLoginNotificationBatch snInstance = new SendLoginNotificationBatch();
        ID batchprocessid = Database.executeBatch(snInstance,5);
    }
}