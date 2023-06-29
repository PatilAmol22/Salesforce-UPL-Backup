global class ClonedMonthlyLiquidationBatch implements Database.Batchable<sObject>{
    global Map<Integer,String> MonthMap =new map<Integer,String>();
    global Map<Integer,String> QuarterMap =new map<Integer,String>();
    global List<Liquidation2__c> LiqToInsert = new List<Liquidation2__c>();
    public boolean automationORnot { get; set; }     //Sku Automation  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */ 
    global String CurrentMonth; 
    global String PreviousMonth;
    global String CurrentQuarter; 
    global String PreviousQuarter;
    global Integer CurrentYear;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        MonthMap.put(1,'Jan');
        MonthMap.put(2,'Feb');
        MonthMap.put(3,'Mar');
        MonthMap.put(4,'Apr');
        MonthMap.put(5,'May');
        MonthMap.put(6,'Jun');
        MonthMap.put(7,'Jul');
        MonthMap.put(8,'Aug');
        MonthMap.put(9,'Sept');
        MonthMap.put(10,'Oct');
        MonthMap.put(11,'Nov');
        MonthMap.put(12,'Dec');   
        
        QuarterMap.put(1,'Quarter 1');
        QuarterMap.put(2,'Quarter 2');
        QuarterMap.put(3,'Quarter 3');
        QuarterMap.put(4,'Quarter 4');
        
        String FiscalYear;
        Integer CurrentMonthInDigit;
        
        List<MultiCountry_Liquidation__c> montlyLiquidation = [SELECT Active_Month__c,Month__c,Name,Previous_Month__c from MultiCountry_Liquidation__c where Name='Mexico' and Active_Month__c=true LIMIT 1];
        System.debug('montlyLiquidation >>>>>>>>>>' +montlyLiquidation);
        
        
        
        List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Distributor_Filter__c, Sales_District_Filter__c,Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c Where Active__c = true AND Name='Mexico' LIMIT 1];
       
        CurrentMonthInDigit = (Date.today()).Month()-1;
       
        
        if(CurrentMonthInDigit==0){
            CurrentMonthInDigit = 12;
        }
        
        Integer PreviousMonthInDigit = (Date.today()).Month()-2;
        if(PreviousMonthInDigit== -1){
            PreviousMonthInDigit = 11;
        } 
        else if(PreviousMonthInDigit== 0){
            PreviousMonthInDigit =12;
        } 
        system.debug('PreviousMonthInDigit==>'+PreviousMonthInDigit);
        if(montlyLiquidation[0] != null && montlyLiquidation[0].Month__c!=null){
            CurrentMonth = montlyLiquidation[0].Month__c;
        }else{
            CurrentMonth = MonthMap.get(CurrentMonthInDigit);
        }
        System.debug('CurrentMonth--->'+CurrentMonth);
        if(montlyLiquidation[0] != null && montlyLiquidation[0].Previous_Month__c!=null){
            PreviousMonth = montlyLiquidation[0].Previous_Month__c;
        }else{
            PreviousMonth = MonthMap.get(PreviousMonthInDigit);
        }
        System.debug('PrvMonth--->'+ PreviousMonth);
        if(Test.isRunningTest()){
            CurrentYear =2023;
        }
        else{
            CurrentYear = Date.Today().Year();
        }
        
        /*Code for Poland*/
        if(CurrentMonthInDigit<=5 && CurrentMonthInDigit>2){
            CurrentQuarter=QuarterMap.get(4);
            PreviousQuarter=QuarterMap.get(3);
        }
        /*else if(CurrentMonthInDigit<=8 && CurrentMonthInDigit>5){
            CurrentQuarter=QuarterMap.get(1);
            PreviousQuarter=QuarterMap.get(4);
        }
        else if(CurrentMonthInDigit<=11 && CurrentMonthInDigit>8){
            CurrentQuarter=QuarterMap.get(2);
            PreviousQuarter=QuarterMap.get(1);
        }
        else{
            CurrentQuarter=QuarterMap.get(3);
            PreviousQuarter=QuarterMap.get(2);
        }*/
        system.debug('CurrentQuarter==>'+CurrentQuarter);
        system.debug('PreviousQuarter==>'+PreviousQuarter);
        if(CurrentMonth=='Dec' || CurrentMonth=='Jan' || CurrentMonth=='Feb' || CurrentMonth=='Mar')
        {
            FiscalYear = (CurrentYear-1)+'-'+(CurrentYear);
        }
        else{
            FiscalYear = CurrentYear+'-'+(CurrentYear+1);
        }
        
        
        
        String DistributorFilter='(';
        String SalesDistrictFilter ='(';
        String Filter = '';
        String SalesOrgFilter = '(';
        
        /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
        String PolandLastFY = '';
        String DistributorFilterPoland='';
        String SalesDistrictFilterPoland ='';
        String FilterPoland = '';
        String SalesOrgFilterPoland = '';
        /* -- */
        /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
        if((CurrentMonth == 'Apr' || CurrentMonth == 'May') && automationORnot == true) {    //Sku Automation (IF)  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */ 
            for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
                if(l.name == 'Poland'){
                   
                }else{
                    
                    if(l.Distributor_Filter__c!= null){
                        DistributorFilter += l.Distributor_Filter__c+' OR ';
                    }
                    if(l.Sales_District_Filter__c!= null){
                        SalesDistrictFilter += l.Sales_District_Filter__c+' OR ';
                    }
                    
                    SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
                }
            }
            
            SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')'; 
            Filter = SalesOrgFilter;
            System.debug('DistributorFilter--->'+DistributorFilter);
            System.debug('SalesDistrictFilter---->'+SalesDistrictFilter);
            if(DistributorFilter!='('){
                DistributorFilter = DistributorFilter.removeEnd('OR ') +')';          
                Filter += ' AND '+DistributorFilter;
            }
            if(SalesDistrictFilter!='('){
                SalesDistrictFilter = SalesDistrictFilter.removeEnd('OR ') +')';
                Filter += ' AND '+SalesDistrictFilter;
            }
            
            
            FilterPoland = SalesOrgFilterPoland;
            //System.debug('DistributorFilter--->'+DistributorFilter);
            //System.debug('SalesDistrictFilter---->'+SalesDistrictFilter);
            if(DistributorFilterPoland !='' && DistributorFilterPoland != null){
                //DistributorFilter = DistributorFilter.removeEnd('OR ') +')';          
				//FilterPoland += ' AND '+DistributorFilterPoland;
            }
            if(SalesDistrictFilterPoland!='' && SalesDistrictFilterPoland != null){
                // SalesDistrictFilter = SalesDistrictFilter.removeEnd('OR ') +')';
               // FilterPoland += ' AND '+SalesDistrictFilterPoland;
            }
            
        }
        else{
            /*for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
                System.debug('l.Distributor_Filter__c---->'+l.Distributor_Filter__c); 
                System.debug('l.Sales_District_Filter__c---->'+l.Sales_District_Filter__c); 
                if(l.Distributor_Filter__c!= null){
                    DistributorFilter += l.Distributor_Filter__c+' OR ';
                }
                if(l.Sales_District_Filter__c!= null){
                    SalesDistrictFilter += l.Sales_District_Filter__c+' OR ';
                }
                
                SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
            }
            
            SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')'; 
            Filter = SalesOrgFilter;
            System.debug('DistributorFilter--->'+DistributorFilter);
            System.debug('SalesDistrictFilter---->'+SalesDistrictFilter);
            if(DistributorFilter!='('){
                DistributorFilter = DistributorFilter.removeEnd('OR ') +')';          
                Filter += ' AND '+DistributorFilter;
            }
            if(SalesDistrictFilter!='('){
                SalesDistrictFilter = SalesDistrictFilter.removeEnd('OR ') +')';
                Filter += ' AND '+SalesDistrictFilter;
            }*/
        }
        /* -- */
        system.debug('Filter-->>'+Filter);
        system.debug('FiscalYear-->>'+FiscalYear);
        
        String query = '';
        if(FilterPoland !=''){              //Sku Automation (IF)
            //query = 'SELECT Id,Sales_Org_Code__c, Sent_to_Batch__c, Ship_To_Party__c, Ship_To_Party__r.User__c, Sales_District__c, Sales_District__r.User__c, Distributor__c, Distributor__r.Sales_District__c, SKU__c, Multi_Country_Key__c, Multi_Country_Formula_Key__c, Liquidation_Annual_Plan__c, Mexico_Sub_Region_Head_access__c FROM Opening_Inventory2__c where RecordType.Name = \'Multi Country\' AND SKU__r.Active_for_liquidation__c = true AND Sent_to_Batch__c = false AND ((Liquidation_Annual_Plan__r.FIscal_Year__c =\''+FiscalYear+'\' AND '+Filter + ') OR (Liquidation_Annual_Plan__r.FIscal_Year__c =\''+PolandLastFY+'\' AND '+FilterPoland + '))';
        }
        else{
            query = 'SELECT Id,Sales_Org_Code__c, Sent_to_Batch__c, Ship_To_Party__c, Ship_To_Party__r.User__c, Sales_District__c, Sales_District__r.User__c, Distributor__c, Distributor__r.Sales_District__c, SKU__c, Multi_Country_Key__c, Multi_Country_Formula_Key__c, Liquidation_Annual_Plan__c, Mexico_Sub_Region_Head_access__c FROM Opening_Inventory2__c where RecordType.Name = \'Multi Country\' AND SKU__r.Active_for_liquidation__c = true AND Sent_to_Batch__c = false AND Liquidation_Annual_Plan__r.FIscal_Year__c =\''+FiscalYear+'\' AND Sales_Org_Code__c = \'5100\'';
        }
        
        System.debug('query----->'+query);
        // system.debug('result==>'+Database.getQueryLocator(query));
        system.debug('automationORnot==>'+automationORnot);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opening_Inventory2__c> scope ) {
        System.debug('scope->'+scope.size());
        MonthMap.put(1,'Jan');
        MonthMap.put(2,'Feb');
        MonthMap.put(3,'Mar');
        MonthMap.put(4,'Apr');
        MonthMap.put(5,'May');
        MonthMap.put(6,'Jun');
        MonthMap.put(7,'Jul');
        MonthMap.put(8,'Aug');
        MonthMap.put(9,'Sept');
        MonthMap.put(10,'Oct');
        MonthMap.put(11,'Nov');
        MonthMap.put(12,'Dec'); 
        
        QuarterMap.put(1,'Quarter 1');
        QuarterMap.put(2,'Quarter 2');
        QuarterMap.put(3,'Quarter 3');
        QuarterMap.put(4,'Quarter 4');
        
        List<MultiCountry_Liquidation__c> montlyLiquidation = [select Active_Month__c,Month__c,Name,Previous_Month__c from MultiCountry_Liquidation__c where Name='Mexico' and Active_Month__c=true];
        List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Distributor_Filter__c, Sales_District_Filter__c,Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c Where Active__c = true and Name='Mexico'];
        Integer CurrentMonthInDigit;
        CurrentMonthInDigit = (Date.today()).Month()-1;
        
        if(CurrentMonthInDigit==0){
            CurrentMonthInDigit = 12;
        }
        
        Integer PreviousMonthInDigit = (Date.today()).Month()-2;
        if(PreviousMonthInDigit== -1){
            PreviousMonthInDigit = 11;
        } 
        else if(PreviousMonthInDigit== 0){
            PreviousMonthInDigit =12;
        } 
        
        if(montlyLiquidation[0].Month__c!=null && montlyLiquidation.size()>0){
            CurrentMonth = montlyLiquidation[0].Month__c;
        }else{
            CurrentMonth = MonthMap.get(CurrentMonthInDigit);
            // CurrentMonth = 'Sept';
        }
        
        System.debug('CurrentMonth--->'+CurrentMonth);
        if(montlyLiquidation[0].Previous_Month__c!=null && montlyLiquidation.size()>0){
            PreviousMonth = montlyLiquidation[0].Previous_Month__c;
        }else{
            PreviousMonth = MonthMap.get(PreviousMonthInDigit);
        }
        System.debug('PrvMonth--->'+ PreviousMonth);
        
        /*Code for Poland*/
        if(CurrentMonthInDigit<=5 && CurrentMonthInDigit>2){
            CurrentQuarter=QuarterMap.get(4);
            PreviousQuarter=QuarterMap.get(3);
        }
       /* else if(CurrentMonthInDigit<=8 && CurrentMonthInDigit>5){
            CurrentQuarter=QuarterMap.get(1);
            PreviousQuarter=QuarterMap.get(4);
        }
        else if(CurrentMonthInDigit<=11 && CurrentMonthInDigit>8){
            CurrentQuarter=QuarterMap.get(2);
            PreviousQuarter=QuarterMap.get(1);
        }
        else{
            CurrentQuarter=QuarterMap.get(3);
            PreviousQuarter=QuarterMap.get(2);
        }*/
        system.debug('CurrentQuarter==>'+CurrentQuarter);
        system.debug('PreviousQuarter==>'+PreviousQuarter);
        /* Appending previous month to the multi country key of scope (Opening Inv) and storing it in a set for quering on it */
        Set<String> MultiCountryKeys = new Set<String>();
        for(Opening_Inventory2__c o : scope){
            MultiCountryKeys.add(o.Multi_Country_Key__c+String.Valueof(PreviousMonth));
            MultiCountryKeys.add(o.Multi_Country_Key__c+String.Valueof(PreviousQuarter));
        }
        System.debug('MCK ---> '+MultiCountryKeys);
        
        /* Quering and storing previous month liquidation data in a Map */             
        List<Liquidation2__c> LastMonthLiqData = new List<Liquidation2__c>();  
        Map <String,Liquidation2__c> LastMonthLiqDataMap = new Map<String,Liquidation2__c>();
        LastMonthLiqData = [SELECT Multi_Country_Key__c, Plan_for_the_next_month__c,Plan_for_the_next_quarter__c 
                            FROM Liquidation2__c
                            WHERE Multi_Country_Key__c IN :MultiCountryKeys
                            AND (Month__c = :PreviousMonth or Quarter__c = :PreviousQuarter)];
        system.debug('last month list '+LastMonthLiqData);
        for(Liquidation2__c l : LastMonthLiqData){
            LastMonthLiqDataMap.put(l.Multi_Country_Key__c,l);
            system.debug('MAP --->' +LastMonthLiqDataMap);
        }  
        
        /* Creating liq data for current month */
        Id Rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId(); 
        system.debug('scope '+scope);
        for(Opening_Inventory2__c oi : scope){
            //if(oi.Sales_Org_Code__c!='2941'){}
            //else{
                if(Test.isRunningTest()){
                    CurrentMonth ='Dec';
                   //automationORnot =true;
                }
                System.debug('automationORnot'+automationORnot);
                if(automationORnot == true){                         //Sku Automation (IF) /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
                    
                    Liquidation2__c liq = new Liquidation2__c(); 
                    if(oi.Ship_To_Party__c!=null){
                        liq.Ship_To_Party__c = oi.Ship_To_Party__c;
                        liq.Mexico_Sub_Region_Head_access__c = oi.Mexico_Sub_Region_Head_access__c;
                        if(oi.Ship_To_Party__r.User__c!=null){
                            liq.OwnerId = oi.Ship_To_Party__r.User__c;
                        }
                    }     
                    if(oi.Sales_District__r.User__c!=null){
                        liq.OwnerId = oi.Sales_District__r.User__c;
                    }  
                    liq.RecordTypeId = Rec_type_liquidation;
                    liq.Distributor__c = oi.Distributor__c;
                    liq.Distributors_Inventory__c = 0;
                    system.debug('MultiKey+Month for Map ---->'+(oi.Multi_Country_Key__c+PreviousQuarter));
                    if(LastMonthLiqDataMap.containsKey(oi.Multi_Country_Key__c+PreviousQuarter)){
                        system.debug('IF');
                        liq.Plan_for_the_Quarter__c = LastMonthLiqDataMap.get(oi.Multi_Country_Key__c+PreviousQuarter).Plan_for_the_next_Quarter__c; 
                    }
                    else{
                        system.debug('else');
                        liq.Plan_for_the_Quarter__c = 0;
                    }
                    
                    liq.Liquidation_Annual_Plan__c = oi.Liquidation_Annual_Plan__c;
                    liq.Quarter__c = CurrentQuarter;
                    liq.Opening_Inventory2__c = oi.Id;
                    liq.Plan_for_the_next_Quarter__c = 0;
                    liq.SKU__c = oi.SKU__c; 
                    liq.Multi_Country_Key__c = oi.Multi_Country_Key__c+CurrentQuarter;
                    LiqToInsert.add(liq);
                    oi.Sent_to_Batch__c = true;
                    System.debug('Tst --->'+LiqToInsert);
                }else{
                    if(CurrentMonth=='Dec' ||CurrentMonth=='Mar' ||CurrentMonth=='Jun' ||CurrentMonth=='Sept'){
                        Liquidation2__c liq = new Liquidation2__c(); 
                        if(oi.Ship_To_Party__c!=null){
                            liq.Ship_To_Party__c = oi.Ship_To_Party__c;
                            liq.Mexico_Sub_Region_Head_access__c = oi.Mexico_Sub_Region_Head_access__c;
                            if(oi.Ship_To_Party__r.User__c!=null){
                                liq.OwnerId = oi.Ship_To_Party__r.User__c;
                            }
                        }     
                        if(oi.Sales_District__r.User__c!=null){
                            liq.OwnerId = oi.Sales_District__r.User__c;
                        }  
                        liq.RecordTypeId = Rec_type_liquidation;
                        liq.Distributor__c = oi.Distributor__c;
                        liq.Distributors_Inventory__c = 0;
                        system.debug('MultiKey+Month for Map ---->'+(oi.Multi_Country_Key__c+PreviousQuarter));
                        if(LastMonthLiqDataMap.containsKey(oi.Multi_Country_Key__c+PreviousQuarter)){
                            system.debug('IF');
                            liq.Plan_for_the_Quarter__c = LastMonthLiqDataMap.get(oi.Multi_Country_Key__c+PreviousQuarter).Plan_for_the_next_Quarter__c; 
                        }
                        else{
                            system.debug('else');
                            liq.Plan_for_the_Quarter__c = 0;
                        }
                        
                        liq.Liquidation_Annual_Plan__c = oi.Liquidation_Annual_Plan__c;
                        liq.Quarter__c = CurrentQuarter;
                        liq.Opening_Inventory2__c = oi.Id;
                        liq.Plan_for_the_next_Quarter__c = 0;
                        liq.SKU__c = oi.SKU__c; 
                        liq.Multi_Country_Key__c = oi.Multi_Country_Key__c+CurrentQuarter;
                        LiqToInsert.add(liq);
                        oi.Sent_to_Batch__c = true;
                        System.debug('Tst --->'+LiqToInsert);
                    }
                }
                
            //}
        }
        if(LiqToInsert.size()>0){
            insert LiqToInsert;
            update scope;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}