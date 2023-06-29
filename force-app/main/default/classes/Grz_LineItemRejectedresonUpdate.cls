global class Grz_LineItemRejectedresonUpdate implements Database.Batchable<sObject>{ 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        if(!test.isRunningTest()){
            query = 'select id,name,Rejection_Code__c,Rejected_Reason__c from Sales_Order_Line_Item__c  where Rejection_Code__c!=null and  Rejected_Reason__c=null';
        }else{
            query = 'select id,name,Rejection_Code__c,Rejected_Reason__c from Sales_Order_Line_Item__c LIMIT 10';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Sales_Order_Line_Item__c> lineItemList) {
        Map<Id,Rejection_Status__c> lineItemRejectedStatusMap = new Map<Id,Rejection_Status__c>([SELECT id,Rejection_Description__c FROM Rejection_Status__c]);        
        List<Sales_Order_Line_Item__c> lineItemUpdate = new List<Sales_Order_Line_Item__c>();
        if(lineItemRejectedStatusMap != null){
            for(Sales_Order_Line_Item__c sol : lineItemList){
                if(lineItemRejectedStatusMap.containskey(sol.Rejection_Code__c)){
                    sol.Rejected_Reason__c = lineItemRejectedStatusMap.get(sol.Rejection_Code__c).Rejection_Description__c;
                	lineItemUpdate.add(sol);
                }
            }
            if(lineItemUpdate.size()>0){
                update lineItemUpdate;
            }
        }
    }   
    global void finish(Database.BatchableContext BC){
    }  
}