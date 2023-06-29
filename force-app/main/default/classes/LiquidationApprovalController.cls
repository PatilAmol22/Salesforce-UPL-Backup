public without sharing class LiquidationApprovalController {
    public static string Month;
    public static List<Product2> productList = new List<Product2>();  
    public static Liquidation_Annual_Plan__c liquiAnnalPlanId = new Liquidation_Annual_Plan__c();
    
    @AuraEnabled
    public static list<Territory_Distributor__c> getTerritories(){
        list<Territory_Distributor__c> rTerritory = new list<Territory_Distributor__c>();
        list<Territory_Distributor__c> tTerritory = new list<Territory_Distributor__c>();
        list<Territory_Distributor__c> sTerritory = new list<Territory_Distributor__c>();
        id userId;
        userId =UserInfo.getUserId();
        User u = [SELECT Profile.Name FROM User WHERE Id=:userId LIMIT 1];
        if(u.Profile.Name=='Regional/Zonal Managers'){
            //Sales_Org_Code__c='1000'
            rTerritory = [select id, name from Territory_Distributor__c where  TerritoryManager__c!=null and (Zonal_Marketing_Manager_1_Id__c =:userId 
                                                                                                                                          OR Zonal_Marketing_Manager_2_Id__c =:userId 
                                                                                                                                          OR Zonal_Marketing_Manager_3_Id__c =:userId
                                                                                                                                          OR Zonal_Manager_Id__c=:userId) ];
        }
        if(u.Profile.Name=='SBU Profile'){
            tTerritory = [select id, name from Territory_Distributor__c where TerritoryManager__c!=null 
                          AND (Zonal_Marketing_Manager_1_Id__c =null 
                               AND Zonal_Marketing_Manager_2_Id__c =null
                               AND Zonal_Marketing_Manager_3_Id__c =null
                               AND Zonal_Manager_Id__c=null ) 
                          AND (SBU__r.SBUMarketingheads__c=:userId                                                 
                               OR SBU__r.SBUUser__c=:userId)];
        }
        if(u.Profile.Name=='System Administrator'){
            sTerritory = [SELECT Name FROM Territory_Distributor__c WHERE Sales_Org_Code__c = '1000' AND Present_in_KEDE__c = true];
        }
       
        if (rTerritory != null && rTerritory.size()>0){
            return rTerritory;
        }
        else if(tTerritory!= null && tTerritory.size()>0){
           return tTerritory;
        }
        else if(sTerritory!= null && sTerritory.size()>0){
            return sTerritory;
        }
        else {  
            return null;
        }       
    }
    
    @AuraEnabled
    public static string getFYData(){
        string yearFY;
        Liquidation_Annual_Plan__c populateYearList = [select FIscal_Year__c 
                                                       FROM Liquidation_Annual_Plan__c 
                                                       WHERE Sales_Org__r.Sales_Org_Code__c='1000' ORDER BY FIscal_Year__c DESC LIMIT 1];
        
        if(populateYearList!=null)
            yearFY = populateYearList.FIscal_Year__c;
        return yearFY;
    }
    
    @AuraEnabled
    public static string getMonth(){
        Integer intMonth = Date.Today().month();
        if(intMonth == 1){ intMonth = 12;
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
        
        String monthFY;
        monthFY = monthMap.get(intMonth);      
        return monthFY;     
    }  
    
    @AuraEnabled
    public static list<Object> getliquidation(id territoryName,string FiscalYear,string mon){
        System.debug('** FiscalYear : '+FiscalYear);
        System.debug('** month : '+mon);
        List<Liquidation2__c> liquiList = new List<Liquidation2__c>();
        
        Map<String,Liquidation2__c> liquidationMap_vf = new Map<String,Liquidation2__c> ();
        Map<String,Opening_Inventory2__c> OpeningInventoryMap_vf = new Map<String,Opening_Inventory2__c>();
        
        System.debug('** selectedTerritory : '+territoryName);
        liquiAnnalPlanId= [ SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                           Fiscal_End_Date__c 
                           FROM Liquidation_Annual_Plan__c 
                           WHERE FIscal_Year__c=:FiscalYear
                           AND Territory_Name__c =:territoryName and Sales_Org_Code__c  = '1000' LIMIT 1];
        
        
        system.debug('**Liquidation_Annual_Plan : ' +liquiAnnalPlanId);
        if(liquiAnnalPlanId!=null){
            
            liquiList = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,Product__r.Name,Product_Code__c,Product_Name__c,
                         Opening_Inventory__c,YTD_Sales__c,Total_Available_Stock__c,Total_Market_Inventory__c,
                         Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,Liquidation_YTD_current_month__c,Liquidation_YTD_current_month_Percentage__c,
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,Is_Current_Month_Liquidation__c,
                         //Added by Varun Start : SCTASK0459610 Start
                         Product_Budget__c, 
                         //Added by Varun Start : SCTASK0459610 End
                         Distributors_Inventory__c,Liquidation_YTD_Trade__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c
                         WHERE Territory__c=:territoryName
                         AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId.Id
                         AND Month__c=:mon];
        }
        system.debug('** liquiList : ' +liquiList);
        Month = mon;
        system.debug('** Liqui Month : ' +Month);
        if(liquiList.size()>0){
            for(Liquidation2__c liqiObj :liquiList) {
                liquidationMap_vf.put(liqiObj.Product__c,liqiObj); 
            }
        }
        system.debug('** liquidationMap_vf : ' +liquidationMap_vf);
        List<Opening_Inventory2__c> openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,Opening_Inventory__c,
                                                   YTD_Sales__c,Opening_Inventory_Cooperatives__c, Opening_Inventory_Govt__c,Product__c,
                                                   State__c,Territory__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,YTD_Sales_Mar__c,YTD_Sales_Apr__c,
                                                   YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,YTD_Sales_Aug__c,YTD_Sales_Sept__c,
                                                   YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c
                                                   FROM Opening_Inventory2__c 
                                                   WHERE Territory__c=:territoryName 
                                                   AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId.Id ];
        system.debug('** openInvList : ' +openInvList);
        if(openInvList.size()>0){
            system.debug('** Inside If openInvList : ' +openInvList);
            OpeningInventoryMap_vf.clear();
            for(Opening_Inventory2__c openObj :openInvList){
                Opening_Inventory2__c openInvObjTemp = new Opening_Inventory2__c();
                openInvObjTemp =  openObj;
                String tmpMth = Month;
                switch on tmpMth {
                    when 'Jan' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jan__c;
                    }
                    when 'Feb' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Feb__c; 
                    }
                    when 'Mar' {
                        openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Mar__c;
                    }
                    when 'Apr' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Apr__c; 
                    }
                    when 'May' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_May__c;
                    }
                    when 'Jun' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jun__c;
                        
                    }
                    when 'Jul' {  openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jul__c;
                        
                    }
                    when 'Aug' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Aug__c;                     
                    }
                    when 'Sept' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Sept__c;
                    }
                    when 'Oct' {  openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Oct__c;                      
                    }
                    when 'Nov' {  openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Nov__c;
                    }
                    when 'Dec' { openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Dec__c;                     
                    }
                    
                }// end of Switch
                //OpeningInventoryMap_vf.put(openObj.Product__c, openObj);
                OpeningInventoryMap_vf.put(openObj.Product__c, openInvObjTemp);
            }
        }
        system.debug('** OpeningInventoryMap_vf : ' +OpeningInventoryMap_vf);
        if(OpeningInventoryMap_vf.size() > 0  && liquidationMap_vf.size()>0){
            system.debug('** Inside If liquidationMap_vf : ' +liquidationMap_vf);
            liquidationMap_vf = refreshProductList(OpeningInventoryMap_vf,liquidationMap_vf);
        }
        
        List<Object> s = new List<Object>();
        for(Integer i=0 ; i< productList.size() ;i++){
            system.debug('** Inside If productList : ' +productList);
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
            system.debug('** Distributors_Inventory__c : ' +liquidationMap_vf.get(productList[i].Id).Id);
            system.debug('** Distributors_Inventory__c : ' +liquidationMap_vf.get(productList[i].Id).Distributors_Inventory__c);
            system.debug('** Retailers_Inventory__c : '  +liquidationMap_vf.get(productList[i].Id).Retailers_Inventory__c);
            system.debug('** ProductLiquidationWrspper : ' +ProductLiquidationWrspper);
            s.add(ProductLiquidationWrspper);
        }
        system.debug('** LiquidationWrapper : ' +s);
        if(s!=null){
            return s;
        }
        else{
            return null;
        }
    }
    
    //Added by Varun Shrivastava : Start
    @AuraEnabled
    public static Boolean fetchCustomSetting(){
        Boolean isLiquidationValidationEnabled = false;
            List<Multi_Country_Liquidation__c> liqSettingRecord = [Select Enable_Liq_Validation__c, Hide_Current_Month_Option__c from Multi_Country_Liquidation__c where Country__c = 'India' limit 1];           
            if(liqSettingRecord != null && liqSettingRecord.size() > 0){
             isLiquidationValidationEnabled = liqSettingRecord[0].Enable_Liq_Validation__c;
            }
        return isLiquidationValidationEnabled;
    }
    //Added by Varun Shrivastava : End

    @AuraEnabled
    public static Map<String,Liquidation2__c> refreshProductList(Map<String,Opening_Inventory2__c> opnInvMap, Map<String,Liquidation2__c> liqMap){
        system.debug('** opnInvMap : ' +opnInvMap);
        system.debug('** opnInvMap : ' +liqMap);
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
                if(pMap.get(k1).Brand_Type__c == 'Power Brand'){
                    if(opnInvMap.containsKey(k1) && liqMap.containsKey(k1)){
                        t1.add(opnInvMap.get(k1));
                    }
                }
            }
            List<Opening_Inventory2__c> t2 = new List<Opening_Inventory2__c>();
            for(Id k2 : pMap.keySet()){
                if(pMap.get(k2).Brand_Type__c == 'Strategic Brand'){
                    if(opnInvMap.containsKey(k2) && liqMap.containsKey(k2)){ t2.add(opnInvMap.get(k2));
                    }
                }
            }
            
            List<Opening_Inventory2__c> t4 = new List<Opening_Inventory2__c>();
            for(Id k4 : pMap.keySet()){
                if(pMap.get(k4).Brand_Type__c != 'Power Brand' && pMap.get(k4).Brand_Type__c != 'Strategic Brand'){
                    if(opnInvMap.containsKey(k4) && liqMap.containsKey(k4)){ t4.add(opnInvMap.get(k4));
                    }
                }
            }
            productList.addAll(allSort(t1,pList));
            productList.addAll(allSort(t2,pList));
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
                            if(!opnInvMap.containsKey(prd)){ liqMap.remove(prd); 
                                productMap.remove(prd);
                            }   
                        }    
                    }else
                        if(opnInvMap.size() > liqMap.size()){
                            for(Id prd : opnInvMap.keySet()){
                                if(!liqMap.containsKey(prd)){ opnInvMap.remove(prd); 
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
        system.debug('** all Sort OpenInven : ' +t);
        system.debug('** all sort Product : ' +pL);
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
    public static String liquiApprove( Id tId,String FY,String M,String commentHistory ){
        String toast;
        List<Crop_Liquidation__c> cropdata = new List<Crop_Liquidation__c>();
        List<String> failedCrops = new List<String>();
        Map<String,Decimal> cropValidationList = new Map<String,Decimal>();
        Map<String,Decimal> cropValidationListFromLiq = new Map<String,Decimal>();
        List<Liquidation2__c> LiqListToCheck = new List<Liquidation2__c>();
       /* cropdata = [SELECT Id,Liquidation__r.Liquidation_YTD_Trade__c,is_Crop_Liquidation_Submitted__c,Liquidation__c,Liquidation_Value__c,Liquidation_YTD_Trade__c
                    FROM Crop_Liquidation__c
                    WHERE Liquidation__r.Territory__c=:tId 
                    AND Liquidation__r.Liquidation_Annual_Plan__r.FIscal_Year__c=:FY 
                    AND Liquidation__r.Month__c=:M];
        if( cropdata.size() > 0 ){
            for( Crop_Liquidation__c v:cropdata ){
                if(cropValidationList.containsKey(v.Liquidation__c)){
                    Decimal SumValue = v.Liquidation_Value__c + cropValidationList.get(v.Liquidation__c) ;
                    cropValidationList.put(v.Liquidation__c,SumValue);
                }else{
                    cropValidationList.put(v.Liquidation__c,v.Liquidation_Value__c);
                }
            }
            if( cropValidationList.size() > 0 ){
                //Updated by Varun Shrivastava: INCTASK0583019: 6 Sept 2021 start
               // LiqListToCheck = [ SELECT Id,Liquidation_YTD_Trade__c FROM Liquidation2__c WHERE Id IN:cropValidationList.keySet() ];
                LiqListToCheck = [ SELECT Id,Fixed_YTD_Sales__c FROM Liquidation2__c WHERE Id IN:cropValidationList.keySet() ];
                //Updated by Varun Shrivastava: INCTASK0583019: 6 Sept 2021 End
                
                if( LiqListToCheck.size() > 0 ){
                    for( Liquidation2__c j:LiqListToCheck ){
                        //Updated by Varun Shrivastava: INCTASK0583019: 6 Sept 2021 start
               			//cropValidationListFromLiq.put( j.Id,j.Liquidation_YTD_Trade__c );
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
            Liquidation_Approval_History__c CheckApprovalRecord = [SELECT Id,Approval_Status__c,Submitted_By__c,Comments__c 
                                                                   FROM Liquidation_Approval_History__c 
                                                                   WHERE 
                                                                   Territory__c=:tId 
                                                                   AND Month__c=:M 
                                                                   AND LAP__r.FIscal_Year__c=:FY 
                                                                   AND Approval_Status__c = 'Pending for Approval'LIMIT 1];
            if(CheckApprovalRecord != null){
                try{  CheckApprovalRecord.Approval_Status__c = 'Approved';
                    if( commentHistory != null ){  CheckApprovalRecord.Comments__c = commentHistory;
                    }
                    CheckApprovalRecord.Approved_Rejected_By__c = userinfo.getUserId();
                    update CheckApprovalRecord;
                    toast = 'Liquidation for this territory is Approved successfully';
                    if( cropdata.size() > 0 ){  List<Crop_Liquidation__c> cropLisToCheck = new List<Crop_Liquidation__c>();
                        for( Crop_Liquidation__c temp:cropdata ){
                            if( temp.is_Crop_Liquidation_Submitted__c == false ){ temp.is_Crop_Liquidation_Submitted__c = true;
                                cropLisToCheck.add(temp);
                            }
                        }
                        if( cropLisToCheck.size() > 0 ){ UPDATE cropLisToCheck;
                        }
                    }
                }catch(Exception e){  toast = 'Failed to Approve records';
                }
                
          //  }
        }
        system.debug('**toast' +toast);
        return toast;
    }
    
    @AuraEnabled
    public static String liquiReject( Id tId,String FY,String M,String commentHistory ){
        List<Liquidation2__c> unSubmitLiqRecords = [SELECT Id,submitted_trade__c FROM Liquidation2__c WHERE Territory__c=:tId 
                                                    AND Liquidation_Annual_Plan__r.Fiscal_Year__c=:FY AND Month__c=:M ];
        if(unSubmitLiqRecords.size() > 0 ){
            for(Liquidation2__c tempLi:unSubmitLiqRecords){
                tempLi.submitted_trade__c = false;
                //  tempLi.Approval_Status__c='Rejected'
                //  tempLi.Comments__c=commentHistory;
            }
            update unSubmitLiqRecords;
        }
        
        
        String toast;
        Liquidation_Approval_History__c CheckApprovalRecord = [SELECT Id,Approval_Status__c,Submitted_By__c 
                                                               FROM Liquidation_Approval_History__c 
                                                               WHERE 
                                                               Territory__c=:tId 
                                                               AND Month__c=:M 
                                                               AND LAP__r.FIscal_Year__c=:FY 
                                                               AND Approval_Status__c = 'Pending for Approval'LIMIT 1];
        if(CheckApprovalRecord != null){
            try{
                CheckApprovalRecord.Approval_Status__c = 'Rejected';
                CheckApprovalRecord.Comments__c=commentHistory;
                CheckApprovalRecord.Approved_Rejected_By__c = userinfo.getUserId();
                update CheckApprovalRecord;
                toast = 'Liquidation for this territory is Rejected successfully';
            }catch(Exception e){
                toast = 'Failed to Reject records';
            }
            
        }
        return toast;
    } 
    @AuraEnabled
    public static string getAlreadyApprovedRecord(id sTerritory,string currentFY, string currentMonth){
        system.debug('** sTerritory : '+sTerritory);
        system.debug('** currentFY : '+currentFY);
        system.debug('** currentMonth: '+currentMonth);
        string Message;
        list<Liquidation_Approval_History__c> previousRecordsOfApprovals = new list<Liquidation_Approval_History__c>();
        if(sTerritory!=null)
        { 
            previousRecordsOfApprovals = [select id,Territory__c,Approval_Status__c
                                          from Liquidation_Approval_History__c where Territory__c=:sTerritory AND Month__c=:currentMonth
                                          AND LAP__r.Fiscal_Year__c=:currentFY LIMIT 1];
        }
        system.debug('**previousRecordsOfApprovals : '+previousRecordsOfApprovals);
        if(previousRecordsOfApprovals.size() == 1 ){
            if( previousRecordsOfApprovals[0].Approval_Status__c == 'Approved' ){
                Message = 'Approved' ;
            }else if( previousRecordsOfApprovals[0].Approval_Status__c == 'Rejected' ){
                Message = 'Rejected' ;
            }else if( previousRecordsOfApprovals[0].Approval_Status__c == 'Pending for Approval' ){
                Message = 'Pending';
            }
        } else{
            Message = 'Not Created' ;
        }   
        
        system.debug('** Message ' +Message);
        if(Message!=null){      
            return Message;
        }
        else{
            return null;
        }
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
        list<Object> Result = getliquidation(territoryName,FiscalYear,Month);
        Return Result;
    }
    
    @AuraEnabled
    public static String Validation( id territoryName,String FiscalYear,String Month,id LiqId,String FieldName,Decimal FieldValue){
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
        System.debug('Liq Record Fetched : '+Result);
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
        
        
        //Added by Varun Shrivastava : SCTASK0459610 End
        if( ExistingValue + EnteredValue > Result.Total_Available_Stock__c ){
            WhatIsTheStatus = 'ERROR';
        }else{
            WhatIsTheStatus = 'SUCCESSFULL';
        }
        if(currentMonthLiquidation < Result.Liquidation_YTD_Previous_Month__c){
            WhatIsTheStatus = 'LIQUIDATION ERROR';
        }
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
        Return getliquidation(territoryName,FiscalYear,Month);
    }
    
    @AuraEnabled
    public static List<Object> OpenInventoryUpdate(String RecordId,Decimal OpenInventory,id territoryName,String FiscalYear,String Month){
        system.debug('**OpenInventory -> ' +OpenInventory);
        
        string openInvId;
        Liquidation2__c llid = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,
                                Opening_Inventory__c,Retailers_Inventory__c, Distributors_Inventory__c
                                FROM Liquidation2__c
                                WHERE id = :RecordId limit 1];
        
        system.debug('** liquidation list -> ' +llid);  
        
        openInvId = llid.Opening_Inventory2__c; 
        
        system.debug('** liquidation Opening Inventory ID -> ' +openInvId);
        
        Liquidation2__c liqUpdate = new Liquidation2__c();
        liqUpdate.Id = RecordId;
        liqUpdate.Distributors_Inventory__c = 0.0;
        liqUpdate.Retailers_Inventory__c = 0.0;
        UPDATE liqUpdate;
        
        system.debug('** liquidation Update -> ' +liqUpdate);
        
        List<Opening_Inventory2__c> openInvList = [select id,Name,Liquidation_Annual_Plan__c,Opening_Inventory__c
                                                   FROM Opening_Inventory2__c 
                                                   WHERE id=:openInvId];
        
        system.debug('** Open Inventory List-> ' +openInvList);
        
        List<Opening_Inventory2__c> updatedOpenInv = new List<Opening_Inventory2__c>();                                                
        if(openInvList.size()>0 && openInvList!=null){
            system.debug('** Inside Updated OpenInventory ');
            for(Opening_Inventory2__c openInv: openInvList){
                openInv.Opening_Inventory__c=OpenInventory;
                updatedOpenInv.add(openInv);
            }
        }
        
        update  updatedOpenInv;
        
        system.debug('** Updated OpenInventory -> ' +updatedOpenInv);
        List<Liquidation2__c> editList = new List<Liquidation2__c>();
        editList.add(liqUpdate);
        UpdateCropRecords(editList,territoryName,FiscalYear,Month);
        Return getliquidation(territoryName,FiscalYear,Month);
    }
    
    @AuraEnabled
    public static List<Object> UpdateNullValueAsZero( id territoryName,String FiscalYear,String Month,String FieldNameHere,String FieldIdHere  ){
        Liquidation2__c instance = new Liquidation2__c();
        instance.Id = FieldIdHere;
        if( FieldNameHere=='Distributors_Inventory__c' ){
            instance.Distributors_Inventory__c = 0.0;
        }else if( FieldNameHere=='Retailers_Inventory__c' ){
            instance.Retailers_Inventory__c = 0.0;
        }else if( FieldNameHere=='Plan_for_the_next_month__c' ){
            instance.Plan_for_the_next_month__c = 0.0;
        }else if( FieldNameHere=='Opening_Inventory__c' ){
            instance.Distributors_Inventory__c = 0.0;
            instance.Retailers_Inventory__c = 0.0;
            OpenInventoryUpdate(FieldIdHere,0.0,territoryName,FiscalYear,Month);
        }
        UPDATE instance;
        List<Liquidation2__c> editList = new List<Liquidation2__c>();
        editList.add(instance);
        UpdateCropRecords(editList,territoryName,FiscalYear,Month);
        Return getliquidation(territoryName,FiscalYear,Month);
    }
    
    @AuraEnabled
    public static String getPageURL(){
        String URL = system.URL.getSalesforceBaseUrl().toExternalForm();
        return URL;
    }
        @AuraEnabled
    public static void UpdateCropRecords(List<Liquidation2__c> UpdatedLiquidationList,id territoryName,String FiscalYear,String Month){
        List<String> ProductIdsToCheck = new List<String>();
        List<Crop_Liquidation__c> ListToDelete = new List<Crop_Liquidation__c>();
        List<Crop_Liquidation__c> ListToUpdate = new List<Crop_Liquidation__c>();
        List<Liquidation2__c> noCropLiqData = new List<Liquidation2__c>();
        
        List<Crop_Liquidation__c> checkYTD = new List<Crop_Liquidation__c>();
        checkYTD = [ SELECT Id,Liquidation__r.Liquidation_YTD_Trade__c,Liquidation_YTD_Trade__c FROM Crop_Liquidation__c WHERE Liquidation__c IN:UpdatedLiquidationList ];
        
        //checking if Crop record existing for the updated products
        if( checkYTD.size() > 0 ){
            system.debug('Priya inside where crop records exist for updated products');
            for( Crop_Liquidation__c v:checkYTD ){
                //checking if the existing crop product is eligible or not
                if( !(v.Liquidation__r.Liquidation_YTD_Trade__c > 0) ){ ListToDelete.add(v);
                }else{
                    //this list is for those crops which must be edited with the updated YTD value (if any)
                    ListToUpdate.add(v);
                }
            }
            if( ListToDelete.size()>0 ){ DELETE ListToDelete;
             system.debug('Priya inside Delete crop records exist for updated products');
            }
            if( ListToUpdate.size()>0 ){
                for( Crop_Liquidation__c k:ListToUpdate ){
                    k.Liquidation_YTD_Trade__c = k.Liquidation__r.Liquidation_YTD_Trade__c;
                }
                UPDATE ListToUpdate;
            }
        }else{
            system.debug('^^Priya more than 0 YTD inside where crop records exist for updated products');
            //if crop records are not existing for the updated products
            noCropLiqData = [ SELECT Id,Product__c FROM Liquidation2__c WHERE Id IN: UpdatedLiquidationList AND Fixed_YTD_Sales__c>0 /*Liquidation_YTD_Trade__c>0*/ ];
            system.debug('^^noCropLiqData --> ' +noCropLiqData);
            if( noCropLiqData.size() > 0 ){
                system.debug('^^ inside loop noCropLiqData --> ' +noCropLiqData);
                //taking those records where YTD swal is more than zero and crop/sub crop records must be created for them
                for( Liquidation2__c v: noCropLiqData ){
                    system.debug('^^ inside for loop');
                    ProductIdsToCheck.add(v.Product__c);
                    system.debug('^^ check product' +ProductIdsToCheck);
                }
            }
            if( ProductIdsToCheck.size()>0 ){
                system.debug('^^ inside check crop for loop');
                CreateCropandSubCropforMissingProducts(ProductIdsToCheck,territoryName,Month,FiscalYear);
            }
        }
    }
    
    @AuraEnabled
    public static void CreateCropandSubCropforMissingProducts(List<String> ProductIdsToCreateRecords,String teriIdhere,String monthhere,String annualPlanhere){
        system.debug('^^Priya inside CreateCropandSubCropforMissingProducts ->' +ProductIdsToCreateRecords);
        List<Crop__c> cropNameListvf = new List<Crop__c>();
        cropNameListvf = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                          WHERE Active_for_Crop_Liquidation__c = true
                          AND Active__c = true 
                          AND Sales_Org_Code__c ='1000'
                          AND Type__c ='Crop'
                          ORDER BY LastModifiedDate ASC];
        system.debug('^^Priya cropNameListvf ->' +cropNameListvf);
        Map<Id,List<Sub_Crops__c>> CropSubCropMapHere = new Map<Id,List<Sub_Crops__c>>();
        Map<String,Liquidation2__c> mapliqhere = new Map<String,Liquidation2__c>();
        Id rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
        List<Crop_Liquidation__c> crpListCreateHere = new List<Crop_Liquidation__c>();
        List<Liquidation2__c> liqListhere = new List<Liquidation2__c>();
        liqListhere = [select id,Name,Liquidation_Annual_Plan__c,Liquidation_Annual_Plan__r.Sales_Org__c,
                       Product__c,Month__c,Liquidation__c,
                       Territory__c,submitted_trade__c,Liquidation_YTD_Trade__c 
                       FROM Liquidation2__c
                       WHERE Territory__c=: teriIdhere
                       AND Month__c=:monthhere
                       AND Liquidation_Annual_Plan__r.Fiscal_Year__c=:annualPlanhere
                       AND submitted_trade__c = true
                       //AND Liquidation_YTD_Trade__c>0 
                       AND Fixed_YTD_Sales__c>0
                       AND Product__c IN:ProductIdsToCreateRecords];
        
        system.debug('^^Priya liqListhere ->' +liqListhere);
        for(Liquidation2__c liobj :liqListhere){
            mapliqhere.put(liobj.Product__c,liobj);
        }
        if(ProductIdsToCreateRecords.size()>0){
            List<Crop__c> cropListhere = new List<Crop__c>();
            //we need to add sales org for Crop List
            cropListhere = [Select Id,Name,Active_for_Crop_Liquidation__c FROM Crop__c 
                            WHERE Active_for_Crop_Liquidation__c = true
                            AND Active__c = true 
                            AND Sales_Org_Code__c ='1000'
                            AND Type__c ='Crop'
                            ORDER BY LastModifiedDate ASC];
            
            
            Crop_Liquidation__c CropLiquidationObjhere;
            for(String proObj: ProductIdsToCreateRecords){
                for(Crop__c crpObj: cropListhere){
                    CropLiquidationObjhere = new Crop_Liquidation__c();
                    CropLiquidationObjhere.Crop__c = crpObj.Id;
                    CropLiquidationObjhere.Liquidation__c = mapliqhere.get(proObj).Id;
                    CropLiquidationObjhere.Liquidation_Value__c = 0.00;
                    
                    CropLiquidationObjhere.Liquidation_YTD_Trade__c = mapliqhere.get(proObj).Liquidation_YTD_Trade__c ;
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
    }
    
     
}