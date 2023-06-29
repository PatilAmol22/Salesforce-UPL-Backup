global class SalesAgreementDeleteBatch implements Database.Batchable<sObject> {
     global String filter = '';
    public SalesAgreementDeleteBatch(String filter){
       this.filter = filter;
    } 
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        string query = 'Select id,  Active_Forecast_Month__c FROM SalesAgreement where Active_Forecast_Month__c =\''+String.escapeSingleQuotes( this.filter ) +'\''+(Test.isRunningTest()?' LIMIT 200':'');
        system.debug('query ==='+query);
         return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<SalesAgreement> scope){
        
       delete scope; 
    }
    global void finish(Database.BatchableContext BC){
        
    }
}