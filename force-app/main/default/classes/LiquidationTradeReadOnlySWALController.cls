/*
* Name: LiquidationTradeReadOnlySWALController 
* Created On: 16 Apr 2020
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: Class is used for Liquidation of India only for ZH and Admin
* Object used: Product2, Liquidation2, Openinventtory2
*/


global class LiquidationTradeReadOnlySWALController {
    
    public Integer selectedMonth{get;set;} //
    public String startDate1 {get;set;}
    public Date StartDate {get;set;}
    public Date EndDate;
    public Integer totalProductNumber {get;set;} // for total number of Product list
    public Integer selectMonth {get;set;}
    public Integer totalLiquidation {get;set;}
    public String submittedMonth {get;set;}
    public String yearForVf {get;set;}
    
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
    public Boolean isAvail {get;set;} //flag for liquidation annual plan  for month is available or not
    public Boolean isSubmitted {get;set;} //after submitted disable the section.
    public Boolean isOpenInvLock {get;set;}
    public Boolean forupdate {get;set;}
    //Code fix for Liquidation module
    public Boolean isLiqSubmitted;
    
    
    
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
    
    public List<Crop__c> cropNameListvf {get;set;} 
    public List<Product2>productListForCropLiqui {get;set;}
    public Map<String,List<Crop_Liquidation__c>> cropLiquidationMap_vf {get;set;}
    
    //variable declaration of Boolean
    public Boolean isDataAvail; //Checking Data is avail previously or not.
    public Boolean flag;
    
    //Declaration for Date type
    private  Date Today;
    private String month; 
    public String ZHId;
    
    
    
    
    //variable declaration for Integer
    
    //variable declaration for List
    public  List<Liquidation_Annual_Plan__c> liquiAnualPlan{get;set;}//master data for current year selected teritory
    // private List<Opening_Inventory__c>openingInvList = new List<Opening_Inventory__c>(); 
    public List<TM_District_Tehsil_Mapping__c> userTehsilMapping;
    public List <Territory_Distributor__c> teriList {get;set;}
    public Boolean isSubmittedCropLiqui {get;set;} // this is used when crop Liquidation is Submitted./ not to edited
    public Boolean forCropSubmit{get;set;}
    
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
    
    
    public LiquidationTradeReadOnlySWALController(){
        try{
            selectedMonth = 0; 
            monthForVF = '';
            monthForNextVF = '';
            //Added by Varun Shrivastava: SCTASK0459610 start
            monthForPreviousVF ='';
            //Added by Varun Shrivastava: SCTASK0459610 End
    
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
            
            
            
            
            
            Today= System.today();
            
            selectedMonth = Today.month();
            
            if(selectedMonth == 1){
                selectedMonth = 12;
            }else{
                selectedMonth =selectedMonth-1;
            }
            
            
            
            
            totalLiquidation = 0;
            submittedMonth ='';
            
            yearForVf = '';
            //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
    		cropTosubCropMap = new Map<Id,List<Sub_Crops__c>>();
            liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>> ();
    		cropToSubCropSizeMap = new Map<Id,Integer>(); 
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
            teriList = new  List <Territory_Distributor__c> (); 
            teriListForUser1 =new List<Territory_Distributor__c>();
            teriListForUser2 =new List<Territory_Distributor__c>();
            teriListForUser3 =new List<Territory_Distributor__c>();
            teriListForUser4 =new List<Territory_Distributor__c>();
            teriListForUser5 = new List<Territory_Distributor__c>();
            ZMMLst = new List<Territory_Distributor__c>();
            cropNameListvf = new List<Crop__c>();
            productListForCropLiqui = new List<Product2>();
            cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>();
            isSubmittedCropLiqui = false;
            forCropSubmit = false;
            
            rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
            rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
            rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
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
            //Added by Varun Shrivastava : SCTASK0459610
            if(selectedMonth == 1)
            monthForPreviousVF = monthMap.get(12);
            else    
            monthForPreviousVF = monthMap.get(selectedMonth-1);
            //Added by Varun Shrivastava : End
            
            monthForVF = monthMap.get(selectedMonth);
            
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
           
            
            
            
            
            if(selectedMonth == 3){
                
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
            
            //Checking for Zonal Head
            teriListForUser3 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                                Zonal_Manager_Id__c,ZonalManager__c, SBU__c,  Zone__c, SBUHead__c 
                                FROM Territory_Distributor__c 
                                WHERE Present_in_KEDE__c = true 
                                AND Neglected__c = false 
                                AND TerritoryCode__c != '#' 
                                AND  Zonal_Manager_Id__c= :userId
                                AND Sales_Org_Code__c='1210'];
            
            if(teriListForUser3.size()>0){
                isZH = true;
                isSubmitted = true;
                forCropSubmit = true;
                
            }else{
                isZH = false;
            }//End of Checking for Zonal Head
            
            
            
            
            ZMMLst =[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,Zonal_Marketing_Manager_1_Id__c,
                     Zonal_Marketing_Manager_2_Id__c,Zonal_Marketing_Manager_3_Id__c,ZonalManager__c,
                     SBU_Head_Id__c, SBU__c,  Zone__c, SBUHead__c 
                     FROM Territory_Distributor__c 
                     WHERE Present_in_KEDE__c = true 
                     AND Neglected__c = false 
                     AND TerritoryCode__c != '#' 
                     AND Sales_Org_Code__c='1210'
                     AND (Zonal_Marketing_Manager_1_Id__c =:userId 
                          OR Zonal_Marketing_Manager_2_Id__c =:userId 
                          OR Zonal_Marketing_Manager_2_Id__c =:userId ) ];
            if(ZMMLst.size()>0){
                isZMM = true;
                isSubmitted = true;
            }else{
                isZMM = false;
            }
            
            /* User LoginUser =  [SELECT Id, Profile_Name__c, Profile.Name, Name, Territory__c, Region__c FROM User where Country='SWAL' AND id=:userId]; 

if(LoginUser.Profile.Name=='System Administrator' || LoginUser.Profile.Name=='CM Users'){
isAdmin = true;
isSubmitted = true;
System.debug('CM user is Login'); 
}else{
isAdmin = false;
productList = new List<product2>();                
}*/
            
            // Create patch for Admin like Trade liquidation for India.
            if(isZH == false && isZMM == false){
                isAdmin = true;
                forCropSubmit = true;
                isSubmitted = true;
                
            }else{
                isAdmin = false;
            }
            
            
            System.debug('is Admin '+isAdmin);
            
            
            //Start of Rollup summary for Zonal Head
            if(isZH || isZMM){
                forCropSubmit = true;
                RollUpZHAdminSwalCtrl RollupTradeSalesLiquidation_SWALObj =new RollUpZHAdminSwalCtrl();
                territoryMap = new Map<String,String>();
                territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                if(territoryMap.size()>0){
                    teritorynameList = territoryMap.values();
                    
                    if(selectedMonth == 3||test.isRunningTest() ){
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
            
            //Roll up of SBU 
            if(isAdmin){
                RollUpZHAdminSwalCtrl RollupTradeSalesLiquidation_SWALObj =new RollUpZHAdminSwalCtrl();
                territoryMap = new Map<String,String>();
                
                if(isAdmin){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getAdminTerritories();
                }
                
                if(territoryMap.size()>0){
                    teritorynameList = territoryMap.values();
                    
                    if(selectedMonth == 3){
                        
                        
                        String strStratDate  = Select_Year.split('-')[1];
                        
                        Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                        
                        
                        
                        Period currentFiscalYearSBU = [SELECT FiscalYearSettings.Name , StartDate,EndDate FROM Period WHERE Type = 'Year' AND (StartDate <=:d AND EndDate >=:d)];
                        
                        StartDate = currentFiscalYearSBU.StartDate;
                        startDate1 = String.valueOf(StartDate);
                        
                        
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYearSBU.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYearSBU.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210' ];
                    }else{
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYear.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYear.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1210' ];
                        
                    }
                    
                    
                    
                    
                    if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                        selectedTeritorry ='All';
                        newLiqMap = RollupTradeSalesLiquidation_SWALObj.rollUpLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                        newOpenMap = RollupTradeSalesLiquidation_SWALObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        
                        if(newLiqMap.size()>0 && newOpenMap.size()>0 /*&& newLiqMap.size() == newOpenMap.size() */|| Test.isRunningTest()){
                            liquidationMap_vf.clear();
                            OpeningInventoryMap_vf.clear();
                            displayProduct();
                            refreshProductList(newOpenMap,newLiqMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        }else{
                            ProductList = new List<Product2>();  
                        }
                        
                    }else{
                        ProductList = new List<Product2>();
                    }
                    
                }else{
                    productList = new List<Product2>();
                }
                
            }//end of Roll up of SBU
            
            
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getLineNumber());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
    }// End of Constructor
    
    
    
    // when year change
    public void onYearChange(){
        Select_Year = selectedYear;
        yearForVf = Select_Year;
        try{
            
            
            if(isZH || isAdmin || isZMM || Test.isRunningTest()){
                forCropSubmit = true;
                Select_Year = selectedYear;
                RollUpZHAdminSwalCtrl RollupTradeSalesLiquidation_SWALObj = new RollUpZHAdminSwalCtrl();
                territoryMap = new Map<String,String>();
                if(isZH || isZMM){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                }
                
                if(isAdmin){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getAdminTerritories();
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
                
                
                
                
                if(territoryMap.size()>0 || Test.isRunningTest()){
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
    
    
    //Start of loadForSelectedMonth
    public void loadDataForSelectedMonth(String territoryName , String liquiAnnalPlanId){
        try{
            liquiList = new List <Liquidation2__c>();
            liquiList = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Product__r.Name,
                         Type__c,submitted_Trade_SWAL__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                        Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                        Liquidation_YTD_Previous_Month__c,Product_Budget__c,  Fixed_YTD_Sales__c  ,  
                        //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
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
                    }
                    if(liqObj.submitted_Trade_SWAL__c == false){
                        isSubmitted = false;
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
        System.debug('Empty update updateSingleRecord');
    }
    //end of Update single Record    
    
    //this function called when submit button is clicked
    public void updateData(){
        
    }
    //end of update Data function
    
    //when month is changed,load the Data from (plan for the next month)previousMonth 
    public void onMonthChange(){
        try{
            String smonth ; 
            Select_Year = selectedYear;
            smonth = monthMap.get(selectedMonth);
            monthForVF = monthMap.get(selectedMonth);
            monthForNextVF = monthMap.get(selectedMonth+1);
            //Added by Varun Shrivastava : SCTASK0459610
            if(selectedMonth == 1)
            monthForPreviousVF = monthMap.get(12);
            else    
            monthForPreviousVF = monthMap.get(selectedMonth-1);
            //Added by Varun Shrivastava : End
            
            if(monthMap.get(selectedMonth)=='Dec'){monthForNextVF = 'Jan';}
            
            
            
            if(isZH || isAdmin || isZMM || Test.isRunningTest()){
                forCropSubmit = true;
                Select_Year = selectedYear;
                RollUpZHAdminSwalCtrl RollupTradeSalesLiquidation_SWALObj = new RollUpZHAdminSwalCtrl();
                territoryMap = new Map<String,String>();
                
                if(selectedTeritorry=='All'){
                    if(isZH || isZMM){
                        territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                    }
                    
                    if(isAdmin){
                        territoryMap = RollupTradeSalesLiquidation_SWALObj.getAdminTerritories();
                    }
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__c IN:territoryMap.keySet()
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1210'];
                }else{
                    
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__r.Name =:selectedTeritorry
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1210'];
                }
                
                
                    
                
                isSubmitted = true;
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
            RollUpZHAdminSwalCtrl RollupTradeSalesLiquidation_SWALObj =new RollUpZHAdminSwalCtrl();
            territoryMap = new Map<String,String>();
            
            Select_Year = selectedYear;
            
            if(selectedTeritorry=='All'){
                 if(isZH || isZMM ){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getZHTerritories();
                }
                
                if(isAdmin){
                    territoryMap = RollupTradeSalesLiquidation_SWALObj.getAdminTerritories();
                }
                 liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c
                                   WHERE Fiscal_Year__c =:selectedYear
                                   AND Territory_Name__c IN:territoryMap.keySet()
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1210'];
                
            }else{
                //this is else part if perticular territory is selected 
                liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c
                                   WHERE Fiscal_Year__c =:selectedYear
                                   AND Territory_Name__r.Name =: selectedTeritorry
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1210'];
            }
            
            	isSubmitted = true;
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
                
            } //end of try blcok
        
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }   
    }// end of function OnchangeTeritirry
    
    
    
    
    //Start of loadAllData function
    public void loadAllData(String territoryName, String liquiAnnualPlanId ,String mth){
        try{
            openInvList = new List<Opening_Inventory2__c>();
            liquiList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,submitted_Trade_SWAL__c,
                         Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                        Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                        Liquidation_YTD_Previous_Month__c,Product_Budget__c,  Fixed_YTD_Sales__c  ,  
                        //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                         Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c 
                         WHERE Territory__c=:territoryName 
                         AND Month__c=:mth
                         AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                         AND RecordTypeId =:rtforLiquidation];
            
            
            if(liquiList.size()>0){
                for(Liquidation2__c liqiObj :liquiList){
                    if( liqiObj.submitted_Trade_SWAL__c == true){
                        isSubmitted= true;
                    }
                }
            }else{
                productList = new list<product2>();
                totalProductNumber = 0;
            }
            OpeningInventoryMap.clear();
            openInvList = [SELECT id,Name,X15_days_lock__c,combination_key__c,Liquidation_Annual_Plan__c,Opening_Inventory__c,
                           YTD_Sales__c, Opening_Inventory_Cooperatives__c, Opening_Inventory_Govt__c,Product__c,
                           State__c,Territory__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                           YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                           //Added by Varun Shrivastava:SCTASK0459610
                           Product_Budget__c,
                           //Added by Varun Shrivastava:SCTASK0459610
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
                    if(openInvObj.X15_days_lock__c == false){
                        isOpenInvLock = false;
                    }
                    if(openInvObj.X15_days_lock__c == true){
                        isOpenInvLock = true;
                    }
                    OpeningInventoryMap.put(openInvObj.Product__c, openInvObj);
                    
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
            
            productList.clear();
            List<Product2> pList = new List<Product2>();
            pList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                     Sales_Org_Code__c,Brand_Type__c ,
                     Indication_Type__c,Budget_NRV__c,IsActive 
                     FROM Product2 
                     WHERE IsActive = true 
                     AND Sales_Org_Code__c = '1210' 
                     AND Active_For_Liquidation__c= true
                    ];
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
    
    
    
    //Methods of Crop Liquidation
    public void createCropLiquidation(){
        String  mth  = monthMap.get(selectedMonth);
        //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        Boolean isSubCropLiqCreated=false; 
        cropTosubCropMap = new Map<Id,List<Sub_Crops__c>>();
        liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>> ();
    	cropToSubCropSizeMap = new Map<Id,Integer>(); 
        cropLiquidationMap_vf= new Map<String, List<Crop_Liquidation__c>>();
        cropNameListvf = new List<Crop__c>();
        //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        
        SwalTradeIndiaCropLiquiZHAdmin TradeSalesObj = new SwalTradeIndiaCropLiquiZHAdmin();
        if(isZH || isAdmin){
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
               
                Boolean tempCheckCropLiquis;
                tempCheckCropLiquis = TradeSalesObj.displayCropDataForSingleTeritory(liquiAnualPlan,selectedTeritorry,mth);
                //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        		isSubCropLiqCreated = tempCheckCropLiquis;
        		//Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
        		
                if(tempCheckCropLiquis){
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
					//isSubmittedCropLiqui = true;
                    isSubmittedCropLiqui=TradeSalesObj.checkingCropLiquidationSubmited(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                    //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
					
                    productListForCropLiqui = TradeSalesObj.showProductListForCropSWALSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
                    cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                    cropLiquidationMap_vf = TradeSalesObj.loadAllDataForCropLiquidationSWALSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                }else{
                    productListForCropLiqui = new List<Product2>();
                    new Map<String,List<Crop_Liquidation__c>>();
                    
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
            }else
            {
                List<Sub_Crops__c> subCropList = new List<Sub_Crops__c>();
                subCropList.add(subCropRecord);
        		cropTosubCropMap.put(subCropRecord.Crop__c, subCropList); 
                cropToSubCropSizeMap.put(subCropRecord.Crop__c, 1);
            }
            
        }
        List<Sub_Crop_Liquidation__c> subCropLiqInsertList = new List<Sub_Crop_Liquidation__c>();
        //System.assert(false,'cropLiquidationMap_vf'+cropLiquidationMap_vf);
        if(cropLiquidationMap_vf.size() > 0){
                if(isZH || isAdmin){
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
        if(liquidationToSubCropLiqMap.size() == 0){
            productListForCropLiqui = new List<Product2>();
            cropLiquidationMap_vf= new Map<String, List<Crop_Liquidation__c>>();
        	liquidationToSubCropLiqMap = new Map<Id,List<Sub_Crop_Liquidation__c>> ();
		}
            
    }
    
    
    
    
}// End of class