/*
     Class Name : LiquidationReportAFSWALController
     Description : Controller Class For My Liquidation Data Tab
     Author : Bonny Mathews
     Date : 15/09/2022
	 APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
     Modified By: Harshaprasad Srustu
     LastmodifiedDate: 12-Feb-2023
 */
public without sharing class LiquidationReportAFSWALController {
    //Constant
   static final String salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
   static final String newAFSalesOrgCode = System.Label.New_AF_Sales_Org_Code_Label;
   static final String salesOrgCodeSWAL = System.Label.SWAL_Sales_Org_Code_Label;
   static final String liquidationNotCompleted = System.Label.NoCompletedLiquidationData;
   static final String liquidationDataNotFound= System.Label.LiquidationDataNotFound;
    
   //Get record types
   //static final String rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
   static final String rtForAFProdLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
   static final String rtForSWALProdLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
   //static final String rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId(); 
   static final String rtForAFCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropTrade').getRecordTypeId();
   static final String rtForSWALCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
   //static final String rtForAnnualPlanSWAL = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();   

   /**
    * Method Name : fetchReportHeaderDetails
    * Description : 
    */
    @AuraEnabled(cacheable=true)
    public static String fetchReportHeaderDetails(String UserId){
        try {
            ReportHeaderWrapper reportheadWrap = new ReportHeaderWrapper();
            String loggedInUserProfile;
            String loggedInUserrCountry;
            String loggedInUserrRole;
            reportheadWrap.territoryZoneMap = new Map<String,List<Map<String,String>>>();
            Integer curMonth = Date.Today().Month();

            //Get Logged In User Profile
            User loggedinUser = [SELECT Id,Country, Profile.Name,UserRole.Name FROM User WHERE Id = :UserId];
            loggedInUserProfile = loggedinUser.Profile.Name;
            loggedInUserrCountry = loggedinUser.Country;
            loggedInUserrRole = loggedinUser.UserRole.Name;
            reportheadWrap.userCountry = loggedinUser.Country;

            if(loggedInUserrCountry == 'India'){
                //Get territories details for logged in user
                if(loggedInUserrRole.containsIgnoreCase('Territory Manager')){
                    for(Territory_Distributor__c terr :[SELECT Id,Zone__r.Name, Name, TerritoryCode__c from Territory_Distributor__c WHERE (Sales_Org_Code__c = :salesOrgCodeAF OR Sales_Org_Code__c = :newAFSalesOrgCode) AND Zone__c != null AND Present_in_KEDE__c != false AND TerritoryManager__c  = :UserId AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                        Map<String,String> territoryMap = new Map<String,String>();
                        territoryMap.put(terr.Name,terr.TerritoryCode__c);
                        reportheadWrap.territoryZoneMap.put(terr.Zone__r.Name,new List<Map<String,String>>{territoryMap});
                    }
                    reportheadWrap.userRole = 'TM-AF';
                }else if(loggedInUserrRole.containsIgnoreCase('Zonal Marketing Manager') || loggedInUserrRole.containsIgnoreCase('Zonal Business Head') || loggedInUserrRole.containsIgnoreCase('SBU Head India') || loggedInUserrRole.containsIgnoreCase('SBU Marketing Head India') || loggedInUserrRole.containsIgnoreCase('UPL Management') || loggedInUserrRole.containsIgnoreCase('SBU Sales Head')){
                    //liquidation.territoryMap.put('All','All');
                    Boolean isSBU = false;
                    for(Territory_Distributor__c terr :[SELECT Id,Zone__r.Name, Name, TerritoryCode__c, Zonal_Marketing_Manager_1_Id__c, Zonal_Manager_Id__c,ZSM_Id__c,SBU_Head_Id__c, SBU_Marketing_heads_Id__c from Territory_Distributor__c WHERE (Sales_Org_Code__c = :salesOrgCodeAF OR Sales_Org_Code__c = :newAFSalesOrgCode) AND Zone__c != null AND Present_in_KEDE__c != false AND (Zonal_Marketing_Manager_1_Id__c=:UserId OR Zonal_Manager_Id__c=:UserId OR ZSM_Id__c=:UserId OR SBU_Head_Id__c=:UserId OR SBU_Marketing_heads_Id__c=:UserId) AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                        Map<String,String> territoryMap = new Map<String,String>();
                        territoryMap.put(terr.Name,terr.TerritoryCode__c);
                        if(reportheadWrap.territoryZoneMap.containsKey(terr.Zone__r.Name)){
                            reportheadWrap.territoryZoneMap.get(terr.Zone__r.Name).add(territoryMap);
                        }else{
                            reportheadWrap.territoryZoneMap.put(terr.Zone__r.Name,new List<Map<String,String>>{territoryMap});
                        }

                        if(terr.SBU_Marketing_heads_Id__c == UserId || terr.SBU_Head_Id__c == UserId){
                            isSBU=true;
                        }else{
                            isSBU=false;
                        }
                    }
                    if(isSBU){
                        reportheadWrap.userRole = 'SBUH/SBUM-AF';
                    }else{
                        reportheadWrap.userRole = 'ZMM/ZM/ZSM-AF';
                    }
                }
            }else if(loggedInUserrCountry == 'SWAL'){
                //Get territories details for logged in user
                if(loggedInUserrRole.containsIgnoreCase('Territory Manager SWAL')){
                    for(Territory_Distributor__c terr :[SELECT Id,Region__r.Name, Name, TerritoryCode__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCodeSWAL AND Zone__c != null AND Present_in_KEDE__c != false AND TerritoryManager__c  = :UserId AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                        Map<String,String> territoryMap = new Map<String,String>();
                        territoryMap.put(terr.Name,terr.TerritoryCode__c);
                        reportheadWrap.territoryZoneMap.put(terr.Region__r.Name,new List<Map<String,String>>{territoryMap});
                    }
                    reportheadWrap.userRole = 'TM-SWAL';
                }else if(loggedInUserrRole.containsIgnoreCase('Regional Manager SWAL')){
                    //liquidation.territoryMap.put('All','All');
                    for(Territory_Distributor__c terr :[SELECT Id,Region__r.Name, Name, TerritoryCode__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCodeSWAL AND Zone__c != null AND Present_in_KEDE__c != false AND (Regional_Manager_Id__c=:UserId OR Zonal_Marketing_Manager_1_Id__c=:UserId OR Zonal_Manager_Id__c=:UserId OR ZSM_Id__c=:UserId) AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                        Map<String,String> territoryMap = new Map<String,String>();
                        territoryMap.put(terr.Name,terr.TerritoryCode__c);
                        if(reportheadWrap.territoryZoneMap.containsKey(terr.Region__r.Name)){
                            reportheadWrap.territoryZoneMap.get(terr.Region__r.Name).add(territoryMap);
                        }else{
                            reportheadWrap.territoryZoneMap.put(terr.Region__r.Name,new List<Map<String,String>>{territoryMap});
                        }
                    }
                    reportheadWrap.userRole = 'RM-SWAL';
                }else if((loggedInUserrRole.containsIgnoreCase('Field Marketing Manager')) || (loggedInUserrRole.containsIgnoreCase('FMM'))){
                    for(Territory_Distributor__c terr :[SELECT Id,Region__r.Name, Name, TerritoryCode__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCodeSWAL AND Zone__c != null AND Present_in_KEDE__c != false AND FMM_User_Id__c=:UserId AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                        Map<String,String> territoryMap = new Map<String,String>();
                        territoryMap.put(terr.Name,terr.TerritoryCode__c);
                        if(reportheadWrap.territoryZoneMap.containsKey(terr.Region__r.Name)){
                            reportheadWrap.territoryZoneMap.get(terr.Region__r.Name).add(territoryMap);
                        }else{
                            reportheadWrap.territoryZoneMap.put(terr.Region__r.Name,new List<Map<String,String>>{territoryMap});
                        }
                    }
                    reportheadWrap.userRole = 'FMM-SWAL';
                }else if(loggedInUserrRole.containsIgnoreCase('ZMM SWAL') || loggedInUserrRole.containsIgnoreCase('Zonal Head SWAL')){ //Included OR condition for Zonal Head SWAL by Harsha as discussed with Ritesh and Abhineet on 10-Feb-2023.
                    for(Territory_Distributor__c terr :[SELECT Id,Region__r.Name, Name, TerritoryCode__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCodeSWAL AND Zone__c != null AND Present_in_KEDE__c != false AND (Zonal_Marketing_Manager_1_Id__c=:UserId OR Zonal_Manager_Id__c=:UserId OR ZSM_Id__c=:UserId) AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                        Map<String,String> territoryMap = new Map<String,String>();
                        territoryMap.put(terr.Name,terr.TerritoryCode__c);
                        if(reportheadWrap.territoryZoneMap.containsKey(terr.Region__r.Name)){
                            reportheadWrap.territoryZoneMap.get(terr.Region__r.Name).add(territoryMap);
                        }else{
                            reportheadWrap.territoryZoneMap.put(terr.Region__r.Name,new List<Map<String,String>>{territoryMap});
                        }
                    }
                    reportheadWrap.userRole = 'ZML-SWAL';
                }
            }

            //Get current liquidation fiscal year
            String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
            if(curMonth == 4){
                Integer fiscalyr = Integer.valueOf(currentFiscalYear)-2;
                reportheadWrap.FiscalYear = String.valueOf(fiscalyr)+'-'+String.valueOf(Integer.valueOf(currentFiscalYear)-1);
            }else{
                Integer fiscalyr = Integer.valueOf(currentFiscalYear)-1;
                reportheadWrap.FiscalYear = String.valueOf(fiscalyr)+'-'+currentFiscalYear;
            }
            reportheadWrap.shwPrvFisYear = System.Label.showPrevFiscalYear;
            System.debug('reportheadWrap = '+JSON.serialize(reportheadWrap.territoryZoneMap));
            return JSON.serialize(reportheadWrap);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * Method Name : getTableData
    * Description : 
    */
    @AuraEnabled
    public static string getTableData(String zone, String territory, String fisyear, String month, String usrCountry, String usrId, String tableType){
        try {
            String retData;
            List<String> territoryList = new List<String>();
            List<Liquidation_Approval_History__c> lahList = new List<Liquidation_Approval_History__c>();
            if(zone == 'All'){
                //call for rollup method for zone 
                for(Territory_Distributor__c terr :[SELECT TerritoryCode__c from Territory_Distributor__c 
                                                    WHERE (Sales_Org_Code__c = :salesOrgCodeAF OR Sales_Org_Code__c = :newAFSalesOrgCode OR Sales_Org_Code__c = :salesOrgCodeSWAL) AND Zone__c != null AND Present_in_KEDE__c = true 
                                                    AND (Zonal_Marketing_Manager_1_Id__c=:usrId OR Zonal_Manager_Id__c=:usrId OR ZSM_Id__c=:usrId OR SBU_Head_Id__c=:usrId OR SBU_Marketing_heads_Id__c=:usrId OR Regional_Manager_Id__c=:usrId OR FMM_User_Id__c=:usrId) AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                    territoryList.add(terr.TerritoryCode__c);
                }
                    if(tableType == 'Product'){
                        lahList = [SELECT Id, Approval_Status__c FROM Liquidation_Approval_History__c WHERE Month__c = :month AND LAP_Fiscal_Year__c = :fisyear AND Territory__r.TerritoryCode__c IN :territoryList AND (Approval_Status__c = 'Approved' OR Approval_Status__c = 'Edit and Approved')];
                        if(lahList.size() > 0){
                            retData = getProductLiquidationData(territoryList, fisyear, month, usrCountry);
                        }else{
                            retData = liquidationNotCompleted;
                        }
                        
                    }else if(tableType == 'Crop'){
                        retData = getCropLiquidationData(territoryList, fisyear, month, usrCountry);
                    }
                
            }else if(zone != 'All' && territory == 'All'){
                //call for rollup method for territory
                for(Territory_Distributor__c terr :[SELECT TerritoryCode__c from Territory_Distributor__c 
                                                    WHERE (Sales_Org_Code__c = :salesOrgCodeAF OR Sales_Org_Code__c = :newAFSalesOrgCode OR Sales_Org_Code__c = :salesOrgCodeSWAL) AND Zone__c != null AND Present_in_KEDE__c = true  AND (Zone__r.Name =:zone OR Region__r.Name =:zone ) 
                                                    AND (Zonal_Marketing_Manager_1_Id__c=:usrId OR Zonal_Manager_Id__c=:usrId OR ZSM_Id__c=:usrId OR SBU_Head_Id__c=:usrId OR SBU_Marketing_heads_Id__c=:usrId OR Regional_Manager_Id__c=:usrId OR FMM_User_Id__c=:usrId) AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                    territoryList.add(terr.TerritoryCode__c);
                }
                    if(tableType == 'Product'){
                        lahList = [SELECT Id, Approval_Status__c FROM Liquidation_Approval_History__c WHERE Month__c = :month AND LAP_Fiscal_Year__c = :fisyear AND Territory__r.TerritoryCode__c IN :territoryList AND (Approval_Status__c = 'Approved' OR Approval_Status__c = 'Edit and Approved')];
                        if(lahList.size() > 0){
                            retData = getProductLiquidationData(territoryList, fisyear, month, usrCountry);
                        }else{
                            retData = liquidationNotCompleted;
                        }
                        
                    }else if(tableType == 'Crop'){
                        retData = getCropLiquidationData(territoryList, fisyear, month, usrCountry);
                    }
                
            }else{
                if(tableType == 'Product'){
                    territoryList.add(territory);
                    lahList = [SELECT Id, Approval_Status__c FROM Liquidation_Approval_History__c WHERE Month__c = :month AND LAP_Fiscal_Year__c = :fisyear AND Territory__r.TerritoryCode__c IN :territoryList AND (Approval_Status__c = 'Approved' OR Approval_Status__c = 'Edit and Approved')];
                    if(lahList.size() > 0){
                        retData = getProductLiquidationData(territoryList, fisyear, month, usrCountry);
                    }else{
                        retData = liquidationNotCompleted;
                    }
                    
                }else if(tableType == 'Crop'){
                    territoryList.add(territory);
                    retData = getCropLiquidationData(territoryList, fisyear, month, usrCountry);
                }
            }
            return retData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * Method Name : getProductLiquidationData
    * Description : 
    */
    public static String getProductLiquidationData(List<String> territoryList, String fisyear, String month, String usrCountry){
        String prodQueryString;
        String retString;
        Integer rowIndex = 0;
        List<Product2> prodList = new List<Product2>();
        Set<String> prodCodeSet = new Set<String>();
        List<LiquidationReportProdWrapper> prodLiqWrapperList = new List<LiquidationReportProdWrapper>();
        List<Liquidation_Approval_History__c> lahList = new List<Liquidation_Approval_History__c>();
        Map<String, AggregateResult> prodCodeToAggregateMap = new Map<String, AggregateResult>();

        if(usrCountry == 'India'){
            prodList = [SELECT Id, Name, Product_Code__c,Budget_NRV__c FROM Product2 WHERE Active_For_Liquidation__c = true AND IsActive = true AND (Sales_Org_Code__c = :salesOrgCodeAF  OR Sales_Org_Code__c = :newAFSalesOrgCode) AND Product_Code__c != null];
            if(prodList.size() > 0){
                for(Product2 prd : prodList){
                    prodCodeSet.add(prd.Product_Code__c);
                }
            }

            //Get Aggregate product Liquidation
            List<AggregateResult> prodLiqAggList = [SELECT Product__r.Product_Code__c prdCde, SUM(Opening_Inventory_MTD__c) oIVal, SUM(MTD_Sales__c) ytdVal, SUM(Distributors_Inventory__c) dIVal, SUM(Retailers_Inventory__c) rIVal, SUM(Product_Budget_LiqCum__c)pbVal 
                                                        FROM Liquidation2__c 
                                                        WHERE Product__r.Product_Code__c IN :prodCodeSet AND Territory_Code__c IN :territoryList AND Financial_Year__c =:fisyear AND Month__c =:month  AND RecordTypeId = :rtForAFProdLiquidation GROUP BY ROLLUP(Product__r.Product_Code__c)];
            for(AggregateResult aggRes : prodLiqAggList){
                prodCodeToAggregateMap.put((String)aggRes.get('prdCde'),aggRes);
            }

        }else if(usrCountry == 'SWAL'){
            prodList = [SELECT Id, Name, Product_Code__c,Budget_NRV__c FROM Product2 WHERE Active_For_Liquidation__c = true AND IsActive = true AND Sales_Org_Code__c = :salesOrgCodeSWAL AND Product_Code__c != null];
            if(prodList.size() > 0){
                for(Product2 prd : prodList){
                    prodCodeSet.add(prd.Product_Code__c);
                }
            }
            
            //Get Aggregate product Liquidation
            List<AggregateResult> prodLiqAggList = [SELECT Product__r.Product_Code__c prdCde, SUM(Opening_Inventory_MTD__c) oIVal, SUM(MTD_Sales__c) ytdVal, SUM(Distributors_Inventory__c) dIVal, SUM(Retailers_Inventory__c) rIVal, SUM(Product_Budget_LiqCum__c)pbVal 
                                                        FROM Liquidation2__c 
                                                        WHERE Product__r.Product_Code__c IN :prodCodeSet AND Territory_Code__c IN :territoryList AND Financial_Year__c =:fisyear AND Month__c =:month  AND RecordTypeId = :rtForSWALProdLiquidation GROUP BY ROLLUP(Product__r.Product_Code__c)];
            for(AggregateResult aggRes : prodLiqAggList){
                prodCodeToAggregateMap.put((String)aggRes.get('prdCde'),aggRes);
            }
        }

        if(prodList.size() > 0 && !prodCodeToAggregateMap.isEmpty()){
            for(Product2 liq : prodList){
                if(prodCodeToAggregateMap.containsKey(liq.Product_Code__c)){
                    LiquidationReportProdWrapper reportProd = new LiquidationReportProdWrapper();
                    reportProd.prodCode = liq.Product_Code__c;
                    reportProd.prodName = liq.Name;
                    reportProd.openInv = (Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('oIVal') != null?(Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('oIVal'):0.00;
                    reportProd.ytdSale = (Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('ytdVal') != null?(Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('ytdVal'):0.00;
                    reportProd.tAvbStck = reportProd.openInv + reportProd.ytdSale;
                    reportProd.distInv = (Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('dIVal') != null?(Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('dIVal'):0.00;
                    reportProd.retInv = (Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('rIVal') != null?(Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('rIVal'):0.00;
                    reportProd.totMrkInv = reportProd.distInv + reportProd.retInv;
                    reportProd.prodBud = (Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('pbVal') != null?(Double)prodCodeToAggregateMap.get(liq.Product_Code__c).get('pbVal'):0.00;
                    reportProd.prodBud = (reportProd.prodBud).setScale(2);
                    reportProd.liqYTD = reportProd.tAvbStck - reportProd.totMrkInv;
                    if(reportProd.tAvbStck == 0.00 || reportProd.tAvbStck == 0){
                        reportProd.liqYTDPer = 0.00;
                    }else{
                        reportProd.liqYTDPer = ((reportProd.liqYTD/reportProd.tAvbStck)*100).setScale(2);
                    }
                    reportProd.index = rowIndex;
                    reportProd.prodNRV = liq.Budget_NRV__c!=null?liq.Budget_NRV__c:0.00;
                    prodLiqWrapperList.add(reportProd);
                    rowIndex ++;
                }
            }
            retString = JSON.serialize(prodLiqWrapperList);
        }else{
            retString = LiquidationDataNotFound;
        }
        return retString;
    }

    /**
    * Method Name : getCropLiquidationData
    * Description : 
    */
    public static String getCropLiquidationData(List<String> territoryList, String fisyear, String month, String usrCountry){
        String retString;
        List<Id> cropId = new List<Id>();
        Set<String> prodLiqCode = new Set<String>();
        LiquidationReportCropTableWrapper repCropTableWrapper = new LiquidationReportCropTableWrapper();
        repCropTableWrapper.liqCropList = new List<Crop__c>();
        repCropTableWrapper.crpAggLiqList = new List<AggregateResult>();
        repCropTableWrapper.prdAggLiqList = new List<AggregateResult>();
        repCropTableWrapper.prodLiqList = new List<Liquidation2__c>();
        Map<String,Liquidation2__c> prdCodeToLiqMap = new Map<String,Liquidation2__c>();

        if(usrCountry == 'India'){
            //Get Crop Name List
            for(Crop__c cropName : [SELECT Id, Name, Crop_Order__c FROM Crop__c Where (Sales_Org_Code__c = :salesOrgCodeAF OR Sales_Org_Code__c = :newAFSalesOrgCode) AND Active__c = true AND Active_for_Crop_Liquidation__c = true AND Is_Old_Crop__c = false ORDER By Crop_Order__c ASC]){
                repCropTableWrapper.liqCropList.add(cropName);
                cropId.add(cropName.Id);
            }

            for(Liquidation2__c prodLiq : [SELECT Id, Product__r.Name, Product__r.Product_Code__c,Product__r.Budget_NRV__c
                                                    FROM Liquidation2__c 
                                                    WHERE Territory_Code__c IN :territoryList AND Financial_Year__c =:fisyear AND Month__c =:month AND Liquidation_MTD_Trade__c > 0 AND RecordTypeId = :rtForAFProdLiquidation ORDER BY Liquidation_MTD_Trade__c DESC]){
                if(!prdCodeToLiqMap.containsKey(prodLiq.Product__r.Product_Code__c)){
                    prdCodeToLiqMap.put(prodLiq.Product__r.Product_Code__c,prodLiq);
                }
            }
            for(String prdCode : prdCodeToLiqMap.keySet()){
                repCropTableWrapper.prodLiqList.add(prdCodeToLiqMap.get(prdCode));
            }
            List<AggregateResult> prodAggregateList = [SELECT Product__r.Product_Code__c prdCde, SUM(Liquidation_MTD_Trade__c) prodLiqVal FROM Liquidation2__c 
                                                        WHERE Liquidation_MTD_Trade__c > 0 AND Territory_Code__c IN :territoryList AND Financial_Year__c =:fisyear AND Month__c =:month  AND RecordTypeId = :rtForAFProdLiquidation GROUP BY ROLLUP(Product__r.Product_Code__c)];

            if(prodAggregateList.size() > 0){
                repCropTableWrapper.prdAggLiqList = prodAggregateList;
            }
            system.debug('repCropTableWrapper.prdAggLiqList = '+repCropTableWrapper.prdAggLiqList);
            //get Aggregate Crop Liquidation data
            List<AggregateResult> crpAggregateList =[SELECT Liquidation__r.Product__r.Product_Code__c prodCode,Crop__r.Name crpName, SUM(Liquidation_Value__c) crpLiqVal
                                                        FROM Crop_Liquidation__c
                                                        WHERE Liquidation_Month__c = :month AND Liquidation__r.Financial_Year__c =:fisyear AND Crop__r.Is_Old_Crop__c = false AND Territory_Code__c IN :territoryList AND Liquidation_Value__c > 0 AND RecordTypeId = :rtForAFCropLiquidation GROUP BY ROLLUP(Liquidation__r.Product__r.Product_Code__c,Crop__r.Name)];
            if(crpAggregateList.size() > 0){
                repCropTableWrapper.crpAggLiqList = crpAggregateList;
            }
        }else if(usrCountry == 'SWAL'){
            //Get Crop Name List
            for(Crop__c cropName : [SELECT Id,Name,Crop_Order__c FROM Crop__c Where Sales_Org_Code__c = :salesOrgCodeSWAL AND Active__c = true AND Active_for_Crop_Liquidation__c = true AND Is_Old_Crop__c = false ORDER By Crop_Order__c ASC]){
                repCropTableWrapper.liqCropList.add(cropName);
                cropId.add(cropName.Id);
            }

            for(Liquidation2__c prodLiq : [SELECT Id, Product__r.Name, Product__r.Product_Code__c,Product__r.Budget_NRV__c 
                                                    FROM Liquidation2__c 
                                                    WHERE Territory_Code__c IN :territoryList AND Financial_Year__c =:fisyear AND Month__c =:month AND Liquidation_MTD_SWAL__c > 0 AND RecordTypeId = :rtForSWALProdLiquidation ORDER BY Liquidation_MTD_SWAL__c DESC]){
                if(!prdCodeToLiqMap.containsKey(prodLiq.Product__r.Product_Code__c)){
                    prdCodeToLiqMap.put(prodLiq.Product__r.Product_Code__c,prodLiq);
                }
            }
            for(String prdCode : prdCodeToLiqMap.keySet()){
                repCropTableWrapper.prodLiqList.add(prdCodeToLiqMap.get(prdCode));
            }
            System.debug('size1 = '+prodLiqCode.size());
            System.debug('size2 = '+repCropTableWrapper.prodLiqList.size());
            List<AggregateResult> prodAggregateList = [SELECT Product__r.Product_Code__c prdCde, SUM(Liquidation_MTD_SWAL__c) prodLiqVal FROM Liquidation2__c 
                                                        WHERE Liquidation_MTD_SWAL__c > 0 AND Territory_Code__c IN :territoryList AND Financial_Year__c =:fisyear AND Month__c =:month AND RecordTypeId = :rtForSWALProdLiquidation GROUP BY ROLLUP(Product__r.Product_Code__c)];

            if(prodAggregateList.size() > 0){
                repCropTableWrapper.prdAggLiqList = prodAggregateList;
            }
            //get Aggregate Crop Liquidation data
            List<AggregateResult> crpAggregateList =[SELECT Liquidation__r.Product__r.Product_Code__c prodCode,Crop__r.Name crpName, SUM(Liquidation_Value__c) crpLiqVal
                                                        FROM Crop_Liquidation__c
                                                        WHERE Liquidation_Month__c = :month AND Liquidation__r.Financial_Year__c =:fisyear AND Crop__r.Is_Old_Crop__c = false AND Territory_Code__c IN :territoryList AND Liquidation_Value__c > 0 AND RecordTypeId = :rtForSWALCropLiquidation GROUP BY ROLLUP(Liquidation__r.Product__r.Product_Code__c,Crop__r.Name)];
            if(crpAggregateList.size() > 0){
                repCropTableWrapper.crpAggLiqList = crpAggregateList;
            }
        }
        retString = JSON.serialize(repCropTableWrapper);
        return retString;
    }

   //Wrapper part
   public class ReportHeaderWrapper{
        private Map<String,List<Map<String,String>>> territoryZoneMap{get;set;}
        private String FiscalYear {get;set;}
        private String userRole {get;set;}
        private String userCountry {get;set;}
        private String message {get;set;}
       private String shwPrvFisYear {get;set;}
    }

    public class LiquidationReportProdWrapper {
        private String prodCode {get;set;}
        private String prodName {get;set;}
        private Decimal openInv {get;set;}
        private Decimal ytdSale {get;set;}
        private Decimal tAvbStck {get;set;}
        private Decimal distInv {get;set;}
        private Decimal retInv {get;set;}
        private Decimal totMrkInv {get;set;}
        private Decimal prodBud {get;set;}
        private Decimal liqYTD {get;set;}
        private Decimal liqYTDPer {get;set;}
        private Integer index {get;set;}
        private Decimal prodNRV{get;set;}
    }

    public class LiquidationReportCropTableWrapper {
        public List<Crop__c> liqCropList {get;set;}
        public List<AggregateResult> crpAggLiqList {get;set;}
        public List<AggregateResult> prdAggLiqList {get;set;}
        public List<Liquidation2__c> prodLiqList {get;set;}
    }
}