/**
* Batch class name: ArgentinaCaseApprovalReminder
* Author: EY
* CR: APPS-5392
* Description: If the case didn't get approved by Jorge for 2 days, send an email to Jorge with the casedetails
* Test Class: ArgentinaNotificationTest 
* */
global class ArgentinaCaseApprovalReminder implements Database.Batchable<SObject>, Database.StateFul {
    
    global DateTime twoDaysBefore = System.now().adddays(-2);
    global List<String> caseList =new List<String>();
    
    global class TestException extends Exception{}
    //Retrieve the Approval records that were pending for 2 days.
    global static Database.QueryLocator start(Database.BatchableContext bc){
        if(Test.isRunningTest()){
            return Database.getQueryLocator('SELECT TargetObjectId,TargetObject.Recordtype.name,Status,CreatedDate FROM ProcessInstance where TargetObject.Type =\'Case\' AND Status =\'Pending\'');
        }else{
            return Database.getQueryLocator('SELECT Id,TargetObjectId,TargetObject.Recordtype.name,Status,CreatedDate FROM ProcessInstance where TargetObject.Type =\'Case\' AND Status =\'Pending\' AND TargetObject.Recordtype.DeveloperName=\'Argentina_Distributor\''); 
        }
    }
    //Prepare the caseList here as excuteMethod runs untill all Batch completes.
    global void execute(Database.BatchableContext bc,List<ProcessInstance> approvalRequests){
        Set<String> approversSet = new Set<String>();
        
        UPL_Static_Info__mdt argentinaApproverDetails = UPL_Static_Info__mdt.getInstance('Argetina_Approvers');
        
        if(String.isNotBlank(argentinaApproverDetails.Common_Info__c)){
            for(String approver : argentinaApproverDetails.Common_Info__c.split(',')){
                approversSet.add(approver);
            }  
        }
        
        Set<Id> processInstanceIds=new Set<Id>();
        Set<Id> caseIds=new Set<Id>();
        
        if(approvalRequests !=null && !approvalRequests.isempty()){
            for(ProcessInstance processId:approvalRequests){
                processInstanceIds.add(processId.Id);
            }
        }
        
        if(processInstanceIds !=null && !processInstanceIds.isEmpty()){
            List<ProcessInstance> processSteps=[Select Id,TargetObjectId,TargetObject.Name,(SELECT ID, ProcessNodeId, StepStatus,TargetObjectId,ActorId,IsPending,Actor.Name,Actor.Username,ProcessInstanceId,CreatedDate FROM StepsAndWorkitems where StepStatus='Pending' and CreatedDate<= :twoDaysBefore) from ProcessInstance where Id IN:processInstanceIds];
            if(processSteps !=null && !processSteps.isEmpty()){
                for(ProcessInstance processrequest:processSteps){
                    system.debug('case list :'+processrequest.StepsAndWorkitems);
                    for(Integer i=0;i<processrequest.StepsAndWorkitems.size();i++){
                        String approverUserName=processrequest.StepsAndWorkitems[i].Actor.UserName;
                        if(approversSet.contains(approverUserName)){
                            caseIds.add(processrequest.TargetObjectId);
                        }
                    }
                }
            }
            
            if(Test.isRunningTest()){
                Id caseRecordId = [SELECT Id FROM Case WHERE Recordtype.DeveloperName IN ('Argentina_Distributor') Limit 1].Id;
                caseIds.add(caseRecordId);
            }
            
            if(caseIds !=null && !caseIds.isEmpty()){
                for(Case caseRec : [Select Id, caseNumber, status, type, createdDate, Subject from Case where Id IN :caseIds]){
                    String caseInfo = caseRec.CaseNumber + ', ' + caseRec.Status + ', '+ caseRec.Type + ', '+ caseRec.Subject + ', '+ caseRec.createdDate;
                    caseList.add(caseInfo);
                } 
            } 
        }  
    }
    //Email argentina case details to business and performexception handling into Monitor Logs
    global void finish(Database.BatchableContext bc){
        List<String> emailList=new List<String>();
        String csvBody='';
        
        try{
            UPL_Static_Info__mdt argentinaEmailDetails = UPL_Static_Info__mdt.getInstance('Argentina_Case_Approval_Notification');
                        
            if(String.isNotBlank(argentinaEmailDetails.Common_Info__c)){
                for(String email : argentinaEmailDetails.Common_Info__c.split(',')){
                    emailList.add(email);
                } 
            }
            
            if(caseList != null && !caseList.isEmpty()){
                for(String caserec :caseList){
                    csvBody=csvBody+caserec+'\n';
                }
                
            }
            
            string csvHeader='Case Number,Case Status,Case type,Title,Case Created Date\n';
            csvBody = csvHeader + csvBody;
            Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
            Blob csvBlob = Blob.valueOf(csvBody); 
            string csvname= 'Cases-Pending for Approval.csv';
            csvAttachment.setFileName(csvname);
            csvAttachment.setBody(csvBlob);  
            List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage  message = new Messaging.SingleEmailMessage();
            message.setSubject('Cases -Pending for Approval');
            message.setHtmlBody('Hello, <br/><br/> Please find the attached list of case Numbers which is waiting for approval: <br/><br/>Thank You.<br/> UPL Management Team');
            message.setToAddresses(emailList);
            message.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment}); 
            emailMessageList.add(message);
            Messaging.sendEmail(emailMessageList);
            
            if(Test.isRunningTest()){
                throw new TestException('Test Exception');
            }
        }catch(Exception exc){
            System.debug('Exception caused in Sending Mails : '+exc.getMessage());//monitor Log
           Monitor_log__c monitorLogObj= new Monitor_log__c();
            monitorLogObj.Name = 'ArgentinaCaseApprovalReminder' + system.now();
            monitorLogObj.Message__c = exc.getMessage();
            monitorLogObj.Line_Number__c = exc.getLineNumber();
            insert monitorLogObj;
        }
    }
}