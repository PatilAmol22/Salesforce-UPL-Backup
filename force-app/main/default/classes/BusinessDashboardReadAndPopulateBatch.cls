/*
* Name: Business Dashboard Read And Populate Batch
* Created On: 08 Mar 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class used for Batch Processing of CSV files
* from Schema Definition Object & Object Details from Custom Setting.
*/
global with sharing class BusinessDashboardReadAndPopulateBatch implements Database.batchable<String>, Database.Stateful{
    private String exceptionJSON;
    //private String batchLogJSON;
    
   public BusinessDashboardBatch batchObj;
    //public BusinessDashboardBatch_clone batchObj;
    public String m_csvFile; 
    
    public BusinessDashboardReadAndPopulateBatch(){
        try{
            batchObj = new BusinessDashboardBatch();     
            
            exceptionJSON = '';
            //batchLogJSON = '';
            
            m_csvFile = batchObj.getFile();
            System.debug('m_csvFile 1:--'+m_csvFile);
        }
        catch(Exception e){
            system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
        }
    }
    
    global Iterable<String> start(Database.batchableContext batchableContext){
        System.debug('m_csvFile 2:--'+m_csvFile);
        return new CSVIterator(m_csvFile, Parser.crlf);
    }
    
    global void execute(Database.BatchableContext batchableContext, List<String> scope){
        //TODO: Create a map with the column name and the position.
        try{
            String csvFile = '';

            System.debug('scope: '+scope);
            
            for(String row : scope){
                csvFile += row + Parser.crlf;
            }           
            batchObj.processData(csvFile);
            System.debug('batchObj:---- '+batchObj);
        }
        catch(Exception e){
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
            //System.abortJob(batchableContext.getJobId());
        }
    }
    
    global void finish(Database.BatchableContext batchableContext){
        System.debug('batchableContext: '+batchableContext);
        
        System.debug('businessDashboardID: '+batchObj.businessDashboardID);

        if(String.isNotBlank(batchObj.businessDashboardID)){
            BusinessDashboard__c  bdObj = new BusinessDashboard__c();
            bdObj.id = batchObj.businessDashboardID;
            
            System.debug('exceptionMonList: '+batchObj.exceptionMonList);
            
            if(!batchObj.exceptionMonList.isEmpty()){
                exceptionJSON = JSON.serialize(batchObj.exceptionMonList);
                
                bdObj.Status__c = 'Partially Completed';
                bdObj.Exceptions__c = batchObj.exceptionMonList.size();
                
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('Exception.log');
                attObj.Body = Blob.valueOf(exceptionJSON);
                attObj.ParentId = batchObj.businessDashboardID;
                insert attObj;
            }

            if(batchObj.errorCSVList.size() > 1){
                
                bdObj.Status__c = 'Partially Completed';
                bdObj.DataErrors__c = batchObj.errorCSVList.size()-1;
                
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('Error.csv');
                attObj.Body = Blob.valueOf(String.join(batchObj.errorCSVList, '\r\n'));
                attObj.ParentId = batchObj.businessDashboardID;
                insert attObj;
                
                Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
                attach1.setContentType('application/csv');
                attach1.setFileName(attObj.Name);
                attach1.setInline(false);
                attach1.Body = attObj.Body;
                
                DateTime d = Date.Today() ;
                String dateString =  d.format('dd/MM/yyyy') ;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //mail.setOrgWideEmailAddressId(orgName.Id);
                mail.setUseSignature(false);
                mail.setToAddresses(new String[] { 'azhar.shaikh@skinternational.com' });
                mail.setSubject(batchObj.filename+' Error File');
                mail.setHtmlBody('Dear User,<br /><br />Please find attached error file generated in SFDC while parsing the SAP BW Data<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+batchObj.errorCSVList.size()+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach1 }); 
                
                // Send the email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            }
            else{
                bdObj.Status__c = 'Completed';
            }
            System.debug('batchObj.successCSVList :----'+batchObj.successCSVList);
            if(batchObj.successCSVList.size() > 1){
                Attachment attObj2 = new Attachment();
                attObj2.Name = String.valueOf('Success.csv');
                attObj2.Body = Blob.valueOf(String.join(batchObj.successCSVList, '\r\n'));
                attObj2.ParentId = batchObj.businessDashboardID;
                insert attObj2;
                
                bdObj.Success__c = batchObj.successCSVList.size()-1;                
            }
            else{
                bdObj.Status__c = 'Failed';
            }
            update bdObj;
            
            if(bdObj.Status__c == 'Completed' || bdObj.Status__c == 'Partially Completed'){
                List<SchedulerSettings__c> settingsList = [SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'DashboardDataDeletionBatch'];
                if(!settingsList.isEmpty()){ 
                    if(settingsList[0].Enabled__c == True){
                        Database.executeBatch(new DashboardDataDeletionBatch(batchObj.selectedObject, batchObj.asOfNow, batchObj.fileName), Integer.valueOf(settingsList[0].Batch_Size__c));
                    }
                }
            }
        }
        
        List<BusinessDashboard__c> businessDashboardList2 = [SELECT Id FROM BusinessDashboard__c 
                                                             WHERE CreatedDate = TODAY 
                                                             AND Status__c = 'Draft'
                                                             AND Id !=:batchObj.businessDashboardID
                                                             ORDER By CreatedDate LIMIT 1 ];
        
        if(!businessDashboardList2.isEmpty()){
            List<SchedulerSettings__c> settingsList = [SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
            if(!settingsList.isEmpty()){
                if(settingsList[0].Enabled__c == True){
                    Database.executeBatch(new BusinessDashboardReadAndPopulateBatch(), Integer.valueOf(settingsList[0].Batch_Size__c));
                }
            }
        }
    }
}