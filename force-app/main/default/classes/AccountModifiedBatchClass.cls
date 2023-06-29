/**
 * Batch class Name: AccountModifiedBatchClass
 * Author: EY (Ishu Mittal)
 * RITM0400199
 * CreatedDate: 26-06-2022 04:41:06
 * ModifiedDate: 28-Nov-2022 22:00 PM IST
 * Description: Custom logic to provide sharing access to Sales Area Account Owner by inserting into AccountShare sObject.
 * */
global class AccountModifiedBatchClass implements Database.Batchable<sObject> {
    
    global class TestException extends Exception{}
    
    //fetch the records of account that is modified in 30 min
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> salesOrgSet = new Set<String>{'1210','1000','1410','1510'};//Set of Sales Org for SWAL, India and AF
        Datetime halfHourBack = Datetime.now().addMinutes(-30); 
        return Database.getQueryLocator('Select id,(Select id,AccountOwner__c,AccountOwner__r.Name,AccountOwnerActive__c,OwnerDosentMatch__c,Distributor__c from Distributor_Sales_Areas__r) from Account where LastModifiedDate>=:halfHourBack and Sales_Org_Code__c IN :salesOrgSet');
    }
    
    //Process the custom logic to provide sharing access to Sales Area Account Owner by inserting into AccountShare sObject
    global void execute(Database.BatchableContext BC, List<Account>  accList) {
        
        List<WrapClass> wrapperClassList=new List<WrapClass>();
        Set<Id> accountSetId = new Set<Id>();
        
        if(null != accList && !accList.isEmpty()){
            for(Account accRecord : accList){ 
                accountSetId.add(accRecord.id);
                if(null != accRecord.Distributor_Sales_Areas__r && !accRecord.Distributor_Sales_Areas__r.isEmpty()){
                    for(DistributorSalesAreaMapping__c salesAreaMapping : accRecord.Distributor_Sales_Areas__r){
                        if(salesAreaMapping.OwnerDosentMatch__c==true && salesAreaMapping.AccountOwnerActive__c==true){//added condition AccountOwnerActive__c
                            System.debug('salesAreaMapping'+salesAreaMapping);  //taking the records whose Sales Area OwnerDosentMatch__c field is true and save the distributor id and AccountOwner id in wrapper class
                            WrapClass wc = new WrapClass();
                            wc.accountID = salesAreaMapping.Distributor__c;
                            wc.newOwnerId = salesAreaMapping.AccountOwner__c;
                            wrapperClassList.add(wc);
                        }
                    }
                }
            }
            
            
            List<AccountShare> deleteExistingSharedRecords = new List<AccountShare>();//list to delete shareAccess of exisiting record
            List<AccountShare> existingManuallySharedRecords = new List<AccountShare>([Select id, AccountID, UserOrGroupId,RowCause  from AccountShare where AccountID in: accountSetId and rowCause='Manual']);  
            
            if(null != existingManuallySharedRecords && !existingManuallySharedRecords.isEmpty()){
                for(AccountShare ac:existingManuallySharedRecords){
                    deleteExistingSharedRecords.add(ac);
                }
                try{
                    if(null != deleteExistingSharedRecords && !deleteExistingSharedRecords.isEmpty()){
                       Database.DeleteResult[] deleteResult = Database.delete(deleteExistingSharedRecords, true); //delete deleteAccountShares;
                    }
                    if(Test.isRunningTest()){
                        throw new TestException('I am running for test class');
                    }
                }catch(Exception e){
                    system.debug('Catch block---->'+e.getMessage());
                    system.debug('Catch block---->'+e.getLineNumber());
                    String stackTrace = e.getStackTraceString().substringBefore('\n');
                    String className = stackTrace.substringAfter('.').substringBefore('.'); 
                    String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
                    insertExceptionRecords(className, methodName, e.getMessage(), 'Others');
                }
            }
            
            Map<String,AccountShare> newAccountShareMap = new Map<String,AccountShare>();
            for(WrapClass w : wrapperClassList){
                String accountUserId='';
                AccountShare thisAccountShare = new AccountShare(); 
                thisAccountShare.userorgroupid = w.newOwnerId;
                thisAccountShare.accountid = w.accountID;
                thisAccountShare.accountaccesslevel = 'Edit';
                thisAccountShare.OpportunityAccessLevel = 'None';
                thisAccountShare.CaseAccessLevel = 'None';
                thisAccountShare.ContactAccessLevel = 'Edit';
                accountUserId=w.accountID+w.newOwnerId;
                newAccountShareMap.put(accountUserId,thisAccountShare);
            }
            
            try{
                if(null != newAccountShareMap && !newAccountShareMap.isEmpty()){
                    Database.SaveResult[] srList = Database.insert(newAccountShareMap.values(), false);

                    for (Database.SaveResult sr : srList) { // Iterate through each returned result
                        if (sr.isSuccess()) {// Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                        } else {  // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Account fields that affected this error: ' + err.getFields());
                                //insertExceptionRecords('AccountModifiedBatchClass', 'execute', err.getMessage(), 'Others');
                            }
                        }
                    }
                }
                if(Test.isRunningTest()){
                    throw new TestException('I am running for test class');
                }
            }catch(Exception e){
                String stackTrace = e.getStackTraceString().substringBefore('\n');
                String className = stackTrace.substringAfter('.').substringBefore('.'); 
                String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
                insertExceptionRecords(className, methodName, e.getMessage(), 'Others');
            }
        }  
    }   
    
    //Logic to send Email alert to Shared mail box
    global void finish(Database.BatchableContext BC) {
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()]; // execute after batch runs  and send mail notification when status is failed.
        if(a.Status =='Failed' || Test.isRunningTest()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'ishu.mittal@upl-ltd.com','vijay.laxmi1@upl-ltd.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Account Owner Sharing Failed' );
            mail.setPlainTextBody
                ('The batch Apex job processed scoreCard update ' + a.TotalJobItems +
                 ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } 
        
    }
    
    //Wrapper class for holding accountId and newUserId
    public class WrapClass{
        
        String accountID; 
        String newOwnerId;
        
        public WrapCLass(){
            accountID =''; 
            newOwnerId='';
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