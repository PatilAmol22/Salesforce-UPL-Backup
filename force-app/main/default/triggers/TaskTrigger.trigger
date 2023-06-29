trigger TaskTrigger on Task (before insert, after insert) {
    Id distributorRecordTypeId;
    if(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor')!=null){
    	distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    }
    //Id recordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
    Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Alerts').getRecordTypeId();
    if(Trigger.isBefore && Trigger.isInsert){
        
        Set<String> accountMobileSet = new Set<String>();
        Set<String> accountEmailSet = new Set<String>();
        
        for(Task taskObj:Trigger.new){
            if(taskObj.TaskSubtype != 'Email'){
                if(taskObj.RecordTypeId == RecordTypeId){
                    if(String.isNotBlank(taskObj.SAP_Mobile__c)){
                        accountMobileSet.add(taskObj.SAP_Mobile__c); 
                    }
                    if(String.isNotBlank(taskObj.SAP_Email__c)){
                        accountEmailSet.add(taskObj.SAP_Email__c);
                    }
                }
            }
        }
        
        //Mapping Account Mobile to Account ID
        Map<String, Id> accountMobileMap = new Map<String, Id>();
        if(!accountMobileSet.isEmpty()){
            for(Account accObj:[Select Id, PersonMobilePhone FROM Account WHERE PersonMobilePhone IN:accountMobileSet AND RecordTypeId=:distributorRecordTypeId]){
                accountMobileMap.put(accObj.PersonMobilePhone, accObj.Id);
            }     
        }
        //Mapping Account Email to Account ID
        Map<String, Id> accountEmailMap = new Map<String, Id>();
        if(!accountEmailSet.isEmpty()){
            for(Account accObj:[Select Id, PersonEmail FROM Account where PersonEmail IN:accountEmailSet AND RecordTypeId=:distributorRecordTypeId]){
                accountEmailMap.put(accObj.PersonEmail, accObj.Id);
            }
        }
        for(Task taskObj:Trigger.new){
            
            //Condition to check if RecordType =  Alerts (SObject = Task)
            if(taskObj.RecordTypeId == RecordTypeId){
                
                //Create Task using existing Account If Mobile No/Email ID exists in SFDC Set Sync  = 'true'
                if(String.isNotBlank(taskObj.SAP_Mobile__c) && accountMobileMap.containsKey(taskObj.SAP_Mobile__c)){
                    taskObj.WhatId = accountMobileMap.get(taskObj.SAP_Mobile__c);
                    taskObj.Sync__c = true;
                }
                else if(String.isNotBlank(taskObj.SAP_Email__c) && accountEmailMap.containsKey(taskObj.SAP_Email__c)){
                    taskObj.WhatId = accountEmailMap.get(taskObj.SAP_Email__c);
                    taskObj.Sync__c = true;
                }
                
                //Create New Create New Task If Mobile No AND Email ID not found in SFDC AND Set Sync  = 'false'
                //Also add Error Message to task with the corressponding Mobile No AND/OR Email ID for reference
                
                else{
                    String errorMessage = '';
                    
                    if(String.isNotBlank(taskObj.SAP_Mobile__c) && String.isNotBlank(taskObj.SAP_Email__c)){
                        errorMessage = 'No Account found with Mobile No - '+taskObj.SAP_Mobile__c+' and Email ID - '+taskObj.SAP_Email__c;
                    }
                    else if(String.isNotBlank(taskObj.SAP_Mobile__c)){
                        errorMessage = 'No Account found with Mobile No - '+taskObj.SAP_Mobile__c;
                    }
                    else if(String.isNotBlank(taskObj.SAP_Email__c)){
                        errorMessage = 'No Account found with Email ID - '+taskObj.SAP_Email__c;
                    }
                    taskObj.Error_Message__c = errorMessage;        
                    taskObj.Sync__c = false;
                }
            }
        }
    }
    Id profileId= userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    if(!profileName.contains('France') && !profileName.contains('Australia') && !profileName.contains('System Administrator')){
        if(Trigger.isBefore && Trigger.isInsert){
            List<Task> taskList = new List<Task>();
            List<Task> accTaskList = new List<Task>(); //Divya: Added for INCTASK0212762 - Send Welcome SMS Karix
            Map<String,List<Task>> taskListforWhatsapp = new Map<String,List<Task>>();
            //List<Task> taskListforWhatsappForPrev = new List<Task>();
            for(Task taskObj:Trigger.new){
                if(taskObj.Subject != null && taskObj.WhatId!=null){ //Divya: Added for INCTASK0212762 - Send Welcome SMS Karix
                    if(taskObj.Subject == 'Welcome SMS'|| String.valueOf(taskObj.WhatId).substring(0,3) == '100'){
                        accTaskList.add(taskObj);
                    }
                   if(taskObj.Subject == 'Auto Product2 Recommendation' || taskObj.Subject == 'Auto Product1 Recommendation'|| taskObj.Subject == 'Auto Product3 Recommendation' || taskObj.Subject == 'Auto Product4 Recommendation'||taskObj.Subject == 'Cross Selling Escalation Preventive'||taskObj.Subject == 'Cross Selling Escalation Cure'|| String.valueOf(taskObj.WhatId).substring(0,3) == '500'){
                        taskList.add(taskObj);
                    }
                    
                    if(taskObj.Subject == 'Cross Selling Whatsapp Preventive' ){
                        if(taskListforWhatsapp.containsKey(taskObj.Subject)){
                            taskListforWhatsapp.get(taskObj.Subject).add(taskObj);
                        }
                        else
                        {
                            taskListforWhatsapp.put(taskObj.Subject,new List<Task>{taskObj});
                        }
                    }
                    if(taskObj.Subject == 'Cross Selling whatsapp Cure' ){
                        if(taskListforWhatsapp.containsKey(taskObj.Subject)){
                            taskListforWhatsapp.get(taskObj.Subject).add(taskObj);
                        }
                        else
                        {
                            taskListforWhatsapp.put(taskObj.Subject,new List<Task>{taskObj});
                        }
                    }
                    if(taskObj.Subject == 'Send feedback message on whatsapp' ){
                        if(taskListforWhatsapp.containsKey(taskObj.Subject)){
                            taskListforWhatsapp.get(taskObj.Subject).add(taskObj);
                        }
                        else
                        {
                            taskListforWhatsapp.put(taskObj.Subject,new List<Task>{taskObj});
                        }
                    }
                    
                }
            }
            //IntegrationWithKarixForCase integrationWithKarixForCase = new IntegrationWithKarixForCase();
            if(!taskList.isEmpty())
                IntegrationWithKarixForCase.getCaseContentsForSMS(taskList);
            if(!acctaskList.isEmpty()) //Divya: Added for INCTASK0212762 - Send Welcome SMS Karix
                IntegrationWithKarixForAccount.getAccountContentsForSMS(acctaskList);
            if(!taskListforWhatsapp.isEmpty()){
                if(taskListforWhatsapp.containsKey('Send feedback message on whatsapp'))
                {
                    IntegrationWithEngagely.getCaseContentsForSMS(taskListforWhatsapp.get('Send feedback message on whatsapp'));
                }
                if(taskListforWhatsapp.containsKey('Cross Selling Whatsapp Preventive'))
                {
                    IntegrationWithEngagely.getRecommendedForwhatsapp(taskListforWhatsapp.get('Cross Selling Whatsapp Preventive'),5);
                }
                if(taskListforWhatsapp.containsKey('Cross Selling whatsapp Cure'))
                {
                    IntegrationWithEngagely.getRecommendedForwhatsapp(taskListforWhatsapp.get('Cross Selling whatsapp Cure'),3);
                }
            }
        }
    }
    
    // Added by (GRZ)Nikhil Verma 09-05-2023
    if(Trigger.isinsert && Trigger.isAfter){
        Set<Id> oppIdSet = new Set<Id>();
        for(Task tsk : Trigger.New){
            if(tsk.WhatId != null && tsk.WhatId.getSObjectType().getDescribe().getName() == 'Opportunity'){
                oppIdSet.add(tsk.WhatId);
            }
        }
        if(oppIdSet != null && !oppIdSet.isEmpty()){
            List<Opportunity> oppListToUpdate = new List<Opportunity>();
            for(Opportunity opp : [SELECT Id, Task_Created__c FROM Opportunity WHERE Id IN:oppIdSet AND Task_Created__c = FALSE]){
                opp.Task_Created__c = true;
                oppListToUpdate.add(opp);
            }
            if(oppListToUpdate != null && !oppListToUpdate.isEmpty()){
                update oppListToUpdate;
            }
        }
    }
    
}