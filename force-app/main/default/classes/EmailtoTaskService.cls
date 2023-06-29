global class EmailtoTaskService implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        List<String> listEmail = new List<String>();

        System.debug('email: '+email);
        System.debug('envelope: '+envelope);
        
        try{    
            
            //Id recordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
            Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Alerts').getRecordTypeId();
            Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            User userObj = [SELECT Id, FirstName FROM User where FirstName like 'Neebal'];
            System.debug('recordTypeId: '+recordTypeId);
            System.debug('distributorRecordTypeId: '+distributorRecordTypeId);
 			
            /*Logic for the subject */
            String emailSubject = email.Subject; 
            emailSubject = emailSubject.substring(emailSubject.indexOf(':') + 1);
            System.debug('emailSubject:'+emailSubject);
            
            //Code to Insert Email Content to Custom Object - Distributor Activity
            Distributor_Activity__c daObj = new Distributor_Activity__c();
            daObj.Subject__c = emailSubject;
            daObj.Alert_Sent_Date__c = System.now();
            daObj.Comments__c = 'Subject: '+emailSubject+'\n\n'+email.plainTextBody;
            daObj.SAP_Type__c = 'Email';
            if(email.toAddresses!=Null){
                if(String.isNotBlank(email.toAddresses[0])){
                    String toAddress = email.toAddresses[0];
                    daObj.SAP_Email__c = toAddress;
                } 
            }
            
            daObj.Status__c = 'Completed';
            
            insert daObj;
            System.debug('daObj: '+daObj);
            
            //Code to Insert Email Content to Standard Object - Task
            List<Account> accountList = new List<Account>();
            if(email.toAddresses!=Null){
            accountList = [Select Id, PersonEmail 
                                         From Account 
                                         Where PersonEmail =: email.toAddresses[0] 
                                         AND RecordTypeID =: distributorRecordTypeId LIMIT 1 FOR UPDATE];
            }
            System.debug('accountList: '+accountList);
            
            Task taskObj = new Task();
            if(emailSubject.length()>254){
                taskObj.Subject = emailSubject.substring(0, 254);
            }
            else{
                taskObj.Subject = emailSubject;
            }
            taskObj.Alert_Sent_Date_SAP__c = System.now();
            taskObj.Description = 'Subject: '+emailSubject+'\n\n'+email.plainTextBody;
            taskObj.SAP_Type__c = 'Email';
            taskObj.RecordTypeId = recordTypeId;
            taskObj.OwnerId = userObj.Id;
            if(email.toAddresses!=Null){
                if(String.isNotBlank(email.toAddresses[0])){
                    String toAddress = email.toAddresses[0];
                    if(toAddress.length()>50){
                        taskObj.SAP_CC_Address__c = toAddress;
                    }
                    else{
                        taskObj.SAP_Email__c = toAddress;
                    }
                }
            }

			taskObj.Status = 'Completed';
            if(accountList.size() > 0){
                taskObj.WhatId = accountList[0].id;                    
            }
   
			insert taskObj;
            System.debug('taskObj: '+taskObj);
            System.debug('task ID: '+taskObj.id);
        }
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
        }
        System.debug('result: '+result);
        return result;
    }
}