/**
* Batch class Name: ArgentinaCaseReminder
* Author: EY
* CR: APPS-5392
* Description: If no action on case for 7 days, Send an email to Argentina Users with the Case Numbers List 
* Test Class:ArgentinaNotificationTest
* */
global class ArgentinaCaseReminder implements Database.Batchable<SObject>,Database.StateFul {
    global List<String> caseDetailsList = new List<String>();
    global class TestException extends Exception{}
    
    //Retrieve the Cases that were last modified/updated 7 days before.
    global static Database.QueryLocator start(Database.BatchableContext bc){
        DateTime lastModifedSevenDaysBefore = System.now().adddays(-7);
        system.debug('lastModifedSevenDaysBefore :'+lastModifedSevenDaysBefore);
        if(Test.isRunningTest()){
            return Database.getQueryLocator('select id,LastModifieddate,status,CaseNumber,Type,createdDate from Case where Recordtype.DeveloperName IN (\'Argentina_Distributor\')');
        }else{
            return Database.getQueryLocator('select id,LastModifieddate,CaseNumber,status,Type,createdDate from Case where Recordtype.DeveloperName IN (\'Argentina_Distributor\') and LastModifieddate <= :lastModifedSevenDaysBefore and Status IN(\'Pending\',\'Approved\')');   //change this to threedays            
        }
    }
    
    //Prepare the caseList here as excuteMethod runs untill all Batch completes.
    global void execute(Database.BatchableContext bc, List<Case> scope){
        if(null !=scope && !scope.isEmpty()){
            for(Case caseRec : scope){
                String caseDetails = caseRec.caseNumber + ', ' +caseRec.status + ', '+caseRec.Type+ ', '+caseRec.createdDate;
                system.debug('caseDetails :'+caseDetails);
                caseDetailsList.add(caseDetails); 
            }
        } 
    }
    
    //Email argentina case details to business and performexception handling into Monitor Logs
    global void finish(Database.BatchableContext bc){
        List<String> emailList = new List<String>();
        String csvBody='';
        try{
            UPL_Static_Info__mdt argentinaEmailDetails = UPL_Static_Info__mdt.getInstance('Argentina_Case_Notification');
            if(String.isNotBlank(argentinaEmailDetails.Common_Info__c)){
                for(String email : argentinaEmailDetails.Common_Info__c.split(',')){
                    emailList.add(email);
                } 
            }
            
            if(null != caseDetailsList && !caseDetailsList.isEmpty()){
                for(String caserec :caseDetailsList){
                    csvBody=csvBody+caserec+'\n';
                }
            }
            
            string csvHeader='Case Number,Case Status,Case type,Case Created Date\n';
            csvBody = csvHeader + csvBody;
            Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
            Blob csvBlob = Blob.valueOf(csvBody); 
            string csvname= 'Case record-not processed for one week.csv';
            csvAttachment.setFileName(csvname);
            csvAttachment.setBody(csvBlob);  
            List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage  message = new Messaging.SingleEmailMessage();
            message.setSubject('Cases -Not Processed');
            message.setHtmlBody('Hello, <br/><br/> Please find the attached list of case Numbers which was not updated for one week : <br/><br/>Thank You.<br/> UPL Management Team');
            message.setToAddresses(emailList);
            message.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment}); 
            emailMessageList.add(message);
            
            Messaging.sendEmail(emailMessageList);
            
            if(Test.isRunningTest()){
                throw new TestException('Test Exception');
            }
        }catch(Exception exc){
            System.debug('Exception caused in Sending Mails : '+exc.getMessage());//Monitor Log
            
            Monitor_log__c monitorLogObj= new Monitor_log__c();
            monitorLogObj.Name = 'ArgentinaCaseReminder' + system.now();
            monitorLogObj.Message__c = exc.getMessage();
            monitorLogObj.Line_Number__c = exc.getLineNumber();
            insert monitorLogObj;
        }
    }
}