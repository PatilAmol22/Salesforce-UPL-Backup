global class TestSWALCropLiqInsertBatch implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
        //String query = 'SELECT Id,Name, TerritoryCode__c,SBU_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '1000' AND SBU_Code__c IN ('901','902','903','904') AND (NOT(Name LIKE '%-b%' OR Name LIKE '%SAIB%' OR Name LIKE '%Vector%' OR NAME LIKE '%—Provision%' OR Name LIKE '%- b%' OR Name LIKE '%- Provision%' OR Name LIKE '%CIL%'))';
        return Database.getQueryLocator([SELECT Id,Name, TerritoryCode__c,SBU_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '1210' AND (NOT(Name LIKE '%-b%' OR Name LIKE '%SAIB%' OR Name LIKE '%Vector%' OR NAME LIKE '%—Provision%' OR Name LIKE '%- b%' OR Name LIKE '%- Provision%' OR Name LIKE '%CIL%')) AND Present_in_KEDE__c = True]);
    }
     global void execute(Database.BatchableContext BC, List<Territory_Distributor__c> scope){
         SWALCropLiqInsertClass.insertCrpLiq(scope[0].Id);
     }
    
    global void finish(Database.BatchableContext BC){
    
    }
}