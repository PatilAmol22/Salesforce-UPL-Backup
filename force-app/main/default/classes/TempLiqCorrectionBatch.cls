global class TempLiqCorrectionBatch implements Database.Batchable<sObject>{
    
     global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'SELECT Id, Month__c, Opening_Inventory2__r.Multi_Country_Key__c, Sales_Org_Code__c, Multi_Country_Key__c FROM Liquidation2__c where RecordType.Name = \'Multi Country\' AND (Sales_Org_Code__c  = \'6451\' OR Sales_Org_Code__c  = \'6410\' OR Sales_Org_Code__c =\'7100\')';
      return Database.getQueryLocator(query);
   }
    
     global void execute(Database.BatchableContext BC, List<Liquidation2__c> scope){  
         for(Liquidation2__c b : scope){
             b.Multi_Country_Key__c = b.Opening_Inventory2__r.Multi_Country_Key__c + b.Month__c;
           }
        update scope;
   }
    
    global void finish(Database.BatchableContext BC){
   }

}