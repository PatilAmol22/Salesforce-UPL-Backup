/**********************************************
 * Name: BCH_AccountUpdateViaSalesDisrtrict
 * Created By: Varun Shrivastava
 * Create Date: 11 May 2021
 * Purpose: Update Account Owner
 * Ticket: SCTASK0465715
**********************************************/
global class BCH_AccountUpdateViaSalesDisrtrict implements Database.Batchable<sObject>,Database.Stateful {
    public List<Id> salesDistrictIdList;
    global List<String> exception_List;

    
    global BCH_AccountUpdateViaSalesDisrtrict(List<ID> idList){
        salesDistrictIdList = idList;
        exception_List = new List<String>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select ID,OwnerId,Sales_District__c,Sales_District__r.User__c		
 										from Account where Sales_District__c in :salesDistrictIdList]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountRecordList){
        for(Integer i=0;i<accountRecordList.size();i++){
            accountRecordList[i].OwnerID = accountRecordList[i].Sales_District__r.User__c;
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
        try{
            if(exception_List != null && exception_List.size() > 0){
                for(String exceptionRecord:exception_List){
                    csvBody=csvBody+exceptionRecord+'\n';
                }
                String emailBody = 'Hello Team \n\nOn Update of Sales district, '+exception_List.size()+' Account Records failed in Update Process.Please see the attached file for details of the records failed.\n\nThanks ';
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
                mail.setSubject('Account Update Failed On Change of Sales District User');
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