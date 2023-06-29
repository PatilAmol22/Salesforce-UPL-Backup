global class MultiCountryLiqAnnualPlanScheduler implements Schedulable{
    public list<AggregateResult> listOfDistributorSalesAreaMapping = new list<AggregateResult>();
    public list<Shipping_Location__c> listOfShippingLocation = new List<Shipping_Location__c>();
    public list<Liquidation_Annual_Plan__c> listOfLiqAnnualPlan = new list<Liquidation_Annual_Plan__c>();
    public list<Liquidation_Annual_Plan__c> listOfLiqAnnualPlanForMexico = new list<Liquidation_Annual_Plan__c>();
    public list<Liquidation_Annual_Plan__c> listOfLiqAnnualPlanToInsert = new list<Liquidation_Annual_Plan__c>();
    public list<Period> listOfPeriod = new list<Period>();
    public date startDate;
    public date endDate;
    public String sch;
    public list<Sales_Org__c> orgList;	
    public Map<String,Sales_Org__c> orgMap ;
    
     global void execute(SchedulableContext SC) {
         try{ 
            //*********************** Common for Indo/Turkey and Mexico ********************************
            listOfPeriod = [SELECT FiscalYearSettings.Name , StartDate,EndDate, type FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
            system.debug('list Of Period size>>----->'+listOfPeriod.size());
            endDate = listOfPeriod[0].EndDate; 
            startDate = listOfPeriod[0].StartDate;
            string sDate = string.valueOfGmt(startDate);
            String eDate = string.valueOfGmt(endDate);
            sch = ' 0 5 * * * ?';
             
            RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation_Annual_Plan__c' and Name='Multi Country'];             
             
             Boolean IndoTurkeyVietnamFlag = false;
             Boolean MexicoFlag = false;
             
             List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c where Active__c = true];
             Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            
             String AccountTypeFilter = '(';
             String SalesOrgFilter = '(';
             String MexicoSalesOrgFilter = '(';
             
             for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
                 if(l.Name == 'Indonesia' || l.Name == 'Turkey' || l.Name == 'Vietnam' || l.Name == 'Poland' || l.Name == 'India'){
                     AccountTypeFilter += l.Account_Type_Filter__c+' OR ';
                     SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
                     IndoTurkeyVietnamFlag = true;
                 }  
                 else if(l.Name == 'Mexico'){
                      MexicoSalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
                      MexicoFlag = true;
                 }
             }
             
             //************************ IF INDONESIA/TURKEY ******************************
             if(IndoTurkeyVietnamFlag == true){
                 
             AccountTypeFilter = AccountTypeFilter.removeEnd('OR ') +')';
             SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')';
             
             String query = 'SELECT count(Id), Distributor__c, Distributor__r.SAP_Code__c, SalesOrg__c FROM DistributorSalesAreaMapping__c WHERE '+SalesOrgFilter+' AND '+AccountTypeFilter+' AND Distributor__r.RecordTypeId=\''+RecordTypeId+'\' AND Distributor__r.Active_For_Liquidation__c=true group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c,SalesOrg__c';
             System.debug('query---->'+query);
             /*Creating reference list and Map for fetching other fields which cannot be queried in Indonesia/Turkey 
               main query due to Aggregate restrictions */
             List<DistributorSalesAreaMapping__c> ReferenceSalesAreaList = new List<DistributorSalesAreaMapping__c>();
             String refquery = 'SELECT Distributor__c, Distributor__r.SAP_Code__c, SalesOrg__c, SalesOrg__r.Sales_Org_Code__c FROM DistributorSalesAreaMapping__c WHERE '+SalesOrgFilter+' AND '+AccountTypeFilter+' AND Distributor__r.RecordTypeId=\''+RecordTypeId+'\' AND Distributor__r.Active_For_Liquidation__c=true ';            
             ReferenceSalesAreaList = Database.query(refquery);
                 System.debug('refquery---->'+refquery);
                 System.debug('ReferenceSalesAreaList---->'+ReferenceSalesAreaList);
             Map<String,DistributorSalesAreaMapping__c> refMap = new Map<String,DistributorSalesAreaMapping__c>();
             for(DistributorSalesAreaMapping__c dsam : ReferenceSalesAreaList){
                 refmap.put(dsam.Distributor__c+''+dsam.SalesOrg__c, dsam);
             }
             system.debug('refmap==?>'+refmap);
             
             //Main query for Indo/Turkey
             listOfDistributorSalesAreaMapping = database.query(query);
                 
            String queryliq = 'SELECT Name, Id, FIscal_Year__c, Distributor__c, Fiscal_Start_Date__c, Fiscal_End_Date__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c ='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c ='+eDate.split(' ')[0]+' AND RecordType.Name=\'Multi Country\' AND '+SalesOrgFilter;
            System.debug('queryliq --->'+queryliq );
            listOfLiqAnnualPlan = Database.query(queryliq);
                
            system.debug('ListOfLiqAnnualPlan size>>----->'+listOfLiqAnnualPlan.size());
                if(listOfLiqAnnualPlan.size()==0 && ListOfPeriod.size()>0){
                     system.debug('If>>----->');
                     for(AggregateResult dsa :listOfDistributorSalesAreaMapping){
                         Liquidation_Annual_Plan__c liqAnnlPln = new Liquidation_Annual_Plan__c(); 
                         liqAnnlPln.RecordTypeId= rt.Id;
                         liqAnnlPln.Fiscal_Start_Date__c = ListOfPeriod[0].StartDate;
                         liqAnnlPln.Fiscal_End_Date__c = ListOfPeriod[0].EndDate;
                         liqAnnlPln.FIscal_Year__c = ListOfPeriod[0].StartDate.year()+'-'+ListOfPeriod[0].EndDate.year();
                         liqAnnlPln.Distributor__c = (Id)dsa.get('Distributor__c');
                         liqAnnlPln.Sales_Org__c= (Id)dsa.get('SalesOrg__c');                        
                         liqAnnlPln.Multi_Country_Key__c = refMap.get((Id)dsa.get('Distributor__c')+''+(Id)dsa.get('SalesOrg__c')).Distributor__r.SAP_Code__c+listOfPeriod[0].StartDate.year()+'-'+listOfPeriod[0].EndDate.year()+refMap.get((Id)dsa.get('Distributor__c')+''+(Id)dsa.get('SalesOrg__c')).SalesOrg__r.Sales_Org_Code__c;
                         ListOfLiqAnnualPlanToInsert.add(liqAnnlPln);
                         system.debug('If>>----->'+liqAnnlPln);
                    } 
                }else{
                     system.debug('Else>>----->');
                    }
             }
             // ***********************END OF IF INDO TURKEY ****************************
             
             //************************ IF MEXICO *************************** 
             if(MexicoFlag == true){
                 
                 MexicoSalesOrgFilter = MexicoSalesOrgFilter.removeEnd('OR ') +')';
                 String mexicoQuery = 'SELECT Id, Distributor__c, Sales_Org__c, Distributor__r.SAP_Code__c, Sales_District__c, SAP_Code__c, Sales_Org_Code__c FROM Shipping_Location__c WHERE '+MexicoSalesOrgFilter+' AND Active_for_Liquidation__c = true AND Distributor__r.Active_for_Liquidation__c = true';
                 listOfShippingLocation = database.query(mexicoQuery);
                 
                 String queryMexicoliq = 'SELECT Name, Id, FIscal_Year__c, Distributor__c, Fiscal_Start_Date__c, Fiscal_End_Date__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c ='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c ='+eDate.split(' ')[0]+' AND RecordType.Name=\'Multi Country\' AND '+MexicoSalesOrgFilter;
                 System.debug('queryliq --->'+queryMexicoliq );
                 listOfLiqAnnualPlanForMexico = Database.query(queryMexicoliq);
                 
                      if(listOfLiqAnnualPlanForMexico.size()==0 && ListOfPeriod.size()>0){
                     system.debug('If>>----->');
                     for(Shipping_Location__c SL : listOfShippingLocation){
                         Liquidation_Annual_Plan__c liqAnnlPlnMexico = new Liquidation_Annual_Plan__c(); 
                         liqAnnlPlnMexico.Distributor__c = SL.Distributor__c;
                         liqAnnlPlnMexico.Sales_District__c = SL.Sales_District__c;
                         liqAnnlPlnMexico.RecordTypeId= rt.Id;
                         liqAnnlPlnMexico.Sales_Org__c= SL.Sales_Org__c;
                         liqAnnlPlnMexico.Fiscal_Start_Date__c = ListOfPeriod[0].StartDate;
                         liqAnnlPlnMexico.Fiscal_End_Date__c = ListOfPeriod[0].EndDate;
                         liqAnnlPlnMexico.FIscal_Year__c = ListOfPeriod[0].StartDate.year()+'-'+ListOfPeriod[0].EndDate.year();
                         liqAnnlPlnMexico.Ship_To_Party__c = SL.Id;
                         liqAnnlPlnMexico.Multi_Country_Key__c = SL.Distributor__r.SAP_Code__c+SL.SAP_Code__c+listOfPeriod[0].StartDate.year()+'-'+listOfPeriod[0].EndDate.year()+SL.Sales_Org_Code__c;
                         ListOfLiqAnnualPlanToInsert.add(liqAnnlPlnMexico);
                    } 
                }else{
                     system.debug('Else>>----->');
                    }
               } //************************* END OF IF MEXICO ****************************
              
             //******************* COMMON PART **************************
              if(ListOfLiqAnnualPlanToInsert.size()>0){ 
                     insert ListOfLiqAnnualPlanToInsert;
                 }
                 
              system.debug('listOfLiqAnnualPlan size>>----->'+ListOfLiqAnnualPlan.size());
             
             } //END OF TRY BLOCK
             catch(Exception e){
                 System.debug('Exception>>----->'+e.getLineNumber());
                 System.debug('Exception>>----->'+e.getMessage());
             }
          }
    
}