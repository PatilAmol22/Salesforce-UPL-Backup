global class ClonedMultiCountryLiqAnnualPlanScheduler implements Schedulable{
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
            
            endDate = listOfPeriod[0].EndDate; 
            startDate = listOfPeriod[0].StartDate;
            string sDate = string.valueOfGmt(startDate);
            String eDate = string.valueOfGmt(endDate);
            sch = ' 0 5 * * * ?';
             
            RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation_Annual_Plan__c' and Name='Multi Country'];             
             
             Boolean IndoTurkeyVietnamFlag = false;
             Boolean MexicoFlag = false;
             
             //querying batch filters for Mexico
             //List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c where Active__c = true];
             List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c where Active__c = true and Name='Mexico'];
             Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
            
             String AccountTypeFilter = '(';
             String SalesOrgFilter = '(';
             String MexicoSalesOrgFilter = '(';
             
             for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
                 if(l.Name == 'Mexico'){
                      MexicoSalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
                      MexicoFlag = true;
                 }
             }
             
             //************************ IF INDONESIA/TURKEY ******************************
             //DONT EXECUTE BATCH FOR "COUNTRY":"TURKEY"
            
             // ***********************END OF IF INDO TURKEY ****************************
             
             //************************ IF MEXICO *************************** 
             if(MexicoFlag == true){
                 String distributor_SAP_codes=System.Label.NewMexicoDistributors;
                 MexicoSalesOrgFilter = MexicoSalesOrgFilter.removeEnd('OR ') +')';
                 String mexicoQuery = ''; 
                 if(Test.isRunningTest()){
                    mexicoQuery = 'SELECT Id, Distributor__c, Sales_Org__c, Distributor__r.SAP_Code__c, Sales_District__c, SAP_Code__c, Sales_Org_Code__c FROM Shipping_Location__c WHERE Sales_Org_Code__c =\'5100\' AND Active_for_Liquidation__c = true AND Distributor__r.Active_for_Liquidation__c = true AND Distributor__r.SAP_Code__c IN (\'0001007824\')';
                 }else{
                    mexicoQuery = 'SELECT Id, Distributor__c, Sales_Org__c, Distributor__r.SAP_Code__c, Sales_District__c, SAP_Code__c, Sales_Org_Code__c FROM Shipping_Location__c WHERE Sales_Org_Code__c =\'5100\' AND Active_for_Liquidation__c = true AND Distributor__r.Active_for_Liquidation__c = true AND Distributor__r.SAP_Code__c IN '+distributor_SAP_codes;    
                 }
                 listOfShippingLocation = database.query(mexicoQuery);
                 System.debug('listOfShippingLocation >>>>>>>>' +listOfShippingLocation);
                 
                 /*String queryMexicoliq = 'SELECT Name, Id, FIscal_Year__c, Distributor__c, Fiscal_Start_Date__c, Fiscal_End_Date__c FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c ='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c ='+eDate.split(' ')[0]+' AND RecordType.Name=\'Multi Country\' AND  Sales_Org_Code__c =\'5100\'';
                 System.debug('queryliq --->'+queryMexicoliq );
                 listOfLiqAnnualPlanForMexico = Database.query(queryMexicoliq);*/
                 //ignore if block - dont check if the liquidation anual plan was already created for this FY
                      if(ListOfPeriod.size()>0){
                    
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
                 
              
             
             } //END OF TRY BLOCK
             catch(Exception e){
                 System.debug('Exception>>----->'+e.getLineNumber());
                 System.debug('Exception>>----->'+e.getMessage());
             }
          }
    
}