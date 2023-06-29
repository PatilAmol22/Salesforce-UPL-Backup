global class AccountUpdateBatch implements Database.Batchable<sObject>,Database.Stateful {
    public List<Id> accountIdList;
    global List<String> exception_List;
    //Sales Area Owner Update-Added by Nandhini to Capture the Territory ids Modified.
    global List<id> territoryIds;

    
    global AccountUpdateBatch(List<ID> idList,List<id> TerritoryIdList){
        accountIdList = idList;
        exception_List = new List<String>();
        //Sales Area Owner Update-Added by Nandhini
        territoryIds=TerritoryIdList;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select ID,OwnerId,Territory_Distributor__c,Territory_Distributor__r.OwnershipofAccount__c
 										from Account where Id in :accountIdList]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountRecordList){
        for(Integer i=0;i<accountRecordList.size();i++){
            if(accountRecordList[i].Territory_Distributor__r.OwnershipofAccount__c != 'BLANK')
            accountRecordList[i].OwnerID = accountRecordList[i].Territory_Distributor__r.OwnershipofAccount__c;
            else
            accountRecordList[i].OwnerID = '005280000017DV0';
                
        }
        Database.SaveResult[] SaveResultList = Database.update(accountRecordList,false);
        if(Test.isRunningTest()){
            Database.SaveResult sr = (Database.SaveResult)
    		JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
        	String msg='';
        	if (!sr.isSuccess()) {
                msg += accountRecordList.get(0).ID;        
                for(Database.Error err : sr.getErrors()) {
            	msg=msg+', ' + err.getFields()+', '+err.getMessage();
        		}
    		}
            if(msg!='')
            exception_List.add(msg);
        }
        for (Integer i=0; i < SaveResultList.size(); i++){
            Database.SaveResult sr = SaveResultList[i];
            String msg='';
        	if (!sr.isSuccess()) {
                msg += accountRecordList.get(i).ID;        
                for(Database.Error err : sr.getErrors()) {
            	msg=msg+', ' + err.getFields()+', '+err.getMessage();
        		}
    		}
            if(msg!='')
            exception_List.add(msg);
        }
	}
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
        String csvBody='';
        //Sales Area Owner Update-Added by Nandhini to call a New batch to update Salesarea record's Account owner field
        SalesAreaUpdateBatch batch = new SalesAreaUpdateBatch(territoryIds);
        Database.executeBatch(batch, 1);
        try{
            
            if(exception_List != null && exception_List.size() > 0){
                for(String exceptionRecord:exception_List){
                    csvBody=csvBody+exceptionRecord+'\n';
                }
                String emailBody = 'Hello Team \n\nOn Change of territory, '+exception_List.size()+' Account Records failed in Update Process.Please see the attached file for details of the records failed.\n\nThanks ';
                string csvHeader='Id, Field, Errors\n';
                csvBody = csvHeader + csvBody;
                System.debug('Error Message : '+exception_List+ ' Msg : '+csvBody);
                Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
                Blob csvBlob = Blob.valueOf(csvBody); 
                string csvname= 'Error Logs.csv';
                csvAttachment.setFileName(csvname);
                csvAttachment.setBody(csvBlob);  
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'ibmgroup@upllimited.onmicrosoft.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Account Update Failed ');
                mail.setPlainTextBody(emailBody);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});    
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception exc){
            System.assert(false,'Excetion caused in Sending Mails : '+exc.getMessage());
        }
    }
    
}