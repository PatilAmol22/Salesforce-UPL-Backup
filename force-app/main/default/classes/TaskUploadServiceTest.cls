@isTest
public class TaskUploadServiceTest {
    static testMethod void Method(){
        TaskUploadService.TaskDetails tasObj =new TaskUploadService.TaskDetails();
        
        List<TaskUploadService.TaskDetails> taskDetailsList =new List<TaskUploadService.TaskDetails>();
        Id alertsRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Alerts').getRecordTypeId();
        Task taskObj = new Task();
        taskObj.Subject='test';
        //taskObj.Alert_Sent_Date_SAP__c=System.now();
        taskObj.Description='test';
        taskObj.SAP_Type__c='Test';
        taskObj.SAP_Email__c='test@gmail.com';
        taskObj.SAP_Mobile__c='9823456715';
        taskObj.SMS_Id__c='211';
        taskObj.SAP_Objno__c='test';
        taskObj.SAP_Type__c='test';
        taskObj.RecordTypeId=alertsRecordTypeId;
        taskObj.Status='In Progress';
        taskObj.status = 'Completed';
        insert taskObj;
        
        tasObj.subject= taskObj.Subject;
        //tasObj.alert_sent_date_SAP=System.now();
        tasObj.description=taskObj.Description;
        tasObj.SAP_type= taskObj.SAP_Type__c;
        tasObj.SAP_email=taskObj.SAP_Email__c;
        tasObj.SAP_mobile=taskObj.SAP_Mobile__c;
        tasObj.SMS_id=taskObj.SMS_Id__c;
        tasObj.SAP_objno=taskObj.SAP_Objno__c;
        tasObj.SAP_type=taskObj.SAP_Type__c;
        tasObj.recordTypeId=taskObj.RecordTypeId;
        tasObj.sfdcId='test';
        tasObj.status = 'Completed';
        taskDetailsList.add(tasObj);
        TaskUploadService.uploadTask(taskDetailsList);
    }
    static testMethod void Method2(){
        TaskUploadService.TaskDetails tasObj =new TaskUploadService.TaskDetails();
        
        List<TaskUploadService.TaskDetails> taskDetailsList =new List<TaskUploadService.TaskDetails>();
        // Id alertsRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Task taskObj = new Task();
        taskObj.Subject='test';
        taskObj.Alert_Sent_Date_SAP__c=Date.today()+1;
        taskObj.Description='test';
        taskObj.SAP_Type__c='Test';
        taskObj.SAP_Email__c='test@gmail.com';
        taskObj.SAP_Mobile__c='9823456715';
        taskObj.SMS_Id__c='211';
        taskObj.SAP_Objno__c='test';
        taskObj.SAP_Type__c='test';
        taskObj.status = 'Completed';
        // taskObj.RecordTypeId=alertsRecordTypeId;
        insert taskObj;
        
        tasObj.subject= taskObj.Subject;
        tasObj.alert_sent_date_SAP=string.valueOf(taskObj.Alert_Sent_Date_SAP__c);
        tasObj.description=taskObj.Description;
        tasObj.SAP_type= taskObj.SAP_Type__c;
        tasObj.SAP_email=taskObj.SAP_Email__c;
        tasObj.SAP_mobile=taskObj.SAP_Mobile__c;
        tasObj.SMS_id=taskObj.SMS_Id__c;
        tasObj.SAP_objno=taskObj.SAP_Objno__c;
        tasObj.SAP_type=taskObj.SAP_Type__c;
        tasObj.status = 'Completed';
        // tasObj.recordTypeId=taskObj.RecordTypeId;
        tasObj.sfdcId='test';
        
        taskDetailsList.add(tasObj);
        TaskUploadService.uploadTask(taskDetailsList);
    }
    
}