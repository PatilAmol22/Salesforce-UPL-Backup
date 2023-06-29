global class TaskUploadService {
    webservice static ServiceResponse uploadTask(List<TaskDetails> taskDetailsList) {
        
        ServiceResponse sponse = new ServiceResponse();
        String exceptionString = '';
        Exception ex;
        
        try{
            Id alertsRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Alerts').getRecordTypeId();
             
            List<Task> upsertTaskList = new List<Task>();
            
            for(TaskDetails tdObj:taskDetailsList){
                
                Task taskObj = new Task();
                taskObj.Status = 'Completed';
                if(String.isNotBlank(tdObj.subject)){
                    //if(taskObj.subject.length()>254){
                    //    taskObj.subject = taskObj.Subject.substring(0, 254);
                    //}
                    //else{
                        taskObj.Subject = tdObj.subject;
                    //}
                }
                if(String.isNotBlank(tdObj.alert_sent_date_SAP)){
                    taskObj.Alert_Sent_Date_SAP__c = Date.valueOf(tdObj.alert_sent_date_SAP);
                }
                else{
                    taskObj.Alert_Sent_Date_SAP__c = System.now();
                }
                if(String.isNotBlank(tdObj.description)){
                    taskObj.Description = tdObj.description;
                }
                if(String.isNotBlank(tdObj.SAP_type)){
                    taskObj.SAP_Type__c = tdObj.SAP_type;
                }
                if(String.isNotBlank(tdObj.SAP_email)){
                    taskObj.SAP_Email__c = tdObj.SAP_email;
                }
                if(String.isNotBlank(tdObj.SAP_mobile)){
                    taskObj.SAP_Mobile__c = tdObj.SAP_mobile;
                }
                if(String.isNotBlank(tdObj.SMS_id)){
                    taskObj.SMS_Id__c = tdObj.SMS_id;
                }
                if(String.isNotBlank(tdObj.SAP_objno)){
                    taskObj.SAP_Objno__c = tdObj.SAP_objno;
                }
                if(String.isNotBlank(tdObj.SAP_type)){
                    taskObj.SAP_Type__c = tdObj.SAP_type;
                }
                if(String.isNotBlank(tdObj.recordTypeId)){
                    taskObj.RecordTypeId = tdObj.recordTypeId;
                }
                else{
                    taskObj.RecordTypeId = alertsRecordTypeId;
                }
                if(taskObj!=null){
                    upsertTaskList.add(taskObj);
                }
                
            }
            
            //Schema.SObjectField sapCode = Account.Fields.SAP_Code__c;
            Database.UpsertResult[] results;
            if(upsertTaskList.size() > 0){
                results = Database.upsert(upsertTaskList, false);
            }
            System.debug('upsertTaskList: '+upsertTaskList);
            System.debug('results: '+results);
            
            sponse.returnTaskDetailsList = new List<TaskDetails>();
            
            if (results != null){
                Integer count = 0;
                for (Database.UpsertResult result : results) {
                    TaskDetails tdObj = taskDetailsList[count];
                    if (!result.isSuccess()) {
                        Database.Error[] errs = result.getErrors();
                        tdObj.status = 'Error';
                        tdObj.errorMessage = String.valueOf(errs);
                        
                        for(Database.Error err : errs){
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                        }
                    }
                    else{
                        tdObj.sfdcId = result.getId();
                        tdObj.status = 'Success';
                    }
                    sponse.returnTaskDetailsList.add(tdObj);
                    count++;
                }
            }
        }        
        catch(Exception e){
            exceptionString += 'Line No: '+e.getLineNumber()+' Exception: '+e.getMessage()+' Cause: '+e.getCause();
            ex = e;
            System.debug(exceptionString);
            //sponse.status = 'Failed';
            sponse.messageDetails = exceptionString;
        }
        //
        return sponse;
    }
    
    global class TaskDetails{
        webservice String sfdcId {get;set;}
        webservice String status {get;set;}
        webservice String errorMessage {get;set;}
        webservice String subject {get;set;}
        webservice String alert_sent_date_SAP {get;set;}
        webservice String description {get;set;}
        webservice String SAP_type {get;set;}
        webservice String recordTypeId {get;set;}
        webservice String SAP_email {get;set;}
        webservice String SAP_objno {get;set;}
        webservice String SAP_mobile {get;set;}
        webservice String SMS_id {get;set;}				
    }
    
    global class ServiceResponse{
        //webservice String status {get;set;} 
        webservice String messageDetails {get;set;}
        webservice List<TaskDetails> returnTaskDetailsList{get;set;}
    }
}