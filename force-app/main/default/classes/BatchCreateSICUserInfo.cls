global class BatchCreateSICUserInfo implements 
    Database.Batchable<sObject>, Database.Stateful{
        
        // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID,TerritoryManager__r.Full_Name__c, TerritoryManager__c, Region__r.RegionHead__c,  TerritoryCode__c' +           
            ' FROM Territory_Distributor__c where Sales_Org_Code__c = \'5191\'' 
            
        );
    }
    global void execute(Database.BatchableContext bc, List<Territory_Distributor__c> scope){
        // process each batch of records
       List<SIC_User_Info__c> LiSICUserInfo = new List<SIC_User_Info__c>();
        
        for (Territory_Distributor__c TD : scope){
            SIC_User_Info__c SICUI = new SIC_User_Info__c();
            SICUI.Territory__c = TD.Id;
            SICUI.Sales_User__c = TD.TerritoryManager__c;
            SICUI.Name = TD.TerritoryManager__r.Full_Name__c;
            SICUI.Regional_Manager__c = TD.Region__r.RegionHead__c;
            SICUI.Combination_Key__c = TD.TerritoryCode__c+Date.Today().Year();
            SICUI.Year__c = Date.Today().Year();
            LiSICUserInfo.add(SICUI);
            
        }
        
        upsert LiSICUserInfo Combination_Key__c;
    }    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
       
    }    

}