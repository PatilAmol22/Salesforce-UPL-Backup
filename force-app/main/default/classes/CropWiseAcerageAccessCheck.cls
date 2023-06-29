public class CropWiseAcerageAccessCheck {
    
    public static void hasEditAccess(list<Crop_Wise_Acerage__c> liCWA){
        set<Id> AccountId = new set<id>();
        for(Crop_Wise_Acerage__c CWA: liCWA){
            AccountId.add(CWA.Farmer__c);
        }
        map<id,UserRecordAccess> mapAccess = new map<id,UserRecordAccess>();
        for(UserRecordAccess U : [select RecordId, HasEditAccess 
                                  FROM UserRecordAccess 
                                  WHERE UserId = :userInfo.getUserId() 
                                  AND RecordId in :AccountId]){
                                     mapAccess.put(U.RecordId, U); 
                                  }
        
        for(Crop_Wise_Acerage__c CWA: liCWA){
            
            if(!mapAccess.get(CWA.Farmer__c).HasEditAccess){
                CWA.addError(system.label.ErrorText);
            }
            
        }
        
        
        
    }

}