global class MultiCountryOpeningInventoryBatch implements Database.Batchable<sObject>{
        global string query = '';
        global map<string,Opening_Inventory2__c> mapOpeningInventory; 
        global List<Liquidation_Batch_Filters__c> LiquidationBatchFilters;   
    
        global MultiCountryOpeningInventoryBatch (string query){  
              
            this.query = query;
            system.debug('query'+ this.query);
            mapOpeningInventory = new map<string,Opening_Inventory2__c>();   
        }

       global Database.QueryLocator start(Database.BatchableContext BC){ 
       
          string query = '';
          query = this.query;                     
          system.debug('query>>----->'+ query);
            
          return Database.getQueryLocator(query);
       }

       global void execute(Database.BatchableContext BC, List<Liquidation_Annual_Plan__c> scope){
        String AccountTypeFilter = '(';
        String SalesOrgFilter = '(';
           List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c Where Active__c = true];  
             for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
                AccountTypeFilter += l.Account_Type_Filter__c+' OR ';
                 SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
             }
             AccountTypeFilter = AccountTypeFilter.removeEnd('OR ') +')';
             SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')'; 
         System.debug('SalesOrgFilter----->'+SalesOrgFilter);
       list<SKU__c> ListOfSku = new list<SKU__c>();   
       string query = 'SELECT Id, Name, SKU_Code__c, Sales_Org__c FROM SKU__c WHERE Active_For_Liquidation__c= true AND '+SalesOrgFilter;
       ListOfSku = Database.query(query);
           System.debug('ListOfSku---->'+ListOfSku);
           //ListOfSku = [SELECT Id, Namc, SKU_Code__c, Sales_Org__c FROM SKU__c WHERE (Sales_Org_Code__c = '6451' OR Sales_Org_Code__c = '6410') AND Active_For_Liquidation__c= true];
       system.debug('ListOfSku>>----->'+ListOfSku.size());
       RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
        system.debug('Record Type>>-----> '+rt);
          For(Liquidation_Annual_Plan__c  liqAnnualPlan : scope ){ 
              For(SKU__c sku: ListOfSku){
                  if(liqAnnualPlan.Sales_Org__c == sku.Sales_Org__c) {
                   Opening_Inventory2__c opnInv2=new Opening_Inventory2__c();
                      if(LiqAnnualPlan.Ship_To_Party__c!=null){
                           opnInv2.Ship_To_Party__c = LiqAnnualPlan.Ship_To_Party__c;
                      }                
                   opnInv2.SKU__c= sku.Id;
                   opnInv2.RecordTypeId= rt.Id;
                   opnInv2.Liquidation_Annual_Plan__c= liqAnnualPlan.id;
                   opnInv2.Distributor__c= liqAnnualPlan.Distributor__c;  
                   opnInv2.Multi_Country_Key__c = sku.SKU_Code__c + liqAnnualPlan.Multi_Country_Key__c;
                   
                     if(!mapOpeningInventory.containskey(sku.Id)){
                       mapOpeningInventory.put(sku.Id,opnInv2);
                      }
                  } //End of first If
              }             
      //TODO: scope checkbox true
      liqAnnualPlan.SentToBatch__c = true;
      update liqAnnualPlan;
      }  
      system.debug('opening Inventory>>----->'+mapOpeningInventory.values());
      insert mapOpeningInventory.values();
   }

   global void finish(Database.BatchableContext BC){
       String AccountTypeFilter = '(';
       String SalesOrgFilter = '(';
       List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c Where Active__c = true];  
             for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
                 AccountTypeFilter += l.Account_Type_Filter__c+' OR ';
                 SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
             }
             AccountTypeFilter = AccountTypeFilter.removeEnd('OR ') +')';
             SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')'; 
   //TODO:check if checkbox true then update
       list<Period> lstPeriod = new list<Period>();
       Date endDate;
       Date startDate;
       lstPeriod = [SELECT FiscalYearSettings.Name,StartDate,EndDate,type  FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
          if(lstPeriod.size()>0){
                  endDate = lstPeriod[0].EndDate; 
                  startDate = lstPeriod[0].StartDate;    
                  string sDate = string.valueOfGmt(startDate);
                  String eDate = string.valueOfGmt(endDate);
       list<Liquidation_Annual_Plan__c> lstLiqdtnAnnlPln = new list<Liquidation_Annual_Plan__c>();
      String recordTypeName = 'Multi Country';
       
      string queryliq ='SELECT Name,Id,Ship_To_Party__c,FIscal_Year__c,Sales_Org__c,SentToBatch__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+' AND SentToBatch__c = false AND RecordType.Name=\'Multi Country\' AND '+SalesOrgFilter+' LIMIT 1';
      System.debug(queryliq);
      lstLiqdtnAnnlPln = Database.query(queryliq);
      
      string query = 'SELECT Name,Id,Ship_To_Party__c,Sales_Org__c,SentToBatch__c,FIscal_Year__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND RecordType.Name=\''+String.escapeSingleQuotes(recordTypeName) +'\' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+' AND SentToBatch__c = false AND '+SalesOrgFilter+' Limit 1';
       
       if(lstLiqdtnAnnlPln.size()>0){
           MultiCountryOpeningInventoryBatch opnInvBtObj = new MultiCountryOpeningInventoryBatch(query); 
           database.executebatch(opnInvBtObj,1);
       }  
       } 
   }
}