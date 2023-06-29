public class SwalTradeIndiaCropLiquiZHAdmin {
    public SwalTradeIndiaCropLiquiZHAdmin(){
        
    }
    
    public Map<String,List<Crop_Liquidation__c>> rollupCropLiquidationSWAL(List<Liquidation_Annual_Plan__c> liquiAnualPlan, String month){
        System.debug('liquiAnualPlan on roll up '+liquiAnualPlan);
        System.debug('month on roll up '+month);
        
        RollUpZHAdminSwalCtrl rollupObj = new RollUpZHAdminSwalCtrl();
        Map<String,List<Crop_Liquidation__c>> newLiqMapCrops = new Map<String,List<Crop_Liquidation__c>>(); 
        newLiqMapCrops = rollupObj.rollupCropLiquidationDetails(liquiAnualPlan,month);
        return newLiqMapCrops;
        
    }
    
    public List<Product2> showProductListForCropForHigher(List<Liquidation_Annual_Plan__c> annualPlan, String month,String recordTypeId){
        
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productListForCropLiqui = new List<product2>();
        
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c 
                   WHERE  Month__c=:month
                   AND Liquidation_Annual_Plan__c IN :annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true 
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<Crop_Liquidation__c> crpList = new List<Crop_Liquidation__c>();
        crpList = [Select Id,Name,Liquidation__c,Liquidation__r.Product__c From Crop_Liquidation__c
                   WHERE Liquidation__c IN:liqList];
        List<String> prodId = new List<String>();
        if(crpList.size()>0){
            for(Crop_Liquidation__c crpObj : crpList){
                prodId.add(crpObj.Liquidation__r.Product__c);   
            }
            
        }
        
        if(prodId.size()>0){
            productListForCropLiqui = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                       Sales_Org_Code__c,Brand_Type__c ,
                                       Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                       FROM Product2 
                                       WHERE IsActive = true 
                                       AND Sales_Org_Code__c = '1210' 
                                       AND Active_For_Liquidation__c= true
                                       AND Id IN:prodId];
            
        }
        return productListForCropLiqui;
        
    }
    
    
    public Boolean displayCropDataForSingleTeritory(List<Liquidation_Annual_Plan__c> liqAnnulPlan,String teriName, String month){ 
        List<Liquidation2__c> liqLists = new List<Liquidation2__c>();
        System.debug('teriName 1:'+teriName);
        System.debug('month 1:'+month);
        System.debug('liqAnnulPlan 1:'+liqAnnulPlan);
        liqLists = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                    Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                    Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                    Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                    FROM Liquidation2__c 
                    WHERE Territory__r.Name=: teriName
                    AND Month__c=:month
                    AND Liquidation_Annual_Plan__c IN: liqAnnulPlan
                    AND submitted_Trade_SWAL__c = true
                    AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqLists){
            liquidationId.add(liqudaobj.Id);    
        }
        //checking if already Crop Liquidation is created or not
        Boolean tempCheckCropLiqui;
        tempCheckCropLiqui = checkingCropLiquidation(liquidationId);
        return tempCheckCropLiqui;
    }
    
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
    
    public List<Product2> showProductListForCropSWALSelectTeri(String selectedTeritorry,String mth,List<Liquidation_Annual_Plan__c> liquiAnnualPlan,String rtforLiquidation){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productList = new List<Product2>();
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,Territory__r.Name,
                   Territory__c
                   FROM Liquidation2__c 
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c IN: liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        
        
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
                               AND Sales_Org_Code__c = '1210' 
                               AND Active_For_Liquidation__c= true
                               AND Id IN:prodId];
                System.debug('productList '+productList);
                System.debug('productList size '+productList.size());
                
            }
            
        }
        return productList;
    }
    
    
    public Map<String,List<Crop_Liquidation__c>> loadAllDataForCropLiquidationSWALSelectTeri(String selectedTeritorry,String mth,List<Liquidation_Annual_Plan__c> liquiAnnualPlan,String rtforLiquidation){
       List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Map<String,List<Crop_Liquidation__c>> cropLiquidationMap = new Map<String,List<Crop_Liquidation__c>>();
        
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c IN:liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        
        
        
        List<Crop_Liquidation__c> cropList = new List<Crop_Liquidation__c>();
        cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
                    Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
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
                
                System.debug('Selected teri cropLiquidationMap '+cropLiquidationMap);
                System.debug('Selected teri cropLiquidationMap size  '+cropLiquidationMap.size()); 
                
            }
        }
        return cropLiquidationMap;
    }
    
    //Updated by Varun Shrivastava  :INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
    public Boolean checkingCropLiquidationSubmited(String teriId, String month, List<Liquidation_Annual_Plan__c> annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Boolean submitCropLiq;
        liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: teriId//Territory__c=: teriId 
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c in :annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        List<Crop_Liquidation__c> cropList = new List<Crop_Liquidation__c>();
        cropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
                    Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                    FROM Crop_Liquidation__c 
                    WHERE Liquidation__c IN:liquidationId];
        
        if(cropList.size()>0){
            for(Crop_Liquidation__c cliqObj:cropList){
                if(cliqObj.is_Crop_Liquidation_Submitted__c == true){
                //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
				submitCropLiq = true;
                break;
                //Added by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes
				
                }else{
                    submitCropLiq = false;
                }
                
                
            }
        }
        return submitCropLiq;
    }
    
    public Map<Id,List<Sub_Crop_Liquidation__c>> fetchSubCropLiqRecord(String teriId, String month, List<Liquidation_Annual_Plan__c> annualPlan, String recordTypeId,Map<Id,List<Sub_Crops__c>> cropTosubCropMap){
        Map<Id,List<Sub_Crop_Liquidation__c>> liquidationToSubCropLiqMap =new Map<Id,List<Sub_Crop_Liquidation__c>>();
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Set<Id> liquidationIdSet = new Set<Id>();
        Set<Id> cropLiquidationIdSet = new Set<Id>();
        if(teriId != null){
        	liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c in :annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
            
        }else{
            liqList = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Month__c,Liquidation__c,
                   Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                   FROM Liquidation2__c
                   WHERE Month__c=:month
                   AND Liquidation_Annual_Plan__c in :annualPlan 
                   AND RecordTypeId =:recordTypeId
                   AND submitted_Trade_SWAL__c = true
                   AND /*Liquidation_YTD_SWAL__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
            //Add Liq annual plan
        }
        
        for(Liquidation2__c liqudaobj:liqList){
            liquidationIdSet.add(liqudaobj.Id);    
        }
        //System.assert(false,'liquidationIdSet : '+liquidationIdSet);
        
        List<Crop_Liquidation__c> cropLiqList = [Select Id,Name,Liquidation__c,Total_Sub_Liq_Value__c From Crop_Liquidation__c WHERE Liquidation__c IN:liquidationIdSet];
        //System.assert(false,'cropLiqList : '+cropLiqList);
        
        
        for(Crop_Liquidation__c cropLiquidationRecord:cropLiqList){
            cropLiquidationIdSet.add(cropLiquidationRecord.Id);
        }
        List<Sub_Crop_Liquidation__c> subCropLiqList = [Select Id,Crop_Liquidation__c,Crop_Liquidation__r.Liquidation__r.Product_Code__c,Sub_Crop_Liquidation_Value__c,
                                                       Crop_Liquidation__r.Product_Name__c,Crop_Liquidation__r.Crop__r.Name,Sub_Crops__c,Sub_Crops__r.Name,Is_Sub_Crop_Liquidation_Submitted__c,Liquidation__c,
                                                       Sales_Org__c 
                                                       from Sub_Crop_Liquidation__c where Crop_Liquidation__c in :cropLiquidationIdSet 
                                                       order by Crop_Liquidation__r.Product_Name__c,Crop_Liquidation__r.Crop__r.LastModifiedDate  ,Sub_Crops__r.Name	 
                                                       ];
        if(teriId != null){
          for(Sub_Crop_Liquidation__c subCropLiq : subCropLiqList){
                if(liquidationToSubCropLiqMap.containsKey(subCropLiq.Crop_Liquidation__c)){
                    liquidationToSubCropLiqMap.get(subCropLiq.Crop_Liquidation__c).add(subCropLiq);
                }else
                {
                    List<Sub_Crop_Liquidation__c> tempsubCropLiqList = new List<Sub_Crop_Liquidation__c>();
                    tempsubCropLiqList.add(subCropLiq);
                    liquidationToSubCropLiqMap.put(subCropLiq.Crop_Liquidation__c, tempsubCropLiqList);        
                }
            }
        }else{
            String assertString='';
            Map<String,Set<ID>> productIDToCropLiqSetMap = new Map<String,Set<Id>>();
            Map<String,List<Sub_Crop_Liquidation__c>> productSubCropToSubCropLiqRecordMap = new Map<String,List<Sub_Crop_Liquidation__c>>();
            Map<String,Sub_Crop_Liquidation__c> combinationKeyToSubCropLiqRecordMap = new Map<String,Sub_Crop_Liquidation__c>();
            
            String combinationKey='';
            for(Sub_Crop_Liquidation__c subCropLiq : subCropLiqList){
                combinationKey= String.valueOf(subCropLiq.Crop_Liquidation__r.Liquidation__r.Product_Code__c)+String.valueOf(subCropLiq.Sub_Crops__c);
                if(productIDToCropLiqSetMap.containsKey(combinationKey)){
                    productIDToCropLiqSetMap.get(combinationKey).add(subCropLiq.Crop_Liquidation__c);
                }else{
                    Set<Id> tempIdSet = new Set<Id>();
                    tempIdSet.add(subCropLiq.Crop_Liquidation__c);
                    productIDToCropLiqSetMap.put(combinationKey,tempIdSet);
                    
                }
                if(productSubCropToSubCropLiqRecordMap.containsKey(combinationKey)){
                    productSubCropToSubCropLiqRecordMap.get(combinationKey).add(subCropLiq);
                }else{
                    List<Sub_Crop_Liquidation__c> tempList = new List<Sub_Crop_Liquidation__c>();
                    tempList.add(subCropLiq);
                    productSubCropToSubCropLiqRecordMap.put(combinationKey,tempList);
                }
            }
                        
            for(Sub_Crop_Liquidation__c subCropLiq : subCropLiqList){
                combinationKey= String.valueOf(subCropLiq.Crop_Liquidation__r.Liquidation__r.Product_Code__c)+String.valueOf(subCropLiq.Sub_Crops__c);
                
                Integer cropLiquidationSizeForProduct = productIDToCropLiqSetMap.get(combinationKey).size();
                if(cropLiquidationSizeForProduct <= 1){
                    if(liquidationToSubCropLiqMap.containsKey(subCropLiq.Crop_Liquidation__c)){
                        liquidationToSubCropLiqMap.get(subCropLiq.Crop_Liquidation__c).add(subCropLiq);
                    }else
                    {
                        List<Sub_Crop_Liquidation__c> tempsubCropLiqList = new List<Sub_Crop_Liquidation__c>();
                        tempsubCropLiqList.add(subCropLiq);
                        liquidationToSubCropLiqMap.put(subCropLiq.Crop_Liquidation__c, tempsubCropLiqList);        
                    }   
                }
                else{
                    Decimal subCropSum=0;
                    Sub_Crop_Liquidation__c previoussubCrop;
                    combinationKey= String.valueOf(subCropLiq.Crop_Liquidation__r.Liquidation__r.Product_Code__c)+String.valueOf(subCropLiq.Sub_Crops__c);
                    List<Sub_Crop_Liquidation__c> addtionalRecordList = productSubCropToSubCropLiqRecordMap.get(combinationKey);
                    List<Sub_Crop_Liquidation__c> clonedList = new List<Sub_Crop_Liquidation__c>();
                    for(Integer i=0;i< addtionalRecordList.size();i++){
                        Sub_Crop_Liquidation__c currentRecord = new Sub_Crop_Liquidation__c();
                        currentRecord.Crop_Liquidation__c = addtionalRecordList[i].Crop_Liquidation__c;
                        currentRecord.Sub_Crop_Liquidation_Value__c = addtionalRecordList[i].Sub_Crop_Liquidation_Value__c;
                        currentRecord.Sub_Crops__c = addtionalRecordList[i].Sub_Crops__c;
                        currentRecord.Is_Sub_Crop_Liquidation_Submitted__c = addtionalRecordList[i].Is_Sub_Crop_Liquidation_Submitted__c;
                        currentRecord.Sales_Org__c = addtionalRecordList[i].Sales_Org__c;
                        currentRecord.Liquidation__c = addtionalRecordList[i].Liquidation__c;
                        clonedList.add(currentRecord);
                    }
                    for(Sub_Crop_Liquidation__c subCropLiqRecord : addtionalRecordList){
                            subCropSum = subCropSum + subCropLiqRecord.Sub_Crop_Liquidation_Value__c;
                        }
                    	subCropLiq.Sub_Crop_Liquidation_Value__c = subCropSum;
                    	
                        if(liquidationToSubCropLiqMap.containsKey(subCropLiq.Crop_Liquidation__c)){
                            liquidationToSubCropLiqMap.get(subCropLiq.Crop_Liquidation__c).add(subCropLiq);
                        }else
                        {
                            List<Sub_Crop_Liquidation__c> tempsubCropLiqList = new List<Sub_Crop_Liquidation__c>();
                            tempsubCropLiqList.add(subCropLiq);
                            liquidationToSubCropLiqMap.put(subCropLiq.Crop_Liquidation__c, tempsubCropLiqList);        
                        }
                    	productSubCropToSubCropLiqRecordMap.get(combinationKey).clear();
                    	productSubCropToSubCropLiqRecordMap.put(combinationKey,clonedList);
                    
                    }
                }
        }
        
        
        return liquidationToSubCropLiqMap;
    }
   // Updated by Varun shrivastava : INCTASK0266628(INC0096506) Sub Crop Liquidation Changes End

}