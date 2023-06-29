public class invoiceUpdateBatch implements Database.Batchable<sObject> {
   public String query = 'SELECT Id, Check_Attachment_File__c FROM Invoice__c WHERE Check_Attachment_File__c  = false AND '+System.Label.Invoice_Update_Sales_Org_Codes;
 
   public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }
 
   public void execute(Database.BatchableContext BC, List<Invoice__c> scope){
       system.debug('scope--->'+scope);
       update scope; 
   }
 
   public void finish(Database.BatchableContext BC){
   }
}