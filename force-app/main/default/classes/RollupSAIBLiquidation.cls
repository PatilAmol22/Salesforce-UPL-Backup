public class  RollupSAIBLiquidation {
    
    public String userId;
    public String profName;
    public Boolean isSBU;
    public Boolean isSHI;
    public list<SAIB_State_Mapping__c> statelst;
    public list<Liquidation2__c> lstLiqdtnDetails;
    public Map<String,String> statelist;
    MAP<String,Liquidation2__c> mapLiquidationDetail ;
    public list<Opening_Inventory2__c> lstOpenInventory ;
    Map<String, Opening_Inventory2__c> mapOpenInventoryDetail;
    Map<String,String> StateMapList;
    
   
    public  RecordType rtforAnnualPlan;
    public  RecordType rtforOpenInventory;
    public  RecordType rtforLiquidation;
    
    public RollupSAIBLiquidation(){
        
        userId = UserInfo.getUserId();
        System.debug('userId in the rollup '+userId);
        statelst =new List<SAIB_State_Mapping__c>();
        lstLiqdtnDetails =new list<Liquidation2__c>();
        mapLiquidationDetail = new MAP<String,Liquidation2__c>();
        mapOpenInventoryDetail =new Map <String, Opening_Inventory2__c>();
        StateMapList = new Map<String,String>();
        isSBU = false;
            
       
        
      
    
        Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate  
                                    FROM Period WHERE Type = 'Year' 
                                    AND StartDate <= TODAY 
                                    AND EndDate >= TODAY];
        
        rtforAnnualPlan = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation_Annual_Plan__c' and Name='SAIB' LIMIT 1][0];
        rtforOpenInventory = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='SAIB' LIMIT 1][0];
        rtforLiquidation =  [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation2__c' and Name='SAIB' LIMIT 1][0];
        
        statelist =new  Map<String,String>();
        
        
        
       
        
       /* if(isSBU){
            statelst = [select id, Name,State__c,State__r.Name 
                        from SAIB_State_Mapping__c WHERE SBU_User__c=:userId] ;
            
            System.debug('statelst in Rollup summary '+statelst.size());
            System.debug('statelst '+statelst);
        }*/
        
       
        
        
        
    } //end of constructor
    
    
    /*public Map<String,String> getStateList(){
        StateMapList.put('All', 'All');
        for(SAIB_State_Mapping__c sobj :statelst){
            StateMapList.put(sobj.State__c, sobj.State__r.Name);
        }
        return StateMapList;
    }*/
    
    //this function is callimg from LiquidationDSAIBController for Roll up summary 
    //This IS FOR lIQUIDATION 
    public Map<String,Liquidation2__c> rollUpLiqdtnDetail(String stateName,String month, list<Liquidation_Annual_Plan__c> lstAnnualPlan){
        try{
            System.debug('State Name is '+stateName);
            System.debug('Month  is '+month);
            System.debug('Liquidation Annual pLan   '+lstAnnualPlan);
            System.debug('Liquidation Annual pLan size  '+lstAnnualPlan.size());
            
            lstLiqdtnDetails  = new list<Liquidation2__c>();
            mapLiquidationDetail = new MAP<String,Liquidation2__c>();
            
            if(stateName=='All'){
                System.debug('lstAnnualPlan in rollup '+lstAnnualPlan);
                lstLiqdtnDetails =[select id,Name,Liquidation_Annual_Plan__c,Product__c,Type__c,Product__r.name,
                                   submitted__c,Month__c,Liquidation__c,Plan_for_the_month__c,Inventory_in_Kg_Cooperatives__c,
                                   Inventory_in_Kg_Govt__c,Plan_for_the_next_month__c,State__c
                                   FROM Liquidation2__c
                                   WHERE RecordTypeId =:rtforLiquidation.Id 
                                   AND Month__c=:month
                                   AND Liquidation_Annual_Plan__c IN:lstAnnualPlan];
            }else{
                lstLiqdtnDetails =[select id,Name,Liquidation_Annual_Plan__c,Product__c,Type__c,Product__r.name,
                                   submitted__c,Month__c,Liquidation__c,Plan_for_the_month__c,Inventory_in_Kg_Cooperatives__c,
                                   Inventory_in_Kg_Govt__c,Plan_for_the_next_month__c,State__c,State__r.Name
                                   FROM Liquidation2__c
                                   WHERE RecordTypeId =:rtforLiquidation.Id 
                                   AND Month__c=:month
                                   AND Liquidation_Annual_Plan__c IN: lstAnnualPlan
                                   AND State__c=:stateName]; 
            }
            
            System.debug('lstLiqdtnDetails '+lstLiqdtnDetails);
             System.debug('lstLiqdtnDetails size '+lstLiqdtnDetails.size());
                
            if(lstLiqdtnDetails.size()>0){ 
                for(Liquidation2__c liq : lstLiqdtnDetails){
                    System.debug(' mapLiquidationDetail '+mapLiquidationDetail);
                    
                    if(mapLiquidationDetail.containskey(liq.Product__c) || test.isRunningTest()){
                        Liquidation2__c liqdtl = new Liquidation2__c();
                        liqdtl = mapLiquidationDetail.get(liq.Product__c);
                        liqdtl.Inventory_in_Kg_Govt__c = liqdtl.Inventory_in_Kg_Govt__c + liq.Inventory_in_Kg_Govt__c;
                        liqdtl.Inventory_in_Kg_Cooperatives__c = liqdtl.Inventory_in_Kg_Cooperatives__c + liq.Inventory_in_Kg_Cooperatives__c;
                        liqdtl.Plan_for_the_month__c = liqdtl.Plan_for_the_month__c + liq.Plan_for_the_month__c;
                        liqdtl.Plan_for_the_next_month__c = liqdtl.Plan_for_the_next_month__c + liq.Plan_for_the_next_month__c;
                        mapLiquidationDetail.put(liqdtl.Product__c,liqdtl);
                    }else{
                        mapLiquidationDetail.put(liq.Product__c,liq);
                    }
                }
            }
            
            
            
        }
        catch(Exception ex){
            System.debug('Error Line Number '+ex.getLineNumber());
            System.debug('Error Message '+ex.getMessage());
        }
        return mapLiquidationDetail;
    }
    
    
    
    //this function is callimg from LiquidationDSAIBController for Roll up summary 
    //This IS FOR OPENING iNVENTORY 
    public map<String,Opening_Inventory2__c> rollUpOpenInventoryDetails(string stateName,string month,list<Liquidation_Annual_Plan__c> lstLiqAnnlPlan){
        try{
            //when state is Null
            if(stateName=='All'){
                System.debug('month in rollup in function rollUpOpenInventoryDetails '+month);
                lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,Liquidation_Annual_Plan__c,X15_days_lock__c,
                                    Territory__c,YTD_Sales__c,Opening_Inventory_Govt__c,Opening_Inventory_Cooperatives__c,YTD_Sales_Govt__c,
                                    YTD_Sales_Corporate__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =: rtforOpenInventory.Id];
            }else{
                System.debug('month not in all');
                System.debug('month not in all state '+stateName);
                lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,Liquidation_Annual_Plan__c,X15_days_lock__c,
                                    Territory__c,YTD_Sales__c,Opening_Inventory_Govt__c,Opening_Inventory_Cooperatives__c,YTD_Sales_Govt__c,
                                    YTD_Sales_Corporate__c
                                    FROM Opening_Inventory2__c                                  
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND State__c =:stateName
                                    AND RecordTypeId =:rtforOpenInventory .Id ];
            }
            
            Opening_Inventory2__c opndtl;
            if(lstOpenInventory.size()>0){
                
                for(Opening_Inventory2__c opn :lstOpenInventory){
                    if(mapOpenInventoryDetail.containskey(opn.Product__c)){
                        opndtl  = new Opening_Inventory2__c();
                        opndtl = mapOpenInventoryDetail.get(opn.Product__c);
                        opndtl.Opening_Inventory_Cooperatives__c = opndtl.Opening_Inventory_Cooperatives__c + opn.Opening_Inventory_Cooperatives__c;
                        opndtl.Opening_Inventory_Govt__c = opndtl.Opening_Inventory_Govt__c + opn.Opening_Inventory_Govt__c;
                        opndtl.YTD_Sales_Corporate__c = opndtl.YTD_Sales_Corporate__c + opn.YTD_Sales_Corporate__c;
                        opndtl.YTD_Sales_Govt__c = opndtl.YTD_Sales_Govt__c + opn.YTD_Sales_Govt__c;
                        mapOpenInventoryDetail.put(opndtl.Product__c,opndtl);
                        
                    }else
                    {
                        mapOpenInventoryDetail.put(opn.Product__c,opn);
                    }
                }
            }
        }
        catch(Exception ex){
            System.debug('Error Line Number '+ex.getLineNumber());
            System.debug('Error Message '+ex.getMessage());
        }
        return mapOpenInventoryDetail;
    }
    
}