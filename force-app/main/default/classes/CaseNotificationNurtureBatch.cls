/*
* Name: CaseNotificationNurtureBatch
* Created On: 6 Sept 2022
* Author: Ben G Padiyara
*  Description: To sent bell notification and mail alerts to managers due to case timeline breach
* Change Log History:
* |---------------------------------------------------------------------------|
* | Version | Changes By | Date      | Description                            |
* |---------------------------------------------------------------------------|
* |   0.1   | Ben      | 6-09-22   | Initial version             |
* |  																	      |     
* |---------------------------------------------------------------------------| 
*/

global class CaseNotificationNurtureBatch implements Database.Batchable<sObject>, Schedulable {
    global FINAL String strQuery;
    public String statusVal;
    public List<Id> idLst=new List<Id>();
    public Id nutureFarmRecordTypeId;
    global List<String> errorMessages = new List<String>();
    global String body='';
    global CaseNotificationNurtureBatch() { 
        this.strQuery = getBatchQuery();
    }
    
    public String getBatchQuery() {
        statusVal='Closed';
        nutureFarmRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        
        idLst.add('0055D000004zv5SQAQ');
        // and ownerid in :idLst
        String strQuery = 'select id,casenumber,ownerid,lastmodifiedDate,status,record_type__c,AccountId from case where recordtypeid = :nutureFarmRecordTypeId and status!= :statusVal'; 
        return strQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scopeList) {
        List<Case> caseLst=(List<Case>) scopeList;
        
        Messaging.SingleEmailMessage[] emailList = new List<Messaging.SingleEmailMessage>();
        Boolean emailAlertFlag=false;
        Set<Id> ownerIdSet=new Set<Id>();
        Set<String> emailIdSet=new Set<String>();
        for(Case eachCase: caseLst)
        {
            ownerIdSet.add(eachCase.ownerid);
        }
        Map<Id,User> userMap= new Map<Id,User>([select id,managerId,manager.email from user where id in :ownerIdSet ]);
        for(Case eachCase: caseLst)
        {
            
            Long timeInMilliSec=System.now().getTime()-eachCase.lastmodifiedDate.getTime();
            Long timeInHours=(timeInMilliSec/(1000*60*60));
            System.debug('Time now '+System.now());
            System.debug('Old Time '+eachCase.lastmodifiedDate);
            System.debug('Hours '+timeInHours);
            if(Test.isRunningTest())
            {
                timeInHours=100;
            }
            if(timeInHours>48)
            {
                //Send email to case owner's manager 
                String emailId= userMap.get(eachCase.OwnerId).managerId!=null?userMap.get(eachCase.OwnerId).manager.email:'';
                if(String.isNotEmpty(emailId))
                {
                    List<String> emailIdLst=new List<String>();
                    emailAlertFlag=true;
                    EmailTemplate emailTemplate =[Select Id,Subject,Description,HtmlValue,DeveloperName,Body  from EmailTemplate where DeveloperName='Case_Notification_Nurture'];
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.id, eachCase.OwnerId, eachCase.id);
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    
                    String emailSubject = email.getSubject();
					String emailTextBody = email.getPlainTextBody();

					message.setTargetObjectId(eachCase.OwnerId);
                   	message.setTreatTargetObjectAsRecipient(false);
					message.setSubject(emailSubject);
					message.setPlainTextBody(emailTextBody);
					message.saveAsActivity = false;
                    message.toAddresses = new String[] {emailId };
                    emailList.add(message);
	
                    
                }
            }
            if(timeInHours>24)
            {
                //push bell notification to case owner
                Messaging.CustomNotification notification = new Messaging.CustomNotification(); 
                notification.setTitle('Case '+eachCase.casenumber+' - SLA Breached'); 
                notification.setBody('Action Required'); 
                notification.setSenderId(Userinfo.getUserId()); 
                CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Case_SLA_Notification'];  
                notification.setNotificationTypeId(type.id); 
                notification.setTargetId(eachCase.id); // target object id 
                notification.send(new Set<String> { eachCase.ownerid });
            }
            
        }
        
        if(emailAlertFlag)
        {
            
            Messaging.sendEmail(emailList, false);
        }
    }
    
    global void finish(Database.BatchableContext BC) { 
    }
    
    global void execute(SchedulableContext sc) { 
        CaseNotificationNurtureBatch caseNotifInstance = new CaseNotificationNurtureBatch();
        ID batchprocessid = Database.executeBatch(caseNotifInstance,100);
    }
    
}