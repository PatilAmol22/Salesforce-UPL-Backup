public class Grz_POGSkuPriceListController {
	
    @AuraEnabled
    public static List<POGDataWrapperData> getPOGSkuPriceList(String year){
        
        String salesOrgCode = System.Label.Grz_PolandSalesOrgCode;
        
        String query = 'SELECT SKU__r.SKU_Code__c, MAX (SKU_Price_Poland__c),Liquidation_Annual_Plan__r.Fiscal_year__c FROM Opening_Inventory2__c where ';
        query += 'Liquidation_Annual_Plan__r.Fiscal_year__c =: year and SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode group by SKU__r.SKU_Code__c ,Liquidation_Annual_Plan__r.Fiscal_year__c';
        
        List<POGDataWrapperData> POGWrapDataList = new List<POGDataWrapperData>();
        
        for (AggregateResult result : Database.query(query)){
            
            POGDataWrapperData obj = new POGDataWrapperData();
            obj.skuCode = String.valueOf(result.get('SKU_Code__c'));
            obj.skuPrice = String.valueOf(result.get('expr0'));
            obj.year = String.valueOf(result.get('FIscal_Year__c'));
            POGWrapDataList.add(obj);
            System.debug('result==>'+result.get('SKU_Code__c'));                   
        }       
        System.debug('POGWrapDataList : '+POGWrapDataList);
        return POGWrapDataList;
    }
    
    public class POGDataWrapperData {
        @AuraEnabled
        public String skuCode { get; set; }
        @AuraEnabled
        public String skuPrice { get; set; }
        @AuraEnabled
        public String year { get; set; }
    }
    
}