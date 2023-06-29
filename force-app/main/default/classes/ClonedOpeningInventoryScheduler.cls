Global class ClonedOpeningInventoryScheduler implements Schedulable {
    global list<Period> ListOfPeriod;
    global list<Liquidation_Annual_Plan__c> ListOfLiqAnnualPlan;
    
    global void execute(SchedulableContext SC) {
        try{ 
            List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c Where Active__c = true and Name='Mexico'];
            System.debug('LiquidationBatchFilters--->'+LiquidationBatchFilters);
            String AccountTypeFilter = '';
            String SalesOrgFilter = '';
            AccountTypeFilter = '(';
            SalesOrgFilter = '(';
            for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
                AccountTypeFilter += l.Account_Type_Filter__c+' OR ';
                SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
            }
            AccountTypeFilter = AccountTypeFilter.removeEnd('OR ') +')';
            SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')';
            string query = '';
            Date endDate;
            Date startDate;
            ListOfPeriod = [SELECT FiscalYearSettings.Name,StartDate,EndDate,type  FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
            
            system.debug('ListOfPeriod'+ListOfPeriod);
            system.debug('ListOfPeriod'+ListOfPeriod[0].Enddate);
            system.debug('ListOfPeriod'+ListOfPeriod[0].StartDate);
            if(ListOfPeriod.size()>0){
                endDate = ListOfPeriod[0].EndDate; 
                startDate = ListOfPeriod[0].StartDate;    
                string sDate = string.valueOfGmt(startDate);
                String eDate = string.valueOfGmt(endDate);
                system.debug('startdate>>--->'+sDate);
                system.debug('Enddate>>--->'+eDate);
                string queryliq ='SELECT Name,Id,Sales_Org_Code__c,FIscal_Year__c,SentToBatch__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+' AND SentToBatch__c = false AND RecordType.Name=\'Multi Country\' AND Sales_Org_Code__c =\'5100\' LIMIT 1';
                ListOfLiqAnnualPlan = Database.query(queryliq);
                system.debug('Hello'+ListOfLiqAnnualPlan.size());
                String recordTypeName = 'Multi Country';
                
                if(Test.isRunningTest()){
                    ListOfLiqAnnualPlan =[SELECT Name,Id,FIscal_Year__c,SentToBatch__c,Multi_Country_Key__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c FROM Liquidation_Annual_Plan__c WHERE SentToBatch__c = false AND RecordType.Name='Multi Country' AND (Sales_Org__r.Sales_Org_Code__c='6451' OR Sales_Org__r.Sales_Org_Code__c='6410') LIMIT 1];
                }
                if(ListOfLiqAnnualPlan.size()>0){
                    system.debug('Hello');
                    query = 'SELECT Name,Id,Ship_To_Party__c,Sales_Org__c,SentToBatch__c,FIscal_Year__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND RecordType.Name=\''+String.escapeSingleQuotes(recordTypeName) +'\' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+' AND SentToBatch__c = false AND Sales_Org_Code__c =\'5100\' Limit 1';
                    if(Test.isRunningTest()){
                        query = 'SELECT Name,Id,Ship_To_Party__c,Sales_Org__c,SentToBatch__c,FIscal_Year__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE  SentToBatch__c = false AND AND RecordType.Name='+recordTypeName+' AND '+SalesOrgFilter+' Limit 1';
                    }
                    
                    system.debug('query inside scheduler --- >' +query);
                    ClonedMultiCountryOpeningInventoryBatch opnInvBtObj = new ClonedMultiCountryOpeningInventoryBatch(query); 
                    database.executebatch(opnInvBtObj,1);
                    
                    
                }
            }
        }
        catch(Exception e){
            System.debug('Sch Exception>>----->'+e.getLineNumber());
            System.debug('Sch Exception>>----->'+e.getMessage());
        }
    }
}