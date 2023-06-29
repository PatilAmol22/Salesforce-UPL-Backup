global class LiquidationAnnualPlanSchedular implements Schedulable  {

    public list<Territory_Distributor__c> lstTerritory;
    public list<Liquidation_Annual_Plan__c> lstLiqAnnlPln;
    public list<Liquidation_Annual_Plan__c> lstLiqAnnlPln1;
    public list<Period> lstPeriod;
    public date startDate;
    public date endDate;
    public String sch;
    public list<Sales_Org__c> orgList;
    
     global void execute(SchedulableContext SC) {
         try{   
            lstTerritory = new list<Territory_Distributor__c>();
            lstLiqAnnlPln1  = new list<Liquidation_Annual_Plan__c>();
            lstLiqAnnlPln = new list<Liquidation_Annual_Plan__c>();
            lstPeriod = new list<Period>();
             
            lstTerritory = [SELECT Id, Name,TerritoryCode__c, SalesOrg__c, Sales_Org_Code__c FROM Territory_Distributor__c WHERE Present_in_KEDE__c = true AND Neglected__c = false AND TerritoryCode__c != '#' AND Sales_Org_Code__c='1000'];
            system.debug('lstTerritory size>>----->'+lstTerritory.size());
            
            orgList=[select Id, Name from Sales_Org__c where Sales_Org_Code__c='1000'];
            
            lstPeriod = [SELECT FiscalYearSettings.Name , StartDate,EndDate, type  FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
            system.debug('lstPeriod size>>----->'+lstPeriod.size());
            endDate = lstPeriod[0].EndDate; 
            startDate = lstPeriod[0].StartDate;
            sch = ' 0 5 * * * ?';
           RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation_Annual_Plan__c' and Name='Trade'];
            lstLiqAnnlPln  = [SELECT Name, Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, Fiscal_End_Date__c 
                                     FROM Liquidation_Annual_Plan__c WHERE Fiscal_Start_Date__c =:startDate AND Fiscal_End_Date__c =:endDate AND RecordType.Name='Trade' AND Sales_Org__r.Sales_Org_Code__c='1000' ];
             
            system.debug('lstLiqAnnlPln size>>----->'+lstLiqAnnlPln.size());
                if(lstLiqAnnlPln.size()==0 && lstPeriod.size()>0){
                     system.debug('If>>----->');
                     for(Territory_Distributor__c  ter :lstTerritory){
                         Liquidation_Annual_Plan__c liqAnnlPln = new Liquidation_Annual_Plan__c(); 
                         liqAnnlPln.RecordTypeId= rt.Id;
                         liqAnnlPln.Fiscal_Start_Date__c = lstPeriod[0].StartDate;
                         liqAnnlPln.Fiscal_End_Date__c = lstPeriod[0].EndDate;
                         liqAnnlPln.FIscal_Year__c = lstPeriod[0].StartDate.year()+'-'+lstPeriod[0].EndDate.year();
                         liqAnnlPln.Territory_Name__c = ter.id;
                         liqAnnlPln.Sales_Org__c=orgList[0].id;
                         //liqAnnlPln.Sales_Qty_External_Key_Annual_Plan__c = ter.TerritoryCode__c + lstPeriod[0].StartDate.year()+'-'+lstPeriod[0].EndDate.year();
                         lstLiqAnnlPln1.add(liqAnnlPln);
                         system.debug('If>>----->'+liqAnnlPln);
                    } 
                }else{
                     system.debug('Else>>----->');
                    }
                 if(lstLiqAnnlPln1.size()>0){ 
                     insert lstLiqAnnlPln1;
                 }
                 
                 system.debug('lstLiqAnnlPln size>>----->'+lstLiqAnnlPln.size());
             }
             catch(Exception e){
                 System.debug('Exception>>----->'+e);
             }
          }
    
}