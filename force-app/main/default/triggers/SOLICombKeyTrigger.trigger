/*
*   Trigger Class - SOLICombKeyTrigger
*   Modified Date: 23-02-2023
*   Description - RITM0500995 : This trigger already exists but we have refactored the code as this was recursively called and concatinate SOLI_Combination_Key__c = SAP order number + Itemnumber on CPIO was thrown with an error.
**/
trigger SOLICombKeyTrigger on Sales_Order__c (after insert,after update) {
    //Test.isrunningtest condition added by Grazitti on 17-8-2021 due to test classes failure due to unavailability of custom settings
    if(Test.isRunningTest() || Trigger_Settings__c.getValues('SOLICombKeyTrigger').isActive__c){
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && Grz_checkRecursiveTrigger.runOnce()){
            Set<String> sapOrderIdSet = new Set<String>();//Modified to String
            Set<String> salesOrderIdSet = new Set<String>();
            List<Sales_Order_Line_Item__c> soliToBeUpdated = new List<Sales_Order_Line_Item__c>();
            
            for(Sales_Order__c soObj : Trigger.new){
                if(String.isNotBlank(soObj.Id)){
                    salesOrderIdSet.add(soObj.Id);
                }
                
                if(String.isNotBlank(soObj.SAP_Order_Number__c)){
                    sapOrderIdSet.add(soObj.SAP_Order_Number__c);
                }
            }
            
            if((null != salesOrderIdSet && !salesOrderIdSet.isEmpty())
                && (null != sapOrderIdSet && !sapOrderIdSet.isEmpty())){
                List<Sales_Order_Line_Item__c> soliList = [SELECT Id,SOLI_Combination_Key__c,Sale_Order__r.SAP_Order_Number__c,Item_Number__c 
                                                           FROM Sales_Order_Line_Item__c 
                                                           WHERE Sale_Order__c IN :salesOrderIdSet 
                                                           AND SAP_Order_Number__c != null 
                                                           AND SOLI_Combination_Key__c = null];
                    system.debug('soliList'+soliList);
                if( null != soliList && soliList.size()>0 ){
                    for( Sales_Order_Line_Item__c var: soliList ){
                        Sales_Order_Line_Item__c soli = new Sales_Order_Line_Item__c(Id = var.Id);
                        soli.SOLI_Combination_Key__c = var.Sale_Order__r.SAP_Order_Number__c + '-' + var.Item_Number__c;   //Updated  by GRZ(Dheeraj Sharma) due to show duplicacy error. 
                        soliToBeUpdated.add(soli);   
                    }
                    system.debug('soliToBeUpdated'+soliToBeUpdated);
                    //UPDATE soliList;
                    if(null != soliToBeUpdated && !soliToBeUpdated.isEmpty()){
                        update soliToBeUpdated;
                    }
                } 
            }
        }       
    }
}