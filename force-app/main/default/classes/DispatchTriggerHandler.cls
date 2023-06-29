public class DispatchTriggerHandler {
    List<Dispatch__c> recordNewList = new List<Dispatch__c>();
    List<Dispatch__c> recordOldList = new List<Dispatch__c>();
    Map<Id, Dispatch__c> recordNewMap = new Map<Id, Dispatch__c>();
    Map<Id, Dispatch__c> recordOldMap = new Map<Id, Dispatch__c>();
    Boolean isInsert, isUpdate, isDelete, isUndelete, isBefore, isAfter = false;
    public static boolean recursionController = false;
    
    public DispatchTriggerHandler( List<Dispatch__c> newList, 
                                  List<Dispatch__c> oldList, 
                                  Map<Id, Dispatch__c> newMap, 
                                  Map<Id, Dispatch__c> oldMap, 
                                  boolean isInsert, 
                                  boolean isUpdate, 
                                  Boolean isDelete, 
                                  Boolean isUndelete, 
                                  Boolean isBefore, 
                                  Boolean isAfter){
                                      this.recordNewList = newList;
                                      this.recordOldList = oldList;
                                      this.recordNewMap = newMap;
                                      this.recordOldMap = oldMap;
                                      this.isInsert = isInsert;
                                      this.isUpdate = isUpdate;
                                      this.isDelete = isDelete;
                                      this.isUndelete = isUndelete;
                                      this.isBefore = isBefore;
                                      this.isAfter = isAfter;        
                                  }
    
    public void AfterUpdateEvent(){
        Map<String,List<Dispatch__c>> mapRefObj = new Map<String,List<Dispatch__c>>();
        for(Dispatch__c dp : recordNewList){
            if(dp.SalesOrg__c != null && dp.Sales_Org_Code__c == '5661' && dp.Reference_Number__c != null 
               && recordOldMap.get(dp.Id).Reference_Number__c != dp.Reference_Number__c  && dp.SalesOrderLineItem__c != null && dp.Quantity__c != null && dp.SKUDescription__c != null){
                   String ref = dp.Reference_Number__c;
                   ref = ref.right(6);
                   if ( !mapRefObj.containsKey(ref) ) {
                       mapRefObj.put(ref , new List<Dispatch__c>{dp});
                   } else {
                       List<Dispatch__c> tempList = mapRefObj.get(ref);
                       tempList.add(dp);
                       mapRefObj.put(ref , tempList );
                   }
               }
        }
        if(!mapRefObj.isEmpty()){
            updateLineItemInBeeTrack(mapRefObj);
        }
    } 
    public void AfterInsertEvent(){
        Map<String,List<Dispatch__c>> mapRefObj = new Map<String,List<Dispatch__c>>();
        for(Dispatch__c dp : recordNewList){
            if(dp.SalesOrg__c != null && dp.Sales_Org_Code__c == '5661' && dp.Reference_Number__c != null 
               && dp.SalesOrderLineItem__c != null && dp.Quantity__c != null && dp.SKUDescription__c != null){
                   String ref = dp.Reference_Number__c;
                   ref = ref.right(6);
                   if ( !mapRefObj.containsKey(ref) ) {
                       mapRefObj.put(ref , new List<Dispatch__c>{dp});
                   } else {
                       List<Dispatch__c> tempList = mapRefObj.get(ref);
                       tempList.add(dp);
                       mapRefObj.put(ref , tempList );
                   }
               }
        }
        if(!mapRefObj.isEmpty()){
            updateLineItemInBeeTrack(mapRefObj);
        }
    }
    
    
    public void updateLineItemInBeeTrack( Map<String,List<Dispatch__c>> mapRefObj){
        Map<String,List<Sales_Order_delivery__c>> mapIdObj = new Map<String,List<Sales_Order_delivery__c>>();
        Id itemRecordType =  Schema.SObjectType.Sales_order_delivery__c.getRecordTypeInfosByDeveloperName().get('Item_Information').getRecordTypeId();
        List<Sales_Order_delivery__c> soList = new List<Sales_Order_delivery__c>();
        for(Sales_Order_delivery__c so : [SELECT Id,Identifier__c, Quantity__c, Item_Name__c from Sales_Order_delivery__c WHERE Identifier__c IN: mapRefObj.keySet() AND recordTypeId =: itemRecordType AND Sales_Order_Line_Item__c = null]){
            for(Dispatch__c dp : mapRefObj.get(so.identifier__c)){
                String ref = dp.Reference_Number__c;
                ref = ref.right(6);
                if(so.identifier__c == ref && so.Item_Name__c == dp.SKUDescription__c){
                    so.Sales_Order_Line_Item__c = dp.SalesOrderLineItem__c;
                    soList.add(so);
                    break;
                }
            }
        }
        if(!soList.isEmpty()){
            update soList;
        }
        
    }
}