/* 
*	Created By	:	Sohel Shaikh (IBM)
*	Description	:	This is controller for LiquidationReport VF page
*/

public without sharing class  LiquidationReportController {

    public List<LiquidationReportController.LiquidationTableWrapper> listLiquidationTableWrapper {get; set;}
    public Map<String, Product2> productMap {get; set;}
    public Map<String, Opening_Inventory2__c> OpeningInventoryMap_vf {get;set;}
    public Map<String, Liquidation2__c> liquidationMap_vf {get; set;}
    public List<Product2> productList;
    public List<Opening_Inventory2__c> openingInventoryList;
    public List<Opening_Inventory2__c> openInvList;
    public List<Liquidation2__c> liquidationList;
    public List<Liquidation2__c> liquiList;
    public List<Liquidation_Annual_Plan__c> liquidationAnnualPlan;
    public String territoryName {get; set;}
    public String fiscalYear {get; set;}
    public String month {get; set;}
    public String salesOrgCode;
    public Territory_Distributor__c territoryObj{get;set;}
    public Id rtForAnnualPlan;
    public Id rtForOpeningInventory;
    public Id rtForLiquidation;

    public LiquidationReportController(){
        productMap = new Map<String, Product2>();
        listLiquidationTableWrapper = new List<LiquidationReportController.LiquidationTableWrapper>();
        liquidationAnnualPlan = new List<Liquidation_Annual_Plan__c>();
        OpeningInventoryMap_vf = new Map<String, Opening_Inventory2__c>();
        liquidationMap_vf = new Map<String, Liquidation2__c>();
        populateLiquidationData();
    }

    public void populateLiquidationData(){
        territoryName = System.currentPageReference().getParameters().get('territoryName');
        fiscalYear = System.currentPageReference().getParameters().get('fiscalYear');
        month = System.currentPageReference().getParameters().get('month');
        salesOrgCode = System.currentPageReference().getParameters().get('salesOrgCode');
        Boolean flg = salesOrgCode.containsIgnoreCase('1000');
        if (salesOrgCode.containsIgnoreCase('1000')) {
            rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
            rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
            rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();    
        }
        if(salesOrgCode.containsIgnoreCase('1210')){
            rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
            rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
            rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId(); 
        } 
        productList = [SELECT Id,Name, product_code__C,ProductCode,Active_For_Liquidation__c, 
                            Sales_Org_Code__c,Brand_Type__c ,
                            Indication_Type__c,Budget_NRV__c, IsActive 
                            FROM Product2 
                            WHERE IsActive = true 
                            AND Sales_Org_Code__c =: salesOrgCode 
                            AND Active_For_Liquidation__c= true
                      ];
        for(Product2 prdct : productList){
            productMap.put(prdct.Id, prdct);
        }
        List<Territory_Distributor__c> teriList;
        teriList = [SELECT id,Name,TerritoryManager__c,SalesOrg__c FROM Territory_Distributor__c 
                    WHERE Present_in_KEDE__c = true
                   	AND Name =: territoryName
                   	AND  Sales_Org_Code__c =: salesOrgCode
                   ];
        if(null != teriList && teriList.size() != 0){
            territoryObj = teriList[0];
            liquidationAnnualPlan = [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c, Fiscal_Start_Date__c, 
                                           Fiscal_End_Date__c 
                                           FROM Liquidation_Annual_Plan__c 
                                           WHERE Fiscal_Year__c =: fiscalYear
                                           AND Territory_Name__c =: territoryObj.Id
                                           AND RecordTypeId =:rtforAnnualPlan 
                                           AND Sales_Org__r.Sales_Org_Code__c=: salesOrgCode
                                    ];
        }
        if(null != territoryObj && null != liquidationAnnualPlan && liquidationAnnualPlan.size() > 0){
            loadDataForSelectedMonth(String.valueOf(territoryObj.id), String.valueOf(liquidationAnnualPlan[0].Id));
        }      
    }

    public void loadDataForSelectedMonth(String territoryName , String liquiAnnalPlanId){
        try{
            Boolean isSubmitted = false;
            Map<String, Opening_Inventory2__c> tempOpenInvMap = new Map<String, Opening_Inventory2__c>();
            Map<String, Liquidation2__c> tempLiqMap = new Map<String, Liquidation2__c>();
            liquiList = new List <Liquidation2__c>(); 
            liquiList = [select id, name,Opening_Inventory2__c,Liquidation_Annual_Plan__c,Product__c,
                         Type__c,submitted_trade__c,Month__c,Liquidation__c,Plan_for_the_month__c,
                         Inventory_in_Kg_Cooperatives__c,Inventory_in_Kg_Govt__c,Retailers_Inventory__c,
                         Distributors_Inventory__c,Plan_for_the_next_month__c,Territory__c,State__c
                         FROM Liquidation2__c
                         WHERE Liquidation_Annual_Plan__c=:liquiAnnalPlanId
                         AND RecordTypeId =:rtforLiquidation
                         AND Month__c=: month
                        ];
            if(liquiList.size() > 0){ 
                if(liquiList[0].submitted_trade__c== true || Test.isRunningTest()){
                    isSubmitted = true;
                }
                if(liquiList[0].submitted_trade__c== false ){
                    isSubmitted = false;
                }
                liquidationMap_vf.clear();
                liquidationMap_vf = new Map<String,Liquidation2__c> ();
                for(Liquidation2__c liqiObj :liquiList) {
                    tempLiqMap.put(liqiObj.Product__c,liqiObj); 
                }
            }else{
                productList = new List<Product2>();
            }
            openInvList = [select id,Name,X15_days_lock__c,Liquidation_Annual_Plan__c,Opening_Inventory__c,
                           YTD_Sales__c,YTD_Sales_Jan__c,YTD_Sales_Feb__c,
                           YTD_Sales_Mar__c,YTD_Sales_Apr__c,YTD_Sales_May__c,YTD_Sales_Jun__c,YTD_Sales_Jul__c,
                           YTD_Sales_Aug__c,YTD_Sales_Sept__c,YTD_Sales_Oct__c,YTD_Sales_Nov__c,YTD_Sales_Dec__c,
                           Product__c,State__c,Territory__c
                           FROM Opening_Inventory2__c 
                           WHERE Territory__c=:territoryName 
                           AND Liquidation_Annual_Plan__c=:liquiAnnalPlanId
                           AND RecordTypeId =: rtForOpeningInventory];
            if(openInvList.size()>0){
                OpeningInventoryMap_vf.clear();
                for(Opening_Inventory2__c openObj :openInvList){
                    Opening_Inventory2__c openInvObjTemp = new Opening_Inventory2__c();
                    openInvObjTemp =  openObj;
                    String tmpMth = month;
                    switch on tmpMth {
                        when 'Jan' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jan__c;
                        }
                        when 'Feb' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Feb__c;
                            System.debug('============> Feb');
                        }
                        when 'Mar' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Mar__c;
                            System.debug('============> March ');
                        }
                        when 'Apr' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Apr__c;
                            System.debug('============> Apr ');
                        }
                        when 'May' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_May__c;
                            System.debug('============> May ');
                        }
                        when 'Jun' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jun__c;
                            System.debug('============> Jun ');
                        }
                        when 'Jul' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Jul__c;
                            System.debug('============> Jul ');
                        }
                        when 'Aug' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Aug__c;
                            System.debug('============> Aug ');
                        }
                        when 'Sept' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Sept__c;
                        }
                        when 'Oct' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Oct__c;
                            
                        }
                        when 'Nov' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Nov__c;
                            System.debug('============> Nov ');
                        }
                        when 'Dec' {
                            openInvObjTemp.YTD_Sales__c = openObj.YTD_Sales_Dec__c;
                            System.debug('============> Dec ');
                        }    
                    } //end of Switch
                    tempOpenInvMap.put(openObj.Product__c, openInvObjTemp);
                }
            }
            else{
                productList = new List<Product2>();
            }
            if(tempOpenInvMap.size() > 0  && tempLiqMap.size()>0){
                tempLiqMap = refreshProductList(tempOpenInvMap, tempLiqMap);
                OpeningInventoryMap_vf.putAll(tempOpenInvMap);
                liquidationMap_vf.putAll(tempLiqMap);
            }
            populateLiquidationTableWrapper();    
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());    
        }    
    }// end of loadDataForSelectedMonth function

    public Map<String,Liquidation2__c> refreshProductList(Map<String,Opening_Inventory2__c> opnInvMap, Map<String,Liquidation2__c> liqMap){
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

    public void populateLiquidationTableWrapper(){
        if(null != OpeningInventoryMap_vf && null != liquidationMap_vf && null != productMap){
            for(Product2 product : productMap.Values()){
                LiquidationTableWrapper liqWrapper = new LiquidationTableWrapper();
                liqWrapper.materialGroup = product.product_code__C;
                liqWrapper.brandName = product.Name;
                liqWrapper.openingInventory = OpeningInventoryMap_vf.get(product.Id).Opening_Inventory__c;
                liqWrapper.YTD_Sales = OpeningInventoryMap_vf.get(product.Id).YTD_Sales__c;
                liqWrapper.distributorInventory = liquidationMap_vf.get(product.Id).Distributors_Inventory__c;
                liqWrapper.retailerInventory = liquidationMap_vf.get(product.Id).Retailers_Inventory__c;
                liqWrapper.planForNextMonth = liquidationMap_vf.get(product.Id).Plan_for_the_next_month__c;
                listLiquidationTableWrapper.add(liqWrapper);
            }
        }  
    }

    public class LiquidationTableWrapper{
        public String materialGroup {get; set;}
        public String brandName {get; set;}
        public Decimal openingInventory {get; set;}
        public Decimal YTD_Sales {get; set;}
        public Decimal distributorInventory {get; set;}
        public Decimal retailerInventory {get; set;}
        public Decimal planForNextMonth {get; set;}
    }
}