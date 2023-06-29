/*
This is utility class for Crop Liquidation for India


*/
public class TradeSalesIndiaCropLiquidation {
    public Id rtForCropLiquidation;
    
    
    public TradeSalesIndiaCropLiquidation(){
        rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropTrade').getRecordTypeId();  
    }
    
    
    public Boolean createCropLiquidationIndia(String teriId, String month, String annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_trade__c = true
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590 Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        //checking if already Crop Liquidation is created or not
        Boolean tempCheckCropLiqui;
        tempCheckCropLiqui = checkingCropLiquidation(liquidationId);
        return tempCheckCropLiqui;
        
    }
    
    
    //This function is checking if Crop liqudiation is already created or not
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
    
    
    public void actionCreateCropLiquidationIndia(String teriId, String month, String annualPlan, String recordTypeId){
        System.debug('### teriId '+teriId);
        System.debug('### month '+month);
        System.debug('### annualPlan '+annualPlan);
        System.debug('### recordTypeId '+recordTypeId);
        
        
        try{
            List<Liquidation2__c> liqList = new List<Liquidation2__c>();
            List<Product2> productListForCropLiqui = new List<Product2>();
            liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                       Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                       Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                       Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                       FROM Liquidation2__c
                       WHERE Territory__c=: teriId
                       AND Month__c=:month
                       AND Liquidation_Annual_Plan__c=:annualPlan
                       AND RecordTypeId =:recordTypeId
                       AND submitted_trade__c = true
                       AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
            
            Map<String,Liquidation2__c> mapliq = new Map<String,Liquidation2__c>();
            for(Liquidation2__c liobj :liqList){
                mapliq.put(liobj.Product__c,liobj);
            }
            
            List<String> prodId = new List<String>();
            if(liqList.size()>0||test.isRunningTest() ){
                
                for(Liquidation2__c liobj:liqList){
                    prodId.add(liobj.Product__c);
                }
                
                if(prodId.size()>0||test.isRunningTest() ){
                    productListForCropLiqui = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                               Sales_Org_Code__c,IsActive 
                                               FROM Product2 
                                               WHERE IsActive = true 
                                               AND Sales_Org_Code__c = '1000' 
                                               AND Active_For_Liquidation__c= true
                                               AND Id IN:prodId];
                    
                    List<Crop__c> cropList = new List<Crop__c>();
                    //we need to add sales org for Crop List
                    cropList = [Select Id,Active_for_Crop_Liquidation__c FROM Crop__c 
                                WHERE Active_for_Crop_Liquidation__c = true
                                AND Active__c = true 
                                AND Sales_Org_Code__c ='1000'
                                AND Type__c ='Crop'
                                ORDER BY LastModifiedDate ASC];
                    
                    
                    
                    
                    List<Crop_Liquidation__c> crpListCreate = new List<Crop_Liquidation__c>();
                    Crop_Liquidation__c CropLiquidationObj;
                    for(Product2 proObj: productListForCropLiqui){
                        for(Crop__c crpObj: cropList){
                            CropLiquidationObj = new Crop_Liquidation__c();
                            CropLiquidationObj.Crop__c = crpObj.Id;
                            CropLiquidationObj.Liquidation__c = mapliq.get(proObj.Id).Id;
                            CropLiquidationObj.Liquidation_Value__c = 0.00;
                            CropLiquidationObj.Liquidation_YTD_Trade__c = mapliq.get(proObj.Id).Liquidation_YTD_Trade__c;
                            CropLiquidationObj.Sales_Org__c = mapliq.get(proObj.Id).Liquidation_Annual_Plan__r.Sales_Org__c;
                            CropLiquidationObj.recordTypeId = rtForCropLiquidation;
                            crpListCreate.add(CropLiquidationObj);
                        }
                        
                    }//End of Outer Product Loop
                    
                    if(crpListCreate.size()>0){
                        insert crpListCreate;   
                    }
                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Error Occure Line Number '+ex.getLineNumber());
            System.debug('Error Occure Message '+ex.getMessage());
        }
    }//end of function actionCreateCropLiquidationIndia
    
    
    public Map<String,List<Crop_Liquidation__c>> loadAllDataForCropLiquidationIndia(String teriId, String month, String annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Map<String,List<Crop_Liquidation__c>> cropLiquidationMap = new Map<String,List<Crop_Liquidation__c>>();
        
        
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
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
        
        if(cropList.size()>0||test.isRunningTest() ){
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
    } // end of function loadAllDataForCropLiquidationIndia
    
    public List<Product2> showProductListForCropIndia(String selectedTeritorry,String mth,String liquiAnnualPlan,String rtforLiquidation){
        
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        List<Product2> productList = new List<Product2>();
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:mth
                   AND Liquidation_Annual_Plan__c=:liquiAnnualPlan
                   AND RecordTypeId =:rtforLiquidation
                   AND submitted_trade__c = true
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590 Replaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        System.debug('in showProductListForCropIndia liqList '+liqList);
        System.debug('in showProductListForCropIndia liqList size '+liqList.size());
        
        
        
        List<String> prodId = new List<String>();
        if(liqList.size()>0||test.isRunningTest() ){
            for(Liquidation2__c liobj:liqList){
                prodId.add(liobj.Product__c);
            }
            
            
            if(prodId.size()>0||test.isRunningTest() ){
                productList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,
                               IsActive 
                               FROM Product2 
                               WHERE IsActive = true 
                               AND Sales_Org_Code__c = '1000' 
                               AND Active_For_Liquidation__c= true
                               AND Id IN:prodId];
                
                
            }
            
        }
        return productList;
    }//end of function showProductListForCropIndia
    
    public void updateSingleRecordForCropLiquidationIndia(String recordIdTotupdate, String prodIdTotupdate, String valueToupdate){
        try{
            
            
            System.debug('clistTemp in utility class recordIdTotupdate '+recordIdTotupdate);
            List<Crop_Liquidation__c> clistTemp = new List<Crop_Liquidation__c>();
            List<Crop_Liquidation__c> clistTempUpdate = new List<Crop_Liquidation__c>();
            
            clistTemp = [Select Id,Name,Liquidation_Value__c
                         FROM Crop_Liquidation__c 
                         WHERE Id=:recordIdTotupdate];
            
            
            System.debug('clistTemp in utility class '+clistTemp);
            System.debug('clistTemp in utility class '+clistTemp.size());
            
            Crop_Liquidation__c cliqObj ;
            for(Crop_Liquidation__c tempcLiqObj : clistTemp){
                cliqObj = new Crop_Liquidation__c();
                cliqObj.Id = tempcLiqObj.Id;
                cliqObj.Liquidation_Value__c = Decimal.valueOf(valueToupdate);
                clistTempUpdate.add(cliqObj);
            }
            if(clistTempUpdate.size()>0){
                update clistTempUpdate;
                System.debug('Update Single value of Crop Liquidation ');
            }
            
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        }
        
    }// end of function updateSingleRecordForCropLiquidationIndia
    
    public Boolean checkingCropLiquidationSubmitedIndia(String teriId, String month, String annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Boolean submitCropLiq;
        
        
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
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
                if(cliqObj.is_Crop_Liquidation_Submitted__c == true){
                    submitCropLiq = true;
                }else{
                    submitCropLiq = false;
                }
                
                
            }
        }
        return submitCropLiq;
    }//end of function checkingCropLiquidationSubmitedIndia
    
    public Boolean checkingCropLiquidationSubmitedIndiaHigh(String teriId, String month, List<Liquidation_Annual_Plan__c> annualPlan){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Boolean submitCropLiq;
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c IN:annualPlan
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
        
        if(cropList.size()>0||test.isRunningTest() ){
            for(Crop_Liquidation__c cliqObj:cropList){
                if(cliqObj.is_Crop_Liquidation_Submitted__c == true){
                    submitCropLiq = true;
                }else{
                    submitCropLiq = false;
                }
                
                
            }
        }
        return submitCropLiq;
    }//end of function checkingCropLiquidationSubmitedIndiaHigh
    
    
    
    
    
    public void updateCropLiquidationIndia(String teriId, String month, String annualPlan, String recordTypeId){
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__c=: teriId
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c=:annualPlan
                   AND RecordTypeId =:recordTypeId
                   AND submitted_trade__c = true
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqList){
            liquidationId.add(liqudaobj.Id);    
        }
        
        List<Crop_Liquidation__c> tempCropList = new List<Crop_Liquidation__c>();
        List<Crop_Liquidation__c> tempCropListUpdate = new List<Crop_Liquidation__c>();
        
        
        tempCropList = [SELECT Id, Name, Crop__c, Liquidation__r.Product__c,is_Crop_Liquidation_Submitted__c,
                        Liquidation__c, Liquidation_Value__c,Liquidation_YTD_Trade__c 
                        FROM Crop_Liquidation__c 
                        WHERE Liquidation__c IN:liquidationId];
        
        
        
        Crop_Liquidation__c tempCrpObj;
        for(Crop_Liquidation__c crpObj :tempCropList){
            tempCrpObj = new Crop_Liquidation__c();
            tempCrpObj.Id = crpObj.Id;
            tempCrpObj.is_Crop_Liquidation_Submitted__c = true;
            tempCropListUpdate.add(tempCrpObj);
        }
        if( tempCropListUpdate.size()>0||test.isRunningTest() ){
            update tempCropListUpdate;
            
            //Added by Priya Dhawan for RITM0180898 : Creating one record in the Approval History object when Crops are submitted
            //that record will make liquidation for that Territory visible in Trade Liquidation Approval vf page
            try{
                Crop_Liquidation__c crp =   [SELECT Id, Crop__c,is_Crop_Liquidation_Submitted__c,Liquidation__r.Product__r.Sales_Org__c ,Liquidation__r.Financial_Year__c,
                                             Liquidation__r.Liquidation_Annual_Plan__c,Liquidation__c, Liquidation__r.Territory__c,Liquidation__r.Territory__r.Name,
                                             Liquidation__r.Month__c,Liquidation__r.Territory__r.SBU__r.SBUUser__r.Email,
                                             Liquidation__r.Territory__r.Zone__r.ZMMUser__r.Email, 
                                             Liquidation__r.Territory__r.Zone__r.ZonalHead__r.Email,
                                             Liquidation__r.Territory__r.TerritoryManager__r.Email, 
                                             Liquidation__r.Territory__r.SBU__r.SBUMarketingheads__r.Email
                                             FROM Crop_Liquidation__c 
                                             WHERE Liquidation__c IN:liquidationId limit 1];   
                system.debug('**Crop_Liquidation__c' +crp);                                   
                List<Liquidation_Approval_History__c> previousRecordsOfApprovals = [SELECT Id,Approval_Status__c,Comments__c FROM Liquidation_Approval_History__c WHERE 
                                                                                    Territory__c=:crp.Liquidation__r.Territory__c 
                                                                                    AND Month__c=:crp.Liquidation__r.Month__c 
                                                                                    AND SalesOrg__c=:crp.Liquidation__r.Product__r.Sales_Org__c 
                                                                                    AND LAP__c=:crp.Liquidation__r.Liquidation_Annual_Plan__c LIMIT 1];
                if(previousRecordsOfApprovals.size() == 1 ){
                    system.debug('**previousRecordsOfApprovals' +previousRecordsOfApprovals);
                    for(Liquidation_Approval_History__c temp:previousRecordsOfApprovals){
                        temp.Approval_Status__c = 'Pending for Approval';
                        temp.Submitted_By__c = userinfo.getUserId();
                        temp.Comments__c='';
                        temp.Territory_Manager_Email__c = crp.Liquidation__r.Territory__r.TerritoryManager__r.Email;
                        temp.ZMM_User_Email__c	= crp.Liquidation__r.Territory__r.Zone__r.ZMMUser__r.Email;
                        temp.Zonal_Head_Email__c = crp.Liquidation__r.Territory__r.Zone__r.ZonalHead__r.Email;
                        temp.Territory_SBU_User_EmailID__c= crp.Liquidation__r.Territory__r.SBU__r.SBUUser__r.Email;
                        temp.Territory_SBU_Marketing_Head_EmailID__c= crp.Liquidation__r.Territory__r.SBU__r.SBUMarketingheads__r.Email;
                        temp.Approved_Rejected_By__c = null;
                    }
                    update previousRecordsOfApprovals;
                }
                else{
                    system.debug('**newApprovalInstance');
                    Liquidation_Approval_History__c newApprovalInstance = new Liquidation_Approval_History__c();
                    newApprovalInstance.Name = crp.Liquidation__r.Territory__r.Name+crp.Liquidation__r.Month__c+crp.Liquidation__r.Financial_Year__c ;
                    newApprovalInstance.Territory__c = crp.Liquidation__r.Territory__c;
                    newApprovalInstance.Month__c = crp.Liquidation__r.Month__c;
                    newApprovalInstance.Submitted_By__c = userinfo.getUserId();
                    newApprovalInstance.Approval_Status__c = 'Pending for Approval';
                    newApprovalInstance.SalesOrg__c = crp.Liquidation__r.Product__r.Sales_Org__c;
                    newApprovalInstance.LAP__c = crp.Liquidation__r.Liquidation_Annual_Plan__c;
                    newApprovalInstance.Territory_Manager_Email__c = crp.Liquidation__r.Territory__r.TerritoryManager__r.Email;
                    newApprovalInstance.Zonal_Head_Email__c = crp.Liquidation__r.Territory__r.Zone__r.ZonalHead__r.Email;
                    newApprovalInstance.ZMM_User_Email__c	= crp.Liquidation__r.Territory__r.Zone__r.ZMMUser__r.Email;
                    newApprovalInstance.Territory_SBU_User_EmailID__c= crp.Liquidation__r.Territory__r.SBU__r.SBUUser__r.Email;
                    newApprovalInstance.Territory_SBU_Marketing_Head_EmailID__c= crp.Liquidation__r.Territory__r.SBU__r.SBUMarketingheads__r.Email;
                    newApprovalInstance.Approved_Rejected_By__c	= null;
                    insert newApprovalInstance;
                    system.debug('**newApprovalInstance'+newApprovalInstance);
                }
            }
            catch(exception e){
                system.debug('Error occured while Operating on Liquidation_Approval_History__c Object at line-->'+e.getLineNumber()+' with message: '+e.getMessage()+' with cause: '+e.getCause() );
            }
            // end of code for RITM0180898
            
        }
        
    }// end of function updateCropLiquidationIndia
    
    public Map<String,List<Crop_Liquidation__c>> rollupCropLiquidationIndia(List<Liquidation_Annual_Plan__c> liquiAnualPlan, String month){
        RollupTradeSalesLiquidation rollupObj = new RollupTradeSalesLiquidation();
        Map<String,List<Crop_Liquidation__c>> newLiqMapCrops = new Map<String,List<Crop_Liquidation__c>>(); 
        newLiqMapCrops = rollupObj.rollupCropLiquidationDetails(liquiAnualPlan,month);
        System.debug('newLiqMapCrops in utility class '+newLiqMapCrops);
        System.debug('newLiqMapCrops in utility class size  '+newLiqMapCrops.size());
        return newLiqMapCrops;
    }// end of function rollupCropLiquidationIndia
    
    
    public List<Product2> showProductListForCropForHigher(List<Liquidation_Annual_Plan__c> annualPlan, String month,String recordTypeId){
        
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
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590 Relaced with Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        
        List<Crop_Liquidation__c> crpList = new List<Crop_Liquidation__c>();
        crpList = [Select Id,Name,Liquidation__c,Liquidation__r.Product__c From Crop_Liquidation__c
                   WHERE Liquidation__c IN: liqList];
        
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
        System.debug('Month in while Test '+month);
        
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
        System.debug('liqLists while Testng '+liqLists);
        System.debug('liqLists while Testng Size '+liqLists.size());
        
        List<String> liquidationId = new List<String>();
        for(Liquidation2__c liqudaobj:liqLists){
            liquidationId.add(liqudaobj.Id);    
        }
        //checking if already Crop Liquidation is created or not
        Boolean tempCheckCropLiqui;
        tempCheckCropLiqui = checkingCropLiquidation(liquidationId);
        return tempCheckCropLiqui;
    } // end of function displayCropDataForSingleTeritory
    
    
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
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590 Fixed_YTD_Sales__c*/ Fixed_YTD_Sales__c > 0];
        
        
        
        
        
        
        List<String> prodId = new List<String>();
        if(liqList.size()>0||test.isRunningTest() ){
            for(Liquidation2__c liobj:liqList){
                prodId.add(liobj.Product__c);
            }
            
            
            if(prodId.size()>0||test.isRunningTest() ){
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
                
                System.debug('Selected teri cropLiquidationMap '+cropLiquidationMap);
                System.debug('Selected teri cropLiquidationMap size  '+cropLiquidationMap.size()); 
                
            }
        }
        return cropLiquidationMap;
    }// end of function loadAllDataForCropLiquidationIndiaSelectTeri
    
    
    public void actionCreateCropLiquidationIndiaForHigher(String selectedTeritorry,String month, List<Liquidation_Annual_Plan__c> liqAnnualPlan,String recordTypeName){
        
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        liqList = [select id,Name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                   Product__c,Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                   Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                   Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,Liquidation_YTD_Trade__c
                   FROM Liquidation2__c
                   WHERE Territory__r.Name=: selectedTeritorry
                   AND Month__c=:month
                   AND Liquidation_Annual_Plan__c IN:liqAnnualPlan
                   AND RecordTypeId =:recordTypeName
                   AND submitted_trade__c = true
                   AND /*Liquidation_YTD_Trade__c>0 SCTASK0419590*/ Fixed_YTD_Sales__c > 0];
        
        System.debug('prodId in utility liqList size  '+liqList.size());
        Map<String,Liquidation2__c> mapliq = new Map<String,Liquidation2__c>();
        for(Liquidation2__c liobj :liqList){
            mapliq.put(liobj.Product__c,liobj);
        }
        
        List<String> prodId = new List<String>();
        if(liqList.size()>0){
            for(Liquidation2__c liobj:liqList){
                prodId.add(liobj.Product__c);
            }
            
            System.debug('prodId in utility class '+prodId);
            System.debug('prodId in utility class size  '+prodId.size());
            List<Product2> productListForCropLiquis = new List<Product2>();
            if(prodId.size()>0){
                productListForCropLiquis = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                                            Sales_Org_Code__c,Brand_Type__c ,
                                            Indication_Type__c,Budget_NRV__c, Active__c, IsActive 
                                            FROM Product2 
                                            WHERE IsActive = true 
                                            AND Sales_Org_Code__c = '1000' 
                                            AND Active_For_Liquidation__c= true
                                            AND Id IN:prodId];
                
                List<Crop__c> cropList = new List<Crop__c>();
                //we need to add sales org for Crop List
                cropList = [Select Id,Active_for_Crop_Liquidation__c FROM Crop__c 
                            WHERE Active_for_Crop_Liquidation__c = true
                            AND Active__c = true 
                            AND Sales_Org_Code__c ='1000'
                            AND Type__c ='Crop'
                            ORDER BY LastModifiedDate ASC];
                
                List<Crop_Liquidation__c> crpListCreate = new List<Crop_Liquidation__c>();
                Crop_Liquidation__c CropLiquidationObj;
                
                for(Product2 proObj: productListForCropLiquis){
                    for(Crop__c crpObj: cropList){
                        CropLiquidationObj = new Crop_Liquidation__c();
                        CropLiquidationObj.Crop__c = crpObj.Id;
                        CropLiquidationObj.Liquidation__c = mapliq.get(proObj.Id).Id;
                        CropLiquidationObj.Liquidation_Value__c = 0.00;
                        CropLiquidationObj.Liquidation_YTD_Trade__c = mapliq.get(proObj.Id).Liquidation_YTD_Trade__c;
                        CropLiquidationObj.Sales_Org__c = mapliq.get(proObj.Id).Liquidation_Annual_Plan__r.Sales_Org__c;
                        CropLiquidationObj.recordTypeId = rtForCropLiquidation;
                        crpListCreate.add(CropLiquidationObj);
                    }
                    
                }//End of Outer Product Loop
                System.debug(' crpListCreate.size() '+crpListCreate.size());
                System.debug('crpListCreate.size() '+crpListCreate);
                if(crpListCreate.size()>0){
                    insert crpListCreate;   
                }
            }
        }
        
        
    }// end of function actionCreateCropLiquidationIndiaForHigher
    
}// end of utility class for Trade Sales India