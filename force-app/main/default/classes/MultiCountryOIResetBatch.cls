global class MultiCountryOIResetBatch implements Database.Batchable<sObject>{
    
     global Database.QueryLocator start(Database.BatchableContext BC){
         
       String SalesOrgFilter = '(';
       String query;

       List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c FROM Liquidation_Batch_Filters__c Where Active__c = true];  
         for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
             SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
         }
       SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')'; 
       query = 'SELECT Id, Sent_to_Batch__c FROM Opening_Inventory2__c WHERE Sent_to_Batch__c = true AND '+SalesOrgFilter;
       system.debug('Main query ---->' +query);
      return Database.getQueryLocator(query);
   }
    
     global void execute(Database.BatchableContext BC, List<Opening_Inventory2__c> scope){  
         for(Opening_Inventory2__c OI : scope){
             OI.Sent_to_Batch__c = false;
         }
         update scope;
   }
    
    global void finish(Database.BatchableContext BC){
   }

}