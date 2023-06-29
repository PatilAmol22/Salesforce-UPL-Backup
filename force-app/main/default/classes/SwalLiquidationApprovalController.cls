/*
 * Written by: Sayan Majumder(crmconsultant3@upl-ltd.com) , 4/4/2021 6:46 pm    
 * Purpose: SWAL Liquidation Approval Aura Component supporting class
 * Included in: SwalLiquidationApproval, ProductLiquidationSWAL, CropLiquidationSWAL aura components
 * Test class name: SwalLiquidationApprovalController_Test
 * Visible to SWAl RM and ZMMs only
*/

public Without Sharing class SwalLiquidationApprovalController {
    public static List<Product2> productList = new List<Product2>();
    public static Map<String,List<String>> cropTosubCropMap = new Map<String,List<String>>();
    public static Map<String,List<Decimal>> subCropMap = new Map<String,List<Decimal>>();
    public static Map<String,List<Sub_Crop_Liquidation__c>> subCropFirstThreeColumns = new Map<String,List<Sub_Crop_Liquidation__c>>();
    public static Liquidation_Annual_Plan__c liquiAnnalPlanId = new Liquidation_Annual_Plan__c();
    public static List<Sub_Crops__c> subCropRecordList = new List<Sub_Crops__c>();
    public static Id rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    public static Id rtforLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    public static Id rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    @AuraEnabled
    public static list<Territory_Distributor__c> getsTerritories(){
        User u = [SELECT Profile.Name FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        List<Territory_Distributor__c> teriListForUser2 = new List<Territory_Distributor__c>();
        List<Territory_Distributor__c> ZMMLst = new List<Territory_Distributor__c>();
        teriListForUser2 = [SELECT Name
                            FROM Territory_Distributor__c 
                            WHERE Present_in_KEDE__c = true 
                            AND Neglected__c = false 
                            AND TerritoryCode__c != '#' 
                            AND TerritoryManager__c != null
                            AND (Regional_Manager_Id__c=: UserInfo.getUserId() OR FMM_User_Id__c=:UserInfo.getUserId())
                            AND Sales_Org_Code__c='1210'];
        if( teriListForUser2.size()>0 ){
            return teriListForUser2;
        }else{
            ZMMLst = [SELECT Name
                      FROM Territory_Distributor__c 
                      WHERE Present_in_KEDE__c = true 
                      AND Neglected__c = false 
                      AND TerritoryCode__c != '#' 
                      AND Sales_Org_Code__c='1210'
                      AND TerritoryManager__c != null
                      AND Regional_Manager_Id__c=null AND FMM_User_Id__c=null
                      AND (ZonalManager__c= :UserInfo.getUserId()
                           OR Zonal_Manager_Id__c= :UserInfo.getUserId()
                           OR Zonal_Marketing_Manager_1_Id__c =:UserInfo.getUserId() 
                           OR Zonal_Marketing_Manager_2_Id__c =:UserInfo.getUserId() 
                           OR Zonal_Marketing_Manager_2_Id__c =:UserInfo.getUserId() ) ];
            if( ZMMLst.size()>0 ){
                return ZMMLst;
            }else{
                if(u.Profile.Name=='System Administrator')
                    return [SELECT Name FROM Territory_Distributor__c WHERE Sales_Org_Code__c = '1210' AND Present_in_KEDE__c = true];
                else
                    return null;
            }
        }
    }
    
    @AuraEnabled
    public static String getFiscal_Year(){
        id rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        List <Liquidation_Annual_Plan__c> populateYearList = [select FIscal_Year__c 
                                                              FROM Liquidation_Annual_Plan__c 
                                                              WHERE Sales_Org__r.Sales_Org_Code__c='1210' 
                                                              AND RecordTypeId =:rtForAnnualPlan ORDER BY FIscal_Year__c DESC LIMIT 1];
        
        return populateYearList[0].FIscal_Year__c;
    }
    
    @AuraEnabled
    public static String getMonths(){
        Integer intMonth = Date.Today().month();
        if(intMonth == 1){
            intMonth = 12;
        }else{
            intMonth =intMonth-1;
        }
        Map<Integer,String> monthMap = new Map<Integer,String>();
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
        
        String mnth;
        mnth = monthMap.get(intMonth);
        return mnth;
    }
    
    @AuraEnabled
    public static list<Object> getsliquidationData(id territoryName,String FiscalYear,String Month){
        List<Liquidation2__c> liquiList = new List<Liquidation2__c>();
        
        Map<String,Liquidation2__c> liquidationMap_vf = new Map<String,Liquidation2__c> ();
        Map<String,Opening_Inventory2__c> OpeningInventoryMap_vf = new Map<String,Opening_Inventory2__c>();
        liquiAnnalPlanId  = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                             Fiscal_End_Date__c 
                             FROM Liquidation_Annual_Plan__c 
                             WHERE FIscal_Year__c=:FiscalYear
                             AND Territory_Name__c =:territoryName
                             AND RecordTypeId =:rtforAnnualPlan 
                             AND Sales_Org__r.Sales_Org_Code__c='1210' LIMIT 1];
        liquiList = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Product__r.Name,Product_Code__c,Product_Name__c,
                     Opening_Inventory__c,YTD_Sales__c,Total_Available_Stock__c,Total_Market_Inventory__c,
                     Type__c,submitted_Trade_SWAL__c,Month__c,Liquidation__c,Plan_for_the_month__c,Liquidation_YTD_current_month__c,Liquidation_YTD_current_month_Percentage__c,
                     Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                     //Added by Varun Start : SCTASK0459610 Start
                     Product_Budget__c, 
                     //Added by Varun Start : SCTASK0459610 End
                     Distributors_Inventory__c,Liquidation_YTD_SWAL__c,Plan_for_the_next_month__c,Territory__c,State__c
                     FROM Liquidation2__c
                     WHERE Territory__c=:territoryName
                     AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId.Id
                     AND RecordTypeId =:rtforLiquidation
                     AND Month__c=:Month];
        if(liquiList.size()>0){
            for(Liquidation2__c liqiObj :liquiList) {
                liquidationMap_vf.put(liqiObj.Product__c,liqiObj); 
            }
        }
        List<Opening_Inventory2__c> openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,Opening_Inventory__c,
                                                   YTD_Sales__c,Opening_Inventory_Cooperatives__c, Opening_Inventory_Govt__c,Product__c,
                                                   State__c,Territory__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                                                   YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                                                   YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c
                                                   FROM Opening_Inventory2__c 
                                                   WHERE Territory__c=:territoryName 
                                                   AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId.Id
                                                   AND RecordTypeId =: rtForOpeningInventory];
        if(openInvList.size()>0){
            OpeningInventoryMap_vf.clear();
            for(Opening_Inventory2__c openObj :openInvList){
                Opening_Inventory2__c openInvObjTemp = new Opening_Inventory2__c();
                openInvObjTemp =  openObj;
                String tmpMth = Month;
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
        }
        if(OpeningInventoryMap_vf.size() > 0  && liquidationMap_vf.size()>0){
            liquidationMap_vf = refreshProductList(OpeningInventoryMap_vf,liquidationMap_vf);
        }
        
        List<Object> s = new List<Object>();
        for(Integer i=0 ; i< productList.size() ;i++){
            Map<String, object> ProductLiquidationWrspper = new Map<String, object>();
            ProductLiquidationWrspper.put('Id', liquidationMap_vf.get(productList[i].Id).Id);
            ProductLiquidationWrspper.put('Brand_Name__c', productList[i].Product_Code__c);
            ProductLiquidationWrspper.put('Product_Name__c', productList[i].Name);
            ProductLiquidationWrspper.put('Opening_Inventory__c', OpeningInventoryMap_vf.get(productList[i].Id).Opening_Inventory__c);
            ProductLiquidationWrspper.put('YTD_Sales__c', OpeningInventoryMap_vf.get(productList[i].Id).YTD_Sales__c);
            ProductLiquidationWrspper.put('Total_Available_Stock__c', OpeningInventoryMap_vf.get(productList[i].Id).Opening_Inventory__c+OpeningInventoryMap_vf.get(productList[i].Id).YTD_Sales__c);
            ProductLiquidationWrspper.put('Distributors_Inventory__c', liquidationMap_vf.get(productList[i].Id).Distributors_Inventory__c);
            ProductLiquidationWrspper.put('Retailers_Inventory__c', liquidationMap_vf.get(productList[i].Id).Retailers_Inventory__c);
            ProductLiquidationWrspper.put('Total_Market_Inventory__c', liquidationMap_vf.get(productList[i].Id).Distributors_Inventory__c + liquidationMap_vf.get(productList[i].Id).Retailers_Inventory__c);
            ProductLiquidationWrspper.put('Plan_for_the_month__c', liquidationMap_vf.get(productList[i].Id).Plan_for_the_month__c);
            //Added by Varun Start : SCTASK0459610 Start
            ProductLiquidationWrspper.put('Product_Budget__c', liquidationMap_vf.get(productList[i].Id).Product_Budget__c);
            //Added by Varun Start : SCTASK0459610 End
            ProductLiquidationWrspper.put('Liquidation_YTD_current_month__c', liquidationMap_vf.get(productList[i].Id).Liquidation_YTD_current_month__c);
            ProductLiquidationWrspper.put('Liquidation_YTD_current_month_Percentage__c', liquidationMap_vf.get(productList[i].Id).Liquidation_YTD_current_month_Percentage__c/100);
            ProductLiquidationWrspper.put('Plan_for_the_next_month__c', liquidationMap_vf.get(productList[i].Id).Plan_for_the_next_month__c);
            s.add(ProductLiquidationWrspper);
        }
        return s;
    }
    //Added by Varun Shrivastava : Start
    @AuraEnabled
    public static Boolean fetchCustomSetting(){
        Boolean isLiquidationValidationEnabled = false;
         List<Multi_Country_Liquidation__c> liqSettingRecord = [Select Enable_Liq_Validation__c, Hide_Current_Month_Option__c from Multi_Country_Liquidation__c where Country__c   = 'SWAL' limit 1];           
            if(liqSettingRecord != null && liqSettingRecord.size() > 0){
                isLiquidationValidationEnabled = liqSettingRecord[0].Enable_Liq_Validation__c;  
            }
        return isLiquidationValidationEnabled;
    }
    //Added by Varun Shrivastava : End

    @AuraEnabled
    public static Map<String,Liquidation2__c> refreshProductList(Map<String,Opening_Inventory2__c> opnInvMap, Map<String,Liquidation2__c> liqMap){
        try{
            
            List<String> LiqProduct = new List<String>();
            LiqProduct.addAll(liqMap.keySet());//Changes made for product visibility by Deeksha
            List<Product2> pList = new List<Product2>();//Changes made for product visibility by Deeksha
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
        }catch(Exception ex){
            System.debug('Errot Message '+ex.getMessage());
            System.debug('Error Line Number '+ex.getLineNumber());
        }
        return liqMap;
    }
    
    @AuraEnabled
    public static List<Product2> allSort(List<Opening_Inventory2__c> t,List<Product2> pL){
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
    
    @AuraEnabled
    public static Map<String,List<String>> getCropLiquidationHeaders(id territoryName,String FiscalYear,String Month){
        List<Crop__c> cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                                        WHERE Active_for_Crop_Liquidation__c = true
                                        AND Active__c = true 
                                        AND Sales_Org_Code__c ='1210'
                                        AND Type__c ='Category'
                                        ORDER BY LastModifiedDate ASC];
        
        List<Sub_Crops__c> subCropRecordList = [Select Id,Name,Crop__c,Crop__r.Name from Sub_Crops__c where Crop__c in : cropNameListvf ORDER BY Crop__r.LastModifiedDate ASC];
        for(Sub_Crops__c sc: subCropRecordList) {
            if(cropTosubCropMap.containsKey(sc.Crop__r.Name) && cropTosubCropMap.get(sc.Crop__r.Name) != null) {
                List<String> Crops = cropTosubCropMap.get(sc.Crop__r.Name);
                Crops.add(sc.Name);
                cropTosubCropMap.put(sc.Crop__r.Name,Crops); 
            }   
            else {
                cropTosubCropMap.put(sc.Crop__r.Name, new List<String> {sc.Name});
            }
        }
        return cropTosubCropMap;
    }
    
    @AuraEnabled
    public static Map<String,decimal> getCropData(id territoryName,String FiscalYear,String Month){
        List<Crop__c> cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                                        WHERE Active_for_Crop_Liquidation__c = true
                                        AND Active__c = true 
                                        AND Sales_Org_Code__c ='1210'
                                        AND Type__c ='Category'
                                        ORDER BY LastModifiedDate ASC];
        
        List<Sub_Crops__c> subCropRecordList = [Select Name from Sub_Crops__c where Crop__c in : cropNameListvf ORDER BY Crop__r.LastModifiedDate ASC];
        List<Sub_Crop_Liquidation__c>subCropRecords = [SELECT Sub_Crops__r.Name,Sub_Crop_Liquidation_Value__c FROM Sub_Crop_Liquidation__c 
                                                       WHERE Liquidation__r.Territory__r.Id=:territoryName
                                                       AND Liquidation__r.Liquidation_Annual_Plan__r.FIscal_Year__c=:FiscalYear
                                                       AND Liquidation__r.Month__c=:Month
                                                       AND Sub_Crops__c IN:subCropRecordList
                                                       ORDER BY Crop_Liquidation__r.Crop__r.LastModifiedDate ASC];
        Map<String,decimal> mapOfSubCrops=new Map<String,decimal>();
        for(Sub_Crop_Liquidation__c temp:subCropRecords){
            mapOfSubCrops.put(temp.Sub_Crops__r.Name,temp.Sub_Crop_Liquidation_Value__c);
        }
        return mapOfSubCrops;
    }
    
    @AuraEnabled
    public static String getPageURL(){
        String URL = system.URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('Sayan URL: '+URL);
        return URL;
    }
    
    @AuraEnabled
    public static list<Object> liquiUpdate(List<Liquidation2__c> editList,id territoryName,String FiscalYear,String Month,Boolean UpdationStatus){
        try{
            List<Liquidation2__c> newEditList = new List<Liquidation2__c>();
            if(UpdationStatus){
                update editList;
                UpdateCropRecords(editList,territoryName,FiscalYear,Month);
            }else{
                for(Liquidation2__c temp:editList){
                    Liquidation2__c newLiq = new Liquidation2__c();
                    newLiq.Distributors_Inventory__c = 0.0;
                    newLiq.Retailers_Inventory__c = 0.0;
                    newLiq.Id = temp.Id;
                    newEditList.add(newLiq);
                }
                update newEditList;
                UpdateCropRecords(newEditList,territoryName,FiscalYear,Month);
            }
        }catch(Exception e){
            system.debug('ERROR --> '+e.getMessage());
        }
        list<Object> Result = getsliquidationData(territoryName,FiscalYear,Month);
        Return Result;
    }
    
    @AuraEnabled
    public static String Validation( id territoryName,String FiscalYear,String Month,id LiqId,String FieldName,Decimal FieldValue ){
        Set<Id> idSet = new Set<Id> ();
        idSet.add(LiqId);
        String QueryString;
        String WhatIsTheStatus;
        //Updated by Varun Shrivastava : SCTASK0459610  Start
        /*if( FieldName == 'Distributors_Inventory__c' ){
            QueryString = 'Retailers_Inventory__c';
        }else if( FieldName == 'Retailers_Inventory__c' ){
            QueryString = 'Distributors_Inventory__c';
        }*/
        //Updated by Varun Shrivastava : SCTASK0459610  Start
        
        String LiquidationId = LiqId;
        //String QuerySOQL = 'SELECT '+QueryString+',Total_Available_Stock__c FROM Liquidation2__c WHERE Id IN :idSet' ;
        String QuerySOQL = 'SELECT Id,Distributors_Inventory__c,Retailers_Inventory__c,Liquidation_YTD_Previous_Month__c,Total_Available_Stock__c,Opening_Inventory2__r.Opening_Inventory__c,' 
        +'Opening_Inventory2__r.YTD_Sales_Jan__c,Opening_Inventory2__r.YTD_Sales_Feb__c,Opening_Inventory2__r.YTD_Sales_Mar__c,Opening_Inventory2__r.YTD_Sales_Apr__c,'
        +'Opening_Inventory2__r.YTD_Sales_May__c,Opening_Inventory2__r.YTD_Sales_Jun__c,Opening_Inventory2__r.YTD_Sales_Jul__c,Opening_Inventory2__r.YTD_Sales_Aug__c,'
        +'Opening_Inventory2__r.YTD_Sales_Sept__c,Opening_Inventory2__r.YTD_Sales_Oct__c,Opening_Inventory2__r.YTD_Sales_Nov__c,Opening_Inventory2__r.YTD_Sales_Dec__c FROM Liquidation2__c WHERE Id IN :idSet' ;
        Liquidation2__c Result = database.query(QuerySOQL);
        //Added by Varun Shrivastava : SCTASK0459610 Start
        Decimal currentMonthLiquidation;
        Decimal ExistingValue;
        Decimal EnteredValue = FieldValue;
        Decimal YTDSalesValue;
        switch on Month {
            when 'Jan' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Jan__c;
            }
            when 'Feb' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Feb__c; 
            }
            when 'Mar' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Mar__c;
            }
            when 'Apr' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Apr__c; 
            }
            when 'May' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_May__c;
            }
            when 'Jun' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Jun__c;
                
            }
            when 'Jul' {  YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Jul__c;
                
            }
            when 'Aug' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Aug__c;                     
            }
            when 'Sept' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Sept__c;
            }
            when 'Oct' {  YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Oct__c;                      
            }
            when 'Nov' {  YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Nov__c;
            }
            when 'Dec' { YTDSalesValue = Result.Opening_Inventory2__r.YTD_Sales_Dec__c;                     
            }
            
        }
        if( FieldName == 'Distributors_Inventory__c' ){
            ExistingValue = Result.Retailers_Inventory__c;
            currentMonthLiquidation = Result.Opening_Inventory2__r.Opening_Inventory__c + YTDSalesValue - (EnteredValue + Result.Retailers_Inventory__c);
        
        }else if( FieldName == 'Retailers_Inventory__c' ){
            ExistingValue = Result.Distributors_Inventory__c;
            currentMonthLiquidation = Result.Opening_Inventory2__r.Opening_Inventory__c + YTDSalesValue - (EnteredValue + Result.Distributors_Inventory__c);
        }
        system.debug('Sayan Entered Value-->'+EnteredValue);
        if( ExistingValue + EnteredValue > Result.Total_Available_Stock__c ){
            WhatIsTheStatus = 'ERROR';
        }else{
            WhatIsTheStatus = 'SUCCESSFULL';
        }
        if(currentMonthLiquidation < Result.Liquidation_YTD_Previous_Month__c){
            WhatIsTheStatus = 'LIQUIDATION ERROR';
        }
        System.debug('Sayan-->'+WhatIsTheStatus);
        return WhatIsTheStatus;
    }
    
    
    @AuraEnabled
    public static List<Object> normalUpdate( String RecordId,Decimal PlanForNext,id territoryName,String FiscalYear,String Month ){
        Liquidation2__c ins = new Liquidation2__c();
        ins.Id = RecordId;
        ins.Plan_for_the_next_month__c = PlanForNext;
        UPDATE ins;
        List<Liquidation2__c> editList = new List<Liquidation2__c>();
        editList.add(ins);
        UpdateCropRecords(editList,territoryName,FiscalYear,Month);
        Return getsliquidationData(territoryName,FiscalYear,Month);
    }
    
    @AuraEnabled
    public static List<Object> OpeningInventoryUpdate( String RecordId,Decimal OI,id territoryName,String FiscalYear,String Month ){
        List<Liquidation2__c> lihere = [ SELECT Opening_Inventory2__c FROM Liquidation2__c WHERE Id=:RecordId ];
        Opening_Inventory2__c oihere = new Opening_Inventory2__c();
        oihere.Id = lihere[0].Opening_Inventory2__c;
        oihere.Opening_Inventory__c = OI;
        update oihere;
        
        Liquidation2__c ins = new Liquidation2__c();
        ins.Id = RecordId;
        ins.Distributors_Inventory__c = 0.0;
        ins.Retailers_Inventory__c = 0.0;
        UPDATE ins;
        
        List<Liquidation2__c> editList = new List<Liquidation2__c>();
        editList.add(ins);
        UpdateCropRecords(editList,territoryName,FiscalYear,Month);
        Return getsliquidationData(territoryName,FiscalYear,Month);
    }
    
    @AuraEnabled
    public static List<Object> UpdateNullValueAsZero( id territoryName,String FiscalYear,String Month,String FieldNameHere,String FieldIdHere  ){
        Liquidation2__c instance = new Liquidation2__c();
        instance.Id = FieldIdHere;
        if( FieldNameHere=='Distributors_Inventory__c' ){
            instance.Distributors_Inventory__c = 0.0;
            UPDATE instance;
        }else if( FieldNameHere=='Retailers_Inventory__c' ){
            instance.Retailers_Inventory__c = 0.0;
            UPDATE instance;
        }else if( FieldNameHere=='Plan_for_the_next_month__c' ){
            instance.Plan_for_the_next_month__c = 0.0;
            UPDATE instance;
        }
        if( FieldNameHere=='Opening_Inventory__c' ){
            OpeningInventoryUpdate( FieldIdHere,0.0,territoryName,FiscalYear,Month );
        }
        
        List<Liquidation2__c> editList = new List<Liquidation2__c>();
        editList.add(instance);
        UpdateCropRecords(editList,territoryName,FiscalYear,Month);
        Return getsliquidationData(territoryName,FiscalYear,Month);
    }
    
    
    
    
    @AuraEnabled
    public static String CheckIfLiquidationIsSubmittedApex( Id tId,String FY,String M ){
        String Message;
        List<Liquidation_Approval_History__c> previousRecordsOfApprovals = [SELECT Id,Approval_Status__c,Submitted_By__c 
                                                                            FROM Liquidation_Approval_History__c 
                                                                            WHERE 
                                                                            Territory__c=:tId 
                                                                            AND Month__c=:M 
                                                                            AND LAP__r.FIscal_Year__c=:FY 
                                                                            LIMIT 1];
        if(previousRecordsOfApprovals.size() == 1 ){
            if( previousRecordsOfApprovals[0].Approval_Status__c == 'Approved' ){
                Message = 'Approved' ;
            }else if( previousRecordsOfApprovals[0].Approval_Status__c == 'Rejected' ){
                Message = 'Rejected' ;
            }else if( previousRecordsOfApprovals[0].Approval_Status__c == 'Pending for Approval' ){
                Message = 'Pending';
            }
        }else{
            Message = 'Not Created' ;
        }
        return Message;
    }
    
    @AuraEnabled
    public static String ApproveAllData( Id tId,String FY,String M,String C ){
        String toast;
        List<Crop_Liquidation__c> cropdata = new List<Crop_Liquidation__c>();
        List<String> failedCrops = new List<String>();
        Map<String,Decimal> cropValidationList = new Map<String,Decimal>();
        Map<String,Decimal> cropValidationListFromLiq = new Map<String,Decimal>();
        List<Liquidation2__c> LiqListToCheck = new List<Liquidation2__c>();
        /*cropdata = [SELECT Id,Liquidation__r.Liquidation_YTD_SWAL__c,is_Crop_Liquidation_Submitted__c,
                    Liquidation__c,Total_Sub_Liq_Value__c,Liquidation_YTD_Trade__c
                    FROM Crop_Liquidation__c
                    WHERE Liquidation__r.Territory__c=:tId 
                    AND Liquidation__r.Liquidation_Annual_Plan__r.FIscal_Year__c=:FY 
                    AND Liquidation__r.Month__c=:M];
        if( cropdata.size() > 0 ){
            for( Crop_Liquidation__c v:cropdata ){
                if(cropValidationList.containsKey(v.Liquidation__c)){
                    Decimal SumValue = v.Total_Sub_Liq_Value__c + cropValidationList.get(v.Liquidation__c) ;
                    cropValidationList.put(v.Liquidation__c,SumValue);
                }else{
                    cropValidationList.put(v.Liquidation__c,v.Total_Sub_Liq_Value__c);
                }
            }
            if( cropValidationList.size() > 0 ){
                system.debug('Sayan cropValidationList-->'+cropValidationList);
                //Updated by Varun Shrivastava: INCTASK0583019: 6 Sept 2021 start
                //LiqListToCheck = [ SELECT Id,Liquidation_YTD_SWAL__c FROM Liquidation2__c WHERE Id IN:cropValidationList.keySet() ];
                LiqListToCheck = [ SELECT Id,Fixed_YTD_Sales__c	 FROM Liquidation2__c WHERE Id IN:cropValidationList.keySet() ];
                //Updated by Varun Shrivastava: INCTASK0583019: 6 Sept 2021 end
                if( LiqListToCheck.size() > 0 ){
                    for( Liquidation2__c j:LiqListToCheck ){
                        //Updated by Varun Shrivastava: INCTASK0583019: 6 Sept 2021 start
                        //cropValidationListFromLiq.put( j.Id,j.Liquidation_YTD_SWAL__c );
                        cropValidationListFromLiq.put( j.Id,j.Fixed_YTD_Sales__c );
                        //Updated by Varun Shrivastava: INCTASK0583019: 6 Sept 2021 End
                        
                    }
                }
            }
            if( cropValidationListFromLiq.size() > 0 && cropValidationList.size() > 0 ){
                for( String val:cropValidationListFromLiq.keySet() ){
                    if( cropValidationListFromLiq.get(val) != cropValidationList.get(val) ){
                        failedCrops.add(val);
                    }
                }
            }
        }
        if( failedCrops.size()>0 ){
            toast = 'Liquidation YTD sales and Crop sum is miss-match';
        }else{
	*/
            Liquidation_Approval_History__c CheckApprovalRecord = [SELECT Id,Approval_Status__c,Submitted_By__c,Comments__c,Territory__r.TerritoryManager__r.Email 
                                                                   FROM Liquidation_Approval_History__c 
                                                                   WHERE 
                                                                   Territory__c=:tId 
                                                                   AND Month__c=:M 
                                                                   AND LAP__r.FIscal_Year__c=:FY 
                                                                   AND Approval_Status__c = 'Pending for Approval'
                                                                   LIMIT 1];
            if(CheckApprovalRecord != null){
                try{
                    CheckApprovalRecord.Approval_Status__c = 'Approved';
                    if( C != null ){
                        CheckApprovalRecord.Comments__c = C;
                    }
                    if( CheckApprovalRecord.Territory__c != null && CheckApprovalRecord.Territory__r.TerritoryManager__c != null ){
                        CheckApprovalRecord.Territory_Manager_Email__c = CheckApprovalRecord.Territory__r.TerritoryManager__r.Email;
                    }
                    CheckApprovalRecord.Approved_Rejected_By__c = userinfo.getUserId();
                    update CheckApprovalRecord;
                    toast = 'Liquidation for this territory is Approved successfully';
                    if( cropdata.size() > 0 ){
                        List<Crop_Liquidation__c> cropLisToCheck = new List<Crop_Liquidation__c>();
                        for( Crop_Liquidation__c temp:cropdata ){
                            if( temp.is_Crop_Liquidation_Submitted__c == false ){
                                temp.is_Crop_Liquidation_Submitted__c = true;
                                cropLisToCheck.add(temp);
                            }
                        }
                        if( cropLisToCheck.size() > 0 ){
                            UPDATE cropLisToCheck;
                        }
                    }
                }catch(Exception e){
                    toast = 'Failed to Approve records';
                }
                
         //   }
        }
        
        return toast;
    }
    
    @AuraEnabled
    public static String RejectAllData( Id tId,String FY,String M,String C ){
        List<Liquidation2__c> unSubmitLiqRecords = [SELECT Id,submitted_Trade_SWAL__c FROM Liquidation2__c WHERE Territory__c=:tId 
                                                    AND Liquidation_Annual_Plan__r.Fiscal_Year__c=:FY AND Month__c=:M ];
        if(unSubmitLiqRecords.size() > 0 ){
            for(Liquidation2__c tempLi:unSubmitLiqRecords){
                tempLi.submitted_Trade_SWAL__c = false;
            }
            update unSubmitLiqRecords;
        }
        
        
        String toast;
        Liquidation_Approval_History__c CheckApprovalRecord = [SELECT Id,Approval_Status__c,Submitted_By__c,Comments__c,Territory__r.TerritoryManager__r.Email 
                                                               FROM Liquidation_Approval_History__c 
                                                               WHERE 
                                                               Territory__c=:tId 
                                                               AND Month__c=:M 
                                                               AND LAP__r.FIscal_Year__c=:FY 
                                                               AND Approval_Status__c = 'Pending for Approval'
                                                               LIMIT 1];
        if(CheckApprovalRecord != null){
            try{
                CheckApprovalRecord.Approval_Status__c = 'Rejected';
                if( C != null ){
                    CheckApprovalRecord.Comments__c = C;
                }
                CheckApprovalRecord.Approved_Rejected_By__c = userinfo.getUserId();
                if( CheckApprovalRecord.Territory__c != null && CheckApprovalRecord.Territory__r.TerritoryManager__c != null ){
                    CheckApprovalRecord.Territory_Manager_Email__c = CheckApprovalRecord.Territory__r.TerritoryManager__r.Email;
                }
                update CheckApprovalRecord;
                toast = 'Liquidation for this territory is Rejected successfully';
            }catch(Exception e){
                toast = 'Failed to Reject records';
            }
            
        }
        return toast;
    }
    
    
    
    @AuraEnabled
    public static String getTerritoryName(Id tId){
        String name = [ SELECT Name FROM Territory_Distributor__c WHERE Id=:tId LIMIT 1][0].Name;
        return name;
    }
    
    
    
    @AuraEnabled
    public static void UpdateCropRecords(List<Liquidation2__c> UpdatedLiquidationList,id territoryName,String FiscalYear,String Month){
        List<String> ProductIdsToCheck = new List<String>();
        List<Crop_Liquidation__c> ListToDelete = new List<Crop_Liquidation__c>();
        List<Crop_Liquidation__c> ListToUpdate = new List<Crop_Liquidation__c>();
        List<Liquidation2__c> noCropLiqData = new List<Liquidation2__c>();
        
        List<Crop_Liquidation__c> checkYTD = new List<Crop_Liquidation__c>();
        checkYTD = [ SELECT Id,Liquidation__r.Liquidation_YTD_SWAL__c,Liquidation_YTD_Trade__c FROM Crop_Liquidation__c WHERE Liquidation__c IN:UpdatedLiquidationList ];
        
        //checking if Crop record existing for the updated products
        if( checkYTD.size() > 0 ){
            for( Crop_Liquidation__c v:checkYTD ){
                //checking if the existing crop product is eligible or not
                if( !(v.Liquidation__r.Liquidation_YTD_SWAL__c > 0) ){
                    //this list is for those crops which must not exist cause their YTD swal value is now Zero
                    ListToDelete.add(v);
                }else{
                    //this list is for those crops which must be edited with the updated YTD SWAL value (if any)
                    ListToUpdate.add(v);
                }
            }
            if( ListToDelete.size()>0 ){
                DELETE ListToDelete;
            }
            if( ListToUpdate.size()>0 ){
                for( Crop_Liquidation__c k:ListToUpdate ){
                    k.Liquidation_YTD_Trade__c = k.Liquidation__r.Liquidation_YTD_SWAL__c;
                }
                UPDATE ListToUpdate;
            }
        }else{
            //if crop records are not existing for the updated products
            noCropLiqData = [ SELECT Id,Product__c FROM Liquidation2__c WHERE Id IN: UpdatedLiquidationList AND Fixed_YTD_Sales__c>0 /*Liquidation_YTD_SWAL__c>0*/ ];
            if( noCropLiqData.size() > 0 ){
                //taking those records where YTD swal is more than zero and crop/sub crop records must be created for them
                for( Liquidation2__c v: noCropLiqData ){
                    ProductIdsToCheck.add(v.Product__c);
                }
            }
            if( ProductIdsToCheck.size()>0 ){
                CreateCropandSubCropforMissingProducts(ProductIdsToCheck,territoryName,Month,FiscalYear);
            }
        }
    }
    
    @AuraEnabled
    public static void CreateCropandSubCropforMissingProducts(List<String> ProductIdsToCreateRecords,String teriIdhere,String monthhere,String annualPlanhere){
        List<Crop__c> cropNameListvf = new List<Crop__c>();
        cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                          WHERE Active_for_Crop_Liquidation__c = true
                          AND Active__c = true 
                          AND Sales_Org_Code__c ='1210'
                          AND Type__c ='Category'
                          ORDER BY LastModifiedDate ASC];
        Map<Id,List<Sub_Crops__c>> CropSubCropMapHere = new Map<Id,List<Sub_Crops__c>>();
        Map<String,Liquidation2__c> mapliqhere = new Map<String,Liquidation2__c>();
        Id rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
        List<Crop_Liquidation__c> crpListCreateHere = new List<Crop_Liquidation__c>();
        List<Liquidation2__c> liqListhere = new List<Liquidation2__c>();
        liqListhere = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                       Product__c,Month__c,Liquidation__c,
                       Territory__c,submitted_Trade_SWAL__c,Liquidation_YTD_SWAL__c 
                       FROM Liquidation2__c
                       WHERE Territory__c=: teriIdhere
                       AND Month__c=:monthhere
                       AND Liquidation_Annual_Plan__r.Fiscal_Year__c=:annualPlanhere
                       AND submitted_Trade_SWAL__c = true
                       //AND Liquidation_YTD_SWAL__c>0 
                       AND Fixed_YTD_Sales__c>0
                       AND Product__c IN:ProductIdsToCreateRecords];
        
        
        for(Liquidation2__c liobj :liqListhere){
            mapliqhere.put(liobj.Product__c,liobj);
        }
        if(ProductIdsToCreateRecords.size()>0){
            List<Crop__c> cropListhere = new List<Crop__c>();
            //we need to add sales org for Crop List
            cropListhere = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                            WHERE Active_for_Crop_Liquidation__c = true
                            AND Active__c = true 
                            AND Sales_Org_Code__c ='1210'
                            AND Type__c ='Category'
                            ORDER BY LastModifiedDate ASC];
            
            
            Crop_Liquidation__c CropLiquidationObjhere;
            for(String proObj: ProductIdsToCreateRecords){
                for(Crop__c crpObj: cropListhere){
                    CropLiquidationObjhere = new Crop_Liquidation__c();
                    CropLiquidationObjhere.Crop__c = crpObj.Id;
                    CropLiquidationObjhere.Liquidation__c = mapliqhere.get(proObj).Id;
                    CropLiquidationObjhere.Liquidation_Value__c = 0.00;
                    
                    CropLiquidationObjhere.Liquidation_YTD_Trade__c = mapliqhere.get(proObj).Liquidation_YTD_SWAL__c ;
                    CropLiquidationObjhere.Sales_Org__c = mapliqhere.get(proObj).Liquidation_Annual_Plan__r.Sales_Org__c;
                    CropLiquidationObjhere.recordTypeId = rtForCropLiquidation;
                    crpListCreateHere.add(CropLiquidationObjhere);
                }
                
            }//End of Outer Product Loop
            System.debug('### crpListCreateHere.size() '+crpListCreateHere.size());
            System.debug('### crpListCreateHere '+crpListCreateHere);
            if(crpListCreateHere.size()>0){
                insert crpListCreateHere;   
            }
            
        }
        Map<String,List<Crop_Liquidation__c>> CropLiqProductIdMap = new Map<String,List<Crop_Liquidation__c>>();
        for(Crop_Liquidation__c var:crpListCreateHere){
            if(CropLiqProductIdMap.containsKey(var.Liquidation__r.Product__c)){
                List<Crop_Liquidation__c> cListHere = CropLiqProductIdMap.get(var.Liquidation__r.Product__c);
                cListHere.add(var);
                CropLiqProductIdMap.put(var.Liquidation__r.Product__c, cListHere);
                
            }else{
                List<Crop_Liquidation__c> CroListHere = New List<Crop_Liquidation__c>();
                CroListHere.add(var);
                CropLiqProductIdMap.put(var.Liquidation__r.Product__c, CroListHere);
            }
        }
        List<Sub_Crops__c> subCropRecordListHere = [Select Id,Name,Crop__c from Sub_Crops__c where Crop__c in : cropNameListvf order by Crop__c, Name];
        
        for(Sub_Crops__c subCropRecord : subCropRecordListHere){
            if(CropSubCropMapHere.containsKey(subCropRecord.Crop__c)){
                CropSubCropMapHere.get(subCropRecord.Crop__c).add(subCropRecord);
            }else{
                List<Sub_Crops__c> subCropListHere = new List<Sub_Crops__c>();
                subCropListHere.add(subCropRecord);
                CropSubCropMapHere.put(subCropRecord.Crop__c, subCropListHere); 
            }
            
        }
        List<Sub_Crop_Liquidation__c> subCropLiqInsertListHere = new List<Sub_Crop_Liquidation__c>();
        if(CropLiqProductIdMap.size() > 0){
            for(String pr : CropLiqProductIdMap.keySet()){
                for(Crop_Liquidation__c cropLiqRecord : CropLiqProductIdMap.get(pr)){
                    for(Sub_Crops__c subCropRecord : CropSubCropMapHere.get(cropLiqRecord.Crop__c)){
                        Sub_Crop_Liquidation__c subCropLiq = new Sub_Crop_Liquidation__c();
                        subCropLiq.Crop_Liquidation__c = cropLiqRecord.ID;
                        subCropLiq.Sub_Crop_Liquidation_Value__c = 0;
                        subCropLiq.Sub_Crops__c = subCropRecord.Id;
                        subCropLiq.Is_Sub_Crop_Liquidation_Submitted__c = false;
                        subCropLiq.Liquidation__c = cropLiqRecord.Liquidation__c;
                        subCropLiq.Sales_Org__c = cropLiqRecord.Sales_Org__c;
                        subCropLiqInsertListHere.add(subCropLiq);
                        
                        /*if(liquidationToSubCropLiqMap.containsKey(cropLiqRecord.ID)){
liquidationToSubCropLiqMap.get(cropLiqRecord.ID).add(subCropLiq);
}else
{
List<Sub_Crop_Liquidation__c> subCropLiqList = new List<Sub_Crop_Liquidation__c>();
subCropLiqList.add(subCropLiq);
liquidationToSubCropLiqMap.put(cropLiqRecord.ID, subCropLiqList);        
}*/
                    }
                }
            }    
            if(subCropLiqInsertListHere.size() > 0)
                insert subCropLiqInsertListHere;
        }
    }
    
}