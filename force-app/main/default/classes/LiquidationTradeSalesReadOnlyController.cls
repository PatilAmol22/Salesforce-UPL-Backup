/*
* Name: LiquidationTradeSalesReadOnlyController
* Created On: 15 Apr 2020
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: Class is used for Liquidation of India
* Object used: Product2, Liquidation2, Openinventtory2
Test Class :-LiquiSalesReadOnlyController_test 
*/


global class LiquidationTradeSalesReadOnlyController {
    
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
    public Boolean forCropSubmit{get;set;}
    
    
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
    public List<Crop__c> cropNameListvf {get;set;}
    public List<Product2>productListForCropLiqui {get;set;}
    public Map<String,List<Crop_Liquidation__c>> cropLiquidationMap_vf {get;set;}
    public Boolean isSubmittedCropLiqui {get;set;} // this is used when crop Liquidation is Submitted./ not to edited
    
    
    
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
    
    
    
    //constructor
    public LiquidationTradeSalesReadOnlyController(){
        try{
            String salesOrgCode = '1000';
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
            isSubmitted = true; //after submitted disable the section.
            isOpenInvLock = true;
            forupdate = false;
            isSubmittedCropLiqui = true;
            
            fieldTotupdate = '';
            recordIdTotupdate ='';
            valueToupdate ='';
            
            
            
            
            
            
            Today= System.today();
            
            if(Test.isRunningTest()){
                selectedMonth = 3;
            }else{
                selectedMonth = Today.month();
            }
            
            //INC-377463:Balasore territory liquidation showing zero:Modified by Deeksha Gupta
            territoryIdMap = new Map<String,Id>();
            for(Territory_Distributor__c  td : [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,    
                                                ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c     
                                                FROM Territory_Distributor__c     
                                                WHERE Present_in_KEDE__c = true     
                                                AND Neglected__c = false     
                                                AND TerritoryCode__c != '#'     
                                                AND Sales_Org_Code__c=:salesOrgCode]){    
                                                    territoryIdMap.put(td.Name,td.id);    
                                                }
     
            if(selectedMonth == 1){
                selectedMonth = 12;
            }else{
                selectedMonth =selectedMonth-1;
            }
            
            
            ZHId ='';
            totalLiquidation = 0;
            submittedMonth ='';
            
            yearForVf = '';
            
            
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
            
            teriList = new  List <Territory_Distributor__c> (); 
            teriListForUser1 =new List<Territory_Distributor__c>();
            teriListForUser2 =new List<Territory_Distributor__c>();
            teriListForUser3 =new List<Territory_Distributor__c>();
            teriListForUser4 =new List<Territory_Distributor__c>();
            teriListForUser5 = new List<Territory_Distributor__c>();
            ZMMUser = new List<Territory_Distributor__c>();
            cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>();
            productListForCropLiqui = new List<Product2>();
            
            
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
                           AND Sales_Org_Code__c = :salesOrgCode 
                           AND Active_For_Liquidation__c= true];
            
            totalProductNumber = productList.size();
            
            teriListForUser4 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                                ZonalManager__c, SBU__c,  Zone__c, SBUHead__c,SBU_Marketing_heads_Id__c 
                                FROM Territory_Distributor__c 
                                WHERE Present_in_KEDE__c = true 
                                AND Neglected__c = false 
                                AND TerritoryCode__c != '#' 
                                AND (SBU_Head_Id__c =:userId OR SBU_Marketing_heads_Id__c=:userId)
                                AND Sales_Org_Code__c=:salesOrgCode];
            
            
            
            
            
            if(teriListForUser4.size()>0){
                isSBU = true;
                forCropSubmit = true;
                isSubmitted = true;
            }else{
                
                isSBU = false;
            }
            
            System.debug('isSBU test class '+isSBU);
            
            if(isSBU == false){
                isAdmin = true;
                forCropSubmit = true;
            }else{
                isAdmin = false;
            }
            
            
            
            
            
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
            selectedYear = Select_Year;
            
            //Start of Rollup summary for Zonal Head
            
            
            
            //Roll up of SBU 
            if(isSBU || isAdmin){
                
                
                RollUpSBUAdminIndiaCtrl rollupTradeSalesLiquidationObj =new RollUpSBUAdminIndiaCtrl();
                territoryMap = new Map<String,String>();
                if(isSBU){
                    territoryMap = rollupTradeSalesLiquidationObj.getSBUTerritories();    
                }
                if(isAdmin){
                    territoryMap = rollupTradeSalesLiquidationObj.getAdminTerritories();  
                }
                
                
                
                if(territoryMap.size()>0){
                    teritorynameList = territoryMap.values();
                    system.debug('Sayan00 selectedMonth-->'+selectedMonth);
                    if(selectedMonth == 3){
                        Integer index;
                        if(selectedMonth <= 3){
                            index = 1;
                        }else{
                            index = 0;
                        }
                        String strStratDate  = selectedYear.split('-')[index];
                        Date d = Date.newInstance(Integer.valueOf(strStratDate), Integer.valueOf(selectedMonth), Integer.valueOf('01'));
                        Period currentFiscalYearSBU = [SELECT FiscalYearSettings.Name , StartDate,EndDate 
                                                       FROM Period 
                                                       WHERE Type = 'Year' AND (StartDate <=:d AND EndDate >=:d)
                                                      ];
                        StartDate = currentFiscalYearSBU.StartDate;
                        startDate1 = String.valueOf(StartDate);
                        
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYearSBU.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYearSBU.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode];
                    }else{
                        liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:currentFiscalYear.StartDate 
                                                  AND Fiscal_End_Date__c=:currentFiscalYear.EndDate) 
                                           AND Territory_Name__c IN:territoryMap.keySet()
                                           AND RecordTypeId =:rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode];
                    }
                    selectedTeritorry ='All';
                    if(liquiAnualPlan.size()>0 || test.isRunningTest()){
                        newLiqMap = rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                        newOpenMap = rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                        if((newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686 && newLiqMap.size()== newOpenMap.size()*/)  || test.isRunningTest()){
                            liquidationMap_vf.clear();
                            OpeningInventoryMap_vf.clear();
                            displayProduct();
                            refreshProductList(newOpenMap, newLiqMap);
                            liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        }else{
                            productList = new list<product2>();
                        }
                    }else{
                        productList = new list<product2>();
                    }
                }else{
                    productList = new list<product2>();
                }
            }//end of SBU
            
            
            
            
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
            
        }
        catch(Exception ex){
            System.debug('Error Mssage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    } //end of default Method
    
    // start of function on year change
    public void onYearChange(){
        try{
            String salesOrgCode = '1000';
            yearForVf = Select_Year;
            //if SBU is login
            if(isSBU || isAdmin){
                Select_Year = selectedYear;
                
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
                
                
                RollUpSBUAdminIndiaCtrl rollupTradeSalesLiquidationObj = new RollUpSBUAdminIndiaCtrl();
                territoryMap = new Map<String,String>();
                
                if(selectedTeritorry == 'All'){
                    if(isSBU){
                        territoryMap = rollupTradeSalesLiquidationObj.getSBUTerritories(); 
                    }
                    if(isAdmin){
                        territoryMap = rollupTradeSalesLiquidationObj.getAdminTerritories(); 
                    }
                    liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE FIscal_Year__c =: selectedYear
                                       AND Territory_Name__c IN:territoryMap.keySet()
                                       AND RecordTypeId = :rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode];
                    teritorynameList = territoryMap.values();
                    
                }else{
                    //if selected perticular teri
                    liquiAnualPlan  = [SELECT Id, FIscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c,Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE FIscal_Year__c =: selectedYear
                                       AND Territory_Name__r.Name =:selectedTeritorry
                                       AND RecordTypeId = :rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode];
                }
                
                
                Boolean dateFlag = validateSelectedFilters(selectedMonth,selectedYear);
                if(dateFlag && liquiAnualPlan.size()>0){
                    newLiqMap = rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                    newOpenMap = rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry,monthMap.get(selectedMonth),liquiAnualPlan);
                    
                    if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686 && newLiqMap.size()== newOpenMap.size()*/ || Test.isRunningTest()){
                        displayProduct();
                        refreshProductList(newOpenMap, newLiqMap);
                        liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                        OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap); 
                        
                    }else{
                        productList = new list<product2>();
                    }
                }//end of liquiAnualPlan checking
                else{
                    totalProductNumber = 0;
                    productList = new list<product2>();
                }
                
            }
            
        }
        catch(Exception ex){
            System.debug('Error Mssage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    }// end of function on year change 
    
    public void updateData(){
        System.debug('updateData ');
    }
    
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
                        if(Today.month()==4){
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
                            Liquidation_YTD_Previous_Month__c,Product_Budget__c,  Fixed_YTD_Sales__c  ,  
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
    //update single Record
    public void updateSingleRecord(){
        System.debug('updateSingleRecord ');
    }
    
    
    
    public void onMonthChange(){
        try{
            String salesOrgCode = '1000';
            RollUpSBUAdminIndiaCtrl rollupTradeSalesLiquidationObj = new RollUpSBUAdminIndiaCtrl();
            String smonth ; 
            territoryMap = new Map<String,String>();
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
            if(isSBU || isAdmin){
                if(selectedTeritorry == 'All'){
                    if(isSBU){
                        territoryMap = rollupTradeSalesLiquidationObj.getSBUTerritories();
                    }
                    if(isAdmin){
                        territoryMap = rollupTradeSalesLiquidationObj.getAdminTerritories();
                    }
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__c IN:territoryMap.keySet()
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode];
                }else{
                    //perticular territory is selected
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__r.Name =: selectedTeritorry
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode];
                    
                }
                
                isSubmitted = true;
                newLiqMap= rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, smonth, liquiAnualPlan);
                newOpenMap=rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, smonth, liquiAnualPlan);  
                if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686 && newLiqMap.size() == newOpenMap.size()*/){
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
            System.debug('Error Occure Messege '+ex.getMessage());
            System.debug('Error Occure Line Number  '+ex.getLineNumber());
        }
        
    }//end of function onMonthChange
    
    
    
    
    
    
    public void OnchangeTeritirry(){   
        try{
            String salesOrgCode = '1000';
            RollUpSBUAdminIndiaCtrl rollupTradeSalesLiquidationObj = new RollUpSBUAdminIndiaCtrl();
            territoryMap = new Map<String,String>();
            Select_Year = selectedYear;
            
            if(isSBU || isAdmin){
                if(selectedTeritorry == 'All'){
                    
                    if(isSBU){
                        territoryMap = rollupTradeSalesLiquidationObj.getSBUTerritories();
                    }
                    if(isAdmin){
                        territoryMap = rollupTradeSalesLiquidationObj.getAdminTerritories();
                    }
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Fiscal_Year__c =:selectedYear
                                       AND Territory_Name__c IN:territoryMap.keySet()
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode];
                    
                    
                    
                }else{
                    //perticuler teri selected 
                    liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c
                                       WHERE Territory_Name__r.Name=:selectedTeritorry
                                       AND Fiscal_Year__c =:selectedYear
                                       AND Sales_Org__r.Sales_Org_Code__c=:salesOrgCode
                                       AND RecordTypeId =:rtforAnnualPlan];
                    
                }
                
                
                isSubmitted = true;
                newLiqMap= rollupTradeSalesLiquidationObj.rollUpCropLiqdtnDetail(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);
                newOpenMap=rollupTradeSalesLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, monthMap.get(selectedMonth), liquiAnualPlan);  
                if(newLiqMap.size()>0 && newOpenMap.size()>0 /*INCTASK0286686 && newLiqMap.size() == newOpenMap.size()*/){
                    displayProduct();
                    refreshProductList(newOpenMap,newLiqMap);
                    OpeningInventoryMap_vf =new Map <String,Opening_Inventory2__c>(newOpenMap);
                    liquidationMap_vf = new Map<String, Liquidation2__c>(newLiqMap);
                }else{
                    productList = new List<product2>(); 
                }
                
            }
            
        }//end of try block
        catch(Exception ex){
            System.debug('Error Occure messege '+ex.getMessage());
            System.debug('Error Occure Line Number  '+ex.getLineNumber()); 
        }
        
    }//end of function OnchangeTeritirry
    
    public void populateYear(){
        try{
            String salesOrgCode = '1000';
            List <Liquidation_Annual_Plan__c> populateYearList = [select id, FIscal_Year__c 
                                                                  FROM Liquidation_Annual_Plan__c 
                                                                  WHERE Sales_Org__r.Sales_Org_Code__c=:salesOrgCode
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
    String salesOrgCode = '1000';
        productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                       Sales_Org_Code__c,Brand_Type__c ,
                       Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                       FROM Product2 
                       WHERE IsActive = true 
                       AND Sales_Org_Code__c =:salesOrgCode 
                       AND Active_For_Liquidation__c= true];     
        totalProductNumber = productList.size(); 
    }
    // new Sorting functionality added
    public Map<String,Liquidation2__c> refreshProductList(Map<String,Opening_Inventory2__c> opnInvMap, Map<String,Liquidation2__c> liqMap){
        String salesOrgCode = '1000';
        productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                       Sales_Org_Code__c,Brand_Type__c ,
                       Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                       FROM Product2 
                       WHERE IsActive = true 
                       AND Sales_Org_Code__c = :salesOrgCode 
                       AND Active_For_Liquidation__c= true];
        productList.clear();
        
        List<Product2> pList = new List<Product2>();
        pList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                 Sales_Org_Code__c,Brand_Type__c ,
                 Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                 FROM Product2 
                 WHERE IsActive = true 
                 AND Sales_Org_Code__c = :salesOrgCode  
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
    
    //This is for Crop Liquidation Methods
    public void createCropLiquidation(){
        String salesOrgCode = '1000';
        String  mth  = monthMap.get(selectedMonth);
        TradeIndiaCropLiquiSBUAdmin TradeObj = new TradeIndiaCropLiquiSBUAdmin();
        if(isSBU || isAdmin){
            System.debug('liquiAnualPlan in zh '+liquiAnualPlan);
            System.debug('liquiAnualPlan in zh Size  '+liquiAnualPlan.size());
            System.debug('Selected territory '+selectedTeritorry);
            System.debug('Month   '+mth);
            cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                              WHERE Active_for_Crop_Liquidation__c = true
                              AND Active__c = true 
                              AND Sales_Org_Code__c =:salesOrgCode
                              AND Type__c ='Crop' 
                              ORDER BY LastModifiedDate ASC];
            
            if(selectedTeritorry == 'All'){
                isSubmittedCropLiqui = true; 
                Map<String,List<Crop_Liquidation__c>> newLiqMapCrop = new Map<String,List<Crop_Liquidation__c>>();
                newLiqMapCrop = TradeObj.rollupCropLiquidationIndia(liquiAnualPlan, mth);
                if(newLiqMapCrop.size()>0){
                    productListForCropLiqui = TradeObj.showProductListForCropForHigher(liquiAnualPlan,mth,rtforLiquidation);
                    cropLiquidationMap_vf = new Map<String, List<Crop_Liquidation__c>>(newLiqMapCrop);     
                }else{
                    productListForCropLiqui = new List<Product2>(); 
                }
                
            }else{
                //perticular  terri selected
                System.debug('in single terii');
                
                Boolean tempCheckCropLiquis;
                tempCheckCropLiquis = TradeObj.displayCropDataForSingleTeritory(liquiAnualPlan,selectedTeritorry,mth);
                if(tempCheckCropLiquis){
                    isSubmittedCropLiqui = true;
                    productListForCropLiqui = TradeObj.showProductListForCropIndiaSelectTeri(selectedTeritorry,mth,liquiAnualPlan,rtforLiquidation);
                    cropLiquidationMap_vf = new Map<String,List<Crop_Liquidation__c>>(); 
                    cropLiquidationMap_vf = TradeObj.loadAllDataForCropLiquidationIndiaSelectTeri(selectedTeritorry, mth, liquiAnualPlan, rtforLiquidation);
                }else{
                    productListForCropLiqui = new list<Product2>();
                    cropLiquidationMap_vf = new Map<String, List<Crop_Liquidation__c>>();
                    
                }
                
                
            }
            
            
            
        }
        
        
        
    }
    
    
}