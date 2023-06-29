/*
     Class Name : LiquidationAnnualPlanOpenInventoryBatch
     Description : Batch class to create the LAP and Opening Inventory records for AF and SWAl at start of financial year. will run on 23rd April
     Author : Bonny Mathews
     Date : 21/11/2022
 */
global class LiquidationAnnualPlanOpenInventoryBatch implements Database.Batchable<sObject>,Database.Stateful {
    Date startDate;
    Date endDate;
    String fisYear;
    String rtForAnnualPlanAF;
    String rtForAnnualPlanSWAL;
    String rtForOpeningInventoryAF;
    String rtForOpeningInventorySWAL;
    String salesOrgCodeAF;
   	String salesOrgCodeNewAF;
    String salesOrgCodeSWAL;
    Set<Id> productAF = new Set<Id>();
    Set<Id> productSWAL = new Set<Id>();
    List<Id> terrIds = new List<Id>();
    
    global LiquidationAnnualPlanOpenInventoryBatch(){
        List<Period> lstPeriod = new List<Period>();
        
        salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
    	salesOrgCodeNewAF = System.Label.New_AF_Sales_Org_Code_Label;
        salesOrgCodeSWAL = System.Label.SWAL_Sales_Org_Code_Label;
        
        lstPeriod = [SELECT FiscalYearSettings.Name , StartDate,EndDate, type  FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY];
        endDate = lstPeriod[0].EndDate; 
        startDate = lstPeriod[0].StartDate;
        fisYear = Integer.valueOf(lstPeriod[0].FiscalYearSettings.Name)-1+'-'+lstPeriod[0].FiscalYearSettings.Name;
        /*fisYear = '2023-2024';
        endDate = Date.parse('31/3/2024');
        startDate = Date.parse('1/4/2023');*/
        
        rtForAnnualPlanAF = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    	rtForAnnualPlanSWAL = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    	rtForOpeningInventoryAF = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    	rtForOpeningInventorySWAL = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        
        for(Product2 afProd : [SELECT Id, Product_Code__c FROM Product2 WHERE Active_For_Liquidation__c = true AND IsActive = true AND (Sales_Org_Code__c = :salesOrgCodeAF OR Sales_Org_Code__c = :salesOrgCodeNewAF) AND Product_Code__c != null]){
            productAF.add(afProd.Id);
        }
        
        for(Product2 swalProd : [SELECT Id, Product_Code__c FROM Product2 WHERE Active_For_Liquidation__c = true AND IsActive = true AND (Sales_Org_Code__c = :salesOrgCodeSWAL) AND Product_Code__c != null]){
            productSWAL.add(swalProd.Id);
        }
     
    }
	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id,Name,Sales_Org_Code__c,SalesOrg__c FROM Territory_Distributor__c WHERE (SalesOrg__r.Sales_Org_Code__c =:salesOrgCodeAF OR SalesOrg__r.Sales_Org_Code__c =:salesOrgCodeNewAF OR SalesOrg__r.Sales_Org_Code__c =:salesOrgCodeSWAL) AND (NOT(Name LIKE '%-b%' OR Name LIKE '%SAIB%' OR Name LIKE '%Vector%' OR NAME LIKE '%—Provision%' OR Name LIKE '%- b%' OR Name LIKE '%Provision%' OR Name LIKE '%CIL%')) AND Present_in_KEDE__c = True]);
    }
    global void execute(Database.BatchableContext BC, List<Territory_Distributor__c> scope){
        
        List<Liquidation_Annual_Plan__c> lapList = new List<Liquidation_Annual_Plan__c>();     
        List<Opening_Inventory2__c> openInvList = new List<Opening_Inventory2__c>();
        Set<Id> terrId = new Set<Id>();
        Map<Id,Id> terrIdWithLapIdMap = new Map<Id,Id>();
        
        for(Territory_Distributor__c terr:scope){
            terrId.add(terr.Id);
            Liquidation_Annual_Plan__c lapObj = new Liquidation_Annual_Plan__c();
                if(terr.Sales_Org_Code__c == salesOrgCodeSWAL){
                   lapObj.RecordTypeId = rtForAnnualPlanSWAL;
                }
                else if(terr.Sales_Org_Code__c == salesOrgCodeAF || terr.Sales_Org_Code__c == salesOrgCodeNewAF){
                   lapObj.RecordTypeId = rtForAnnualPlanAF; 
                }
                lapObj.Fiscal_Start_Date__c = startDate;
                lapObj.Fiscal_End_Date__c = endDate;
                lapObj.FIscal_Year__c = fisYear;
                lapObj.Sales_Org__c = terr.SalesOrg__c;
                lapObj.Territory_Name__c = terr.Id;
                lapObj.CurrencyIsoCode = 'INR';
                lapList.add(lapObj);
            
        }
        if(lapList.size()>0){
            INSERT lapList;
        }
        
        for(Liquidation_Annual_Plan__c laps : [SELECT Id, Territory_Name__c FROM Liquidation_Annual_Plan__c WHERE Territory_Name__c IN:terrId AND FIscal_Year__c =:fisYear]){
            terrIdWithLapIdMap.put(laps.Territory_Name__c,laps.Id);
        }
        
        for(Territory_Distributor__c terr:scope){
                if(terr.Sales_Org_Code__c == salesOrgCodeAF || terr.Sales_Org_Code__c == salesOrgCodeNewAF){
                    for(Id prodId : productAF){
                        Opening_Inventory2__c opnInvObj = new Opening_Inventory2__c();
                        opnInvObj.Liquidation_Annual_Plan__c = terrIdWithLapIdMap.get(terr.Id);
                        opnInvObj.Product__c = prodId;
                        opnInvObj.Territory__c = terr.Id;
                        opnInvObj.Opening_Inventory__c = 0;
                        opnInvObj.RecordTypeId = rtForOpeningInventoryAF;
                        opnInvObj.CurrencyIsoCode = 'INR';
                        opnInvObj.Is_From_Liq_Module__c = true;
                        openInvList.add(opnInvObj);
                    }
                }
                else if(terr.Sales_Org_Code__c == salesOrgCodeSWAL){
                    for(Id prodId : productSWAL){
                        Opening_Inventory2__c opnInvObj = new Opening_Inventory2__c();
                        opnInvObj.Liquidation_Annual_Plan__c = terrIdWithLapIdMap.get(terr.Id);
                        opnInvObj.Product__c = prodId;
                        opnInvObj.Territory__c = terr.Id;
                        opnInvObj.Opening_Inventory__c = 0;
                        opnInvObj.RecordTypeId = rtForOpeningInventorySWAL;
                        opnInvObj.CurrencyIsoCode = 'INR';
                        opnInvObj.Is_From_Liq_Module__c = true;
                        openInvList.add(opnInvObj);
                    }
                }
            
        }
        if(openInvList.size()>0){
            INSERT openInvList;
            terrIds.addAll(terrId);
        }
    }
    global void finish(Database.BatchableContext BC){
		LiquidationAFSWALUtility.sendEmail('New Fiscal Year'+fisyear,String.valueOf(terrIds.size()));
    }
}