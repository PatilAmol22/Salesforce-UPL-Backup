/**************************************************************************************************
* Name               : SecondarySalesDataTriggerHandler 
* TestClass			 : SecondarySalesDataTriggerHandlerTest
* Description        : Handler class for SecondarySalesDataTrigger
* Created Date       : 14/02/2023                                                                
* Created By         : Nikhil Verma (Grazitti) RITM0507183                                                                       
**************************************************************************************************/ 
public class SecondarySalesDataTriggerHandler {
    
    /**************************************************************************************************
    * Name               : NAMSalesDataOperation (used for USA Secondary Sales Data Only i.e.3100)
    * Description        : method to update Customer_Name__c(AccountLookup i.e. for Retailer Account) and Product_Name__c(SKU__c lookup) while inserting data if 
    * 					   EBID__c(for retailer account) and Customer_Product_Code__c(Sku Code) field are populated in data upload activity.
    * 					   This logic will help to reduce effort to map AccountId and skuId in CSV sheet. 
    * Created Date       : 14/02/2023                                                                
    * Created By         : Nikhil Verma (Grazitti)                                                                       
    **************************************************************************************************/ 
    public void NAMSalesDataOperation(List<Secondary_Sales_Data__c> newList){
        Set<String> ebidSet = new Set<String>();
        Set<String> productSet = new Set<String>();
        for(Secondary_Sales_Data__c sd : newList){
            if(sd.Sales_Org_Code__c == '3100' && (sd.Customer_Name__c == null || sd.Product_Name__c == null) && 
               sd.EBID__c != null && sd.Customer_Product_Code__c != null){
                   ebidSet.add(sd.EBID__c);
                   String SkuCode = sd.Customer_Product_Code__c;
                   SkuCode = SkuCode.leftPad(18, '0');
                   productSet.add(SkuCode);
               }
        }
        if(ebidSet != null && !ebidSet.isEmpty()){
            Map<String,Id> ebidToAccIdMap = new Map<String,Id>();
            for(Account acc : [SELECT Id,EBID__c FROM Account WHERE Sales_Org_Code__c = '3100' AND EBID__c != null AND EBID__c IN:ebidSet ]){
                ebidToAccIdMap.put(acc.EBID__c, acc.Id);
            }
            Map<String,Id> codeToSKUIdMap = new Map<String,Id>();
            for(SKU__c sku : [SELECT Id,SKU_Code__c FROM SKU__c WHERE Sales_Org_Code__c = '3100' AND SKU_Code__c != null AND SKU_Code__c IN:productSet]){
                String skuCode = sku.SKU_Code__c;
                skuCode = skuCode.replaceFirst('^0+','');
                codeToSKUIdMap.put(skuCode,sku.Id);
            }
            for(Secondary_Sales_Data__c sd : newList){
                if(sd.Sales_Org_Code__c == '3100' && (sd.Customer_Name__c == null || sd.Product_Name__c == null) && 
               		sd.EBID__c != null && sd.Customer_Product_Code__c != null){
                       if(ebidToAccIdMap != null && ebidToAccIdMap.containsKey(sd.EBID__c)){
                           sd.Customer_Name__c = ebidToAccIdMap.get(sd.EBID__c);
                       }
                       if(codeToSKUIdMap != null && codeToSKUIdMap.containsKey(sd.Customer_Product_Code__c)){
                           sd.Product_Name__c = codeToSKUIdMap.get(sd.Customer_Product_Code__c);
                       }
                   }
            }
        }
    }
    
    // Added for NAM owner update GRZ(Nikhil Verma) 20-03-2023
    public void ownershipUpdateNAM(List<Secondary_Sales_Data__c> newList){
        Set<Id> accIdSet = new Set<Id>();
        for(Secondary_Sales_Data__c sd : newList){
            if(sd.Sales_Org_Code__c == '3100' && sd.Customer_Name__c != null){
                accIdSet.add(sd.Customer_Name__c);
            }
        }
        if(accIdSet != null && !accIdSet.isEmpty()){
            Map<Id,Id> accIdToOwnerMap = new Map<Id,Id>();
            for(Account acc : [SELECT Id,OwnerId FROM Account WHERE Id IN:accIdSet]){
            	accIdToOwnerMap.put(acc.Id , acc.OwnerId );
            }
            if(accIdToOwnerMap != null){
                for(Secondary_Sales_Data__c sd : newList){
                    if(sd.Sales_Org_Code__c == '3100' && sd.Customer_Name__c != null && accIdToOwnerMap.containsKey(sd.Customer_Name__c)){
                        sd.OwnerId = accIdToOwnerMap.get(sd.Customer_Name__c);
                    }
        		}
            }
        }
    }
    /*-------------END NAM owner update GRZ(Nikhil Verma) 20-03-2023--------*/
    
}