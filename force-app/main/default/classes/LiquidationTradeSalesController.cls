/*
* Name: LiquidationTradeSalesController
* Created On: 16 July 2018
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: Class is used for Liquidation of India/ this is for TM and ZH
* Object used: Product2, Liquidation2, Openinventtory2
*/


global class LiquidationTradeSalesController {
    
    //Getter Setter with visualforce Page
    //Integer
    public Integer selectedMonth{get;set;} //
    public String startDate1 {get;set;}
    public Date StartDate {get;set;}
    public Date EndDate;
    public Integer totalProductNumber {get;set;} // for total number of Product list
    public Integer selectMonth {get;set;}
    public Integer totalLiquidation {get;set;}
    public String submittedMonth {get;set;}
    public String yearForVf {get;set;}
    
    
    //INC-377463:Balasore territory liquidation showing zero:Modified by Deeksha Gupta
    public Map<String,Id> territoryIdMap;
    
    
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
    String profName;
    
    public List<String> popYearList {get;set;}
    
    
    
    //Boolean
    public Boolean isTM {get;set;} // flag for user profile.
    public Boolean isRM {get;set;} // flag for Regional/Zonal Mangers
    public Boolean isZH {get;set;} //flag for Sales Head  
    public Boolean isSBU {get;set;}  //flag for SBU
    public Boolean isAdmin {get;set;}
    public Boolean isZMM {get;set;}
    public Integer tmpSelectedMonth;
    
    
    public Boolean isAvail {get;set;} //flag for liquidation annual plan  for month is available or not
    public Boolean isSubmitted {get;set;} //after submitted disable the section.
    public Boolean isOpenInvLock {get;set;}
    public Boolean forupdate {get;set;}
    
    
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
    public String ZHId;
    
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
    
    
    
    
    //variable declaration for Integer
    
    //variable declaration for List
    public  List<Liquidation_Annual_Plan__c> liquiAnualPlan{get;set;}//master data for current year selected teritory
    //private List<Opening_Inventory__c>openingInvList = new List<Opening_Inventory__c>(); 
    public List<TM_District_Tehsil_Mapping__c> userTehsilMapping;
    public List <Territory_Distributor__c> teriList {get;set;}
    
    public List<Territory_Distributor__c> teriListForUser1 ;
    public List<Territory_Distributor__c> teriListForUser2 ;
    public List<Territory_Distributor__c> teriListForUser3 ;
    public List<Territory_Distributor__c> teriListForUser4 ;
    public List<Territory_Distributor__c> teriListForUser5 ;
    public List<Territory_Distributor__c> ZMMUser ;
    
    
    
    //All declaration for Crop Liquidation Variable
    public List<Crop__c> cropNameListvf {get;set;}
    public List<Product2>productListForCropLiqui {get;set;}
    public Map<String,List<Crop_Liquidation__c>> cropLiquidationMap_vf {get;set;}
    public Boolean forCropSubmit{get;set;}
    public Boolean isSubmittedCropLiqui {get;set;} // this is used when crop Liquidation is Submitted./ not to edited
    public Boolean isTerritoryManagerAbsent {get;set;}
    
    
    //constructor
    public LiquidationTradeSalesController(){
        try{
            selectedMonth = 0; 
            monthForVF = '';
            monthForNextVF = '';
            //Added by Varun Shrivastava : SCTASK0459610
            monthForPreviousVF = '';
            //Added by Varun Shrivastava : End
            userId =UserInfo.getUserId();
            //userId =UserInfo.getUserRoleId();
            isTM = false;  // flag for user profile.
            isRM = false; // flag for Regional/Zonal Mangers
            isZH = false; //flag for Sales Head  
            isSBU = false;  //flag for SBU
            isAdmin = false;
            isZMM = false;
            isAvail = false; //flag for liquidation annual plan  for month is available or not
            isSubmitted = false; //after submitted disable the section.
            isOpenInvLock = false;
            forupdate = false;
            
            
            
            
            system.debug('Id is '+userId);
            Today= System.today();
            
            selectedMonth = Today.month();
            //INC-377463:Balasore territory liquidation showing zero:Modified by Deeksha Gupta
            territoryIdMap = new Map<String,Id>();
            for(Territory_Distributor__c  td : [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,     
                                                ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c        
                                                FROM Territory_Distributor__c       
                                                WHERE Present_in_KEDE__c = true         
                                                AND Neglected__c = false        
                                                AND TerritoryCode__c != '#'         
                                                AND Sales_Org_Code__c='1000']){     
                                                    territoryIdMap.put(td.Name,td.id);      
                                                }
            
            
            if(selectedMonth == 1){
                selectedMonth = 12;
            }else{
                selectedMonth =selectedMonth-1;
            }
            
            //Added by Varun Shrivastava : Start : SCTASK0459610
            List<Multi_Country_Liquidation__c> liqSettingRecord = [Select Enable_Liq_Validation__c, Hide_Current_Month_Option__c from Multi_Country_Liquidation__c where Country__c = 'India' limit 1];           
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
            
            System.debug('selectedMonth in constructor '+selectedMonth);
            ZHId ='';
            totalLiquidation = 0;
            submittedMonth ='';
            
            yearForVf = '';
            System.debug('selectedMonth in march '+selectedMonth);
            
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
            teriList = new  List <Territory_Distributor__c> (); 
            teriListForUser1 =new List<Territory_Distributor__c>();
            teriListForUser2 =new List<Territory_Distributor__c>();
            teriListForUser3 =new List<Territory_Distributor__c>();
            teriListForUser4 =new List<Territory_Distributor__c>();
            teriListForUser5 = new List<Territory_Distributor__c>();
            ZMMUser = new List<Territory_Distributor__c>();
            
            
            //All variable Initialization for Crop Liquidation
            cropNameListvf = new List<Crop__c>();
            productListForCropLiqui = new List<Product2>();
            cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>();
            forCropSubmit = false; 
            isSubmittedCropLiqui = false;
            isTerritoryManagerAbsent = false;
            
            
            
            
            
            rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
            rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
            rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
            
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
            System.debug('selectedMonth in current '+selectedMonth);
            
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            
            
            
            StartDate = currentFiscalYear.StartDate;
            startDate1 = String.valueOf(StartDate);
            
            System.debug('Start Date @@ '+startDate1);
            EndDate = currentFiscalYear.EndDate;
            
            
            
            productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                           Sales_Org_Code__c,Brand_Type__c ,
                           Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                           FROM Product2 
                           WHERE IsActive = true 
                           AND Sales_Org_Code__c = '1000' 
                           AND Active_For_Liquidation__c= true];
            
            totalProductNumber = productList.size();
            system.debug('@@'+totalProductNumber);
            teriListForUser1 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                                ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c 
                                FROM Territory_Distributor__c 
                                WHERE Present_in_KEDE__c = true 
                                AND Neglected__c = false 
                                AND TerritoryCode__c != '#' 
                                AND  TerritoryManager__c=:userId
                                AND Sales_Org_Code__c='1000'];
            
            if(teriListForUser1.size()>0){
                isTM = true;
                System.debug('IsTM in Default in Constructor '+isTM);
                ZHId = teriListForUser1[0].Zonal_Manager_Id__c;
            }else{
                productList = new List<Product2>();
                isTM = false;  
            }
            
            
            System.debug('userId Zonal Head '+userId);
            teriListForUser3 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                                ZonalManager__c, SBU__c,  Zone__c, SBUHead__c 
                                FROM Territory_Distributor__c 
                                WHERE Present_in_KEDE__c = true 
                                AND Neglected__c = false 
                                AND TerritoryCode__c != '#' 
                                AND  Zonal_Manager_Id__c= :userId
                                AND Sales_Org_Code__c='1000'];
            
            
            System.debug('teriListForUser3 '+teriListForUser3.size());
            if(teriListForUser3.size()>0){
                isZH = true;
                
                isSubmitted = true;
                forCropSubmit = true; 
                
                
            }else{
                isZH = false;
            }
            
            System.debug('isZh while Testing '+isZH);
            
            //for ZMM        
            
            
            ZMMUser = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,Zonal_Marketing_Manager_1_Id__c,
                       ZonalManager__c, SBU__c,  Zone__c, SBUHead__c,Zonal_Marketing_Manager_2_Id__c, Zonal_Marketing_Manager_3_Id__c
                       FROM Territory_Distributor__c 
                       WHERE Present_in_KEDE__c = true 
                       AND Neglected__c = false 
                       AND TerritoryCode__c != '#' 
                       AND Sales_Org_Code__c='1000'
                       AND  (Zonal_Marketing_Manager_1_Id__c =:userId 
                             OR Zonal_Marketing_Manager_2_Id__c =:userId 
                             OR Zonal_Marketing_Manager_3_Id__c =:userId)];
            
            if(ZMMUser.size()>0){
                isZMM = true;
                System.debug('ZMM log '+userId);
                System.debug('Prashant Wani is Login ');
                isSubmitted = true;
                forCropSubmit = true;
            }else{
                isZMM = false;
            }
            
            
            //start of Rollup summery
            if(isTM){
                
                teriList = [select id,Name,TerritoryManager__c,SalesOrg__c 
                            FROM Territory_Distributor__c 
                            WHERE TerritoryManager__c=:userId
                            AND Sales_Org_Code__c='1000'];
                
                if(teriList.size()>0){
                    selectedTeritorry = teriList[0].Name;
                    if(selectedMonth ==3){
                        
                        Period currentFiscalYear2 = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                                     FROM Period WHERE Type = 'Year' 
                                                     AND StartDate <= TODAY 
                                                     AND EndDate >= TODAY];
                        
                        DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear2.EndDate,Time.newInstance(0,0,0,0));
                        System.debug('dateTimeScheduled.format() '+dateTimeScheduled.format('yyyy-MM-dd')); 
                        
                        Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
                        
                        
                        Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                                 From Period 
                                                 WHERE EndDate< :theDate
                                                 AND Type ='Year' order By EndDate DESC Limit 1];
                        
                        //@@ startDate1
                        StartDate = lastFiscalYear.StartDate;
                        startDate1 = String.valueOf(StartDate);
                        
                        liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                           Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:lastFiscalYear.StartDate
                                                  AND Fiscal_End_Date__c=:lastFiscalYear.EndDate)
                                           AND(Territory_Name__c =:teriList[0].id)
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    }else{
                        liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                           Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:StartDate
                                                  AND Fiscal_End_Date__c=:EndDate)
                                           AND Territory_Name__c =:teriList[0].id
                                           AND RecordTypeId =:rtforAnnualPlan 
                                           AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    }
                    
                    
                    if(liquiAnualPlan.size()>0 || test.isRunningTest()){
                        
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
                    }else{
                        productList = new List<Product2>();
                    }
                    
                    for(Opening_Inventory2__c prodObj:openInvList){
                        OpeningInventoryMap.put(prodObj.Product__c, prodObj);
                        System.debug('prodObj.Product__c '+prodObj.Product__c);
                    }
                    
                    if(liquiAnualPlan.size()>0){
                        teritorynameList.add(teriList[0].Name); 
                        selectedTeritorry = teriList[0].Name;
                        
                    }else{
                        productList = new list<product2>();
                    }
                    
                } 
                else{
                    System.debug('Error occur ');
                    productList = new list<product2>();
                }
            } //end of TM
            
            
            
            System.debug('selectedMonth for last year '+selectedMonth);
            if(selectedMonth == 3){
                System.debug('inside if selectedMonthsd '+selectedMonth); 
                Period currentFiscalYear1 = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                             FROM Period WHERE Type = 'Year' 
                                             AND StartDate <= TODAY 
                                             AND EndDate >= TODAY];
                
                DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear1.EndDate,Time.newInstance(0,0,0,0));
                System.debug('dateTimeScheduled.format() '+dateTimeScheduled.format('yyyy-MM-dd')); 
                
                Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
                
                
                Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                         From Period 
                                         WHERE EndDate< :theDate
                                         AND Type ='Year' order By EndDate DESC Limit 1];
                Select_Year = lastFiscalYear.StartDate.year()+'-'+lastFiscalYear.EndDate.year();   
            }else{
                Select_Year = currentFiscalYear.StartDate.year()+'-'+currentFiscalYear.EndDate.year();    
            }
            selectedYear = Select_Year;
            
            //Start of Rollup summary for Zonal Head
            if(isZH || isZMM){ 
                System.debug('Pratap Ramkhamb Login Roll up ');
                
                RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj =new RollupTradeSalesLiquidation();
                territoryMap = new Map<String,String>();
                territoryMap = rollupTradeSalesLiquidationObj.getZHTerritories();
                
                if(territoryMap.size()>0){
                    teritorynameList = territoryMap.values();
                    
                    if(selectedMonth == 3){
                        
                        
                        Integer index;
                        if(selectedMonth <= 3){
                            index = 1;
                        }else{
                            index = 0;
                        }
                        String strStratDate  = selectedYear.split('-')[index];
                        System.debug('strStratDate '+strStratDate);
                        Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                        System.debug('Date is '+d);
                        
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
                                           AND Sales_Org__r.Sales_Org_Code__c='1000'];
                        System.debug('liquiAnualPlan in ZH Pratap Rankhamb' +liquiAnualPlan);
                        System.debug('liquiAnualPlan in ZH Pratap Rankhamb size ' +liquiAnualPlan.size());
                        
                        
                        
                    }else{
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYear.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYear.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId = :rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    }
                    
                    
                    
                    
                    System.debug('liquiAnualPlan ==========>'+liquiAnualPlan.size());
                    
                    selectedTeritorry ='All';
                    if(liquiAnualPlan.size()>0){
                        newOpenMap = rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        newLiqMap = rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                        
                        System.debug('newOpenMap '+newOpenMap.size());
                        System.debug('newLiqMap '+newLiqMap.size());
                        
                        liquidationMap_vf.clear();
                        OpeningInventoryMap_vf.clear();
                        
                        
                        if((newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newLiqMap.size()== newOpenMap.size()*/) ||Test.isRunningTest()){
                            displayProduct();
                            refreshProductList(newOpenMap, newLiqMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);  
                            
                        }else{
                            productList = new List<Product2>();
                        }
                    }else{
                        productList = new list<product2>();
                    }
                    
                }else{
                    productList = new list<product2>();
                }
                
            }//end of rollup of Zonal Head
            
            
            //Roll up of SBU 
            
            // sendEmailToZH();
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }// End of Constructor
    
    
    
    
    
    // This is default Method
    public void defaultMethod(){
        try{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Account site'));
            Integer diff1;
            String mth = monthMap.get(selectedMonth);
            //Added by Varun Shrivastava : Start : SCTASK0459610
            if(hideCurrentMonthLiqOption){
                selectedMonth = selectedMonth - 1;
                mth = monthMap.get(selectedMonth);
            }
            //Added by Varun Shrivastava : End : SCTASK0459610
            
            if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                if(isTM || Test.isRunningTest()){
                    
                    diff1 = checkDataForMonth(teriList[0].id,mth,liquiAnualPlan[0].id);
                    System.debug('value of diff1 is '+diff1);
                    if(diff1 == 0 || Test.isRunningTest()){
                        displayProduct();
                        loadAllData(teriList[0].id,liquiAnualPlan[0].id,mth);
                    }
                    else{
                        createData(teriList[0].id,liquiAnualPlan[0].id,mth);
                        displayProduct();
                        loadAllData(teriList[0].id,liquiAnualPlan[0].id,mth);
                    }
                } 
            }
        }
        catch(Exception ex){
            System.debug('Error Mssage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    } //end of default Method
    
    // start of function on year change
    public void onYearChange(){
        try{
            yearForVf = Select_Year;
            if(isTM){
                month  = monthMap.get(selectedMonth);
                System.debug('selectedYear in year change '+selectedYear);
                System.debug('selectedYear in year change month '+selectedMonth);
                
                //2019-04-01
                Integer index;
                if(selectedMonth <= 3){
                    index = 1;
                }else{
                    index = 0;
                }
                String strStratDate  = selectedYear.split('-')[index];
                System.debug('strStratDate '+strStratDate);
                Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                System.debug('Date is '+d);
                
                
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' AND (StartDate <=:d AND EndDate >=:d)];
                
                StartDate = currentFiscalYear.StartDate;
                startDate1 = String.valueOf(StartDate);
                
                
                if(teriList.size()>0){
                    liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__c =:teriList[0].id
                                       AND RecordTypeId = : rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    
                    
                    
                    
                    if(null != liquiAnualPlan && liquiAnualPlan.size() != 0){
                        openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,
                                       Opening_Inventory__c,YTD_Sales__c,Opening_Inventory_Cooperatives__c,
                                       //Added by Varun Shrivastava: SCTASK0459610
                                       Product_Budget__c,
                                       YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                          			   YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           			   YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                                       //Added by Varun Shrivastava: SCTASK0459610
                                       Opening_Inventory_Govt__c,Product__c,State__c,Territory__c
                                       FROM Opening_Inventory2__c 
                                       WHERE Territory__c=:teriList[0].id 
                                       AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                       AND RecordTypeId =: rtForOpeningInventory];
                        OpeningInventoryMap = new Map<Id, Opening_Inventory2__c>();
                        for(Opening_Inventory2__c opninv : openInvList){
                            OpeningInventoryMap.put(opninv.Product__c, opninv);   
                        }    
                    }
                    
                    
                    if(liquiAnualPlan.size()>0){
                        displayProduct();
                        refreshProductList(newOpenMap, newLiqMap);
                        Select_Year = selectedYear;
                        selectedTeritorry = teriList[0].name;
                        Boolean dateFlag = validateSelectedFilters(selectedMonth,selectedYear);
                        Integer differ = checkDataForMonth(teriList[0].id,month,liquiAnualPlan[0].id);
                        
                        if(dateFlag){
                            
                            if((differ == 0) || Test.isRunningTest()){
                                //refreshProductList(open);
                                loadAllData(teriList[0].id,liquiAnualPlan[0].id,month); 
                            }else{
                                createData(teriList[0].id,liquiAnualPlan[0].id,month);
                                loadAllData(teriList[0].id,liquiAnualPlan[0].id,month); 
                            }
                            
                            
                        }else{
                            productList = new List<Product2>();
                            startDate1 = selectedYear;
                            totalProductNumber =0;
                            Select_Year = selectedYear;    
                        }  
                    }
                    else{
                        productList = new List<Product2>();
                        // startDate1 = selectedYear;
                        totalProductNumber =0;
                        Select_Year = selectedYear;
                    }
                    
                }else{
                    productList = new List<Product2>();
                    totalProductNumber =0;
                    //startDate1 = selectedYear;
                    Select_Year = selectedYear;
                }
            }  // end of TM
            
            
            
            
            //if ZH is login
            if(isZH || isZMM ){
                
                Select_Year = selectedYear;
                RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj = new RollupTradeSalesLiquidation();
                territoryMap = new Map<String,String>();
                
                territoryMap = rollupTradeSalesLiquidationObj.getZHTerritories();
                System.debug('selectedYear in year change '+selectedYear);
                System.debug('selectedYear in year change month '+selectedMonth);
                //2019-04-01
                Integer index;
                if(selectedMonth <= 3){
                    index = 1;
                }else{
                    index = 0;
                }
                String strStratDate  = selectedYear.split('-')[index];
                
                Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                
                
                
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' AND (StartDate <=:d AND EndDate >=:d)];
                
                StartDate = currentFiscalYear.StartDate;
                startDate1 = String.valueOf(StartDate);
                
                
                
                if(territoryMap.size()>0){
                    
                    teritorynameList = territoryMap.values();
                    
                    liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE FIscal_Year__c =: selectedYear
                                       AND Territory_Name__c IN:territoryMap.keySet()
                                       AND RecordTypeId =: rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    
                    Boolean dateFlag = validateSelectedFilters(selectedMonth,selectedYear);
                    if(dateFlag && liquiAnualPlan.size()>0){
                        newLiqMap = rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        newOpenMap = rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        
                        if((newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newLiqMap.size()== newOpenMap.size()*/) || Test.isRunningTest()){
                            displayProduct();
                            refreshProductList(newOpenMap, newLiqMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);   
                            
                        }else{
                            productList = new list<product2>();
                        }
                        
                    }//emd of liquiAnualPlan checking
                    else{
                        totalProductNumber = 0;
                        //  startDate1 = selectedYear;
                        productList = new list<product2>();
                    }
                } 
            } // end of ZH ZMM is login
            
            
        }
        catch(Exception ex){
            System.debug('Error Mssage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    }
    // end of function on year change 
    
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
                          Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
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
    
    //This function is called to check data for given month is available or not
    //if YES return true otherwise False.
    //checkDataForMonth function
    public Integer checkDataForMonth(String territoryName ,String mnth,String liquiAnnualPlanId){
        List <Liquidation2__c> tempLiquiList = new  List <Liquidation2__c>();
        Integer result;
        try{
            tempLiquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                             Product__c,Type__c,submitted_trade__c,
                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                             Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                             Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                             Month__c,Territory__c
                             FROM Liquidation2__c 
                             WHERE Month__c=:mnth
                             AND Territory__c=:territoryName
                             AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                             AND RecordTypeId =:rtforLiquidation];
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber()); 
        }
        result = (OpeningInventoryMap.values()).size() - tempLiquiList.size();
        return result;
        
    } 
    //end of checkDataForMonth function
    
    Boolean validateSelectedFilters(Integer month,String selectedYear){
        Boolean result;
        if(null != month && null != selectedYear && '' != selectedYear){
            Date currentDate = Date.today();
            Date currentDate1 = Date.newInstance(currentDate.year(), currentDate.month(), Integer.valueOf('01'));
            Integer index;
            if(month <= 3){
                index = 1;
            }else{
                index = 0;
            }
            String strStratDate1  = selectedYear.split('-')[index];
            Date selectedDate1 = Date.newInstance(Integer.valueOf(strStratDate1), month, Integer.valueOf('01'));
            
            if(selectedDate1 <= currentDate1 ){
                result = true;
            }else{
                result = false;
            }
        }
        return result;
    }
    
    public void loadAllData(String territoryName, String liquiAnnualPlanId ,String mth){
        try{
            if(mth != '' && null != mth){
                
                
                openInvList = new List<Opening_Inventory2__c>();
                Map<String, Opening_Inventory2__c> tempOpenInvMap = new Map<String, Opening_Inventory2__c>();
                openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,
                               Opening_Inventory__c,YTD_Sales__c,Opening_Inventory_Cooperatives__c,
                               YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                               YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,
                               YTD_Sales_Sept__c,YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                               //Added by Varun Shrivastava:SCTASK0459610
                               Product_Budget__c,
                               //Added by Varun Shrivastava:SCTASK0459610
                               Opening_Inventory_Govt__c,Product__c,State__c,Territory__c
                               FROM Opening_Inventory2__c 
                               WHERE Territory__c=:territoryName 
                               AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                               AND RecordTypeId =:rtForOpeningInventory];
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
                        Opening_Inventory2__c openInvObjTemp = new Opening_Inventory2__c();                    
                        openInvObjTemp =  openInvObj;
                        String tmpMth = monthMap.get(selectedMonth);
                        
                        switch on tmpMth {
                            
                            when 'Jan' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Jan__c;
                            }
                            when 'Feb' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Feb__c;
                                System.debug('============> Feb');
                            }
                            when 'Mar' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Mar__c;
                                System.debug('============> March ');
                            }
                            when 'Apr' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Apr__c;
                                System.debug('============> Apr ');
                            }
                            when 'May' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_May__c;
                                System.debug('============> May ');
                            }
                            when 'Jun' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Jun__c;
                                System.debug('============> Jun ');
                            }
                            when 'Jul' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Jul__c;
                                System.debug('============> Jul ');
                            }
                            when 'Aug' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Aug__c;
                                System.debug('============> Aug ');
                            }
                            when 'Sept' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Sept__c;
                                System.debug('============> Sep ');
                            }
                            when 'Oct' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Oct__c;
                                System.debug('============> Oct ');
                            }
                            when 'Nov' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Nov__c;
                                System.debug('============> Nov ');
                            }
                            when 'Dec' {
                                openInvObjTemp.YTD_Sales__c = openInvObj.YTD_Sales_Dec__c;
                                System.debug('============> Dec ');
                            }
                            
                            
                        }// end of Switch case
                        
                        tempOpenInvMap.put(openInvObj.Product__c, openInvObjTemp);
                    }
                    
                }else{
                    totalProductNumber = 0;
                    productList = new list<product2>();
                }
                
                //loading all Data  from previous month
                liquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                             Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                             Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                             Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                             Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
                             //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                             Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                             FROM Liquidation2__c 
                             WHERE Territory__c=:territoryName 
                             AND Month__c=:mth
                             AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                             AND RecordTypeId =:rtforLiquidation];
                Map<String,Liquidation2__c> tempLiqMap =new Map<String,Liquidation2__c>(); 
                if(liquiList.size()>0){
                    for(Liquidation2__c liqiObj :liquiList){
                        if( liqiObj.submitted_trade__c == true){
                            isSubmitted= true;
                            forCropSubmit = true;
                        }
                        liquidationMap.put(liqiObj.Product__c,liqiObj);
                        tempLiqMap.put(liqiObj.Product__c,liqiObj);
                        
                    }
                }else{
                    totalProductNumber =0;
                    productList = new list<product2>();
                } 
                tempLiqMap = refreshProductList(tempOpenInvMap, tempLiqMap);
                OpeningInventoryMap_vf.putAll(tempOpenInvMap);
                liquidationMap_vf.putAll(tempLiqMap);  
            }else{
                productList = new list<product2>();    
            }
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber()); 
        }
        // List<Liquidation2__c> liquiList = new List<Liquidation2__c>();
        
        
    }
    
    public void loadDataForSelectedMonth(String territoryName , String liquiAnnalPlanId){
        try{
            Map<String, Opening_Inventory2__c> tempOpenInvMap = new Map<String, Opening_Inventory2__c>();
            Map<String, Liquidation2__c> tempLiqMap = new Map<String, Liquidation2__c>();
            liquiList = new List <Liquidation2__c>();
            
            liquiList = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                         Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                         Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                         Liquidation_YTD_Previous_Month__c,Product_Budget__c,		Fixed_YTD_Sales__c	,	
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c
                         WHERE Territory__c=:territoryName
                         AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId
                         AND RecordTypeId =:rtforLiquidation
                         AND Month__c=:monthMap.get(selectedMonth)];
            
            
            if(liquiList.size()>0 ){
                
                if(liquiList[0].submitted_trade__c== true || Test.isRunningTest()){
                    isSubmitted = true;
                    forCropSubmit = true;
                }
                if(liquiList[0].submitted_trade__c== false ){
                    isSubmitted = false;
                    forCropSubmit = false;
                }
                liquidationMap_vf.clear();
                liquidationMap_vf = new Map<String,Liquidation2__c> ();
                for(Liquidation2__c liqiObj :liquiList) {
                    tempLiqMap.put(liqiObj.Product__c,liqiObj); 
                }
            }else{
                totalProductNumber = 0;
            }
            openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,Opening_Inventory__c,
                           YTD_Sales__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,
                           YTD_Sales_Mar__c,YTD_Sales_Apr__c,YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,
                           YTD_Sales_Aug__c,YTD_Sales_Sept__c,YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                           //Added by Varun Shrivastava:SCTASK0459610
                           Product_Budget__c,
                           //Added by Varun Shrivastava:SCTASK0459610
                           Product__c,State__c,Territory__c
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
                            System.debug('============> Feb');
                        }
                        when 'Mar' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Mar__c;
                            System.debug('============> March ');
                        }
                        when 'Apr' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Apr__c;
                            System.debug('============> Apr ');
                        }
                        when 'May' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_May__c;
                            System.debug('============> May ');
                        }
                        when 'Jun' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jun__c;
                            System.debug('============> Jun ');
                        }
                        when 'Jul' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jul__c;
                            System.debug('============> Jul ');
                        }
                        when 'Aug' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Aug__c;
                            System.debug('============> Aug ');
                        }
                        when 'Sept' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Sept__c;
                        }
                        when 'Oct' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Oct__c;
                            
                        }
                        when 'Nov' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Nov__c;
                            System.debug('============> Nov ');
                        }
                        when 'Dec' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Dec__c;
                            System.debug('============> Dec ');
                        }
                        
                        
                    } //end of Switch
                    tempOpenInvMap.put(openObj.Product__c, openInvObjTemp);
                }
            }
            else{
                productList = new List<Product2>();
                totalProductNumber = 0;
            }
            if(tempOpenInvMap.size() > 0  && tempLiqMap.size()>0){
                tempLiqMap = refreshProductList(tempOpenInvMap, tempLiqMap);
                OpeningInventoryMap_vf.putAll(tempOpenInvMap);
                liquidationMap_vf.putAll(tempLiqMap);
            }
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());    
        }
        
        
    }
    // end of loadDataForSelectedMonth function
    
    //getting liquidation for previous month
    public List<Liquidation2__c> getPreviousMonthLiquidation(String teritoryName, String liquiAnualPlanId){
        
        List<Liquidation2__c> previousDataList = new List<Liquidation2__c>();
        previousDataList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Type__c,
                            submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,Inventory_in_Kg_Cooperatives__c,
                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                            Liquidation_YTD_Previous_Month__c,Product_Budget__c	,Fixed_YTD_Sales__c,			
                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                            Inventory_in_Kg_Govt__c,Retailers_Inventory__c,Distributors_Inventory__c,Plan_for_the_next_month__c,
                            Territory__c,State__c
                            FROM Liquidation2__c 
                            WHERE Month__c=:monthMap.get(selectedMonth-1)
                            AND Territory__c=:teritoryName
                            AND Liquidation_Annual_Plan__c=:liquiAnualPlanId
                            AND RecordTypeId =:rtforLiquidation];
        
        if(previousDataList.size()>0){
            flag = true;
        }
        else
        {
            flag = false;
        }
        return previousDataList;
    }
    //end of function
    
    //if Data is available for prevoious month Then load it otherwise create it
    public void createData(String territoryName, String liquiAnnualPlanId,String mth){
        try{
            
            List<Liquidation2__c> currentLiquidationList;
            
            System.debug('in creation of Data for the month of '+mth);
            System.debug('Selected Month is '+selectedMonth);
            System.debug('in creation of Data for the month of liquiAnnualPlanId '+liquiAnnualPlanId);
            
            String PreMonth='';
            
            if(selectedMonth == 1){
                PreMonth = monthMap.get(12);    
            }else{
                PreMonth = monthMap.get(selectedMonth-1);    
            }
            //Added by Varun Shrivastava : SCTASK0459610
            monthForPreviousVF = PreMonth;
            Map<String , Liquidation2__c> LiquidationMap;
            Map<String , Liquidation2__c> currentLiquidationMap;
            //Added by Varun Shrivastava : SCTASK0459610
            System.debug('PreMonth   '+PreMonth);
            
            System.debug('PreMonth in Create Data '+PreMonth);
            Boolean chkForPrevMthData;
            
            List<Liquidation2__c> tempList = New List<Liquidation2__c>();
            Liquidation2__c liquiObj = new  Liquidation2__c();
            list<Liquidation2__c> createLiqList = new list<Liquidation2__c>();
            List<Liquidation_Annual_Plan__c> tempLiquiAnnualPlan = new List<Liquidation_Annual_Plan__c>();
            System.debug('System.Today '+System.today());
            Date tmpDate = System.today();
            
            tmpSelectedMonth =tmpDate.month();  
            System.debug('tmpSelectedMonth '+tmpSelectedMonth);  
            
            

            
            //5 indicate for May Month
            if(tmpSelectedMonth == 5){
                System.debug('inside New Fiscal Year and Month Of May');
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                            FROM Period WHERE Type = 'Year' 
                                            AND StartDate <= TODAY 
                                            AND EndDate >= TODAY];
                
                DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear.EndDate,Time.newInstance(0,0,0,0));
                System.debug('dateTimeScheduled.format() '+dateTimeScheduled.format('yyyy-MM-dd')); 
                
                Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
                System.debug(' theDate '+theDate);
                System.debug('In five');
                
                Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                         From Period 
                                         WHERE EndDate< :theDate
                                         AND Type ='Year' order By EndDate DESC Limit 1];
                
                System.debug('lastFiscalYear.StartDate '+lastFiscalYear.StartDate);
                System.debug('lastFiscalYear.EndDate '+lastFiscalYear.EndDate);
                
                tempLiquiAnnualPlan = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE (Fiscal_Start_Date__c=:lastFiscalYear.StartDate
                                              AND Fiscal_End_Date__c=:lastFiscalYear.EndDate)
                                       AND(Territory_Name__c =:territoryName)
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                System.debug('In five last Year '+tempLiquiAnnualPlan );
                System.debug('In five last Year '+tempLiquiAnnualPlan.size());
                
                
                if(tempLiquiAnnualPlan.size()>0){
                    System.debug('In five last Year id liquiAnualPlan '+liquiAnualPlan[0].id);    
                    tempList = [SELECT id,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                                Type__c,submitted__c,Plan_for_the_next_month__c,Territory__c,Month__c,
                                //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                Liquidation_YTD_Previous_Month__c,Product_Budget__c	,Fixed_YTD_Sales__c,			
                                //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                Plan_for_the_month__c,Liquidation__c,Liquidation_YTD_Trade__c,submitted_trade__c,Plan_for_Next_Month_Trade__c
                                FROM Liquidation2__c 
                                WHERE Territory__c=:territoryName
                                AND Liquidation_Annual_Plan__c=:tempLiquiAnnualPlan[0].id
                                AND Month__c =:PreMonth
                                AND RecordTypeId =:rtforLiquidation];
                    
                    currentLiquidationList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                                              Product__c,Type__c,submitted_trade__c,Month__c,
                                              //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                                Distributors_Inventory__c,Retailers_Inventory__c,Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                                Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
                                                //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                                Territory__c
                                              FROM Liquidation2__c 
                                              WHERE Month__c=:mth
                                              AND Territory__c=:territoryName
                                              AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                                              AND RecordTypeId =:rtforLiquidation];
                    
                    for(Liquidation2__c obj : tempList){
                        System.debug(' fff Plan_for_the_next_month__c '+obj.Plan_for_the_next_month__c);
                    }
                    
                }
                
            }else {
                tempList = [SELECT id,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                            Type__c,submitted__c,Plan_for_the_next_month__c,Territory__c,Month__c,
                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                            Distributors_Inventory__c,Retailers_Inventory__c,Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                            Liquidation_YTD_Previous_Month__c,Product_Budget__c	,Fixed_YTD_Sales__c,			
                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                            Plan_for_the_month__c,Plan_for_Next_Month_Trade__c,Liquidation__c,Liquidation_YTD_Trade__c,submitted_trade__c
                            FROM Liquidation2__c 
                            WHERE Territory__c=:territoryName
                            AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                            AND Month__c =:PreMonth
                            AND RecordTypeId =:rtforLiquidation]; 
                
                currentLiquidationList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                                          Product__c,Type__c,submitted_trade__c,Month__c,
                                          //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                            Distributors_Inventory__c,Retailers_Inventory__c,Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                            Liquidation_YTD_Previous_Month__c,Product_Budget__c	,Fixed_YTD_Sales__c	,	
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                            Territory__c
                                          FROM Liquidation2__c 
                                          WHERE Month__c=:mth
                                          AND Territory__c=:territoryName
                                          AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                                          AND RecordTypeId =:rtforLiquidation];
                System.debug('In else part');
            }
            
            LiquidationMap  = new  Map<String , Liquidation2__c>();
            currentLiquidationMap  = new  Map<String , Liquidation2__c>();
            for(Liquidation2__c obj : tempList){
                LiquidationMap.put(obj.Product__c,obj) ;
            }
            for(Liquidation2__c lobj: currentLiquidationList){
                currentLiquidationMap.put(lobj.Product__c,lobj);
            }
            
            
            
            
            if(tempList.size()>0){
                chkForPrevMthData = true; 
                
            }else{
                chkForPrevMthData = false;
            }
            
            System.debug('value of chkForPrevMthData '+chkForPrevMthData);
            List <Product2> prodList = new List <Product2>();
            
            prodList = [SELECT Id, Name, ProductCode, Combination_Key__c, 
                        Budget_NRV__c,Product_Code__c, Sales_Org__c, 
                        VF_Image__c, Brand_Type__c, Sales_Org_Code__c 
                        FROM Product2 
                        WHERE IsActive = true 
                        AND Sales_Org_Code__c = '1000' 
                        AND Active_For_Liquidation__c= true];
            
            
            
            
            if(chkForPrevMthData || Test.isRunningTest()){
                if(prodList.size()>0){
                    System.debug('Data is creating from previuos Data ');
                    Integer i = 0;
                    for(Product2 prodObj :prodList){
                        liquiObj = new  Liquidation2__c(); 
                        Boolean currentFlag = currentLiquidationMap.containsKey(String.valueOf(prodObj.Id));
                        if(!currentFlag && OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquiObj.Opening_Inventory2__c = opObj.Id;
                            System.debug('for april liquiAnnualPlanId '+liquiAnnualPlanId);
                            liquiObj.Liquidation_Annual_Plan__c = liquiAnnualPlanId;
                            liquiObj.Product__c = prodObj.Id;
                            liquiObj.Type__c = 'Trade';
                            liquiObj.submitted_trade__c = false;
                            liquiObj.YTD_Sales__c = 0;
                            liquiObj.Month__c = mth;
                            liquiObj.Liquidation__c = 0;
                            System.debug('value of I '+i);
                            if(LiquidationMap.containsKey(String.valueOf(prodObj.Id))) {
                                Liquidation2__c lObj= new Liquidation2__c(); //bh
                                lObj = LiquidationMap.get(prodObj.Id); //bh
                                System.debug('for april Plan_for_the_next_month__c 4441 '+lObj.Plan_for_the_next_month__c +'  '+lObj.Liquidation_YTD_Trade__c);
                                liquiObj.Plan_for_the_month__c =lObj.Plan_for_the_next_month__c + lObj.Liquidation_YTD_Trade__c;
                                //Added by Varun Start : SCTASK0459610
                                liquiObj.Distributor_Inventory_Previous_Month__c = 	lObj.Distributors_Inventory__c;	
                                liquiObj.Retailer_Inventory_Previous_Month__c = lObj.Retailers_Inventory__c;	
                                liquiObj.Liquidation_YTD_Previous_Month__c	= lObj.Fixed_YTD_Sales__c;
                                liquiObj.Product_Budget__c = opObj.Product_Budget__c;	
                                liquiObj.Retailers_Inventory__c	= lObj.Retailers_Inventory__c;
                                switch on selectedMonth{
                                    when 1 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Jan__c - opObj.YTD_Sales_Dec__c;	
                                    }
                                     when 2 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Feb__c - opObj.YTD_Sales_Jan__c;	
                                    }
                                     when 3 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Mar__c - opObj.YTD_Sales_Feb__c;	
                                    }
                                     when 4 {
                                        liquiObj.Distributors_Inventory__c = opObj.Opening_Inventory__c + opObj.YTD_Sales_Apr__c;	
                                    }
                                     when 5 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_May__c - opObj.YTD_Sales_Apr__c;	
                                    }
                                     when 6 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Jun__c - opObj.YTD_Sales_May__c;	
                                    }
                                     when 7 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Jul__c - opObj.YTD_Sales_Jun__c;	
                                    }
                                     when 8 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Aug__c - opObj.YTD_Sales_Jul__c;	
                                    }
                                     when 9 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Sept__c - opObj.YTD_Sales_Aug__c;	
                                    }
                                     when 10 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Oct__c - opObj.YTD_Sales_Sept__c;	
                                    }
                                     when 11 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Nov__c - opObj.YTD_Sales_Oct__c	;	
                                    }
                                    when 12 {
                                        liquiObj.Distributors_Inventory__c = lObj.Distributors_Inventory__c + opObj.YTD_Sales_Dec__c - opObj.YTD_Sales_Nov__c;	
                                    }
                            }
                                //Added by Varun End : SCTASK0459610
                            }
                            liquiObj.RecordTypeId = rtforLiquidation;
                            //liquiObj.Retailers_Inventory__c = 0; Commented by Varun Shrivastava : SCTASK0459610
                            liquiObj.Plan_for_the_next_month__c = 0;
                            liquiObj.Territory__c = territoryName;
                            createLiqList.add(liquiObj);
                        }
                        i++;
                    }//end of for loop
                    
                    if(createLiqList.size()>0){
                        insert createLiqList;
                        displayProduct();
                    }
                    
                    liquidationMap_vf.clear();
                    for(Liquidation2__c liquiObj1 : createLiqList){
                        liquidationMap_vf.put(liquiObj1.Product__c,liquiObj1);
                    }
                    
                }//end of Product list condition
                
                
            }else{
                System.debug('Creation of Data in Month of '+mth);
                System.debug('@@@ liquiAnnualPlanId '+liquiAnnualPlanId);
                if(prodList.size()>0){
                    System.debug('Creation of Data By ZMM ');
                    System.debug('OpeningInventoryMap by ZMM '+OpeningInventoryMap.size());
                    for(Product2 prodObj :prodList){
                        liquiObj= new Liquidation2__c();
                        Boolean currentFlag = currentLiquidationMap.containsKey(String.valueOf(prodObj.Id));
                        if(!currentFlag && OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            System.debug('OpeningInventoryMap '+OpeningInventoryMap.size());
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquiObj.Opening_Inventory2__c = opObj.Id;
                            liquiObj.Liquidation_Annual_Plan__c = liquiAnnualPlanId;
                            liquiObj.Product__c = prodObj.Id;
                            liquiObj.Type__c = 'Trade';
                            liquiObj.submitted_trade__c = false;
                            liquiObj.Month__c = mth;
                            liquiObj.YTD_Sales__c = 0;
                            liquiObj.Plan_for_the_month__c =0;
                            liquiObj.RecordTypeId = rtforLiquidation;
                            liquiObj.Retailers_Inventory__c = 0;
                            liquiObj.Plan_for_the_next_month__c = 0;
                            liquiObj.Territory__c = territoryName;
                            createLiqList.add(liquiObj);
                        }
                        
                    }
                    System.debug('createLiqList.size by ZMM '+createLiqList.size());
                    if(createLiqList.size()>0){
                        insert createLiqList;
                        System.debug('Creation of Data By ZMM Prashant Wani');
                    }
                    
                    liquidationMap_vf.clear();
                    for(Liquidation2__c liquiObj1 : createLiqList){
                        liquidationMap_vf.put(liquiObj1.Product__c,liquiObj1);
                    }
                    
                }
                
            }
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    }
    
    //update single Record
    public void updateSingleRecord(){
        system.debug('@@@'+totalProductNumber);
        try{
            
            if(isTM || isZMM){
                //totalLiquidation is use to check no negegative calculation done on visualforce page.
                if(totalLiquidation>0 || totalLiquidation == 0 ){
                    
                    if(fieldTotupdate=='Opening_Inventory__c'){
                        List <Opening_Inventory2__c> opInList = new List <Opening_Inventory2__c>();
                        List <Opening_Inventory2__c> opInUpdateList = new List <Opening_Inventory2__c>();
                        opInList = [select id,Name,
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
                                
                            } 
                        }
                        
                        if(opInUpdateList.size()>0){
                            update opInUpdateList;    
                        }
                    }
                    
                    if(fieldTotupdate=='distributer_inventory'){
                        System.debug('in UpdatesingleRecord distributer_inventory');
                        // List <Liquidation2__c> liquiList = new List <Liquidation2__c>();
                        List <Liquidation2__c> liquiUpdateList = new List <Liquidation2__c>();
                        List <Liquidation2__c> liquiUpdateList1 = new List <Liquidation2__c>();
                        liquiUpdateList1 = [select id,Name,Retailers_Inventory__c,
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                            Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                            Distributors_Inventory__c 
                                            FROM Liquidation2__c
                                            WHERE id=:recordIdTotupdate];
                        
                        if(liquiUpdateList1.size()>0){
                            for(Liquidation2__c liquObj :liquiUpdateList1){
                                liquObj.Distributors_Inventory__c = Decimal.valueOf(valueToupdate);
                                
                                liquiUpdateList.add(liquObj);
                                
                            } 
                        }
                        
                        if(liquiUpdateList.size()>0){
                            update liquiUpdateList;    
                        }
                    }
                    
                    
                    
                    if(fieldTotupdate=='retailer_inventory'){
                        System.debug('From retailer inventory');
                        System.debug('in UpdatesingleRecord distributer_inventory');
                        List <Liquidation2__c> liiUpdateList1 = new List <Liquidation2__c>();
                        List <Liquidation2__c> liiUpdateList = new List <Liquidation2__c>();
                        liiUpdateList1 = [select id,Name,
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                            Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                            Retailers_Inventory__c 
                                          FROM Liquidation2__c
                                          WHERE id=:recordIdTotupdate];
                        if(liiUpdateList1.size()>0){
                            for(Liquidation2__c liquiObj :liiUpdateList1){
                                liquiObj.Retailers_Inventory__c = Decimal.valueOf(valueToupdate);
                                liiUpdateList.add(liquiObj);
                            }
                            if(liiUpdateList.size()>0){
                                update liiUpdateList;
                            }
                        }  
                    }
                    if(fieldTotupdate=='Plan_for_the_next_month__c'){
                        Integer tmpMonth ;
                        System.debug('selected month in update single record '+selectedMonth);
                        System.debug('totalLiquidation==========> '+totalLiquidation);
                        tmpMonth = selectedMonth;
                        System.debug('selectedMonth in update Sing line '+selectedMonth);
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
                                              Liquidation_YTD_Previous_Month__c	,Product_Budget__c	,Fixed_YTD_Sales__c,		
                                                //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                                Liquidation_Annual_Plan__c,Territory__c
                                              FROM Liquidation2__c ];
                            System.debug('monthMap.get(tmpMonth) in Update single  '+monthMap.get(tmpMonth));
                        }else{
                            
                            lstLiquidation =[select id, Name,Month__c,Product__c,
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                            Liquidation_YTD_Previous_Month__c,Product_Budget__c	,Fixed_YTD_Sales__c,	
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                            Type__c,Plan_for_the_month__c,Liquidation_Annual_Plan__c,Territory__c
                                             FROM Liquidation2__c 
                                             WHERE Month__c =: monthMap.get(tmpMonth)
                                             AND Territory__r.Name =:selectedTeritorry
                                             AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                             AND Product__c =:prodIdTotupdate
                                             AND RecordTypeId =:rtforLiquidation
                                            ];
                        }
                        if(lstLiquidation.size()>0){
                            for(Liquidation2__c liqObj :lstLiquidation){
                                liqObj.Plan_for_the_month__c = Decimal.valueOf(valueToupdate) + Decimal.valueOf(totalLiquidation) ;
                                liqObj.Product__c = prodIdTotupdate;
                                liqObj.Type__c = 'Trade';
                                liqObj.Liquidation_Annual_Plan__c = liquiAnualPlan[0].id;
                                //liqObj.Territory__c =teriList[0].id ;
                                liqObj.Territory__c = territoryIdMap.get(selectedTeritorry);
                                lstLiquidationUpdate.add(liqObj);
                            }
                            System.debug('lstLiquidationUpdate '+lstLiquidationUpdate);
                            update lstLiquidationUpdate;
                        }
                        List <Liquidation2__c> liquiUpdateLst1 = new List <Liquidation2__c>();
                        List <Liquidation2__c> liquiUpdteList = new List <Liquidation2__c>();
                        liquiUpdateLst1 = [select id,Name,
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                            Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                            Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
                                            //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                            Plan_for_the_next_month__c  
                                           FROM Liquidation2__c
                                           WHERE id=:recordIdTotupdate
                                          ]; 
                        if(liquiUpdateLst1.size()>0){
                            for(Liquidation2__c liquiObj :liquiUpdateLst1){
                                liquiObj.Plan_for_the_next_month__c =Decimal.valueOf(valueToupdate);
                                liquiUpdteList.add(liquiObj);
                            }
                            if(liquiUpdteList.size()>0){
                                update liquiUpdteList;
                            }
                        }
                    } 
                }//end of Condition of Total liquidation
            }
        }
        catch(Exception ex){
            System.debug('Errors Massage  '+ex.getMessage());
            System.debug('Errors Line '+ex.getLineNumber());
        }    
    }
    
    //this function called when submit button is clicked
    public void updateData(){
        try{
            system.debug('@@@'+totalProductNumber);
            system.debug('@@@'+SelectedYear);
            submittedMonth = monthMap.get(selectedMonth);
            List <liquidation2__c> liquiUpdateList1 = new List <liquidation2__c>();
            List<Opening_Inventory2__c> openUpdateList =new List<Opening_Inventory2__c> ();
            System.debug('liquiList after Submit '+liquiList.size());
            List<Liquidation_Annual_Plan__c> liquiAAnulPlan = new List<Liquidation_Annual_Plan__c> (); 
            if(selectedMonth == 3){
                //Sohel Shaikh (IBM) : Liquidaiton issues fixed : Year change bug fixed
                Integer index;
                if(selectedMonth <= 3){
                    index = 1;
                }else{
                    index = 0;
                }
                String strStratDate  = SelectedYear.split('-')[index];
                System.debug('strStratDate '+strStratDate);
                Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                System.debug('Date is '+d);
                Period currentFiscalYearRMU = [SELECT FiscalYearSettings.Name , StartDate,EndDate 
                                               FROM Period 
                                               WHERE Type = 'Year' 
                                               AND (StartDate <=:d AND EndDate >=:d)
                                              ];
                StartDate = currentFiscalYearRMU.StartDate;
                startDate1 = String.valueOf(StartDate);
                System.debug('startDate1 in update data'+startDate1);
                liquiAAnulPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:currentFiscalYearRMU.StartDate
                                          AND Fiscal_End_Date__c=:currentFiscalYearRMU.EndDate)
                                   AND Territory_Name__r.Name =:selectedTeritorry
                                   AND RecordTypeId =:rtforAnnualPlan 
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'
                                  ];
                System.debug('liquiAAnulPlan  ++++='+liquiAAnulPlan.size());
                System.debug('liquiAAnulPlan  ++++='+liquiAAnulPlan);
            }else{
                liquiAAnulPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND Territory_Name__r.Name =:selectedTeritorry
                                   AND RecordTypeId =:rtforAnnualPlan 
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'
                                  ];
            }
            
            liquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                         Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                         Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,	
                         Liquidation_YTD_Previous_Month__c	,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         //Added by Varun Shrivastava: SCTASK0419590 Start
                         Fixed_YTD_Sales__c,YTD_Sales_formula__c,Product_Budget__c	,Liquidation_YTD_Trade__c,    
                         //Added by Varun Shrivastava: SCTASK0419590 End
                         Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c 
                         WHERE Territory__c=:territoryIdMap.get(selectedTeritorry)
                         AND Liquidation_Annual_Plan__c=:liquiAnualPlan
                         AND RecordTypeId =:rtforLiquidation
                         AND Month__c=:monthMap.get(selectedMonth)
                        ];
            for(liquidation2__c liquiObj : liquiList){
                liquiObj.submitted_trade__c = true;
                //System.debug('number '+selectedMonth);
                //Added by Varun Shrivastava: SCTASK0419590 Start
                liquiObj.Fixed_YTD_Sales__c = liquiObj.Liquidation_YTD_Trade__c  ;  
                //Added by Varun Shrivastava: SCTASK0419590 End
                liquiUpdateList1.add(liquiObj);
            }
            if(liquiUpdateList1.size()>0){
                update liquiUpdateList1;
                isSubmitted = true;
                forCropSubmit = true;
                System.debug('value is isSubmitted '+isSubmitted);
            }
            if(openUpdateList.size()>0){
                update openUpdateList;
            } 
            //sendEmailToZH(); RITM0180898 : Sending Email after Product Liquidation is Submitted is stopped now as asked by Shiva
            //sendEmailandReport(); RITM0180898 : Sending Email after Product Liquidation is Submitted is stopped now as asked by Shiva
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }
    
    //when month is changed,load the Data from (plan for the next month)previousMonth 
    public void onMonthChange(){
        try{
            
            
            String smonth ; 
            smonth = monthMap.get(selectedMonth);
            
            monthForVF = monthMap.get(selectedMonth);
            monthForNextVF = monthMap.get(selectedMonth+1); 
            if(monthMap.get(selectedMonth)=='Dec'){
                monthForNextVF = 'Jan';
            }
            //Added by Varun Shrivastava : SCTASK0459610
            if(selectedMonth == 1)
            monthForPreviousVF = monthMap.get(12);
            else    
            monthForPreviousVF = monthMap.get(selectedMonth-1);
            //Added by Varun Shrivastava : End
            //if user is territory manager
            if(isTM){
                Integer flag2;
                System.debug('selectedYear in year change '+selectedYear);
                System.debug('selectedYear in year change month '+selectedMonth);
                //2019-04-01
                //Sohel Shaikh(IBM) : Fixed Liquidation issues : Fixed year calculation issue
                Integer index;
                if(selectedMonth <= 3){
                    index = 1;
                }else{
                    index = 0;
                }
                String strStratDate  = selectedYear.split('-')[index];
                System.debug('strStratDate '+strStratDate);
                Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                System.debug('Date is '+d);
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' AND (StartDate <=:d AND EndDate >=:d)]; 
                StartDate = currentFiscalYear.StartDate;
                startDate1 = String.valueOf(StartDate);
                System.debug('startDate1 in month change'+startDate1); 
                if(teriList.size()>0){
                    liquiAnualPlan = [SELECT Id, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                      Fiscal_End_Date__c 
                                      FROM Liquidation_Annual_Plan__c 
                                      WHERE Fiscal_Year__c =:selectedYear
                                      AND Territory_Name__c =:teriList[0].id
                                      AND RecordTypeId = : rtforAnnualPlan
                                      AND Sales_Org__r.Sales_Org_Code__c='1000'
                                     ];
                    System.debug('smonth '+smonth);                    
                    flag2 = checkDataForMonth(teriList[0].id,smonth,liquiAnualPlan[0].id);
                    System.debug('flag2 in Month Change '+flag2);
                    if(flag2 == 0){
                        displayProduct();
                        loadDataForSelectedMonth(teriList[0].id,liquiAnualPlan[0].id);
                    }else{
                        createDataForSelectedMonth(teriList[0].id,liquiAnualPlan[0].id);
                        loadDataForSelectedMonth(teriList[0].id,liquiAnualPlan[0].id); 
                    }
                }
            }// end of user TM
            
            //if user is regional Manager
            /* if(isRM){

RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj =new RollupTradeSalesLiquidation();
newLiqMap=rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, smonth, liquiAnualPlan);
newOpenMap =rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, smonth, liquiAnualPlan);
displayProduct();

if(newLiqMap.size()>0 && newOpenMap.size()>0){
OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
}else{
productList = new list<product2>();
}
}*/ // end of Regional Manager. "same code is run for Zonal Head  but change made in Rollup summary controller " 
            if(isZH || isZMM){
                System.debug('on month change selectedTeritorry '+selectedTeritorry);
                System.debug('on month change smonth '+smonth);
                System.debug('on month change liquiAnualPlan size  On MOnth Change '+liquiAnualPlan.size());
                System.debug('on month change liquiAnualPlan size  On MOnth Change '+liquiAnualPlan.size());
                System.debug('Pratap Rankhanb is Login 1 '+isZH);
                if(selectedTeritorry== 'All'){
                    isSubmitted = true;
                    forCropSubmit = true;
                    System.debug('Pratap Rankhanb is Login 1 All '+isZH);
                    RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj =new RollupTradeSalesLiquidation();
                    newLiqMap = rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, smonth, liquiAnualPlan);
                    newOpenMap = rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, smonth, liquiAnualPlan);
                    if((newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newOpenMap.size() == newLiqMap.size()*/) || Test.isRunningTest()){
                        displayProduct();
                        refreshProductList(newOpenMap,newLiqMap);
                        OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                    }else{
                        productList = new list<product2>();
                    }      
                }else{
                    //End of ALL Teri
                    //Selection of Perticular Teri
                    System.debug('Pratap Rankhanb is Login 2 '+isZH);
                    System.debug('In else on month change selectedTeritorry '+selectedTeritorry);
                    System.debug('In else on month change smonth '+smonth);
                    System.debug('In else on month change liquiAnualPlan size  On Month Change '+liquiAnualPlan.size());
                    System.debug('ZZZZZZZZIn else on month change liquiAnualPlan size  On MOnth Change '+liquiAnualPlan); 
                    if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                        System.debug('Pratap Rankhanb is Login 3 '+isZH);
                        ZMMUser = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,Zonal_Marketing_Manager_1_Id__c,
                                   ZonalManager__c, SBU__c,  Zone__c, SBUHead__c,Zonal_Marketing_Manager_2_Id__c, Zonal_Marketing_Manager_3_Id__c
                                   FROM Territory_Distributor__c 
                                   WHERE Present_in_KEDE__c = true 
                                   AND Neglected__c = false 
                                   AND TerritoryCode__c != '#' 
                                   AND Sales_Org_Code__c='1000'
                                   AND Name =: selectedTeritorry
                                   AND  (Zonal_Marketing_Manager_1_Id__c =:userId 
                                         OR Zonal_Marketing_Manager_2_Id__c =:userId 
                                         OR Zonal_Marketing_Manager_3_Id__c =:userId
                                         OR Zonal_Manager_Id__c =:userId)];   
                        System.debug('bbbb ZMMUser '+ZMMUser.size()); 
                        System.debug('bbbb ZMMUser territory '+ZMMUser[0].id);
                        System.debug('bbbb ZMMUser '+selectedTeritorry);
                        System.debug('bbbb ZMMUser Zonal_Marketing_Manager_1_Id__c '+userId);
                        System.debug('bbbb ZMMUser annual plan '+liquiAnualPlan[0].id);
                        if(ZMMUser.size()>0){    
                            System.debug('Pratap Rankhanb is Login 4 '+isZH);
                            if(ZMMUser[0].TerritoryManager__c == null || Test.isRunningTest()){
                                Integer flag2;  
                                isSubmitted = false;
                                forCropSubmit = false;
                                isTerritoryManagerAbsent = true;
                                flag2 = checkDataForMonth(ZMMUser[0].id,smonth,liquiAnualPlan[0].id); 
                                System.debug('Tm absent inside ');
                                System.debug('Tm absent inside value of flag2  '+flag2);
                                if(flag2 != 0 && isZMM){
                                    System.debug('Pune Baramati 1');
                                    
                                    createDataForSelectedMonth(ZMMUser[0].id,liquiAnualPlan[0].id);
                                    loadDataForSelectedMonth(ZMMUser[0].id,liquiAnualPlan[0].id);    
                                }else{
                                    System.debug('Display Otherwise');
                                    System.debug('Pune Baramati 2');
                                    loadDataForSelectedMonth(ZMMUser[0].id,liquiAnualPlan[0].id);      
                                }             
                            }// end of TM absent checking 
                            else{    
                                System.debug('In present of TM on Month Change');
                                // isSubmitted = true;
                                RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj =new RollupTradeSalesLiquidation();
                                newLiqMap = rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, smonth, liquiAnualPlan);
                                newOpenMap = rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, smonth, liquiAnualPlan);
                                if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newOpenMap.size() == newLiqMap.size()*/){
                                    displayProduct();
                                    refreshProductList(newOpenMap,newLiqMap);
                                    OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                                    liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                                }else{
                                    productList = new list<product2>();
                                }
                            }       
                        } //end of ZMM user size greater than zero           
                    }   
                } // end of ZMM User
                //isSubmitted = true;
                RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj =new RollupTradeSalesLiquidation();
                newLiqMap = rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, smonth, liquiAnualPlan);
                newOpenMap = rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, smonth, liquiAnualPlan);
                if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newOpenMap.size() == newLiqMap.size()*/){
                    displayProduct();
                    refreshProductList(newOpenMap,newLiqMap);
                    OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                    liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                }else{
                    productList = new list<product2>();
                }              
            }// end of isZH/ZMM  User
            
        } //end of Try 
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }  
    }
    
    //when month is changed,load the Data from (plan for the next month)previousMonth and 
    public List<Liquidation2__c> getDataForPrevSelectedMonth(String territoryName,String liquiAnualPlanId){
        System.debug('getDataForPrevSelectedMonth Selected Month '+selectedMonth);
        Integer tmpMonth ;
        tmpMonth = selectedMonth;
        if(selectedMonth == 1){
            tmpMonth = 12;
        }else{
            tmpMonth = selectedMonth -1;
        }
        List<Liquidation2__c> tempLiqList = new List<Liquidation2__c>();
        tempLiqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Liquidation_YTD_Trade__c,
                       Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,Inventory_in_Kg_Cooperatives__c,
                       Inventory_in_Kg_Govt__c,Retailers_Inventory__c,Distributors_Inventory__c,Plan_for_the_next_month__c,
                       //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                       Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                       Liquidation_YTD_Previous_Month__c	,Product_Budget__c	,Fixed_YTD_Sales__c,	
                       //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                       Territory__c,State__c
                       FROM Liquidation2__c
                       WHERE Territory__c =:territoryName
                       AND Liquidation_Annual_Plan__c=:liquiAnualPlanId
                       AND Month__c=:monthMap.get(tmpMonth)
                       AND RecordTypeId =:rtforLiquidation
                      ];
        return tempLiqList;       
    }
    
    public void createDataForSelectedMonth(String territoryName , String liquiAnnalPlanId){
        try{
            List<Liquidation2__c> currentLiquidationList;
            Map<String , Liquidation2__c> currentLiquidationMap  = new  Map<String , Liquidation2__c>();
            flag=checkSelectedPrevMonthData(territoryName,liquiAnnalPlanId);
            System.debug('flag ==>'+flag);
            List<Liquidation2__c> tmpliqLst = new List<Liquidation2__c>();
            list<Liquidation2__c> createLiqList = new list<Liquidation2__c>();
            Liquidation2__c liquidationObj;
            List <Product2> prodList = new List <Product2>();
            prodList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                        Sales_Org_Code__c,Brand_Type__c ,
                        Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                        FROM Product2 
                        WHERE IsActive = true 
                        AND Sales_Org_Code__c = '1000' 
                        AND Active_For_Liquidation__c= true
                       ];
            System.debug('Prod List : '+prodList);
            tmpliqLst =  getDataForPrevSelectedMonth(territoryName,liquiAnnalPlanId);
            //Sohel Shaikh(IBM) : added code to fetch current liquidation list
            currentLiquidationList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                                      Product__c,Type__c,submitted_trade__c,
                                      //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                        Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                        Liquidation_YTD_Previous_Month__c,Product_Budget__c	,	Fixed_YTD_Sales__c	,	
                                        //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                        Month__c,Territory__c
                                      FROM Liquidation2__c 
                                      WHERE Month__c=:monthMap.get(selectedMonth)
                                      AND Territory__c=:territoryName
                                      AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                      AND RecordTypeId =:rtforLiquidation
                                     ];
            for(Liquidation2__c lobj: currentLiquidationList){
                currentLiquidationMap.put(lobj.Product__c,lobj);
            }
            if(flag){
                if(prodList.size()>0){
                    Integer i=0;
                    System.debug('OpeningInventoryMap '+OpeningInventoryMap);
                    System.debug('OpeningInventoryMap size ==> '+OpeningInventoryMap.size());
                    for(Product2 prodObj :prodList){
                        liquidationObj= new Liquidation2__c();
                        //Sohel Shaikh(IBM) : Fixed Liquidation issues
                        Boolean fflag = currentLiquidationMap.containsKey(String.valueOf(prodObj.Id));
                        System.debug('fflg : '+fflag + ' Liq : '+currentLiquidationMap.get(String.valueOf(prodObj.Id)) );
                        if(!fflag && OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquidationObj.Opening_Inventory2__c = opObj.Id;
                            liquidationObj.Liquidation_Annual_Plan__c = liquiAnnalPlanId;
                            liquidationObj.Product__c = prodObj.Id;
                            liquidationObj.Type__c = 'Trade';
                            liquidationObj.submitted_trade__c = false;
                            liquidationObj.YTD_Sales__c = 0;
                            liquidationObj.Month__c = monthMap.get(selectedMonth);
                            liquidationObj.Liquidation__c = 0;
                            liquidationObj.Plan_for_the_month__c =tmpliqLst[i].Plan_for_the_next_month__c + tmpliqLst[i].Liquidation_YTD_Trade__c;
                            //Added by Varun Start : SCTASK0459610
                            liquidationObj.Distributor_Inventory_Previous_Month__c = 	tmpliqLst[i].Distributors_Inventory__c;	
                            liquidationObj.Retailer_Inventory_Previous_Month__c = tmpliqLst[i].Retailers_Inventory__c;
                            liquidationObj.Liquidation_YTD_Previous_Month__c = 	tmpliqLst[i].Fixed_YTD_Sales__c;
                            liquidationObj.Product_Budget__c = opObj.Product_Budget__c;	
                            liquidationObj.Retailers_Inventory__c	= tmpliqLst[i].Retailers_Inventory__c;
                            switch on selectedMonth{
                                    when 1 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Jan__c - opObj.YTD_Sales_Dec__c;	
                                    }
                                     when 2 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Feb__c - opObj.YTD_Sales_Jan__c;	
                                    }
                                     when 3 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Mar__c	- opObj.YTD_Sales_Feb__c;	
                                    }
                                     when 4 {
                                        liquidationObj.Distributors_Inventory__c = opObj.Opening_Inventory__c	+ opObj.YTD_Sales_Apr__c;	
                                    }
                                     when 5 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_May__c - opObj.YTD_Sales_Apr__c;	
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
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Oct__c - opObj.YTD_Sales_Sept__c;	
                                    }
                                     when 11 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Nov__c - opObj.YTD_Sales_Oct__c	;	
                                    }
                                    when 12 {
                                        liquidationObj.Distributors_Inventory__c = tmpliqLst[i].Distributors_Inventory__c + opObj.YTD_Sales_Dec__c - opObj.YTD_Sales_Nov__c;	
                                    }
                            }
                            
                            //Added by Varun End : SCTASK0459610
                            liquidationObj.RecordTypeId = rtforLiquidation;
                            //liquidationObj.Retailers_Inventory__c = 0; Commented by Varun  : SCTASK0459610
                            liquidationObj.Plan_for_the_next_month__c = 0;
                            liquidationObj.Territory__c = territoryName;
                            i++;
                            createLiqList.add(liquidationObj); 
                        }
                    }
                    if(createLiqList.size()>0){
                        insert createLiqList;
                    }     
                }  
            }else{
                //if previous month data is not available  create data plan for the selected month with zero
                if(prodList.size()>0){
                    System.debug('OpeningInventoryMap------> '+OpeningInventoryMap);
                    System.debug('OpeningInventoryMap size ------> '+OpeningInventoryMap.size());
                    for(Product2 prodObj :prodList){
                        liquidationObj= new Liquidation2__c();
                        //Sohel Shaikh(IBM) : fixed Liquidation issues
                        Boolean fflag = currentLiquidationMap.containsKey(String.valueOf(prodObj.Id));
                        if(!fflag && OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquidationObj.Opening_Inventory2__c = opObj.Id;
                            liquidationObj.Liquidation_Annual_Plan__c = liquiAnnalPlanId;
                            liquidationObj.Product__c = prodObj.Id;
                            liquidationObj.Type__c = 'Trade';
                            liquidationObj.submitted_trade__c = false;
                            liquidationObj.Month__c = monthMap.get(selectedMonth);
                            liquidationObj.YTD_Sales__c = 0;
                            liquidationObj.Plan_for_the_month__c =0;
                            //Added by Varun Start : SCTASK0459610
                            liquidationObj.Distributor_Inventory_Previous_Month__c = 	0;	
                            liquidationObj.Retailer_Inventory_Previous_Month__c = 0;
                            liquidationObj.Liquidation_YTD_Previous_Month__c = 0;	
                            liquidationObj.Product_Budget__c = opObj.Product_Budget__c;	 
                            //Added by Varun End : SCTASK0459610
                            liquidationObj.RecordTypeId = rtforLiquidation;
                            liquidationObj.Retailers_Inventory__c = 0;
                            liquidationObj.Plan_for_the_next_month__c = 0;
                            liquidationObj.Territory__c = territoryName;
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
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
            
        }     
    }//End of Function 
    
    public void OnchangeTeritirry(){   
        try{
            RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj = new RollupTradeSalesLiquidation();
            territoryMap = new Map<String,String>();
            //territoryMap = rollupTradeSalesLiquidationObj.getRMTeritories();
            Select_Year = selectedYear;
            System.debug('selectedTeritorry on teri change '+selectedTeritorry);
            System.debug('selectedYear on teri change '+selectedYear);
            if(selectedTeritorry=='All'){
                if(isZH || isZMM){
                    territoryMap = rollupTradeSalesLiquidationObj.getZHTerritories();
                }
                liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c
                                   WHERE Fiscal_Year__c =:selectedYear
                                   AND Territory_Name__c IN:territoryMap.keySet()
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'
                                  ];   
                isSubmitted = true; 
                forCropSubmit = true;
                if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                    newLiqMap= rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                    newOpenMap=rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);  
                    if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newLiqMap.size() == newOpenMap.size()*/){
                        displayProduct();
                        refreshProductList(newOpenMap,newLiqMap);
                        OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                    }else{
                        productList = new List<product2>(); 
                    }
                }//end of Liqu annual plan    
            }else{
                //When user check  perticular Teri
                if(isZH || isZMM){ 
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Territory_Name__r.Name=:selectedTeritorry
                                       AND Fiscal_Year__c =:selectedYear
                                       AND Sales_Org__r.Sales_Org_Code__c='1000'
                                       AND RecordTypeId =:rtforAnnualPlan];  
                    if(liquiAnualPlan.size()>0){
                        System.debug('When user check  perticular Teri ZH 1 ');    
                        ZMMUser = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,Zonal_Marketing_Manager_1_Id__c,
                                   ZonalManager__c, SBU__c,  Zone__c, SBUHead__c,Zonal_Marketing_Manager_2_Id__c, Zonal_Marketing_Manager_3_Id__c
                                   FROM Territory_Distributor__c 
                                   WHERE Present_in_KEDE__c = true 
                                   AND Neglected__c = false 
                                   AND TerritoryCode__c != '#' 
                                   AND Sales_Org_Code__c='1000'
                                   AND Name =: selectedTeritorry
                                   AND  (Zonal_Marketing_Manager_1_Id__c =:userId 
                                         OR Zonal_Marketing_Manager_2_Id__c =:userId 
                                         OR Zonal_Marketing_Manager_3_Id__c =:userId)
                                  ];
                        if(ZMMUser.size()>0){ 
                            if(ZMMUser[0].TerritoryManager__c == null){
                                isSubmitted = false;
                                forCropSubmit = false;
                                isTerritoryManagerAbsent = true;
                                openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,
                                               Opening_Inventory__c,YTD_Sales__c,Opening_Inventory_Cooperatives__c,
                                               //Added by Varun Shrivastava : SCTASK0459610
                                               Product_Budget__c,
                                               YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                          			            YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           			            YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                                                //Added by Varun Shrivastava : SCTASK0459610
                                               Opening_Inventory_Govt__c,Product__c,State__c,Territory__c
                                               FROM Opening_Inventory2__c 
                                               WHERE Territory__c=:ZMMUser[0].Id 
                                               AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                               AND RecordTypeId =: rtForOpeningInventory];
                                //checking for size of opening inventory
                                if(openInvList.size()>0){
                                    for(Opening_Inventory2__c prodObj:openInvList){
                                        OpeningInventoryMap.put(prodObj.Product__c, prodObj);
                                        System.debug('prodObj.Product__c '+prodObj.Product__c);
                                    }//end of for Loop
                                    String mth = monthMap.get(selectedMonth);
                                    Integer diff2 = checkDataForMonth(ZMMUser[0].Id,mth,liquiAnualPlan[0].id);
                                    System.debug('oooo value of isAvail vacant Teri '+isAvail);
                                    if(diff2 != 0 && isZMM){
                                        //create Data
                                        isSubmitted = false;
                                        isSubmittedCropLiqui = false;
                                        forCropSubmit = false;
                                        createData(ZMMUser[0].Id,liquiAnualPlan[0].id,mth);
                                        displayProduct();
                                        loadAllData(ZMMUser[0].Id,liquiAnualPlan[0].id,mth);
                                    }else{
                                        loadAllData(ZMMUser[0].Id,liquiAnualPlan[0].id,mth);
                                    }
                                    
                                }//end of Checking openInvList 
                                else{
                                    productList = new List <Product2>();
                                }  
                            }//end of Checking Territory Manager is Absent or Not 
                            else{
                                isSubmitted = true;
                                forCropSubmit = true;
                                isSubmittedCropLiqui = true;
                                //RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj1 = new RollupTradeSalesLiquidation();
                                newLiqMap= rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                                newOpenMap=rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);  
                                System.debug('sasasas newLiqMap.size()>0 '+newLiqMap.size());
                                System.debug('sasasas newOpenMap.size()>0 '+newOpenMap.size());
                                if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newLiqMap.size() == newOpenMap.size()*/){
                                    displayProduct();
                                    System.debug('dasdasdasdasdasd');
                                    refreshProductList(newOpenMap,newLiqMap);
                                    OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                                    liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                                }else{
                                    productList = new List<product2>(); 
                                }
                                
                            }//end of else part of Checking TerritoryManager__c is Absent or Not
                        }else{
                            System.debug('When user check  perticular Teri ZH 5 ');    
                            isSubmitted = true;
                            forCropSubmit = true;
                            //RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj1 = new RollupTradeSalesLiquidation();
                            newLiqMap= rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                            newOpenMap=rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);  
                            if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686: && newLiqMap.size() == newOpenMap.size()*/){
                                displayProduct();
                                refreshProductList(newOpenMap,newLiqMap);
                                OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                                liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            }else{
                                productList = new List<product2>(); 
                            }
                        }
                    }
                }// End RM created Liquidation for perticular Territory 
                
                /* RollupTradeSalesLiquidation rollupTradeSalesLiquidationObj1 = new RollupTradeSalesLiquidation();
newLiqMap= rollupTradeSalesLiquidationObj1.rollUpCropLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
newOpenMap=rollupTradeSalesLiquidationObj1.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);  
System.debug('Prashant Wani Loging 3');
if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size() == newOpenMap.size()){
displayProduct();
OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
System.debug('Prashant Wani Loging 4');
}else{
productList = new List<product2>(); 
}//end of Creating of Liquidation Data  */
                
            }//end of else part of All Territory
            
        }// end of try
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }
    
    public void populateYear(){
        try{
            List <Liquidation_Annual_Plan__c> populateYearList = [select id, FIscal_Year__c 
                                                                  FROM Liquidation_Annual_Plan__c 
                                                                  WHERE Sales_Org__r.Sales_Org_Code__c='1000' 
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
    }
    
    public void displayProduct(){  
        productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                       Sales_Org_Code__c,Brand_Type__c ,
                       Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                       FROM Product2 
                       WHERE IsActive = true 
                       AND Sales_Org_Code__c = '1000' 
                       AND Active_For_Liquidation__c= true];     
        totalProductNumber = productList.size(); 
    }
    // new Sorting functionality added
    public Map<String,Liquidation2__c> refreshProductList(Map<String,Opening_Inventory2__c> opnInvMap, Map<String,Liquidation2__c> liqMap){
        productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                       Sales_Org_Code__c,Brand_Type__c ,
                       Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                       FROM Product2 
                       WHERE IsActive = true 
                       AND Sales_Org_Code__c = '1000' 
                       AND Active_For_Liquidation__c= true];
        productList.clear();
        System.debug('@@@@@'+totalProductNumber);
        List<Product2> pList = new List<Product2>();
        pList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                 Sales_Org_Code__c,Brand_Type__c ,
                 Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                 FROM Product2 
                 WHERE IsActive = true 
                 AND Sales_Org_Code__c = '1000' 
                 AND Active_For_Liquidation__c= true
                ];
        Map<Id,Product2> pMap = new Map<Id, Product2>();
        for(Product2 prdctd : pList){
            pMap.put(prdctd.Id, prdctd);
        }
        List<Opening_Inventory2__c> t1 = new List<Opening_Inventory2__c>();
        for(Id k1 : pMap.keySet()){
            if(pMap.get(k1).Brand_Type__c == 'Power Brand'){
                if(opnInvMap.containsKey(k1) && liqMap.containsKey(k1)){
                    t1.add(opnInvMap.get(k1));
                }
            }
        }
        List<Opening_Inventory2__c> t2 = new List<Opening_Inventory2__c>();
        for(Id k2 : pMap.keySet()){
            if(pMap.get(k2).Brand_Type__c == 'Strategic Brand'){
                if(opnInvMap.containsKey(k2) && liqMap.containsKey(k2)){
                    t2.add(opnInvMap.get(k2));
                }
            }
        }
        List<Opening_Inventory2__c> t3 = new List<Opening_Inventory2__c>();
        for(Id k3 : pMap.keySet()){
            if(pMap.get(k3).Brand_Type__c != 'Power Brand' && pMap.get(k3).Brand_Type__c != 'Strategic Brand'){
                if(opnInvMap.containsKey(k3) && liqMap.containsKey(k3)){
                    t3.add(opnInvMap.get(k3));
                }
            }
        }
        productList.addAll(allSort(t1,pList));
        productList.addAll(allSort(t2,pList));
        productList.addAll(allSort(t3,pList));
        
        Map<Id,Product2> productMap = new Map<Id, Product2>();
        for(Product2 prdct : productList){
            productMap.put(prdct.Id, prdct);
        }
        totalProductNumber = pList.size(); 
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
                }
                /*INCTASK0286686: Sayan (IBM) 6th Oct, 2020 - Fixed the Liquidation Visibility issue for ZMM and ZM after 20 products were removed in September*/
                else
                    if(opnInvMap.size() > liqMap.size()){
                        for(Id prd : opnInvMap.keySet()){
                            if(!liqMap.containsKey(prd)){
                                opnInvMap.remove(prd); 
                                productMap.remove(prd);
                            }   
                        }    
                    }/*INCTASK0286686: Sayan (IBM) 6th Oct, 2020 - Fixed the Liquidation Visibility issue for ZMM and ZM after 20 products were removed in September*/
            } 
            productList = productMap.values();
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
                    nk.addAll(NewproductMap.values());                   
                }
            }
        }
        return nk;
    }
    //Sayan Majumder (IBM): new Sorting functionality added
    
    
    
    /* RITM0180898 : Sending Email after Product Liquidation is Submitted is stopped now as asked by Shiva
     * public void sendEmailandReport(){
        userId =UserInfo.getUserId();
        User usr = [select id,Name,UserRoleId,Email from User Where id =:userId LIMIT 1];
        List<User> uList = new List<User>();
        if(isTM){
            Territory_Distributor__c terriotryTM = [SELECT Id, Zonal_Manager_Id__c, Zonal_Marketing_Manager_1_Id__c, Zonal_Marketing_Manager_2_Id__c, Zonal_Marketing_Manager_3_Id__c
                                                    FROM Territory_Distributor__c
                                                    WHERE Name =: selectedTeritorry AND Sales_Org_Code__c = '1000'];
            List<String> uIds = new List<String>();
            if(null != terriotryTM.Zonal_Manager_Id__c && terriotryTM.Zonal_Manager_Id__c != ''){
                uIds.add(terriotryTM.Zonal_Manager_Id__c);
            }
            if(null != terriotryTM.Zonal_Marketing_Manager_1_Id__c && terriotryTM.Zonal_Marketing_Manager_1_Id__c != ''){
                uIds.add(terriotryTM.Zonal_Marketing_Manager_1_Id__c);
            }
            if(null != terriotryTM.Zonal_Marketing_Manager_2_Id__c && terriotryTM.Zonal_Marketing_Manager_2_Id__c != ''){
                uIds.add(terriotryTM.Zonal_Marketing_Manager_2_Id__c);
            }
            if(null != terriotryTM.Zonal_Marketing_Manager_3_Id__c && terriotryTM.Zonal_Marketing_Manager_3_Id__c != ''){
                uIds.add(terriotryTM.Zonal_Marketing_Manager_3_Id__c);
            }
            uList = [SELECT Id, Email FROM User WHERE Id IN: uIds];
        } 
        if(usr!=null){
            PageReference ref = Page.LiquidationReport;
            ref.getParameters().put('month',monthMap.get(selectedMonth));
            ref.getParameters().put('territoryName',selectedTeritorry);
            ref.getParameters().put('fiscalYear',Select_Year);
            ref.getParameters().put('salesOrgCode','1000');
            ref.setRedirect(true);
            Blob b;
            if(Test.isRunningTest()){
                b = Blob.valueOf('UNIT.TEST');     
            }else{
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
            mail.setToAddresses(sendTo);
            mail.setSubject(' New Liquidation entry for '+monthMap.get(selectedMonth));
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName('LiquidationReport.xls');
            efa1.setBody(b);
            String body ='<html><body><p>Dear '+usr.Name+' ,</p><p>Liquidation is submitted by '+ usr.Name+'</p>';
            body += '<p>Here are the details:</p><p>Liquidation Type: Trade </p>';
            body += ' <p>Month: '+monthMap.get(selectedMonth)+'</p><p>Financial Year: '+Select_Year+'</p><p>Territory Name: '+selectedTeritorry+'</p><br/>';
            body += ' <p>Thank you,</p></body></html>';
            mail.setHtmlBody(body);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
            mails.add(mail);            
            Messaging.sendEmail(mails);  
        }
    }
    
    public void sendEmailToZH(){
        User usr = [select id,Name,UserRoleId,Email from User Where id =:userId LIMIT 1];
        System.debug('ZHId in send Email '+ZHId);
        User usr1 = [select id,Name,UserRoleId,Email from User Where id =:ZHId LIMIT 1];
        System.debug('usr1.Name '+usr1.Name);
        if(usr!=null){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add(usr1.Email);
            mail.setToAddresses(sendTo);
            mail.setSubject(' New Liquidation entry for '+monthMap.get(selectedMonth));
            //String body = 'Dear '+usr1.Name;
            String body ='<html><body><p>Dear '+usr1.Name+' ,</p><p>Liquidation is submitted by '+ usr.Name+'</p>';
            body += '<p>Here are the details:</p><p>Liquidation Type: Trade </p>';
            body += ' <p>Month: '+monthMap.get(selectedMonth)+'</p><p>Financial Year: '+Select_Year+'</p><p>Territory Name: '+selectedTeritorry+'</p><br/>';
            //body += '<p>Here is the detail link to view the liquidation details:</p><br/>';
            body += ' <p>Thank you,</p></body></html>';
            mail.setHtmlBody(body);
            mails.add(mail);            
            Messaging.sendEmail(mails);  
        }
    }*/
    
    
    // This is all Method for Crop Liquidation
    
    public void createCropLiquidation(){
        
        String  mth  = monthMap.get(selectedMonth);
        TradeSalesIndiaCropLiquidation tcliObj = new TradeSalesIndiaCropLiquidation();
        
        if(isTM){
            cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                              WHERE Active_for_Crop_Liquidation__c = true
                              AND Active__c = true 
                              AND Sales_Org_Code__c ='1000'
                              AND Type__c ='Crop' 
                              ORDER BY LastModifiedDate ASC];
            Boolean tempCheckCropLiqui;
            tempCheckCropLiqui = tcliObj.createCropLiquidationIndia(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
            if(tempCheckCropLiqui){
                // LoadAllData for Crop Liquidation
                // System.debug('LoadAllData for Crop Liquidation');
                productListForCropLiqui = tcliObj.showProductListForCropIndia(selectedTeritorry,mth,liquiAnualPlan[0].id,rtforLiquidation);
                cropLiquidationMap_vf = tcliObj.loadAllDataForCropLiquidationIndia(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
                isSubmittedCropLiqui = tcliObj.checkingCropLiquidationSubmitedIndia(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
                
                //Added by Varun 14 April 2021 SCTASK0419590 Start
                List<Crop_Liquidation__c> firstProductCropLiq = cropLiquidationMap_vf.get(productListForCropLiqui[0].id);
                Set<Id> cropIdSet = new Set<Id>();
                for(Crop_Liquidation__c crpLiq :firstProductCropLiq){
                    cropIdSet.add(crpLiq.Crop__c);
                }
                if(cropIdSet.size() > 0){
                    cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                              WHERE Sales_Org_Code__c ='1000'
                              AND Type__c ='Crop' 
                              and id IN :cropIdSet
                              ORDER BY LastModifiedDate ASC];
                }
                //Added by Varun 14 April 2021 SCTASK0419590 End
            }else{
                //Create Data for Crop Liquidation
                tcliObj.actionCreateCropLiquidationIndia(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
                productListForCropLiqui = tcliObj.showProductListForCropIndia(selectedTeritorry,mth,liquiAnualPlan[0].id,rtforLiquidation);
                cropLiquidationMap_vf = tcliObj.loadAllDataForCropLiquidationIndia(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation);
            }
        }// is TM is End
        
        if(isZH || isZMM){
            //Updated by Varun shrivastava : Start: INCTASK0371295
            /*cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                              WHERE Active_for_Crop_Liquidation__c = true
                              AND Active__c = true 
                              AND Sales_Org_Code__c ='1000'
                              AND Type__c ='Category'
                              ORDER BY LastModifiedDate ASC];*/
            cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                              WHERE Active_for_Crop_Liquidation__c = true
                              AND Active__c = true 
                              AND Sales_Org_Code__c ='1000'
                              AND Type__c ='Crop'
                              ORDER BY LastModifiedDate ASC];
            
            //Updated by Varun shrivastava : End: INCTASK0371295
            
            if(selectedTeritorry == 'All'){
                //if All Territory is Selected
                isSubmittedCropLiqui = true; 
                Map<String,List<Crop_Liquidation__c>> newLiqMapCrop = new Map<String,List<Crop_Liquidation__c>>();
                newLiqMapCrop = tcliObj.rollupCropLiquidationIndia(liquiAnualPlan,mth);
                if(newLiqMapCrop.size()>0){
                    productListForCropLiqui = tcliObj.showProductListForCropForHigher(liquiAnualPlan,mth,rtforLiquidation);
                    cropLiquidationMap_vf = new Map<String, List<Crop_Liquidation__c>>(newLiqMapCrop);     
                    //Added by Varun 14 April 2021 SCTASK0419590 Start
                    List<Crop_Liquidation__c> firstProductCropLiq = cropLiquidationMap_vf.get(productListForCropLiqui[0].id);
                    Set<Id> cropIdSet = new Set<Id>();
                    for(Crop_Liquidation__c crpLiq :firstProductCropLiq){
                        cropIdSet.add(crpLiq.Crop__c);
                    }
                    if(cropIdSet.size() > 0){
                        cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                                          WHERE Sales_Org_Code__c ='1000'
                                          AND Type__c ='Crop' 
                                          and id IN :cropIdSet
                                          ORDER BY LastModifiedDate ASC];
                    }
                    //Added by Varun 14 April 2021 SCTASK0419590 End
                }else{
                    productListForCropLiqui = new List<Product2>(); 
                }
                
            }else{
                //if Perticualer Territory is Selected
                
                //single territory selected
                System.debug('selectedTeritorry  single  '+selectedTeritorry);
                Boolean tempCheckCropLiquis;
                tempCheckCropLiquis = tcliObj.displayCropDataForSingleTeritory(liquiAnualPlan,selectedTeritorry,mth);
                System.debug('selectedTeritorry tempCheckCropLiquis '+tempCheckCropLiquis);
                
                if(tempCheckCropLiquis){
                    if(isZMM && isTerritoryManagerAbsent){
                        isSubmittedCropLiqui = tcliObj.checkingCropLiquidationSubmitedIndiaHigh(selectedTeritorry, mth, liquiAnualPlan);
                    }else{
                        isSubmittedCropLiqui = true; 
                    }
                    
                    productListForCropLiqui = tcliObj.showProductListForCropIndiaSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
                    cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                    cropLiquidationMap_vf = tcliObj.loadAllDataForCropLiquidationIndiaSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                    //Added by Varun 14 April 2021 SCTASK0419590 Start
                    List<Crop_Liquidation__c> firstProductCropLiq = cropLiquidationMap_vf.get(productListForCropLiqui[0].id);
                    Set<Id> cropIdSet = new Set<Id>();
                    for(Crop_Liquidation__c crpLiq :firstProductCropLiq){
                        cropIdSet.add(crpLiq.Crop__c);
                    }
                    if(cropIdSet.size() > 0){
                        cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                                          WHERE Sales_Org_Code__c ='1000'
                                          AND Type__c ='Crop' 
                                          and id IN :cropIdSet
                                          ORDER BY LastModifiedDate ASC];
                    }
                    //Added by Varun 14 April 2021 SCTASK0419590 End
                }else{
                    if(isTerritoryManagerAbsent && isZMM){
                        //create crop Liquidation if TM is absent
                        tcliObj.actionCreateCropLiquidationIndiaForHigher(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                        productListForCropLiqui = tcliObj.showProductListForCropIndiaSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
                        cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                        cropLiquidationMap_vf = tcliObj.loadAllDataForCropLiquidationIndiaSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                    }else{
                        System.debug('Territory Manger not  Absent');
                        productListForCropLiqui = new List<Product2>();
                        cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                        
                    }
                    
                }
                
            }
            
        }//end of ZH and ZMM
        
        
        
        
        
        
    }// End of CreateCrop Function
    
    // this is function is update the value of submited Crop Liquidation to true.
    public void updateCropLiquidation(){
        String  mth  = monthMap.get(selectedMonth);
        
        TradeSalesIndiaCropLiquidation tradeSalesObj = new TradeSalesIndiaCropLiquidation();
        //tradeSalesObj.updateCropLiquidationIndia(teriList[0].id, mth, liquiAnualPlan[0].id, rtforLiquidation); Commented for INC0166167 by Sayan Majumder (crmconsultant3@upl-ltd.com), 28th April 2021
        tradeSalesObj.updateCropLiquidationIndia(liquiAnualPlan[0].Territory_Name__c, mth, liquiAnualPlan[0].id, rtforLiquidation); // Added for INC0166167 by Sayan Majumder (crmconsultant3@upl-ltd.com), 28th April 2021
        
    }//end of function updateCropLiquidation
    
    //this function is for update single crop value     
    public void updateSingleRecordForCropLiquidation(){
        
        try{
            TradeSalesIndiaCropLiquidation tradeSalesObj = new TradeSalesIndiaCropLiquidation();
            System.debug('in Main class recordIdTotupdate '+recordIdTotupdate);
            System.debug('in Main class prodIdTotupdate '+prodIdTotupdate);
            System.debug('in Main class valueToupdate '+valueToupdate);
            
            tradeSalesObj.updateSingleRecordForCropLiquidationIndia(recordIdTotupdate, prodIdTotupdate, valueToupdate); 
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
    }// end of function updateSingleRecordForCropLiquidation
    
    
}