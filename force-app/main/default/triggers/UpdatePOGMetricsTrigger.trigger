trigger UpdatePOGMetricsTrigger on SalesAgreementProductSchedule (before update) {
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            if(Trigger.new[0].Sales_Org__c == '5191'){
                UpdatePOGMetricsHandler.updateMethod(Trigger.new);
            	UpdatePOGMetricsHandler.insertCombinationKey(Trigger.new); //use this for combination key update
            }
        }
    }
    
}