/*
 * Author: Tanuj (Grazitti)
 * Ticket No: RITM0414915
 * Will be used with SalesOrder Tab for Brazil
 */
public class BrazilEnhancedListforBarterNewController {
public List<ProcessInstanceWorkItem> PIWI_List {get;set;}
    public List<Sales_order__c> SO_List {get;set;}
    public BrazilEnhancedListforBarterNewController(ApexPages.StandardController controller){
        id loggedInUserId = System.UserInfo.getUserId();
        PIWI_List = [SELECT ProcessInstance.TargetObjectId FROM ProcessInstanceWorkItem WHERE ProcessInstance.Status = 'Pending' AND ActorId= :loggedInUserId];
        Set<id> SoIdSet = new Set<id>();
        for(ProcessInstanceWorkItem PIWI : PIWI_List)
        {
            SoIdSet.add(PIWI.ProcessInstance.TargetObjectId);
        }
        
        SO_List = [SELECT id, Name, SAP_Order_Number__c, BrazilSalesOrderStatus__c, Total_Value_Brazil__c, CreatedDate, Invoice_Status__c, owner.firstname, Sold_to_Party__c,Sold_to_Party__r.name, Type_of_Order__c,  DateofFAT__c, TotalLedgerCost__c, TotalReplacementCost__c, sales_district__c, order_status__c, Flag__c
                   FROM Sales_order__c
                   WHERE id in :SoIdSet
                   ORDER BY createddate DESC];
        
        system.debug('.............................SO_List=='+SO_List);
    }
    public BrazilEnhancedListforBarterNewController(){
    }
}