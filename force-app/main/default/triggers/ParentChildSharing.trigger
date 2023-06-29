trigger ParentChildSharing on Parent_Child_Mapping__c (After Insert, After Update, Before Delete) {
    
    ParentChildSharingHandler handler = new ParentChildSharingHandler(True);
    
    Japan_Sharing_Period__c period = [SELECT Id, Active__c, From_Date__c, To_Date__c FROM Japan_Sharing_Period__c];
    Boolean active = period.Active__c;  
    String fromDate = period.From_Date__c.format('yyyy-MM-dd');
    String toDate = period.To_Date__c.format('yyyy-MM-dd');
    
    /* After Insert */
    if(Trigger.isInsert && Trigger.isAfter && Active==true){
        handler.OnAfterInsert(Trigger.new,fromDate,toDate);
    }
    
    /* After Update */
    else if(Trigger.isUpdate && Trigger.isAfter && Active==true){
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap,fromDate,toDate);        
    }
    
    /* Before Delete */
    else if(Trigger.isDelete && Trigger.isBefore && Active==true){
        handler.OnBeforeDelete(Trigger.old, Trigger.oldMap,fromDate,toDate);
    }
       
}