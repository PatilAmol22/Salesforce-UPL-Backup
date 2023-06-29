public class OpportunityLineItemTriggerHandler {
    
    public static Boolean isTriggerFire = true;
    public static void sync(Set<Id> oliIds ){
        
        List<OpportunityLineItem> lstQLIUpdate = new List<OpportunityLineItem>();
        
        
        
        
        for(QuoteLineItem qli: [Select id, Pack_Size__c,Storage_Location__c,Max_Price__c,SKU__c,Min_Price__c,UOM__c,Division__c,Sales_Org__c,Distribution_Channel__c,opportunity_line_item_id_1__c from QuoteLineItem WHERE opportunity_line_item_id_1__c= :oliIds]){
            //System.debug('qli.Pack_Size__c in OpportunityLineItemTriggerHandler after insert '+qli.Pack_Size__c);
            //System.debug('qli.opportunity_line_item_id_1__c '+qli.opportunity_line_item_id_1__c);
            lstQLIUpdate.add(new OpportunityLineItem(Id=qli.opportunity_line_item_id_1__c, Pack_Size__c=qli.Pack_Size__c,Max_Price__c=qli.Max_Price__c,Min_Price__c=qli.Min_Price__c,UOM__c=qli.UOM__c, Sales_Org__c=qli.Sales_Org__c,Division__c=qli.Division__c,Distribution_Channel__c=qli.Distribution_Channel__c,Storage_Location__c=qli.Storage_Location__c,SKU__c=qli.SKU__c));                  
        }
        if(!lstQLIUpdate.isEmpty() || Test.isRunningTest()){
            isTriggerFire = false;
            update lstQLIUpdate;
            isTriggerFire = true;
        }
    }
}