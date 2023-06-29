trigger LiquidationTrigger on Liquidation2__c (After update) {
    Trigger_Settings__c newtri = Trigger_Settings__c.getValues('LiquidationTrigger');
    if( newtri.isActive__c ){
        /*
        Set<Territory_Distributor__c> territoryToUpdate = new Set<Territory_Distributor__c>();
        List<Territory_Distributor__c> territoryToUpdateList = new List<Territory_Distributor__c>();
        string currMonth = system.now().addMonths(-1).format('MMM');
        Date theDate = Date.today().addMonths(-1);
        Period currFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                 FROM Period WHERE Type = 'Year' 
                                 AND StartDate <= :theDate 
                                 AND EndDate >= :theDate]; 
        String currfisYear = currFiscalYear.StartDate.year()+'-'+currFiscalYear.EndDate.year();
        
        for(Liquidation2__c liq:Trigger.new){
            //system.debug('trigger month__c->'+Trigger.newMap.get(liq.id).Month__c);
            //system.debug('currMonth->'+currMonth);
            if(((Trigger.oldMap.get(liq.id).submitted_trade__c == false && Trigger.newMap.get(liq.id).submitted_trade__c == true) || (Trigger.oldMap.get(liq.id).submitted_Trade_SWAL__c == false && Trigger.newMap.get(liq.id).submitted_Trade_SWAL__c == true)) && ((Trigger.newMap.get(liq.id).Month__c == currMonth && Trigger.newMap.get(liq.id).Financial_Year__c == currfisYear)||test.isRunningTest()) ){
                territoryToUpdate.add(new Territory_Distributor__c(id = liq.Territory__c,Liquidation_Submitted__c =true));
            }
            if((Trigger.oldMap.get(liq.id).submitted_trade__c == true && Trigger.newMap.get(liq.id).submitted_trade__c == false) || (Trigger.oldMap.get(liq.id).submitted_Trade_SWAL__c == true && Trigger.newMap.get(liq.id).submitted_Trade_SWAL__c == false) && ((Trigger.newMap.get(liq.id).Month__c == currMonth && Trigger.newMap.get(liq.id).Financial_Year__c == currfisYear)||test.isRunningTest()) ){
                territoryToUpdate.add(new Territory_Distributor__c(id = liq.Territory__c,Liquidation_Submitted__c =false));
            }
        }
        territoryToUpdateList.addAll(territoryToUpdate);
        update territoryToUpdateList;
        */

        if(trigger.isAfter && trigger.isUpdate){
            LiquidationTriggerHandler.deleteChildCropLiquidation(Trigger.New, Trigger.oldMap);
        }
    }
}