/* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-07-2022 */  
public class SKU_Trigger_Handler {
    public static void automation(list<sku__c> skuList, map<id,sku__c> skuMap){
    Integer CurrentMonthInDigit;
    CurrentMonthInDigit = (Date.today()).Month()-1;
    // CurrentMonthInDigit = 6;
    list<Opening_Inventory2__c> mapOpeningInventory = new list<Opening_Inventory2__c>();
    String AccountTypeFilter = '(';
    String SalesOrgFilter = '(';
    String SalesOrgFilterPoland = '';
    List<Liquidation_Batch_Filters__c> LiquidationBatchFilters= [SELECT Id, Name, Sales_Org_Filter__c, Active__c, Account_Type_Filter__c FROM Liquidation_Batch_Filters__c Where Active__c = true]; 
    system.debug('LiquidationBatchFilters'+LiquidationBatchFilters);
    for(Liquidation_Batch_Filters__c l : LiquidationBatchFilters){
        if(l.name == 'Poland'){
            SalesOrgFilterPoland = l.Sales_Org_Filter__c;              
        }
        // else{
        AccountTypeFilter += l.Account_Type_Filter__c+' OR ';
        SalesOrgFilter += l.Sales_Org_Filter__c+ ' OR ';
        //}
        
    }
    AccountTypeFilter = AccountTypeFilter.removeEnd('OR ') +')';
    SalesOrgFilter = SalesOrgFilter.removeEnd('OR ') +')';
    
    STring Q1 = '';
    
    if(Test.isRunningTest()){
        CurrentMonthInDigit = 4;
    }else{
        CurrentMonthInDigit = (Date.today()).Month()-1;
    }
    if(CurrentMonthInDigit == 3){
        Integer lastYear;
        lastYear = (Date.today()).year()-1;
        Date myDate = Date.newInstance(lastYear, 4, 01);
        list<Period> lastYearPeriod = new list<Period>();
        lastYearPeriod = [SELECT FiscalYearSettings.Name,StartDate,EndDate,type  FROM Period WHERE Type = 'Year' AND StartDate <=: myDate AND EndDate >=: myDate];
        if(lastYearPeriod.size() > 0){
            Date endDate;
            Date startDate;
            endDate = lastYearPeriod[0].EndDate; 
            startDate = lastYearPeriod[0].StartDate;    
            string sDate = string.valueOfGmt(startDate);
            String eDate = string.valueOfGmt(endDate);
            Q1 = '( Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+')';
        }
    }else if((CurrentMonthInDigit == 4 || CurrentMonthInDigit == 5) && SalesOrgFilterPoland != ''){
        Integer lastYear;
        lastYear = (Date.today()).year()-1;
        Date myDate = Date.newInstance(lastYear, 4, 01);
        list<Period> lastYearPeriod = new list<Period>();
        lastYearPeriod = [SELECT FiscalYearSettings.Name,StartDate,EndDate,type  FROM Period WHERE Type = 'Year' AND StartDate <=: myDate AND EndDate >=: myDate];
        if(lastYearPeriod.size() > 0){
            Date endDate;
            Date startDate;
            endDate = lastYearPeriod[0].EndDate; 
            startDate = lastYearPeriod[0].StartDate;    
            string sDate = string.valueOfGmt(startDate);
            String eDate = string.valueOfGmt(endDate);
            Q1 = '( Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+'';
            if(SalesOrgFilterPoland != ''){
                Q1 = Q1+' AND '+SalesOrgFilterPoland+')';                    
            }else{
                Q1 = Q1+')';
            }
            
        }
    }
    
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
        
        string queryliq = '';
        if(Q1 != ''){
            queryliq = 'SELECT Name,Id,Ship_To_Party__c,Sales_Org__c,SentToBatch__c,FIscal_Year__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE RecordType.Name=\''+String.escapeSingleQuotes(recordTypeName) +'\' ';
            if(SalesOrgFilter != '' && SalesOrgFilter != '()'){
                queryliq = queryliq+ 'AND '+SalesOrgFilter;
            }
            queryliq = queryliq+' AND (( Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+') OR ' + Q1+')';
        }else{
            queryliq = 'SELECT Name,Id,Ship_To_Party__c,Sales_Org__c,SentToBatch__c,FIscal_Year__c,Distributor__c,Fiscal_Start_Date__c,Fiscal_End_Date__c,Multi_Country_Key__c FROM Liquidation_Annual_Plan__c WHERE RecordType.Name=\''+String.escapeSingleQuotes(recordTypeName) +'\' AND  Fiscal_Start_Date__c <='+sDate.split(' ')[0]+' AND Fiscal_End_Date__c >='+eDate.split(' ')[0]+'';
            if(SalesOrgFilter != ''  && SalesOrgFilter != '()'){
                queryliq = queryliq+' AND '+SalesOrgFilter;
            }
        }
        
        System.debug(queryliq);
        
        
        lstLiqdtnAnnlPln = Database.query(queryliq);
        
        
        
        Id rt =	Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();            
        //RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
        system.debug('Record Type>>-----> '+rt);
        system.debug('lstLiqdtnAnnlPln -->> '+ lstLiqdtnAnnlPln);
        system.debug('trigger.new'+ skuList);
        For(Liquidation_Annual_Plan__c  liqAnnualPlan : lstLiqdtnAnnlPln ){ 
            For(SKU__c sku: skuList){
                if(sku.active_for_Liquidation__c == true){
                    
                    if(sku.active_for_Liquidation__c != (skuMap.get(sku.id)).active_for_Liquidation__c){
                        system.debug('sku'+ sku);
                        system.debug('liqAnnualPlan.Sales_Org__c'+ liqAnnualPlan.Sales_Org__c);
                        system.debug('sku.Sales_Org__c'+ sku.Sales_Org__c);
                        if(liqAnnualPlan.Sales_Org__c == sku.Sales_Org__c) {
                            Opening_Inventory2__c opnInv2=new Opening_Inventory2__c();
                            if(LiqAnnualPlan.Ship_To_Party__c!=null){
                                opnInv2.Ship_To_Party__c = LiqAnnualPlan.Ship_To_Party__c;
                            }                
                            opnInv2.SKU__c= sku.Id;
                            opnInv2.RecordTypeId= rt;
                            opnInv2.Liquidation_Annual_Plan__c= liqAnnualPlan.id;
                            opnInv2.Distributor__c= liqAnnualPlan.Distributor__c;  
                            opnInv2.Multi_Country_Key__c = sku.SKU_Code__c + liqAnnualPlan.Multi_Country_Key__c;
                            
                            system.debug('mapOpeningInventory.size()'+mapOpeningInventory.size());
                            //if(!mapOpeningInventory.containskey(sku.Id)){
                            //     system.debug('IFF');
                            mapOpeningInventory.add(opnInv2);
                            //  }
                        } //End of first If
                    }
                }
                
            }   
        }  
        system.debug('mapOpeningInventory'+mapOpeningInventory);
        insert mapOpeningInventory;
        
        if(!test.isRunningTest()){
            if(mapOpeningInventory.size()> 0){
                system.debug('test');
                MultiCountryMonthlyLiquidationBatch opnInvBtObj = new MultiCountryMonthlyLiquidationBatch(); 
                opnInvBtObj.automationORnot = true;
                database.executeBatch(opnInvBtObj);
                
               
               
                
            }
        }
        
        
    } 
    }
	
	
	
	 // Add Below Method for RITM0449691  GRZ(Dheeraj Sharma) 27-12-2022 
    public static void caseSkuUnitCostUpdate(list<sku__c> skuList,  map<id,sku__c> skuMap){
        Map<Id , sku__c> skMap = new  Map<Id , sku__c>();   
        Set<Id> ids=new Set<Id>();
        for(Sku__c sk : skuList){
            if((sk.Sales_Org_Code__c == '3100' || sk.Sales_Org_Code__c =='3710') && sk.unit_cost__c != (skuMap.get(sk.id)).unit_cost__c){
                skMap.put(sk.id,sk);  
            }
        }
        List<Case> caseList =new List<Case>();
        for(Case css :[SELECT Id ,Sku_Unit_Cost__c,pack_Size_Sku__c ,AccountId from Case where Pack_Size_SKU__c In: skMap.Keyset()]){
            if(skMap.containsKey(css.pack_Size_Sku__c)){
                css.Sku_Unit_Cost__c = skMap.get(css.pack_Size_Sku__c).Unit_Cost__c;   
                caseList.add(css);
            }
        }
        if(caseList!=null || caseList.size()>0 ){
            update caseList;
        }
    }    
    // End Method for RITM0449691  GRZ(Dheeraj Sharma) 27-12-2022 
	
}