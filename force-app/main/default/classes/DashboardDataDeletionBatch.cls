/*
* Name: DashboardDataDeletionBatch
* Created On: 03 May 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Class is used for deletion of re-sent object wise Dashboard data to keep only the latest data sent on the same day
*/

global class DashboardDataDeletionBatch implements Database.Batchable<sObject>, Database.Stateful{
    private String query;
    private DateTime asOfNowSoql;
    private String batchType;
    private String originalFileID;
    
    public DashboardDataDeletionBatch(String batchType){ 
        this.batchType = batchType;
        
        List<SchemaObjectMapping__c> schemaList = [Select Object__c FROM SchemaObjectMapping__c WHERE Deleted_on__c!= TODAY];
        
        String objectName = '';
        
        if(!schemaList.isEmpty()){
            objectName = schemaList[0].Object__c;
            SchemaObjectMapping__c smObj = schemaList[0];
            smObj.Deleted_on__c = System.today();
            update smObj;
        }
        
        query =  'SELECT ID FROM '+objectName+' ';
        query += 'WHERE CreatedDate < LAST_N_DAYS:7';
        
        System.debug('query: '+query);
        System.debug('exec soql: '+'SELECT ID FROM '+objectName+' WHERE CreatedDate < LAST_N_DAYS:7');
    }
    
    public DashboardDataDeletionBatch(String objectName, DateTime asOfnow, String fileName){
        System.debug('-------Constructor---------');
        try{
            System.debug('objectName: '+objectName);
            System.debug('asOfNow: '+asOfNow);
            System.debug('fileName: '+fileName);
            
            asOfNowSoql = asOfnow;
            //originalID = originalFileID;
            String asOfString = asOfNow.format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'');
            
            query =  'SELECT ID, BusinessDashboard__c FROM '+objectName+' ';
            query += 'WHERE BusinessDashboard__r.As_of_now__c !=:asOfNowSoql ';
            query += 'AND BusinessDashboard__r.EmailSubject__c LIKE \'%' + fileName + '%\'';
            query += 'AND CreatedDate = TODAY';
            
            System.debug('query: '+query);
            System.debug('exec soql: '+'SELECT ID FROM '+objectName+' WHERE BusinessDashboard__r.As_of_now__c != '+asOfString+' AND BusinessDashboard__r.EmailSubject__c LIKE \'%' + fileName + '%\' AND createdDate = TODAY');
        }
        catch(Exception Ex){    
            System.debug('Line No: '+ex.getLineNumber()+ 'Exception: '+ex.getMessage());
        }
    } 
    
    global Database.Querylocator start(Database.BatchableContext bc){
        System.debug('--------Start---------');
        
        return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        
        System.debug('--------Execute---------');
        
        try{
            System.debug('scope: '+scope.size()); 
            
            if(!scope.isEmpty()){    
                String fileID = String.valueOf(scope[0].get('BusinessDashboard__c'));
                
                List<BusinessDashboard__c> bdList = [Select Id, OriginalFile__c 
                                                     FROM BusinessDashboard__c 
                                                     WHERE ID=:fileID LIMIT 1 ];
                
                if(!bdList.isEmpty()){
                    originalFileID = bdList[0].OriginalFile__c;
                    System.debug('bdList[0]: '+bdList[0].OriginalFile__c);                         
                }
                
                Database.delete(scope, false);
            }
            
            System.debug('After delete : scope: '+scope.size());
        }
        catch(exception ex){
            System.debug('Line No: '+ex.getLineNumber()+ 'Exception: '+ex.getMessage());
        }        
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('--------Finish---------');
        if(String.isNotBlank(batchType)){
            if(batchType == 'Daily'){
                List<SchemaObjectMapping__c> schemaList = [Select Object__c FROM SchemaObjectMapping__c WHERE Deleted_on__c!= TODAY];
                if(!schemaList.isEmpty()){
                    Database.executeBatch(new DashboardDataDeletionBatch('Daily'), 100);
                }
            }
        }
        else{
            if(String.isNotBlank(originalFileID)){
                BusinessDashboard__c bdObj = new BusinessDashboard__c();
                bdObj.Id = originalFileID;
                bdObj.Status__c = 'Deleted';
                update bdObj;
            }
        }
    }
}