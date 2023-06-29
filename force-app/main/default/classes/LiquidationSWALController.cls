/*
     Class Name : LiquidationSWALController
     Description : Controller Class For SWAL Liquidation module
     Author : Bonny Mathews
     Date : 05/08/2022
 */
public without sharing class LiquidationSWALController {
    //Constant
    static final String salesOrgCode = System.Label.SWAL_Sales_Org_Code_Label;
    static final String noLAPPresentErrorMessage = System.Label.NoLAPPresentErrorMessage;
    static final String liqNotSubmittedErrorMessage = System.Label.LiquidationNotSubmittedErrorMessage;
    static final String allowOIEdit = System.Label.AllowOIEdit; //By pass validation
    static final String allowProdValidationBypass = System.Label.AllowProdValidationBypass; //By pass validation
    static final String allowCropValidationBypass = System.Label.AllowCropValidationBypass; //By pass validation
    //Get record types
    static final String rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();																																   
    static final String rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
	static final String rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
      
    /*
    Method Name : fetchHeaderDetails
    Description : Fetch the details of logged in User
    */
    @AuraEnabled
    public static LiquidationWrapper fetchHeaderDetails(String UserId){
        try {

            LiquidationWrapper liquidation = new LiquidationWrapper();
            String loggedInUserProfile;
            String loggedInUserrRole;
            liquidation.territoryMap = new Map<String,String>();
            liquidation.isTMAvailableMap = new Map<String,boolean>();
            liquidation.isFMMHasRoleMap = new Map<String,boolean>();
            liquidation.isZMLHasRoleMap = new Map<String,boolean>();
            Integer curMonth = Date.Today().Month();
			
            //Get liq valid period
            MultiCountry_Liquidation__c mcLiq = MultiCountry_Liquidation__c.getValues('SWAL');
            if(mcLiq.Active__c == true && mcLiq.Month__c == String.valueOf(curMonth)){
                liquidation.validLiqPeriod = true;
            }else{
                liquidation.validLiqPeriod = false;
            }  
			//Get Logged In User Profile
            User loggedinUser = [SELECT Id, Profile.Name,UserRole.Name FROM User WHERE Id = :UserId];
            loggedInUserProfile = loggedinUser.Profile.Name;
            loggedInUserrRole = loggedinUser.UserRole.Name;

            //Get territories details for logged in user
            if(loggedInUserrRole.containsIgnoreCase('Territory Manager SWAL')){
                for(Territory_Distributor__c terr :[SELECT Id, Name, TerritoryCode__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCode AND Region__c != null AND Present_in_KEDE__c != false AND TerritoryManager__c  = :UserId AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                    liquidation.territoryMap.put(terr.Name,terr.TerritoryCode__c);
                }
                liquidation.userRole = 'TM';
            }else if(loggedInUserrRole.containsIgnoreCase('Regional Manager SWAL')){
                for(Territory_Distributor__c terr :[SELECT Id, Name, TerritoryCode__c, TerritoryManager__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCode AND Region__c != null AND Present_in_KEDE__c != false AND Regional_Manager_Id__c = :UserId AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                    liquidation.territoryMap.put(terr.Name,terr.TerritoryCode__c);
                    if(terr.TerritoryManager__c != null ){
                        liquidation.isTMAvailableMap.put(terr.TerritoryCode__c,true);
                    }else{
                        liquidation.isTMAvailableMap.put(terr.TerritoryCode__c,false);
                    }						 
                }
                liquidation.userRole = 'RM';
            }else if((loggedInUserrRole.containsIgnoreCase('Field Marketing Manager')) || (loggedInUserrRole.containsIgnoreCase('FMM'))){
                for(Territory_Distributor__c terr :[SELECT Id, Name, TerritoryCode__c, TerritoryManager__c,Regional_Manager_Id__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCode AND Region__c != null AND Present_in_KEDE__c != false AND FMM_User_Id__c = :UserId AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                    liquidation.territoryMap.put(terr.Name,terr.TerritoryCode__c);
                    if(terr.TerritoryManager__c != null && terr.Regional_Manager_Id__c == null){
                        liquidation.isTMAvailableMap.put(terr.TerritoryCode__c,true);
                        liquidation.isFMMHasRoleMap.put(terr.TerritoryCode__c,true);
                    }else if(terr.TerritoryManager__c == null && terr.Regional_Manager_Id__c == null){
                        liquidation.isTMAvailableMap.put(terr.TerritoryCode__c,false);
                        liquidation.isFMMHasRoleMap.put(terr.TerritoryCode__c,true);
                    }else{
                        liquidation.isFMMHasRoleMap.put(terr.TerritoryCode__c,false);
                    }					 
                }
                liquidation.userRole = 'FMM';
            }else if(loggedInUserrRole.containsIgnoreCase('ZMM SWAL') || loggedInUserrRole.containsIgnoreCase('Zonal Head SWAL')){
                for(Territory_Distributor__c terr :[SELECT Id, Name, TerritoryCode__c, TerritoryManager__c,Regional_Manager_Id__c,FMM_User_Id__c from Territory_Distributor__c WHERE Sales_Org_Code__c = :salesOrgCode AND Region__c != null AND Present_in_KEDE__c != false AND (Zonal_Marketing_Manager_1_Id__c=:UserId OR Zonal_Manager_Id__c=:UserId OR ZSM_Id__c=:UserId) AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision'))]){
                    liquidation.territoryMap.put(terr.Name,terr.TerritoryCode__c);
                    if(terr.TerritoryManager__c != null && terr.Regional_Manager_Id__c == null && terr.FMM_User_Id__c == null){
                        liquidation.isTMAvailableMap.put(terr.TerritoryCode__c,true);
                        liquidation.isZMLHasRoleMap.put(terr.TerritoryCode__c,true);
                    }else if(terr.TerritoryManager__c == null && terr.Regional_Manager_Id__c == null && terr.FMM_User_Id__c == null){
                        liquidation.isTMAvailableMap.put(terr.TerritoryCode__c,false);
                        liquidation.isZMLHasRoleMap.put(terr.TerritoryCode__c,true);
                    }else{
                        liquidation.isZMLHasRoleMap.put(terr.TerritoryCode__c,false);
                    }					 
                }
                liquidation.userRole = 'ZML';
            }
            
            String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
            if(curMonth == 4){
                Integer fiscalyr = Integer.valueOf(currentFiscalYear)-2;
                liquidation.FiscalYear = String.valueOf(fiscalyr)+'-'+String.valueOf(Integer.valueOf(currentFiscalYear)-1);
            }else{
                Integer fiscalyr = Integer.valueOf(currentFiscalYear)-1;
                liquidation.FiscalYear = String.valueOf(fiscalyr)+'-'+currentFiscalYear;
            }
            
            return liquidation;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    Method Name : getProductLiquidationData
    Description : 
    */
    @AuraEnabled
    public static String getProductLiquidationData(String territoryCode, String fisYear, String liqMonth, String usrRole, boolean isTmAvb){
        try {
            String lapId;
            String liqStatus;
            boolean isProdSubmitted = false;
            boolean isCropSubmitted = false;
            String liqPrevMonth;
            String prevFisYear;
            String retData;
            String territoryId;
            LiquidationSWALProductTableWrapper swalProductTableWrapper = new LiquidationSWALProductTableWrapper();
            swalProductTableWrapper.liqSWALProductList = new List<LiquidationSWALProductWrapper>();
            swalProductTableWrapper.byProdPassValid = allowProdValidationBypass;   //By pass validation
            //Populate Month Map
            MAP<Integer,String> monthMap = new MAP<Integer,String>();
            monthMap.put(4,'Apr');
            monthMap.put(5,'May');
            monthMap.put(6,'Jun');
            monthMap.put(7,'Jul');
            monthMap.put(8,'Aug');
            monthMap.put(9,'Sept');
            monthMap.put(10,'Oct');
            monthMap.put(11,'Nov');
            monthMap.put(12,'Dec');
            monthMap.put(1,'Jan');
            monthMap.put(2,'Feb');
            monthMap.put(3,'Mar');
            
            Integer curMonth = Date.Today().Month();
            //Get Liquidation Anual Plan details for current territory and Fiscal Year
            List<Liquidation_Annual_Plan__c> liqAPList = [SELECT Id, Name, Territory_Name__c FROM Liquidation_Annual_Plan__c WHERE Sales_Org_Code__c = :salesOrgCode and FIscal_Year__c= :fisYear AND Territory_Name__r.TerritoryCode__c = :territoryCode AND RecordTypeId = :rtForAnnualPlan];
            if(liqAPList.size() > 0){
                lapId = liqAPList[0].Id;
                territoryId = liqAPList[0].Territory_Name__c;
            }else{
                return System.Label.NoLAPPresentErrorMessage;
            }

                List<Liquidation_Approval_History__c> liqStatusList = [SELECT Id, Approval_Status__c, Is_Product_Liquidation_Submitted__c, Is_Crop_Liquidation_Submitted__c, LAP_Fiscal_Year__c FROM Liquidation_Approval_History__c 
                                    WHERE LAP__c = :lapId AND SalesOrg__r.Sales_Org_Code__c = :salesOrgCode AND Territory__r.TerritoryCode__c = :territoryCode AND LAP_Fiscal_Year__c = :fisYear AND Month__c = :liqMonth LIMIT 1];
                if(liqStatusList.size()>0){
                    liqStatus = liqStatusList[0].Approval_Status__c;
                    isProdSubmitted = liqStatusList[0].Is_Product_Liquidation_Submitted__c;
                    isCropSubmitted = liqStatusList[0].Is_Crop_Liquidation_Submitted__c;
                }else{
                    liqStatus = 'Not Started';//'Pending for Approval''Not Started'
                    
                    if(curMonth >= 3 && curMonth <= 12){
                        liqPrevMonth = monthMap.get(curMonth-2);
                    }else if(curMonth < 3){
                        liqPrevMonth = monthMap.get(curMonth+10);
                    }
                    if(curMonth == 5){
                        List<String> res = fisYear.split('-',2);
                        prevFisYear = String.valueOf(Integer.valueOf(res[0])-1)+'-'+String.valueOf(Integer.valueOf(res[1])-1);
                    }
                }
                //check user role
                if(usrRole == 'TM'){
                    swalProductTableWrapper.liqStatus = liqStatus;
                    swalProductTableWrapper.isProdSub = isProdSubmitted;
                    swalProductTableWrapper.liqSWALProductList =  getProductLiqTableData(lapId, fisYear, prevFisYear, territoryCode, liqMonth, liqPrevMonth, liqStatus, territoryId, usrRole, isTmAvb);
                    retData = JSON.serialize(swalProductTableWrapper);
                }else{
					if (isTmAvb == true && (liqStatus == 'Not Started' || liqStatus == 'In Progress' || liqStatus == 'Rejected' || liqStatus == 'Unlocked')){
                        retData = liqNotSubmittedErrorMessage;
                    }
					else{
						 swalProductTableWrapper.liqStatus = liqStatus;
                        swalProductTableWrapper.isProdSub = isProdSubmitted;
                        swalProductTableWrapper.liqSWALProductList =  getProductLiqTableData(lapId, fisYear, prevFisYear, territoryCode, liqMonth, liqPrevMonth, liqStatus, territoryId, usrRole, isTmAvb);
                        retData = JSON.serialize(swalProductTableWrapper);
					}
                }
            return retData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

	/*
    Method Name : getProductLiqTableData
    Description : 
    */	
	public static List<LiquidationSWALProductWrapper> getProductLiqTableData(String lapId, String fisYear, String prevFisYear, String territoryCode, String liqMonth, String liqPrevMonth, String liqStatus, String terrId, String usrRole, boolean isTmAvb){
        try{
            List<LiquidationSWALProductWrapper> prodLiquidationList = new List<LiquidationSWALProductWrapper>();       

            Map<String, Opening_Inventory2__c> opInvMap = new Map<String, Opening_Inventory2__c>();
            Map<String, Liquidation2__c> prodLiqMap = new Map<String, Liquidation2__c>();
            Map<String, Product2> productMap = new Map<String, Product2>();
            Integer rowIndex = 0;
            String monthStr;
            String fiscalYearStr;
            String lapIdStr;

            if(liqPrevMonth == '' || String.isBlank(liqPrevMonth)){
                monthStr = liqMonth;
            }else{
                monthStr = liqPrevMonth;
            }

            if(prevFisYear == '' || String.isBlank(prevFisYear)){
                fiscalYearStr = fisYear;
                lapIdStr = lapId;
            }else{
                fiscalYearStr = prevFisYear;
                List<Liquidation_Annual_Plan__c> prevLiqAPList = [SELECT Id, Name FROM Liquidation_Annual_Plan__c WHERE Sales_Org_Code__c = :salesOrgCode and FIscal_Year__c= :prevFisYear AND Territory_Name__r.TerritoryCode__c = :territoryCode AND RecordTypeId = :rtForAnnualPlan LIMIT 1];
                if(prevLiqAPList.size() > 0){
                    lapIdStr = prevLiqAPList[0].Id;
                }
            }

            //Get SWAL Product List Active for Liquidation
            for(Product2 swalProd : [SELECT Id, Name, Product_Code__c FROM Product2 WHERE Active_For_Liquidation__c = true AND IsActive = true AND Sales_Org_Code__c = :salesOrgCode AND Product_Code__c != null]){
                productMap.put(swalProd.Product_Code__c,swalProd);
            }

            if(liqStatus == 'Not Started'){
                //Create map of Product and Opening Inventory data
				List<Opening_Inventory2__c> opInvList = new List<Opening_Inventory2__c>();
                if(prevFisYear == '' || String.isBlank(prevFisYear)){
                    /*opInvList = [SELECT Id, Product__c, Product__r.Name,Product__r.Product_Code__c, Opening_Inventory__c, 
                                                         YTD_Sales_Jan__c, YTD_Sales_Feb__c, YTD_Sales_Mar__c, YTD_Sales_Apr__c, YTD_Sales_May__c, YTD_Sales_Jun__c, YTD_Sales_Jul__c, YTD_Sales_Aug__c, YTD_Sales_Sept__c, YTD_Sales_Oct__c, YTD_Sales_Nov__c, YTD_Sales_Dec__c,
                                                         Product_Budget_cum__c, Territory__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lapIdStr AND Multi_Country_Formula_Key__c  =:fiscalYearStr AND RecordTypeId =: rtForOpeningInventory AND Product__r.Product_Code__c IN :productMap.keySet() AND Territory__r.TerritoryCode__c  =:territoryCode];*/
                    opInvList = [SELECT Id, Product__c, Product__r.Name,Product__r.Product_Code__c,
                                                         MTD_Sales_Jan__c, MTD_Sales_Feb__c, MTD_Sales_Mar__c, MTD_Sales_Apr__c, MTD_Sales_May__c, MTD_Sales_Jun__c, MTD_Sales_Jul__c, MTD_Sales_Aug__c, MTD_Sales_Sept__c, MTD_Sales_Oct__c, MTD_Sales_Nov__c, MTD_Sales_Dec__c,
                                                         Product_Budget_cum__c, Territory__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lapIdStr AND Multi_Country_Formula_Key__c  =:fiscalYearStr AND RecordTypeId =: rtForOpeningInventory AND Product__r.Product_Code__c IN :productMap.keySet() AND Territory__r.TerritoryCode__c  =:territoryCode];                                     
                }else{
                    /*opInvList = [SELECT Id, Product__c, Product__r.Name,Product__r.Product_Code__c, Opening_Inventory__c, 
                                                         YTD_Sales_Jan__c, YTD_Sales_Feb__c, YTD_Sales_Mar__c, YTD_Sales_Apr__c, YTD_Sales_May__c, YTD_Sales_Jun__c, YTD_Sales_Jul__c, YTD_Sales_Aug__c, YTD_Sales_Sept__c, YTD_Sales_Oct__c, YTD_Sales_Nov__c, YTD_Sales_Dec__c,
                                                         Product_Budget_cum__c, Territory__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lapId AND Multi_Country_Formula_Key__c  =:fisYear AND RecordTypeId =: rtForOpeningInventory AND Product__r.Product_Code__c IN :productMap.keySet() AND Territory__r.TerritoryCode__c  =:territoryCode];*/
                    opInvList = [SELECT Id, Product__c, Product__r.Name,Product__r.Product_Code__c,
                                                         MTD_Sales_Jan__c, MTD_Sales_Feb__c, MTD_Sales_Mar__c, MTD_Sales_Apr__c, MTD_Sales_May__c, MTD_Sales_Jun__c, MTD_Sales_Jul__c, MTD_Sales_Aug__c, MTD_Sales_Sept__c, MTD_Sales_Oct__c, MTD_Sales_Nov__c, MTD_Sales_Dec__c,
                                                         Product_Budget_cum__c, Territory__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lapId AND Multi_Country_Formula_Key__c  =:fisYear AND RecordTypeId =: rtForOpeningInventory AND Product__r.Product_Code__c IN :productMap.keySet() AND Territory__r.TerritoryCode__c  =:territoryCode];                                                                                    
                }

                for(Opening_Inventory2__c opInv : opInvList){
                     opInvMap.put(opInv.Product__r.Product_Code__c,opInv);                                   
                }																																  
            }

            for(Liquidation2__c prodLiquidation : [SELECT Id, Product__r.Name, Product__r.Product_Code__c, Distributors_Inventory__c, Retailers_Inventory__c,  Month__c ,Opening_Inventory__c,YTD_Sales__c, Territory__c, Product__c, Liquidation_Annual_Plan__c, Product_Budget_LiqCum__c, Opening_Inventory2__c, Opening_Inventory2__r.Is_From_Liq_Module__c, Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c, Liquidation_YTD_Previous_Month__c, Prev_Month_YTD_Sales__c,Opening_Inventory_MTD__c,MTD_Sales__c 
                                                    FROM Liquidation2__c WHERE Liquidation_Annual_Plan__c = :lapIdStr AND Financial_Year__c = :fiscalYearStr 
                                                    AND Territory_Code__c = :territoryCode AND Month__c = :monthStr AND RecordTypeId = :rtForLiquidation AND Product__r.Product_Code__c IN :productMap.keySet()]){
                prodLiqMap.put(prodLiquidation.Product__r.Product_Code__c,prodLiquidation);
            }

            if(String.isBlank(prevFisYear) && liqStatus == 'Not Started'){
                if(!opInvMap.isEmpty()){
                    for(String prdCode : productMap.keySet()){
                        LiquidationSWALProductWrapper swalProd = new LiquidationSWALProductWrapper();
                        if(opInvMap.containsKey(prdCode)){
                            swalProd.prodCode = prdCode;
                            swalProd.lannualpId = lapId;
                            swalProd.terId = terrId;
                            swalProd.prodName = opInvMap.get(prdCode).Product__r.Name;
                            swalProd.prodId = opInvMap.get(prdCode).Product__c;
                            swalProd.opnInvId = opInvMap.get(prdCode).Id;
                            //commenting this code for now.
                            //swalProd.openInv = opInvMap.get(prdCode).Opening_Inventory__c!=null?opInvMap.get(prdCode).Opening_Inventory__c:0;
                            
                            switch on liqMonth{
                                when 'Jan'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Jan__c!=null?opInvMap.get(prdCode).MTD_Sales_Jan__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Dec__c!=null?opInvMap.get(prdCode).MTD_Sales_Dec__c:0;
                                }
                                when 'Feb'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Feb__c!=null?opInvMap.get(prdCode).MTD_Sales_Feb__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Jan__c!=null?opInvMap.get(prdCode).MTD_Sales_Jan__c:0;
                                }
                                                
                                when 'Mar'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Mar__c!=null?opInvMap.get(prdCode).MTD_Sales_Mar__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Feb__c!=null?opInvMap.get(prdCode).MTD_Sales_Feb__c:0;		                    }
                                
                                when 'May'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_May__c!=null?opInvMap.get(prdCode).MTD_Sales_May__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Apr__c!=null?opInvMap.get(prdCode).MTD_Sales_Apr__c:0;
                                }
                                when 'Jun'{		  
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Jun__c!=null?opInvMap.get(prdCode).MTD_Sales_Jun__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_May__c!=null?opInvMap.get(prdCode).MTD_Sales_May__c:0;
                                }
                                when 'Jul'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Jul__c!=null?opInvMap.get(prdCode).MTD_Sales_Jul__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Jun__c!=null?opInvMap.get(prdCode).MTD_Sales_Jun__c:0;
                                }
                                when 'Aug'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Aug__c!=null?opInvMap.get(prdCode).MTD_Sales_Aug__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Jul__c!=null?opInvMap.get(prdCode).MTD_Sales_Jul__c:0;
                                }
                                when 'Sept'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Sept__c!=null?opInvMap.get(prdCode).MTD_Sales_Sept__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Aug__c!=null?opInvMap.get(prdCode).MTD_Sales_Aug__c:0;
                                }
                                when 'Oct'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Oct__c!=null?opInvMap.get(prdCode).MTD_Sales_Oct__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Sept__c!=null?opInvMap.get(prdCode).MTD_Sales_Sept__c:0;
                                }
                                when 'Nov'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Nov__c!=null?opInvMap.get(prdCode).MTD_Sales_Nov__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Oct__c!=null?opInvMap.get(prdCode).MTD_Sales_Oct__c:0;
                                }
                                when 'Dec'{
                                    swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Dec__c!=null?opInvMap.get(prdCode).MTD_Sales_Dec__c:0;
                                    swalProd.prevMntYtdSale = opInvMap.get(prdCode).MTD_Sales_Nov__c!=null?opInvMap.get(prdCode).MTD_Sales_Nov__c:0;
                                }
                            }

                            
                            swalProd.prodBud = opInvMap.get(prdCode).Product_Budget_cum__c!=null?opInvMap.get(prdCode).Product_Budget_cum__c:0;
                            if(!prodLiqMap.isEmpty() && prodLiqMap.containsKey(prdCode)){
                                swalProd.distInv = prodLiqMap.get(prdCode).Distributors_Inventory__c!=null?prodLiqMap.get(prdCode).Distributors_Inventory__c:0;			   
                                swalProd.retInv = prodLiqMap.get(prdCode).Retailers_Inventory__c!=null?prodLiqMap.get(prdCode).Retailers_Inventory__c:0;
                                swalProd.totMrkInv = swalProd.distInv + swalProd.retInv;
                                swalProd.openInv =  swalProd.totMrkInv; //major change
                                swalProd.tAvbStck = swalProd.openInv + swalProd.ytdSale;
                                swalProd.liqYTD = swalProd.tAvbStck - swalProd.totMrkInv;   //(prodLiqMap.get(prdCode).Opening_Inventory__c+prodLiqMap.get(prdCode).YTD_Sales__c) - swalProd.totMrkInv;
                                swalProd.prevMntliqYTD = swalProd.liqYTD;
                                if(swalProd.tAvbStck == 0){
                                    swalProd.liqYTDPer = 0;
                                }else{
                                    swalProd.liqYTDPer = (swalProd.liqYTD/swalProd.tAvbStck).setScale(2);
                                }	 					 				 
                                swalProd.prevMntDI = prodLiqMap.get(prdCode).Distributors_Inventory__c!=null?prodLiqMap.get(prdCode).Distributors_Inventory__c:0;
                                swalProd.prevMntRI = prodLiqMap.get(prdCode).Retailers_Inventory__c!=null?prodLiqMap.get(prdCode).Retailers_Inventory__c:0;
                                if(allowOIEdit == 'True'){
                                    swalProd.isDisableOI = false;
                                 }else{
                                    swalProd.isDisableOI = true;
                                 }
                            }else{
                                swalProd.distInv = 0.0;			   
                                swalProd.retInv = 0.0;
                                swalProd.totMrkInv = swalProd.distInv + swalProd.retInv;
                                //swalProd.totMrkInv = 0.0;
                                swalProd.liqYTD = 0.0;
                                swalProd.prevMntliqYTD = 0.0;
                                swalProd.liqYTDPer = 0.0;	 					 				 
                                swalProd.prevMntDI = 0.0;
                                swalProd.prevMntRI = 0.0;
                                swalProd.isDisableOI = false;
                                swalProd.openInv =  0.0; 
                                swalProd.tAvbStck =  0.0; // This else part is for new product or new terrritory
                            }
                            swalProd.index = rowIndex;
                            prodLiquidationList.add(swalProd);
                        }
                        rowIndex ++;
                    }
                }
            }else if(!String.isBlank(prevFisYear) && liqStatus == 'Not Started'){
                //New Financial Year
                if(!opInvMap.isEmpty()){
                    for(String prdCode : productMap.keySet()){
                        LiquidationSWALProductWrapper swalProd = new LiquidationSWALProductWrapper();
                        swalProd.prodCode = prdCode;
                        swalProd.lannualpId = lapId;
                        swalProd.terId = terrId;
                        swalProd.prodId = productMap.get(prdCode).Id;
                        swalProd.prodName = productMap.get(prdCode).Name;
                        swalProd.opnInvId = opInvMap.get(prdCode).Id;
                        
                        swalProd.ytdSale = opInvMap.get(prdCode).MTD_Sales_Apr__c!=null?opInvMap.get(prdCode).MTD_Sales_Apr__c:0;
                        swalProd.prevMntYtdSale =0.0; //need to check
                        
                        swalProd.prodBud = opInvMap.get(prdCode).Product_Budget_cum__c!=null?opInvMap.get(prdCode).Product_Budget_cum__c:0.0;
                        if(!prodLiqMap.isEmpty() && prodLiqMap.containsKey(prdCode)){
                            swalProd.distInv = prodLiqMap.get(prdCode).Distributors_Inventory__c!=null?prodLiqMap.get(prdCode).Distributors_Inventory__c:0;
                            swalProd.retInv = prodLiqMap.get(prdCode).Retailers_Inventory__c!=null?prodLiqMap.get(prdCode).Retailers_Inventory__c:0;
                            swalProd.totMrkInv = swalProd.distInv + swalProd.retInv;
                            swalProd.openInv = swalProd.totMrkInv; // Major change
                            swalProd.tAvbStck = swalProd.openInv + swalProd.ytdSale;
                            swalProd.liqYTD =  swalProd.tAvbStck - swalProd.totMrkInv; //(prodLiqMap.get(prdCode).Opening_Inventory__c+prodLiqMap.get(prdCode).YTD_Sales__c)-swalProd.totMrkInv;
                            swalProd.prevMntliqYTD = swalProd.liqYTD;
                            if(swalProd.tAvbStck == 0){
                                swalProd.liqYTDPer = 0;
                            }else{
                                swalProd.liqYTDPer = (swalProd.liqYTD/swalProd.tAvbStck).setScale(2);
                            }
                            
                            swalProd.prevMntDI = prodLiqMap.get(prdCode).Distributors_Inventory__c!=null?prodLiqMap.get(prdCode).Distributors_Inventory__c:0;
                            swalProd.prevMntRI = prodLiqMap.get(prdCode).Retailers_Inventory__c!=null?prodLiqMap.get(prdCode).Retailers_Inventory__c:0;
                        }else{
                            swalProd.distInv = 0.0;
                            swalProd.retInv = 0.0;
                            swalProd.totMrkInv = 0.0;
                            swalProd.openInv = 0.0;
                            swalProd.tAvbStck = 0.0;
                            swalProd.liqYTD = 0.0;
                            swalProd.liqYTDPer = 0.0;
                            swalProd.prevMntDI = 0.0;
                            swalProd.prevMntRI = 0.0;
                        }
                        swalProd.isDisableOI = false;
                        swalProd.index = rowIndex;
                        prodLiquidationList.add(swalProd);
                        rowIndex ++;
                    }
                }
            }else if(!prodLiqMap.isEmpty() && liqStatus != 'Not Started'){
                for(String prdCode : productMap.keySet()){
                    LiquidationSWALProductWrapper swalProd = new LiquidationSWALProductWrapper();
                    if(prodLiqMap.containsKey(prdCode)){
                        swalProd.prodCode = prdCode;
                        swalProd.liqId = prodLiqMap.get(prdCode).Id;
                        swalProd.opnInvId = prodLiqMap.get(prdCode).Opening_Inventory2__c;
                        swalProd.lannualpId = prodLiqMap.get(prdCode).Liquidation_Annual_Plan__c;
                        swalProd.terId = prodLiqMap.get(prdCode).Territory__c;
                        swalProd.prodId = prodLiqMap.get(prdCode).Product__c;
                        swalProd.prodName = prodLiqMap.get(prdCode).Product__r.Name;
                        swalProd.openInv = prodLiqMap.get(prdCode).Opening_Inventory_MTD__c != null ? prodLiqMap.get(prdCode).Opening_Inventory_MTD__c : 0; //Opening_Inventory__c!=null?prodLiqMap.get(prdCode).Opening_Inventory__c:0;
                        swalProd.ytdSale = prodLiqMap.get(prdCode).MTD_Sales__c != null ? prodLiqMap.get(prdCode).MTD_Sales__c : 0; //YTD_Sales__c!=null?prodLiqMap.get(prdCode).YTD_Sales__c:0;
                        swalProd.tAvbStck = swalProd.openInv + swalProd.ytdSale;
                        swalProd.prodBud = prodLiqMap.get(prdCode).Product_Budget_LiqCum__c!=null?prodLiqMap.get(prdCode).Product_Budget_LiqCum__c:0.0;
                        swalProd.distInv = prodLiqMap.get(prdCode).Distributors_Inventory__c!=null?prodLiqMap.get(prdCode).Distributors_Inventory__c:0;
                        swalProd.retInv = prodLiqMap.get(prdCode).Retailers_Inventory__c!=null?prodLiqMap.get(prdCode).Retailers_Inventory__c:0;
                        swalProd.totMrkInv = swalProd.distInv + swalProd.retInv;
                        swalProd.liqYTD = (swalProd.tAvbStck - swalProd.totMrkInv);
                        if(swalProd.tAvbStck == 0){
                            swalProd.liqYTDPer = 0;
                        }else{
                            swalProd.liqYTDPer = (swalProd.liqYTD/swalProd.tAvbStck).setScale(2);
                        }
                        swalProd.index = rowIndex;
                        if((liqStatus == 'Approved' || liqStatus == 'Edit and Approved')
                                ||((liqStatus == 'In Progress' || liqStatus == 'Pending for Approval') && usrRole=='TM' && prodLiqMap.get(prdCode).Opening_Inventory2__r.Is_From_Liq_Module__c) 
                                || (liqStatus == 'In Progress' && (usrRole=='RM' || usrRole=='FMM' || usrRole=='ZML') && isTmAvb == false && prodLiqMap.get(prdCode).Opening_Inventory2__r.Is_From_Liq_Module__c)){
                            swalProd.isDisableOI = true;
                        }else if (((liqStatus == 'Rejected' || liqStatus == 'Unlocked') && usrRole=='TM' && (prodLiqMap.get(prdCode).Opening_Inventory2__r.Is_From_Liq_Module__c || allowOIEdit == 'True')) 
                        || ((liqStatus == 'Pending for Approval' || liqStatus == 'Unlocked') && (usrRole=='RM' || usrRole=='FMM' || usrRole=='ZML') && (prodLiqMap.get(prdCode).Opening_Inventory2__r.Is_From_Liq_Module__c || allowOIEdit == 'True'))){  //By pass validation
                            swalProd.isDisableOI = false;
                        }else{
                            swalProd.isDisableOI = true;
                        }
                        swalProd.prevMntDI = prodLiqMap.get(prdCode).Distributor_Inventory_Previous_Month__c!=null?prodLiqMap.get(prdCode).Distributor_Inventory_Previous_Month__c:0;
                        swalProd.prevMntRI = prodLiqMap.get(prdCode).Retailer_Inventory_Previous_Month__c!=null?prodLiqMap.get(prdCode).Retailer_Inventory_Previous_Month__c:0;
                        swalProd.prevMntYtdSale =prodLiqMap.get(prdCode).Prev_Month_YTD_Sales__c!=null?prodLiqMap.get(prdCode).Prev_Month_YTD_Sales__c:0;
                        swalProd.prevMntliqYTD = prodLiqMap.get(prdCode).Liquidation_YTD_Previous_Month__c!=null?prodLiqMap.get(prdCode).Liquidation_YTD_Previous_Month__c:0;
                        prodLiquidationList.add(swalProd);
                    }
                    rowIndex ++;
                }
            }
            return prodLiquidationList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
 
    public static List<LiquidationSWALProductWrapper> parseProductJsonString(String prodJsonStr){
        List<LiquidationSWALProductWrapper> liqSWALProdList = new List<LiquidationSWALProductWrapper>();
        liqSWALProdList = (List<LiquidationSWALProductWrapper>)JSON.deserializeStrict(prodJsonStr,List<LiquidationSWALProductWrapper>.class);
        return liqSWALProdList;
    }

	/*
    Method Name : createProductLiquidation
    Description : 
    */	 
    @AuraEnabled
    public static String createProductLiquidation(String prodLiqData, String liqMonth, String liqFiscalYear, String liqTerrCode, String liqStatus){
        try {
            List<Liquidation2__c> prodLiquidationUpsertList = new List<Liquidation2__c>();
            List<Liquidation_Approval_History__c> lahToInsertList = new List<Liquidation_Approval_History__c>();
            List<LiquidationSWALProductWrapper> liqSWALProductList = new List<LiquidationSWALProductWrapper>();
            Map<String,String> newOpeningInvMap = new Map<String,String>();
            List<Opening_Inventory2__c> opnInvUpsertList = new List<Opening_Inventory2__c>();
            Set<Id> prodIdSet = new Set<Id>();
            String liqapId;
            String terrDistId;
            
            Sales_Org__c salesOrg = [SELECT Id From Sales_Org__c Where Sales_Org_Code__c = :salesOrgCode];
            liqSWALProductList = parseProductJsonString(prodLiqData);
                  
            if(liqSWALProductList.size() > 0){
                /*for(LiquidationSWALProductWrapper afOpnInv : liqSWALProductList){
                    Opening_Inventory2__c opnInvObj = new Opening_Inventory2__c();
                    if(!afOpnInv.isDisableOI){
                            opnInvObj.Opening_Inventory__c = afOpnInv.openInv;
                            opnInvObj.Id = afOpnInv.opnInvId;
                            opnInvUpsertList.add(opnInvObj);
                    }
                }

                if(opnInvUpsertList.size() > 0){
                    UPDATE opnInvUpsertList;
                }*/

                for(LiquidationSWALProductWrapper swalProdLiq : liqSWALProductList){
                    Liquidation2__c prodLiq = new Liquidation2__c();
                    if(liqStatus == 'Rejected'||liqStatus == 'Pending for Approval'||liqStatus == 'Unlocked'){
                        prodLiq.Id = swalProdLiq.liqId;
                    }
                    prodLiq.Opening_Inventory2__c = swalProdLiq.opnInvId;
                    prodLiq.Opening_Inventory_MTD__c = swalProdLiq.openInv;//new entry
                    prodLiq.Liquidation_Annual_Plan__c = swalProdLiq.lannualpId;
                    prodLiq.Territory__c = swalProdLiq.terId;
                    prodLiq.Product__c = swalProdLiq.prodId;
                    //prodLiq.YTD_Sales__c = swalProdLiq.ytdSale;
                    prodLiq.MTD_Sales__c = swalProdLiq.ytdSale; // new entry
                    prodLiq.Distributors_Inventory__c = swalProdLiq.distInv;
                    prodLiq.Retailers_Inventory__c = swalProdLiq.retInv;
                    prodLiq.Month__c = liqMonth;
                    prodLiq.RecordTypeId = rtForLiquidation;
                    prodLiq.Distributor_Inventory_Previous_Month__c = swalProdLiq.prevMntDI;
                    prodLiq.Retailer_Inventory_Previous_Month__c = swalProdLiq.prevMntRI;
                    prodLiq.Liquidation_YTD_Previous_Month__c = swalProdLiq.prevMntliqYTD;
                    prodLiq.Prev_Month_YTD_Sales__c = swalProdLiq.prevMntYtdSale;
                    prodLiquidationUpsertList.add(prodLiq);
                    liqapId = swalProdLiq.lannualpId;
                    terrDistId = swalProdLiq.terId;
                }
            }

            if(prodLiquidationUpsertList.size() > 0){												   
                UPSERT prodLiquidationUpsertList;
            }

            if(liqStatus == 'Rejected' || liqStatus == 'Unlocked'){
                Liquidation_Approval_History__c lahObj = [SELECT Id, Approval_Status__c, Is_Product_Liquidation_Submitted__c FROM Liquidation_Approval_History__c WHERE LAP__c = :liqapId AND SalesOrg__r.Sales_Org_Code__c = :salesOrgCode AND Territory__r.TerritoryCode__c = :liqTerrCode AND LAP_Fiscal_Year__c = :liqFiscalYear AND Month__c = :liqMonth LIMIT 1];
                lahObj.Approval_Status__c = 'In Progress';
                lahObj.Is_Product_Liquidation_Submitted__c = true;								
                UPDATE lahObj;
            }else if(liqStatus == 'Pending for Approval'){
                Liquidation_Approval_History__c lahObj = [SELECT Id, Approval_Status__c, Is_Product_Liquidation_Submitted__c FROM Liquidation_Approval_History__c WHERE LAP__c = :liqapId AND SalesOrg__r.Sales_Org_Code__c = :salesOrgCode AND Territory__r.TerritoryCode__c = :liqTerrCode AND LAP_Fiscal_Year__c = :liqFiscalYear AND Month__c = :liqMonth LIMIT 1];
                lahObj.Is_Product_Liquidation_Submitted__c = true;
                UPDATE lahObj;
            }else if(liqStatus == 'Not Started'){
                Liquidation_Approval_History__c lahObj = new Liquidation_Approval_History__c();
                lahObj.Approval_Status__c = 'In Progress';
                lahObj.Is_Product_Liquidation_Submitted__c = true;
                lahObj.LAP__c = liqapId;
                lahObj.SalesOrg__c = salesOrg.Id;
                lahObj.Territory__c = terrDistId;
                lahObj.Submitted_By__c = UserInfo.getUserId();
				lahObj.Month__c = liqMonth;						   							   
                INSERT lahObj;
            }
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Method Name : handleLiquidationApproval
     * Description : 
     */
    
    @AuraEnabled
    public static string updateLiquidationApproval(String actionName, String terrCode, String fiscalYear, String liqMonth, String remarks){
        try {
            String lapId;
            List<Liquidation_Approval_History__c> liqAppHistoryToUpdateList = new List<Liquidation_Approval_History__c>();
            Liquidation_Annual_Plan__c lapObj = [SELECT Id, Name FROM Liquidation_Annual_Plan__c WHERE Sales_Org_Code__c = :salesOrgCode and FIscal_Year__c= :fiscalYear AND Territory_Name__r.TerritoryCode__c = :terrCode AND RecordTypeId = :rtForAnnualPlan LIMIT 1];
            lapId = lapObj.Id;

            for(Liquidation_Approval_History__c liqAppHistory : [SELECT Id, Approval_Status__c, Comments__c, Approved_Rejected_By__c FROM Liquidation_Approval_History__c WHERE LAP__c = :lapId AND SalesOrg__r.Sales_Org_Code__c = :salesOrgCode AND Territory__r.TerritoryCode__c = :terrCode AND LAP_Fiscal_Year__c = :fiscalYear AND Month__c = :liqMonth LIMIT 1]){
                if(actionName == 'Approved'){
                    liqAppHistory.Approval_Status__c = 'Approved';
                    liqAppHistory.Comments__c = remarks;
                    liqAppHistory.Approved_Rejected_By__c = UserInfo.getUserId();
                }else if(actionName == 'Rejected'){
                    liqAppHistory.Approval_Status__c = 'Rejected';
                    liqAppHistory.Comments__c = remarks;
                    liqAppHistory.Approved_Rejected_By__c = UserInfo.getUserId();
                }
                liqAppHistoryToUpdateList.add(liqAppHistory);
            }

            if(liqAppHistoryToUpdateList.size() > 0){
												   
                UPDATE liqAppHistoryToUpdateList;
            }

            return 'Success';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    /**
     * Method Name : getCropBreakupData
     * Description : 
     */
    
    @AuraEnabled
    public static string getCropBreakupData(String territoryCode, String fisYear, String liqMonth){
        try {
            String lapId;
            String liqStatus;
            boolean isProdSubmitted = false;
            boolean isCropSubmitted = false;
            Set<String> prodCodeSet = new Set<String>();
            String monthStr;
            String fyStr;
            String retData;

            LiquidationSWAlCropTableWrapper swalCropTableWrapper = new LiquidationSWAlCropTableWrapper();
            swalCropTableWrapper.liqSWALCropList = new List<Crop__c>();
            swalCropTableWrapper.swalProdLiqList = new List<Liquidation2__c>();
            swalCropTableWrapper.swalCropLiqList = new List<Crop_Liquidation__c>();
            swalCropTableWrapper.byCropPassValid = allowCropValidationBypass;  //By pass validation 

            //Populate Month Map
            MAP<Integer,String> monthMap = new MAP<Integer,String>();
            monthMap.put(4,'Apr');
            monthMap.put(5,'May');
            monthMap.put(6,'Jun');
            monthMap.put(7,'Jul');
            monthMap.put(8,'Aug');
            monthMap.put(9,'Sept');
            monthMap.put(10,'Oct');
            monthMap.put(11,'Nov');
            monthMap.put(12,'Dec');
            monthMap.put(1,'Jan');
            monthMap.put(2,'Feb');
            monthMap.put(3,'Mar');

            //Get Liquidation Anual Plan details for current territory and Fiscal Year
            List<Liquidation_Annual_Plan__c> liqAPList = [SELECT Id, Name FROM Liquidation_Annual_Plan__c WHERE Sales_Org_Code__c = :salesOrgCode and FIscal_Year__c= :fisYear AND Territory_Name__r.TerritoryCode__c = :territoryCode AND RecordTypeId = :rtForAnnualPlan LIMIT 1];
            if(liqAPList.size() > 0){
                lapId = liqAPList[0].Id;

                //Liquidation Status for liqMonth
                List<Liquidation_Approval_History__c> liqStatusList = [SELECT Id, Approval_Status__c, Is_Product_Liquidation_Submitted__c, Is_Crop_Liquidation_Submitted__c, LAP_Fiscal_Year__c FROM Liquidation_Approval_History__c 
                                    WHERE LAP__c = :lapId AND SalesOrg__r.Sales_Org_Code__c = :salesOrgCode AND Territory__r.TerritoryCode__c = :territoryCode AND LAP_Fiscal_Year__c = :fisYear AND Month__c = :liqMonth LIMIT 1];
                if(liqStatusList.size()>0){
                    liqStatus = liqStatusList[0].Approval_Status__c;
                    isCropSubmitted = liqStatusList[0].Is_Crop_Liquidation_Submitted__c;
                    swalCropTableWrapper.liqStatus = liqStatus;
                    swalCropTableWrapper.isCrpSub = isCropSubmitted;

                    /*if(liqStatus == 'In Progress' && isCropSubmitted == false){
                        Integer curMonth = Date.Today().Month();
                        if(curMonth >= 3 && curMonth <= 12){
                            monthStr =  monthMap.get(curMonth-2);
                        }else if(curMonth < 3){
                            monthStr =  monthMap.get(curMonth+10);
                        }
                        if(curMonth == 5){
                            List<String> res = fisYear.split('-',2);
                            fyStr = String.valueOf(Integer.valueOf(res[0])-1)+'-'+String.valueOf(Integer.valueOf(res[1])-1);
                        }else{
                            fyStr = fisYear;
                        }
                    }else{
                        monthStr = liqMonth;
                        fyStr = fisYear;
                    }*/
                    monthStr = liqMonth;
                    fyStr = fisYear;
                }

                //Get Crop Name List
                for(Crop__c cropName : [SELECT Id,Name,Crop_Order__c FROM Crop__c Where Sales_Org_Code__c = :salesOrgCode AND Active__c = true AND Active_for_Crop_Liquidation__c = true AND Is_Old_Crop__c = false ORDER By Crop_Order__c ASC]){
                    swalCropTableWrapper.liqSWALCropList.add(cropName);
                }

                //get product liq data where liq YTD is not 0
                for(Liquidation2__c prdLiq : [SELECT Id, Product__r.Name, Product__r.Product_Code__c, Liquidation_MTD_SWAL__c 
                                                FROM Liquidation2__c 
                                                WHERE Territory_Code__c =:territoryCode AND Financial_Year__c =:fisYear AND Month__c =:liqMonth AND Liquidation_MTD_SWAL__c > 0 AND Liquidation_Annual_Plan__c = :lapId AND RecordTypeId = :rtForLiquidation ORDER BY Liquidation_MTD_SWAL__c DESC]){
                    swalCropTableWrapper.swalProdLiqList.add(prdLiq);
                    prodCodeSet.add(prdLiq.Product__r.Product_Code__c);
                }

                //get Crop Liquidation data
                if(prodCodeSet.size() > 0){
                    for(Crop_Liquidation__c crpLiq : [SELECT Id, Liquidation__c,Liquidation__r.Product__r.Product_Code__c, Crop__r.Id, Crop__r.Name,Crop__r.Crop_Order__c, Liquidation_Value__c, Liquidation_YTD_Prev_Month__c,Liquidation_YTD_Trade__c,Prev_Month_Crop_Liquidation_Volume__c
                                                        FROM Crop_Liquidation__c 
                                                        WHERE Liquidation__r.Product__r.Product_Code__c  In :prodCodeSet AND Liquidation_Month__c = :monthStr AND Territory_Code__c = :territoryCode AND Liquidation__r.Financial_Year__c =:fyStr AND RecordTypeId = :rtForCropLiquidation AND Crop__r.Is_Old_Crop__c = false
                                                        ORDER BY Crop__r.Name ASC]){
                        swalCropTableWrapper.swalCropLiqList.add(crpLiq);                                   
                    }
                }
            }
            retData = JSON.serialize(swalCropTableWrapper);
            return retData;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
	
	/*
    Method Name : parseCropJsonString
    Description : 
    */
    public static List<LiquidationSWALCropWrapper> parseCropJsonString(String cropJsonStr){
        List<LiquidationSWALCropWrapper> liqSWALCropList = new List<LiquidationSWALCropWrapper>();
        liqSWALCropList = (List<LiquidationSWALCropWrapper>)JSON.deserializeStrict(cropJsonStr,List<LiquidationSWALCropWrapper>.class);
        return liqSWALCropList;
    }

    /*
    Method Name : createCropLiquidation
    Description : 
    */
    @AuraEnabled
    public static string createCropLiquidation(String cropLiqData, String territoryCode, String fiscalYear, String liqMonth, String liqStatus, String userRole, String remarks){
        try {
            List<LiquidationSWALCropWrapper> liqSWALCropList = new List<LiquidationSWALCropWrapper>();
            List<Crop_Liquidation__c> cropLiqToUpsertList  = new List<Crop_Liquidation__c>();

            Sales_Org__c salesOrg = [SELECT Id From Sales_Org__c Where Sales_Org_Code__c = :salesOrgCode];
            liqSWALCropList = parseCropJsonString(cropLiqData);

            if(liqSWALCropList.size() > 0){
                for(LiquidationSWALCropWrapper crpWrap : liqSWALCropList){
                    Crop_Liquidation__c cropLiq = new Crop_Liquidation__c();
                    cropLiq.RecordTypeId = rtForCropLiquidation;
                    cropLiq.Liquidation__c = crpWrap.liqId;
                    cropLiq.Sales_Org__c = salesOrg.Id;
                    cropLiq.Liquidation_YTD_Trade__c = crpWrap.prodYTD;
                    cropLiq.Liquidation_Value__c = crpWrap.curLiqValue;
                    cropLiq.Prev_Month_Crop_Liquidation_Volume__c = crpWrap.prevLiqValue;
                    cropLiq.is_Crop_Liquidation_Submitted__c = true;
                    cropLiq.Crop__c = crpWrap.crpId;
                    cropLiq.Liquidation_YTD_Prev_Month__c = crpWrap.prevMonthLiqYTD;
					if(!String.isBlank(crpWrap.crpLiqId)){									  
						cropLiq.Id = crpWrap.crpLiqId;
					} 
                    cropLiqToUpsertList.add(cropLiq);
                }
            }

            //UPSERT Crop Liquidation
            if(cropLiqToUpsertList.size() > 0){
											 
                UPSERT cropLiqToUpsertList;
            }
            //Update Liquidation Approval History Status
            Liquidation_Approval_History__c lahObj = [SELECT Id, Approval_Status__c, Is_Product_Liquidation_Submitted__c, Is_Crop_Liquidation_Submitted__c, Comments__c 
                                                        FROM Liquidation_Approval_History__c 
                                                        WHERE SalesOrg__r.Sales_Org_Code__c = :salesOrgCode AND Territory__r.TerritoryCode__c = :territoryCode AND LAP_Fiscal_Year__c = :fiscalYear AND Month__c = :liqMonth LIMIT 1];

            if(userRole == 'TM' && liqStatus == 'In Progress'){
                lahObj.Approval_Status__c = 'Pending for Approval';
                lahObj.Is_Crop_Liquidation_Submitted__c = true;
                lahObj.Is_Product_Liquidation_Submitted__c = false;
            }else if((userRole=='RM' || userRole=='FMM' || userRole=='ZML') && liqStatus == 'In Progress'){
                lahObj.Approval_Status__c = 'Approved';
                lahObj.Is_Crop_Liquidation_Submitted__c = true;
                lahObj.Approved_Rejected_By__c = UserInfo.getUserId();
            }else if((userRole=='RM' || userRole=='FMM' || userRole=='ZML') && liqStatus == 'Pending for Approval'){
                lahObj.Approval_Status__c = 'Edit and Approved';
                lahObj.Comments__c = remarks;
                lahObj.Approved_Rejected_By__c = UserInfo.getUserId();
            }			
            UPDATE lahObj;
            return 'Success';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    //Wrapper
    public class LiquidationWrapper{
        @AuraEnabled
        public Map<String,String> territoryMap{get;set;}
        @AuraEnabled
        public Map<String,boolean> isTMAvailableMap{get;set;}
        @AuraEnabled
        public String FiscalYear {get;set;}
        @AuraEnabled
        public String userRole {get;set;}
        @AuraEnabled
        public boolean validLiqPeriod {get;set;}
        @AuraEnabled
        public Map<String,boolean> isFMMHasRoleMap{get;set;}
        @AuraEnabled
        public Map<String,boolean> isZMLHasRoleMap{get;set;}
    }

    public class LiquidationSWALProductWrapper {
        private String lannualpId {get;set;}
        private String terId {get;set;}
        private String prodId {get;set;}
        private String opnInvId {get;set;}
        private String prodCode {get;set;}
        private String prodName {get;set;}
        private Decimal openInv {get;set;}
        private Decimal ytdSale {get;set;}
        private Decimal prevMntYtdSale {get;set;}
        private Decimal tAvbStck {get;set;}
        private Decimal distInv {get;set;}
        private Decimal retInv {get;set;}
        private Decimal totMrkInv {get;set;}
        private Decimal prodBud {get;set;}
        private Decimal liqYTD {get;set;}
        private Decimal prevMntliqYTD {get;set;}
        private Decimal liqYTDPer {get;set;}
        private Integer index {get;set;}
        private String liqMonth{get;set;}
        private String liqId{get;set;}  
        private boolean isDisableOI{get;set;}
        private Decimal prevMntDI{get;set;}
        private Decimal prevMntRI{get;set;}
        private boolean isOpnInvEdit{get;set;}
    }

    public class LiquidationSWALProductTableWrapper {
        public String liqStatus {get;set;}
        public boolean isProdSub {get;set;}
        public List<LiquidationSWALProductWrapper> liqSWALProductList {get;set;}
        public String byProdPassValid{get;set;}   //By pass validation
    }

    public class LiquidationSWALCropTableWrapper {
        public String liqStatus {get;set;}
        public boolean isCrpSub {get;set;}
        public List<Crop__c> liqSWALCropList {get;set;}
        public List<Liquidation2__c> swalProdLiqList {get;set;}
        public List<Crop_Liquidation__c> swalCropLiqList {get;set;}
        public String byCropPassValid{get;set;}   //By pass validation
    }

    public class LiquidationSWALCropWrapper {
        private String crpLiqId {get;set;}
        private String liqId {get;set;}
        private String crpName {get;set;}
        private String crpId {get;set;}
        private String prdCode {get;set;}
        private Decimal curLiqValue {get;set;}
        private Decimal prevLiqValue {get;set;}
		private Decimal prodYTD {get;set;}								  
        private Decimal prevMonthLiqYTD {get;set;}
		private Integer sortOrder {get;set;}
        private String crpIndex {get;set;}									  
    }
}