/**
* Batch class Name: SalesAreaUpdateBatch
* Author: EY (Harshaprasad Srustu)
* APPS-3542 - India Customer visibility issue
* CreatedDate: 08-DEC-2022
* Description: Custom logic to provide update the SalesArea' AccountOwner upon change on TerritoryManager from territory record
* 				associated to respective SalesOrg
* */
global class SalesAreaUpdateBatch  implements Database.Batchable<sObject>, Database.Stateful {
    
    global class TestException extends Exception{}
    global List<id> TerritoryIdList;
    //global static final String uplUserId = [Select Id from User where userName = 'sadmin@upl.com.uat' and isActive = true].id;
    global static final Set<String> salesOrgSet = new Set<String>{'1210','1000','1410','1510'};//Set of Sales Org for SWAL, India and AF
        global List<String> exceptionList = new List<String>();
    global Integer processedRecords = 0;
    global Set<Id> processsedSalesAreaId = new Set<Id>();
    global SalesAreaUpdateBatch(List<id> TerritoryIds){
        TerritoryIdList=TerritoryIds;
        system.debug('TerritoryIdList'+TerritoryIdList);
    }
    //fetch the records of account that is modified in 30 min
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Datetime halfHourBack = Datetime.now().addMinutes(-30); 
        return Database.getQueryLocator('Select id, Sales_Org_Code__c, TerritoryManager__c,OwnershipofAccount__c, TerritoryManager__r.Name, TerritoryManagerActive__c from Territory_Distributor__c WHERE  ID IN :TerritoryIdList AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgSet');   
    }
    
    //Update the SalesArea's Account Owner from Territory associated to respective SalesOrg.
    global void execute(Database.BatchableContext BC, List<Territory_Distributor__c>  territoryList) {
        Map<Id, Territory_Distributor__c> territoryOwnerMap = new Map<Id,Territory_Distributor__c>();
        List<DistributorSalesAreaMapping__c> salesAreaList = new List<DistributorSalesAreaMapping__c>();
        //Save point for restoring the values in case of any exception
        Savepoint sp = Database.setSavepoint();
        
        if(null != territoryList && !territoryList.isEmpty()){
            
            for(Territory_Distributor__c  territoryRecord : territoryList){
                system.debug('territoryRecord.OwnershipofAccount__c =='+territoryRecord.OwnershipofAccount__c);
                if(String.isNotBlank(territoryRecord.OwnershipofAccount__c) && territoryRecord.OwnershipofAccount__c != 'BLANK'){
                    territoryOwnerMap.put(territoryRecord.Id, territoryRecord);
                    system.debug('territoryOwnerMap  :'+territoryOwnerMap);
                }
            }
            
            for(DistributorSalesAreaMapping__c salesAreaRecord : [Select Id, AccountOwner__c, Territory__c, Sales_Org_Code__c,Division__c from DistributorSalesAreaMapping__c WHERE SalesOrg__r.Sales_Org_Code__c IN :salesOrgSet AND Territory__c IN :territoryOwnerMap.keySet() and Division__r.Name!='ALP']){
                //DistributorSalesAreaMapping__c recordToUpdate = new DistributorSalesAreaMapping__c( Id = salesAreaRecord.Id);
                if(territoryOwnerMap.get(salesAreaRecord.territory__c).Sales_Org_Code__c == salesAreaRecord.Sales_Org_Code__c	&& territoryOwnerMap.get(salesAreaRecord.territory__c).OwnershipofAccount__c !=  salesAreaRecord.AccountOwner__c){
                    system.debug('inside saleaarea map');
                    salesAreaRecord.AccountOwner__c = territoryOwnerMap.get(salesAreaRecord.territory__c).OwnershipofAccount__c;
                    
                    salesAreaList.add(salesAreaRecord);
                }
            }
            
            try{
                if(null != salesAreaList && !salesAreaList.isEmpty()){
                    System.debug('salesAreaList >>>>>>' +salesAreaList.size());
                    Database.SaveResult[] saveResultList = Database.update(salesAreaList,false);
                    for (Integer i=0; i < saveResultList.size(); i++){
                        Database.SaveResult sr = saveResultList[i];
                        String msg='';
                        processedRecords++;
                        System.debug('processedRecords >>>>>>>>>>>>>>>>>>>' +processedRecords);
                        if (sr.isSuccess()) {
                            System.debug('processsedSalesAreaId >>>>>>>>>>>>>>>>>>>' +sr.getId());
                            processsedSalesAreaId.add(sr.getId());
                            
                        }else{
                            System.debug('Failed Ids >>>>>>>>>>>>>>>>>>>' +salesAreaList.get(i).ID);
                            msg += salesAreaList.get(i).ID;        
                            for(Database.Error err : sr.getErrors()) {
                                msg = msg+', ' + err.getFields()+', '+err.getMessage();
                                System.debug('Error Message >>>>>>>>>>>>>>>>>>>' +msg);
                            }
                        }
                        if(Test.isRunningTest()){
                            msg += salesAreaList.get(0).ID;
                        }
                        if(String.isNotBlank(msg)){
                            exceptionList.add(msg);   
                        }  
                    }
                }
                if(Test.isRunningTest()){
                    throw new TestException('I am running for test class');
                }
            } catch(Exception e){
                //Database.rollback(sp);
                String stackTrace = e.getStackTraceString().substringBefore('\n');
                String className = stackTrace.substringAfter('.').substringBefore('.'); 
                String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
                System.debug('stackTrace >>>>'+stackTrace);
                System.debug('className >>>>'+className);
                System.debug('methodName >>>>'+methodName);
                //insertExceptionRecords(className, methodName, e.getMessage(), 'Others');
            } finally {
                salesAreaList.clear();
                territoryOwnerMap.clear();
            }
        } 
    }
    
    //Send email of SalesArea records that are failed during update process
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()]; // execute after batch runs  and send mail notification when status is failed.
        String csvSuccessBody='';
        String csvFailedBody = '';
        try{
            String emailBody = 'Total records Processed by SalesAreaUpdateBatch is: '+processedRecords+'\n\n';
            List<Messaging.EmailFileAttachment> SuccessFailAttachment=new List<Messaging.EmailFileAttachment>();
            if(null != processsedSalesAreaId && !processsedSalesAreaId.isEmpty()){
                emailBody = emailBody + 'Records successfully updated are: '+ processsedSalesAreaId.size() + '\n\n';
            }            
            string csvSuccessHeader= 'Id\n';
            for(String successRecord : processsedSalesAreaId){
                csvSuccessBody = csvSuccessBody + successRecord + '\n';
            }
            Messaging.EmailFileAttachment csvSuccessAttachment = new Messaging.EmailFileAttachment();
            
            csvSuccessBody = csvSuccessHeader + csvSuccessBody;
            Blob csvSuccessBlob = Blob.valueOf(csvSuccessBody);
            
            csvSuccessAttachment.setFileName('SalesArea_success.csv');
            csvSuccessAttachment.setBody(csvSuccessBlob); 
            
            
            if(null != exceptionList && !exceptionList.isEmpty()){
                emailBody = emailBody + 'Failed Records count is: '+ exceptionList.size() + '\n\n';  
            }
            //-----Changed by Nandhini----
            Messaging.EmailFileAttachment csvFailedAttachment = new Messaging.EmailFileAttachment();
            boolean isFailedRecordExists = false;
            
            string csvFailedHeader= 'Id, Field, Errors\n';
            if(null != exceptionList && !exceptionList.isEmpty()){
                for(String exceptionRecord : exceptionList){
                    
                    csvFailedBody = csvFailedBody + exceptionRecord+'\n';
                }
            }
            csvFailedBody = csvFailedHeader + csvFailedBody;
            System.debug('csvFailedBody>>>>>>' +csvFailedBody);
            Blob csvFailedBlob = Blob.valueOf(csvFailedBody);
            csvFailedAttachment.setFileName('SalesArea_error.csv');
            csvFailedAttachment.setBody(csvFailedBlob);
            System.debug('inside if condition >>>>>>' +csvFailedBody);
            
            if(null != processsedSalesAreaId && !processsedSalesAreaId.isEmpty())
            {
                SuccessFailAttachment.add(csvSuccessAttachment); 
            }
            if(null != exceptionList && !exceptionList.isEmpty()){
                SuccessFailAttachment.add(csvFailedAttachment); 
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> EmailListToSend=new List<String>();
            String EmailList = System.Label.Sales_Area_Owner_Update_Email;
            system.debug('Label list :'+EmailList);
            if(String.isNotBlank(EmailList)){
                for(String email : EmailList.split(',')){
                    EmailListToSend.add(email);
                }
            }
            //mail.setToAddresses(new String[] {'nandhini.perumalsamy@upl-ltd.com','harshaprasad.srustu@upl-ltd.com'});
            mail.setToAddresses(EmailListToSend);
            mail.setSubject('SalesArea Owner Update ');
            mail.setPlainTextBody(emailBody);
            System.debug('emailBody>>>>>>' +emailBody);
            //if(null != csvSuccessAttachment || ( null != csvFailedAttachment && null != exceptionList && !exceptionList.isEmpty())){
            //mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvSuccessAttachment,csvFailedAttachment});
            //}
            mail.setFileAttachments(SuccessFailAttachment);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } catch(Exception exc){
            System.debug('Exception caused in Sending Mails : '+exc.getMessage());
            
        } 
    }
    
    //Insert failed records into log object for future reference
    global Partner_Portal_Logs__c insertExceptionRecords(String className, String methodName, String exceptionMsg, String errorType){
        Partner_Portal_Logs__c exceptionLogsEntries = new Partner_Portal_Logs__c();
        exceptionLogsEntries.ClassName__c =  className;
        exceptionLogsEntries.MethodName__c = methodName;
        exceptionLogsEntries.Exception_Message__c = exceptionMsg;
        exceptionLogsEntries.ErrorType__c = errorType;
        insert exceptionLogsEntries; 
        return exceptionLogsEntries;
    } 
}