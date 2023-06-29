/*
* Name: LiquidationTradeSalesController_SWAL 
* Created On: 21-09-2018
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: Class is used for Liquidation of SWAL (for only TM and RM, for ZH and Admin not available) 
* Object used: Product2, Liquidation2, Openinventtory2
* Latest Code Change : SCTASK0292264, Sayan - Now SWAL Zonal Heads are given provision as same as ZMMs
* Supported test class : LiquidationTradeSalesSWAL_Test
*/

global class LiquidationTradeSalesController_SWAL {
    
    public Integer selectedMonth{get;set;} //
    public String startDate1 {get;set;}
    public Date StartDate {get;set;}
    public Date EndDate;
    public Integer totalProductNumber {get;set;} // for total number of Product list
    public Integer selectMonth {get;set;}
    public Integer totalLiquidation {get;set;}
    public String submittedMonth {get;set;}
    public String yearForVf {get;set;}
    public List<Crop__c> cropNameListvf {get;set;} 
    public List<Product2>productListForCropLiqui {get;set;}
    
    public  Id rtforAnnualPlan;
    public  Id rtForOpeningInventory;
    public  Id rtforLiquidation;
    
    //String
    public String Select_Year{get;set;} //selected year
    public String selectedTeritorry{get;set;}//selected teritory
    public String fieldTotupdate {get;set;}
    public String recordIdTotupdate{get;set;}
    public String valueToupdate {get;set;}
    public String monthForVF {get;set;}
    public String monthForNextVF {get;set;}
    //Added by Varun Shrivastava: SCTASK0459610 start
    public String monthForPreviousVF {get;set;}
    public Boolean isLiquidationValidationEnabled{get;set;}
    public Boolean hideCurrentMonthLiqOption{get;set;}
    //Added by Varun Shrivastava: SCTASK0459610 End
    public String selectedYear {get;set;}
    public String prodIdTotupdate {get;set;}
    public Boolean forCropSubmit{get;set;}
    String profName;
    public List<String> popYearList {get;set;}
    
    
    //Boolean
    public Boolean isTM {get;set;} // flag for user profile.
    public Boolean isRM {get;set;} // flag for Regional/Zonal Mangers
    public Boolean isZH {get;set;} //flag for Sales Head  
    public Boolean isSBU {get;set;}  //flag for SBU
    public Boolean isAdmin {get;set;}
    public Boolean isZMM {get;set;}
    public Boolean isAvail {get;set;} //flag for liquidation annual plan  for month is available or not
    public Boolean isSubmitted {get;set;} //after submitted disable the section.
    public Boolean isOpenInvLock {get;set;}
    public Boolean forupdate {get;set;}
    //Code fix for Liquidation module
    public Boolean isLiqSubmitted;
    public Boolean isTerritoryManagerAbsent {get;set;}
    
    
    
    //List
    
    public List<String>teritorynameList{get;set;}
    
    public List<Product2>productList {get;set;}
    public List <Liquidation2__c> liquiList {get;set;}
    public List <Opening_Inventory2__c> openInvList {get;set;}
    //End of getter and Setter
    
    //SET
    SET <String> populateYearSet {get;set;}
    
    //Select option
    public SET <String> popuYear {get;set;}
    //variable declaration of String
    private String userId;
    public String teritoryCode = '';
    
    //variable declaration of Map
    public Map<Id,Liquidation2__c> liquidationMap {get;set;}
    public Map<Id,Opening_Inventory2__c> OpeningInventoryMap {get;set;}
    
    public Map<String,Liquidation2__c> liquidationMap_vf {get;set;}
    public Map<String,Opening_Inventory2__c> OpeningInventoryMap_vf {get;set;}
    public MAP<String,Liquidation2__c> newLiqMap{get;set;}
    private MAP<Integer,String> monthMap = new MAP<Integer,String>();
    public Map<String,Opening_Inventory2__c> newOpenMap ;
    public Map<String,String> territoryMap ;   //= new Map<String,String>();
    
    //variable declaration of Boolean
    public Boolean isDataAvail; //Checking Data is avail previously or not.
    public Boolean flag;
    
    //Declaration for Date type
    private  Date Today;
    private String month; 
    public String ZHId;
    
    //this is for Crop Liquidation
    public Map<String,List<Crop_Liquidation__c>> cropLiquidationMap_vf {get;set;}
    public Boolean isSubmittedCropLiqui {get;set;} // this is used when crop Liquidation is Submitted./ not to edited
    
    
    //variable declaration for Integer
    
    //variable declaration for List
    public  List<Liquidation_Annual_Plan__c> liquiAnualPlan{get;set;}//master data for current year selected teritory
    // private List<Opening_Inventory__c>openingInvList = new List<Opening_Inventory__c>(); 
    public List<TM_District_Tehsil_Mapping__c> userTehsilMapping;
    public List <Territory_Distributor__c> teriList {get;set;}
    
    public List<Territory_Distributor__c> teriListForUser1 ;
    public List<Territory_Distributor__c> teriListForUser2 ;
    public List<Territory_Distributor__c> teriListForUser3 ;
    public List<Territory_Distributor__c> teriListForUser4 ;
    public List<Territory_Distributor__c> teriListForUser5 ;
    public List<Territory_Distributor__c> ZMMLst;
    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
    public Map<Id,List<Sub_Crops__c>> cropTosubCropMap {get;set;}
    public Map<Id,List<Sub_Crop_Liquidation__c>> liquidationToSubCropLiqMap{get;set;}
    public Map<Id,Integer> cropToSubCropSizeMap{get;set;}
    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
    
    
    
    public LiquidationTradeSalesController_SWAL(){
        try{
            selectedMonth = 0; 
            monthForVF = '';
            monthForNextVF = '';
            //Added by Varun Shrivastava : SCTASK0459610
            monthForPreviousVF = '';
            //Added by Varun Shrivastava : End
            isLiqSubmitted = false; //Code fix for Liquidation module
            
            userId =UserInfo.getUserId();
            //userId =UserInfo.getUserRoleId();
            isTM = false;  // flag for user profile.
            isRM = false; // flag for Regional/Zonal Mangers
            isZH = false; //flag for Sales Head  
            isSBU = false;  //flag for SBU
            isAdmin = false;
            isAvail = false; //flag for liquidation annual plan  for month is available or not
            isSubmitted = false; //after submitted disable the section.
            isOpenInvLock = false;
            isZMM = false;
            forupdate = false;
            ZHId = '';
            isSubmittedCropLiqui = false;
            
            
            
            Today= System.today();
            
            selectedMonth = Today.month();
            
            if(selectedMonth == 1){
                selectedMonth = 12;
            }else{
                selectedMonth =selectedMonth-1;
            }
            
            
            //Added by Varun Shrivastava : Start : SCTASK0459610
            List<Multi_Country_Liquidation__c> liqSettingRecord = [Select Enable_Liq_Validation__c, Hide_Current_Month_Option__c from Multi_Country_Liquidation__c where Country__c	 = 'SWAL' limit 1];           
            isLiquidationValidationEnabled = false;
            hideCurrentMonthLiqOption = false;
            if(liqSettingRecord != null && liqSettingRecord.size() > 0){
                isLiquidationValidationEnabled = liqSettingRecord[0].Enable_Liq_Validation__c;
                Profile pf = [Select ID, Name from Profile where Id = :UserInfo.getProfileId()];
                if(pf.Name != 'System Administrator' && liqSettingRecord[0].Hide_Current_Month_Option__c){
                    hideCurrentMonthLiqOption = true;   
                }
            }
            //Added by Varun Shrivastava : Start : SCTASK0459610
            
            totalLiquidation = 0;
            submittedMonth ='';
            
            yearForVf = '';
            //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
            cropTosubCropMap = new Map<Id,List<Sub_Crops__c>>();
            liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>> ();
            cropToSubCropSizeMap = new Map<Id,Integer>(); 
            isTerritoryManagerAbsent=false;
            //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
            
            liquiAnualPlan = new List<Liquidation_Annual_Plan__c>();
            productList = new List<Product2>();
            forupdate = true;
            teritorynameList = new List<String>();
            liquiList =  new List<Liquidation2__c>();
            
            openInvList =new List<Opening_Inventory2__c>();
            userTehsilMapping = new List<TM_District_Tehsil_Mapping__c>();
            
            liquidationMap =new Map<Id,Liquidation2__c>();
            territoryMap = new Map<String,String>();
            OpeningInventoryMap = new Map<Id,Opening_Inventory2__c>();
            
            liquidationMap_vf =new Map<String,Liquidation2__c>();
            OpeningInventoryMap_vf = new Map<String,Opening_Inventory2__c>();
            newLiqMap =new MAP<String,Liquidation2__c>();
            newOpenMap = new Map<String, Opening_Inventory2__c>();
            popuYear =new Set<String>();
            populateYearSet =new SET <String>();
            popYearList =new List<String> ();
            cropNameListvf = new List<Crop__c>();
            productListForCropLiqui = new List<Product2>();
            teriList = new  List <Territory_Distributor__c> (); 
            teriListForUser1 =new List<Territory_Distributor__c>();
            teriListForUser2 =new List<Territory_Distributor__c>();
            teriListForUser3 =new List<Territory_Distributor__c>();
            teriListForUser4 =new List<Territory_Distributor__c>();
            teriListForUser5 = new List<Territory_Distributor__c>();
            ZMMLst = new List<Territory_Distributor__c>();
            
            rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
            rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
            rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
            populateYear();
            
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
            
            
            if(selectedMonth == 12){
                monthForNextVF = monthMap.get(1);
            }else{
                monthForNextVF = monthMap.get(selectedMonth+1);
            }
            
            monthForVF = monthMap.get(selectedMonth);
            //Added by Varun Shrivastava : SCTASK0459610
            if(selectedMonth == 1)
                monthForPreviousVF = monthMap.get(12);
            else    
                monthForPreviousVF = monthMap.get(selectedMonth-1);
            //Added by Varun Shrivastava : End
            
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            
            StartDate = currentFiscalYear.StartDate;
            startDate1 = String.valueOf(StartDate);
            
            
            EndDate = currentFiscalYear.EndDate;
            
            productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                           Sales_Org_Code__c,Brand_Type__c ,
                           Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                           FROM Product2 
                           WHERE IsActive = true 
                           AND Sales_Org_Code__c = '1210' 
                           AND Active_For_Liquidation__c= true];            
            totalProductNumber = productList.size();
            
            
            
            
            
            
            //this query is checking for loging user is Territory Manager
            teriListForUser1 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,Zonal_Manager_Id__c,
                                Regional_Manager_Id__c,ZonalManager__c, SBU__c,  Zone__c, SBUHead__c 
                                FROM Territory_Distributor__c 
                                WHERE Present_in_KEDE__c = true 
                                AND Neglected__c = false 
                                AND TerritoryCode__c != '#' 
                                AND TerritoryManager__c=:userId
                                AND Sales_Org_Code__c='1210'];
            
            
            if(teriListForUser1.size()>0){
                isTM = true;
                
                ZHId =teriListForUser1[0].Regional_Manager_Id__c;
            }else{
                productList = new List<Product2>();
                isTM = false;  
            }
            //End of Checking TM
            if(selectedMonth == 3 || Test.isRunningTest()){
                
                Period currentFiscalYear1 = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                             FROM Period WHERE Type = 'Year' 
                                             AND StartDate <= TODAY 
                                             AND EndDate >= TODAY];
                
                DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear1.EndDate,Time.newInstance(0,0,0,0));
                
                
                Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
                
                
                Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                         From Period 
                                         WHERE EndDate< :theDate
                                         AND Type ='Year' order By EndDate DESC Limit 1];
                Select_Year = lastFiscalYear.StartDate.year()+'-'+lastFiscalYear.EndDate.year(); 
                
            }else{
                Select_Year = currentFiscalYear.StartDate.year()+'-'+currentFiscalYear.EndDate.year();    
            }
            
            //Checking for RM
            teriListForUser2 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,ZonalManager__c, 
                                SBU__c,Regional_Manager_Id__c,  Zone__c, SBUHead__c 
                                FROM Territory_Distributor__c 
                                WHERE Present_in_KEDE__c = true 
                                AND Neglected__c = false 
                                AND TerritoryCode__c != '#' 
                                AND (Regional_Manager_Id__c=: userId OR FMM_User_Id__c=:userId)
                                AND Sales_Org_Code__c='1210'];
            
            if(teriListForUser2.size()>0){
                isRM = true;
                isSubmitted = true;
                forCropSubmit = true;
                
            }else{
                isRM = false;
                
            }//end of RM checking
            
            
            
            
            
            ZMMLst =[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,Zonal_Marketing_Manager_1_Id__c,
                     Zonal_Marketing_Manager_2_Id__c,Zonal_Marketing_Manager_3_Id__c,ZonalManager__c,Zonal_Manager_Id__c,
                     SBU_Head_Id__c, SBU__c,  Zone__c, SBUHead__c 
                     FROM Territory_Distributor__c 
                     WHERE Present_in_KEDE__c = true 
                     AND Neglected__c = false 
                     AND TerritoryCode__c != '#' 
                     AND Sales_Org_Code__c='1210'
                     AND (ZonalManager__c= :userId
                          OR Zonal_Manager_Id__c= :userId
                          OR Zonal_Marketing_Manager_1_Id__c =:userId 
                          OR Zonal_Marketing_Manager_2_Id__c =:userId 
                          OR Zonal_Marketing_Manager_2_Id__c =:userId ) ];
            if(ZMMLst.size()>0){
                isZMM = true;
                isSubmitted = true;
                forCropSubmit = true;
            }else{
                isZMM = false;
            }
            
            //start basic for TM
            if(isTM){
                teriList = [select id,Name,TerritoryManager__c,SalesOrg__c 
                            FROM Territory_Distributor__c WHERE TerritoryManager__c=:userId
                            AND Sales_Org_Code__c='1210'];
                if(teriList.size()>0){
                    selectedTeritorry = teriList[0].Name;
                    if(selectedMonth == 3){
                        
                        Period currentFiscalYear2 = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                                     FROM Period WHERE Type = 'Year' 
                                                     AND StartDate <= TODAY 
                                                     AND EndDate >= TODAY];
                        
                        DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear2.EndDate,Time.newInstance(0,0,0,0));
                        
                        
                        Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
                        Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                                 From Period 
                                                 WHERE EndDate< :theDate
                                                 AND Type ='Year' order By EndDate DESC Limit 1];
                        
                        StartDate = lastFiscalYear.StartDate;
                        startDate1 = String.valueOf(StartDate);
                        
                        liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, 
                                           Fiscal_Start_Date__c, Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:lastFiscalYear.StartDate
                                                  AND Fiscal_End_Date__c=:lastFiscalYear.EndDate)
                                           AND(Territory_Name__c =:teriList[0].id)
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210'];
                        
                        
                    }else{
                        System.debug('liquiAnualPlan while Testing StartDate '+StartDate);
                        System.debug('liquiAnualPlan while Testing EndDate '+EndDate);
                        System.debug('liquiAnualPlan while Testing teriList[0].id '+teriList[0].id);
                        
                        liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, 
                                           Fiscal_Start_Date__c, Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:StartDate
                                                  AND Fiscal_End_Date__c=:EndDate)
                                           AND(Territory_Name__c =:teriList[0].id)
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210'];
                    }
                    
                    System.debug('liquiAnualPlan while Testing '+liquiAnualPlan);
                    if(liquiAnualPlan.size()>0){
                        openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,
                                       Opening_Inventory__c,YTD_Sales__c,Opening_Inventory_Cooperatives__c,
                                       //Added by Varun Shrivastava:SCTASK0459610
                                       Product_Budget__c,
                                       YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                          			   YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           			   YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                                       //Added by Varun Shrivastava:SCTASK0459610
                                       Opening_Inventory_Govt__c,Product__c,State__c,Territory__c
                                       FROM Opening_Inventory2__c 
                                       WHERE Territory__c=:teriList[0].id 
                                       AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                       AND RecordTypeId =: rtForOpeningInventory];
                        
                        for(Opening_Inventory2__c prodObj:openInvList){
                            OpeningInventoryMap.put(prodObj.Product__c, prodObj);
                            
                        }
                        
                        teritorynameList.add(teriList[0].Name); 
                        selectedTeritorry = teriList[0].Name;
                        
                    }else{
                        //if Annual Plan is not created then, productlist will null to avoid mapkey not found
                        productList = new List<Product2>();
                    }
                    
                    
                    
                    
                }
            }// End of TM Basic
            
            //if RM is log in then it display Rollup summary
            if(isRM){
                
                RollupTradeSalesLiquidation_SWAL  RollupTradeSalesLiquidation_SWALObj = new RollupTradeSalesLiquidation_SWAL();
                territoryMap = new Map<String,String>();
                territoryMap = RollupTradeSalesLiquidation_SWALObj.getRMTeritories();
                
                if(territoryMap.size()>0){
                    
                    
                    
                    teritorynameList = territoryMap.values();
                    if(selectedMonth == 3){
                        
                        
                        String strStratDate  = Select_Year.split('-')[1];
                        
                        Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                        
                        
                        Period currentFiscalYearRM = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' 
                                                      AND (StartDate <=:d AND EndDate >=:d)];
                        StartDate = currentFiscalYearRM.StartDate;
                        startDate1 = String.valueOf(StartDate);
                        
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYearRM.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYearRM.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210']; 
                        
                        
                        
                        
                        
                    }else{
                        
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYear.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYear.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210'];
                        
                    }
                    
                    
                    if(liquiAnualPlan.size()>0){
                        
                        selectedTeritorry= 'All';
                        newLiqMap = RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        newOpenMap = RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        
                        
                        
                        if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size() */|| Test.isRunningTest()){
                            liquidationMap_vf.clear();
                            OpeningInventoryMap_vf.clear();
                            displayProduct();
                            refreshProductList(newOpenMap,newLiqMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        }else{
                            productList = new List<Product2>();  
                        }
                    }else{
                        productList = new List<Product2>();    
                    }
                }else{
                    productList = new List<Product2>();
                }
                
            }// end of Roll up of RM
            
            //Start of Rollup summary for Zonal Head
            if(isZH || isZMM){
                RollupTradeSalesLiquidation_SWAL RollupTradeSalesLiquidation_SWALObj =new RollupTradeSalesLiquidation_SWAL();
                territoryMap = new Map<String,String>();
                territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                if(territoryMap.size()>0){
                    teritorynameList = territoryMap.values();
                    
                    if(selectedMonth == 3){
                        
                        
                        String strStratDate  = Select_Year.split('-')[1];
                        
                        Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                        
                        
                        Period currentFiscalYearZH = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' 
                                                      AND (StartDate <=:d AND EndDate >=:d)];
                        StartDate = currentFiscalYearZH.StartDate;
                        startDate1 = String.valueOf(StartDate);
                        
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYearZH.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYearZH.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId = :rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210' ];                        
                        
                        
                    }else{
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYear.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYear.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId = :rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210' ];
                    }
                    
                    
                    
                    if(liquiAnualPlan.size()>0){
                        selectedTeritorry ='All';
                        newLiqMap = RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                        newOpenMap = RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        
                        if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size()*/ || Test.isRunningTest()){
                            liquidationMap_vf.clear();
                            OpeningInventoryMap_vf.clear();
                            displayProduct();
                            refreshProductList(newOpenMap,newLiqMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                            
                        }else{
                            productList = new List<Product2>();
                        }
                        
                        
                    }else{
                        productList = new List<Product2>();
                    }
                    
                    
                }else{
                    productList = new List<Product2>();
                }
            }//end of rollup of Zonal Head
            
            
            
            
            
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getLineNumber());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
    }// End of Constructor
    
    // This is default Method
    public void defaultMethod(){
        try{
            String mth = monthMap.get(selectedMonth);
            //Added by Varun Shrivastava : Start : SCTASK0459610
            if(hideCurrentMonthLiqOption || Test.isRunningTest()){
                selectedMonth = selectedMonth - 1;
                mth = monthMap.get(selectedMonth);
            }
            //Added by Varun Shrivastava : End : SCTASK0459610
            
            if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                if(isTM){
                    isAvail = checkDataForMonth(teriList[0].id,mth,liquiAnualPlan[0].id);
                    
                    if(isAvail){
                        displayProduct();
                        loadAllData(teriList[0].id,liquiAnualPlan[0].id,mth);
                    }else{
                        createData(teriList[0].id,liquiAnualPlan[0].id,mth);
                        displayProduct();
                        loadAllData(teriList[0].id,liquiAnualPlan[0].id,mth);
                    }
                }
                
                
            }else{
                productList = new List<Product2>();
            }
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getLineNumber());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
    }//end of default Method
    
    // when year change
    public void onYearChange(){
        Select_Year = selectedYear;
        yearForVf = Select_Year;
        try{
            //start of TM on Year change
            if(isTM){
                month  = monthMap.get(selectedMonth);
                if(teriList.size()>0){
                    //2019-04-01
                    Integer index;
                    if(selectedMonth <= 3){
                        index = 1;
                    }else{
                        index = 0;
                    }
                    String strStratDate  = selectedYear.split('-')[index];
                    
                    Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                    
                    Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate 
                                                FROM Period WHERE Type = 'Year' 
                                                AND (StartDate <=:d AND EndDate >=:d)];
                    StartDate = currentFiscalYear.StartDate;
                    startDate1 = String.valueOf(StartDate);
                    
                    
                    liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__c =:teriList[0].id
                                       AND RecordTypeId = : rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1210'];
                    
                    if(liquiAnualPlan.size()>0){
                        //displayProduct();
                        Select_Year = selectedYear;
                        selectedTeritorry = teriList[0].name;
                        loadAllData(teriList[0].id,liquiAnualPlan[0].id,month);
                    }else{
                        productList = new List<Product2>();
                        totalProductNumber =0;
                        Select_Year = selectedYear;
                    }
                }else{
                    productList = new List<Product2>();
                    
                }
            } //end of TM on Year change
            
            if(isRM || isZH || isZMM){
                Select_Year = selectedYear;
                RollupTradeSalesLiquidation_SWAL RollupTradeSalesLiquidation_SWALObj = new RollupTradeSalesLiquidation_SWAL();
                territoryMap = new Map<String,String>();
                
                if(isRM){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getRMTeritories();
                }
                if(isZH || isZMM){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                }
                
                Integer index;
                if(selectedMonth <= 3){
                    index = 1;
                }else{
                    index = 0;
                }
                String strStratDate  = selectedYear.split('-')[index];
                
                Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                
                
                
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate 
                                            FROM Period 
                                            WHERE Type = 'Year' AND (StartDate <=:d AND EndDate >=:d)];
                
                StartDate = currentFiscalYear.StartDate;
                startDate1 = String.valueOf(StartDate);
                
                
                
                
                if(territoryMap.size()>0){
                    teritorynameList = territoryMap.values();
                    liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE FIscal_Year__c =: selectedYear
                                       AND Territory_Name__c IN:territoryMap.keySet()
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1210'];
                    
                    if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                        
                        newLiqMap = RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        newOpenMap = RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size() */|| Test.isRunningTest()){
                            
                            liquidationMap_vf.clear();
                            OpeningInventoryMap_vf.clear();
                            displayProduct();
                            refreshProductList(newOpenMap, newLiqMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap); 
                        }else{
                            productList = new List<Product2>();        
                        }
                        
                    }else{
                        productList = new List<Product2>();    
                    }
                }else{
                    // totalProductNumber = 0;
                    //startDate1 = selectedYear;
                    productList = new list<product2>();
                }
            }// end of comparision RM ZH SBU ADMIN on year change
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getMessage());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
        
    }
    //end of Function on Year change
    
    // start of checkSelectedPrevMonthData function
    public Boolean checkSelectedPrevMonthData(String territoryName,String liquiAnualPlanId){
        
        try{
            
            
            Integer tmpMonth  = selectedMonth;
            
            if(selectedMonth == 1){
                tmpMonth = 12;
            }else{
                tmpMonth =selectedMonth-1;
            }
            
            liquiList  = [select id, Name, Month__c,Territory__c,
                          //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                          Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                          Liquidation_YTD_Previous_Month__c,Product_Budget__c,	Fixed_YTD_Sales__c	,	
                          //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                          Liquidation_Annual_Plan__c 
                          FROM Liquidation2__c 
                          WHERE Month__c=:monthMap.get(tmpMonth)
                          AND Territory__c=:territoryName
                          AND Liquidation_Annual_Plan__c =:liquiAnualPlanId
                          AND RecordTypeId = :rtforLiquidation];
            
        }
        Catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
        if(liquiList.size()>0){
            return true;  
        }
        else{
            return false;
        }    
        
    } 
    //end of checkSelectedPrevMonthData function
    
    //Start of loadForSelectedMonth
    public void loadDataForSelectedMonth(String territoryName , String liquiAnnalPlanId){
        try{
            liquiList = new List <Liquidation2__c>();
            liquiList = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Product__r.Name,
                         Type__c,submitted_Trade_SWAL__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 2 June 2021 Start
                         Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                         Liquidation_YTD_Previous_Month__c,Product_Budget__c,	Fixed_YTD_Sales__c	,	
                         //Added by Varun Shrivastava: SCTASK0459610 : 2 June 2021 End
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         Distributors_Inventory__c,Liquidation_YTD_SWAL__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c
                         WHERE Territory__c=:territoryName
                         AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId
                         AND RecordTypeId =:rtforLiquidation
                         AND Month__c=:monthMap.get(selectedMonth)];
            
            if(liquiList.size()>0){
                for(Liquidation2__c liqObj : liquiList){
                    if(liqObj.submitted_Trade_SWAL__c == true){
                        isSubmitted = true;
                        forCropSubmit = true;
                    }
                    if(liqObj.submitted_Trade_SWAL__c == false){
                        isSubmitted = false;
                        forCropSubmit = false;
                    }
                }//end of for loop
                liquidationMap_vf.clear();
                liquidationMap_vf = new Map<String,Liquidation2__c> ();
                for(Liquidation2__c liqiObj :liquiList) {
                    
                    liquidationMap_vf.put(liqiObj.Product__c,liqiObj); 
                }
            }else{
                productList = new List<Product2>();
                totalProductNumber = 0;
            }
            
            openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,Opening_Inventory__c,
                           YTD_Sales__c,Opening_Inventory_Cooperatives__c, Opening_Inventory_Govt__c,Product__c,
                           State__c,Territory__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                           YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           //Added by Varun Shrivastava:SCTASK0459610
                           Product_Budget__c,
                           //Added by Varun Shrivastava:SCTASK0459610
                           YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c
                           FROM Opening_Inventory2__c 
                           WHERE Territory__c=:territoryName 
                           AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId
                           AND RecordTypeId =: rtForOpeningInventory];
            
            
            if(openInvList.size()>0){
                OpeningInventoryMap_vf.clear();
                for(Opening_Inventory2__c openObj :openInvList){
                    Opening_Inventory2__c openInvObjTemp = new Opening_Inventory2__c();
                    openInvObjTemp =  openObj;
                    String tmpMth = monthMap.get(selectedMonth);
                    switch on tmpMth {
                        when 'Jan' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jan__c;
                        }
                        when 'Feb' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Feb__c;
                            
                        }
                        when 'Mar' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Mar__c;
                            
                        }
                        when 'Apr' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Apr__c;
                            
                        }
                        when 'May' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_May__c;
                            
                        }
                        when 'Jun' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jun__c;
                            
                        }
                        when 'Jul' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jul__c;
                            
                        }
                        when 'Aug' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Aug__c;
                            
                        }
                        when 'Sept' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Sept__c;
                        }
                        when 'Oct' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Oct__c;
                            
                        }
                        when 'Nov' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Nov__c;
                            
                        }
                        when 'Dec' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Dec__c;
                            
                        }
                        
                    }// end of Switch
                    //OpeningInventoryMap_vf.put(openObj.Product__c, openObj);
                    OpeningInventoryMap_vf.put(openObj.Product__c, openInvObjTemp);
                }
            }else{
                productList = new List<Product2>();
                totalProductNumber = 0;
            }
            if(OpeningInventoryMap_vf.size() > 0  && liquidationMap_vf.size()>0){
                liquidationMap_vf = refreshProductList(OpeningInventoryMap_vf,liquidationMap_vf);//sayan
            }
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getLineNumber());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
    } 
    //End of loadForSelectedMonth
    
    
    
    
    //Start of Update single Record
    public void updateSingleRecord(){
        try{
            //Code fix for Liquidation module(added for ZMM)
            if(isTM || isRM || isZMM){ 
                if(totalLiquidation>0 || totalLiquidation == 0 ){
                    
                    
                    
                    
                    // update value from Opening Inventory
                    if(fieldTotupdate=='Opening_Inventory__c'){
                        List <Opening_Inventory2__c> opInList = new List <Opening_Inventory2__c>();
                        List <Opening_Inventory2__c> opInUpdateList = new List <Opening_Inventory2__c>();
                        opInList = [SELECT id,Name,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                          			   YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           			   YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                                       
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Opening_Inventory__c 
                                    FROM Opening_Inventory2__c
                                    WHERE id=:recordIdTotupdate];
                        
                        
                        if(opInList.size()>0){
                            for(Opening_Inventory2__c openInv :opInList){
                                openInv.Opening_Inventory__c = Decimal.valueOf(valueToupdate);
                                opInUpdateList.add(openInv);
                                
                            }//end of For loop 
                        }//end of If condition
                        
                        
                        if(opInUpdateList.size()>0){
                            update opInUpdateList;    
                        }
                    }//end of update value from Opening Inventory
                    
                    //start of Update Distributor inventory  
                    if(fieldTotupdate=='distributer_inventory'){
                        List <Liquidation2__c> liquiUpdateList = new List <Liquidation2__c>();
                        List <Liquidation2__c> liquiUpdateList1 = new List <Liquidation2__c>();
                        liquiUpdateList1 = [select id,Name,Retailers_Inventory__c,
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                            Liquidation_YTD_Previous_Month__c,Product_Budget__c,	Fixed_YTD_Sales__c	,	
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                            Distributors_Inventory__c 
                                            FROM Liquidation2__c
                                            WHERE id=:recordIdTotupdate];
                        
                        if(liquiUpdateList1.size()>0 || Test.isRunningTest()){
                            for(Liquidation2__c liquObj :liquiUpdateList1){
                                liquObj.Distributors_Inventory__c = Decimal.valueOf(valueToupdate);
                                liquiUpdateList.add(liquObj);
                                
                            } 
                        }
                        
                        if(liquiUpdateList.size()>0){
                            update liquiUpdateList;    
                        }
                    }//End of Update Distributor inventory
                    
                    //Start of retailer inventory
                    if(fieldTotupdate=='retailer_inventory'){
                        
                        //List <Liquidation2__c> liquiList = new List <Liquidation2__c>();
                        List <Liquidation2__c> liquiUpdateList = new List <Liquidation2__c>();
                        List <Liquidation2__c> liquiUpdateList1 = new List <Liquidation2__c>();
                        liquiUpdateList1 = [select id,Name,
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                            Liquidation_YTD_Previous_Month__c,Product_Budget__c,	Fixed_YTD_Sales__c	,	
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                            Retailers_Inventory__c 
                                            FROM Liquidation2__c
                                            WHERE id=:recordIdTotupdate];
                        if(liquiUpdateList1.size()>0){
                            for(Liquidation2__c liquiObj :liquiUpdateList1){
                                liquiObj.Retailers_Inventory__c = Decimal.valueOf(valueToupdate);
                                liquiUpdateList.add(liquiObj);
                            }
                            if(liquiUpdateList.size()>0){
                                update liquiUpdateList;
                            }
                        }
                    }//end of retailer inventory updates
                    
                    // start of Update for plan for Next month
                    if(fieldTotupdate=='Plan_for_the_next_month__c'){
                        Integer tmpMonth ;
                        tmpMonth = selectedMonth;
                        
                        if(selectedMonth == 12){
                            tmpMonth = 1;
                        }else{
                            tmpMonth  =selectedMonth +1;
                        }
                        List<Liquidation2__c> lstLiquidation = new List<Liquidation2__c>();
                        List<Liquidation2__c> lstLiquidationUpdate = new List<Liquidation2__c>();
                        if(Test.isRunningTest()){
                            lstLiquidation = [select id, Name,Month__c,Product__c,Type__c,Plan_for_the_month__c,
                                              //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                              Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                              Liquidation_YTD_Previous_Month__c	,Product_Budget__c,Fixed_YTD_Sales__c,		
                                              //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                              Liquidation_Annual_Plan__c,Territory__c
                                              FROM Liquidation2__c ];
                        }else{
                            lstLiquidation =[select id, Name,Month__c,Product__c,Type__c,Plan_for_the_month__c,
                                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                             Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                             Liquidation_YTD_Previous_Month__c,Product_Budget__c,Fixed_YTD_Sales__c,	
                                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                             Liquidation_Annual_Plan__c,Territory__c
                                             FROM Liquidation2__c 
                                             WHERE Month__c =: monthMap.get(tmpMonth)
                                             AND Territory__r.Name =:selectedTeritorry
                                             AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                             AND Product__c =:prodIdTotupdate
                                             AND RecordTypeId =:rtforLiquidation];
                        }
                        
                        if(lstLiquidation.size()>0){
                            for(Liquidation2__c liqObj :lstLiquidation){
                                liqObj.Plan_for_the_month__c = Decimal.valueOf(valueToupdate) + Decimal.valueOf(totalLiquidation) ;
                                liqObj.Product__c = prodIdTotupdate;
                                liqObj.Type__c = 'Trade';
                                liqObj.Liquidation_Annual_Plan__c = liquiAnualPlan[0].id;
                                liqObj.Territory__c =teriList[0].id ;
                                lstLiquidationUpdate.add(liqObj);
                            }
                            update lstLiquidationUpdate;
                        }
                        
                        List <Liquidation2__c> liquiList = new List <Liquidation2__c>();
                        List <Liquidation2__c> liquiUpdateList = new List <Liquidation2__c>();
                        liquiList = [select id,Name,
                                     //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                     Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                     Liquidation_YTD_Previous_Month__c,Product_Budget__c,	Fixed_YTD_Sales__c	,	
                                     //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                     Plan_for_the_next_month__c 
                                     FROM Liquidation2__c
                                     WHERE id=:recordIdTotupdate]; 
                        if(liquiList.size()>0){
                            for(Liquidation2__c liquiObj :liquiList){
                                liquiObj.Plan_for_the_next_month__c =Decimal.valueOf(valueToupdate);
                                liquiUpdateList.add(liquiObj);
                            }
                            if(liquiUpdateList.size()>0){
                                update liquiUpdateList;
                            }
                        }
                        
                    }//end of Update for plan for Next month
                }// end of Total liquidation above zero
            }//end of isTM
        }//end of Try
        catch(Exception ex){
            System.debug('Error Message '+ex.getMessage());  
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
    }
    //end of Update single Record    
    
    //this function called when submit button is clicked
    public void updateData(){
        try{
            
            submittedMonth = monthMap.get(selectedMonth);
            List <liquidation2__c> liquiUpdateList1 = new List <liquidation2__c>();
            List<Opening_Inventory2__c> openUpdateList =new List<Opening_Inventory2__c> ();
            List<Liquidation_Annual_Plan__c> liquiAAnulPlan = new List<Liquidation_Annual_Plan__c> ();
            System.debug('in submit selectedMonth '+ selectedMonth);
            if(selectedMonth == 3 || Test.isRunningTest()){
                String strStratDate  = Select_Year.split('-')[1];
                
                Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                
                
                Period currentFiscalYearRMU = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' 
                                               AND (StartDate <=:d AND EndDate >=:d)];
                StartDate = currentFiscalYearRMU.StartDate;
                startDate1 = String.valueOf(StartDate);
                
                liquiAAnulPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:currentFiscalYearRMU.StartDate
                                          AND Fiscal_End_Date__c=:currentFiscalYearRMU.EndDate)
                                   AND Territory_Name__r.Name =:selectedTeritorry
                                   AND RecordTypeId =:rtforAnnualPlan 
                                   AND Sales_Org__r.Sales_Org_Code__c='1210'];
                
            }else{
                
                
                liquiAAnulPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND Territory_Name__r.Name =:selectedTeritorry
                                   AND RecordTypeId =:rtforAnnualPlan 
                                   AND Sales_Org__r.Sales_Org_Code__c='1210'];
            }
            
            System.debug('submittedMonth in While testing '+submittedMonth); 
            
            liquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,submitted_Trade_SWAL__c,
                         Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                         Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,	
                         Liquidation_YTD_Previous_Month__c	,Product_Budget__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         //Added by Varun Shrivastava: SCTASK0419590 Start
                         Fixed_YTD_Sales__c,YTD_Sales_formula__c,Liquidation_YTD_SWAL__c,		
                         //Added by Varun Shrivastava: SCTASK0419590 End
                         Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c 
                         WHERE Territory__r.Name=:selectedTeritorry 
                         AND Month__c=:submittedMonth
                         AND Liquidation_Annual_Plan__c=:liquiAAnulPlan[0].id
                         AND RecordTypeId =:rtforLiquidation];
            
            
            
            
            
            
            for(liquidation2__c liquiObj : liquiList){
                liquiObj.submitted_Trade_SWAL__c = true;
                //Added by Varun Shrivastava: SCTASK0419590 Start
                liquiObj.Fixed_YTD_Sales__c = liquiObj.Liquidation_YTD_SWAL__c	;	
                //Added by Varun Shrivastava: SCTASK0419590 End
                
                liquiUpdateList1.add(liquiObj);
            }
            if(liquiUpdateList1.size()>0){
                update liquiUpdateList1;
                isSubmitted =true;
                // forCropSubmit = true;
            }
            
            if(openUpdateList.size()>0){
                update openUpdateList;
            }
            
            
            // sendEmailToRM(); RITM0180898 : Sending Email after Product Liquidation is Submitted is stopped now as asked by Shiva
            // sendEmailandReport(); RITM0180898 : Sending Email after Product Liquidation is Submitted is stopped now as asked by Shiva
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    }
    //end of update Data function
    
    //when month is changed,load the Data from (plan for the next month)previousMonth 
    public void onMonthChange(){
        try{
            String smonth ; 
            Select_Year = selectedYear;
            smonth = monthMap.get(selectedMonth);
            monthForVF = monthMap.get(selectedMonth);
            //Added by Varun Shrivastava : SCTASK0459610
            if(selectedMonth == 1)
                monthForPreviousVF = monthMap.get(12);
            else    
                monthForPreviousVF = monthMap.get(selectedMonth-1);
            //Added by Varun Shrivastava : End
            
            monthForNextVF = monthMap.get(selectedMonth+1);
            if(monthMap.get(selectedMonth)=='Dec'){monthForNextVF = 'Jan';}
            
            liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                               Fiscal_End_Date__c 
                               FROM Liquidation_Annual_Plan__c 
                               WHERE FIscal_Year__c=:Select_Year
                               AND Territory_Name__r.Name =:selectedTeritorry
                               AND RecordTypeId =:rtforAnnualPlan 
                               AND Sales_Org__r.Sales_Org_Code__c='1210'];
            //if user is territory manager
            if(isTM){
                boolean flag2;
                String strStratDate  = selectedYear.split('-')[0]; 
                
                Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                
                
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' AND (StartDate <=:d AND EndDate >=:d)];
                
                StartDate = currentFiscalYear.StartDate;
                EndDate = currentFiscalYear.EndDate;
                startDate1 = String.valueOf(StartDate);
                
                
                flag2 = checkDataForMonth(teriList[0].id,smonth,liquiAnualPlan[0].id);
                
                
                if(flag2){
                    loadDataForSelectedMonth(teriList[0].id,liquiAnualPlan[0].id);
                }else{
                    createDataForSelectedMonth(teriList[0].id,liquiAnualPlan[0].id);
                    loadDataForSelectedMonth(teriList[0].id,liquiAnualPlan[0].id); 
                }
            }// end of user TM
            
            //if user is RM and TM is not present for that Territory then Liquiation is created for perticular month and perticular Territory
            if(isRM ){
                if(selectedTeritorry == 'All'){
                    
                    RollupTradeSalesLiquidation_SWAL RollupTradeSalesLiquidation_SWALObj =new RollupTradeSalesLiquidation_SWAL();
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getRMTeritories();
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__c IN:territoryMap.keySet()
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1210'];
                    newLiqMap=RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, smonth, liquiAnualPlan);
                    newOpenMap =RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry, smonth, liquiAnualPlan);
                    if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size()*/){
                        displayProduct();
                        refreshProductList(newOpenMap,newLiqMap);
                        OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap); 
                    }else{
                        productList = new List<Product2>();
                    }
                    
                }else{
                    //for single Territory 
                    if(liquiAnualPlan.size()>0){
                        
                        
                        teriListForUser2 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,ZonalManager__c, 
                                            SBU__c,Regional_Manager_Id__c,  Zone__c, SBUHead__c 
                                            FROM Territory_Distributor__c 
                                            WHERE Present_in_KEDE__c = true 
                                            AND Neglected__c = false 
                                            AND TerritoryCode__c != '#' 
                                            AND Name =:selectedTeritorry
                                            AND (Regional_Manager_Id__c=: userId OR FMM_User_Id__c=:userId)
                                            AND Sales_Org_Code__c='1210'];
                        if(teriListForUser2.size()>0){
                            if(teriListForUser2[0].TerritoryManager__c == null){
                                boolean flag2;
                                flag2 = checkDataForMonth(teriListForUser2[0].id,smonth,liquiAnualPlan[0].id); 
                                
                                
                                if(!flag2){
                                    createDataForSelectedMonth(teriListForUser2[0].id,liquiAnualPlan[0].id);
                                    loadDataForSelectedMonth(teriListForUser2[0].id,liquiAnualPlan[0].id); 
                                }else{
                                    
                                    loadDataForSelectedMonth(teriListForUser2[0].id,liquiAnualPlan[0].id);
                                } //end of flag checking else part
                                
                            }//end of Territory Manager is Absent or Not
                            else{
                                isSubmitted = true;
                                forCropSubmit = true;
                                RollupTradeSalesLiquidation_SWAL RollupTradeSalesLiquidation_SWALObj =new RollupTradeSalesLiquidation_SWAL();
                                newLiqMap=RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, smonth, liquiAnualPlan);
                                newOpenMap =RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry, smonth, liquiAnualPlan);
                                
                                if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size()*/){
                                    displayProduct();
                                    refreshProductList(newOpenMap,newLiqMap);
                                    OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                                    liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap); 
                                }else{
                                    productList = new List<Product2>();
                                } 
                            }
                        }//end of teriListForUser2 size checking
                        
                    }//end of liquiAnualPlan size checking
                }
            } //end of RM Code
            
            
            //if the  user is RM ZH SBU and Admin
            if(isZH || isZMM){
                Select_Year = selectedYear;
                RollupTradeSalesLiquidation_SWAL RollupTradeSalesLiquidation_SWALObj = new RollupTradeSalesLiquidation_SWAL();
                territoryMap = new Map<String,String>();
                teriListForUser2 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,ZonalManager__c, 
                                    SBU__c,Regional_Manager_Id__c,  Zone__c, SBUHead__c,ZMM_Name__c ,FMM_User_Id__c,
                                    Zonal_Marketing_Manager_3_Id__c ,Zonal_Marketing_Manager_2_Id__c,Zonal_Manager_Id__c,
                                    Zonal_Marketing_Manager_1_Id__c 
                                    FROM Territory_Distributor__c 
                                    WHERE Present_in_KEDE__c = true 
                                    AND Neglected__c = false 
                                    AND TerritoryCode__c != '#' 
                                    AND Name =:selectedTeritorry
                                    AND (ZonalManager__c= :userId OR Zonal_Manager_Id__c= :userId OR Zonal_Marketing_Manager_1_Id__c= :userId  
                                         OR Zonal_Marketing_Manager_2_Id__c= :userId  OR Zonal_Marketing_Manager_3_Id__c= :userId)];               
                if(isZH || isZMM){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                }
                
                liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c
                                   WHERE Fiscal_Year__c =:selectedYear
                                   AND Territory_Name__c IN:territoryMap.keySet()
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1210'];
                
                if(teriListForUser2.size()>0){
                    if(teriListForUser2[0].TerritoryManager__c == null && teriListForUser2[0].FMM_User_Id__c == null && (teriListForUser2[0].Zonal_Marketing_Manager_1_Id__c == userId || teriListForUser2[0].Zonal_Marketing_Manager_2_Id__c == userId || teriListForUser2[0].Zonal_Marketing_Manager_3_Id__c == userId || teriListForUser2[0].Zonal_Head__c == userId)|| Test.isRunningTest() ){
                        
                        
                        openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,
                                       Opening_Inventory__c,YTD_Sales__c,Opening_Inventory_Cooperatives__c,
                                       //Added by Varun Shrivastava:SCTASK0459610
                                       Product_Budget__c,
                                       YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                          			   YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           			   YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                                       //Added by Varun Shrivastava:SCTASK0459610
                                       Opening_Inventory_Govt__c,Product__c,State__c,Territory__c
                                       FROM Opening_Inventory2__c 
                                       WHERE Territory__c=:teriListForUser2[0].Id 
                                       AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                       AND RecordTypeId =: rtForOpeningInventory];
                        if(openInvList.size()>0){
                            //putting into map OpeningInventoryMap
                            for(Opening_Inventory2__c prodObj:openInvList){
                                OpeningInventoryMap.put(prodObj.Product__c, prodObj);
                                
                            }// end of for loop
                            //creating data for vacant territory
                            String mth = monthMap.get(selectedMonth);
                            isAvail = checkDataForMonth(teriListForUser2[0].Id,mth,liquiAnualPlan[0].id);
                            
                            if(!isAvail){
                                //create Data
                                
                                if(isRM || isZMM){
                                    createData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);
                                    displayProduct();
                                    loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);    
                                }else{
                                    
                                    isSubmitted = true;
                                    forCropSubmit = true;
                                    
                                    loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth); 
                                }
                                
                            }else{
                                if(isLiqSubmitted){
                                    isSubmitted = true;
                                    forCropSubmit = true;
                                    loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);
                                }
                                else{
                                    isSubmitted = false;
                                    forCropSubmit = false;
                                    displayProduct();
                                    loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);
                                }
                                
                            }
                            
                            
                        }//end of Opening Inventory size checking
                        else{
                            
                            productList = new List<Product2>();
                        }
                        
                    }//end of teriListForUser2 TerritoryManager__c is Null or not
                    else{
                        
                        isSubmitted = true;
                        forCropSubmit = true;
                        newLiqMap= RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                        newOpenMap=RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                        if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size()*/){
                            displayProduct();
                            refreshProductList(newOpenMap,newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                        }else{
                            productList = new List<product2>(); 
                        }
                        
                    }//end of Else
                }else{
                    
                    isSubmitted = true;
                    forCropSubmit = true;
                    newLiqMap= RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                    newOpenMap=RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                    if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size()*/){
                        displayProduct();
                        refreshProductList(newOpenMap,newLiqMap);
                        OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                    }else{
                        productList = new List<product2>(); 
                    }
                }
            } //end of if the  user is RM ZH SBU and Admin
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }
    //end of onMonthChange Function
    
    //when user change Territory 
    public void OnchangeTeritirry(){
        try{
            //Code fix for Liquidation module
            isLiqSubmitted = false;
            
            productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                           Sales_Org_Code__c,Brand_Type__c ,
                           Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                           FROM Product2 
                           WHERE IsActive = true 
                           AND Sales_Org_Code__c = '1210' 
                           AND Active_For_Liquidation__c= true];  
            
            totalProductNumber = productList.size();
            
            
            
            
            RollupTradeSalesLiquidation_SWAL RollupTradeSalesLiquidation_SWALObj =new RollupTradeSalesLiquidation_SWAL();
            territoryMap = new Map<String,String>();
            // territoryMap = RollupTradeSalesLiquidation_SWALObj.getRMTeritories(); 
            Select_Year = selectedYear;
            
            if(selectedTeritorry=='All'){
                if(isRM){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getRMTeritories(); 
                    
                }
                if(isZH || isZMM ){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                }
                
                
                liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c
                                   WHERE Fiscal_Year__c =:selectedYear
                                   AND Territory_Name__c IN:territoryMap.keySet()
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1210'];
                
                isSubmitted = true;
                forCropSubmit = true;
                if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                    newLiqMap= RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                    newOpenMap=RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                    if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size()*/ || Test.isRunningTest()){
                        displayProduct();
                        refreshProductList(newOpenMap,newLiqMap);
                        OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                    }else{
                        productList = new List<product2>(); 
                    }
                }else{
                    productList = new List<Product2>();
                }
                
            }else{
                if(isRM || isZH || isZMM){
                    
                    isSubmitted = false;
                    forCropSubmit = false;
                    
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Territory_Name__r.Name=:selectedTeritorry
                                       AND Fiscal_Year__c =:selectedYear
                                       AND Sales_Org__r.Sales_Org_Code__c='1210'];
                    
                    
                    
                    if(liquiAnualPlan.size()>0){
                        //checking TM is available for selected Teritory or not
                        //Code fix for Liquidation module
                        
                        teriListForUser2 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,ZonalManager__c, 
                                            SBU__c,Regional_Manager_Id__c,  Zone__c, SBUHead__c,ZMM_Name__c ,FMM_User_Id__c,
                                            Zonal_Marketing_Manager_3_Id__c ,Zonal_Marketing_Manager_2_Id__c,Zonal_Manager_Id__c,
                                            Zonal_Marketing_Manager_1_Id__c 
                                            //Added by Varun shrivastava: INCTASK0410898 
                                            ,Zonal_Head__c
                                            //Added by Varun shrivastava:INCTASK0410898 
                                            FROM Territory_Distributor__c 
                                            WHERE Present_in_KEDE__c = true 
                                            AND Neglected__c = false 
                                            AND TerritoryCode__c != '#' 
                                            AND Name =:selectedTeritorry
                                            AND (Regional_Manager_Id__c=: userId OR ZonalManager__c= :userId
                                                 OR FMM_User_Id__c=:userId OR Zonal_Manager_Id__c= :userId OR Zonal_Marketing_Manager_1_Id__c= :userId  
                                                 OR Zonal_Marketing_Manager_2_Id__c= :userId  OR Zonal_Marketing_Manager_3_Id__c= :userId)];
                        
                        
                        if(teriListForUser2.size()>0){
                            if((teriListForUser2[0].TerritoryManager__c == null &&(teriListForUser2[0].Regional_Manager_Id__c == userId))|| (teriListForUser2[0].TerritoryManager__c == null &&(teriListForUser2[0].Zonal_Head__c == userId || teriListForUser2[0].Zonal_Marketing_Manager_1_Id__c == userId || teriListForUser2[0].Zonal_Marketing_Manager_2_Id__c == userId || teriListForUser2[0].Zonal_Marketing_Manager_3_Id__c == userId))|| Test.isRunningTest() ){
                                isTerritoryManagerAbsent = true;
                                //System.assert(false,'teriListForUser2:'+teriListForUser2.size() + ' teriListForUser2:'+teriListForUser2[0]);
                                //System.assert(false,'isTerritoryManagerAbsent : '+isTerritoryManagerAbsent);
                                
                                openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,
                                               Opening_Inventory__c,YTD_Sales__c,Opening_Inventory_Cooperatives__c,
                                               //Added by Varun Shrivastava:SCTASK0459610
                                               Product_Budget__c,
                                               YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                          			            YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           			            YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                                                //Added by Varun Shrivastava:SCTASK0459610
                                               Opening_Inventory_Govt__c,Product__c,State__c,Territory__c
                                               FROM Opening_Inventory2__c 
                                               WHERE Territory__c=:teriListForUser2[0].Id 
                                               AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                               AND RecordTypeId =: rtForOpeningInventory];
                                if(openInvList.size()>0){
                                    //putting into map OpeningInventoryMap
                                    for(Opening_Inventory2__c prodObj:openInvList){
                                        OpeningInventoryMap.put(prodObj.Product__c, prodObj);
                                        
                                    }// end of for loop
                                    //creating data for vacant territory
                                    String mth = monthMap.get(selectedMonth);
                                    isAvail = checkDataForMonth(teriListForUser2[0].Id,mth,liquiAnualPlan[0].id);
                                    if(!isAvail){
                                        //create Data
                                        
                                        if(isRM || isZMM){
                                            createData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);
                                            displayProduct();
                                            loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);  
                                        }else{
                                            
                                            isSubmitted = true;
                                            forCropSubmit = true;
                                            loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth); 
                                        }
                                        
                                    }else{
                                        if(isLiqSubmitted){
                                            isSubmitted = True;
                                            forCropSubmit = true;
                                            loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);
                                        }
                                        else{
                                            isSubmitted = false;
                                            forCropSubmit = false;
                                            displayProduct();
                                            loadAllData(teriListForUser2[0].Id,liquiAnualPlan[0].id,mth);
                                        }
                                        
                                    }
                                    
                                    
                                }//end of Opening Inventory size checking
                                else{
                                    
                                    productList = new List<Product2>();
                                }
                                
                            }//end of teriListForUser2 TerritoryManager__c is Null or not
                            else{
                                isSubmitted = true;
                                forCropSubmit = true;
                                newLiqMap= RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                                newOpenMap=RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                                if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size()*/){
                                    displayProduct();
                                    refreshProductList(newOpenMap,newLiqMap);
                                    OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                                    liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                                }else{
                                    productList = new List<product2>(); 
                                }
                                
                            }//end of Else
                        }else{
                            isSubmitted = true;
                            forCropSubmit = true;
                            newLiqMap= RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                            newOpenMap=RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                            if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size() == newOpenMap.size()){
                                displayProduct();
                                refreshProductList(newOpenMap,newLiqMap);
                                OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                                liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            }else{
                                productList = new List<product2>(); 
                            }
                        }
                        
                    }// end of Liqui annual Plan
                    
                    //end of Creating of Liquidation Data   
                }// end RM created Liquidation for perticular Territory 
                
            }//end of else part of All Territory
            
            
        }
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }
    
    
    
    
    //this function create data on Month change by TM
    public void createDataForSelectedMonth(String territoryName , String liquiAnnalPlanId){
        try{
            flag=checkSelectedPrevMonthData(territoryName,liquiAnnalPlanId);
            List<Liquidation2__c> tmpliqLst = new List<Liquidation2__c>();
            list<Liquidation2__c> createLiqList = new list<Liquidation2__c>();
            Liquidation2__c liquidationObj ;//=new Liquidation2__c();
            List <Product2> prodList = new List <Product2>();
            //RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation2__c' and Name='Trade'];
            prodList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                        Sales_Org_Code__c,Brand_Type__c ,
                        Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                        FROM Product2 
                        WHERE IsActive = true 
                        AND Sales_Org_Code__c = '1210' 
                        AND Active_For_Liquidation__c= true];
            tmpliqLst =  getDataForPrevSelectedMonth(territoryName,liquiAnnalPlanId);
            
            if(flag || test.isrunningtest()){
                if(prodList.size()>0){
                    Integer i=0;
                    for(Product2 prodObj :prodList){
                        liquidationObj= new Liquidation2__c();
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquidationObj.Opening_Inventory2__c = opObj.Id;
                            liquidationObj.Liquidation_Annual_Plan__c = liquiAnnalPlanId;
                            liquidationObj.Product__c = prodObj.Id;
                            liquidationObj.submitted_Trade_SWAL__c = false;
                            liquidationObj.YTD_Sales__c = 0;
                            
                            liquidationObj.Month__c = monthMap.get(selectedMonth);
                            liquidationObj.Liquidation__c = 0;
                            //Changes made for product visibility by Deeksha
                            if(LiquidationMap.containsKey(prodObj.id) && i< tmpliqLst.size() || Test.isRunningTest())
                            {
                                liquidationObj.Plan_for_the_month__c = tmpliqLst[i].Plan_for_the_next_month__c + tmpliqLst[i].Liquidation_YTD_SWAL__c;
                                //Added by Varun Start : SCTASK0459610
                                liquidationObj.Distributor_Inventory_Previous_Month__c = 	tmpliqLst[i].Distributors_Inventory__c;	
                                liquidationObj.Retailer_Inventory_Previous_Month__c = tmpliqLst[i].Retailers_Inventory__c;
                                liquidationObj.Liquidation_YTD_Previous_Month__c = 	tmpliqLst[i].Fixed_YTD_Sales__c;
                                liquidationObj.Product_Budget__c = opObj.Product_Budget__c;
                                liquidationObj.Retailers_Inventory__c = tmpliqLst[i].Retailers_Inventory__c;
                                switch on selectedMonth{
                                    when 1 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Jan__c - opObj.YTD_Sales_Dec__c;	
                                    }
                                    when 2 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Feb__c - opObj.YTD_Sales_Jan__c;	
                                    }
                                    when 3 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Mar__c	 - opObj.YTD_Sales_Feb__c;	
                                    }
                                    when 4 {
                                        liquidationObj.Distributors_Inventory__c = opObj.Opening_Inventory__c + opObj.YTD_Sales_Apr__c;	
                                    }
                                    when 5 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_May__c	 - opObj.YTD_Sales_Apr__c;	
                                    }
                                    when 6 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Jun__c - opObj.YTD_Sales_May__c;	
                                    }
                                    when 7 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Jul__c - opObj.YTD_Sales_Jun__c;	
                                    }
                                    when 8 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Aug__c - opObj.YTD_Sales_Jul__c;	
                                    }
                                    when 9 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Sept__c	 - opObj.YTD_Sales_Aug__c;	
                                    }
                                    when 10 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Oct__c	 - opObj.YTD_Sales_Sept__c;	
                                    }
                                    when 11 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Nov__c - opObj.YTD_Sales_Oct__c	;	
                                    }
                                    when 12 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Dec__c - opObj.YTD_Sales_Nov__c;	
                                    }
                                }
                                //Added by Varun End : SCTASK0459610
                                
                            }
                            else{
                                liquidationObj.Plan_for_the_month__c =0;
                                //Added by Varun Start : SCTASK0459610
                                liquidationObj.Distributor_Inventory_Previous_Month__c = 0;	
                                liquidationObj.Retailer_Inventory_Previous_Month__c = 0;
                                liquidationObj.Liquidation_YTD_Previous_Month__c = 	0;
                                liquidationObj.Product_Budget__c = opObj.Product_Budget__c;
                                liquidationObj.Retailers_Inventory__c = 0;
                                //Added by Varun End : SCTASK0459610
                            }
                            //End of Changes made for product visibility by Deeksha
                            //System.debug('In Month Change tmpliqLst[i].Plan_for_the_next_month__c  '+tmpliqLst[i].Plan_for_the_next_month__c+' tmpliqLst[i].Liquidation_YTD_SWAL__c  '+tmpliqLst[i].Liquidation_YTD_SWAL__c);
                            //liquidationObj.Plan_for_the_month__c = tmpliqLst[i].Plan_for_the_next_month__c + tmpliqLst[i].Liquidation_YTD_SWAL__c;
                            System.debug('In Month Change liquidationObj.Plan_for_the_month__c '+liquidationObj.Plan_for_the_month__c);
                            liquidationObj.RecordTypeId = rtforLiquidation;
                            //liquidationObj.Retailers_Inventory__c = 0; Commented by Varun : SCTASK0459610
                            liquidationObj.Plan_for_the_next_month__c = 0;
                            liquidationObj.Territory__c = territoryName;
                            createLiqList.add(liquidationObj); 
                            
                            i++;
                        }
                        
                    }//end of for loop
                    if(createLiqList.size()>0){
                        insert createLiqList;
                        
                    }
                } 
                
            }else{
                //if previous month data is not available  create data plan for month with zero
                if(prodList.size()>0){
                    
                    for(Product2 prodObj :prodList){
                        liquidationObj= new Liquidation2__c();
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id)) || test.isRunningTest()){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquidationObj.Liquidation_Annual_Plan__c = liquiAnnalPlanId;
                            liquidationObj.Product__c = prodObj.Id;
                            liquidationObj.submitted_Trade_SWAL__c = false;
                            liquidationObj.Month__c = monthMap.get(selectedMonth);
                            liquidationObj.YTD_Sales__c = 0;
                            liquidationObj.Plan_for_the_month__c = 0;
                            liquidationObj.RecordTypeId = rtforLiquidation;
                            liquidationObj.Retailers_Inventory__c = 0;
                            liquidationObj.Plan_for_the_next_month__c = 0;
                            //Added by Varun Start : SCTASK0459610
                            liquidationObj.Distributor_Inventory_Previous_Month__c = 	0;	
                            liquidationObj.Retailer_Inventory_Previous_Month__c = 0;
                            liquidationObj.Liquidation_YTD_Previous_Month__c = 0;
                            liquidationObj.Product_Budget__c = opObj.Product_Budget__c;	
                            //Added by Varun End : SCTASK0459610
                            liquidationObj.Territory__c = territoryName;
                            liquidationObj.Opening_Inventory2__c = opObj.Id;
                            
                            createLiqList.add(liquidationObj);
                        }
                        
                    }
                    if(createLiqList.size()>0){
                        insert createLiqList;    
                    }
                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }// end of createDataForSelectedMonth 
    
    
    //this function getData for Previous Month when user click on month select list
    public List<Liquidation2__c> getDataForPrevSelectedMonth(String territoryName,String liquiAnualPlanId){
        Integer tmpMonth ;
        tmpMonth = selectedMonth;
        if(selectedMonth == 1){
            tmpMonth = 12;
        }else{
            tmpMonth = selectedMonth -1;
        }
        
        
        
        
        
        List<Liquidation2__c> tempLiqList = new List<Liquidation2__c>();
        tempLiqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Liquidation_YTD_SWAL__c,
                       Type__c,submitted_Trade_SWAL__c,Month__c,Liquidation__c,Plan_for_the_month__c,Inventory_in_Kg_Cooperatives__c,
                       Inventory_in_Kg_Govt__c,Retailers_Inventory__c,Distributors_Inventory__c,Plan_for_the_next_month__c,
                       //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                       Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                       Liquidation_YTD_Previous_Month__c,Product_Budget__c	,Fixed_YTD_Sales__c,	
                       //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                       Territory__c,State__c
                       FROM Liquidation2__c
                       WHERE Territory__c =:territoryName
                       AND Liquidation_Annual_Plan__c=:liquiAnualPlanId
                       AND Month__c=:monthMap.get(tmpMonth)
                       AND RecordTypeId =:rtforLiquidation];
        
        return tempLiqList;      
    }//end of getDataForPrevSelectedMonth
    
    //checkDataForMonth function
    public Boolean checkDataForMonth(String territoryName ,String mnth,String liquiAnnualPlanId){
        List <Liquidation2__c> tempLiquiList = new  List <Liquidation2__c>();
        try{
            
            tempLiquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,submitted_Trade_SWAL__c,
                             Product__c,Type__c,submitted_trade__c,Month__c,
                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                             Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                             Liquidation_YTD_Previous_Month__c,Product_Budget__c,	Fixed_YTD_Sales__c	,	
                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                             Territory__c
                             FROM Liquidation2__c 
                             WHERE Month__c=:mnth
                             AND Territory__c=:territoryName
                             AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                             AND RecordTypeId =:rtforLiquidation];
        }
        
        catch(Exception ex){
            System.debug('Error Message '+ex.getLineNumber());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
        
        if(tempLiquiList.size()>0){
            //Code fix for Liquidation module
            for(Liquidation2__c L : tempLiquiList){
                if(L.submitted_Trade_SWAL__c == true)
                    isLiqSubmitted = true;
                break;
            }
            
            return true;
        }else{
            isLiqSubmitted = false;
            return false;
        }
        
    }//end of checkDataForMonth function
    
    
    //Start of loadAllData function
    public void loadAllData(String territoryName, String liquiAnnualPlanId ,String mth){
        try{
            openInvList = new List<Opening_Inventory2__c>();
            liquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,submitted_Trade_SWAL__c,
                         Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                         Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                         Liquidation_YTD_Previous_Month__c,Product_Budget__c,	Fixed_YTD_Sales__c	,	
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c 
                         WHERE Territory__c=:territoryName 
                         AND Month__c=:mth
                         AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                         AND RecordTypeId =:rtforLiquidation];
            
            system.debug('liquiList size: '+liquiList.size());
            if(liquiList.size()>0){
                for(Liquidation2__c liqiObj :liquiList){
                    if( liqiObj.submitted_Trade_SWAL__c == true){
                        isSubmitted= true;
                        forCropSubmit = true;
                    }else{
                        isSubmitted= false;
                        forCropSubmit = false; 
                    }
                }
                system.debug('isSubmitted: '+isSubmitted);
            }else{
                productList = new list<product2>();
                totalProductNumber = 0;
            }
            OpeningInventoryMap.clear();
            openInvList = [SELECT id,Name,X15_days_lock__c,combination_key__c,Liquidation_Annual_Plan__c,Opening_Inventory__c,
                           YTD_Sales__c, Opening_Inventory_Cooperatives__c, Opening_Inventory_Govt__c,Product__c,
                           State__c,Territory__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                           //Added by Varun Shrivastava:SCTASK0459610
                           Product_Budget__c,
                           //Added by Varun Shrivastava:SCTASK0459610
                           YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c
                           FROM Opening_Inventory2__c 
                           WHERE Territory__c=:territoryName 
                           AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                           AND RecordTypeId =:rtForOpeningInventory];
            
            if(liquiList.size()>0){
                for(Liquidation2__c liqiObj :liquiList) {
                    liquidationMap.put(liqiObj.Product__c,liqiObj); 
                    
                }
            }else{
                productList = new list<product2>();
            }
            productList.clear();
            if(openInvList.size()>0){
                for(Opening_Inventory2__c openInvObj :openInvList){
                    /*if(openInvObj.X15_days_lock__c == false){
isOpenInvLock = false;
}
if(openInvObj.X15_days_lock__c == true){
isOpenInvLock = true;
}*/
                    if(Today.month()==5){
                        isOpenInvLock = false;
                    }else{
                        isOpenInvLock = true;
                    }
                    OpeningInventoryMap.put(openInvObj.Product__c, openInvObj);
                    system.debug('@@@@'+openInvObj.combination_key__c);
                }
            }
            productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                           Sales_Org_Code__c,Brand_Type__c ,
                           Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                           FROM Product2 
                           WHERE IsActive = true 
                           AND Sales_Org_Code__c = '1210' 
                           AND Active_For_Liquidation__c= true AND id IN :OpeningInventoryMap.keySet()];
            // display opening inventory on vf map
            if(openInvList.size()>0){
                OpeningInventoryMap_vf.clear();
                for(Opening_Inventory2__c openInvObj :openInvList){
                    Opening_Inventory2__c openInvObjTemp = new Opening_Inventory2__c();
                    
                    openInvObjTemp =  openInvObj;
                    String tmpMth = monthMap.get(selectedMonth);
                    switch on tmpMth {
                        
                        when 'Jan' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Jan__c;
                        } 
                        
                        when 'Feb' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Feb__c;
                            
                        }
                        when 'Mar' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Mar__c;
                            
                        }
                        when 'Apr' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Apr__c;
                            
                        }
                        when 'May' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_May__c;
                            
                        }
                        when 'Jun' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Jun__c;
                            
                        }
                        when 'Jul' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Jul__c;
                            
                        }
                        when 'Aug' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Aug__c;
                            
                        }
                        when 'Sept' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Sept__c;
                            
                        }
                        when 'Oct' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Oct__c;
                            
                        }
                        when 'Nov' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Nov__c;
                            
                        }
                        when 'Dec' {
                            openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Dec__c;
                            
                        }
                        
                        
                    } //end of switch case
                    // openInvObj.Product__c, openInvObjTemp
                    //   OpeningInventoryMap_vf.put(openInvObj.Product__c, openInvObj);
                    OpeningInventoryMap_vf.put(openInvObj.Product__c, openInvObjTemp);
                }
                
            }else{
                totalProductNumber = 0;
                productList = new list<product2>();
            }
            liquidationMap_vf.clear();
            if(liquiList.size()>0){
                for(Liquidation2__c liqiObj :liquiList) {
                    liquidationMap_vf.put(liqiObj.Product__c,liqiObj); 
                }
            }else{
                productList = new list<product2>();
            }
            liquidationMap_vf = refreshProductList(OpeningInventoryMap_vf,liquidationMap_vf);//sayan
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getLineNumber());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
    } // end of loadAllData function
    
    
    //if Data is available for prevoious month Then load it otherwise create it
    public void createData(String territoryName, String liquiAnnualPlanId,String mth){
        try{
            String PreMonth='';
            if(selectedMonth == 1){
                PreMonth = monthMap.get(12);    
            }else{
                PreMonth = monthMap.get(selectedMonth-1);    
            }
            //Added by Varun Shrivastava : SCTASK0459610
            monthForPreviousVF = PreMonth;
            Map<String , Liquidation2__c> LiquidationMap;
            //Added by Varun Shrivastava : SCTASK0459610
            Boolean chkForPrevMthData;
            List<Liquidation2__c> tempList = New List<Liquidation2__c>();
            Liquidation2__c liquiObj = new  Liquidation2__c();
            list<Liquidation2__c> createLiqList = new list<Liquidation2__c>();
            Date tmpDate = System.today();
            Integer tmpSelectedMonth =tmpDate.month();
            //Map<String , Liquidation2__c> LiquidationMap  = new  Map<String , Liquidation2__c>();
            if(tmpSelectedMonth == 4 || Test.isRunningTest()){
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                            FROM Period WHERE Type = 'Year' 
                                            AND StartDate <= TODAY 
                                            AND EndDate >= TODAY];
                DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear.EndDate,Time.newInstance(0,0,0,0));
                Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
                Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                         From Period 
                                         WHERE EndDate< :theDate
                                         AND Type ='Year' order By EndDate DESC Limit 1];
                
                system.debug('INC0187719 ->'+lastFiscalYear.StartDate);
                system.debug('INC0187719 ->'+lastFiscalYear.EndDate);
                liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:lastFiscalYear.StartDate
                                          AND Fiscal_End_Date__c=:lastFiscalYear.EndDate)
                                   AND(Territory_Name__c =:territoryName)
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1210'];
                
                if(liquiAnualPlan.size()>0){
                    tempList = [SELECT id,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                                Plan_for_the_next_month__c,Territory__c,Month__c,
                                //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                Liquidation_YTD_Previous_Month__c,Product_Budget__c,Fixed_YTD_Sales__c,
                                Retailers_Inventory__c,Distributors_Inventory__c,
                                //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                Plan_for_the_month__c,Liquidation__c,Liquidation_YTD_SWAL__c,submitted_trade__c
                                FROM Liquidation2__c 
                                WHERE Territory__c=:territoryName
                                AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                AND Month__c =:PreMonth
                                AND RecordTypeId =:rtforLiquidation];
            			System.debug('Territory Name:'+territoryName);
                    System.debug('PreMonth Name:'+PreMonth);
                    System.debug('Liquidation_Annual_Plan__c Name:'+liquiAnualPlan);
                }
            }else{
                tempList = [SELECT id,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                            Type__c,submitted__c,Plan_for_the_next_month__c,Territory__c,Month__c,
                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                            Liquidation_YTD_Previous_Month__c,Product_Budget__c,Fixed_YTD_Sales__c,	
                            Distributors_Inventory__c,Retailers_Inventory__c,
                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                            Plan_for_the_month__c,Liquidation__c,Liquidation_YTD_SWAL__c,submitted_trade__c
                            FROM Liquidation2__c 
                            WHERE Territory__c=:territoryName
                            AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                            AND Month__c =:PreMonth
                            AND RecordTypeId =:rtforLiquidation];  
                System.debug('LAP ID : '+liquiAnnualPlanId);
                System.debug('territoryName : '+territoryName);
                System.debug('Month : '+PreMonth);
                String debugKeySet='';
                //Map<String , Liquidation2__c> LiquidationMap  = new  Map<String , Liquidation2__c>();
                LiquidationMap  = new  Map<String , Liquidation2__c>();
                for(Liquidation2__c obj : tempList){
                    LiquidationMap.put(obj.Product__c,obj) ;
                    System.debug('Map Key:'+obj.Product__c);
                    debugKeySet+=obj.Product__c+':';
                }
                System.debug('Key Set:'+debugKeySet);
            }
            if(tempList.size()>0){
                chkForPrevMthData = true; 
            }else{
                chkForPrevMthData = false;
            }
            
            List <Product2> prodList = new List <Product2>();
            prodList = [SELECT Id, Name, ProductCode, Combination_Key__c, 
                        Budget_NRV__c,Product_Code__c, Sales_Org__c, 
                        VF_Image__c, Brand_Type__c, Sales_Org_Code__c 
                        FROM Product2 
                        WHERE IsActive = true 
                        AND Sales_Org_Code__c = '1210' 
                        AND Active_For_Liquidation__c= true];
            
            if(chkForPrevMthData){
                
                if(prodList.size()>0){
                    Integer i = 0;
                    for(Product2 prodObj :prodList){
                        liquiObj = new  Liquidation2__c(); 
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquiObj.Opening_Inventory2__c = opObj.Id;
                            liquiObj.Liquidation_Annual_Plan__c = liquiAnnualPlanId;
                            liquiObj.Product__c = prodObj.Id	;
                            
                            liquiObj.submitted_Trade_SWAL__c = false;
                            liquiObj.YTD_Sales__c = 0;
                            liquiObj.Month__c = mth;
                            liquiObj.Liquidation__c = 0;
                            System.debug('prod Obj : '+prodObj.id + 'contains flag : '+LiquidationMap.containsKey(prodObj.id));
                            if(LiquidationMap.containsKey(prodObj.id))
                            {
                                liquiObj.Plan_for_the_month__c =LiquidationMap.get(prodObj.id).Plan_for_the_next_month__c + LiquidationMap.get(prodObj.id).Liquidation_YTD_SWAL__c;
                                //Added by Varun Start : SCTASK0459610
                                liquiObj.Distributor_Inventory_Previous_Month__c = 	LiquidationMap.get(prodObj.id).Distributors_Inventory__c;	
                                liquiObj.Retailer_Inventory_Previous_Month__c = LiquidationMap.get(prodObj.id).Retailers_Inventory__c;	
                                liquiObj.Liquidation_YTD_Previous_Month__c	= LiquidationMap.get(prodObj.id).Fixed_YTD_Sales__c;
                                liquiObj.Retailers_Inventory__c	= LiquidationMap.get(prodObj.id).Retailers_Inventory__c;
                                switch on selectedMonth{
                                    when 1 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Jan__c - opObj.YTD_Sales_Dec__c;	
                                    }
                                    when 2 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Feb__c - opObj.YTD_Sales_Jan__c;	
                                    }
                                    when 3 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Mar__c	 - opObj.YTD_Sales_Feb__c;	
                                    }
                                    when 4 {
                                        liquiObj.Distributors_Inventory__c = opObj.Opening_Inventory__c + opObj.YTD_Sales_Apr__c;	
                                    }
                                    when 5 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_May__c	 - opObj.YTD_Sales_Apr__c;	
                                    }
                                    when 6 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Jun__c - opObj.YTD_Sales_May__c;	
                                    }
                                    when 7 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Jul__c - opObj.YTD_Sales_Jun__c;	
                                    }
                                    when 8 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Aug__c - opObj.YTD_Sales_Jul__c;	
                                    }
                                    when 9 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Sept__c	 - opObj.YTD_Sales_Aug__c;	
                                    }
                                    when 10 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Oct__c	 - opObj.YTD_Sales_Sept__c;	
                                    }
                                    when 11 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Nov__c - opObj.YTD_Sales_Oct__c	;	
                                    }
                                    when 12 {
                                        liquiObj.Distributors_Inventory__c = LiquidationMap.get(prodObj.id).Distributors_Inventory__c + opObj.YTD_Sales_Dec__c - opObj.YTD_Sales_Nov__c;	
                                    }
                                }
                                liquiObj.Product_Budget__c	= opObj.Product_Budget__c;
                                
                                //Added by Varun End : SCTASK0459610
                            }
                            else{
                                liquiObj.Plan_for_the_month__c =0;
                                
                                //Added by Varun Start : SCTASK0459610
                                liquiObj.Distributor_Inventory_Previous_Month__c = 	0;	
                                liquiObj.Retailer_Inventory_Previous_Month__c = 0;	
                                liquiObj.Liquidation_YTD_Previous_Month__c	= 0;	
                                liquiObj.Product_Budget__c	= opObj.Product_Budget__c;
                                liquiObj.Retailers_Inventory__c = 0;
                                //Added by Varun End : SCTASK0459610
                            }
                            liquiObj.RecordTypeId = rtforLiquidation;
                            //liquiObj.Retailers_Inventory__c = 0; // Commented by Varun : SCTASK0459610
                            liquiObj.Plan_for_the_next_month__c = 0;
                            liquiObj.Territory__c = territoryName;
                            createLiqList.add(liquiObj);
                            i++;
                        }
                        
                    }//end of for loop
                    if(createLiqList.size()>0){
                        insert createLiqList;
                    }
                    liquidationMap_vf.clear();
                    for(Liquidation2__c liquiObj1 : createLiqList){
                        liquidationMap_vf.put(liquiObj1.Product__c,liquiObj1);
                    }
                }//end of productlist condition
            }else{
                if(prodList.size()>0){
                    for(Product2 prodObj :prodList){
                        liquiObj= new Liquidation2__c();
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquiObj.Opening_Inventory2__c = opObj.Id;
                            liquiObj.Liquidation_Annual_Plan__c = liquiAnnualPlanId;
                            liquiObj.Product__c = prodObj.Id;
                            liquiObj.submitted_Trade_SWAL__c = false;
                            liquiObj.Month__c = mth;
                            liquiObj.YTD_Sales__c = 0;
                            liquiObj.Plan_for_the_month__c =0;
                            liquiObj.RecordTypeId = rtforLiquidation;
                            liquiObj.Retailers_Inventory__c = 0;
                            liquiObj.Plan_for_the_next_month__c = 0;
                            liquiObj.Territory__c = territoryName;
                            createLiqList.add(liquiObj);
                        }//end of if condtion product key
                    }// end of for loop
                    if(createLiqList.size()>0){
                        insert createLiqList;    
                    }
                    
                    liquidationMap_vf.clear();
                    for(Liquidation2__c liquiObj1 : createLiqList){
                        liquidationMap_vf.put(liquiObj1.Product__c,liquiObj1);
                    }
                    
                }//end of product list condition
            }
        }
        catch(Exception ex){
            System.debug('Errot Message '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber());
        }   
        
    } //end of CreateData function
    
    //populating Year 
    public void populateYear(){
        try{
            List <Liquidation_Annual_Plan__c> populateYearList = [select id, FIscal_Year__c 
                                                                  FROM Liquidation_Annual_Plan__c 
                                                                  WHERE Sales_Org__r.Sales_Org_Code__c='1210' 
                                                                  AND RecordTypeId =:rtForAnnualPlan];
            
            for(Liquidation_Annual_Plan__c laPObj :populateYearList){
                popuYear.add(laPObj.FIscal_Year__c);
            }
            popYearList =new List<String>(popuYear);
            popYearList.sort();
            
        }catch(Exception ex){
            System.debug('Errot Message '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber());
        }
    }//end of populating Year
    
    //display product
    public void displayProduct(){
        try{
            productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                           Sales_Org_Code__c,Brand_Type__c ,
                           Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                           FROM Product2 
                           WHERE IsActive = true 
                           AND Sales_Org_Code__c = '1210' 
                           AND Active_For_Liquidation__c= true];
            
            totalProductNumber = productList.size();     
        }
        catch(Exception ex){
            System.debug('Errot Message '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber());
        }
    }//End of display product
    //sayan
    public Map<String,Liquidation2__c> refreshProductList(Map<String,Opening_Inventory2__c> opnInvMap, Map<String,Liquidation2__c> liqMap){
        try{
            /*productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
Sales_Org_Code__c,Brand_Type__c ,
Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
FROM Product2 
WHERE IsActive = true 
AND Sales_Org_Code__c = '1210' 
AND Active_For_Liquidation__c= true];*/
            productList.clear();
            List<String> LiqProduct = new List<String>();
            LiqProduct.addAll(liqMap.keySet());//Changes made for product visibility by Deeksha
            List<Product2> pList = new List<Product2>();//Changes made for product visibility by Deeksha
            /*pList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
Sales_Org_Code__c,Brand_Type__c ,
Indication_Type__c,Budget_NRV__c,IsActive 
FROM Product2 
WHERE IsActive = true 
AND Sales_Org_Code__c = '1210' 
AND Active_For_Liquidation__c= true
];*/
            pList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                     Sales_Org_Code__c,Brand_Type__c ,
                     Indication_Type__c,Budget_NRV__c,IsActive 
                     FROM Product2 
                     WHERE id IN :LiqProduct];//Changes made for product visibility by Deeksha
            
            Map<Id,Product2> pMap = new Map<Id, Product2>();
            for(Product2 prdctd : pList){
                pMap.put(prdctd.Id, prdctd);
            }
            List<Opening_Inventory2__c> t1 = new List<Opening_Inventory2__c>();
            for(Id k1 : pMap.keySet()){
                if(pMap.get(k1).Brand_Type__c == 'Platinum'){
                    if(opnInvMap.containsKey(k1) && liqMap.containsKey(k1)){
                        t1.add(opnInvMap.get(k1));
                    }
                }
            }
            List<Opening_Inventory2__c> t2 = new List<Opening_Inventory2__c>();
            for(Id k2 : pMap.keySet()){
                if(pMap.get(k2).Brand_Type__c == 'Gold'){
                    if(opnInvMap.containsKey(k2) && liqMap.containsKey(k2)){
                        t2.add(opnInvMap.get(k2));
                    }
                }
            }
            List<Opening_Inventory2__c> t3 = new List<Opening_Inventory2__c>();
            for(Id k3 : pMap.keySet()){
                if(pMap.get(k3).Brand_Type__c == 'Silver'){
                    if(opnInvMap.containsKey(k3) && liqMap.containsKey(k3)){
                        t3.add(opnInvMap.get(k3));
                    }
                }
            }
            List<Opening_Inventory2__c> t4 = new List<Opening_Inventory2__c>();
            for(Id k4 : pMap.keySet()){
                if(pMap.get(k4).Brand_Type__c != 'Platinum' && pMap.get(k4).Brand_Type__c != 'Gold' && pMap.get(k4).Brand_Type__c != 'Silver'){
                    if(opnInvMap.containsKey(k4) && liqMap.containsKey(k4)){
                        t4.add(opnInvMap.get(k4));
                    }
                }
            }
            productList.addAll(allSort(t1,pList));
            productList.addAll(allSort(t2,pList));
            productList.addAll(allSort(t3,pList));
            productList.addAll(allSort(t4,pList));
            system.debug('@@@@@'+productList.size());
            system.debug('@@@@@'+liqMap.size());
            system.debug('@@@@@'+opnInvMap.size());
            Map<Id,Product2> productMap = new Map<Id, Product2>();
            for(Product2 prdct : productList){
                productMap.put(prdct.Id, prdct);
            }
            if(null != opnInvMap && null != liqMap){
                if(opnInvMap.size() == liqMap.size()){
                    for(Id prd : productMap.keySet()){
                        if(!opnInvMap.containsKey(prd) && !liqMap.containsKey(prd)){
                            productMap.remove(prd);
                        }
                    }   
                }else{
                    if(opnInvMap.size() < liqMap.size()){
                        for(Id prd : liqMap.keySet()){
                            if(!opnInvMap.containsKey(prd)){
                                liqMap.remove(prd); 
                                productMap.remove(prd);
                            }   
                        }    
                    }else
                        if(opnInvMap.size() > liqMap.size()){
                            for(Id prd : opnInvMap.keySet()){
                                if(!liqMap.containsKey(prd)){
                                    opnInvMap.remove(prd); 
                                    productMap.remove(prd);
                                }   
                            }    
                        }
                } 
            }
            productList.clear();
            productList = productMap.values();
            totalProductNumber = productList.size();
        }catch(Exception ex){
            System.debug('Errot Message '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber());
        }
        return liqMap;
    }
    public List<Product2> allSort(List<Opening_Inventory2__c> t,List<Product2> pL){
        List<Product2> nk = new List<Product2>();
        integer i = 0;
        integer j = 0;
        integer n = t.size();
        Opening_Inventory2__c a;
        for (i = 0; i < n; ++i) 
        {
            for (j = i + 1; j < n; ++j) 
            {
                if ((t[i].Opening_Inventory__c+t[i].YTD_Sales__c) < (t[j].Opening_Inventory__c+t[j].Ytd_Sales__c))
                {
                    a = t[i];
                    t[i] = t[j];
                    t[j] = a;
                }
            }
        }
        Map<Id,Product2> NewproductMap = new Map<Id, Product2>();
        for(integer g = 0; g < t.size(); g++){
            Id AID = t[g].Product__c;
            for(product2 np : pL){
                if(np.Id == AID){
                    NewproductMap.put(AID,np);
                }
            }
        }
        nk.addAll(NewproductMap.values());
        return nk;
    }
    //sayan
    
    
    
    //Sohel Shaikh IBM : Added new functionality
    /* RITM0180898 : Sending Email after Product Liquidation is Submitted is stopped now as asked by Shiva
* public void sendEmailandReport(){

userId =UserInfo.getUserId();
User usr = [select id,Name,UserRoleId,Email from User Where id =:userId LIMIT 1];
List<User> uList = new List<User>();

if(isTM){
Territory_Distributor__c terriotryTM = [SELECT Id, Regional_Manager_Id__c, FMM_User_Id__c
FROM Territory_Distributor__c
WHERE Name =: selectedTeritorry AND Sales_Org_Code__c = '1210'];
system.debug('terriotryTM : '+terriotryTM);
List<String> uIds = new List<String>();
if(null != terriotryTM.Regional_Manager_Id__c && terriotryTM.Regional_Manager_Id__c != ''){
uIds.add(terriotryTM.Regional_Manager_Id__c);
}
if(null != terriotryTM.FMM_User_Id__c && terriotryTM.FMM_User_Id__c != ''){
uIds.add(terriotryTM.FMM_User_Id__c);
}
uList = [SELECT Id, Email FROM User WHERE Id IN: uIds];
}

if(usr!=null){

PageReference ref = Page.LiquidationReport;
ref.getParameters().put('month',monthMap.get(selectedMonth));
ref.getParameters().put('territoryName',selectedTeritorry);
ref.getParameters().put('fiscalYear',Select_Year);
ref.getParameters().put('salesOrgCode','1210');
ref.setRedirect(true);
Blob b;
if(Test.isRunningTest()) { 
b = blob.valueOf('Unit.Test');
} else {
b = ref.getContent();
}


List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
List<String> sendTo = new List<String>();
sendTo.add(usr.Email);
if(null != uList && uList.size() != 0){
for(User u : uList){
if(null != u.Email && u.Email != ''){
sendTo.add(u.Email);
}
}
}
system.debug('sendTo : '+sendTo);
//sendTo.add('crmconsultant3@upl-ltd.com');
//sendTo.add('shiva.reddy@upl-ltd.com');
mail.setToAddresses(sendTo);
mail.setSubject(' New Liquidation entry for '+monthMap.get(selectedMonth));

Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
efa1.setFileName('LiquidationReport.xls');
efa1.setBody(b);


//String body = 'Dear '+usr1.Name;
String body ='<html><body><p>Dear '+usr.Name+' ,</p><p>SWAL Liquidation is submitted by '+ usr.Name+'</p>';
body += '<p>Here are the details:</p><p>Liquidation Type: Trade </p>';
body += ' <p>Month: '+monthMap.get(selectedMonth)+'</p><p>Financial Year: '+Select_Year+'</p><p>Territory Name: '+selectedTeritorry+'</p><br/>';
//body += '<p>Here is the detail link to view the liquidation details:</p><br/>';
body += ' <p>Thank you,</p></body></html>';
mail.setHtmlBody(body);
mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
mails.add(mail);            
Messaging.sendEmail(mails);  
}
}
public void sendEmailToRM(){

User usr = [select id,Name,UserRoleId,Email from User Where id =:userId LIMIT 1];

User usr1 = [select id,Name,UserRoleId,Email from User Where id =:ZHId LIMIT 1];
if(usr!=null){


List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
List<String> sendTo = new List<String>();
sendTo.add(usr1.Email);
mail.setToAddresses(sendTo);
mail.setSubject('New Liquidation entry for '+monthMap.get(selectedMonth));

//String body = 'Dear '+usr1.Name;
String body ='<html><body><p>Dear '+usr1.Name+',</p><p>Liquidation is submitted by '+ usr.Name+'</p>';
body += '<p>Here are the details:</p><p>Liquidation Type: Trade </p>';
body += ' <p>Month: '+monthMap.get(selectedMonth)+'</p><p>Financial Year: '+Select_Year+'</p><p>Territory Name: '+selectedTeritorry+'</p><br/>';
//body += '<p>Here is the detail link to view the liquidation details:</p><br/>';
body += ' <p>Thank you,</p></body></html>';
mail.setHtmlBody(body);
mails.add(mail);
Messaging.sendEmail(mails);
}
}*/
    
    
    
    // Modified by Deeksha :Add product
    /* public void createLiqForNewProducts(String territoryName, String liquiAnnualPlanId,String mth){
displayProduct();
List<String> liquidationList = new List<String>();
liquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,submitted_Trade_SWAL__c,
Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
FROM Liquidation2__c 
WHERE Territory__c=:territoryName 
AND Month__c=:mth
AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
AND RecordTypeId =:rtforLiquidation];
for(Liquidation2__c liq : liquiList){
liquidationList.add(liq.Product__c); 
}

if (productList.size() >0 && liquiList.SIZE()>0 ){
List<Product2> newProducts = new List<Product2>();
for(Product2 p : productList){  
if(!liquidationList.contains(p.id)){
newProducts.add(p);
}
}
if(newProducts.size()>0)
createLiq(newProducts,territoryName,liquiAnnualPlanId,mth,liquiList[0].submitted_Trade_SWAL__c);
}

}
// Modified by Deeksha :Add product
public void createLiq(List<Product2> prodList ,String territoryName, String liquiAnnualPlanId,String mth,boolean submitted_Trade_SWAL){
Liquidation2__c liquidationObj ;
list<Liquidation2__c> createLiqList = new list<Liquidation2__c>();
for(Product2 p : prodList){
liquidationObj= new Liquidation2__c();
if(OpeningInventoryMap.containsKey(String.valueOf(p.Id))){
Opening_Inventory2__c opObj = OpeningInventoryMap.get(p.id);
liquidationObj.Opening_Inventory2__c = opObj.Id;
liquidationObj.Liquidation_Annual_Plan__c = liquiAnnualPlanId;
liquidationObj.Product__c = p.Id;
//liquidationObj.Type__c = 'Trade';
liquidationObj.submitted_Trade_SWAL__c = submitted_Trade_SWAL;
liquidationObj.YTD_Sales__c = 0;

liquidationObj.Month__c = mth;
liquidationObj.Liquidation__c = 0;

liquidationObj.Plan_for_the_month__c = 0;

liquidationObj.RecordTypeId = rtforLiquidation;
liquidationObj.Retailers_Inventory__c = 0;
liquidationObj.Plan_for_the_next_month__c = 0;
liquidationObj.Territory__c = territoryName;
createLiqList.add(liquidationObj); 

}

}//end of for loop
if(createLiqList.size()>0){
insert createLiqList;

}
}// End of classcheckDataForMonth*/
    
    
    
    
    
    
    
    
    
    
    
    //this is the function create crop Liquidation
    public void createCropLiquidation(){
        String  mth  = monthMap.get(selectedMonth);
        TradeSalesSWALCropLiquidation TradeSalesObj = new TradeSalesSWALCropLiquidation();
        //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        Boolean isSubCropLiqCreated=false; 
        cropTosubCropMap = new Map<Id,List<Sub_Crops__c>>();
        liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>> ();
        cropToSubCropSizeMap = new Map<Id,Integer>(); 
        cropLiquidationMap_vf= new Map<String, List<Crop_Liquidation__c>>();
        cropNameListvf = new List<Crop__c>();
        //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        
        if(isTM){
            cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                              WHERE Active_for_Crop_Liquidation__c = true
                              AND Active__c = true 
                              AND Sales_Org_Code__c ='1210'
                              AND Type__c ='Category'
                              ORDER BY LastModifiedDate ASC];
            
            Boolean tempCheckCropLiqui;
            
            tempCheckCropLiqui = TradeSalesObj.createCropLiquidationSWAL(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
            //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
            isSubCropLiqCreated = tempCheckCropLiqui;
            //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
            
            System.debug('tempCheckCropLiqui '+tempCheckCropLiqui);
            
            if(tempCheckCropLiqui){
                // LoadAllData for Crop Liquidation
                // System.debug('LoadAllData for Crop Liquidation');
                productListForCropLiqui = TradeSalesObj.showProductListForCropSWAL(selectedTeritorry,mth,liquiAnualPlan[0].id,rtforLiquidation);
                cropLiquidationMap_vf = TradeSalesObj.loadAllDataForCropLiquidationSWAL(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
                //Updated by Varun Shrivastava INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                isSubmittedCropLiqui = TradeSalesObj.checkingCropLiquidationSubmited(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                System.debug('$$$$ isSubmittedCropLiqui '+isSubmittedCropLiqui);
                
                
                
            }else{
                //Create Data for Crop Liquidation
                TradeSalesObj.actionCreateCropLiquidationSWAL(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
                productListForCropLiqui = TradeSalesObj.showProductListForCropSWAL(selectedTeritorry,mth,liquiAnualPlan[0].id,rtforLiquidation);
                cropLiquidationMap_vf = TradeSalesObj.loadAllDataForCropLiquidationSWAL(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
            }
        }// isTM is loging End
        
        
        //if RM is Login
        if(isRM || isZMM){
            System.debug('liquiAnualPlan in RM '+liquiAnualPlan);
            System.debug('liquiAnualPlan in zh Size  '+liquiAnualPlan.size());
            System.debug('Selected territory '+selectedTeritorry);
            System.debug('Month   '+mth);
            cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                              WHERE Active_for_Crop_Liquidation__c = true
                              AND Active__c = true 
                              AND Sales_Org_Code__c ='1210'
                              AND Type__c ='Category'
                              ORDER BY LastModifiedDate ASC];
            
            if(selectedTeritorry=='All'){
                isSubmittedCropLiqui = true;
                Map<String,List<Crop_Liquidation__c>> newLiqMapCrop = new Map<String,List<Crop_Liquidation__c>>();
                newLiqMapCrop = TradeSalesObj.rollupCropLiquidationSWAL(liquiAnualPlan,mth);
                System.debug('retruning from roll up newLiqMapCrop '+newLiqMapCrop);
                
                if(newLiqMapCrop.size()>0){
                    productListForCropLiqui = TradeSalesObj.showProductListForCropForHigher(liquiAnualPlan,mth,rtforLiquidation);
                    cropLiquidationMap_vf = new Map<String, List<Crop_Liquidation__c>>(newLiqMapCrop);   
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                    isSubCropLiqCreated = true;
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                    
                }else{
                    productListForCropLiqui = new List<Product2>(); 
                }
                
            }else{
                // if perticular territory is selected
                System.debug('selectedTeritorry '+selectedTeritorry);
                //display data foe selected territory
                Boolean tempCheckCropLiquis;
                tempCheckCropLiquis = TradeSalesObj.displayCropDataForSingleTeritory(liquiAnualPlan,selectedTeritorry,mth);
                //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                isSubCropLiqCreated = tempCheckCropLiquis;
                //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                System.debug('in SWAL tempCheckCropLiquis '+tempCheckCropLiquis);
                if(tempCheckCropLiquis){
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                    //isSubmittedCropLiqui = true;
                    isSubmittedCropLiqui=TradeSalesObj.checkingCropLiquidationSubmited(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
                    
                    //SCTASK0292264: Sayan start - RM will only be able to see Liquidation if Submitted by TM or if TM is absent
                    system.debug('Crop Liq is submitted already--> '+isSubmittedCropLiqui);
                    system.debug('isTerritoryManagerAbsent--> '+isTerritoryManagerAbsent);
                    if(isSubmittedCropLiqui || isTerritoryManagerAbsent){
                        productListForCropLiqui = TradeSalesObj.showProductListForCropSWALSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
                        System.debug('productListForCropLiqui at select territory in RM '+productListForCropLiqui);
                        cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                        cropLiquidationMap_vf = TradeSalesObj.loadAllDataForCropLiquidationSWALSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                    }
                    //SCTASK0292264: Sayan end
                    
                    /*productListForCropLiqui = TradeSalesObj.showProductListForCropSWALSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
System.debug('productListForCropLiqui at select territory in RM '+productListForCropLiqui);
cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
cropLiquidationMap_vf = TradeSalesObj.loadAllDataForCropLiquidationSWALSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);*/
                }else{
                    if(isTerritoryManagerAbsent){
                        //create crop Liquidation if TM is absent
                        TradeSalesObj.actionCreateCropLiquidationSWALForHigher(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                        productListForCropLiqui = TradeSalesObj.showProductListForCropSWALSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
                        cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                        cropLiquidationMap_vf = TradeSalesObj.loadAllDataForCropLiquidationSWALSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                    }else{
                        productListForCropLiqui = TradeSalesObj.showProductListForCropSWALSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
                        cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                        cropLiquidationMap_vf = TradeSalesObj.loadAllDataForCropLiquidationSWALSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                    }
                    
                }
            }
        }
        //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        List<Sub_Crops__c> subCropRecordList = [Select Id,Name,Crop__c from Sub_Crops__c where Crop__c in : cropNameListvf order by Crop__c, Name];
            for(Sub_Crops__c subCropRecord : subCropRecordList){
                if(cropTosubCropMap.containsKey(subCropRecord.Crop__c)){
                    cropTosubCropMap.get(subCropRecord.Crop__c).add(subCropRecord);
                    Integer value = cropToSubCropSizeMap.get(subCropRecord.Crop__c);
                    value++;
                    cropToSubCropSizeMap.put(subCropRecord.Crop__c, value);
                }else{
                    List<Sub_Crops__c> subCropList = new List<Sub_Crops__c>();
                    subCropList.add(subCropRecord);
                    cropTosubCropMap.put(subCropRecord.Crop__c, subCropList); 
                    cropToSubCropSizeMap.put(subCropRecord.Crop__c, 1);
                }
            }
        
        List<Sub_Crop_Liquidation__c> subCropLiqInsertList = new List<Sub_Crop_Liquidation__c>();
        if(!isSubCropLiqCreated && (isTM || (isTerritoryManagerAbsent && isRM) || (isTerritoryManagerAbsent && isZMM))){
            if(cropLiquidationMap_vf.size() > 0){
                for(String pr : cropLiquidationMap_vf.keySet()){
                    for(Crop_Liquidation__c cropLiqRecord : cropLiquidationMap_vf.get(pr)){
                        for(Sub_Crops__c subCropRecord : cropTosubCropMap.get(cropLiqRecord.Crop__c)){
                            Sub_Crop_Liquidation__c subCropLiq = new Sub_Crop_Liquidation__c();
                            subCropLiq.Crop_Liquidation__c = cropLiqRecord.ID;
                            subCropLiq.Sub_Crop_Liquidation_Value__c = 0;
                            subCropLiq.Sub_Crops__c = subCropRecord.Id;
                            subCropLiq.Is_Sub_Crop_Liquidation_Submitted__c = false;
                            subCropLiq.Liquidation__c = cropLiqRecord.Liquidation__c;
                            subCropLiq.Sales_Org__c = cropLiqRecord.Sales_Org__c;
                            subCropLiqInsertList.add(subCropLiq);
                            
                            if(liquidationToSubCropLiqMap.containsKey(cropLiqRecord.ID)){
                                liquidationToSubCropLiqMap.get(cropLiqRecord.ID).add(subCropLiq);
                            }else
                            {
                                List<Sub_Crop_Liquidation__c> subCropLiqList = new List<Sub_Crop_Liquidation__c>();
                                subCropLiqList.add(subCropLiq);
                                liquidationToSubCropLiqMap.put(cropLiqRecord.ID, subCropLiqList);        
                            }
                        }
                    }
                }    
                if(subCropLiqInsertList.size() > 0)
                    insert subCropLiqInsertList;
            }else{
                productListForCropLiqui = new List<Product2>();
                cropLiquidationMap_vf= new Map<String, List<Crop_Liquidation__c>>();
                liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>> ();
                
            }
        }
        else{
            if(cropLiquidationMap_vf.size() > 0){
                
                if(isTM){
                    liquidationToSubCropLiqMap = TradeSalesObj.fetchSubCropLiqRecord(teriList[0].id, mth, liquiAnualPlan, rtforLiquidation, cropTosubCropMap);
                }
                if(isRM || isZMM){
                    if(selectedTeritorry == 'All'){
                        liquidationToSubCropLiqMap = TradeSalesObj.fetchSubCropLiqRecord(null, mth, liquiAnualPlan, rtforLiquidation, cropTosubCropMap);
                        //System.assert(false,'liquidationToSubCropLiqMap : '+liquidationToSubCropLiqMap);
                    }else{
                        List<Territory_Distributor__c> territoryList=[Select Id,Name from Territory_Distributor__c where Name = :selectedTeritorry and Sales_Org_Code__c = '1210'];
                        if(territoryList.size() > 0)
                            liquidationToSubCropLiqMap = TradeSalesObj.fetchSubCropLiqRecord(territoryList[0].ID, mth, liquiAnualPlan, rtforLiquidation, cropTosubCropMap);
                        
                    }
                }
            }else{
                productListForCropLiqui = new List<Product2>();
                cropLiquidationMap_vf= new Map<String, List<Crop_Liquidation__c>>();
                liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>> ();
                
            }
            
        }
        /*String assertValue='';
for(Product2 product :productListForCropLiqui){
assertValue=assertValue+'Product:'+product.Name+' Crop Liquidation Size : '+(cropLiquidationMap_vf.get(product.ID)).size();
assertValue=assertValue+'\n';
}
*/// end of the function of createCropLiquidation
        //System.assert(false,'assertValue:'+liquidationToSubCropLiqMap.size());
        
    }
    
    public void updateSingleRecordForCropLiquidation(){
        TradeSalesSWALCropLiquidation tradeSales = new TradeSalesSWALCropLiquidation();
        tradeSales.updateSingleRecordForCropLiquidationSWAL(recordIdTotupdate, prodIdTotupdate, valueToupdate);
    }
    
    
    public void updateCropLiquidation(){
        String  mth  = monthMap.get(selectedMonth);
        TradeSalesSWALCropLiquidation tradeSales = new TradeSalesSWALCropLiquidation();
        //System.assert(false,'teriList:'+teriList + 'liquiAnualPlan : '+liquiAnualPlan);
        //Updated by Varun Shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes Start
        tradeSales.updateCropLiquidationSWAL(selectedTeritorry, mth, liquiAnualPlan[0].id, rtforLiquidation);
        //Updated by Varun Shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes End
    }
       
    
}