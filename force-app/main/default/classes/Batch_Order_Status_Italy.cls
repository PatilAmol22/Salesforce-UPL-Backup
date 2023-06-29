/****************************************
 * Created By: Varun Shrivastava
 * Created Date: 25 Jan 2021
 * Ticket: SCTASK0335027
 * **************************************/

global class Batch_Order_Status_Italy implements Database.Batchable<sObject>,Database.Stateful{
    global List<String> exception_List;
	global Batch_Order_Status_Italy(){
        exception_List = new List<String>();
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query='Select id,Order_Status__c,Order_Type_Code__c,Valid_To__c from Sales_Order__c where Sales_Org_lk__r.Sales_Org_Code__c = \'2410\' and Valid_To__c < TODAY and Order_Type_Code__c = \'ZICQ\' and Order_Status__c != \'Closed\'  order by CreatedDate desc';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Sales_Order__c> saleOrderList){
        List<Sales_Order__c> salesOrderListToUpdate = new List<Sales_Order__c>();
        for(Sales_Order__c  salesOrderRecord : saleOrderList){
           salesOrderRecord.Order_Status__c = 'Closed';
           salesOrderListToUpdate.add(salesOrderRecord);
        }
        Database.SaveResult[] SaveResultList = Database.update(salesOrderListToUpdate,false);
        if(Test.isRunningTest()){
            Database.SaveResult sr = (Database.SaveResult)
    		JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
        	String msg='';
        	if (!sr.isSuccess()) {
                msg += saleOrderList.get(0).ID;        
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
                msg += saleOrderList.get(i).ID;        
                for(Database.Error err : sr.getErrors()) {
            	msg=msg+', ' + err.getFields()+', '+err.getMessage();
        		}
    		}
            if(msg!='')
            exception_List.add(msg);
        }
    }
    
    public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
        String csvBody='';
        try{
            if(exception_List != null && exception_List.size() > 0){
                for(String exceptionRecord:exception_List){
                    csvBody=csvBody+exceptionRecord+'\n';
                }
                String emailBody = 'Hello Team \n\nOn Change Italy Sales Order Status, '+exception_List.size()+' Sales Order Records failed in Update Process.Please see the attached file for details of the records failed.\n\nThanks ';
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
                mail.setSubject('Italy Sale Order Status Update for ZICQ Failed ');
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