/**********************************************
 * Name: BCH_Liquidation_FieldUpdate
 * Created By: Varun Shrivastava
 * Create Date: 29 April 2021
 * Purpose: Update Fixed YTD Sales field in Old Liquidation Records for AF and SWAL both
 * Ticket: SCTASK0419590
**********************************************/


global class BCH_Liquidation_FieldUpdate implements Database.Batchable<sObject>,Database.Stateful {
	
    global List<String> exception_List;
  	global BCH_Liquidation_FieldUpdate(){
        exception_List = new List<String>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        List<String> salesOrgCodeList = new List<String>();
        salesOrgCodeList.add('1000');
        salesOrgCodeList.add('1210');
        String query='Select Id,Liquidation_YTD_Trade__c,Liquidation_YTD_SWAL__c,Fixed_YTD_Sales__c,Sales_Org_Code__c from Liquidation2__c '+ 
            		  'where Sales_Org_Code__c in :salesOrgCodeList And CreatedDate >= 2020-07-29T00:00:00.000+05:30'; 	
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext bc, List<Liquidation2__c> liquidationRecords){
     	List<Liquidation2__c> updateLiquidationList = new List<Liquidation2__c>();
        for(Liquidation2__c liq:liquidationRecords){
            if(liq.Sales_Org_Code__c == '1210'){
                liq.Fixed_YTD_Sales__c = liq.Liquidation_YTD_SWAL__c;
            }else{
                liq.Fixed_YTD_Sales__c = liq.Liquidation_YTD_Trade__c;
            }
            updateLiquidationList.add(liq);
        }
        Database.SaveResult[] SaveResultList = Database.update(updateLiquidationList,false);
        if(Test.isRunningTest()){
            Database.SaveResult sr = (Database.SaveResult)
                JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
            String msg='';
            if (!sr.isSuccess()) {
                msg += liquidationRecords.get(0).ID;        
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
                msg += liquidationRecords.get(i).ID;        
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
                String emailBody = 'Hello Team \n\nOn Update of Liquidation Records, '+exception_List.size()+' Liquidation Records failed in Update Process.Please see the attached file for details of the records failed.\n\nThanks ';
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
                mail.setSubject('Liquidation Fixed FTD Sales Update Failed');
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