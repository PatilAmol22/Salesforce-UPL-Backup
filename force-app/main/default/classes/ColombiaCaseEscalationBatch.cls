/**
 * Batch class Name: ColombiaCaseEscalationBatch
 * Author: EY
 * CR: APPS-2074
 * CreatedDate: 28-Oct-2022
 * ModifiedDate: 28-Oct-2022 02:10 AM IST
 * 				 02-Nov-2022 19:01 AM IST
 * Description: If no action on case in 48 hours, then case should be escalated. An email will be sent to respective users 
 * */
global class ColombiaCaseEscalationBatch implements Database.Batchable<SObject>,Database.StateFul {
    
    global ColombiaCaseEscalationBatch(){
       
    }

    global static Database.QueryLocator start(Database.BatchableContext bc){
        List<Colombia_Case_module__mdt> assignUserList = [select id,Running_User__c,Assign__c,Assign_User__c,Creator_Profile__c,Label,Case_Type__c,
                                                          Escalate__c,Escalation_User__c,Assignee_Username__c,Escalate_User_Name__c 
                                                          FROM Colombia_Case_module__mdt];
        Set<String> assigneeUserSet = new Set<String>();
        for(Colombia_Case_module__mdt csmtd : assignUserList){
            assigneeUserSet.add(csmtd.Assignee_Username__c);
        }        
        List<User> actualUserList = [select id, name, email, userName from User where userName IN :assigneeUserSet and isActive = true];
        Set<String> userNameSet = new Set<String>();
        for(User userDetails : actualUserList){
            userNameSet.add(userDetails.userName);
        }
        system.debug('system now ' + System.now());
        //DateTime hrBefore = System.now().addHours(-2); //change this time to N_days_Ago:2 for actual testing before deploying
        DateTime hrBefore = System.now()-(5/1440);
        system.debug('hrBefore ==>'+hrBefore);
       
        //to check
         DateTime TwodaysBefore = System.now().adddays(-2);
        system.debug('hrBeforeDays ==>'+TwodaysBefore);
        
        if(Test.isRunningTest()){
          return Database.getQueryLocator('select id,createddate,colombia_User__c,colombia_user__r.name,status,Type from Case where Recordtype.DeveloperName = \'Colombia_Case\' AND Status NOT IN (\'Closed\',\'Escalated\')');
        }else{
            system.debug('Executing Query');
            
            //'select id,createddate,colombia_User__c,colombia_user__r.name,status from Case where Recordtype.DeveloperName = \'Colombia_Case\' AND Status NOT IN (\'Closed\',\'Escalated\') AND colombia_user__r.userName IN (\''+ userNameSet +'\') and createddate <= :hrBefore';
          return Database.getQueryLocator('select id,createddate,colombia_User__c,colombia_user__r.name,status,Type from Case where Recordtype.DeveloperName = \'Colombia_Case\' AND Status NOT IN (\'Closed\',\'Escalated\') AND colombia_user__r.userName IN: userNameSet and createddate <= :TwodaysBefore');    
        }
    }
    
    global void execute(Database.BatchableContext bc,List<Case> caseRecords){
        system.debug('Execute Method Start------->'+caseRecords);
       /* List<Case>  incoList = new List<Case>();
        List<Case>  disPRLst  = new List<Case>();
        List<Case>  proAvaLst  = new List<Case>();
        List<Case>  PcfLst  = new List<Case>();
        List<Case>  ocOULst  = new List<Case>();
        List<Case>  otherList = new List<Case>();*/
        List<case> caselisttoBeUpdated=new List<case>();
        Savepoint sp = Database.setSavepoint();
        
        try{
          
            List<Colombia_Case_module__mdt> cmdtDetails = getCustomMetadetails();
            Set<String> escalateUserSet = new Set<String>();
            Map<String,String> escalateMap = new Map<String,String>();
            
            for(Colombia_Case_module__mdt csmtd : cmdtDetails){
                escalateUserSet.add(csmtd.Escalate_User_Name__c);
                //escalateMap.put(csmtd.Case_Type__c,csmtd.Escalate__c);//spanish key
                escalateMap.put(csmtd.Label,csmtd.Escalate__c);//English keys
                system.debug('CaseType----->'+csmtd.Case_Type__c);
                system.debug('CaseType----->'+csmtd.Label);
            }
           system.debug('Escalate user----->'+escalateUserSet);
            Map<String,User> userMap = new Map<String,User>();
            List<User> ecalationUserList = [select id,email,name,username,title,isActive from User where username IN: escalateUserSet and IsActive =: true];
            system.debug('Escalation user--->'+ecalationUserList);
            system.debug('Escalation List Size----->'+ecalationUserList.size());
            
            if(null != ecalationUserList && !ecalationUserList.isEmpty()){
                for(User esUser : ecalationUserList){
                    system.debug('label name'+System.Label.Colombiafranciscosarmiento_Ur);
                    system.debug('username inside loop'+esUser.Username);
                    if(esUser.Username == System.Label.colombia_JAIRO_HERRERA_user){//change this to Name to userName    user not available in uat and prod /System.Label.ColombiaJairoherrera_Ur
                        userMap.put(UPLConstantClass.INVOICE,esUser);
                        userMap.put(UPLConstantClass.CREDITLIMIT,esUser);
                        userMap.put(UPLConstantClass.OUTSTANDING,esUser);
                        userMap.put(UPLConstantClass.PAYMENTSANDRECEIPTS,esUser); 
                        
						
                    }else if(esUser.Username == System.label.colomia_Ivan_Navas_user){//change this to Name to userName  user not available in uat and prod      /System.Label.ColombiaIvanNavas_Ur
                        userMap.put(UPLConstantClass.DISPATCH,esUser);
                         
                        
                    }else if(esUser.username == System.Label.ColombiaLuisCarlosOvalle_Ur){    //change this to Name to userName ---  In custom label added username
                        userMap.put(UPLConstantClass.PRODUCTAVAILABILITY,esUser);
                         
                        
                    }else if(esUser.Username == System.Label.ColombiaOscarRodriguez_Ur){ // In custom label added username
                        userMap.put(UPLConstantClass.PRODUCTCOMPLAINTSBYFARMERS,esUser);
                        
                        userMap.put('Product Leakage',esUser);
                        userMap.put('Product Related',esUser);
                        
                    }else if(esUser.username == System.Label.Colombiafranciscosarmiento_Ur){
                        userMap.put(UPLConstantClass.ORDERCANCELLATION,esUser);
                        userMap.put(UPLConstantClass.ORDERUPDATE,esUser);
                        userMap.put(UPLConstantClass.SHIPPINGADDRESS,esUser);
                        
                        
                    }else if(esUser.Username == System.Label.colombia_JUAN_OROZCO_user){//change this to Name to userName -- user not available in uat and prod --- /System.Label.Colombiajuanorozco_Ur
                        userMap.put(UPLConstantClass.OTHER,esUser);
                        
                    }
                    system.debug('users iteration Loop----->'+esUser);
                    
                }
                system.debug('Values----->'+userMap.values());
                system.debug('keys'+userMap.keyset());
                 system.debug('usermap -------->'+userMap);
                system.debug('Map Size------>'+userMap.size());
            }
            User userRecord = null;
            if(null != caseRecords && !caseRecords.isEmpty()){
                for(Case caObj : caseRecords){
                    system.debug('check case type '+caObj.Type);
                    if(caObj.Type == UPLConstantClass.INVOICE || caObj.Type == UPLConstantClass.CREDITLIMIT //ColombiaCaseHandler.CREDITLIMIT 
                       || caObj.Type == UPLConstantClass.OUTSTANDING || caObj.Type == UPLConstantClass.PAYMENTSANDRECEIPTS){//caObj.Typev  ColombiaCaseHandler.PAYMENTSANDRECEIPTS
                          
                           if(userMap.containsKey(caObj.Type)){
                               userRecord = userMap.get(caObj.Type);
                                caObj.Status = UPLConstantClass.ESCALATED;
                               caObj.Escalate__c = escalateMap.get(caObj.Type);
                               caObj.EscalationUser__c = userRecord.Id;
                           }
                           caselisttoBeUpdated.add(caObj);
                       }else if(caObj.Type == UPLConstantClass.DISPATCH){
                          
                           if(userMap.containsKey(caObj.Type)){
                               userRecord = userMap.get(caObj.Type);
                                caObj.Status = UPLConstantClass.ESCALATED;
                               caObj.EscalationUser__c = userRecord.Id;
                               caObj.Escalate__c = escalateMap.get(caObj.Type);
                           }
                           caselisttoBeUpdated.add(caObj);
                       }else if(caObj.Type == UPLConstantClass.PRODUCTAVAILABILITY){
                           if(userMap.containsKey(caObj.Type)){
                               caObj.Status = UPLConstantClass.ESCALATED;
                               userRecord = userMap.get(caObj.Type);
                               caObj.Escalate__c = escalateMap.get(caObj.Type);
                               caObj.EscalationUser__c = userRecord.Id;
                               
                           }
                           caselisttoBeUpdated.add(caObj);
                       }else if(caObj.Type == UPLConstantClass.PRODUCTLEAKAGE || caObj.Type == UPLConstantClass.ProductRelated || caObj.Type == UPLConstantClass.PRODUCTCOMPLAINTSBYFARMERS){
                           if(userMap.containsKey(caObj.Type)){
                                 system.debug('Debug logs PRODUCTCOMPLAINTSBYFARMERS---->'+userMap.containsKey(caObj.Type));
                               caObj.Escalate__c = escalateMap.get(caObj.Type);
                               userRecord = userMap.get(caObj.Type);
                               caObj.Status = UPLConstantClass.ESCALATED;
                               caObj.EscalationUser__c = userRecord.Id;
                           }
                           caselisttoBeUpdated.add(caObj);
                       }else if(caObj.Type ==UPLConstantClass.ORDERCANCELLATION
                                || caObj.Type == UPLConstantClass.ORDERUPDATE 
                                || caObj.Type == UPLConstantClass.SHIPPINGADDRESS){ 
                                    system.debug('case type inside'+caObj.Type);
                           if(userMap.containsKey(caObj.Type)){
                                system.debug('inside another if'+caObj.Type);
                               userRecord = userMap.get(caObj.Type);
                                caObj.Status = UPLConstantClass.ESCALATED;
                               caObj.Escalate__c = escalateMap.get(caObj.Type);
                               caObj.EscalationUser__c =userRecord.Id;
                               
                               caObj.Status = UPLConstantClass.ESCALATED;
                            
                           }
                           caselisttoBeUpdated.add(caObj);
                       }else if(caObj.Type == UPLConstantClass.OTHER){
                               system.debug('inside other type');
                           if(userMap.containsKey(caObj.Type)){
                               caObj.Status = UPLConstantClass.ESCALATED;
                               
                               userRecord = userMap.get(caObj.Type);
                               caObj.Escalate__c = escalateMap.get(caObj.Type);
                               caObj.EscalationUser__c = userRecord.id;
                              system.debug('casetypeStatus '+caObj.Status);
                             
                           }
                           caselisttoBeUpdated.add(caObj);
                       }
                }
               
                List<Database.SaveResult> finalList = new List<Database.SaveResult>();
                if(null != caselisttoBeUpdated && !caselisttoBeUpdated.isEmpty()){
                    List<Database.SaveResult> sResultIncoList = Database.update(caselisttoBeUpdated, false);
                    finalList.addAll(sResultIncoList);
                    
                }
                
                /*if(null != disPRLst && !disPRLst.isEmpty()){
                    List<Database.SaveResult> sResultDisPRLst =  Database.update(disPRLst, false);
                    finalList.addAll(sResultDisPRLst);
                    
                }
                if(null != proAvaLst && !proAvaLst.isEmpty()){
                    List<Database.SaveResult> sresultProAvaLst =  Database.update(proAvaLst, false);
                    finalList.addAll(sresultProAvaLst);
                    
                }
                if(null != PcfLst && !PcfLst.isEmpty()){
                    List<Database.SaveResult>  sResultPcfLst =  Database.update(PcfLst, false);
                    finalList.addAll(sResultPcfLst);
                    
                }
                if(null != ocOULst && !ocOULst.isEmpty()){
                    List<Database.SaveResult> sResultOcOULst = Database.update(ocOULst, false);
                    finalList.addAll(sResultOcOULst);
                    
                }
                if(null != otherList && !otherList.isEmpty()){
                    List<Database.SaveResult>  sResultOtherList = Database.update(otherList, false);
                    finalList.addAll(sResultOtherList);
                }*/
                
                System.debug('finalList==> '+finalList.size());
                
                if(null != finalList && !finalList.isEmpty()){
                     sendEmailToEscalateUser(finalList,userMap);
                }
              
                /* System.debug('incoList==> '+incoList.size());
                 System.debug('disPRLst==> '+disPRLst.size());
                 System.debug('proAvaLst==> '+proAvaLst.size());
                 System.debug('PcfLst==> '+PcfLst.size());
                 System.debug('ocOULst==> '+ocOULst.size());
                 System.debug('otherList==> '+otherList.size());*/
                
            }
        } catch(Exception e){
            system.debug('Catch block---->'+e.getMessage());
            system.debug('Catch block---->'+e.getLineNumber());
            //rolling back if any exception raises.
            Database.rollback(sp);
            //Inserting into log sObject when any failure occurs
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            
            Partner_Portal_Logs__c colombiaCaseEscalationRec = new Partner_Portal_Logs__c();
            colombiaCaseEscalationRec.ClassName__c =  className;
            colombiaCaseEscalationRec.MethodName__c = methodName;
            colombiaCaseEscalationRec.Exception_Message__c = e.getMessage();
            colombiaCaseEscalationRec.ErrorType__c = 'Cases';
            insert colombiaCaseEscalationRec; 
        } 
    } 
    
    global void finish(Database.BatchableContext bc){
        
		AsyncApexJob job=[select id,NumberOfErrors,JobItemsProcessed,Status,TotalJobItems,CompletedDate from AsyncApexJob where id =:bc.getJobId()];
        system.debug('Finish Method--->'+job.JobItemsProcessed);
    }
    
    global void sendEmailToEscalateUser(List<Database.saveResult> saveResult, Map<String,User> userMap){
        Set<Id> processedResultSet = new Set<Id>();
        for(Database.saveResult saveObj : saveResult){
            if(saveObj.isSuccess()){
                processedResultSet.add(saveObj.id);
            }
        }
        system.debug('Processed Result'+processedResultSet);
        system.debug('Processed Result'+processedResultSet.size());
        
        
        if(null != processedResultSet){
            List<Case> listCases = [select id,Account.Name,Farmer_Name__c,Priority,CaseNumber,Additional_Information__c,Assignee__c,Colombia_User__c,Status,Escalate__c,Type,EscalationUser__c from case where id IN :processedResultSet];
            //List<Messaging.SingleEmailMessage> singleEmailList = new List<Messaging.SingleEmailMessage>();
            system.debug('List Case-->'+listCases);
            system.debug('List Case Size-->'+listCases.size());
            
            
            contact conObj = [select id,firstname from contact limit 1];
            
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTemp = [Select id, Subject, Body From EmailTemplate Where DeveloperName = 'Colombia_Case_Escalation_Email_Template'];
            for(Case caseObj : listCases){
                system.debug('Case Type --->'+caseObj.Type);
                if(userMap.get(caseObj.Type) !=null ){
                    User userObj = userMap.get(caseObj.Type); 
                    system.debug('User----->'+userObj);
                    system.debug('emailTemp :'+emailTemp);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(emailTemp.Id);
                    mail.setTargetObjectId(conObj.Id);
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
    
    global static List<Colombia_Case_Module__mdt> mColombiaDetails;
    global static List<Colombia_Case_module__mdt> getCustomMetadetails(){
        if(mColombiaDetails == null){
            mColombiaDetails = new List<Colombia_Case_module__mdt>();
            List<Colombia_Case_Module__mdt> cmdtDetails = [select id,Running_User__c,Assign__c,Assign_User__c,Creator_Profile__c,Case_Type__c,Label,
                                                              Escalate__c,Escalation_User__c,Assignee_Username__c,Escalate_User_Name__c from Colombia_Case_module__mdt];
            mColombiaDetails.addAll(cmdtDetails);
        }
      return mColombiaDetails;
    }

}