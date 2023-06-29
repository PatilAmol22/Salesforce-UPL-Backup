public class TradeIndiaCropLiquiSBUAdmin {
    public TradeIndiaCropLiquiSBUAdmin(){
        
    }
    
    public Map<String,List<Crop_Liquidation__c>> rollupCropLiquidationIndia(List<Liquidation_Annual_Plan__c> liquiAnualPlan, String month){
        // change Roll for crop Liquidation
        RollUpSBUAdminIndiaCtrl rollupObj = new RollUpSBUAdminIndiaCtrl();
        Map<String,List<Crop_Liquidation__c>> newLiqMapCrops = new Map<String,List<Crop_Liquidation__c>>(); 
        newLiqMapCrops = rollupObj.rollupCropLiquidationDetails(liquiAnualPlan,month);
        return newLiqMapCrops;
    }// end of function rollupCropLiquidationIndia
    
    
    public List<Product2> showProductListForCropForHigher(List<Liquidation_Annual_Plan__c> annualPlan, String month,String recordTypeId){
        System.debug('Month is '+month);
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productListForCropLiquis = new List<product2>();
        
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE  Month__c=:month
                   AND Liquidation_Annual_Plan__c IN :annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_trade__c = true
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
        
        
        List<Crop_Liquidation__c> crpList = new List<Crop_Liquidation__c>();
        crpList = [Select Id,Name,Liquidation__c,Liquidation__r.Product__c From Crop_Liquidation__c
                   WHERE Liquidation__c IN: liqList];
        
        System.debug('crpList while testing  '+crpList);
        List<String> prodId = new List<String>();
        if(crpList.size()>0){
            for(Crop_Liquidation__c crpObj :crpList){
                
                prodId.add(crpObj.Liquidation__r.Product__c);
                
            }
            if(prodId.size()>0){
                productListForCropLiquis = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                            Sales_Org_Code__c,Brand_Type__c ,
                                            Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                            FROM Product2 
                                            WHERE IsActive = true 
                                            AND Sales_Org_Code__c = '1000' 
                                            AND Active_For_Liquidation__c= true
                                            AND Id IN:prodId];
                System.debug('@@@@ productListForCropLiqui '+productListForCropLiquis);
                System.debug('@@@ productListForCropLiqui '+productListForCropLiquis.size());
            }
        }
        return productListForCropLiquis;
        
    }// end of function showProductListForCropForHigher
    
    
    
    public Boolean displayCropDataForSingleTeritory(List<Liquidation_Annual_Plan__c> liqAnnulPlan,String teriName, String month){ 
        List<Liquidation2__c> liqLists = new List<Liquidation2__c>();
        
        liqLists = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                    Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                    Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                    Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                    FROM Liquidation2__c
                    WHERE Territory__r.Name=: teriName
                    AND Month__c=:month
                    AND Liquidation_Annual_Plan__c IN: liqAnnulPlan
                    AND submitted_trade__c = true
                    AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqLists){
            liquidationId.add(liqudaobj.Id);    
        }
        //checking if already Crop Liquidation is created or not
        Boolean tempCheckCropLiqui;
        tempCheckCropLiqui = checkingCropLiquidation(liquidationId);
        return tempCheckCropLiqui;
    } // end of function displayCropDataForSingleTeritory
    
    public Boolean checkingCropLiquidation(List<String> liquiIds){
        System.debug('liquiIds '+liquiIds);
        List<Crop_Liquidation__c> cropLiqList = new List<Crop_Liquidation__c>(); 
        cropLiqList = [Select Id,Name,Liquidation__c From Crop_Liquidation__c WHERE Liquidation__c IN:liquiIds];
        if(cropLiqList.size()>0){
            return true;
        }else{
            return false;
        }
        
    }
    
    
    public List<Product2> showProductListForCropIndiaSelectTeri(String selectedTeritorry,String mth,List<Liquidation_Annual_Plan__c> liquiAnnualPlan,String rtforLiquidation){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productList = new List<Product2>();
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c IN: liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_trade__c = true
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
        
        List<String> prodId = new List<String>();
        if(liqList.size()>0){
            for(Liquidation2__c liobj:liqList){
                prodId.add(liobj.Product__c);
            }
            
            
            if(prodId.size()>0){
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,
                               IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true
                               AND Id IN:prodId];
                System.debug('productList '+productList);
                System.debug('productList size '+productList.size());
                
            }
            
        }
        return productList;
    }// end of function showProductListForCropIndiaSelectTeri
    
    
    public Map<String,List<Crop_Liquidation__c>> loadAllDataForCropLiquidationIndiaSelectTeri(String selectedTeritorry,String mth,List<Liquidation_Annual_Plan__c> liquiAnnualPlan,String rtforLiquidation){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Map<String,List<Crop_Liquidation__c>> cropLiquidationMap = new Map<String,List<Crop_Liquidation__c>>();
        
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c IN:liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_trade__c = true
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        
        
        
        List<Crop_Liquidation__c> cropList = new List<Crop_Liquidation__c>();
        cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
                    Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                    FROM Crop_Liquidation__c 
                    WHERE Liquidation__c IN:liquidationId];
        
        if(cropList.size()>0){
            for(Crop_Liquidation__c cliqObj:cropList){
                
                
                if(cropLiquidationMap.containsKey(cliqObj.Liquidation__r.Product__c)){
                    List<Crop_Liquidation__c> cList = cropLiquidationMap.get(cliqObj.Liquidation__r.Product__c);
                    cList.add(cliqObj);
                    cropLiquidationMap.put(cliqObj.Liquidation__r.Product__c, cList);
                    
                }else{
                    List<Crop_Liquidation__c> CroList = New List<Crop_Liquidation__c>();
                    CroList.add(cliqObj);
                    cropLiquidationMap.put(cliqObj.Liquidation__r.Product__c, CroList);
                }
                
                
                
            }
        }
        return cropLiquidationMap;
    }// end of function loadAllDataForCropLiquidationIndiaSelectTeri
    
    
    
}