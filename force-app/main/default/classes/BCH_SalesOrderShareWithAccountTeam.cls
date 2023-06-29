/**********************************************
 * Name: BCH_SalesOrderShareWithAccountTeam
 * Created By: Varun Shrivastava
 * Create Date: 26 Aug 2021
 * Purpose: Share Sales Order(Colombia, Mexico and Indonesia) with Account Team Member 
 * Version2: This updated batch will delete Mexico Sales Order Share with Account Team Member instead of Created By.
 * Run Bacth with Size 1
 * Ticket: SCTASK0573152
**********************************************/

global class BCH_SalesOrderShareWithAccountTeam implements Database.Batchable<sObject>,Database.Stateful{
global List<String> exception_List;
  	global BCH_SalesOrderShareWithAccountTeam(){
        exception_List = new List<String>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        //String query='Select Id, Sold_to_Party__c from Sales_Order__c where Sales_Org_lk__r.Sales_Org_Code__c in (\'5710\',\'5100\',\'6451\',\'6410\')'; 	
        String query= 'Select id,ParentId,Parent.OwnerId, Parent.CreatedByID, UserOrGroupId,AccessLevel, RowCause from Sales_Order__Share where AccessLevel = \'Read\' and Parent.SalesOrgCode__c = \'5100\'';
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext bc, List<Sales_Order__Share> salesOrderShareList){
     	//List<Sales_Order__share> salesOrderShareList = new List<Sales_Order__share>();
        List<Sales_Order__share> salesOrderShareDeleteList = new List<Sales_Order__share>();
        
        for(Sales_Order__Share salesOrderShare:salesOrderShareList){
            if(salesOrderShare.UserOrGroupId != salesOrderShare.Parent.CreatedById && salesOrderShare.UserOrGroupId != salesOrderShare.Parent.OwnerID){
                salesOrderShareDeleteList.add(salesOrderShare);
            }
        }
        try{
        	delete salesOrderShareDeleteList;
        }catch(Exception exc){
            exception_List.add(exc.getMessage());
        }
        /*if(Test.isRunningTest()){
            Database.SaveResult sr = (Database.SaveResult)
                JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
            String msg='';
            if (!sr.isSuccess()) {
                msg += salesOrderShareDeleteList.get(0).ID;        
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
                msg += salesOrderShareList.get(i).ID;        
                for(Database.Error err : sr.getErrors()) {
                    msg=msg+', ' + err.getFields()+', '+err.getMessage();
                }
            }
            if(msg!='')
                exception_List.add(msg);
        }*/
    }
    
    global void finish(Database.BatchableContext bc){
        /*AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
        String csvBody='';
        try{
            if(exception_List != null && exception_List.size() > 0){
                for(String exceptionRecord:exception_List){
                    csvBody=csvBody+exceptionRecord+'\n';
                }
                String emailBody = 'Hello Team \n\nOn Delete Share of Sales Order Records, '+exception_List.size()+' Sales Order Share Records failed in Insert Process.Please see the attached file for details of the records failed.\n\nThanks ';
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
                mail.setSubject('Sales Order Share Delete Record Failed');
                mail.setPlainTextBody(emailBody);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});    
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception exc){
            System.assert(false,'Excetion caused in Sending Mails : '+exc.getMessage());
        }*/
    }
}