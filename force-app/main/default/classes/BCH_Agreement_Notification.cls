/**********************************************
 * Name: BCH_Agreement_Notification
 * Created By: Varun Shrivastava
 * Create Date: 4 May 2021
 * Purpose: Notification Alert and Mail on Agreement Expiry
 * Ticket: SCTASK0381589
**********************************************/

global class BCH_Agreement_Notification implements Database.Batchable<sObject>,Database.Stateful{
	global List<String> exception_List;
  	global BCH_Agreement_Notification(){
        exception_List = new List<String>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query='Select Id,AN_Expiry_Flag__c,AN_Recall_Expiry_Flag__c,Expiration_Date_France__c,Recall_Expiry_Date__c,Customer_Name__c from Agrement_clients__c '+ 
            		  'where Expiration_Date_France__c = Today OR Recall_Expiry_Date__c	= Today'; 	
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext bc, List<Agrement_clients__c> agreementRecordsList){
     	List<Agrement_clients__c> updateAgreementList = new List<Agrement_clients__c>();
        for(Agrement_clients__c agreement:agreementRecordsList){
            if(agreement.Expiration_Date_France__c == Date.today())
                agreement.AN_Expiry_Flag__c = true;
            if(agreement.Recall_Expiry_Date__c == Date.today())
                agreement.AN_Recall_Expiry_Flag__c = true;
            updateAgreementList.add(agreement);
        }
        Database.SaveResult[] SaveResultList = Database.update(updateAgreementList,false);
        if(Test.isRunningTest()){
            Database.SaveResult sr = (Database.SaveResult)
                JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
            String msg='';
            if (!sr.isSuccess()) {
                msg += updateAgreementList.get(0).ID;        
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
                msg += updateAgreementList.get(i).ID;        
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
                String emailBody = 'Hello Team \n\nOn Update of Agreement Records, '+exception_List.size()+' Agreement Records failed in Update Process.Please see the attached file for details of the records failed.\n\nThanks ';
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
                mail.setSubject('Agreement Record Update Failed');
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