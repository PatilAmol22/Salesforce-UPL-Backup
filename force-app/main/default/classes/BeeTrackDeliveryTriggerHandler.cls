/* Code is not bulkified as this object is supposed to
/* store data only related to beetrack delivery for Chile
/* as Beetrack system does not fire data in bulk and we have to
/* map that data with Sales Order Line Item by finding Reference_Number__c
/* filed on Dispatch__c object */

public class BeeTrackDeliveryTriggerHandler {
    List<Sales_order_delivery__c> recordNewList = new List<Sales_order_delivery__c>();
    List<Sales_order_delivery__c> recordOldList = new List<Sales_order_delivery__c>();
    Map<Id, Sales_order_delivery__c> recordNewMap = new Map<Id, Sales_order_delivery__c>();
    Map<Id, Sales_order_delivery__c> recordOldMap = new Map<Id, Sales_order_delivery__c>();
    Boolean isInsert, isUpdate, isDelete, isUndelete, isBefore, isAfter = false;
    public static boolean recursionController = false;
    
    public BeeTrackDeliveryTriggerHandler( List<Sales_order_delivery__c> newList, 
                                          List<Sales_order_delivery__c> oldList, 
                                          Map<Id, Sales_order_delivery__c> newMap, 
                                          Map<Id, Sales_order_delivery__c> oldMap, 
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
    
    public void BeforeInsertEvent(){
        Id itemRecordType =  Schema.SObjectType.Sales_order_delivery__c.getRecordTypeInfosByDeveloperName().get('Item_Information').getRecordTypeId();
        List<String> identifier = new List<String>();
        for(Sales_order_delivery__c sod : recordNewList){
            if(!String.isEmpty(sod.Parent_Record__c) && sod.RecordTypeId == itemRecordType && !String.isEmpty(sod.identifier__c)){
                identifier.add(sod.identifier__c);
            }
        }
        if(!identifier.isEmpty()){
            String searchStr = '%' + identifier[0] + '%';
            for(Dispatch__c dp :[SELECT Id,Reference_number__c,SalesOrderLineItem__c,SKUDescription__c,Quantity__c FROM dispatch__c where Reference_Number__c != null AND SalesOrg__r.name='Chile' AND Reference_Number__c like: searchStr ]){
                for(Sales_order_delivery__c sod : recordNewList){
                    if(sod.Item_Name__c != null && sod.Quantity__c != null && dp.SKUDescription__c != null && dp.Quantity__c != null && dp.Quantity__c == sod.Quantity__c && dp.SKUDescription__c == sod.Item_Name__c ){
                        sod.Sales_Order_Line_Item__c = dp.SalesOrderLineItem__c;
                    }
                }
            }
        }
    }
    public void BeforeUpdateEvent(){
        Id itemRecordType =  Schema.SObjectType.Sales_order_delivery__c.getRecordTypeInfosByDeveloperName().get('Item_Information').getRecordTypeId();
        List<String> identifier = new List<String>();
        for(Sales_order_delivery__c sod : recordNewList){
            if(!String.isEmpty(sod.Parent_Record__c) && sod.RecordTypeId == itemRecordType && !String.isEmpty(sod.identifier__c) && String.isEmpty(sod.Sales_Order_Line_Item__c)){
                identifier.add(sod.identifier__c);
            }
        }
        if(!identifier.isEmpty()){
            String searchStr = '%' + identifier[0] + '%';
            for(Dispatch__c dp :[SELECT Id,Reference_number__c,SalesOrderLineItem__c,SKUDescription__c,Quantity__c FROM dispatch__c where Reference_Number__c != null AND SalesOrg__r.name='Chile' AND Reference_Number__c like: searchStr ]){
                for(Sales_order_delivery__c sod : recordNewList){
                    if(sod.Item_Name__c != null && sod.Quantity__c != null && dp.SKUDescription__c != null && dp.Quantity__c != null && dp.Quantity__c == sod.Quantity__c && dp.SKUDescription__c == sod.Item_Name__c ){
                        sod.Sales_Order_Line_Item__c = dp.SalesOrderLineItem__c;
                    }
                }
            }
            
        }
    }
    public void AfterInsertEvent(){
        
        Id deliveryRecordType =  Schema.SObjectType.Sales_order_delivery__c.getRecordTypeInfosByDeveloperName().get('Delivery_Information').getRecordTypeId();
        Id itemRecordType =  Schema.SObjectType.Sales_order_delivery__c.getRecordTypeInfosByDeveloperName().get('Item_Information').getRecordTypeId();
        List<Sales_order_delivery__c> delItemsList = new List<Sales_order_delivery__c>();
        List<Sales_order_delivery__c> delItemsToUpdate = new List<Sales_order_delivery__c>();
        List<Sales_order_delivery__c> sodlDelete = new List<Sales_order_delivery__c>();
        Map<String,Grz_BeeTrackResponse.DispatchUpdate> mapUpdateResp = new  Map<String,Grz_BeeTrackResponse.DispatchUpdate>();
        for(Sales_order_delivery__c sod : recordNewList){
            if(String.isEmpty(sod.identifier__c) && String.isEmpty(sod.SubStatus__c) && !String.isEmpty(sod.Response__c)){
                if(sod.Response__c.contains('"event":"create"')){
                    Sales_order_delivery__c soli = new Sales_order_delivery__c();
                    Grz_BeeTrackResponse.DispatchCreate resCreate = new Grz_BeeTrackResponse.DispatchCreate();
                    resCreate = (Grz_BeeTrackResponse.DispatchCreate)JSON.deserialize(sod.Response__c, Grz_BeeTrackResponse.DispatchCreate.class);
                    soli.Id = sod.Id;
                    soli.resource__c = resCreate.resource;
                    soli.Event__c = resCreate.event;
                    soli.RecordTypeId = deliveryRecordType;
                    soli.Account_Name__c = resCreate.account_name;
                    soli.identifier__c = resCreate.dispatch_guide.identifier;
                    soli.Contact_name__c = resCreate.dispatch_guide.contact_name;
                    soli.Contact_email__c = resCreate.dispatch_guide.contact_email;
                    soli.Contact_Address__c = resCreate.dispatch_guide.contact_address;
                    
                    for(Grz_BeeTrackResponse.Items item : resCreate.items ){
                        Sales_order_delivery__c deliveryItem = new Sales_order_delivery__c();
                        deliveryItem.RecordTypeId = itemRecordType;
                        deliveryItem.identifier__c = resCreate.dispatch_guide.identifier;
                        if(item.id != null){
                            deliveryItem.Item_Id__c = String.valueOf(item.id);
                        }
                        if(item.name != null && item.name != ''){
                            deliveryItem.Item_Name__c = item.name;
                        }
                        if(item.original_quantity != null){
                            deliveryItem.Original_Quanitity__c = String.valueOf(item.original_quantity);
                        }
                        if(item.quantity != null){
                            deliveryItem.Quantity__c = item.quantity;
                        }
                        if(item.delivered_quantity != null){
                            deliveryItem.Delivered_Quantity__c = String.valueOf(item.delivered_quantity);
                        }
                        if(item.code != null && item.code != ''){
                            deliveryItem.Item_Code__c = item.code;
                        }
                        deliveryItem.Parent_Record__c = sod.Id;
                        delItemsList.add(deliveryItem);
                    }
                    
                    delItemsList.add(soli);
                    
                }
                else if(sod.Response__c.contains('"event":"update"')){
                    sodlDelete.add(sod);
                    Grz_BeeTrackResponse.DispatchUpdate resUpdate = new Grz_BeeTrackResponse.DispatchUpdate();
                    resUpdate = (Grz_BeeTrackResponse.DispatchUpdate)JSON.deserialize(sod.Response__c.replace('"cast"','"cast_z"'), Grz_BeeTrackResponse.DispatchUpdate.class);
                    mapUpdateResp.put(resUpdate.identifier, resUpdate);
                }
            }
        }
        for(Sales_order_delivery__c sod : [SELECT Id,Identifier__c,Item_Id__c,Parent_Record__c FROM Sales_order_delivery__c WHERE Identifier__c IN: mapUpdateResp.keySet()]){
            if(sod.Parent_Record__c == null){
                sod.resource__c = mapUpdateResp.get(sod.Identifier__c).resource;
                sod.Event__c = mapUpdateResp.get(sod.Identifier__c).event;
                if(mapUpdateResp.get(sod.Identifier__c).identifier != null && mapUpdateResp.get(sod.Identifier__c).identifier != ''){
                    sod.identifier__c = mapUpdateResp.get(sod.Identifier__c).identifier;
                }
                if(mapUpdateResp.get(sod.Identifier__c).dispatch_id != null){
                    sod.Dispatch_Id__c = String.valueOf(mapUpdateResp.get(sod.Identifier__c).dispatch_id);
                }
                if(mapUpdateResp.get(sod.Identifier__c).truck_identifier != null && mapUpdateResp.get(sod.Identifier__c).truck_identifier != ''){
                    sod.Truck_Identifier__c = mapUpdateResp.get(sod.Identifier__c).truck_identifier;
                }
                if(mapUpdateResp.get(sod.Identifier__c).status != null){
                    sod.Status__c = String.valueOf(mapUpdateResp.get(sod.Identifier__c).status);
                }
                if(mapUpdateResp.get(sod.Identifier__c).substatus != null && mapUpdateResp.get(sod.Identifier__c).substatus != ''){
                    sod.SubStatus__c = mapUpdateResp.get(sod.Identifier__c).substatus;
                }
                if(mapUpdateResp.get(sod.Identifier__c).substatus_code != null && mapUpdateResp.get(sod.Identifier__c).substatus_code != ''){
                    sod.Substatus_Code__c = mapUpdateResp.get(sod.Identifier__c).substatus_code;
                }
                if(mapUpdateResp.get(sod.Identifier__c).estimated_at != null && mapUpdateResp.get(sod.Identifier__c).estimated_at != ''){
                    sod.Estimated_at__c = mapUpdateResp.get(sod.Identifier__c).estimated_at;
                } 
                if(mapUpdateResp.get(sod.Identifier__c).arrived_at != null && mapUpdateResp.get(sod.Identifier__c).arrived_at != ''){
                    sod.Arrived_At__c = mapUpdateResp.get(sod.Identifier__c).arrived_at;
                }
                if(mapUpdateResp.get(sod.Identifier__c).evaluation_answers.size() > 0){
                    if(mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].cast_z != null && mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].cast_z == 'photo'){
                        sod.Evaluation_Cast__c = mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].cast_z;
                        if(mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].name != null && mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].name != ''){
                            sod.Evaluation_Name__c = mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].name;
                        }
                        if(mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].value != null && mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].value != ''){
                            sod.Image_URL__c = mapUpdateResp.get(sod.Identifier__c).evaluation_answers[0].value; 
                        }
                    }
                }
            }else if(sod.Parent_Record__c != null && sod.Item_Id__c != null){
                for(Grz_BeeTrackResponse.Items item : mapUpdateResp.get(sod.Identifier__c).items){
                    if(sod.Item_Id__c == String.valueOf(item.id)){
                        if(item.original_quantity != null){
                            sod.Original_Quanitity__c = String.valueOf(item.original_quantity);
                        }
                        if(item.quantity != null){
                            sod.Quantity__c = item.quantity;
                        }
                        if(item.delivered_quantity != null){
                            sod.Delivered_Quantity__c = String.valueOf(item.delivered_quantity);
                        }
                        if(mapUpdateResp.get(sod.Identifier__c).substatus != null && mapUpdateResp.get(sod.Identifier__c).substatus != ''){
                            sod.SubStatus__c = mapUpdateResp.get(sod.Identifier__c).substatus;
                        }
                        if(mapUpdateResp.get(sod.Identifier__c).estimated_at != null && mapUpdateResp.get(sod.Identifier__c).estimated_at != ''){
                            sod.Estimated_at__c = mapUpdateResp.get(sod.Identifier__c).estimated_at;
                        } 
                        if(mapUpdateResp.get(sod.Identifier__c).arrived_at != null && mapUpdateResp.get(sod.Identifier__c).arrived_at != ''){
                            sod.Arrived_At__c = mapUpdateResp.get(sod.Identifier__c).arrived_at;
                        }
                    }
                }
            }
            delItemsToUpdate.add(sod);
        }
        try{
            if(!delItemsList.isEmpty()){
                upsert delItemsList;
            }
            
            if(!delItemsToUpdate.isEmpty()){
                update delItemsToUpdate;
            }
            if(!sodlDelete.isEmpty()){
                delete [SELECT Id FROM Sales_order_delivery__c where id in :recordNewList];
            }
        }catch(Exception e){
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.Name = 'BeeTrack Error';
            storeError.Exception_Message__c = e.getMessage();
            insert storeError;
        }
    }
    
    
    
    public void AfterUpdateEvent(){
        
    }
}