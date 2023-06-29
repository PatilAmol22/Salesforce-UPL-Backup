global class MultiCountryDistributorLiquidation implements Database.batchable<sObject>{
    
    global MultiCountry_Liquidation__c multiCountry;
    global Id rec_type_OI;
    global Liquidation_Batch_Filters__c batchFilter;
    global String Query = '';
    global Map<Integer,String> MonthMap =new map<Integer,String>();
    global List<Liquidation2__c> LiqToInsert = new List<Liquidation2__c>();
    global String CurrentMonth; 
    global String PreviousMonth; 
    global Integer CurrentYear;
    global String CurrentQuarter; 
    global String PreviousQuarter;
    global Map<Integer,String> QuarterMap =new map<Integer,String>();
        global MultiCountryDistributorLiquidation(String query,Liquidation_Batch_Filters__c bf){
            
            this.Query = query;
            batchFilter = bf;
            System.debug('Query '+Query);
        }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = '';
        query = this.Query; 
        multiCountry = [select Id,Name from MultiCountry_Liquidation__c where Active__c=true limit 1];
        Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Period PeriodYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate, type FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Liquidation_Annual_Plan__c> scope){
        List<SKU__c> ListOfSku = new List<SKU__c>();
        map<string,Opening_Inventory2__c> mapOpeningInventory = new map<string,Opening_Inventory2__c>();   
        string SKUquery = 'SELECT Id, Name, SKU_Code__c, Sales_Org__c FROM SKU__c WHERE Active_For_Liquidation__c= true AND ('+batchFilter.Sales_Org_Filter__c+')';
        ListOfSku = Database.query(SKUquery);
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
        system.debug('Record Type>>-----> '+rt);
        Map<String,Id> openingInvSalesOrg=new Map<String,Id>();
        Id polandSalesOrg=[Select Id from Sales_org__c where name='Poland' and sales_org_code__c='2941' limit 1].id;
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
                        String s=String.valueOf(opnInv2.SKU__c)+String.valueOf(opnInv2.Distributor__c);
                        openingInvSalesOrg.put(s,liqAnnualPlan.Sales_Org__c);
                    }
                } 
            }
            System.debug('openingInvSalesOrg==>'+openingInvSalesOrg);
            liqAnnualPlan.SentToBatch__c = true;
            update liqAnnualPlan;
            insert mapOpeningInventory.values();
            
            System.debug(scope.size());
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
            
            Integer CurrentMonthInDigit = (Date.today()).Month()-1;
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
            
            CurrentMonth = MonthMap.get(CurrentMonthInDigit);
            System.debug('CurrentMonth--->'+CurrentMonth);
            PreviousMonth = MonthMap.get(PreviousMonthInDigit);
            System.debug('PrvMonth--->'+ PreviousMonth);
            
            /*Code for Poland*/
        if(CurrentMonthInDigit<=5 && CurrentMonthInDigit>2){
            CurrentQuarter=QuarterMap.get(4);
            PreviousQuarter=QuarterMap.get(3);
        }
        else if(CurrentMonthInDigit<=8 && CurrentMonthInDigit>5){
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
        }
        system.debug('CurrentQuarter==>'+CurrentQuarter);
        system.debug('PreviousQuarter==>'+PreviousQuarter);
        
            
            /* Appending previous month to the multi country key of scope (Opening Inv) and storing it in a set for quering on it */
            Set<String> MultiCountryKeys = new Set<String>();
            for(Opening_Inventory2__c o : mapOpeningInventory.values()){
                MultiCountryKeys.add(o.Multi_Country_Key__c+String.Valueof(PreviousMonth));
                MultiCountryKeys.add(o.Multi_Country_Key__c+String.Valueof(PreviousQuarter));
            }
            System.debug('MCK ---> '+MultiCountryKeys);
            
            /* Quering and storing previous month liquidation data in a Map */             
            List<Liquidation2__c> LastMonthLiqData = new List<Liquidation2__c>();  
            Map <String,Liquidation2__c> LastMonthLiqDataMap = new Map<String,Liquidation2__c>();
            LastMonthLiqData = [SELECT Multi_Country_Key__c, Plan_for_the_next_month__c 
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
            for(Opening_Inventory2__c oi : mapOpeningInventory.values()){
                String s=String.valueOf(oi.SKU__c)+String.valueOf(oi.Distributor__c);
                if(openingInvSalesOrg.get(s)!=polandSalesOrg){
                    system.debug('inside if');
                Liquidation2__c liq = new Liquidation2__c(); 
                if(oi.Ship_To_Party__c!=null){
                    liq.Ship_To_Party__c = oi.Ship_To_Party__c;
                    //       liq.Mexico_Sub_Region_Head_access__c = oi.Mexico_Sub_Region_Head_access__c;
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
                system.debug('MultiKey+Month for Map ---->'+(oi.Multi_Country_Key__c+PreviousMonth));
                if(LastMonthLiqDataMap.containsKey(oi.Multi_Country_Key__c+PreviousMonth)){
                    system.debug('IF');
                    liq.Plan_for_the_month__c = LastMonthLiqDataMap.get(oi.Multi_Country_Key__c+PreviousMonth).Plan_for_the_next_month__c; 
                }
                else{
                    system.debug('else');
                    liq.Plan_for_the_month__c = 0;
                }
                liq.Liquidation_Annual_Plan__c = oi.Liquidation_Annual_Plan__c;
                liq.Month__c = CurrentMonth;
                //    liq.Month__c = 'Jan';
                liq.Opening_Inventory2__c = oi.Id;
                liq.Plan_for_the_next_month__c = 0;
                liq.Retailers_Inventory__c = 0;
                liq.Sales_District__c = oi.Distributor__r.Sales_District__c;
                liq.SKU__c = oi.SKU__c; 
                liq.Multi_Country_Key__c = oi.Multi_Country_Key__c+CurrentMonth;
                //    liq.Multi_Country_Key__c = oi.Multi_Country_Key__c+'Jan';
                LiqToInsert.add(liq);
                oi.Sent_to_Batch__c = true;
                System.debug('Tst --->'+LiqToInsert);
                }
                 else{
                     system.debug('inside else');
               // if(CurrentMonth=='Dec' ||CurrentMonth=='Mar' ||CurrentMonth=='Jun' ||CurrentMonth=='Sept'){
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
                // }
            }
            if(LiqToInsert.size()>0){
                insert LiqToInsert;
                update mapOpeningInventory.values();
            }
        }  
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
}