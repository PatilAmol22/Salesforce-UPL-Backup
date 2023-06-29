public without sharing class LiquidationTriggerHandler {
    /*
    Method Name : deleteChildCropLiquidation
    Description : Delete the related child crop liquidation whose product liquidation has been updated to 0
    */

    public static void deleteChildCropLiquidation(List<Liquidation2__c> newLiquidationList, Map<Id, Liquidation2__c> oldLiquidationMap){
        List<Crop_Liquidation__c> cropLiqToDeleteList = new List<Crop_Liquidation__c>();
        Set<Id> liqIdSet = new Set<Id>();
        for(Liquidation2__c liq : newLiquidationList){
            if(liq.Sales_Org_Code__c  == System.Label.AF_Sales_Org_Code_Label){
                if(liq.Liquidation_YTD_Trade__c == 0){
                    liqIdSet.add(liq.Id);
                }
            }else if(liq.Sales_Org_Code__c  == System.Label.SWAL_Sales_Org_Code_Label){
                if(liq.Liquidation_YTD_SWAL__c == 0){
                    liqIdSet.add(liq.Id);
                }
            }
        }

        if(liqIdSet.size() > 0){
            for(Crop_Liquidation__c crpLiq : [SELECT Id FROM Crop_Liquidation__c WHERE Liquidation__c IN :liqIdSet]){
                cropLiqToDeleteList.add(crpLiq);
            }
        }
        
        if(cropLiqToDeleteList.size() > 0){
            DELETE cropLiqToDeleteList;
        }
    } 
}