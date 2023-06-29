public class CropLiquidationDeleteInvocable {
    
    @InvocableMethod(label='Delete Crop Liquidation Records' description='Delete Crop Liquidation Records after Product Liquidation is Unlocked')
    public static void CropLiquidationDelete(List<Liquidation2__c> unlockedProductLiquidations) {
        
        List<String> unlockedProductLiquidations2 = new List<String>();
        for(Liquidation2__c l:unlockedProductLiquidations){
            unlockedProductLiquidations2.add(l.Id);
        }
        
        List<Liquidation2__c> liqUnlocked = new List<Liquidation2__c>();
        liqUnlocked = [SELECT Id, Month__c, Territory_Code__c, Financial_Year__c FROM Liquidation2__c WHERE Id in:unlockedProductLiquidations2 LIMIT 1];
        
        List<Crop_Liquidation__c> cropToDelete = new List<Crop_Liquidation__c>();
        for(Liquidation2__c tl:liqUnlocked){
            String fy = tl.Financial_Year__c;
            system.debug('tl.Financial_Year__c-->'+tl.Financial_Year__c);
            String tc = tl.Territory_Code__c;
            system.debug('tl.Territory_Code__c-->'+tl.Territory_Code__c);
            String m = tl.Month__c;
            system.debug('tl.Month__c-->'+tl.Month__c);
            cropToDelete = [SELECT Id FROM Crop_Liquidation__c WHERE Financial_Year__c = :fy AND Territory_Code__c = :tc AND Month__c = :m];
        }
        system.debug('unlockedProductLiquidations-->'+unlockedProductLiquidations2);
        
        if(cropToDelete.size()>0){
            for(Crop_Liquidation__c cl:cropToDelete){
                system.debug('Deletable Crop-->'+cl);
            }
            delete cropToDelete;
        }
    }
}