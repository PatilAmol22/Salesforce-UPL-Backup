/*Class:-GetPriceBookDataPoland
Test Class:-
Created By:- Shubham Bansal
THis class is use to fetch pricebook and show those on account
*/

public class GetPriceBookDataPoland {
    @AuraEnabled(cacheable = true)
    public static List<pricebookMasterAndDiscountWrapper> getPriceBookData(string recordId){
        List<PriceBookMaster__c> pbmList = new  List<PriceBookMaster__c>();
         List<PriceBook_Indonesia_Discount__c> pidList = new  List<PriceBook_Indonesia_Discount__c>();
                 List<pricebookMasterAndDiscountWrapper> wrapList = new  List<pricebookMasterAndDiscountWrapper>();
        map<String,Decimal> keyvsdiscount = new   map<String,Decimal>();
          map<String,String> skucodevspaymentTerm = new   map<String,String>();
        Set<String> CombinationkeySet = new Set<String>();
         
        pbmList =  [SELECT Id,SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c,CompositeKey__c,
                    SKUCode__r.Division__r.Division_Code__c,SKUCode__r.Distribution_Channel__c,SKUCode__r.Division__c,
                    SKUCode__c,SKUCode__r.Truck_Quantity__c,SKUCode__r.Payment_Term__c,SKUCode__r.Logistic_Discount__c,
                    Division__c,Division__r.Name,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, SKUCode__r.ID,  
                    SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, DistributorCustomerCode__r.SAP_Customer_Code__c,
                  DistributorCustomerCode__r.name,  DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c,    
                    SKUCode__r.Sales_Director_MSP__c, SKUCode__r.New_Combination_Key_for_SWAL__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                    UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,   
                    SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,SKUCode__r.Active_ingredient_Italy__c,
                    SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c,
                    Pmnt_Term__r.Payment_Term__c,StartDate__c,Payment_Term__c,Pmnt_Term__c,EndDate__c
                    
                    FROM PriceBookMaster__c 
                    WHERE DistributorCustomerCode__c =: recordId
                    AND DepotCode__r.Location__c ='PD01' 
                    AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c='20'
                    AND (SKUCode__r.Division__r.Division_Code__c = '10' OR SKUCode__r.Division__r.Division_Code__c = '60')
                    AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941'   
                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True   
                    ORDER BY Pmnt_Term__r.Payment_Term__c desc ,SKUCode__r.SKU_Description__c asc]; 
        system.debug('@@@@@@@@@@@@pbmList@@@@@@'+pbmList);
        

 if(pbmList!=null && !pbmList.isEmpty()){
     for(PriceBookMaster__c pbm:pbmList){
         CombinationkeySet.add(pbm.SKUCode__r.New_Combination_Key_for_SWAL__c);
         
     }
     
 }
         if(CombinationkeySet!=null && !CombinationkeySet.isEmpty()){
             
             System.debug('CombinationkeySet'+CombinationkeySet);
         for(PriceBook_Indonesia_Discount__c pid:[SELECT Id, Name,DistributorCustomerCode__c,Payment_Term__c,New_Composite_key__c,Manual_Discount__c,SKUCode__r.ID,Payment_Term__r.Payment_Term__c
                 FROM PriceBook_Indonesia_Discount__c
                 WHERE DistributorCustomerCode__c=:recordId
                       AND New_Composite_key__c=:CombinationkeySet]){
                          keyvsdiscount.put(pid.New_Composite_key__c,pid.Manual_Discount__c);
                         
                          
                       }
         }
         //Query added for fetching payment terms for APPS-5098


         for(PriceBook_Indonesia_Discount__c pid:[SELECT Id, Name,DistributorCustomerCode__c,Payment_Term__c,New_Composite_key__c,Manual_Discount__c,SKUCode__r.ID,Payment_Term__r.Payment_Term__c,CompositeKey__c,Payment_Term__r.Payterms_Desc__c
                 FROM PriceBook_Indonesia_Discount__c
                 WHERE DistributorCustomerCode__c=:recordId AND DepotCode__r.Location__c ='PD01' 
                    AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c='20'
                    AND (SKUCode__r.Division__r.Division_Code__c = '10' OR SKUCode__r.Division__r.Division_Code__c = '60')
                    AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2941'   
                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True   
                    ORDER BY Payment_Term__r.Payment_Term__c desc ,SKUCode__r.SKU_Description__c asc]
                      ){
                          
                              System.debug('eneter in map');
                          skucodevspaymentTerm.put(pid.SKUCode__r.ID,pid.Payment_Term__r.Payterms_Desc__c);
                           System.debug('skucodevspaymentTerm'+skucodevspaymentTerm);
                          }

                          
                         
                          
                       
        
       if(pbmList!=null && !pbmList.isEmpty()){
     for(PriceBookMaster__c pbm:pbmList){
           wrapList.add(new pricebookMasterAndDiscountWrapper(pbm.SKUCode__r.SKU_Description__c,pbm.DistributorCustomerCode__r.name,
                      skucodevspaymentTerm.get(pbm.SKUCode__r.ID),pbm.DistributorCustomerCode__r.SAP_Customer_Code__c,
                       pbm.UOM__c,pbm.Price__c,keyvsdiscount.get(pbm.SKUCode__r.New_Combination_Key_for_SWAL__c),
                        pbm.StartDate__c,pbm.EndDate__c));
         
     }
     
 } 
        
        return wrapList;
    }
    
    public class pricebookMasterAndDiscountWrapper {
    @AuraEnabled public String SkuName;
    @AuraEnabled public String CustomerName;
    @AuraEnabled public String PaymentTerm;
    @AuraEnabled public String CustomerCode;
    @AuraEnabled public String  UOM;
    @AuraEnabled public Decimal BasePrice;
    @AuraEnabled public Decimal ManualDiscount;
        @AuraEnabled public Date Startdate;
        @AuraEnabled public Date EndDate;
        
                public pricebookMasterAndDiscountWrapper( String SkuName, String CustomerName, String PaymentTerm,
                                                     String CustomerCode, String  UOM,  Decimal BasePrice, Decimal ManualDiscount,
                                                        Date Startdate,  Date EndDate) {
            this.SkuName = SkuName;
            this.CustomerName = CustomerName;
            this.PaymentTerm = PaymentTerm;
            this.CustomerCode = CustomerCode;
                                                            this.UOM = UOM;
            this.BasePrice = BasePrice;
            this.ManualDiscount = ManualDiscount;
            this.Startdate = Startdate;
                                                            this.EndDate = EndDate;
        }

}
    
}