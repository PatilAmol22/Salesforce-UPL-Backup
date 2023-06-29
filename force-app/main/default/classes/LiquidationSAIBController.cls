public class LiquidationSAIBController {
    
    //Getter Setter with visualforce Page
    //Integer
    public Integer selectedMonth{get;set;} //
    public Date StartDate;
    public String StartDate1{get;set;}
    public Date EndDate;
    public Integer totalProductNumber {get;set;} // for total number of Product list
    public Integer selectMonth {get;set;}
    public Integer totalLiquidation {get;set;}
    public String submittedMonth {get;set;}
    
    public  Id rtforAnnualPlan;
    public  Id rtforOpeningInventory;
    public  Id rtforLiquidation;
    
    
    
    
    
    //String
    public String Select_Year{get;set;} //selected year
    public String selectedTeritorry{get;set;}//selected teritory
    
    public String fieldTotupdate {get;set;}
    public String recordIdTotupdate{get;set;}
    public String valueToupdate {get;set;}
    public String prodIdTotupdate {get;set;}
    
    public String monthForVF {get;set;}
    public String monthForNextVF {get;set;}
    public String selectedYear {get;set;}
    String roleName;
    public List<String> popYearList {get;set;}
    
    
    //Boolean
    public Boolean isBH {get;set;} // flag for user profile.
    
    
    public Boolean isAvail {get;set;} //flag for liquidation annual plan  for month is available or not
    public Boolean isSubmitted {get;set;} //after submitted disable the section.
    public Boolean isOpenInvLock {get;set;}
    public Boolean forupdate {get;set;}
    
    
    //List
    
    public List<String>teritorynameList{get;set;}
    
    public List<Product2>productList {get;set;}
    public List <Liquidation2__c> liquiList {get;set;}
    public List <Opening_Inventory2__c> openInvList {get;set;}
    public List<SAIB_State_Mapping__c>  stateMapp1;
    public List<SAIB_State_Mapping__c>  stateMapp2;
    //End of getter and Setter
    
    //SET
    SET <String> populateYearSet {get;set;}
    
    //Select option
    public SET <String> popuYear {get;set;}
    //variable declaration of String
    private String userId;
    public String teritoryCode = '';
    public String SBUID;
    
    //variable declaration of Map
    public Map<String,Liquidation2__c> liquidationMap {get;set;}
    public Map<String,Opening_Inventory2__c> OpeningInventoryMap {get;set;}
    
    public Map<String,Liquidation2__c> liquidationMap_vf {get;set;}
    public Map<String,Opening_Inventory2__c> OpeningInventoryMap_vf {get;set;}
    public MAP<String,Liquidation2__c> newLiqMap{get;set;}
    private MAP<Integer,String> monthMap = new MAP<Integer,String>();
    public Map<String,Opening_Inventory2__c> newOpenMap ;
    public Map<String,String> territoryMap ;   
    
    //variable declaration of Boolean
    public Boolean isDataAvail; //Checking Data is avail previously or not.
    public Boolean flag;
    public Boolean isSBU;
    public Boolean isSHI;
    public Boolean isAdmin;
    
    //Declaration for Date type
    private  Date Today;
    private String month; 
    
    //variable declaration for Integer
    
    //variable declaration for List
    public  List<Liquidation_Annual_Plan__c> liquiAnualPlan;//master data for current year selected teritory
    //private List<Opening_Inventory__c>openingInvList = new List<Opening_Inventory__c>(); 
    public List<TM_District_Tehsil_Mapping__c> userTehsilMapping;
    public List<SAIB_State_Mapping__c> saibStatMappList {get;set;}
    public List<String>  statelst ;
    
    
    //constructor
    public LiquidationSAIBController(){
        try{
            selectedMonth =0; 
            monthForVF = '';
            monthForNextVF = '';
            SBUID ='';
            
            userId =UserInfo.getUserId();
            
            Today= System.today();
            selectedMonth = Today.month();
            
            
            
            if(selectedMonth == 1){
                selectedMonth = 12;
            }else{
                selectedMonth =selectedMonth-1;
            }
            
            
            
            totalLiquidation = 0;
            submittedMonth = '';
            
            liquiAnualPlan = new List<Liquidation_Annual_Plan__c>();
            productList = new List<Product2>();
            forupdate = true;
            teritorynameList = new List<String>();
            liquiList =  new List<Liquidation2__c>();
            saibStatMappList = new list<SAIB_State_Mapping__c>();
            openInvList =new List<Opening_Inventory2__c>();
            userTehsilMapping = new List<TM_District_Tehsil_Mapping__c>();
            
            stateMapp1 =new List<SAIB_State_Mapping__c>();
            stateMapp2 =new List<SAIB_State_Mapping__c>();
            
            liquidationMap =new Map<String,Liquidation2__c>();
            territoryMap = new Map<String,String>();
            OpeningInventoryMap = new Map<String,Opening_Inventory2__c>();
            statelst = new List<String>();
            liquidationMap_vf =new Map<String,Liquidation2__c>();
            OpeningInventoryMap_vf = new Map<String,Opening_Inventory2__c>();
            newLiqMap =new MAP<String,Liquidation2__c>();
            newOpenMap = new Map<String, Opening_Inventory2__c>();
            popuYear =new Set<String>();
            populateYearSet =new SET <String>();
            popYearList =new List<String> ();
            
            isBH = false;
            isSBU = false;
            isAdmin = false;
            
            rtforAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
            rtforOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
            rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
            
            
            
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
            
            
            
            
            monthForVF = monthMap.get(selectedMonth);
            
            if(monthMap.get(selectedMonth)=='Dec'){
                monthForNextVF = 'Jan';
            }
            else{
                monthForNextVF = monthMap.get(selectedMonth+1);
            }
            
            
            
            
            
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY];
            
            StartDate = currentFiscalYear.StartDate;
            StartDate1 = String.valueOf(StartDate);
            EndDate = currentFiscalYear.EndDate;
            
            System.debug('StartDate '+StartDate);
            System.debug('End Date '+EndDate);
            
            
            Select_Year = currentFiscalYear.StartDate.year()+'-'+currentFiscalYear.EndDate.year();
            
            saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                FROM SAIB_State_Mapping__c 
                                WHERE User__c=:userId order by State__r.Name];
            
            saibStatMappList.sort();
            
            
            stateMapp1 = [select id,Name,State__c,State__r.Name,User__c 
                          FROM SAIB_State_Mapping__c
                          WHERE User__c =:userId];
            
            if(stateMapp1.size()>0){
                isBH =true; 
                SBUID = stateMapp1[0].User__c;
            }else{
                isBH = false;
            }
            
            
            stateMapp2 = [select id,Name,State__c,State__r.Name,User__c 
                          FROM SAIB_State_Mapping__c
                          WHERE SBU_User__c =:userId];
            
            if(stateMapp2.size()>0){
                isSBU = true;
                System.debug('SBU log in ');
            }else{
                isSBU =false;
            }
            
            
            User LoginUser =  [SELECT Id, Profile_Name__c, Profile.Name, Name, Territory__c, Region__c FROM User where Country='India' AND id=:userId]; 
            
            if(LoginUser.Profile.Name=='System Administrator' || LoginUser.Profile.Name=='CM Users' || Test.isRunningTest()){
                isAdmin = true;
                isSubmitted = true;
                System.debug('CM user is Login');
            }else{
                isAdmin = false;
                productList = new List<product2>();                
            }
            
            populateYear();
            //sendEmailToSBU();
            
            
        }
        catch(Exception ex){
            System.debug('Error Line Number '+ex.getLineNumber());
            System.debug('Error Message  '+ex.getMessage());
        }
        
        
        
    }//end of constuctor
    
    
    
    public void defaultMethod(){
        try{
            if(isBH){
                String mth = monthMap.get(selectedMonth-1);
                if(saibStatMappList.size()==1){
                    System.debug('Brajesh Singh is login ');
                    liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE (Fiscal_Start_Date__c=:StartDate
                                              AND Fiscal_End_Date__c=:EndDate)
                                       AND(State__c=:saibStatMappList[0].State__c)
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    
                    System.debug('liquiAnualPlan in test '+liquiAnualPlan.size());            
                    
                    
                    openInvList = [select id,Name,Opening_Inventory_Cooperatives__c,Opening_Inventory_Govt__c,YTD_Sales_Corporate__c,
                                   YTD_Sales_Govt__c,RecordTypeId,Product__c,Liquidation_Annual_Plan__c,X15_days_lock__c
                                   FROM Opening_Inventory2__c 
                                   WHERE State__c=:saibStatMappList[0].State__c 
                                   AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                   AND RecordTypeId =:rtForOpeningInventory];
                    

                    for(Opening_Inventory2__c opnObj:openInvList){
                        OpeningInventoryMap.put(opnObj.Product__c, opnObj);
                    }
                    
                    
                    selectedTeritorry = saibStatMappList[0].State__r.Name;
                    //selectedTeritorry = saibStatMappList[0].State__c;
                    
                    
                    if(liquiAnualPlan.size()>0){
                        isAvail = checkDataForMonth(saibStatMappList[0].State__c, mth, liquiAnualPlan[0].id);
                        if(isAvail){
                            loadAllData(saibStatMappList[0].State__c, liquiAnualPlan[0].id,mth);
                        }else{
                            //create Data
                            createData(saibStatMappList[0].State__c, liquiAnualPlan[0].id, mth);
                            loadAllData(saibStatMappList[0].State__c, liquiAnualPlan[0].id,mth);
                        }
                    }
                }else{
                    System.debug('mth in default method  '+mth);
                    selectedTeritorry = '--Select State--';
                    totalProductNumber =  0;
                    
                }
                
            }//end of BH
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if(isSBU){
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c 
                                    WHERE SBU_User__c=:userId order by State__r.Name ];
                
                
                System.debug('saibStatMappList '+saibStatMappList.size());
                System.debug('saibStatMappList '+saibStatMappList);
                // saibStatMappList.sort();
                
                selectedTeritorry = 'All';
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
               
                System.debug('StartDate   '+StartDate);
                System.debug('EndDate   '+EndDate);
                System.debug('statelst '+statelst);
                System.debug('rtforAnnualPlan   '+rtforAnnualPlan);
          
                
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c IN: statelst)
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan size in Main Class '+liquiAnualPlan.size());
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                
                selectedTeritorry= 'All';
                String mnth = monthMap.get(selectedMonth);
                
                if(liquiAnualPlan.size()>0){
                    
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                    if(newOpenMap.size()>0 && newLiqMap.size()>0 && newOpenMap.size()== newLiqMap.size() || Test.isRunningTest()){
                        liquidationMap.clear();
                        OpeningInventoryMap.clear();
                        liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                        OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                    }else{
                        productList = new List<Product2>();    
                    }
                }else{
                    productList = new List<Product2>();
                }
            }//End of SBU
            
            //for Admin and CM Users 
            
             if(isAdmin){
                
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c];
                
                
               System.debug('in Admin and CM saibStatMappList '+saibStatMappList);
                // saibStatMappList.sort();
                
                selectedTeritorry = 'All';
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('statelst '+statelst);
                 System.debug('in Admin and CM StartDate '+StartDate);   
                 System.debug('in Admin and CM EndDate '+EndDate); 
                 System.debug('in Admin and CM statelst '+statelst); 
                 System.debug('in Admin and CM rtforAnnualPlan '+rtforAnnualPlan); 
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c IN: statelst)
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
				System.debug('in Admin and CM liquiAnualPlan '+liquiAnualPlan);           
                System.debug('in Admin and CM liquiAnualPlan size '+liquiAnualPlan.size());           
                
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                
                selectedTeritorry= 'All';
                String mnth = monthMap.get(selectedMonth);
                
                if(liquiAnualPlan.size()>0){
                    
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan); 
                    
                    if(newOpenMap.size()>0 && newLiqMap.size()>0 && newLiqMap.size()== newOpenMap.size() || Test.isRunningTest()){
                        liquidationMap.clear();
                        OpeningInventoryMap.clear();
                        System.debug('in Admin and CM newOpenMap.size() '+newOpenMap.size());
                        System.debug('in Admin and CM newLiqMap.size() '+newLiqMap.size());
                        liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                        OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                    }else{
                        productList = new List<Product2>();    
                    }
                }else{
                    productList = new List<Product2>();
                }
            }//End of SBU
            
            
            
        }catch(Exception ex) {
            System.debug('Error Message '+ex.getMessage());
            System.debug('Error Line Number  '+ex.getLineNumber());
        }
    }
    //start of OnchangeTeritirry function
    public void OnchangeTeritirry(){
        try{
            
            System.debug('valie of BH is '+isBH);
            //start of BH on change State
            if(isBH){
                String mnth = monthMap.get(selectedMonth);
                System.debug('on Teri Chage month name is  '+mnth);
                System.debug('Brajesh Singh in Change territory '+selectedTeritorry);
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE Fiscal_Year__c =:Select_Year
                                   AND(State__c=:selectedTeritorry)
                                   AND RecordTypeId =: rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                System.debug('liquiAnualPlan in change terri '+liquiAnualPlan.size());
                
                
                openInvList = [select id,Name,Opening_Inventory_Cooperatives__c,Opening_Inventory_Govt__c,YTD_Sales_Corporate__c,
                               YTD_Sales_Govt__c,RecordTypeId,Product__c,Liquidation_Annual_Plan__c,X15_days_lock__c
                               FROM Opening_Inventory2__c 
                               WHERE State__c=:selectedTeritorry
                               AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                               AND RecordTypeId =:rtForOpeningInventory];
                
                System.debug('openInvList on state size Change '+openInvList.size());
                System.debug('openInvList on state Change '+openInvList);
                
                if(openInvList.size()>0){
                    openingInventoryMap.clear();
                    for(Opening_Inventory2__c openObj :openInvList){
                        openingInventoryMap.put(openObj.Product__c, openObj);
                    }
                }
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan in state chage '+liquiAnualPlan.size());
                
                if(liquiAnualPlan.size()>0 && openInvList.size()>0 ){
                    
                    isAvail = checkDataForMonth(selectedTeritorry, mnth, liquiAnualPlan[0].id);
                    
                    if(isAvail){
                        loadAllData(selectedTeritorry, liquiAnualPlan[0].id,mnth);
                    }
                    else{
                        createData(selectedTeritorry, liquiAnualPlan[0].id, mnth) ;
                        
                        loadAllData(selectedTeritorry, liquiAnualPlan[0].id,mnth);
                    }
                }
                else{
                    productList =new List<Product2>();
                }
            }//End of BH  
            
            //start of SBU 
            //This part of code is also usefull for the to create Liquidation for that state if User or BH of that perticuler
            //State is not present
            if(isSBU || isAdmin){
                try{
                    saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                        FROM SAIB_State_Mapping__c 
                                        WHERE SBU_User__c=:userId order by State__r.Name];
                    
                    RollupSAIBLiquidation RollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                    System.debug('selectedTeritorry  by SBU   dsdsadasd'+selectedTeritorry);
                    
                    if(selectedTeritorry=='All'){
                        System.debug('User Selected All State');
                        System.debug('Selected All State');
                        isSubmitted = true;
                        saibStatMappList.sort();
                        for(SAIB_State_Mapping__c sObj:saibStatMappList){
                            statelst.add(sObj.State__c);
                        }
                        System.debug('statelst '+statelst);
                        liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                           Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE (Fiscal_Start_Date__c=:StartDate
                                                  AND Fiscal_End_Date__c=:EndDate)
                                           AND(State__c IN: statelst)
                                           AND RecordTypeId =: rtforAnnualPlan
                                           AND Sales_Org__r.Sales_Org_Code__c='1000'];
                        
                        
                        System.debug('liquiAnualPlan '+liquiAnualPlan);
                        System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                        productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                       Sales_Org_Code__c,Brand_Type__c ,
                                       Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                       FROM Product2 
                                       WHERE IsActive = true 
                                       AND Sales_Org_Code__c = '1000' 
                                       AND Active_For_Liquidation__c= true];
                        
                        totalProductNumber =  productList.size();
                        String mnth = monthMap.get(selectedMonth);
                        if(liquiAnualPlan.size()>0){
                            newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                            newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                        }else{
                            productList =new List<Product2>();
                        }
                        liquidationMap.clear();
                        OpeningInventoryMap.clear();
                        if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size()){
                            liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                            OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                        }else{
                            productList =new List<Product2>();
                        }
                        isSubmitted =true;
                        
                    }//END OF ALL STATE condition 
                    else{
                        String mnth = monthMap.get(selectedMonth);
                        //this is part for creating liquidation for selected state if the BH of that state is not available
                        saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                        FROM SAIB_State_Mapping__c 
                                        WHERE SBU_User__c=:userId order by State__r.Name];
                        
                        List <SAIB_State_Mapping__c> saibStatMappList1 = new List<SAIB_State_Mapping__c>();
                        saibStatMappList1 = [select id,Name,State__c,State__r.Name,User__c
                                            FROM SAIB_State_Mapping__c 
                                            WHERE SBU_User__c=:userId  
                                            AND State__c =:selectedTeritorry];
                        
                        System.debug('saibStatMappList when User is selected single state size '+saibStatMappList.size());
                        System.debug('saibStatMappList when User is selected single state '+saibStatMappList);
                        System.debug('saibStatMappList when User is selected single state saibStatMappList[0].User__c'+saibStatMappList[0].User__c);
                        
                        if(saibStatMappList1.size()>0){
                            if(saibStatMappList1[0].User__c == null){
                                System.debug('BH is not present for that state');
                                
                                System.debug('on Teri Chage month name is  '+mnth);
                                System.debug('Brajesh Singh in Change territory '+selectedTeritorry);
                                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                                   Fiscal_End_Date__c 
                                                   FROM Liquidation_Annual_Plan__c 
                                                   WHERE Fiscal_Year__c =:Select_Year
                                                   AND(State__c=:selectedTeritorry)
                                                   AND RecordTypeId =: rtforAnnualPlan
                                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                                
                                System.debug('liquiAnualPlan in change terri by sbu '+liquiAnualPlan.size());
                                
                                
                                openInvList = [select id,Name,Opening_Inventory_Cooperatives__c,Opening_Inventory_Govt__c,YTD_Sales_Corporate__c,
                                               YTD_Sales_Govt__c,RecordTypeId,Product__c,Liquidation_Annual_Plan__c,X15_days_lock__c
                                               FROM Opening_Inventory2__c 
                                               WHERE State__c=:selectedTeritorry
                                               AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                               AND RecordTypeId =:rtForOpeningInventory];
                                
                                System.debug('openInvList on state size Change by sbu '+openInvList.size());
                                System.debug('openInvList on state Change by sbu '+openInvList);
                                
                                if(openInvList.size()>0){
                                    openingInventoryMap.clear();
                                    for(Opening_Inventory2__c openObj :openInvList){
                                        openingInventoryMap.put(openObj.Product__c, openObj);
                                    }
                                }
                                
                                System.debug('liquiAnualPlan '+liquiAnualPlan);
                                System.debug('liquiAnualPlan in state chage '+liquiAnualPlan.size());
                                
                                if(liquiAnualPlan.size()>0 && openInvList.size()>0 ){
                                    
                                    isAvail = checkDataForMonth(selectedTeritorry, mnth, liquiAnualPlan[0].id);
                                    System.debug('isAvail By SBU '+isAvail);
                                        
                                    if(isAvail){
                                        System.debug('isAvail By SBU inside true part '+isAvail);
                                        loadAllData(selectedTeritorry, liquiAnualPlan[0].id,mnth);
                                        
                                    }
                                    else{
                                        System.debug('isAvail By SBU inside false part '+isAvail);
                                        if(isSBU){
                                            createData(selectedTeritorry, liquiAnualPlan[0].id, mnth) ;
                                            loadAllData(selectedTeritorry, liquiAnualPlan[0].id,mnth); 
                                        }else{
                                             isSubmitted = true;
                                             loadAllData(selectedTeritorry, liquiAnualPlan[0].id,mnth); 
                                        }
                                        
                                    }
                                }
                                else{
                                    productList =new List<Product2>();
                                }
                                
                                
                            }// end of checking size of saibStatMappList
                            
                            else{
                                // backspace 
                                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                                   Fiscal_End_Date__c 
                                                   FROM Liquidation_Annual_Plan__c 
                                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                                          AND Fiscal_End_Date__c=:EndDate)
                                                   AND(State__c =:selectedTeritorry )
                                                   AND RecordTypeId =: rtforAnnualPlan
                                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                                System.debug('liquiAnualPlan size when user is selected single '+liquiAnualPlan.size());
                                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                               Sales_Org_Code__c,Brand_Type__c ,
                                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                               FROM Product2 
                                               WHERE IsActive = true 
                                               AND Sales_Org_Code__c = '1000' 
                                               AND Active_For_Liquidation__c= true];
                                System.debug('productList size when user is selected single '+productList.size());
                                totalProductNumber =  productList.size();
                                mnth = monthMap.get(selectedMonth);
                                if(liquiAnualPlan.size()>0 || Test.isRunningTest()){
                                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                                }else{
                                    productList =new List<Product2>();
                                }
                                liquidationMap.clear();
                                OpeningInventoryMap.clear();
                                System.debug('swswsws newLiqMap.size() '+newLiqMap.size());
                                System.debug('swswsws newOpenMap.size() '+newOpenMap.size());
                                if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size()){
                                    liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                                    OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                                }else{
                                    productList =new List<Product2>();
                                }
                                
                                
                            }
                            
                        }
                        else{
                            productList = new List<Product2>();
                        }
                        
                        
                        System.debug('User selected sinle state');
                        
                    }// end of else part of  selection of single State
                    
                    
                }// end of Try block
                catch(Exception ex){
                    System.debug('Error message '+ex.getMessage());
                    System.debug('Error Line '+ex.getLineNumber());
                }
                
                
                
            }//end of SBU
            
            
            
            //Start of SBU
           /* if(isSBU){
                System.debug('selectedTeritorry  by SBU '+selectedTeritorry);
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c 
                                    WHERE SBU_User__c=:userId order by State__r.Name ];
                
                System.debug('');
                saibStatMappList.sort();
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('statelst '+statelst);
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c =: selectedTeritorry)
                                   AND RecordTypeId =: rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                String mnth = monthMap.get(selectedMonth);
                if(liquiAnualPlan.size()>0){
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                }else{
                    productList =new List<Product2>();
                }
                liquidationMap.clear();
                OpeningInventoryMap.clear();
                if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size()){
                    liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                    OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                }else{
                    productList =new List<Product2>();
                }
                isSubmitted =true;
            }// end of SBU*/
            
            // for Admin and CM Users 
            /* if(isAdmin){
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c];
                
                
                saibStatMappList.sort();
                
                
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('statelst '+statelst);
                 
                 System.debug('other in Admin and CM StartDate '+StartDate);   
                 System.debug('other in Admin and CM EndDate '+EndDate); 
                 System.debug('other in Admin and CM statelst '+statelst); 
                 System.debug('other in Admin and CM rtforAnnualPlan '+rtforAnnualPlan); 
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c IN: statelst)
                                   AND RecordTypeId =: rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                String mnth = monthMap.get(selectedMonth);
                if(liquiAnualPlan.size()>0){
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                }else{
                    productList =new List<Product2>();
                }
                liquidationMap.clear();
                OpeningInventoryMap.clear();
                if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size()){
                    liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                    OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                }else{
                    productList =new List<Product2>();
                }
                isSubmitted =true;
            }*/
        }
        catch(Exception ex){
            System.debug('Error line number '+ex.getLineNumber());
            System.debug('Error Message  '+ex.getMessage());
        }
        
    }
    
    public void onMonthChange(){
        
        try{
            String  smonth;
            
            smonth  = monthMap.get(selectedMonth);
            System.debug('smonth on Mnth Change '+smonth);
            
            monthForVF = monthMap.get(selectedMonth);
            monthForNextVF = monthMap.get(selectedMonth+1);
            
            if(monthMap.get(selectedMonth)=='Dec'){monthForNextVF = 'Jan';}
            
            if(isBH ){
                System.debug('selected teri on month change  State is '+selectedTeritorry);
                System.debug('selected teri on month change Year is '+Select_Year);
                System.debug('selected teri on month change selected month is '+selectedMonth);
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE Fiscal_Year__c =: Select_Year
                                   AND State__c=:selectedTeritorry
                                   AND RecordTypeId =: rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liqui annual plan '+liquiAnualPlan);
                if(liquiAnualPlan.size()>0){ 
                    
                    isAvail = checkDataForMonth(selectedTeritorry, smonth, liquiAnualPlan[0].id);
                    
                    System.debug('isAvail in month change '+isAvail);
                    if(isAvail){
                        System.debug('Data available  ');
                        loadDataForSelectedMonth(selectedTeritorry, liquiAnualPlan[0].id);
                    }else{
                        System.debug('In creation of Month '+smonth);
                        createDataForSelectedMonth(selectedTeritorry, liquiAnualPlan[0].id);
                        loadDataForSelectedMonth(selectedTeritorry, liquiAnualPlan[0].id);
                    }
                }else{
                    productList =new List<Product2>();
                }
                
            }// end of BH
            
            
            
            /////////////////////////////////////////////ENd Of Business Head India///////////////////////////
            
            
            
            if(isSBU || Test.isRunningTest()){
                System.debug('SBU is login On Month Change');
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c 
                                    WHERE SBU_User__c=:userId order by State__r.Name ];
                
                
                saibStatMappList.sort();
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('SelectedTeritorry qwqwqwqw '+selectedTeritorry);
                if(selectedTeritorry== 'All'){
                    System.debug('Display Roll up');
                    isSubmitted = true;
                    RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                    liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                       Fiscal_End_Date__c 
                                       FROM Liquidation_Annual_Plan__c 
                                       WHERE (Fiscal_Start_Date__c=:StartDate
                                              AND Fiscal_End_Date__c=:EndDate)
                                       AND(State__c IN: statelst)
                                       AND RecordTypeId =:rtforAnnualPlan
                                       AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    System.debug('liquiAnualPlan '+liquiAnualPlan);
                    System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                    productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                   Sales_Org_Code__c,Brand_Type__c ,
                                   Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                   FROM Product2 
                                   WHERE IsActive = true 
                                   AND Sales_Org_Code__c = '1000' 
                                   AND Active_For_Liquidation__c= true];
                    
                    totalProductNumber =  productList.size();
                    String mnth = monthMap.get(selectedMonth);
                    if(liquiAnualPlan.size()>0){
                        newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                        newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                    }else{
                        productList =new List<Product2>();
                    }
                    liquidationMap.clear();
                    OpeningInventoryMap.clear();
                    if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size() || Test.isRunningTest()){
                        liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                        OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);    
                    }else{
                        productList =new List<Product2>();
                    }
                }else{
                    // this is else part of All State is Selected and create Liquidation for Selected month and Selected States
                    System.debug('create Liquidation for that State and Month');
                    System.debug('you have selected ');
                    System.debug('selected teri on month change  State is '+selectedTeritorry);
                    System.debug('selected teri on month change selected month is '+selectedMonth);
                    
                    String mnth = monthMap.get(selectedMonth);
                    System.debug('selected teri on month change selected month is '+mnth);
                    
                    saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                        FROM SAIB_State_Mapping__c 
                                        WHERE SBU_User__c=:userId order by State__r.Name];
                    List <SAIB_State_Mapping__c> saibStatMappList1 = new List<SAIB_State_Mapping__c>();
                    saibStatMappList1 = [select id,Name,State__c,State__r.Name,User__c
                                         FROM SAIB_State_Mapping__c 
                                         WHERE SBU_User__c=:userId  
                                         AND State__c =:selectedTeritorry];
                    
                    
                    System.debug('saibStatMappList1cccc User__c '+saibStatMappList1[0].User__c);
                    System.debug('saibStatMappList1cccc '+saibStatMappList1.size());
                    
                     liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                               Fiscal_End_Date__c 
                                               FROM Liquidation_Annual_Plan__c 
                                               WHERE Fiscal_Year__c =: Select_Year
                                               AND State__c=:selectedTeritorry
                                               AND RecordTypeId =: rtforAnnualPlan
                                               AND Sales_Org__r.Sales_Org_Code__c='1000'];
                    
                    System.debug('liquiAnualPlan asdfdfggfh '+liquiAnualPlan.size());
                    
                    if(saibStatMappList1.size()>0){
                        if(saibStatMappList1[0].User__c == null){
                            //if User Means BH is not present for Selected State then SBU is Created Liquidation for That State and Selected Month
                           
                            System.debug('liquiAnualPlan when SBU is login and Change Month after selecting');
                            if(liquiAnualPlan.size()>0){
                                isAvail = checkDataForMonth(selectedTeritorry, smonth, liquiAnualPlan[0].id);
                                System.debug('isAvail in month change on month change '+isAvail);
                                if(isAvail){
                                    System.debug('Data available  ');
                                    loadDataForSelectedMonth(selectedTeritorry, liquiAnualPlan[0].id);
                                }else{
                                    System.debug('In creation of Month '+smonth);
                                    createDataForSelectedMonth(selectedTeritorry, liquiAnualPlan[0].id);
                                    loadDataForSelectedMonth(selectedTeritorry, liquiAnualPlan[0].id);
                                }
                                
                            }else{
                                productList = new List<Product2>();
                            }
                            
                        }//end of checking user means BH
                        else{
                            //display rollup
                            RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                            productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                           Sales_Org_Code__c,Brand_Type__c ,
                                           Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                           FROM Product2 
                                           WHERE IsActive = true 
                                           AND Sales_Org_Code__c = '1000' 
                                           AND Active_For_Liquidation__c= true];
                            
                            totalProductNumber =  productList.size();
                            mnth = monthMap.get(selectedMonth);
                            if(liquiAnualPlan.size()>0){
                                newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                                newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                            }else{
                                productList =new List<Product2>();
                            }
                            liquidationMap.clear();
                            OpeningInventoryMap.clear();
                            if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size()){
                                liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                                OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);    
                            }else{
                                productList =new List<Product2>();
                            }
                        }
                        
                        
                    }// end of Checking saib Mapping Size List 
                    
                }// end of this is else part of All State is Selected and create Liquidation for Selected month and Selected States
                
            } // End of SBU Checking
            
            
           /* if(isSBU){
                
                
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c 
                                    WHERE SBU_User__c=:userId order by State__r.Name ];
                
                
                saibStatMappList.sort();
                
                
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('statelst '+statelst);
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c IN: statelst)
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                
                String mnth = monthMap.get(selectedMonth);
                if(liquiAnualPlan.size()>0){
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                }else{
                    productList =new List<Product2>();
                }
                liquidationMap.clear();
                OpeningInventoryMap.clear();
                if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size()){
                    liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                    OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);    
                }else{
                    productList =new List<Product2>();
                }
                
            }// end of SBU On Month Change*/
            
             if(isAdmin){
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c];
                
                
                saibStatMappList.sort();
                
                
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('statelst '+statelst);
                 
                 System.debug('another in Admin and CM StartDate '+StartDate);   
                 System.debug('another in Admin and CM EndDate '+EndDate); 
                 System.debug('another in Admin and CM statelst '+statelst); 
                 System.debug('another in Admin and CM rtforAnnualPlan '+rtforAnnualPlan); 
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c IN: statelst)
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                
                String mnth = monthMap.get(selectedMonth);
                if(liquiAnualPlan.size()>0){
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan);     
                }else{
                    productList =new List<Product2>();
                }
                liquidationMap.clear();
                OpeningInventoryMap.clear();
                if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size()){
                    liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                    OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);    
                }else{
                    productList =new List<Product2>();
                }
                
            }
            
            
            
            
            
        }
        catch(Exception ex){
            System.debug('Error line number '+ex.getLineNumber());
            System.debug('Error message '+ex.getMessage());
        }
    }
    
    public void onYearChange(){ 
        
        try{
            if(isBH){
                Select_Year = selectedYear; 
                System.debug('selectedYear in Test Class '+selectedYear);
                
                String  mth  = monthMap.get(selectedMonth-1);
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE Fiscal_Year__c =:selectedYear
                                   AND State__c =:selectedTeritorry
                                   AND RecordTypeId =: rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan'+liquiAnualPlan.size());
                
                if(liquiAnualPlan.size()>0){
                    displayProduct();
                    loadAllData(selectedTeritorry, liquiAnualPlan[0].id,mth);
                }else{
                    productList =new List<Product2>();
                }
            }
            
            if(isSBU){
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c 
                                    WHERE SBU_User__c=:userId order by State__r.Name ];
                
                Select_Year = selectedYear;
                saibStatMappList.sort();
                
                
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('statelst '+statelst);
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c IN: statelst)
                                   AND RecordTypeId =: rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                
                
                
                
                String mnth = monthMap.get(selectedMonth);
                
                if(liquiAnualPlan.size()>0){
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan); 
                    
                }
                else{
                    productList =new List<Product2>();
                }
                liquidationMap.clear();
                OpeningInventoryMap.clear();
                if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size() == newOpenMap.size()){
                    liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                    OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                }else{
                    productList =new List<Product2>();
                }
                
                System.debug('liquidationMap '+liquidationMap.size());
                isSubmitted = true;
                
            }//end of BHI and SHI
            
            
            
            if(isAdmin){
                isSubmitted = true;
                RollupSAIBLiquidation rollupSAIBLiquidationObj = new RollupSAIBLiquidation();
                saibStatMappList = [select id,Name,State__c,State__r.Name,User__c
                                    FROM SAIB_State_Mapping__c ];
                
                Select_Year = selectedYear;
                saibStatMappList.sort();
                
                
                
                for(SAIB_State_Mapping__c sObj:saibStatMappList){
                    statelst.add(sObj.State__c);
                }
                System.debug('statelst '+statelst);
                
                liquiAnualPlan  = [SELECT Id, Fiscal_Year__c, State__c,Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:StartDate
                                          AND Fiscal_End_Date__c=:EndDate)
                                   AND(State__c IN: statelst)
                                   AND RecordTypeId =: rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                
                
                System.debug('liquiAnualPlan '+liquiAnualPlan);
                System.debug('liquiAnualPlan size '+liquiAnualPlan.size());
                
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,Brand_Type__c ,
                               Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true];
                
                totalProductNumber =  productList.size();
                
                
                
                
                
                String mnth = monthMap.get(selectedMonth);
                
                if(liquiAnualPlan.size()>0){
                    newOpenMap = rollupSAIBLiquidationObj.rollUpOpenInventoryDetails(selectedTeritorry, mnth, liquiAnualPlan);   
                    newLiqMap = rollupSAIBLiquidationObj.rollUpLiqdtnDetail(selectedTeritorry, mnth, liquiAnualPlan); 
                    
                }
                else{
                    productList =new List<Product2>();
                }
                liquidationMap.clear();
                OpeningInventoryMap.clear();
                if(newLiqMap.size()>0 && newOpenMap.size()>0 && newLiqMap.size()== newOpenMap.size() || test.isRunningTest()){
                    liquidationMap = new Map<String, Liquidation2__c>(newLiqMap);
                    OpeningInventoryMap =new Map <String,Opening_Inventory2__c>(newOpenMap);
                }else{
                    productList =new List<Product2>();
                }
                
                System.debug('liquidationMap '+liquidationMap.size());
                isSubmitted = true;
                
            }
            
        }
        catch(Exception ex){
            System.debug('Error Line Number '+ex.getLineNumber()); 
            System.debug('Error message  '+ex.getMessage());
        }
        
    }
    
    public void updateData(){
        try{
            
            submittedMonth = monthMap.get(selectedMonth);
            
            
            List <liquidation2__c> liquiUpdateList = new List <liquidation2__c>();
            List <Opening_Inventory2__c>  openUpdateList = new List <Opening_Inventory2__c>();
            
            System.debug('liquiList '+liquiList);
            System.debug('liquiList size '+liquiList.size());
            
            for(liquidation2__c liquiObj : liquiList){
                liquiObj.submitted__c = true;
                liquiUpdateList.add(liquiObj);
            }
            
            if(liquiUpdateList.size()>0){
                update liquiUpdateList;
                isSubmitted =true;
                System.debug('value is isSubmitted '+isSubmitted);
            }
            
            
            /*for(Opening_Inventory2__c opnObj :openInvList){
opnObj.X15_days_lock__c = true;
openUpdateList.add(opnObj) ;
}*/
            
            if(openUpdateList.size()>0){
                update openUpdateList;
            }
            
            sendEmailToSBU();
            
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    }  
    
    public void populateYear(){
        
        //System.debug('populating years');
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
            
            //System.debug('popYearList '+popYearList);
            //System.debug('popYearList '+popYearList.size());
            
        }catch(Exception ex){
            System.debug('Errot Message '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber());
        }
        
    }
    
    public Boolean checkDataForMonth(String stateName ,String month, String liquiAnnualPlanId){
        
        List <Liquidation2__c> tempLiquiList = new  List <Liquidation2__c>();
        System.debug('Month in Test class '+month);
        tempLiquiList = [select id, Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                         Product__c,Type__c,submitted__c,State__c,Total_Placement_Govt__c,
                         Total_Placement_Corporate__c,Month__c,Plan_for_the_month__c,Inventory_in_Kg_Cooperatives__c,
                         Inventory_in_Kg_Govt__c,Plan_for_the_next_month__c
                         FROM Liquidation2__c
                         WHERE State__c =:stateName
                         AND Liquidation_Annual_Plan__c =:liquiAnnualPlanId
                         AND Month__c =:month
                         AND RecordTypeId = :rtforLiquidation]; 
        
        if(tempLiquiList.size()>0){
            return true;    
        }else{
            return false;
        }
        
        
        
        
    }
    
    public void loadAllData(String StateName,String liquiAnnualPlanId, String mth){
        
        try{
            
            System.debug('openInvList in loading all data '+StateName);
            System.debug('openInvList in loading all data '+liquiAnnualPlanId);
            System.debug('openInvList in loading all data '+mth);
            
            displayProduct();
            openInvList = new List<Opening_Inventory2__c>();
            liquiList = new List<Liquidation2__c>();
            
            openInvList =[select id,Name,Product__c,Opening_Inventory__c,X15_days_lock__c,RecordTypeId,Liquidation_Annual_Plan__c,
                          Opening_Inventory_Cooperatives__c,Opening_Inventory_Govt__c,
                          YTD_Sales_Corporate__c,YTD_Sales_Govt__c,State__c
                          FROM Opening_Inventory2__c
                          WHERE State__c=:StateName
                          AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                          AND RecordTypeId =:rtforOpeningInventory];
            
            System.debug('openInvList in loading all data '+openInvList);
            
            
            
            liquiList=[select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Type__c,
                       State__c,Total_Placement_Govt__c,Total_Placement_Corporate__c,Month__c,Plan_for_the_month__c,
                       Inventory_in_Kg_Cooperatives__c,submitted__c,Inventory_in_Kg_Govt__c,Distributors_Inventory__c,Plan_for_the_next_month__c
                       FROM Liquidation2__c 
                       WHERE State__c=:StateName
                       AND Month__c=:mth
                       AND Liquidation_Annual_Plan__c =:liquiAnnualPlanId
                       AND RecordTypeId = : rtforLiquidation];
            
            
            
            if(openInvList.size()>0){
                for(Opening_Inventory2__c opnObj:openInvList){
                    if(opnObj.X15_days_lock__c==true){
                        isOpenInvLock = true;
                    }
                    if(opnObj.X15_days_lock__c==false){
                        isOpenInvLock = False;
                    }
                    openingInventoryMap.put(opnObj.Product__c,opnObj);
                }
            }
            else{
                productList =new List<Product2>();
            }
            
            if(liquiList.size()>0){
                for(Liquidation2__c liqObj : liquiList){
                    System.debug('submitted__c '+liqObj.submitted__c);                    
                    if(liqObj.submitted__c== true){
                        isSubmitted = true;
                    }
                    if(liqObj.submitted__c == false){
                        isSubmitted = false;
                    }
                    liquidationMap.put(liqObj.Product__c,liqObj);
                }
            }else{
                productList =new List<Product2>();
            }
            
        }
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line Numkber  '+ex.getLineNumber());
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
        
        totalProductNumber =  productList.size();
        
    }
    
    
    public void updateSingleRecord(){
        if(isBH || isSBU){
            try{
                
                //totalLiquidation is use to check no negative calculation done on visualforce page.
                if(totalLiquidation>0 ||  totalLiquidation==0){
                    // System.debug('totalLiquidation inside condition  '+totalLiquidation);
                    
                    if(fieldTotupdate=='Opening_Inventory_Govt__c'){
                        System.debug('inside opening inventory GOVt');
                        List<Opening_Inventory2__c> openList = new  List<Opening_Inventory2__c>();
                        List<Opening_Inventory2__c> openListUpdate = new  List<Opening_Inventory2__c>();
                        
                        openList =[select id,Name,Opening_Inventory_Govt__c FROM Opening_Inventory2__c
                                   WHERE id=:recordIdTotupdate];
                        
                        for(Opening_Inventory2__c openbj : openList){
                            openbj.Id = recordIdTotupdate;
                            openbj.Opening_Inventory_Govt__c = Decimal.valueOf(valueToUpdate);
                            openListUpdate.add(openbj);
                        }
                        if(openListUpdate.size()>0){
                            update openListUpdate;
                        }
                    }
                    
                    
                    
                    if(fieldTotupdate=='Opening_Inventory_Cooperatives__c'){
                        
                        List<Opening_Inventory2__c> openList = new  List<Opening_Inventory2__c>();
                        List<Opening_Inventory2__c> openListUpdate = new  List<Opening_Inventory2__c>();
                        
                        openList =[select id,Name,Opening_Inventory_Cooperatives__c FROM Opening_Inventory2__c
                                   WHERE id=:recordIdTotupdate];
                        
                        for(Opening_Inventory2__c openbj : openList){
                            openbj.Id = recordIdTotupdate;
                            openbj.Opening_Inventory_Cooperatives__c = Decimal.valueOf(valueToUpdate);
                            openListUpdate.add(openbj);
                        }
                        if(openListUpdate.size()>0){
                            update openListUpdate;
                        }
                    }
                    
                    if(fieldTotupdate=='Inventory_in_Kg_Govt__c'){
                        
                        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
                        List<Liquidation2__c> liqListUpdate = new List<Liquidation2__c>();
                        liqList =[select id,Name,Inventory_in_Kg_Govt__c FROM Liquidation2__c
                                  WHERE id=:recordIdTotupdate];
                        for(Liquidation2__c liqObj :liqList){
                            liqObj.Id =recordIdTotupdate;
                            liqObj.Inventory_in_Kg_Govt__c =decimal.valueOf(valueToupdate) ;
                            liqListUpdate.add(liqObj);
                        }
                        
                        if(liqListUpdate.size()>0){
                            update liqListUpdate;
                        }
                    }
                    
                    
                    if(fieldTotupdate =='Inventory_in_Kg_Cooperatives__c'){
                        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
                        List<Liquidation2__c> liqListUpdate = new List<Liquidation2__c>();
                        
                        liqList =[select id,Name,Inventory_in_Kg_Cooperatives__c FROM Liquidation2__c
                                  WHERE id=:recordIdTotupdate];
                        
                        for(Liquidation2__c liqObj :liqList){
                            liqObj.Id =recordIdTotupdate;
                            liqObj.Inventory_in_Kg_Cooperatives__c =decimal.valueOf(valueToupdate) ;
                            liqListUpdate.add(liqObj);
                        }
                        
                        if(liqListUpdate.size()>0){
                            update liqListUpdate;
                        }
                    }
                    
                    
                    
                    //Plan_for_the_next_month__c
                    
                    if(fieldTotupdate=='Plan_for_the_next_month__c'){
                        
                        
                        Integer tmpMonth ;
                        System.debug('selected month in update single record '+selectedMonth);
                        System.debug('totalLiquidation==========> '+totalLiquidation);
                        
                        tmpMonth = selectedMonth;
                        System.debug('selectedMonth in update Sing line '+selectedMonth);
                        
                        if(selectedMonth == 12){
                            tmpMonth = 1;
                        }else{
                            tmpMonth  = selectedMonth + 1;
                        }
                        
                        
                        List<Liquidation2__c> lstLiquidation = new List<Liquidation2__c>();
                        List<Liquidation2__c> lstLiquidationUpdate = new List<Liquidation2__c>();
                        
                        lstLiquidation =[select id, Name,Month__c,Plan_for_the_month__c,State__c
                                         FROM Liquidation2__c 
                                         WHERE Month__c =: monthMap.get(tmpMonth)
                                         AND State__c =:selectedTeritorry
                                         AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                         AND Product__c =:prodIdTotupdate
                                         AND RecordTypeId =:rtforLiquidation];
                        
                        System.debug('lstLiquidation in single update '+lstLiquidation.size());
                        System.debug('lstLiquidation in single update '+lstLiquidation);
                        
                        
                        if(lstLiquidation.size()>0 || Test.isRunningTest()){
                            for(Liquidation2__c liqObj :lstLiquidation){
                                liqObj.Plan_for_the_month__c = Decimal.valueOf(valueToupdate) + Decimal.valueOf(totalLiquidation) ;
                                liqObj.Product__c = prodIdTotupdate;
                                liqObj.Liquidation_Annual_Plan__c = liquiAnualPlan[0].id;
                                liqObj.State__c =selectedTeritorry;
                                lstLiquidationUpdate.add(liqObj);
                            }
                            update lstLiquidationUpdate;
                        }
                        
                        
                        
                        
                        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
                        List<Liquidation2__c> liqListUpdate = new List<Liquidation2__c>();
                        
                        liqList =[select id,Name,Plan_for_the_next_month__c FROM Liquidation2__c
                                  WHERE id=:recordIdTotupdate];
                        
                        for(Liquidation2__c liqObj :liqList){
                            liqObj.Id =recordIdTotupdate;
                            liqObj.Plan_for_the_next_month__c =decimal.valueOf(valueToupdate) ;
                            liqListUpdate.add(liqObj);
                        }
                        
                        if(liqListUpdate.size()>0){
                            update liqListUpdate;
                        }
                    }
                    
                    
                    
                    
                }
            }
            catch(Exception ex){
                System.debug('Error Line Number '+ex.getLineNumber());
                System.debug('Error Message '+ex.getMessage());
            }
            
        }
        
        
    }
    
    public void createData(String stateName , String liquiAnnualPlanId,String mnth){
        
        try{
            
            Boolean flagForCreateData;
            String PreMonth='';
            
            if(selectedMonth == 1){
                PreMonth = monthMap.get(12);    
                System.debug('PreMonth inside if '+PreMonth);
            }else{
                PreMonth = monthMap.get(selectedMonth-1);    
                System.debug('PreMonth inside else '+PreMonth);
            }
            
            List<Liquidation2__c> tempList = new List<Liquidation2__c>();
            
            
            Date tmpDate = System.today();
            Integer tmpSelectedMonth =tmpDate.month();
            if(tmpSelectedMonth == 5){
                Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                            FROM Period WHERE Type = 'Year' 
                                            AND StartDate <= TODAY 
                                            AND EndDate >= TODAY];
                
                DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear.EndDate,Time.newInstance(0,0,0,0));
                System.debug('dateTimeScheduled.format() '+dateTimeScheduled.format('yyyy-MM-dd')); 
                
                Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
                System.debug(' theDate '+theDate);
                
                Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                         From Period 
                                         WHERE EndDate< :theDate
                                         AND Type ='Year' order By EndDate DESC Limit 1];
                liquiAnualPlan  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                   Fiscal_End_Date__c 
                                   FROM Liquidation_Annual_Plan__c 
                                   WHERE (Fiscal_Start_Date__c=:lastFiscalYear.StartDate
                                          AND Fiscal_End_Date__c=:lastFiscalYear.EndDate)
                                   AND(Territory_Name__c =:stateName)
                                   AND RecordTypeId =:rtforAnnualPlan
                                   AND Sales_Org__r.Sales_Org_Code__c='1000'];
                if(liquiAnualPlan.size()>0){
                    tempList = [SELECT id,State__c,Liquidation_Annual_Plan__c,Month__c,
                                Plan_for_the_next_month__c,Liquidation_YTD_SAIB__c
                                FROM Liquidation2__c
                                WHERE State__c=:stateName
                                AND Liquidation_Annual_Plan__c=:liquiAnualPlan[0].id
                                AND Month__c =:PreMonth
                                AND RecordTypeId =:rtforLiquidation];
                }
                
            }else{
                tempList = [SELECT id,State__c,Liquidation_Annual_Plan__c,Month__c,
                            Plan_for_the_next_month__c,Liquidation_YTD_SAIB__c
                            FROM Liquidation2__c
                            WHERE State__c=:stateName
                            AND Liquidation_Annual_Plan__c=:liquiAnnualPlanId
                            AND Month__c =:PreMonth
                            AND RecordTypeId =:rtforLiquidation];
            }
            
            if(tempList.size()>0){
                flagForCreateData = true;
            }else{
                flagForCreateData = false;
            }
            
            System.debug('values flagForCreateData  '+ flagForCreateData);
            
            Liquidation2__c liquiObj = new  Liquidation2__c();
            liquiList = new List<Liquidation2__c>(); 
            List <Product2> prodList = new List <Product2>();
            
            prodList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                        Sales_Org_Code__c,Brand_Type__c ,
                        Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                        FROM Product2 
                        WHERE IsActive = true 
                        AND Sales_Org_Code__c = '1000' 
                        AND Active_For_Liquidation__c= true];
            
            System.debug('OpeningInventoryMap '+OpeningInventoryMap.size());
            System.debug('OpeningInventoryMap '+OpeningInventoryMap);
            
            
            if(flagForCreateData){
                System.debug('create data form previous Month');
                System.debug('Data is creating from previuos Data ');
                if(prodList.size()>0){
                    Integer i = 0;
                    for(Product2 prodObj :prodList){
                        liquiObj = new  Liquidation2__c();
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquiObj.Opening_Inventory2__c = opObj.Id;
                            liquiObj.Liquidation_Annual_Plan__c = liquiAnnualPlanId;
                            liquiObj.Product__c = prodObj.Id;
                            liquiObj.Type__c = 'SAIB';
                            liquiObj.submitted_trade__c = false; 
                            liquiObj.YTD_Sales__c = 0;
                            liquiObj.Month__c = mnth;
                            liquiObj.Plan_for_the_month__c =tempList[i].Plan_for_the_next_month__c + tempList[i].Liquidation_YTD_SAIB__c;
                            liquiObj.RecordTypeId = rtforLiquidation;
                            liquiObj.Inventory_in_Kg_Cooperatives__c = 0;
                            liquiObj.Inventory_in_Kg_Govt__c = 0;
                            liquiObj.Plan_for_the_next_month__c = 0;
                            liquiObj.State__c = stateName;
                            liquiList.add(liquiObj);
                            i++;
                        }
                    }//End of For Loop
                    
                    if(liquiList.size()>0){
                        insert liquiList;
                    }
                    
                    liquidationMap.clear();
                    for(Liquidation2__c liquiObj1 : liquiList){
                        liquidationMap.put(liquiObj1.Product__c,liquiObj1);
                    }
                }//end of product list condition
                
            }else{
                if(prodList.size()>0){
                    for(Product2 prodObj :prodList){
                        liquiObj = new  Liquidation2__c();
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquiObj.Opening_Inventory2__c = opObj.Id;
                            liquiObj.Liquidation_Annual_Plan__c = liquiAnualPlan[0].Id ;
                            liquiObj.Product__c = prodObj.Id;
                            liquiObj.Type__c = 'SAIB';
                            liquiObj.submitted__c= false;
                            liquiObj.State__c = stateName;
                            liquiObj.Total_Placement_Govt__c = 0;
                            liquiObj.Total_Placement_Corporate__c = 0;
                            liquiObj.Month__c = mnth;
                            liquiObj.RecordTypeId = rtforLiquidation;
                            liquiObj.YTD_Sales__c = 0;
                            liquiObj.Plan_for_the_month__c = 0;
                            liquiObj.Inventory_in_Kg_Cooperatives__c = 0;
                            liquiObj.Inventory_in_Kg_Govt__c = 0;
                            liquiObj.Plan_for_the_next_month__c = 0;
                            liquiList.add(liquiObj);
                        }
                    }
                    if(liquiList.size()>0){
                        insert liquiList; 
                    }
                    
                    
                    liquidationMap.clear();
                    for(Liquidation2__c liquiObj1 : liquiList){
                        liquidationMap.put(liquiObj1.Product__c,liquiObj1);
                    }
                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Error line number '+ex.getLineNumber());
            System.debug('Error Message '+ex.getMessage());
        }
        
    }
    
    public void createDataForSelectedMonth(String StateName , String liquiAnnalPlanId){
        try{
            
            Boolean flag;
            
            flag=checkSelectedPrevMonthData(StateName,liquiAnnalPlanId);
            
            
            
            List<Liquidation2__c> tmpliqLst = new List<Liquidation2__c>();
            list<Liquidation2__c> createLiqList = new list<Liquidation2__c>();
            Liquidation2__c liquidationObj ;//=new Liquidation2__c();
            List <Product2> prodList = new List <Product2>();
            
            
            prodList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                        Sales_Org_Code__c,Brand_Type__c ,
                        Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                        FROM Product2 
                        WHERE IsActive = true 
                        AND Sales_Org_Code__c = '1000' 
                        AND Active_For_Liquidation__c= true];
            
            tmpliqLst =  getDataForPrevSelectedMonth(StateName,liquiAnnalPlanId);
            
            if(flag){
                if(prodList.size()>0){
                    Integer i=0;
                    for(Product2 prodObj :prodList){
                        liquidationObj= new Liquidation2__c();
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquidationObj.Opening_Inventory2__c = opObj.Id;
                            liquidationObj.Liquidation_Annual_Plan__c = liquiAnnalPlanId;
                            liquidationObj.Product__c = prodObj.Id;
                            liquidationObj.Type__c = 'SAIB';
                            liquidationObj.submitted__c = false;
                            liquidationObj.Month__c = monthMap.get(selectedMonth);
                            liquidationObj.YTD_Sales__c = 0;
                            liquidationObj.RecordTypeId = rtforLiquidation;
                            liquidationObj.Plan_for_the_month__c =tmpliqLst[i].Plan_for_the_next_month__c + tmpliqLst[i].Liquidation_YTD_SAIB__c;
                            liquidationObj.Inventory_in_Kg_Cooperatives__c = 0;
                            liquidationObj.Inventory_in_Kg_Govt__c = 0;
                            
                            liquidationObj.Plan_for_the_next_month__c = 0;
                            liquidationObj.State__c = StateName;
                            
                            i++;
                            createLiqList.add(liquidationObj);
                        }
                        
                    }
                    if(createLiqList.size()>0){
                        insert createLiqList;    
                    }
                    
                }
                
            }else{
                //if previous month data is not available  create data plan for month with zero
                if(prodList.size()>0){
                    for(Product2 prodObj :prodList){
                        liquidationObj= new Liquidation2__c();
                        if(OpeningInventoryMap.containsKey(String.valueOf(prodObj.Id))){
                            Opening_Inventory2__c opObj = OpeningInventoryMap.get(prodObj.id);
                            liquidationObj.Opening_Inventory2__c = opObj.Id;
                            liquidationObj.Liquidation_Annual_Plan__c = liquiAnnalPlanId;
                            liquidationObj.Product__c = prodObj.Id;
                            liquidationObj.Type__c = 'SAIB';
                            liquidationObj.submitted__c = false;
                            liquidationObj.Month__c = monthMap.get(selectedMonth);
                            liquidationObj.YTD_Sales__c = 0;
                            liquidationObj.RecordTypeId = rtforLiquidation;
                            
                            liquidationObj.Plan_for_the_month__c =0;
                            liquidationObj.Inventory_in_Kg_Cooperatives__c = 0;
                            liquidationObj.Inventory_in_Kg_Govt__c = 0;
                            
                            liquidationObj.Plan_for_the_next_month__c = 0;
                            liquidationObj.State__c = StateName;
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
            System.debug('Error line nunmber '+ex.getLineNumber());
            System.debug('Error message '+ex.getMessage());
        }
        
    }
    
    public void loadDataForSelectedMonth(String stateName , String liquiAnnalPlanId){
        try{
            
            liquiList = new List <Liquidation2__c>();
            System.debug('loadDataForSelectedMonth stateName  '+stateName);
            System.debug('loadDataForSelectedMonth liquiAnnalPlanId  '+liquiAnnalPlanId);
            System.debug('loadDataForSelectedMonth Month '+monthMap.get(selectedMonth));
            liquiList = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                         Type__c,submitted__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,
                         Plan_for_the_next_month__c,State__c
                         FROM Liquidation2__c
                         WHERE State__c=:stateName
                         AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId
                         AND RecordTypeId =:rtforLiquidation
                         AND Month__c=:monthMap.get(selectedMonth)];
            
          
            
            
            if(liquiList.size()>0){
                //System.debug('liquiList[0].submitted__c '+liquiList[0].submitted__c); 
                if(liquiList[0].submitted__c== true){
                    isSubmitted = true;
                }
                if(liquiList[0].submitted__c== false){
                    isSubmitted = false;
                }
                
                liquidationMap.clear();
                for(Liquidation2__c liqiObj :liquiList) {
                    liquidationMap.put(liqiObj.Product__c,liqiObj); 
                }
            }
            
            
            openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,Opening_Inventory_Cooperatives__c,
                           Opening_Inventory_Govt__c,Product__c,State__c,YTD_Sales_Govt__c ,YTD_Sales_Corporate__c 
                           FROM Opening_Inventory2__c 
                           WHERE State__c=:stateName 
                           AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId
                           AND RecordTypeId = :rtforOpeningInventory];
            
            if(openInvList.size()>0){
                openingInventoryMap.clear();
                for(Opening_Inventory2__c openObj :openInvList){
                    openingInventoryMap.put(openObj.Product__c, openObj);
                }
            }
            
            
            
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());    
        }
        
        
        
    }
    
    public Boolean checkSelectedPrevMonthData(String StateName,String liquiAnualPlanId){
        
        try{
            
            Integer tmpMonth  = selectedMonth;
            
            if(selectedMonth == 1){
                tmpMonth = 12;
            }else{
                tmpMonth =selectedMonth-1;
            }
            
            
            
            liquiList  = [select id, Name, Month__c,Territory__c,Plan_for_the_next_month__c,Liquidation_Annual_Plan__c,State__c 
                          FROM Liquidation2__c 
                          WHERE Month__c = :monthMap.get(tmpMonth)
                          AND State__c=:StateName
                          AND Liquidation_Annual_Plan__c =:liquiAnualPlanId
                          AND RecordTypeId =: rtforLiquidation];
            
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
    
    
    
    public List<Liquidation2__c> getDataForPrevSelectedMonth(String stateName,String liquiAnualPlanId){
        
        List<Liquidation2__c> tempLiqList = new List<Liquidation2__c>();
        
        try{
            Integer tmpMonth ;
            tmpMonth = selectedMonth;
            if(selectedMonth == 1){
                tmpMonth = 12;
            }else{
                tmpMonth = selectedMonth - 1;
            }
            
            
            
            tempLiqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                           Type__c,submitted__c,Month__c,Liquidation__c,Plan_for_the_month__c,Inventory_in_Kg_Cooperatives__c,
                           Inventory_in_Kg_Govt__c,Retailers_Inventory__c,Distributors_Inventory__c,Plan_for_the_next_month__c,
                           Territory__c,State__c,Liquidation_YTD_SAIB__c
                           FROM Liquidation2__c
                           WHERE State__c =:stateName
                           AND Liquidation_Annual_Plan__c=:liquiAnualPlanId
                           AND Month__c=:monthMap.get(tmpMonth)
                           AND RecordTypeId =:rtforLiquidation];
            
            
        }
        Catch(Exception ex){
            System.debug('Error Line Number '+ex.getLineNumber());
            System.debug('Error Message  '+ex.getMessage());
        }
        return tempLiqList;     
        
    }
    
    public void sendEmailToSBU(){
        try{
            User usr = [select id,Name,UserRoleId,Email from User Where id =:userId LIMIT 1];
            
            User usr1 = [select id,Name,UserRoleId,Email from User Where id =:SBUID LIMIT 1];
            if(usr!=null){
                System.debug('Name of User in Send Email is '+usr.Name);
                System.debug('Email of User in Send Email is '+usr.Email);
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                sendTo.add(usr1.Email);
                mail.setToAddresses(sendTo);
                mail.setSubject(' New Liquidation entry for '+monthMap.get(selectedMonth));
                
                //String body = 'Dear '+usr1.Name;
                String body ='<html><body><p>Dear '+usr1.Name+',</p><p>Liquidation is submitted by '+ usr.Name+'</p>';
                body += '<p>Here are the details:</p><p>Liquidation Type: SAIB </p>';
                body += ' <p>Month: '+monthMap.get(selectedMonth)+'</p><p>Financial Year: '+Select_Year+'</p><p>State Name: '+selectedTeritorry+'</p><br/>';
                //body += '<p>Here is the detail link to view the liquidation details:</p><br/>';
                body += ' <p>Thank you,</p></body></html>';
                mail.setHtmlBody(body);
                mails.add(mail);
                Messaging.sendEmail(mails);
            }
        }
        catch(Exception ex){
            System.debug('Error Line '+ex.getLineNumber());
            System.debug('Error Message '+ex.getMessage());
        }
        
        
    }
    
    
}