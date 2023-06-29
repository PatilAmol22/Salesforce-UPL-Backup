public with sharing class Grz_PriceBookMasterClass {
    @AuraEnabled(cacheable=true)
    public static PriceBookDetailWrapperList getPriceBookDetailList(String Accountrecord)
    {
        System.debug('Accountrecord--'+ Accountrecord);
        List<PriceBookMaster__c> PriceBookItem = new list<PriceBookMaster__c>();
        List<PricebookDiscount__c> pbdisList =new List<PricebookDiscount__c>();
        Map<Id,Decimal> pBDiscountMap = new Map<Id,Decimal>();  
        Map<Id,Decimal> accrualDiscountMap = new Map<Id,Decimal>();
        PriceBookItem = [SELECT Id, DistributorCustomerCode__r.Name,Sales_Org_Code__c, DepotCode__r.Depot_Code__c,Batch__c,Order_Italy_Type__c,SKUCode__c ,
                         SKUCode__r.Name, SKUCode__r.SKU_Description__c, SKUCode__r.SKU_Code__c, SKUCode__r.Sales_Org__r.sales_org_code__c,DistributionChannel__r.Distribution_Channel_Code__c,
                         DistributorCustomerCode__c,DepotCode__c, DistributorCustomerCode__r.SAP_Code__c,DepotCode__r.Location__c,Division__r.Division_Code__c,
                         EndDate__c,StartDate__c,SKUCode__r.Area_Manager_MSP__c,SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,
                         SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Active__c,CurrencyIsoCode,
                         SKUCode__r.Brand_Name__c,Final_Price__c FROM PriceBookMaster__c 
                         WHERE DistributorCustomerCode__c =: Accountrecord AND PG_CODE__c = NULL AND DepotCode__r.Location__c ='IT00' AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'
                         AND SKUCode__r.Sales_Agent_MSP__c!=null  AND SKUCode__r.Sales_Agent_MSP__c!=0 AND SKUCode__r.Area_Manager_MSP__c!=null AND SKUCode__r.Area_Manager_MSP__c!=0  
                         AND SKUCode__r.Sales_Director_MSP__c!=null AND SKUCode__r.Sales_Director_MSP__c!=0 AND SKUCode__r.Active__c = True AND StartDate__c <= TODAY AND EndDate__c >= TODAY];  
        PriceBookDetailWrapperList finallist = new PriceBookDetailWrapperList();
        List<PriceBookDetailWrapper> resultobjlist = new List<PriceBookDetailWrapper>();
        pbdisList = [SELECT Id, SKUCode__c ,PG_Code__c,  
                     Price__c, Accrual_Discount__c, CurrencyIsoCode, LastModifiedDate    
                     FROM PricebookDiscount__c  
                     WHERE  DepotCode__r.Location__c ='IT00'    
                     AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                     AND PG_Code__c =null AND DistributorCustomerCode__c=:Accountrecord 
                     AND SKUCode__r.Active__c = True AND StartDate__c <= TODAY AND EndDate__c >= TODAY]; 
        if(PriceBookItem.size()== 0){
            system.debug('PBM List 1 Query return no result');
            pbdisList.clear();
            String pgcode = [Select id, PriceGroupCode__c,PriceGroupCode__r.PG_Code__c from Account where Id = :Accountrecord].PriceGroupCode__c;
            system.debug('pgcode---'+pgcode);
            if(pgcode != Null){
                
                PriceBookItem = [SELECT Id,DistributorCustomerCode__r.Name,Sales_Org_Code__c, DepotCode__r.Depot_Code__c,Batch__c,SKUCode__c ,Order_Italy_Type__c,SKUCode__r.Name,  
                                 SKUCode__r.SKU_Code__c,SKUCode__r.SKU_Description__c,DistributionChannel__r.Distribution_Channel_Code__c,DistributorCustomerCode__c, SKUCode__r.Sales_Org__r.sales_org_code__c,SKUCode__r.Active__c,
                                 DepotCode__c, Division__r.Division_Code__c,DepotCode__r.Location__c,DistributorCustomerCode__r.SAP_Code__c,UOM__c,SKUCode__r.Area_Manager_MSP__c, StartDate__c,EndDate__c,   
                                 SKUCode__r.Sales_Director_MSP__c, Price__c, DistributorCustomerCode__r.PG_Code__c,PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                                 CurrencyIsoCode,SKUCode__r.Brand_Name__c,Final_Price__c FROM PriceBookMaster__c 
                                 WHERE PG_CODE__c =: pgcode AND DistributorCustomerCode__c =NULL AND DepotCode__r.Location__c ='IT00' 
                                 AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                                 AND SKUCode__r.Sales_Agent_MSP__c!=null  AND SKUCode__r.Sales_Agent_MSP__c!=0  
                                 AND SKUCode__r.Area_Manager_MSP__c!=null AND SKUCode__r.Area_Manager_MSP__c!=0 
                                 AND SKUCode__r.Sales_Director_MSP__c!=null AND SKUCode__r.Sales_Director_MSP__c!=0 
                                 AND SKUCode__r.Active__c = True AND StartDate__c <= TODAY AND EndDate__c >= TODAY];   
                system.debug('Price Book List query went in the second block. Records found-->'+PriceBookItem.Size());
                
                pbdisList = [SELECT Id, SKUCode__c ,PG_Code__c,   
                             Price__c, Accrual_Discount__c, CurrencyIsoCode, LastModifiedDate,DistributorCustomerCode__r.PG_Code__c    
                             FROM PricebookDiscount__c  
                             WHERE  DepotCode__r.Location__c ='IT00'    
                             AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                             AND PG_Code__c =: pgcode AND DistributorCustomerCode__c=null   
                             AND SKUCode__r.Active__c = True AND StartDate__c <= TODAY AND EndDate__c >= TODAY];    
                system.debug('Price Discount List query went in the second block. Records found-->'+pbdisList.Size());
            }
            
        }else{
            system.debug('PBM List 1 Query has found prices');
        }
        if(PriceBookItem.size()==0){
            system.debug('PBM List 2 Query return no result');
            pbdisList.clear(); 
            PriceBookItem = [SELECT Id,Sales_Org_Code__c, DistributorCustomerCode__r.Name, DepotCode__r.Depot_Code__c,Batch__c,SKUCode__c ,Order_Italy_Type__c,SKUCode__r.Name,  
                             SKUCode__r.SKU_Code__c,SKUCode__r.SKU_Description__c, DistributionChannel__r.Distribution_Channel_Code__c,DistributorCustomerCode__c, SKUCode__r.Sales_Org__r.sales_org_code__c,SKUCode__r.Active__c,
                             DepotCode__c, Division__r.Division_Code__c,DepotCode__r.Location__c,DistributorCustomerCode__r.SAP_Code__c,UOM__c,SKUCode__r.Area_Manager_MSP__c, StartDate__c,EndDate__c,   
                             SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                             CurrencyIsoCode,SKUCode__r.Brand_Name__c,Final_Price__c FROM PriceBookMaster__c
                             WHERE PG_CODE__c = NULL AND DepotCode__r.Location__c ='IT00' AND DistributorCustomerCode__c =NULL 
                             AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'   
                             AND SKUCode__r.Sales_Agent_MSP__c!=null AND SKUCode__r.Sales_Agent_MSP__c!=0    
                             AND SKUCode__r.Area_Manager_MSP__c!=null AND SKUCode__r.Area_Manager_MSP__c!=0  
                             AND SKUCode__r.Sales_Director_MSP__c!=null AND SKUCode__r.Sales_Director_MSP__c!=0  
                             AND SKUCode__r.Active__c = True AND StartDate__c <= TODAY AND EndDate__c >= TODAY];    
            system.debug('Price Book List query went in the third block. Records found-->'+PriceBookItem.Size());
            pbdisList = [SELECT Id, SKUCode__c ,PG_Code__c, 
                         Price__c, Accrual_Discount__c, CurrencyIsoCode, LastModifiedDate     
                         FROM PricebookDiscount__c  
                         WHERE  DepotCode__r.Location__c ='IT00'    
                         AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                         AND PG_Code__c =null AND DistributorCustomerCode__c=null   
                         AND SKUCode__r.Active__c = True AND StartDate__c <= TODAY AND EndDate__c >= TODAY];    
            system.debug('Price Discount List query went in the third block. Records found-->'+pbdisList.Size());
        }else{
            system.debug('PBM List 2 Query has found prices');
        }
        if(pbdisList.size()>0){ 
            for(PricebookDiscount__c pbdObj :pbdisList){
                if(pbdObj.Price__c!=null){
                    pBDiscountMap.put(pbdObj.SKUCode__c, pbdObj.Price__c);        
                }else{
                    pBDiscountMap.put(pbdObj.SKUCode__c, 0);        
                }
                if(pbdObj.Accrual_Discount__c!=null){
                    accrualDiscountMap.put(pbdObj.SKUCode__c, pbdObj.Accrual_Discount__c);        
                }else{
                    accrualDiscountMap.put(pbdObj.SKUCode__c, 0);        
                }
                
            }   
        } 
        System.debug('pBDiscountMap--'+ pBDiscountMap);
        System.debug('accrualDiscountMap---'+ accrualDiscountMap);
        if(PriceBookItem.size()>0){
            System.debug('PriceBookItem.size()---'+ PriceBookItem.size());
            for(PriceBookMaster__c price: PriceBookItem){
                PriceBookDetailWrapper resultobj = new PriceBookDetailWrapper();
                resultobj.Ids = price.Id;
                resultobj.UOM = price.UOM__c;
                resultobj.SalesOrgCode = price.Sales_Org_Code__c;
                resultobj.DistributionChannel = price.DistributionChannel__r.Distribution_Channel_Code__c;
                resultobj.Division = price.Division__r.Division_Code__c;
                resultobj.SoldToPartyName = price.DistributorCustomerCode__r.Name;
                if(price.DistributorCustomerCode__r.SAP_Code__c != Null)
                    resultobj.SoldToPartyCode = price.DistributorCustomerCode__r.SAP_Code__c.right(7);
                
                if(price.SKUCode__r.SKU_Code__c != Null)
                    resultobj.SKUCode = price.SKUCode__r.SKU_Code__c.right(7);
                resultobj.SKUName = price.SKUCode__r.SKU_Description__c;
                resultobj.Currencypricebook = price.CurrencyIsoCode;
                resultobj.ValidFrom = price.StartDate__c;
                resultobj.Validto = price.EndDate__c;
                resultobj.Batch = price.Batch__c;
                resultobj.DepotStorageLocation = price.DepotCode__r.Depot_Code__c;
                resultobj.MaterialPrice = price.Price__c;
                resultobj.EstimatedFinalPrice = price.Final_Price__c;
               resultobj.OrderTypeItaly = price.Order_Italy_Type__c;
                if(pbdisList.size()>0){ 
                    if(pBDiscountMap.containsKey(price.SKUCode__c)){    
                        resultobj.standardRebate = pBDiscountMap.get(price.SKUCode__c); 
                        System.debug('resultobj.standardRebate---'+ resultobj.standardRebate);
                    }  
                    if(accrualDiscountMap.containsKey(price.SKUCode__c)){   
                        resultobj.AccrualDiscount = accrualDiscountMap.get(price.SKUCode__c);
                        System.debug(' resultobj.AccrualDiscount---'+  resultobj.AccrualDiscount);
                    } 
                }  
                System.debug('resultobj---'+ resultobj);
                resultobjlist.add(resultobj);
            }  
            
        }
        
        System.debug('resultobjlist---'+ resultobjlist);
        finallist.PriceBookDetailList = resultobjlist;
        return finallist;
    }
    @AuraEnabled
    public static boolean deletePriceBookMasters(string skurecordid)
    {
        System.debug('skurecordid---'+ skurecordid);
        List<PriceBookMaster__c> UpdatePriceBookItem = new list<PriceBookMaster__c>(); 
        List<PriceBookMaster__c> PriceBookItem = [SELECT Id, Sales_Org_Code__c,SKUCode__c FROM PriceBookMaster__c 
                                                  WHERE SKUCode__c =: skurecordid AND StartDate__c <= TODAY AND EndDate__c >= TODAY]; 
        if(PriceBookItem.size()>0){
            for(PriceBookMaster__c pr : PriceBookItem){
                pr.EndDate__c = System.today() - 1;
                UpdatePriceBookItem.add(pr);
            }
            try{
                if(UpdatePriceBookItem.size()>0)
                    update UpdatePriceBookItem;
                    System.debug('UpdatePriceBookItem---'+ UpdatePriceBookItem);
                    return true;
                
               
            }
            catch(Exception e){
            System.debug(e.getMessage());
            return false;
        }
            
        }
        else
            return false;
        
    }
    @AuraEnabled
    public static String deletePriceBookMastersonAccount(string pricerecordid)
    {
        System.debug('pricerecordid---'+ pricerecordid);
        List<PriceBookMaster__c> UpdatePriceBookItem = new list<PriceBookMaster__c>(); 
        List<PriceBookMaster__c> PriceBookItem = [SELECT Id, Sales_Org_Code__c,SKUCode__c FROM PriceBookMaster__c 
                                                  WHERE id =: pricerecordid]; 
        for(PriceBookMaster__c pr : PriceBookItem){
            pr.EndDate__c = System.today() - 1;
            UpdatePriceBookItem.add(pr);
        }
        System.debug('UpdatePriceBookItemon account---'+ UpdatePriceBookItem);
        try{
            if(UpdatePriceBookItem.size()>0)
            update UpdatePriceBookItem;
            return pricerecordid;
        }catch(Exception e){
            System.debug(e.getMessage());
            return e.getMessage();
        }
        
    
        
    }
    @AuraEnabled
    public static String updatePriceBookMasters(string skurecordid, decimal newmaterialprice)
    {
        System.debug('skurecordid---'+ skurecordid);
        System.debug('newmaterialprice---'+ newmaterialprice);
        List<PriceBookMaster__c> UpdatePriceBookItem = new list<PriceBookMaster__c>(); 
        List<PriceBookMaster__c> PriceBookItem = [SELECT Id, Sales_Org_Code__c,Price__c,SKUCode__c FROM PriceBookMaster__c 
                                                  WHERE SKUCode__c =: skurecordid AND StartDate__c <= TODAY AND EndDate__c >= TODAY]; 
        System.debug('PriceBookItem--11111'+PriceBookItem);
        if(PriceBookItem.size()>0){
            for(PriceBookMaster__c pr : PriceBookItem){
                system.debug('pr-----'+pr);
                pr.Price__c = newmaterialprice;
                UpdatePriceBookItem.add(pr);
            }
        
            
           System.debug('UpdatePriceBookItemonaccount---'+ UpdatePriceBookItem);
             try{
                 if(UpdatePriceBookItem.size()>0)
				 update UpdatePriceBookItem;
            	 return skurecordid;         
            }
            catch(Exception e){
                System.debug(e.getMessage());
                return e.getMessage();
            }
        }
        else{
            return '';
        }
       }
        @AuraEnabled
        public static void updatePriceBookMastersonAccount(string pricerecordid, decimal newmaterialprice)
        {
            System.debug('pricerecordid---'+ pricerecordid);
            List<PriceBookMaster__c> UpdatePriceBookItem = new list<PriceBookMaster__c>(); 
            List<PriceBookMaster__c> PriceBookItem = [SELECT Id, Sales_Org_Code__c,Price__c,SKUCode__c FROM PriceBookMaster__c 
                                                      WHERE id =: pricerecordid]; 
            for(PriceBookMaster__c pr : PriceBookItem){
                pr.Price__c = newmaterialprice;
                UpdatePriceBookItem.add(pr);
            }
            try{
                if(UpdatePriceBookItem.size()>0)
				update UpdatePriceBookItem;
            	System.debug('UpdatePriceBookItemonaccount---'+ UpdatePriceBookItem);                
            }
            catch(Exception e){
                System.debug('error-'+e);
            }
            
            
        }
        public class PriceBookDetailWrapper
        {
            @AuraEnabled public String Ids{get;set;}
            @AuraEnabled public String UOM{get;set;}
            @AuraEnabled public String SalesOrgCode{get;set;}
            @AuraEnabled public String DistributionChannel{get;set;}
            @AuraEnabled public String Division{get;set;}
            @AuraEnabled public String SoldToPartyCode{get;set;} 
            @AuraEnabled public String SoldToPartyName{get;set;}
            @AuraEnabled public String SKUCode{get;set;}
            @AuraEnabled public String SKUName{get;set;}
            @AuraEnabled public String Currencypricebook{get;set;}
            @AuraEnabled public Date ValidFrom{get;set;}
            @AuraEnabled public Date Validto{get;set;}
            @AuraEnabled public String Batch{get;set;}
            @AuraEnabled public String DepotStorageLocation{get;set;} 
            @AuraEnabled public Decimal MaterialPrice{get;set;}
            @AuraEnabled public Decimal StandardRebate{get;set;}
            @AuraEnabled public Decimal EstimatedFinalPrice{get;set;}
            @AuraEnabled public Decimal AccrualDiscount{get;set;}
            @AuraEnabled public String OrderTypeItaly{get;set;}
        }
        public class PriceBookDetailWrapperList
        {
            @AuraEnabled public List<PriceBookDetailWrapper> PriceBookDetailList{get;set;}
        }
        
    }