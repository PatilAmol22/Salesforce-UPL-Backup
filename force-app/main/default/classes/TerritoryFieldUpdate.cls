global class TerritoryFieldUpdate  implements System.Schedulable {
    global void execute(SchedulableContext sc) {
        updateLiquidationSubmittedStatus();
        
    }

    public static void updateLiquidationSubmittedStatus(){
        //Migration from 1000 to 1410
        //String salesOrgCodeIndiaSAS = UtilityClass.getSalesOrgIndiaSAS();
        Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
        String salesOrgCodeIndiaSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c;
        List<Territory_Distributor__c> territoryToUpdate = new List<Territory_Distributor__c>();
        for(Territory_Distributor__c td : [select id,Liquidation_Submitted__c from Territory_Distributor__c where Sales_Org_Code__c IN (:salesOrgCodeIndiaSAS,'1210')]){
        td.Liquidation_Submitted__c = false;
        territoryToUpdate.add(td);
        }
        update territoryToUpdate;
    }
    }