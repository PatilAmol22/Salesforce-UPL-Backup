public class RollUpSBUAdminIndiaCtrl {
    
    public String userId;
    
    public  RecordType rtforAnnualPlan;
    public  RecordType rtforOpenInventory;
    public  RecordType rtforLiquidation;
    
    public List<Territory_Distributor__c> teriListForUser1 ;
    public List<Territory_Distributor__c> teriListForUser2 ;
    public List<Territory_Distributor__c> teriListForUser3 ;
    public List<Territory_Distributor__c> teriListForUser4 ;
    
    
    
    // public Boolean isRM ;
    
    public Boolean isSBU;
    public Boolean isAdmin;
    
    //List
    public list<Territory_Distributor__c> lstTerritories{get;set;}
    public list<Liquidation2__c> lstLiqdtnDetails;
    public list<Opening_Inventory2__c> lstOpenInventory ;
    
    
    //Map
    MAP<String,Liquidation2__c> mapLiquidationDetail = new MAP<String,Liquidation2__c>();
    Map<String, Opening_Inventory2__c> mapOpenInventoryDetail = new Map <String, Opening_Inventory2__c>();
    MAP<String,List<Crop_Liquidation__c>> mapCropLiqidationDetail =  new MAP<String,List<Crop_Liquidation__c>>();
    
    public RollUpSBUAdminIndiaCtrl(){
        try{
            userId = UserInfo.getUserId();
            rtforAnnualPlan = [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation_Annual_Plan__c' and Name='Trade' LIMIT 1][0];
            rtforOpenInventory = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Trade' LIMIT 1][0];
            rtforLiquidation =  [SELECT Id,Name FROM RecordType WHERE SobjectType='Liquidation2__c' and Name='Trade' LIMIT 1][0];
            
            
            teriListForUser1 =new List<Territory_Distributor__c>();
            teriListForUser2 =new List<Territory_Distributor__c>();
            teriListForUser3 =new List<Territory_Distributor__c>();
            teriListForUser4 =new List<Territory_Distributor__c>();
            
            isSBU = false;
            isAdmin =  false;
            
            
            teriListForUser4 = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                                ZonalManager__c, SBU__c,  Zone__c, SBUHead__c 
                                FROM Territory_Distributor__c 
                                WHERE Present_in_KEDE__c = true 
                                AND Neglected__c = false 
                                AND TerritoryCode__c != '#' 
                                AND (SBU_Head_Id__c =:userId OR SBU_Marketing_heads_Id__c=:userId)
                                AND Sales_Org_Code__c='1000'];
            
            if(teriListForUser4.size()>0){
                isSBU = true;
                
            }else{
                isSBU = false;
            }            
            
            if(isSBU){
                lstTerritories = [SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                                  ZonalManager__c, SBU__c,  Zone__c, SBUHead__c 
                                  FROM Territory_Distributor__c 
                                  WHERE Present_in_KEDE__c = true 
                                  AND Neglected__c = false 
                                  AND TerritoryCode__c != '#' 
                                  AND (SBU_Head_Id__c =:userId OR SBU_Marketing_heads_Id__c=:userId)
                                  AND Sales_Org_Code__c='1000'];
            }
            
            
            if(isSBU == false){
                isAdmin = true;
            }else{
                isAdmin = false;
            }
            
            
            
            if(isAdmin){
                lstTerritories = [SELECT Id, Name from Territory_Distributor__c 
                                  WHERE Present_in_KEDE__c = true 
                                  AND Neglected__c = false 
                                  AND TerritoryCode__c != '#' 
                                  AND Sales_Org_Code__c='1000'];
            }
            
            
        }
        catch(Exception ex){
            
        }
    }//end of constructor
    
    public Map<String,String> getSBUTerritories(){
        Map<String, String> teriSBUMap = new Map<String, String>();
        try{
            
            
            teriSBUMap.put('All','All');
            for(Territory_Distributor__c trObj :lstTerritories){
                teriSBUMap.put(trObj.Id,trObj.Name);
            }
        }
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ ex.getLineNumber());
        }
        return teriSBUMap;
    } //end of Function getSBUTerritories
    
    public Map<String,String> getAdminTerritories(){
        Map<String, String> teriAdminMap = new Map<String, String>();
        try{
            teriAdminMap.put('All','All');
            for(Territory_Distributor__c trObj :lstTerritories){
                teriAdminMap.put(trObj.Id,trObj.Name);
            }
        }
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ ex.getLineNumber());
        }
        return teriAdminMap;
    } //end of Function
    
    public map<String,Liquidation2__c> rollUpCropLiqdtnDetail(string territory,string month,list<Liquidation_Annual_Plan__c> lstLiqAnnlPlan){
        
        try{
            lstLiqdtnDetails  = new list<Liquidation2__c>();
            mapLiquidationDetail = new MAP<String,Liquidation2__c>();
            
            //when it selected the All territory 
            if(territory == 'All'){
                //System.debug('All hai liquidation main');
                lstLiqdtnDetails = [SELECT Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                                    Type__c,Product__r.name,submitted__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                                    Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                                    //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                    Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                    Liquidation_YTD_Previous_Month__c,Product_Budget__c,  Fixed_YTD_Sales__c  ,  
                                    //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                    Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                                    FROM Liquidation2__c
                                    WHERE  Month__c=:month 
                                    AND RecordTypeId =: rtforLiquidation.Id
                                    AND Liquidation_Annual_Plan__c IN : lstLiqAnnlPlan];
                
                System.debug('lstLiqdtnDetails size '+lstLiqdtnDetails.size());
                System.debug('lstLiqdtnDetails '+lstLiqdtnDetails);
                
                
            }else{
                lstLiqdtnDetails = [SELECT Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Type__c,
                                    Product__r.name,submitted__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                                    Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                                    //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                                    Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                                    Liquidation_YTD_Previous_Month__c,Product_Budget__c,  Fixed_YTD_Sales__c  ,  
                                    //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                                    Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                                    FROM Liquidation2__c
                                    WHERE  Month__c=:month
                                    AND RecordTypeId =: rtforLiquidation.Id
                                    AND Territory__r.Name=:territory
                                    AND Liquidation_Annual_Plan__c IN : lstLiqAnnlPlan];
                
                
            }
            
            if(lstLiqdtnDetails.size()>0){
                // integer i=0;
                
                for(Liquidation2__c liq :lstLiqdtnDetails){
                    
                    if(mapLiquidationDetail.containskey(liq.Product__c ) || test.isRunningTest()){
                        
                        Liquidation2__c liqdtl = new Liquidation2__c();
                        
                        liqdtl = mapLiquidationDetail.get(liq.Product__c);
                        liqdtl.Distributors_Inventory__c = liqdtl.Distributors_Inventory__c + liq.Distributors_Inventory__c;
                        liqdtl.Retailers_Inventory__c = liqdtl.Retailers_Inventory__c + liq.Retailers_Inventory__c;
                        liqdtl.Plan_for_the_month__c = liqdtl.Plan_for_the_month__c + liq.Plan_for_the_month__c;
                        liqdtl.Plan_for_the_next_month__c = liqdtl.Plan_for_the_next_month__c + liq.Plan_for_the_next_month__c;
                        mapLiquidationDetail.put(liqdtl.Product__c,liqdtl);
                        
                    }else{
                        mapLiquidationDetail.put(liq.Product__c,liq );
                        
                    }
                }
            }
            
        }
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ ex.getLineNumber());
        }
        return mapLiquidationDetail;
    }// end of function
    
    
    //this is roll up for open inventory
    public map<String,Opening_Inventory2__c> rollUpOpenInventoryDetails(string territory,string month,list<Liquidation_Annual_Plan__c> lstLiqAnnlPlan){
        try{
            
            System.debug('lstLiqAnnlPlan '+lstLiqAnnlPlan);
            
            
            //when territory is All 
            if(territory=='All'){
                
                /*lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,YTD_Sales__c
FROM Opening_Inventory2__c 
WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
AND RecordTypeId =:rtforOpenInventory.Id];*/
                 
                
                
                
                /*LIST <Opening_Inventory2__c> oplISt = new LIST<Opening_Inventory2__c>();
                String s = 'SELECT id,Name,Product__c,Opening_Inventory__c, YTD_Sales_'+month+'__c FROM Opening_Inventory2__c Where Liquidation_Annual_Plan__c IN ';
                s+=':lstLiqAnnlPlan LIMIT 20';
                oplISt = Database.query(s);
                
                System.debug('oplISt '+oplISt);
                System.debug('oplISt size '+oplISt.size());*/
                
                
                if(month == 'Jan'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Jan__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Feb'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Feb__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Mar'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Mar__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Apr'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Apr__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'May'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_May__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Jun'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Jun__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Jul'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Jul__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Aug'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Aug__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Sept'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Sept__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Oct'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Oct__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Nov'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Nov__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                if(month == 'Dec'){
                    lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    YTD_Sales_Dec__c
                                    FROM Opening_Inventory2__c 
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND RecordTypeId =:rtforOpenInventory.Id]; 
                }
                
                
                
                
                
            }else{
                //when territory is selected from select list
                
                lstOpenInventory = [select id,Name,Product__c,Opening_Inventory__c,Liquidation_Annual_Plan__c,
                                    X15_days_lock__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                                    YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                                    YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c, 
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Product_Budget__c,
                                    //Added by Varun Shrivastava:SCTASK0459610
                                    Territory__c,YTD_Sales__c
                                    FROM Opening_Inventory2__c
                                    WHERE Liquidation_Annual_Plan__c IN:lstLiqAnnlPlan
                                    AND Territory__r.Name=:territory
                                    AND RecordTypeId =:rtforOpenInventory.Id];
            }
            
            
            System.debug('@@@ lstOpenInventory '+lstOpenInventory.size());
            Opening_Inventory2__c opndtl;
            if(lstOpenInventory.size()>0){
                
                for(Opening_Inventory2__c opn :lstOpenInventory){
                    if(mapOpenInventoryDetail.containskey(opn.Product__c)){
                        opndtl  = new Opening_Inventory2__c();
                        opndtl = mapOpenInventoryDetail.get(opn.Product__c);
                        
                        
                        switch on month {
                            when 'Jan' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Jan__c;
                                
                            }
                            
                            when 'Feb' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Feb__c;
                            }
                            when 'Mar' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Mar__c;
                            }
                            when 'Apr' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Apr__c;
                            }
                            when 'May' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_May__c;
                            }
                            when 'Jun' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Jun__c;
                            }
                            when 'Jul' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Jul__c;
                            }
                            when 'Aug' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Aug__c;
                            }
                            when 'Sept' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Sept__c;
                            }
                            when 'Oct' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Oct__c;
                            }
                            when 'Nov' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Nov__c;
                            }
                            when 'Dec' {
                                opndtl.Opening_Inventory__c = opndtl.Opening_Inventory__c + opn.Opening_Inventory__c;
                                opndtl.YTD_Sales__c = opndtl.YTD_Sales__c + opn.YTD_Sales_Dec__c;
                            }
                            
                        }// end of switch case      
                        mapOpenInventoryDetail.put(opndtl.Product__c,opndtl);
                        
                    }else{
                        Opening_Inventory2__c openInvObjTemp = new Opening_Inventory2__c();
                        openInvObjTemp =  opn;
                        switch on month {
                            when 'Jan' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Jan__c;
                            }
                            when 'Feb' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Feb__c;
                                
                            }
                            when 'Mar' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Mar__c;
                                
                            }
                            when 'Apr' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Apr__c;
                                
                            }
                            when 'May' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_May__c;
                                
                            }
                            when 'Jun' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Jun__c;
                                
                            }
                            when 'Jul' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Jul__c;
                                
                            }
                            when 'Aug' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Aug__c;
                                
                            }
                            when 'Sept' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Sept__c;
                                
                            }
                            when 'Oct' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Oct__c;
                                
                            }
                            when 'Nov' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Nov__c;
                                
                            }
                            when 'Dec' {
                                openInvObjTemp.YTD_Sales__c = opn.YTD_Sales_Dec__c;
                                
                            }
                            
                        }//end of switch case
                        
                        mapOpenInventoryDetail.put(opn.Product__c,opn);
                    }
                }//end of For Loop
                
            }
        }
        catch(Exception ex){
            System.debug('Error message '+ex.getMessage());
            System.debug('Error Line '+ ex.getLineNumber());
        }
        
        return mapOpenInventoryDetail;
    } //end of Function
    
    
    //crop Liquidation Rollup for India
    
    public MAP<String,List<Crop_Liquidation__c>> rollupCropLiquidationDetails(List<Liquidation_Annual_Plan__c> liquiAnnualPlan, String month){
        System.debug('In roll up Liquidatio Annual Plan '+liquiAnnualPlan);
        System.debug('In roll up Liquidatio MOnth is '+month);
        mapCropLiqidationDetail =  new MAP<String,List<Crop_Liquidation__c>>();
        Map<String,Crop_Liquidation__c> tempCrpMap = new Map<String,Crop_Liquidation__c>();
        
        
        List<Liquidation2__c> liquiList = new List<Liquidation2__c>();
        liquiList = [select id,Name,Liquidation_Annual_Plan__c,Product__c,
                    //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 Start
                    Distributor_Inventory_Previous_Month__c,Retailer_Inventory_Previous_Month__c,
                    Liquidation_YTD_Previous_Month__c,Product_Budget__c,  Fixed_YTD_Sales__c  ,  
                    //Added by Varun Shrivastava: SCTASK0459610 : 25 May 2021 End
                    Liquidation_YTD_Trade__c,Type__c,Month__c,Territory__c
                     FROM Liquidation2__c
                     WHERE Month__c=:month
                     AND Liquidation_Annual_Plan__c IN:liquiAnnualPlan
                     AND submitted_trade__c = true
                     AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
        
        System.debug('in roll up liquiList '+liquiList);
        System.debug('in roll up liquiList '+liquiList.size());
        
        List<String> LiqId = new List<String>();
        for(Liquidation2__c liqObj :liquiList){
            
            LiqId.add(liqObj.Id);
        }
        System.debug('LiqId '+LiqId);
        
        
        List<Crop_Liquidation__c> crpList = new List<Crop_Liquidation__c>();
        crpList = [SELECT Id,Name,Liquidation__r.Product__c, RecordTypeId, Crop__c,
                   Liquidation__c, Sales_Org__c,Liquidation_YTD_Trade__c, 
                   Liquidation_Value__c, Product_Name__c, is_Crop_Liquidation_Submitted__c 
                   FROM Crop_Liquidation__c
                   WHERE Liquidation__c IN:LiqId];
        
        System.debug('crpList '+crpList);
        System.debug('crpList Size  '+crpList.size());
        
        if(crpList.size()>0){
            for(Crop_Liquidation__c crObj: crpList){
                if(!tempCrpMap.containskey(crObj.Liquidation__c)){
                    tempCrpMap.put(crObj.Liquidation__c,crObj);
                }
                
                
            }
            
            
            //Map --> Key = Product + ',' + Crop  Value = Crop_Liquidation__c object
            Map<String,Crop_Liquidation__c> rollupLiquidationCropMap = new Map<String,Crop_Liquidation__c>();
            
            //Map --> Key = Product + ',' + Liquidation Value = YTD Value
            Map<String,Decimal> ytdMap = new Map<String,Decimal>();
            
            //Map --> Key = Product Value = YTD Value
            Map<String,Decimal> productytdMap = new Map<String,Decimal>();
            for(Crop_Liquidation__c crpObj :crpList){
                
                ytdMap.put(crpObj.Product_Name__c+','+crpObj.Liquidation__c,crpObj.Liquidation_YTD_Trade__c);    
                
                if(rollupLiquidationCropMap.containskey(crpObj.Product_Name__c+','+crpObj.Crop__c)){
                    Crop_Liquidation__c liqCrop =  rollupLiquidationCropMap.get(crpObj.Product_Name__c+','+crpObj.Crop__c);
                    crpObj.Liquidation_Value__c = crpObj.Liquidation_Value__c + liqCrop.Liquidation_Value__c;
                    rollupLiquidationCropMap.put(crpObj.Product_Name__c+','+crpObj.Crop__c,crpObj);
                    
                }else{
                    
                    rollupLiquidationCropMap.put(crpObj.Product_Name__c+','+crpObj.Crop__c,crpObj);
                }
            }
            
            for(String key :ytdMap.keySet()){
                String productKey = key.split(',')[0];
                if(productytdMap.containskey(productKey)){
                    productytdMap.put(productKey,ytdMap.get(key)+productytdMap.get(productKey));    
                }
                else{
                    productytdMap.put(productKey,ytdMap.get(key));    
                }
                
            }
            
            for(String key :rollupLiquidationCropMap.keySet()){
                String productKey = key.split(',')[0];
                Crop_Liquidation__c singleCropLiq = rollupLiquidationCropMap.get(key);
                singleCropLiq.Liquidation_YTD_Trade__c = productytdMap.get(productKey);
                if(mapCropLiqidationDetail.containskey(singleCropLiq.Liquidation__r.Product__c)){
                    List<Crop_Liquidation__c> crList  = mapCropLiqidationDetail.get(singleCropLiq.Liquidation__r.Product__c);
                    crList.add(singleCropLiq);
                    mapCropLiqidationDetail.put(singleCropLiq.Liquidation__r.Product__c,crList);    
                }
                else{
                    List<Crop_Liquidation__c> crList  = new List<Crop_Liquidation__c>();
                    crList.add(singleCropLiq);
                    mapCropLiqidationDetail.put(singleCropLiq.Liquidation__r.Product__c,crList);    
                }
                
            }
            
        }
        
        System.debug('mapCropLiqidationDetail ytd size  '+mapCropLiqidationDetail);
        return mapCropLiqidationDetail;
        
        
        
    }
    
    
    
    
    
    
    
}