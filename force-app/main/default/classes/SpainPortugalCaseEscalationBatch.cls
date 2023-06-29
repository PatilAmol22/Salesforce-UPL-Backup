/**
 * Batch class Name: SPainPortugalCaseEscalationBatch
 * Author: EY
 * CR: APPS-5135
 * Description: If no action on case in 5 days, then case should be escalated. An email will be sent to respective users 
 * */
global class SpainPortugalCaseEscalationBatch implements Database.Batchable<SObject>,Database.StateFul {
    
    global static String salesOrgCodeOrCountry;
    global static List<Colombia_Case_Module__mdt> customMetadataDetails;
    
   /* global CaseEscalationBatch(String salesOrgCountry){
        salesOrgCodeOrCountry =salesOrgCountry;
    }*/
    global  Database.QueryLocator start(Database.BatchableContext bc){
        DateTime fiveDaysBefore = System.now().adddays(-5);//change it to 5
        //for Testing
        DateTime hrBefore = System.now()-(5/1440);
        system.debug('hrBefore ==>'+hrBefore);
        if(Test.isRunningTest()){
          return Database.getQueryLocator('select id,createddate,colombia_User__c,User_Assigned__c,Sales_Org_Code__c,colombia_user__r.name,status,Type from Case where Recordtype.DeveloperName IN (\'Iberia_Community_Cases\') AND Status NOT IN (\'Closed\',\'Escalated\')');
        }else{
        //if(salesOrgCodeOrCountry =='Spain' || salesOrgCodeOrCountry=='Portugal'){
            return Database.getQueryLocator('select id,createddate,colombia_User__c,User_Assigned__c,Sales_Org_Code__c,colombia_user__r.name,status,Type from Case where Recordtype.DeveloperName IN (\'Iberia_Community_Cases\') AND Status NOT IN (\'Closed\',\'Escalated\') and LastModifieddate <= :hrBefore limit 5');   //change this to threedays 
       
        }
            /*}
        else{
            return Database.getQueryLocator('select id,createddate,colombia_User__c,colombia_user__r.name,status,Type from Case where Recordtype.DeveloperName IN (\'Naturagri_Spain\',\'Spain_Cases\',\'Portugal_cases\') AND Status NOT IN (\'Closed\',\'Escalated\') and createddate <= :threeDaysBefore');    
        }*/
        
    }
    global void execute(Database.BatchableContext bc,List<Case> caseRecords){
        List<case> caselisttoBeUpdated=new List<case>();
        List<Database.SaveResult> processedCases = new List<Database.SaveResult>();
        List<Colombia_Case_module__mdt> caseEscalationMetadataDetails = getCustomMetadetails();
        Set<String> escalateUserSet = new Set<String>();
        if(caseEscalationMetadataDetails != null && !caseEscalationMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt csmtd : caseEscalationMetadataDetails){
                escalateUserSet.add(csmtd.Escalate_User_Name__c);
            }
        }
        
        
        Map<String,Id> escalateUserMapIberia = new Map<String,Id>();
        Map<String,String> escalateIberia = new Map<String,String>();
        
        Map<String,Id> userMap = new Map<String,Id>();
        Map<Id,User> UserInfo = new Map<Id,User>();
        if(escalateUserSet !=null && !escalateUserSet.isEmpty()){
            List<User> ecalationUserList = [select id,email,name,username,title,isActive from User where username IN: escalateUserSet and IsActive =: true];
            for(User us:ecalationUserList){
                userMap.put(us.username,us.Id);
                UserInfo.put(us.Id,us);
            } 
        }
        if(caseEscalationMetadataDetails != null && !caseEscalationMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt csmtd : caseEscalationMetadataDetails){
                
                if(csmtd.Sales_Org_Code_Country__c =='Iberia'){
                    if(userMap.containsKey(csmtd.Escalate_User_Name__c)){
                        Id escalationUserId =userMap.get(csmtd.Escalate_User_Name__c);
                        escalateUserMapIberia.put(csmtd.Case_Type__c,escalationUserId);
                        escalateIberia.put(csmtd.Case_Type__c,csmtd.Escalate__c);
                    } 
                }
              }
        }
        for(Case caseRec:caseRecords){
            if(caseRec.Sales_Org_Code__C == 'Iberia'){
                if(escalateIberia.containsKey(caseRec.Type)){
                    caseRec.Escalate__c = escalateIberia.get(caseRec.Type);
                }
                
                if(escalateUserMapIberia.containskey(caseRec.Type)){
                    caseRec.EscalationUser__c = escalateUserMapIberia.get(caseRec.Type); 
                    caseRec.Status='Escalated';
                }
            }
            caselisttoBeUpdated.add(caseRec);
        }
        try{
            if(caselisttoBeUpdated !=null & !caselisttoBeUpdated.isempty()){
               processedCases= Database.Update(caselisttoBeUpdated,false);
                if(processedCases !=null && !processedCases.isEmpty()){
                    sendEmailToEscalateUser(processedCases,UserInfo);
                }
            }
            
        }
        Catch(Exception ex){
            System.debug('exception in update :'+ex.getMessage());
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
    global static List<Colombia_Case_module__mdt> getCustomMetadetails(){
        if(customMetadataDetails == null){
            customMetadataDetails = new List<Colombia_Case_module__mdt>();
            //if(salesOrgCodeOrCountry =='Spain' || salesOrgCodeOrCountry=='Portugal'){
                List<Colombia_Case_Module__mdt> cmdtDetails = [select id,Running_User__c,Assign__c,Assign_User__c,Creator_Profile__c,Case_Type__c,Label,
                                                               Escalate__c,Escalation_User__c,Assignee_Username__c,Escalate_User_Name__c,Sales_Org_Code_Country__c from Colombia_Case_module__mdt where Sales_Org_Code_Country__c='Iberia'];
                
                customMetadataDetails.addAll(cmdtDetails);  
            //}
            
        }
        return customMetadataDetails;
    }
    global void sendEmailToEscalateUser(List<Database.saveResult> processedcaseResult, Map<Id,User> userMap){
        Set<Id> processedResultSet = new Set<Id>();
        for(Database.saveResult saveObj : processedcaseResult){
            if(saveObj.isSuccess()){
                processedResultSet.add(saveObj.id);
            }
        }
        if(null != processedResultSet && !processedResultSet.isEmpty()){
            List<Case> listCases = [select id,Account.Name,Farmer_Name__c,Priority,CaseNumber,Additional_Information__c,Assignee__c,User_Assigned__c,Status,Escalate__c,Type,EscalationUser__c from case where id IN :processedResultSet];
            //contact conObj = [select id,firstname from contact limit 1];
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTemp = [Select id, Subject, Body From EmailTemplate Where DeveloperName = 'Spain_Portugal_Case_Escalation'];
            for(Case caseObj : listCases){
                system.debug('Case Type --->'+caseObj.Type);
                if(userMap.containskey(caseObj.EscalationUser__c)){
                    User userObj = userMap.get(caseObj.EscalationUser__c); 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(emailTemp.Id);
                   // mail.setTargetObjectId(conObj.Id);
                    mail.setTargetObjectId(caseObj.EscalationUser__c);
                    mail.setWhatId(caseObj.Id);
                    mail.setSaveAsActivity(false);
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.toAddresses = new String[] { userObj.email};
                        emailList.add(mail);
                }
            }
            if(!emailList.isEmpty() && emailList!=null){
                Messaging.sendEmail(emailList);
            }
        }
    }   
}